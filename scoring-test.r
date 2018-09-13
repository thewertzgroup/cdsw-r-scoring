library(jsonlite)

# An example of fully labeled input payload
#
# mandatory labels:
#   payload_type = full
#   avg_meanthroughputul
#   avg_meanthroughputdl
#   min_totaldataul
#   max_totaldataul
#   sum_totaldataul
#   avg_totaldataul
#   min_totaldatadl
#   max_totaldatadl
#   sum_totaldatadl
#   avg_totaldatadl
#   avg_internetlatency
#   avg_httpsuccessratio
#
json.full <- '{
  "payload_type": "full",
  "msisdn": 632001647830,
  "pxn_mo": 7,
  "pxn_yr": 2018,
  "avg_meanthroughputul": -0.36,
  "avg_meanthroughputdl": 0.02,
  "min_totaldataul": 0,
  "max_totaldataul": -0.58,
  "sum_totaldataul": -0.61,
  "avg_totaldataul": -0.05,
  "min_totaldatadl": 0,
  "max_totaldatadl": 1.36,
  "sum_totaldatadl": -0.39,
  "avg_totaldatadl": 0.37,
  "avg_internetlatency": -0.2,
  "avg_httpsuccessratio": 0.37
}'

full.valid <- fromJSON(json.full)

# An example of non-labeled input payload
#
# mandatory labels:
#   payload_type = simple
#   body = a list of values for avg_meanthroughputul, avg_meanthroughputdl,
#          min_totaldataul, max_totaldataul, sum_totaldataul, avg_totaldataul,
#          min_totaldatadl, max_totaldatadl, sum_totaldatadl, avg_totaldatadl,
#          avg_internetlatency, and avg_httpsuccessratio, in this order
json.simple <- '{
  "payload_type": "simple",
  "body": [-0.36, 0.02, 0, -0.58, -0.61, -0.05, 0, 1.36, -0.39, 0.37, -0.2, 0.37]
}'

simple.valid <- fromJSON(json.simple)
