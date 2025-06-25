Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA608284B2E
	for <dm-devel@lists.linux.dev>; Wed, 25 Jun 2025 09:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750842011; cv=none; b=fJfJTyZqd9s/ZrH9LIUoQI1thcwSpWRoSVGC5Cdd4y7xBLMxAlXzqzsMPQk4NpBNL1DMepl/q8qe591lVkdcreXn89v43MQsvEhoGKOajaXxXGScro/23TW9GKyEkKk4NaawHjmaagLrtOL2d5UNGPSk9tF5utWI4frjhY1kyzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750842011; c=relaxed/simple;
	bh=cLum2mJYNrXN/nie2yj6FwlHFnf7NcRI6AjEB2QtaPw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UM3NPw+AnfsPyaInE+fNODg6mt0E9Viqe9p5XeIKBKyjfNuV3/C9W0KqR9irAtSelIkYabazRyExIL2xWzThhofVvVdrzeEU9fXl1FKfaIXG8dOOP6hM6/D6KEaGgcFTBr0L4smnVaxB4s3YeuLTGpDad7eOlbh88pUgCoaOGBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=KqZ5i2sa; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="KqZ5i2sa"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-747fba9f962so536772b3a.0
        for <dm-devel@lists.linux.dev>; Wed, 25 Jun 2025 02:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1750842009; x=1751446809; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k+QCcUeb08PVGLXzIaRlTmAxctWwE4jc9s6GjnrKIno=;
        b=KqZ5i2sa8Rl8rdjwSOI335L6LGc3jPFtol4ArQDgbowVBwyY6pgi9eM9hBeqSxzF5s
         nlxqy3uOTkLy+Qaaua4wq6/MgmcuDg6fRzENGWCVtb0+0LamQYSnVadjoaPLn0C/sVSO
         pLMYrCnNTq1Creq1BfBP6O+GsL3bA6geQdxDhZZk3DE18NO5w6H9kkrqt/EM/cuEvEzO
         Zh0fDxVmxF+swldWP29aWkIaxAUnRKDW5J+t6iIbVqkPgL7RQ96ZrT3tKRQowGWOpQDv
         v5Dq3F13Y90mCynfhh1Ctw5frzNZolRJ713iGk/bJl1QjdNtNNQhiNZl/zYq6Ctk1XLn
         M6tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750842009; x=1751446809;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k+QCcUeb08PVGLXzIaRlTmAxctWwE4jc9s6GjnrKIno=;
        b=Nn5xiQcaVjvZ8WC4645N1lz91dGAJm1Butq1kFfYHHUWGgQ8u5KphPw7R+0K41derV
         Ct7V3hlrwwSxqVz6gwoPn6FNZfU5mR+/YGIy+RJYIO9vnJLY4YoGFDxlOQWnN0M15DMP
         Q304C5+eYWzWxwfVjE1JHBDrba0sYVr+8NeucCsqrBsWxJ87FwOa6a8Yjy2oCIxs3Sra
         xIFqRK9w4nbmpNa3t59QnKuWVDUfygbJoi4ukf+aOCpzb60pu7oE++9m+5ilgtymXr+L
         5kMGX42rJWubw/bbMqmkWluvqlKfMMvupYi0vDskkarlMOY0R4gZtqe62+9+wplzw1D2
         yabw==
X-Forwarded-Encrypted: i=1; AJvYcCXgWv58+la1uMWrMC43duugno948oD8TaYrhKcXdFqyod8TYGp3zGYcAUMz+OPRUacLHQaeysAYAw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy22u4kIaULchV1Yyfr1a9L261O9zhDxWVQX+wX845unF1rVYBq
	mYXAI8nPQz3ZPxDYBMaMLxS1ximPpRSLYZugxFQjVauf1kWfe/FvpDKAk1yM4RQMioc=
X-Gm-Gg: ASbGnculFk7ZexaEgwsK6cJjHA1bAfcOBIvjCkX1q56zjxD7R0xQpp1Byiuk0OGwCM+
	KsL33RfQ2k5HGtZJHIop/1TM1rUnPDhku4k5AaQldTfhpmbTgwKmPubbf7SvbKdScGivLnnjnwS
	WcFtMUAVhLUJAGnIYdvccBcdKvWTk1ajKfTDckXT1KCRC3OLOlKcX1XCiwXMSkj+S5EW/REBNAO
	4oIXfAvaLQXUeURN3N6TEsQPu5qkvOcV1eqtw+3RyzArwFobBAm41nl5onMrmbRz+ZGJEt55jlf
	W3Mm6x58hpyABWUdBeGFApBPW1RWRLTlpUoIoz2lf7fqvSOCK72M6jBiRU9Ha808bniqDrII+Vd
	05AuecAKWyEyDanKul60tzsrhwT/bUxfFocmlDg==
X-Google-Smtp-Source: AGHT+IGaTqimpJw/4oAiia6YAOj/kfdUDPbXcRo6du0JRPUlo1fFAabQi/ht+lvPmevXa5TYRjq+JA==
X-Received: by 2002:a05:6a00:1826:b0:736:9f2e:1357 with SMTP id d2e1a72fcca58-74ad4dd8aaemr2735688b3a.12.1750842008926;
        Wed, 25 Jun 2025 02:00:08 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-749b5e09e1csm3744195b3a.5.2025.06.25.02.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 02:00:08 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uULzB-000000030hB-3Ci4;
	Wed, 25 Jun 2025 19:00:05 +1000
Date: Wed, 25 Jun 2025 19:00:05 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: [WARN 6.16-rc3] warning in bdev_count_inflight()
Message-ID: <aFu6laXAY0_0Wga3@dread.disaster.area>
References: <aFuypjqCXo9-5_En@dread.disaster.area>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFuypjqCXo9-5_En@dread.disaster.area>

On Wed, Jun 25, 2025 at 06:26:14PM +1000, Dave Chinner wrote:
> Hi Jens,
> 
> I had this warning fire on 6.16-rc3 whilst running fstests. I don't
> know what test caused it - I run 64 tests in parallel over a couple
> of hundred loop devices, so there's lots of stuff going on all the
> time.
> 
> This warning fired when xfs_repair was running on some kind of DM
> device:
> 
> [ 7339.374977] ------------[ cut here ]------------
> [ 7339.378576] WARNING: CPU: 49 PID: 2034647 at block/genhd.c:144 bdev_count_inflight+0x7c/0x90
> [ 7339.382933] Modules linked in:
> [ 7339.385169] CPU: 49 UID: 0 PID: 2034647 Comm: xfs_repair Not tainted 6.16.0-rc3-dgc+ #342 PREEMPT(full)
> [ 7339.390668] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [ 7339.396211] RIP: 0010:bdev_count_inflight+0x7c/0x90
> [ 7339.399196] Code: ff 48 8b 94 16 90 00 00 00 01 d3 48 ff c0 eb bc 45 85 ff 78 15 85 db 78 1a 44 01 fb 89 d8 5b 41 5e 41 5f 5d c3 cc cc cc cc cc <0f> 0b 45 31 ff 85 db 79 e6 0f 0b 31 db eb e0 0f 1f 44 00 00 90 90
> [ 7339.409039] RSP: 0018:ffffc900100bf978 EFLAGS: 00010286
> [ 7339.412126] RAX: 0000000000000040 RBX: 0000000000000000 RCX: 0000000000000040
> [ 7339.417910] RDX: 0000000000000040 RSI: 0000000000000040 RDI: ffffffff82f911c8
> [ 7339.421923] RBP: ffffc900100bf990 R08: 0000000000000c00 R09: ffff889878c81400
> [ 7339.425940] R10: 0000000000000000 R11: ffffffff823dc150 R12: 00000001006b668c
> [ 7339.433641] R13: ffff889849c98600 R14: ffff889849c98600 R15: 00000000ffffffff
> [ 7339.437308] FS:  00007f383ad55680(0000) GS:ffff88a09a4b1000(0000) knlGS:0000000000000000
> [ 7339.441577] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 7339.444716] CR2: 00007f3820000020 CR3: 0000001886ec6000 CR4: 0000000000350ef0
> [ 7339.447851] Call Trace:
> [ 7339.449436]  <TASK>
> [ 7339.450683]  bdev_start_io_acct+0x58/0xc0
> [ 7339.452661]  dm_io_acct+0x60/0x100
> [ 7339.454471]  dm_submit_bio_remap+0x4f/0x100
> [ 7339.456592]  __map_bio+0x125/0x260
> [ 7339.458423]  dm_submit_bio+0x562/0xd70
> [ 7339.459996]  ? kmem_cache_alloc_noprof+0x188/0x320
> [ 7339.462501]  ? __blk_flush_plug+0xe6/0x140
> [ 7339.464613]  __submit_bio+0x12c/0x210
> [ 7339.467010]  submit_bio_noacct_nocheck+0x12e/0x2a0
> [ 7339.469166]  ? iov_iter_extract_pages+0x152/0x220
> [ 7339.476238]  submit_bio_noacct+0x2fd/0x380
> [ 7339.478354]  submit_bio+0xe5/0xf0
> [ 7339.480182]  submit_bio_wait+0x54/0xc0
> [ 7339.481722]  blkdev_direct_IO+0x415/0x480
> [ 7339.483977]  ? __pfx_submit_bio_wait_endio+0x10/0x10
> [ 7339.487079]  blkdev_read_iter+0x9d/0x170
> [ 7339.494123]  vfs_read+0x269/0x2f0
> [ 7339.494131]  __x64_sys_pread64+0x71/0xc0
> [ 7339.494134]  x64_sys_call+0x28ca/0x2f60
> [ 7339.498789]  do_syscall_64+0x6b/0x1f0
> [ 7339.498794]  ? exc_page_fault+0x70/0xa0
> [ 7339.498798]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [ 7339.505840] RIP: 0033:0x7f383dd039ee
> [ 7339.505845] Code: 08 0f 85 f5 4b ff ff 49 89 fb 48 89 f0 48 89 d7 48 89 ce 4c 89 c2 4d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 89 5c 24 08 0f 05 <c3> 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 80 00 00 00 00 48 83 ec 08
> [ 7339.505848] RSP: 002b:00007f383ad548e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000011
> [ 7339.505851] RAX: ffffffffffffffda RBX: 00007f383ad55680 RCX: 00007f383dd039ee
> [ 7339.505854] RDX: 0000000000000200 RSI: 000055f7bb191400 RDI: 0000000000000004
> [ 7339.538888] rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: {
> [ 7339.541277] RBP: 0000000000000200 R08: 0000000000000000 R09: 0000000000000000
> [ 7339.541282] R10: 000000001c200000 R11: 0000000000000246 R12: 00000000000e1000
> [ 7339.544844]  49-....
> [ 7339.548428] R13: 0000000000000001 R14: 00007f383ad54a60 R15: 000055f7bb186ae0
> [ 7339.548433]  </TASK>
> 

Not a one-off. Just hit it again from fsx doing RWF_DONTCACHE IO,
and given that I've never seen this until 6.16-rc3, it's probably a
recent regression.

 ------------[ cut here ]------------
 WARNING: CPU: 11 PID: 1137920 at block/genhd.c:146 bdev_count_inflight+0x85/0x90
 Modules linked in:
 CPU: 11 UID: 0 PID: 1137920 Comm: fsx Tainted: G        W           6.16.0-rc3-dgc+ #342 PREEMPT(full)
 Tainted: [W]=WARN
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
 RIP: 0010:bdev_count_inflight+0x85/0x90
 Code: 01 d3 48 ff c0 eb bc 45 85 ff 78 15 85 db 78 1a 44 01 fb 89 d8 5b 41 5e 41 5f 5d c3 cc cc cc cc cc 0f 0b 45 31 ff 85 db 79 e6 <0f> 0b 31 db eb e0 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90
 XFS (loop357): Mounting V5 Filesystem 8c4f5c6c-3a2b-402d-96ed-19ccc1845e50
 RSP: 0018:ffffc9000d727700 EFLAGS: 00010286
 RAX: 0000000000000040 RBX: 00000000ffffffff RCX: 0000000000000040
 RDX: 0000000000000040 RSI: 0000000000000040 RDI: ffffffff82f911c8
 RBP: ffffc9000d727718 R08: 00000000000003f0 R09: 000018795ca45f1b
 R10: 0000000000000000 R11: ffffffff81328110 R12: 00000001015980ee
 R13: 0000000000000000 R14: ffff88884400b000 R15: 0000000000000000
 FS:  00007f5978c75740(0000) GS:ffff88889a731000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000055c7311d1918 CR3: 00000009ac6b6000 CR4: 0000000000350ef0
 Call Trace:
  <TASK>
  update_io_ticks+0x47/0x80
  blk_account_io_start+0xd4/0x190
  blk_mq_submit_bio+0x259/0x700
  __submit_bio+0x99/0x210
  submit_bio_noacct_nocheck+0xad/0x2a0
  submit_bio_noacct+0x2fd/0x380
  submit_bio+0xe5/0xf0
  xfs_submit_ioend+0x9b/0xb0
  iomap_writepages+0xaab/0xb40
  xfs_vm_writepages+0x1b2/0x1e0
  do_writepages+0xbf/0x1d0
  filemap_fdatawrite_range_kick+0x84/0xb0
  xfs_file_buffered_write+0x22d/0x290
  xfs_file_write_iter+0x137/0x270
  do_iter_readv_writev+0x190/0x1f0
  vfs_writev+0x11a/0x350
  __se_sys_pwritev2+0x6b/0xf0
  __x64_sys_pwritev2+0x25/0x30
  x64_sys_call+0x1d0c/0x2f60
  do_syscall_64+0x6b/0x1f0

> I have no idea if it is reproducable - this is the first time I've
> hit it. I've cc'd the DM list so they are aware of this, too.

Latest hit indicates that it has nothing to do with DM at all.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
