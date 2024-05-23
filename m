Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB3676F17
	for <dm-devel@lists.linux.dev>; Thu, 23 May 2024 22:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.205.220.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716502634; cv=none; b=pDhyBghmdnTtkKWDS22FauW9PSm39g4+RlOtUHJ8vA//DQdSIGJsWwEavWaekBIpQFx3nRnGbvs0tirwO8UA/0ErNqoA8+BbQMLra/bljxdFXQZMV7RrAf3U3KLCexoz81ZaCbNOX5Tu9abZV1Hu9fir0JLMnwVG3akD8YKsI38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716502634; c=relaxed/simple;
	bh=WKSeStaX/TFdgri9jtr2/9pLUQwqpsJ7Cj+v+tXlRwo=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Clam9vgUTNsKqQlLaoYwD9nALl1/kvSPqBw9ZdWiTTouAC7Jk01l85mavS7kxqFkhLihX3apR+jIUMaSCzNj/otrhaoFwBXF2KaHs3rPoFu3tE8bcPdi7wSwNEf3iSloddAsJ/y6KA86EvRAFd/LkygZNKucKRTSfcJphglTrug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net; spf=none smtp.mailfrom=lists.ewheeler.net; arc=none smtp.client-ip=173.205.220.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=lists.ewheeler.net
Received: from localhost (localhost [127.0.0.1])
	by mx.ewheeler.net (Postfix) with ESMTP id 7E16481;
	Thu, 23 May 2024 15:17:12 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
	by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id v-ScayE9AXXK; Thu, 23 May 2024 15:17:10 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx.ewheeler.net (Postfix) with ESMTPSA id AC0BE40;
	Thu, 23 May 2024 15:17:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net AC0BE40
Date: Thu, 23 May 2024 15:17:10 -0700 (PDT)
From: Eric Wheeler <dm-devel@lists.ewheeler.net>
To: Mike Snitzer <snitzer@kernel.org>
cc: Mikulas Patocka <mpatocka@redhat.com>, 
    Benjamin Marzinski <bmarzins@redhat.com>, Yang Yang <yang.yang@vivo.com>, 
    Alasdair Kergon <agk@redhat.com>, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org
Subject: Re: dm: optimize flushes
In-Reply-To: <Zk4Y6DMgK71UuoKd@kernel.org>
Message-ID: <92786ecf-aa40-5e7-47c3-82614dffca78@ewheeler.net>
References: <20240514090445.2847-1-yang.yang@vivo.com> <20240514090445.2847-4-yang.yang@vivo.com> <ZkTXzG1yrPmW64Z6@redhat.com> <60bd4b9-8edd-7e22-ce8b-e5d0e43da195@redhat.com> <90f4beb-2e15-3f9-4bc2-0d13872e8ea@redhat.com> <Zk4Y6DMgK71UuoKd@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Wed, 22 May 2024, Mike Snitzer wrote:
> On Thu, May 16, 2024 at 10:49:55PM +0200, Mikulas Patocka wrote:
> > Device mapper sends flush bios to all the targets and the targets send it
> > to the underlying device. That may be inefficient, for example if a table
> > contains 10 linear targets pointing to the same physical device, then
> > device mapper would send 10 flush bios to that device - despite the fact
> > that only one bio would be sufficient.
> > 
> > This commit optimizes the flush behavior. It introduces a per-target
> > variable flush_pass_around - it is set when the target supports flush
> > optimization - currently, the dm-linear and dm-stripe targets support it.
> > When all the targets in a table have flush_pass_around, flush_pass_around
> > on the table is set. __send_empty_flush tests if the table has
> > flush_pass_around - and if it has, no flush bios are sent to the targets
> > and the list dm_table->devices is iterated and the flush bios are sent to
> > each member of the list.
> 
> What does "pass around" mean?  Seems like an awkward name for this.
> (Naming can be hard, I don't have better suggestions at the moment.)

just playing with naming ideas from other disciplines in case you likes 
one of these concepts better than "pass around".  I'm not attached any of 
these, this is just for making conversation so the flag can be easily 
understood:

	- flush_can_scatter (as in scatter/gather)
	- flush_can_distribute
	- flush_can_spread
	- flush_deduplicate
	
...

> > Index: linux-2.6/include/linux/device-mapper.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/device-mapper.h	2024-05-15 16:56:49.000000000 +0200
> > +++ linux-2.6/include/linux/device-mapper.h	2024-05-15 16:56:49.000000000 +0200
> > @@ -397,6 +397,11 @@ struct dm_target {
> >  	 * bio_set_dev(). NOTE: ideally a target should _not_ need this.
> >  	 */
> >  	bool needs_bio_set_dev:1;
> > +
> > +	/*
> > +	 * Set if the target supports flush optimization
> > +	 */
> > +	bool flush_pass_around:1;
> >  };
> 
> How does a developer _know_ if a target can set this flag?  Please
> elaborate on the requirements in this code comment.

Relatedly,

To what extent can this be set automatically? For example, if you have a 
bunch of non-DM (eg, SCSI) disks under a device mapper target, then it 
seems reasonable that they would "support" this feature in the identity 
sense: they can take flush and it will (should) not be spread to other 
devices in the DM stack, so the device mapper targets being instantiated 
in such a case would enable this flag.  Thus, a new target that only has 
non-DM devices can (probably?) default enabled; maybe there are counter 
examples here.

Another consideration is for targets (eg, dm-thinpool) which have multiple 
lower-level block devices on the same table definition line, often a data 
and metadata volume. By contrast, linear tables may have multiple backing 
devices in separate target table lines.  This may be further complicated 
by the fact that a device mapper target can be composed of multiple 
disparate targets as separate table lines, each of which may have a 
different number of backing devices for their own definition.

Perhaps your design already covers these edge cases, so I am only 
mentioning this in case it may prompt ideas for other edge cases 
to review.


--
Eric Wheeler



> 
> >  
> >  void *dm_per_bio_data(struct bio *bio, size_t data_size);
> > Index: linux-2.6/drivers/md/dm.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/md/dm.c	2024-05-15 16:56:49.000000000 +0200
> > +++ linux-2.6/drivers/md/dm.c	2024-05-16 20:06:32.000000000 +0200
> > @@ -645,7 +645,7 @@ static struct bio *alloc_tio(struct clon
> >  
> >  	/* Set default bdev, but target must bio_set_dev() before issuing IO */
> >  	clone->bi_bdev = md->disk->part0;
> > -	if (unlikely(ti->needs_bio_set_dev))
> > +	if (likely(ti != NULL) && unlikely(ti->needs_bio_set_dev))
> >  		bio_set_dev(clone, md->disk->part0);
> >  
> >  	if (len) {
> > @@ -1107,7 +1107,7 @@ static void clone_endio(struct bio *bio)
> >  	blk_status_t error = bio->bi_status;
> >  	struct dm_target_io *tio = clone_to_tio(bio);
> >  	struct dm_target *ti = tio->ti;
> > -	dm_endio_fn endio = ti->type->end_io;
> > +	dm_endio_fn endio = likely(ti != NULL) ? ti->type->end_io : NULL;
> >  	struct dm_io *io = tio->io;
> >  	struct mapped_device *md = io->md;
> >  
> > @@ -1154,7 +1154,7 @@ static void clone_endio(struct bio *bio)
> >  	}
> >  
> >  	if (static_branch_unlikely(&swap_bios_enabled) &&
> > -	    unlikely(swap_bios_limit(ti, bio)))
> > +	    likely(ti != NULL) && unlikely(swap_bios_limit(ti, bio)))
> >  		up(&md->swap_bios_semaphore);
> >  
> >  	free_tio(bio);
> 
> What is it about this commit that makes it important to verify ti
> isn't NULL in the above 3 hunks?
> 
> Should these NULL checks be factored out as a separate fix?
> 
> Or can these hunks be dropped?
> 
> > @@ -1566,17 +1566,36 @@ static void __send_empty_flush(struct cl
> >  	ci->sector_count = 0;
> >  	ci->io->tio.clone.bi_iter.bi_size = 0;
> >  
> > -	for (unsigned int i = 0; i < t->num_targets; i++) {
> > -		unsigned int bios;
> > -		struct dm_target *ti = dm_table_get_target(t, i);
> > -
> > -		if (unlikely(ti->num_flush_bios == 0))
> > -			continue;
> > -
> > -		atomic_add(ti->num_flush_bios, &ci->io->io_count);
> > -		bios = __send_duplicate_bios(ci, ti, ti->num_flush_bios,
> > -					     NULL, GFP_NOWAIT);
> > -		atomic_sub(ti->num_flush_bios - bios, &ci->io->io_count);
> > +	if (!t->flush_pass_around) {
> > +		for (unsigned int i = 0; i < t->num_targets; i++) {
> > +			unsigned int bios;
> > +			struct dm_target *ti = dm_table_get_target(t, i);
> > +
> > +			if (unlikely(ti->num_flush_bios == 0))
> > +				continue;
> > +
> > +			atomic_add(ti->num_flush_bios, &ci->io->io_count);
> > +			bios = __send_duplicate_bios(ci, ti, ti->num_flush_bios,
> > +						     NULL, GFP_NOWAIT);
> > +			atomic_sub(ti->num_flush_bios - bios, &ci->io->io_count);
> > +		}
> > +	} else {
> > +		/*
> > +		 * Note that there's no need to grab t->devices_lock here
> > +		 * because the targets that support flush pass-around don't
> > +		 * modify the list of devices.
> > +		 */
> > +		struct list_head *devices = dm_table_get_devices(t);
> > +		unsigned int len = 0;
> > +		struct dm_dev_internal *dd;
> > +		list_for_each_entry(dd, devices, list) {
> > +			struct bio *clone;
> > +			clone = alloc_tio(ci, NULL, 0, &len, GFP_NOIO);
> > +			atomic_add(1, &ci->io->io_count);
> > +			bio_set_dev(clone, dd->dm_dev->bdev);
> > +			clone->bi_end_io = clone_endio;
> > +			dm_submit_bio_remap(clone, NULL);
> > +		}
> >  	}
> >  
> >  	/*
> > 
> > 
> 
> Still missing what "pass-around" is meant to convey given that you
> aren't passing around the same flush... you're cloning a new flush and
> issuing one per device.  Probably worth explaining that's what you
> mean by "flush_pass_around" (both in commit header and elaborate in
> code)?
> 
> Also, you're issuing a flush to _all_ devices in a table. Not just
> the data devices.  .iterate_devices returns only the data devices.
> If/when there is a need to extend this feature to targets that have
> metadata devices (e.g. dm-thin, cache, etc): would it make sense to
> filter out non-data devices (by stepping through each target in the
> table and using iterate_devices)?
> 
> Mike
> 
> 
