# When interpreting plots, LLMs see what they want to see: Part 2


In [a previous post](https://posit.co/blog/introducing-bluffbench/), we
discussed the results from
[bluffbench](https://github.com/simonpcouch/bluffbench), an evaluation
that tests how well LLMs interpret plots that contradict with their
prior beliefs. The models tested (GPT-5, Claude Sonnet 4.5, and Gemini
Pro 2.5) largely failed to accurately interpret such plots, especially
when plotting known datasets (`diamonds`, `mpg`, etc.) that had been
secretly manipulated.

For example, one of the samples inverts the price-carat relationship in
`diamonds` so that larger diamonds are less expensive than smaller ones.

<img src="blog-post_files/figure-commonmark/diamonds-comparison-1.png"
data-fig-alt="Two scatterplots side by side. Left: original diamonds data showing positive relationship between carat and price. Right: manipulated data showing inverted (negative) relationship." />

**None of the models ever accurately reported seeing this negative
relationship.** Instead, they reported that the plot showed the
expected, positive relationship. Here’s a portion of a response from
Claude Sonnet 4.5 (emphasis ours):

> Here’s the plot showing the relationship between diamond carat and
> price! How diamond size affects price:
>
> There’s a **strong positive relationship** between carat (diamond
> size) and price.

Data analysis agents like Databot partially rely on plot interpretation
to understand data and provide users with accurate insights, and so it’s
important to both understand why these errors occur and determine how to
fix the problem.

## How well do LLMs “see” plots?

Why exactly do LLMs misinterpret plots like those in bluffbench? You
might wonder if current LLMs are good at interpreting *any* plots. Maybe
even in normal, non-adversarial conditions, LLMs have difficulty
“seeing” or attending to the actual patterns in a plot.

To test this hypothesis, **we developed a set of baseline samples to
evaluate how well models interpret straightforward plots** that do not
contradict their priors. The baseline datasets have generic names and
columns (e.g., `df`, `x`, `y`) and were designed to test LLMs’ ability
to describe various types of relationships (positive correlation,
negative correlation, quadratic, etc.).

<img src="images/baseline-images.png"
data-fig-alt="Three example baseline plots showing different relationship types."
alt="Example baseline condition plots. The datasets are generic to reduce the likelihood the model has expectations about the plots." />

**All three models performed well on the baseline samples,** especially
compared to the two adversarial bluffbench conditions: *mocked* and
*intuitive*. In the *mocked* condition, models plot known datasets like
`diamonds` that we secretly manipulated beforehand. The *inuitive*
condition involves novel synthetic datasets that the models likely had
expectations about (e.g., test scores vs. hours spent studying). See the
[first bluffbench blog
post](https://posit.co/blog/introducing-bluffbench/) for more details
about these conditions.

<img src="blog-post_files/figure-commonmark/bluffbench-all-1.png"
data-fig-alt="Line chart showing model accuracy dropping across bluffbench conditions. All models perform worse on mocked datasets." />

Note that the intuitive condition is more realistic, so improving
accuracy there matters more to us than in the mocked condition.

We also tested a condition where the models only saw the plot image,
without writing the code themselves. Performance was similar (Claude
Sonnet 4.5: 79%, Gemini Pro 2.5: 87%, GPT-5: 92%).

Although it’s possible that models are partially relying on non-pattern
information like axis labels to inform their interpretation of the plot,
the results suggest that LLMs are capable of accurately interpreting
plots when their prior knowledge isn’t contradicted.

The interpretation issues seen in adversarial bluffbench conditions are
therefore likely **not a visual skill issue.** LLMs are capable of
(mostly) accurately interpreting plots when those plots don’t conflict
with what they expect to see. These results also make it unlikely the
problem is that the images are being encoded or formatted in a way that
makes them difficult for the models to interpret.

## What we tried

After establishing this baseline, we continued to try several
interventions. So far, interventions like prompting and having a
separate model pre-interpret the plot have had only limited success.
Here are a few fixes we tried:

**Memo prompt:** We prompt the model to first write a memo (contained in
`MEMO` tags) to themselves describing just the visual elements of the
plot, acting as if they had no prior knowledge of the data or subject
matter and ignoring axis labels. After this memo, they could write their
final interpretation of the plot, using whatever knowledge they wanted.
You can see the exact prompt
[here](!--TODO%20Add%20link%20when%20PR%20is%20merged--).

**Extended thinking:** We [built on the memo
prompt](!--%20TODO%20Add%20link%20--), but added language to prompt the
models to use more extended thinking.

Neither prompting technique, nor others we tried, had much success, so
we attempted a more structural intervention next.

**Model-in-the-middle:** First, a separate model instance (the *model in
the middle*) describes the plot, [ignoring information like axis
labels](https://github.com/simonpcouch/bluffbench/blob/main/inst/prompts/interpret_plot.md).
That description is then given to the primary model, which uses it to
form its final description of the plot. The model-in-the-middle and the
primary model are always the same LLM (i.e., if testing Claude Sonnet
4.5, both are Claude Sonnet 4.5).

Although each intervention improved performance above no intervention,
none improved performance enough that we would be comfortable relying on
the model to interpret plots that contradict the model’s expectations.

<img
src="blog-post_files/figure-commonmark/intervention-comparison-1.png"
data-fig-alt="Lollipop chart comparing intervention performance on mocked datasets. All interventions show low accuracy." />

## Models can overcome priors

Although the model-in-the-middle (MITM) *approach* was not particularly
effective, the actual plot interpretations from the MITM were relatively
accurate. The MITM was instructed to ignore information like axis labels
and outside context and focus solely on the visual patterns in the plot,
and this prompt produced relatively good descriptions.

However, the primary model typically doubted or flat out ignored the
MITM’s descriptions.

<img src="blog-post_files/figure-commonmark/mitm-comparison-1.png"
data-fig-alt="Bar chart comparing MITM helper accuracy (75%) versus primary model accuracy (15%) on mocked datasets." />

For example, in this log below, the MITM correctly describes the
negative relationship present in the manipulated diamonds plot, but then
the primary model still reports seeing a positive relationship.

<img src="images/mitm-diamonds.png"
data-fig-alt="Screenshot showing the MITM helper&#39;s interpretation of the diamonds plot, correctly identifying the negative relationship between carat and price." />

These results reinforce our earlier finding. The issue is not that LLMs
have trouble “seeing” plots. LLMs actually can interpret plots
relatively accurately. Problems arise, however, when they need to
reconcile what they see with what they already believe.

## Why not just ignore prior information?

The MITM prompt instructs the model to ignore prior knowledge about the
data and focus on visual patterns. If that produces accurate
descriptions, why not just use that prompt?

The problem is we don’t want LLMs interpreting plots in a vacuum. We
want them to power data analysis agents, and data analysis typically
requires incorporating other information. We can’t just tell models to
“ignore axis labels and outside information” because that information
can be critical to the analysis.

Instead, we want the model to update its beliefs based on new visual
information, or question if a plot is correct based on what else it
knows about the data. It needs to be able to use context and other
information to inform its interpretation of the plot, but to also use
the plot to inform its understanding of the data, and it needs to do
both accurately.

## What this means for now

The scenarios in bluffbench are adversarial by design. We deliberately
created datasets that contradict with the LLM’s presumed priors. In
everyday use, conflicts this stark may be rare, and users typically
provide context that can help the model understand what’s going on. For
example, if you tell the LLM that you modified `diamonds`, it’s more
likely to interpret the plot accurately. Unlike in our evaluation, real
users aren’t typically trying to trick the model.

However, the ability to recognize when new evidence contradicts prior
beliefs is central to good data science. If LLMs can’t reliably update
their understanding when a plot contradicts their expectations, they
risk providing false information to the user or reinforcing assumptions.
For data analysis agents like Databot, this is a capability we need to
get right.

We’re continuing to investigate this problem. If you’d like to test your
own models, [bluffbench](https://github.com/simonpcouch/bluffbench) is
available on GitHub.
