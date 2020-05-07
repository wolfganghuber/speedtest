#/bin/bash
RES=`/usr/local/bin/speedtest-cli --csv 2> /dev/null`  
if [ -z "$RES" ]
then
  RES="NA,NA,NA,`gdate --utc +%FT%TZ`,NA,NA,NA,NA,NA,NA"
fi
echo $RES >> /Users/whuber/Dropbox/speedtest/`hostname -s`-speedtest.csv

# CSV column headers:
# [1] "Server ID"   "Sponsor"     "Server Name" "Timestamp"   "Distance"
# [6] "Ping"        "Download"    "Upload"      "Share"       "IP Address"