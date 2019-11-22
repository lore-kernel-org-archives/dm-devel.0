From: Erich Eckner <device-mapper@eckner.net>
Subject: ignore/update integrity checksums
Date: Fri, 22 Nov 2019 10:07:14 +0100 (CET)
Message-ID: <alpine.LNX.2.21.99999.375.1911221006490.1609868@nlopc43.ioq.uni-jena.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: quoted-printable
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

cryptsetup luksFormat /dev/sde --key-file /mnt/key/key --integrity hmac-sha=
256

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


Recently, I rebooted this box and apparently, I missed to cleanly sync the=
=20
disks, so they now report integrity errors, when mdadm probes (during=20
assemble) for the raid superblock:

device-mapper: crypt: dm-1: INTEGRITY AEAD ERROR, sector 11031354368

There was no write activity on the raid before the reboot except for a=20
running

mdadm /dev/md0 --replace /dev/dm-0 --with /dev/dm-1

which of course might have written a lot to all superblocks.

Since I believe, the superblocks should be mostly in-sync (except for=20
event-counters?): Is there a way to ignore or re-calculate the integrity=20
checks?

Also: What is the correct way to assure, that data has been synced to the=
=20
disk(s) before switching off power? (If that matters, there is a=20
raid-controller underneath: "06:00.0 RAID bus controller: Hewlett-Packard=
=20
Company Smart Array G6 controllers (rev 01)" - but it
does not actually handle the raid, it only feeds the disks through to the=
=20
os) I can execute any command after closing the luks-integrity device, my=
=20
question aims at: what should I execute?

regards,
Erich


-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE3p92iMrPBP64GmxZCu7JB1Xae1oFAl3XpUQACgkQCu7JB1Xa
e1ry/hAAsWBT+D4UgVEbLNQj8s2cpFP8z4iTfT2vTG9UeEilxjpxrU5tPcRGKANv
qewyTwC5JrH6Mst3AE6P+ToSUWisMOcUXSg663dh4q8lmJjL/IdBrTU6cMqrFJV/
QXx3crf3j6soZ9AXSQgGRJm0wIV24WKg5vgTTDug56TR0ifUK+KJrWsqtforhtYu
hynMYlMHOcYUX4aPRHL6M56K9dSt92/9i5oRcm+jmKKSnTceJHduSD4RPMs93Lb9
JYIef1Qg+0wZqPZr1JD5AR+IU4J4dvysiqP9H3XYNIZaGYo2dGI6q6+6ksuGDxDu
sCeMFNlOdftptC8HlVUm29sERNEXqN+cWZ5X9OdEPKPuY+fQtF4vugy9rRcw+Q41
FHLGs5Aip/jGbXxh0vtOflcpZF4O4j4mu5r0KWEh1YgMIOb+JeWueGamSCdvb0yP
p/ZwfCM0a3sncOw5YRIIS6YXshCl57xzgRv326Z199Y9uROAd0pGvW2B91pKS2QM
W++AaEozRAT5X/5PSSJpw9bx2iprS6YwkygCeFuIswcrMfvbaiwBdXeIVvPZRJjO
lTVMnxWIqt3zkDWaZdwJzQCFycLtlGGXlei4Y3TCBfwRRGBWj6iLRY6t7SlKX9ST
7KHoha1dp2EheKJV6eZXo0mxrF7bt6gcPeVpPZIKKGJG5XkgHMA=3D
=3DVedA
-----END PGP SIGNATURE-----
