import altair as alt
import os
import pandas as pd
import sys

data_dir = sys.argv[1]

if not os.path.isdir(data_dir):
    raise ValueError("Invalid input directory.")

sample_dirs = [f.path for f in os.scandir(data_dir) if f.is_dir()]

samples = []
depths = []
coverages = []

for sample_dir in sample_dirs:
    summary_file = os.path.join(sample_dir, "cecret_results.csv")
    summary_df = pd.read_csv(summary_file)
    samples.append(summary_df.loc[0, "sample_id"])
    depths.append(summary_df.loc[0, "depth_after_trimming"])
    coverages.append(summary_df.loc[0, "1X_coverage_after_trimming"])

all_summary = pd.DataFrame({
    "accession": samples,
    "depth": depths,
    "coverage": coverages,
})

print(all_summary)
