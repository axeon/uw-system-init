#!/bin/bash
systemctl stop mihomo
unset http_proxy https_proxy all_proxy no_proxy
echo "Proxy OFF"