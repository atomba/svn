#!/bin/bash
#
# Author: Eric Tang @TYO Lab
#         twitter.com/_e_tang

if [ "x$1" == "x" ]
    then
    echo "A bucket name must be provided".
    echo "Usage: $0 [bucket_name]"
    exit
fi

if [ "x$2" == "x" ]
then 
    command=-1
else
    command=`expr $2 / 1`
fi    

bucket=$1

if [[ "x$AWS_REGION" == "x" ]]
then
    region="ap-southeast-2"
    echo "AWS region is not set, it can to be set by using: export AWS_REGION=xxxxxx"
fi

echo "Using region: $AWS_REGION"

rm -f /tmp/s3policy.json
cat << EOF >> /tmp/s3policy.json
{
    "Version": "2012-10-17",
    "Id": "Policy1565157422787",
    "Statement": [
        {
            "Sid": "Stmt1565157417996",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::$1/*"
        }
    ]
}
EOF

rm -f /tmp/s3website.json
cat << EOF >> /tmp/s3website.json
{
    "IndexDocument": {
        "Suffix": "index.html"
    },
    "ErrorDocument": {
        "Key": "error.html"
    }
}
EOF

# cat list.txt | while read line; 
# do 
    echo $bucket; 
    if [ $command -eq 0 ] || [ $command -eq -1 ] 
    then
        aws s3api create-bucket --bucket $bucket --region $AWS_REGION --create-bucket-configuration LocationConstraint=$AWS_REGION
    fi

    if [ $command -eq 1 ] || [ $command -eq -1 ] 
    then
        aws s3api put-bucket-acl --bucket $bucket --acl public-read 
    fi

    if [ $command -eq 2 ] || [ $command -eq -1 ] 
    then
        aws s3api put-bucket-policy --bucket $bucket --policy file:///tmp/s3policy.json
    fi

    if [ $command -eq 3 ] || [ $command -eq -1 ]
    then
        aws s3 website s3://$bucket/  --index-document index.html
    fi


# done
