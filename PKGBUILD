# Maintainer: Joshua Ellis <josh@jpellis.me>
# Contributor: Anish Tondwalkar <anish@tjhsst.edu>
# Contributor: Ghost91 <m_graeb11@cs.uni-kl.de>
# Contributor: Michael Pusterhofer <pusterhofer at student dot tugraz dot at>
# Contributor: Raphael Scholer <rscholer@gmx.de>
# Contributor: kjslag <kjslag at gmail dot com>
# Contributor: teratomata <teratomat@gmail.com>

pkgname=mathematica
pkgver=13.1.0
pkgrel=1
pkgdesc="A computational software program used in scientific, engineering, and mathematical fields and other areas of technical computing with offline documentation."
arch=('x86_64')
url="http://www.wolfram.com/mathematica/"
license=('proprietary')
depends=(
    'openmp'
)
optdepends=(
    ## The following list of dependencies was inferred from namcap's output.  If
    ## you believe there is an error, please let me know.  Also feel free to
    ## contribute description to dependencies if you know what they do.
    'alsa-lib'
    'atk'
    'cairo'
    'ffmpeg'
    'fontconfig'
    'gdk-pixbuf2'
    'glib2'
    'glu'
    'gmime'
    'gmp'
    'gtk2'
    'harfbuzz'
    'intel-tbb'
    'java-environment'
    'java-runtime'
    'leptonica'
    'libbson'
    'libffi'
    'libmongoc'
    'libogg'
    'libpng12'
    'libselinux'
    'libsm'
    'libssh2'
    'libutil-linux'
    'libx11'
    'libxcomposite'
    'libxml2'
    'libxrandr'
    'libxslt'
    'libxss'
    'libxtst'
    'libxxf86vm'
    'mesa-demos: for improved graphics output'
    'ncurses'
    'nvidia-utils'
    'openssl-1.0'
    'pango'
    'pixman'
    'portaudio'
    'postgresql-libs'
    'python'
    'qt5-declarative'
    'qt5-multimedia'
    'qt5-webengine'
    'qt5-xmlpatterns'
    'r'
    'tesseract'
    'zlib'
)
source=("local://Mathematica_${pkgver}_BNDL_LINUX.sh"
        "Z98-mathematica-path.sh")
md5sums=('23e6c72f6b948cefc4f588ec563af488'
         'd38f38de6da65a30f8c95bd5d59df83d')
options=("!strip")

## To build this package you need to place the mathematica-installer into your
## startdir If you don't own the installer you can download a trial version at
## http://www.wolfram.com/mathematica/trial

## The documentation takes up the majority of the disk space.  If you do not wish
## to keep it, uncomment the relevant lines at the bottom of this PKGBUILD.

## The final package can be very large (especially if documentation is kept) and
## compression can be quite slow.  In most cases, the package is installed
## straight away and the package need not be kept, so compression is disabled.
# PKGEXT='.pkg.tar'

prepare() {
    warning "Building Mathematica takes more than 24GiB of space for 'makepkg'."
    warning "Building in a tmpfs (e.g. /tmp when mounted into RAM) may not work."

    if [ $(echo "${srcdir}" | wc -w) -ne 1 ]; then
        msg2 "ERROR: The Mathematica installer doesn't support directory names with spaces."
        msg2 "Current build directory: ${srcdir}"
        exit 1
    fi

    chmod +x ${srcdir}/Mathematica_${pkgver}_BNDL_LINUX.sh
}

package() {
    msg2 "Running Mathematica installer"
    # https://reference.wolfram.com/language/tutorial/InstallingMathematica.html#650929293
    sh ${srcdir}/Mathematica_${pkgver}_BNDL_LINUX.sh \
             --keep --target ${srcdir}/Mathematica_${pkgver}_BNDL_LINUX \
        -- \
             -execdir=${pkgdir}/usr/bin \
             -targetdir=${pkgdir}/opt/Mathematica \
             -auto # ... `--keep` extracted files
    msg2 "Errors related to 'xdg-icon-resource' and 'xdg-desktop-menu' are to be expected during Mathematica's installation."
    rm ${pkgdir}/opt/Mathematica/InstallErrors

    msg2 "Fixing symbolic links"
    cd ${pkgdir}/opt/Mathematica/Executables
    rm wolframscript
    ln -s /opt/Mathematica/SystemFiles/Kernel/Binaries/Linux-x86-64/wolframscript
    cd ${pkgdir}/usr/bin
    rm *
    # add to $PATH
    install -Dm644 -t "${pkgdir}/etc/profile.d" "${srcdir}/Z98-mathematica-path.sh"

    msg2 "Setting up WolframScript"
    mkdir -p ${srcdir}/WolframScript
    mkdir -p ${pkgdir}/usr/share/
    cd ${srcdir}/WolframScript
    bsdtar -xf ${pkgdir}/opt/Mathematica/SystemFiles/Installation/wolframscript_*_amd64.deb data.tar.xz
    tar -xf data.tar.xz -C ${pkgdir}/usr/share/ --strip=3 ./usr/share/


    msg2 "Copying menu and mimetype information"
    mkdir -p \
          ${pkgdir}/usr/share/applications \
          ${pkgdir}/usr/share/desktop-directories \
          ${pkgdir}/usr/share/mime/packages
    cd ${pkgdir}/opt/Mathematica/SystemFiles/Installation
    desktopFile='wolfram-mathematica.desktop'
    mv 'wolfram-mathematica13.desktop' $desktopFile                           # remove ${pkgver}
    sed -Ei 's|^(\s*TryExec=).*|\1Mathematica|g' $desktopFile                 # find in $PATH
    sed -Ei 's|^(\s*Exec=).*|\1Mathematica --singlelaunch %F|g' $desktopFile  # use single instance
    printf 'Categories=Science;Education;Languages;ArtificialIntelligence;Astronomy;Biology;Chemistry;ComputerScience;DataVisualization;Geography;ImageProcessing;Math;NumericalAnalysis;MedicalSoftware;Physics;ParallelComputer;\n' >> $desktopFile
    printf 'StartupWMClass=Mathematica\n' >> $desktopFile                     # no semicolon
    cp $desktopFile ${pkgdir}/usr/share/applications/
    # cp wolfram-all.directory ${pkgdir}/usr/share/desktop-directories/       # unused
    cp *.xml ${pkgdir}/usr/share/mime/packages/

    msg2 "Copying icons"
    mkdir -p ${pkgdir}/usr/share/icons/hicolor/{32x32,64x64,128x128}/{apps,mimetypes}
    cd ${pkgdir}/opt/Mathematica/SystemFiles/FrontEnd/SystemResources/X
    for i in 32 64 128; do
        cp App-${i}.png ${pkgdir}/usr/share/icons/hicolor/${i}x${i}/apps/wolfram-mathematica.png
        for mimetype in $(ls vnd.* | cut -d '-' -f1 | uniq); do
            cp ${mimetype}-${i}.png ${pkgdir}/usr/share/icons/hicolor/${i}x${i}/mimetypes/application-${mimetype}.png
        done
    done

    msg2 "Copying man pages"
    mkdir -p ${pkgdir}/usr/share/man/man1
    cd ${pkgdir}/opt/Mathematica/SystemFiles/SystemDocumentation/Unix
    cp *.1 ${pkgdir}/usr/share/man/man1

    msg2 "Copying license"
    mkdir -p ${pkgdir}/usr/share/licenses/Mathematica/
    cp ${pkgdir}/opt/Mathematica/LICENSE.txt ${pkgdir}/usr/share/licenses/Mathematica/license.txt

    msg2 "Fixing file permissions"
    chmod go-w -R ${pkgdir}/*
}
