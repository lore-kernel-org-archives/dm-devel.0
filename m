From: Lukas Straub <lukasstraub2@web.de>
Subject: Re: [PATCH v2] dm-integrity: Prevent RMW for full metadata buffer
 writes
Date: Thu, 26 Mar 2020 12:24:18 +0100
Message-ID: <20200326122418.741b2ffc@luklap>
References: <20200227142601.61f3cd54@luklap>
        <20200324171821.GA2444@redhat.com>
        <20200324195912.518dc87c@luklap>
        <20200324191148.GA2921@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/rBuFSl4aDuDI2ufSEpF2qcj";
 protocol="application/pgp-signature"; micalg=pgp-sha512
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200324191148.GA2921@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>, dm-devel <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

--Sig_/rBuFSl4aDuDI2ufSEpF2qcj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 24 Mar 2020 15:11:49 -0400
Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Mar 24 2020 at  2:59pm -0400,
> Lukas Straub <lukasstraub2@web.de> wrote:
>=20
> > On Tue, 24 Mar 2020 13:18:22 -0400
> > Mike Snitzer <snitzer@redhat.com> wrote:
> >  =20
> > > On Thu, Feb 27 2020 at  8:26am -0500,
> > > Lukas Straub <lukasstraub2@web.de> wrote:
> > >  =20
> > > > If a full metadata buffer is being written, don't read it first. Th=
is
> > > > prevents a read-modify-write cycle and increases performance on HDDs
> > > > considerably.
> > > >=20
> > > > To do this we now calculate the checksums for all sectors in the bi=
o in one
> > > > go in integrity_metadata and then pass the result to dm_integrity_r=
w_tag,
> > > > which now checks if we overwrite the whole buffer.
> > > >=20
> > > > Benchmarking with a 5400RPM HDD with bitmap mode:
> > > > integritysetup format --no-wipe --batch-mode --interleave-sectors $=
((64*1024)) -t 4 -s 512 -I crc32c -B /dev/sdc
> > > > integritysetup open --buffer-sectors=3D1 -I crc32c -B /dev/sdc hdda=
_integ
> > > > dd if=3D/dev/zero of=3D/dev/mapper/hdda_integ bs=3D64K count=3D$((1=
6*1024*4)) conv=3Dfsync oflag=3Ddirect status=3Dprogress
> > > >=20
> > > > Without patch:
> > > > 4294967296 bytes (4.3 GB, 4.0 GiB) copied, 400.326 s, 10.7 MB/s
> > > >=20
> > > > With patch:
> > > > 4294967296 bytes (4.3 GB, 4.0 GiB) copied, 41.2057 s, 104 MB/s
> > > >=20
> > > > Signed-off-by: Lukas Straub <lukasstraub2@web.de>
> > > > ---
> > > > Hello Everyone,
> > > > So here is v2, now checking if we overwrite a whole metadata buffer=
 instead
> > > > of the (buggy) check if we overwrite a whole tag area before.
> > > > Performance stayed the same (with --buffer-sectors=3D1).
> > > >=20
> > > > The only quirk now is that it advertises a very big optimal io size=
 in the
> > > > standard configuration (where buffer_sectors=3D128). Is this a Prob=
lem?
> > > >=20
> > > > v2:
> > > >  -fix dm_integrity_rw_tag to check if we overwrite a whole metadat =
buffer
> > > >  -fix optimal io size to check if we overwrite a whole metadata buf=
fer
> > > >=20
> > > > Regards,
> > > > Lukas Straub   =20
> > >=20
> > >=20
> > > Not sure why you didn't cc Mikulas but I just checked with him and he
> > > thinks:
> > >=20
> > > You're only seeing a boost because you're using 512-byte sector and
> > > 512-byte buffer. Patch helps that case but hurts in most other cases
> > > (due to small buffers). =20
> >=20
> > Hmm, buffer-sectors is still user configurable. If the user wants fast
> > write performance on slow HDDs he can set a small buffer-sector and
> > benefit from this patch. With the default buffer-sectors=3D128 it
> > shouldn't have any impact. =20
>=20
> OK, if you'd be willing to conduct tests to prove there is no impact
> with larger buffers that'd certainly help reinforce your position and
> make it easier for me to take your patch.
>=20
> But if you're just testing against slow HDD testbeds then the test
> coverage isn't wide enough.
>=20
> Thanks,
> Mike
>=20

Sure,
This time testing with an Samsung 850 EVO SSD:

without patch:

root@teststore:/home/lukas# integritysetup format --no-wipe --batch-mode -I=
 crc32c -B /dev/sdc1
root@teststore:/home/lukas# integritysetup open -I crc32c -B /dev/sdc1 ssda=
_integ
root@teststore:/home/lukas# dd if=3D/dev/zero of=3D/dev/mapper/ssda_integ b=
s=3D64K count=3D$((16*1024*4)) conv=3Dfsync oflag=3Ddirect status=3Dprogress
4177264640 bytes (4.2 GB, 3.9 GiB) copied, 28 s, 149 MB/s
65536+0 records in
65536+0 records out
4294967296 bytes (4.3 GB, 4.0 GiB) copied, 28.8946 s, 149 MB/s
root@teststore:/home/lukas# dd if=3D/dev/zero of=3D/dev/mapper/ssda_integ b=
s=3D4M count=3D$((256*4)) conv=3Dfsync oflag=3Ddirect status=3Dprogress
4211081216 bytes (4.2 GB, 3.9 GiB) copied, 22 s, 191 MB/s
1024+0 records in
1024+0 records out
4294967296 bytes (4.3 GB, 4.0 GiB) copied, 22.6355 s, 190 MB/s
root@teststore:/home/lukas# time mkfs.ext4 /dev/mapper/ssda_integ 4g
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 1048576 4k blocks and 262144 inodes
Filesystem UUID: 679c4808-d549-4576-a8ef-4c46c78c6070
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done


real    0m0.318s
user    0m0.016s
sys     0m0.001s
root@teststore:/home/lukas# mount /dev/mapper/ssda_integ /mnt/
root@teststore:/home/lukas# cd /mnt/
root@teststore:/mnt# time tar -xJf /home/lukas/linux-5.5.4.tar.xz

real    0m18.708s
user    0m14.351s
sys     0m8.585s
root@teststore:/mnt# time rm -rf linux-5.5.4/

real    0m3.226s
user    0m0.117s
sys     0m2.958s


with patch:

root@teststore:/home/lukas# integritysetup format --no-wipe --batch-mode -I=
 crc32c -B /dev/sdc1
root@teststore:/home/lukas# integritysetup open -I crc32c -B /dev/sdc1 ssda=
_integ
root@teststore:/home/lukas# dd if=3D/dev/zero of=3D/dev/mapper/ssda_integ b=
s=3D64K count=3D$((16*1024*4)) conv=3Dfsync oflag=3Ddirect status=3Dprogress
4169007104 bytes (4.2 GB, 3.9 GiB) copied, 27 s, 154 MB/s
65536+0 records in
65536+0 records out
4294967296 bytes (4.3 GB, 4.0 GiB) copied, 27.9165 s, 154 MB/s
root@teststore:/home/lukas# dd if=3D/dev/zero of=3D/dev/mapper/ssda_integ b=
s=3D4M count=3D$((256*4)) conv=3Dfsync oflag=3Ddirect status=3Dprogress
4169138176 bytes (4.2 GB, 3.9 GiB) copied, 22 s, 189 MB/s
1024+0 records in
1024+0 records out
4294967296 bytes (4.3 GB, 4.0 GiB) copied, 22.9181 s, 187 MB/s
root@teststore:/home/lukas# time mkfs.ext4 /dev/mapper/ssda_integ 4g
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 1048576 4k blocks and 262144 inodes
Filesystem UUID: 9a9decad-19e2-46a4-8cc5-ce27238829f2
Superblock backups stored on blocks:=20
        32768, 98304, 163840, 229376, 294912, 819200, 884736

Allocating group tables: done                           =20
Writing inode tables: done                           =20
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done=20


real    0m0.341s
user    0m0.000s
sys     0m0.016s
root@teststore:/home/lukas# mount /dev/mapper/ssda_integ /mnt/
root@teststore:/home/lukas# cd /mnt/
root@teststore:/mnt# time tar -xJf /home/lukas/linux-5.5.4.tar.xz

real    0m18.409s
user    0m14.191s
sys     0m8.585s
root@teststore:/mnt# time rm -rf linux-5.5.4/

real    0m3.200s
user    0m0.133s
sys     0m2.979s


Regards,
Lukas Straub

--Sig_/rBuFSl4aDuDI2ufSEpF2qcj
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEg/qxWKDZuPtyYo+kNasLKJxdslgFAl58kOIACgkQNasLKJxd
sljn2Q//fdRtqln3arcfUfX72NS0AlgI0CCCB7uwcn974EK4BeqEKJeu612dloWE
I9CXr6d47xbsJ0V3rsiPyLilbFWLc4898optf0PqEvI8rQ4ksbY9lEuS0vqkymSR
GeIMEQNbpn5uK+K+zVDGnR5Yg1+XYsfxTwGtwotHmFGMfYBYnCIClEc2gPykMW+Z
9hfaCdpLYAy51yHqawZsIjz7wdPfp5EQB2Mcs4nl4vV9rp24T+Vs8qOaA2E1c1OE
hGpSX9b+Gs0UW5pT6DJyScugqIdkSEvKwGyz1riisrLHnUP3M9akDlVcMUU/Q8o3
xV9N473P7ZYUP3dqcHPUQoeTP4xhzWXM6cQHPVWNHfaTQz7c+gJP6duRw5kT2PVD
1AEuciRZcSqvz6dXoYoY2pCQ/nh7Ry4T2yqi/rVQhity10ZJRKYXWYviwnRP+Kxg
wPfONRya5iMHBKHspO6eVpkS2B6jPd4UHhiDFnj1/Ls66ijo3G4VccdNl0OWpjv6
tSTP3Cl2BrC9NjwzerhFSmU+7K5WReOWeah0eOeiBRV5BDrZ4x8FZA6QqhHjBKlQ
7TXyhRf7KcK06rgB3tRUtG3/P7kQx3KY8H4sLOtlngYgqBYmAstXBa0BG7Md51v0
qI5Y2smMmHI/UBnaPw+xZZTxqHBF4A/jAJLAZZs5krKUuiSTdNQ=
=pSN3
-----END PGP SIGNATURE-----

--Sig_/rBuFSl4aDuDI2ufSEpF2qcj--
