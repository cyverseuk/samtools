#!/bin/bash

function debug {
  echo "creating debugging directory"
mkdir .debug
for word in ${rmthis}
  do
    if [[ "${word}" == *.sh ]] || [[ "${word}" == lib ]]
      then
        mv "${word}" .debug;
      fi
  done
}

rmthis=`ls`
echo ${rmthis}

INPUTSU="${input_file}"
echo "Input file is " "${INPUTSU}"

OUTPUT=$(basename ${INPUTSU})
OUTPUT=${OUTPUT%%.*}
CMDLINEARG="samtools view -b -S -@ 16 ${input_file} -o ${OUTPUT}.bam; samtools sort -@ 16 ${OUTPUT}.bam sorted_${OUTPUT}"

echo ${CMDLINEARG};

chmod +x launch.sh

echo  universe                = docker >> lib/condorSubmitEdit.htc
echo docker_image            =  cyverseuk/samtools:v0.1.19 >> lib/condorSubmitEdit.htc ######
echo executable               =  ./launch.sh >> lib/condorSubmitEdit.htc #####
echo arguments                          = ${CMDLINEARG} >> lib/condorSubmitEdit.htc
echo transfer_input_files = ${INPUTSU}, launch.sh >> lib/condorSubmitEdit.htc
#echo transfer_output_files = ${OUTPUTSU} >> lib/condorSubmitEdit.htc
cat /mnt/data/apps/sam_to_sorted_bam/lib/condorSubmit.htc >> lib/condorSubmitEdit.htc

less lib/condorSubmitEdit.htc

jobid=`condor_submit -batch-name ${PWD##*/} lib/condorSubmitEdit.htc`
jobid=`echo $jobid | sed -e 's/Sub.*uster //'`
jobid=`echo $jobid | sed -e 's/\.//'`

#echo $jobid

#echo going to monitor job $jobid
condor_tail -f $jobid

debug

exit 0
