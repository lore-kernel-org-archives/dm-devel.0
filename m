Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B063C215767
	for <dm-devel@lists.linux.dev>; Wed, 22 Jan 2025 18:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737569713; cv=none; b=UfcKrZElwzCXP7pfvKc0tRr94tYjMQIOBk7JhZv0sRx9sB3+fKLT2fQc0x7p0yQ3jdpWsdcrDnlJkJ0lSnEu6v3UrA0JDMRehuR1LapnrubSiRBIOCpnyHR03RaoUIzvbJLhR2YVAPHxeRGDwHT9sTidrZqqtAXD6LBPMg8ZAJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737569713; c=relaxed/simple;
	bh=av6DQjzIWOKRx+hewf1XE/KXJk/uFbwZsrTrJbSV/mY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=V1OJNvbjn8LCdw8kO1G2QIpsTVTvI3GdQoUYpr7prcGPAddLJQUgbFs7qKsz+72m62xLo76WeABedCiQtl5O5/Tk4qgYo9GgsM42YoLN6orlPLtW0QW8dneVG4b1UrX9mw1ErdnG8GHcWAL7yWNtXzBUwpLVSifaBabmlL1+nhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a0K4k3vC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a0K4k3vC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737569710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JAO1OsADZVekxtDltwlIQpQR7kI7qhm27ghzkPCWvJQ=;
	b=a0K4k3vCWHQWaPBaFSMeQddNsOPOk+WKTsBGL/7HuWi1AF9zf6HzMYe9hlx6uhsDhWqK34
	dCNUeNIC2lVPaPGW7kvjRQXwtKpIWiNOi5T5TducovjV1N1QuV5dPZoaToo/Li9Rro9As1
	m4tsQpHkvbAWTQPiFw1xGFUlwWRgGfI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-510-U6Pt4InNPdiiC2V4wYOpdQ-1; Wed,
 22 Jan 2025 13:15:06 -0500
X-MC-Unique: U6Pt4InNPdiiC2V4wYOpdQ-1
X-Mimecast-MFC-AGG-ID: U6Pt4InNPdiiC2V4wYOpdQ
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 006EB1956050;
	Wed, 22 Jan 2025 18:15:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 76CB43003E7F;
	Wed, 22 Jan 2025 18:15:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 50MIF3PD3003932
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 13:15:03 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 50MIF2xQ3003931;
	Wed, 22 Jan 2025 13:15:02 -0500
Date: Wed, 22 Jan 2025 13:15:02 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v3 03/15] multipathd: sync maps at end of checkerloop
Message-ID: <Z5E1pvEjzv-wnK6h@redhat.com>
References: <20250117202738.126196-1-mwilck@suse.com>
 <20250117202738.126196-4-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250117202738.126196-4-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OAOaYnOU8HCsuOBlP563g7G8OiRvwr0NrgL2B0f30gQ_1737569705
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 17, 2025 at 09:27:26PM +0100, Martin Wilck wrote:
> Rather than calling sync_mpp early in the checkerloop and tracking
> map synchronization with synced_count, call sync_mpp() in the CHECKER_FINISHED
> state, if either at least one path of the map has been checked in the current
> iteration, or the sync tick has expired. This avoids potentially deleting
> paths from the pathvec through the do_sync_mpp() -> update_multipath_strings()
> -> sync_paths -> check_removed_paths() call chain while we're iterating over
> the pathvec. Also, the time gap between obtaining path states and syncing
> the state with the kernel is smaller this way.
> 
> Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  libmultipath/structs.h     |  2 +-
>  libmultipath/structs_vec.c |  1 -
>  multipathd/main.c          | 26 +++++++++++---------------
>  3 files changed, 12 insertions(+), 17 deletions(-)
> 
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index 6a30c59..9d22bdd 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -471,7 +471,7 @@ struct multipath {
>  	int ghost_delay_tick;
>  	int queue_mode;
>  	unsigned int sync_tick;
> -	int synced_count;
> +	int checker_count;
>  	enum prio_update_type prio_update;
>  	uid_t uid;
>  	gid_t gid;
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index 7a4e3eb..6aa744d 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -530,7 +530,6 @@ update_multipath_table (struct multipath *mpp, vector pathvec, int flags)
>  	conf = get_multipath_config();
>  	mpp->sync_tick = conf->max_checkint;
>  	put_multipath_config(conf);
> -	mpp->synced_count++;
>  
>  	r = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
>  			  (mapid_t) { .str = mpp->alias },
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 4a28fbb..e4e6bf7 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2470,7 +2470,7 @@ sync_mpp(struct vectors * vecs, struct multipath *mpp, unsigned int ticks)
>  	if (mpp->sync_tick)
>  		mpp->sync_tick -= (mpp->sync_tick > ticks) ? ticks :
>  				  mpp->sync_tick;
> -	if (mpp->sync_tick)
> +	if (mpp->sync_tick && !mpp->checker_count)
>  		return;
>  
>  	do_sync_mpp(vecs, mpp);
> @@ -2513,12 +2513,6 @@ update_path_state (struct vectors * vecs, struct path * pp)
>  		return handle_path_wwid_change(pp, vecs)? CHECK_PATH_REMOVED :
>  							  CHECK_PATH_SKIPPED;
>  	}
> -	if (pp->mpp->synced_count == 0) {
> -		do_sync_mpp(vecs, pp->mpp);
> -		/* if update_multipath_strings orphaned the path, quit early */
> -		if (!pp->mpp)
> -			return CHECK_PATH_SKIPPED;
> -	}
>  	if ((newstate != PATH_UP && newstate != PATH_GHOST &&
>  	     newstate != PATH_PENDING) && (pp->state == PATH_DELAYED)) {
>  		/* If path state become failed again cancel path delay state */
> @@ -2918,9 +2912,11 @@ check_paths(struct vectors *vecs, unsigned int ticks)
>  	vector_foreach_slot(vecs->pathvec, pp, i) {
>  		if (pp->is_checked != CHECK_PATH_UNCHECKED)
>  			continue;
> -		if (pp->mpp)
> +		if (pp->mpp) {
>  			pp->is_checked = check_path(pp, ticks);
> -		else
> +			if (pp->is_checked == CHECK_PATH_STARTED)
> +				pp->mpp->checker_count++;
> +		} else
>  			pp->is_checked = check_uninitialized_path(pp, ticks);
>  		if (pp->is_checked == CHECK_PATH_STARTED &&
>  		    checker_need_wait(&pp->checker))
> @@ -3014,12 +3010,10 @@ checkerloop (void *ap)
>  			pthread_cleanup_push(cleanup_lock, &vecs->lock);
>  			lock(&vecs->lock);
>  			pthread_testcancel();
> -			vector_foreach_slot(vecs->mpvec, mpp, i)
> -				mpp->synced_count = 0;
>  			if (checker_state == CHECKER_STARTING) {
>  				vector_foreach_slot(vecs->mpvec, mpp, i) {
> -					sync_mpp(vecs, mpp, ticks);
>  					mpp->prio_update = PRIO_UPDATE_NONE;
> +					mpp->checker_count = 0;
>  				}
>  				vector_foreach_slot(vecs->pathvec, pp, i)
>  					pp->is_checked = CHECK_PATH_UNCHECKED;
> @@ -3032,11 +3026,13 @@ checkerloop (void *ap)
>  							     start_time.tv_sec);
>  			if (checker_state == CHECKER_FINISHED) {
>  				vector_foreach_slot(vecs->mpvec, mpp, i) {
> -					if ((update_mpp_prio(mpp) ||
> -					     (mpp->need_reload && mpp->synced_count > 0)) &&
> -					    reload_and_sync_map(mpp, vecs) == 2)
> +					sync_mpp(vecs, mpp, ticks);
> +					if ((update_mpp_prio(mpp) || mpp->need_reload) &&
> +					    reload_and_sync_map(mpp, vecs) == 2) {
>  						/* multipath device deleted */
>  						i--;
> +						continue;
> +					}
>  				}
>  			}
>  			lock_cleanup_pop(vecs->lock);
> -- 
> 2.47.1

