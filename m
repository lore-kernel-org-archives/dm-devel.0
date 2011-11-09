From: Milan Broz <mbroz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [ANNOUNCE] cryptsetup 1.4.1
Date: Wed, 09 Nov 2011 13:46:15 +0100
Message-ID: <4EBA7617.4030401@redhat.com>
References: <4EA85582.3080904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org>
In-Reply-To: <4EA85582.3080904-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <http://www.saout.de/mailman/options/dm-crypt>,
 <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.saout.de/pipermail/dm-crypt>
List-Post: <mailto:dm-crypt-4q3lyFh4P1g@public.gmane.org>
List-Help: <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=help>
List-Subscribe: <http://www.saout.de/mailman/listinfo/dm-crypt>,
 <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=subscribe>
Errors-To: dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org
Sender: dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org
To: dm-crypt <dm-crypt-4q3lyFh4P1g@public.gmane.org>
Cc: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

The stable cryptsetup 1.4.1 release is available at

   http://code.google.com/p/cryptsetup/

Feedback and bug reports are welcomed.


Cryptsetup 1.4.1 Release Notes
==============================

Changes since version 1.4.0

* Merge experimental Python cryptsetup (pycryptsetup) binding.

  This option is disabled by default, you can enable build of Python binding
  with --enable--python configure switch.

  Note that binding currently covers only partial libcryptsetup functions,
  mainly LUKS device handling needed for Anaconda installer.
  Until now provided separately as python-cryptsetup.
  Thanks to Martin Sivak for the code.

  See python subdirectory for more info.

  Python binding code is experimental for now, no stable API guarantee.

* Fix crypt_get_volume_key_size() for plain device.
  (cryptsetup status reported zero key size for plain crypt devices).

* Fix typo in set_iteration_time API call (old name remains for compatibility reasons).

* Fix FSF address in license and add LGPL license text.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk66dhcACgkQf1Jlc7shgi8RCgCfXkzU1oUSDpsEiSxHQ/rd51l1
uuEAn3zxefcqXz7JiW3hjW4GlEnAl1gj
=ePPt
-----END PGP SIGNATURE-----
_______________________________________________
dm-crypt mailing list
dm-crypt-4q3lyFh4P1g@public.gmane.org
http://www.saout.de/mailman/listinfo/dm-crypt
