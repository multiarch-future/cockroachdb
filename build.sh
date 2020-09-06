if [ "$TARGETPLATFORM" = "linux/amd64" ]
then
	wget -qO- https://binaries.cockroachdb.com/cockroach-v20.1.5.linux-amd64.tgz | tar  xvz
	cp -i cockroach-v20.1.5.linux-amd64/cockroach /
	wget -O /cockroach.sh https://raw.githubusercontent.com/cockroachdb/cockroach/$COMMIT/build/deploy/cockroach.sh
	chmod +x /cockroach.sh
else
	mkdir -p $(go env GOPATH)/src/github.com/cockroachdb
	cd $(go env GOPATH)/src/github.com/cockroachdb
	git clone https://github.com/cockroachdb/cockroach
	cd cockroach
	git checkout $COMMIT

	export krb5_cv_attr_constructor_destructor=yes
	export ac_cv_func_regcomp=yes
	export ac_cv_printf_positional=yes

	./build/builder/mkrelease.sh arm64-linux -j 12

	mv cockroach-linux-* /cockroach
	cp build/deploy/cockroach.sh /
fi