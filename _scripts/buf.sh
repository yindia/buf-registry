#!/bin/bash
set -x

TMP_DEPS_FOLDER=tmp/deps
TMP_DEPS_GRPC_GATEWAY_FOLDER=tmp/grpc-gateway
TMP_DEPS_K8S_IO=tmp/k8s.io

download () {
    # # clear all the tmp deps folder
    rm -rf $TMP_DEPS_GRPC_GATEWAY_FOLDER $TMP_DEPS_K8S_IO

    # # grpc-gateway deps
    git -c advice.detachedHead=false clone --depth 1 --branch v1.15.2 https://github.com/grpc-ecosystem/grpc-gateway $TMP_DEPS_GRPC_GATEWAY_FOLDER #v1.15.2 is used to keep the grpc-gateway version in sync with generated protos which is using the LYFT image
    cp -r $TMP_DEPS_GRPC_GATEWAY_FOLDER/protoc-gen-swagger  proto/protoc-gen-swagger/
    rm -rf $TMP_DEPS_GRPC_GATEWAY_FOLDER

    # # k8 dependencies
    git clone --depth 1 https://github.com/kubernetes/api $TMP_DEPS_K8S_IO/api
    git clone --depth 1 https://github.com/kubernetes/apimachinery $TMP_DEPS_K8S_IO/apimachinery
    cp -r $TMP_DEPS_K8S_IO/k8s.io proto/k8s.io
    rm -rf $TMP_DEPS_K8S_IO

    rm -rf tmp
}

publish () {
    buf mod update proto/k8s.io/
    buf mod update proto/protoc-gen-swagger/
    buf build --verbose --debug
    echo $BUF_TOEKN | buf registry login --username $BUF_USER --token-stdin
    ls -al proto/k8s.io/k8s.io
    ls -al proto/protoc-gen-swagger/protoc-gen-swagger
    buf push proto/k8s.io/
    buf push proto/protoc-gen-swagger/
}

$1