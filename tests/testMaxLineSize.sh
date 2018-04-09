#!/bin/bash
# Check max line size of shell scripts

if [ "$1" = "" ];then
  PATH="."
else
  PATH=$1
fi
echo $PWD
if [ ! -d "${PATH}" ]; then
  printf "ERROR: path '%s' not found'\n" "${PATH}"
  exit 1
fi

MAX_LENGTH=119
return=0

echo "Check file max line size..."
for file in $(/bin/ls ${PATH}/*.sh) 
  do
  i=1
  while IFS= read -r line || [ -n "$line" ];
  do 
      [ "${#line}" -gt $MAX_LENGTH ] && printf "[%s] Line %s exceded max lenght\n" "$file" "$i";return=119
      ((i++))
  done < $file
done

echo "Done"
exit $return