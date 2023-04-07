import altair as alt
import pandas as pd

from vega_datasets import data

state_ids = data.population_engineers_hurricanes()[["state", "id"]]

df = pd.\
read_csv("gisaid_parsed.tsv", sep="\t")

df = df.assign(Lineage=df["Lineage"].fillna("No data"))

df = df[["state", "Lineage", "Collection Date"]].\
groupby(["state", "Lineage"]).\
count().\
reset_index(drop=False)

df = df.merge(
    right=state_ids,
    on="state",
    how="outer"
).\
rename(columns={
    "Collection Date": "n",
})

states = alt.topo_feature(data.us_10m.url, "states")

chart = alt.Chart(df).mark_geoshape().encode(
    shape="geo:G",
    color=alt.Color(
        "n:Q",
        scale
    ),
    facet=alt.Facet("Lineage:N", columns=2),
).transform_lookup(
    lookup="id",
    from_=alt.LookupData(data=states, key="id"),
    as_="geo",
).properties(
    width=500,
    height=300
).project(
    type="albersUsa"
)

chart.save("map.png", method="selenium", scale_factor=2)

# https://stackoverflow.com/questions/73059639/how-to-make-altair-display-nan-points-with-a-quantitative-color-scale
# https://snyk.io/advisor/python/altair/functions/altair.Scale
