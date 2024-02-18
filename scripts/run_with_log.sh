#! /bin/bash

run_output=$(eval $@ 2>&1)


if [ $? -eq 0 ]; then
    echo "$run_output"
else
    echo "$run_output"
    log_file_command="$(echo $run_output | grep -oP 'nix log /nix/store(.*)0.drv')"
    eval $log_file_command
    exit 2
fi
