Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E0F34A3C0
	for <dm-devel@lists.linux.dev>; Tue, 21 Oct 2025 19:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761074194; cv=none; b=bJsSk+a/9R8wXycjKmLyp7WZPBXlqBN4YuFZMtqYP3DplwAi+VRlqrBX+vUu1nQKJj+kTRE4LHSMuWN2X+hi40ugViqjTc2O+DFbcMMPqHHpbxVK7jXiGB1dP8UkSdtvXlK4Do48oymFNBEXiuAww3WHFdp21Ew0bUuL5DQkz3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761074194; c=relaxed/simple;
	bh=AmReOZCD1x8Sk/N6D5ZiKjTaLrZxSusaJgyBMpGb2Gk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VBg/RXiU0DnTdU0fPHk1m5iks5W0cryQw6ltcxKSe4mIT3oQp7WLk7MkOYlK5k3qvjW9152eoT7yjFeuXJhLVD4NO8qV7RzV1kFrtN1ulkRCaY84PjHxW3qmzhbKjV2pwJjRvr7d9vYl+E7TXACga2pc6yzSZSqEJcG5WrXsxMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mo5AHGhZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mo5AHGhZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761074190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v0Oe/5HuoWDLpJoIPd3oyR/J28Ecq7NQwP7IC26zECo=;
	b=Mo5AHGhZNQbOi8oetcQGJMs2g7kboSfzg3o2n8f/aF+51jSqtYBJMizIyLeAMYIcELbk+g
	i/REbOnKzoq4IHrkn25h0It9VuwfwZOV3VnYjXyKg1XWVnpYtTIoVvZSYq4WUYRoTOIw0S
	7G8Lyzf8if+fklbmQhGr3w0b/jPq/u8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-542-HRIPV6LgPDCbeRjYFokaFA-1; Tue,
 21 Oct 2025 15:16:22 -0400
X-MC-Unique: HRIPV6LgPDCbeRjYFokaFA-1
X-Mimecast-MFC-AGG-ID: HRIPV6LgPDCbeRjYFokaFA_1761074180
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B79321954224;
	Tue, 21 Oct 2025 19:16:20 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4073330001A7;
	Tue, 21 Oct 2025 19:16:20 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 59LJGIEH3453173
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 15:16:18 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 59LJGHSQ3453172;
	Tue, 21 Oct 2025 15:16:17 -0400
Date: Tue, 21 Oct 2025 15:16:17 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org
Subject: Re: [PATCH] dm: Fix deadlock when reloading a multipath table
Message-ID: <aPfcAfn6gsgNLwC7@redhat.com>
References: <20251009030431.2895495-1-bmarzins@redhat.com>
 <ed792d72a1ca47937631af6e12098d9a20626bcf.camel@suse.com>
 <aOg2Yul2Di4Ymom-@redhat.com>
 <e407b683dceb9516b54cede5624baa399f8fa638.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e407b683dceb9516b54cede5624baa399f8fa638.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Fri, Oct 10, 2025 at 12:19:51PM +0200, Martin Wilck wrote:
> On Thu, 2025-10-09 at 18:25 -0400, Benjamin Marzinski wrote:
> > On Thu, Oct 09, 2025 at 11:57:08AM +0200, Martin Wilck wrote:
> > > On Wed, 2025-10-08 at 23:04 -0400, Benjamin Marzinski wrote:
> > > > Request-based devices (dm-multipath) queue I/O in blk-mq on
> > > > noflush
> > > > suspends. Any queued IO will make it impossible to freeze the
> > > > queue.
> > > > If
> > > > a process attempts to update the queue limits while there is
> > > > queued
> > > > IO,
> > > > it can be get stuck holding the limits lock, while unable to
> > > > freeze
> > > > the
> > > > queue. If device-mapper then attempts to update the limits during
> > > > a
> > > > table swap, it will deadlock trying to grab the limits lock while
> > > > making
> > > > it impossible to flush the IO.
> > > > 
> > > > Disallow updating the queue limits during a table swap, when
> > > > updating
> > > > an
> > > > immutable request-based dm device (dm-multipath) during a noflush
> > > > suspend. It is userspace's responsibility to make sure that the
> > > > new
> > > > table uses the same limits as the existing table if it asks for a
> > > > noflush suspend.
> > > > 
> > > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > > ---
> > > >  drivers/md/dm-table.c |  4 ++++
> > > >  drivers/md/dm-thin.c  |  7 ++-----
> > > >  drivers/md/dm.c       | 35 +++++++++++++++++++++++------------
> > > >  3 files changed, 29 insertions(+), 17 deletions(-)
> > > > 
> > > > diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> > > > index ad0a60a07b93..0522cd700e0e 100644
> > > > --- a/drivers/md/dm-table.c
> > > > +++ b/drivers/md/dm-table.c
> > > > @@ -2043,6 +2043,10 @@ bool dm_table_supports_size_change(struct
> > > > dm_table *t, sector_t old_size,
> > > >  	return true;
> > > >  }
> > > >  
> > > > +/*
> > > > + * This function will be skipped by noflush reloads of immutable
> > > > request
> > > > + * based devices (dm-mpath).
> > > > + */
> > > >  int dm_table_set_restrictions(struct dm_table *t, struct
> > > > request_queue *q,
> > > >  			      struct queue_limits *limits)
> > > >  {
> > > > diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> > > > index c84149ba4e38..6f98936f0e05 100644
> > > > --- a/drivers/md/dm-thin.c
> > > > +++ b/drivers/md/dm-thin.c
> > > > @@ -4383,11 +4383,8 @@ static void thin_postsuspend(struct
> > > > dm_target
> > > > *ti)
> > > >  {
> > > >  	struct thin_c *tc = ti->private;
> > > >  
> > > > -	/*
> > > > -	 * The dm_noflush_suspending flag has been cleared by
> > > > now,
> > > > so
> > > > -	 * unfortunately we must always run this.
> > > > -	 */
> > > > -	noflush_work(tc, do_noflush_stop);
> > > > +	if (dm_noflush_suspending(ti))
> > > > +		noflush_work(tc, do_noflush_stop);
> > > >  }
> > > >  
> > > >  static int thin_preresume(struct dm_target *ti)
> > > > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > > > index 3ede5ba4cf7e..87e65c48dd04 100644
> > > > --- a/drivers/md/dm.c
> > > > +++ b/drivers/md/dm.c
> > > > @@ -2439,7 +2439,6 @@ static struct dm_table *__bind(struct
> > > > mapped_device *md, struct dm_table *t,
> > > >  {
> > > >  	struct dm_table *old_map;
> > > >  	sector_t size, old_size;
> > > > -	int ret;
> > > >  
> > > >  	lockdep_assert_held(&md->suspend_lock);
> > > >  
> > > > @@ -2454,11 +2453,13 @@ static struct dm_table *__bind(struct
> > > > mapped_device *md, struct dm_table *t,
> > > >  
> > > >  	set_capacity(md->disk, size);
> > > >  
> > > > -	ret = dm_table_set_restrictions(t, md->queue, limits);
> > > > -	if (ret) {
> > > > -		set_capacity(md->disk, old_size);
> > > > -		old_map = ERR_PTR(ret);
> > > > -		goto out;
> > > > +	if (limits) {
> > > > +		int ret = dm_table_set_restrictions(t, md-
> > > > >queue,
> > > > limits);
> > > > +		if (ret) {
> > > > +			set_capacity(md->disk, old_size);
> > > > +			old_map = ERR_PTR(ret);
> > > > +			goto out;
> > > > +		}
> > > >  	}
> > > >  
> > > >  	/*
> > > > @@ -2836,6 +2837,7 @@ static void dm_wq_work(struct work_struct
> > > > *work)
> > > >  
> > > >  static void dm_queue_flush(struct mapped_device *md)
> > > >  {
> > > > +	clear_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
> > > >  	clear_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags);
> > > >  	smp_mb__after_atomic();
> > > >  	queue_work(md->wq, &md->work);
> > > > @@ -2848,6 +2850,7 @@ struct dm_table *dm_swap_table(struct
> > > > mapped_device *md, struct dm_table *table)
> > > >  {
> > > >  	struct dm_table *live_map = NULL, *map = ERR_PTR(-
> > > > EINVAL);
> > > >  	struct queue_limits limits;
> > > > +	bool update_limits = true;
> > > >  	int r;
> > > >  
> > > >  	mutex_lock(&md->suspend_lock);
> > > > @@ -2856,20 +2859,31 @@ struct dm_table *dm_swap_table(struct
> > > > mapped_device *md, struct dm_table *table)
> > > >  	if (!dm_suspended_md(md))
> > > >  		goto out;
> > > >  
> > > > +	/*
> > > > +	 * To avoid a potential deadlock locking the queue
> > > > limits,
> > > > disallow
> > > > +	 * updating the queue limits during a table swap, when
> > > > updating an
> > > > +	 * immutable request-based dm device (dm-multipath)
> > > > during a
> > > > noflush
> > > > +	 * suspend. It is userspace's responsibility to make
> > > > sure
> > > > that the new
> > > > +	 * table uses the same limits as the existing table, if
> > > > it
> > > > asks for a
> > > > +	 * noflush suspend.
> > > > +	 */
> > > > +	if (dm_request_based(md) && md->immutable_target &&
> > > > +	    __noflush_suspending(md))
> > > > +		update_limits = false;
> > > >  	/*
> > > >  	 * If the new table has no data devices, retain the
> > > > existing
> > > > limits.
> > > >  	 * This helps multipath with queue_if_no_path if all
> > > > paths
> > > > disappear,
> > > >  	 * then new I/O is queued based on these limits, and
> > > > then
> > > > some paths
> > > >  	 * reappear.
> > > >  	 */
> > > > -	if (dm_table_has_no_data_devices(table)) {
> > > > +	else if (dm_table_has_no_data_devices(table)) {
> > > >  		live_map = dm_get_live_table_fast(md);
> > > >  		if (live_map)
> > > >  			limits = md->queue->limits;
> > > >  		dm_put_live_table_fast(md);
> > > >  	}
> > > >  
> > > > -	if (!live_map) {
> > > > +	if (update_limits && !live_map) {
> > > >  		r = dm_calculate_queue_limits(table, &limits);
> > > >  		if (r) {
> > > >  			map = ERR_PTR(r);
> > > > @@ -2877,7 +2891,7 @@ struct dm_table *dm_swap_table(struct
> > > > mapped_device *md, struct dm_table *table)
> > > >  		}
> > > >  	}
> > > >  
> > > > -	map = __bind(md, table, &limits);
> > > > +	map = __bind(md, table, update_limits ? &limits : NULL);
> > > >  	dm_issue_global_event();
> > > >  
> > > >  out:
> > > > @@ -2930,7 +2944,6 @@ static int __dm_suspend(struct
> > > > mapped_device
> > > > *md, struct dm_table *map,
> > > >  
> > > >  	/*
> > > >  	 * DMF_NOFLUSH_SUSPENDING must be set before presuspend.
> > > > -	 * This flag is cleared before dm_suspend returns.
> > > >  	 */
> > > >  	if (noflush)
> > > >  		set_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
> > > > @@ -2993,8 +3006,6 @@ static int __dm_suspend(struct
> > > > mapped_device
> > > > *md, struct dm_table *map,
> > > >  	if (!r)
> > > >  		set_bit(dmf_suspended_flag, &md->flags);
> > > >  
> > > > -	if (noflush)
> > > > -		clear_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
> > > >  	if (map)
> > > >  		synchronize_srcu(&md->io_barrier);
> > > 
> > > This moves the clear_bit() behind synchronize_rcu(). Is that safe?
> > 
> > It's not just moved behind the synchronize_rcu().
> > DMF_NOFLUSH_SUSPENDING
> > is now set for the entire time the device is suspended. If people
> > would
> > like, I'll update the patch to rename it to DMF_NOFLUSH_SUSPEND.
> 
> Right. I realize now that there's a smp_mb__after_atomic() in
> dm_queue_flush().
> 
> > I did check to see if holding it for the entire suspend would cause
> > issues, but I didn't see any case where it would. If I missed a 
> > case where __noflush_suspending() should only return true if we are
> > actually in the process of suspending, I can easily update that
> > function to do that.
> 
> If this is necessary, I agree that the flag an related function should
> be renamed. But there are already generic DM flags to indicate that a
> queue is suspend*ed*. Perhaps, instead of changing the semantics of
> DMF_NOFLUSH_SUSPENDING, it would make more sense to test 
> 
>   (__noflush_suspending || test_bit(DMF_BLOCK_IO_FOR_SUSPEND)
> 
> in dm_swap_table()?

Won't we ALWAYS be suspended when we are in dm_swap_table()? We do need
to refresh the limits in some cases (the cases where multipath-tools
currently reloads the table without setting noflush). What we need to
know is "is this table swap happening in a noflush suspend, where
userspace understands that it can't modify the device table in a way
that would change the limits". For multipath, this is almost always the
case. 

> 
> Anyway, I am still not convinced that we want to have this specific
> exception for multipath only.

I agree that Bart's solution looks better to me, if it can get in.
 
> > > In general, I'm wondering whether we need a more generic solution
> > > to
> > > this problem. Therefore I've added linux-block to cc.
> > > 
> > > The way I see it, if a device has queued IO without any means to
> > > perform the IO, it can't be frozen. We'd either need to fail all
> > > queued
> > > IO in this case, or refuse attempts to freeze the queue.
> > 
> > In general, it's perfectly normal to start freezing the queue while
> > there are still outstanding requests.
> 
> Sure, but my point was "without any means to perform the IO". As you
> pointed out yourself, a freeze attempt in this situation would get
> stuck.
> 
> I find Bart's approach very attractive; freezing might not be necessary
> at all in that case. We'dd just need to avoid a race where paths get
> reinstated while the operation that would normally have required a
> freeze is ongoing.

I agree. Even just the timing out of freezes, his
"[PATCH 2/3] block: Restrict the duration of sysfs attribute changes"
would be enough to keep this from deadlocking the system.

-Ben

> Martin

