#!/bin/bash

# Functions
show_users() {
    # Get list of users and their home directories, sort alphabetically
    getent passwd | awk -F: '{print $1 ": " $6}' | sort
}

show_processes() {
    # Get list of processes, sort by PID
    ps -eo pid,comm --no-headers | sort -n
}

show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -u, --users          Display users and their home directories"
    echo "  -p, --processes      Display running processes"
    echo "  -h, --help          Show this help message"
    echo "  -l, --log PATH      Redirect output to file PATH"
    echo "  -e, --errors PATH   Redirect error output to file PATH"
    echo ""
    exit 0
}

# Variables for output redirection
LOG_FILE=""
ERRORS_FILE=""
SHOW_USERS=0
SHOW_PROCESSES=0
SHOW_HELP=0

# Define options for getopt
OPTIONS=uphl:e:
LONGOPTS=users,processes,help,log:,errors:

# Parse command line arguments
PARSED=`getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@"`

# Check if parsing was successful
if [ $? -ne 0 ]; then
    exit 1
fi

# Set parsed arguments
eval set -- "$PARSED"

# Process command line arguments
while true; do
    case "$1" in
        -u|--users)
            SHOW_USERS=1
            shift
            ;;
        -p|--processes)
            SHOW_PROCESSES=1
            shift
            ;;
        -h|--help)
            SHOW_HELP=1
            shift
            ;;
        -l|--logfile)
            LOG_FILE="$2"
            shift 2
            ;;
        -e|--errors)
            ERRORS_FILE="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Internal error" >&2
            exit 1
            ;;
    esac
done

# Configure error output redirection
if [ -n "$ERRORS_FILE" ]; then
    # Redirect stderr (file descriptor 2) to specified errors file
    exec 2>>"$ERRORS_FILE"
    if [ $? -ne 0 ]; then
        echo "Error: Cannot open error file for writing: $ERRORS_FILE" >&2
        exit 1
    fi
fi

# Configure standard output redirection
if [ -n "$LOG_FILE" ]; then
    # Redirect stdout (file descriptor 1) to specified log file
    exec 1>>"$LOG_FILE"
    if [ $? -ne 0 ]; then
        echo "Error: Cannot open log file for writing: $LOG_FILE" >&2
        exit 1
    fi
fi

# Execute requested actions based on flags
if [ $SHOW_HELP -eq 1 ]; then
    show_help
fi

if [ $SHOW_USERS -eq 1 ]; then
    show_users
fi

if [ $SHOW_PROCESSES -eq 1 ]; then
    show_processes
fi

# If no options were specified, show help
if [ $SHOW_USERS -eq 0 ] && [ $SHOW_PROCESSES -eq 0 ] && [ $SHOW_HELP -eq 0 ]; then
    show_help
fi
