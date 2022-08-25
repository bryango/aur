# Maintainer: Alberto Fanjul <albertofanjul@gmail.com>
_name=miraclecast
pkgname=$_name-git
pkgver=300.43505ab
pkgrel=1
pkgdesc="MiracleCast provides software to connect external monitors to your system via Wifi. It is compatible to Miracast. Link-management works, everything else is still being worked on. Replaces openwfd. Contribute on https://github.com/albfan/aur-miraclecast"
arch=('i686' 'x86_64' 'armv6h' 'armv7h')
url="https://github.com/albfan/$_name"
license=('GPL')
depends=(git "systemd>=221" "python3" "glib2")
provides=("$_name")
conflicts=("$_name")
backup=(etc/dbus-1/system.d/org.freedesktop.miracle.conf)
source=("$_name::git+https://github.com/albfan/miraclecast.git#branch=master")
md5sums=('SKIP')

build() {
  cd "$srcdir/$_name"
  ./autogen.sh
  ./configure --prefix=/usr --sysconfdir=/etc
  make
}

check() {
  cd "$srcdir/$_name"
  make -k check
}

package() {
  cd "$srcdir/$_name"
  make DESTDIR="$pkgdir/" install
}

pkgver() {
  cd "$srcdir/$_name"
  echo $(git rev-list --count HEAD).$(git rev-parse --short HEAD)
}
