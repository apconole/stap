#!/bin/bash

mount -t debugfs none /sys/kernel/debug

exec stap -g --all-modules /usr/local/bin/probe.stap 2>&1 | tee -a /tmp/probe.log
