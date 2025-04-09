Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A351C84AA
	for <dm-devel@lists.linux.dev>; Wed,  9 Apr 2025 20:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744229722; cv=none; b=WVKJq1qE3aUHIBesqZg1F4AunVj0+qDZ6nA0upGg0II3pStvrc9W1Qds6UsihzDBMmvkmGUk9WizBVOP3wHgxy2H9mZmkEVt4lPyrxyeVWLmaOyrkaDjD4vobjQMzZ4iWGReh6RIfc0jCs7ejzTNy7+dmiKtwx7iwTb4djoAA4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744229722; c=relaxed/simple;
	bh=kOMskeKaM8e56y4ZV43NgvjkeRM1D8f7ncR3Kc8RYaQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=bfNVq2MYhD1f+YicZVMkWsbEi7NqKQhaZNorO+IgnQnid8IeAuVtAS6qTneL2Xj/Xe5j9w+DkCmUvqfG/lCf2HatZTMX/MxLSyJJOx2wNE1yVUao1B76781woJ5xDzcWLES9mMXiTUF2KowBvggR20yQzR87hQ6BddaYrxrh83o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KMFSkmOx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KMFSkmOx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744229717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ctowqm0GkbKgCDZFGt62bxT7W+pPDqoL7hkbMD3a0bE=;
	b=KMFSkmOxHauTvfdMihaRApzqRdwRrblMKkFTWXEgG+mKL4tPiapW35kc+b0yQu+pKWHcno
	CVSAHxjkk6Lam+xPAQUTDsHGbE3XrCMHsu10f6yZTQAkaG5bsE+cb9QGILN004grV+m/g0
	duzEb0AK7rTBOtCqtQiJTL803OVEdBU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-382-DijC6RxZNxOvGbiLscZFMg-1; Wed,
 09 Apr 2025 16:15:14 -0400
X-MC-Unique: DijC6RxZNxOvGbiLscZFMg-1
X-Mimecast-MFC-AGG-ID: DijC6RxZNxOvGbiLscZFMg_1744229713
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 54197180087D;
	Wed,  9 Apr 2025 20:15:13 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8C7371828A87;
	Wed,  9 Apr 2025 20:15:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 539KFBr94163135
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 9 Apr 2025 16:15:11 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 539KFB464163134;
	Wed, 9 Apr 2025 16:15:11 -0400
Date: Wed, 9 Apr 2025 16:15:11 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@lists.linux.dev, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 5/6] dm: limit swapping tables for devices with zone
 write plugs
Message-ID: <Z_bVTz1rgfmcPt9h@redhat.com>
References: <20250408235159.4128838-1-bmarzins@redhat.com>
 <20250408235159.4128838-6-bmarzins@redhat.com>
 <2fb19069-5e02-4f5a-9f8a-b362e08dffe3@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <2fb19069-5e02-4f5a-9f8a-b362e08dffe3@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pdtJD4N2_Sqz9_29c-7J7yVKigGhPv4QYJThgOoqR5w_1744229713
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 09, 2025 at 03:20:31PM +0900, Damien Le Moal wrote:
> On 4/9/25 8:51 AM, Benjamin Marzinski wrote:
> > dm_revalidate_zones() only allowed new or previously unzoned devices to
> > call blk_revalidate_disk_zones(). If the device was already zoned,
> > disk->nr_zones would always equal md->nr_zones, so dm_revalidate_zones()
> > returned without doing any work. This would make the zoned settings for
> > the device not match the new table. If the device had zone write plug
> > resources, it could run into errors like bdev_zone_is_seq() reading
> > invalid memory because disk->conv_zones_bitmap was the wrong size.
> > 
> > If the device doesn't have any zone write plug resources, calling
> > blk_revalidate_disk_zones() will always correctly update device.  If
> > blk_revalidate_disk_zones() fails, it can still overwrite or clear the
> > current disk->nr_zones value. In this case, DM must restore the previous
> > value of disk->nr_zones, so that the zoned settings will continue to
> > match the previous that it failed back to.
> 
> s/previous/previous value ?
> s/failed/fell ?

Sure.
 
> > 
> > If the device already has zone write plug resources,
> > blk_revalidate_disk_zones() will not correctly update them, if it is
> > called for arbitrary zoned device changes.  Since there is not much need
> > for this ability, the easiest solution is to disallow any table reloads
> > that change the zoned settings, for devices that already have zone plug
> > resources.  Specifically, if a device already has zone plug resources
> > allocated, it can only switch to another zoned table that also emulates
> > zone append.  Also, it cannot change the device size or the zone size. A
> > device can switch to an error target.
> > 
> > Fixes: bb37d77239af2 ("dm: introduce zone append emulation")
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> [...]
> 
> > @@ -1873,11 +1898,17 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
> >  		limits->features &= ~BLK_FEAT_DAX;
> >  
> >  	/* For a zoned table, setup the zone related queue attributes. */
> > -	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
> > -	    (limits->features & BLK_FEAT_ZONED)) {
> > -		r = dm_set_zones_restrictions(t, q, limits);
> > -		if (r)
> > -			return r;
> > +	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED)) {
> > +		if (limits->features & BLK_FEAT_ZONED) {
> > +			r = dm_set_zones_restrictions(t, q, limits);
> > +			if (r)
> > +				return r;
> > +		} else if (dm_has_zone_plugs(t->md)) {
> > +			DMWARN("%s: device has zone write plug resources. "
> > +			       "Cannot switch to non-zoned table.",
> > +			       dm_device_name(t->md));
> > +			return -EINVAL;
> > +		}
> 
> I am confused with this one. We can only have zone write plugs if the device is
> zoned. So it seems that the check for "if (dm_has_zone_plugs(t->md)" should
> really be inside dm_set_zones_restrictions(). Or is this trying to detect a
> table change that would switch the device from zoned to non-zoned ? If that is
> the case, regardless of the zone write plug initialization state, we should
> never allow such change.

I don't think that, for instance, allowing a linear device stacked on
top of a zoned device to get remapped to stack on top of a non-zoned
device runs much more risk than allowing a linear device to get remapped
in any other case? This is currently allowed, and I don't believe anyone
has complained about it. I would rather assume that the user knows what
they are doing, instead of disallowing things that aren't obviously
wrong, and won't cause system problems if they are (aside from the
problems that naturally result from putting the wrong device in your
table line). But if Mikulas and Mike think it would be better to
disallow this, then I'm fine with that.

> >  	}
> >  
> >  	if (dm_table_supports_atomic_writes(t))
> > diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> > index 11e19281bb64..1d419734fefc 100644
> > --- a/drivers/md/dm-zone.c
> > +++ b/drivers/md/dm-zone.c
> > @@ -158,22 +158,22 @@ int dm_revalidate_zones(struct dm_table *t, struct request_queue *q)
> >  {
> >  	struct mapped_device *md = t->md;
> >  	struct gendisk *disk = md->disk;
> > +	unsigned int nr_zones = disk->nr_zones;
> >  	int ret;
> >  
> >  	if (!get_capacity(disk))
> >  		return 0;
> >  
> > -	/* Revalidate only if something changed. */
> > -	if (!disk->nr_zones || disk->nr_zones != md->nr_zones) {
> > -		DMINFO("%s using %s zone append",
> > -		       disk->disk_name,
> > -		       queue_emulates_zone_append(q) ? "emulated" : "native");
> > -		md->nr_zones = 0;
> > -	}
> > -
> > -	if (md->nr_zones)
> > +	/*
> > +	 * Do not revalidate if zone append emulation resources have already
> > +	 * been allocated.
> 
> Maybe better to rephrased this (to be precise) to something like:
> 
> 	/*
> 	 * Do not revalidate if zone write plug resources have already
> 	 * been allocated.
> 	 */
> 
> > +	 */
> > +	if (dm_has_zone_plugs(md))
> >  		return 0;
> >  
> > +	DMINFO("%s using %s zone append", disk->disk_name,
> > +	       queue_emulates_zone_append(q) ? "emulated" : "native");
> > +
> >  	/*
> >  	 * Our table is not live yet. So the call to dm_get_live_table()
> >  	 * in dm_blk_report_zones() will fail. Set a temporary pointer to
> > @@ -187,6 +187,7 @@ int dm_revalidate_zones(struct dm_table *t, struct request_queue *q)
> >  
> >  	if (ret) {
> >  		DMERR("Revalidate zones failed %d", ret);
> > +		disk->nr_zones = nr_zones;
> >  		return ret;
> >  	}
> >  
> > @@ -383,12 +384,28 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
> >  		lim->max_open_zones = 0;
> >  		lim->max_active_zones = 0;
> >  		lim->max_hw_zone_append_sectors = 0;
> > +		lim->max_zone_append_sectors = 0;
> >  		lim->zone_write_granularity = 0;
> >  		lim->chunk_sectors = 0;
> >  		lim->features &= ~BLK_FEAT_ZONED;
> >  		return 0;
> >  	}
> >  
> > +	if (get_capacity(disk) && dm_has_zone_plugs(t->md)) {
> > +		if (q->limits.chunk_sectors != lim->chunk_sectors) {
> > +			DMWARN("%s: device has zone write plug resources. "
> > +			       "Cannot change zone size",
> > +			       disk->disk_name);
> > +			return -EINVAL;
> > +		}
> > +		if (lim->max_hw_zone_append_sectors != 0 &&
> > +		    !dm_table_is_wildcard(t)) {
> > +			DMWARN("%s: device has zone write plug resources. "
> > +			       "New table must emulate zone append",
> > +			       disk->disk_name);
> > +			return -EINVAL;
> > +		}
> > +	}
> 
> I have some concerns about this: what if the new table has the same capacity
> and the same zone size but the types of zones changed ? We are not checking
> this here and we cannot actually check that without doing a report zones. So I
> really think we should just use the big hammer here and simply only allow the
> wildcard target and no other change.

I don't see how this could lead to accessing invalid memory, which was
my big concern, with these patches. The worst that could happen in an IO
error, AFAICS. Disallowing all table loads except for the error target
would keep people from being able from things like changing options on
the dm-crypt target. Again, that is just my preference, and I'll defer
to Mike and Mikulas on how this should be handled.

> >  	/*
> >  	 * Warn once (when the capacity is not yet set) if the mapped device is
> >  	 * partially using zone resources of the target devices as that leads to
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index 292414da871d..240f6dab8dda 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -2429,6 +2429,12 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
> >  	size = dm_table_get_size(t);
> >  
> >  	old_size = dm_get_size(md);
> > +
> > +	if (!dm_table_supports_size_change(t, old_size, size)) {
> > +		old_map = ERR_PTR(-EINVAL);
> > +		goto out;
> > +	}
> 
> And I guess we could probably move the "wildcard-only is allowed" change check
> here as that would further simplify the revalidation code. No ?

If we are disallowing any zoned device to reload its table to something
other than an error target, then yes. It can go here. If we only care
about zoned devices that emulate zoned append, when we need to wait till
dm_set_zones_restrictions() where we determine that. Since we already
need to handle failures in dm_table_set_restrictions(), moving it
doesn't simplify the code much.

-Ben
 
> > +
> >  	set_capacity(md->disk, size);
> >  
> >  	ret = dm_table_set_restrictions(t, md->queue, limits);
> > diff --git a/drivers/md/dm.h b/drivers/md/dm.h
> > index e5d3a9f46a91..245f52b59215 100644
> > --- a/drivers/md/dm.h
> > +++ b/drivers/md/dm.h
> > @@ -58,6 +58,7 @@ void dm_table_event_callback(struct dm_table *t,
> >  			     void (*fn)(void *), void *context);
> >  struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector);
> >  bool dm_table_has_no_data_devices(struct dm_table *table);
> > +bool dm_table_is_wildcard(struct dm_table *t);
> >  int dm_calculate_queue_limits(struct dm_table *table,
> >  			      struct queue_limits *limits);
> >  int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
> > @@ -72,6 +73,8 @@ struct target_type *dm_table_get_immutable_target_type(struct dm_table *t);
> >  struct dm_target *dm_table_get_immutable_target(struct dm_table *t);
> >  struct dm_target *dm_table_get_wildcard_target(struct dm_table *t);
> >  bool dm_table_request_based(struct dm_table *t);
> > +bool dm_table_supports_size_change(struct dm_table *t, sector_t old_size,
> > +				   sector_t new_size);
> >  
> >  void dm_lock_md_type(struct mapped_device *md);
> >  void dm_unlock_md_type(struct mapped_device *md);
> > @@ -111,12 +114,14 @@ bool dm_is_zone_write(struct mapped_device *md, struct bio *bio);
> >  int dm_zone_get_reset_bitmap(struct mapped_device *md, struct dm_table *t,
> >  			     sector_t sector, unsigned int nr_zones,
> >  			     unsigned long *need_reset);
> > +#define dm_has_zone_plugs(md) ((md)->disk->zone_wplugs_hash != NULL)
> >  #else
> >  #define dm_blk_report_zones	NULL
> >  static inline bool dm_is_zone_write(struct mapped_device *md, struct bio *bio)
> >  {
> >  	return false;
> >  }
> > +#define dm_has_zone_plugs(md) false
> >  #endif
> >  
> >  /*
> 
> 
> -- 
> Damien Le Moal
> Western Digital Research

