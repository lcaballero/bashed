#!/usr/bin/env bash


red=31 ; green=32 ; brown=33 ; blue=34
purple=35 ; cyan=36 ; light_gray=37

function _a() {
	echo -e -n "\033[$1m${@:2}\033[0m"
}
function _rd() {
	_a $red $*
}
function _gr() {
	_a $green $*
}
function _br() {
	_a $brown $*
}
function _bl() {
	_a $blue $*
}
function _pr() {
	_a $purple $*
}
function _cy() {
	_a $cyan $*
}
function _gy() {
	_a $light_gray $*
}
function _n() {
	echo -e ""
}
