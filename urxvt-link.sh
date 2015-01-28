#!/bin/bash
echo -n "$1" | nohup >/dev/null 2>&1 xclip

firefox "$1"
