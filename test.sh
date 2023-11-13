taskList=""
for file in /home/philipp/Projects/pno.dev-typo3/vendor/pnodev/jim-scripts-typo3/*
do
  if [ "$taskList" == "" ]
  then
    taskList="$(basename "$file" ".sh")"
  else
    taskList="$taskList $(basename "$file" ".sh")"
  fi
done

echo "$taskList"
