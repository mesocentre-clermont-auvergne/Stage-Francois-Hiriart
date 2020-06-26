#!/bin/bash
#
# Galaxy wrapper for  WIG parser
# Written by Eugen Eirich @ Institute of Molecular Biology Mainz
#

set -e


#get parameters

until [ $# -eq 0 ]
do
	case $1 in
		input=*)
			input=${1#input=}
			;;
		extract=*)
			extract=${1#extract=}
			;;
		context=*)
			context=${1#context=}
			;;
		depth=*)
			depth="cutoff=${1#depth=}"
			;;
		cov_out=*)
			cov_out=${1#cov_out=}
			;;
		meth_out=*)
			meth_out=${1#meth_out=}
			;;
	esac
	shift
done

case $extract in
      c)
	output="-cov_out=$cov_out";;
      m)
	output="-meth_out=$meth_out";;
      b)
	output="-meth_out=$meth_out -cov_out=$cov_out";;
esac

if [ "$context" != "" ] 
then
    context="-context=$context"
fi

cd "$(dirname ${BASH_SOURCE[0]})"
perl wig_extractor.pl -e $extract $context $output $input 2>&1>/dev/null
