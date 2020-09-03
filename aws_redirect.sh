#!/bin/bash
#
# Author: Eric Tang @TYO Lab
#         twitter.com/_e_tang


if [ "x$1" == "x" ] || [ "x$2" == "x" ]
    then
    echo "Both bucket names (from and to) must be provided".
    echo "Usage: $0 [from_bucket_name] [to_bucket_name]"
    exit
fi

rm -f /tmp/s3redirect.json
cat << EOF >> /tmp/s3redirect.json
{
    "RedirectAllRequestsTo": {
        "HostName": "$2"
    }
}
EOF

aws s3api put-bucket-website --bucket $1 --website-configuration file:///tmp/s3redirect.json