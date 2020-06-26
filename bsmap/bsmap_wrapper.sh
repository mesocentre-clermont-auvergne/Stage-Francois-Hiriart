#!/bin/bash
#
# Galaxy wrapper for BSMAP
# Written by Eugen Eirich @ Institute for Molecular Biology Mainz
#

set -e

#get parameters

until [ $# -eq 0 ]
do
	case $1 in
		ref=*)
			ref=${1#ref=}
			;;
		library=*)
			library=${1#library=}
			;;
		unpaired=*)
			unpaired=${1#unpaired=}
			;;
		mapped=*)
			mapped=${1#mapped=}
			;;
		fullparam=*)
			fullparam=${1#fullparam=}
			;;
		mate1=*)
			mate1=${1#mate1=}
			;;
		mate2=*)
			mate2=${1#mate2=}
			;;
		qual=*)
			qual="-z ${1#qual=}"
			;;
		threshold=*)
			threshold="-q ${1#threshold=}"
			;;
		lowqual=*)
			lowqual="-f ${1#lowqual=}"
			;;
		adapter=*)
			adapter=${1#adapter=}
			;;
		firstn=*)
			firstn="-L ${1#firstn=}"
			;;
		repeat_reads=*)
			repeat_reads="-r ${1#repeat_reads=}"
			;;
		seed_size=*)
			seed_size="-s ${1#seed_size=}"
			;;
		mismatch=*)
			mismatch="-v ${1#mismatch=}"
			;;
		equal_best=*)
			equal_best="-w ${1#equal_best=}"
			;;
		start=*)
			start="-B ${1#start=}"
			;;
		end=*)
			end="-E ${1#end=}"
			;;
		index_interval=*)
			index_interval="-I ${1#index_interval=}"
			;;
		seed_random=*)
			seed_random=${1#seed_random=}
			;;
		rrbs=*)
			rrbs=${1#rrbs=}
			;;
		mode=*)
			mode="-n ${1#mode=}"
			;;
		align_info=*)
			align_info=${1#align_info=}
			;;
		maxinsert=*)
			maxinsert="-x ${1#maxinsert=}"
			;;
		mininsert=*)
			mininsert="-m ${1#mininsert=}"
			;;
		summary=*)
			summary=${1#summary=}
			;;
	esac
	shift
done


if [ "$rrbs" != "" ]
then
  rrbs="-D $rrbs"
fi

if [ "$align_info" != "" ]
then
  align_info="-M $align_info"
fi

if [ "$adapter" != "" ]
then
  adapter="-A $adapter"
fi

if [ "$seed_random" != "" ]
then
  seed_random="-S $seed_random"
fi


if [ "$library" == "single" ]
then
    if [ "$fullparam" == 'false' ]
    then      
      bsmap -a $mate1 -d $ref -o $mapped -R -r 0 -p 4 > $summary
    else
      bsmap -a $mate1 -d $ref -o $mapped -R -r 0 -p 4 $qual $threshold $lowqual $adapter $firstn $repeat_reads $seed_size $mismatch $equal_best $start $end $index_interval $mode  > $summary
    fi
else
    if [ "$fullparam" == 'false' ]
    then
      bsmap -a $mate1 -b $mate2 -2 $unpaired -d $ref -o $mapped -R -r 0 -p 4  > $summary
    else
      bsmap -a $mate1 -b $mate2 -2 $unpaired -d $ref -o $mapped -R -r 0 -p 4 $qual $threshold $lowqual $adapter $firstn $repeat_reads $seed_size $mismatch $equal_best $start $end $index_interval $mode $maxinsert $mininsert   > $summary
    fi
fi
