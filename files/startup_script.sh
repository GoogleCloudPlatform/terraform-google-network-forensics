#! /bin/bash
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

# shellcheck disable=SC2016,SC2034,SC2086,SC2001

sudo userdel -r packer

INTERFACE_NAME=$(ip -br link | grep -v LOOPBACK | awk '{ print $1 }')
export INTERFACE_NAME

sed -i 's/"vpc"/"${vpc_name}"/' /usr/local/zeek/share/zeek/site/add_fields.zeek
sed -i 's/"project"/"${project_id}"/' /usr/local/zeek/share/zeek/site/add_fields.zeek

echo -e '\n# Ignore collector subnets\nredef PacketFilter::default_capture_filter="(ip or not ip) and not (net ${collector_cidr})";\n' >> /usr/local/zeek/share/zeek/site/local.zeek

sed -i '0,/interface=.*/s//interface='$INTERFACE_NAME'/' /usr/local/zeek/etc/node.cfg
sed -i '0,/LogExpireInterval = .*/s//LogExpireInterval = 3day/' /usr/local/zeek/etc/zeekctl.cfg

echo "" >> /usr/local/zeek/etc/networks.cfg
echo -e '${ip_cidrs}' >> /usr/local/zeek/etc/networks.cfg

export PATH=/usr/local/zeek/bin:$PATH
zeekctl install
zeekctl deploy

systemctl restart google-fluentd

if [ -f /etc/startup_script_completed ]; then
exit 0
fi
a2ensite default-ssl
a2enmod ssl

file_ports="/etc/apache2/ports.conf"
file_http_site="/etc/apache2/sites-available/000-default.conf"

http_listen_prts="Listen 80\nListen 8008\nListen 8080\nListen 8088"
http_vh_prts="*:80 *:8008 *:8080 *:8088"

vm_hostname="$(curl -H "Metadata-Flavor:Google" \
http://169.254.169.254/computeMetadata/v1/instance/name)"

echo "Page served from: $vm_hostname" | \
tee /var/www/html/index.html

prt_conf="$(cat "$file_ports")"
prt_conf_2="$(echo "$prt_conf" | sed "s|Listen 80|$${http_listen_prts}|")"

echo "$prt_conf_2" | tee "$file_ports"

http_site_conf="$(cat "$file_http_site")"
http_site_conf_2="$(echo "$http_site_conf" | sed "s|*:80|$${http_vh_prts}|")"

echo "$http_site_conf_2" | tee "$file_http_site"

systemctl restart apache2

touch /etc/startup_script_completed
