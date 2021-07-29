#  Copyright 2021 Google LLC
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.


# This script adds the cloud agent's package repository to our VM and installs the Fluentd (Cloud Logging agent).
# After the installation, it starts the Fluentd service.
# Further, it adds the Zeek configuration file to its respective Fluentd directory and restarts the Fluentd service.


#! /bin/bash

curl -sSO https://dl.google.com/cloudagents/add-logging-agent-repo.sh
bash add-logging-agent-repo.sh

apt-get update              # necessary to update
apt-get install -y google-fluentd google-fluentd-catch-all-config-structured

service google-fluentd start

cp -f /tmp/files/zeek.conf /etc/google-fluentd/config.d/

service google-fluentd force-reload
service google-fluentd restart

echo "---------------------------------------- Fluentd Configurations Completed!"