Received: from mail-43167.protonmail.ch (mail-43167.protonmail.ch [185.70.43.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD9348CFC
	for <dm-devel@lists.linux.dev>; Mon, 18 Nov 2024 18:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731953394; cv=none; b=qWZMopTVAMMLkCFWyxOdSil1/msgqzMXi0Xb8jnFac+vHpFnS7SxLlqVtyU4AH6ZQW+FgNDGzdyNs7MwbTCw7gHlY2+uGbKjqhHiRcqbvJ7i4e64eMu2J55mxa9puAtSOGmOn93+Y1JyEm6nG973p8yjvdOeZywpevQ2qgQskjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731953394; c=relaxed/simple;
	bh=UOi16vCaffKE5AvGDjAcA66m6HzGkEIG0iTZpmVlxOg=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F86xRAS9IKUMs9PCPoA7eETWjQfE2/+V5aAtvzbvAWWOOsA1oPDfF5A/XLB++oFsak9i2x/dR6CFM/NuO0O6kjt4gvIYrWqTvzsoLJdqmykc+1J1NDYbHpMmgIkHU+2la6Uh3gxZMNCXoRJkGAyGvKzvN+cgR/i0utMw54ubWjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=C/BQIKLy; arc=none smtp.client-ip=185.70.43.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="C/BQIKLy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1731953385; x=1732212585;
	bh=dqNkuFi3YwsoyGjtQxU+exyAXwr7r/D2i+EgfCQi8ok=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector:List-Unsubscribe:List-Unsubscribe-Post;
	b=C/BQIKLyGnTZEOiKp2QhLgayLMR1AFtPNGG/tqAPtFqKfIFlx5YomckfqwDUeX2oc
	 E+tnNg4gadytS7d0qV/OLOn1YxkkTg4ciIWRXz6ZWyaIJeDyL+yR/vPIHRb5nCivjM
	 sMcrosWwNSaD1R4CXez9wFAIPnuYvW1ymmu7YSjPQDR/PWgV5yMextanD144EqZIE/
	 RtIOFXb/r+5nMUfBTaGCPInmXsmWetMfIwVWnjTThWnP/jR18mWWtI/GbUVzZLFpEJ
	 znxj+yumqtI1m3BDz2K/DvM2oUJoS6tApP94hm1ycEFhVrfYRyxVbaGNSv+Rz/w8ls
	 k2aold0Z7dBbQ==
Date: Mon, 18 Nov 2024 18:09:42 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
From: dap581 <dap581@protonmail.com>
Cc: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, Milan Broz <gmazyland@gmail.com>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>, Damien Le Moal <dlemoal@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: kernel 6.12-rc7 device-mapper inconsistency
Message-ID: <DoKVvqoZo7ojL0ngDU4K1mTnR5gEyBiMRv-CUdMSMQRRVWLHKEJeI_lQ-K6cqlMEaqopKktzxNEvCPHY2Q-sGYqJdYZ46_socrbsk5XZqZQ=@protonmail.com>
In-Reply-To: <1426ad71-79b4-4062-b2bf-84278be66a5d@redhat.com>
References: <sL6OHvHA2vueSjCGptT5XUvM5jjGMf3xGWrAW6npODvitd85paTESdsxpbircJbDh9VVyBNDNiqOcU39-LM7WwuldK5Tk4UkRSZjsycWdpo=@protonmail.com> <1426ad71-79b4-4062-b2bf-84278be66a5d@redhat.com>
Feedback-ID: 43237694:user:proton
X-Pm-Message-ID: 541ed2c90e05e37082e8124a09b95b52f84c18d1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

>On Monday, November 18th, 2024 at 1:27 PM, Mikulas Patocka <mpatocka@redha=
t.com> wrote:
> Hi=20
> Please apply this patch and report what it prints. So, that we can find
> out which limits cause the problem.
> Mikulas

Hello,
Sorry for the delay, with patch applied to 6.12.0 released today:
dmesg output after running luksOpen on hdd (sda)

[  109.421097] failure 4: fffe00, 1000
[  109.421112] device-mapper: table: 254:1: adding target device sda1 cause=
d an alignment inconsistency: physical_block_size=3D4096, logical_block_siz=
e=3D512, alignment_offset=3D0, start=3D16777216
[  109.421123] failure 4: fffe00, 1000
[  109.421126] device-mapper: table: 254:1: adding target device sda1 cause=
d an alignment inconsistency: physical_block_size=3D4096, logical_block_siz=
e=3D512, alignment_offset=3D0, start=3D16777216
[  109.421379] failure 4: fffe00, 1000
[  109.421384] device-mapper: table: 254:1: adding target device sda1 cause=
d an alignment inconsistency: physical_block_size=3D4096, logical_block_siz=
e=3D512, alignment_offset=3D0, start=3D16777216
[  109.421392] failure 4: fffe00, 1000
[  109.421395] device-mapper: table: 254:1: adding target device sda1 cause=
d an alignment inconsistency: physical_block_size=3D4096, logical_block_siz=
e=3D512, alignment_offset=3D0, start=3D16777216

>Hi
>Does this patch fix it?
---
 block/blk-settings.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6/block/blk-settings.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/block/blk-settings.c=092024-11-18 15:24:18.000000000 +01=
00
+++ linux-2.6/block/blk-settings.c=092024-11-18 15:29:24.000000000 +0100
@@ -250,6 +250,13 @@ static int blk_validate_limits(struct qu
 =09=09lim->io_min =3D lim->physical_block_size;
=20
 =09/*
+=09 * The optimal I/O size may not be aligned to physical block size
+=09 * (because it may be limited by dma engines which have no clue about
+=09 * block size of the disks attached to them), so we round it down here.
+=09 */
+=09lim->io_opt =3D round_down(lim->io_opt, lim->physical_block_size);
+
+=09/*
 =09 * max_hw_sectors has a somewhat weird default for historical reason,
 =09 * but driver really should set their own instead of relying on this
 =09 * value.

----

Yes!
With the above patch applied (blk-settings: round down io_opt to physical_b=
lock_size)
No more "device-mapper inconsistency" when I unlock my hdd, I also tried th=
e other hdd to make sure.
All good.

lsblk -t

NAME          ALIGNMENT MIN-IO   OPT-IO PHY-SEC LOG-SEC ROTA SCHED RQ-SIZE =
   RA WSAME
sda                   0   4096 16773120    4096     512    1 bfq       256 =
32760    0B
=E2=94=94=E2=94=80sda1                0   4096 16773120    4096     512    =
1 bfq       256 32760    0B
  =E2=94=94=E2=94=80raid-hdd4         0   4096 16773120    4096    4096    =
1               32760    0B
sdb                   0   4096 16773120    4096     512    1 bfq       256 =
32760    0B
=E2=94=94=E2=94=80sdb1                0   4096 16773120    4096     512    =
1 bfq       256 32760    0B
  =E2=94=94=E2=94=80raid-hdd3         0   4096 16773120    4096    4096    =
1               32760    0B
sdc                   0   4096 16773120    4096     512    1 bfq       256 =
32760    0B
=E2=94=94=E2=94=80sdc1                0   4096 16773120    4096     512    =
1 bfq       256 32760    0B
  =E2=94=94=E2=94=80raid-hdd2         0   4096 16773120    4096    4096    =
1               32760    0B
sdd                   0   4096 16773120    4096     512    1 bfq       256 =
32760    0B
=E2=94=94=E2=94=80sdd1                0   4096 16773120    4096     512    =
1 bfq       256 32760    0B
  =E2=94=94=E2=94=80raid-hdd1         0   4096 16773120    4096    4096    =
1               32760    0B

Thanks!
