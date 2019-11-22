From: Erich Eckner <device-mapper@eckner.net>
Subject: ignore/update integrity checksums
Date: Fri, 22 Nov 2019 09:54:13 +0100 (CET)
Message-ID: <alpine.LNX.2.21.99999.375.1911220937550.2770450@nlopc43.ioq.uni-jena.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Hi,

I have multiple disks with LUKS+integrity created by

cryptsetup luksFormat /dev/sde --key-file /mnt/key/key --integrity hmac-sha256

which are part of a raid6. Details of the device:

/dev/mapper/leg0 is active.
   type:    LUKS2
   cipher:  aes-xts-plain64
   keysize: 768 bits
   key location: keyring
   integrity: hmac(sha256)
   integrity keysize: 256 bits
   device:  /dev/sdb
   sector size:  512
   offset:  0 sectors
   size:    11031354576 sectors
   mode:    read/write


Recently, I rebooted this box and apparently, I missed to cleanly sync the 
disks, so they now report integrity errors, when mdadm probes (during 
assemble) for the raid superblock:

device-mapper: crypt: dm-1: INTEGRITY AEAD ERROR, sector 11031354368

There was no write activity on the raid before the reboot except for a 
running

mdadm /dev/md0 --replace /dev/dm-0 --with /dev/dm-1

which of course might have written a lot to all superblocks.

Since I believe, the superblocks should be mostly in-sync (except for 
event-counters?): Is there a way to ignore or re-calculate the integrity 
checks?

Also: What is the correct way to assure, that data has been synced to the 
disk(s) before switching off power? (If that matters, there is a 
raid-controller underneath: "06:00.0 RAID bus controller: Hewlett-Packard 
Company Smart Array G6 controllers (rev 01)" - but it does not actually 
handle the raid, it only feeds the disks through to the os) I can execute 
any command after closing the luks-integrity device, my question aims at: 
what should I execute?

regards,
Erich

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE3p92iMrPBP64GmxZCu7JB1Xae1oFAl3XojcACgkQCu7JB1Xa
e1q17g//TCKyH5US3c5j+FHH/90gsAoW8LuMzeIV3KnswtJm1fA/lWhbJMbKG/8r
eo1P48wOKLRTNT5RJV+M3+we/80la/x6PGl2IM/WXTGT8TAdOISKksifzJ7/wXhd
UxIjzhenc2mFnpYjrMABY3BYGvJf7AkrmrmliGe/BO9sMKej6R1WlE17ZOD+sGFN
/FWLPtgcBcfVFNk+tn2aUa6oovLxpzzhYUcktuqpI0WQOOydQwRsb3sIM0bYHpNZ
99ieIHyIDY7p0V/Ym0Msm/ic1PIzsPtWl6MiRmzjXf8v0UVVFKb23kuPxXHKEBLV
5u/DOzbrBpT+w5hI8eUk5me/qUPWEnrY/4AodZEJxwOpbeqOEbLPa15cPxwT5s3b
+45mpf0raREAI4WANNym5FmAxVukaQKaEGJ7Q8AyVJtN76oGaPNhxEQ4BDxQXOsV
RituTR17MULV80jpVS2atwRNkged9H6aRaDtcmrkx2qyaAHSLghXTLySID9XumbW
pkH45nWvsU1z8t8Lvxy81CrMnB8cmy6Iud3yH1WVKvCnjqmbSZQ4FMXw0fiAas+C
Q1ipkMdKg2mgLUQCRgwWpbvtVR14kZnQjZoPAhOTzbGaYTRbaEPkOMoKqCRStUkb
3l+Hg+AGeP9CR19sFYoR2HSnJGdeK/kYUEBuNfHrOjop2yi+lZY=
=aG59
-----END PGP SIGNATURE-----
