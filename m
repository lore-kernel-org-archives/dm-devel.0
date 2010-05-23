From: Milan Broz <mbroz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [ANNOUNCE] cryptsetup 1.1.1
Date: Sun, 23 May 2010 16:27:39 +0200
Message-ID: <4BF93B5B.3070907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org>
List-Unsubscribe: <http://www.saout.de/mailman/options/dm-crypt>,
	<mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.saout.de/pipermail/dm-crypt>
List-Post: <mailto:dm-crypt-4q3lyFh4P1g@public.gmane.org>
List-Help: <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=help>
List-Subscribe: <http://www.saout.de/mailman/listinfo/dm-crypt>,
	<mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=subscribe>
Sender: dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org
Errors-To: dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org
To: dm-crypt <dm-crypt-4q3lyFh4P1g@public.gmane.org>
Cc: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

The stable cryptsetup 1.1.1 release is available at

   http://code.google.com/p/cryptsetup/

Feedback and bug reports are welcomed.

Milan
mbroz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org


Cryptsetup 1.1.1 Release Notes
==============================

Changes since version 1.1.1-rc2
* Fix luksClose error if underlying device is LVM logical volume.

Changes since version 1.1.1-rc1
* Fix automatic dm-crypt module loading.

Changes since version 1.1.0

Important changes:
~~~~~~~~~~~~~~~~~~

* Detects and use device-mapper udev support if available.

  This should allow synchronisation with udev rules and avoid races with udev.

  If package maintainer want to use old, direct libdevmapper device node creation,
  use configure option --disable-udev.

* Supports device topology detection for data alignment.

  If kernel provides device topology ioctl calls, the LUKS data area
  alignment is automatically set to optimal value.

  This means that stacked devices (like LUKS over MD/LVM)
  should use the most optimal data alignment.

  (You can still overwrite this calculation using --align-payload option.)

* Prefers some device paths in status display.
  (So status command will try to find top level device name, like /dev/sdb.)

* Fix package config file to use proper package version.

Other changes:
~~~~~~~~~~~~~~
* Fix luksOpen reading of passphrase on stdin (if "-" keyfile specified).
* Fix isLuks to initialise crypto backend (blkid instead is suggested anyway).
* Properly initialise crypto backend in header backup/restore commands.
* Do not verify unlocking passphrase in luksAddKey command.
* Allow no hash specification in plain device constructor - user can provide volume key directly.
* Try to use pkgconfig for device mapper library in configuration script.
* Add some compatibility checks and disable LUKS suspend/resume if not supported.
* Rearrange tests, "make check" now run all available test for package.
* Avoid class C++ keyword in library header.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv5O1sACgkQf1Jlc7shgi9NWwCeLKDZVw50v/UURvmdAyb+vAJ/
r1gAn38pny0qkFgzD9FxBo9qWT2gi5qT
=h4oU
-----END PGP SIGNATURE-----
_______________________________________________
dm-crypt mailing list
dm-crypt-4q3lyFh4P1g@public.gmane.org
http://www.saout.de/mailman/listinfo/dm-crypt
