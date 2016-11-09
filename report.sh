#!/bin/bash

GOROOT=/opt/go1.6

source "colors.sh"

function go_install() {
	go install
	if [ "$?" != "0" ]; then
		echo "repository doesn't compile."
		exit 1
	fi
}

function go_test() {
	go test --race ./... 
	if [ "$?" != "0" ]; then
		echo "all tests build and pass."
		exit 1
	fi
}

function go_fmt() {
	find $(pwd) \( ! -regex '.*\.files.*' -and -regex '.*\.go$' \) -type f -exec gofmt -w {} \;
}

function go_vet() {
	go vet
	if [ "$?" != "0" ]; then
		echo "making sure go code doesn't have any suspicious constructs"
		exit 1
	fi
}

function go_misspell() {
	misspell ./**/*
	if [ "$?" != "0" ]; then
		echo "code has misspellings in comments or strings, etc"
		exit 1
	fi
}

function go_assign() {
	ineffassign .
	if [ "$?" != "0" ]; then
		echo "passes checks for ineffectual assignments"
		exit 1
	fi
}

function go_cyclo() {
	go_src=$( find $(pwd) \( ! -regex '.*\.git.*' -and ! -regex '.*\.idea.*' -and ! -regex '.*\.files.*' -and -regex '.*\.go$' -and ! -regex '.*_test\.go$' \) -type f )
	for g in $go_src; do
		gocyclo -over 15 "$g"
		if [ "$?" != "0" ]; then
			echo "cyclo complexity is too hight (max 15)"
			exit 1
		fi
	done
}

function go_lint() {
	go_src=$( find $(pwd) \( ! -regex '.*\.git.*' -and ! -regex '.*\.idea.*' -and ! -regex '.*\.files.*' -and ! -regex '.*/embedded/.*' -and -regex '.*\.go$' -and ! -regex '.*_test\.go$' \) -type f )
	for g in $go_src ; do
		golint -min_confidence 0.3 "$g"
		if [ "$?" != "0" ]; then
			echo "golint found errors $g"
			exit 1
		fi
	done
}

function checks() {
	_gr "checking build" ; _n ; go_install
	_gr "checking passes all tests" ; _n ; go_test
	_gr "checking passes formating" ; _n ; go_fmt
	_gr "checking for suspsiscious code" ; _n ; go_vet
	_gr "checking spelling in comments and strings" ; _n ; go_misspell
	_gr "checking for ineffectual assignments" ; _n ; go_assign
	_gr "checking cyclomatic complexity" ; _n ; go_cyclo
	_gr "checking lint complaints" ; _n ; go_lint
}

$1
