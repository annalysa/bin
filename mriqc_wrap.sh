#!/bin/bash

: <<COMMENTBLOCK
This code calls the docker MRIQC tool. See https://mriqc.readthedocs.io/en/stable/docker.html. MRIQC evaluates the quality of T1w and functional scans stored in a BIDS compliant data structure.
This script requires that you are in the directory where your subject subdirectories are stored in the BIDS data structure.
See also mriqc_T1class.sh which runs the random forest classifier on the group_T1w.tsv file.
COMMENTBLOCK


# Exit and spit out help message if number of arguments is too small
if [ $# -lt 1 ]
    then
        echo "======================================================"
        echo "This assumes you are running docker"
        echo "and have downloaded mriqc: docker pull poldracklab/mriqc"
        echo "One argument is required"
        echo "argument: name of input to evaluate"
        echo "e.g. Run a subject: $0 304"
        echo "e.g. Run multiple subjects: $0 304 305 306"
        echo "Or use 'group' to run the group reports (assuming you have run the subjects)"
        echo "e.g., $0 group"
        echo "Group is very fast. Subjects take longer."
        echo "On the mac, ensure Docker has more than the default 2 GB of RAM:"
        echo "Docker->Preferences->Advanced"
        echo "======================================================"
        exit 1
fi

# assign the argument to "input"
input=${1}
# if the argument is "group"
if [ $# -eq 1 ] && [ ${input} = "group" ]; then
  echo "Group results will be calculated and"
  echo "placed in derivatives/mriqc/group_bold.html and *.tsv, group_T1w.html and *.tsv"
  docker run -it --rm -v ${PWD}:/data:ro -v ${PWD}/derivatives/mriqc:/out poldracklab/mriqc:latest /data /out group
  ls ${PWD}/derivatives/mriqc/group*
# If the argument is anything other than "group", assume it is participant label(s)
elif [ ! ${input} = "group" ]; then
  echo "The subject directory for sub-${input} will be evaluated and the results"
  echo "placed in derivatives/mriqc/sub-${input}"
  # Including "" around PWD ensures it will handle spaces in the path names.
  docker run -it --rm -v "${PWD}":/data:ro -v "${PWD}"/derivatives/mriqc:/out poldracklab/mriqc:latest /data /out participant --participant_label ${*} --verbose-reports --ica -w /out/mriqc_work

# For anything else, spit out the help message and stop.
else
  echo "======================================================"
  echo "This assumes you are running docker"
  echo "and have downloaded mriqc: docker pull poldracklab/mriqc"
  echo "One argument is required"
  echo "argument: name of input to evaluate"
  echo "e.g. Run a subject: $0 304"
  echo "e.g. Run multiple subjects: $0 304 305 306"
  echo "Or use 'group' to run the group reports (assuming you have run the subjects)"
  echo "e.g., $0 group"
  echo "======================================================"
  exit 1
fi
