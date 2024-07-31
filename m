Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15FD1649BF
	for <dm-devel@lists.linux.dev>; Wed, 31 Jul 2024 20:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722458495; cv=none; b=k1o+3FIlZPjRSlq7FbRSTrsGJtcYWGUG6xAOPVpNFCHcqjupUba2abCCDQg3CKTsz8P1LETFMfWAdixLHRQKjlAi4ojJNbmaKkWDIsJQxAneUxKLRz7p5hzpejqzTWebo6u+Q2pilz74bWYhfiocNxdaJFpB0cSK1DFjkevLWqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722458495; c=relaxed/simple;
	bh=sZW2WYXS/nyPVC0sPutRAjU3jomXv07ZVqlpQ6SgRng=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oMhtM0gVwJlMFS3D7jB/q28CzQmMeikyQZ7zVMT4FKOPal7r3u92SNQb1AAgo2tG8WmpFGc2tA+LQ3r3m16+ZloAES3ek3+EG6+5ag58LEkaroW0ufVnVwiG3oPliGKaeX4VVRN2Tnmbf1IoKPXfxwHpJzBlufxOfIGlF81WGC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HPWrfibj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HPWrfibj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722458493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ed9tINVM/C/2Zr5mQQ++V62QqUtMwhnNtSW86ae1VM4=;
	b=HPWrfibjMOaopJzsGlF9bBLDOy/eHMkUIJMiKg43Won3fHO/H0L6YUJ1JYpcCoKd+OvaXl
	0ixXjWPFwpkycE7tdRF+OdnhINayeAmthcuWBKE4lEjj7LocFz24P7/GbP81mzuK/aYSMw
	bbu9SG9Zf3ElIrXvF/l/oK+Q/q68ARs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-c_WPZqmqNcefCX77e1tg7Q-1; Wed, 31 Jul 2024 16:41:31 -0400
X-MC-Unique: c_WPZqmqNcefCX77e1tg7Q-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3685a5a765fso2817529f8f.1
        for <dm-devel@lists.linux.dev>; Wed, 31 Jul 2024 13:41:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722458489; x=1723063289;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ed9tINVM/C/2Zr5mQQ++V62QqUtMwhnNtSW86ae1VM4=;
        b=axq/Y5XdAMMDaIze1Suc03KnCY7mlBDidfKyzUfu8Wt1IXIlerNWpOyrziNBhOd5cM
         oznUSbzP4UkogTM8kpi5AuNqsVoGkWbQYsr49oGIOWuRqKmKYlmYYxBRqLXmBSEgRq/4
         zYa1g+Xu/zC2nSzYD0zBsgrAIHY67Nou7M0UyBSaWBwKukM/9zwtctyJaOpy4rLlaFqO
         3gMqM/H0RitJZsEAAkaMUwaUmrHPrvIE+JxdQHIq99o8dazv9TzMV5zPjC6xWuxzP89k
         KaJUktr+R7xyN5JnwoNDg2n7gcfjTtvR6V5lI6LhQGN8Y5xLVl9ItDW9wG2jkxWJBNqF
         dmVw==
X-Forwarded-Encrypted: i=1; AJvYcCUfwKwPDfjuS46JwR3W4KVhz2is7tD6f3+kPxrfaTy4VEHTza1jp65fSIC2RVLz9MaUNQ8SpMF8HiyW3jHYzHX595ZID2Cgcmo=
X-Gm-Message-State: AOJu0YzaNek++SLYNx4T9D5fWBonMD9rGieDjb3mly+/sn7oV3OOYmzg
	9OtjRL0elh27sQpiVNV39TLvkkrU8tHkNL04iOPZ6x6WHyBiu3nbQhp9LSa3t8VZT2pJ3wvyl4g
	P5e0p88gU+xgkirHOHtGxsPSSrt3GIJhMilQQ0plVGGpQqgUR493liSqtQuSFaBdYH6rtVy9JHL
	oCeePIfNrZIJLBt/JKFyaflb44wDxJVnYMzA1fzJUbpg==
X-Received: by 2002:a05:6000:d0c:b0:367:33f0:91c6 with SMTP id ffacd0b85a97d-36baaf91dc9mr279060f8f.62.1722458489417;
        Wed, 31 Jul 2024 13:41:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEMy02oUDrgX06zjzF6Y0z1MEcELo1GJ/MzCTTuwESV4iKs9a+hUSS9mmiXRhl/E2oPonp7PH+GKsf03tbQyoY=
X-Received: by 2002:a05:6000:d0c:b0:367:33f0:91c6 with SMTP id
 ffacd0b85a97d-36baaf91dc9mr279040f8f.62.1722458488631; Wed, 31 Jul 2024
 13:41:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <a6d068a26a90057fb3cdaa59f9d57a2af41a6b22.camel@yandex.ru>
 <1f879e67-4d64-4df0-5817-360d84ff8b89@huaweicloud.com> <29d69e586e628ef2e5f2fd7b9fe4e7062ff36ccf.camel@yandex.ru>
 <517243f0-77c5-9d67-a399-78c449f6afc6@huaweicloud.com> <810a319b846c7e16d85a7f52667d04252a9d0703.camel@yandex.ru>
 <9c60881e-d28f-d8d5-099c-b9678bd69db9@huaweicloud.com> <57241c91337e8fc3257b6d4a35c273af59875eff.camel@yandex.ru>
 <37df66ec9cf1a0570a86ec0b9f17ae18ed11b832.camel@yandex.ru>
In-Reply-To: <37df66ec9cf1a0570a86ec0b9f17ae18ed11b832.camel@yandex.ru>
From: Bryan Gurney <bgurney@redhat.com>
Date: Wed, 31 Jul 2024 16:41:16 -0400
Message-ID: <CAHhmqcTomcMEooe-mtZ5n1Gm_OfJ+bVssk54oXz84=Au75+Tag@mail.gmail.com>
Subject: Re: Lockup of (raid5 or raid6) + vdo after taking out a disk under load
To: Konstantin Kharlamov <Hi-Angel@yandex.ru>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, Song Liu <song@kernel.org>, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "yangerkun@huawei.com" <yangerkun@huawei.com>, 
	"yukuai (C)" <yukuai3@huawei.com>, dm-devel@lists.linux.dev, 
	Matthew Sakai <msakai@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Konstantin,

This sounds a lot like something that I encountered with md, back in
2019, on the old vdo-devel mailing list:

https://listman.redhat.com/archives/vdo-devel/2019-August/000171.html

Basically, I had a RAID-5 md array that was in the process of recovery:

$ cat /proc/mdstat
Personalities : [raid0] [raid6] [raid5] [raid4]
md0 : active raid5 sde[4] sdd[2] sdc[1] sdb[0]
      2929890816 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] [U=
UU_]
      [=3D>...................]  recovery =3D  9.1% (89227836/976630272)
finish=3D85.1min speed=3D173727K/sec
      bitmap: 0/8 pages [0KB], 65536KB chunk

Note that the speed of the recovery is 173,727 KB/sec, which is less
than the sync_speed_max value:

$ grep . /sys/block/md0/md/sync_speed*
/sys/block/md0/md/sync_speed:171052
/sys/block/md0/md/sync_speed_max:200000 (system)
/sys/block/md0/md/sync_speed_min:1000 (system)

...And when I decreased "sync_speed_max" to "65536", I stopped seeing
hung task timeouts.

There's a similar setting in dm-raid: the "--maxrecoveryrate" option
of lvchange.  So, to set the maximum recovery rate to 64 MiB per
second per device, this would be the command, for an example VG/LV of
"p_r5/testdmraid5"

# lvchange --maxrecoveryrate 64M p_r5/testdmraid5

(Older hard disk drives may not have a sequential read / write speed
of more than 100 MiB/sec; this meant that md's default of 200 MiB/sec
was "too fast", and would result in the recovery I/O starving the VDO
volume from being able to service I/O.)

The current value of max_recovery_rate for dm-raid can be displayed
with "lvs -a -o +raid_max_recovery_rate".

By reducing the maximum recovery rate for the dm-raid RAID-5 logical
volume, does this result in the hung task timeouts for the
"dm-vdo0-bioQ*" to not appear, and for the fio job to continue
writing?


Thanks,

Bryan



On Wed, Jul 31, 2024 at 10:21=E2=80=AFAM Konstantin Kharlamov
<Hi-Angel@yandex.ru> wrote:
>
> CC'ing VDO maintainers, because the problem is only reproducible with
> VDO, so potentially they might have some ideas.
>
> On Mon, 2024-07-22 at 20:56 +0300, Konstantin Kharlamov wrote:
> > Hi, sorry for the delay, I had to give away the nodes and we had a
> > week
> > of teambuilding and company party, so for the past week I only
> > managed
> > to hack away stripping debug symbols, get another node and set it up.
> >
> > Experiments below are based off of vanilla 6.9.8 kernel *without*
> > your
> > patch.
> >
> > On Mon, 2024-07-15 at 09:56 +0800, Yu Kuai wrote:
> > > Line number will be helpful.
> >
> > So, after tinkering with building scripts I managed to build modules
> > with debug symbols (not the kernel itself but should be good enough),
> > but for some reason kernel doesn't show line numbers in stacktraces.
> > No
> > idea what could be causing it, so I had to decode line numbers
> > manually, below is an output where I inserted line numbers for
> > raid456
> > manually after decoding them with `gdb`.
> >
> >     [=E2=80=A6]
> >     [ 1677.293366]  <TASK>
> >     [ 1677.293661]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
> >     [ 1677.293972]  ? _raw_spin_unlock_irq+0x10/0x30
> >     [ 1677.294276]  ? _raw_spin_unlock_irq+0xa/0x30
> >     [ 1677.294586]  raid5d at drivers/md/raid5.c:6572
> >     [ 1677.294910]  md_thread+0xc1/0x170
> >     [ 1677.295228]  ? __pfx_autoremove_wake_function+0x10/0x10
> >     [ 1677.295545]  ? __pfx_md_thread+0x10/0x10
> >     [ 1677.295870]  kthread+0xff/0x130
> >     [ 1677.296189]  ? __pfx_kthread+0x10/0x10
> >     [ 1677.296498]  ret_from_fork+0x30/0x50
> >     [ 1677.296810]  ? __pfx_kthread+0x10/0x10
> >     [ 1677.297112]  ret_from_fork_asm+0x1a/0x30
> >     [ 1677.297424]  </TASK>
> >     [=E2=80=A6]
> >     [ 1705.296253]  <TASK>
> >     [ 1705.296554]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
> >     [ 1705.296864]  ? _raw_spin_unlock_irq+0x10/0x30
> >     [ 1705.297172]  ? _raw_spin_unlock_irq+0xa/0x30
> >     [ 1677.294586]  raid5d at drivers/md/raid5.c:6597
> >     [ 1705.297794]  md_thread+0xc1/0x170
> >     [ 1705.298099]  ? __pfx_autoremove_wake_function+0x10/0x10
> >     [ 1705.298409]  ? __pfx_md_thread+0x10/0x10
> >     [ 1705.298714]  kthread+0xff/0x130
> >     [ 1705.299022]  ? __pfx_kthread+0x10/0x10
> >     [ 1705.299333]  ret_from_fork+0x30/0x50
> >     [ 1705.299641]  ? __pfx_kthread+0x10/0x10
> >     [ 1705.299947]  ret_from_fork_asm+0x1a/0x30
> >     [ 1705.300257]  </TASK>
> >     [=E2=80=A6]
> >     [ 1733.296255]  <TASK>
> >     [ 1733.296556]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
> >     [ 1733.296862]  ? _raw_spin_unlock_irq+0x10/0x30
> >     [ 1733.297170]  ? _raw_spin_unlock_irq+0xa/0x30
> >     [ 1677.294586]  raid5d at drivers/md/raid5.c:6572
> >     [ 1733.297792]  md_thread+0xc1/0x170
> >     [ 1733.298096]  ? __pfx_autoremove_wake_function+0x10/0x10
> >     [ 1733.298403]  ? __pfx_md_thread+0x10/0x10
> >     [ 1733.298711]  kthread+0xff/0x130
> >     [ 1733.299018]  ? __pfx_kthread+0x10/0x10
> >     [ 1733.299330]  ret_from_fork+0x30/0x50
> >     [ 1733.299637]  ? __pfx_kthread+0x10/0x10
> >     [ 1733.299943]  ret_from_fork_asm+0x1a/0x30
> >     [ 1733.300251]  </TASK>
> >
> > > Meanwhile, can you check if the underlying
> > > disks has IO while raid5 stuck, by /sys/block/[device]/inflight.
> >
> > The two devices that are left after the 3rd one is removed has these
> > numbers that don't change with time:
> >
> >     [Mon Jul 22 20:18:06 @ ~]:> for d in dm-19 dm-17; do echo -n $d;
> > cat
> >     /sys/block/$d/inflight; done
> >     dm-19       9        1
> >     dm-17      11        2
> >     [Mon Jul 22 20:18:11 @ ~]:> for d in dm-19 dm-17; do echo -n $d;
> > cat
> >     /sys/block/$d/inflight; done
> >     dm-19       9        1
> >     dm-17      11        2
> >
> > They also don't change after I return the disk back (which is to be
> > expected I guess, given that the lockup doesn't go away).
> >
> > > >
> > > > > At first, can the problem reporduce with raid1/raid10? If not,
> > > > > this
> > > > > is
> > > > > probably a raid5 bug.
> > > >
> > > > This is not reproducible with raid1 (i.e. no lockups for raid1),
> > > > I
> > > > tested that. I didn't test raid10, if you want I can try (but
> > > > probably
> > > > only after the weekend, because today I was asked to give the
> > > > nodes
> > > > away, for the weekend at least, to someone else).
> > >
> > > Yes, please try raid10 as well. For now I'll say this is a raid5
> > > problem.
> >
> > Tested: raid10 works just fine, i.e. no lockup and fio continues
> > having non-zero IOPS.
> >
> > > > > The best will be that if I can reporduce this problem myself.
> > > > > The problem is that I don't understand the step 4: turning off
> > > > > jbod
> > > > > slot's power, is this only possible for a real machine, or can
> > > > > I
> > > > > do
> > > > > this in my VM?
> > > >
> > > > Well, let's say that if it is possible, I don't know a way to do
> > > > that.
> > > > The `sg_ses` commands that I used
> > > >
> > > >   sg_ses --dev-slot-num=3D9 --set=3D3:4:1   /dev/sg26 #
> > > > turning
> > > > off
> > > >   sg_ses --dev-slot-num=3D9 --clear=3D3:4:1 /dev/sg26 #
> > > > turning
> > > > on
> > > >
> > > > =E2=80=A6sets and clears the value of the 3:4:1 bit, where the bit =
is
> > > > defined
> > > > by the JBOD's manufacturer datasheet. The 3:4:1 specifically is
> > > > defined
> > > > by "AIC" manufacturer. That means the command as is unlikely to
> > > > work on
> > > > a different hardware.
> > >
> > > I never do this before, I'll try.
> > > >
> > > > Well, while on it, do you have any thoughts why just using a
> > > > `echo
> > > > 1 >
> > > > /sys/block/sdX/device/delete` doesn't reproduce it? Does perhaps
> > > > kernel
> > > > not emulate device disappearance too well?
> > >
> > > echo 1 > delete just delete the disk from kernel, and scsi/dm-raid
> > > will
> > > know that this disk is deleted. However, the disk will stay in
> > > kernel
> > > for the other way, dm-raid does not aware that underlying disks are
> > > problematic and IO will still be generated and issued.
> > >
> > > Thanks,
> > > Kuai
>
>

