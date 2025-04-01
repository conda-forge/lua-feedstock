#!/usr/bin/env bash

if [ $(uname) == Linux ]; then
    make CC="${CC}" INSTALL_TOP="${PREFIX}" LUA_SO="liblua${SHLIB_EXT}" linux
elif [ $(uname) == Darwin ]; then
    make CC="${CC}" INSTALL_TOP="${PREFIX}" LUA_SO="liblua${SHLIB_EXT}" macosx
fi

if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" ]]; then
    make CC="${CC}" INSTALL_TOP="${PREFIX}" LUA_SO="liblua${SHLIB_EXT}" test
fi

make INSTALL_TOP="${PREFIX}" LUA_SO="liblua${SHLIB_EXT}" install

# Create the pkg-config file
mkdir -p "${PREFIX}/lib/pkgconfig"
(sed -e "s@PKG_VERSION@${PKG_VERSION}@g" -e "s@CONDA_PREFIX@${PREFIX}@g" |
    sed -E "s@^(V=.+)\.[0-9]+@\1@g" \
        >"${PREFIX}/lib/pkgconfig/lua.pc") <<"EOF"
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
Libs: -L${libdir} -llua -lm
Cflags: -I${includedir}
EOF
