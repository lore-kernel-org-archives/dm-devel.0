Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793309267;
	b=dIXqX2jogXHsbsC5u2etMhNDwu8EcXrsZCY9e9Z24C4qoz7VCgGF1JjvANz8DADWlLZp
	 3E70UIpdaVcbnllcLl4c7l15+71yxs1SZJHyLtmj3Tbugoqi0wXFQJNb5xdG/552wO+51
	 FFSBvr6nYWqOMXTUF8pMuLe1OUYdcM3Sr+ToUjddapQA3wdphsyNW7GQ0LMN5ga0Ho2Do
	 lM9PeqvIaktj7CDWM7sZ33B3Lt3szlVHnGOC7P7bO0cZLZ8Cl6uTnpKPnebnZ/ztl3of+
	 +eY3oaX/qUTprieSkE5A1YJmyzMgKcvI+QgZ2vZHPIVZAFjOitSD1Mh3QQKssYdxuPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793309267;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition;
	bh=GrDsjidFYE5PeCQkjmW7oWsevDhJRHOIv7g3iakVUYs=;
	b=umpQg/YCEKo5cAa9wOSw8FIFaYSdW/AxKobJXyP74BnKg7VWslcrc3/Iyx0wnRCHQD25
	 TZzEQos7iVkNccThKSG7Fxj7GONKNwv0BahM+Y+/+OJJZ5FFO6R0FudGD0uaFt6U+pQWF
	 Z0vXeIgsVZDH+mdEyn/X4iw6JFPTg5KoXlhfPgtNjqF6YH9d30/v6HdERQZH0bll9UCwf
	 zUB97fzd6wTKHVb3u1IG+UFWdJI8H48xm6cohZfcA7sMrw8t6RIkshKvcfC7FC0BFe6L3
	 e6u0KFrDwMJYI+/cbp9CdrLMXbWRYhp6nckHU7JjjVzN7jabyG4zT/SvCJli6ZLH4TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Ex1h6U+g;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A33C606A31A
	for <dm-devel@lists.linux.dev>; Thu, 29 Oct 2026 21:27:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A33C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Ex1h6U+g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793309266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GrDsjidFYE5PeCQkjmW7oWsevDhJRHOIv7g3iakVUYs=;
	b=Ex1h6U+gTyiRQfuxYKbj3XAfVZpmwUJ1QhNbN3WJw45g/vb/nIIwNyjaUxQPPEQ6R9A4Ds
	cRjigYB0EFahq6i8ZHbiEV3nR8zj5Un/838I7cs6hAUyozGOfYT1I+GN8myqm1LC73vvhp
	u5vGYKceCrNUKqz7Rcpx/gOuKR8aOmo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-467-BNjcgul_NVKcFwOVXvkZJA-1; Thu,
 29 Oct 2026 17:27:43 -0400
X-MC-Unique: BNjcgul_NVKcFwOVXvkZJA-1
X-Mimecast-MFC-AGG-ID: BNjcgul_NVKcFwOVXvkZJA_1793309262
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BD9EC19560B2;
	Thu, 29 Oct 2026 21:27:41 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 397F130001A4;
	Thu, 29 Oct 2026 21:27:41 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 69TLReBK780714
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 29 Oct 2026 17:27:40 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 69TLRd8H780713;
	Thu, 29 Oct 2026 17:27:39 -0400
Date: Thu, 29 Oct 2026 17:27:39 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Brian Bunker <brian@purestorage.com>
Cc: dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v1 1/1] multipathd: verify udev WWIDs with the device
 before moving paths
Message-ID: <auO6S56Jdjpxh8Bh@redhat.com>
References: <20261029175727.25457-1-brian@purestorage.com>
 <20261029175727.25457-2-brian@purestorage.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261029175727.25457-2-brian@purestorage.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hk34Z8aGVJTpVLCQT2Te1ZRv1efzeELXMDx69oBn2iA_1793309262
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 29, 2026 at 10:57:27AM -0700, Brian Bunker wrote:
> multipathd takes a path's WWID from udev. When a change uevent reports
> a different WWID, uev_update_path() removes the path from its map and
> re-adds it through uev_add_path(), which places it in whatever map owns
> the new WWID. Nothing checks the new value against the device itself;
> recheck_wwid only covers paths coming back up in the checker and
> "multipathd add path". If udev reports the wrong WWID, or the uevent is
> stale by the time it is processed, the path goes into the map of a
> different LUN and I/O for one LUN is silently sent to another.
> 
> Use SG_IO to read VPD page 0x83 from the device in two places, for
> paths where can_recheck_wwid() is true:
> 
> - In uev_update_path(), if the device still reports the cached WWID,
>   ignore the udev value and leave the path where it is.
> 
> - In ev_add_path(), refuse to add a path whose WWID the device doesn't
>   confirm. The path is orphaned, its WWID is cleared and it is marked
>   INIT_MISSING_UDEV, so the checker retriggers udev (bounded by
>   retrigger_tries) and the path is re-added from fresh data.
> 
> ev_add_path() is the common point for uevent, CLI and checker adds, so
> the second check holds even when the udev data is stale by the time it
> is used. If the SG_IO read fails, behavior is unchanged.
> 
> Split the SG_IO read out of check_path_wwid_change() into
> get_sgio_wwid() so all three checks share it.

The code all looks good to me. I must admit, I'm a little paranoid about
forcing perfectly normal ev_add_path() calls to double-check the wwid.
Currently, that only happens if you enable "recheck_wwid", or if
something is going wrong with initializing the path. The issue is that
scsi devices can have multiple wwids, and the multipath code has to be
in sync with the code that udev runs to the wwid, otherwise they can be
different. I don't think these functions differ. I know I've checked
them in the past. But unless there is a problem getting the wwid from
udev or someone turns on recheck_wwid (I don't know how common that is)
paths don't ever run this code. 

We could avoid this by hijacking the need_do_map argument to
uev_add_path() and ev_add_path(). If, instead of just being 0 or 1, it
could also be a third value for reinits (we should probably use an enum
in this case), we could only double-check the wwid on reinits, which
only happen when there is an issue getting the wwid from udev.

Thoughts? Am I just being paranoid here?

-Ben
 
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> ---
>  multipathd/main.c | 57 ++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 52 insertions(+), 5 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 9bce4d6b..656efb6e 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1086,14 +1086,16 @@ handle_path_wwid_change(struct path *pp, struct vectors *vecs)
>  	return removed;
>  }
>  
> -bool
> -check_path_wwid_change(struct path *pp)
> +/*
> + * Read the WWID directly from the device with SG_IO, bypassing udev
> + * and sysfs. Returns true and fills in wwid on success.
> + */
> +static bool get_sgio_wwid(struct path *pp, char *wwid)
>  {
> -	char wwid[WWID_SIZE];
> -	int len = 0;
> +	int len;
>  	size_t i;
>  
> -	if (!strlen(pp->wwid))
> +	if (pp->fd < 0)
>  		return false;
>  
>  	/* Get the real fresh device wwid by sgio. sysfs still has old
> @@ -1111,6 +1113,15 @@ check_path_wwid_change(struct path *pp)
>  		/* no-op */
>  	wwid[i] = '\0';
>  	condlog(4, "%s: Got wwid %s by sgio", pp->dev, wwid);
> +	return true;
> +}
> +
> +bool check_path_wwid_change(struct path *pp)
> +{
> +	char wwid[WWID_SIZE];
> +
> +	if (!strlen(pp->wwid) || !get_sgio_wwid(pp, wwid))
> +		return false;
>  
>  	if (strncmp(wwid, pp->wwid, WWID_SIZE)) {
>  		condlog(0, "%s: wwid '%s' doesn't match wwid '%s' from device",
> @@ -1121,6 +1132,24 @@ check_path_wwid_change(struct path *pp)
>  	return false;
>  }
>  
> +/*
> + * udev reported a new WWID for a path. Returns true if the device
> + * itself still reports old_wwid, in which case the udev value must
> + * not be trusted.
> + */
> +static bool device_kept_wwid(struct path *pp, const char *old_wwid)
> +{
> +	char wwid[WWID_SIZE];
> +
> +	if (!can_recheck_wwid(pp) || !get_sgio_wwid(pp, wwid) ||
> +	    strncmp(wwid, old_wwid, WWID_SIZE))
> +		return false;
> +
> +	condlog(0, "%s: ignoring wwid '%s' from udev, device still reports '%s'",
> +		pp->dev, pp->wwid, wwid);
> +	return true;
> +}
> +
>  /*
>   * uev_add_path can call uev_update_path, and uev_update_path can call
>   * uev_add_path
> @@ -1315,6 +1344,20 @@ ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
>  		condlog(0, "%s: failed to get path uid", pp->dev);
>  		goto fail; /* leave path added to pathvec */
>  	}
> +	/*
> +	 * The WWID normally comes from udev, possibly from an event that
> +	 * was queued long before we got here. Adding a path to the map
> +	 * of a different LUN corrupts data, so confirm the WWID with the
> +	 * device first. On a mismatch, leave the path out and let the
> +	 * checker retrigger udev to get a fresh WWID.
> +	 */
> +	if (can_recheck_wwid(pp) && check_path_wwid_change(pp)) {
> +		condlog(0, "%s: not adding path, wwid '%s' not confirmed by device",
> +			pp->dev, pp->wwid);
> +		memset(pp->wwid, 0, WWID_SIZE);
> +		pp->initialized = INIT_MISSING_UDEV;
> +		goto fail;
> +	}
>  	mpp = find_mp_by_wwid(vecs->mpvec, pp->wwid);
>  	if (mpp && pp->size && mpp->size != pp->size) {
>  		condlog(0, "%s: failed to add new path %s, device size mismatch", mpp->alias, pp->dev);
> @@ -1702,6 +1745,10 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
>  			strcpy(pp->wwid, wwid);
>  		else if (strlen(wwid) &&
>  			 strncmp(wwid, pp->wwid, WWID_SIZE) != 0) {
> +			if (device_kept_wwid(pp, wwid)) {
> +				strcpy(pp->wwid, wwid);
> +				goto out;
> +			}
>  			condlog(0, "%s: path wwid changed from '%s' to '%s'",
>  				uev->kernel, wwid, pp->wwid);
>  			ev_remove_path(pp, vecs, 1);
> -- 
> 2.56.0

