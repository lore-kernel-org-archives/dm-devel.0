Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BBF357D11;
	Tue, 16 Jun 2026 12:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781614675; cv=none; b=IF3lj1mfLDHe+JNueoMc7Uv3xNrhVFloxW3lvX8mb6FNDO7p15o8SpKj6LmYHI7YjYYzZQ2ApTJlxicKWWEy0VqO9U2HCZvP33AmC56Kb0P9kbHVKHrC8mDhypz5uqWcUSnZ7Ood/+mpeX7oHzQxLNnRTULuTUw+69gQPh8TK5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781614675; c=relaxed/simple;
	bh=zM6yyQduHzlBSbyi1O/QFeT0kfbgG1s5FfvjQ9Bm/y8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RTdOEqIDtHxGo3jk6GQxknzikX4MBOsRqOE9aDFEklhHLy5klpCuCnq2DKV5XU+8uyTqGQoB0NtKbdOxywBgPT58+ATCdHo61nGzCX8qo7ddyxJfoZODf52c6CwOolUJ4QWeo8hJtbvxZ4c0WICRDxox1fKSN9vtTtvOyRvpexg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=UeeXQpZY; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="UeeXQpZY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=F8hE4z9JRLxnrtDhuXfJ4p9jf50xX0zsN8ROHlQ6TS4=; b=UeeXQpZYKg97XZvH
	M18cNKrMUYbo0B6GubiAAvJ479yrV7Mi2fiAsR7jfCHZq7UHCXT8Wbr4s9nQ/jgik1oxDIUKWOAni
	5tsTZmdTaTtZwCiowYpv4grzhJuIJoMRhrq2pKCKkmqeMk/n2/nZvec77kEpNVcuMqjjatViBZAT8
	i7mfiMPifX2iRN0azuIatVl4sQgAZuk4fv3+qNfM5BVThHFiOoZ9OwASt2Ju4OWqQqI6SUR1k6L0B
	k4PE5tJ0mz7628AYDxrrm4THBZvgUwS63VecUxBdCYY0dlDzvMfnP97WjXWPp6BE5KnjOP4qApULK
	imM0xdttLURW28Pgyg==;
Received: from dg by mx.treblig.org with local (Exim 4.98.2)
	(envelope-from <dg@treblig.org>)
	id 1wZTMO-000000082VY-2zNa;
	Tue, 16 Jun 2026 12:57:44 +0000
Date: Tue, 16 Jun 2026 12:57:44 +0000
From: "Dr. David Alan Gilbert" <dave@treblig.org>
To: Keith Busch <kbusch@kernel.org>
Cc: Vjaceslavs Klimovs <vklimovs@gmail.com>,
	Thorsten Leemhuis <regressions@leemhuis.info>, trnka@scm.com,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	Linux kernel regressions list <regressions@lists.linux.dev>
Subject: Re: Repeatable, raid1+O_DIRECT, hang/warn
Message-ID: <ajFISH9bvyWjLOM6@gallifrey>
References: <ai7rnH20IYeSmY8s@gallifrey>
 <165d3195-c81d-4760-870b-23a9a3b3b72c@leemhuis.info>
 <ai_1LYtofh1fwD-N@gallifrey>
 <CAC_j7i0eDccVWzPeRafM50mZEOFHPz2cwd=RZqqx6TK2EVRFvw@mail.gmail.com>
 <ajCTaUaACV9eNmWo@kbusch-mbp>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <ajCTaUaACV9eNmWo@kbusch-mbp>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.12.88+deb13-amd64 (x86_64)
X-Uptime: 12:47:27 up 31 days, 16:00,  2 users,  load average: 0.00, 0.02,
 0.00
User-Agent: Mutt/2.2.13 (2024-03-09)

* Keith Busch (kbusch@kernel.org) wrote:
> On Mon, Jun 15, 2026 at 04:16:12PM -0700, Vjaceslavs Klimovs wrote:
> > Your trace looks like what the two earlier reports hit: a read reaching
> > a leaf device with sectors > 0 but phys_seg 0 (an empty bio). One aside
> > that may help read the trace: blk_io_trace.error is a __u16, so the
> > bracketed values on your C lines are errnos as u16 (65514 = -EINVAL,
> > 65531 = -EIO).
> > 
> > The WARN itself is new, the bad bio isn't. bio_add_page() only started
> > rejecting len == 0 in 643893647cac ("block: reject zero length in
> > bio_add_page()", v7.1-rc1); on 7.0.8 the same empty bio tripped
> > scsi_alloc_sgtables()'s !nr_segs instead, which matches what you saw.
> > That fits your "not a recent regression": the condition is older, v7.1
> > just made it loud.
> > 
> > For Tomas's and my reports (QEMU O_DIRECT to the LV block device) the
> > origin looks like 5ff3f74e145a ("block: simplify direct io validity
> > check", v6.18): blkdev_dio_invalid() now checks only aggregate
> > ki_pos | count alignment and dropped the per-segment
> > bdev_iter_is_aligned() walk, so a degenerate or misaligned O_DIRECT no
> > longer gets -EINVAL at the fops boundary. But your reproducer reads a
> > file, which goes through the filesystem O_DIRECT path and never calls
> > blkdev_dio_invalid(), and still makes the empty bio. So it isn't only
> > that one entry point.
> > 
> > dm-mirror then hangs because Keith's f7b24c7b41f2 only covers md
> > raid1/raid10; legacy dm-mirror (dm-raid1.c) has no equivalent and
> > rebuilds the empty read onto the other leg. Note the leg's status isn't
> > even consistent (your SATA path returns BLK_STS_IOERR, not
> > BLK_STS_INVAL), so copying that status check into dm-mirror probably
> > wouldn't catch every case.
> > 
> > For what it's worth, that points me toward rejecting the empty or
> > misaligned bio once, at submission, with -EINVAL, rather than teaching
> > each consumer to tolerate it. But you'll know the tradeoffs far better
> > than I do.
> > 
> > I have a small QEMU + LVM raid1/mirror setup that reproduces the
> > block-device variant and bisects to 5ff3f74e. Happy to run your file
> > reproducer with some instrumentation at the dm-mirror read entry
> > (bi_size vs bio_sectors vs bvec lengths) to see whether the bio is
> > already empty on arrival or built that way on the retry, and to test
> > any patch.
> 
> Thanks for following up here. I didn't initially see your follow-up
> until Thorsten linked it. I apologize for missing that, this feature is
> important so I don't want to see anything regress for it.
> 
> There is a known bug fix I think future tests should include:
> 
>   https://lore.kernel.org/linux-block/20260612223205.465913-1-kbusch@meta.com/

> This likely isn't the fix you're looking for, but including it rules out
> conditions that are not important here.
> 
> After that, can we try this suggestion and see if the hang goes away?
> 
>   https://lore.kernel.org/linux-block/ajBb8tK-0aJBpIgF@kbusch-mbp/

With just that one in, the machine survives - thanks!

It does give:

[  505.208354] device-mapper: raid1: Mirror read failed from 252:24. Trying alternative device.
[  505.239376] device-mapper: raid1: All sides of mirror have failed.
[  505.239389] device-mapper: raid1: Read failure on mirror device 252:25.  Failing I/O.
[  505.239394] device-mapper: raid1: Mirror read failed.

Although as far as I can tell the RAID hasn't errored and is still in sync.

If I turn the test case into a write (just s/pread/pwrite/ ) - the machine
still survives but then it does lose raid sync, and the raid resync
seems to stick until I do a 'lvchange --refresh main/lvol0'
which recovers after having spat out a:

[  865.319527] Buffer I/O error on dev dm-26, logical block 262128, async page read

> I expect the original test case to still return an error (and I think it
> was designed to), but it shouldn't produce the warn or bug splats with a
> stuck uninterruptable task.

It's not clear to me if it was designed to fail or not; I've not had
a chance to rerun the original qemu block tests yet, and I don't know
if old kernels succesfully used O_DIRECT in this case.

It still feels that my pwrite case above shouldn't cause a raid de-sync
(especially since a normal user can do it).

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
