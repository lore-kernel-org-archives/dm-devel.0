Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFFF158DCA
	for <dm-devel@lists.linux.dev>; Mon, 19 Aug 2024 21:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.24.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724101548; cv=none; b=G27sdvJBKxcw2XC1ocOV0cOIaid/15U+Y8Mb3lTJDUThuMdOeLYFgvLPLrc/z9roiL1thUncToDKYp14nDuTzm9aDrpq6T/TNCHQYuWxRmMF89G+pd5kef0O5XuSku7PX5cvRr0nAPgftebpvtpLyl9kmT+JvZNKvhirtMKIOcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724101548; c=relaxed/simple;
	bh=E5h5/Icg8iR4AwzpTRU2XA+J+5bppgdxspOwa3UZWJI=;
	h=MIME-Version:Content-Type:Message-ID:Date:From:To:Cc:Subject:
	 In-Reply-To:References; b=pB0AZqIT1dN7kqXE6CIj9/REkcre2EDKyqdUFSmhDJJQp3/pkWJFOEuAnBWhvWd/V1dCMSkFQgBrPlJkDKd7kY9pFMx7OK5FJx0jkr8p6gItU3MBj0R/8Kp9jKQdXOBcmKxYgjxPBNEg1s2xhLoo/EX+rzi+7W1qh0E9rQNdhfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org; spf=pass smtp.mailfrom=stoffel.org; arc=none smtp.client-ip=172.104.24.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stoffel.org
Received: from quad.stoffel.org (syn-097-095-183-072.res.spectrum.com [97.95.183.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id 0FCB91E121;
	Mon, 19 Aug 2024 17:05:29 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id A87C0A090A; Mon, 19 Aug 2024 17:05:23 -0400 (EDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Message-ID: <26307.45971.357185.491868@quad.stoffel.home>
Date: Mon, 19 Aug 2024 17:05:23 -0400
From: "John Stoffel" <john@stoffel.org>
To: tihmstar <tihmstar@gmail.com>
Cc: John Stoffel <john@stoffel.org>,
    Christian Theune <ct@flyingcircus.io>,
    Yu Kuai <yukuai1@huaweicloud.com>,
    "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
    dm-devel@lists.linux.dev,
    "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
In-Reply-To: <595DE483-7F2D-4B27-9645-AC51E8B90D0C@gmail.com>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
	<316050c6-fac2-b022-6350-eaedcc7d953a@huaweicloud.com>
	<58450ED6-EBC3-4770-9C5C-01ABB29468D6@flyingcircus.io>
	<EACD5B78-93F6-443C-BB5A-19C9174A1C5C@flyingcircus.io>
	<22C5E55F-9C50-4DB7-B656-08BEC238C8A7@flyingcircus.io>
	<26291.57727.410499.243125@quad.stoffel.home>
	<2EE0A3CE-CFF2-460C-97CD-262D686BFA8C@flyingcircus.io>
	<26292.54499.173087.840312@quad.stoffel.home>
	<595DE483-7F2D-4B27-9645-AC51E8B90D0C@gmail.com>
X-Mailer: VM 8.3.x under 28.2 (x86_64-pc-linux-gnu)

>>>>> "tihmstar" =3D=3D tihmstar  <tihmstar@gmail.com> writes:

> Hi,

> i think i have the same problem (looks very similar at least).  I
> updated my kernel yesterday, but before that (a few minor versions
> earlier) i'm pretty sure i've seen a very similar stacktrace with
> "md_bitmap_startwrite".

This almost smells like an MD RAID5/6 bitmap problem, have you tried
the patch that was posted in the thread to turn off bitmaps? =20

> The setup seems to be similar, with some slight differences.

> I'm also running a linux RAID6 with LUKS, however i'm running it on S=
ATA HDD, not NVME.

Shouldn't be a difference, except in terms of speed I would think.

> Also i have the LUKS layer on each hdd individually, then the RAID6
is build ontop of the /dev/ma pper/-devices of those hdds.

Interesting.  Why this way?  It would seem you now have to enter N
passwords on bootup, instead of just one. =20

> I.e. i have LUKS below the RAID, while Christian has it on top of the=
 RAID.

> Directly on the raid i have btrfs (as "single disk", raid is handled
> by linux-raid).

Goot, btrfs RAID6 is known to have problems in a big way.=20

> The "trigger" is similar too, i have one large NAS with 100TB data, w=
hich i'm trying to migrate to my new NAS.
> "rclone copy --links --local-zero-size-links -P --transfers=3D16 --sf=
tp-ask-password ....."

> After running that for ~30hours (10GB network link), IO on the new NA=
S is completely stuck.

> I attached a few files with info about my setup, which i think might =
be useful.
> I'm happy to help debugging, but i too have data on the new NAS, so r=
ebuilding the RAID isn't an option for me either.

> Cheers
> tihmstar

> PS: second try sending this (never used mailing lists before)

> [root@coldnas ~]# dmesg=20
> [56065.390298] md/raid:md127: read error corrected (8 sectors at 8952=
913016 on dm-1)
> [56068.949917] ata25.00: exception Emask 0x0 SAct 0x79ffffe1 SErr 0x0=
 action 0x0
> [56068.957061] ata25.00: irq_stat 0x40000008
> [56068.961099] ata25.00: failed command: READ FPDMA QUEUED
> [56068.966335] ata25.00: cmd 60/40:d8:00:9d:a5/05:00:15:02:00/40 tag =
27 ncq dma 688128 in
>                         res 43/40:40:c0:9d:a5/00:05:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56068.982442] ata25.00: status: { DRDY SENSE ERR }
> [56068.987078] ata25.00: error: { UNC }
> [56069.083162] ata25.00: configured for UDMA/133
> [56069.083228] sd 24:0:0:0: [sdc] tag#27 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56069.083232] sd 24:0:0:0: [sdc] tag#27 Sense Key : Medium Error [cu=
rrent]=20
> [56069.083234] sd 24:0:0:0: [sdc] tag#27 Add. Sense: Unrecovered read=
 error
> [56069.083236] sd 24:0:0:0: [sdc] tag#27 CDB: Read(16) 88 00 00 00 00=
 02 15 a5 9d 00 00 00 05 40 00 00
> [56069.083238] critical medium error, dev sdc, sector 8953109760 op 0=
x0:(READ) flags 0x84700 phys_seg 168 prio class 0
> [56069.093669] ata25: EH complete
> [56071.267547] ata25.00: exception Emask 0x0 SAct 0xffffffff SErr 0x0=
 action 0x0
> [56071.274689] ata25.00: irq_stat 0x40000008
> [56071.278714] ata25.00: failed command: READ FPDMA QUEUED
> [56071.283952] ata25.00: cmd 60/c0:80:48:aa:a5/02:00:15:02:00/40 tag =
16 ncq dma 360448 in
>                         res 43/40:c0:b0:ab:a5/00:02:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56071.300082] ata25.00: status: { DRDY SENSE ERR }
> [56071.304712] ata25.00: error: { UNC }
> [56071.390681] ata25.00: configured for UDMA/133
> [56071.390724] sd 24:0:0:0: [sdc] tag#16 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D4s
> [56071.390726] sd 24:0:0:0: [sdc] tag#16 Sense Key : Medium Error [cu=
rrent]=20
> [56071.390728] sd 24:0:0:0: [sdc] tag#16 Add. Sense: Unrecovered read=
 error
> [56071.390729] sd 24:0:0:0: [sdc] tag#16 CDB: Read(16) 88 00 00 00 00=
 02 15 a5 aa 48 00 00 02 c0 00 00
> [56071.390731] critical medium error, dev sdc, sector 8953113160 op 0=
x0:(READ) flags 0x84700 phys_seg 88 prio class 0
> [56071.401093] ata25: EH complete
> [56073.426604] ata25.00: exception Emask 0x0 SAct 0x1000 SErr 0x0 act=
ion 0x0
> [56073.433402] ata25.00: irq_stat 0x40000008
> [56073.437466] ata25.00: failed command: READ FPDMA QUEUED
> [56073.442727] ata25.00: cmd 60/08:60:a8:b9:a5/00:00:15:02:00/40 tag =
12 ncq dma 4096 in
>                         res 43/40:08:a8:b9:a5/00:00:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56073.458694] ata25.00: status: { DRDY SENSE ERR }
> [56073.463326] ata25.00: error: { UNC }
> [56073.564919] ata25.00: configured for UDMA/133
> [56073.564929] sd 24:0:0:0: [sdc] tag#12 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56073.564933] sd 24:0:0:0: [sdc] tag#12 Sense Key : Medium Error [cu=
rrent]=20
> [56073.564935] sd 24:0:0:0: [sdc] tag#12 Add. Sense: Unrecovered read=
 error
> [56073.564937] sd 24:0:0:0: [sdc] tag#12 CDB: Read(16) 88 00 00 00 00=
 02 15 a5 b9 a8 00 00 00 08 00 00
> [56073.564939] critical medium error, dev sdc, sector 8953117096 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56073.575101] ata25: EH complete
> [56074.052895] md/raid:md127: read error corrected (8 sectors at 8953=
082280 on dm-1)
> [56077.233232] ata25.00: exception Emask 0x0 SAct 0x83f7ff02 SErr 0x0=
 action 0x0
> [56077.240378] ata25.00: irq_stat 0x40000008
> [56077.244411] ata25.00: failed command: READ FPDMA QUEUED
> [56077.249645] ata25.00: cmd 60/40:88:00:d5:a5/05:00:15:02:00/40 tag =
17 ncq dma 688128 in
>                         res 43/40:40:40:d5:a5/00:05:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56077.265768] ata25.00: status: { DRDY SENSE ERR }
> [56077.270401] ata25.00: error: { UNC }
> [56077.371947] ata25.00: configured for UDMA/133
> [56077.371989] sd 24:0:0:0: [sdc] tag#17 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56077.371992] sd 24:0:0:0: [sdc] tag#17 Sense Key : Medium Error [cu=
rrent]=20
> [56077.371994] sd 24:0:0:0: [sdc] tag#17 Add. Sense: Unrecovered read=
 error
> [56077.371995] sd 24:0:0:0: [sdc] tag#17 CDB: Read(16) 88 00 00 00 00=
 02 15 a5 d5 00 00 00 05 40 00 00
> [56077.371997] critical medium error, dev sdc, sector 8953124096 op 0=
x0:(READ) flags 0x84700 phys_seg 168 prio class 0
> [56077.382450] ata25: EH complete
> [56079.490942] ata25.00: exception Emask 0x0 SAct 0xffffffff SErr 0x0=
 action 0x0
> [56079.498082] ata25.00: irq_stat 0x40000008
> [56079.502109] ata25.00: failed command: READ FPDMA QUEUED
> [56079.507345] ata25.00: cmd 60/c0:80:40:e2:a5/02:00:15:02:00/40 tag =
16 ncq dma 360448 in
>                         res 43/40:c0:40:e3:a5/00:02:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56079.523453] ata25.00: status: { DRDY SENSE ERR }
> [56079.528103] ata25.00: error: { UNC }
> [56079.637795] ata25.00: configured for UDMA/133
> [56079.637949] sd 24:0:0:0: [sdc] tag#16 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D4s
> [56079.637952] sd 24:0:0:0: [sdc] tag#16 Sense Key : Medium Error [cu=
rrent]=20
> [56079.637955] sd 24:0:0:0: [sdc] tag#16 Add. Sense: Unrecovered read=
 error
> [56079.637957] sd 24:0:0:0: [sdc] tag#16 CDB: Read(16) 88 00 00 00 00=
 02 15 a5 e2 40 00 00 02 c0 00 00
> [56079.637959] critical medium error, dev sdc, sector 8953127488 op 0=
x0:(READ) flags 0x80700 phys_seg 88 prio class 0
> [56079.648339] ata25: EH complete
> [56084.636191] ata25.00: exception Emask 0x0 SAct 0x3fde1800 SErr 0x0=
 action 0x0
> [56084.643341] ata25.00: irq_stat 0x40000008
> [56084.647380] ata25.00: failed command: READ FPDMA QUEUED
> [56084.652610] ata25.00: cmd 60/08:88:c8:ab:a5/00:00:15:02:00/40 tag =
17 ncq dma 4096 in
>                         res 43/40:08:c8:ab:a5/00:00:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56084.668561] ata25.00: status: { DRDY SENSE ERR }
> [56084.673189] ata25.00: error: { UNC }
> [56084.760994] ata25.00: configured for UDMA/133
> [56084.761009] sd 24:0:0:0: [sdc] tag#17 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D4s
> [56084.761012] sd 24:0:0:0: [sdc] tag#17 Sense Key : Medium Error [cu=
rrent]=20
> [56084.761013] sd 24:0:0:0: [sdc] tag#17 Add. Sense: Unrecovered read=
 error
> [56084.761015] sd 24:0:0:0: [sdc] tag#17 CDB: Read(16) 88 00 00 00 00=
 02 15 a5 ab c8 00 00 00 08 00 00
> [56084.761016] critical medium error, dev sdc, sector 8953113544 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56084.771196] ata25: EH complete
> [56087.035282] ata25.00: exception Emask 0x0 SAct 0x1ffc SErr 0x0 act=
ion 0x0
> [56087.042074] ata25.00: irq_stat 0x40000008
> [56087.046100] ata25.00: failed command: READ FPDMA QUEUED
> [56087.051341] ata25.00: cmd 60/08:10:d0:ab:a5/00:00:15:02:00/40 tag =
2 ncq dma 4096 in
>                         res 43/40:08:d0:ab:a5/00:00:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56087.067187] ata25.00: status: { DRDY SENSE ERR }
> [56087.071879] ata25.00: error: { UNC }
> [56087.168480] ata25.00: configured for UDMA/133
> [56087.168495] sd 24:0:0:0: [sdc] tag#2 FAILED Result: hostbyte=3DDID=
_OK driverbyte=3DDRIVER_OK cmd_age=3D6s
> [56087.168498] sd 24:0:0:0: [sdc] tag#2 Sense Key : Medium Error [cur=
rent]=20
> [56087.168501] sd 24:0:0:0: [sdc] tag#2 Add. Sense: Unrecovered read =
error
> [56087.168503] sd 24:0:0:0: [sdc] tag#2 CDB: Read(16) 88 00 00 00 00 =
02 15 a5 ab d0 00 00 00 08 00 00
> [56087.168504] critical medium error, dev sdc, sector 8953113552 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56087.178680] ata25: EH complete
> [56087.435439] md/raid:md127: read error corrected (8 sectors at 8953=
078736 on dm-1)
> [56087.435437] md/raid:md127: read error corrected (8 sectors at 8953=
078728 on dm-1)
> [56090.450888] ata25.00: exception Emask 0x0 SAct 0x701f9ff SErr 0x0 =
action 0x0
> [56090.457937] ata25.00: irq_stat 0x40000008
> [56090.461967] ata25.00: failed command: READ FPDMA QUEUED
> [56090.467243] ata25.00: cmd 60/08:00:40:e3:a5/00:00:15:02:00/40 tag =
0 ncq dma 4096 in
>                         res 43/40:08:40:e3:a5/00:00:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56090.483104] ata25.00: status: { DRDY SENSE ERR }
> [56090.487736] ata25.00: error: { UNC }
> [56090.708972] ata25.00: configured for UDMA/133
> [56090.708989] sd 24:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=3DDID=
_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56090.708992] sd 24:0:0:0: [sdc] tag#0 Sense Key : Medium Error [cur=
rent]=20
> [56090.708994] sd 24:0:0:0: [sdc] tag#0 Add. Sense: Unrecovered read =
error
> [56090.708997] sd 24:0:0:0: [sdc] tag#0 CDB: Read(16) 88 00 00 00 00 =
02 15 a5 e3 40 00 00 00 08 00 00
> [56090.708998] critical medium error, dev sdc, sector 8953127744 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56090.719219] ata25: EH complete
> [56094.801196] ata25.00: exception Emask 0x0 SAct 0x3ff0 SErr 0x0 act=
ion 0x0
> [56094.808023] ata25.00: irq_stat 0x40000008
> [56094.812070] ata25.00: failed command: READ FPDMA QUEUED
> [56094.817310] ata25.00: cmd 60/08:20:40:d5:a5/00:00:15:02:00/40 tag =
4 ncq dma 4096 in
>                         res 43/40:08:40:d5:a5/00:00:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56094.833164] ata25.00: status: { DRDY SENSE ERR }
> [56094.837814] ata25.00: error: { UNC }
> [56094.940782] ata25.00: configured for UDMA/133
> [56094.940794] sd 24:0:0:0: [sdc] tag#4 FAILED Result: hostbyte=3DDID=
_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56094.940797] sd 24:0:0:0: [sdc] tag#4 Sense Key : Medium Error [cur=
rent]=20
> [56094.940798] sd 24:0:0:0: [sdc] tag#4 Add. Sense: Unrecovered read =
error
> [56094.940800] sd 24:0:0:0: [sdc] tag#4 CDB: Read(16) 88 00 00 00 00 =
02 15 a5 d5 40 00 00 00 08 00 00
> [56094.940801] critical medium error, dev sdc, sector 8953124160 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56094.950988] ata25: EH complete
> [56097.106784] ata25.00: exception Emask 0x0 SAct 0x1ff SErr 0x0 acti=
on 0x0
> [56097.113493] ata25.00: irq_stat 0x40000008
> [56097.117535] ata25.00: failed command: READ FPDMA QUEUED
> [56097.122766] ata25.00: cmd 60/08:00:48:d5:a5/00:00:15:02:00/40 tag =
0 ncq dma 4096 in
>                         res 43/40:08:48:d5:a5/00:00:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56097.138641] ata25.00: status: { DRDY SENSE ERR }
> [56097.143266] ata25.00: error: { UNC }
> [56097.240013] ata25.00: configured for UDMA/133
> [56097.240023] sd 24:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=3DDID=
_OK driverbyte=3DDRIVER_OK cmd_age=3D4s
> [56097.240025] sd 24:0:0:0: [sdc] tag#0 Sense Key : Medium Error [cur=
rent]=20
> [56097.240027] sd 24:0:0:0: [sdc] tag#0 Add. Sense: Unrecovered read =
error
> [56097.240029] sd 24:0:0:0: [sdc] tag#0 CDB: Read(16) 88 00 00 00 00 =
02 15 a5 d5 48 00 00 00 08 00 00
> [56097.240030] critical medium error, dev sdc, sector 8953124168 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56097.250218] ata25: EH complete
> [56097.410333] md/raid:md127: read error corrected (8 sectors at 8953=
089344 on dm-1)
> [56097.410336] md/raid:md127: read error corrected (8 sectors at 8953=
089352 on dm-1)
> [56099.619970] ata25.00: exception Emask 0x0 SAct 0xfc400 SErr 0x0 ac=
tion 0x0
> [56099.626852] ata25.00: irq_stat 0x40000008
> [56099.630893] ata25.00: failed command: READ FPDMA QUEUED
> [56099.636124] ata25.00: cmd 60/08:70:60:d5:a5/00:00:15:02:00/40 tag =
14 ncq dma 4096 in
>                         res 43/40:08:60:d5:a5/00:00:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56099.652076] ata25.00: status: { DRDY SENSE ERR }
> [56099.656714] ata25.00: error: { UNC }
> [56100.347242] ata25.00: configured for UDMA/133
> [56100.347261] sd 24:0:0:0: [sdc] tag#14 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D7s
> [56100.347265] sd 24:0:0:0: [sdc] tag#14 Sense Key : Medium Error [cu=
rrent]=20
> [56100.347267] sd 24:0:0:0: [sdc] tag#14 Add. Sense: Unrecovered read=
 error
> [56100.347269] sd 24:0:0:0: [sdc] tag#14 CDB: Read(16) 88 00 00 00 00=
 02 15 a5 d5 60 00 00 00 08 00 00
> [56100.347271] critical medium error, dev sdc, sector 8953124192 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56100.357447] ata25: EH complete
> [56102.646580] ata25.00: exception Emask 0x0 SAct 0xffffffff SErr 0x0=
 action 0x0
> [56102.653723] ata25.00: irq_stat 0x40000008
> [56102.657799] ata25.00: failed command: READ FPDMA QUEUED
> [56102.663032] ata25.00: cmd 60/08:08:68:d5:a5/00:00:15:02:00/40 tag =
1 ncq dma 4096 in
>                         res 43/40:08:68:d5:a5/00:00:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56102.678903] ata25.00: status: { DRDY SENSE ERR }
> [56102.683529] ata25.00: error: { UNC }
> [56102.771380] ata25.00: configured for UDMA/133
> [56102.771406] sd 24:0:0:0: [sdc] tag#1 FAILED Result: hostbyte=3DDID=
_OK driverbyte=3DDRIVER_OK cmd_age=3D9s
> [56102.771410] sd 24:0:0:0: [sdc] tag#1 Sense Key : Medium Error [cur=
rent]=20
> [56102.771412] sd 24:0:0:0: [sdc] tag#1 Add. Sense: Unrecovered read =
error
> [56102.771414] sd 24:0:0:0: [sdc] tag#1 CDB: Read(16) 88 00 00 00 00 =
02 15 a5 d5 68 00 00 00 08 00 00
> [56102.771416] critical medium error, dev sdc, sector 8953124200 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56102.781675] ata25: EH complete
> [56103.029621] md/raid:md127: read error corrected (8 sectors at 8953=
092928 on dm-1)
> [56103.092184] md/raid:md127: read error corrected (8 sectors at 8953=
089376 on dm-1)
> [56103.092186] md/raid:md127: read error corrected (8 sectors at 8953=
089384 on dm-1)
> [56105.587003] ata25.00: exception Emask 0x0 SAct 0xbf048f84 SErr 0x0=
 action 0x0
> [56105.594143] ata25.00: irq_stat 0x40000008
> [56105.598252] ata25.00: failed command: READ FPDMA QUEUED
> [56105.603519] ata25.00: cmd 60/08:38:c0:9d:a5/00:00:15:02:00/40 tag =
7 ncq dma 4096 in
>                         res 43/40:08:c0:9d:a5/00:00:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56105.619401] ata25.00: status: { DRDY SENSE ERR }
> [56105.624038] ata25.00: error: { UNC }
> [56105.720389] ata25.00: configured for UDMA/133
> [56105.720406] sd 24:0:0:0: [sdc] tag#7 FAILED Result: hostbyte=3DDID=
_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56105.720408] sd 24:0:0:0: [sdc] tag#7 Sense Key : Medium Error [cur=
rent]=20
> [56105.720410] sd 24:0:0:0: [sdc] tag#7 Add. Sense: Unrecovered read =
error
> [56105.720411] sd 24:0:0:0: [sdc] tag#7 CDB: Read(16) 88 00 00 00 00 =
02 15 a5 9d c0 00 00 00 08 00 00
> [56105.720412] critical medium error, dev sdc, sector 8953109952 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56105.730613] ata25: EH complete
> [56107.886332] ata25.00: exception Emask 0x0 SAct 0x801f0fe SErr 0x0 =
action 0x0
> [56107.893397] ata25.00: irq_stat 0x40000008
> [56107.897450] ata25.00: failed command: READ FPDMA QUEUED
> [56107.902682] ata25.00: cmd 60/08:60:d0:9d:a5/00:00:15:02:00/40 tag =
12 ncq dma 4096 in
>                         res 43/40:08:d0:9d:a5/00:00:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56107.918625] ata25.00: status: { DRDY SENSE ERR }
> [56107.923257] ata25.00: error: { UNC }
> [56108.027884] ata25.00: configured for UDMA/133
> [56108.027924] sd 24:0:0:0: [sdc] tag#12 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D4s
> [56108.027928] sd 24:0:0:0: [sdc] tag#12 Sense Key : Medium Error [cu=
rrent]=20
> [56108.027930] sd 24:0:0:0: [sdc] tag#12 Add. Sense: Unrecovered read=
 error
> [56108.027932] sd 24:0:0:0: [sdc] tag#12 CDB: Read(16) 88 00 00 00 00=
 02 15 a5 9d d0 00 00 00 08 00 00
> [56108.027933] critical medium error, dev sdc, sector 8953109968 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56108.038104] ata25: EH complete
> [56109.020217] md/raid:md127: read error corrected (8 sectors at 8953=
075136 on dm-1)
> [56109.070237] md/raid:md127: read error corrected (8 sectors at 8953=
075152 on dm-1)
> [56128.637868] ata25.00: exception Emask 0x0 SAct 0x1f08400 SErr 0x0 =
action 0x0
> [56128.644996] ata25.00: irq_stat 0x40000008
> [56128.649038] ata25.00: failed command: READ FPDMA QUEUED
> [56128.654277] ata25.00: cmd 60/40:50:08:b5:bf/05:00:15:02:00/40 tag =
10 ncq dma 688128 in
>                         res 43/40:40:50:b9:bf/00:05:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56128.670394] ata25.00: status: { DRDY SENSE ERR }
> [56128.675024] ata25.00: error: { UNC }
> [56128.778932] ata25.00: configured for UDMA/133
> [56128.778969] sd 24:0:0:0: [sdc] tag#10 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56128.778973] sd 24:0:0:0: [sdc] tag#10 Sense Key : Medium Error [cu=
rrent]=20
> [56128.778975] sd 24:0:0:0: [sdc] tag#10 Add. Sense: Unrecovered read=
 error
> [56128.778978] sd 24:0:0:0: [sdc] tag#10 CDB: Read(16) 88 00 00 00 00=
 02 15 bf b5 08 00 00 05 40 00 00
> [56128.778980] critical medium error, dev sdc, sector 8954819848 op 0=
x0:(READ) flags 0x84700 phys_seg 168 prio class 0
> [56128.789429] ata25: EH complete
> [56140.808042] ata25.00: exception Emask 0x0 SAct 0xffffffff SErr 0x0=
 action 0x0
> [56140.815183] ata25.00: irq_stat 0x40000008
> [56140.819207] ata25.00: failed command: READ FPDMA QUEUED
> [56140.824447] ata25.00: cmd 60/c0:58:50:fa:c1/02:00:15:02:00/40 tag =
11 ncq dma 360448 in
>                         res 43/40:c0:88:fa:c1/00:02:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56140.840704] ata25.00: status: { DRDY SENSE ERR }
> [56140.845334] ata25.00: error: { UNC }
> [56140.933033] ata25.00: configured for UDMA/133
> [56140.933158] sd 24:0:0:0: [sdc] tag#11 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56140.933161] sd 24:0:0:0: [sdc] tag#11 Sense Key : Medium Error [cu=
rrent]=20
> [56140.933163] sd 24:0:0:0: [sdc] tag#11 Add. Sense: Unrecovered read=
 error
> [56140.933166] sd 24:0:0:0: [sdc] tag#11 CDB: Read(16) 88 00 00 00 00=
 02 15 c1 fa 50 00 00 02 c0 00 00
> [56140.933168] critical medium error, dev sdc, sector 8954968656 op 0=
x0:(READ) flags 0x80700 phys_seg 88 prio class 0
> [56140.943561] ata25: EH complete
> [56151.197018] ata25.00: exception Emask 0x0 SAct 0x90a00708 SErr 0x0=
 action 0x0
> [56151.204161] ata25.00: irq_stat 0x40000008
> [56151.208245] ata25.00: failed command: READ FPDMA QUEUED
> [56151.213520] ata25.00: cmd 60/08:b8:50:b9:bf/00:00:15:02:00/40 tag =
23 ncq dma 4096 in
>                         res 43/40:08:50:b9:bf/00:00:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56151.229462] ata25.00: status: { DRDY SENSE ERR }
> [56151.234143] ata25.00: error: { UNC }
> [56151.346056] ata25.00: configured for UDMA/133
> [56151.346077] sd 24:0:0:0: [sdc] tag#23 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56151.346081] sd 24:0:0:0: [sdc] tag#23 Sense Key : Medium Error [cu=
rrent]=20
> [56151.346083] sd 24:0:0:0: [sdc] tag#23 Add. Sense: Unrecovered read=
 error
> [56151.346085] sd 24:0:0:0: [sdc] tag#23 CDB: Read(16) 88 00 00 00 00=
 02 15 bf b9 50 00 00 00 08 00 00
> [56151.346087] critical medium error, dev sdc, sector 8954820944 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56151.356272] ata25: EH complete
> [56151.993105] md/raid:md127: read error corrected (8 sectors at 8954=
786128 on dm-1)
> [56160.208102] ata25.00: exception Emask 0x0 SAct 0x6000 SErr 0x0 act=
ion 0x0
> [56160.214893] ata25.00: irq_stat 0x40000008
> [56160.218993] ata25.00: failed command: READ FPDMA QUEUED
> [56160.224233] ata25.00: cmd 60/30:68:00:dd:bf/09:00:15:02:00/40 tag =
13 ncq dma 1204224 in
>                         res 43/40:30:c8:e2:bf/00:09:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56160.240498] ata25.00: status: { DRDY SENSE ERR }
> [56160.245133] ata25.00: error: { UNC }
> [56160.342920] ata25.00: configured for UDMA/133
> [56160.342941] sd 24:0:0:0: [sdc] tag#13 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D7s
> [56160.342944] sd 24:0:0:0: [sdc] tag#13 Sense Key : Medium Error [cu=
rrent]=20
> [56160.342946] sd 24:0:0:0: [sdc] tag#13 Add. Sense: Unrecovered read=
 error
> [56160.342949] sd 24:0:0:0: [sdc] tag#13 CDB: Read(16) 88 00 00 00 00=
 02 15 bf dd 00 00 00 09 30 00 00
> [56160.342950] critical medium error, dev sdc, sector 8954830080 op 0=
x0:(READ) flags 0x84700 phys_seg 138 prio class 0
> [56160.353550] ata25: EH complete
> [56162.898662] ata25.00: exception Emask 0x0 SAct 0xff033fff SErr 0x0=
 action 0x0
> [56162.905798] ata25.00: irq_stat 0x40000008
> [56162.909825] ata25.00: failed command: READ FPDMA QUEUED
> [56162.915066] ata25.00: cmd 60/08:c0:88:fa:c1/00:00:15:02:00/40 tag =
24 ncq dma 4096 in
>                         res 43/40:08:88:fa:c1/00:00:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56162.931020] ata25.00: status: { DRDY SENSE ERR }
> [56162.935724] ata25.00: error: { UNC }
> [56163.025343] ata25.00: configured for UDMA/133
> [56163.025377] sd 24:0:0:0: [sdc] tag#24 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56163.025380] sd 24:0:0:0: [sdc] tag#24 Sense Key : Medium Error [cu=
rrent]=20
> [56163.025381] sd 24:0:0:0: [sdc] tag#24 Add. Sense: Unrecovered read=
 error
> [56163.025383] sd 24:0:0:0: [sdc] tag#24 CDB: Read(16) 88 00 00 00 00=
 02 15 c1 fa 88 00 00 00 08 00 00
> [56163.025384] critical medium error, dev sdc, sector 8954968712 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56163.035579] ata25: EH complete
> [56165.407934] ata25.00: exception Emask 0x0 SAct 0x3f00301e SErr 0x0=
 action 0x0
> [56165.415071] ata25.00: irq_stat 0x40000008
> [56165.419099] ata25.00: failed command: READ FPDMA QUEUED
> [56165.424332] ata25.00: cmd 60/08:08:a0:fa:c1/00:00:15:02:00/40 tag =
1 ncq dma 4096 in
>                         res 43/40:08:a0:fa:c1/00:00:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56165.440240] ata25.00: status: { DRDY SENSE ERR }
> [56165.444882] ata25.00: error: { UNC }
> [56165.541134] ata25.00: configured for UDMA/133
> [56165.541174] sd 24:0:0:0: [sdc] tag#1 FAILED Result: hostbyte=3DDID=
_OK driverbyte=3DDRIVER_OK cmd_age=3D4s
> [56165.541178] sd 24:0:0:0: [sdc] tag#1 Sense Key : Medium Error [cur=
rent]=20
> [56165.541180] sd 24:0:0:0: [sdc] tag#1 Add. Sense: Unrecovered read =
error
> [56165.541182] sd 24:0:0:0: [sdc] tag#1 CDB: Read(16) 88 00 00 00 00 =
02 15 c1 fa a0 00 00 00 08 00 00
> [56165.541183] critical medium error, dev sdc, sector 8954968736 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56165.551397] ata25: EH complete
> [56165.908338] md/raid:md127: read error corrected (8 sectors at 8954=
933896 on dm-1)
> [56165.908399] md/raid:md127: read error corrected (8 sectors at 8954=
933920 on dm-1)
> [56168.776163] ata25.00: exception Emask 0x0 SAct 0x3e00 SErr 0x0 act=
ion 0x0
> [56168.782972] ata25.00: irq_stat 0x40000008
> [56168.787088] ata25.00: failed command: READ FPDMA QUEUED
> [56168.792331] ata25.00: cmd 60/68:48:00:15:c2/05:00:15:02:00/40 tag =
9 ncq dma 708608 in
>                         res 43/40:68:38:16:c2/00:05:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56168.808360] ata25.00: status: { DRDY SENSE ERR }
> [56168.812995] ata25.00: error: { UNC }
> [56168.914982] ata25.00: configured for UDMA/133
> [56168.915022] sd 24:0:0:0: [sdc] tag#9 FAILED Result: hostbyte=3DDID=
_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56168.915026] sd 24:0:0:0: [sdc] tag#9 Sense Key : Medium Error [cur=
rent]=20
> [56168.915028] sd 24:0:0:0: [sdc] tag#9 Add. Sense: Unrecovered read =
error
> [56168.915030] sd 24:0:0:0: [sdc] tag#9 CDB: Read(16) 88 00 00 00 00 =
02 15 c2 15 00 00 00 05 68 00 00
> [56168.915032] critical medium error, dev sdc, sector 8954975488 op 0=
x0:(READ) flags 0x84700 phys_seg 168 prio class 0
> [56168.925513] ata25: EH complete
> [56171.028271] ata25.00: exception Emask 0x0 SAct 0xffffffff SErr 0x0=
 action 0x0
> [56171.035404] ata25.00: irq_stat 0x40000008
> [56171.039425] ata25.00: failed command: READ FPDMA QUEUED
> [56171.044663] ata25.00: cmd 60/88:b0:68:22:c2/05:00:15:02:00/40 tag =
22 ncq dma 724992 in
>                         res 43/40:88:40:24:c2/00:05:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56171.060767] ata25.00: status: { DRDY SENSE ERR }
> [56171.065396] ata25.00: error: { UNC }
> [56171.197504] ata25.00: configured for UDMA/133
> [56171.197561] sd 24:0:0:0: [sdc] tag#22 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D4s
> [56171.197563] sd 24:0:0:0: [sdc] tag#22 Sense Key : Medium Error [cu=
rrent]=20
> [56171.197565] sd 24:0:0:0: [sdc] tag#22 Add. Sense: Unrecovered read=
 error
> [56171.197567] sd 24:0:0:0: [sdc] tag#22 CDB: Read(16) 88 00 00 00 00=
 02 15 c2 22 68 00 00 05 88 00 00
> [56171.197568] critical medium error, dev sdc, sector 8954978920 op 0=
x0:(READ) flags 0x84700 phys_seg 89 prio class 0
> [56171.207924] ata25: EH complete
> [56173.646130] ata25.00: exception Emask 0x0 SAct 0x1f830fc SErr 0x0 =
action 0x0
> [56173.653181] ata25.00: irq_stat 0x40000008
> [56173.657206] ata25.00: failed command: READ FPDMA QUEUED
> [56173.662452] ata25.00: cmd 60/08:98:c8:e2:bf/00:00:15:02:00/40 tag =
19 ncq dma 4096 in
>                         res 43/40:08:c8:e2:bf/00:00:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56173.678392] ata25.00: status: { DRDY SENSE ERR }
> [56173.683024] ata25.00: error: { UNC }
> [56173.788276] ata25.00: configured for UDMA/133
> [56173.788298] sd 24:0:0:0: [sdc] tag#19 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56173.788301] sd 24:0:0:0: [sdc] tag#19 Sense Key : Medium Error [cu=
rrent]=20
> [56173.788302] sd 24:0:0:0: [sdc] tag#19 Add. Sense: Unrecovered read=
 error
> [56173.788304] sd 24:0:0:0: [sdc] tag#19 CDB: Read(16) 88 00 00 00 00=
 02 15 bf e2 c8 00 00 00 08 00 00
> [56173.788305] critical medium error, dev sdc, sector 8954831560 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56173.798484] ata25: EH complete
> [56176.164900] ata25.00: exception Emask 0x0 SAct 0x7f003c40 SErr 0x0=
 action 0x0
> [56176.172042] ata25.00: irq_stat 0x40000008
> [56176.176075] ata25.00: failed command: READ FPDMA QUEUED
> [56176.181310] ata25.00: cmd 60/08:c0:d8:e2:bf/00:00:15:02:00/40 tag =
24 ncq dma 4096 in
>                         res 43/40:08:d8:e2:bf/00:00:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56176.197248] ata25.00: status: { DRDY SENSE ERR }
> [56176.201885] ata25.00: error: { UNC }
> [56176.304061] ata25.00: configured for UDMA/133
> [56176.304083] sd 24:0:0:0: [sdc] tag#24 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D4s
> [56176.304086] sd 24:0:0:0: [sdc] tag#24 Sense Key : Medium Error [cu=
rrent]=20
> [56176.304088] sd 24:0:0:0: [sdc] tag#24 Add. Sense: Unrecovered read=
 error
> [56176.304091] sd 24:0:0:0: [sdc] tag#24 CDB: Read(16) 88 00 00 00 00=
 02 15 bf e2 d8 00 00 00 08 00 00
> [56176.304092] critical medium error, dev sdc, sector 8954831576 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56176.314265] ata25: EH complete
> [56178.758401] ata25.00: exception Emask 0x0 SAct 0xf0000 SErr 0x0 ac=
tion 0x0
> [56178.765286] ata25.00: irq_stat 0x40000008
> [56178.769308] ata25.00: failed command: READ FPDMA QUEUED
> [56178.774543] ata25.00: cmd 60/08:80:f0:e2:bf/00:00:15:02:00/40 tag =
16 ncq dma 4096 in
>                         res 43/40:08:f0:e2:bf/00:00:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56178.790490] ata25.00: status: { DRDY SENSE ERR }
> [56178.795122] ata25.00: error: { UNC }
> [56178.903147] ata25.00: configured for UDMA/133
> [56178.903159] sd 24:0:0:0: [sdc] tag#16 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D7s
> [56178.903162] sd 24:0:0:0: [sdc] tag#16 Sense Key : Medium Error [cu=
rrent]=20
> [56178.903164] sd 24:0:0:0: [sdc] tag#16 Add. Sense: Unrecovered read=
 error
> [56178.903166] sd 24:0:0:0: [sdc] tag#16 CDB: Read(16) 88 00 00 00 00=
 02 15 bf e2 f0 00 00 00 08 00 00
> [56178.903168] critical medium error, dev sdc, sector 8954831600 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56178.913335] ata25: EH complete
> [56179.970979] md/raid:md127: read error corrected (8 sectors at 8954=
796744 on dm-1)
> [56179.995987] md/raid:md127: read error corrected (8 sectors at 8954=
796760 on dm-1)
> [56180.127216] md/raid:md127: read error corrected (8 sectors at 8954=
796784 on dm-1)
> [56182.417776] ata25.00: exception Emask 0x0 SAct 0x82a33a10 SErr 0x0=
 action 0x0
> [56182.424916] ata25.00: irq_stat 0x40000008
> [56182.428940] ata25.00: failed command: READ FPDMA QUEUED
> [56182.434181] ata25.00: cmd 60/00:68:00:f0:bf/05:00:15:02:00/40 tag =
13 ncq dma 655360 in
>                         res 43/40:00:a8:f0:bf/00:05:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56182.450294] ata25.00: status: { DRDY SENSE ERR }
> [56182.454927] ata25.00: error: { UNC }
> [56182.860118] ata25.00: configured for UDMA/133
> [56182.860160] sd 24:0:0:0: [sdc] tag#13 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56182.860162] sd 24:0:0:0: [sdc] tag#13 Sense Key : Medium Error [cu=
rrent]=20
> [56182.860164] sd 24:0:0:0: [sdc] tag#13 Add. Sense: Unrecovered read=
 error
> [56182.860166] sd 24:0:0:0: [sdc] tag#13 CDB: Read(16) 88 00 00 00 00=
 02 15 bf f0 00 00 00 05 00 00 00
> [56182.860167] critical medium error, dev sdc, sector 8954834944 op 0=
x0:(READ) flags 0x80700 phys_seg 160 prio class 0
> [56182.870623] ata25: EH complete
> [56187.499909] ata25.00: exception Emask 0x0 SAct 0xffffffff SErr 0x0=
 action 0x0
> [56187.507047] ata25.00: irq_stat 0x40000008
> [56187.511096] ata25.00: failed command: READ FPDMA QUEUED
> [56187.516328] ata25.00: cmd 60/c0:38:40:0a:c0/02:00:15:02:00/40 tag =
7 ncq dma 360448 in
>                         res 43/40:c0:90:0c:c0/00:02:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56187.532352] ata25.00: status: { DRDY SENSE ERR }
> [56187.536977] ata25.00: error: { UNC }
> [56187.683438] ata25.00: configured for UDMA/133
> [56187.683565] sd 24:0:0:0: [sdc] tag#7 FAILED Result: hostbyte=3DDID=
_OK driverbyte=3DDRIVER_OK cmd_age=3D7s
> [56187.683568] sd 24:0:0:0: [sdc] tag#7 Sense Key : Medium Error [cur=
rent]=20
> [56187.683571] sd 24:0:0:0: [sdc] tag#7 Add. Sense: Unrecovered read =
error
> [56187.683573] sd 24:0:0:0: [sdc] tag#7 CDB: Read(16) 88 00 00 00 00 =
02 15 c0 0a 40 00 00 02 c0 00 00
> [56187.683574] critical medium error, dev sdc, sector 8954841664 op 0=
x0:(READ) flags 0x84700 phys_seg 88 prio class 0
> [56187.693985] ata25: EH complete
> [56190.600849] ata25.00: exception Emask 0x0 SAct 0x3c00000 SErr 0x0 =
action 0x0
> [56190.607902] ata25.00: irq_stat 0x40000008
> [56190.611931] ata25.00: failed command: READ FPDMA QUEUED
> [56190.617167] ata25.00: cmd 60/08:b0:40:24:c2/00:00:15:02:00/40 tag =
22 ncq dma 4096 in
>                         res 43/40:08:40:24:c2/00:00:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56190.633103] ata25.00: status: { DRDY SENSE ERR }
> [56190.637732] ata25.00: error: { UNC }
> [56190.749035] ata25.00: configured for UDMA/133
> [56190.749045] sd 24:0:0:0: [sdc] tag#22 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56190.749047] sd 24:0:0:0: [sdc] tag#22 Sense Key : Medium Error [cu=
rrent]=20
> [56190.749049] sd 24:0:0:0: [sdc] tag#22 Add. Sense: Unrecovered read=
 error
> [56190.749051] sd 24:0:0:0: [sdc] tag#22 CDB: Read(16) 88 00 00 00 00=
 02 15 c2 24 40 00 00 00 08 00 00
> [56190.749052] critical medium error, dev sdc, sector 8954979392 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56190.759221] ata25: EH complete
> [56192.116233] md/raid:md127: read error corrected (8 sectors at 8954=
944576 on dm-1)
> [56194.231404] ata25.00: exception Emask 0x0 SAct 0xffe00083 SErr 0x0=
 action 0x0
> [56194.238545] ata25.00: irq_stat 0x40000008
> [56194.242576] ata25.00: failed command: READ FPDMA QUEUED
> [56194.247816] ata25.00: cmd 60/08:a8:90:0c:c0/00:00:15:02:00/40 tag =
21 ncq dma 4096 in
>                         res 43/40:08:90:0c:c0/00:00:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56194.263754] ata25.00: status: { DRDY SENSE ERR }
> [56194.268384] ata25.00: error: { UNC }
> [56194.372726] ata25.00: configured for UDMA/133
> [56194.372748] sd 24:0:0:0: [sdc] tag#21 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56194.372752] sd 24:0:0:0: [sdc] tag#21 Sense Key : Medium Error [cu=
rrent]=20
> [56194.372754] sd 24:0:0:0: [sdc] tag#21 Add. Sense: Unrecovered read=
 error
> [56194.372756] sd 24:0:0:0: [sdc] tag#21 CDB: Read(16) 88 00 00 00 00=
 02 15 c0 0c 90 00 00 00 08 00 00
> [56194.372758] critical medium error, dev sdc, sector 8954842256 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56194.382955] ata25: EH complete
> [56196.397118] ata25.00: exception Emask 0x0 SAct 0xffcf3fff SErr 0x0=
 action 0x0
> [56196.404260] ata25.00: irq_stat 0x40000008
> [56196.408299] ata25.00: failed command: READ FPDMA QUEUED
> [56196.413528] ata25.00: cmd 60/08:80:a8:f0:bf/00:00:15:02:00/40 tag =
16 ncq dma 4096 in
>                         res 43/40:08:a8:f0:bf/00:00:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56196.429462] ata25.00: status: { DRDY SENSE ERR }
> [56196.434090] ata25.00: error: { UNC }
> [56196.530294] ata25.00: configured for UDMA/133
> [56196.530341] sd 24:0:0:0: [sdc] tag#16 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56196.530345] sd 24:0:0:0: [sdc] tag#16 Sense Key : Medium Error [cu=
rrent]=20
> [56196.530347] sd 24:0:0:0: [sdc] tag#16 Add. Sense: Unrecovered read=
 error
> [56196.530349] sd 24:0:0:0: [sdc] tag#16 CDB: Read(16) 88 00 00 00 00=
 02 15 bf f0 a8 00 00 00 08 00 00
> [56196.530351] critical medium error, dev sdc, sector 8954835112 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56196.540554] ata25: EH complete
> [56198.681800] ata25.00: exception Emask 0x0 SAct 0xffffffff SErr 0x0=
 action 0x0
> [56198.688940] ata25.00: irq_stat 0x40000008
> [56198.692969] ata25.00: failed command: READ FPDMA QUEUED
> [56198.698203] ata25.00: cmd 60/08:48:b0:f0:bf/00:00:15:02:00/40 tag =
9 ncq dma 4096 in
>                         res 43/40:08:b0:f0:bf/00:00:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56198.714053] ata25.00: status: { DRDY SENSE ERR }
> [56198.718683] ata25.00: error: { UNC }
> [56198.804495] ata25.00: configured for UDMA/133
> [56198.804544] sd 24:0:0:0: [sdc] tag#9 FAILED Result: hostbyte=3DDID=
_OK driverbyte=3DDRIVER_OK cmd_age=3D4s
> [56198.804547] sd 24:0:0:0: [sdc] tag#9 Sense Key : Medium Error [cur=
rent]=20
> [56198.804548] sd 24:0:0:0: [sdc] tag#9 Add. Sense: Unrecovered read =
error
> [56198.804550] sd 24:0:0:0: [sdc] tag#9 CDB: Read(16) 88 00 00 00 00 =
02 15 bf f0 b0 00 00 00 08 00 00
> [56198.804551] critical medium error, dev sdc, sector 8954835120 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56198.814780] ata25: EH complete
> [56201.562060] ata25.00: exception Emask 0x0 SAct 0xffffffff SErr 0x0=
 action 0x0
> [56201.569195] ata25.00: irq_stat 0x40000008
> [56201.573222] ata25.00: failed command: READ FPDMA QUEUED
> [56201.578453] ata25.00: cmd 60/08:98:b8:f0:bf/00:00:15:02:00/40 tag =
19 ncq dma 4096 in
>                         res 43/40:08:b8:f0:bf/00:00:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56201.594397] ata25.00: status: { DRDY SENSE ERR }
> [56201.599028] ata25.00: error: { UNC }
> [56201.686862] ata25.00: configured for UDMA/133
> [56201.686971] sd 24:0:0:0: [sdc] tag#19 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D7s
> [56201.686975] sd 24:0:0:0: [sdc] tag#19 Sense Key : Medium Error [cu=
rrent]=20
> [56201.686977] sd 24:0:0:0: [sdc] tag#19 Add. Sense: Unrecovered read=
 error
> [56201.686980] sd 24:0:0:0: [sdc] tag#19 CDB: Read(16) 88 00 00 00 00=
 02 15 bf f0 b8 00 00 00 08 00 00
> [56201.686981] critical medium error, dev sdc, sector 8954835128 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56201.697185] ata25: EH complete
> [56204.153189] ata25.00: exception Emask 0x0 SAct 0x7eb9f001 SErr 0x0=
 action 0x0
> [56204.160325] ata25.00: irq_stat 0x40000008
> [56204.164349] ata25.00: failed command: READ FPDMA QUEUED
> [56204.169575] ata25.00: cmd 60/08:70:d0:f0:bf/00:00:15:02:00/40 tag =
14 ncq dma 4096 in
>                         res 43/40:08:d0:f0:bf/00:00:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56204.185512] ata25.00: status: { DRDY SENSE ERR }
> [56204.190140] ata25.00: error: { UNC }
> [56204.285936] ata25.00: configured for UDMA/133
> [56204.285962] sd 24:0:0:0: [sdc] tag#14 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D9s
> [56204.285966] sd 24:0:0:0: [sdc] tag#14 Sense Key : Medium Error [cu=
rrent]=20
> [56204.285968] sd 24:0:0:0: [sdc] tag#14 Add. Sense: Unrecovered read=
 error
> [56204.285969] sd 24:0:0:0: [sdc] tag#14 CDB: Read(16) 88 00 00 00 00=
 02 15 bf f0 d0 00 00 00 08 00 00
> [56204.285970] critical medium error, dev sdc, sector 8954835152 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56204.296157] ata25: EH complete
> [56204.675513] md/raid:md127: read error corrected (8 sectors at 8954=
800296 on dm-1)
> [56204.675539] md/raid:md127: read error corrected (8 sectors at 8954=
807440 on dm-1)
> [56205.744062] md/raid:md127: read error corrected (8 sectors at 8954=
800304 on dm-1)
> [56205.744063] md/raid:md127: read error corrected (8 sectors at 8954=
800312 on dm-1)
> [56205.762220] md/raid:md127: read error corrected (8 sectors at 8954=
800336 on dm-1)
> [56208.131813] ata25.00: exception Emask 0x0 SAct 0x3ff87c SErr 0x0 a=
ction 0x0
> [56208.138777] ata25.00: irq_stat 0x40000008
> [56208.142810] ata25.00: failed command: READ FPDMA QUEUED
> [56208.148045] ata25.00: cmd 60/08:58:38:16:c2/00:00:15:02:00/40 tag =
11 ncq dma 4096 in
>                         res 43/40:08:38:16:c2/00:00:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56208.163988] ata25.00: status: { DRDY SENSE ERR }
> [56208.168617] ata25.00: error: { UNC }
> [56208.251256] ata25.00: configured for UDMA/133
> [56208.251278] sd 24:0:0:0: [sdc] tag#11 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56208.251281] sd 24:0:0:0: [sdc] tag#11 Sense Key : Medium Error [cu=
rrent]=20
> [56208.251283] sd 24:0:0:0: [sdc] tag#11 Add. Sense: Unrecovered read=
 error
> [56208.251286] sd 24:0:0:0: [sdc] tag#11 CDB: Read(16) 88 00 00 00 00=
 02 15 c2 16 38 00 00 00 08 00 00
> [56208.251287] critical medium error, dev sdc, sector 8954975800 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56208.261478] ata25: EH complete
> [56210.458900] ata25.00: exception Emask 0x0 SAct 0x57c0154b SErr 0x0=
 action 0x0
> [56210.466042] ata25.00: irq_stat 0x40000008
> [56210.470074] ata25.00: failed command: READ FPDMA QUEUED
> [56210.475307] ata25.00: cmd 60/08:e0:48:16:c2/00:00:15:02:00/40 tag =
28 ncq dma 4096 in
>                         res 43/40:08:48:16:c2/00:00:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56210.491246] ata25.00: status: { DRDY SENSE ERR }
> [56210.495877] ata25.00: error: { UNC }
> [56210.592096] ata25.00: configured for UDMA/133
> [56210.592116] sd 24:0:0:0: [sdc] tag#28 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D4s
> [56210.592118] sd 24:0:0:0: [sdc] tag#28 Sense Key : Medium Error [cu=
rrent]=20
> [56210.592120] sd 24:0:0:0: [sdc] tag#28 Add. Sense: Unrecovered read=
 error
> [56210.592122] sd 24:0:0:0: [sdc] tag#28 CDB: Read(16) 88 00 00 00 00=
 02 15 c2 16 48 00 00 00 08 00 00
> [56210.592123] critical medium error, dev sdc, sector 8954975816 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56210.602295] ata25: EH complete
> [56212.738574] ata25.00: exception Emask 0x0 SAct 0xffffffff SErr 0x0=
 action 0x0
> [56212.745711] ata25.00: irq_stat 0x40000008
> [56212.749733] ata25.00: failed command: READ FPDMA QUEUED
> [56212.754964] ata25.00: cmd 60/08:68:60:16:c2/00:00:15:02:00/40 tag =
13 ncq dma 4096 in
>                         res 43/40:08:60:16:c2/00:00:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56212.770902] ata25.00: status: { DRDY SENSE ERR }
> [56212.775529] ata25.00: error: { UNC }
> [56212.857966] ata25.00: configured for UDMA/133
> [56212.858023] sd 24:0:0:0: [sdc] tag#13 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D6s
> [56212.858026] sd 24:0:0:0: [sdc] tag#13 Sense Key : Medium Error [cu=
rrent]=20
> [56212.858028] sd 24:0:0:0: [sdc] tag#13 Add. Sense: Unrecovered read=
 error
> [56212.858031] sd 24:0:0:0: [sdc] tag#13 CDB: Read(16) 88 00 00 00 00=
 02 15 c2 16 60 00 00 00 08 00 00
> [56212.858032] critical medium error, dev sdc, sector 8954975840 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56212.868220] ata25: EH complete
> [56222.496422] ata25.00: exception Emask 0x0 SAct 0x60000000 SErr 0x0=
 action 0x0
> [56222.503555] ata25.00: irq_stat 0x40000008
> [56222.507581] ata25.00: failed command: READ FPDMA QUEUED
> [56222.512806] ata25.00: cmd 60/00:e8:00:25:c0/08:00:15:02:00/40 tag =
29 ncq dma 1048576 in
>                         res 43/40:00:50:28:c0/00:08:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56222.529006] ata25.00: status: { DRDY SENSE ERR }
> [56222.533632] ata25.00: error: { UNC }
> [56222.671224] ata25.00: configured for UDMA/133
> [56222.671234] sd 24:0:0:0: [sdc] tag#29 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D9s
> [56222.671237] sd 24:0:0:0: [sdc] tag#29 Sense Key : Aborted Command =
[current]=20
> [56222.671239] sd 24:0:0:0: [sdc] tag#29 <<vendor>>ASC=3D0x80 ASCQ=3D=
0x2=20
> [56222.671241] sd 24:0:0:0: [sdc] tag#29 CDB: Read(16) 88 00 00 00 00=
 02 15 c0 25 00 00 00 08 00 00 00
> [56222.671242] I/O error, dev sdc, sector 8954848512 op 0x0:(READ) fl=
ags 0x84700 phys_seg 30 prio class 0
> [56222.680538] ata25: EH complete
> [56222.688487] md/raid:md127: read error corrected (8 sectors at 8954=
940984 on dm-1)
> [56222.688713] md/raid:md127: read error corrected (8 sectors at 8954=
941000 on dm-1)
> [56222.694091] md/raid:md127: read error corrected (8 sectors at 8954=
941024 on dm-1)
> [56268.461816] ata25.00: exception Emask 0x0 SAct 0x3c015f SErr 0x0 a=
ction 0x0
> [56268.468783] ata25.00: irq_stat 0x40000008
> [56268.472807] ata25.00: failed command: READ FPDMA QUEUED
> [56268.478039] ata25.00: cmd 60/68:00:98:08:f9/07:00:15:02:00/40 tag =
0 ncq dma 970752 in
>                         res 43/40:68:f0:0c:f9/00:07:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56268.494065] ata25.00: status: { DRDY SENSE ERR }
> [56268.498696] ata25.00: error: { UNC }
> [56268.613464] ata25.00: configured for UDMA/133
> [56268.613500] sd 24:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=3DDID=
_OK driverbyte=3DDRIVER_OK cmd_age=3D9s
> [56268.613503] sd 24:0:0:0: [sdc] tag#0 Sense Key : Aborted Command [=
current]=20
> [56268.613505] sd 24:0:0:0: [sdc] tag#0 <<vendor>>ASC=3D0x80 ASCQ=3D0=
x2=20
> [56268.613507] sd 24:0:0:0: [sdc] tag#0 CDB: Read(16) 88 00 00 00 00 =
02 15 f9 08 98 00 00 07 68 00 00
> [56268.613508] I/O error, dev sdc, sector 8958576792 op 0x0:(READ) fl=
ags 0x80700 phys_seg 112 prio class 0
> [56268.622926] ata25: EH complete
> [56274.436128] ata25.00: exception Emask 0x0 SAct 0xffffffff SErr 0x0=
 action 0x0
> [56274.443268] ata25.00: irq_stat 0x40000008
> [56274.447298] ata25.00: failed command: READ FPDMA QUEUED
> [56274.452542] ata25.00: cmd 60/c0:f8:58:82:fb/02:00:15:02:00/40 tag =
31 ncq dma 360448 in
>                         res 43/40:c0:c0:84:fb/00:02:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56274.468653] ata25.00: status: { DRDY SENSE ERR }
> [56274.473431] ata25.00: error: { UNC }
> [56274.569728] ata25.00: configured for UDMA/133
> [56274.569846] sd 24:0:0:0: [sdc] tag#31 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D5s
> [56274.569849] sd 24:0:0:0: [sdc] tag#31 Sense Key : Medium Error [cu=
rrent]=20
> [56274.569851] sd 24:0:0:0: [sdc] tag#31 Add. Sense: Unrecovered read=
 error
> [56274.569853] sd 24:0:0:0: [sdc] tag#31 CDB: Read(16) 88 00 00 00 00=
 02 15 fb 82 58 00 00 02 c0 00 00
> [56274.569854] critical medium error, dev sdc, sector 8958739032 op 0=
x0:(READ) flags 0x80700 phys_seg 88 prio class 0
> [56274.580225] ata25: EH complete
> [56277.816375] ata25.00: exception Emask 0x0 SAct 0x7c00003f SErr 0x0=
 action 0x0
> [56277.823514] ata25.00: irq_stat 0x40000008
> [56277.827538] ata25.00: failed command: READ FPDMA QUEUED
> [56277.832776] ata25.00: cmd 60/08:d0:c0:84:fb/00:00:15:02:00/40 tag =
26 ncq dma 4096 in
>                         res 43/40:08:c0:84:fb/00:00:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56277.848709] ata25.00: status: { DRDY SENSE ERR }
> [56277.853339] ata25.00: error: { UNC }
> [56277.943562] ata25.00: configured for UDMA/133
> [56277.943583] sd 24:0:0:0: [sdc] tag#26 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56277.943586] sd 24:0:0:0: [sdc] tag#26 Sense Key : Medium Error [cu=
rrent]=20
> [56277.943588] sd 24:0:0:0: [sdc] tag#26 Add. Sense: Unrecovered read=
 error
> [56277.943590] sd 24:0:0:0: [sdc] tag#26 CDB: Read(16) 88 00 00 00 00=
 02 15 fb 84 c0 00 00 00 08 00 00
> [56277.943591] critical medium error, dev sdc, sector 8958739648 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56277.953781] ata25: EH complete
> [56278.035244] md/raid:md127: read error corrected (8 sectors at 8958=
704832 on dm-1)
> [56282.414840] ata25.00: exception Emask 0x0 SAct 0x1f00 SErr 0x0 act=
ion 0x0
> [56282.421632] ata25.00: irq_stat 0x40000008
> [56282.425664] ata25.00: failed command: READ FPDMA QUEUED
> [56282.430892] ata25.00: cmd 60/40:40:00:9d:fb/05:00:15:02:00/40 tag =
8 ncq dma 688128 in
>                         res 43/40:40:70:a0:fb/00:05:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56282.446907] ata25.00: status: { DRDY SENSE ERR }
> [56282.451530] ata25.00: error: { UNC }
> [56282.550283] ata25.00: configured for UDMA/133
> [56282.550306] sd 24:0:0:0: [sdc] tag#8 FAILED Result: hostbyte=3DDID=
_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56282.550309] sd 24:0:0:0: [sdc] tag#8 Sense Key : Medium Error [cur=
rent]=20
> [56282.550311] sd 24:0:0:0: [sdc] tag#8 Add. Sense: Unrecovered read =
error
> [56282.550313] sd 24:0:0:0: [sdc] tag#8 CDB: Read(16) 88 00 00 00 00 =
02 15 fb 9d 00 00 00 05 40 00 00
> [56282.550314] critical medium error, dev sdc, sector 8958745856 op 0=
x0:(READ) flags 0x84700 phys_seg 168 prio class 0
> [56282.560764] ata25: EH complete
> [56284.651765] ata25.00: exception Emask 0x0 SAct 0xffffffff SErr 0x0=
 action 0x0
> [56284.658903] ata25.00: irq_stat 0x40000008
> [56284.662929] ata25.00: failed command: READ FPDMA QUEUED
> [56284.668166] ata25.00: cmd 60/f8:68:08:ad:fb/02:00:15:02:00/40 tag =
13 ncq dma 389120 in
>                         res 43/40:f8:50:ae:fb/00:02:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56284.684304] ata25.00: status: { DRDY SENSE ERR }
> [56284.688940] ata25.00: error: { UNC }
> [56284.782803] ata25.00: configured for UDMA/133
> [56284.782879] sd 24:0:0:0: [sdc] tag#13 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D4s
> [56284.782882] sd 24:0:0:0: [sdc] tag#13 Sense Key : Medium Error [cu=
rrent]=20
> [56284.782884] sd 24:0:0:0: [sdc] tag#13 Add. Sense: Unrecovered read=
 error
> [56284.782886] sd 24:0:0:0: [sdc] tag#13 CDB: Read(16) 88 00 00 00 00=
 02 15 fb ad 08 00 00 02 f8 00 00
> [56284.782887] critical medium error, dev sdc, sector 8958749960 op 0=
x0:(READ) flags 0x80700 phys_seg 94 prio class 0
> [56284.793258] ata25: EH complete
> [56291.737028] ata25.00: exception Emask 0x0 SAct 0xffffffff SErr 0x0=
 action 0x0
> [56291.744159] ata25.00: irq_stat 0x40000008
> [56291.748188] ata25.00: failed command: READ FPDMA QUEUED
> [56291.753427] ata25.00: cmd 60/08:c8:50:ae:fb/00:00:15:02:00/40 tag =
25 ncq dma 4096 in
>                         res 43/40:08:50:ae:fb/00:00:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56291.769386] ata25.00: status: { DRDY SENSE ERR }
> [56291.774088] ata25.00: error: { UNC }
> [56291.880394] ata25.00: configured for UDMA/133
> [56291.880466] sd 24:0:0:0: [sdc] tag#25 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56291.880470] sd 24:0:0:0: [sdc] tag#25 Sense Key : Medium Error [cu=
rrent]=20
> [56291.880472] sd 24:0:0:0: [sdc] tag#25 Add. Sense: Unrecovered read=
 error
> [56291.880475] sd 24:0:0:0: [sdc] tag#25 CDB: Read(16) 88 00 00 00 00=
 02 15 fb ae 50 00 00 00 08 00 00
> [56291.880476] critical medium error, dev sdc, sector 8958750288 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56291.890675] ata25: EH complete
> [56294.678468] ata25.00: exception Emask 0x0 SAct 0x3800800 SErr 0x0 =
action 0x0
> [56294.685525] ata25.00: irq_stat 0x40000008
> [56294.689551] ata25.00: failed command: READ FPDMA QUEUED
> [56294.694778] ata25.00: cmd 60/08:c0:60:ae:fb/00:00:15:02:00/40 tag =
24 ncq dma 4096 in
>                         res 43/40:08:60:ae:fb/00:00:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56294.710714] ata25.00: status: { DRDY SENSE ERR }
> [56294.715342] ata25.00: error: { UNC }
> [56294.804414] ata25.00: configured for UDMA/133
> [56294.804432] sd 24:0:0:0: [sdc] tag#24 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D5s
> [56294.804436] sd 24:0:0:0: [sdc] tag#24 Sense Key : Medium Error [cu=
rrent]=20
> [56294.804438] sd 24:0:0:0: [sdc] tag#24 Add. Sense: Unrecovered read=
 error
> [56294.804440] sd 24:0:0:0: [sdc] tag#24 CDB: Read(16) 88 00 00 00 00=
 02 15 fb ae 60 00 00 00 08 00 00
> [56294.804442] critical medium error, dev sdc, sector 8958750304 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56294.814622] ata25: EH complete
> [56294.823246] md/raid:md127: read error corrected (8 sectors at 8958=
715472 on dm-1)
> [56295.533704] md/raid:md127: read error corrected (8 sectors at 8958=
715488 on dm-1)
> [56297.739116] ata25.00: exception Emask 0x0 SAct 0x811807fe SErr 0x0=
 action 0x0
> [56297.746250] ata25.00: irq_stat 0x40000008
> [56297.750274] ata25.00: failed command: READ FPDMA QUEUED
> [56297.755507] ata25.00: cmd 60/08:08:70:a0:fb/00:00:15:02:00/40 tag =
1 ncq dma 4096 in
>                         res 43/40:08:70:a0:fb/00:00:15:02:00/00 Emask=
 0x408 (media error) <F>
> [56297.771358] ata25.00: status: { DRDY SENSE ERR }
> [56297.775986] ata25.00: error: { UNC }
> [56297.861641] ata25.00: configured for UDMA/133
> [56297.861658] sd 24:0:0:0: [sdc] tag#1 FAILED Result: hostbyte=3DDID=
_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56297.861661] sd 24:0:0:0: [sdc] tag#1 Sense Key : Medium Error [cur=
rent]=20
> [56297.861664] sd 24:0:0:0: [sdc] tag#1 Add. Sense: Unrecovered read =
error
> [56297.861666] sd 24:0:0:0: [sdc] tag#1 CDB: Read(16) 88 00 00 00 00 =
02 15 fb a0 70 00 00 00 08 00 00
> [56297.861668] critical medium error, dev sdc, sector 8958746736 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56297.871852] ata25: EH complete
> [56298.209332] md/raid:md127: read error corrected (8 sectors at 8958=
711920 on dm-1)
> [56305.006612] ata25.00: exception Emask 0x0 SAct 0x3f28f00 SErr 0x0 =
action 0x0
> [56305.013664] ata25.00: irq_stat 0x40000008
> [56305.017691] ata25.00: failed command: READ FPDMA QUEUED
> [56305.022937] ata25.00: cmd 60/00:78:00:90:15/05:00:16:02:00/40 tag =
15 ncq dma 655360 in
>                         res 43/40:00:40:93:15/00:05:16:02:00/00 Emask=
 0x408 (media error) <F>
> [56305.039048] ata25.00: status: { DRDY SENSE ERR }
> [56305.043677] ata25.00: error: { UNC }
> [56305.168764] ata25.00: configured for UDMA/133
> [56305.168820] sd 24:0:0:0: [sdc] tag#15 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56305.168824] sd 24:0:0:0: [sdc] tag#15 Sense Key : Medium Error [cu=
rrent]=20
> [56305.168826] sd 24:0:0:0: [sdc] tag#15 Add. Sense: Unrecovered read=
 error
> [56305.168828] sd 24:0:0:0: [sdc] tag#15 CDB: Read(16) 88 00 00 00 00=
 02 16 15 90 00 00 00 05 00 00 00
> [56305.168830] critical medium error, dev sdc, sector 8960446464 op 0=
x0:(READ) flags 0x80700 phys_seg 159 prio class 0
> [56305.179276] ata25: EH complete
> [56307.266729] ata25.00: exception Emask 0x0 SAct 0xec SErr 0x0 actio=
n 0x0
> [56307.273348] ata25.00: irq_stat 0x40000008
> [56307.277379] ata25.00: failed command: READ FPDMA QUEUED
> [56307.282614] ata25.00: cmd 60/40:10:00:9d:15/05:00:16:02:00/40 tag =
2 ncq dma 688128 in
>                         res 43/40:40:20:a1:15/00:05:16:02:00/00 Emask=
 0x408 (media error) <F>
> [56307.298638] ata25.00: status: { DRDY SENSE ERR }
> [56307.303270] ata25.00: error: { UNC }
> [56307.399985] ata25.00: configured for UDMA/133
> [56307.400014] sd 24:0:0:0: [sdc] tag#2 FAILED Result: hostbyte=3DDID=
_OK driverbyte=3DDRIVER_OK cmd_age=3D4s
> [56307.400017] sd 24:0:0:0: [sdc] tag#2 Sense Key : Medium Error [cur=
rent]=20
> [56307.400019] sd 24:0:0:0: [sdc] tag#2 Add. Sense: Unrecovered read =
error
> [56307.400021] sd 24:0:0:0: [sdc] tag#2 CDB: Read(16) 88 00 00 00 00 =
02 16 15 9d 00 00 00 05 40 00 00
> [56307.400023] critical medium error, dev sdc, sector 8960449792 op 0=
x0:(READ) flags 0x84700 phys_seg 168 prio class 0
> [56307.410470] ata25: EH complete
> [56310.075585] ata25.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action=
 0x0
> [56310.082119] ata25.00: irq_stat 0x40000008
> [56310.086146] ata25.00: failed command: READ FPDMA QUEUED
> [56310.091383] ata25.00: cmd 60/08:00:40:93:15/00:00:16:02:00/40 tag =
0 ncq dma 4096 in
>                         res 43/40:08:40:93:15/00:00:16:02:00/00 Emask=
 0x408 (media error) <F>
> [56310.107240] ata25.00: status: { DRDY SENSE ERR }
> [56310.111869] ata25.00: error: { UNC }
> [56310.249012] ata25.00: configured for UDMA/133
> [56310.249025] sd 24:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=3DDID=
_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56310.249028] sd 24:0:0:0: [sdc] tag#0 Sense Key : Medium Error [cur=
rent]=20
> [56310.249031] sd 24:0:0:0: [sdc] tag#0 Add. Sense: Unrecovered read =
error
> [56310.249033] sd 24:0:0:0: [sdc] tag#0 CDB: Read(16) 88 00 00 00 00 =
02 16 15 93 40 00 00 00 08 00 00
> [56310.249035] critical medium error, dev sdc, sector 8960447296 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56310.259210] ata25: EH complete
> [56312.894324] md/raid:md127: read error corrected (8 sectors at 8960=
412480 on dm-1)
> [56315.319228] ata25.00: exception Emask 0x0 SAct 0xe0000 SErr 0x0 ac=
tion 0x0
> [56315.326108] ata25.00: irq_stat 0x40000008
> [56315.330136] ata25.00: failed command: READ FPDMA QUEUED
> [56315.335376] ata25.00: cmd 60/08:88:20:a1:15/00:00:16:02:00/40 tag =
17 ncq dma 4096 in
>                         res 43/40:08:20:a1:15/00:00:16:02:00/00 Emask=
 0x408 (media error) <F>
> [56315.351313] ata25.00: status: { DRDY SENSE ERR }
> [56315.355946] ata25.00: error: { UNC }
> [56315.488843] ata25.00: configured for UDMA/133
> [56315.488853] sd 24:0:0:0: [sdc] tag#17 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56315.488856] sd 24:0:0:0: [sdc] tag#17 Sense Key : Medium Error [cu=
rrent]=20
> [56315.488857] sd 24:0:0:0: [sdc] tag#17 Add. Sense: Unrecovered read=
 error
> [56315.488859] sd 24:0:0:0: [sdc] tag#17 CDB: Read(16) 88 00 00 00 00=
 02 16 15 a1 20 00 00 00 08 00 00
> [56315.488861] critical medium error, dev sdc, sector 8960450848 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56315.499030] ata25: EH complete
> [56316.119276] md/raid:md127: read error corrected (8 sectors at 8960=
416032 on dm-1)
> [56324.775934] ata25.00: exception Emask 0x0 SAct 0x7000000f SErr 0x0=
 action 0x0
> [56324.783070] ata25.00: irq_stat 0x40000008
> [56324.787095] ata25.00: failed command: READ FPDMA QUEUED
> [56324.792337] ata25.00: cmd 60/c0:e0:68:ca:34/02:00:16:02:00/40 tag =
28 ncq dma 360448 in
>                         res 43/40:c0:88:cb:34/00:02:16:02:00/00 Emask=
 0x408 (media error) <F>
> [56324.808453] ata25.00: status: { DRDY SENSE ERR }
> [56324.813084] ata25.00: error: { UNC }
> [56324.935531] ata25.00: configured for UDMA/133
> [56324.935573] sd 24:0:0:0: [sdc] tag#28 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D5s
> [56324.935577] sd 24:0:0:0: [sdc] tag#28 Sense Key : Medium Error [cu=
rrent]=20
> [56324.935579] sd 24:0:0:0: [sdc] tag#28 Add. Sense: Unrecovered read=
 error
> [56324.935582] sd 24:0:0:0: [sdc] tag#28 CDB: Read(16) 88 00 00 00 00=
 02 16 34 ca 68 00 00 02 c0 00 00
> [56324.935583] critical medium error, dev sdc, sector 8962493032 op 0=
x0:(READ) flags 0x84700 phys_seg 88 prio class 0
> [56324.945933] ata25: EH complete
> [56327.568023] ata25.00: exception Emask 0x0 SAct 0x7f8001ff SErr 0x0=
 action 0x0
> [56327.575156] ata25.00: irq_stat 0x40000008
> [56327.579185] ata25.00: failed command: READ FPDMA QUEUED
> [56327.584415] ata25.00: cmd 60/08:b8:88:cb:34/00:00:16:02:00/40 tag =
23 ncq dma 4096 in
>                         res 43/40:08:88:cb:34/00:00:16:02:00/00 Emask=
 0x408 (media error) <F>
> [56327.600346] ata25.00: status: { DRDY SENSE ERR }
> [56327.604973] ata25.00: error: { UNC }
> [56327.692932] ata25.00: configured for UDMA/133
> [56327.692968] sd 24:0:0:0: [sdc] tag#23 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56327.692971] sd 24:0:0:0: [sdc] tag#23 Sense Key : Medium Error [cu=
rrent]=20
> [56327.692973] sd 24:0:0:0: [sdc] tag#23 Add. Sense: Unrecovered read=
 error
> [56327.692976] sd 24:0:0:0: [sdc] tag#23 CDB: Read(16) 88 00 00 00 00=
 02 16 34 cb 88 00 00 00 08 00 00
> [56327.692978] critical medium error, dev sdc, sector 8962493320 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56327.703153] ata25: EH complete
> [56330.009432] ata25.00: exception Emask 0x0 SAct 0xffffffff SErr 0x0=
 action 0x0
> [56330.016578] ata25.00: irq_stat 0x40000008
> [56330.020604] ata25.00: failed command: READ FPDMA QUEUED
> [56330.025845] ata25.00: cmd 60/08:b8:90:cb:34/00:00:16:02:00/40 tag =
23 ncq dma 4096 in
>                         res 43/40:08:90:cb:34/00:00:16:02:00/00 Emask=
 0x408 (media error) <F>
> [56330.041782] ata25.00: status: { DRDY SENSE ERR }
> [56330.046407] ata25.00: error: { UNC }
> [56330.142059] ata25.00: configured for UDMA/133
> [56330.142130] sd 24:0:0:0: [sdc] tag#23 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D4s
> [56330.142133] sd 24:0:0:0: [sdc] tag#23 Sense Key : Medium Error [cu=
rrent]=20
> [56330.142135] sd 24:0:0:0: [sdc] tag#23 Add. Sense: Unrecovered read=
 error
> [56330.142136] sd 24:0:0:0: [sdc] tag#23 CDB: Read(16) 88 00 00 00 00=
 02 16 34 cb 90 00 00 00 08 00 00
> [56330.142138] critical medium error, dev sdc, sector 8962493328 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56330.152328] ata25: EH complete
> [56330.473245] md/raid:md127: read error corrected (8 sectors at 8962=
458504 on dm-1)
> [56330.475305] md/raid:md127: read error corrected (8 sectors at 8962=
458512 on dm-1)
> [56381.913875] ata25.00: exception Emask 0x0 SAct 0x8 SErr 0x0 action=
 0x0
> [56381.920405] ata25.00: irq_stat 0x40000008
> [56381.924429] ata25.00: failed command: READ FPDMA QUEUED
> [56381.929664] ata25.00: cmd 60/00:18:00:d0:6b/05:00:16:02:00/40 tag =
3 ncq dma 655360 in
>                         res 43/40:00:18:d0:6b/00:05:16:02:00/00 Emask=
 0x408 (media error) <F>
> [56381.945685] ata25.00: status: { DRDY SENSE ERR }
> [56381.950313] ata25.00: error: { UNC }
> [56382.040583] ata25.00: configured for UDMA/133
> [56382.040598] sd 24:0:0:0: [sdc] tag#3 FAILED Result: hostbyte=3DDID=
_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56382.040601] sd 24:0:0:0: [sdc] tag#3 Sense Key : Medium Error [cur=
rent]=20
> [56382.040603] sd 24:0:0:0: [sdc] tag#3 Add. Sense: Unrecovered read =
error
> [56382.040605] sd 24:0:0:0: [sdc] tag#3 CDB: Read(16) 88 00 00 00 00 =
02 16 6b d0 00 00 00 05 00 00 00
> [56382.040606] critical medium error, dev sdc, sector 8966098944 op 0=
x0:(READ) flags 0x80700 phys_seg 160 prio class 0
> [56382.051045] ata25: EH complete
> [56384.109723] ata25.00: exception Emask 0x0 SAct 0x7fe00000 SErr 0x0=
 action 0x0
> [56384.116861] ata25.00: irq_stat 0x40000008
> [56384.120885] ata25.00: failed command: READ FPDMA QUEUED
> [56384.126117] ata25.00: cmd 60/40:a8:00:dd:6b/05:00:16:02:00/40 tag =
21 ncq dma 688128 in
>                         res 43/40:40:f8:dd:6b/00:05:16:02:00/00 Emask=
 0x408 (media error) <F>
> [56384.142231] ata25.00: status: { DRDY SENSE ERR }
> [56384.146862] ata25.00: error: { UNC }
> [56384.264767] ata25.00: configured for UDMA/133
> [56384.264806] sd 24:0:0:0: [sdc] tag#21 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56384.264809] sd 24:0:0:0: [sdc] tag#21 Sense Key : Medium Error [cu=
rrent]=20
> [56384.264810] sd 24:0:0:0: [sdc] tag#21 Add. Sense: Unrecovered read=
 error
> [56384.264812] sd 24:0:0:0: [sdc] tag#21 CDB: Read(16) 88 00 00 00 00=
 02 16 6b dd 00 00 00 05 40 00 00
> [56384.264813] critical medium error, dev sdc, sector 8966102272 op 0=
x0:(READ) flags 0x84700 phys_seg 168 prio class 0
> [56384.275275] ata25: EH complete
> [56386.346397] ata25.00: exception Emask 0x0 SAct 0x7f7d0 SErr 0x0 ac=
tion 0x0
> [56386.353275] ata25.00: irq_stat 0x40000008
> [56386.357302] ata25.00: failed command: READ FPDMA QUEUED
> [56386.362537] ata25.00: cmd 60/c0:30:40:ea:6b/02:00:16:02:00/40 tag =
6 ncq dma 360448 in
>                         res 43/40:c0:d8:eb:6b/00:02:16:02:00/00 Emask=
 0x408 (media error) <F>
> [56386.378556] ata25.00: status: { DRDY SENSE ERR }
> [56386.383185] ata25.00: error: { UNC }
> [56386.472369] ata25.00: configured for UDMA/133
> [56386.472430] sd 24:0:0:0: [sdc] tag#6 FAILED Result: hostbyte=3DDID=
_OK driverbyte=3DDRIVER_OK cmd_age=3D4s
> [56386.472433] sd 24:0:0:0: [sdc] tag#6 Sense Key : Medium Error [cur=
rent]=20
> [56386.472435] sd 24:0:0:0: [sdc] tag#6 Add. Sense: Unrecovered read =
error
> [56386.472438] sd 24:0:0:0: [sdc] tag#6 CDB: Read(16) 88 00 00 00 00 =
02 16 6b ea 40 00 00 02 c0 00 00
> [56386.472439] critical medium error, dev sdc, sector 8966105664 op 0=
x0:(READ) flags 0x84700 phys_seg 88 prio class 0
> [56386.482798] ata25: EH complete
> [56388.841034] ata25.00: exception Emask 0x0 SAct 0x80000041 SErr 0x0=
 action 0x0
> [56388.848169] ata25.00: irq_stat 0x40000008
> [56388.852195] ata25.00: failed command: READ FPDMA QUEUED
> [56388.857423] ata25.00: cmd 60/08:f8:18:d0:6b/00:00:16:02:00/40 tag =
31 ncq dma 4096 in
>                         res 43/40:08:18:d0:6b/00:00:16:02:00/00 Emask=
 0x408 (media error) <F>
> [56388.873364] ata25.00: status: { DRDY SENSE ERR }
> [56388.877996] ata25.00: error: { UNC }
> [56388.988119] ata25.00: configured for UDMA/133
> [56388.988136] sd 24:0:0:0: [sdc] tag#31 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56388.988139] sd 24:0:0:0: [sdc] tag#31 Sense Key : Medium Error [cu=
rrent]=20
> [56388.988141] sd 24:0:0:0: [sdc] tag#31 Add. Sense: Unrecovered read=
 error
> [56388.988142] sd 24:0:0:0: [sdc] tag#31 CDB: Read(16) 88 00 00 00 00=
 02 16 6b d0 18 00 00 00 08 00 00
> [56388.988143] critical medium error, dev sdc, sector 8966098968 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56388.998324] ata25: EH complete
> [56391.522804] ata25.00: exception Emask 0x0 SAct 0x1e9c179c SErr 0x0=
 action 0x0
> [56391.529945] ata25.00: irq_stat 0x40000008
> [56391.533976] ata25.00: failed command: READ FPDMA QUEUED
> [56391.539212] ata25.00: cmd 60/08:d8:20:d0:6b/00:00:16:02:00/40 tag =
27 ncq dma 4096 in
>                         res 43/40:08:20:d0:6b/00:00:16:02:00/00 Emask=
 0x408 (media error) <F>
> [56391.555146] ata25.00: status: { DRDY SENSE ERR }
> [56391.559778] ata25.00: error: { UNC }
> [56391.695556] ata25.00: configured for UDMA/133
> [56391.695634] sd 24:0:0:0: [sdc] tag#27 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D4s
> [56391.695637] sd 24:0:0:0: [sdc] tag#27 Sense Key : Medium Error [cu=
rrent]=20
> [56391.695639] sd 24:0:0:0: [sdc] tag#27 Add. Sense: Unrecovered read=
 error
> [56391.695642] sd 24:0:0:0: [sdc] tag#27 CDB: Read(16) 88 00 00 00 00=
 02 16 6b d0 20 00 00 00 08 00 00
> [56391.695643] critical medium error, dev sdc, sector 8966098976 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56391.705828] ata25: EH complete
> [56393.848207] ata25.00: exception Emask 0x0 SAct 0xf9fff8bf SErr 0x0=
 action 0x0
> [56393.855346] ata25.00: irq_stat 0x40000008
> [56393.859386] ata25.00: failed command: READ FPDMA QUEUED
> [56393.864624] ata25.00: cmd 60/c8:d8:48:3a:6e/02:00:16:02:00/40 tag =
27 ncq dma 364544 in
>                         res 43/40:c8:08:3b:6e/00:02:16:02:00/00 Emask=
 0x408 (media error) <F>
> [56393.880732] ata25.00: status: { DRDY SENSE ERR }
> [56393.885357] ata25.00: error: { UNC }
> [56393.986399] ata25.00: configured for UDMA/133
> [56393.986540] sd 24:0:0:0: [sdc] tag#27 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56393.986544] sd 24:0:0:0: [sdc] tag#27 Sense Key : Medium Error [cu=
rrent]=20
> [56393.986546] sd 24:0:0:0: [sdc] tag#27 Add. Sense: Unrecovered read=
 error
> [56393.986549] sd 24:0:0:0: [sdc] tag#27 CDB: Read(16) 88 00 00 00 00=
 02 16 6e 3a 48 00 00 02 c8 00 00
> [56393.986550] critical medium error, dev sdc, sector 8966257224 op 0=
x0:(READ) flags 0x80700 phys_seg 88 prio class 0
> [56393.996900] ata25: EH complete
> [56396.083820] md/raid:md127: read error corrected (8 sectors at 8966=
064160 on dm-1)
> [56396.083837] md/raid:md127: read error corrected (8 sectors at 8966=
064152 on dm-1)
> [56400.565346] ata25.00: exception Emask 0x0 SAct 0xfdfbf7df SErr 0x0=
 action 0x0
> [56400.572485] ata25.00: irq_stat 0x40000008
> [56400.576527] ata25.00: failed command: READ FPDMA QUEUED
> [56400.581758] ata25.00: cmd 60/08:60:08:3b:6e/00:00:16:02:00/40 tag =
12 ncq dma 4096 in
>                         res 43/40:08:08:3b:6e/00:00:16:02:00/00 Emask=
 0x408 (media error) <F>
> [56400.597695] ata25.00: status: { DRDY SENSE ERR }
> [56400.602329] ata25.00: error: { UNC }
> [56400.734083] ata25.00: configured for UDMA/133
> [56400.734136] sd 24:0:0:0: [sdc] tag#12 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56400.734139] sd 24:0:0:0: [sdc] tag#12 Sense Key : Medium Error [cu=
rrent]=20
> [56400.734142] sd 24:0:0:0: [sdc] tag#12 Add. Sense: Unrecovered read=
 error
> [56400.734144] sd 24:0:0:0: [sdc] tag#12 CDB: Read(16) 88 00 00 00 00=
 02 16 6e 3b 08 00 00 00 08 00 00
> [56400.734146] critical medium error, dev sdc, sector 8966257416 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56400.744333] ata25: EH complete
> [56401.189218] md/raid:md127: read error corrected (8 sectors at 8966=
222600 on dm-1)
> [56403.685654] ata25.00: exception Emask 0x0 SAct 0x701ffff0 SErr 0x0=
 action 0x0
> [56403.692794] ata25.00: irq_stat 0x40000008
> [56403.696816] ata25.00: failed command: READ FPDMA QUEUED
> [56403.702049] ata25.00: cmd 60/08:20:d8:eb:6b/00:00:16:02:00/40 tag =
4 ncq dma 4096 in
>                         res 43/40:08:d8:eb:6b/00:00:16:02:00/00 Emask=
 0x408 (media error) <F>
> [56403.717891] ata25.00: status: { DRDY SENSE ERR }
> [56403.722515] ata25.00: error: { UNC }
> [56403.833001] ata25.00: configured for UDMA/133
> [56403.833024] sd 24:0:0:0: [sdc] tag#4 FAILED Result: hostbyte=3DDID=
_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56403.833029] sd 24:0:0:0: [sdc] tag#4 Sense Key : Medium Error [cur=
rent]=20
> [56403.833032] sd 24:0:0:0: [sdc] tag#4 Add. Sense: Unrecovered read =
error
> [56403.833034] sd 24:0:0:0: [sdc] tag#4 CDB: Read(16) 88 00 00 00 00 =
02 16 6b eb d8 00 00 00 08 00 00
> [56403.833036] critical medium error, dev sdc, sector 8966106072 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56403.843247] ata25: EH complete
> [56406.373840] ata25.00: exception Emask 0x0 SAct 0x7f81fe6b SErr 0x0=
 action 0x0
> [56406.380972] ata25.00: irq_stat 0x40000008
> [56406.385004] ata25.00: failed command: READ FPDMA QUEUED
> [56406.390247] ata25.00: cmd 60/08:48:e0:eb:6b/00:00:16:02:00/40 tag =
9 ncq dma 4096 in
>                         res 43/40:08:e0:eb:6b/00:00:16:02:00/00 Emask=
 0x408 (media error) <F>
> [56406.406107] ata25.00: status: { DRDY SENSE ERR }
> [56406.410737] ata25.00: error: { UNC }
> [56406.507071] ata25.00: configured for UDMA/133
> [56406.507094] sd 24:0:0:0: [sdc] tag#9 FAILED Result: hostbyte=3DDID=
_OK driverbyte=3DDRIVER_OK cmd_age=3D4s
> [56406.507096] sd 24:0:0:0: [sdc] tag#9 Sense Key : Medium Error [cur=
rent]=20
> [56406.507098] sd 24:0:0:0: [sdc] tag#9 Add. Sense: Unrecovered read =
error
> [56406.507100] sd 24:0:0:0: [sdc] tag#9 CDB: Read(16) 88 00 00 00 00 =
02 16 6b eb e0 00 00 00 08 00 00
> [56406.507101] critical medium error, dev sdc, sector 8966106080 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56406.517282] ata25: EH complete
> [56408.531429] ata25.00: exception Emask 0x0 SAct 0xbfff87ff SErr 0x0=
 action 0x0
> [56408.538690] ata25.00: irq_stat 0x40000008
> [56408.542722] ata25.00: failed command: READ FPDMA QUEUED
> [56408.547952] ata25.00: cmd 60/08:78:f8:dd:6b/00:00:16:02:00/40 tag =
15 ncq dma 4096 in
>                         res 43/40:08:f8:dd:6b/00:00:16:02:00/00 Emask=
 0x408 (media error) <F>
> [56408.563920] ata25.00: status: { DRDY SENSE ERR }
> [56408.568559] ata25.00: error: { UNC }
> [56408.664647] ata25.00: configured for UDMA/133
> [56408.664684] sd 24:0:0:0: [sdc] tag#15 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56408.664687] sd 24:0:0:0: [sdc] tag#15 Sense Key : Medium Error [cu=
rrent]=20
> [56408.664689] sd 24:0:0:0: [sdc] tag#15 Add. Sense: Unrecovered read=
 error
> [56408.664690] sd 24:0:0:0: [sdc] tag#15 CDB: Read(16) 88 00 00 00 00=
 02 16 6b dd f8 00 00 00 08 00 00
> [56408.664692] critical medium error, dev sdc, sector 8966102520 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56408.674879] ata25: EH complete
> [56410.899004] md/raid:md127: read error corrected (8 sectors at 8966=
071256 on dm-1)
> [56410.899015] md/raid:md127: read error corrected (8 sectors at 8966=
071264 on dm-1)
> [56412.014769] md/raid:md127: read error corrected (8 sectors at 8966=
067704 on dm-1)
> [56419.657721] ata25.00: exception Emask 0x0 SAct 0x1eff1f SErr 0x0 a=
ction 0x0
> [56419.664684] ata25.00: irq_stat 0x40000008
> [56419.668729] ata25.00: failed command: READ FPDMA QUEUED
> [56419.673959] ata25.00: cmd 60/00:88:00:15:6c/08:00:16:02:00/40 tag =
17 ncq dma 1048576 in
>                         res 43/40:00:78:15:6c/00:08:16:02:00/00 Emask=
 0x408 (media error) <F>
> [56419.690151] ata25.00: status: { DRDY SENSE ERR }
> [56419.694787] ata25.00: error: { UNC }
> [56419.827430] ata25.00: configured for UDMA/133
> [56419.827504] sd 24:0:0:0: [sdc] tag#17 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56419.827507] sd 24:0:0:0: [sdc] tag#17 Sense Key : Medium Error [cu=
rrent]=20
> [56419.827509] sd 24:0:0:0: [sdc] tag#17 Add. Sense: Unrecovered read=
 error
> [56419.827510] sd 24:0:0:0: [sdc] tag#17 CDB: Read(16) 88 00 00 00 00=
 02 16 6c 15 00 00 00 08 00 00 00
> [56419.827511] critical medium error, dev sdc, sector 8966116608 op 0=
x0:(READ) flags 0x84700 phys_seg 29 prio class 0
> [56419.837858] ata25: EH complete
> [56421.908274] ata25.00: exception Emask 0x0 SAct 0x70e1847f SErr 0x0=
 action 0x0
> [56421.915411] ata25.00: irq_stat 0x40000008
> [56421.919444] ata25.00: failed command: READ FPDMA QUEUED
> [56421.924674] ata25.00: cmd 60/00:00:00:1d:6c/08:00:16:02:00/40 tag =
0 ncq dma 1048576 in
>                         res 43/40:00:50:23:6c/00:08:16:02:00/00 Emask=
 0x408 (media error) <F>
> [56421.940790] ata25.00: status: { DRDY SENSE ERR }
> [56421.945421] ata25.00: error: { UNC }
> [56422.051628] ata25.00: configured for UDMA/133
> [56422.051706] sd 24:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=3DDID=
_OK driverbyte=3DDRIVER_OK cmd_age=3D4s
> [56422.051710] sd 24:0:0:0: [sdc] tag#0 Sense Key : Medium Error [cur=
rent]=20
> [56422.051712] sd 24:0:0:0: [sdc] tag#0 Add. Sense: Unrecovered read =
error
> [56422.051714] sd 24:0:0:0: [sdc] tag#0 CDB: Read(16) 88 00 00 00 00 =
02 16 6c 1d 00 00 00 08 00 00 00
> [56422.051716] critical medium error, dev sdc, sector 8966118656 op 0=
x0:(READ) flags 0x84700 phys_seg 29 prio class 0
> [56422.062114] ata25: EH complete
> [56424.259349] ata25.00: exception Emask 0x0 SAct 0x6b1ffc08 SErr 0x0=
 action 0x0
> [56424.266486] ata25.00: irq_stat 0x40000008
> [56424.270517] ata25.00: failed command: READ FPDMA QUEUED
> [56424.275749] ata25.00: cmd 60/08:50:78:15:6c/00:00:16:02:00/40 tag =
10 ncq dma 4096 in
>                         res 43/40:08:78:15:6c/00:00:16:02:00/00 Emask=
 0x408 (media error) <F>
> [56424.291690] ata25.00: status: { DRDY SENSE ERR }
> [56424.296324] ata25.00: error: { UNC }
> [56424.384160] ata25.00: configured for UDMA/133
> [56424.384177] sd 24:0:0:0: [sdc] tag#10 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56424.384180] sd 24:0:0:0: [sdc] tag#10 Sense Key : Medium Error [cu=
rrent]=20
> [56424.384182] sd 24:0:0:0: [sdc] tag#10 Add. Sense: Unrecovered read=
 error
> [56424.384184] sd 24:0:0:0: [sdc] tag#10 CDB: Read(16) 88 00 00 00 00=
 02 16 6c 15 78 00 00 00 08 00 00
> [56424.384185] critical medium error, dev sdc, sector 8966116728 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56424.394369] ata25: EH complete
> [56424.599523] md/raid:md127: read error corrected (8 sectors at 8966=
081912 on dm-1)
> [56428.528870] ata25.00: exception Emask 0x0 SAct 0xff747eff SErr 0x0=
 action 0x0
> [56428.536009] ata25.00: irq_stat 0x40000008
> [56428.540060] ata25.00: failed command: READ FPDMA QUEUED
> [56428.545308] ata25.00: cmd 60/08:48:50:23:6c/00:00:16:02:00/40 tag =
9 ncq dma 4096 in
>                         res 43/40:08:50:23:6c/00:00:16:02:00/00 Emask=
 0x408 (media error) <F>
> [56428.561598] ata25.00: status: { DRDY SENSE ERR }
> [56428.566242] ata25.00: error: { UNC }
> [56428.690982] ata25.00: configured for UDMA/133
> [56428.691017] sd 24:0:0:0: [sdc] tag#9 FAILED Result: hostbyte=3DDID=
_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [56428.691020] sd 24:0:0:0: [sdc] tag#9 Sense Key : Medium Error [cur=
rent]=20
> [56428.691022] sd 24:0:0:0: [sdc] tag#9 Add. Sense: Unrecovered read =
error
> [56428.691023] sd 24:0:0:0: [sdc] tag#9 CDB: Read(16) 88 00 00 00 00 =
02 16 6c 23 50 00 00 00 08 00 00
> [56428.691025] critical medium error, dev sdc, sector 8966120272 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56428.701217] ata25: EH complete
> [56430.789563] ata25.00: exception Emask 0x0 SAct 0xffffffff SErr 0x0=
 action 0x0
> [56430.796699] ata25.00: irq_stat 0x40000008
> [56430.800724] ata25.00: failed command: READ FPDMA QUEUED
> [56430.805977] ata25.00: cmd 60/08:a0:58:23:6c/00:00:16:02:00/40 tag =
20 ncq dma 4096 in
>                         res 43/40:08:58:23:6c/00:00:16:02:00/00 Emask=
 0x408 (media error) <F>
> [56430.822085] ata25.00: status: { DRDY SENSE ERR }
> [56430.826719] ata25.00: error: { UNC }
> [56430.923535] ata25.00: configured for UDMA/133
> [56430.923604] sd 24:0:0:0: [sdc] tag#20 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D4s
> [56430.923607] sd 24:0:0:0: [sdc] tag#20 Sense Key : Medium Error [cu=
rrent]=20
> [56430.923608] sd 24:0:0:0: [sdc] tag#20 Add. Sense: Unrecovered read=
 error
> [56430.923610] sd 24:0:0:0: [sdc] tag#20 CDB: Read(16) 88 00 00 00 00=
 02 16 6c 23 58 00 00 00 08 00 00
> [56430.923611] critical medium error, dev sdc, sector 8966120280 op 0=
x0:(READ) flags 0x4000 phys_seg 1 prio class 0
> [56430.933789] ata25: EH complete
> [56431.464686] md/raid:md127: read error corrected (8 sectors at 8966=
085464 on dm-1)
> [56431.464684] md/raid:md127: read error corrected (8 sectors at 8966=
085456 on dm-1)
> [57881.912653] ata25.00: exception Emask 0x0 SAct 0x843ff807 SErr 0x0=
 action 0x0
> [57881.919808] ata25.00: irq_stat 0x40000008
> [57881.923835] ata25.00: failed command: READ FPDMA QUEUED
> [57881.929074] ata25.00: cmd 60/48:58:00:65:4c/05:00:1d:02:00/40 tag =
11 ncq dma 692224 in
>                         res 43/40:48:68:66:4c/00:05:1d:02:00/00 Emask=
 0x408 (media error) <F>
> [57881.945260] ata25.00: status: { DRDY SENSE ERR }
> [57881.949953] ata25.00: error: { UNC }
> [57882.041190] ata25.00: configured for UDMA/133
> [57882.041253] sd 24:0:0:0: [sdc] tag#11 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D3s
> [57882.041256] sd 24:0:0:0: [sdc] tag#11 Sense Key : Medium Error [cu=
rrent]=20
> [57882.041258] sd 24:0:0:0: [sdc] tag#11 Add. Sense: Data synchroniza=
tion mark error
> [57882.041260] sd 24:0:0:0: [sdc] tag#11 CDB: Read(16) 88 00 00 00 00=
 02 1d 4c 65 00 00 00 05 48 00 00
> [57882.041261] I/O error, dev sdc, sector 9081480448 op 0x0:(READ) fl=
ags 0x84700 phys_seg 168 prio class 0
> [57882.050685] ata25: EH complete
> [57885.724654] ata25.00: exception Emask 0x0 SAct 0xffffffff SErr 0x0=
 action 0x0
> [57885.731866] ata25.00: irq_stat 0x40000008
> [57885.735894] ata25.00: failed command: READ FPDMA QUEUED
> [57885.741217] ata25.00: cmd 60/08:20:68:66:4c/00:00:1d:02:00/40 tag =
4 ncq dma 4096 in
>                         res 43/40:08:68:66:4c/00:00:1d:02:00/00 Emask=
 0x408 (media error) <F>
> [57885.757076] ata25.00: status: { DRDY SENSE ERR }
> [57885.761721] ata25.00: error: { UNC }
> [57885.898142] ata25.00: configured for UDMA/133
> [57885.898197] ata25: EH complete
> [57888.362234] ata25.00: exception Emask 0x0 SAct 0xffffffff SErr 0x0=
 action 0x0
> [57888.369399] ata25.00: irq_stat 0x40000008
> [57888.373430] ata25.00: failed command: READ FPDMA QUEUED
> [57888.378665] ata25.00: cmd 60/08:60:68:66:4c/00:00:1d:02:00/40 tag =
12 ncq dma 4096 in
>                         res 43/40:08:68:66:4c/00:00:1d:02:00/00 Emask=
 0x408 (media error) <F>
> [57888.394601] ata25.00: status: { DRDY SENSE ERR }
> [57888.399243] ata25.00: error: { UNC }
> [57888.488931] ata25.00: configured for UDMA/133
> [57888.488992] ata25: EH complete
> [57891.013850] ata25.00: exception Emask 0x0 SAct 0xbffc00b6 SErr 0x0=
 action 0x0
> [57891.020998] ata25.00: irq_stat 0x40000008
> [57891.025037] ata25.00: failed command: READ FPDMA QUEUED
> [57891.030565] ata25.00: cmd 60/08:90:68:66:4c/00:00:1d:02:00/40 tag =
18 ncq dma 4096 in
>                         res 43/40:08:68:66:4c/00:00:1d:02:00/00 Emask=
 0x408 (media error) <F>
> [57891.046568] ata25.00: status: { DRDY SENSE ERR }
> [57891.051257] ata25.00: error: { UNC }
> [57891.154641] ata25.00: configured for UDMA/133
> [57891.154667] ata25: EH complete
> [57893.666329] ata25.00: exception Emask 0x0 SAct 0xffffffff SErr 0x0=
 action 0x0
> [57893.673470] ata25.00: irq_stat 0x40000008
> [57893.677495] ata25.00: failed command: READ FPDMA QUEUED
> [57893.682722] ata25.00: cmd 60/08:48:68:66:4c/00:00:1d:02:00/40 tag =
9 ncq dma 4096 in
>                         res 43/40:08:68:66:4c/00:00:1d:02:00/00 Emask=
 0x408 (media error) <F>
> [57893.698570] ata25.00: status: { DRDY SENSE ERR }
> [57893.703198] ata25.00: error: { UNC }
> [57893.795404] ata25.00: configured for UDMA/133
> [57893.795458] ata25: EH complete
> [57896.285432] ata25.00: exception Emask 0x0 SAct 0x3ffc0020 SErr 0x0=
 action 0x0
> [57896.292651] ata25.00: irq_stat 0x40000008
> [57896.296685] ata25.00: failed command: READ FPDMA QUEUED
> [57896.301920] ata25.00: cmd 60/08:90:68:66:4c/00:00:1d:02:00/40 tag =
18 ncq dma 4096 in
>                         res 43/40:08:68:66:4c/00:00:1d:02:00/00 Emask=
 0x408 (media error) <F>
> [57896.317965] ata25.00: status: { DRDY SENSE ERR }
> [57896.322722] ata25.00: error: { UNC }
> [57896.419495] ata25.00: configured for UDMA/133
> [57896.419516] ata25: EH complete
> [57898.960626] ata25.00: exception Emask 0x0 SAct 0xffffffff SErr 0x0=
 action 0x0
> [57898.967775] ata25.00: irq_stat 0x40000008
> [57898.971808] ata25.00: failed command: READ FPDMA QUEUED
> [57898.977066] ata25.00: cmd 60/08:70:68:66:4c/00:00:1d:02:00/40 tag =
14 ncq dma 4096 in
>                         res 43/40:08:68:66:4c/00:00:1d:02:00/00 Emask=
 0x408 (media error) <F>
> [57898.993042] ata25.00: status: { DRDY SENSE ERR }
> [57898.997677] ata25.00: error: { UNC }
> [57899.085209] ata25.00: configured for UDMA/133
> [57899.085258] sd 24:0:0:0: [sdc] tag#14 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D15s
> [57899.085260] sd 24:0:0:0: [sdc] tag#14 Sense Key : Medium Error [cu=
rrent]=20
> [57899.085262] sd 24:0:0:0: [sdc] tag#14 Add. Sense: Data synchroniza=
tion mark error
> [57899.085264] sd 24:0:0:0: [sdc] tag#14 CDB: Read(16) 88 00 00 00 00=
 02 1d 4c 66 68 00 00 00 08 00 00
> [57899.085265] I/O error, dev sdc, sector 9081480808 op 0x0:(READ) fl=
ags 0x4000 phys_seg 1 prio class 0
> [57899.094430] ata25: EH complete
> [57900.557539] md/raid:md127: read error corrected (8 sectors at 9081=
445992 on dm-1)
> [57903.266393] ata25.00: exception Emask 0x0 SAct 0x7fe0c3ff SErr 0x0=
 action 0x0
> [57903.273531] ata25.00: irq_stat 0x40000008
> [57903.277559] ata25.00: failed command: READ FPDMA QUEUED
> [57903.282790] ata25.00: cmd 60/10:a8:00:70:4c/05:00:1d:02:00/40 tag =
21 ncq dma 663552 in
>                         res 43/40:10:40:74:4c/00:05:1d:02:00/00 Emask=
 0x408 (media error) <F>
> [57903.298899] ata25.00: status: { DRDY SENSE ERR }
> [57903.303523] ata25.00: error: { UNC }
> [57903.433667] ata25.00: configured for UDMA/133
> [57903.433735] sd 24:0:0:0: [sdc] tag#21 FAILED Result: hostbyte=3DDI=
D_OK driverbyte=3DDRIVER_OK cmd_age=3D2s
> [57903.433738] sd 24:0:0:0: [sdc] tag#21 Sense Key : Medium Error [cu=
rrent]=20
> [57903.433740] sd 24:0:0:0: [sdc] tag#21 Add. Sense: Data synchroniza=
tion mark error
> [57903.433742] sd 24:0:0:0: [sdc] tag#21 CDB: Read(16) 88 00 00 00 00=
 02 1d 4c 70 00 00 00 05 10 00 00
> [57903.433743] I/O error, dev sdc, sector 9081483264 op 0x0:(READ) fl=
ags 0x80700 phys_seg 162 prio class 0
> [57903.443152] ata25: EH complete
> [57906.791480] ata25.00: exception Emask 0x0 SAct 0x7f0fffff SErr 0x0=
 action 0x0
> [57906.798705] ata25.00: irq_stat 0x40000008
> [57906.802742] ata25.00: failed command: READ FPDMA QUEUED
> [57906.807980] ata25.00: cmd 60/08:c0:40:74:4c/00:00:1d:02:00/40 tag =
24 ncq dma 4096 in
>                         res 43/40:08:40:74:4c/00:00:1d:02:00/00 Emask=
 0x408 (media error) <F>
> [57906.823914] ata25.00: status: { DRDY SENSE ERR }
> [57906.828540] ata25.00: error: { UNC }
> [57906.990783] ata25.00: configured for UDMA/133
> [57906.990830] ata25: EH complete
> [57909.373378] ata25.00: exception Emask 0x0 SAct 0x7800000f SErr 0x0=
 action 0x0
> [57909.380521] ata25.00: irq_stat 0x40000008
> [57909.384548] ata25.00: failed command: READ FPDMA QUEUED
> [57909.389785] ata25.00: cmd 60/08:e0:40:74:4c/00:00:1d:02:00/40 tag =
28 ncq dma 4096 in
>                         res 43/40:08:40:74:4c/00:00:1d:02:00/00 Emask=
 0x408 (media error) <F>
> [57909.405722] ata25.00: status: { DRDY SENSE ERR }
> [57909.410352] ata25.00: error: { UNC }
> [57909.548237] ata25.00: configured for UDMA/133
> [57909.548284] ata25: EH complete
> [57911.907322] ata25.00: exception Emask 0x0 SAct 0x7003feff SErr 0x0=
 action 0x0
> [57911.914465] ata25.00: irq_stat 0x40000008
> [57911.918490] ata25.00: failed command: READ FPDMA QUEUED
> [57911.923726] ata25.00: cmd 60/08:e8:40:74:4c/00:00:1d:02:00/40 tag =
29 ncq dma 4096 in
>                         res 43/40:08:40:74:4c/00:00:1d:02:00/00 Emask=
 0x408 (media error) <F>
> [57911.939665] ata25.00: status: { DRDY SENSE ERR }
> [57911.944297] ata25.00: error: { UNC }
> [57912.065349] ata25.00: configured for UDMA/133
> [57912.065458] ata25: EH complete
> [57914.457377] ata25.00: exception Emask 0x0 SAct 0xfff07fff SErr 0x0=
 action 0x0
> [57914.464516] ata25.00: irq_stat 0x40000008
> [57914.468545] ata25.00: failed command: READ FPDMA QUEUED
> [57914.473780] ata25.00: cmd 60/08:50:40:74:4c/00:00:1d:02:00/40 tag =
10 ncq dma 4096 in
>                         res 43/40:08:40:74:4c/00:00:1d:02:00/00 Emask=
 0x408 (media error) <F>
> [57914.489711] ata25.00: status: { DRDY SENSE ERR }
> [57914.494339] ata25.00: error: { UNC }
> [57914.614467] ata25.00: configured for UDMA/133
> [57914.614561] ata25: EH complete
> [57917.090724] ata25.00: exception Emask 0x0 SAct 0x7ffc3fff SErr 0x0=
 action 0x0
> [57917.097865] ata25.00: irq_stat 0x40000008
> [57917.101902] ata25.00: failed command: READ FPDMA QUEUED
> [57917.107138] ata25.00: cmd 60/08:e0:40:74:4c/00:00:1d:02:00/40 tag =
28 ncq dma 4096 in
>                         res 43/40:08:40:74:4c/00:00:1d:02:00/00 Emask=
 0x408 (media error) <F>
> [57917.123080] ata25.00: status: { DRDY SENSE ERR }
> [57917.127815] ata25.00: error: { UNC }
> [57917.246905] ata25.00: configured for UDMA/133
> [57917.247000] ata25: EH complete
> [57919.617397] ata25.00: exception Emask 0x0 SAct 0xfe7fc7ff SErr 0x0=
 action 0x0
> [57919.624542] ata25.00: irq_stat 0x40000008
> [57919.628570] ata25.00: failed command: READ FPDMA QUEUED
> [57919.633802] ata25.00: cmd 60/08:40:40:74:4c/00:00:1d:02:00/40 tag =
8 ncq dma 4096 in
>                         res 43/40:08:40:74:4c/00:00:1d:02:00/00 Emask=
 0x408 (media error) <F>
> [57919.649663] ata25.00: status: { DRDY SENSE ERR }
> [57919.654296] ata25.00: error: { UNC }
> [57919.769685] ata25.00: configured for UDMA/133
> [57919.769797] sd 24:0:0:0: [sdc] tag#8 FAILED Result: hostbyte=3DDID=
_OK driverbyte=3DDRIVER_OK cmd_age=3D15s
> [57919.769800] sd 24:0:0:0: [sdc] tag#8 Sense Key : Medium Error [cur=
rent]=20
> [57919.769803] sd 24:0:0:0: [sdc] tag#8 Add. Sense: Data synchronizat=
ion mark error
> [57919.769805] sd 24:0:0:0: [sdc] tag#8 CDB: Read(16) 88 00 00 00 00 =
02 1d 4c 74 40 00 00 00 08 00 00
> [57919.769807] I/O error, dev sdc, sector 9081484352 op 0x0:(READ) fl=
ags 0x4000 phys_seg 1 prio class 0
> [57919.778997] ata25: EH complete
> [57919.882467] md/raid:md127: read error corrected (8 sectors at 9081=
449536 on dm-1)
> [64266.546763] INFO: task btrfs-transacti:8202 blocked for more than =
122 seconds.
> [64266.553999]       Tainted: P           OE      6.10.5-arch1-1 #1
> [64266.560013] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" dis=
ables this message.
> [64266.567852] task:btrfs-transacti state:D stack:0     pid:8202  tgi=
d:8202  ppid:2      flags:0x00004000
> [64266.567855] Call Trace:
> [64266.567856]  <TASK>
> [64266.567858]  __schedule+0x3d5/0x1520
> [64266.567865]  schedule+0x27/0xf0
> [64266.567867]  wait_for_commit+0x11f/0x1d0 [btrfs 6037d5c3ca04912456=
b14a5819efacac8aa8a062]
> [64266.567898]  ? __pfx_autoremove_wake_function+0x10/0x10
> [64266.567902]  btrfs_commit_transaction+0xbb6/0xc80 [btrfs 6037d5c3c=
a04912456b14a5819efacac8aa8a062]
> [64266.567924]  transaction_kthread+0x159/0x1c0 [btrfs 6037d5c3ca0491=
2456b14a5819efacac8aa8a062]
> [64266.567943]  ? __pfx_transaction_kthread+0x10/0x10 [btrfs 6037d5c3=
ca04912456b14a5819efacac8aa8a062]
> [64266.567958]  kthread+0xcf/0x100
> [64266.567960]  ? __pfx_kthread+0x10/0x10
> [64266.567962]  ret_from_fork+0x31/0x50
> [64266.567964]  ? __pfx_kthread+0x10/0x10
> [64266.567966]  ret_from_fork_asm+0x1a/0x30
> [64266.567969]  </TASK>
> [64266.567998] INFO: task kworker/u64:57:96535 blocked for more than =
122 seconds.
> [64266.575240]       Tainted: P           OE      6.10.5-arch1-1 #1
> [64266.581256] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" dis=
ables this message.
> [64266.589077] task:kworker/u64:57  state:D stack:0     pid:96535 tgi=
d:96535 ppid:2      flags:0x00004000
> [64266.589080] Workqueue: writeback wb_workfn (flush-btrfs-1)
> [64266.589084] Call Trace:
> [64266.589085]  <TASK>
> [64266.589086]  __schedule+0x3d5/0x1520
> [64266.589091]  schedule+0x27/0xf0
> [64266.589093]  raid5_get_active_stripe+0x279/0x560 [raid456 b94de4f0=
8587c81d0c642257de3cb756cdaec135]
> [64266.589100]  ? __pfx_autoremove_wake_function+0x10/0x10
> [64266.589102]  raid5_make_request+0x20f/0x12a0 [raid456 b94de4f08587=
c81d0c642257de3cb756cdaec135]
> [64266.589107]  ? srso_alias_return_thunk+0x5/0xfbef5
> [64266.589109]  ? btrfs_add_ordered_sum+0x26/0x70 [btrfs 6037d5c3ca04=
912456b14a5819efacac8aa8a062]
> [64266.589133]  ? __pfx_woken_wake_function+0x10/0x10
> [64266.589139]  md_handle_request+0x154/0x270 [md_mod 5b42cb1736bc5b8=
27320e91152fa39660da047e7]
> [64266.589146]  ? srso_alias_return_thunk+0x5/0xfbef5
> [64266.589147]  __submit_bio+0x168/0x240
> [64266.589151]  submit_bio_noacct_nocheck+0x197/0x3e0
> [64266.589153]  btrfs_submit_chunk+0x1a9/0x6c0 [btrfs 6037d5c3ca04912=
456b14a5819efacac8aa8a062]
> [64266.589176]  ? srso_alias_return_thunk+0x5/0xfbef5
> [64266.589179]  btrfs_submit_bio+0x1a/0x30 [btrfs 6037d5c3ca04912456b=
14a5819efacac8aa8a062]
> [64266.589198]  submit_one_bio+0x36/0x50 [btrfs 6037d5c3ca04912456b14=
a5819efacac8aa8a062]
> [64266.589218]  submit_extent_page+0x104/0x290 [btrfs 6037d5c3ca04912=
456b14a5819efacac8aa8a062]
> [64266.589235]  ? folio_clear_dirty_for_io+0x121/0x190
> [64266.589237]  __extent_writepage_io+0x1e6/0x470 [btrfs 6037d5c3ca04=
912456b14a5819efacac8aa8a062]
> [64266.589254]  ? writepage_delalloc+0x83/0x150 [btrfs 6037d5c3ca0491=
2456b14a5819efacac8aa8a062]
> [64266.589271]  extent_write_cache_pages+0x281/0x850 [btrfs 6037d5c3c=
a04912456b14a5819efacac8aa8a062]
> [64266.589293]  btrfs_writepages+0x89/0x130 [btrfs 6037d5c3ca04912456=
b14a5819efacac8aa8a062]
> [64266.589310]  ? __pfx_end_bbio_data_write+0x10/0x10 [btrfs 6037d5c3=
ca04912456b14a5819efacac8aa8a062]
> [64266.589325]  do_writepages+0x7e/0x270
> [64266.589329]  __writeback_single_inode+0x41/0x340
> [64266.589331]  ? wbc_detach_inode+0x116/0x240
> [64266.589333]  writeback_sb_inodes+0x21c/0x4f0
> [64266.589341]  __writeback_inodes_wb+0x4c/0xf0
> [64266.589343]  wb_writeback+0x193/0x310
> [64266.589347]  wb_workfn+0x2a5/0x440
> [64266.589350]  process_one_work+0x17b/0x330
> [64266.589352]  worker_thread+0x2e2/0x410
> [64266.589354]  ? __pfx_worker_thread+0x10/0x10
> [64266.589355]  kthread+0xcf/0x100
> [64266.589357]  ? __pfx_kthread+0x10/0x10
> [64266.589359]  ret_from_fork+0x31/0x50
> [64266.589361]  ? __pfx_kthread+0x10/0x10
> [64266.589362]  ret_from_fork_asm+0x1a/0x30
> [64266.589366]  </TASK>
> [64266.589367] INFO: task kworker/u64:80:96615 blocked for more than =
122 seconds.
> [64266.596592]       Tainted: P           OE      6.10.5-arch1-1 #1
> [64266.602597] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" dis=
ables this message.
> [64266.610419] task:kworker/u64:80  state:D stack:0     pid:96615 tgi=
d:96615 ppid:2      flags:0x00004000
> [64266.610422] Workqueue: writeback wb_workfn (flush-btrfs-1)
> [64266.610424] Call Trace:
> [64266.610425]  <TASK>
> [64266.610426]  __schedule+0x3d5/0x1520
> [64266.610430]  schedule+0x27/0xf0
> [64266.610432]  raid5_get_active_stripe+0x279/0x560 [raid456 b94de4f0=
8587c81d0c642257de3cb756cdaec135]
> [64266.610436]  ? __pfx_autoremove_wake_function+0x10/0x10
> [64266.610439]  raid5_make_request+0x20f/0x12a0 [raid456 b94de4f08587=
c81d0c642257de3cb756cdaec135]
> [64266.610443]  ? srso_alias_return_thunk+0x5/0xfbef5
> [64266.610444]  ? btrfs_add_ordered_sum+0x26/0x70 [btrfs 6037d5c3ca04=
912456b14a5819efacac8aa8a062]
> [64266.610461]  ? __pfx_woken_wake_function+0x10/0x10
> [64266.610465]  md_handle_request+0x154/0x270 [md_mod 5b42cb1736bc5b8=
27320e91152fa39660da047e7]
> [64266.610469]  ? srso_alias_return_thunk+0x5/0xfbef5
> [64266.610471]  __submit_bio+0x168/0x240
> [64266.610473]  submit_bio_noacct_nocheck+0x197/0x3e0
> [64266.610476]  btrfs_submit_chunk+0x1a9/0x6c0 [btrfs 6037d5c3ca04912=
456b14a5819efacac8aa8a062]
> [64266.610495]  ? __extent_writepage_io+0x21f/0x470 [btrfs 6037d5c3ca=
04912456b14a5819efacac8aa8a062]
> [64266.610511]  btrfs_submit_bio+0x1a/0x30 [btrfs 6037d5c3ca04912456b=
14a5819efacac8aa8a062]
> [64266.610529]  submit_one_bio+0x36/0x50 [btrfs 6037d5c3ca04912456b14=
a5819efacac8aa8a062]
> [64266.610545]  extent_write_cache_pages+0x397/0x850 [btrfs 6037d5c3c=
a04912456b14a5819efacac8aa8a062]
> [64266.610565]  btrfs_writepages+0x89/0x130 [btrfs 6037d5c3ca04912456=
b14a5819efacac8aa8a062]
> [64266.610581]  ? __pfx_end_bbio_data_write+0x10/0x10 [btrfs 6037d5c3=
ca04912456b14a5819efacac8aa8a062]
> [64266.610597]  do_writepages+0x7e/0x270
> [64266.610600]  __writeback_single_inode+0x41/0x340
> [64266.610601]  ? wbc_detach_inode+0x116/0x240
> [64266.610604]  writeback_sb_inodes+0x21c/0x4f0
> [64266.610611]  __writeback_inodes_wb+0x4c/0xf0
> [64266.610614]  wb_writeback+0x193/0x310
> [64266.610617]  wb_workfn+0xc4/0x440
> [64266.610620]  process_one_work+0x17b/0x330
> [64266.610622]  worker_thread+0x2e2/0x410
> [64266.610624]  ? __pfx_worker_thread+0x10/0x10
> [64266.610625]  kthread+0xcf/0x100
> [64266.610627]  ? __pfx_kthread+0x10/0x10
> [64266.610629]  ret_from_fork+0x31/0x50
> [64266.610630]  ? __pfx_kthread+0x10/0x10
> [64266.610632]  ret_from_fork_asm+0x1a/0x30
> [64266.610635]  </TASK>
> [64266.610636] INFO: task kworker/u64:102:96624 blocked for more than=
 122 seconds.
> [64266.617953]       Tainted: P           OE      6.10.5-arch1-1 #1
> [64266.623962] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" dis=
ables this message.
> [64266.631784] task:kworker/u64:102 state:D stack:0     pid:96624 tgi=
d:96624 ppid:2      flags:0x00004000
> [64266.631786] Workqueue: writeback wb_workfn (flush-btrfs-1)
> [64266.631789] Call Trace:
> [64266.631790]  <TASK>
> [64266.631791]  __schedule+0x3d5/0x1520
> [64266.631795]  schedule+0x27/0xf0
> [64266.631797]  raid5_get_active_stripe+0x279/0x560 [raid456 b94de4f0=
8587c81d0c642257de3cb756cdaec135]
> [64266.631800]  ? __pfx_autoremove_wake_function+0x10/0x10
> [64266.631803]  raid5_make_request+0x20f/0x12a0 [raid456 b94de4f08587=
c81d0c642257de3cb756cdaec135]
> [64266.631807]  ? srso_alias_return_thunk+0x5/0xfbef5
> [64266.631808]  ? btrfs_add_ordered_sum+0x26/0x70 [btrfs 6037d5c3ca04=
912456b14a5819efacac8aa8a062]
> [64266.631824]  ? __pfx_woken_wake_function+0x10/0x10
> [64266.631828]  md_handle_request+0x154/0x270 [md_mod 5b42cb1736bc5b8=
27320e91152fa39660da047e7]
> [64266.631832]  ? srso_alias_return_thunk+0x5/0xfbef5
> [64266.631834]  __submit_bio+0x168/0x240
> [64266.631836]  submit_bio_noacct_nocheck+0x197/0x3e0
> [64266.631839]  btrfs_submit_chunk+0x1a9/0x6c0 [btrfs 6037d5c3ca04912=
456b14a5819efacac8aa8a062]
> [64266.631857]  ? srso_alias_return_thunk+0x5/0xfbef5
> [64266.631860]  btrfs_submit_bio+0x1a/0x30 [btrfs 6037d5c3ca04912456b=
14a5819efacac8aa8a062]
> [64266.631877]  submit_one_bio+0x36/0x50 [btrfs 6037d5c3ca04912456b14=
a5819efacac8aa8a062]
> [64266.631893]  submit_extent_page+0x104/0x290 [btrfs 6037d5c3ca04912=
456b14a5819efacac8aa8a062]
> [64266.631908]  ? folio_clear_dirty_for_io+0x121/0x190
> [64266.631910]  __extent_writepage_io+0x1e6/0x470 [btrfs 6037d5c3ca04=
912456b14a5819efacac8aa8a062]
> [64266.631926]  ? writepage_delalloc+0x83/0x150 [btrfs 6037d5c3ca0491=
2456b14a5819efacac8aa8a062]
> [64266.631942]  extent_write_cache_pages+0x281/0x850 [btrfs 6037d5c3c=
a04912456b14a5819efacac8aa8a062]
> [64266.631962]  btrfs_writepages+0x89/0x130 [btrfs 6037d5c3ca04912456=
b14a5819efacac8aa8a062]
> [64266.631978]  ? __pfx_end_bbio_data_write+0x10/0x10 [btrfs 6037d5c3=
ca04912456b14a5819efacac8aa8a062]
> [64266.631993]  do_writepages+0x7e/0x270
> [64266.631996]  __writeback_single_inode+0x41/0x340
> [64266.631998]  ? wbc_detach_inode+0x116/0x240
> [64266.632000]  writeback_sb_inodes+0x21c/0x4f0
> [64266.632007]  __writeback_inodes_wb+0x4c/0xf0
> [64266.632010]  wb_writeback+0x193/0x310
> [64266.632013]  wb_workfn+0x2a5/0x440
> [64266.632016]  process_one_work+0x17b/0x330
> [64266.632018]  worker_thread+0x2e2/0x410
> [64266.632020]  ? __pfx_worker_thread+0x10/0x10
> [64266.632021]  kthread+0xcf/0x100
> [64266.632023]  ? __pfx_kthread+0x10/0x10
> [64266.632025]  ret_from_fork+0x31/0x50
> [64266.632026]  ? __pfx_kthread+0x10/0x10
> [64266.632028]  ret_from_fork_asm+0x1a/0x30
> [64266.632031]  </TASK>
> [64266.632032] INFO: task kworker/u64:25:100536 blocked for more than=
 122 seconds.
> [64266.639341]       Tainted: P           OE      6.10.5-arch1-1 #1
> [64266.645348] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" dis=
ables this message.
> [64266.653171] task:kworker/u64:25  state:D stack:0     pid:100536 tg=
id:100536 ppid:2      flags:0x00004000
> [64266.653173] Workqueue: writeback wb_workfn (flush-btrfs-1)
> [64266.653175] Call Trace:
> [64266.653176]  <TASK>
> [64266.653177]  __schedule+0x3d5/0x1520
> [64266.653181]  schedule+0x27/0xf0
> [64266.653183]  raid5_get_active_stripe+0x279/0x560 [raid456 b94de4f0=
8587c81d0c642257de3cb756cdaec135]
> [64266.653187]  ? __pfx_autoremove_wake_function+0x10/0x10
> [64266.653189]  raid5_make_request+0x20f/0x12a0 [raid456 b94de4f08587=
c81d0c642257de3cb756cdaec135]
> [64266.653193]  ? srso_alias_return_thunk+0x5/0xfbef5
> [64266.653194]  ? btrfs_add_ordered_sum+0x26/0x70 [btrfs 6037d5c3ca04=
912456b14a5819efacac8aa8a062]
> [64266.653210]  ? __pfx_woken_wake_function+0x10/0x10
> [64266.653214]  md_handle_request+0x154/0x270 [md_mod 5b42cb1736bc5b8=
27320e91152fa39660da047e7]
> [64266.653218]  ? srso_alias_return_thunk+0x5/0xfbef5
> [64266.653220]  __submit_bio+0x168/0x240
> [64266.653222]  submit_bio_noacct_nocheck+0x197/0x3e0
> [64266.653225]  btrfs_submit_chunk+0x1a9/0x6c0 [btrfs 6037d5c3ca04912=
456b14a5819efacac8aa8a062]
> [64266.653244]  ? srso_alias_return_thunk+0x5/0xfbef5
> [64266.653246]  btrfs_submit_bio+0x1a/0x30 [btrfs 6037d5c3ca04912456b=
14a5819efacac8aa8a062]
> [64266.653264]  submit_one_bio+0x36/0x50 [btrfs 6037d5c3ca04912456b14=
a5819efacac8aa8a062]
> [64266.653279]  submit_extent_page+0x104/0x290 [btrfs 6037d5c3ca04912=
456b14a5819efacac8aa8a062]
> [64266.653295]  ? folio_clear_dirty_for_io+0x121/0x190
> [64266.653297]  __extent_writepage_io+0x1e6/0x470 [btrfs 6037d5c3ca04=
912456b14a5819efacac8aa8a062]
> [64266.653312]  ? writepage_delalloc+0x83/0x150 [btrfs 6037d5c3ca0491=
2456b14a5819efacac8aa8a062]
> [64266.653328]  extent_write_cache_pages+0x281/0x850 [btrfs 6037d5c3c=
a04912456b14a5819efacac8aa8a062]
> [64266.653348]  btrfs_writepages+0x89/0x130 [btrfs 6037d5c3ca04912456=
b14a5819efacac8aa8a062]
> [64266.653364]  ? __pfx_end_bbio_data_write+0x10/0x10 [btrfs 6037d5c3=
ca04912456b14a5819efacac8aa8a062]
> [64266.653381]  do_writepages+0x7e/0x270
> [64266.653383]  ? srso_alias_return_thunk+0x5/0xfbef5
> [64266.653385]  ? select_task_rq_fair+0x7f8/0x1da0
> [64266.653388]  __writeback_single_inode+0x41/0x340
> [64266.653390]  ? wbc_detach_inode+0x116/0x240
> [64266.653392]  writeback_sb_inodes+0x21c/0x4f0
> [64266.653399]  __writeback_inodes_wb+0x4c/0xf0
> [64266.653402]  wb_writeback+0x193/0x310
> [64266.653405]  wb_workfn+0xc4/0x440
> [64266.653408]  process_one_work+0x17b/0x330
> [64266.653410]  worker_thread+0x2e2/0x410
> [64266.653412]  ? __pfx_worker_thread+0x10/0x10
> [64266.653413]  kthread+0xcf/0x100
> [64266.653415]  ? __pfx_kthread+0x10/0x10
> [64266.653417]  ret_from_fork+0x31/0x50
> [64266.653418]  ? __pfx_kthread+0x10/0x10
> [64266.653420]  ret_from_fork_asm+0x1a/0x30
> [64266.653423]  </TASK>
> [64266.653424] INFO: task kworker/u64:52:101215 blocked for more than=
 122 seconds.
> [64266.660726]       Tainted: P           OE      6.10.5-arch1-1 #1
> [64266.666738] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" dis=
ables this message.
> [64266.674556] task:kworker/u64:52  state:D stack:0     pid:101215 tg=
id:101215 ppid:2      flags:0x00004000
> [64266.674558] Workqueue: writeback wb_workfn (flush-btrfs-1)
> [64266.674560] Call Trace:
> [64266.674561]  <TASK>
> [64266.674562]  __schedule+0x3d5/0x1520
> [64266.674566]  schedule+0x27/0xf0
> [64266.674568]  raid5_get_active_stripe+0x279/0x560 [raid456 b94de4f0=
8587c81d0c642257de3cb756cdaec135]
> [64266.674572]  ? __pfx_autoremove_wake_function+0x10/0x10
> [64266.674575]  raid5_make_request+0x20f/0x12a0 [raid456 b94de4f08587=
c81d0c642257de3cb756cdaec135]
> [64266.674579]  ? srso_alias_return_thunk+0x5/0xfbef5
> [64266.674580]  ? btrfs_add_ordered_sum+0x26/0x70 [btrfs 6037d5c3ca04=
912456b14a5819efacac8aa8a062]
> [64266.674596]  ? __pfx_woken_wake_function+0x10/0x10
> [64266.674599]  md_handle_request+0x154/0x270 [md_mod 5b42cb1736bc5b8=
27320e91152fa39660da047e7]
> [64266.674604]  ? srso_alias_return_thunk+0x5/0xfbef5
> [64266.674605]  __submit_bio+0x168/0x240
> [64266.674608]  submit_bio_noacct_nocheck+0x197/0x3e0
> [64266.674610]  btrfs_submit_chunk+0x1a9/0x6c0 [btrfs 6037d5c3ca04912=
456b14a5819efacac8aa8a062]
> [64266.674629]  ? srso_alias_return_thunk+0x5/0xfbef5
> [64266.674631]  btrfs_submit_bio+0x1a/0x30 [btrfs 6037d5c3ca04912456b=
14a5819efacac8aa8a062]
> [64266.674649]  submit_one_bio+0x36/0x50 [btrfs 6037d5c3ca04912456b14=
a5819efacac8aa8a062]
> [64266.674665]  submit_extent_page+0x104/0x290 [btrfs 6037d5c3ca04912=
456b14a5819efacac8aa8a062]
> [64266.674680]  ? folio_clear_dirty_for_io+0x121/0x190
> [64266.674682]  __extent_writepage_io+0x1e6/0x470 [btrfs 6037d5c3ca04=
912456b14a5819efacac8aa8a062]
> [64266.674697]  ? writepage_delalloc+0x83/0x150 [btrfs 6037d5c3ca0491=
2456b14a5819efacac8aa8a062]
> [64266.674713]  extent_write_cache_pages+0x281/0x850 [btrfs 6037d5c3c=
a04912456b14a5819efacac8aa8a062]
> [64266.674733]  btrfs_writepages+0x89/0x130 [btrfs 6037d5c3ca04912456=
b14a5819efacac8aa8a062]
> [64266.674748]  ? __pfx_end_bbio_data_write+0x10/0x10 [btrfs 6037d5c3=
ca04912456b14a5819efacac8aa8a062]
> [64266.674764]  do_writepages+0x7e/0x270
> [64266.674767]  __writeback_single_inode+0x41/0x340
> [64266.674769]  ? wbc_detach_inode+0x116/0x240
> [64266.674771]  writeback_sb_inodes+0x21c/0x4f0
> [64266.674778]  __writeback_inodes_wb+0x4c/0xf0
> [64266.674780]  wb_writeback+0x193/0x310
> [64266.674784]  wb_workfn+0x2a5/0x440
> [64266.674787]  process_one_work+0x17b/0x330
> [64266.674789]  worker_thread+0x2e2/0x410
> [64266.674791]  ? __pfx_worker_thread+0x10/0x10
> [64266.674792]  kthread+0xcf/0x100
> [64266.674794]  ? __pfx_kthread+0x10/0x10
> [64266.674795]  ret_from_fork+0x31/0x50
> [64266.674797]  ? __pfx_kthread+0x10/0x10
> [64266.674799]  ret_from_fork_asm+0x1a/0x30
> [64266.674802]  </TASK>
> [64266.674803] INFO: task kworker/u64:71:101293 blocked for more than=
 123 seconds.
> [64266.682113]       Tainted: P           OE      6.10.5-arch1-1 #1
> [64266.688120] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" dis=
ables this message.
> [64266.695943] task:kworker/u64:71  state:D stack:0     pid:101293 tg=
id:101293 ppid:2      flags:0x00004000
> [64266.695945] Workqueue: writeback wb_workfn (flush-btrfs-1)
> [64266.695948] Call Trace:
> [64266.695949]  <TASK>
> [64266.695950]  __schedule+0x3d5/0x1520
> [64266.695954]  schedule+0x27/0xf0
> [64266.695956]  raid5_get_active_stripe+0x279/0x560 [raid456 b94de4f0=
8587c81d0c642257de3cb756cdaec135]
> [64266.695960]  ? __pfx_autoremove_wake_function+0x10/0x10
> [64266.695962]  raid5_make_request+0x20f/0x12a0 [raid456 b94de4f08587=
c81d0c642257de3cb756cdaec135]
> [64266.695966]  ? __pfx_woken_wake_function+0x10/0x10
> [64266.695968]  ? srso_alias_return_thunk+0x5/0xfbef5
> [64266.695969]  ? blk_cgroup_bio_start+0x8c/0xd0
> [64266.695973]  md_handle_request+0x154/0x270 [md_mod 5b42cb1736bc5b8=
27320e91152fa39660da047e7]
> [64266.695978]  ? srso_alias_return_thunk+0x5/0xfbef5
> [64266.695979]  __submit_bio+0x168/0x240
> [64266.695982]  submit_bio_noacct_nocheck+0x197/0x3e0
> [64266.695985]  btrfs_submit_chunk+0x1a9/0x6c0 [btrfs 6037d5c3ca04912=
456b14a5819efacac8aa8a062]
> [64266.696003]  ? srso_alias_return_thunk+0x5/0xfbef5
> [64266.696005]  btrfs_submit_bio+0x1a/0x30 [btrfs 6037d5c3ca04912456b=
14a5819efacac8aa8a062]
> [64266.696023]  submit_one_bio+0x36/0x50 [btrfs 6037d5c3ca04912456b14=
a5819efacac8aa8a062]
> [64266.696038]  submit_extent_page+0x104/0x290 [btrfs 6037d5c3ca04912=
456b14a5819efacac8aa8a062]
> [64266.696054]  ? folio_clear_dirty_for_io+0x121/0x190
> [64266.696056]  __extent_writepage_io+0x1e6/0x470 [btrfs 6037d5c3ca04=
912456b14a5819efacac8aa8a062]
> [64266.696071]  ? writepage_delalloc+0x83/0x150 [btrfs 6037d5c3ca0491=
2456b14a5819efacac8aa8a062]
> [64266.696087]  extent_write_cache_pages+0x281/0x850 [btrfs 6037d5c3c=
a04912456b14a5819efacac8aa8a062]
> [64266.696107]  btrfs_writepages+0x89/0x130 [btrfs 6037d5c3ca04912456=
b14a5819efacac8aa8a062]
> [64266.696122]  ? __pfx_end_bbio_data_write+0x10/0x10 [btrfs 6037d5c3=
ca04912456b14a5819efacac8aa8a062]
> [64266.696138]  do_writepages+0x7e/0x270
> [64266.696141]  __writeback_single_inode+0x41/0x340
> [64266.696143]  ? wbc_detach_inode+0x116/0x240
> [64266.696145]  writeback_sb_inodes+0x21c/0x4f0
> [64266.696152]  __writeback_inodes_wb+0x4c/0xf0
> [64266.696155]  wb_writeback+0x193/0x310
> [64266.696158]  wb_workfn+0x34b/0x440
> [64266.696161]  process_one_work+0x17b/0x330
> [64266.696163]  worker_thread+0x2e2/0x410
> [64266.696165]  ? __pfx_worker_thread+0x10/0x10
> [64266.696166]  kthread+0xcf/0x100
> [64266.696168]  ? __pfx_kthread+0x10/0x10
> [64266.696169]  ret_from_fork+0x31/0x50
> [64266.696171]  ? __pfx_kthread+0x10/0x10
> [64266.696173]  ret_from_fork_asm+0x1a/0x30
> [64266.696176]  </TASK>
> [64266.696177] INFO: task kworker/u64:83:101621 blocked for more than=
 123 seconds.
> [64266.703487]       Tainted: P           OE      6.10.5-arch1-1 #1
> [64266.709494] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" dis=
ables this message.
> [64266.717308] task:kworker/u64:83  state:D stack:0     pid:101621 tg=
id:101621 ppid:2      flags:0x00004000
> [64266.717310] Workqueue: writeback wb_workfn (flush-btrfs-1)
> [64266.717313] Call Trace:
> [64266.717313]  <TASK>
> [64266.717315]  __schedule+0x3d5/0x1520
> [64266.717319]  schedule+0x27/0xf0
> [64266.717320]  raid5_get_active_stripe+0x279/0x560 [raid456 b94de4f0=
8587c81d0c642257de3cb756cdaec135]
> [64266.717324]  ? __pfx_autoremove_wake_function+0x10/0x10
> [64266.717327]  raid5_make_request+0x20f/0x12a0 [raid456 b94de4f08587=
c81d0c642257de3cb756cdaec135]
> [64266.717331]  ? srso_alias_return_thunk+0x5/0xfbef5
> [64266.717332]  ? btrfs_add_ordered_sum+0x26/0x70 [btrfs 6037d5c3ca04=
912456b14a5819efacac8aa8a062]
> [64266.717348]  ? __pfx_woken_wake_function+0x10/0x10
> [64266.717351]  md_handle_request+0x154/0x270 [md_mod 5b42cb1736bc5b8=
27320e91152fa39660da047e7]
> [64266.717356]  ? srso_alias_return_thunk+0x5/0xfbef5
> [64266.717357]  __submit_bio+0x168/0x240
> [64266.717360]  submit_bio_noacct_nocheck+0x197/0x3e0
> [64266.717363]  btrfs_submit_chunk+0x1a9/0x6c0 [btrfs 6037d5c3ca04912=
456b14a5819efacac8aa8a062]
> [64266.717381]  ? srso_alias_return_thunk+0x5/0xfbef5
> [64266.717383]  btrfs_submit_bio+0x1a/0x30 [btrfs 6037d5c3ca04912456b=
14a5819efacac8aa8a062]
> [64266.717401]  submit_one_bio+0x36/0x50 [btrfs 6037d5c3ca04912456b14=
a5819efacac8aa8a062]
> [64266.717416]  submit_extent_page+0x104/0x290 [btrfs 6037d5c3ca04912=
456b14a5819efacac8aa8a062]
> [64266.717432]  ? folio_clear_dirty_for_io+0x121/0x190
> [64266.717433]  __extent_writepage_io+0x1e6/0x470 [btrfs 6037d5c3ca04=
912456b14a5819efacac8aa8a062]
> [64266.717449]  ? writepage_delalloc+0x83/0x150 [btrfs 6037d5c3ca0491=
2456b14a5819efacac8aa8a062]
> [64266.717465]  extent_write_cache_pages+0x281/0x850 [btrfs 6037d5c3c=
a04912456b14a5819efacac8aa8a062]
> [64266.717485]  btrfs_writepages+0x89/0x130 [btrfs 6037d5c3ca04912456=
b14a5819efacac8aa8a062]
> [64266.717501]  ? __pfx_end_bbio_data_write+0x10/0x10 [btrfs 6037d5c3=
ca04912456b14a5819efacac8aa8a062]
> [64266.717516]  do_writepages+0x7e/0x270
> [64266.717518]  ? srso_alias_return_thunk+0x5/0xfbef5
> [64266.717519]  ? autoremove_wake_function+0x15/0x60
> [64266.717522]  __writeback_single_inode+0x41/0x340
> [64266.717523]  ? wbc_detach_inode+0x116/0x240
> [64266.717526]  writeback_sb_inodes+0x21c/0x4f0
> [64266.717533]  __writeback_inodes_wb+0x4c/0xf0
> [64266.717535]  wb_writeback+0x193/0x310
> [64266.717539]  wb_workfn+0x2a5/0x440
> [64266.717542]  process_one_work+0x17b/0x330
> [64266.717544]  worker_thread+0x2e2/0x410
> [64266.717546]  ? __pfx_worker_thread+0x10/0x10
> [64266.717547]  kthread+0xcf/0x100
> [64266.717548]  ? __pfx_kthread+0x10/0x10
> [64266.717550]  ret_from_fork+0x31/0x50
> [64266.717552]  ? __pfx_kthread+0x10/0x10
> [64266.717554]  ret_from_fork_asm+0x1a/0x30
> [64266.717557]  </TASK>
> [64266.717558] INFO: task kworker/u64:88:101623 blocked for more than=
 123 seconds.
> [64266.724865]       Tainted: P           OE      6.10.5-arch1-1 #1
> [64266.730873] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" dis=
ables this message.
> [64266.738691] task:kworker/u64:88  state:D stack:0     pid:101623 tg=
id:101623 ppid:2      flags:0x00004000
> [64266.738693] Workqueue: writeback wb_workfn (flush-btrfs-1)
> [64266.738695] Call Trace:
> [64266.738696]  <TASK>
> [64266.738697]  __schedule+0x3d5/0x1520
> [64266.738701]  schedule+0x27/0xf0
> [64266.738703]  raid5_get_active_stripe+0x279/0x560 [raid456 b94de4f0=
8587c81d0c642257de3cb756cdaec135]
> [64266.738707]  ? __pfx_autoremove_wake_function+0x10/0x10
> [64266.738709]  raid5_make_request+0x20f/0x12a0 [raid456 b94de4f08587=
c81d0c642257de3cb756cdaec135]
> [64266.738714]  ? srso_alias_return_thunk+0x5/0xfbef5
> [64266.738715]  ? btrfs_add_ordered_sum+0x26/0x70 [btrfs 6037d5c3ca04=
912456b14a5819efacac8aa8a062]
> [64266.738731]  ? __pfx_woken_wake_function+0x10/0x10
> [64266.738734]  md_handle_request+0x154/0x270 [md_mod 5b42cb1736bc5b8=
27320e91152fa39660da047e7]
> [64266.738739]  ? srso_alias_return_thunk+0x5/0xfbef5
> [64266.738740]  __submit_bio+0x168/0x240
> [64266.738743]  submit_bio_noacct_nocheck+0x197/0x3e0
> [64266.738745]  btrfs_submit_chunk+0x1a9/0x6c0 [btrfs 6037d5c3ca04912=
456b14a5819efacac8aa8a062]
> [64266.738764]  ? srso_alias_return_thunk+0x5/0xfbef5
> [64266.738766]  btrfs_submit_bio+0x1a/0x30 [btrfs 6037d5c3ca04912456b=
14a5819efacac8aa8a062]
> [64266.738788]  submit_one_bio+0x36/0x50 [btrfs 6037d5c3ca04912456b14=
a5819efacac8aa8a062]
> [64266.738804]  submit_extent_page+0x104/0x290 [btrfs 6037d5c3ca04912=
456b14a5819efacac8aa8a062]
> [64266.738819]  ? folio_clear_dirty_for_io+0x121/0x190
> [64266.738821]  __extent_writepage_io+0x1e6/0x470 [btrfs 6037d5c3ca04=
912456b14a5819efacac8aa8a062]
> [64266.738836]  ? writepage_delalloc+0x83/0x150 [btrfs 6037d5c3ca0491=
2456b14a5819efacac8aa8a062]
> [64266.738852]  extent_write_cache_pages+0x281/0x850 [btrfs 6037d5c3c=
a04912456b14a5819efacac8aa8a062]
> [64266.738872]  btrfs_writepages+0x89/0x130 [btrfs 6037d5c3ca04912456=
b14a5819efacac8aa8a062]
> [64266.738887]  ? __pfx_end_bbio_data_write+0x10/0x10 [btrfs 6037d5c3=
ca04912456b14a5819efacac8aa8a062]
> [64266.738902]  do_writepages+0x7e/0x270
> [64266.738905]  __writeback_single_inode+0x41/0x340
> [64266.738907]  ? wbc_detach_inode+0x116/0x240
> [64266.738909]  writeback_sb_inodes+0x21c/0x4f0
> [64266.738917]  __writeback_inodes_wb+0x4c/0xf0
> [64266.738919]  wb_writeback+0x193/0x310
> [64266.738922]  wb_workfn+0x2a5/0x440
> [64266.738926]  process_one_work+0x17b/0x330
> [64266.738928]  worker_thread+0x2e2/0x410
> [64266.738929]  ? __pfx_worker_thread+0x10/0x10
> [64266.738931]  kthread+0xcf/0x100
> [64266.738932]  ? __pfx_kthread+0x10/0x10
> [64266.738934]  ret_from_fork+0x31/0x50
> [64266.738936]  ? __pfx_kthread+0x10/0x10
> [64266.738937]  ret_from_fork_asm+0x1a/0x30
> [64266.738941]  </TASK>
> [64266.738942] INFO: task kworker/u64:108:102161 blocked for more tha=
n 123 seconds.
> [64266.746331]       Tainted: P           OE      6.10.5-arch1-1 #1
> [64266.752336] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" dis=
ables this message.
> [64266.760152] task:kworker/u64:108 state:D stack:0     pid:102161 tg=
id:102161 ppid:2      flags:0x00004000
> [64266.760154] Workqueue: writeback wb_workfn (flush-btrfs-1)
> [64266.760156] Call Trace:
> [64266.760157]  <TASK>
> [64266.760158]  __schedule+0x3d5/0x1520
> [64266.760162]  schedule+0x27/0xf0
> [64266.760164]  raid5_get_active_stripe+0x279/0x560 [raid456 b94de4f0=
8587c81d0c642257de3cb756cdaec135]
> [64266.760168]  ? __pfx_autoremove_wake_function+0x10/0x10
> [64266.760170]  raid5_make_request+0x20f/0x12a0 [raid456 b94de4f08587=
c81d0c642257de3cb756cdaec135]
> [64266.760175]  ? __pfx_woken_wake_function+0x10/0x10
> [64266.760176]  ? srso_alias_return_thunk+0x5/0xfbef5
> [64266.760177]  ? blk_cgroup_bio_start+0x8c/0xd0
> [64266.760181]  md_handle_request+0x154/0x270 [md_mod 5b42cb1736bc5b8=
27320e91152fa39660da047e7]
> [64266.760185]  ? srso_alias_return_thunk+0x5/0xfbef5
> [64266.760187]  __submit_bio+0x168/0x240
> [64266.760189]  submit_bio_noacct_nocheck+0x197/0x3e0
> [64266.760192]  btrfs_submit_chunk+0x1a9/0x6c0 [btrfs 6037d5c3ca04912=
456b14a5819efacac8aa8a062]
> [64266.760210]  ? srso_alias_return_thunk+0x5/0xfbef5
> [64266.760213]  btrfs_submit_bio+0x1a/0x30 [btrfs 6037d5c3ca04912456b=
14a5819efacac8aa8a062]
> [64266.760230]  submit_one_bio+0x36/0x50 [btrfs 6037d5c3ca04912456b14=
a5819efacac8aa8a062]
> [64266.760246]  submit_extent_page+0x104/0x290 [btrfs 6037d5c3ca04912=
456b14a5819efacac8aa8a062]
> [64266.760261]  ? folio_clear_dirty_for_io+0x121/0x190
> [64266.760263]  __extent_writepage_io+0x1e6/0x470 [btrfs 6037d5c3ca04=
912456b14a5819efacac8aa8a062]
> [64266.760278]  ? writepage_delalloc+0x83/0x150 [btrfs 6037d5c3ca0491=
2456b14a5819efacac8aa8a062]
> [64266.760294]  extent_write_cache_pages+0x281/0x850 [btrfs 6037d5c3c=
a04912456b14a5819efacac8aa8a062]
> [64266.760314]  btrfs_writepages+0x89/0x130 [btrfs 6037d5c3ca04912456=
b14a5819efacac8aa8a062]
> [64266.760330]  ? __pfx_end_bbio_data_write+0x10/0x10 [btrfs 6037d5c3=
ca04912456b14a5819efacac8aa8a062]
> [64266.760345]  do_writepages+0x7e/0x270
> [64266.760346]  ? srso_alias_return_thunk+0x5/0xfbef5
> [64266.760349]  __writeback_single_inode+0x41/0x340
> [64266.760351]  ? wbc_detach_inode+0x116/0x240
> [64266.760353]  writeback_sb_inodes+0x21c/0x4f0
> [64266.760360]  __writeback_inodes_wb+0x4c/0xf0
> [64266.760363]  wb_writeback+0x193/0x310
> [64266.760366]  wb_workfn+0x2a5/0x440
> [64266.760369]  process_one_work+0x17b/0x330
> [64266.760371]  worker_thread+0x2e2/0x410
> [64266.760373]  ? __pfx_worker_thread+0x10/0x10
> [64266.760374]  kthread+0xcf/0x100
> [64266.760376]  ? __pfx_kthread+0x10/0x10
> [64266.760378]  ret_from_fork+0x31/0x50
> [64266.760380]  ? __pfx_kthread+0x10/0x10
> [64266.760381]  ret_from_fork_asm+0x1a/0x30
> [64266.760385]  </TASK>
> [64266.760385] Future hung task reports are suppressed, see sysctl ke=
rnel.hung_task_warnings
> [85040.962654] systemd-coredump[137770]: Process 1259 (systemd-journa=
l) of user 0 terminated abnormally with signal 6/ABRT, processing...
> sda           8:0    0  14.6T  0 disk =20
> =E2=94=94=E2=94=80sda1        8:1    0  14.5T  0 part =20
>   =E2=94=94=E2=94=80c07     254:3    0  14.5T  0 crypt=20
>     =E2=94=94=E2=94=80md127   9:127  0 116.4T  0 raid6 /var/myhdd
> sdb           8:16   0  14.6T  0 disk =20
> =E2=94=94=E2=94=80sdb1        8:17   0  14.5T  0 part =20
>   =E2=94=94=E2=94=80c09     254:4    0  14.5T  0 crypt=20
>     =E2=94=94=E2=94=80md127   9:127  0 116.4T  0 raid6 /var/myhdd
> sdc           8:32   0  14.6T  0 disk =20
> =E2=94=94=E2=94=80sdc1        8:33   0  14.5T  0 part =20
>   =E2=94=94=E2=94=80c05     254:1    0  14.5T  0 crypt=20
>     =E2=94=94=E2=94=80md127   9:127  0 116.4T  0 raid6 /var/myhdd
> sdd           8:48   0  14.6T  0 disk =20
> =E2=94=94=E2=94=80sdd1        8:49   0  14.5T  0 part =20
>   =E2=94=94=E2=94=80c10     254:9    0  14.5T  0 crypt=20
>     =E2=94=94=E2=94=80md127   9:127  0 116.4T  0 raid6 /var/myhdd
> sde           8:64   0  14.6T  0 disk =20
> =E2=94=94=E2=94=80sde1        8:65   0  14.5T  0 part =20
>   =E2=94=94=E2=94=80c06     254:10   0  14.5T  0 crypt=20
>     =E2=94=94=E2=94=80md127   9:127  0 116.4T  0 raid6 /var/myhdd
> sdf           8:80   0  14.6T  0 disk =20
> =E2=94=94=E2=94=80sdf1        8:81   0  14.5T  0 part =20
>   =E2=94=94=E2=94=80c08     254:8    0  14.5T  0 crypt=20
>     =E2=94=94=E2=94=80md127   9:127  0 116.4T  0 raid6 /var/myhdd
> sdg           8:96   0  14.6T  0 disk =20
> =E2=94=94=E2=94=80sdg1        8:97   0  14.5T  0 part =20
>   =E2=94=94=E2=94=80c03     254:7    0  14.5T  0 crypt=20
>     =E2=94=94=E2=94=80md127   9:127  0 116.4T  0 raid6 /var/myhdd
> sdh           8:112  0  14.6T  0 disk =20
> =E2=94=94=E2=94=80sdh1        8:113  0  14.5T  0 part =20
>   =E2=94=94=E2=94=80c04     254:6    0  14.5T  0 crypt=20
>     =E2=94=94=E2=94=80md127   9:127  0 116.4T  0 raid6 /var/myhdd
> sdi           8:128  0  14.6T  0 disk =20
> =E2=94=94=E2=94=80sdi1        8:129  0  14.5T  0 part =20
>   =E2=94=94=E2=94=80c01     254:2    0  14.5T  0 crypt=20
>     =E2=94=94=E2=94=80md127   9:127  0 116.4T  0 raid6 /var/myhdd
> sdj           8:144  0  14.6T  0 disk =20
> =E2=94=94=E2=94=80sdj1        8:145  0  14.5T  0 part =20
>   =E2=94=94=E2=94=80c02     254:5    0  14.5T  0 crypt=20
>     =E2=94=94=E2=94=80md127   9:127  0 116.4T  0 raid6 /var/myhdd
> [root@coldnas ~]# cat /proc/mdstat=20
> Personalities : [raid6] [raid5] [raid4]=20
> md127 : active raid6 dm-10[5] dm-9[9] dm-8[7] dm-7[2] dm-6[3] dm-5[1]=
 dm-4[8] dm-3[6] dm-2[0] dm-1[4]
>       124972269568 blocks super 1.2 level 6, 4096k chunk, algorithm 2=
 [10/10] [UUUUUUUUUU]
>       bitmap: 3/117 pages [12KB], 65536KB chunk

> unused devices: <none>
> ps aux | grep "        D"
> root        8202  0.2  0.0      0     0 ?        D    Aug18   4:11 [b=
trfs-transaction]
> hasi        9117  0.4  0.0   4544  2628 ?        Ds   Aug18   6:33 /u=
sr/lib/ssh/sftp-server
> hasi        9143  0.4  0.0   4572  2756 ?        Ds   Aug18   6:37 /u=
sr/lib/ssh/sftp-server
> hasi        9180  1.1  0.0   4452  2796 ?        Ds   Aug18  16:56 /u=
sr/lib/ssh/sftp-server
> hasi       30949  0.4  0.0   4488  2556 ?        Ds   Aug18   4:55 /u=
sr/lib/ssh/sftp-server
> hasi       31971  0.3  0.0   4512  2628 ?        Ds   Aug18   4:30 /u=
sr/lib/ssh/sftp-server
> hasi       32277  0.3  0.0   4592  2580 ?        Ds   Aug18   4:30 /u=
sr/lib/ssh/sftp-server
> hasi       32379  0.3  0.0   4540  2692 ?        Ds   Aug18   3:58 /u=
sr/lib/ssh/sftp-server
> hasi       32694  0.3  0.0   4536  2976 ?        Ds   Aug18   3:54 /u=
sr/lib/ssh/sftp-server
> hasi       34038  0.2  0.0   4536  2736 ?        Ds   Aug18   2:59 /u=
sr/lib/ssh/sftp-server
> hasi       35651  0.2  0.0   4568  2556 ?        Ds   01:18   1:56 /u=
sr/lib/ssh/sftp-server
> hasi       35767  0.2  0.0   4604  2624 ?        Ds   01:21   2:03 /u=
sr/lib/ssh/sftp-server
> hasi       35771  0.2  0.0   4464  2556 ?        Ds   01:21   2:07 /u=
sr/lib/ssh/sftp-server
> hasi       35816  0.2  0.0   4512  2864 ?        Ds   01:22   2:07 /u=
sr/lib/ssh/sftp-server
> hasi       36497  0.2  0.0   4636  2864 ?        Ds   01:37   2:01 /u=
sr/lib/ssh/sftp-server
> hasi       36504  0.2  0.0   4548  2692 ?        Ds   01:37   2:06 /u=
sr/lib/ssh/sftp-server
> hasi       36511  0.2  0.0   4540  2864 ?        Ds   01:37   1:48 /u=
sr/lib/ssh/sftp-server
> hasi       43900  0.1  0.0   4456  2568 ?        Ds   02:47   1:36 /u=
sr/lib/ssh/sftp-server
> hasi       55877  0.1  0.0   4476  2756 ?        Ds   03:22   1:17 /u=
sr/lib/ssh/sftp-server
> hasi       55917  0.1  0.0   4516  2848 ?        Ds   03:24   1:16 /u=
sr/lib/ssh/sftp-server
> hasi       56055  0.1  0.0   4516  2456 ?        Ds   03:27   1:21 /u=
sr/lib/ssh/sftp-server
> hasi       56075  0.1  0.0   4380  2584 ?        Ds   03:28   1:26 /u=
sr/lib/ssh/sftp-server
> hasi       56086  0.1  0.0   4512  2712 ?        Ds   03:28   1:28 /u=
sr/lib/ssh/sftp-server
> hasi       56090  0.1  0.0   4556  2928 ?        Ds   03:28   1:28 /u=
sr/lib/ssh/sftp-server
> hasi       56231  0.1  0.0   4508  2752 ?        Ds   03:29   1:15 /u=
sr/lib/ssh/sftp-server
> hasi       57837  0.1  0.0   4408  2500 ?        Ds   03:33   1:15 /u=
sr/lib/ssh/sftp-server
> hasi       57840  0.1  0.0   4460  2944 ?        Ds   03:33   1:12 /u=
sr/lib/ssh/sftp-server
> hasi       85960  0.1  0.0   4552  2816 ?        Ds   05:00   1:03 /u=
sr/lib/ssh/sftp-server
> hasi       85967  0.1  0.0   4508  2648 ?        Ds   05:00   0:41 /u=
sr/lib/ssh/sftp-server
> hasi       85980  0.1  0.0   4520  2568 ?        Ds   05:00   0:55 /u=
sr/lib/ssh/sftp-server
> hasi       85985  0.1  0.0   4496  2784 ?        Ds   05:00   0:53 /u=
sr/lib/ssh/sftp-server
> root       96535  0.8  0.0      0     0 ?        D    05:35   5:46 [k=
worker/u64:57+flush-btrfs-1]
> root       96615  0.6  0.0      0     0 ?        D    05:35   4:33 [k=
worker/u64:80+flush-btrfs-1]
> root       96624  0.6  0.0      0     0 ?        D    05:35   4:31 [k=
worker/u64:102+flush-btrfs-1]
> root      100536  0.6  0.0      0     0 ?        D    05:53   4:25 [k=
worker/u64:25+flush-btrfs-1]
> root      101215  0.6  0.0      0     0 ?        D    05:57   3:56 [k=
worker/u64:52+flush-btrfs-1]
> root      101293  0.7  0.0      0     0 ?        D    05:57   4:53 [k=
worker/u64:71+flush-btrfs-1]
> root      101621  0.6  0.0      0     0 ?        D    05:59   3:56 [k=
worker/u64:83+flush-btrfs-1]
> root      101623  0.6  0.0      0     0 ?        D    05:59   3:57 [k=
worker/u64:88+flush-btrfs-1]
> root      102161  0.6  0.0      0     0 ?        D    06:01   3:55 [k=
worker/u64:108+flush-btrfs-1]
> root      103370  0.5  0.0      0     0 ?        D    06:08   3:43 [k=
worker/u64:144+flush-btrfs-1]
> root      108317  0.6  0.0      0     0 ?        D    06:30   3:48 [k=
worker/u64:24+flush-btrfs-1]
> root      109537  0.6  0.0      0     0 ?        D    06:37   3:40 [k=
worker/u64:4+flush-btrfs-1]
> root      109550  0.6  0.0      0     0 ?        D    06:37   3:42 [k=
worker/u64:26+flush-btrfs-1]
> root      109553  0.6  0.0      0     0 ?        D    06:37   3:41 [k=
worker/u64:32+flush-btrfs-1]
> root      109555  0.6  0.0      0     0 ?        D    06:37   3:42 [k=
worker/u64:34+flush-btrfs-1]
> root      109559  0.6  0.0      0     0 ?        D    06:37   3:42 [k=
worker/u64:42+flush-btrfs-1]
> root      109564  0.6  0.0      0     0 ?        D    06:37   3:42 [k=
worker/u64:48+flush-btrfs-1]
> root      115503  0.2  0.0      0     0 ?        D    07:37   1:26 [k=
worker/u64:6+flush-btrfs-1]
> root      118242  0.1  0.0      0     0 ?        D    08:08   0:47 [k=
worker/u64:68+flush-btrfs-1]
> root      119894  0.1  0.0      0     0 ?        D    08:22   0:36 [k=
worker/u64:14+flush-btrfs-1]
> root      120633  0.1  0.0      0     0 ?        D    08:28   0:43 [k=
worker/u64:5+flush-btrfs-1]
> root      120638  0.0  0.0      0     0 ?        D    08:28   0:20 [k=
worker/u64:23+flush-btrfs-1]
> root      120642  0.0  0.0      0     0 ?        D    08:28   0:28 [k=
worker/u64:35+flush-btrfs-1]
> root      122280  0.0  0.0      0     0 ?        D    08:36   0:20 [k=
worker/u64:0+flush-btrfs-1]
> root      122669  0.0  0.0      0     0 ?        D    08:39   0:11 [k=
worker/u64:79+flush-btrfs-1]
> root      123019  0.0  0.0      0     0 ?        D    08:42   0:27 [k=
worker/u64:85+blkcg_punt_bio]
> root      123028  0.0  0.0      0     0 ?        D    08:42   0:21 [k=
worker/u64:95+flush-btrfs-1]
> root      124094  0.0  0.0      0     0 ?        D    08:51   0:08 [k=
worker/u64:29+flush-btrfs-1]
> root      124101  0.0  0.0      0     0 ?        D    08:51   0:20 [k=
worker/u64:91+flush-btrfs-1]
> root      124177  0.0  0.0      0     0 ?        D    08:51   0:19 [k=
worker/u64:106+flush-btrfs-1]
> root      124418  0.0  0.0      0     0 ?        D    08:53   0:20 [k=
worker/u64:114+flush-btrfs-1]
> root      124423  0.0  0.0      0     0 ?        D    08:53   0:15 [k=
worker/u64:119+flush-btrfs-1]
> root      124428  0.0  0.0      0     0 ?        D    08:53   0:13 [k=
worker/u64:124+flush-btrfs-1]
> root      124628  0.0  0.0      0     0 ?        D    08:55   0:22 [k=
worker/u64:132+flush-btrfs-1]
> root      124629  0.0  0.0      0     0 ?        D    08:55   0:20 [k=
worker/u64:133+flush-btrfs-1]
> root      124630  0.0  0.0      0     0 ?        D    08:55   0:05 [k=
worker/u64:134+flush-btrfs-1]
> root      124633  0.0  0.0      0     0 ?        D    08:55   0:05 [k=
worker/u64:137+flush-btrfs-1]
> root      124636  0.0  0.0      0     0 ?        D    08:55   0:07 [k=
worker/u64:140+blkcg_punt_bio]
> root      124637  0.0  0.0      0     0 ?        D    08:55   0:23 [k=
worker/u64:141+flush-btrfs-1]
> work      125055  0.0  0.0 156020 22868 ?        Dl   08:59   0:15 sm=
bd: client [192.168.67.33]
> root      126064  0.0  0.0      0     0 ?        D    09:07   0:18 [k=
worker/u64:28+flush-btrfs-1]
> hasi      127483  0.0  0.0   2604  1776 ?        Ds   09:32   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127494  0.0  0.0   2604  1704 ?        Ds   09:32   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127501  0.0  0.0   2604  1688 ?        Ds   09:32   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127508  0.0  0.0   2604  1772 ?        Ds   09:32   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127520  0.0  0.0   2604  1804 ?        Ds   09:33   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127527  0.0  0.0   2604  1864 ?        Ds   09:33   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127543  0.0  0.0   2604  1732 ?        Ds   09:33   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127551  0.0  0.0   2604  1700 ?        Ds   09:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127558  0.0  0.0   2604  1916 ?        Ds   09:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127565  0.0  0.0   2604  1916 ?        Ds   09:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127572  0.0  0.0   2604  1700 ?        Ds   09:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127579  0.0  0.0   2604  1864 ?        Ds   09:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127600  0.0  0.0   2604  1688 ?        Ds   09:36   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127608  0.0  0.0   2604  1700 ?        Ds   09:36   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127617  0.0  0.0   2604  1732 ?        Ds   09:36   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127624  0.0  0.0   2604  1728 ?        Ds   09:37   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127631  0.0  0.0   2604  1908 ?        Ds   09:37   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127646  0.0  0.0   2604  1596 ?        Ds   09:37   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127654  0.0  0.0   2604  2044 ?        Ds   09:37   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127664  0.0  0.0   2604  1732 ?        Ds   09:37   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127676  0.0  0.0   2604  1752 ?        Ds   09:38   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127683  0.0  0.0   2604  1728 ?        Ds   09:38   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127701  0.0  0.0   2604  1776 ?        Ds   09:38   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127709  0.0  0.0   2604  1688 ?        Ds   09:39   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127716  0.0  0.0   2604  1872 ?        Ds   09:39   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127723  0.0  0.0   2604  1700 ?        Ds   09:39   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127730  0.0  0.0   2736  1960 ?        Ds   09:39   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127741  0.0  0.0   2604  1844 ?        Ds   09:39   0:00 /u=
sr/lib/ssh/sftp-server
> root      127746  0.0  0.0      0     0 ?        D    09:39   0:00 [k=
worker/u64:1+flush-btrfs-1]
> hasi      127760  0.0  0.0   2604  1704 ?        Ds   09:41   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127768  0.0  0.0   2604  1872 ?        Ds   09:41   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127777  0.0  0.0   2604  1944 ?        Ds   09:41   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127784  0.0  0.0   2604  1732 ?        Ds   09:42   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127791  0.0  0.0   2604  1712 ?        Ds   09:42   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127803  0.0  0.0   2604  1728 ?        Ds   09:42   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127811  0.0  0.0   2604  1596 ?        Ds   09:42   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127818  0.0  0.0   2604  1728 ?        Ds   09:42   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127830  0.0  0.0   2604  1776 ?        Ds   09:43   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127837  0.0  0.0   2604  1772 ?        Ds   09:43   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127848  0.0  0.0   2604  1728 ?        Ds   09:43   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127856  0.0  0.0   2604  1916 ?        Ds   09:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127863  0.0  0.0   2604  1916 ?        Ds   09:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127870  0.0  0.0   2604  1904 ?        Ds   09:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127878  0.0  0.0   2604  1700 ?        Ds   09:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127885  0.0  0.0   2604  1716 ?        Ds   09:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127899  0.0  0.0   2604  1864 ?        Ds   09:46   0:00 /u=
sr/lib/ssh/sftp-server
> root      127900  0.0  0.0      0     0 ?        D    09:46   0:00 [k=
worker/u64:2+flush-btrfs-1]
> hasi      127908  0.0  0.0   2604  1716 ?        Ds   09:46   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127917  0.0  0.0   2604  2072 ?        Ds   09:46   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127929  0.0  0.0   2604  1732 ?        Ds   09:47   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127936  0.0  0.0   2604  2000 ?        Ds   09:47   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127948  0.0  0.0   2604  1776 ?        Ds   09:47   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127956  0.0  0.0   2604  1688 ?        Ds   09:47   0:00 /u=
sr/lib/ssh/sftp-server
> root      127957  0.0  0.0      0     0 ?        D    09:47   0:00 [k=
worker/u64:3+flush-btrfs-1]
> root      127958  0.0  0.0      0     0 ?        D    09:47   0:00 [k=
worker/u64:7+flush-btrfs-1]
> hasi      127965  0.0  0.0   2604  1824 ?        Ds   09:47   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127980  0.0  0.0   2604  1704 ?        Ds   09:48   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      127987  0.0  0.0   2604  2016 ?        Ds   09:48   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128005  0.0  0.0   2604  1704 ?        Ds   09:48   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128013  0.0  0.0   2604  1752 ?        Ds   09:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128020  0.0  0.0   2604  1700 ?        Ds   09:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128027  0.0  0.0   2604  1732 ?        Ds   09:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128034  0.0  0.0   2604  1856 ?        Ds   09:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128043  0.0  0.0   2604  1776 ?        Ds   09:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128057  0.0  0.0   2604  1992 ?        Ds   09:51   0:00 /u=
sr/lib/ssh/sftp-server
> root      128062  0.0  0.0      0     0 ?        D    09:51   0:00 [k=
worker/u64:8+flush-btrfs-1]
> root      128063  0.0  0.0      0     0 ?        D    09:51   0:00 [k=
worker/u64:9+flush-btrfs-1]
> hasi      128071  0.0  0.0   2604  1916 ?        Ds   09:51   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128080  0.0  0.0   2604  1716 ?        Ds   09:51   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128087  0.0  0.0   2604  1864 ?        Ds   09:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128094  0.0  0.0   2604  1596 ?        Ds   09:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128104  0.0  0.0   2604  1776 ?        Ds   09:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128112  0.0  0.0   2604  1772 ?        Ds   09:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128119  0.0  0.0   2604  1688 ?        Ds   09:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128131  0.0  0.0   2604  1864 ?        Ds   09:53   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128138  0.0  0.0   2604  1944 ?        Ds   09:53   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128149  0.0  0.0   2604  1864 ?        Ds   09:53   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128157  0.0  0.0   2604  1804 ?        Ds   09:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128164  0.0  0.0   2604  1944 ?        Ds   09:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128171  0.0  0.0   2604  1880 ?        Ds   09:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128180  0.0  0.0   2604  1716 ?        Ds   09:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128187  0.0  0.0   2604  1596 ?        Ds   09:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128201  0.0  0.0   2604  1596 ?        Ds   09:56   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128209  0.0  0.0   2740  1904 ?        Ds   09:56   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128216  0.0  0.0   4408  3012 ?        Ds   09:56   0:00 /u=
sr/lib/ssh/sftp-server
> root      128217  0.0  0.0      0     0 ?        D    09:56   0:00 [k=
worker/u64:10+flush-btrfs-1]
> hasi      128228  0.0  0.0   2604  1728 ?        Ds   09:57   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128235  0.0  0.0   2604  2044 ?        Ds   09:57   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128246  0.0  0.0   2604  1844 ?        Ds   09:57   0:00 /u=
sr/lib/ssh/sftp-server
> root      128250  0.0  0.0      0     0 ?        D    09:57   0:00 [k=
worker/u64:11+flush-btrfs-1]
> hasi      128260  0.0  0.0   4408  2696 ?        Ds   09:57   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128263  0.0  0.0   2604  1688 ?        Ds   09:57   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128277  0.0  0.0   2604  1908 ?        Ds   09:58   0:00 /u=
sr/lib/ssh/sftp-server
> root      128282  0.0  0.0      0     0 ?        D    09:58   0:00 [k=
worker/u64:12+flush-btrfs-1]
> hasi      128289  0.0  0.0   2604  1752 ?        Ds   09:58   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128303  0.0  0.0   2604  1716 ?        Ds   09:58   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128306  0.0  0.0   4408  2752 ?        Ds   09:58   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128315  0.0  0.0   2604  1688 ?        Ds   09:59   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128322  0.0  0.0   2604  1864 ?        Ds   09:59   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128329  0.0  0.0   2604  2072 ?        Ds   09:59   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128338  0.0  0.0   2604  1728 ?        Ds   09:59   0:00 /u=
sr/lib/ssh/sftp-server
> root      128345  0.0  0.0      0     0 ?        D    10:00   0:00 [k=
worker/u64:13+flush-btrfs-1]
> hasi      128361  0.0  0.0   2604  2044 ?        Ds   10:01   0:00 /u=
sr/lib/ssh/sftp-server
> root      128364  0.0  0.0      0     0 ?        D    10:01   0:00 [k=
worker/u64:15+flush-btrfs-1]
> hasi      128372  0.0  0.0   2604  1772 ?        Ds   10:01   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128381  0.0  0.0   2604  1732 ?        Ds   10:01   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128390  0.0  0.0   4408  2752 ?        Ds   10:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128397  0.0  0.0   2604  1700 ?        Ds   10:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128400  0.0  0.0   2604  1688 ?        Ds   10:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128414  0.0  0.0   2604  1596 ?        Ds   10:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128421  0.0  0.0   2604  1728 ?        Ds   10:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128433  0.0  0.0   2604  1872 ?        Ds   10:03   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128440  0.0  0.0   2604  1772 ?        Ds   10:03   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128459  0.0  0.0   2604  1700 ?        Ds   10:03   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128466  0.0  0.0   2604  2044 ?        Ds   10:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128475  0.0  0.0   4456  2944 ?        Ds   10:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128485  0.0  0.0   2604  1688 ?        Ds   10:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128493  0.0  0.0   2604  1944 ?        Ds   10:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128500  0.0  0.0   2604  1804 ?        Ds   10:04   0:00 /u=
sr/lib/ssh/sftp-server
> root      128504  0.0  0.0      0     0 ?        D    10:05   0:00 [k=
worker/u64:16+flush-btrfs-1]
> hasi      128515  0.0  0.0   2604  1688 ?        Ds   10:06   0:00 /u=
sr/lib/ssh/sftp-server
> root      128516  0.0  0.0      0     0 ?        D    10:06   0:00 [k=
worker/u64:17+flush-btrfs-1]
> hasi      128524  0.0  0.0   2604  1916 ?        Ds   10:06   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128533  0.0  0.0   2604  1752 ?        Ds   10:06   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128540  0.0  0.0   2604  1732 ?        Ds   10:07   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128547  0.0  0.0   2604  2072 ?        Ds   10:07   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128560  0.0  0.0   2604  1688 ?        Ds   10:07   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128567  0.0  0.0   2604  1716 ?        Ds   10:07   0:00 /u=
sr/lib/ssh/sftp-server
> root      128572  0.0  0.0      0     0 ?        D    10:07   0:00 [k=
worker/u64:18+flush-btrfs-1]
> hasi      128576  0.0  0.0   2604  1716 ?        Ds   10:07   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128588  0.0  0.0   2604  2000 ?        Ds   10:08   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128599  0.0  0.0   2604  1900 ?        Ds   10:08   0:00 /u=
sr/lib/ssh/sftp-server
> root      128601  0.0  0.0      0     0 ?        D    10:08   0:00 [k=
worker/u64:19+flush-btrfs-1]
> hasi      128612  0.0  0.0   2604  1944 ?        Ds   10:08   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128619  0.0  0.0   2604  1728 ?        Ds   10:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128627  0.0  0.0   2604  1596 ?        Ds   10:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128634  0.0  0.0   2604  1700 ?        Ds   10:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128641  0.0  0.0   2604  1908 ?        Ds   10:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128650  0.0  0.0   2604  2016 ?        Ds   10:09   0:00 /u=
sr/lib/ssh/sftp-server
> root      128652  0.0  0.0      0     0 ?        D    10:09   0:00 [k=
worker/u64:20+flush-btrfs-1]
> root      128656  0.0  0.0      0     0 ?        D    10:10   0:00 [k=
worker/u64:21+flush-btrfs-1]
> hasi      128667  0.0  0.0   2604  1904 ?        Ds   10:11   0:00 /u=
sr/lib/ssh/sftp-server
> root      128670  0.0  0.0      0     0 ?        D    10:11   0:00 [k=
worker/u64:22+flush-btrfs-1]
> hasi      128678  0.0  0.0   2604  1688 ?        Ds   10:11   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128687  0.0  0.0   2604  1732 ?        Ds   10:11   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128694  0.0  0.0   2604  1752 ?        Ds   10:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128701  0.0  0.0   2604  1716 ?        Ds   10:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128711  0.0  0.0   2604  1596 ?        Ds   10:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128718  0.0  0.0   2604  1716 ?        Ds   10:12   0:00 /u=
sr/lib/ssh/sftp-server
> root      128724  0.0  0.0      0     0 ?        D    10:12   0:00 [k=
worker/u64:27+flush-btrfs-1]
> hasi      128727  0.0  0.0   2604  1864 ?        Ds   10:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128741  0.0  0.0   2604  1776 ?        Ds   10:13   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128748  0.0  0.0   2604  1596 ?        Ds   10:13   0:00 /u=
sr/lib/ssh/sftp-server
> root      128749  0.0  0.0      0     0 ?        D    10:13   0:00 [k=
worker/u64:30+flush-btrfs-1]
> hasi      128760  0.0  0.0   2604  1596 ?        Ds   10:13   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128767  0.0  0.0   2604  1908 ?        Ds   10:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128776  0.0  0.0   2604  1864 ?        Ds   10:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128786  0.0  0.0   2604  1688 ?        Ds   10:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128793  0.0  0.0   2604  1872 ?        Ds   10:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128800  0.0  0.0   2604  1772 ?        Ds   10:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128817  0.0  0.0   2604  1916 ?        Ds   10:16   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128825  0.0  0.0   2604  2072 ?        Ds   10:16   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128835  0.0  0.0   2604  2000 ?        Ds   10:16   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128843  0.0  0.0   2604  1704 ?        Ds   10:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128850  0.0  0.0   2604  1716 ?        Ds   10:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128860  0.0  0.0   2780  1904 ?        Ds   10:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128869  0.0  0.0   2604  1728 ?        Ds   10:17   0:00 /u=
sr/lib/ssh/sftp-server
> root      128871  0.0  0.0      0     0 ?        D    10:17   0:00 [k=
worker/u64:31+flush-btrfs-1]
> hasi      128878  0.0  0.0   2604  1916 ?        Ds   10:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128899  0.0  0.0   2604  1880 ?        Ds   10:18   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128907  0.0  0.0   2604  1944 ?        Ds   10:18   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128919  0.0  0.0   2604  1844 ?        Ds   10:18   0:00 /u=
sr/lib/ssh/sftp-server
> root      128922  0.0  0.0      0     0 ?        D    10:19   0:00 [k=
worker/u64:33+flush-btrfs-1]
> hasi      128929  0.0  0.0   2604  1752 ?        Ds   10:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128937  0.0  0.0   2604  1596 ?        Ds   10:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128944  0.0  0.0   2604  1716 ?        Ds   10:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128951  0.0  0.0   2604  1804 ?        Ds   10:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128958  0.0  0.0   2604  2072 ?        Ds   10:19   0:00 /u=
sr/lib/ssh/sftp-server
> root      128965  0.0  0.0      0     0 ?        D    10:20   0:00 [k=
worker/u64:36+flush-btrfs-1]
> hasi      128976  0.0  0.0   2604  1716 ?        Ds   10:21   0:00 /u=
sr/lib/ssh/sftp-server
> root      128977  0.0  0.0      0     0 ?        D    10:21   0:00 [k=
worker/u64:37+flush-btrfs-1]
> hasi      128985  0.0  0.0   2604  1772 ?        Ds   10:21   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      128994  0.0  0.0   2604  1916 ?        Ds   10:21   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129001  0.0  0.0   2604  1944 ?        Ds   10:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129008  0.0  0.0   2604  1916 ?        Ds   10:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129018  0.0  0.0   2604  1804 ?        Ds   10:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129025  0.0  0.0   2604  1704 ?        Ds   10:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129033  0.0  0.0   2604  1728 ?        Ds   10:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129045  0.0  0.0   2604  1688 ?        Ds   10:23   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129052  0.0  0.0   2604  1732 ?        Ds   10:23   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129063  0.0  0.0   2604  1872 ?        Ds   10:23   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129070  0.0  0.0   2604  1968 ?        Ds   10:24   0:00 /u=
sr/lib/ssh/sftp-server
> root      129074  0.0  0.0      0     0 ?        D    10:24   0:00 [k=
worker/u64:38+flush-btrfs-1]
> hasi      129082  0.0  0.0   2604  1804 ?        Ds   10:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129089  0.0  0.0   2604  1688 ?        Ds   10:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129096  0.0  0.0   2604  1716 ?        Ds   10:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129103  0.0  0.0   2604  1688 ?        Ds   10:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129117  0.0  0.0   2604  1732 ?        Ds   10:26   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129125  0.0  0.0   2604  2000 ?        Ds   10:26   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129139  0.0  0.0   2604  1776 ?        Ds   10:26   0:00 /u=
sr/lib/ssh/sftp-server
> work      129145  0.0  0.0  97816 22024 ?        Dl   10:26   0:00 sm=
bd: client [192.168.67.33]
> root      129161  0.0  0.0      0     0 ?        D    10:27   0:00 [k=
worker/u64:39+flush-btrfs-1]
> hasi      129168  0.0  0.0   2604  1716 ?        Ds   10:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129175  0.0  0.0   2604  1864 ?        Ds   10:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129185  0.0  0.0   2604  1864 ?        Ds   10:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129192  0.0  0.0   2604  1844 ?        Ds   10:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129203  0.0  0.0   2604  1688 ?        Ds   10:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129216  0.0  0.0   2604  1688 ?        Ds   10:28   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129223  0.0  0.0   2604  1992 ?        Ds   10:28   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129236  0.0  0.0   2604  2072 ?        Ds   10:28   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129246  0.0  0.0   2604  1596 ?        Ds   10:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129255  0.0  0.0   2604  1944 ?        Ds   10:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129262  0.0  0.0   2604  1716 ?        Ds   10:29   0:00 /u=
sr/lib/ssh/sftp-server
> root      129263  0.0  0.0      0     0 ?        D    10:29   0:00 [k=
worker/u64:40+flush-btrfs-1]
> hasi      129270  0.0  0.0   2604  1700 ?        Ds   10:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129277  0.0  0.0   2604  1772 ?        Ds   10:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129292  0.0  0.0   2604  1776 ?        Ds   10:31   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129300  0.0  0.0   2604  1732 ?        Ds   10:31   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129309  0.0  0.0   2604  1700 ?        Ds   10:31   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129319  0.0  0.0   2604  1880 ?        Ds   10:32   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129330  0.0  0.0   2604  1864 ?        Ds   10:32   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129341  0.0  0.0   2604  1688 ?        Ds   10:32   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129348  0.0  0.0   2604  1716 ?        Ds   10:32   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129355  0.0  0.0   2604  1772 ?        Ds   10:32   0:00 /u=
sr/lib/ssh/sftp-server
> root      129362  0.0  0.0      0     0 ?        D    10:33   0:00 [k=
worker/u64:41+flush-btrfs-1]
> hasi      129369  0.0  0.0   2604  1944 ?        Ds   10:33   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129376  0.0  0.0   2604  1776 ?        Ds   10:33   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129394  0.0  0.0   2604  1752 ?        Ds   10:33   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129401  0.0  0.0   2604  1864 ?        Ds   10:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129409  0.0  0.0   2604  1944 ?        Ds   10:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129416  0.0  0.0   2604  1900 ?        Ds   10:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129425  0.0  0.0   2604  1944 ?        Ds   10:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129432  0.0  0.0   2604  1728 ?        Ds   10:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129450  0.0  0.0   2604  1700 ?        Ds   10:36   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129458  0.0  0.0   2604  1856 ?        Ds   10:36   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129472  0.0  0.0   2604  1752 ?        Ds   10:36   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129479  0.0  0.0   2604  1732 ?        Ds   10:37   0:00 /u=
sr/lib/ssh/sftp-server
> root      129480  0.0  0.0      0     0 ?        D    10:37   0:00 [k=
worker/u64:43+flush-btrfs-1]
> hasi      129487  0.0  0.0   2604  1704 ?        Ds   10:37   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129497  0.0  0.0   2604  1732 ?        Ds   10:37   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129504  0.0  0.0   2604  1856 ?        Ds   10:37   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129512  0.0  0.0   2604  1700 ?        Ds   10:37   0:00 /u=
sr/lib/ssh/sftp-server
> root      129519  0.0  0.0      0     0 ?        D    10:38   0:00 [k=
worker/u64:44+flush-btrfs-1]
> hasi      129526  0.0  0.0   2604  2044 ?        Ds   10:38   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129535  0.0  0.0   2604  1752 ?        Ds   10:38   0:00 /u=
sr/lib/ssh/sftp-server
> root      129541  0.0  0.0      0     0 ?        D    10:38   0:00 [k=
worker/u64:45+flush-btrfs-1]
> hasi      129554  0.0  0.0   2736  1772 ?        Ds   10:38   0:00 /u=
sr/lib/ssh/sftp-server
> root      129560  0.0  0.0      0     0 ?        D    10:39   0:00 [k=
worker/u64:46+flush-btrfs-1]
> hasi      129567  0.0  0.0   2604  1916 ?        Ds   10:39   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129575  0.0  0.0   2604  1872 ?        Ds   10:39   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129582  0.0  0.0   2604  1688 ?        Ds   10:39   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129589  0.0  0.0   2604  1972 ?        Ds   10:39   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129597  0.0  0.0   2604  1596 ?        Ds   10:39   0:00 /u=
sr/lib/ssh/sftp-server
> root      129598  0.0  0.0      0     0 ?        D    10:39   0:00 [k=
worker/u64:47+flush-btrfs-1]
> root      129599  0.0  0.0      0     0 ?        D    10:39   0:00 [k=
worker/u64:49+flush-btrfs-1]
> hasi      129613  0.0  0.0   2604  1916 ?        Ds   10:41   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129622  0.0  0.0   2604  1728 ?        Ds   10:41   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129631  0.0  0.0   2604  1944 ?        Ds   10:41   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129638  0.0  0.0   2604  1960 ?        Ds   10:42   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129647  0.0  0.0   2604  1916 ?        Ds   10:42   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129657  0.0  0.0   2604  1776 ?        Ds   10:42   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129664  0.0  0.0   2604  1728 ?        Ds   10:42   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129671  0.0  0.0   2604  1716 ?        Ds   10:42   0:00 /u=
sr/lib/ssh/sftp-server
> root      129679  0.0  0.0      0     0 ?        D    10:43   0:00 [k=
worker/u64:50+flush-btrfs-1]
> hasi      129686  0.0  0.0   2604  1596 ?        Ds   10:43   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129693  0.0  0.0   2604  1596 ?        Ds   10:43   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129704  0.0  0.0   2604  1688 ?        Ds   10:43   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129711  0.0  0.0   2604  1864 ?        Ds   10:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129719  0.0  0.0   2604  1700 ?        Ds   10:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129726  0.0  0.0   2604  1944 ?        Ds   10:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129733  0.0  0.0   2604  1620 ?        Ds   10:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129740  0.0  0.0   2604  1864 ?        Ds   10:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129754  0.0  0.0   2604  1776 ?        Ds   10:46   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129763  0.0  0.0   2604  2000 ?        Ds   10:46   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129776  0.0  0.0   2604  2016 ?        Ds   10:46   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129784  0.0  0.0   2604  1696 ?        Ds   10:47   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129791  0.0  0.0   2604  2000 ?        Ds   10:47   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129803  0.0  0.0   2604  1716 ?        Ds   10:47   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129810  0.0  0.0   2604  1700 ?        Ds   10:47   0:00 /u=
sr/lib/ssh/sftp-server
> root      129811  0.0  0.0      0     0 ?        D    10:47   0:00 [k=
worker/u64:51+flush-btrfs-1]
> root      129812  0.0  0.0      0     0 ?        D    10:47   0:00 [k=
worker/u64:53+flush-btrfs-1]
> hasi      129819  0.0  0.0   2604  1688 ?        Ds   10:47   0:00 /u=
sr/lib/ssh/sftp-server
> root      129823  0.0  0.0      0     0 ?        D    10:47   0:00 [k=
worker/u64:54+flush-btrfs-1]
> hasi      129836  0.0  0.0   2604  1716 ?        Ds   10:48   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129843  0.0  0.0   2604  1856 ?        Ds   10:48   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129856  0.0  0.0   2604  1992 ?        Ds   10:48   0:00 /u=
sr/lib/ssh/sftp-server
> root      129861  0.0  0.0      0     0 ?        D    10:49   0:00 [k=
worker/u64:55+flush-btrfs-1]
> root      129862  0.0  0.0      0     0 ?        D    10:49   0:00 [k=
worker/u64:56+flush-btrfs-1]
> root      129863  0.0  0.0      0     0 ?        D    10:49   0:00 [k=
worker/u64:58+flush-btrfs-1]
> hasi      129870  0.0  0.0   2604  1688 ?        Ds   10:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129878  0.0  0.0   2604  1804 ?        Ds   10:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129885  0.0  0.0   2604  1872 ?        Ds   10:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129892  0.0  0.0   2604  1904 ?        Ds   10:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129902  0.0  0.0   2604  1688 ?        Ds   10:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129917  0.0  0.0   2604  1596 ?        Ds   10:51   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129925  0.0  0.0   2604  1772 ?        Ds   10:51   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129934  0.0  0.0   2604  1944 ?        Ds   10:51   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129941  0.0  0.0   2604  1776 ?        Ds   10:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129949  0.0  0.0   2604  1716 ?        Ds   10:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129958  0.0  0.0   2604  1596 ?        Ds   10:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129965  0.0  0.0   2604  1728 ?        Ds   10:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129972  0.0  0.0   2604  1752 ?        Ds   10:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129985  0.0  0.0   2604  1772 ?        Ds   10:53   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      129992  0.0  0.0   2604  1864 ?        Ds   10:53   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130004  0.0  0.0   2604  1864 ?        Ds   10:53   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130011  0.0  0.0   2604  1844 ?        Ds   10:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130020  0.0  0.0   2604  1732 ?        Ds   10:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130027  0.0  0.0   2604  1596 ?        Ds   10:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130034  0.0  0.0   2604  1752 ?        Ds   10:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130041  0.0  0.0   2604  1772 ?        Ds   10:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130055  0.0  0.0   2604  1700 ?        Ds   10:56   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130063  0.0  0.0   2604  1992 ?        Ds   10:56   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130079  0.0  0.0   2604  1916 ?        Ds   10:56   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130086  0.0  0.0   2604  1596 ?        Ds   10:57   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130097  0.0  0.0   2604  1688 ?        Ds   10:57   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130105  0.0  0.0   2604  1732 ?        Ds   10:57   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130109  0.0  0.0   2604  1752 ?        Ds   10:57   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130114  0.0  0.0   2604  1916 ?        Ds   10:57   0:00 /u=
sr/lib/ssh/sftp-server
> root      130127  0.0  0.0      0     0 ?        D    10:57   0:00 [k=
worker/u64:59+flush-btrfs-1]
> hasi      130138  0.0  0.0   2604  1716 ?        Ds   10:58   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130145  0.0  0.0   2604  1944 ?        Ds   10:58   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130156  0.0  0.0   2604  1900 ?        Ds   10:58   0:00 /u=
sr/lib/ssh/sftp-server
> root      130161  0.0  0.0      0     0 ?        D    10:59   0:00 [k=
worker/u64:60+flush-btrfs-1]
> hasi      130168  0.0  0.0   2604  1872 ?        Ds   10:59   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130176  0.0  0.0   2604  1916 ?        Ds   10:59   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130183  0.0  0.0   2604  1688 ?        Ds   10:59   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130190  0.0  0.0   2604  1832 ?        Ds   10:59   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130199  0.0  0.0   2604  1704 ?        Ds   10:59   0:00 /u=
sr/lib/ssh/sftp-server
> root      130206  0.0  0.0      0     0 ?        D    11:00   0:00 [k=
worker/u64:61+flush-btrfs-1]
> hasi      130222  0.0  0.0   2604  1776 ?        Ds   11:01   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130232  0.0  0.0   2604  1728 ?        Ds   11:01   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130239  0.0  0.0   2604  1772 ?        Ds   11:01   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130246  0.0  0.0   2604  1752 ?        Ds   11:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130254  0.0  0.0   2604  1716 ?        Ds   11:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130263  0.0  0.0   2604  1864 ?        Ds   11:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130270  0.0  0.0   2604  1872 ?        Ds   11:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130279  0.0  0.0   2604  1700 ?        Ds   11:02   0:00 /u=
sr/lib/ssh/sftp-server
> root      130281  0.0  0.0      0     0 ?        D    11:02   0:00 [k=
worker/u64:62+flush-btrfs-1]
> hasi      130291  0.0  0.0   2604  1772 ?        Ds   11:03   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130298  0.0  0.0   2604  1804 ?        Ds   11:03   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130310  0.0  0.0   2604  1772 ?        Ds   11:03   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130322  0.0  0.0   2604  1916 ?        Ds   11:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130332  0.0  0.0   2604  1864 ?        Ds   11:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130339  0.0  0.0   2604  1704 ?        Ds   11:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130349  0.0  0.0   2604  1700 ?        Ds   11:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130356  0.0  0.0   2604  1716 ?        Ds   11:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130370  0.0  0.0   2604  1864 ?        Ds   11:06   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130378  0.0  0.0   2604  1880 ?        Ds   11:06   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130391  0.0  0.0   2604  2016 ?        Ds   11:06   0:00 /u=
sr/lib/ssh/sftp-server
> root      130393  0.0  0.0      0     0 ?        D    11:07   0:00 [k=
worker/u64:63+flush-btrfs-1]
> root      130394  0.0  0.0      0     0 ?        D    11:07   0:00 [k=
worker/u64:64+flush-btrfs-1]
> hasi      130402  0.0  0.0   2604  1704 ?        Ds   11:07   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130410  0.0  0.0   2604  2072 ?        Ds   11:07   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130420  0.0  0.0   2604  1716 ?        Ds   11:07   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130427  0.0  0.0   2604  1700 ?        Ds   11:07   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130436  0.0  0.0   2604  1864 ?        Ds   11:07   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130448  0.0  0.0   2604  1904 ?        Ds   11:08   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130458  0.0  0.0   2604  1844 ?        Ds   11:08   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130470  0.0  0.0   2604  1856 ?        Ds   11:08   0:00 /u=
sr/lib/ssh/sftp-server
> root      130475  0.0  0.0      0     0 ?        D    11:09   0:00 [k=
worker/u64:65+flush-btrfs-1]
> hasi      130482  0.0  0.0   2604  1916 ?        Ds   11:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130490  0.0  0.0   2604  1688 ?        Ds   11:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130497  0.0  0.0   2604  1732 ?        Ds   11:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130504  0.0  0.0   2604  1872 ?        Ds   11:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130511  0.0  0.0   2604  1944 ?        Ds   11:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130525  0.0  0.0   2604  1716 ?        Ds   11:11   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130533  0.0  0.0   2604  1872 ?        Ds   11:11   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130542  0.0  0.0   2604  1716 ?        Ds   11:11   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130549  0.0  0.0   2604  1872 ?        Ds   11:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130557  0.0  0.0   2604  1804 ?        Ds   11:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130566  0.0  0.0   2604  1772 ?        Ds   11:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130573  0.0  0.0   2604  1728 ?        Ds   11:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130582  0.0  0.0   2604  1716 ?        Ds   11:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130593  0.0  0.0   2604  1864 ?        Ds   11:13   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130600  0.0  0.0   2604  1716 ?        Ds   11:13   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130611  0.0  0.0   2604  1776 ?        Ds   11:13   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130618  0.0  0.0   2604  1900 ?        Ds   11:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130630  0.0  0.0   2604  1872 ?        Ds   11:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130637  0.0  0.0   2604  1700 ?        Ds   11:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130644  0.0  0.0   2604  1596 ?        Ds   11:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130651  0.0  0.0   2604  1872 ?        Ds   11:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130668  0.0  0.0   2604  1772 ?        Ds   11:16   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130676  0.0  0.0   2700  1988 ?        Ds   11:16   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130693  0.0  0.0   2604  1716 ?        Ds   11:16   0:00 /u=
sr/lib/ssh/sftp-server
> root      130694  0.0  0.0      0     0 ?        D    11:17   0:00 [k=
worker/u64:66+flush-btrfs-1]
> hasi      130701  0.0  0.0   2604  1864 ?        Ds   11:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130709  0.0  0.0   2604  1776 ?        Ds   11:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130718  0.0  0.0   2604  1716 ?        Ds   11:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130725  0.0  0.0   2604  1864 ?        Ds   11:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130734  0.0  0.0   2604  1776 ?        Ds   11:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130745  0.0  0.0   2604  1732 ?        Ds   11:18   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130752  0.0  0.0   2604  2072 ?        Ds   11:18   0:00 /u=
sr/lib/ssh/sftp-server
> root      130767  0.0  0.0      0     0 ?        D    11:18   0:00 [k=
worker/u64:67+flush-btrfs-1]
> hasi      130775  0.0  0.0   2604  1904 ?        Ds   11:18   0:00 /u=
sr/lib/ssh/sftp-server
> root      130781  0.0  0.0      0     0 ?        D    11:19   0:00 [k=
worker/u64:69+flush-btrfs-1]
> hasi      130788  0.0  0.0   2604  1716 ?        Ds   11:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130796  0.0  0.0   2604  1864 ?        Ds   11:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130803  0.0  0.0   2604  1776 ?        Ds   11:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130810  0.0  0.0   2604  1944 ?        Ds   11:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130817  0.0  0.0   2604  1916 ?        Ds   11:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130831  0.0  0.0   2604  1704 ?        Ds   11:21   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130841  0.0  0.0   2604  1944 ?        Ds   11:21   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130848  0.0  0.0   2604  1944 ?        Ds   11:21   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130855  0.0  0.0   2604  1828 ?        Ds   11:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130870  0.0  0.0   2604  1872 ?        Ds   11:22   0:00 /u=
sr/lib/ssh/sftp-server
> root      130871  0.0  0.0      0     0 ?        D    11:22   0:00 [k=
worker/u64:70+flush-btrfs-1]
> hasi      130880  0.0  0.0   2604  1688 ?        Ds   11:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130887  0.0  0.0   2604  1776 ?        Ds   11:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130896  0.0  0.0   2604  1804 ?        Ds   11:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130907  0.0  0.0   2604  1752 ?        Ds   11:23   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130914  0.0  0.0   2604  1728 ?        Ds   11:23   0:00 /u=
sr/lib/ssh/sftp-server
> root      130915  0.0  0.0      0     0 ?        D    11:23   0:00 [k=
worker/u64:72+flush-btrfs-1]
> hasi      130926  0.0  0.0   2604  1732 ?        Ds   11:23   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130933  0.0  0.0   2604  1596 ?        Ds   11:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130944  0.0  0.0   4408  2808 ?        Ds   11:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130947  0.0  0.0   2604  1872 ?        Ds   11:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130955  0.0  0.0   2604  1728 ?        Ds   11:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130962  0.0  0.0   2604  1872 ?        Ds   11:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130977  0.0  0.0   2604  1804 ?        Ds   11:26   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130985  0.0  0.0   2604  1900 ?        Ds   11:26   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      130995  0.0  0.0   2604  1704 ?        Ds   11:26   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131024  0.0  0.0   2604  1716 ?        Ds   11:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131031  0.0  0.0   2604  1804 ?        Ds   11:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131040  0.0  0.0   2676  1904 ?        Ds   11:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131048  0.0  0.0   2604  1904 ?        Ds   11:27   0:00 /u=
sr/lib/ssh/sftp-server
> root      131064  0.0  0.0      0     0 ?        D    11:27   0:00 [k=
worker/u64:73+flush-btrfs-1]
> hasi      131065  0.0  0.0   2604  1688 ?        Ds   11:27   0:00 /u=
sr/lib/ssh/sftp-server
> root      131067  0.0  0.0      0     0 ?        D    11:27   0:00 [k=
worker/u64:74+flush-btrfs-1]
> hasi      131077  0.0  0.0   2604  2044 ?        Ds   11:28   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131085  0.0  0.0   2604  1804 ?        Ds   11:28   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131096  0.0  0.0   2604  1752 ?        Ds   11:28   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131103  0.0  0.0   2604  1916 ?        Ds   11:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131112  0.0  0.0   2604  1916 ?        Ds   11:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131119  0.0  0.0   2604  1804 ?        Ds   11:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131126  0.0  0.0   2604  1704 ?        Ds   11:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131133  0.0  0.0   2676  2000 ?        Ds   11:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131150  0.0  0.0   2604  1752 ?        Ds   11:31   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131158  0.0  0.0   2604  1872 ?        Ds   11:31   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131167  0.0  0.0   2604  1596 ?        Ds   11:31   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131178  0.0  0.0   2604  1844 ?        Ds   11:32   0:00 /u=
sr/lib/ssh/sftp-server
> root      131184  0.0  0.0      0     0 ?        D    11:32   0:00 [k=
worker/u64:75+flush-btrfs-1]
> hasi      131191  0.0  0.0   2604  1944 ?        Ds   11:32   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131200  0.0  0.0   2604  1596 ?        Ds   11:32   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131207  0.0  0.0   2604  1916 ?        Ds   11:32   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131216  0.0  0.0   2604  1732 ?        Ds   11:32   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131227  0.0  0.0   2604  1728 ?        Ds   11:33   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131234  0.0  0.0   2604  1864 ?        Ds   11:33   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131250  0.0  0.0   2604  1716 ?        Ds   11:33   0:00 /u=
sr/lib/ssh/sftp-server
> root      131251  0.0  0.0      0     0 ?        D    11:34   0:00 [k=
worker/u64:76+flush-btrfs-1]
> hasi      131258  0.0  0.0   2604  2004 ?        Ds   11:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131267  0.0  0.0   2604  1916 ?        Ds   11:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131274  0.0  0.0   2604  1772 ?        Ds   11:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131281  0.0  0.0   2604  1728 ?        Ds   11:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131288  0.0  0.0   2604  1872 ?        Ds   11:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131301  0.0  0.0   2604  1728 ?        Ds   11:36   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131309  0.0  0.0   2604  1728 ?        Ds   11:36   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131318  0.0  0.0   2604  1872 ?        Ds   11:36   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131326  0.0  0.0   2604  1944 ?        Ds   11:37   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131333  0.0  0.0   2676  1844 ?        Ds   11:37   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131344  0.0  0.0   2604  1728 ?        Ds   11:37   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131351  0.0  0.0   2604  1880 ?        Ds   11:37   0:00 /u=
sr/lib/ssh/sftp-server
> root      131357  0.0  0.0      0     0 ?        D    11:37   0:00 [k=
worker/u64:77+flush-btrfs-1]
> hasi      131367  0.0  0.0   2604  1728 ?        Ds   11:37   0:00 /u=
sr/lib/ssh/sftp-server
> root      131372  0.0  0.0      0     0 ?        D    11:38   0:00 [k=
worker/u64:78+flush-btrfs-1]
> hasi      131379  0.0  0.0   2604  1944 ?        Ds   11:38   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131386  0.0  0.0   2604  1944 ?        Ds   11:38   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131397  0.0  0.0   2604  1804 ?        Ds   11:38   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131404  0.0  0.0   2604  1716 ?        Ds   11:39   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131412  0.0  0.0   2604  1704 ?        Ds   11:39   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131419  0.0  0.0   2604  1704 ?        Ds   11:39   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131426  0.0  0.0   2604  1900 ?        Ds   11:39   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131435  0.0  0.0   2604  1700 ?        Ds   11:39   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131456  0.0  0.0   2604  1904 ?        Ds   11:41   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131464  0.0  0.0   4408  2968 ?        Ds   11:41   0:00 /u=
sr/lib/ssh/sftp-server
> root      131465  0.0  0.0      0     0 ?        D    11:41   0:00 [k=
worker/u64:81+flush-btrfs-1]
> hasi      131476  0.0  0.0   2604  1700 ?        Ds   11:41   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131484  0.0  0.0   2604  2000 ?        Ds   11:42   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131495  0.0  0.0   2604  1728 ?        Ds   11:42   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131504  0.0  0.0   2604  1804 ?        Ds   11:42   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131511  0.0  0.0   2604  1776 ?        Ds   11:42   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131520  0.0  0.0   2604  1776 ?        Ds   11:42   0:00 /u=
sr/lib/ssh/sftp-server
> root      131522  0.0  0.0      0     0 ?        D    11:42   0:00 [k=
worker/u64:82+flush-btrfs-1]
> hasi      131532  0.0  0.0   2604  1944 ?        Ds   11:43   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131539  0.0  0.0   2604  1716 ?        Ds   11:43   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131550  0.0  0.0   2604  1704 ?        Ds   11:43   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131557  0.0  0.0   2604  1776 ?        Ds   11:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131565  0.0  0.0   2604  1864 ?        Ds   11:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131572  0.0  0.0   2604  1688 ?        Ds   11:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131579  0.0  0.0   2604  1716 ?        Ds   11:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131586  0.0  0.0   2604  1716 ?        Ds   11:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131600  0.0  0.0   2604  1864 ?        Ds   11:46   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131608  0.0  0.0   2604  1688 ?        Ds   11:46   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131617  0.0  0.0   2604  2000 ?        Ds   11:46   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131630  0.0  0.0   2604  1944 ?        Ds   11:47   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131637  0.0  0.0   2604  1700 ?        Ds   11:47   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131646  0.0  0.0   2604  2000 ?        Ds   11:47   0:00 /u=
sr/lib/ssh/sftp-server
> root      131654  0.0  0.0      0     0 ?        D    11:47   0:00 [k=
worker/u64:84+flush-btrfs-1]
> hasi      131655  0.0  0.0   2604  1904 ?        Ds   11:47   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131667  0.0  0.0   2604  1776 ?        Ds   11:47   0:00 /u=
sr/lib/ssh/sftp-server
> root      131674  0.0  0.0      0     0 ?        D    11:48   0:00 [k=
worker/u64:86+flush-btrfs-1]
> hasi      131681  0.0  0.0   2604  1716 ?        Ds   11:48   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131688  0.0  0.0   2604  1716 ?        Ds   11:48   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131700  0.0  0.0   2604  1776 ?        Ds   11:48   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131707  0.0  0.0   2604  1596 ?        Ds   11:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131715  0.0  0.0   2604  1716 ?        Ds   11:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131722  0.0  0.0   2604  1864 ?        Ds   11:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131729  0.0  0.0   2604  2072 ?        Ds   11:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131741  0.0  0.0   2604  1732 ?        Ds   11:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131757  0.0  0.0   2604  1844 ?        Ds   11:51   0:00 /u=
sr/lib/ssh/sftp-server
> root      131761  0.0  0.0      0     0 ?        D    11:51   0:00 [k=
worker/u64:87+flush-btrfs-1]
> hasi      131769  0.0  0.0   2604  1716 ?        Ds   11:51   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131778  0.0  0.0   2604  1752 ?        Ds   11:51   0:00 /u=
sr/lib/ssh/sftp-server
> root      131779  0.0  0.0      0     0 ?        D    11:52   0:00 [k=
worker/u64:89+flush-btrfs-1]
> hasi      131787  0.0  0.0   2604  1944 ?        Ds   11:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131794  0.0  0.0   2604  1728 ?        Ds   11:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131803  0.0  0.0   2604  1716 ?        Ds   11:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131810  0.0  0.0   2604  1596 ?        Ds   11:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131819  0.0  0.0   2604  1864 ?        Ds   11:52   0:00 /u=
sr/lib/ssh/sftp-server
> root      131822  0.0  0.0      0     0 ?        D    11:52   0:00 [k=
worker/u64:90+flush-btrfs-1]
> hasi      131831  0.0  0.0   2604  1804 ?        Ds   11:53   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131838  0.0  0.0   2604  1752 ?        Ds   11:53   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131849  0.0  0.0   2604  1596 ?        Ds   11:53   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131856  0.0  0.0   2604  1916 ?        Ds   11:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131864  0.0  0.0   2604  1728 ?        Ds   11:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131871  0.0  0.0   2604  1916 ?        Ds   11:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131878  0.0  0.0   2604  1944 ?        Ds   11:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131885  0.0  0.0   2604  1732 ?        Ds   11:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131900  0.0  0.0   2604  1728 ?        Ds   11:56   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131908  0.0  0.0   2604  1864 ?        Ds   11:56   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131917  0.0  0.0   2676  1828 ?        Ds   11:56   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131930  0.0  0.0   2604  1716 ?        Ds   11:57   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131937  0.0  0.0   2604  1772 ?        Ds   11:57   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131946  0.0  0.0   2604  2016 ?        Ds   11:57   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131956  0.0  0.0   2604  1716 ?        Ds   11:57   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131965  0.0  0.0   2604  1716 ?        Ds   11:57   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      131998  0.0  0.0   2604  1716 ?        Ds   11:58   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132005  0.0  0.0   2604  1872 ?        Ds   11:58   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132016  0.0  0.0   2604  1772 ?        Ds   11:58   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132023  0.0  0.0   2604  1908 ?        Ds   11:59   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132031  0.0  0.0   2604  1728 ?        Ds   11:59   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132038  0.0  0.0   2604  1804 ?        Ds   11:59   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132045  0.0  0.0   2604  1844 ?        Ds   11:59   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132057  0.0  0.0   2604  1716 ?        Ds   11:59   0:00 /u=
sr/lib/ssh/sftp-server
> root      132058  0.0  0.0      0     0 ?        D    11:59   0:00 [k=
worker/u64:92+flush-btrfs-1]
> hasi      132080  0.0  0.0   2604  1908 ?        Ds   12:01   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132093  0.0  0.0   2604  1916 ?        Ds   12:01   0:00 /u=
sr/lib/ssh/sftp-server
> root      132094  0.0  0.0      0     0 ?        D    12:01   0:00 [k=
worker/u64:93+flush-btrfs-1]
> hasi      132101  0.0  0.0   2604  1944 ?        Ds   12:01   0:00 /u=
sr/lib/ssh/sftp-server
> root      132103  0.0  0.0      0     0 ?        D    12:02   0:00 [k=
worker/u64:94+flush-btrfs-1]
> hasi      132110  0.0  0.0   2604  1716 ?        Ds   12:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132117  0.0  0.0   2604  1704 ?        Ds   12:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132126  0.0  0.0   2604  1688 ?        Ds   12:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132133  0.0  0.0   2604  1944 ?        Ds   12:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132142  0.0  0.0   2604  1688 ?        Ds   12:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132153  0.0  0.0   2604  1772 ?        Ds   12:03   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132160  0.0  0.0   2604  1916 ?        Ds   12:03   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132172  0.0  0.0   2604  1716 ?        Ds   12:03   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132184  0.0  0.0   2604  1728 ?        Ds   12:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132192  0.0  0.0   2604  1712 ?        Ds   12:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132201  0.0  0.0   2604  1864 ?        Ds   12:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132208  0.0  0.0   2604  1596 ?        Ds   12:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132215  0.0  0.0   2604  1944 ?        Ds   12:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132229  0.0  0.0   2604  1804 ?        Ds   12:06   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132237  0.0  0.0   2604  1728 ?        Ds   12:06   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132246  0.0  0.0   2604  1932 ?        Ds   12:06   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132261  0.0  0.0   2604  1772 ?        Ds   12:07   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132268  0.0  0.0   2604  1804 ?        Ds   12:07   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132277  0.0  0.0   2676  1816 ?        Ds   12:07   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132285  0.0  0.0   2604  1772 ?        Ds   12:07   0:00 /u=
sr/lib/ssh/sftp-server
> root      132286  0.0  0.0      0     0 ?        D    12:07   0:00 [k=
worker/u64:96+flush-btrfs-1]
> hasi      132295  0.0  0.0   2604  1804 ?        Ds   12:07   0:00 /u=
sr/lib/ssh/sftp-server
> root      132296  0.0  0.0      0     0 ?        D    12:07   0:00 [k=
worker/u64:97+flush-btrfs-1]
> hasi      132307  0.0  0.0   2604  1728 ?        Ds   12:08   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132314  0.0  0.0   2604  1732 ?        Ds   12:08   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132325  0.0  0.0   2604  1932 ?        Ds   12:08   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132334  0.0  0.0   2604  1716 ?        Ds   12:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132342  0.0  0.0   2604  1596 ?        Ds   12:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132349  0.0  0.0   2604  1804 ?        Ds   12:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132356  0.0  0.0   2604  1844 ?        Ds   12:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132368  0.0  0.0   2604  1932 ?        Ds   12:09   0:00 /u=
sr/lib/ssh/sftp-server
> root      132369  0.0  0.0      0     0 ?        D    12:09   0:00 [k=
worker/u64:98+flush-btrfs-1]
> hasi      132383  0.0  0.0   2604  1772 ?        Ds   12:11   0:00 /u=
sr/lib/ssh/sftp-server
> root      132384  0.0  0.0      0     0 ?        D    12:11   0:00 [k=
worker/u64:99+flush-btrfs-1]
> hasi      132392  0.0  0.0   2604  1688 ?        Ds   12:11   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132401  0.0  0.0   2604  1728 ?        Ds   12:11   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132409  0.0  0.0   2604  1864 ?        Ds   12:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132416  0.0  0.0   2604  1596 ?        Ds   12:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132425  0.0  0.0   2604  1752 ?        Ds   12:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132432  0.0  0.0   2604  1700 ?        Ds   12:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132441  0.0  0.0   2604  1704 ?        Ds   12:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132452  0.0  0.0   2604  1596 ?        Ds   12:13   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132459  0.0  0.0   2604  1596 ?        Ds   12:13   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132470  0.0  0.0   2604  1944 ?        Ds   12:13   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132477  0.0  0.0   2604  1752 ?        Ds   12:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132485  0.0  0.0   2604  1944 ?        Ds   12:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132492  0.0  0.0   2604  1776 ?        Ds   12:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132499  0.0  0.0   2604  1864 ?        Ds   12:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132506  0.0  0.0   2604  1772 ?        Ds   12:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132523  0.0  0.0   2604  1772 ?        Ds   12:16   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132531  0.0  0.0   2604  1904 ?        Ds   12:16   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132542  0.0  0.0   2604  2000 ?        Ds   12:16   0:00 /u=
sr/lib/ssh/sftp-server
> root      132556  0.0  0.0      0     0 ?        D    12:17   0:00 [k=
worker/u64:100+flush-btrfs-1]
> hasi      132557  0.0  0.0   2604  1872 ?        Ds   12:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132564  0.0  0.0   2604  1728 ?        Ds   12:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132578  0.0  0.0   2604  1704 ?        Ds   12:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132585  0.0  0.0   2604  1916 ?        Ds   12:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132594  0.0  0.0   2604  1864 ?        Ds   12:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132608  0.0  0.0   2604  1816 ?        Ds   12:18   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132617  0.0  0.0   2604  1772 ?        Ds   12:18   0:00 /u=
sr/lib/ssh/sftp-server
> root      132618  0.0  0.0      0     0 ?        D    12:18   0:00 [k=
worker/u64:101+flush-btrfs-1]
> hasi      132630  0.0  0.0   2604  1932 ?        Ds   12:18   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132640  0.0  0.0   2604  1772 ?        Ds   12:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132648  0.0  0.0   2604  1752 ?        Ds   12:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132655  0.0  0.0   2604  1916 ?        Ds   12:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132662  0.0  0.0   2604  1844 ?        Ds   12:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132672  0.0  0.0   2604  1772 ?        Ds   12:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132686  0.0  0.0   2604  1960 ?        Ds   12:21   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132697  0.0  0.0   2604  1776 ?        Ds   12:21   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132704  0.0  0.0   2604  1752 ?        Ds   12:21   0:00 /u=
sr/lib/ssh/sftp-server
> root      132705  0.0  0.0      0     0 ?        D    12:22   0:00 [k=
worker/u64:103+flush-btrfs-1]
> hasi      132713  0.0  0.0   2604  1872 ?        Ds   12:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132720  0.0  0.0   2604  1716 ?        Ds   12:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132729  0.0  0.0   2604  1700 ?        Ds   12:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132736  0.0  0.0   2604  1732 ?        Ds   12:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132745  0.0  0.0   2604  1732 ?        Ds   12:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132756  0.0  0.0   2604  1596 ?        Ds   12:23   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132763  0.0  0.0   2604  1916 ?        Ds   12:23   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132774  0.0  0.0   2604  1688 ?        Ds   12:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132781  0.0  0.0   2604  1700 ?        Ds   12:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132789  0.0  0.0   2604  2016 ?        Ds   12:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132800  0.0  0.0   2604  1732 ?        Ds   12:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132807  0.0  0.0   2604  1728 ?        Ds   12:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132814  0.0  0.0   2604  1804 ?        Ds   12:24   0:00 /u=
sr/lib/ssh/sftp-server
> root      132815  0.0  0.0      0     0 ?        D    12:24   0:00 [k=
worker/u64:104+flush-btrfs-1]
> hasi      132829  0.0  0.0   2604  1704 ?        Ds   12:26   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132839  0.0  0.0   2740  2000 ?        Ds   12:26   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132847  0.0  0.0   2604  1960 ?        Ds   12:26   0:00 /u=
sr/lib/ssh/sftp-server
> root      132851  0.0  0.0      0     0 ?        D    12:27   0:00 [k=
worker/u64:105+flush-btrfs-1]
> root      132852  0.0  0.0      0     0 ?        D    12:27   0:00 [k=
worker/u64:107+flush-btrfs-1]
> hasi      132860  0.0  0.0   2604  1688 ?        Ds   12:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132867  0.0  0.0   2604  1688 ?        Ds   12:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132876  0.0  0.0   2604  1944 ?        Ds   12:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132883  0.0  0.0   2604  1856 ?        Ds   12:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132893  0.0  0.0   2604  1596 ?        Ds   12:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132925  0.0  0.0   2604  1932 ?        Ds   12:28   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132935  0.0  0.0   2604  1716 ?        Ds   12:28   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132946  0.0  0.0   2604  2044 ?        Ds   12:29   0:00 /u=
sr/lib/ssh/sftp-server
> root      132948  0.0  0.0      0     0 ?        D    12:29   0:00 [k=
worker/u64:109+flush-btrfs-1]
> hasi      132955  0.0  0.0   2604  1716 ?        Ds   12:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132963  0.0  0.0   2604  1732 ?        Ds   12:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132970  0.0  0.0   2604  1596 ?        Ds   12:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132977  0.0  0.0   2604  1804 ?        Ds   12:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      132985  0.0  0.0   2604  2016 ?        Ds   12:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133001  0.0  0.0   2604  1944 ?        Ds   12:31   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133011  0.0  0.0   2604  1916 ?        Ds   12:31   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133018  0.0  0.0   2604  1776 ?        Ds   12:32   0:00 /u=
sr/lib/ssh/sftp-server
> root      133022  0.0  0.0      0     0 ?        D    12:32   0:00 [k=
worker/u64:110+flush-btrfs-1]
> hasi      133030  0.0  0.0   2604  1776 ?        Ds   12:32   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133037  0.0  0.0   2604  1704 ?        Ds   12:32   0:00 /u=
sr/lib/ssh/sftp-server
> root      133038  0.0  0.0      0     0 ?        D    12:32   0:00 [k=
worker/u64:111+flush-btrfs-1]
> hasi      133047  0.0  0.0   2604  1728 ?        Ds   12:32   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133054  0.0  0.0   2604  1704 ?        Ds   12:32   0:00 /u=
sr/lib/ssh/sftp-server
> root      133055  0.0  0.0      0     0 ?        D    12:32   0:00 [k=
worker/u64:112+flush-btrfs-1]
> hasi      133064  0.0  0.0   2604  1700 ?        Ds   12:32   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133075  0.0  0.0   2604  1772 ?        Ds   12:33   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133082  0.0  0.0   2604  1596 ?        Ds   12:33   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133098  0.0  0.0   2604  1596 ?        Ds   12:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133106  0.0  0.0   2604  2016 ?        Ds   12:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133115  0.0  0.0   2604  1944 ?        Ds   12:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133124  0.0  0.0   2604  1732 ?        Ds   12:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133131  0.0  0.0   2604  1716 ?        Ds   12:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133138  0.0  0.0   2604  1772 ?        Ds   12:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133157  0.0  0.0   2604  1864 ?        Ds   12:36   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133167  0.0  0.0   2604  1844 ?        Ds   12:36   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133175  0.0  0.0   2604  1900 ?        Ds   12:37   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133188  0.0  0.0   2604  1732 ?        Ds   12:37   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133195  0.0  0.0   2604  1824 ?        Ds   12:37   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133204  0.0  0.0   2604  1704 ?        Ds   12:37   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133211  0.0  0.0   2604  1944 ?        Ds   12:37   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133221  0.0  0.0   2604  2044 ?        Ds   12:37   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133234  0.0  0.0   2604  1716 ?        Ds   12:38   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133241  0.0  0.0   2604  1972 ?        Ds   12:38   0:00 /u=
sr/lib/ssh/sftp-server
> root      133243  0.0  0.0      0     0 ?        D    12:38   0:00 [k=
worker/u64:113+flush-btrfs-1]
> root      133249  0.0  0.0      0     0 ?        D    12:38   0:00 [k=
worker/u64:115+flush-btrfs-1]
> hasi      133262  0.0  0.0   2604  1872 ?        Ds   12:39   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133269  0.0  0.0   2604  1704 ?        Ds   12:39   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133277  0.0  0.0   2604  1804 ?        Ds   12:39   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133284  0.0  0.0   2604  1716 ?        Ds   12:39   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133291  0.0  0.0   2604  1900 ?        Ds   12:39   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133299  0.0  0.0   2604  1904 ?        Ds   12:39   0:00 /u=
sr/lib/ssh/sftp-server
> root      133310  0.0  0.0      0     0 ?        D    12:41   0:00 [k=
worker/u64:116+flush-btrfs-1]
> hasi      133318  0.0  0.0   2604  2016 ?        Ds   12:41   0:00 /u=
sr/lib/ssh/sftp-server
> root      133322  0.0  0.0      0     0 ?        D    12:41   0:00 [k=
worker/u64:117+flush-btrfs-1]
> hasi      133332  0.0  0.0   2604  1716 ?        Ds   12:41   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133339  0.0  0.0   2604  1688 ?        Ds   12:42   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133348  0.0  0.0   2604  1900 ?        Ds   12:42   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133357  0.0  0.0   2604  1772 ?        Ds   12:42   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133367  0.0  0.0   2604  1864 ?        Ds   12:42   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133374  0.0  0.0   2604  1804 ?        Ds   12:42   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133383  0.0  0.0   2604  1804 ?        Ds   12:42   0:00 /u=
sr/lib/ssh/sftp-server
> root      133388  0.0  0.0      0     0 ?        D    12:42   0:00 [k=
worker/u64:118+flush-btrfs-1]
> root      133389  0.0  0.0      0     0 ?        D    12:43   0:00 [k=
worker/u64:120+flush-btrfs-1]
> hasi      133396  0.0  0.0   2604  1728 ?        Ds   12:43   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133403  0.0  0.0   2604  1596 ?        Ds   12:43   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133414  0.0  0.0   2604  1752 ?        Ds   12:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133421  0.0  0.0   2604  1864 ?        Ds   12:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133429  0.0  0.0   2604  1872 ?        Ds   12:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133436  0.0  0.0   2604  1596 ?        Ds   12:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133443  0.0  0.0   2604  1752 ?        Ds   12:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133450  0.0  0.0   2604  1688 ?        Ds   12:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133464  0.0  0.0   2604  1916 ?        Ds   12:46   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133474  0.0  0.0   2604  1732 ?        Ds   12:46   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133481  0.0  0.0   2604  1972 ?        Ds   12:47   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133501  0.0  0.0   2604  1772 ?        Ds   12:47   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133504  0.0  0.0   2604  1772 ?        Ds   12:47   0:00 /u=
sr/lib/ssh/sftp-server
> root      133505  0.0  0.0      0     0 ?        D    12:47   0:00 [k=
worker/u64:121+flush-btrfs-1]
> hasi      133514  0.0  0.0   2604  1688 ?        Ds   12:47   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133521  0.0  0.0   2604  1932 ?        Ds   12:47   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133533  0.0  0.0   2604  1752 ?        Ds   12:47   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133547  0.0  0.0   2604  1776 ?        Ds   12:48   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133554  0.0  0.0   2604  1908 ?        Ds   12:48   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133568  0.0  0.0   2604  1944 ?        Ds   12:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133575  0.0  0.0   2604  1864 ?        Ds   12:49   0:00 /u=
sr/lib/ssh/sftp-server
> root      133576  0.0  0.0      0     0 ?        D    12:49   0:00 [k=
worker/u64:122+flush-btrfs-1]
> hasi      133584  0.0  0.0   2604  1916 ?        Ds   12:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133591  0.0  0.0   2604  1596 ?        Ds   12:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133598  0.0  0.0   2604  2016 ?        Ds   12:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133606  0.0  0.0   2604  2000 ?        Ds   12:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133624  0.0  0.0   2604  1704 ?        Ds   12:51   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133634  0.0  0.0   2604  1716 ?        Ds   12:51   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133641  0.0  0.0   2604  1704 ?        Ds   12:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133652  0.0  0.0   2604  1696 ?        Ds   12:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133656  0.0  0.0   2604  1904 ?        Ds   12:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133667  0.0  0.0   2604  1872 ?        Ds   12:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133674  0.0  0.0   2604  1944 ?        Ds   12:52   0:00 /u=
sr/lib/ssh/sftp-server
> root      133675  0.0  0.0      0     0 ?        D    12:52   0:00 [k=
worker/u64:123+flush-btrfs-1]
> hasi      133684  0.0  0.0   2604  1772 ?        Ds   12:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133695  0.0  0.0   2604  1716 ?        Ds   12:53   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133702  0.0  0.0   2604  1596 ?        Ds   12:53   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133713  0.0  0.0   2604  1704 ?        Ds   12:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133721  0.0  0.0   2604  1688 ?        Ds   12:54   0:00 /u=
sr/lib/ssh/sftp-server
> root      133722  0.0  0.0      0     0 ?        D    12:54   0:00 [k=
worker/u64:125+flush-btrfs-1]
> hasi      133730  0.0  0.0   2604  1804 ?        Ds   12:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133737  0.0  0.0   2736  1908 ?        Ds   12:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133746  0.0  0.0   2604  1732 ?        Ds   12:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133753  0.0  0.0   2604  1716 ?        Ds   12:54   0:00 /u=
sr/lib/ssh/sftp-server
> root      133757  0.0  0.0      0     0 ?        D    12:55   0:00 [k=
worker/u64:126+flush-btrfs-1]
> hasi      133769  0.0  0.0   2604  1688 ?        Ds   12:56   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133779  0.0  0.0   2604  1596 ?        Ds   12:56   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133786  0.0  0.0   2604  1880 ?        Ds   12:57   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133796  0.0  0.0   2604  1716 ?        Ds   12:57   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133803  0.0  0.0   2604  1872 ?        Ds   12:57   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133812  0.0  0.0   2604  1916 ?        Ds   12:57   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133819  0.0  0.0   2604  1900 ?        Ds   12:57   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133830  0.0  0.0   2604  1772 ?        Ds   12:57   0:00 /u=
sr/lib/ssh/sftp-server
> root      133835  0.0  0.0      0     0 ?        D    12:57   0:00 [k=
worker/u64:127+flush-btrfs-1]
> hasi      133842  0.0  0.0   2776  1952 ?        Ds   12:58   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133851  0.0  0.0   2604  1872 ?        Ds   12:58   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133863  0.0  0.0   2604  2072 ?        Ds   12:59   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133874  0.0  0.0   2604  1916 ?        Ds   12:59   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133882  0.0  0.0   2604  1804 ?        Ds   12:59   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133889  0.0  0.0   2604  1732 ?        Ds   12:59   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133896  0.0  0.0   2604  1752 ?        Ds   12:59   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133903  0.0  0.0   2604  1700 ?        Ds   12:59   0:00 /u=
sr/lib/ssh/sftp-server
> root      133917  0.0  0.0      0     0 ?        D    13:01   0:00 [k=
worker/u64:128+flush-btrfs-1]
> hasi      133925  0.0  0.0   2604  1752 ?        Ds   13:01   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133935  0.0  0.0   2604  1728 ?        Ds   13:01   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133942  0.0  0.0   2604  1688 ?        Ds   13:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133950  0.0  0.0   2604  1716 ?        Ds   13:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133957  0.0  0.0   2604  2016 ?        Ds   13:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133970  0.0  0.0   2604  1700 ?        Ds   13:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133977  0.0  0.0   2604  1916 ?        Ds   13:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      133986  0.0  0.0   2604  1804 ?        Ds   13:02   0:00 /u=
sr/lib/ssh/sftp-server
> root      133991  0.0  0.0      0     0 ?        D    13:02   0:00 [k=
worker/u64:129+flush-btrfs-1]
> hasi      133998  0.0  0.0   2604  1776 ?        Ds   13:03   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134005  0.0  0.0   2604  1704 ?        Ds   13:03   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134017  0.0  0.0   2604  1776 ?        Ds   13:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134027  0.0  0.0   4408  2808 ?        Ds   13:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134030  0.0  0.0   2604  1704 ?        Ds   13:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134047  0.0  0.0   2604  1700 ?        Ds   13:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134058  0.0  0.0   2604  1916 ?        Ds   13:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134065  0.0  0.0   2604  1752 ?        Ds   13:04   0:00 /u=
sr/lib/ssh/sftp-server
> root      134073  0.0  0.0      0     0 ?        D    13:06   0:00 [k=
worker/u64:130+flush-btrfs-1]
> hasi      134081  0.0  0.0   2604  1916 ?        Ds   13:06   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134091  0.0  0.0   2604  1688 ?        Ds   13:06   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134098  0.0  0.0   2604  1704 ?        Ds   13:07   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134106  0.0  0.0   2604  1864 ?        Ds   13:07   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134113  0.0  0.0   2604  1776 ?        Ds   13:07   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134122  0.0  0.0   2604  1728 ?        Ds   13:07   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134129  0.0  0.0   2604  2000 ?        Ds   13:07   0:00 /u=
sr/lib/ssh/sftp-server
> root      134132  0.0  0.0      0     0 ?        D    13:07   0:00 [k=
worker/u64:131+flush-btrfs-1]
> hasi      134142  0.0  0.0   2604  1700 ?        Ds   13:07   0:00 /u=
sr/lib/ssh/sftp-server
> root      134147  0.0  0.0      0     0 ?        D    13:07   0:00 [k=
worker/u64:135+flush-btrfs-1]
> hasi      134154  0.0  0.0   2604  1972 ?        Ds   13:08   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134162  0.0  0.0   2604  1932 ?        Ds   13:08   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134180  0.0  0.0   2604  1772 ?        Ds   13:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134187  0.0  0.0   2604  1716 ?        Ds   13:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134199  0.0  0.0   2604  1872 ?        Ds   13:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134202  0.0  0.0   2604  1732 ?        Ds   13:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134209  0.0  0.0   2604  1716 ?        Ds   13:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134216  0.0  0.0   2604  1864 ?        Ds   13:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134230  0.0  0.0   2604  1804 ?        Ds   13:11   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134240  0.0  0.0   2604  1704 ?        Ds   13:11   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134247  0.0  0.0   2604  1916 ?        Ds   13:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134255  0.0  0.0   2604  1916 ?        Ds   13:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134262  0.0  0.0   2604  1904 ?        Ds   13:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134273  0.0  0.0   2604  1704 ?        Ds   13:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134282  0.0  0.0   2604  1872 ?        Ds   13:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134289  0.0  0.0   2604  1728 ?        Ds   13:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134300  0.0  0.0   2604  1804 ?        Ds   13:13   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134307  0.0  0.0   2604  1944 ?        Ds   13:13   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134318  0.0  0.0   2604  1732 ?        Ds   13:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134325  0.0  0.0   2604  1596 ?        Ds   13:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134338  0.0  0.0   2604  1688 ?        Ds   13:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134340  0.0  0.0   2604  2016 ?        Ds   13:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134356  0.0  0.0   2604  1872 ?        Ds   13:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134363  0.0  0.0   2604  1916 ?        Ds   13:14   0:00 /u=
sr/lib/ssh/sftp-server
> root      134367  0.0  0.0      0     0 ?        D    13:15   0:00 [k=
worker/u64:136+flush-btrfs-1]
> hasi      134381  0.0  0.0   2604  1732 ?        Ds   13:16   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134391  0.0  0.0   2604  1772 ?        Ds   13:16   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134398  0.0  0.0   2604  1752 ?        Ds   13:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134406  0.0  0.0   2604  1704 ?        Ds   13:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134413  0.0  0.0   2604  1688 ?        Ds   13:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134422  0.0  0.0   2604  1916 ?        Ds   13:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134431  0.0  0.0   2604  1704 ?        Ds   13:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134438  0.0  0.0   2604  1752 ?        Ds   13:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134449  0.0  0.0   2604  1704 ?        Ds   13:18   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134461  0.0  0.0   2604  1900 ?        Ds   13:18   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134486  0.0  0.0   2604  1872 ?        Ds   13:19   0:00 /u=
sr/lib/ssh/sftp-server
> root      134487  0.0  0.0      0     0 ?        D    13:19   0:00 [k=
worker/u64:138+flush-btrfs-1]
> hasi      134494  0.0  0.0   2604  1916 ?        Ds   13:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134502  0.0  0.0   2604  1916 ?        Ds   13:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134509  0.0  0.0   2604  1864 ?        Ds   13:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134516  0.0  0.0   2604  1752 ?        Ds   13:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134523  0.0  0.0   2604  1688 ?        Ds   13:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134537  0.0  0.0   2604  1772 ?        Ds   13:21   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134547  0.0  0.0   2604  1944 ?        Ds   13:21   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134554  0.0  0.0   2604  1732 ?        Ds   13:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134562  0.0  0.0   2604  1864 ?        Ds   13:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134569  0.0  0.0   2604  1596 ?        Ds   13:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134578  0.0  0.0   2604  1772 ?        Ds   13:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134587  0.0  0.0   2604  1916 ?        Ds   13:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134594  0.0  0.0   2604  1864 ?        Ds   13:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134605  0.0  0.0   2604  1716 ?        Ds   13:23   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134612  0.0  0.0   2604  1716 ?        Ds   13:23   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134623  0.0  0.0   2604  1864 ?        Ds   13:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134630  0.0  0.0   2604  1716 ?        Ds   13:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134638  0.0  0.0   2604  1732 ?        Ds   13:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134645  0.0  0.0   2604  1900 ?        Ds   13:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134653  0.0  0.0   2604  1804 ?        Ds   13:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134660  0.0  0.0   2604  1688 ?        Ds   13:24   0:00 /u=
sr/lib/ssh/sftp-server
> root      134675  0.0  0.0      0     0 ?        D    13:26   0:00 [k=
worker/u64:139+flush-btrfs-1]
> hasi      134683  0.0  0.0   2604  1732 ?        Ds   13:26   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134693  0.0  0.0   2604  1700 ?        Ds   13:26   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134700  0.0  0.0   2604  1716 ?        Ds   13:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134708  0.0  0.0   2604  1688 ?        Ds   13:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134715  0.0  0.0   2604  1864 ?        Ds   13:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134724  0.0  0.0   2604  1596 ?        Ds   13:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134733  0.0  0.0   2604  1776 ?        Ds   13:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134740  0.0  0.0   2604  1728 ?        Ds   13:27   0:00 /u=
sr/lib/ssh/sftp-server
> root      134745  0.0  0.0      0     0 ?        D    13:28   0:00 [k=
worker/u64:142+flush-btrfs-1]
> hasi      134752  0.0  0.0   2604  1688 ?        Ds   13:28   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134759  0.0  0.0   2604  1904 ?        Ds   13:28   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134771  0.0  0.0   2604  1932 ?        Ds   13:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134784  0.0  0.0   2604  1772 ?        Ds   13:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134792  0.0  0.0   2604  1916 ?        Ds   13:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134799  0.0  0.0   2604  1700 ?        Ds   13:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134806  0.0  0.0   2604  1716 ?        Ds   13:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134813  0.0  0.0   2604  1596 ?        Ds   13:29   0:00 /u=
sr/lib/ssh/sftp-server
> root      134814  0.0  0.0      0     0 ?        D    13:29   0:00 [k=
worker/u64:143+flush-btrfs-1]
> hasi      134828  0.0  0.0   2604  1776 ?        Ds   13:31   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134838  0.0  0.0   2604  1916 ?        Ds   13:31   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134848  0.0  0.0   2604  1716 ?        Ds   13:32   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134856  0.0  0.0   2604  1804 ?        Ds   13:32   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134863  0.0  0.0   2604  1872 ?        Ds   13:32   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134872  0.0  0.0   2604  1716 ?        Ds   13:32   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134881  0.0  0.0   2604  1916 ?        Ds   13:32   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134888  0.0  0.0   2604  1916 ?        Ds   13:32   0:00 /u=
sr/lib/ssh/sftp-server
> root      134893  0.0  0.0      0     0 ?        D    13:33   0:00 [k=
worker/u64:145+flush-btrfs-1]
> hasi      134900  0.0  0.0   2604  1872 ?        Ds   13:33   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134911  0.0  0.0   2604  1700 ?        Ds   13:33   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134923  0.0  0.0   2604  1728 ?        Ds   13:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134930  0.0  0.0   2604  1944 ?        Ds   13:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134938  0.0  0.0   2604  1880 ?        Ds   13:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134946  0.0  0.0   2604  1732 ?        Ds   13:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134953  0.0  0.0   2604  1944 ?        Ds   13:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134960  0.0  0.0   2604  1900 ?        Ds   13:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134981  0.0  0.0   2604  1716 ?        Ds   13:36   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134991  0.0  0.0   2604  1804 ?        Ds   13:36   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      134999  0.0  0.0   2604  1864 ?        Ds   13:37   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135007  0.0  0.0   2604  1944 ?        Ds   13:37   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135014  0.0  0.0   2604  1716 ?        Ds   13:37   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135023  0.0  0.0   2604  1716 ?        Ds   13:37   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135032  0.0  0.0   2604  1596 ?        Ds   13:37   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135039  0.0  0.0   2604  1700 ?        Ds   13:37   0:00 /u=
sr/lib/ssh/sftp-server
> root      135065  0.0  0.0      0     0 ?        D    13:38   0:00 [k=
worker/u64:146+flush-btrfs-1]
> hasi      135072  0.0  0.0   2604  1596 ?        Ds   13:38   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135085  0.0  0.0   2604  1916 ?        Ds   13:38   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135097  0.0  0.0   2604  1972 ?        Ds   13:39   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135105  0.0  0.0   2604  1716 ?        Ds   13:39   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135113  0.0  0.0   2604  1700 ?        Ds   13:39   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135120  0.0  0.0   2604  1900 ?        Ds   13:39   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135133  0.0  0.0   4308  2940 ?        Ds   13:39   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135140  0.0  0.0   2604  1960 ?        Ds   13:39   0:00 /u=
sr/lib/ssh/sftp-server
> root      135161  0.0  0.0      0     0 ?        D    13:41   0:00 [k=
worker/u64:148+flush-btrfs-1]
> hasi      135169  0.0  0.0   2604  1728 ?        Ds   13:41   0:00 /u=
sr/lib/ssh/sftp-server
> root      135170  0.0  0.0      0     0 ?        D    13:41   0:00 [k=
worker/u64:149+flush-btrfs-1]
> hasi      135183  0.0  0.0   2604  1732 ?        Ds   13:41   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135191  0.0  0.0   2604  1704 ?        Ds   13:42   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135199  0.0  0.0   2604  1804 ?        Ds   13:42   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135206  0.0  0.0   2604  1700 ?        Ds   13:42   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135215  0.0  0.0   2604  1752 ?        Ds   13:42   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135224  0.0  0.0   2604  1864 ?        Ds   13:42   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135231  0.0  0.0   2604  1688 ?        Ds   13:42   0:00 /u=
sr/lib/ssh/sftp-server
> root      135234  0.0  0.0      0     0 ?        D    13:43   0:00 [k=
worker/u64:150+flush-btrfs-1]
> hasi      135241  0.0  0.0   2604  1688 ?        Ds   13:43   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135250  0.0  0.0   2604  1732 ?        Ds   13:43   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135258  0.0  0.0   2604  1776 ?        Ds   13:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135265  0.0  0.0   2604  1716 ?        Ds   13:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135273  0.0  0.0   2604  1596 ?        Ds   13:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135280  0.0  0.0   2604  1732 ?        Ds   13:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135287  0.0  0.0   2604  1916 ?        Ds   13:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135294  0.0  0.0   2604  1864 ?        Ds   13:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135308  0.0  0.0   2604  1732 ?        Ds   13:46   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135316  0.0  0.0   2604  1596 ?        Ds   13:46   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135323  0.0  0.0   2604  1716 ?        Ds   13:47   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135337  0.0  0.0   2604  1932 ?        Ds   13:47   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135345  0.0  0.0   2604  1944 ?        Ds   13:47   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135355  0.0  0.0   2604  1704 ?        Ds   13:47   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135364  0.0  0.0   2604  1704 ?        Ds   13:47   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135371  0.0  0.0   2604  1864 ?        Ds   13:47   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135385  0.0  0.0   2604  1704 ?        Ds   13:48   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135395  0.0  0.0   2604  1752 ?        Ds   13:48   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135403  0.0  0.0   2604  1752 ?        Ds   13:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135410  0.0  0.0   2604  1864 ?        Ds   13:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135418  0.0  0.0   2604  1700 ?        Ds   13:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135425  0.0  0.0   2604  1944 ?        Ds   13:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135432  0.0  0.0   2676  1844 ?        Ds   13:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135439  0.0  0.0   2604  1776 ?        Ds   13:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135456  0.0  0.0   2604  1816 ?        Ds   13:51   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135468  0.0  0.0   2604  1716 ?        Ds   13:51   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135475  0.0  0.0   2604  1916 ?        Ds   13:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135483  0.0  0.0   2604  1776 ?        Ds   13:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135490  0.0  0.0   2604  2072 ?        Ds   13:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135500  0.0  0.0   2604  1872 ?        Ds   13:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135509  0.0  0.0   2604  1864 ?        Ds   13:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135517  0.0  0.0   2604  1716 ?        Ds   13:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135527  0.0  0.0   2604  1704 ?        Ds   13:53   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135542  0.0  0.0   2604  1596 ?        Ds   13:53   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135551  0.0  0.0   2604  1716 ?        Ds   13:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135559  0.0  0.0   2604  1732 ?        Ds   13:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135567  0.0  0.0   2604  1916 ?        Ds   13:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135574  0.0  0.0   2604  1716 ?        Ds   13:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135582  0.0  0.0   2604  1728 ?        Ds   13:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135589  0.0  0.0   2604  1772 ?        Ds   13:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135602  0.0  0.0   2604  1700 ?        Ds   13:56   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135610  0.0  0.0   2604  1992 ?        Ds   13:56   0:00 /u=
sr/lib/ssh/sftp-server
> root      135614  0.0  0.0      0     0 ?        D    13:57   0:00 [k=
worker/u64:151+flush-btrfs-1]
> hasi      135619  0.0  0.0   2604  1688 ?        Ds   13:57   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135627  0.0  0.0   2604  2000 ?        Ds   13:57   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135637  0.0  0.0   2604  1596 ?        Ds   13:57   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135647  0.0  0.0   2604  1992 ?        Ds   13:57   0:00 /u=
sr/lib/ssh/sftp-server
> root      135652  0.0  0.0      0     0 ?        D    13:57   0:00 [k=
worker/u64:152+flush-btrfs-1]
> hasi      135659  0.0  0.0   2604  2016 ?        Ds   13:57   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135667  0.0  0.0   2604  1900 ?        Ds   13:57   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135679  0.0  0.0   2604  1972 ?        Ds   13:58   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135688  0.0  0.0   2604  1916 ?        Ds   13:58   0:00 /u=
sr/lib/ssh/sftp-server
> root      135689  0.0  0.0      0     0 ?        D    13:59   0:00 [k=
worker/u64:153+flush-btrfs-1]
> hasi      135697  0.0  0.0   2604  1992 ?        Ds   13:59   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135707  0.0  0.0   2604  1804 ?        Ds   13:59   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135716  0.0  0.0   2604  1716 ?        Ds   13:59   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135723  0.0  0.0   2604  1880 ?        Ds   13:59   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135731  0.0  0.0   2604  1772 ?        Ds   13:59   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135738  0.0  0.0   2604  1916 ?        Ds   13:59   0:00 /u=
sr/lib/ssh/sftp-server
> root      135754  0.0  0.0      0     0 ?        D    14:01   0:00 [k=
worker/u64:154+flush-btrfs-1]
> hasi      135763  0.0  0.0   2604  1944 ?        Ds   14:01   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135771  0.0  0.0   2604  1716 ?        Ds   14:01   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135778  0.0  0.0   2604  1776 ?        Ds   14:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135789  0.0  0.0   2604  1872 ?        Ds   14:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135796  0.0  0.0   2604  1804 ?        Ds   14:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135805  0.0  0.0   2604  1716 ?        Ds   14:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135814  0.0  0.0   2604  1804 ?        Ds   14:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135821  0.0  0.0   2604  1804 ?        Ds   14:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135831  0.0  0.0   2604  1944 ?        Ds   14:03   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135846  0.0  0.0   2604  1960 ?        Ds   14:03   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135857  0.0  0.0   2604  1704 ?        Ds   14:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135864  0.0  0.0   2604  1904 ?        Ds   14:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135878  0.0  0.0   2604  1804 ?        Ds   14:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135885  0.0  0.0   2604  1716 ?        Ds   14:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135892  0.0  0.0   2604  1804 ?        Ds   14:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135899  0.0  0.0   2604  1596 ?        Ds   14:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135910  0.0  0.0   2604  1688 ?        Ds   14:06   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135918  0.0  0.0   2604  1728 ?        Ds   14:06   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135926  0.0  0.0   2604  1732 ?        Ds   14:07   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135935  0.0  0.0   2604  1772 ?        Ds   14:07   0:00 /u=
sr/lib/ssh/sftp-server
> root      135936  0.0  0.0      0     0 ?        D    14:07   0:00 [k=
worker/u64:155+flush-btrfs-1]
> hasi      135943  0.0  0.0   2604  1772 ?        Ds   14:07   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135952  0.0  0.0   2604  1728 ?        Ds   14:07   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135961  0.0  0.0   2604  1864 ?        Ds   14:07   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      135968  0.0  0.0   2604  2044 ?        Ds   14:07   0:00 /u=
sr/lib/ssh/sftp-server
> root      135969  0.0  0.0      0     0 ?        D    14:07   0:00 [k=
worker/u64:156+flush-btrfs-1]
> hasi      136004  0.0  0.0   2604  1908 ?        Ds   14:08   0:00 /u=
sr/lib/ssh/sftp-server
> root      136011  0.0  0.0      0     0 ?        D    14:08   0:00 [k=
worker/u64:157+flush-btrfs-1]
> hasi      136019  0.0  0.0   2604  1732 ?        Ds   14:08   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136027  0.0  0.0   2604  1700 ?        Ds   14:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136035  0.0  0.0   2604  1700 ?        Ds   14:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136043  0.0  0.0   2604  1864 ?        Ds   14:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136050  0.0  0.0   2604  1772 ?        Ds   14:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136057  0.0  0.0   2604  1776 ?        Ds   14:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136064  0.0  0.0   2604  1944 ?        Ds   14:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136075  0.0  0.0   2604  1772 ?        Ds   14:11   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136084  0.0  0.0   2604  1944 ?        Ds   14:11   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136092  0.0  0.0   2604  1700 ?        Ds   14:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136100  0.0  0.0   2604  1944 ?        Ds   14:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136107  0.0  0.0   2604  1752 ?        Ds   14:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136116  0.0  0.0   2604  1716 ?        Ds   14:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136125  0.0  0.0   2604  1804 ?        Ds   14:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136132  0.0  0.0   2604  1772 ?        Ds   14:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136143  0.0  0.0   2604  1940 ?        Ds   14:13   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136153  0.0  0.0   2604  1864 ?        Ds   14:13   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136162  0.0  0.0   2604  1772 ?        Ds   14:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136170  0.0  0.0   2604  1716 ?        Ds   14:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136178  0.0  0.0   2604  2000 ?        Ds   14:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136187  0.0  0.0   2604  1688 ?        Ds   14:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136194  0.0  0.0   2604  1972 ?        Ds   14:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136207  0.0  0.0   2604  1772 ?        Ds   14:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136223  0.0  0.0   2604  1916 ?        Ds   14:16   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136231  0.0  0.0   2604  1776 ?        Ds   14:16   0:00 /u=
sr/lib/ssh/sftp-server
> root      136232  0.0  0.0      0     0 ?        D    14:17   0:00 [k=
worker/u64:159+flush-btrfs-1]
> hasi      136239  0.0  0.0   2604  1732 ?        Ds   14:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136247  0.0  0.0   2604  1716 ?        Ds   14:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136254  0.0  0.0   2604  1596 ?        Ds   14:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136263  0.0  0.0   2604  1716 ?        Ds   14:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136272  0.0  0.0   2604  1732 ?        Ds   14:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136279  0.0  0.0   2604  1596 ?        Ds   14:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136290  0.0  0.0   2604  1596 ?        Ds   14:18   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136299  0.0  0.0   2604  1716 ?        Ds   14:18   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136312  0.0  0.0   2604  1860 ?        Ds   14:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136323  0.0  0.0   2604  1716 ?        Ds   14:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136331  0.0  0.0   2604  1700 ?        Ds   14:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136338  0.0  0.0   2604  1900 ?        Ds   14:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136352  0.0  0.0   2604  1704 ?        Ds   14:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136359  0.0  0.0   2604  1728 ?        Ds   14:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136375  0.0  0.0   2604  1716 ?        Ds   14:21   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136384  0.0  0.0   2604  1752 ?        Ds   14:21   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136391  0.0  0.0   2604  1772 ?        Ds   14:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136399  0.0  0.0   2604  1700 ?        Ds   14:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136406  0.0  0.0   2604  1732 ?        Ds   14:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136415  0.0  0.0   2604  1716 ?        Ds   14:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136424  0.0  0.0   2604  1804 ?        Ds   14:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136431  0.0  0.0   2604  1728 ?        Ds   14:22   0:00 /u=
sr/lib/ssh/sftp-server
> root      136434  0.0  0.0      0     0 ?        D    14:23   0:00 [k=
worker/u64:160+flush-btrfs-1]
> hasi      136442  0.0  0.0   2604  1704 ?        Ds   14:23   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136450  0.0  0.0   2604  1716 ?        Ds   14:23   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136458  0.0  0.0   2604  1872 ?        Ds   14:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136465  0.0  0.0   2604  1752 ?        Ds   14:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136473  0.0  0.0   2604  1864 ?        Ds   14:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136480  0.0  0.0   2604  1700 ?        Ds   14:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136487  0.0  0.0   2604  1908 ?        Ds   14:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136495  0.0  0.0   2604  1944 ?        Ds   14:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136507  0.0  0.0   2604  1688 ?        Ds   14:26   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136516  0.0  0.0   2604  1908 ?        Ds   14:26   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136526  0.0  0.0   2604  2044 ?        Ds   14:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136537  0.0  0.0   2604  1880 ?        Ds   14:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136545  0.0  0.0   2604  1944 ?        Ds   14:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136554  0.0  0.0   2604  1960 ?        Ds   14:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136569  0.0  0.0   2604  1944 ?        Ds   14:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136577  0.0  0.0   2604  1716 ?        Ds   14:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136587  0.0  0.0   2604  1864 ?        Ds   14:28   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136596  0.0  0.0   2604  1700 ?        Ds   14:28   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136604  0.0  0.0   2604  1864 ?        Ds   14:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136611  0.0  0.0   2604  1716 ?        Ds   14:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136619  0.0  0.0   2604  1728 ?        Ds   14:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136626  0.0  0.0   2604  1716 ?        Ds   14:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136633  0.0  0.0   2604  1716 ?        Ds   14:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136640  0.0  0.0   2604  1904 ?        Ds   14:29   0:00 /u=
sr/lib/ssh/sftp-server
> root      136644  0.0  0.0      0     0 ?        D    14:29   0:00 [k=
worker/u64:161+flush-btrfs-1]
> root      136646  0.0  0.0      0     0 ?        D    14:29   0:00 [k=
worker/u64:162+flush-btrfs-1]
> hasi      136657  0.0  0.0   2604  2016 ?        Ds   14:31   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136668  0.0  0.0   2604  1704 ?        Ds   14:31   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136678  0.0  0.0   2604  1712 ?        Ds   14:32   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136689  0.0  0.0   2604  1804 ?        Ds   14:32   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136692  0.0  0.0   2604  1972 ?        Ds   14:32   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136703  0.0  0.0   2604  1752 ?        Ds   14:32   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136712  0.0  0.0   2604  1688 ?        Ds   14:32   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136719  0.0  0.0   2604  1772 ?        Ds   14:32   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136729  0.0  0.0   2604  1776 ?        Ds   14:33   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136740  0.0  0.0   2604  1972 ?        Ds   14:33   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136751  0.0  0.0   2604  1944 ?        Ds   14:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136758  0.0  0.0   2604  1804 ?        Ds   14:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136766  0.0  0.0   2604  1944 ?        Ds   14:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136773  0.0  0.0   2604  1872 ?        Ds   14:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136780  0.0  0.0   2604  1860 ?        Ds   14:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136787  0.0  0.0   2604  1688 ?        Ds   14:34   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136799  0.0  0.0   2604  1772 ?        Ds   14:36   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136807  0.0  0.0   2604  1596 ?        Ds   14:36   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136815  0.0  0.0   2604  1972 ?        Ds   14:37   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136827  0.0  0.0   2604  1900 ?        Ds   14:37   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136836  0.0  0.0   2604  1916 ?        Ds   14:37   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136845  0.0  0.0   2604  1716 ?        Ds   14:37   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136855  0.0  0.0   2604  1776 ?        Ds   14:37   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136862  0.0  0.0   2604  1772 ?        Ds   14:37   0:00 /u=
sr/lib/ssh/sftp-server
> root      136866  0.0  0.0      0     0 ?        D    14:38   0:00 [k=
worker/u64:163+flush-btrfs-1]
> hasi      136874  0.0  0.0   2604  1900 ?        Ds   14:38   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136906  0.0  0.0   2604  1776 ?        Ds   14:38   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136914  0.0  0.0   2604  1732 ?        Ds   14:39   0:00 /u=
sr/lib/ssh/sftp-server
> root      136915  0.0  0.0      0     0 ?        D    14:39   0:00 [k=
worker/u64:164+flush-btrfs-1]
> hasi      136922  0.0  0.0   2604  1752 ?        Ds   14:39   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136930  0.0  0.0   2604  1688 ?        Ds   14:39   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136941  0.0  0.0   2604  1596 ?        Ds   14:39   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136948  0.0  0.0   2604  1916 ?        Ds   14:39   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136955  0.0  0.0   2604  1700 ?        Ds   14:39   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136975  0.0  0.0   2604  1728 ?        Ds   14:41   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136984  0.0  0.0   2604  1688 ?        Ds   14:41   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      136993  0.0  0.0   2604  1700 ?        Ds   14:42   0:00 /u=
sr/lib/ssh/sftp-server
> root      136994  0.0  0.0      0     0 ?        D    14:42   0:00 [k=
worker/u64:165+flush-btrfs-1]
> hasi      137001  0.0  0.0   2604  1872 ?        Ds   14:42   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137008  0.0  0.0   2604  1972 ?        Ds   14:42   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137019  0.0  0.0   2604  1716 ?        Ds   14:42   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137028  0.0  0.0   2604  1864 ?        Ds   14:42   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137035  0.0  0.0   2604  1704 ?        Ds   14:42   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137045  0.0  0.0   2604  1732 ?        Ds   14:43   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137053  0.0  0.0   2604  1732 ?        Ds   14:43   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137061  0.0  0.0   2604  1716 ?        Ds   14:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137071  0.0  0.0   2604  1688 ?        Ds   14:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137079  0.0  0.0   2604  1900 ?        Ds   14:44   0:00 /u=
sr/lib/ssh/sftp-server
> root      137081  0.0  0.0      0     0 ?        D    14:44   0:00 [k=
worker/u64:166+flush-btrfs-1]
> root      137082  0.0  0.0      0     0 ?        D    14:44   0:00 [k=
worker/u64:167+flush-btrfs-1]
> hasi      137089  0.0  0.0   2604  1716 ?        Ds   14:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137096  0.0  0.0   2604  1716 ?        Ds   14:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137103  0.0  0.0   2604  1700 ?        Ds   14:44   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137115  0.0  0.0   2604  1772 ?        Ds   14:46   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137123  0.0  0.0   2604  1904 ?        Ds   14:46   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137133  0.0  0.0   2604  1772 ?        Ds   14:47   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137140  0.0  0.0   2604  1596 ?        Ds   14:47   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137147  0.0  0.0   2604  1732 ?        Ds   14:47   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137156  0.0  0.0   2604  1704 ?        Ds   14:47   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137166  0.0  0.0   2604  1700 ?        Ds   14:47   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137175  0.0  0.0   2604  1776 ?        Ds   14:47   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137188  0.0  0.0   2604  1804 ?        Ds   14:48   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137200  0.0  0.0   2604  2044 ?        Ds   14:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137207  0.0  0.0   2604  1944 ?        Ds   14:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137214  0.0  0.0   2604  1732 ?        Ds   14:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137222  0.0  0.0   2604  1872 ?        Ds   14:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137229  0.0  0.0   2604  1960 ?        Ds   14:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137239  0.0  0.0   2604  1716 ?        Ds   14:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137246  0.0  0.0   2604  1688 ?        Ds   14:49   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137257  0.0  0.0   2604  1704 ?        Ds   14:51   0:00 /u=
sr/lib/ssh/sftp-server
> root      137258  0.0  0.0      0     0 ?        D    14:51   0:00 [k=
worker/u64:168+flush-btrfs-1]
> hasi      137266  0.0  0.0   2604  1864 ?        Ds   14:51   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137274  0.0  0.0   2604  1700 ?        Ds   14:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137281  0.0  0.0   2604  1688 ?        Ds   14:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137288  0.0  0.0   2604  1716 ?        Ds   14:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137297  0.0  0.0   2604  1752 ?        Ds   14:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137307  0.0  0.0   2604  1804 ?        Ds   14:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137314  0.0  0.0   2604  1752 ?        Ds   14:52   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137325  0.0  0.0   2604  1716 ?        Ds   14:53   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137335  0.0  0.0   2604  1900 ?        Ds   14:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137344  0.0  0.0   2604  1772 ?        Ds   14:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137351  0.0  0.0   2604  1944 ?        Ds   14:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137359  0.0  0.0   2604  1704 ?        Ds   14:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137366  0.0  0.0   2604  1704 ?        Ds   14:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137373  0.0  0.0   2604  1960 ?        Ds   14:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137381  0.0  0.0   2604  1872 ?        Ds   14:54   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137398  0.0  0.0   2604  1732 ?        Ds   14:56   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137407  0.0  0.0   2604  1716 ?        Ds   14:56   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137415  0.0  0.0   2604  1700 ?        Ds   14:57   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137422  0.0  0.0   2604  1772 ?        Ds   14:57   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137429  0.0  0.0   2604  1704 ?        Ds   14:57   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137438  0.0  0.0   2604  1776 ?        Ds   14:57   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137448  0.0  0.0   2604  1700 ?        Ds   14:57   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137455  0.0  0.0   2604  1732 ?        Ds   14:57   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137465  0.0  0.0   2604  1752 ?        Ds   14:58   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137479  0.0  0.0   2604  1752 ?        Ds   14:59   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137486  0.0  0.0   2604  1804 ?        Ds   14:59   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137493  0.0  0.0   2604  1864 ?        Ds   14:59   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137501  0.0  0.0   2604  1916 ?        Ds   14:59   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137508  0.0  0.0   2604  1772 ?        Ds   14:59   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137515  0.0  0.0   2604  2072 ?        Ds   14:59   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137530  0.0  0.0   2604  1716 ?        Ds   15:00   0:00 /u=
sr/lib/ssh/sftp-server
> root      137531  0.0  0.0      0     0 ?        D    15:00   0:00 [k=
worker/u64:171+flush-btrfs-1]
> hasi      137547  0.0  0.0   2604  1864 ?        Ds   15:01   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137557  0.0  0.0   2604  1804 ?        Ds   15:01   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137566  0.0  0.0   2604  1716 ?        Ds   15:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137573  0.0  0.0   2604  1772 ?        Ds   15:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137580  0.0  0.0   2604  1732 ?        Ds   15:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137589  0.0  0.0   2604  1596 ?        Ds   15:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137598  0.0  0.0   2604  1596 ?        Ds   15:02   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137605  0.0  0.0   2604  1700 ?        Ds   15:02   0:00 /u=
sr/lib/ssh/sftp-server
> root      137609  0.0  0.0      0     0 ?        D    15:03   0:00 [k=
worker/u64:172+flush-btrfs-1]
> root      137611  0.0  0.0      0     0 ?        D    15:03   0:00 [k=
worker/u64:173+flush-btrfs-1]
> hasi      137625  0.0  0.0   2604  1816 ?        Ds   15:03   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137640  0.0  0.0   2604  1688 ?        Ds   15:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137647  0.0  0.0   2604  2044 ?        Ds   15:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137656  0.0  0.0   2604  1944 ?        Ds   15:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137664  0.0  0.0   2604  1944 ?        Ds   15:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137671  0.0  0.0   2604  1944 ?        Ds   15:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137678  0.0  0.0   2604  1916 ?        Ds   15:04   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137688  0.0  0.0   2604  1772 ?        Ds   15:05   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137699  0.0  0.0   2604  1704 ?        Ds   15:06   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137709  0.0  0.0   2604  1728 ?        Ds   15:06   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137717  0.0  0.0   2604  1776 ?        Ds   15:07   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137724  0.0  0.0   2604  2016 ?        Ds   15:07   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137732  0.0  0.0   2604  1752 ?        Ds   15:07   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137739  0.0  0.0   2604  1916 ?        Ds   15:07   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137748  0.0  0.0   2604  1864 ?        Ds   15:07   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137755  0.0  0.0   2604  1704 ?        Ds   15:07   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137766  0.0  0.0   2604  1688 ?        Ds   15:08   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137778  0.0  0.0   2604  1704 ?        Ds   15:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137785  0.0  0.0   2604  1772 ?        Ds   15:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137792  0.0  0.0   2604  1700 ?        Ds   15:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137800  0.0  0.0   2604  1596 ?        Ds   15:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137807  0.0  0.0   2604  1804 ?        Ds   15:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137816  0.0  0.0   2604  2044 ?        Ds   15:09   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137826  0.0  0.0   2604  1776 ?        Ds   15:10   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137844  0.0  0.0   2604  1816 ?        Ds   15:11   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137856  0.0  0.0   2604  1844 ?        Ds   15:11   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137865  0.0  0.0   2604  1732 ?        Ds   15:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137872  0.0  0.0   2604  1772 ?        Ds   15:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137879  0.0  0.0   2604  1752 ?        Ds   15:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137886  0.0  0.0   2604  1700 ?        Ds   15:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137895  0.0  0.0   2604  1596 ?        Ds   15:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137902  0.0  0.0   2604  1944 ?        Ds   15:12   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137914  0.0  0.0   2604  1752 ?        Ds   15:13   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137925  0.0  0.0   2604  1716 ?        Ds   15:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137932  0.0  0.0   2604  1700 ?        Ds   15:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137939  0.0  0.0   2604  1704 ?        Ds   15:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137947  0.0  0.0   2604  1960 ?        Ds   15:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137956  0.0  0.0   2604  1732 ?        Ds   15:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137963  0.0  0.0   2604  1716 ?        Ds   15:14   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137977  0.0  0.0   2604  1716 ?        Ds   15:15   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      137992  0.0  0.0   2604  1716 ?        Ds   15:16   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138002  0.0  0.0   2604  1872 ?        Ds   15:16   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138011  0.0  0.0   2604  1716 ?        Ds   15:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138018  0.0  0.0   2604  1872 ?        Ds   15:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138025  0.0  0.0   2604  1804 ?        Ds   15:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138046  0.0  0.0   2604  1880 ?        Ds   15:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138057  0.0  0.0   2604  1988 ?        Ds   15:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138065  0.0  0.0   2604  1844 ?        Ds   15:17   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138088  0.0  0.0   2604  1864 ?        Ds   15:18   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138099  0.0  0.0   2604  1752 ?        Ds   15:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138106  0.0  0.0   2604  1916 ?        Ds   15:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138113  0.0  0.0   2604  1704 ?        Ds   15:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138121  0.0  0.0   2604  1872 ?        Ds   15:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138132  0.0  0.0   2604  1776 ?        Ds   15:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138139  0.0  0.0   2604  1688 ?        Ds   15:19   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138147  0.0  0.0   2604  1732 ?        Ds   15:20   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138162  0.0  0.0   2604  1880 ?        Ds   15:21   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138173  0.0  0.0   2604  1944 ?        Ds   15:21   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138182  0.0  0.0   2604  1776 ?        Ds   15:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138189  0.0  0.0   2604  1716 ?        Ds   15:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138196  0.0  0.0   2604  1688 ?        Ds   15:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138203  0.0  0.0   2604  1776 ?        Ds   15:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138212  0.0  0.0   2604  1872 ?        Ds   15:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138219  0.0  0.0   2604  1688 ?        Ds   15:22   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138229  0.0  0.0   2604  1716 ?        Ds   15:23   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138243  0.0  0.0   2604  1944 ?        Ds   15:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138250  0.0  0.0   2604  1728 ?        Ds   15:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138257  0.0  0.0   2604  1900 ?        Ds   15:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138267  0.0  0.0   2604  1904 ?        Ds   15:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138276  0.0  0.0   2604  1688 ?        Ds   15:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138283  0.0  0.0   2604  1700 ?        Ds   15:24   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138293  0.0  0.0   2604  1816 ?        Ds   15:25   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138305  0.0  0.0   2604  1596 ?        Ds   15:26   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138315  0.0  0.0   2604  1688 ?        Ds   15:26   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138326  0.0  0.0   2604  1728 ?        Ds   15:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138333  0.0  0.0   2604  1716 ?        Ds   15:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138340  0.0  0.0   2604  1716 ?        Ds   15:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138347  0.0  0.0   2604  1596 ?        Ds   15:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138356  0.0  0.0   2604  1776 ?        Ds   15:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138363  0.0  0.0   2604  1688 ?        Ds   15:27   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138373  0.0  0.0   2604  1716 ?        Ds   15:28   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138384  0.0  0.0   2604  1688 ?        Ds   15:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138391  0.0  0.0   2604  1596 ?        Ds   15:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138398  0.0  0.0   2604  1728 ?        Ds   15:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138406  0.0  0.0   2604  1716 ?        Ds   15:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138413  0.0  0.0   2604  1872 ?        Ds   15:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138423  0.0  0.0   2604  1916 ?        Ds   15:29   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138433  0.0  0.0   2604  1804 ?        Ds   15:30   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138455  0.0  0.0   2604  1804 ?        Ds   15:31   0:00 /u=
sr/lib/ssh/sftp-server
> hasi      138470  0.0  0.0   2604  2072 ?        Ds   15:31   0:00 /u=
sr/lib/ssh/sftp-server
> root      138974  0.0  0.0   3936  2080 pts/2    S+   16:32   0:00 gr=
ep         D
> [root@coldnas ~]# uname -a
> Linux coldnas 6.10.5-arch1-1 #1 SMP PREEMPT_DYNAMIC Thu, 15 Aug 2024 =
00:25:30 +0000 x86_64 GNU/Linux


>> Am 08.08.2024 um 16:23 schrieb John Stoffel <john@stoffel.org>:
>>=20
>>>>>>> "Christian" =3D=3D Christian Theune <ct@flyingcircus.io> writes=
:
>>=20
>>> Hi,
>>>> On 7. Aug 2024, at 23:05, John Stoffel <john@stoffel.org> wrote:
>>>>=20
>>>>>>>>> "Christian" =3D=3D Christian Theune <ct@flyingcircus.io> writ=
es:
>>>>=20
>>>>=20
>>>>=20
>>>>> i had some more time at hand and managent to compile 5.15.164. Th=
e
>>>>> issue is the same. After around 1h30m of work it hangs.  I=E2=80=99=
ll try to
>>>>> reproduce this on a newer supported kernel if I can.
>>>>=20
>>>> Supported by who?   NixOS?  Why don't you just install linux kerne=
l
>>>> 6.6.x and see of the problem is still there?  5.15.x is ancient an=
d
>>>> un-supported upstream now. =20
>>=20
>>> I did just that. However, 5.15 =E2=80=9Cun-supported=E2=80=9D by up=
stream is
>>> confusing me. It=E2=80=99s an official LTS kernel with an EOL of De=
cember
>>> 2026.
>>=20
>> To quote the kernel.org:
>>=20
>> Longterm
>>=20
>> There are usually several "longterm maintenance" kernel releases
>> provided for the purposes of backporting bugfixes for older kernel
>> trees. Only important bugfixes are applied to such kernels and they
>> don't usually see very frequent releases, especially for older trees=
.
>>=20
>> So when we run into people having problems with LTS kernels, the fir=
st
>> thing we ask is for them to run the most recent kernels, because
>> that's where the bug fixing happens. =20
>>=20
>> In any case, there have been some bugs in recent RAID5/RAID6 setups,=

>> so going to a recent kernel will help track these down.=20
>>=20
>>=20
>>> Also, I=E2=80=99d like to note that NixOS kernels tend to be very c=
lose to
>>> upstream. The only patches that I can see are involved here are
>>> those that patch out some hard coded references to user space paths=
:
>>=20
>> Not in this case, kernel 5.15 is ancient, you should be running 6.9.=
x
>> or even newer for debugging issues like this.=20
>>=20
>>> https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/linux-k=
ernels.nix#L173
>>> https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux=
/kernel/request-key-helper.patch
>>> https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux=
/kernel/bridge-stp-helper.patch
>>=20
>>> Kernel is now:
>>=20
>>> Linux barbrady08 6.10.3 #1-NixOS SMP PREEMPT_DYNAMIC Sat Aug  3 07:=
01:09 UTC 2024 x86_64 GNU/Linux
>>=20
>>=20
>>> The issue is still there on 6.10.3 and now looks like shown below.
>>=20
>> Great!  Thanks for doing this change, this will let the developers
>> help you more easily.=20
>>=20
>>> I=E2=80=99m aware that this is output that shows symptoms and not
>>> (necessarily) the cause. I=E2=80=99m currently a bit out of ideas w=
here to
>>> look for more information and would appreciate any pointers. My
>>> suspicion is an interaction problem triggered by the use of NVMe in=

>>> combination with other systems (xfs, dm-crypt and raid are the ones=

>>> I=E2=80=99m aware of playign a role).
>>=20
>>> The use of NVMe itself likely isn=E2=80=99t the issue (we=E2=80=99v=
e been using NVMe
>>> on similar hosts and also in combination with dm-crypt with this
>>> kernel for a while now) and I could imagine that it triggers a race=

>>> condition due to the higher performance - although the specific
>>> performance parameters aren't *that* high. Right before the lockup =
I
>>> see ~700 IOPS reading and ~2.5k IOPS writing. So we have seen NVMe
>>> with dm-crypt but not with raid before.
>>=20
>>> I can perform debugging on that machine as needed, but googling for=

>>> any combination of hung tasks related to nvme/xfs/crypt/raid only
>>> ends up showing me generic performance concerns from forum, an
>>> unrelated xfs issue mentioned by redhat and the list archive entry
>>> from this post.
>>=20
>> Can you try setting up some loop devices in the same type of
>> configuration, and seeing if you can replicate the issue that way?
>> Let's try to get the nvme stuff out of the way to see if this can be=

>> replicated more easily. =20
>>=20
>>=20
>>> [ 7497.019235] INFO: task .backy-wrapped:2706 blocked for more than=
 122 seconds.
>>> [ 7497.027265]       Not tainted 6.10.3 #1-NixOS
>>> [ 7497.032173] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" d=
isables this message.
>>> [ 7497.040974] task:.backy-wrapped  state:D stack:0     pid:2706  t=
gid:2706  ppid:1      flags:0x00000002
>>> [ 7497.040979] Call Trace:
>>> [ 7497.040981]  <TASK>
>>> [ 7497.040987]  __schedule+0x3fa/0x1550
>>> [ 7497.040996]  ? xfs_iextents_copy+0xec/0x1b0 [xfs]
>>> [ 7497.041085]  ? srso_alias_return_thunk+0x5/0xfbef5
>>> [ 7497.041089]  ? xlog_copy_iovec+0x30/0x90 [xfs]
>>> [ 7497.041168]  schedule+0x27/0xf0
>>> [ 7497.041171]  io_schedule+0x46/0x70
>>> [ 7497.041173]  folio_wait_bit_common+0x13f/0x340
>>> [ 7497.041180]  ? __pfx_wake_page_function+0x10/0x10
>>> [ 7497.041187]  folio_wait_writeback+0x2b/0x80
>>> [ 7497.041191]  truncate_inode_partial_folio+0x5b/0x190
>>> [ 7497.041194]  truncate_inode_pages_range+0x1de/0x400
>>> [ 7497.041207]  evict+0x1b0/0x1d0
>>> [ 7497.041212]  __dentry_kill+0x6e/0x170
>>> [ 7497.041216]  dput+0xe5/0x1b0
>>> [ 7497.041218]  do_renameat2+0x386/0x600
>>> [ 7497.041226]  __x64_sys_rename+0x43/0x50
>>> [ 7497.041229]  do_syscall_64+0xb7/0x200
>>> [ 7497.041234]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>> [ 7497.041236] RIP: 0033:0x7f4be586f75b
>>> [ 7497.041265] RSP: 002b:00007fffd2706538 EFLAGS: 00000246 ORIG_RAX=
: 0000000000000052
>>> [ 7497.041267] RAX: ffffffffffffffda RBX: 00007fffd27065d0 RCX: 000=
07f4be586f75b
>>> [ 7497.041269] RDX: 0000000000000000 RSI: 00007f4bd6f73e50 RDI: 000=
07f4bd6f732d0
>>> [ 7497.041270] RBP: 00007fffd2706580 R08: 00000000ffffffff R09: 000=
0000000000000
>>> [ 7497.041271] R10: 00007fffd27067b0 R11: 0000000000000246 R12: 000=
00000ffffff9c
>>> [ 7497.041273] R13: 00000000ffffff9c R14: 0000000037fb4ab0 R15: 000=
07f4be5814810
>>> [ 7497.041277]  </TASK>
>>> [ 7497.041281] INFO: task kworker/u131:1:12780 blocked for more tha=
n 122 seconds.
>>> [ 7497.049410]       Not tainted 6.10.3 #1-NixOS
>>> [ 7497.054317] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" d=
isables this message.
>>> [ 7497.063124] task:kworker/u131:1  state:D stack:0     pid:12780 t=
gid:12780 ppid:2      flags:0x00004000
>>> [ 7497.063131] Workqueue: kcryptd-253:4-1 kcryptd_crypt [dm_crypt]
>>> [ 7497.063140] Call Trace:
>>> [ 7497.063141]  <TASK>
>>> [ 7497.063145]  __schedule+0x3fa/0x1550
>>> [ 7497.063154]  schedule+0x27/0xf0
>>> [ 7497.063156]  md_bitmap_startwrite+0x14f/0x1c0
>>> [ 7497.063160]  ? __pfx_autoremove_wake_function+0x10/0x10
>>> [ 7497.063168]  __add_stripe_bio+0x1f4/0x240 [raid456]
>>> [ 7497.063175]  raid5_make_request+0x34d/0x1280 [raid456]
>>> [ 7497.063182]  ? __pfx_woken_wake_function+0x10/0x10
>>> [ 7497.063184]  ? bio_split_rw+0x193/0x260
>>> [ 7497.063190]  md_handle_request+0x153/0x270
>>> [ 7497.063194]  ? srso_alias_return_thunk+0x5/0xfbef5
>>> [ 7497.063198]  __submit_bio+0x190/0x240
>>> [ 7497.063203]  submit_bio_noacct_nocheck+0x19a/0x3c0
>>> [ 7497.063205]  ? srso_alias_return_thunk+0x5/0xfbef5
>>> [ 7497.063207]  ? submit_bio_noacct+0x46/0x5a0
>>> [ 7497.063210]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
>>> [ 7497.063214]  process_one_work+0x18f/0x3b0
>>> [ 7497.063219]  worker_thread+0x233/0x340
>>> [ 7497.063222]  ? __pfx_worker_thread+0x10/0x10
>>> [ 7497.063225]  kthread+0xcd/0x100
>>> [ 7497.063228]  ? __pfx_kthread+0x10/0x10
>>> [ 7497.063230]  ret_from_fork+0x31/0x50
>>> [ 7497.063234]  ? __pfx_kthread+0x10/0x10
>>> [ 7497.063236]  ret_from_fork_asm+0x1a/0x30
>>> [ 7497.063243]  </TASK>
>>> [ 7497.063246] INFO: task kworker/u131:0:17487 blocked for more tha=
n 122 seconds.
>>> [ 7497.071367]       Not tainted 6.10.3 #1-NixOS
>>> [ 7497.076269] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" d=
isables this message.
>>> [ 7497.085073] task:kworker/u131:0  state:D stack:0     pid:17487 t=
gid:17487 ppid:2      flags:0x00004000
>>> [ 7497.085081] Workqueue: kcryptd-253:4-1 kcryptd_crypt [dm_crypt]
>>> [ 7497.085086] Call Trace:
>>> [ 7497.085087]  <TASK>
>>> [ 7497.085089]  __schedule+0x3fa/0x1550
>>> [ 7497.085094]  schedule+0x27/0xf0
>>> [ 7497.085096]  md_bitmap_startwrite+0x14f/0x1c0
>>> [ 7497.085098]  ? __pfx_autoremove_wake_function+0x10/0x10
>>> [ 7497.085102]  __add_stripe_bio+0x1f4/0x240 [raid456]
>>> [ 7497.085108]  raid5_make_request+0x34d/0x1280 [raid456]
>>> [ 7497.085114]  ? __pfx_woken_wake_function+0x10/0x10
>>> [ 7497.085116]  ? bio_split_rw+0x193/0x260
>>> [ 7497.085120]  md_handle_request+0x153/0x270
>>> [ 7497.085122]  ? srso_alias_return_thunk+0x5/0xfbef5
>>> [ 7497.085125]  __submit_bio+0x190/0x240
>>> [ 7497.085128]  submit_bio_noacct_nocheck+0x19a/0x3c0
>>> [ 7497.085131]  ? srso_alias_return_thunk+0x5/0xfbef5
>>> [ 7497.085133]  ? submit_bio_noacct+0x46/0x5a0
>>> [ 7497.085135]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
>>> [ 7497.085138]  process_one_work+0x18f/0x3b0
>>> [ 7497.085142]  worker_thread+0x233/0x340
>>> [ 7497.085145]  ? __pfx_worker_thread+0x10/0x10
>>> [ 7497.085148]  ? __pfx_worker_thread+0x10/0x10
>>> [ 7497.085150]  kthread+0xcd/0x100
>>> [ 7497.085152]  ? __pfx_kthread+0x10/0x10
>>> [ 7497.085155]  ret_from_fork+0x31/0x50
>>> [ 7497.085157]  ? __pfx_kthread+0x10/0x10
>>> [ 7497.085159]  ret_from_fork_asm+0x1a/0x30
>>> [ 7497.085164]  </TASK>
>>> [ 7497.085165] INFO: task kworker/u131:2:18973 blocked for more tha=
n 122 seconds.
>>> [ 7497.093282]       Not tainted 6.10.3 #1-NixOS
>>> [ 7497.098185] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" d=
isables this message.
>>> [ 7497.106988] task:kworker/u131:2  state:D stack:0     pid:18973 t=
gid:18973 ppid:2      flags:0x00004000
>>> [ 7497.106993] Workqueue: kcryptd-253:4-1 kcryptd_crypt [dm_crypt]
>>> [ 7497.106998] Call Trace:
>>> [ 7497.106999]  <TASK>
>>> [ 7497.107001]  __schedule+0x3fa/0x1550
>>> [ 7497.107006]  schedule+0x27/0xf0
>>> [ 7497.107009]  md_bitmap_startwrite+0x14f/0x1c0
>>> [ 7497.107012]  ? __pfx_autoremove_wake_function+0x10/0x10
>>> [ 7497.107016]  __add_stripe_bio+0x1f4/0x240 [raid456]
>>> [ 7497.107021]  raid5_make_request+0x34d/0x1280 [raid456]
>>> [ 7497.107026]  ? __pfx_woken_wake_function+0x10/0x10
>>> [ 7497.107028]  ? bio_split_rw+0x193/0x260
>>> [ 7497.107033]  md_handle_request+0x153/0x270
>>> [ 7497.107036]  ? srso_alias_return_thunk+0x5/0xfbef5
>>> [ 7497.107039]  __submit_bio+0x190/0x240
>>> [ 7497.107042]  submit_bio_noacct_nocheck+0x19a/0x3c0
>>> [ 7497.107044]  ? srso_alias_return_thunk+0x5/0xfbef5
>>> [ 7497.107046]  ? submit_bio_noacct+0x46/0x5a0
>>> [ 7497.107049]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
>>> [ 7497.107052]  process_one_work+0x18f/0x3b0
>>> [ 7497.107055]  worker_thread+0x233/0x340
>>> [ 7497.107058]  ? __pfx_worker_thread+0x10/0x10
>>> [ 7497.107060]  ? __pfx_worker_thread+0x10/0x10
>>> [ 7497.107063]  kthread+0xcd/0x100
>>> [ 7497.107065]  ? __pfx_kthread+0x10/0x10
>>> [ 7497.107067]  ret_from_fork+0x31/0x50
>>> [ 7497.107069]  ? __pfx_kthread+0x10/0x10
>>> [ 7497.107071]  ret_from_fork_asm+0x1a/0x30
>>> [ 7497.107081]  </TASK>
>>> [ 7497.107086] INFO: task rsync:23530 blocked for more than 122 sec=
onds.
>>> [ 7497.114327]       Not tainted 6.10.3 #1-NixOS
>>> [ 7497.119226] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" d=
isables this message.
>>> [ 7497.128020] task:rsync           state:D stack:0     pid:23530 t=
gid:23530 ppid:23520  flags:0x00000000
>>> [ 7497.128024] Call Trace:
>>> [ 7497.128025]  <TASK>
>>> [ 7497.128027]  __schedule+0x3fa/0x1550
>>> [ 7497.128030]  ? srso_alias_return_thunk+0x5/0xfbef5
>>> [ 7497.128034]  schedule+0x27/0xf0
>>> [ 7497.128036]  schedule_timeout+0x15d/0x170
>>> [ 7497.128040]  __down_common+0x119/0x220
>>> [ 7497.128045]  down+0x47/0x60
>>> [ 7497.128048]  xfs_buf_lock+0x31/0xe0 [xfs]
>>> [ 7497.128131]  xfs_buf_find_lock+0x55/0x100 [xfs]
>>> [ 7497.128185]  xfs_buf_get_map+0x1ea/0xa80 [xfs]
>>> [ 7497.128236]  xfs_buf_read_map+0x62/0x2a0 [xfs]
>>> [ 7497.128287]  ? xfs_read_agf+0x97/0x150 [xfs]
>>> [ 7497.128357]  xfs_trans_read_buf_map+0x12e/0x310 [xfs]
>>> [ 7497.128429]  ? xfs_read_agf+0x97/0x150 [xfs]
>>> [ 7497.128489]  xfs_read_agf+0x97/0x150 [xfs]
>>> [ 7497.128540]  xfs_alloc_read_agf+0x5a/0x200 [xfs]
>>> [ 7497.128589]  xfs_alloc_fix_freelist+0x345/0x660 [xfs]
>>> [ 7497.128641]  xfs_alloc_vextent_prepare_ag+0x2d/0x120 [xfs]
>>> [ 7497.128690]  xfs_alloc_vextent_exact_bno+0xd1/0x100 [xfs]
>>> [ 7497.128740]  xfs_ialloc_ag_alloc+0x177/0x610 [xfs]
>>> [ 7497.128812]  xfs_dialloc+0x219/0x7b0 [xfs]
>>> [ 7497.128864]  ? xfs_trans_alloc_icreate+0x93/0x120 [xfs]
>>> [ 7497.128935]  xfs_create+0x2c7/0x640 [xfs]
>>> [ 7497.128998]  ? srso_alias_return_thunk+0x5/0xfbef5
>>> [ 7497.129001]  ? srso_alias_return_thunk+0x5/0xfbef5
>>> [ 7497.129003]  ? get_cached_acl+0x4c/0x90
>>> [ 7497.129008]  xfs_generic_create+0x321/0x3a0 [xfs]
>>> [ 7497.129061]  ? srso_alias_return_thunk+0x5/0xfbef5
>>> [ 7497.129065]  path_openat+0xf82/0x1240
>>> [ 7497.129072]  do_filp_open+0xc4/0x170
>>> [ 7497.129084]  do_sys_openat2+0xab/0xe0
>>> [ 7497.129090]  __x64_sys_openat+0x57/0xa0
>>> [ 7497.129093]  do_syscall_64+0xb7/0x200
>>> [ 7497.129096]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>> [ 7497.129099] RIP: 0033:0x7f6809d2be2f
>>> [ 7497.129121] RSP: 002b:00007ffe3d410cf0 EFLAGS: 00000246 ORIG_RAX=
: 0000000000000101
>>> [ 7497.129123] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 000=
07f6809d2be2f
>>> [ 7497.129124] RDX: 00000000000000c2 RSI: 00007ffe3d412fc0 RDI: 000=
00000ffffff9c
>>> [ 7497.129126] RBP: 000000000003a2f8 R08: 001f1108db8eff56 R09: 000=
07ffe3d410f2c
>>> [ 7497.129128] R10: 0000000000000180 R11: 0000000000000246 R12: 000=
07ffe3d41300b
>>> [ 7497.129129] R13: 00007ffe3d412fc0 R14: 8421084210842109 R15: 000=
07f6809dc6a80
>>> [ 7497.129133]  </TASK>
>>> [ 7497.129146] INFO: task kworker/u131:3:23611 blocked for more tha=
n 122 seconds.
>>> [ 7497.137277]       Not tainted 6.10.3 #1-NixOS
>>> [ 7497.142187] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" d=
isables this message.
>>> [ 7497.150980] task:kworker/u131:3  state:D stack:0     pid:23611 t=
gid:23611 ppid:2      flags:0x00004000
>>> [ 7497.150986] Workqueue: writeback wb_workfn (flush-253:4)
>>> [ 7497.150993] Call Trace:
>>> [ 7497.150995]  <TASK>
>>> [ 7497.150998]  __schedule+0x3fa/0x1550
>>> [ 7497.151007]  schedule+0x27/0xf0
>>> [ 7497.151009]  schedule_timeout+0x15d/0x170
>>> [ 7497.151013]  __wait_for_common+0x90/0x1c0
>>> [ 7497.151015]  ? __pfx_schedule_timeout+0x10/0x10
>>> [ 7497.151020]  xfs_buf_iowait+0x1c/0xc0 [xfs]
>>> [ 7497.151094]  __xfs_buf_submit+0x132/0x1e0 [xfs]
>>> [ 7497.151146]  xfs_buf_read_map+0x129/0x2a0 [xfs]
>>> [ 7497.151197]  ? xfs_btree_read_buf_block+0xa7/0x120 [xfs]
>>> [ 7497.151267]  xfs_trans_read_buf_map+0x12e/0x310 [xfs]
>>> [ 7497.151336]  ? xfs_btree_read_buf_block+0xa7/0x120 [xfs]
>>> [ 7497.151396]  xfs_btree_read_buf_block+0xa7/0x120 [xfs]
>>> [ 7497.151446]  xfs_btree_lookup_get_block+0xa6/0x1f0 [xfs]
>>> [ 7497.151497]  xfs_btree_lookup+0xea/0x500 [xfs]
>>> [ 7497.151546]  ? xfs_btree_increment+0x44/0x310 [xfs]
>>> [ 7497.151596]  xfs_alloc_fixup_trees+0x66/0x4c0 [xfs]
>>> [ 7497.151661]  xfs_alloc_cur_finish+0x2b/0xa0 [xfs]
>>> [ 7497.151710]  xfs_alloc_ag_vextent_near+0x437/0x540 [xfs]
>>> [ 7497.151764]  xfs_alloc_vextent_iterate_ags.constprop.0+0xc8/0x20=
0 [xfs]
>>> [ 7497.151813]  ? srso_alias_return_thunk+0x5/0xfbef5
>>> [ 7497.151817]  ? xfs_buf_item_format+0x1b8/0x450 [xfs]
>>> [ 7497.151884]  xfs_alloc_vextent_start_ag+0xc0/0x190 [xfs]
>>> [ 7497.151938]  xfs_bmap_btalloc+0x4dd/0x640 [xfs]
>>> [ 7497.151999]  xfs_bmapi_allocate+0xac/0x2c0 [xfs]
>>> [ 7497.152048]  xfs_bmapi_convert_one_delalloc+0x1f6/0x430 [xfs]
>>> [ 7497.152105]  xfs_bmapi_convert_delalloc+0x43/0x60 [xfs]
>>> [ 7497.152155]  xfs_map_blocks+0x257/0x420 [xfs]
>>> [ 7497.152228]  iomap_writepages+0x271/0x9b0
>>> [ 7497.152235]  xfs_vm_writepages+0x67/0x90 [xfs]
>>> [ 7497.152287]  do_writepages+0x76/0x260
>>> [ 7497.152294]  ? uas_submit_urbs+0x8c/0x4c0 [uas]
>>> [ 7497.152297]  ? srso_alias_return_thunk+0x5/0xfbef5
>>> [ 7497.152300]  ? psi_group_change+0x213/0x3c0
>>> [ 7497.152305]  __writeback_single_inode+0x3d/0x350
>>> [ 7497.152307]  ? srso_alias_return_thunk+0x5/0xfbef5
>>> [ 7497.152309]  ? srso_alias_return_thunk+0x5/0xfbef5
>>> [ 7497.152312]  writeback_sb_inodes+0x21c/0x4e0
>>> [ 7497.152323]  __writeback_inodes_wb+0x4c/0xf0
>>> [ 7497.152325]  ? srso_alias_return_thunk+0x5/0xfbef5
>>> [ 7497.152328]  wb_writeback+0x193/0x310
>>> [ 7497.152332]  wb_workfn+0x357/0x450
>>> [ 7497.152337]  process_one_work+0x18f/0x3b0
>>> [ 7497.152342]  worker_thread+0x233/0x340
>>> [ 7497.152345]  ? __pfx_worker_thread+0x10/0x10
>>> [ 7497.152348]  kthread+0xcd/0x100
>>> [ 7497.152352]  ? __pfx_kthread+0x10/0x10
>>> [ 7497.152354]  ret_from_fork+0x31/0x50
>>> [ 7497.152358]  ? __pfx_kthread+0x10/0x10
>>> [ 7497.152360]  ret_from_fork_asm+0x1a/0x30
>>> [ 7497.152366]  </TASK>
>>> [ 7497.152368] INFO: task kworker/u131:4:23612 blocked for more tha=
n 123 seconds.
>>> [ 7497.160489]       Not tainted 6.10.3 #1-NixOS
>>> [ 7497.165390] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" d=
isables this message.
>>> [ 7497.174190] task:kworker/u131:4  state:D stack:0     pid:23612 t=
gid:23612 ppid:2      flags:0x00004000
>>> [ 7497.174194] Workqueue: kcryptd-253:4-1 kcryptd_crypt [dm_crypt]
>>> [ 7497.174200] Call Trace:
>>> [ 7497.174201]  <TASK>
>>> [ 7497.174203]  __schedule+0x3fa/0x1550
>>> [ 7497.174208]  schedule+0x27/0xf0
>>> [ 7497.174210]  md_bitmap_startwrite+0x14f/0x1c0
>>> [ 7497.174214]  ? __pfx_autoremove_wake_function+0x10/0x10
>>> [ 7497.174219]  __add_stripe_bio+0x1f4/0x240 [raid456]
>>> [ 7497.174227]  raid5_make_request+0x34d/0x1280 [raid456]
>>> [ 7497.174233]  ? __pfx_woken_wake_function+0x10/0x10
>>> [ 7497.174235]  ? bio_split_rw+0x193/0x260
>>> [ 7497.174242]  md_handle_request+0x153/0x270
>>> [ 7497.174245]  ? srso_alias_return_thunk+0x5/0xfbef5
>>> [ 7497.174248]  __submit_bio+0x190/0x240
>>> [ 7497.174252]  submit_bio_noacct_nocheck+0x19a/0x3c0
>>> [ 7497.174255]  ? srso_alias_return_thunk+0x5/0xfbef5
>>> [ 7497.174257]  ? submit_bio_noacct+0x46/0x5a0
>>> [ 7497.174259]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
>>> [ 7497.174263]  process_one_work+0x18f/0x3b0
>>> [ 7497.174266]  worker_thread+0x233/0x340
>>> [ 7497.174269]  ? __pfx_worker_thread+0x10/0x10
>>> [ 7497.174271]  kthread+0xcd/0x100
>>> [ 7497.174273]  ? __pfx_kthread+0x10/0x10
>>> [ 7497.174276]  ret_from_fork+0x31/0x50
>>> [ 7497.174277]  ? __pfx_kthread+0x10/0x10
>>> [ 7497.174279]  ret_from_fork_asm+0x1a/0x30
>>> [ 7497.174285]  </TASK>
>>> [ 7497.174292] INFO: task kworker/u130:33:23645 blocked for more th=
an 123 seconds.
>>> [ 7497.182499]       Not tainted 6.10.3 #1-NixOS
>>> [ 7497.187400] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" d=
isables this message.
>>> [ 7497.196203] task:kworker/u130:33 state:D stack:0     pid:23645 t=
gid:23645 ppid:2      flags:0x00004000
>>> [ 7497.196209] Workqueue: xfs-cil/dm-4 xlog_cil_push_work [xfs]
>>> [ 7497.196281] Call Trace:
>>> [ 7497.196282]  <TASK>
>>> [ 7497.196285]  __schedule+0x3fa/0x1550
>>> [ 7497.196289]  ? srso_alias_return_thunk+0x5/0xfbef5
>>> [ 7497.196293]  schedule+0x27/0xf0
>>> [ 7497.196295]  xlog_state_get_iclog_space+0x102/0x2b0 [xfs]
>>> [ 7497.196346]  ? __pfx_default_wake_function+0x10/0x10
>>> [ 7497.196351]  xlog_write_get_more_iclog_space+0xd0/0x100 [xfs]
>>> [ 7497.196400]  xlog_write+0x310/0x470 [xfs]
>>> [ 7497.196451]  xlog_cil_push_work+0x6a5/0x880 [xfs]
>>> [ 7497.196503]  process_one_work+0x18f/0x3b0
>>> [ 7497.196507]  worker_thread+0x233/0x340
>>> [ 7497.196510]  ? __pfx_worker_thread+0x10/0x10
>>> [ 7497.196512]  ? __pfx_worker_thread+0x10/0x10
>>> [ 7497.196515]  kthread+0xcd/0x100
>>> [ 7497.196517]  ? __pfx_kthread+0x10/0x10
>>> [ 7497.196519]  ret_from_fork+0x31/0x50
>>> [ 7497.196522]  ? __pfx_kthread+0x10/0x10
>>> [ 7497.196524]  ret_from_fork_asm+0x1a/0x30
>>> [ 7497.196529]  </TASK>
>>> [ 7497.196531] INFO: task kworker/u131:6:23863 blocked for more tha=
n 123 seconds.
>>> [ 7497.204648]       Not tainted 6.10.3 #1-NixOS
>>> [ 7497.209539] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" d=
isables this message.
>>> [ 7497.218347] task:kworker/u131:6  state:D stack:0     pid:23863 t=
gid:23863 ppid:2      flags:0x00004000
>>> [ 7497.218353] Workqueue: kcryptd-253:4-1 kcryptd_crypt [dm_crypt]
>>> [ 7497.218359] Call Trace:
>>> [ 7497.218360]  <TASK>
>>> [ 7497.218363]  __schedule+0x3fa/0x1550
>>> [ 7497.218369]  schedule+0x27/0xf0
>>> [ 7497.218371]  md_bitmap_startwrite+0x14f/0x1c0
>>> [ 7497.218375]  ? __pfx_autoremove_wake_function+0x10/0x10
>>> [ 7497.218379]  __add_stripe_bio+0x1f4/0x240 [raid456]
>>> [ 7497.218384]  raid5_make_request+0x34d/0x1280 [raid456]
>>> [ 7497.218390]  ? __pfx_woken_wake_function+0x10/0x10
>>> [ 7497.218392]  ? bio_split_rw+0x193/0x260
>>> [ 7497.218398]  md_handle_request+0x153/0x270
>>> [ 7497.218401]  ? srso_alias_return_thunk+0x5/0xfbef5
>>> [ 7497.218405]  __submit_bio+0x190/0x240
>>> [ 7497.218408]  submit_bio_noacct_nocheck+0x19a/0x3c0
>>> [ 7497.218410]  ? srso_alias_return_thunk+0x5/0xfbef5
>>> [ 7497.218413]  ? submit_bio_noacct+0x46/0x5a0
>>> [ 7497.218415]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
>>> [ 7497.218419]  process_one_work+0x18f/0x3b0
>>> [ 7497.218423]  worker_thread+0x233/0x340
>>> [ 7497.218426]  ? __pfx_worker_thread+0x10/0x10
>>> [ 7497.218428]  kthread+0xcd/0x100
>>> [ 7497.218430]  ? __pfx_kthread+0x10/0x10
>>> [ 7497.218433]  ret_from_fork+0x31/0x50
>>> [ 7497.218435]  ? __pfx_kthread+0x10/0x10
>>> [ 7497.218437]  ret_from_fork_asm+0x1a/0x30
>>> [ 7497.218442]  </TASK>
>>> [ 7497.218444] INFO: task kworker/u131:7:23864 blocked for more tha=
n 123 seconds.
>>> [ 7497.226572]       Not tainted 6.10.3 #1-NixOS
>>> [ 7497.231475] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" d=
isables this message.
>>> [ 7497.240277] task:kworker/u131:7  state:D stack:0     pid:23864 t=
gid:23864 ppid:2      flags:0x00004000
>>> [ 7497.240282] Workqueue: kcryptd-253:4-1 kcryptd_crypt [dm_crypt]
>>> [ 7497.240287] Call Trace:
>>> [ 7497.240288]  <TASK>
>>> [ 7497.240290]  __schedule+0x3fa/0x1550
>>> [ 7497.240298]  schedule+0x27/0xf0
>>> [ 7497.240301]  md_bitmap_startwrite+0x14f/0x1c0
>>> [ 7497.240304]  ? __pfx_autoremove_wake_function+0x10/0x10
>>> [ 7497.240310]  __add_stripe_bio+0x1f4/0x240 [raid456]
>>> [ 7497.240314]  raid5_make_request+0x34d/0x1280 [raid456]
>>> [ 7497.240320]  ? __pfx_woken_wake_function+0x10/0x10
>>> [ 7497.240322]  ? bio_split_rw+0x193/0x260
>>> [ 7497.240328]  md_handle_request+0x153/0x270
>>> [ 7497.240330]  ? srso_alias_return_thunk+0x5/0xfbef5
>>> [ 7497.240334]  __submit_bio+0x190/0x240
>>> [ 7497.240338]  submit_bio_noacct_nocheck+0x19a/0x3c0
>>> [ 7497.240340]  ? srso_alias_return_thunk+0x5/0xfbef5
>>> [ 7497.240342]  ? submit_bio_noacct+0x46/0x5a0
>>> [ 7497.240345]  kcryptd_crypt_write_convert+0x118/0x1e0 [dm_crypt]
>>> [ 7497.240348]  process_one_work+0x18f/0x3b0
>>> [ 7497.240353]  worker_thread+0x233/0x340
>>> [ 7497.240356]  ? __pfx_worker_thread+0x10/0x10
>>> [ 7497.240358]  kthread+0xcd/0x100
>>> [ 7497.240361]  ? __pfx_kthread+0x10/0x10
>>> [ 7497.240364]  ret_from_fork+0x31/0x50
>>> [ 7497.240366]  ? __pfx_kthread+0x10/0x10
>>> [ 7497.240368]  ret_from_fork_asm+0x1a/0x30
>>> [ 7497.240375]  </TASK>
>>> [ 7497.240376] Future hung task reports are suppressed, see sysctl =
kernel.hung_task_warnings
>>=20
>>>>=20
>>>>=20
>>>>=20
>>>>> Kernel:
>>>>=20
>>>>> Linux version 5.15.164 (nixbld@localhost) (gcc (GCC) 12.2.0, GNU =
ld (GNU Binutils) 2.40) #1-NixOS SMP Sat Jul 27 08:46:18 UTC 2024
>>>>=20
>>>>> The config is unchanged except from the deprecated NFSD_V2_ACL an=
d NFSD_V3 options which I had to remove. NFS is not in use on this serv=
er, though.
>>>>=20
>>>>> Output:
>>>>=20
>>>>> [ 4549.838672] INFO: task kworker/u64:7:432 blocked for more than=
 122 seconds.
>>>>> [ 4549.846507]       Not tainted 5.15.164 #1-NixOS
>>>>> [ 4549.851616] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=
 disables this message.
>>>>> [ 4549.860421] task:kworker/u64:7   state:D stack:    0 pid:  432=
 ppid:     2 flags:0x00004000
>>>>> [ 4549.860426] Workqueue: kcryptd/253:4 kcryptd_crypt [dm_crypt]
>>>>> [ 4549.860435] Call Trace:
>>>>> [ 4549.860437]  <TASK>
>>>>> [ 4549.860440]  __schedule+0x373/0x1580
>>>>> [ 4549.860446]  ? sysvec_call_function_single+0xa/0x90
>>>>> [ 4549.860449]  ? asm_sysvec_call_function_single+0x16/0x20
>>>>> [ 4549.860453]  schedule+0x5b/0xe0
>>>>> [ 4549.860455]  md_bitmap_startwrite+0x177/0x1e0
>>>>> [ 4549.860459]  ? finish_wait+0x90/0x90
>>>>> [ 4549.860465]  add_stripe_bio+0x449/0x770 [raid456]
>>>>> [ 4549.860472]  raid5_make_request+0x1cf/0xbd0 [raid456]
>>>>> [ 4549.860476]  ? kmem_cache_alloc_node_trace+0x341/0x3e0
>>>>> [ 4549.860480]  ? srso_alias_return_thunk+0x5/0x7f
>>>>> [ 4549.860484]  ? linear_map+0x44/0x90 [dm_mod]
>>>>> [ 4549.860490]  ? finish_wait+0x90/0x90
>>>>> [ 4549.860492]  ? __blk_queue_split+0x516/0x580
>>>>> [ 4549.860495]  md_handle_request+0x11f/0x1b0
>>>>> [ 4549.860500]  md_submit_bio+0x6e/0xb0
>>>>> [ 4549.860502]  __submit_bio+0x18c/0x220
>>>>> [ 4549.860505]  ? srso_alias_return_thunk+0x5/0x7f
>>>>> [ 4549.860507]  ? crypt_page_alloc+0x46/0x60 [dm_crypt]
>>>>> [ 4549.860510]  submit_bio_noacct+0xbe/0x2d0
>>>>> [ 4549.860512]  kcryptd_crypt+0x3a8/0x5a0 [dm_crypt]
>>>>> [ 4549.860517]  process_one_work+0x1d3/0x360
>>>>> [ 4549.860521]  worker_thread+0x4d/0x3b0
>>>>> [ 4549.860523]  ? process_one_work+0x360/0x360
>>>>> [ 4549.860525]  kthread+0x115/0x140
>>>>> [ 4549.860528]  ? set_kthread_struct+0x50/0x50
>>>>> [ 4549.860530]  ret_from_fork+0x1f/0x30
>>>>> [ 4549.860535]  </TASK>
>>>>> [ 4549.860536] INFO: task kworker/u64:23:448 blocked for more tha=
n 122 seconds.
>>>>> [ 4549.868461]       Not tainted 5.15.164 #1-NixOS
>>>>> [ 4549.873555] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=
 disables this message.
>>>>> [ 4549.882358] task:kworker/u64:23  state:D stack:    0 pid:  448=
 ppid:     2 flags:0x00004000
>>>>> [ 4549.882364] Workqueue: kcryptd/253:4 kcryptd_crypt [dm_crypt]
>>>>> [ 4549.882368] Call Trace:
>>>>> [ 4549.882369]  <TASK>
>>>>> [ 4549.882370]  __schedule+0x373/0x1580
>>>>> [ 4549.882373]  ? sysvec_apic_timer_interrupt+0xa/0x90
>>>>> [ 4549.882375]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>>>>> [ 4549.882379]  schedule+0x5b/0xe0
>>>>> [ 4549.882382]  md_bitmap_startwrite+0x177/0x1e0
>>>>> [ 4549.882384]  ? finish_wait+0x90/0x90
>>>>> [ 4549.882387]  add_stripe_bio+0x449/0x770 [raid456]
>>>>> [ 4549.882393]  raid5_make_request+0x1cf/0xbd0 [raid456]
>>>>> [ 4549.882397]  ? __bio_clone_fast+0xa5/0xe0
>>>>> [ 4549.882401]  ? srso_alias_return_thunk+0x5/0x7f
>>>>> [ 4549.882403]  ? finish_wait+0x90/0x90
>>>>> [ 4549.882406]  md_handle_request+0x11f/0x1b0
>>>>> [ 4549.882410]  ? blk_throtl_charge_bio_split+0x23/0x60
>>>>> [ 4549.882413]  md_submit_bio+0x6e/0xb0
>>>>> [ 4549.882415]  __submit_bio+0x18c/0x220
>>>>> [ 4549.882417]  ? srso_alias_return_thunk+0x5/0x7f
>>>>> [ 4549.882419]  ? crypt_page_alloc+0x46/0x60 [dm_crypt]
>>>>> [ 4549.882421]  submit_bio_noacct+0xbe/0x2d0
>>>>> [ 4549.882424]  kcryptd_crypt+0x3a8/0x5a0 [dm_crypt]
>>>>> [ 4549.882428]  process_one_work+0x1d3/0x360
>>>>> [ 4549.882431]  worker_thread+0x4d/0x3b0
>>>>> [ 4549.882433]  ? process_one_work+0x360/0x360
>>>>> [ 4549.882435]  kthread+0x115/0x140
>>>>> [ 4549.882436]  ? set_kthread_struct+0x50/0x50
>>>>> [ 4549.882438]  ret_from_fork+0x1f/0x30
>>>>> [ 4549.882442]  </TASK>
>>>>> [ 4549.882497] INFO: task .backy-wrapped:2578 blocked for more th=
an 122 seconds.
>>>>> [ 4549.890517]       Not tainted 5.15.164 #1-NixOS
>>>>> [ 4549.895611] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=
 disables this message.
>>>>> [ 4549.904406] task:.backy-wrapped  state:D stack:    0 pid: 2578=
 ppid:     1 flags:0x00000002
>>>>> [ 4549.904411] Call Trace:
>>>>> [ 4549.904412]  <TASK>
>>>>> [ 4549.904414]  __schedule+0x373/0x1580
>>>>> [ 4549.904419]  ? xlog_cil_commit+0x556/0x880 [xfs]
>>>>> [ 4549.904465]  ? __xfs_trans_commit+0xac/0x2f0 [xfs]
>>>>> [ 4549.904498]  schedule+0x5b/0xe0
>>>>> [ 4549.904500]  io_schedule+0x42/0x70
>>>>> [ 4549.904503]  wait_on_page_bit_common+0x119/0x380
>>>>> [ 4549.904507]  ? __page_cache_alloc+0x80/0x80
>>>>> [ 4549.904510]  wait_on_page_writeback+0x22/0x70
>>>>> [ 4549.904513]  truncate_inode_pages_range+0x26f/0x6d0
>>>>> [ 4549.904520]  evict+0x15f/0x180
>>>>> [ 4549.904524]  __dentry_kill+0xde/0x170
>>>>> [ 4549.904527]  dput+0x139/0x320
>>>>> [ 4549.904529]  do_renameat2+0x375/0x5f0
>>>>> [ 4549.904536]  __x64_sys_rename+0x3f/0x50
>>>>> [ 4549.904538]  do_syscall_64+0x34/0x80
>>>>> [ 4549.904541]  entry_SYSCALL_64_after_hwframe+0x6c/0xd6
>>>>> [ 4549.904544] RIP: 0033:0x7fbf3e61a75b
>>>>> [ 4549.904545] RSP: 002b:00007ffc61e25988 EFLAGS: 00000246 ORIG_R=
AX: 0000000000000052
>>>>> [ 4549.904548] RAX: ffffffffffffffda RBX: 00007ffc61e25a20 RCX: 0=
0007fbf3e61a75b
>>>>> [ 4549.904549] RDX: 0000000000000000 RSI: 00007fbf2f7ff150 RDI: 0=
0007fbf2f7fc190
>>>>> [ 4549.904550] RBP: 00007ffc61e259d0 R08: 00000000ffffffff R09: 0=
000000000000000
>>>>> [ 4549.904551] R10: 00007ffc61e25c00 R11: 0000000000000246 R12: 0=
0000000ffffff9c
>>>>> [ 4549.904552] R13: 00000000ffffff9c R14: 00000000016afab0 R15: 0=
0007fbf30ef0810
>>>>> [ 4549.904555]  </TASK>
>>>>> [ 4549.904556] INFO: task kworker/u64:0:4372 blocked for more tha=
n 122 seconds.
>>>>> [ 4549.912477]       Not tainted 5.15.164 #1-NixOS
>>>>> [ 4549.917573] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=
 disables this message.
>>>>> [ 4549.926373] task:kworker/u64:0   state:D stack:    0 pid: 4372=
 ppid:     2 flags:0x00004000
>>>>> [ 4549.926376] Workqueue: kcryptd/253:4 kcryptd_crypt [dm_crypt]
>>>>> [ 4549.926380] Call Trace:
>>>>> [ 4549.926381]  <TASK>
>>>>> [ 4549.926383]  __schedule+0x373/0x1580
>>>>> [ 4549.926386]  ? sysvec_apic_timer_interrupt+0xa/0x90
>>>>> [ 4549.926389]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>>>>> [ 4549.926392]  schedule+0x5b/0xe0
>>>>> [ 4549.926394]  md_bitmap_startwrite+0x177/0x1e0
>>>>> [ 4549.926397]  ? finish_wait+0x90/0x90
>>>>> [ 4549.926401]  add_stripe_bio+0x449/0x770 [raid456]
>>>>> [ 4549.926406]  raid5_make_request+0x1cf/0xbd0 [raid456]
>>>>> [ 4549.926410]  ? __bio_clone_fast+0xa5/0xe0
>>>>> [ 4549.926413]  ? finish_wait+0x90/0x90
>>>>> [ 4549.926415]  ? __blk_queue_split+0x2d0/0x580
>>>>> [ 4549.926418]  md_handle_request+0x11f/0x1b0
>>>>> [ 4549.926422]  md_submit_bio+0x6e/0xb0
>>>>> [ 4549.926424]  __submit_bio+0x18c/0x220
>>>>> [ 4549.926426]  ? srso_alias_return_thunk+0x5/0x7f
>>>>> [ 4549.926428]  ? crypt_page_alloc+0x46/0x60 [dm_crypt]
>>>>> [ 4549.926431]  submit_bio_noacct+0xbe/0x2d0
>>>>> [ 4549.926434]  kcryptd_crypt+0x3a8/0x5a0 [dm_crypt]
>>>>> [ 4549.926437]  process_one_work+0x1d3/0x360
>>>>> [ 4549.926441]  worker_thread+0x4d/0x3b0
>>>>> [ 4549.926442]  ? process_one_work+0x360/0x360
>>>>> [ 4549.926444]  kthread+0x115/0x140
>>>>> [ 4549.926447]  ? set_kthread_struct+0x50/0x50
>>>>> [ 4549.926448]  ret_from_fork+0x1f/0x30
>>>>> [ 4549.926454]  </TASK>
>>>>> [ 4549.926459] INFO: task rsync:4929 blocked for more than 122 se=
conds.
>>>>> [ 4549.933603]       Not tainted 5.15.164 #1-NixOS
>>>>> [ 4549.938702] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=
 disables this message.
>>>>> [ 4549.947501] task:rsync           state:D stack:    0 pid: 4929=
 ppid:  4925 flags:0x00000000
>>>>> [ 4549.947503] Call Trace:
>>>>> [ 4549.947505]  <TASK>
>>>>> [ 4549.947505]  ? usleep_range_state+0x90/0x90
>>>>> [ 4549.947510]  __schedule+0x373/0x1580
>>>>> [ 4549.947513]  ? srso_alias_return_thunk+0x5/0x7f
>>>>> [ 4549.947515]  ? blk_mq_sched_insert_requests+0x97/0xe0
>>>>> [ 4549.947519]  ? usleep_range_state+0x90/0x90
>>>>> [ 4549.947521]  schedule+0x5b/0xe0
>>>>> [ 4549.947523]  schedule_timeout+0xff/0x130
>>>>> [ 4549.947526]  __wait_for_common+0xaf/0x160
>>>>> [ 4549.947530]  xfs_buf_iowait+0x1c/0xa0 [xfs]
>>>>> [ 4549.947573]  __xfs_buf_submit+0x109/0x1b0 [xfs]
>>>>> [ 4549.947604]  xfs_buf_read_map+0x120/0x280 [xfs]
>>>>> [ 4549.947635]  ? xfs_btree_read_buf_block.constprop.0+0xae/0xf0 =
[xfs]
>>>>> [ 4549.947670]  xfs_trans_read_buf_map+0x156/0x2c0 [xfs]
>>>>> [ 4549.947705]  ? xfs_btree_read_buf_block.constprop.0+0xae/0xf0 =
[xfs]
>>>>> [ 4549.947735]  xfs_btree_read_buf_block.constprop.0+0xae/0xf0 [x=
fs]
>>>>> [ 4549.947764]  ? srso_alias_return_thunk+0x5/0x7f
>>>>> [ 4549.947766]  xfs_btree_lookup_get_block+0xa2/0x180 [xfs]
>>>>> [ 4549.947798]  xfs_btree_lookup+0xe9/0x540 [xfs]
>>>>> [ 4549.947830]  xfs_alloc_lookup_eq+0x1d/0x30 [xfs]
>>>>> [ 4549.947863]  xfs_alloc_fixup_trees+0xe7/0x3b0 [xfs]
>>>>> [ 4549.947893]  xfs_alloc_cur_finish+0x2b/0xa0 [xfs]
>>>>> [ 4549.947923]  xfs_alloc_ag_vextent_near.constprop.0+0x3f2/0x4a0=
 [xfs]
>>>>> [ 4549.947954]  xfs_alloc_ag_vextent+0x13f/0x150 [xfs]
>>>>> [ 4549.947983]  xfs_alloc_vextent+0x327/0x450 [xfs]
>>>>> [ 4549.948013]  xfs_bmap_btalloc+0x44e/0x830 [xfs]
>>>>> [ 4549.948047]  xfs_bmapi_allocate+0xda/0x300 [xfs]
>>>>> [ 4549.948076]  xfs_bmapi_write+0x4ab/0x570 [xfs]
>>>>> [ 4549.948109]  xfs_da_grow_inode_int+0xd8/0x320 [xfs]
>>>>> [ 4549.948141]  ? srso_alias_return_thunk+0x5/0x7f
>>>>> [ 4549.948142]  ? xfs_da_read_buf+0xf7/0x150 [xfs]
>>>>> [ 4549.948171]  ? srso_alias_return_thunk+0x5/0x7f
>>>>> [ 4549.948174]  xfs_dir2_grow_inode+0x68/0x120 [xfs]
>>>>> [ 4549.948204]  ? srso_alias_return_thunk+0x5/0x7f
>>>>> [ 4549.948206]  xfs_dir2_node_addname+0x5ea/0x9e0 [xfs]
>>>>> [ 4549.948241]  xfs_dir_createname+0x1cf/0x1e0 [xfs]
>>>>> [ 4549.948271]  xfs_rename+0x87e/0xcd0 [xfs]
>>>>> [ 4549.948308]  xfs_vn_rename+0xfa/0x170 [xfs]
>>>>> [ 4549.948340]  vfs_rename+0x818/0x10d0
>>>>> [ 4549.948345]  ? lookup_dcache+0x17/0x60
>>>>> [ 4549.948348]  ? do_renameat2+0x57f/0x5f0
>>>>> [ 4549.948350]  do_renameat2+0x57f/0x5f0
>>>>> [ 4549.948355]  __x64_sys_rename+0x3f/0x50
>>>>> [ 4549.948357]  do_syscall_64+0x34/0x80
>>>>> [ 4549.948360]  entry_SYSCALL_64_after_hwframe+0x6c/0xd6
>>>>> [ 4549.948362] RIP: 0033:0x7fcc5520c1d7
>>>>> [ 4549.948364] RSP: 002b:00007ffe3909c748 EFLAGS: 00000246 ORIG_R=
AX: 0000000000000052
>>>>> [ 4549.948366] RAX: ffffffffffffffda RBX: 00007ffe3909c8f0 RCX: 0=
0007fcc5520c1d7
>>>>> [ 4549.948367] RDX: 0000000000000000 RSI: 00007ffe3909c8f0 RDI: 0=
0007ffe3909e8f0
>>>>> [ 4549.948368] RBP: 00007ffe3909e8f0 R08: 0000000000000000 R09: 0=
0007ffe3909c2f8
>>>>> [ 4549.948369] R10: 00007ffe3909c2f7 R11: 0000000000000246 R12: 0=
000000000000000
>>>>> [ 4549.948370] R13: 00000000023c9c30 R14: 00000000000081a4 R15: 0=
000000000000004
>>>>> [ 4549.948373]  </TASK>
>>>>> [ 4549.948374] INFO: task kworker/u64:1:4930 blocked for more tha=
n 122 seconds.
>>>>> [ 4549.956299]       Not tainted 5.15.164 #1-NixOS
>>>>> [ 4549.961396] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=
 disables this message.
>>>>> [ 4549.970198] task:kworker/u64:1   state:D stack:    0 pid: 4930=
 ppid:     2 flags:0x00004000
>>>>> [ 4549.970202] Workqueue: kcryptd/253:4 kcryptd_crypt [dm_crypt]
>>>>> [ 4549.970205] Call Trace:
>>>>> [ 4549.970206]  <TASK>
>>>>> [ 4549.970209]  __schedule+0x373/0x1580
>>>>> [ 4549.970211]  ? srso_alias_return_thunk+0x5/0x7f
>>>>> [ 4549.970215]  schedule+0x5b/0xe0
>>>>> [ 4549.970217]  md_bitmap_startwrite+0x177/0x1e0
>>>>> [ 4549.970219]  ? finish_wait+0x90/0x90
>>>>> [ 4549.970223]  add_stripe_bio+0x449/0x770 [raid456]
>>>>> [ 4549.970229]  raid5_make_request+0x1cf/0xbd0 [raid456]
>>>>> [ 4549.970232]  ? kmem_cache_alloc_node_trace+0x341/0x3e0
>>>>> [ 4549.970236]  ? srso_alias_return_thunk+0x5/0x7f
>>>>> [ 4549.970238]  ? linear_map+0x44/0x90 [dm_mod]
>>>>> [ 4549.970244]  ? finish_wait+0x90/0x90
>>>>> [ 4549.970245]  ? __blk_queue_split+0x516/0x580
>>>>> [ 4549.970248]  md_handle_request+0x11f/0x1b0
>>>>> [ 4549.970251]  md_submit_bio+0x6e/0xb0
>>>>> [ 4549.970254]  __submit_bio+0x18c/0x220
>>>>> [ 4549.970256]  ? srso_alias_return_thunk+0x5/0x7f
>>>>> [ 4549.970258]  ? crypt_page_alloc+0x46/0x60 [dm_crypt]
>>>>> [ 4549.970260]  submit_bio_noacct+0xbe/0x2d0
>>>>> [ 4549.970263]  kcryptd_crypt+0x3a8/0x5a0 [dm_crypt]
>>>>> [ 4549.970267]  process_one_work+0x1d3/0x360
>>>>> [ 4549.970270]  worker_thread+0x4d/0x3b0
>>>>> [ 4549.970272]  ? process_one_work+0x360/0x360
>>>>> [ 4549.970274]  kthread+0x115/0x140
>>>>> [ 4549.970276]  ? set_kthread_struct+0x50/0x50
>>>>> [ 4549.970278]  ret_from_fork+0x1f/0x30
>>>>> [ 4549.970282]  </TASK>
>>>>> [ 4549.970284] INFO: task kworker/u64:2:4949 blocked for more tha=
n 123 seconds.
>>>>> [ 4549.978205]       Not tainted 5.15.164 #1-NixOS
>>>>> [ 4549.983290] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=
 disables this message.
>>>>> [ 4549.992088] task:kworker/u64:2   state:D stack:    0 pid: 4949=
 ppid:     2 flags:0x00004000
>>>>> [ 4549.992093] Workqueue: kcryptd/253:4 kcryptd_crypt [dm_crypt]
>>>>> [ 4549.992097] Call Trace:
>>>>> [ 4549.992098]  <TASK>
>>>>> [ 4549.992100]  __schedule+0x373/0x1580
>>>>> [ 4549.992103]  ? sysvec_apic_timer_interrupt+0xa/0x90
>>>>> [ 4549.992106]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>>>>> [ 4549.992109]  schedule+0x5b/0xe0
>>>>> [ 4549.992111]  md_bitmap_startwrite+0x177/0x1e0
>>>>> [ 4549.992114]  ? finish_wait+0x90/0x90
>>>>> [ 4549.992117]  add_stripe_bio+0x449/0x770 [raid456]
>>>>> [ 4549.992122]  raid5_make_request+0x1cf/0xbd0 [raid456]
>>>>> [ 4549.992125]  ? kmem_cache_alloc+0x261/0x3b0
>>>>> [ 4549.992129]  ? srso_alias_return_thunk+0x5/0x7f
>>>>> [ 4549.992131]  ? linear_map+0x44/0x90 [dm_mod]
>>>>> [ 4549.992135]  ? finish_wait+0x90/0x90
>>>>> [ 4549.992137]  ? __blk_queue_split+0x516/0x580
>>>>> [ 4549.992139]  md_handle_request+0x11f/0x1b0
>>>>> [ 4549.992142]  md_submit_bio+0x6e/0xb0
>>>>> [ 4549.992144]  __submit_bio+0x18c/0x220
>>>>> [ 4549.992146]  ? srso_alias_return_thunk+0x5/0x7f
>>>>> [ 4549.992148]  ? crypt_page_alloc+0x46/0x60 [dm_crypt]
>>>>> [ 4549.992150]  submit_bio_noacct+0xbe/0x2d0
>>>>> [ 4549.992153]  kcryptd_crypt+0x3a8/0x5a0 [dm_crypt]
>>>>> [ 4549.992157]  process_one_work+0x1d3/0x360
>>>>> [ 4549.992160]  worker_thread+0x4d/0x3b0
>>>>> [ 4549.992162]  ? process_one_work+0x360/0x360
>>>>> [ 4549.992163]  kthread+0x115/0x140
>>>>> [ 4549.992166]  ? set_kthread_struct+0x50/0x50
>>>>> [ 4549.992168]  ret_from_fork+0x1f/0x30
>>>>> [ 4549.992172]  </TASK>
>>>>> [ 4549.992174] INFO: task kworker/u64:5:4952 blocked for more tha=
n 123 seconds.
>>>>> [ 4550.000095]       Not tainted 5.15.164 #1-NixOS
>>>>> [ 4550.005187] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=
 disables this message.
>>>>> [ 4550.013985] task:kworker/u64:5   state:D stack:    0 pid: 4952=
 ppid:     2 flags:0x00004000
>>>>> [ 4550.013988] Workqueue: kcryptd/253:4 kcryptd_crypt [dm_crypt]
>>>>> [ 4550.013992] Call Trace:
>>>>> [ 4550.013993]  <TASK>
>>>>> [ 4550.013995]  __schedule+0x373/0x1580
>>>>> [ 4550.013997]  ? sysvec_apic_timer_interrupt+0xa/0x90
>>>>> [ 4550.014000]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>>>>> [ 4550.014003]  schedule+0x5b/0xe0
>>>>> [ 4550.014005]  md_bitmap_startwrite+0x177/0x1e0
>>>>> [ 4550.014008]  ? finish_wait+0x90/0x90
>>>>> [ 4550.014010]  add_stripe_bio+0x449/0x770 [raid456]
>>>>> [ 4550.014015]  raid5_make_request+0x1cf/0xbd0 [raid456]
>>>>> [ 4550.014018]  ? __bio_clone_fast+0xa5/0xe0
>>>>> [ 4550.014022]  ? finish_wait+0x90/0x90
>>>>> [ 4550.014024]  ? __blk_queue_split+0x2d0/0x580
>>>>> [ 4550.014027]  md_handle_request+0x11f/0x1b0
>>>>> [ 4550.014030]  md_submit_bio+0x6e/0xb0
>>>>> [ 4550.014032]  __submit_bio+0x18c/0x220
>>>>> [ 4550.014034]  ? srso_alias_return_thunk+0x5/0x7f
>>>>> [ 4550.014036]  ? crypt_page_alloc+0x46/0x60 [dm_crypt]
>>>>> [ 4550.014038]  submit_bio_noacct+0xbe/0x2d0
>>>>> [ 4550.014041]  kcryptd_crypt+0x3a8/0x5a0 [dm_crypt]
>>>>> [ 4550.014044]  process_one_work+0x1d3/0x360
>>>>> [ 4550.014047]  worker_thread+0x4d/0x3b0
>>>>> [ 4550.014049]  ? process_one_work+0x360/0x360
>>>>> [ 4550.014050]  kthread+0x115/0x140
>>>>> [ 4550.014052]  ? set_kthread_struct+0x50/0x50
>>>>> [ 4550.014054]  ret_from_fork+0x1f/0x30
>>>>> [ 4550.014058]  </TASK>
>>>>> [ 4550.014059] INFO: task kworker/u64:8:4954 blocked for more tha=
n 123 seconds.
>>>>> [ 4550.021982]       Not tainted 5.15.164 #1-NixOS
>>>>> [ 4550.027078] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=
 disables this message.
>>>>> [ 4550.035881] task:kworker/u64:8   state:D stack:    0 pid: 4954=
 ppid:     2 flags:0x00004000
>>>>> [ 4550.035884] Workqueue: kcryptd/253:4 kcryptd_crypt [dm_crypt]
>>>>> [ 4550.035887] Call Trace:
>>>>> [ 4550.035888]  <TASK>
>>>>> [ 4550.035890]  __schedule+0x373/0x1580
>>>>> [ 4550.035893]  ? sysvec_apic_timer_interrupt+0xa/0x90
>>>>> [ 4550.035896]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>>>>> [ 4550.035899]  schedule+0x5b/0xe0
>>>>> [ 4550.035901]  md_bitmap_startwrite+0x177/0x1e0
>>>>> [ 4550.035904]  ? finish_wait+0x90/0x90
>>>>> [ 4550.035907]  add_stripe_bio+0x449/0x770 [raid456]
>>>>> [ 4550.035912]  raid5_make_request+0x1cf/0xbd0 [raid456]
>>>>> [ 4550.035916]  ? __bio_clone_fast+0xa5/0xe0
>>>>> [ 4550.035919]  ? finish_wait+0x90/0x90
>>>>> [ 4550.035921]  ? __blk_queue_split+0x2d0/0x580
>>>>> [ 4550.035924]  md_handle_request+0x11f/0x1b0
>>>>> [ 4550.035927]  md_submit_bio+0x6e/0xb0
>>>>> [ 4550.035929]  __submit_bio+0x18c/0x220
>>>>> [ 4550.035931]  ? srso_alias_return_thunk+0x5/0x7f
>>>>> [ 4550.035933]  ? crypt_page_alloc+0x46/0x60 [dm_crypt]
>>>>> [ 4550.035936]  submit_bio_noacct+0xbe/0x2d0
>>>>> [ 4550.035939]  kcryptd_crypt+0x3a8/0x5a0 [dm_crypt]
>>>>> [ 4550.035942]  process_one_work+0x1d3/0x360
>>>>> [ 4550.035946]  worker_thread+0x4d/0x3b0
>>>>> [ 4550.035948]  ? process_one_work+0x360/0x360
>>>>> [ 4550.035949]  kthread+0x115/0x140
>>>>> [ 4550.035951]  ? set_kthread_struct+0x50/0x50
>>>>> [ 4550.035953]  ret_from_fork+0x1f/0x30
>>>>> [ 4550.035957]  </TASK>
>>>>> [ 4550.035958] INFO: task kworker/u64:9:4955 blocked for more tha=
n 123 seconds.
>>>>> [ 4550.043881]       Not tainted 5.15.164 #1-NixOS
>>>>> [ 4550.048979] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=
 disables this message.
>>>>> [ 4550.057786] task:kworker/u64:9   state:D stack:    0 pid: 4955=
 ppid:     2 flags:0x00004000
>>>>> [ 4550.057790] Workqueue: kcryptd/253:4 kcryptd_crypt [dm_crypt]
>>>>> [ 4550.057794] Call Trace:
>>>>> [ 4550.057796]  <TASK>
>>>>> [ 4550.057798]  __schedule+0x373/0x1580
>>>>> [ 4550.057801]  ? sysvec_apic_timer_interrupt+0xa/0x90
>>>>> [ 4550.057803]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>>>>> [ 4550.057806]  schedule+0x5b/0xe0
>>>>> [ 4550.057808]  md_bitmap_startwrite+0x177/0x1e0
>>>>> [ 4550.057810]  ? finish_wait+0x90/0x90
>>>>> [ 4550.057813]  add_stripe_bio+0x449/0x770 [raid456]
>>>>> [ 4550.057818]  raid5_make_request+0x1cf/0xbd0 [raid456]
>>>>> [ 4550.057821]  ? __bio_clone_fast+0xa5/0xe0
>>>>> [ 4550.057824]  ? finish_wait+0x90/0x90
>>>>> [ 4550.057826]  ? __blk_queue_split+0x2d0/0x580
>>>>> [ 4550.057828]  md_handle_request+0x11f/0x1b0
>>>>> [ 4550.057831]  md_submit_bio+0x6e/0xb0
>>>>> [ 4550.057834]  __submit_bio+0x18c/0x220
>>>>> [ 4550.057835]  ? srso_alias_return_thunk+0x5/0x7f
>>>>> [ 4550.057837]  ? crypt_page_alloc+0x46/0x60 [dm_crypt]
>>>>> [ 4550.057839]  submit_bio_noacct+0xbe/0x2d0
>>>>> [ 4550.057842]  kcryptd_crypt+0x3a8/0x5a0 [dm_crypt]
>>>>> [ 4550.057846]  process_one_work+0x1d3/0x360
>>>>> [ 4550.057848]  worker_thread+0x4d/0x3b0
>>>>> [ 4550.057850]  ? process_one_work+0x360/0x360
>>>>> [ 4550.057852]  kthread+0x115/0x140
>>>>> [ 4550.057854]  ? set_kthread_struct+0x50/0x50
>>>>> [ 4550.057856]  ret_from_fork+0x1f/0x30
>>>>> [ 4550.057860]  </TASK>
>>>>=20
>>>>=20
>>>>> On 7. Aug 2024, at 08:46, Christian Theune <ct@flyingcircus.io> w=
rote:
>>>>>=20
>>>>> I tried updating to 5.15.164, but have to struggle against our co=
nfig management as some options have been shifted that I need to filter=
 out: NFSD_V3 and NFSD2_ACL are now fixed and cause config errors if se=
t - I guess that=E2=80=99s a valid thing to happen within an LTS releas=
e. I=E2=80=99ll try again on Friday
>>>>>=20
>>>>>>> On 7. Aug 2024, at 07:31, Christian Theune <ct@flyingcircus.io>=
 wrote:
>>>>>>>=20
>>>>>>> Sure,
>>>>>>>=20
>>>>>>> would you prefer me testing on 5.15.x or something else?
>>>>>>>=20
>>>>>>> On 7. Aug 2024, at 04:55, Yu Kuai <yukuai1@huaweicloud.com> wro=
te:
>>>>>>>=20
>>>>>>> Hi,
>>>>>>>=20
>>>>>>> =E5=9C=A8 2024/08/06 22:10, Christian Theune =E5=86=99=E9=81=93=
:
>>>>>>>>> we are seeing an issue that can be triggered with relative ea=
se on a server that has been working fine for a few weeks. The regular =
workload is a backup utility that copies off data from virtual disk ima=
ges in 4MiB (compressed) chunks from Ceph onto a local NVME-based RAID-=
6 array that is encrypted using LUKS.
>>>>>>>>> Today I started a larger rsync job from another server (that =
has a couple of million files with around 200-300 gib in total) to migr=
ate data and we=E2=80=99ve seen the server suddenly lock up twice. Any =
IO that interacts with the mountpoint (/srv/backy) will hang indefinite=
ly. A reset is required to get out of this as the machine will hang try=
ing to unmount the affected filesystem. No other messages than the hung=
 tasks are being presented - I have no indicator for hardware faults at=
 the moment.
>>>>>>>>> I=E2=80=99m messaging both dm-devel and linux-raid as I=E2=80=
=99m suspecting either one or both (or an interaction) might be the cau=
se.
>>>>>>>>> Kernel:
>>>>>>>>> Linux version 5.15.138 (nixbld@localhost) (gcc (GCC) 12.2.0, =
GNU ld (GNU Binutils) 2.40) #1-NixOS SMP Wed Nov 8 16:26:52 UTC 2023
>>>>>>>=20
>>>>>>> Since you can trigger this easily, I'll suggest you to try the =
latest
>>>>>>> kernel release first.
>>>>>>>=20
>>>>>>> Thanks,
>>>>>>> Kuai
>>>>>>>=20
>>>>>>>>> See the kernel config attached.
>>>>>>>=20
>>>>>>>=20
>>>>>>> Liebe Gr=C3=BC=C3=9Fe,
>>>>>>> Christian Theune
>>>>>>>=20
>>>>>>> --=20
>>>>>>> Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 21940=
1 0
>>>>>>> Flying Circus Internet Operations GmbH =C2=B7 https://flyingcir=
cus.io
>>>>>>> Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschl=
and
>>>>>>> HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christia=
n Theune, Christian Zagrodnick
>>>>>>>=20
>>>>>>>=20
>>>>>=20
>>>>> Liebe Gr=C3=BC=C3=9Fe,
>>>>> Christian Theune
>>>>>=20
>>>>> --=20
>>>>> Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 =
0
>>>>> Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircu=
s.io
>>>>> Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschlan=
d
>>>>> HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian =
Theune, Christian Zagrodnick
>>>>>=20
>>>>=20
>>>>> Liebe Gr=C3=BC=C3=9Fe,
>>>>> Christian Theune
>>>>=20
>>>>> --=20
>>>>> Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 =
0
>>>>> Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircu=
s.io
>>>>> Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschlan=
d
>>>>> HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian =
Theune, Christian Zagrodnick
>>>>=20
>>>>=20
>>=20
>>> Liebe Gr=C3=BC=C3=9Fe,
>>> Christian Theune
>>=20
>>> --=20
>>> Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
>>> Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.=
io
>>> Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
>>> HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Th=
eune, Christian Zagrodnick
>>=20
>>=20

