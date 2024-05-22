Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8E7182DB
	for <dm-devel@lists.linux.dev>; Wed, 22 May 2024 21:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716411957; cv=none; b=MB0Ymae70u82y40HXlpteEVsQmt2eCBW3EUAybDgesQnvJB0eYCGutdj6jANel7Baq72E/oZl1ZZaHSAVlLP/Q1DcY/cHlr+jWFd2hUCNQxUDgGap59RhKOLuYf4pwf8EnmqHC6T/DZ6+D87mRpMuqo0eqdLH7b+etBP7jx2hBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716411957; c=relaxed/simple;
	bh=UuN+TNfyvWOM2QErKz9AgxlRgNIUw9Xz6smYUuJ2Xwg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=VFVy6BOWzKdw/YUpGC+N8yRTJkaYFUN23HQMl1I/+JgVq7MX9mMM/1nWYqFBeK7szjtRiCW6WmnsspPqZC3pWbmkahVGlL+kbIH1cFEbs3VSeDrB5IM0RAiGcZ+Z25RWZl+piLfvETgHNwslW2I6t8d3p+HKwiZGKhKPgl1+6tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FHgEbxuE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FHgEbxuE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716411955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fbWdfGX3ZmKUSYN5RjcaKLdCuKumShJmeeAR8Ld2BSY=;
	b=FHgEbxuESY+Mz7vKFLbj6z+JdBdp7wNx+zIQMYf/MqtxTD1syPitfBGGPYZ6o/MkKnIgwb
	TaxxQDDgYJoejT0YotngMZX/GwRIr1l8YEP9vf5CjkU8Z3yoqlPH480c0iw04MgniZfgLT
	yQeYdNlT/OnnU7qFvO4+gPODKSiqjxU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-132-42JCeEzPO8mAr3Hb6u2fxg-1; Wed, 22 May 2024 17:05:53 -0400
X-MC-Unique: 42JCeEzPO8mAr3Hb6u2fxg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 281BE185A780;
	Wed, 22 May 2024 21:05:53 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 18E46100046D;
	Wed, 22 May 2024 21:05:53 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 0074B30C1C33; Wed, 22 May 2024 21:05:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id EFA3F3FB52;
	Wed, 22 May 2024 23:05:52 +0200 (CEST)
Date: Wed, 22 May 2024 23:05:52 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
cc: Benjamin Marzinski <bmarzins@redhat.com>, Yang Yang <yang.yang@vivo.com>, 
    Alasdair Kergon <agk@redhat.com>, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org
Subject: Re: dm: optimize flushes
In-Reply-To: <Zk4Y6DMgK71UuoKd@kernel.org>
Message-ID: <9a0db0-4415-2013-6132-f1788b76a4ee@redhat.com>
References: <20240514090445.2847-1-yang.yang@vivo.com> <20240514090445.2847-4-yang.yang@vivo.com> <ZkTXzG1yrPmW64Z6@redhat.com> <60bd4b9-8edd-7e22-ce8b-e5d0e43da195@redhat.com> <90f4beb-2e15-3f9-4bc2-0d13872e8ea@redhat.com> <Zk4Y6DMgK71UuoKd@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3



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

What about "flush_bypass" or "flush_bypasses_map"?

> > Index: linux-2.6/drivers/md/dm-table.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/md/dm-table.c	2024-05-15 16:56:49.000000000 +0200
> > +++ linux-2.6/drivers/md/dm-table.c	2024-05-15 16:56:49.000000000 +0200
> > @@ -160,6 +160,7 @@ int dm_table_create(struct dm_table **re
> >  	t->type = DM_TYPE_NONE;
> >  	t->mode = mode;
> >  	t->md = md;
> > +	t->flush_pass_around = 1;
> >  	*result = t;
> >  	return 0;
> >  }
> 
> Should be: t->flush_pass_around = true;

Yes.

> > +
> > +	/*
> > +	 * Set if the target supports flush optimization
> > +	 */
> > +	bool flush_pass_around:1;
> >  };
> 
> How does a developer _know_ if a target can set this flag?  Please
> elaborate on the requirements in this code comment.

What about:

"The target supports flush optimization. When all the targets in the table 
support flush optimization, flushes will not use the "map" method and they 
will be sent directly to all the devices in the table. This optimization 
reduces the number of flushes that are being sent if multiple targets use 
the same underlying device."

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

They can't be dropped.

When performing the flush bypass optimization, the dm core creates a 
dm_target_io structure that isn't associated with any specific target. So, 
the pointer "tio->ti" is NULL.

I could set "tio->ti" to any target, but I think it's better to set it to 
NULL, just to mark that there is no target association.

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
                                              ^^^^
Here we set tio->ti to NULL.

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

I mean that flushes bypass the map method.

> Also, you're issuing a flush to _all_ devices in a table. Not just
> the data devices.  .iterate_devices returns only the data devices.
> If/when there is a need to extend this feature to targets that have
> metadata devices (e.g. dm-thin, cache, etc): would it make sense to
> filter out non-data devices (by stepping through each target in the
> table and using iterate_devices)?

This optimization only makes sense if there are multiple targets in the 
table. dm-thin, dm-cache, dm-raid is usually the only target in the table, 
so the optimization doesn't make sense for them. Trying to support the 
"flush bypass" optimization for them would bloat the code without reducing 
the number of flush requests at all.

> Mike

Mikulas

