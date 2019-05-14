From: Erich Eckner <device-mapper@eckner.net>
Subject: add identifying information in INTEGRITY AEAD ERROR
	message
Date: Tue, 14 May 2019 11:48:46 +0200 (CEST)
Message-ID: <alpine.LNX.2.21.9999.1905141138180.19368@nlopc43.ioq.uni-jena.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="596483122-1015369343-1557827332=:19368"
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--596483122-1015369343-1557827332=:19368
Content-Type: text/plain; format=flowed; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Hi,

I have a bunch of dm integrity devices tied together to an md raid. Now I 
see the following error message in dmesg:

device-mapper: crypt: INTEGRITY AEAD ERROR, sector 1109341168

repeated a couple of times every few seconds in a row with differing 
sector numbers. There are no other errors in dmesg next to these. As I 
understand, this means, one of the drives deliveres garbage to the 
integrity device which hence issues a read error. (There is an e2fsck 
running on the raid which generates a lot of disk i/o.) That's good - it's 
exactly what I intended this integrity thing for.

My problem now is, that I would like to find out which of my 10 drives is 
the bad one. Is there any way to get some identifying information (a uuid, 
the name of the device in /dev/mapper/, ...)?

ah, the usual statistics:
> uname -a
Linux fileserver 5.1.0 #56 SMP Tue May 7 06:24:43 CEST 2019 x86_64 
Intel(R) Pentium(R) CPU G2020 @ 2.90GHz GenuineIntel GNU/Linux
> zgrep INTEGRITY /proc/config.gz
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_DM_INTEGRITY=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
CONFIG_INTEGRITY_AUDIT=y

The kernel is manually compiled - I'm happy to activate any options you 
deem necessary.

regards,
Erich Eckner
Friedrich-Schiller-Universität Jena
Institut für Optik und Quantenelektronik
Helmholtzweg 4
07743 Jena

Tel. +49 3641 9-47238

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE3p92iMrPBP64GmxZCu7JB1Xae1oFAlzajwAACgkQCu7JB1Xa
e1rQ2g/9HVoQcSwhKxLW6w7wy8rgUlHBt/DbWxeHM6KTkss5yxrVNUkv1TGXop9l
krDMKvhpNxI29IrhvSgqSbtJw0sk9iJU0urFsrs09TK6ATvcUtO5X8CLnPULqBqC
YnnygcBgVt16FgoaAMVSyx2qEGrO5DXzquqLlJAa2z0+ZZGWa/5Nrhm3nfbHBbQQ
pjiNpk+iNVbGIhe8+tR+vOZfJaghrA3B9W7FyYARlfB1Gy4S/DM5im2HTw/2ESJp
nkSprpxiq5WyN56tFKnCrZSwe2Ga4NCNP6h8Gz7ynKlpbziXMey8BP3Puvfh7UNa
Blcz648/3RwqfKkGqrY2mypo6DyiWribHr0A8Uza/RWVERbg0U9o1DdZ6DKbbnSm
MKfAuSKBE2WErHrfwNN7WGOK/xlonkR8oADcaLI8db1Xu4Stj1HqA5lB9aT+K9KP
kJFnc1254qJ+LvQHJfPTsW8sKgqwIfccNONltta/BCJCgcDl79y0VL9WX/dJS6Pu
xqSSejPJ7Fp+gpR+FZbllWn+rCGF+JY6dku5oObp5uZOlfwQg8+zAhf4TQLYJmn0
dzgaqonpzzmEGHUw31/R2Km0aHtuEsTCW986Gx9taWY84JyQDRSXjAXHsxJCMtN3
rpMbDemoSRz6/WnI48VauN2obeUS3dmQraV+MNPpGiJmt86XM0o=
=YfBa
-----END PGP SIGNATURE-----
--596483122-1015369343-1557827332=:19368
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--596483122-1015369343-1557827332=:19368--
