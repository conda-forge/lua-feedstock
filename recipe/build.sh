#!/usr/bin/env bash

sed -r -e '/^LUA_(SO|A|T)=/ s/lua/lua5.3/' -e '/^LUAC_T=/ s/luac/luac5.3/' -i src/Makefile

make INSTALL_TOP=$PREFIX \
     CC="${CC}" \
     MYCFLAGS="${CLFAGS} -fPIC -I$PREFIX/include -L$PREFIX/lib  -DLUA_USE_DLOPEN -DLUA_USE_LINUX -DLUA_USER_DEFAULT_PATH='\"$PREFIX/\"'" \
     MYLDFLAGS="$LDFLAGS -L$PREFIX/lib -Wl,-rpath=$PREFIX/lib" \
     linux

make \
    TO_BIN='lua5.3 luac5.3' \
    TO_LIB="liblua5.3.a liblua5.3.so liblua5.3.so.5.3 liblua5.3.so.5.3.6" \
    INSTALL_DATA='cp -d' \
    INSTALL_TOP="$PREFIX" \
    INSTALL_INC="$PREFIX"/include/lua5.3 \
    INSTALL_MAN="$PREFIX"/share/man/man1 \
    install


mv ${PREFIX}/share/man/man1/lua.1 ${PREFIX}/share/man/man1/lua5.3.1
mv ${PREFIX}/share/man/man1/luac.1 ${PREFIX}/share/man/man1/luac5.3.1

# Create the pkg-config file
mkdir -p "${PREFIX}/lib/pkgconfig"
(sed -e "s@PKG_VERSION@${PKG_VERSION}@g" -e "s@CONDA_PREFIX@${PREFIX}@g" | \
     sed -E "s@^(V=.+)\.[0-9]+@\1@g" \
         > "${PREFIX}/lib/pkgconfig/lua53.pc") << "EOF"
V=PKG_VERSION
R=PKG_VERSION
prefix=CONDA_PREFIX
INSTALL_BIN=${prefix}/bin
INSTALL_INC=${prefix}/include/lua5.3
INSTALL_LIB=${prefix}/lib
INSTALL_MAN=${prefix}/share/man/man1
INSTALL_LMOD=${prefix}/share/lua/${V}
INSTALL_CMOD=${prefix}/lib/lua/${V}
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include/lua5.3
Name: Lua
Description: An Extensible Extension Language
Version: ${R}
Requires:
Libs: -L${libdir} -llua5.3 -lm -ldl
Cflags: -I${includedir}
EOF

ln -sfr ${PREFIX}/lib/pkgconfig/lua53.pc ${PREFIX}/lib/pkgconfig/lua5.3.pc
ln -sfr ${PREFIX}/lib/pkgconfig/lua53.pc ${PREFIX}/lib/pkgconfig/lua-5.3.pc
