#!/bin/bash
#
# Galaxy wrapper for BSMAP Methylation Caller
#

set -e

#get parameters

until [ $# -eq 0 ]
do
	case $1 in
		input=*)
			input=${1#input=}
			;;
		method=*)
			method=${1#method=}
			;;
		output=*)
			output=${1#output=}
			;;
		tempdir=*)
			tempdir=${1#tempdir=}
			;;
		ref=*)
			ref=${1#ref=}
			;;
	esac
	shift
done

methratio.py -o $output -d $ref -q $input