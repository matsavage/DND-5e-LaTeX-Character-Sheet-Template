#!/bin/bash

reference_files="$(find ./result/*.pdf)"

echo $filename

# run imagemagick compare for all files
results=()
for file in $reference_files
do
  filename=`basename $file`

  result="$(magick compare -metric mae result/${filename} tests/reference/${filename} difference_${filename%%.*}.png 2>&1)"

  if [[ $result == *"attempt to perform an operation not allowed by the security policy"* ]]; then
    echo "Failed due to PDF security policy"
    exit 1
  fi

  similarity="$(echo $result | grep -oP '(?<=\().+?(?=\))')"
  similarity_percent=$(awk '{ print $1 * 100 }' <<< $similarity)

  results+=($similarity_percent)

  printf "%s: difference from reference: %0.4f%% \n" $file $similarity_percent
done

# return 1 if any file is over threshold
for result in ${results[@]}
do
  if (( $(echo "$result > 0.0001" | bc -l) )); then
    exit 1
  fi
done

exit 0
