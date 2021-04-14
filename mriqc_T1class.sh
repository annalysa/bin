#!/bin/bash

: <<COMMENTBLOCK
This code calls the docker MRIQC tool to run the T1w classifier. See https://mriqc.readthedocs.io/en/stable/docker.html.
Run from the directory containing group_T1w.tsv after group level.

-w sets the directory for the output file

This generates: mclf_run-*_data-unseen_pred.csv (The date will be appear instead of the *)
The result tells us, for each T1w image, whether its quality is acceptable or not: 0=”accept”, 1=”reject”
The result includes three columns: subject_id,prob_y,pred_y.  It looks like if the prob_y value is greater than 50%, then the data is rejected.
 
COMMENTBLOCK


docker run -it --rm -v ${PWD}:/scratch -w /scratch --entrypoint=mriqc_clf poldracklab/mriqc --load-classifier -X group_T1w.tsv