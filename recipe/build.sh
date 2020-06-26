LUA_CFLAGS="-DLUA_USER_DEFAULT_PATH='\"$PREFIX/\"' -DLUA_USE_POSIX"
make generic CC=${CC} INSTALL_TOP=$PREFIX MYCFLAGS="${CLFAGS} -fPIC -I$PREFIX/include -L$PREFIX/lib ${LUA_CFLAGS}" MYLDFLAGS="-L$PREFIX/lib -Wl,-rpath,$PREFIX/lib"
make generic CC=${CC} test
make install INSTALL_TOP=$PREFIX

# Create the pkg-config file
mkdir -p "${PREFIX}/lib/pkgconfig"
(sed -e "s@PKG_VERSION@${PKG_VERSION}@g" -e "s@CONDA_PREFIX@${PREFIX}@g" | \
 sed -E "s@^(V=.+)\.[0-9]+@\1@g" \
 > "${PREFIX}/lib/pkgconfig/lua.pc") << "EOF"
V=PKG_VERSION
R=PKG_VERSION

prefix=CONDA_PREFIX
INSTALL_BIN=${prefix}/bin
INSTALL_INC=${prefix}/include
INSTALL_LIB=${prefix}/lib
INSTALL_MAN=${prefix}/share/man/man1
INSTALL_LMOD=${prefix}/share/lua/${V}
INSTALL_CMOD=${prefix}/lib/lua/${V}
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: Lua
Description: An Extensible Extension Language
Version: ${R}
Requires:
Libs: -L${libdir} -llua -lm -ldl
Cflags: -I${includedir}
EOF
