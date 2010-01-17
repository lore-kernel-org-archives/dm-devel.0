From: Milan Broz <mbroz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [ANNOUNCE] cryptsetup 1.1.0
Date: Sun, 17 Jan 2010 16:22:36 +0100
Message-ID: <4B532B3C.6030705@redhat.com>
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


The stable cryptsetup 1.1.0 release is available at

   http://code.google.com/p/cryptsetup/

Feedback and bug reports are welcomed.

Milan
mbroz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org


Cryptsetup 1.1.0 Release Notes
==============================

Changes since version 1.0.7
- ---------------------------

Important changes:
~~~~~~~~~~~~~~~~~~

 * IMPORTANT: the default compiled-in cipher parameters changed
	plain mode: aes-cbc-essiv:sha256 (default is backward incompatible!).
	LUKS mode: aes-cbc-essiv:sha256 (only key size increased)
	In both modes is now default key size 256bits.

	 * Default compiled-in parameters are now configurable through configure options:
	   --with-plain-* / --with-luks1-* (see configure --help)

	 * If you need backward compatible defaults for distribution use
	   configure --with-plain-mode=cbc-plain --with-luks1-keybits=128

	 Default compiled-in modes are printed in "cryptsetup --help" output.

 * Change in iterations count (LUKS):
	The slot and key digest iteration minimum count is now 1000.
	The key digest iteration count is calculated from iteration time (approx 1/8 of req. time).
	For more info about above items see discussion here: http://tinyurl.com/yaug97y

 * New libcryptsetup API (documented in libcryptsetup.h).

	The old API (using crypt_options struct) is still available but will remain
	frozen and not used for new functions.
	Soname of library changed to libcryptsetup.so.1.0.0.
	(But only recompilation should be needed for old programs.)

	The new API provides much more flexible operation over LUKS device for
	applications, it is preferred that new applications will use libcryptsetup
	and not wrapper around cryptsetup binary.

 * New luksHeaderBackup and luksHeaderRestore commands.

	These commands allows binary backup of LUKS header.
	Please read man page about possible security issues with backup files.

 * New luksSuspend (freeze device and wipe key) and luksResume (with provided passphrase).

	luksSuspend wipe encryption key in kernel memory and set device to suspend
	(blocking all IO) state. This option can be used for situations when you need
	temporary wipe encryption key (like suspend to RAM etc.)
	Please read man page for more information.

 * New --master-key-file option for luksFormat and luksAddKey.

	User can now specify pre-generated master key in file, which allows regenerating
	LUKS header or add key with only master key knowledge.

 * Uses libgcrypt and enables all gcrypt hash algorithms for LUKS through -h luksFormat option.

	Please note that using different hash for LUKS header make device incompatible with
	old cryptsetup releases.

 * Introduces --debug parameter.

	Use when reporting bugs (just run cryptsetup with --debug and attach output
	to issue report.) Sensitive data are never printed to this log.

 * Moves command successful messages to verbose level.

 * Requires device-mapper library and libgcrypt to build.

 * Uses dm-uuid for all crypt devices, contains device type and name now.

 * Removes support for dangerous non-exclusive option
	(it is ignored now, LUKS device must be always opened exclusive)

Other changes:
~~~~~~~~~~~~~~
 * Fixed localization to work again. Also cryptsetup is now translated by translationproject.org.
 * Fix some libcryptsetup problems, including
    * exported symbols and versions in libcryptsetup (properly use versioned symbols)
    * Add crypt_log library function.
    * Add CRYPT_ prefix to enum defined in libcryptsetup.h.
 * Move duplicate Command failed message to verbose level (error is printed always).
 * Fix several problems in build system
    * use autopoint and clean gettext processing.
    * Check in configure if selinux libraries are required in static version.
    * Fix build for non-standard location of gcrypt library.
 * Add temporary debug code to find processes locking internal device.
 * Fix error handling during reading passphrase.
 * Fail passphrase read if piped input no longer exists.
 * Fix man page to not require --size which expands to device size by default.
 * Clean up Makefiles and configure script.
 * Try to read first sector from device to properly check that device is ready.
 * Move memory locking and dm initialization to command layer.
 * Increase priority of process if memory is locked.
 * Add log macros and make logging more consistent.
 * Keyfile now must be provided by path, only stdin file descriptor is used (api only).
 * Do not call isatty() on closed keyfile descriptor.
 * Move key slot manipulation function into LUKS specific code.
 * Replace global options struct with separate parameters in helper functions.
 * Implement old API calls using new functions.
 * Allow using passphrase provided in options struct for LuksOpen.
 * Allow restrict keys size in LuksOpen.
 * Fix errors when compiled with LUKS_DEBUG.
 * Print error when getline fails.
 * Completely remove internal SHA1 implementation code, not needed anymore.
 * Pad luks header to 512 sector size.
 * Rework read/write blockwise to not split operation to many pieces.
 * Use posix_memalign if available.
 * Fix segfault if provided slot in luksKillslot is invalid.
 * Remove unneeded timeout when remove of temporary device succeeded.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktTKzwACgkQf1Jlc7shgi9hlACcCgTgI9aGwdfSzOT5dlHFfCXJ
IQYAn1RDFWBZPPkdu2WSV+jbeK0MzwG/
=h9ny
-----END PGP SIGNATURE-----
_______________________________________________
dm-crypt mailing list
dm-crypt-4q3lyFh4P1g@public.gmane.org
http://www.saout.de/mailman/listinfo/dm-crypt
