From: Hauke Laging <mailinglisten@hauke-laging.de>
Subject: "create snapshots of any block device"
Date: Tue, 22 Jan 2013 12:12:58 +0100
Message-ID: <1766138.NkjTPulnJa@inno>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7964815174902455645=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--===============7964815174902455645==
Content-Type: multipart/signed; boundary="nextPart2476536.tsRO0aVDiO";
	micalg="pgp-sha256"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable


--nextPart2476536.tsRO0aVDiO
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Hello,

I am a bit surprised to read this:
"Device-mapper allows you, without massive data copying:

*) To create snapshots of any block device [...]"

here:
http://www.kernel.org/doc/Documentation/device-mapper/snapshot.txt

Isn't that at least misleading? Is it really possible to create a snaps=
hot of=20
e.g. /dev/sda5 without creating an *additional* device as snapshot orig=
in?


I export LVs to a VM where they appear as regular disks so that I canno=
t use =20
LVMs snapshot integration. Thus I create a dm device with a linear mapp=
ing to=20
each of these disks and mount the dm device, not the disk.

I just had the idea to create these dm layer devices as snapshot-origin=
s from=20
the start (instead of loading this target when a snapshot is really goi=
ng to=20
be created). Is there anything to be said against this? Is there any re=
ason at=20
all to use linear instead of snapshot-origin for devices with just one =
target=20
(except for possible confusion)?


Hauke
--=20
=E2=98=BA
PGP: 7D82 FB9F D25A 2CE4 5241 6C37 BF4B 8EEF 1A57 1DF5 (seit 2012-11-04=
)
http://www.openpgp-schulungen.de/

--nextPart2476536.tsRO0aVDiO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQFYBAABCABCBQJQ/nQ6OxpodHRwOi8vd3d3LmhhdWtlLWxhZ2luZy5kZS9vcGVu
cGdwL3BvbGljeV9fMHgxYTU3MWRmNS5odG1sAAoJEEhrF6s/lq2OVxYH/RkU1NDh
GPk0LoO68KH+3GZ6LnBCgk8PQccGPDpwXfxcbSMmhW2OKQAWXfp70QvvzLqLdjaF
2WEbim5niBDpZWyHhBcspxr2wiMSNbAtFIQBRQwiYc8oqguPSxjNgrweotXJNKCv
LhfxCiteSw56tzM0A20O4TBe+Q199Z1k0qQP8j+NNXBU/+igXjfsKWT0D7uB3g9V
WGl5E8r3C3n74CgIhtz5EhFOH0xEXZ64tJWRiA3oLVq72YPZAJi8zScEo5n+o8Pm
2XWoYhscwYJP639s/AsA7HuqbiievdrEwgX25AxT8f5ITw6sKh+OJLIwlnDcpAjB
c1s7XyN3CxbSEsI=
=PM8+
-----END PGP SIGNATURE-----

--nextPart2476536.tsRO0aVDiO--


--===============7964815174902455645==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7964815174902455645==--
