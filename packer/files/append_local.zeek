## This will be required to configure custom Zeek

# Produce JSON Streaming logs
@load json-streaming-logs

# add custom fields
@load add_fields

# Ignore checksums due top hardware offloading.
redef ignore_checksums = T;
