From: Milan Broz <mbroz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [ANNOUNCE] cryptsetup 1.1.2
Date: Sun, 30 May 2010 20:45:23 +0200
Message-ID: <4C02B243.8070404@redhat.com>
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

The stable cryptsetup 1.1.2 release is available at

   http://code.google.com/p/cryptsetup/

Feedback and bug reports are welcomed.

Milan
mbroz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

== Cryptsetup 1.1.2 Release Notes ==

This release fixes a regression (introduced in 1.1.1 version) in handling
key files containing new line characters (affects only files read from
standard input).

Cryptsetup can accept passphrase on stdin (standard input).

Handling of new line (\n) character is defined by input specification:

 * if keyfile is specified as "-" (using --key-file=- of by "-" positional argument
   in luksFormat and luksAddKey, like cat file | cryptsetup --key-file=- <action>),
   input is processed as normal binary file and no new line is interpreted.

 * if there is no key file specification (with default input from stdin pipe
   like echo passphrase | cryptsetup <action>) input is processed as input from terminal,
   reading will stop after new line is detected.

Moreover, luksFormat now understands --key-file (in addition to positional key
file argument).

N.B. Using of standard input and pipes for passphrases should be avoided if possible,
cryptsetup have no control of used pipe buffers between commands in scripts and cannot
guarantee that all passphrase/key-file buffers are properly wiped after use.

=== changes since version 1.1.1 ===

 * Fix luksFormat/luksOpen reading passphrase from stdin and "-" keyfile.
 * Support --key-file/-d option for luksFormat.
 * Fix description of --key-file and add --verbose and --debug options to man page.
 * Add verbose log level and move unlocking message there.
 * Remove device even if underlying device disappeared (remove, luksClose).
 * Fix (deprecated) reload device command to accept new device argument.

For changes in previous version please see Cryptsetup 1.1.1 Release Notes
http://code.google.com/p/cryptsetup/wiki/Cryptsetup111

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwCskMACgkQf1Jlc7shgi8qoACeJ/kHiVoasT7XR/hpfu4I2seA
KKIAn362smF2PNQFyI8OjL1fn0hrdsZy
=hHU3
-----END PGP SIGNATURE-----
_______________________________________________
dm-crypt mailing list
dm-crypt-4q3lyFh4P1g@public.gmane.org
http://www.saout.de/mailman/listinfo/dm-crypt
