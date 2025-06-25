Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A368326981C;
	Wed, 25 Jun 2025 14:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750862892; cv=none; b=l9xOfvpALx9dSPosywIm1p0Pfnwskfsd3qte6aqDD11KXgQuSj5uB5nYleuFXCli/LZE4f1oQNmEikCkROxvJUTwPm40en1LUc0MusbWW4f2TzII8sjbgP4U6uF22/xvHzCXlM9MPzD2LG4WzWBYsHuKXK+CwH7LnLbiA/tsLa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750862892; c=relaxed/simple;
	bh=FQhM2MZGAEK8rHpBO9SB75oLWlnPGskktCsXR30s3Uo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PlJnF0/Ys5Po7yeJd3eKZBfGUmF5gm75ZR1sSsySBH43R7vCP9P8GJEzk/vPMYJnylvR7awJ151MhhWQbg73vYRwf2DOessAYE6zdTj8kMd5aBIFsxtsV6PMd5j2STayDYtRNQTFq8haZ+66oi5pFuCUFDAMPpGNWaPhAwnR8Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LaxGieJ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LaxGieJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD03C4CEF5;
	Wed, 25 Jun 2025 14:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750862892;
	bh=FQhM2MZGAEK8rHpBO9SB75oLWlnPGskktCsXR30s3Uo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LaxGieJ/kSlW90lQyD1WKYFhBIwGiMQ594ZcRdBME9EDlUp4pJxikDS1tiimFf8VD
	 8rRdQcertTLiJW3WgYvgGbMeubmtdB24DAq3z4uOUKpKNjOqZZosndykwwkvcpFMK1
	 rikcFkxxwjRLkzFfGj7EAnfaEbkOdXfTOuaBEtWVTncK7xYVkpwKWMUbzL2+Aq5LqD
	 VQwQW82jCflKeBipnbHeGPiFtUR3M4A6EEH5rZ3vSOc4aUxc/pgA1TyzAi31h+lZs3
	 V6yW4g2gzeHXr7gUSq8kpBCAR9iY31cQAiyLvIakNzh3nqeB/sat2ar95oVB5Jdg2i
	 slqmg3sJNkTNg==
Message-ID: <36b2bb05-d26f-484b-acae-fdad7645f1cd@kernel.org>
Date: Wed, 25 Jun 2025 23:48:09 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [WARN 6.16-rc3] warning in bdev_count_inflight()
To: Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 dm-devel@lists.linux.dev, Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
References: <aFuypjqCXo9-5_En@dread.disaster.area>
 <aFu6laXAY0_0Wga3@dread.disaster.area>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <aFu6laXAY0_0Wga3@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/25/25 18:00, Dave Chinner wrote:
> On Wed, Jun 25, 2025 at 06:26:14PM +1000, Dave Chinner wrote:
>> Hi Jens,
>>
>> I had this warning fire on 6.16-rc3 whilst running fstests. I don't
>> know what test caused it - I run 64 tests in parallel over a couple
>> of hundred loop devices, so there's lots of stuff going on all the
>> time.
>>
>> This warning fired when xfs_repair was running on some kind of DM
>> device:

You are not alone seeing this one. Shin'ichiro saw it with blktests runs and
other peoples have mentioned seeing it with various hardware as well. We have no
reliable reproducer yet, and because it randomly shows up. So it is hard to
debug. This is since 6.16-rc1 I think.

>>
>> [ 7339.374977] ------------[ cut here ]------------
>> [ 7339.378576] WARNING: CPU: 49 PID: 2034647 at block/genhd.c:144 bdev_count_inflight+0x7c/0x90
>> [ 7339.382933] Modules linked in:
>> [ 7339.385169] CPU: 49 UID: 0 PID: 2034647 Comm: xfs_repair Not tainted 6.16.0-rc3-dgc+ #342 PREEMPT(full)
>> [ 7339.390668] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>> [ 7339.396211] RIP: 0010:bdev_count_inflight+0x7c/0x90
>> [ 7339.399196] Code: ff 48 8b 94 16 90 00 00 00 01 d3 48 ff c0 eb bc 45 85 ff 78 15 85 db 78 1a 44 01 fb 89 d8 5b 41 5e 41 5f 5d c3 cc cc cc cc cc <0f> 0b 45 31 ff 85 db 79 e6 0f 0b 31 db eb e0 0f 1f 44 00 00 90 90
>> [ 7339.409039] RSP: 0018:ffffc900100bf978 EFLAGS: 00010286
>> [ 7339.412126] RAX: 0000000000000040 RBX: 0000000000000000 RCX: 0000000000000040
>> [ 7339.417910] RDX: 0000000000000040 RSI: 0000000000000040 RDI: ffffffff82f911c8
>> [ 7339.421923] RBP: ffffc900100bf990 R08: 0000000000000c00 R09: ffff889878c81400
>> [ 7339.425940] R10: 0000000000000000 R11: ffffffff823dc150 R12: 00000001006b668c
>> [ 7339.433641] R13: ffff889849c98600 R14: ffff889849c98600 R15: 00000000ffffffff
>> [ 7339.437308] FS:  00007f383ad55680(0000) GS:ffff88a09a4b1000(0000) knlGS:0000000000000000
>> [ 7339.441577] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [ 7339.444716] CR2: 00007f3820000020 CR3: 0000001886ec6000 CR4: 0000000000350ef0
>> [ 7339.447851] Call Trace:
>> [ 7339.449436]  <TASK>
>> [ 7339.450683]  bdev_start_io_acct+0x58/0xc0
>> [ 7339.452661]  dm_io_acct+0x60/0x100
>> [ 7339.454471]  dm_submit_bio_remap+0x4f/0x100
>> [ 7339.456592]  __map_bio+0x125/0x260
>> [ 7339.458423]  dm_submit_bio+0x562/0xd70
>> [ 7339.459996]  ? kmem_cache_alloc_noprof+0x188/0x320
>> [ 7339.462501]  ? __blk_flush_plug+0xe6/0x140
>> [ 7339.464613]  __submit_bio+0x12c/0x210
>> [ 7339.467010]  submit_bio_noacct_nocheck+0x12e/0x2a0
>> [ 7339.469166]  ? iov_iter_extract_pages+0x152/0x220
>> [ 7339.476238]  submit_bio_noacct+0x2fd/0x380
>> [ 7339.478354]  submit_bio+0xe5/0xf0
>> [ 7339.480182]  submit_bio_wait+0x54/0xc0
>> [ 7339.481722]  blkdev_direct_IO+0x415/0x480
>> [ 7339.483977]  ? __pfx_submit_bio_wait_endio+0x10/0x10
>> [ 7339.487079]  blkdev_read_iter+0x9d/0x170
>> [ 7339.494123]  vfs_read+0x269/0x2f0
>> [ 7339.494131]  __x64_sys_pread64+0x71/0xc0
>> [ 7339.494134]  x64_sys_call+0x28ca/0x2f60
>> [ 7339.498789]  do_syscall_64+0x6b/0x1f0
>> [ 7339.498794]  ? exc_page_fault+0x70/0xa0
>> [ 7339.498798]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>> [ 7339.505840] RIP: 0033:0x7f383dd039ee
>> [ 7339.505845] Code: 08 0f 85 f5 4b ff ff 49 89 fb 48 89 f0 48 89 d7 48 89 ce 4c 89 c2 4d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 89 5c 24 08 0f 05 <c3> 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 80 00 00 00 00 48 83 ec 08
>> [ 7339.505848] RSP: 002b:00007f383ad548e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000011
>> [ 7339.505851] RAX: ffffffffffffffda RBX: 00007f383ad55680 RCX: 00007f383dd039ee
>> [ 7339.505854] RDX: 0000000000000200 RSI: 000055f7bb191400 RDI: 0000000000000004
>> [ 7339.538888] rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: {
>> [ 7339.541277] RBP: 0000000000000200 R08: 0000000000000000 R09: 0000000000000000
>> [ 7339.541282] R10: 000000001c200000 R11: 0000000000000246 R12: 00000000000e1000
>> [ 7339.544844]  49-....
>> [ 7339.548428] R13: 0000000000000001 R14: 00007f383ad54a60 R15: 000055f7bb186ae0
>> [ 7339.548433]  </TASK>
>>
> 
> Not a one-off. Just hit it again from fsx doing RWF_DONTCACHE IO,
> and given that I've never seen this until 6.16-rc3, it's probably a
> recent regression.
> 
>  ------------[ cut here ]------------
>  WARNING: CPU: 11 PID: 1137920 at block/genhd.c:146 bdev_count_inflight+0x85/0x90
>  Modules linked in:
>  CPU: 11 UID: 0 PID: 1137920 Comm: fsx Tainted: G        W           6.16.0-rc3-dgc+ #342 PREEMPT(full)
>  Tainted: [W]=WARN
>  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>  RIP: 0010:bdev_count_inflight+0x85/0x90
>  Code: 01 d3 48 ff c0 eb bc 45 85 ff 78 15 85 db 78 1a 44 01 fb 89 d8 5b 41 5e 41 5f 5d c3 cc cc cc cc cc 0f 0b 45 31 ff 85 db 79 e6 <0f> 0b 31 db eb e0 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90
>  XFS (loop357): Mounting V5 Filesystem 8c4f5c6c-3a2b-402d-96ed-19ccc1845e50
>  RSP: 0018:ffffc9000d727700 EFLAGS: 00010286
>  RAX: 0000000000000040 RBX: 00000000ffffffff RCX: 0000000000000040
>  RDX: 0000000000000040 RSI: 0000000000000040 RDI: ffffffff82f911c8
>  RBP: ffffc9000d727718 R08: 00000000000003f0 R09: 000018795ca45f1b
>  R10: 0000000000000000 R11: ffffffff81328110 R12: 00000001015980ee
>  R13: 0000000000000000 R14: ffff88884400b000 R15: 0000000000000000
>  FS:  00007f5978c75740(0000) GS:ffff88889a731000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 000055c7311d1918 CR3: 00000009ac6b6000 CR4: 0000000000350ef0
>  Call Trace:
>   <TASK>
>   update_io_ticks+0x47/0x80
>   blk_account_io_start+0xd4/0x190
>   blk_mq_submit_bio+0x259/0x700
>   __submit_bio+0x99/0x210
>   submit_bio_noacct_nocheck+0xad/0x2a0
>   submit_bio_noacct+0x2fd/0x380
>   submit_bio+0xe5/0xf0
>   xfs_submit_ioend+0x9b/0xb0
>   iomap_writepages+0xaab/0xb40
>   xfs_vm_writepages+0x1b2/0x1e0
>   do_writepages+0xbf/0x1d0
>   filemap_fdatawrite_range_kick+0x84/0xb0
>   xfs_file_buffered_write+0x22d/0x290
>   xfs_file_write_iter+0x137/0x270
>   do_iter_readv_writev+0x190/0x1f0
>   vfs_writev+0x11a/0x350
>   __se_sys_pwritev2+0x6b/0xf0
>   __x64_sys_pwritev2+0x25/0x30
>   x64_sys_call+0x1d0c/0x2f60
>   do_syscall_64+0x6b/0x1f0
> 
>> I have no idea if it is reproducable - this is the first time I've
>> hit it. I've cc'd the DM list so they are aware of this, too.
> 
> Latest hit indicates that it has nothing to do with DM at all.
> 
> -Dave.


-- 
Damien Le Moal
Western Digital Research
