import altair as alt
import pandas as pd

all_summary = pd.read_csv("all_summary.tsv", sep="\t")

chart = alt.Chart(all_summary).mark_circle().encode(
    x=alt.X(
        "coverage",
        scale=alt.Scale(zero=False),
    ),
    y="depth",
)

chart.save("coverage_vs_depth_plot.png", scale_factor=1)
