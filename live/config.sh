#!/bin/bash
# kiwi runs this inside the image after installing packages. Kansora's own setup
# (services from its presets, graphical target, greetd, boot splash, GRUB menu)
# happens in the kansora package's scriptlets; this covers what only an image
# build needs.
set -euxo pipefail

test -f /.kconfig && . /.kconfig
test -f /.profile && . /.profile

# Each installed machine makes its own identity
rm -f /etc/machine-id
echo 'uninitialized' > /etc/machine-id
rm -f /var/lib/systemd/random-seed

# Match Fedora's GRUB settings (kiwi issue 2198, no submenus or recovery entries)
echo "GRUB_DEFAULT=saved" >> /etc/default/grub
echo "GRUB_DISABLE_SUBMENU=true" >> /etc/default/grub
echo "GRUB_DISABLE_RECOVERY=true" >> /etc/default/grub

# No root password (users are created in the installer)
passwd -d root
passwd -l root

# Live session: livesys runs /usr/libexec/livesys/sessions.d/livesys-niri
echo 'livesys_session="niri"' > /etc/sysconfig/livesys
