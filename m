From: Milan Broz <gmazyland-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] cryptsetup 1.4.3
Date: Thu, 31 May 2012 10:38:10 +0200
Message-ID: <4FC72DF2.9070106@gmail.com>
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

The stable cryptsetup 1.4.3 release is available at

   http://code.google.com/p/cryptsetup/

Feedback and bug reports are welcomed.


Cryptsetup 1.4.3 Release Notes
==============================

Changes since version 1.4.2

* Fix readonly activation if underlying device is readonly (1.4.0).

* Fix loop mapping on readonly file.

* Include stddef.h in libdevmapper.h (size_t definition).

* Fix keyslot removal for device with 4k hw block (1.4.0).
(Wipe keyslot failed in this case.)

* Relax --shared flag to allow mapping even for overlapping segments.

  The --shared flag (and API CRYPT_ACTIVATE_SHARED flag) is now able
  to map arbitrary overlapping area. From API it is even usable
  for LUKS devices.
  It is user responsibility to not cause data corruption though.

  This allows e.g. scubed to work again and also allows some
  tricky extensions later.

* Allow empty cipher (cipher_null) for testing.

  You can now use "null" (or directly cipher_null-ecb) in cryptsetup.
  This means no encryption, useful for performance tests
  (measure dm-crypt layer overhead).

* Switch on retry on device remove for libdevmapper.
  Device-mapper now retry removal if device is busy.

* Allow "private" activation (skip some udev global rules) flag.
  Cryptsetup library API now allows to specify CRYPT_ACTIVATE_PRIVATE,
  which means that some udev rules are not processed.
  (Used for temporary devices, like internal keyslot mappings where
  it is not desirable to run any device scans.)

* This release also includes some Red Hat/Fedora specific extensions
related to FIPS140-2 compliance.

In fact, all these patches are more formal changes and are just subset
of building blocks for FIPS certification. See FAQ for more details
about FIPS.

FIPS extensions are enabled by using --enable-fips configure switch.

In FIPS mode (kernel booted with fips=1 and gcrypt in FIPS mode)

  - it provides library and binary integrity verification using
  libfipscheck (requires pre-generated checksums)

  - it uses FIPS approved RNG for encryption key and salt generation
  (note that using /dev/random is not formally FIPS compliant RNG).

 - only gcrypt crypto backend is currently supported in FIPS mode.

The FIPS RNG requirement for salt comes from NIST SP 800-132 recommendation.
(Recommendation for Password-Based Key Derivation. Part 1: Storage Applications.
http://csrc.nist.gov/publications/nistpubs/800-132/nist-sp800-132.pdf)
LUKS should be aligned to this recommendation otherwise.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPxy3yAAoJENmwV3vZPpj8338QAKV7PFpTuW8aIcx2wqM2C9QQ
JWudHWLwPml88YYQt00FhaBQgN6zklElp9TQTGf/6l0tqluDgxc3ALuMi9+jCDb0
yQGpgv1JE3ZhCb0OVpOBhp2p495J5zPVyBdOWEXIq0Go/pREoEbdQ9c5XANaKzF2
oYCpw1QhXIf2z6cUMiTMfN3Ivb4E4KDmaAJpuWLdkqrrdOMrepEneYs4VSH+feQ4
anmikqHqVSzkOQjmZ5cZYcfdMZCQlrJKdOpqwTQCLSzMvMLo3e/bb8J1l7+I1AIu
Rkap0ODlCVX+QsddI1b38GLPVn3wxtme4wC6/gsGRi+uHThtjnCEOFq5wn2mlveN
w6g3+F+sle+YjQsT5S9fgXlOMT4D6MaobTHQppDFa2ajYHsEJKWjX/yRALMBo7zq
pN0sVHUT/dEj06RoPTEnObJmL/y3wY+ibE19+PdmBewYPr1uhwLlA/vCwnLiItxr
GnRgXxex+rhJjrtCoJRrYNLeA6fFldrIovaoiHRft9bvJv9q3QYNgKLDJdCegUUT
9OO/HlzkB7Vsds4xtgRgHXJNP9dZqOd9ccX4a2bAUj45n8FJ9F/u/n9G5uS7X6c8
tOQCUmB+MS+WIINmSCP7wI3sDYfBaW4w0KxZvDyGQca6dddQPWabVARwKPG3q4Mi
eoxGYC+mPiCL0kENLY4M
=hmEH
-----END PGP SIGNATURE-----
_______________________________________________
dm-crypt mailing list
dm-crypt-4q3lyFh4P1g@public.gmane.org
http://www.saout.de/mailman/listinfo/dm-crypt
