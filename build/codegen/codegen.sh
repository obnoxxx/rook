#!/usr/bin/env -S bash -e

# Copyright 2018 The Rook Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

##GROUP_VERSIONS="ceph.rook.io:v1"

scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

basedir="$(cd "$(dirname "${scriptdir}/../../../../.." )" && pwd)"

boilerplate="${CODE_GENERATOR}/examples/hack/"boilerplate.go.txt
kube_codegen="${CODE_GENERATOR}/kube_codegen.sh"


echo "DEBUG: scriptdir: ${scriptdir}"
echo "DEBUG: basedir: ${basedir}"
echo "DEBUG: CODE_GENERATOR: ${CODE_GENERATOR}"
echo "DEBUG: boilerplate ${boilerplate}"
echo "DEBUG: kube_codegen: ${kube_codegen}"



set -o pipefail


source "${kube_codegen}"



## echo "DEBUG: done"
## exit 0

# CODE GENERATION
# we run deepcopy and client,lister,informer generations separately so we can use the flag "--plural-exceptions"
# which is only known by client,lister,informer binary and not the deepcopy binary

# run code deepcopy generation
 kube::codegen::gen_helpers \
    --boilerplate "${boilerplate}" \
    "${basedir}/rook/rook"/pkg/apis

##    "${GROUP_VERSIONS}" \

# run code client,lister,informer generation
kube::codegen::gen_client \
    --output-dir "${basedir}" \
    --output-pkg "${basedir}/rook/rook"/pkg/client \
    --boilerplate "${boilerplate}" \
    --with-watch \
    "${basedir}/rook/rook"/pkg/apis \

##    --plural-exceptions "CephNFS:CephNFSes"
