#!/bin/sh

# 1. grep line number of open & close tag of student in input xml
# 2. sed the line(s) content by sed refer to order.txt within the start & end line
# 3. redirect the line to output xml

# Constants
in_xml="in.xml"
out_xml="out.xml"
order_txt="order.txt"

# Clean up
rm -f ${out_xml}

if [ "$1" != "" ]; then
	in_xml="$1"
fi

# Start tag of root
head -2 ${in_xml} > ${out_xml}

# 1.
testcase_count=`grep -c "<student" ${in_xml}`

for(( index=1; index<=${testcase_count}; index=index+1 ))
do
	base_start=`grep -n "<student" ${in_xml} | cut -d ':' -f 1 | head -${index} | tail -1`
	base_end=`grep -n  "</student" ${in_xml} | cut -d ':' -f 1 | head -${index} | tail -1`

	sed -n "${base_start}p" ${in_xml} >> ${out_xml}
	sed -n "${base_start}p" ${in_xml}	
	order_count=`cat ${order_txt} | wc -l`
	# 2. 
	for(( i=1; i<=${order_count}; i=i+1 ))
	do
		tag=`sed -n "${i}p" ${order_txt}`
		# get the start tag line number
		start_line=`sed -n "${base_start},${base_end}p" ${in_xml} | grep -n "<${tag}>" | cut -d ':' -f 1`
		
		# get the end tag line number
		end_line=`sed -n "${base_start},${base_end}p" ${in_xml} | grep -n "</${tag}>" | cut -d ':' -f 1`
	
		# Debug
		# echo "${tag}, start:${start_line}, end:${end_line}"
		# grep the including content
		sed -n "${base_start},${base_end}p" ${in_xml} | sed -n "${start_line}, ${end_line}p" >> ${out_xml}
	done
	sed -n "${base_end}p" ${in_xml} >> ${out_xml} 
done
# End tag of root
tail -1 ${in_xml} >> ${out_xml}
