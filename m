Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F5D1E1E11
	for <dm-devel@lists.linux.dev>; Wed, 19 Mar 2025 16:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742403034; cv=none; b=LZPzJGETQG8hseWrE4ZX6S8MolweyOuQwYYGsax5tx49A9pIWy6RlKxF18EsWOvh8q1eBVtUu0RcMUtKxG+bwpZ1RJ2xhQ8YeX9UD+zs/M97GQTDDFdbOyCcKbnrO8TnH2OVz9Kq24qBXf/gOqyqFy8V57mR1GKkYoItsxMGuLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742403034; c=relaxed/simple;
	bh=vKKVX17AjrXlAFLfclNoUTodVrDTOorrXT8recqIP6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kfeAJq+Blj97OwO08H+v1OYw74oy9DQeAFTRKDwDTozaf57xXpIrhsh7IKObH0V5yEU0b5kWLeu7g/LTjLHUTkmLfZjjV/YJGmleJIo70ViabsTghhl2mzGt0ummxKcShMxMsQNmUpUq0r8lrm2HMcrOtuJA6p37sUX/rn8XqZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MBwxylvN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MBwxylvN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742403031;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tUXfMsKF0dQ22/314PRUuLEKobtCdevpLn/draYtV+4=;
	b=MBwxylvN1Nq14AHgcS2BaLcJe5/gvIpf1ATfKJDreWIbThbWNfS1TtRjeufD5T8iKhVszT
	dAN1OzqfXzTipocC640/yssQeRCoamT4fD+2NmShIkm2ug8smR1yIVkOGoPS/7zXRxxNPj
	Jz+KsqSd+fciF0UVXUIsQPFXKwnb9gQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-300-P62khHSwPzifWzY5qJFRGw-1; Wed,
 19 Mar 2025 12:50:27 -0400
X-MC-Unique: P62khHSwPzifWzY5qJFRGw-1
X-Mimecast-MFC-AGG-ID: P62khHSwPzifWzY5qJFRGw_1742403025
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C0088180035E;
	Wed, 19 Mar 2025 16:50:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6EB563001D0E;
	Wed, 19 Mar 2025 16:50:24 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 52JGoN1P2303807
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 19 Mar 2025 12:50:23 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 52JGoLoW2303806;
	Wed, 19 Mar 2025 12:50:21 -0400
Date: Wed, 19 Mar 2025 12:50:21 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        dm-devel@lists.linux.dev, linux-block@vger.kernel.org
Subject: Re: [PATCH v2 5/6] dm: fix dm_blk_report_zones
Message-ID: <Z9r1zUwAJTlqanpR@redhat.com>
References: <20250317044510.2200856-1-bmarzins@redhat.com>
 <20250317044510.2200856-6-bmarzins@redhat.com>
 <20250318065721.GB16259@lst.de>
 <Z9nvOcQRrxopHfrF@redhat.com>
 <ae356993-ffa3-4ee1-87e3-3257dedf9908@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae356993-ffa3-4ee1-87e3-3257dedf9908@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Wed, Mar 19, 2025 at 10:40:38AM +0900, Damien Le Moal wrote:
> On 3/19/25 7:10 AM, Benjamin Marzinski wrote:
> > On Tue, Mar 18, 2025 at 07:57:21AM +0100, Christoph Hellwig wrote:
> >> On Mon, Mar 17, 2025 at 12:45:09AM -0400, Benjamin Marzinski wrote:
> >>> __bind(). Otherwise the zone resources could change while accessing
> >>> them. Finally, it is possible that md->zone_revalidate_map will change
> >>> while calling this function. Only read it once, so that we are always
> >>> using the same value. Otherwise we might miss a call to
> >>> dm_put_live_table().
> >>
> >> This checking for calling context is pretty ugly.  Can you just use
> >> a separate report zones helper or at least a clearly documented flag for it?
> > 
> > Not sure how that would work. The goal is to keep another process,
> > calling something like blkdev_report_zones_ioctl(), from being able to
> > call its report_zones_cb, while DM is in blk_revalidate_disk_zones()
> > which needs to use that same disk->fops->report_zones() interface in
> > order to call blk_revalidate_zone_cb(). We need some way to distinguish
> > between the callers. We could export blk_revalidate_zone_cb() and have
> > dm_blk_report_zones() check if it was called with that report_zones_cb.
> > That seems just as ugly to me. But if you like that better, fine.
> > Otherwise I don't see how we can distinguish between the call from
> > blk_revalidate_disk_zones() and a call from something like
> > blkdev_report_zones_ioctl(). Am I not understanding your suggestion?
> > 
> > Allowing the blkdev_report_zones_ioctl() call to go ahead using
> > md->zone_revalidate_map runs into three problems.
> > 
> > 1. It's running while the device is switching tables, and there's no
> > guarantee that DM won't encounter an error and have to fail back. So it
> > could report information for this unused table. We could just say that
> > this is what you get from trying to grab the zone information of a
> > device while it's switching tables. Fine.
> > 
> > 2. Without this patch, it's possible that while
> > blkdev_report_zones_ioctl() is still running its report_zones_cb, DM
> > fails switching tables and frees the new table that's being used by
> > blkdev_report_zones_ioctl(), causing use-after-free errors. However,
> > this is solvable by calling srcu_read_lock(&md->io_barrier) to make sure
> > that we're in a SRCU read section while using md->zone_revalidate_map.
> > Making that chage should make DM as safe as any other zoned device,
> > which brings me to...
> > 
> > 3. On any zoned device, not just DM, what's stopping
> > one process from syncing the zone write plug offsets:
> > blkdev_report_zones_ioctl() -> blkdev_report_zones() ->
> > various.report_zones() -> disk_report_zones_cb() ->
> > disk_zone_wplug_sync_wp_offset()
> 
> disk_zone_wplug_sync_wp_offset() is a nop for any zone write plug that does not
> have BLK_ZONE_WPLUG_NEED_WP_UPDATE set. And that flag is set only for zones
> that had a write error. Given that recovering from write errors on zoned device
> requires to:
> 1) stop writing to the zone,
> 2) Do a report zone (which will sync the wp offset)
> 3) Restart writing
> there is no write IOs going on for the zone that is being reported, for a well
> behaved user. If the user is not well behaved, it will get errors/out of sync
> wp, until the user behaves :) So I would not worry too much about this.

The issue isn't that there could be IO errors, it's that we are reading
and writing from these zwplugs without any way to keep them from being
freed while we're doing so. 

> As we discussed, the table switching should be allowed only for the wildcard
> target (dm-error) and that's it. We should not allow table switching otherwise.
> And given that inserting dm-error does not cause any change to the zone
> configuration, I do not see why we need to revalidate zones.

With this patchset we will never call blk_revalidate_disk_zones() when
we have disk->zone_wplugs_hash, which means that
disk_zone_wplug_sync_wp_offset() can never be called once we are using a
zoned table, so that's not a problem.

The problem we do have happens when we are initially switching to that
zoned table. blk_revalidate_disk_zones() can allocate
disk->zone_wplugs_hash, and the later fail and free it. In this case, if
some userspace process does a BLKREPORTZONE ioctl() while
md->zone_revalidate_map is set and disk->zone_wplugs_hash exists, it
could well be still running when disk->zone_wplugs_hash gets freed. We
obviously can't ban loading a zoned dm-crypt table at all.

I admit, this is a very unlikely occurance, but very unlikely memory
corruptions are still memory corruptions, and much harder to track down
when they do occur. My original patch, which only allows the task that
set md->zone_revalidate_map to work during suspends, solves this issue.
So does my suggestion that dm_blk_report_zones() only allow calls with
blk_revalidate_zone_cb() as the callback to use md->zone_revalidate_map.
If Christoph has a better solution that I'm misunderstanding, I'm fine
with that to. But since we want people to be able to set up dm-crypt on
top of zoned devices, we have to guard against userspace processes
running at the same time as we're doing that, in case we fail and free
the resources.

> > 
> > While another process is running into problems while dealing with the
> > gendisk's zone configuration changing:
> > 
> > blk_revalidate_disk_zones() -> disk_free_zone_resources()
> 
> We should not allow the zone configuration to change. That is impossible to
> deal with at the user level.

The comments above blk_revalidate_disk_zones() sure make it sound like
it could get called after a device has already been set up

/*
 * blk_revalidate_disk_zones - (re)allocate and initialize zone write plugs
 * @disk:       Target disk
 *
 * Helper function for low-level device drivers to check, (re) allocate and
 * initialize resources used for managing zoned disks. This function should
 * normally be called by blk-mq based drivers when a zoned gendisk is probed
 * and when the zone configuration of the gendisk changes (e.g. after a format).
 * Before calling this function, the device driver must already have set the
 * device zone size (chunk_sector limit) and the max zone append limit.
 * BIO based drivers can also use this function as long as the device queue
 * can be safely frozen.
 */

and a brief look does make it appear that nvme and scsi device can call
this when the device is rescanned. Perhaps there's no risk of them
failing in this case? 

> > I don't see any synchronizing between these two call paths. Am I missing
> > something that stops this? Can this only happen for DM devices, for some
> > reason? If this can't happen, I'm fine with just adding a
> > srcu_read_lock() to dm_blk_report_zones() and calling it good.  If it
> > can happen, then we should fix that.
> 
> I think it can happen today but no-one ever had this issue because no-one has
> tried to switch a dm-table on a zoned drive. And I really think we should
> prevent that from being done, except for dm-error since that's used for fstests.

This patchset allows zoned devices that don't allocate zone write plug
resources to be arbitrarily changed. This never caused problems, so we
have no idea how often people were doing it. I don't see anything unsafe
there, and people typically do all sorts of things with linear dm devices.

For devices that have allocated zone write plug resources, they can only
reload tables that do not change the zone resources (only dm-crypat and
dm-error targets will work here), and blk_revalidate_disk_zones() is
never called. Not allowing any dm-crypt reloads would keep people from
reloading a dm-crypt device with the exact same table or simply with an
optional parameter changed. Doing that is safe, and again we have no
idea how often this has been happening, since it wouldn't cause any
problems. 

-Ben

> > 
> > -Ben
> > 
> 
> 
> -- 
> Damien Le Moal
> Western Digital Research

