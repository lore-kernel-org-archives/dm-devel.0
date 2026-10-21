Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792555680;
	b=t6+T9ZUoDBPSm04cyaaVUUv782WFCa+TE6JtDH+ajAD7TvCaaIMggmRgyxhTbJtbTbkv
	 xWZgOUY0mXaJchk1VamW4n6/SZoPgraFJgZvFmKIADisUxoEjAww392IRBDe4Okx2J0Zv
	 GQsIFjQnEVUVkyKn3XalKH4dmGAk1vYTKL1Miez4MqqrKk4R0TCtVlbFivFGhVOesY4+c
	 w4tyJ59QW5K+FOgR0H4JdIBCB18EX+O5duVK9I4ZkOWowi+SywtPD2N2ReGu/HOrouPER
	 g0dNisVV8P4ODbKXux77HCq362OtZxDzZRhm1mldRxYXun+SOBc4X3QRonbQtfTWCeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792555680;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition;
	bh=LpCPRR21pF4lu9AhA/Lwlh1d1d85sxH+xu5ZZBQ1yRY=;
	b=qoSPRIcQA7rxAyFfTb+8RqxYw7Abr64V8svh/7wNBdB3JlHYe5E4MfFlMSBAvppVg+0t
	 HLbwMWRij6StACazds3/Qikuuo4yGwzJvfDmWMK/Og1nvVq4z5hmkAxUGDsYVA/0CQmih
	 YzqtAnB+cxnFJetwxwuKfJDTXyCgtyyGqOarYP6se+/GM04DkHY+T7K6dXOxtKk+mqMlU
	 ljWBdoAyr1em1BILq3UACKUBKWJH2UAxp6+WZqjlIp8ZYRP9luLPjsQxw64jE+jl0pvfl
	 HwEZZnAtkkHaPhukX570+B9SHz1eGgsuiuRfQqKvD/iSVpQPoU28h/GSmyVU1GgkX8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YPyQcnE+;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5975606A31A
	for <dm-devel@lists.linux.dev>; Wed, 21 Oct 2026 04:07:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5975606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YPyQcnE+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792555678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LpCPRR21pF4lu9AhA/Lwlh1d1d85sxH+xu5ZZBQ1yRY=;
	b=YPyQcnE+OKaYBzscleLqvObhOs9DXu2DQ9+lzatokO0ARHDuneCqmqTUXA885VhY8RFxO4
	IGTELMP06/LII4CgwrcQQk1/X9g+Vrg3AQ+klHCMLm5vM03cV8Tztri+IgPu0TIBTYviQe
	hVL6tqoc6zBh6TCD2Tv44JHdoRMhHFU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-369-W1pPqTvSNIyEzgSH7GKJHw-1; Wed,
 21 Oct 2026 04:07:54 +0000
X-MC-Unique: W1pPqTvSNIyEzgSH7GKJHw-1
X-Mimecast-MFC-AGG-ID: W1pPqTvSNIyEzgSH7GKJHw_1792555673
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 77FA91956067;
	Wed, 21 Oct 2026 04:07:53 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D2B377E9;
	Wed, 21 Oct 2026 04:07:50 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 69L47nex3402574
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 00:07:49 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 69L47jr83402213;
	Wed, 21 Oct 2026 00:07:45 -0400
Date: Wed, 21 Oct 2026 00:07:45 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Brian Bunker <brian@purestorage.com>
Cc: dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 1/1] multipathd: don't leave maps read-only after write
 protect is cleared
Message-ID: <atg6kVbZJSLoBLTA@redhat.com>
References: <20261020204841.50459-1-brian@purestorage.com>
 <20261020204841.50459-2-brian@purestorage.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261020204841.50459-2-brian@purestorage.com>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZOLQyfd3WryXwR5yt8pbtHUx51oOdk47fx6IA39VXF0_1792555673
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 20, 2026 at 01:48:39PM -0700, Brian Bunker wrote:
> ev_add_path() sets mpp->force_readonly when a newly added path is
> read-only, but never clears it. If a map is created or reloaded while
> its storage is write protected, the flag stays set. When write protect
> is cleared, the reload that uev_update_path() does for the DISK_RO=0
> uevent uses the stale flag and loads the map read-only, even though all
> of its paths are read-write. uev_update_path() clears the flag after
> that reload, so the map only recovers if another DISK_RO=0 uevent
> reloads it again. If none comes, the map stays read-only, and since
> mpp->dmi.read_only is then 1, needs_ro_update() also ignores later
> DISK_RO=1 uevents for it.
> 
> Add a helper, map_has_ro_path(), that checks whether any of a map's
> paths is read-only in sysfs, and use it to set force_readonly:
> 
> - In ev_add_path(), set force_readonly from all of the map's paths
>   rather than only the path being added, and clear it once the map has
>   been loaded, as uev_update_path() already does after its reload. With
>   need_do_map == 0 the flag is left set for the call that loads the map.
> 
> - In uev_update_path(), set force_readonly from the paths' current
>   state in sysfs instead of from the uevent. The kernel updates the ro
>   attribute before it sends the DISK_RO uevent, so sysfs is current
>   when the uevent is handled.
> 
> - In update_map(), which does reloads that were delayed while the map
>   was waiting for udev (UDEV_WAIT_RELOAD), recompute force_readonly
>   before setting up the map, since the paths' state may have changed
>   since it was last set.
> 
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> ---
>  multipathd/main.c | 44 +++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 37 insertions(+), 7 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 9bce4d6b..68916256 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -709,6 +709,22 @@ void cleanup_reset_vec(struct vector_s **v)
>  	vector_reset(*v);
>  }
>  
> +static int sysfs_get_ro(struct path *pp);
> +
> +/* A map must be loaded read-only if any of its paths is read-only. */
> +static bool
> +map_has_ro_path(struct multipath *mpp)
> +{
> +	struct path *pp;
> +	unsigned int i;
> +

In multipathd, you can't trust mpp->paths to be up to date unless you
know that you've called update_mpp_paths() after acquiring the vecs
lock. I don't believe that's the case for uev_update_path(). Instead
this should use:

        vector_foreach_slot (mpp->pg, pgp, i) {
                vector_foreach_slot (pgp->paths, pp, j) {


> +	vector_foreach_slot (mpp->paths, pp, i) {
> +		if (sysfs_get_ro(pp) == 1)
> +			return true;
> +	}
> +	return false;
> +}
> +
>  static int
>  update_map (struct multipath *mpp, struct vectors *vecs, int new_map)
>  {
> @@ -732,6 +748,13 @@ retry:
>  
>  	mpp->action = ACT_RELOAD;
>  
> +	/*
> +	 * This may be a delayed reload, and the paths' write protect
> +	 * state may have changed since force_readonly was last set.
> +	 * Recompute it from the current paths.
> +	 */
> +	mpp->force_readonly = map_has_ro_path(mpp);
> +
>  	if (setup_map(mpp, &params, vecs)) {
>  		condlog(0, "%s: failed to setup new map in update", mpp->alias);
>  		retries = -1;
> @@ -1305,7 +1328,6 @@ ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
>  	int retries = 3;
>  	int start_waiter = 0;
>  	int ret;
> -	int ro;
>  	unsigned char prflag = PR_UNSET;
>  
>  	/*
> @@ -1370,10 +1392,11 @@ rescan:
>  			goto fail; /* leave path added to pathvec */
>  	}
>  
> -	/* ro check - if new path is ro, force map to be ro as well */
> -	ro = sysfs_get_ro(pp);
> -	if (ro == 1)
> -		mpp->force_readonly = 1;
> +	/*
> +	 * Load the map read-only if any of its paths is read-only,
> +	 * not just the one being added.
> +	 */
> +	mpp->force_readonly = map_has_ro_path(mpp);
>  

need_do_map is false when we are adding multiple paths at once, and only
want to reload once at the end (where we set it to true). Since we will
check all the paths ro state before doing the reload when need_do_map is
true, it seems safe to not check them all when need_do_map is false.
It's just extra work.


>  	if (!need_do_map)
>  		return 0;
> @@ -1400,6 +1423,8 @@ rescan:
>  		sleep(1);
>  		ret = domap(mpp, params, 1);
>  	}
> +	/* force_readonly only applies to this load, as in uev_update_path() */
> +	mpp->force_readonly = 0;

I think it may be better to remove this code from here and
uev_update_path(), and instead clear it in dm_addmap() on success, like
we do for mpp->nead_reload.

>  	if (ret == DOMAP_FAIL || ret == DOMAP_RETRY) {
>  		condlog(0, "%s: failed in domap for addition of new "
>  			"path %s", mpp->alias, pp->dev);
> @@ -1732,8 +1757,13 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
>  			if (mpp->wait_for_udev != UDEV_WAIT_DONE)
>  				mpp->wait_for_udev = UDEV_WAIT_RELOAD;
>  			else {
> -				if (ro == 1)
> -					pp->mpp->force_readonly = 1;
> +				/*
> +				 * force_readonly may be stale from ev_add_path().
> +				 * Set it from the paths' current state in sysfs,
> +				 * which the kernel updates before sending the
> +				 * uevent, rather than from the uevent itself.
> +				 */

Instead of calling this here, it might be better to set mpp->force_readonly
in needs_ro_update(), when it returns true. There are three cases in
that function which return true:

for "if (!has_dm_info(mpp))", it would have to call map_has_ro_path() to set
mpp->force_readonly correctly.

For "if (ro == 1)", it should unconditionally set mpp->force_readonly

for the final return, it could either leave it unset and trust that it
wasn't already set, or it could unconditionally clear it to be extra safe.

-Ben

> +				pp->mpp->force_readonly = map_has_ro_path(mpp);
>  				retval = reload_and_sync_map(mpp, vecs);
>  				if (retval == 2)
>  					condlog(2, "%s: map removed during reload", pp->dev);
> -- 
> 2.56.0

