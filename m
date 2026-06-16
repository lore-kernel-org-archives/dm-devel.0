Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F5917555;
	Tue, 16 Jun 2026 00:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781568364; cv=none; b=AwA9stbfS1evSX+P1I29MN7ikrrwASjYeJNSMn3lelXggWbhmcTqv/IC37W5u6runVvu9453XZBAwP2+9KbRAX2jraX3TTr9XKXFsNGlCNHogJA1rC4Ho7x04GRTbfrdY+2EoGXU9NQB6R1UsIhYI9dZVMJtH3npmrLXVmMBqGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781568364; c=relaxed/simple;
	bh=dCzH09ZkuD1AgzdmKLO1CA9KGoefFYYfGVx00yz3kkk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ukjqYVjIX14IVhwvPimCrCvcmfYl2jLpVL06/Kyo4wpbZXol00nSDVjEDROvAxBa6YsgxH68+FkA1/jP0NRTn17vMAPRTxTyHB3Q/lVqMB5fAhlXy6vvgfYOcatk5Q8Wb909F2XdyLaXA/3cYH36dWY6DVaJtrMHgGMqzf7HLFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F4Uwpx/F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F4Uwpx/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B181F000E9;
	Tue, 16 Jun 2026 00:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781568362;
	bh=D0PoIHVHhiMu7J6asi9m9ZoXppYPlvsCw4tTs7m5Bvg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F4Uwpx/FZNdzP8KBMuGIBz/U0evnRCHDgd6WzE/vtxwW0fxBGMgrFTUkZDQxZptnO
	 hJ05qUxhuhK+jPBtCtv8RLiatIq3U0RrhMy0xI6Nxfxva+Cn4wDItpIw9rr3DyFQ/O
	 /xMOr7TSAD0Etb0v0OzN7pf0d960CzZUajbQRWIKpeJiCPbnCj1SRQApGl/97GqXIu
	 jr0ebR48OmZxxEDAiPphmTR86frtbGb2uY3iXqJnAbKm6bkoxwnZV27BlyzcOak/7p
	 6OXNWt4vsrTq4oJwZLD2FztWOfoOR+ZM5dahl5S2+EGU0EkJ/UbsymihvR1Hzij1ZH
	 /rWLdGUh+Wa1A==
Date: Mon, 15 Jun 2026 18:06:01 -0600
From: Keith Busch <kbusch@kernel.org>
To: Vjaceslavs Klimovs <vklimovs@gmail.com>
Cc: "Dr. David Alan Gilbert" <linux@treblig.org>,
	Thorsten Leemhuis <regressions@leemhuis.info>, trnka@scm.com,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	Linux kernel regressions list <regressions@lists.linux.dev>
Subject: Re: Repeatable, raid1+O_DIRECT, hang/warn
Message-ID: <ajCTaUaACV9eNmWo@kbusch-mbp>
References: <ai7rnH20IYeSmY8s@gallifrey>
 <165d3195-c81d-4760-870b-23a9a3b3b72c@leemhuis.info>
 <ai_1LYtofh1fwD-N@gallifrey>
 <CAC_j7i0eDccVWzPeRafM50mZEOFHPz2cwd=RZqqx6TK2EVRFvw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC_j7i0eDccVWzPeRafM50mZEOFHPz2cwd=RZqqx6TK2EVRFvw@mail.gmail.com>

On Mon, Jun 15, 2026 at 04:16:12PM -0700, Vjaceslavs Klimovs wrote:
> Your trace looks like what the two earlier reports hit: a read reaching
> a leaf device with sectors > 0 but phys_seg 0 (an empty bio). One aside
> that may help read the trace: blk_io_trace.error is a __u16, so the
> bracketed values on your C lines are errnos as u16 (65514 = -EINVAL,
> 65531 = -EIO).
> 
> The WARN itself is new, the bad bio isn't. bio_add_page() only started
> rejecting len == 0 in 643893647cac ("block: reject zero length in
> bio_add_page()", v7.1-rc1); on 7.0.8 the same empty bio tripped
> scsi_alloc_sgtables()'s !nr_segs instead, which matches what you saw.
> That fits your "not a recent regression": the condition is older, v7.1
> just made it loud.
> 
> For Tomas's and my reports (QEMU O_DIRECT to the LV block device) the
> origin looks like 5ff3f74e145a ("block: simplify direct io validity
> check", v6.18): blkdev_dio_invalid() now checks only aggregate
> ki_pos | count alignment and dropped the per-segment
> bdev_iter_is_aligned() walk, so a degenerate or misaligned O_DIRECT no
> longer gets -EINVAL at the fops boundary. But your reproducer reads a
> file, which goes through the filesystem O_DIRECT path and never calls
> blkdev_dio_invalid(), and still makes the empty bio. So it isn't only
> that one entry point.
> 
> dm-mirror then hangs because Keith's f7b24c7b41f2 only covers md
> raid1/raid10; legacy dm-mirror (dm-raid1.c) has no equivalent and
> rebuilds the empty read onto the other leg. Note the leg's status isn't
> even consistent (your SATA path returns BLK_STS_IOERR, not
> BLK_STS_INVAL), so copying that status check into dm-mirror probably
> wouldn't catch every case.
> 
> For what it's worth, that points me toward rejecting the empty or
> misaligned bio once, at submission, with -EINVAL, rather than teaching
> each consumer to tolerate it. But you'll know the tradeoffs far better
> than I do.
> 
> I have a small QEMU + LVM raid1/mirror setup that reproduces the
> block-device variant and bisects to 5ff3f74e. Happy to run your file
> reproducer with some instrumentation at the dm-mirror read entry
> (bi_size vs bio_sectors vs bvec lengths) to see whether the bio is
> already empty on arrival or built that way on the retry, and to test
> any patch.

Thanks for following up here. I didn't initially see your follow-up
until Thorsten linked it. I apologize for missing that, this feature is
important so I don't want to see anything regress for it.

There is a known bug fix I think future tests should include:

  https://lore.kernel.org/linux-block/20260612223205.465913-1-kbusch@meta.com/

This likely isn't the fix you're looking for, but including it rules out
conditions that are not important here.

After that, can we try this suggestion and see if the hang goes away?

  https://lore.kernel.org/linux-block/ajBb8tK-0aJBpIgF@kbusch-mbp/

I expect the original test case to still return an error (and I think it
was designed to), but it shouldn't produce the warn or bug splats with a
stuck uninterruptable task.
