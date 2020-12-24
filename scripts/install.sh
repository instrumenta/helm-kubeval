#! /bin/bash -e

cd $HELM_PLUGIN_DIR
version="$(cat plugin.yaml | grep "version" | cut -d '"' -f 2)"
echo "Installing helm-kubeval v${version} ..."

unpackCommand="tar xzvf"
directoryTargetFlag="-C"
format=".tar.gz"
arch="-amd64"
unameOut="$(uname -s)"

case "${unameOut}" in
    Linux*)     os=linux;;
    Darwin*)    os=darwin;;
    MINGW32*)   
      os=windows
      arch="-386"
      format=".zip"
      unpackCommand="unzip"
      directoryTargetFlag="-d"
      ;;
    MINGW64*)   
      os=windows
      format=".zip"
      unpackCommand="unzip"
      directoryTargetFlag="-d"
      ;;
    *)          os="UNKNOWN:${unameOut}"
esac

url="https://github.com/instrumenta/kubeval/releases/download/${version}/kubeval-${os}${arch}${format}"

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

rm -rf bin && mkdir bin && $unpackCommand $filename $directoryTargetFlag bin > /dev/null && rm -f $filename

echo "helm-kubeval ${version} is installed."
echo
echo "See https://kubeval.instrumenta.dev for help getting started."
