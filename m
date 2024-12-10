Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC3C2451D3
	for <dm-devel@lists.linux.dev>; Tue, 10 Dec 2024 23:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733873467; cv=none; b=Aronjzr25zZNPgbOVj+nDyz165M1byFb54bDLzDk+oLuVC0eYYLh1gCs/ZH/OnheiFDmDmiOS19AnFhj44sFYp9cuVbHWY7AQi0i3Q23Xo3jvzKKTe/XYPGe386HgPNLUusDt4mVsh+ffwA8J7OZwXiDW1+FFMXAK12O0dpVPiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733873467; c=relaxed/simple;
	bh=UPBoe7SrsoXs4WPuMfCDWuH2wAW40aprTZreYCQCByU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=aCToS4noVNd1WPu8z+VCLxEVUPTCU09qAAkkBjK3okUKHt7NisQo7Lw4hKhKGtdEIDM+vsBFT/tNP86e93+mfhiWUHtpVnsYOTQZVGwGb0HZrfPfAfy7MhGwM4Qf5U/A5E3Qk5zu0FsWFjjzvoNaIRh5ATTELKB+K6PFI4yFYDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ikUrQt6z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ikUrQt6z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733873464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rzl/fvvckUGMNAaHoxYcKD7mF0sLltN0K+xjYfAvN7w=;
	b=ikUrQt6zCeUTE6y1WlvInAOlxIwJNRPgefwT9d+Es/ca9A6cNj0zXybuI9SPFWtD2rHSDD
	e0rrn5jV6Vkt/p7g5N46uIh6Ss/k/maCSXgrnxfPux5BzeEBnSW2HCMCfpo2Iw8XQ3CE+o
	y8Gw5GfyxJiNmr9NYaggr75F2pzNgJI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-512-Tra-Mx7eMzmw2f7kALVfyg-1; Tue,
 10 Dec 2024 18:31:00 -0500
X-MC-Unique: Tra-Mx7eMzmw2f7kALVfyg-1
X-Mimecast-MFC-AGG-ID: Tra-Mx7eMzmw2f7kALVfyg
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 21ADB19560AA;
	Tue, 10 Dec 2024 23:30:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C407619560A2;
	Tue, 10 Dec 2024 23:30:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4BANUvwY1425622
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 10 Dec 2024 18:30:57 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4BANUv731425621;
	Tue, 10 Dec 2024 18:30:57 -0500
Date: Tue, 10 Dec 2024 18:30:57 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 03/13] multipathd: allow map removal in do_sync_mpp()
Message-ID: <Z1jPMVejcI61qP9z@redhat.com>
References: <20241206233617.382200-1-mwilck@suse.com>
 <20241206233617.382200-4-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20241206233617.382200-4-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zMKBsMXHF9hlvWlCgO0cCJH0B7T8WMdRPRKd6hGWS7I_1733873459
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 07, 2024 at 12:36:07AM +0100, Martin Wilck wrote:
> We previously didn't allow map removal inside the checker loop. But
> with the late updates to the checkerloop code, it should be safe to orphan
> paths and delete maps even in this situation. We remove such maps everywhere
> else in the code already, whenever refresh_multipath() or setup_multipath()
> is called.

Actually, thinking about this more, what do we get by proactively
deleting the multipath device if something goes wrong in the checker? If
we successfully reload a device, but can't sync it with the kernel,
that's one thing, But that was triggered by a change in the device, and
we know that when we reloaded the device, device-mapper was working. I'm
leery of possibly deleting the map because of a transient device-mapper
issue.  I'm not sure if on a check that we do repeatedly, we should
delete the device on an error.  We haven't in the past, and as far as I
know, it doesn't cause problems.  

Without a benefit to doing this, I'm not sure it makes sense.

-Ben

> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c | 43 ++++++++++++++++++++-----------------------
>  1 file changed, 20 insertions(+), 23 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 4a28fbb..131dab6 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2446,34 +2446,30 @@ get_new_state(struct path *pp)
>  	return newstate;
>  }
>  
> -static void
> -do_sync_mpp(struct vectors * vecs, struct multipath *mpp)
> +/* Returns true if the mpp was deleted */
> +static int
> +do_sync_mpp(struct vectors *vecs, struct multipath *mpp)
>  {
> -	int i, ret;
> -	struct path *pp;
> +	int ret;
> +
> +	ret = refresh_multipath(vecs, mpp);
> +	if (ret)
> +		return ret;
>  
> -	ret = update_multipath_strings(mpp, vecs->pathvec);
> -	if (ret != DMP_OK) {
> -		condlog(1, "%s: %s", mpp->alias, ret == DMP_NOT_FOUND ?
> -			"device not found" :
> -			"couldn't synchronize with kernel state");
> -		vector_foreach_slot (mpp->paths, pp, i)
> -			pp->dmstate = PSTATE_UNDEF;
> -		return;
> -	}
>  	set_no_path_retry(mpp);
> +	return 0;
>  }
>  
> -static void
> +static int
>  sync_mpp(struct vectors * vecs, struct multipath *mpp, unsigned int ticks)
>  {
>  	if (mpp->sync_tick)
>  		mpp->sync_tick -= (mpp->sync_tick > ticks) ? ticks :
>  				  mpp->sync_tick;
>  	if (mpp->sync_tick)
> -		return;
> +		return 0;
>  
> -	do_sync_mpp(vecs, mpp);
> +	return do_sync_mpp(vecs, mpp);
>  }
>  
>  static int
> @@ -2513,12 +2509,10 @@ update_path_state (struct vectors * vecs, struct path * pp)
>  		return handle_path_wwid_change(pp, vecs)? CHECK_PATH_REMOVED :
>  							  CHECK_PATH_SKIPPED;
>  	}
> -	if (pp->mpp->synced_count == 0) {
> -		do_sync_mpp(vecs, pp->mpp);
> +	if (pp->mpp->synced_count == 0 && do_sync_mpp(vecs, pp->mpp))
>  		/* if update_multipath_strings orphaned the path, quit early */
> -		if (!pp->mpp)
> -			return CHECK_PATH_SKIPPED;
> -	}
> +		return CHECK_PATH_SKIPPED;
> +
>  	if ((newstate != PATH_UP && newstate != PATH_GHOST &&
>  	     newstate != PATH_PENDING) && (pp->state == PATH_DELAYED)) {
>  		/* If path state become failed again cancel path delay state */
> @@ -3018,8 +3012,11 @@ checkerloop (void *ap)
>  				mpp->synced_count = 0;
>  			if (checker_state == CHECKER_STARTING) {
>  				vector_foreach_slot(vecs->mpvec, mpp, i) {
> -					sync_mpp(vecs, mpp, ticks);
> -					mpp->prio_update = PRIO_UPDATE_NONE;
> +					if (sync_mpp(vecs, mpp, ticks))
> +						/* map deleted */
> +						i--;
> +					else
> +						mpp->prio_update = PRIO_UPDATE_NONE;
>  				}
>  				vector_foreach_slot(vecs->pathvec, pp, i)
>  					pp->is_checked = CHECK_PATH_UNCHECKED;
> -- 
> 2.47.0

