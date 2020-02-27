#!/bin/bash

for i in *; do
	filename=$(echo ${i}|awk -F\. '{print $1}')
	extension=$(echo ${i}|awk -F\. '{print $2}')
	if [ ${extension} == "asm" ]; then
		nasm ${i} -f bin -o ${filename}.bin
	fi
done
