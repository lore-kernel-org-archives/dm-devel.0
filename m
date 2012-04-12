From: Milan Broz <gmazyland-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] cryptsetup 1.4.2
Date: Thu, 12 Apr 2012 10:38:58 +0200
Message-ID: <4F8694A2.2070804@gmail.com>
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

The stable cryptsetup 1.4.2 release is available at

   http://code.google.com/p/cryptsetup/

Feedback and bug reports are welcomed.


Cryptsetup 1.4.2 Release Notes
==============================

Changes since version 1.4.1

* Add --keyfile-offset and --new-keyfile-offset parameters to API and CLI.
  These options can be used to skip start of keyfile or device used as keyfile.

* Add repair command and crypt_repair() for known LUKS metadata problems repair.

  Some well-known LUKS metadata corruptions are easy to repair, this
  command should provide a way to fix these problems.

  Always create binary backup of header device before running repair,
  (only 4kB - visible header) for example by using dd:
     dd if=/dev/<LUKS header device> of=repair_bck.img bs=1k count=4

  Then you can try to run repair:
     cryptsetup repair <device>

 Note, not all problems are possible to repair and if keyslot or some header
 parameters are overwritten, device is lost permanently.

* Fix header check to support old (cryptsetup 1.0.0) header alignment.
  (Regression in 1.4.0)

* Allow to specify --align-payload only for luksFormat.

* Add --master-key-file option to luksOpen (open using volume key).

* Support UUID=<LUKS_UUID> format for device specification.
  You can open device by UUID (only shortcut to /dev/disk/by-uuid/ symlinks).

* Support password verification with quiet flag if possible. (1.2.0)
  Password verification can be still possible if input is terminal.

* Fix retry if entered passphrases (with verify option) do not match.
  (It should retry if requested, not fail.)

* Fix use of empty keyfile.

* Fix error message for luksClose and detached LUKS header.

* Allow --header for status command to get full info with detached header.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPhpShAAoJENmwV3vZPpj8vIoQAKmnjPd6x3s6nJjq0FRrFBZl
W+75LCImLInAZ4qOzGJys2m7rVBsrBPymcR59RDz/J6uY8QZh5gN7Fi4h59klOB5
Hi6JSsCl516z8c4fZ5m7qJA5FEX6Hn+PlpXaGzDqud+xjFz1Xd3sDC63GRMoUDlZ
N5HRbofC9PK+Cdq6joFwvPRvJCwp96cB2D7wR4b+bDy/Iau+Ydu0Ce+GcR99tyl5
kZ+umlQfgahYM0+wKnPYQZ3e9EKWS9h4746hnMLS0SmHEyczCx466tfm0DMxkRp3
hrx6LJ1goCIhuBwuYWMOahSMZNREjQ9HCCm2uBeHzIKBN1PtHm4vOTQ+VQWJ3ThI
WgMh7W7ezXGaJY8z2Xo1y5pNsspRin/kmsnogBvjd02CTyuda8ZDl2D2JpQcFbbO
JTz8vCAKJlZFB5NHoifhR8NAHsrcvc4aYUw4wu97hC+XzCkvrYXq3jrRCQ77yrYg
7CP3/MGyvWHPc5PbQVRBORO2R8UMKsPwcYqOuPzJFWlH7vxydvoXPa+5JXmlJTxZ
qW0Mf9ww8OioxqQat0uLI88Mgd2cA2Ys8Iv4Rp1TbAUvrTYjLS8qso+lkG7s7zcc
wmVaXz1WgyOwmjbsyV95qRKiCIA0NOqPUSNnKajmUjGuxBpHUjTQwsXPsMdbVXS/
c6+vm3SIWinLkje3bSbd
=QRJh
-----END PGP SIGNATURE-----
_______________________________________________
dm-crypt mailing list
dm-crypt-4q3lyFh4P1g@public.gmane.org
http://www.saout.de/mailman/listinfo/dm-crypt
