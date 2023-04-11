# import geopandas as gpd
import pandas as pd
from matplotlib import pyplot as plt
from matplotlib import gridspec as gspec
import matplotlib.colors as mcolors

gis_data = pd.read_csv("gisaid_parsed.tsv", sep='\t')
gis_data["State"] = gis_data['state'].replace({"Baltimore":"Maryland"})
gis_data["State"].unique()

# Load GISAID data and select desired columns, exclude alaska
lineage_data = gis_data[["State", "Lineage"]]
lineage_data = lineage_data[lineage_data["State"] != "Alaska"]
lineage_data.head()

# Specify colors for pie plot
colors = dict(zip(lineage_data["Lineage"].unique(), mcolors.TABLEAU_COLORS.values()))

# Get proportion of each lineage in each state
lineage_counts = lineage_data.value_counts(["State", "Lineage"]).reset_index().groupby("State").agg(list)
lineage_counts.columns = ["Lineage", "Counts"]
lineage_counts["Colors"] = lineage_counts["Lineage"].apply(lambda lin_list: [colors[lin] for lin in lin_list])
lineage_counts
# labels = counts.index
# labels
# plt.pie(counts, labels=labels)
# plt.legend()

fig, axs = plt.subplots(ncols=3, nrows=4, figsize=(10, 15), layout="constrained")
state_idx = 0
for row in range(4):
    for col in range(3):
        if row == 3 and col > 0:
            continue
        data = lineage_counts.iloc[state_idx]
        axs[row, col].pie(data["Counts"], labels=data["Lineage"], colors=data["Colors"])
        axs[row, col].set_title(lineage_counts.index[state_idx], size = 18)
        state_idx += 1

plt.savefig("figure_2.png", dpi=300)
