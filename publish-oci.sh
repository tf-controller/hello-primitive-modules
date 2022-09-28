pushd .

REPO=tf-controller/hello-primitive-modules
PROVIDER_VERSION=v4.32.0

tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)
cd $tmp_dir

git clone https://github.com/${REPO}
cd aws-primitive-modules

TAG=$(git rev-parse --short HEAD)
SOURCE="$(git config --get remote.origin.url)"
REVISION="$(git branch --show-current)/$(git rev-parse HEAD)"

rm -rf .git
rm Makefile
rm *.sh

flux push artifact \
    oci://ghcr.io/${REPO}/$PROVIDER_VERSION:$TAG \
	--path="./" \
	--source=$SOURCE \
	--revision=$REVISION

flux tag artifact \
    oci://ghcr.io/${REPO}/$PROVIDER_VERSION:$TAG \
    --tag latest

flux tag artifact \
    oci://ghcr.io/${REPO}/$PROVIDER_VERSION:$TAG \
    --tag $1

rm -rf $tmp_dir

popd
