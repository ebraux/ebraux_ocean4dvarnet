#!/bin/bash
set -e

locale-gen en_US.UTF-8
echo "LC_ALL=en_US.UTF-8" >> /etc/environment
echo "LANG=en_US.UTF-8" >> /etc/environment