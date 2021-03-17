#!/bin/bash

: <<COMMENTBLOCK
Wrapper for diannepat/scif_fsl docker container
Author: Dianne Patterson, Ph.D.
COMMENTBLOCK

if [ $# -lt 1 ]; then
  echo "Usage: $0 arg"
  echo "wraps the scif Docker commands"
  echo "=============================="
  echo "SCIF HELP"
  docker run -ti --rm diannepat/scif_fsl
  echo "=============================="
  echo "SCIF APPS in this container"
  docker run -ti --rm diannepat/scif_fsl apps
  echo "=============================="
  echo "If you provide one argument, it can be"
  echo "shell, pyshell, version or fsl"
  echo "------------------------------"
  echo "fsl:"
  echo "If you provide fsl, then the Docker container will mount the current directory under data"
  echo "and put you inside the container at a bash prompt."
  echo "This allows you to use FSL5 functions."
  echo "=============================="
  echo "If you provide two arguments, they should be an action"
  echo "followed by the name of an app"
  echo "e.g., help roixtractor"
  echo "=============================="
  echo "If you provide **xtract** as your first argument, then you can run roixtractor."
  echo "by providing:" 
  echo "the function (Stats, Lat or Mask)," 
  echo "input image (e.g., a stats image for Stats or Lat, and a binary 1-0 mask Mask),"   
  echo "stats threshold, and"
  echo "atlas (HO-CB or HCP-MMP1)."
  echo "Stats generates a CSV & NIfTI containing above threshold regions" 
  echo "Lat, the CSV file will contain laterality information" 
  echo "Mask with threshold=0 provides volume of each ROI that is lesion (cubed mm and percentage)"
  echo ""
  echo "xtract examples with sfw.sh:"
  echo ""
  echo "sfw.sh xtract Stats run-01_IC-06_Russian_Unlearnable.nii 1.3 HO-CB"
  echo "sfw.sh xtract Lat run-01_IC-06_Russian_Unlearnable.nii 1.3 HCP-MMP1"
  echo "sfw.sh xtract Mask w1158lesion.nii.gz 0 HO-CB"
  echo "=============================="
  echo "If you provide deface as your first argument, then you can run Freesurfer defacing"
  echo "by providing the T1w NIfTI image (with its extension) to be defaced e.g.,"
  echo "$0 deface anat_T1w.nii.gz"
  echo ""
  echo "=============================="
  exit 1
fi

if [ ${1} = "xtract" ]; then
  func=${2}
  stats_img=${3}
  stats_thresh=${4}
  atlas=${5}
  docker run -it --rm -v "${PWD}":/scif/data/roixtractor diannepat/scif_fsl run roixtractor ${func} ${stats_img} ${stats_thresh} ${atlas}
elif [ ${1} = "deface" ]; then
  T1w_img=${2}
  docker run -it --rm -v "${PWD}":/scif/data/deface_fs diannepat/scif_fsl run deface_fs ${T1w_img}
elif [ ${1} = "fsl" ]; then
  echo "entering the container so you can run FSL."
  echo "cd to /scif/data/fsl to find your mounted directory."
  echo "==============================================="
  echo ""
  docker run -it --rm -v "${PWD}":/scif/data/fsl diannepat/scif_fsl shell 
elif [ $# -eq 1 ]; then
  action=${1}
  docker run -ti --rm diannepat/scif_fsl ${action}
elif [ $# -eq 2 ]; then
  action=${1}
  app=${2}
  docker run -ti --rm diannepat/scif_fsl ${action} ${app}
fi
