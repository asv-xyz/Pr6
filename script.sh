#!/bin/bash

# Variables
OPTIONS=uphl:e:
LONGOPTS=users,processes,help,log:,errors:
PARSED=`getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@"`

# Check if any errors occured
if [ $? -ne 0 ]; then
    exit 1
fi

# Format
eval set -- "$PARSED"

# Main script
while true; do
    case "$1" in
        -u|--users)
            echo "1"
            shift
            ;;
        -p|--processes)
            echo "2"
            shift
            ;;
        -h|--help)
            echo "3"
            shift
            ;;
        -l|--logfile)
            echo "4: $2"
            shift 2
            ;;
        -e|--errors)
            echo "5: $2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Internal error"
            exit 1
            ;;
    esac
done
