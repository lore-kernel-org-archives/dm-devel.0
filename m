From: Hauke Laging <mailinglisten@hauke-laging.de>
Subject: turning the root volume into a snapshot stalls (ioctl
	hangs)
Date: Tue, 8 Nov 2011 12:57:07 +0100
Message-ID: <201111081257.08114.mailinglisten@hauke-laging.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0448879899258979302=="
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============0448879899258979302==
Content-Type: multipart/signed; boundary="nextPart6263352.jUIxjc1mEa";
	protocol="application/pgp-signature"; micalg=pgp-ripemd160
Content-Transfer-Encoding: 7bit

--nextPart6263352.jUIxjc1mEa
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello,

for energy saving purposes I try to buffer disk accesses in RAM by making t=
he=20
mounted (LVM) volume a snapshot and putting the COW device on tmpfs (loop=20
device over a sparse file) so that I can flush the changes later by making =
the=20
volume a snapshot-merge target. Note: I am NOT trying to make a snapshot of=
=20
the root volume! (This has obviously been done sucessfully by others.)

This works for a data volume but the system hangs when trying this with the=
=20
root volume. The interesting point: The problem seems not to be caused by a=
n=20
access to the root filesystem.

I have created a chroot environment in a tmpfs volume (and sucessfully done=
=20
this with a data volume from there). The relevant part of the script (locat=
ed=20
in the chroot environment, of course) is:

dmsetup suspend "$cryptodevice_name" || exit 1
dmsetup load "$cryptodevice_name" --table "0 ${origin_block_count} \
     snapshot-merge ${origin_major_minor} ${cow_major_minor} P 8" || exit 1
dmsetup resume "$cryptodevice_name" || exit 1

The hanging occurs during the "dmsetup load". I hat a look at it by strace.=
=20
This is what happens with the data volume:

[...]
stat("/dev/mapper/control", {st_mode=3DS_IFCHR|0600, st_rdev=3Dmakedev(10, =
236),=20
=2E..}) =3D 0
open("/dev/mapper/control", O_RDWR) =3D 3
open("/proc/devices", O_RDONLY)   =3D 4
fstat(4, {st_mode=3DS_IFREG|0444, st_size=3D0, ...}) =3D 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D=20
0x7f855bec6000
read(4, "Character devices:\n  1 mem\n  4 /"..., 1024) =3D 490
close(4)                          =3D 0
munmap(0x7f855bec6000, 4096)      =3D 0
ioctl(3, DM_VERSION, 0x6162a0)    =3D 0
ioctl(3, DM_TABLE_LOAD, 0x6161f0) =3D 0
close(3)                          =3D 0
exit_group(0)                     =3D ?
[...]

The same call for the root volume leads to
[...]
ioctl(3, DM_TABLE_LOAD, 0x6161f0) =3D
(I am not sure about the 0x6161f0)
The exit code never appears. I do not know whether this is a problem of the=
=20
ioctl or one of strace. But as the volume has already been suspended at tha=
t=20
time I do not see any reason why strace should be affected. The system is n=
ot=20
completely dead but no useful actitivy is possible any more.

Issuing a suspend and a resume immediately afterwards (without the load) do=
es=20
not kill the system. So the problem seems to be about the dmsetup load.

This is openSUSE 11.4.
start cmd:> uname -a
Linux inno 2.6.37.6-0.7-desktop #1 SMP PREEMPT 2011-07-21 02:17:24 +0200=20
x86_64 x86_64 x86_64 GNU/Linux


Best regards,

Hauke
=2D-=20
PGP: D44C 6A5B 71B0 427C CED3 025C BD7D 6D27 ECCB 5814

--nextPart6263352.jUIxjc1mEa
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iQFMBAABAwA2BQJOuRkULxpodHRwOi8vd3d3LmhhdWtlLWxhZ2luZy5kZS9vcGVu
cGdwL3BvbGljeS5odG1sAAoJEFug+LU6QDJR7AcH/RtqM8tAx/ooHebdQUeyCqzv
12t364qF+RedM00pRqQVARKB6BGaMzB3fhwxdgV68ghRX5L5BDdWSTx8sOWKHqqN
WFyDlUzg9PoFvk2/HrnUD0tBurwzH6K2D59AsN3G8UJogDsKkXDNrFLPcu7/2QJW
y9+wRjCqRhHmTwpHhmGB37NzzcMfR4VV4cB4OlQwJUxQMPIxp6s/9MBPfG0ojIO8
zHBZH2qrA/cCuIwDdeOlKY+F84A7irazmyIUDzErtuB5oK4sNXsz+G90HgkHjr6U
OANpTPFQNvzyB3dhf/Wlv7Ov7N0fy5bDUP3K/Or/L6CSZTtxS9U64XtLUIEO2oE=
=vaRT
-----END PGP SIGNATURE-----

--nextPart6263352.jUIxjc1mEa--


--===============0448879899258979302==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0448879899258979302==--
