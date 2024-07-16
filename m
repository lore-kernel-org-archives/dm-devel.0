Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA6228DD0
	for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 20:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721160023; cv=none; b=bFPDz6Ygl9LnkIC6A4tyqEujjpBzwfjIG1BzD1whiB3WbaURspXG2C854/VinhjphzfqdXb1S8niDlToJVxPIaLZdk0AMknwAAu9YJQtSiU+wOmDMdZtQjP4QyqMth54Zf7NKjcEfSQiJ66nqycT6esJdy1Df9ITrwy7P2N1S0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721160023; c=relaxed/simple;
	bh=t2wq1R9uYtGFEqIC1Rsf1bcrQAS6GKMwjuJyH88GQZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=BcgXTdSvGH2pLrtCGW9Vsf/VfC+k0+qwpQK4ctO4Ey3vCpfUjQAlnDEPlhDb+j7/pb8MHr9Z5QWK041/RJ5ytyP/hWkECM8z2OtzIw3ueyTJU0ALJ55tnnbo6u4pnxw8uduV9q/CgUyIVa9/IXVSwXo5NbCCQ6eqUzHYEqSsoyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E7aggb2+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E7aggb2+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721160020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6lorY3oxyuA+234xkgg8HEdHI1CtJVyDT0b05kQSre4=;
	b=E7aggb2+r+FWBGKoq3mDkPT8Nz+ddY3ex+sWN5CUGPs+RyhW1tAqo7YZfFlerbpK85VJvG
	ZnSWyWOL2/BA9CXKKTGsS/7/q9cd/SU6y8D33QKPJGMH8w3/tRT8+8V0rO6mHxnFMA7LXl
	ovWcX9VGSnL2n8XIuncQ95xjnqlnm3g=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-224-ErCjGhAIPVWNtOt-ea0h3A-1; Tue,
 16 Jul 2024 16:00:18 -0400
X-MC-Unique: ErCjGhAIPVWNtOt-ea0h3A-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8DABC1956046;
	Tue, 16 Jul 2024 20:00:17 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EA18E1955D47;
	Tue, 16 Jul 2024 20:00:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46GK0Frw2129117
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Jul 2024 16:00:15 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46GK0FIo2129116;
	Tue, 16 Jul 2024 16:00:15 -0400
Date: Tue, 16 Jul 2024 16:00:15 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 21/22] multipathd: check paths in order by mpp
Message-ID: <ZpbRTxsx3JZLvKGP@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
 <20240713060506.2015463-22-bmarzins@redhat.com>
 <a55e8f056b18f97cd40e27d7262cd0640d036967.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <a55e8f056b18f97cd40e27d7262cd0640d036967.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Jul 15, 2024 at 11:19:57PM +0200, Martin Wilck wrote:
> On Sat, 2024-07-13 at 02:05 -0400, Benjamin Marzinski wrote:
> > Instead of checking all of the paths in vecs->pathvec in order, first
> > check all the paths in each multipath device. Then check the
> > uninitialized paths.
> > 
> > One issue with checking paths this way is that the multipath device
> > can
> > be resynced or even removed while a path is being checked. The path
> > can
> > also be removed. If there is any change to the multipath device,
> > multipathd needs to loop through its paths again, because the current
> > indexes may not longer be valid.
> > 
> > To do this change mpp->is_checked to an int called mpp->synced_count,
> > and increment it whenever the multipath device gets resynced. After
> > each
> > path is checked, make sure that the multipath device still exists,
> > that
> > mpp->synced_count hasn't changed. If either has happened, restart
> > checking at the current index in mpvec (which will either be the same
> > mpp if it was just resynced, or the next mpp if the last one was
> > deleted). Since the multipath device is resynced when its first path
> > is
> > checked, this restart will happen to every multipath device at least
> > once per loop. But the paths themselves aren't rechecked, so it's not
> > much overhead.
> 
> Why don't we just sync the map once before we start checking the paths,
> instead of doing it when the first path is checked? 

I guess we could loop through all the paths of a multipath device and
see if any of them are due for a check this loop. The if the path
checker returns pending we will have resynced the map for no benefit,
and we will continue to do so until the checker completes. This could
lead to us doing more resyncs than we were before, with no added
benefit.

> > If resyncing a multipath device fails in do_check_mpp(), there may be
> > path devices that have pp->mpp set, but are no longer in one of the
> > multipath device's pathgroups, and thus will not get checked. This
> > almost definitely means the multipath device was deleted. If
> > do_check_mpp() failed to resync the device, but it wasn't deleted, it
> > will get called again in max_checkint seconds even if it no longer
> > has
> > mpp->pg set, and the paths will get checked again after that.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/structs.h     |  2 +-
> >  libmultipath/structs_vec.c |  1 +
> >  multipathd/main.c          | 54 ++++++++++++++++++++++++++++++++----
> > --
> >  3 files changed, 48 insertions(+), 9 deletions(-)
> > 
> > diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> > index 457d7836..91509881 100644
> > --- a/libmultipath/structs.h
> > +++ b/libmultipath/structs.h
> > @@ -455,7 +455,7 @@ struct multipath {
> >  	int ghost_delay_tick;
> >  	int queue_mode;
> >  	unsigned int sync_tick;
> > -	bool is_checked;
> > +	int synced_count;
> >  	uid_t uid;
> >  	gid_t gid;
> >  	mode_t mode;
> > diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> > index 60360c76..704e0f21 100644
> > --- a/libmultipath/structs_vec.c
> > +++ b/libmultipath/structs_vec.c
> > @@ -513,6 +513,7 @@ update_multipath_table (struct multipath *mpp,
> > vector pathvec, int flags)
> >  	conf = get_multipath_config();
> >  	mpp->sync_tick = conf->max_checkint;
> >  	put_multipath_config(conf);
> > +	mpp->synced_count++;
> >  
> >  	r = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
> >  			  (mapid_t) { .str = mpp->alias },
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 27e18a0c..d51bc852 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -2356,7 +2356,6 @@ do_check_mpp(struct vectors * vecs, struct
> > multipath *mpp)
> >  	int i, ret;
> >  	struct path *pp;
> >  
> > -	mpp->is_checked = true;
> >  	ret = update_multipath_strings(mpp, vecs->pathvec);
> >  	if (ret != DMP_OK) {
> >  		condlog(1, "%s: %s", mpp->alias, ret ==
> > DMP_NOT_FOUND ?
> > @@ -2428,7 +2427,7 @@ do_check_path (struct vectors * vecs, struct
> > path * pp)
> >  		condlog(0, "%s: path wwid change detected.
> > Removing", pp->dev);
> >  		return handle_path_wwid_change(pp, vecs)? -1 : 0;
> >  	}
> > -	if (!pp->mpp->is_checked) {
> > +	if (pp->mpp->synced_count == 0) {
> >  		do_check_mpp(vecs, pp->mpp);
> >  		/* if update_multipath_strings orphaned the path,
> > quit early */
> >  		if (!pp->mpp)
> > @@ -2787,18 +2786,57 @@ check_paths(struct vectors *vecs, unsigned
> > int ticks, int *num_paths_p)
> >  {
> >  	unsigned int paths_checked = 0;
> >  	struct timespec diff_time, start_time, end_time;
> > +	struct multipath *mpp;
> >  	struct path *pp;
> >  	int i, rc;
> >  
> >  	get_monotonic_time(&start_time);
> > +
> > +	vector_foreach_slot(vecs->mpvec, mpp, i) {
> > +		struct pathgroup *pgp;
> > +		struct path *pp;
> > +		int j, k;
> > +		bool check_for_waiters = false;
> > +		/* maps can be rechecked, so this is not always 0 */
> > +		int synced_count = mpp->synced_count;
> > +
> > +		vector_foreach_slot (mpp->pg, pgp, j) {
> > +			vector_foreach_slot (pgp->paths, pp, k) {
> > +				if (!pp->mpp || pp->is_checked)
> > +					continue;
> > +				pp->is_checked = true;
> > +				rc = check_path(vecs, pp, ticks,
> > +						start_time.tv_sec);
> > +				if (rc > 0)
> > +					*num_paths_p += 1;
> > +				if (++paths_checked % 128 == 0)
> > +					check_for_waiters = true;
> > +				/*
> > +				 * mpp has been removed or resynced.
> > Path may
> > +				 * have been removed.
> > +				 */
> > +				if (VECTOR_SLOT(vecs->mpvec, i) !=
> > mpp ||
> > +				    synced_count != mpp-
> > >synced_count) {
> > +					i--;
> > +					goto next_mpp;
> > +				}
> 
> I'm aware that you have implemented the rather vague idea I had
> mentioned previously, thanks a lot for that.
> 
> This is ok, but the fact that the arrays we are looping over can be
> modified deeply inside functions inside the loop feels fragile. I
> wonder if it would be possible to clean up our code flow such that
> neither mpp nor path objects can be removed at this point the code. 

We could handle the paths WWID changing by just failng it immediately,
and then removing it after we check the other paths.  But unless we
either wanted to resync even when it was unnecessary like I mentioned
above, or we decide that we don't need to resync before updating the
path state, then no. There will be cases when we need to start checking
the path to see if we need to resync and when we resync the device could
be gone or have changed pathgroups.

Now, there's no reason I know of why we must resync the multipath device
before checking a path. I want to do it mostly because I think there is
a good chance that we will run into some weird corner case behaviors if
we stop doing it. It's nice to grab a lock so no other thread can change
the state, and then make get it to match the kernel state, before you
start changing that state based on you path check results. But the
moment after you grab that state it could already be out of date, so
multipathd needs to handle that possibility regardless.

Also the current changes already open us up to new corner cases. For
instance, if you fail calling update_multipath_strings() in
do_check_mpp(), mpp->pg may well be cleared. This means that you won't
end up checking any of the other paths in that multipath device until
something else reloads the device, either an event or check_mpp(). We
could work around this by calling check_path() for paths with pp->mpp
set but that haven't been checked yet in the loop where we currently
just call handle_uninitialized_path(). I debated doing this, but almost
always when do_check_mpp() fails, it will be because the device was
removed.

Another solution could be to set sync_tick to something low if we fail
when resyncing the mpp. That would let us process the remove event that
is almost definitely waiting for us, but still retry syncing the mpp
state soonish if that's not the case. I should probably do that
regardless of whether we check the unchecked paths with pp->mpp set in
the uninitialized paths loop.

But at any rate, we could try simply not resyncing the map until after
checking the paths, and handling whatever bugs appear. Or even try
something that dovetails with what I believe is your bigger vision,
where we start all the path checkers for all the paths of a device, and
only look to see which ones have completed once we're all done. If some
of the path checkers returned, we could save the checker results in
pp->newstate, check if the wwids changed and handle that, and then
resync the mpp and update it's state based on the checker results for
it's current paths.

But yeah, that's work for a different day.

> The sync code could set flags on paths and / or multipath objects that
> tell the caller that these objects are no longer valid, and we could
> remove them when we're done with the loop. I'm aware that we'd still
> need to cover path group changes. Perhaps we should create a temporary
> array of all paths in the map (possibly sorted by major/minor number).
> We'd ignore newly added paths (they should have been checked recently
> anyway, shouldn't they?) and skip over paths that are flagged as being
> removed.
> 
> I realize I'm making vague suggestions again. Your current work shows
> that this is more complicated than I first imagined. Thanks a lot for
> considering all the corner cases.
> 
> This isn't something I'd expect to change in the current patch set,
> just something to think about for the future.
> 
> > +			}
> > +		}
> > +next_mpp:
> > +		if (check_for_waiters &&
> > +		    (lock_has_waiters(&vecs->lock) ||
> > waiting_clients())) {
> > +			get_monotonic_time(&end_time);
> > +			timespecsub(&end_time, &start_time,
> > &diff_time);
> > +			if (diff_time.tv_sec > 0)
> > +				return CHECKER_RUNNING;
> > +		}
> > +	}
> >  	vector_foreach_slot(vecs->pathvec, pp, i) {
> > -		if (pp->is_checked)
> > +		if (pp->mpp || pp->is_checked)
> >  			continue;
> >  		pp->is_checked = true;
> > -		if (pp->mpp)
> > -			rc = check_path(vecs, pp, ticks,
> > start_time.tv_sec);
> > -		else
> > -			rc = handle_uninitialized_path(vecs, pp,
> > ticks);
> > +
> > +		rc = handle_uninitialized_path(vecs, pp, ticks);
> >  		if (rc < 0)
> >  			i--;
> >  		else
> > @@ -2871,7 +2909,7 @@ checkerloop (void *ap)
> >  			lock(&vecs->lock);
> >  			pthread_testcancel();
> >  			vector_foreach_slot(vecs->mpvec, mpp, i)
> > -				mpp->is_checked = false;
> > +				mpp->synced_count = 0;
> 
> Why do we need to reset this? Can't we just increment the counter
> whenever we sync, and let it wrap at UINT_MAX?

We need to restart looping through the mpp paths whenever
mpp->synced_count has changed, but we only call do_check_mpp() in
do_check_path() if mpp->synced_count is 0, since we only want to do that
once per time we check the mpp. I should probably rename that
to do_sync_mpp().

> >  			if (checker_state == CHECKER_STARTING) {
> >  				vector_foreach_slot(vecs->mpvec,
> > mpp, i)
> >  					check_mpp(vecs, mpp, ticks);

