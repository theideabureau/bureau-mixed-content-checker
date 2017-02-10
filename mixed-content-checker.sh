#!/bin/bash

urls_path="$(pwd)/urls.txt"
log_path="$(pwd)/log.txt"
base="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -f $urls_path ]; then
    echo "Exiting: file urls.txt not found in current directory"
	exit 1
fi



urls=$(
while read url
do
  echo -n " ${url}"
done < $urls_path)

# echo $urls;

$base/phantomjs-mixed-content-scan/report-mixed-content.js $urls

exit 1

counter=0
line_count=`wc -l $urls_path | awk {'print $1'}`
issue_counter=0
issue_urls=""

echo > log_path

while read url; do

	counter=$[$counter+1]

	echo -ne "$counter/$line_count\r"

	if "$base/phantomjs-mixed-content-scan/report-mixed-content.js" $url | grep -q "loaded an insecure resource"; then
		issue_counter=$[$issue_counter+1]
		issue_urls="${issue_urls}$url"$'\n'
	fi

done < $urls_path

echo "$issue_urls" > log.txt
echo "Finished, there were $issue_counter issues:"$'\n'
echo "$issue_urls"
