Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A27A40C03
	for <dm-devel@lists.linux.dev>; Wed,  4 Sep 2024 19:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725479503; cv=none; b=I/O6egG8BHq30QXFEmtQ1X5WGUYKyHQsQXKXqTAayGRP6E2aBx4EfI3jmxZAQdqKnowZfYl6xZa1WtckSKBR6pPqrc5AeAgV5p5/ZxMYGcSPb+d/gjJVcH2/9Dezz87dO9f/CmhEpJcKJGJ74ny5ka0b8oKGy+eH5vun3WorB30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725479503; c=relaxed/simple;
	bh=f1a92Sg4DB9XgEYjRdM2Azcr6g8/nGGTipSJjEhJWVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=WSKYAscE1Hra5MZx2Awh9vRvap068UQXlocYL8sKKdOauvjJr0n0scjSYbaIo82rWB8D16ii/3PzuZqZ7/cxabFwsaqnPRh/NewRdnMCx7TdgI2sMPB1W5Zy45DSQjn8dzxy+qZVJWcazsDRY9W1hVf8/3AJLLrDTUWz5TI82+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d6qllKox; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d6qllKox"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725479500;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pDXq6gEquNIFWjVBEBTa5YeMi08b7E3AqY3EZi5QgTo=;
	b=d6qllKoxemzOqA1ZnDtsnyMFw7vpkXglXT1qbSEEGx0t/XhlHgtgKKFKU/o+zT99verKIa
	HMk3Ja6ERZm9dpEjzoIvRD+Px4sNl4eJ2zbNYdJm8AfwM6PRuBEj+KNSbUnl0VZ/7GQOdq
	mkkyxaE4yRm8d9NzgfX9+RtV5yJ7MmI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-352-o9eVN8szOqqTm--tWTHt3A-1; Wed,
 04 Sep 2024 15:51:39 -0400
X-MC-Unique: o9eVN8szOqqTm--tWTHt3A-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E397F1955D44;
	Wed,  4 Sep 2024 19:51:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 677DE19560AD;
	Wed,  4 Sep 2024 19:51:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 484JpaGw482046
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 4 Sep 2024 15:51:36 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 484Jpail482045;
	Wed, 4 Sep 2024 15:51:36 -0400
Date: Wed, 4 Sep 2024 15:51:36 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 13/15] multipathd: update priority once after updating
 all paths
Message-ID: <Zti6SP_4UI_z57Ws@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
 <20240828221757.4060548-14-bmarzins@redhat.com>
 <053e43b8586abc36dd19f2ffee14cb0b31edb14f.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <053e43b8586abc36dd19f2ffee14cb0b31edb14f.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Sep 04, 2024 at 08:57:46PM +0200, Martin Wilck wrote:
> On Wed, 2024-08-28 at 18:17 -0400, Benjamin Marzinski wrote:
> > Instead of updating the path priorities and possibly reloading the
> > multipath device when each path is updated, wait till all paths
> > have been updated, and then go through the multipath devices updating
> > the priorities once, reloading if necessary.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/structs.h |   9 +++
> >  multipathd/main.c      | 169 ++++++++++++++++++++++++++-------------
> > --
> >  2 files changed, 118 insertions(+), 60 deletions(-)
> > 
> > diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> > index af8e31e9..1f531d30 100644
> > --- a/libmultipath/structs.h
> > +++ b/libmultipath/structs.h
> > @@ -318,6 +318,7 @@ enum check_path_states {
> >  	CHECK_PATH_UNCHECKED,
> >  	CHECK_PATH_STARTED,
> >  	CHECK_PATH_CHECKED,
> > +	CHECK_PATH_NEW_UP,
> >  	CHECK_PATH_SKIPPED,
> >  	CHECK_PATH_REMOVED,
> >  };
> > @@ -421,6 +422,13 @@ enum prflag_value {
> >  	PRFLAG_SET,
> >  };
> >  
> > +enum prio_update_type {
> > +	PRIO_UPDATE_NONE,
> > +	PRIO_UPDATE_NORMAL,
> > +	PRIO_UPDATE_NEW_PATH,
> > +	PRIO_UPDATE_MARGINAL,
> > +};
> > +
> >  struct multipath {
> >  	char wwid[WWID_SIZE];
> >  	char alias_old[WWID_SIZE];
> > @@ -464,6 +472,7 @@ struct multipath {
> >  	int queue_mode;
> >  	unsigned int sync_tick;
> >  	int synced_count;
> > +	enum prio_update_type prio_update;
> >  	uid_t uid;
> >  	gid_t gid;
> >  	mode_t mode;
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 2bcc6066..1511f701 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -1996,15 +1996,13 @@ mpvec_garbage_collector (struct vectors *
> > vecs)
> >   * best pathgroup, and this is the first path in the pathgroup to
> > come back
> >   * up, then switch to this pathgroup */
> >  static int
> > -followover_should_failback(struct path * pp)
> > +do_followover_should_failback(struct path * pp)
> >  {
> >  	struct pathgroup * pgp;
> >  	struct path *pp1;
> >  	int i;
> >  
> > -	if (pp->mpp->pgfailback != -FAILBACK_FOLLOWOVER ||
> > -	    !pp->mpp->pg || !pp->pgindex ||
> > -	    pp->pgindex != pp->mpp->bestpg)
> > +	if (pp->pgindex != pp->mpp->bestpg)
> >  		return 0;
> 
> What happened to the !pp->pgindex test? Is it not necessary any more?

In followover_should_failback(), before calling this function, we test
if mpp->bestpg is 0 and return early if it is (because 0 is not a valid
pathgroup id).  Thus, if pp->pgindex equals mpp->bestpg (and we should
failback), it's obviously not zero. If it's not equal to mpp->bestpg,
then it doesn't matter what it is, because we aren't doing the
failback anyway. Right?

> 
> 
> >  
> >  	pgp = VECTOR_SLOT(pp->mpp->pg, pp->pgindex - 1);
> > @@ -2017,6 +2015,26 @@ followover_should_failback(struct path * pp)
> >  	return 1;
> >  }
> >  
> > +static int
> > +followover_should_failback(struct multipath *mpp)
> > +{
> > +	struct path *pp;
> > +	struct pathgroup * pgp;
> > +	int i, j;
> > +
> > +	if (mpp->pgfailback != -FAILBACK_FOLLOWOVER || !mpp->pg ||
> > !mpp->bestpg)
> > +		return 0;
> > +
> > +	vector_foreach_slot (mpp->pg, pgp, i) {
> > +		vector_foreach_slot (pgp->paths, pp, j) {
> > +			if (pp->is_checked == CHECK_PATH_NEW_UP &&
> > +			    do_followover_should_failback(pp))
> > +				return 1;
> > +		}
> > +	}
> > +	return 0;
> > +}
> > +
> >  static void
> >  missing_uev_wait_tick(struct vectors *vecs)
> >  {
> > @@ -2132,41 +2150,53 @@ partial_retrigger_tick(vector pathvec)
> >  	}
> >  }
> >  
> > -static int update_prio(struct path *pp, int force_refresh_all)
> > +static bool update_prio(struct multipath *mpp, bool refresh_all)
> >  {
> >  	int oldpriority;
> > -	struct path *pp1;
> > +	struct path *pp;
> >  	struct pathgroup * pgp;
> > -	int i, j, changed = 0;
> > +	int i, j;
> > +	bool changed = false;
> > +	bool skipped_path = false;
> >  	struct config *conf;
> >  
> > -	oldpriority = pp->priority;
> > -	if (pp->state != PATH_DOWN) {
> > -		conf = get_multipath_config();
> > -		pthread_cleanup_push(put_multipath_config, conf);
> > -		pathinfo(pp, conf, DI_PRIO);
> > -		pthread_cleanup_pop(1);
> > +	vector_foreach_slot (mpp->pg, pgp, i) {
> > +		vector_foreach_slot (pgp->paths, pp, j) {
> > +			if (pp->state != PATH_UP && pp->state !=
> > PATH_GHOST)
> > +				continue;
> 
> This test used to be pp->state == PATH_DOWN (see below).
> 
> Just trying to confirm that you did this on purpose. It might justify a
> separate patch, with rationale. After all, AFAICS, we will now keep the
> old priority for all path states except PATH_UP and PATH_GHOST, while
> previously we attempted to fetch the prio for most of them, and only
> used the previous value if fetching the prio failed.

In my understanding, we don't try getting the priority of failed paths
because some of the prioritizers can hang. On this grounds, if we are
excluding PATH_DOWN we should definitely also exclude PATH_SHAKY and
PATH_TIMEOUT and probably also PATH_DELAYED.

Also, since only paths that are in PATH_UP or PATH_GHOST are usable by
the kernel and contribute to the pathgroup's priority, not attempting to
update the priority of these other paths avoids the risk of hanging whil
not hurting anything (except that they might end up in the wrong
pathgroup during the time when they aren't usable, if you have
group_by_prio set).

Lastly, The way do_check_path() worked before this patchset was
inconsistent. If a path changed state to anything other than PATH_UP or
PATH_GHOST we skipped the prio update. However if the path kept the same
state we did the prio update, even if it wasn't PATH_UP or PATH_GHOST,
as long as it wasn't PATH_DOWN. That seems wrong.

But I'm fine with making these changes in a separate patch.

-Ben
 
> > +			if (!refresh_all &&
> > +			    pp->is_checked != CHECK_PATH_CHECKED) {
> > +				skipped_path = true;
> > +				continue;
> > +			}
> > +			oldpriority = pp->priority;
> > +			conf = get_multipath_config();
> > +			pthread_cleanup_push(put_multipath_config,
> > conf);
> > +			pathinfo(pp, conf, DI_PRIO);
> > +			pthread_cleanup_pop(1);
> > +			if (pp->priority != oldpriority)
> > +				changed = true;
> > +		}
> >  	}
> > -
> > -	if (pp->priority != oldpriority)
> > -		changed = 1;
> > -	else if (!force_refresh_all)
> > -		return 0;
> > -
> > -	vector_foreach_slot (pp->mpp->pg, pgp, i) {
> > -		vector_foreach_slot (pgp->paths, pp1, j) {
> > -			if (pp1 == pp || pp1->state == PATH_DOWN)
> > +	if (!changed || !skipped_path)
> > +		return changed;
> > +	/*
> > +	 * If a path changed priorities, refresh the priorities of
> > any
> > +	 * paths we skipped
> > +	 */
> > +	vector_foreach_slot (mpp->pg, pgp, i) {
> > +		vector_foreach_slot (pgp->paths, pp, j) {
> > +			if (pp->state != PATH_UP && pp->state !=
> > PATH_GHOST)
> > +				continue;
> > +			if (pp->is_checked == CHECK_PATH_CHECKED)
> >  				continue;
> > -			oldpriority = pp1->priority;
> >  			conf = get_multipath_config();
> >  			pthread_cleanup_push(put_multipath_config,
> > conf);
> > -			pathinfo(pp1, conf, DI_PRIO);
> > +			pathinfo(pp, conf, DI_PRIO);
> >  			pthread_cleanup_pop(1);
> > -			if (pp1->priority != oldpriority)
> > -				changed = 1;
> >  		}
> >  	}
> > -	return changed;
> > +	return true;
> >  }
> >  
> >  static int reload_map(struct vectors *vecs, struct multipath *mpp,
> > @@ -2393,14 +2423,12 @@ static int
> >  update_path_state (struct vectors * vecs, struct path * pp)
> >  {
> >  	int newstate;
> > -	int new_path_up = 0;
> >  	int chkr_new_path_up = 0;
> >  	int disable_reinstate = 0;
> >  	int oldchkrstate = pp->chkrstate;
> >  	unsigned int checkint, max_checkint;
> >  	struct config *conf;
> > -	int marginal_pathgroups, marginal_changed = 0;
> > -	bool need_reload;
> > +	int marginal_pathgroups;
> >  
> >  	conf = get_multipath_config();
> >  	checkint = conf->checkint;
> > @@ -2462,7 +2490,7 @@ update_path_state (struct vectors * vecs,
> > struct path * pp)
> >  			}
> >  			if (!pp->marginal) {
> >  				pp->marginal = 1;
> > -				marginal_changed = 1;
> > +				pp->mpp->prio_update =
> > PRIO_UPDATE_MARGINAL;
> >  			}
> >  		} else {
> >  			if (pp->marginal || pp->state ==
> > PATH_DELAYED)
> > @@ -2470,7 +2498,7 @@ update_path_state (struct vectors * vecs,
> > struct path * pp)
> >  					pp->dev);
> >  			if (marginal_pathgroups && pp->marginal) {
> >  				pp->marginal = 0;
> > -				marginal_changed = 1;
> > +				pp->mpp->prio_update =
> > PRIO_UPDATE_MARGINAL;
> >  			}
> >  		}
> >  	}
> > @@ -2537,7 +2565,8 @@ update_path_state (struct vectors * vecs,
> > struct path * pp)
> >  		 */
> >  		if (!disable_reinstate)
> >  			reinstate_path(pp);
> > -		new_path_up = 1;
> > +		if (pp->mpp->prio_update != PRIO_UPDATE_MARGINAL)
> > +			pp->mpp->prio_update = PRIO_UPDATE_NEW_PATH;
> >  
> >  		if (oldchkrstate != PATH_UP && oldchkrstate !=
> > PATH_GHOST)
> >  			chkr_new_path_up = 1;
> > @@ -2588,38 +2617,48 @@ update_path_state (struct vectors * vecs,
> > struct path * pp)
> >  				LOG_MSG(2, pp);
> >  		}
> >  	}
> > -
> > +	if (pp->mpp->prio_update == PRIO_UPDATE_NONE &&
> > +            (newstate == PATH_UP || newstate == PATH_GHOST))
> > +		pp->mpp->prio_update = PRIO_UPDATE_NORMAL;
> >  	pp->state = newstate;
> > +	return chkr_new_path_up ? CHECK_PATH_NEW_UP :
> > CHECK_PATH_CHECKED;
> > +}
> >  
> > -	if (pp->mpp->wait_for_udev)
> > -		return CHECK_PATH_CHECKED;
> > -	/*
> > -	 * path prio refreshing
> > -	 */
> > -	condlog(4, "path prio refresh");
> > -
> > -	if (marginal_changed) {
> > -		update_prio(pp, 1);
> > -		reload_and_sync_map(pp->mpp, vecs);
> > -	} else if (update_prio(pp, new_path_up) &&
> > -		   pp->mpp->pgpolicyfn == (pgpolicyfn
> > *)group_by_prio &&
> > -		   pp->mpp->pgfailback == -FAILBACK_IMMEDIATE) {
> > +static int
> > +update_mpp_prio(struct vectors *vecs, struct multipath *mpp)
> > +{
> > +	bool need_reload, changed;
> > +	enum prio_update_type prio_update = mpp->prio_update;
> > +	mpp->prio_update = PRIO_UPDATE_NONE;
> > +
> > +	if (mpp->wait_for_udev || prio_update == PRIO_UPDATE_NONE)
> > +		return 0;
> > +	condlog(4, "prio refresh");
> > +
> > +	changed = update_prio(mpp, prio_update !=
> > PRIO_UPDATE_NORMAL);
> > +	if (prio_update == PRIO_UPDATE_MARGINAL)
> > +		return reload_and_sync_map(mpp, vecs);
> > +	if (changed && mpp->pgpolicyfn == (pgpolicyfn
> > *)group_by_prio &&
> > +	    mpp->pgfailback == -FAILBACK_IMMEDIATE) {
> >  		condlog(2, "%s: path priorities changed. reloading",
> > -			pp->mpp->alias);
> > -		reload_and_sync_map(pp->mpp, vecs);
> > -	} else if (need_switch_pathgroup(pp->mpp, &need_reload)) {
> > -		if (pp->mpp->pgfailback > 0 &&
> > -		    (new_path_up || pp->mpp->failback_tick <= 0))
> > -			pp->mpp->failback_tick = pp->mpp->pgfailback
> > + 1;
> > -		else if (pp->mpp->pgfailback == -FAILBACK_IMMEDIATE
> > ||
> > -			 (chkr_new_path_up &&
> > followover_should_failback(pp))) {
> > +			mpp->alias);
> > +		return reload_and_sync_map(mpp, vecs);
> > +	}
> > +	if (need_switch_pathgroup(mpp, &need_reload)) {
> > +		if (mpp->pgfailback > 0 &&
> > +		    (prio_update == PRIO_UPDATE_NEW_PATH ||
> > +		     mpp->failback_tick <= 0))
> > +			mpp->failback_tick = mpp->pgfailback + 1;
> > +		else if (mpp->pgfailback == -FAILBACK_IMMEDIATE ||
> > +			 (prio_update == PRIO_UPDATE_NEW_PATH &&
> > +			  followover_should_failback(mpp))) {
> >  			if (need_reload)
> > -				reload_and_sync_map(pp->mpp, vecs);
> > +				return reload_and_sync_map(mpp,
> > vecs);
> >  			else
> > -				switch_pathgroup(pp->mpp);
> > +				switch_pathgroup(mpp);
> >  		}
> >  	}
> > -	return CHECK_PATH_CHECKED;
> > +	return 0;
> >  }
> >  
> >  static int
> > @@ -2859,7 +2898,7 @@ update_paths(struct vectors *vecs, int
> > *num_paths_p, time_t start_secs)
> >  			i--;
> >  		else {
> >  			pp->is_checked = rc;
> > -			if (rc == CHECK_PATH_CHECKED)
> > +			if (rc == CHECK_PATH_CHECKED ||
> > CHECK_PATH_NEW_UP)
> >  				(*num_paths_p)++;
> >  		}
> >  		if (++paths_checked % 128 == 0 &&
> > @@ -2932,8 +2971,10 @@ checkerloop (void *ap)
> >  			vector_foreach_slot(vecs->mpvec, mpp, i)
> >  				mpp->synced_count = 0;
> >  			if (checker_state == CHECKER_STARTING) {
> > -				vector_foreach_slot(vecs->mpvec,
> > mpp, i)
> > +				vector_foreach_slot(vecs->mpvec,
> > mpp, i) {
> >  					sync_mpp(vecs, mpp, ticks);
> > +					mpp->prio_update =
> > PRIO_UPDATE_NONE;
> > +				}
> >  				vector_foreach_slot(vecs->pathvec,
> > pp, i)
> >  					pp->is_checked =
> > CHECK_PATH_UNCHECKED;
> >  				checker_state =
> > CHECKER_CHECKING_PATHS;
> > @@ -2943,6 +2984,14 @@ checkerloop (void *ap)
> >  			if (checker_state == CHECKER_UPDATING_PATHS)
> >  				checker_state = update_paths(vecs,
> > &num_paths,
> >  							    
> > start_time.tv_sec);
> > +			if (checker_state == CHECKER_FINISHED) {
> > +				vector_foreach_slot(vecs->mpvec,
> > mpp, i) {
> > +					if (update_mpp_prio(vecs,
> > mpp) == 2) {
> > +						/* multipath device
> > deleted */
> > +						i--;
> > +					}
> > +				}
> > +			}
> >  			lock_cleanup_pop(vecs->lock);
> >  			if (checker_state != CHECKER_FINISHED) {
> >  				/* Yield to waiters */

