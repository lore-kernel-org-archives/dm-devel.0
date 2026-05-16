Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.63.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071F62D63E8;
	Sat, 16 May 2026 05:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.68.63.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778908226; cv=none; b=JDmr2g7T92x04FVLAqSm4+SHH2KfaNVY2j+LLnNVkP2AHwV9CX1Xhv+g3j2IIjvBAXoz3hNZXj/RAvcScve9n8JRYlIGUIp4LklGN/dFweXAm83qnB3ApkYygct599H/UUXelXzLvO96/Gjr3Uf8NxAy1XwoX0cWokhy4JkLxGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778908226; c=relaxed/simple;
	bh=D8BHF2e7ol40Q7czWVQrbVmOuHc1mEAiLQSWLpEkrvI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BDDd/m1Rrwp+OTFaLsrAAcN9bNUuI3+aLxCdHiPyxgpx4/pcspHvvoWEqyOvjujFPy735BMY9JZ3Nv9K2f6COx44iPUkF60VMk0DlumHxdMn063PR5Ebncb8VtJ2ZYIl1aX0s+R8P2J0Ag+s4/AvWNaYUwkAwTLTAlziQ1gbcbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=A7nUkgN2; arc=none smtp.client-ip=188.68.63.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="A7nUkgN2"
Received: from mors-relay-8201.netcup.net (localhost [127.0.0.1])
	by mors-relay-8201.netcup.net (Postfix) with ESMTPS id 4gHXFL3RKYz3vx0;
	Sat, 16 May 2026 07:10:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1778908214;
	bh=D8BHF2e7ol40Q7czWVQrbVmOuHc1mEAiLQSWLpEkrvI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=A7nUkgN2eGOvhU4WXMKHGEa6P2r5vE1nEWor7QJtO9m1csBo5P0lDFTNDIJROzKJS
	 rvg9NRoSrDwnD8E2bzLRBSLyLAtBOVZyGgrb5JcqSwa4gz7rsKpwfWGZ8P9k9MNLpt
	 b142NZB7PmuaPW82o5nd5n+woeNwLOkTzhX3aGdrUM1cS8WaDeFDSsgWiZI0S8z8f1
	 BLmoJ+/qwzenmPic+AovSbBTqzPHJXMF4U9KFfU62J0poS8DZQujsK4XHGJ6cvYexo
	 rWdz0BvKL9gmYvGg87gAWiLf7YemXIyQksDlJ75SEtCer4k6IB/hGZ/SgN5YvL3laR
	 /v4Gfh5BOVDvw==
Received: from policy01-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-8201.netcup.net (Postfix) with ESMTPS id 4gHXDX2j94z3vxf;
	Sat, 16 May 2026 07:09:32 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at policy01-mors.netcup.net
X-Spam-Flag: NO
X-Spam-Score: -2.901
X-Spam-Level: 
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy01-mors.netcup.net (Postfix) with ESMTPS id 4gHXDW1dMDz8tYK;
	Sat, 16 May 2026 07:09:31 +0200 (CEST)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id 485EA6038A;
	Sat, 16 May 2026 07:09:30 +0200 (CEST)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <c3e576c8-f548-4ee4-87de-cb9151f8a061@leemhuis.info>
Date: Sat, 16 May 2026 07:09:29 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] block: virtio-blk + LVM raid1 spurious sector-0 read
 failures on libaio/threads submit since 5ff3f74e145a ("block: simplify direct
 io validity check")
To: Vjaceslavs Klimovs <vklimovs@gmail.com>, Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@kernel.org>, Hannes Reinecke <hare@suse.de>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
 linux-raid@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, regressions@lists.linux.dev
References: 
 <CAC_j7i1R7oy+nRhxEjCTba=DUgn02w9X+p94DCu0aHv5+5tKnQ@mail.gmail.com>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: 
 <CAC_j7i1R7oy+nRhxEjCTba=DUgn02w9X+p94DCu0aHv5+5tKnQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: 
 <177890817076.3831586.10386450463854607080@mxe9fb.netcup.net>
X-Rspamd-Server: rspamd-worker-8404
X-Rspamd-Queue-Id: 485EA6038A
X-NC-CID: tAMvYmqH/meHEIlGdngnv5viqO4OlrXp0oO+3t/3OO+A03Yzhjs=

On 5/15/26 18:52, Vjaceslavs Klimovs wrote:
> Summary
> -------
> On v6.18, starting a libvirt/QEMU guest with virtio-blk backed by an
> LVM "--type raid1" LV (drivers/md/dm-raid.c stacked on
> drivers/md/raid1.c) makes md/raid1 register read failures at LV
> sector 0 within seconds of "virsh start" and mark rimage_0 Faulty
> once max_corrected_read_errors (default 20) is exceeded. Reads
> succeed via the redirect path so guests boot, but every guest disk
> ends up degraded on every VM start. Same workload on legacy
> "--type mirror" (drivers/md/dm-raid1.c) crashes the host: a
> zero-length READ reaches the NVMe controller, is rejected with
> "Invalid Field in Command", and the dm-mirror recovery path oopses.

That sounds somewhat like
https://lore.kernel.org/all/2982107.4sosBPzcNG@electra/

Have you tried latest 7.1-rc? It contains a fix for the problem
mentioned in said thread: f7b24c7b41f23b ("md/raid1,raid10: don't fail
devices for invalid IO errors") [v7.1-rc2]

Ciao, Thorsten

> Symptom on dm-raid raid1 (post --type raid1)
> --------------------------------------------
> Per LV, at virsh start, in host dmesg:
> 
>   kernel: raid1_end_read_request: 95 callbacks suppressed
>   kernel: raid1_read_request: 95 callbacks suppressed
>   kernel: md/raid1:mdX: dm-58: rescheduling sector 0
>   kernel: md/raid1:mdX: redirecting sector 0 to other mirror: dm-58
>   kernel: md/raid1:mdX: dm-58: rescheduling sector 0
>   kernel: md/raid1:mdX: redirecting sector 0 to other mirror: dm-58
>   [... 10 rescheduling/redirecting pairs ...]
>   kernel: md/raid1:mdX: dm-58: Raid device exceeded read_error
> threshold [cur 21:max 20]
>   kernel: md/raid1:mdX: dm-58: Failing raid device
>   kernel: md/raid1:mdX: Disk failure on dm-58, disabling device.
>   kernel: md/raid1:mdX: Operation continuing on 1 devices.
> 
>   dmeventd: WARNING: Device #0 of raid1 array, vg0-iris_boot, has failed.
>   dmeventd: WARNING: Waiting for resynchronization to finish before
> initiating repair on RAID device vg0-iris_boot.
>   dmeventd: Use 'lvconvert --repair vg0/iris_boot' to replace failed device.
> 
> Subsequent "lvs -a":
> 
>   WARNING: RaidLV vg0/iris_boot needs to be refreshed!
>   See character 'r' at position 9 in the RaidLV's attributes and its SubLV(s).
> 
> dmesg | grep nvme is EMPTY on this path. The NVMe driver is not
> involved in producing the error; the failure originates between the
> virtio-blk bio submission and raid1_end_read_request().
> 
> Symptom on legacy dm-mirror (pre-conversion --type mirror)
> ----------------------------------------------------------
> Same workload on drivers/md/dm-raid1.c reaches the NVMe controller
> as a zero-length READ and panics the host through dm-mirror's
> recovery path:
> 
>   kernel: operation not supported error, dev nvme1n1, sector 935446535
> op 0x0:(READ) flags 0x0 phys_seg 0 prio class 2
>   kernel: nvme1n1: I/O Cmd(0x2) @ LBA 935446535, 0 blocks, I/O Error
> (sct 0x0 / sc 0x2)
>   [... 10+ identical bursts at same timestamp ...]
>   dmeventd: Primary mirror device 252:58 read failed.
>   dmeventd: vg0-iris_boot is now in-sync.
>   [kernel oops in dm_mirror recovery path, full trace lost to console flash]
> 
> The "phys_seg 0", "0 blocks", "sct 0x0/sc 0x2" trio (NVMe Generic,
> Invalid Field in Command, NVMe spec 4.1.1.2) is unambiguous: a bio
> with bi_iter.bi_size == 0 and bi_vcnt == 0 left the block layer and
> hit the controller. dm-raid raid1 hides this by retrying on the
> surviving leg, but the upstream-of-md trigger is identical.
> 
> Bisect
> ------
> git bisect, v6.12..v6.18, 16 deterministic GOOD/BAD steps, no skips,
> ~104 minutes:
> 
>   5ff3f74e145adc79b49668adb8de276446acf6be is the first bad commit
>   block: simplify direct io validity check
> 
>   --- a/block/fops.c
>   +++ b/block/fops.c
>   @@ -38,8 +38,8 @@ static blk_opf_t dio_bio_write_op(struct kiocb *iocb)
>    static bool blkdev_dio_invalid(struct block_device *bdev, struct kiocb *iocb,
>                                   struct iov_iter *iter)
>    {
>   -        return iocb->ki_pos & (bdev_logical_block_size(bdev) - 1) ||
>   -                !bdev_iter_is_aligned(bdev, iter);
>   +        return (iocb->ki_pos | iov_iter_count(iter)) &
>   +                        (bdev_logical_block_size(bdev) - 1);
>    }
> 
> The dropped bdev_iter_is_aligned() used to walk the iov_iter and
> reject per-segment misaligned/degenerate vectors at the blkdev fops
> entry point. The replacement only validates ki_pos and total length
> against the logical block size. Cases that now pass that no longer
> get rejected:
> 
>   - iter with iov_iter_count(iter) == 0  (degenerate; total length is
>     "sector-aligned" since 0 % 512 == 0)
>   - iter where total length is sector-aligned but a segment isn't
> 
> The commit message justifies the removal with "The block layer
> checks all the segments for validity later". This is true for the
> io_uring submit path (which enters __blkdev_direct_IO directly and
> does its own validation) but not for the libaio aio_read/write_iter
> or the worker-pool sync read/write_iter paths that enter via
> blkdev_{read,write}_iter() -> blkdev_dio_invalid(). For those paths,
> the segment check has no replacement.
> 
> Reproducing
> ----------------------------------------------------------
> 
> The trigger requires QEMU virtio-blk's specific submission shape AND
> a non-io_uring submit. Userspace libaio alone, userspace
> preadv-in-a-thread alone, and QEMU's raw-driver open probes (which
> qemu-img info exercises identically) are all insufficient. The
> combination that hits the bug is "guest-driven I/O through
> virtio-blk-pci with cache.direct=on and aio in {native, threads}".
> 
> #regzbot introduced: 5ff3f74e145adc79b49668adb8de276446acf6be
> 
> Thanks,
> Vjaceslavs Klimovs
> 

