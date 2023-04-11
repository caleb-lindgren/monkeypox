import altair as alt
import pandas as pd

from vega_datasets import data

state_ids = data.population_engineers_hurricanes()[["state", "id"]]

source = pd.\
read_csv("gisaid_parsed.tsv", sep="\t")

source = source.assign(Lineage=source["Lineage"].fillna("No data"))

source = source[["state", "Lineage", "Collection Date"]].\
groupby(["state", "Lineage"]).\
count().\
reset_index(drop=False)

source = source.merge(
    right=state_ids,
    on="state",
    how="outer"
).\
rename(columns={
    "Collection Date": "n",
})

states = alt.topo_feature(data.us_10m.url, "states")

foreground = alt.Chart().mark_geoshape().encode(
    shape="geo:G",
    color=alt.Color(
        "n:Q",
    ),
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

background = alt.Chart().mark_geoshape(
    fill="lightgray",
    stroke="white",
).encode(
    shape="geo:G",
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

chart = alt.layer(background, foreground, data=source)#.facet("Lineage:N", columns=2)

chart.save("map.png", method="selenium", scale_factor=2)
