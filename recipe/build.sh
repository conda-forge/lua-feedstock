make generic CC=${CC} INSTALL_TOP=$PREFIX MYCFLAGS="${CLFAGS} -fPIC -I$PREFIX/include -L$PREFIX/lib -DLUA_USER_DEFAULT_PATH='\"$PREFIX/\"'" MYLDFLAGS="-L$PREFIX/lib -Wl,-rpath,$PREFIX/lib"
make generic CC=${CC} test
make install INSTALL_TOP=$PREFIX
