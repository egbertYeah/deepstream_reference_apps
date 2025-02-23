#!/bin/sh
################################################################################
# Copyright (c) 2021-2023, NVIDIA CORPORATION. All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.
################################################################################

#This script is to download peoplenet pretrained model and run peoplenet DeepStream application

echo "==================================================================="
echo "begin download models for peopleNet "
echo "==================================================================="
mkdir -p ./triton/peopleNet/
wget --content-disposition https://api.ngc.nvidia.com/v2/models/nvidia/tao/peoplenet/versions/deployable_quantized_v2.6.1/zip \
-O peoplenet_deployable_quantized_v2.6.1.zip && \
unzip peoplenet_deployable_quantized_v2.6.1.zip -d ./triton/peopleNet/ && \
rm peoplenet_deployable_quantized_v2.6.1.zip

mkdir -p ./triton/peopleNet/1
./tao-converter -k tlt_encode -t int8 -c ./triton/peopleNet/resnet34_peoplenet_int8.txt -b 1 -d 3,544,960 -e ./triton/peopleNet/1/resnet34_peoplenet_int8.etlt_b1_gpu0_int8.engine ./triton/peopleNet/resnet34_peoplenet_int8.etlt
cp triton/peopleNet_config.pbtxt ./triton/peopleNet/config.pbtxt

echo "==================================================================="
echo "Run deepstream-app"
echo "==================================================================="
deepstream-app -c deepstream_app_source1_peoplenet.txt
