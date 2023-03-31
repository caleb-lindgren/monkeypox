import altair as alt
import pandas as pd

all_summary = pd.read_csv("all_summary.tsv", sep="\t")

chart = alt.Chart(all_summary).mark_circle().encode(
    x=alt.X(
        "coverage",
        title="MPXV genome coverage (%)",
        scale=alt.Scale(zero=False),
    ),
    y=alt.Y(
        "depth",
        title="Depth of coverage (mean number of reads)",
    ),
)

chart.save("coverage_vs_depth_plot.png", scale_factor=4)
