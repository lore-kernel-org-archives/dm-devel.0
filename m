Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C61B18DB24
	for <dm-devel@lists.linux.dev>; Mon, 10 Mar 2025 17:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628249; cv=none; b=OAMqD+xeo2sNECZ5qoYcWossnmtcHtpkQzfrigE9X8zd4wimz/wC8xX9zzXO0QHB78QozMyfvCGfjIQYWbZXzuSsF+p/+mMRvgZkvCMWXAE8e4b9C00aqERaINTiBLwoDKQL3ZDtpCq8ob6m4QOOjPGIaCK4cJIamYC9wUNzyU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628249; c=relaxed/simple;
	bh=GH8/rH1SI2j1ceiXTzakUYJwaQ2lj4sVPGRISfCSt0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YiUpSMyINL63ph1WrdHEirQDukeChDMMTbgPzEkLSsZr8q6HB0EfE+gxIuru5QAzE+qHLzvnejwY0oXBXUJyYZYwLy6INrB6KPrzwDcMYqev2HiaDzYvPa+MPC1UzsHVoAHKXc077aO6t2roTGQhgOUN1PV5X5ywJ8aggSIoZgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pu9SELzS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pu9SELzS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741628246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zZwW1Pyf314nkOcDOOWAdxiKKYBtxRCDqYI9mkDDoks=;
	b=Pu9SELzSDnBrTJuG3tyTpjhRycYVMi/pya1wf20i92oHgxw5Iz4LPnI92v2+YDnHwXAs50
	67IP0RZd5uD6c930Odtf6u9FO5jQbbZnOG0TCnErIHQJMvExXa7/cWOVC/ccYzGlui5vGm
	CBYm5wL2HPRcP2Rzxni2aznykrLWMOA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-617-QJlpmnvSPOmzTsfWKeiuEw-1; Mon,
 10 Mar 2025 13:37:22 -0400
X-MC-Unique: QJlpmnvSPOmzTsfWKeiuEw-1
X-Mimecast-MFC-AGG-ID: QJlpmnvSPOmzTsfWKeiuEw_1741628241
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 007C31955BC1;
	Mon, 10 Mar 2025 17:37:21 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B14761956096;
	Mon, 10 Mar 2025 17:37:20 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 52AHbJXn480743
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 10 Mar 2025 13:37:19 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 52AHbJ6O480742;
	Mon, 10 Mar 2025 13:37:19 -0400
Date: Mon, 10 Mar 2025 13:37:19 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/7] dm: handle failures in dm_table_set_restrictions
Message-ID: <Z88jTxQqoLitl4ee@redhat.com>
References: <20250309222904.449803-1-bmarzins@redhat.com>
 <20250309222904.449803-4-bmarzins@redhat.com>
 <9b5ff861-964d-472c-9267-5e5b10186ed3@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b5ff861-964d-472c-9267-5e5b10186ed3@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Mon, Mar 10, 2025 at 08:25:39AM +0900, Damien Le Moal wrote:
> On 3/10/25 07:28, Benjamin Marzinski wrote:
> > If dm_table_set_restrictions() fails while swapping tables,
> > device-mapper will continue using the previous table. It must be sure to
> > leave the mapped_device in it's previous state on failure.  Otherwise
> > device-mapper could end up using the old table with settings from the
> > unused table.
> > 
> > Do not update the mapped device in dm_set_zones_restrictions(). Wait
> > till after dm_table_set_restrictions() is sure to succeed to update the
> > md zoned settings. Do the same with the dax settings, and if
> > dm_revalidate_zones() fails, restore the original queue limits.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  drivers/md/dm-table.c | 24 ++++++++++++++++--------
> >  drivers/md/dm-zone.c  | 26 ++++++++++++++++++--------
> >  drivers/md/dm.h       |  1 +
> >  3 files changed, 35 insertions(+), 16 deletions(-)
> > 
> > diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> > index 0ef5203387b2..4003e84af11d 100644
> > --- a/drivers/md/dm-table.c
> > +++ b/drivers/md/dm-table.c
> > @@ -1836,6 +1836,7 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
> >  			      struct queue_limits *limits)
> >  {
> >  	int r;
> > +	struct queue_limits old_limits;
> >  
> >  	if (!dm_table_supports_nowait(t))
> >  		limits->features &= ~BLK_FEAT_NOWAIT;
> > @@ -1862,16 +1863,11 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
> >  	if (dm_table_supports_flush(t))
> >  		limits->features |= BLK_FEAT_WRITE_CACHE | BLK_FEAT_FUA;
> >  
> > -	if (dm_table_supports_dax(t, device_not_dax_capable)) {
> > +	if (dm_table_supports_dax(t, device_not_dax_capable))
> >  		limits->features |= BLK_FEAT_DAX;
> > -		if (dm_table_supports_dax(t, device_not_dax_synchronous_capable))
> > -			set_dax_synchronous(t->md->dax_dev);
> > -	} else
> > +	else
> >  		limits->features &= ~BLK_FEAT_DAX;
> >  
> > -	if (dm_table_any_dev_attr(t, device_dax_write_cache_enabled, NULL))
> > -		dax_write_cache(t->md->dax_dev, true);
> > -
> >  	/* For a zoned table, setup the zone related queue attributes. */
> >  	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
> >  	    (limits->features & BLK_FEAT_ZONED)) {
> > @@ -1883,6 +1879,7 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
> >  	if (dm_table_supports_atomic_writes(t))
> >  		limits->features |= BLK_FEAT_ATOMIC_WRITES;
> >  
> > +	old_limits = q->limits;
> 
> I am not sure this is safe to do like this since the user may be simultaneously
> changing attributes, which would result in the old_limits struct being in an
> inconsistent state. So shouldn't we hold q->limits_lock here ? We probably want
> a queue_limits_get() helper for that though.
> 
> >  	r = queue_limits_set(q, limits);
> 
> ...Or, we could modify queue_limits_set() to also return the old limit struct
> under the q limits_lock. That maybe easier.

If we disallow switching between zoned devices then this is unnecssary.
OTherwise you're right. We do want to make sure that we don't grep the
limits while something is updating the limits.

Unfortunately, thinking about this just made me realize a different
problem, that has nothing to do with this patchset. bio-based devices
can't handle freezing the queue while there are plugged zone write bios.
So, for instance, if you do something like:

# modprobe scsi_debug dev_size_mb=512 zbc=managed zone_size_mb=128 zone_nr_conv=0 delay=20
# dmsetup create test --table "0 1048576 crypt aes-cbc-essiv:sha256 deadbeefdeadbeefdeadbeefdeadbeef 0 /dev/sda 0"
# dd if=/dev/zero of=/dev/mapper/test bs=1M count=128 &
# echo 0 > /sys/block/dm-1/queue/iostats

you hang.

*** FREEZING THE QUEUE WHILE UPDATING THE LIMIT ***
root@fedora-test:~# cat /proc/1344/stack 
[<0>] blk_mq_freeze_queue_wait+0x9f/0xd0
[<0>] queue_limits_commit_update_frozen+0x38/0x60
[<0>] queue_attr_store+0xc6/0x1b0
[<0>] kernfs_fop_write_iter+0x13b/0x1f0
[<0>] vfs_write+0x28d/0x450
[<0>] ksys_write+0x6c/0xe0
[<0>] do_syscall_64+0x82/0x160
[<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e

**** WRITING OUT THE PLUGGED BIOS [kworker/0:1H+dm-1_zwplugs] ****
root@fedora-test:~# cat /proc/341/stack
[<0>] __bio_queue_enter+0x13c/0x270
[<0>] __submit_bio+0xf9/0x280
[<0>] submit_bio_noacct_nocheck+0x197/0x3e0
[<0>] blk_zone_wplug_bio_work+0x1ad/0x1f0
[<0>] process_one_work+0x176/0x330
[<0>] worker_thread+0x252/0x390
[<0>] kthread+0xec/0x230
[<0>] ret_from_fork+0x31/0x50
[<0>] ret_from_fork_asm+0x1a/0x30

Changing the iostats limit could be swapped with anything that freezes
the queue.

-Ben

> 
> >  	if (r)
> >  		return r;
> > @@ -1894,10 +1891,21 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
> >  	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
> >  	    (limits->features & BLK_FEAT_ZONED)) {
> >  		r = dm_revalidate_zones(t, q);
> > -		if (r)
> > +		if (r) {
> > +			queue_limits_set(q, &old_limits);
> >  			return r;
> > +		}
> >  	}
> >  
> > +	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED))
> > +		dm_finalize_zone_settings(t, limits);
> > +
> > +	if (dm_table_supports_dax(t, device_not_dax_synchronous_capable))
> > +		set_dax_synchronous(t->md->dax_dev);
> > +
> > +	if (dm_table_any_dev_attr(t, device_dax_write_cache_enabled, NULL))
> > +		dax_write_cache(t->md->dax_dev, true);
> > +
> >  	dm_update_crypto_profile(q, t);
> >  	return 0;
> >  }
> > diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> > index 20edd3fabbab..681058feb63b 100644
> > --- a/drivers/md/dm-zone.c
> > +++ b/drivers/md/dm-zone.c
> > @@ -340,12 +340,8 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
> >  	 * mapped device queue as needing zone append emulation.
> >  	 */
> >  	WARN_ON_ONCE(queue_is_mq(q));
> > -	if (dm_table_supports_zone_append(t)) {
> > -		clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
> > -	} else {
> > -		set_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
> > +	if (!dm_table_supports_zone_append(t))
> >  		lim->max_hw_zone_append_sectors = 0;
> > -	}
> >  
> >  	/*
> >  	 * Determine the max open and max active zone limits for the mapped
> > @@ -383,9 +379,6 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
> >  		lim->zone_write_granularity = 0;
> >  		lim->chunk_sectors = 0;
> >  		lim->features &= ~BLK_FEAT_ZONED;
> > -		clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
> > -		md->nr_zones = 0;
> > -		disk->nr_zones = 0;
> >  		return 0;
> >  	}
> >  
> > @@ -408,6 +401,23 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
> >  	return 0;
> >  }
> >  
> > +void dm_finalize_zone_settings(struct dm_table *t, struct queue_limits *lim)
> > +{
> > +	struct mapped_device *md = t->md;
> > +
> > +	if (lim->features & BLK_FEAT_ZONED) {
> > +		if (dm_table_supports_zone_append(t))
> > +			clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
> > +		else
> > +			set_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
> > +	} else {
> > +		clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
> > +		md->nr_zones = 0;
> > +		md->disk->nr_zones = 0;
> > +	}
> > +}
> > +
> > +
> >  /*
> >   * IO completion callback called from clone_endio().
> >   */
> > diff --git a/drivers/md/dm.h b/drivers/md/dm.h
> > index a0a8ff119815..e5d3a9f46a91 100644
> > --- a/drivers/md/dm.h
> > +++ b/drivers/md/dm.h
> > @@ -102,6 +102,7 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t);
> >  int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
> >  		struct queue_limits *lim);
> >  int dm_revalidate_zones(struct dm_table *t, struct request_queue *q);
> > +void dm_finalize_zone_settings(struct dm_table *t, struct queue_limits *lim);
> >  void dm_zone_endio(struct dm_io *io, struct bio *clone);
> >  #ifdef CONFIG_BLK_DEV_ZONED
> >  int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
> 
> 
> -- 
> Damien Le Moal
> Western Digital Research

