# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-2020 Team LibreELEC
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)
# Copyright (C) 2022-present Fewtarius

PKG_NAME="bash"
PKG_VERSION="5.1.16"
PKG_LICENSE="GPL"
PKG_SITE="http://www.gnu.org/software/bash/"
PKG_URL="http://ftpmirror.gnu.org/bash/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses readline"
PKG_LONGDESC="The GNU Bourne Again shell."

PKG_CONFIGURE_OPTS_TARGET="--with-curses \
                           --enable-readline \
                           --without-bash-malloc \
                           --with-installed-readline"

pre_configure_target() {
  export CFLAGS_FOR_BUILD="${HOST_CFLAGS} -std=gnu17"
}

post_configure_target() {
  sed -i \
    -e "s|^READLINE_LIB = .*|READLINE_LIB = ${SYSROOT_PREFIX}/usr/lib/libreadline.a|" \
    -e "s|^READLINE_LDFLAGS = .*|READLINE_LDFLAGS =|" \
    -e "s|^HISTORY_LIB = .*|HISTORY_LIB = ${SYSROOT_PREFIX}/usr/lib/libhistory.a|" \
    -e "s|^HISTORY_LDFLAGS = .*|HISTORY_LDFLAGS =|" \
    -e "s|^TERMCAP_LIB = .*|TERMCAP_LIB = ${SYSROOT_PREFIX}/usr/lib/libtinfo.a|" \
    -e "s|^TERMCAP_LDFLAGS = .*|TERMCAP_LDFLAGS =|" \
    Makefile
}

post_install() {
  ln -sf bash ${INSTALL}/usr/bin/sh
  mkdir -p ${INSTALL}/etc
  cat <<EOF >${INSTALL}/etc/shells
/usr/bin/bash
/usr/bin/sh
EOF
  chmod 4755 ${INSTALL}/usr/bin/bash
}
