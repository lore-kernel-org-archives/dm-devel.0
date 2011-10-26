From: Milan Broz <mbroz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [ANNOUNCE] cryptsetup 1.4.0
Date: Wed, 26 Oct 2011 20:46:26 +0200
Message-ID: <4EA85582.3080904@redhat.com>
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
Errors-To: dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org
Sender: dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org
To: dm-crypt <dm-crypt-4q3lyFh4P1g@public.gmane.org>
Cc: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

The stable cryptsetup 1.4.0 release is available at

   http://code.google.com/p/cryptsetup/

Feedback and bug reports are welcomed.


Cryptsetup 1.4.0 Release Notes
==============================

Changes since version 1.4.0 RC1

 * Fix verbose messages in isLuks command.
 * Update on-disk format specification document. 

Changes since version 1.3.1

Important changes
~~~~~~~~~~~~~~~~~

WARNING: This release removes old deprecated API from libcryptsetup
         (all functions using struct crypt_options).

         This require libcrypsetup version change and
         rebuild of applications using cryptsetup library.
         All new API symbols are backward compatible.

* If device is not rotational disk, cryptsetup no longer tries
  to wipe keyslot with Gutmann algorithm for magnetic media erase
  but simply rewrites area once by random data.

* The on-disk LUKS header can now be detached (e.g. placed on separate
  device or in file) using new --header option.

  This option is only relevant for LUKS devices and can be used in
  luksFormat, luksOpen, luksSuspend, luksResume and resize commands.

  If used with luksFormat the --align-payload option is taken
  as absolute sector alignment on ciphertext device and can be zero.

  Example:
    Create LUKS device with ciphertext device on /dev/sdb and header
    on device /dev/sdc. Use all space on /dev/sdb (no reserved area for header).

          cryptsetup luksFormat /dev/sdb --header /dev/sdc --align-payload 0

   Activate such device:
          cryptsetup luksOpen /dev/sdb --header /dev/sdc test_disk

   You can use file for LUKS header (loop device will be used while
   manipulating with such detached header), just you have to create
   large enough file in advance.

          dd if=/dev/zero of=/mnt/luks_header bs=1M count=4
          cryptsetup luksFormat /dev/sdb --header /mnt/luks_header --align-payload 0

   Activation is the same as above.

          cryptsetup luksOpen /dev/sdb --header /mnt/luks_header test_disk

   All keyslot operations need to be run on _header_ not on ciphertext device,
   an example:

          cryptsetup luksAddKey /mnt/luks_header

   If you do not use --align-payload 0, you can later restore LUKS header
   on device itself (and use it as normal LUKS device without detached header).

   WARNING: There is no possible check that specified ciphertext device
            matches detached on-disk header. Use with care, it can destroy
            your data in case of a mistake.

   WARNING: Storing LUKS header in a file means that anti-forensic splitter
            cannot properly work (there is filesystem allocation layer between
            header and disk).

* Support --enable-discards option to allow discards/TRIM requests.

   Since kernel 3.1, dm-crypt devices optionally (not by default) support
   block discards (TRIM) comands.
   If you want to enable this operation, you have to enable it manually
   on every activation using --enable-discards

          cryptsetup luksOpen --enable-discards /dev/sdb test_disk

   WARNING: There are several security consequences, please read at least
            http://asalor.blogspot.com/2011/08/trim-dm-crypt-problems.html
            before you enable it.

* Add --shared option for creating non-overlapping crypt segments.

   The --shared options checks that mapped segments are not overlapping
   and allows non-exclusive access to underlying device.
   Only plain crypt devices can be used in this mode.

   Example - map 64M of device disk and following 32 M area as another disk.

     cryptsetup create outer_disk /dev/sdb --offset 0 --size 65536
     cryptsetup create inner_disk /dev/sdb --offset 65536 --size 32768 --shared

 (It can be used to simulate trivial hidden disk concepts.)

libcryptsetup API changes:
  * Added options to suport detached metadata device
     crypt_init_by_name_and_header()
     crypt_set_data_device()
  * Add crypt_last_error() API call.
  * Fix plain crypt format parameters to include size option.
  * Add crypt_get_iv_offset() function.

  * Remove old API functions (all functions using crypt_options).

* Support key-slot option for luksOpen (use only explicit keyslot).

   You can now specify key slot in luksOpen and limit checking
   only to specified slot.

* Support retries and timeout parameters for luksSuspend.
  (The same way as in luksOpen.)

* Add doxygen-like documentation (it will be available on project page later).
  (To generate it manually run doxygen in docs directory.)

Other changes
~~~~~~~~~~~~~
* Fix crypt_load to properly check device size.
* Do not allow context format of already formatted device.
* Do not allow key retrieval while suspended (key could be wiped).
* Do not allow suspend for non-LUKS devices.
* Fix luksKillSLot exit code if slot is inactive or invalid.
* Fix exit code if passphrases do not match in luksAddKey.
* Fix return code for status command when device doesn't exists.
* Support Nettle 2.4 crypto backend (supports ripemd160).
* Add LUKS on-disk format description into package.
* Enhance check of device size before writing LUKS header.
* Add more paranoid checks for LUKS header and keyslot attributes.
* Use new /dev/loop-control (kernel 3.1) if possible.
* Remove hash/hmac restart from crypto backend and make it part of hash/hmac final.
* Improve check for invalid offset and size values.
* Revert default initialisation of volume key in crypt_init_by_name().
* Add more regression tests.
* Add some libcryptsetup example files (see docs/examples).

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk6oVYIACgkQf1Jlc7shgi8GgACfQA/SbQfTftOZe+VvRxJUfh1L
9sQAn3KEByrXgQ71NrJs+Sxei7I3bfbE
=3A0M
-----END PGP SIGNATURE-----
_______________________________________________
dm-crypt mailing list
dm-crypt-4q3lyFh4P1g@public.gmane.org
http://www.saout.de/mailman/listinfo/dm-crypt
