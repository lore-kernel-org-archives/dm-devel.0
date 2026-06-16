Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E713195FC;
	Tue, 16 Jun 2026 14:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781618696; cv=none; b=Zy2R2z8VjTQIp2jt5Q7SYN80cxzo6TiYapgSLLovcj+pYnxnj53k3145sh/mxdJAjPQ13m82INGHEhqQSFhulNLcpd0fze04T1npSaQM8ye183gXSbrMovenVDcIH61iJPe/jxSAYjnlbujBNaY5WTF8U1iHmwetFR0NVPgGxnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781618696; c=relaxed/simple;
	bh=+XTM8HComuJp9mJb67vhcrqpaS2S9NvMCqXH7vYR8eI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gfJHp0MJ4XkJzmiKs42ae+erAlJadf2iEGK+JoT0H46FtmdCiX2wd0oWv4OWpLM3g9Xj1nDwmw60TEGCqmyw4iL4kfHmH2LI3/gmI+qlK7OYHaE8eQrviy14zLe3pNV+UF/vIZZGjmyT7uWaCfkcV2KoynssDNLTU8O34QtOexY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=jwArWyVr; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="jwArWyVr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=NrDzEHkU9UH4S6zMhq+Z1fXZcTmNTi2n2kGbaEHw6z8=; b=jwArWyVrukc0iLRZ
	0IdBCNCF4kbizVtJx+sz6D9P9hrRrcdiUMxY+wM3+o3vqXi5dYs+XHa1grUvcoPgECIZM9uPFH8DC
	mpFz7yKQv5O20U3vCc9lPAeXP3dfREI+kDrw6McjU1MWy6kCZIjbDZ6byyLTQibwfi75WHSfhHpPY
	9KeiCV9Z52RhoGTYxLFT6iHSaTruS6O3Vkn6hqoPfdxRtvRsJX4tirUJNuMnB+OuiJYmP1wE+SOty
	AMiWgYxUQmhOweU53n8IIJDYabq7jAldxxoFurc+LHhbxhEfx6eXMZqj7XY1mz0k8KiDGfP3jX1LO
	kRFZegY5/Bkkw64YmQ==;
Received: from dg by mx.treblig.org with local (Exim 4.98.2)
	(envelope-from <dg@treblig.org>)
	id 1wZUPJ-000000083nK-298a;
	Tue, 16 Jun 2026 14:04:49 +0000
Date: Tue, 16 Jun 2026 14:04:49 +0000
From: "Dr. David Alan Gilbert" <dave@treblig.org>
To: Keith Busch <kbusch@kernel.org>, zkabelac@redhat.com
Cc: Vjaceslavs Klimovs <vklimovs@gmail.com>,
	Thorsten Leemhuis <regressions@leemhuis.info>, trnka@scm.com,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	Linux kernel regressions list <regressions@lists.linux.dev>
Subject: Re: Repeatable, raid1+O_DIRECT, hang/warn
Message-ID: <ajFYAeItZkyZ9Imi@gallifrey>
References: <ai7rnH20IYeSmY8s@gallifrey>
 <165d3195-c81d-4760-870b-23a9a3b3b72c@leemhuis.info>
 <ai_1LYtofh1fwD-N@gallifrey>
 <CAC_j7i0eDccVWzPeRafM50mZEOFHPz2cwd=RZqqx6TK2EVRFvw@mail.gmail.com>
 <ajCTaUaACV9eNmWo@kbusch-mbp>
 <ajFISH9bvyWjLOM6@gallifrey>
 <ajFK5NXkxd6jU5zu@gallifrey>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <ajFK5NXkxd6jU5zu@gallifrey>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.12.88+deb13-amd64 (x86_64)
X-Uptime: 14:03:37 up 31 days, 17:16,  2 users,  load average: 0.15, 0.06,
 0.02
User-Agent: Mutt/2.2.13 (2024-03-09)

* Dr. David Alan Gilbert (dave@treblig.org) wrote:
> * Dr. David Alan Gilbert (dave@treblig.org) wrote:
> > * Keith Busch (kbusch@kernel.org) wrote:
> > > On Mon, Jun 15, 2026 at 04:16:12PM -0700, Vjaceslavs Klimovs wrote:
> > > > Your trace looks like what the two earlier reports hit: a read reaching
> > > > a leaf device with sectors > 0 but phys_seg 0 (an empty bio). One aside
> > > > that may help read the trace: blk_io_trace.error is a __u16, so the
> > > > bracketed values on your C lines are errnos as u16 (65514 = -EINVAL,
> > > > 65531 = -EIO).
> > > > 
> > > > The WARN itself is new, the bad bio isn't. bio_add_page() only started
> > > > rejecting len == 0 in 643893647cac ("block: reject zero length in
> > > > bio_add_page()", v7.1-rc1); on 7.0.8 the same empty bio tripped
> > > > scsi_alloc_sgtables()'s !nr_segs instead, which matches what you saw.
> > > > That fits your "not a recent regression": the condition is older, v7.1
> > > > just made it loud.
> > > > 
> > > > For Tomas's and my reports (QEMU O_DIRECT to the LV block device) the
> > > > origin looks like 5ff3f74e145a ("block: simplify direct io validity
> > > > check", v6.18): blkdev_dio_invalid() now checks only aggregate
> > > > ki_pos | count alignment and dropped the per-segment
> > > > bdev_iter_is_aligned() walk, so a degenerate or misaligned O_DIRECT no
> > > > longer gets -EINVAL at the fops boundary. But your reproducer reads a
> > > > file, which goes through the filesystem O_DIRECT path and never calls
> > > > blkdev_dio_invalid(), and still makes the empty bio. So it isn't only
> > > > that one entry point.
> > > > 
> > > > dm-mirror then hangs because Keith's f7b24c7b41f2 only covers md
> > > > raid1/raid10; legacy dm-mirror (dm-raid1.c) has no equivalent and
> > > > rebuilds the empty read onto the other leg. Note the leg's status isn't
> > > > even consistent (your SATA path returns BLK_STS_IOERR, not
> > > > BLK_STS_INVAL), so copying that status check into dm-mirror probably
> > > > wouldn't catch every case.
> > > > 
> > > > For what it's worth, that points me toward rejecting the empty or
> > > > misaligned bio once, at submission, with -EINVAL, rather than teaching
> > > > each consumer to tolerate it. But you'll know the tradeoffs far better
> > > > than I do.
> > > > 
> > > > I have a small QEMU + LVM raid1/mirror setup that reproduces the
> > > > block-device variant and bisects to 5ff3f74e. Happy to run your file
> > > > reproducer with some instrumentation at the dm-mirror read entry
> > > > (bi_size vs bio_sectors vs bvec lengths) to see whether the bio is
> > > > already empty on arrival or built that way on the retry, and to test
> > > > any patch.
> > > 
> > > Thanks for following up here. I didn't initially see your follow-up
> > > until Thorsten linked it. I apologize for missing that, this feature is
> > > important so I don't want to see anything regress for it.
> > > 
> > > There is a known bug fix I think future tests should include:
> > > 
> > >   https://lore.kernel.org/linux-block/20260612223205.465913-1-kbusch@meta.com/
> > 
> > > This likely isn't the fix you're looking for, but including it rules out
> > > conditions that are not important here.
> > > 
> > > After that, can we try this suggestion and see if the hang goes away?
> > > 
> > >   https://lore.kernel.org/linux-block/ajBb8tK-0aJBpIgF@kbusch-mbp/
> > 
> > With just that one in, the machine survives - thanks!
> > 
> > It does give:
> > 
> > [  505.208354] device-mapper: raid1: Mirror read failed from 252:24. Trying alternative device.
> > [  505.239376] device-mapper: raid1: All sides of mirror have failed.
> > [  505.239389] device-mapper: raid1: Read failure on mirror device 252:25.  Failing I/O.
> > [  505.239394] device-mapper: raid1: Mirror read failed.
> > 
> > Although as far as I can tell the RAID hasn't errored and is still in sync.
> > 
> > If I turn the test case into a write (just s/pread/pwrite/ ) - the machine
> > still survives but then it does lose raid sync, and the raid resync
> > seems to stick until I do a 'lvchange --refresh main/lvol0'
> > which recovers after having spat out a:
> > 
> > [  865.319527] Buffer I/O error on dev dm-26, logical block 262128, async page read
> > 
> > > I expect the original test case to still return an error (and I think it
> > > was designed to), but it shouldn't produce the warn or bug splats with a
> > > stuck uninterruptable task.
> > 
> > It's not clear to me if it was designed to fail or not; I've not had
> > a chance to rerun the original qemu block tests yet, and I don't know
> > if old kernels succesfully used O_DIRECT in this case.
> > 
> > It still feels that my pwrite case above shouldn't cause a raid de-sync
> > (especially since a normal user can do it).
> 
> Just to follow up on that;  if I use the modern lvm mode 
> ( lvcreate  -m 1 -L 1G main /dev/sda2 /dev/sdb2 ) rather than
> the old mirror with the same patch, then:
> 
>   a) I get no log errors with either read or write
>   b) read still gives EIO
>   c) write apparently succeeds ?!

One more confirmation; running qemu's 'make check' during build passes
with no log errors (whether it skipped any tests due to it's detection
code I don't know).

Dave

> Dave
> 
> > Dave
> > -- 
> >  -----Open up your eyes, open up your mind, open up your code -------   
> > / Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
> > \        dave @ treblig.org |                               | In Hex /
> >  \ _________________________|_____ http://www.treblig.org   |_______/
> -- 
>  -----Open up your eyes, open up your mind, open up your code -------   
> / Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
> \        dave @ treblig.org |                               | In Hex /
>  \ _________________________|_____ http://www.treblig.org   |_______/
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
