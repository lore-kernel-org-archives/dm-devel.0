Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4975286405
	for <dm-devel@lists.linux.dev>; Thu,  9 Oct 2025 22:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760048748; cv=none; b=KX5Lw7SznlWFTtaDNyyrHGEcK7+P/cywqv6mqos/Nk8NQqrGASyWhoXt/duWUlwzJExnmMbP6M7QoXi/erFSsXW5BxUVJrUCnPr0vWJ+vjsvjTTFq+eFIcoSTggjOP2E9/PojsPM6wAZH+S84p62MKEr4xkOkHOLyDY/O448IR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760048748; c=relaxed/simple;
	bh=zw0iNdj3m3qwUjWjPIg+fKTIWtWdKurqXKxC19BNZjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jGDSauXlG95DkMs8R3P3sE/EMyYxAG1JcE1hiXgADThAKUTkGh8TgsOG0J8TRIvAgaTSnmTr/kZHOz6ipOZBhPmOeCyPw/6lWqT4aJjYLZJrRBc6zfwdmY319tG8IuwN01OIxZmc6xUNzyMXkv/WvfyfAocJr7C6HiAWvWlUSFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gzs+mVwB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gzs+mVwB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760048745;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v9EwrRpAd0xIefdvpKUt80h7n/6WUYanOHkCB6oYamE=;
	b=gzs+mVwBna3xAwBER1J4L4EKhcUisK7CKiXgbcn/HMAMECfISdMb2enuRLOwRNekyTnOBo
	lGoX4jJyvqruJcjVHAluap8O8n9iVasyM2EyVQODCWkoFdC7I6c2QSVVyOloQUPxyq9GoM
	L1uagl/ILPkQ9bLLZn7dkfdM39t9FUo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-178-qincvNUfM-ecklYn8k5voA-1; Thu,
 09 Oct 2025 18:25:42 -0400
X-MC-Unique: qincvNUfM-ecklYn8k5voA-1
X-Mimecast-MFC-AGG-ID: qincvNUfM-ecklYn8k5voA_1760048741
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 127501800350;
	Thu,  9 Oct 2025 22:25:41 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 40A871953944;
	Thu,  9 Oct 2025 22:25:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 599MPciP2928659
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 9 Oct 2025 18:25:38 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 599MPcaR2928658;
	Thu, 9 Oct 2025 18:25:38 -0400
Date: Thu, 9 Oct 2025 18:25:38 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        dm-devel@lists.linux.dev, linux-block@vger.kernel.org
Subject: Re: [PATCH] dm: Fix deadlock when reloading a multipath table
Message-ID: <aOg2Yul2Di4Ymom-@redhat.com>
References: <20251009030431.2895495-1-bmarzins@redhat.com>
 <ed792d72a1ca47937631af6e12098d9a20626bcf.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ed792d72a1ca47937631af6e12098d9a20626bcf.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Thu, Oct 09, 2025 at 11:57:08AM +0200, Martin Wilck wrote:
> On Wed, 2025-10-08 at 23:04 -0400, Benjamin Marzinski wrote:
> > Request-based devices (dm-multipath) queue I/O in blk-mq on noflush
> > suspends. Any queued IO will make it impossible to freeze the queue.
> > If
> > a process attempts to update the queue limits while there is queued
> > IO,
> > it can be get stuck holding the limits lock, while unable to freeze
> > the
> > queue. If device-mapper then attempts to update the limits during a
> > table swap, it will deadlock trying to grab the limits lock while
> > making
> > it impossible to flush the IO.
> > 
> > Disallow updating the queue limits during a table swap, when updating
> > an
> > immutable request-based dm device (dm-multipath) during a noflush
> > suspend. It is userspace's responsibility to make sure that the new
> > table uses the same limits as the existing table if it asks for a
> > noflush suspend.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  drivers/md/dm-table.c |  4 ++++
> >  drivers/md/dm-thin.c  |  7 ++-----
> >  drivers/md/dm.c       | 35 +++++++++++++++++++++++------------
> >  3 files changed, 29 insertions(+), 17 deletions(-)
> > 
> > diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> > index ad0a60a07b93..0522cd700e0e 100644
> > --- a/drivers/md/dm-table.c
> > +++ b/drivers/md/dm-table.c
> > @@ -2043,6 +2043,10 @@ bool dm_table_supports_size_change(struct
> > dm_table *t, sector_t old_size,
> >  	return true;
> >  }
> >  
> > +/*
> > + * This function will be skipped by noflush reloads of immutable
> > request
> > + * based devices (dm-mpath).
> > + */
> >  int dm_table_set_restrictions(struct dm_table *t, struct
> > request_queue *q,
> >  			      struct queue_limits *limits)
> >  {
> > diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> > index c84149ba4e38..6f98936f0e05 100644
> > --- a/drivers/md/dm-thin.c
> > +++ b/drivers/md/dm-thin.c
> > @@ -4383,11 +4383,8 @@ static void thin_postsuspend(struct dm_target
> > *ti)
> >  {
> >  	struct thin_c *tc = ti->private;
> >  
> > -	/*
> > -	 * The dm_noflush_suspending flag has been cleared by now,
> > so
> > -	 * unfortunately we must always run this.
> > -	 */
> > -	noflush_work(tc, do_noflush_stop);
> > +	if (dm_noflush_suspending(ti))
> > +		noflush_work(tc, do_noflush_stop);
> >  }
> >  
> >  static int thin_preresume(struct dm_target *ti)
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index 3ede5ba4cf7e..87e65c48dd04 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -2439,7 +2439,6 @@ static struct dm_table *__bind(struct
> > mapped_device *md, struct dm_table *t,
> >  {
> >  	struct dm_table *old_map;
> >  	sector_t size, old_size;
> > -	int ret;
> >  
> >  	lockdep_assert_held(&md->suspend_lock);
> >  
> > @@ -2454,11 +2453,13 @@ static struct dm_table *__bind(struct
> > mapped_device *md, struct dm_table *t,
> >  
> >  	set_capacity(md->disk, size);
> >  
> > -	ret = dm_table_set_restrictions(t, md->queue, limits);
> > -	if (ret) {
> > -		set_capacity(md->disk, old_size);
> > -		old_map = ERR_PTR(ret);
> > -		goto out;
> > +	if (limits) {
> > +		int ret = dm_table_set_restrictions(t, md->queue,
> > limits);
> > +		if (ret) {
> > +			set_capacity(md->disk, old_size);
> > +			old_map = ERR_PTR(ret);
> > +			goto out;
> > +		}
> >  	}
> >  
> >  	/*
> > @@ -2836,6 +2837,7 @@ static void dm_wq_work(struct work_struct
> > *work)
> >  
> >  static void dm_queue_flush(struct mapped_device *md)
> >  {
> > +	clear_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
> >  	clear_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags);
> >  	smp_mb__after_atomic();
> >  	queue_work(md->wq, &md->work);
> > @@ -2848,6 +2850,7 @@ struct dm_table *dm_swap_table(struct
> > mapped_device *md, struct dm_table *table)
> >  {
> >  	struct dm_table *live_map = NULL, *map = ERR_PTR(-EINVAL);
> >  	struct queue_limits limits;
> > +	bool update_limits = true;
> >  	int r;
> >  
> >  	mutex_lock(&md->suspend_lock);
> > @@ -2856,20 +2859,31 @@ struct dm_table *dm_swap_table(struct
> > mapped_device *md, struct dm_table *table)
> >  	if (!dm_suspended_md(md))
> >  		goto out;
> >  
> > +	/*
> > +	 * To avoid a potential deadlock locking the queue limits,
> > disallow
> > +	 * updating the queue limits during a table swap, when
> > updating an
> > +	 * immutable request-based dm device (dm-multipath) during a
> > noflush
> > +	 * suspend. It is userspace's responsibility to make sure
> > that the new
> > +	 * table uses the same limits as the existing table, if it
> > asks for a
> > +	 * noflush suspend.
> > +	 */
> > +	if (dm_request_based(md) && md->immutable_target &&
> > +	    __noflush_suspending(md))
> > +		update_limits = false;
> >  	/*
> >  	 * If the new table has no data devices, retain the existing
> > limits.
> >  	 * This helps multipath with queue_if_no_path if all paths
> > disappear,
> >  	 * then new I/O is queued based on these limits, and then
> > some paths
> >  	 * reappear.
> >  	 */
> > -	if (dm_table_has_no_data_devices(table)) {
> > +	else if (dm_table_has_no_data_devices(table)) {
> >  		live_map = dm_get_live_table_fast(md);
> >  		if (live_map)
> >  			limits = md->queue->limits;
> >  		dm_put_live_table_fast(md);
> >  	}
> >  
> > -	if (!live_map) {
> > +	if (update_limits && !live_map) {
> >  		r = dm_calculate_queue_limits(table, &limits);
> >  		if (r) {
> >  			map = ERR_PTR(r);
> > @@ -2877,7 +2891,7 @@ struct dm_table *dm_swap_table(struct
> > mapped_device *md, struct dm_table *table)
> >  		}
> >  	}
> >  
> > -	map = __bind(md, table, &limits);
> > +	map = __bind(md, table, update_limits ? &limits : NULL);
> >  	dm_issue_global_event();
> >  
> >  out:
> > @@ -2930,7 +2944,6 @@ static int __dm_suspend(struct mapped_device
> > *md, struct dm_table *map,
> >  
> >  	/*
> >  	 * DMF_NOFLUSH_SUSPENDING must be set before presuspend.
> > -	 * This flag is cleared before dm_suspend returns.
> >  	 */
> >  	if (noflush)
> >  		set_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
> > @@ -2993,8 +3006,6 @@ static int __dm_suspend(struct mapped_device
> > *md, struct dm_table *map,
> >  	if (!r)
> >  		set_bit(dmf_suspended_flag, &md->flags);
> >  
> > -	if (noflush)
> > -		clear_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
> >  	if (map)
> >  		synchronize_srcu(&md->io_barrier);
> 
> This moves the clear_bit() behind synchronize_rcu(). Is that safe?

It's not just moved behind the synchronize_rcu(). DMF_NOFLUSH_SUSPENDING
is now set for the entire time the device is suspended. If people would
like, I'll update the patch to rename it to DMF_NOFLUSH_SUSPEND.

I did check to see if holding it for the entire suspend would cause
issues, but I didn't see any case where it would. If I missed a 
case where __noflush_suspending() should only return true if we are
actually in the process of suspending, I can easily update that
function to do that.
 
> In general, I'm wondering whether we need a more generic solution to
> this problem. Therefore I've added linux-block to cc.
> 
> The way I see it, if a device has queued IO without any means to
> perform the IO, it can't be frozen. We'd either need to fail all queued
> IO in this case, or refuse attempts to freeze the queue.

In general, it's perfectly normal to start freezing the queue while
there are still outstanding requests. I'm not sure that there is a good
way to distinguish between multipath's queued requests and other cases.
I'd be happy to be proved wrong, however.

-Ben
 
> Thanks,
> Martin

