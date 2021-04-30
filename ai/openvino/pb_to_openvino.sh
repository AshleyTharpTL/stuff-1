#!/bin/bash

input_pb="${$1}"
output="${2}"

# needs to be added to path. See openvino setup instructions.
mo_tf.py --input-model ${input_pb} --output ${output} --keep_shape_ops --data_type FP16
