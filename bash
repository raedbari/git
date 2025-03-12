#!/bin/bash


time=$(date +%y-%m-%d+%M-%S)
backup_file=/home/ubuntu/bash
destination=/home/ubuntu/backup
filename=file-backup-$time.tar.gz
logfile="/home/ubuntu/backup/logfile.log"
file="$destination/$filename"
s3b="raed-project-bash"


if ! command -v aws &> /dev/null
then
        echo "install aws first"
        exit 2
fi

if [ $? -ne 2 ]
then
  if [ -f $filename ]
  then
         echo "error file $filename already exists" | tee -a "$logfile"
  else
            tar -czvf "$destination/$filename" "$backup_file"
            echo
                echo "backup added successfully. backup file: $destination/$filename" | tee -a "$logfile"
               aws s3 cp "$file" "s3://$s3b/"

  fi
fi
if [ $? -eq 0 ]
then
        echo "backup uploaded seccessfully to $s3b"
else
                echo "failed to upload to $s3b"
fi
