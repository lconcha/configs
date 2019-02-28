#!/bin/bash

sed -i 's/^IPAddressDeny=any/#IPAddressDeny=any/' /lib/systemd/system/systemd-logind.service

