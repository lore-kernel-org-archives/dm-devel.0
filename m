Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538C01BFE10
	for <dm-devel@lists.linux.dev>; Fri, 24 Jan 2025 21:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737752716; cv=none; b=lSTBimvToHteofYuH4OxPdIbohTt4Yr6yDifWmE7vS+dCfZbU2oNJwt+LtnhBfKEpoka0cevYzXoSmuOmXLX1YOAXhKKA7DaReRYWXJFq86B1h9UzeuWqplBWK6jBvTtNbpHm0x3M3aMhBc7pmnr9vxB+UWrB9iuGARrcNhorV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737752716; c=relaxed/simple;
	bh=rreqlxUa6wCF+Fn4HYTE7L2q/96sXinnPUGrUXmwaDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=UQ+86zQRcYtXIYFQVqK5VbYt997tFRZ1SWpkhcJViOpSaaXIwZxiroj1y60HhkwOdVLKL87MLdwlzH2uuEPSDiY1sTkVfmyggi8Rza2TyKlPKhcy2JnFYACEIMwHrTxOmPrxGCm0rq8wnZOgMY9irg7dbntP0NY2+wFGlfMv/F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y0/coIgE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y0/coIgE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737752713;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0ECzjARL6mJ8TauZ27KLToc7y2ntv084/gDX/BOdlMM=;
	b=Y0/coIgEAMeLZ7uxUusxSy7DWWnEyONb2ijmCKAFq620j05rApzBIuWU+HeGdtNW4kDEJG
	ZW+xyFmVjART+dv9TlWi4YymSDfYrld/W/S0YwUhaHHTLOIUOfFgUOKcjBwarFHYtH86sb
	qFV2/uw9zIzgCa78T9mH/sCK2Ap1z8s=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-444-51sZH43EP1emp4QtwmJaNg-1; Fri,
 24 Jan 2025 16:05:11 -0500
X-MC-Unique: 51sZH43EP1emp4QtwmJaNg-1
X-Mimecast-MFC-AGG-ID: 51sZH43EP1emp4QtwmJaNg
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E7470195608A;
	Fri, 24 Jan 2025 21:05:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7F40118008CC;
	Fri, 24 Jan 2025 21:05:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 50OL57CL3228175
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 24 Jan 2025 16:05:07 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 50OL57X23228174;
	Fri, 24 Jan 2025 16:05:07 -0500
Date: Fri, 24 Jan 2025 16:05:07 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] multipathd: trigger uevents for blacklisted paths in
 reconfigure
Message-ID: <Z5QAgyfmjl5XXCKO@redhat.com>
References: <20250123221212.123833-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250123221212.123833-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xe_hza9RFmNs4iIDHC-vdfQEzupmhyEK0i8WH8fBh_Q_1737752710
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 23, 2025 at 11:12:12PM +0100, Martin Wilck wrote:
> If multipathd has already configured maps, and the user changes the
> blacklist or other parameters that cause currently multipathed
> devices to be skipped, and then runs "multipathd reconfigure"
> or restarts multipathd, multipathd flushes the maps in question,
> but doesn't trigger uevents for the now-blacklisted paths.
> 
> This is because the blacklisted paths are removed from the discovered
> maps internally when update_pathvec_from_dm() is called through
> map_discovery() and update_multipath_table(); when later
> trigger_paths_udev_change() is called from coalesce_maps(), the
> map contains no paths for which an uevent could be triggered.
> 
> The map_discovery() code flow is special, because we will call
> coalesce_paths() afterwards anyway and reconstruct the mpvec. Unlike the
> regular code flow, we don't want the maps to be "corrected" in this
> case, because the maps discovered here aren't going to be reloaded.
> We just want update_pathvec_from_dm() to populate the pathvec.
> 
> Therefore add a new flag DI_DISCOVERY, which is only set when
> update_multipath_table() is called from map_discovery(), and if
> this flag is set, keep PATHINFO_SKIPPED paths in the map's table in
> update_pathvec_from_dm(). Later on, the paths will still be visible
> in the old mpp (ompp) in coalesce_maps(), and uevents will be
> triggered for them to release them to systemd.
> 
> We can't always do this for PATHINFO_SKIPPED, because in some cases
> paths may be accepted in a map first and SKIPPED later (for example if
> the WWID wasn't yet available at startup). Therefore the special
> case for DI_DISCOVERY is necessary.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  libmultipath/discovery.h   | 2 ++
>  libmultipath/structs_vec.c | 6 +++++-
>  multipathd/main.c          | 2 +-
>  3 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
> index c4a8dd9..2b39eb0 100644
> --- a/libmultipath/discovery.h
> +++ b/libmultipath/discovery.h
> @@ -74,6 +74,7 @@ enum discovery_mode {
>  	DI_BLACKLIST__,
>  	DI_NOIO__,
>  	DI_NOFALLBACK__,
> +	DI_DISCOVERY__,
>  };
>  
>  #define DI_SYSFS	(1 << DI_SYSFS__)
> @@ -84,6 +85,7 @@ enum discovery_mode {
>  #define DI_BLACKLIST	(1 << DI_BLACKLIST__)
>  #define DI_NOIO		(1 << DI_NOIO__) /* Avoid IO on the device */
>  #define DI_NOFALLBACK	(1 << DI_NOFALLBACK__) /* do not allow wwid fallback */
> +#define DI_DISCOVERY	(1 << DI_DISCOVERY__) /* set only during map discovery */
>  
>  #define DI_ALL		(DI_SYSFS  | DI_IOCTL | DI_CHECKER | DI_PRIO | DI_WWID)
>  
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index b2bb47c..7d53aa3 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -107,6 +107,9 @@ static void update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
>  	bool mpp_has_wwid;
>  	bool must_reload = false;
>  	bool pg_deleted = false;
> +	bool map_discovery = !!(pathinfo_flags & DI_DISCOVERY);
> +
> +	pathinfo_flags &= ~DI_DISCOVERY;
>  
>  	if (!mpp->pg)
>  		return;
> @@ -193,7 +196,8 @@ static void update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
>  					rc = pathinfo(pp, conf,
>  						      DI_SYSFS|DI_WWID|DI_BLACKLIST|DI_NOFALLBACK|pathinfo_flags);
>  					pthread_cleanup_pop(1);
> -					if (rc != PATHINFO_OK) {
> +					if (rc == PATHINFO_FAILED ||
> +					    (rc == PATHINFO_SKIPPED && !map_discovery)) {
>  						condlog(1, "%s: error %d in pathinfo, discarding path",
>  							pp->dev, rc);
>  						vector_del_slot(pgp->paths, j--);
> diff --git a/multipathd/main.c b/multipathd/main.c
> index b4a366e..43a0240 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1758,7 +1758,7 @@ map_discovery (struct vectors * vecs)
>  		return 1;
>  
>  	vector_foreach_slot (vecs->mpvec, mpp, i)
> -		if (update_multipath_table(mpp, vecs->pathvec, 0) != DMP_OK) {
> +		if (update_multipath_table(mpp, vecs->pathvec, DI_DISCOVERY) != DMP_OK) {
>  			vector_del_slot(vecs->mpvec, i--);
>  			remove_map(mpp, vecs->pathvec);
>  		}
> -- 
> 2.48.1

