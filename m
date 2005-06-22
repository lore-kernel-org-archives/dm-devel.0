From: =?UTF-8?B?RGF2aWQgVmlkYWwgUm9kcsOtZ3Vleg==?= <vidalrod@in.tum.de>
Subject: Access beyond end of device with LVM2 over sw RAID1
Date: Wed, 22 Jun 2005 19:35:09 +0200
Message-ID: <42B9A14D.7090402@in.tum.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello everyone,

I am new to this list, looking for an explanation of a problem which has
been there for a relatively long time. I've found nothing similar in the
mailing list archive, hence this mail.

Discs configuration: 2 S-ATA HDs configured as a RAID-1 mirror, on top
of which an LVM2 volume group (VG) sits. Different logical volumes (LVs)
are defined there, one of which (/home) has a snapshot. Everything is
managed with IBM's EVMS tool set, so I'm using EVMS volumes on top of
each LV.

While running kernel 2.6.10, everything is allright. But when I use one
of the 2.6.11.* or 2.6.12-* kernels, reading files on /home leads to
innumerable I/O errors, and the kernel complains about trying to access
beyond the end of the dm device. Note that I'm reading the original
volume, not the snapshot. Volumes without a snapshot don't show this
behavior. In fact, although the root filesystem is also an EVMS volume
on top of an LV, the system boots normally.

The problem goes away if I either downgrade to 2.6.10 or remove the
snapshot.

Is this a known problem, and if not, should I give more informations?

Thank you in advance,
David VIDAL RODRIGUEZ
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFCuaFMK3CyMA5SxrwRAl07AJ9F70wnthgxrQOTea0JY5s2COS2LQCfXn5B
pXH2c3k5ubU1BEUMrP08KBQ=
=RpQ2
-----END PGP SIGNATURE-----
