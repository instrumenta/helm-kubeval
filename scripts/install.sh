#!/bin/sh -e

cd $HELM_PLUGIN_DIR
version="$(cat plugin.yaml | grep "version" | cut -d '"' -f 2)"
echo "Installing helm-kubeval v${version} ..."

unameOut="$(uname -s)"

case "${unameOut}" in
    Linux*)     os=linux;;
    Darwin*)    os=darwin;;
    *)          os="UNKNOWN:${unameOut}"
esac

url="https://github.com/instrumenta/kubeval/releases/download/${version}/kubeval-${os}-amd64.tar.gz"

if [ "$url" = "" ]
then
    echo "Unsupported OS / architecture: ${os}_${arch}"
    exit 1
fi

filename=`echo ${url} | sed -e "s/^.*\///g"`

if [ -n $(command -v curl) ]
then
    curl -sSL -O $url
elif [ -n $(command -v wget) ]
then
    wget -q $url
else
    echo "Need curl or wget"
    exit -1
fi

rm -rf bin && mkdir bin && tar xzvf $filename -C bin > /dev/null && rm -f $filename

echo "helm-kubeval ${version} is installed."
echo
echo "See https://kubeval.instrumenta.dev for help getting started."
