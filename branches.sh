#!/bin/bash

source "colors.sh"

function branch_info() {
	ref=$(command git symbolic-ref HEAD)
	echo ${ref#refs/heads/}
}

cwd=$(pwd)

#green="%30s \033[32m %s \033[00m\n"
#red="%30s \033[31m %s \033[00m\n"
#yellow="%30s \033[33m %s \033[00m\n"

for x in $cwd/* ; do
	base=$(basename $x)
	if [ -d $x/.git ]; then
		cd $x
		branch=$(branch_info)
		if [ "$branch" == "master" ]; then
			printf %30s $(_gr $base) ; printf " %s" $(_gr $branch) ; _n
		else
			printf %30s $(_rd $base) ; printf " %s" $(_rd $branch) ; _n
		fi
	else
		printf %30s $(_br "$base") ; printf " Not a git repo" ; _n
	fi
done
