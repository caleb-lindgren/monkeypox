import altair as alt
import os
import pandas as pd
import sys

"""
Usage: `python make_coverage_vs_depth_plot.py /path/to/cecret/output/directory/`
"""

data_dir = sys.argv[1]

if not os.path.isdir(data_dir):
    raise ValueError("Invalid input directory.")

sample_dirs = [f.path for f in os.scandir(data_dir) if f.is_dir()]

samples = []
depths = []
coverages = []
perc_kepts = []

all_count = 0
empty_count = 0

for sample_dir in sample_dirs:
    all_count += 1
    summary_file = os.path.join(sample_dir, "cecret_results.csv")
    if os.path.isfile(summary_file):
        summary_df = pd.read_csv(summary_file)
        samples.append(summary_df.loc[0, "sample_id"])
        depths.append(summary_df.loc[0, "depth_after_trimming"])
        coverages.append(summary_df.loc[0, "1X_coverage_after_trimming"])
        try:
            perc_kepts.append(summary_df.loc[0, "seqyclean_Perc_Kept"])
        except:
            perc_kepts.append(summary_df.loc[0, "seqycln_Perc_Kept"])
    else:
        empty_count += 1

all_summary = pd.DataFrame({
    "accession": samples,
    "depth": depths,
    "coverage": coverages,
    "perc_kept": perc_kepts,
})

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
    tooltip="accession",
)

chart.save("coverage_vs_depth.html")
