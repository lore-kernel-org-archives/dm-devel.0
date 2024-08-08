Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD53F187855
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 07:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723100830; cv=none; b=rINXrKC2midEUWbINC42tgMYjkSkX+INmpK3AjxpEQsMRwgxNjwi7DkvBGB5pmhYp6q3QnXMIoRZ/0iR0v43LlCSzjKAFl2s277OnO2sDf/Q3uXp1obD9GJn+axzxXk+cQt8mcEyuwwYI1H5MpwjGL+vTozdz4gHTgK3tpG8cv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723100830; c=relaxed/simple;
	bh=XYjREJe5d9EZmzxnqwmH1ONaO9grsnYIEi5aOtXCTeU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=lBWVFPN53Pim1xDdQJ79opwKhvYtCl/NW6RrcMqGAB39TIGbv+cXJr8l6oqQxGdbPeJ4Sr/5hQW+l4B2apWWrnlCfMv3bj/MeakMwtckyyHeIJLG8vt6o/s3W0JgXRdqJgVDnbMEzzI6VMnJnhweMwK9Y9/K85hrCMqvwlBCExM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=KdlGc78H; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="KdlGc78H"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1723100825;
	bh=tQKFZ1koSpp25USGTdUA496wrotpEXbF8P1tU2E4/Tc=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=KdlGc78H4/rH6BDkhRZE06fFWD0yE5YcylxSLmA/G8zL39x1iTKF+iH6GvYQI3tqg
	 Oe9iZWYQLKF4BGCLLiTWhz8TaaqyN7ob0F3AdJPU6mQ3QzzFO9bnEbWJuFBBAxSegb
	 +odHIpfB7qSUb6KyF/bY6vCAUz+CXlShFU+jW55Q=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <1dfc4792-02b2-5b3c-c3d1-bf1b187a182e@huaweicloud.com>
Date: Thu, 8 Aug 2024 09:06:44 +0200
Cc: John Stoffel <john@stoffel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <4363F3A3-46C2-419E-B43A-4CDA8C293CEB@flyingcircus.io>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
 <316050c6-fac2-b022-6350-eaedcc7d953a@huaweicloud.com>
 <58450ED6-EBC3-4770-9C5C-01ABB29468D6@flyingcircus.io>
 <EACD5B78-93F6-443C-BB5A-19C9174A1C5C@flyingcircus.io>
 <22C5E55F-9C50-4DB7-B656-08BEC238C8A7@flyingcircus.io>
 <26291.57727.410499.243125@quad.stoffel.home>
 <2EE0A3CE-CFF2-460C-97CD-262D686BFA8C@flyingcircus.io>
 <1dfc4792-02b2-5b3c-c3d1-bf1b187a182e@huaweicloud.com>
To: Yu Kuai <yukuai1@huaweicloud.com>

Hi,

> On 8. Aug 2024, at 08:55, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>=20
> Since 6.10 is the same, I take a closer look at this.

Much appreciated, thanks!

> At first is this a new problem or a new scenario?

Both? ;)

The user-level scenario (rsyncing those files) is a regular task that =
has been working fine. The new aspect of the scenario is only that =
we=E2=80=99re now using NVMe. The problem has not been observed before.

>> [ 7497.019235] INFO: task .backy-wrapped:2706 blocked for more than =
122 seconds.
>> [ 7497.027265]       Not tainted 6.10.3 #1-NixOS
>> [ 7497.032173] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" =
disables this message.
>> [ 7497.040974] task:.backy-wrapped  state:D stack:0     pid:2706  =
tgid:2706  ppid:1      flags:0x00000002
>> [ 7497.040979] Call Trace:
>> [ 7497.040981]  <TASK>
>> [ 7497.040987]  __schedule+0x3fa/0x1550
>> [ 7497.040996]  ? xfs_iextents_copy+0xec/0x1b0 [xfs]
>> [ 7497.041085]  ? srso_alias_return_thunk+0x5/0xfbef5
>> [ 7497.041089]  ? xlog_copy_iovec+0x30/0x90 [xfs]
>> [ 7497.041168]  schedule+0x27/0xf0
>> [ 7497.041171]  io_schedule+0x46/0x70
>> [ 7497.041173]  folio_wait_bit_common+0x13f/0x340
>> [ 7497.041180]  ? __pfx_wake_page_function+0x10/0x10
>> [ 7497.041187]  folio_wait_writeback+0x2b/0x80
>> [ 7497.041191]  truncate_inode_partial_folio+0x5b/0x190
>> [ 7497.041194]  truncate_inode_pages_range+0x1de/0x400
>> [ 7497.041207]  evict+0x1b0/0x1d0
>> [ 7497.041212]  __dentry_kill+0x6e/0x170
>> [ 7497.041216]  dput+0xe5/0x1b0
>> [ 7497.041218]  do_renameat2+0x386/0x600
>> [ 7497.041226]  __x64_sys_rename+0x43/0x50
>> [ 7497.041229]  do_syscall_64+0xb7/0x200
>> [ 7497.041234]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> [ 7497.041236] RIP: 0033:0x7f4be586f75b
>> [ 7497.041265] RSP: 002b:00007fffd2706538 EFLAGS: 00000246 ORIG_RAX: =
0000000000000052
>> [ 7497.041267] RAX: ffffffffffffffda RBX: 00007fffd27065d0 RCX: =
00007f4be586f75b
>> [ 7497.041269] RDX: 0000000000000000 RSI: 00007f4bd6f73e50 RDI: =
00007f4bd6f732d0
>> [ 7497.041270] RBP: 00007fffd2706580 R08: 00000000ffffffff R09: =
0000000000000000
>> [ 7497.041271] R10: 00007fffd27067b0 R11: 0000000000000246 R12: =
00000000ffffff9c
>> [ 7497.041273] R13: 00000000ffffff9c R14: 0000000037fb4ab0 R15: =
00007f4be5814810
>> [ 7497.041277]  </TASK>
>> [ 7497.041281] INFO: task kworker/u131:1:12780 blocked for more than =
122 seconds.
>> [ 7497.049410]       Not tainted 6.10.3 #1-NixOS
>> [ 7497.054317] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" =
disables this message.
>> [ 7497.063124] task:kworker/u131:1  state:D stack:0     pid:12780 =
tgid:12780 ppid:2      flags:0x00004000
>> [ 7497.063131] Workqueue: kcryptd-253:4-1 kcryptd_crypt [dm_crypt]
>> [ 7497.063140] Call Trace:
>> [ 7497.063141]  <TASK>
>> [ 7497.063145]  __schedule+0x3fa/0x1550
>> [ 7497.063154]  schedule+0x27/0xf0
>> [ 7497.063156]  md_bitmap_startwrite+0x14f/0x1c0
>=20
> =46rom code review, the counter for the bit reaches COUNTER_MAX, means
> there are already lots of write IO issued in the range represented by
> this bit. And md_bitmap_startwrite() is waiting for such IO to be done
> to issue new IO. Hence either IO is handered too slow or deadlock is
> triggered.
>=20
> So for the next step, can you do the following test for problem
> identificatioin?
>=20
> 1) With the hangtaks, are the underlying disks idle?(By iostat). And =
can
> you please collect /sys/block/[disk]/inflight for both raid and
> underlying disks.

I will try that.

> 2) Can you still reporduce the problem with raid1/raid10?
> 3) Can you still reporduce the problem with bitmap disabled? By adding
> md-bitmap=3Dnone while creating the array.

Here=E2=80=99s the part where debugging is limited: I do have valuable =
data on this machine. If we can get around re-creating the array that =
would be great. Otherwise I=E2=80=99ll have to move the data to a =
different host - this can be done but it will take some time.

I could take the hot-spare out of the cluster and do something with it, =
but I guess that doesn=E2=80=99t give you any insight, right?

I=E2=80=99ll get back to you with the information from question 1.

Christian

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

