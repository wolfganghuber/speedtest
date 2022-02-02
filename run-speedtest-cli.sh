#/bin/bash
# RES=`/opt/homebrew/bin/speedtest-cli --csv 2> /dev/null`  
RES=`speedtest-cli --csv 2> /dev/null`  
if [ -z "$RES" ]
then
  RES="NA,NA,NA,`gdate --utc +%FT%TZ`,NA,NA,NA,NA,NA,NA"
fi
echo "$RES">> /Users/whuber/svnco/speedtest/speedtest-`hostname -s`.csv

# CSV column headers:
# [1] "Server ID"   "Sponsor"     "Server Name" "Timestamp"   "Distance"
# [6] "Ping"        "Download"    "Upload"      "Share"       "IP Address"
