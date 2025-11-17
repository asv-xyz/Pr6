#!/bin/bash

while getopts ":uphl:e:" opt; do
	case $opt in
		u)
			echo "1" ;;
		p)
			echo "2" ;;
		h)
			echo "3" ;;
		l)
			echo "4" ;;
		e)
			echo "5" ;;
	esac
done
