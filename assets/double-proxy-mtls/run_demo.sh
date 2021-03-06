#!/bin/bash

# Copyright IBM Corporation 2018
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ENVOY_PORT=15001

./set_iptables.sh $ENVOY_PORT `id -u root`
envoy -c envoy_config1.yaml --v2-config-only &
envoy -c envoy_config2.yaml --v2-config-only --base-id 2 &

su - clientuser -c "curl -s https://edition.cnn.com | grep -o '<title>.*</title>'"
sleep 5
curl -s localhost:8002/stats | grep tcp.envoy2.local.downstream_cx_total
sleep 5
curl -s localhost:8002/stats | grep tcp.cnn.downstream_cx_total
sleep 5
