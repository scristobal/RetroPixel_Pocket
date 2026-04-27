PKG_NAME="yabasanshiroSA"
PKG_VERSION="c7618d2ecbf77b1e8188fa8af4fa1cfb34833a72"
PKG_LICENSE="GPLv2"
#PKG_SITE="https://github.com/devmiyax/yabause"
#PKG_URL="${PKG_SITE}.git"

PKG_SITE="file://${OLDPWD}/extpackage/yabasanshiroSA-c7618d2ecbf77b1e8188fa8af4fa1cfb34833a72"
PKG_URL="${PKG_SITE}"
PKG_DEPENDS_TARGET="toolchain SDL2 boost openal-soft ${OPENGLES} zlib"
PKG_LONGDESC="Yabause is a Sega Saturn emulator and took over as Yaba Sanshiro"
PKG_TOOLCHAIN="cmake-make"
PKG_GIT_CLONE_BRANCH="pi4-1-9-0"
PKG_TAR_COPY_OPTS="--exclude=.git --exclude=.svn --exclude=.libreelec-unpack --exclude=.libreelec-package"

PKG_PATCH_DIRS="${DEVICE}"

unpack() {
  mkdir -p "${PKG_BUILD}"
  tar cf - -C "${PKG_SOURCE_NAME}" ${PKG_TAR_COPY_OPTS} . | tar xf - -C "${PKG_BUILD}"
}

pre_patch() {
  find "$(echo "${PKG_BUILD}" | cut -f1 -d\ )" -type f -exec perl -0pi -e 's/\r\n/\n/g' {} +
}

post_patch() {
  sed -i -e '/project(yabause)/a include_directories(${CMAKE_CURRENT_SOURCE_DIR})' \
    -e '/project(yabause)/a set(YABAUSE_LIBRARIES ${YABAUSE_LIBRARIES} EGL GLESv2)' \
    -e '/project(yabause)/a set(yabause_SOURCES ${yabause_SOURCES} yglcache.c ygles.c yglshaderes.c)' \
    -e '/project(yabause)/a add_definitions(-DHAVE_LIBGL=1 -D_OGLES3_=1 -DYAB_ASYNC_RENDERING -DYAB_PORT_OSD)' \
    -e '/add_definitions(-DIMPROVED_SAVESTATES)/a set(yabause_SOURCES ${yabause_SOURCES} yglcache.c ygles.c yglshaderes.c nanovg/nanovg_osdcore.c)' \
    "${PKG_BUILD}/yabause/src/CMakeLists.txt"
}

post_unpack() {
  # use host versions
  sed -i "s|COMMAND m68kmake|COMMAND ${PKG_BUILD}/m68kmake_host|" ${PKG_BUILD}/yabause/src/musashi/CMakeLists.txt
  sed -i "s|COMMAND ./bin2c|COMMAND ${PKG_BUILD}/bin2c_host|" ${PKG_BUILD}/yabause/src/retro_arena/nanogui-sdl/CMakeLists.txt
}

pre_make_target() {
  # runs on host so make them manually if package is not crosscompile friendly
  ${HOST_CC} ${PKG_BUILD}/yabause/src/retro_arena/nanogui-sdl/resources/bin2c.c -o ${PKG_BUILD}/bin2c_host
  ${HOST_CC} ${PKG_BUILD}/yabause/src/musashi/m68kmake.c -o ${PKG_BUILD}/m68kmake_host
}

pre_configure_target() {
PKG_CMAKE_OPTS_TARGET="${PKG_BUILD}/yabause \
                         -DYAB_PORTS=retro_arena \
                         -DYAB_WANT_DYNAREC_DEVMIYAX=ON \
                         -DYAB_WANT_ARM7=ON \
                         -DCMAKE_TOOLCHAIN_FILE=${PKG_BUILD}/yabause/src/retro_arena/n2.cmake \
                         -DYAB_WANT_VULKAN=OFF \
                         -DOPENGL_INCLUDE_DIR=${SYSROOT_PREFIX}/usr/include \
                         -DOPENGL_egl_LIBRARY=${SYSROOT_PREFIX}/usr/lib/libEGL.so \
                         -DOPENGL_gles2_LIBRARY=${SYSROOT_PREFIX}/usr/lib/libGLESv2.so \
                         -DOPENGL_gl_LIBRARY=OPENGL_gl_LIBRARY-NOTFOUND \
                         -DOPENGL_glu_LIBRARY=OPENGL_glu_LIBRARY-NOTFOUND \
                         -DOPENGL_glx_LIBRARY=OPENGL_glx_LIBRARY-NOTFOUND \
                         -DGLUT_INCLUDE_DIR=GLUT_INCLUDE_DIR-NOTFOUND \
                         -DGLUT_glut_LIBRARY=GLUT_glut_LIBRARY-NOTFOUND \
                         -DXRANDR_LIBRARY=XRANDR_LIBRARY-NOTFOUND \
                         -DLIBPNG_LIB_DIR=${SYSROOT_PREFIX}/usr/lib \
                         -Dpng_STATIC_LIBRARIES=${SYSROOT_PREFIX}/usr/lib/libpng16.a \
                         -DCMAKE_BUILD_TYPE=Release \
                         -DCMAKE_RULE_MESSAGES=OFF \
                         -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  cp -a ${PKG_BUILD}/src/retro_arena/yabasanshiro ${INSTALL}/usr/bin
  cp -a ${PKG_DIR}/yabasanshiro.sh ${INSTALL}/usr/bin

  mkdir -p ${INSTALL}/usr/config/yabasanshiro
  cp ${PKG_DIR}/config/* ${INSTALL}/usr/config/yabasanshiro
} 
