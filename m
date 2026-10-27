Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793074628;
	b=0+LMiHCdauG8QlOC7Ly4xyGeQ7DQqEzBO8/mnIHWB/Hf+15hgwUyvLAFaUKQGERvTGmE
	 w7EyqDjAgeoPoK73j5AV9QZA+buHUHiEzrtS1Ox0WCH+4dyYAH4V3jifdar70Y2nkl5Kl
	 eyU/bwutJVj39yhQjqBolCwEcocZFERGRVC9yHgMbFslA5Mf7NJI2ttQjTbTzCB6/nGwT
	 qfaaj1CVdT8ufJ+PDOq9PvqejyzpqGhiLgM/mSSUpEgZ8xnM9HMLqBa9hVzhvHS266FWZ
	 A2rcQtAiAZ47qlccPdluXuv8Cigzyh4EW8BRAISDHJZbtQRLVVtRcPyL25MPOX659vQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793074628;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition;
	bh=GFtlo7nOjy2iIXbXN164Ak+djS/zDfnPpb34AhdT6oU=;
	b=27f/NRm6i/sm8HoleiDG6+qY4jEr8ZohLlXDFnD0njPqkzV/dfeNgnkirnfrMtuyVhfo
	 3bkFAqNQ8ubnK3LGaIxrmgjlsDMwlEcykLDmOtj2QyX9SFiqFJSnwGPOQVNFaEls7fOJ3
	 BqWPi2VwqcdlWbqFRR3jXe+oxg9kDN7fKPyLzgXIAamj7B2UFMas+7mr3cCNdgDg1cIVG
	 Bs9IE93GXLwb8EL+6W3xFbJxMSkZ7RyKNAPUNZ36JAoSmcmTmOzs3In03KxvfB0Qy1hrt
	 BApTZeEvjizYgse2/uz4r3devfsvUBly3+EnAcRDdGvREj7kru1TGfdDC9ow9Ce9sVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LxdyfniU;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D36606A31A
	for <dm-devel@lists.linux.dev>; Tue, 27 Oct 2026 04:17:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10D36606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LxdyfniU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793074627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GFtlo7nOjy2iIXbXN164Ak+djS/zDfnPpb34AhdT6oU=;
	b=LxdyfniU0uEgHMCC5E3KEj+Ww7lLgcDPMtJ8kORwlaewSeSP744/QHjIcuB2Ox/z6CkNQh
	jDxCThUtyfukxV+cVEJNc0bJV/U43ll4GbQuErUU776U0dKZIWmD+Hdtybqs+IR/FgPqoO
	YDXUL/iUXWC4QrmroEe1XnnuU9zdxkg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-587-Bo72MVoxNJ2AVWdnphrwBA-1; Tue,
 27 Oct 2026 00:17:03 -0400
X-MC-Unique: Bo72MVoxNJ2AVWdnphrwBA-1
X-Mimecast-MFC-AGG-ID: Bo72MVoxNJ2AVWdnphrwBA_1793074622
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 31F251956043;
	Tue, 27 Oct 2026 04:17:02 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B8F4D195608B;
	Tue, 27 Oct 2026 04:17:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 69R4H0vN280040
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 27 Oct 2026 00:17:00 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 69R4H0Ta280039;
	Tue, 27 Oct 2026 00:17:00 -0400
Date: Tue, 27 Oct 2026 00:17:00 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Brian Bunker <brian@purestorage.com>
Cc: dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v4 1/1] multipathd: don't leave maps read-only after
 write protect is cleared
Message-ID: <auAlvMxSuLghYscn@redhat.com>
References: <20261022234853.79725-1-brian@purestorage.com>
 <20261022234853.79725-2-brian@purestorage.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261022234853.79725-2-brian@purestorage.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2xLzPhozImiBQQ2zrXKFBOC980ljZqwlJstICT22HdI_1793074622
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 22, 2026 at 04:48:53PM -0700, Brian Bunker wrote:
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
> Fix this by setting force_readonly before each load and clearing it
> when the load reads it:
> 
> - needs_ro_update() now sets force_readonly whenever it returns true:
>   to 1 for a DISK_RO=1 uevent, and to 0 when all of the map's paths
>   are writable. uev_update_path() no longer sets or clears it itself.
>   If the map has no dm info, needs_ro_update() now fetches it, and
>   returns false if that fails, instead of assuming a reload is needed.
> 
> - ev_add_path() sets it from all of the map's paths rather than only
>   the path being added, and only when it is about to load the map
>   (need_do_map). mpp->paths is up to date there after adopt_paths(),
>   while mpp->pg doesn't contain the new paths yet.
> 
> - update_map(), which does reloads that were delayed while the map was
>   waiting for udev (UDEV_WAIT_RELOAD), recomputes it from the map's
>   paths before setting up the map.
> 
> - dm_addmap_create() and dm_addmap_reload() clear it as soon as they
>   have read it, so it only applies to the load it was set for.
> 
> - If a reload fails, dm_addmap_reload() sets it back, because the map
>   still has its old table. If the map was supposed to become read-only,
>   the next reload then tries again. needs_ro_update() clears the flag
>   again when a DISK_RO=0 uevent arrives for a read-write map and none
>   of the map's paths is read-only any more, so that a later reload for
>   an unrelated reason, such as a path group change, doesn't load the
>   map read-only.
> 
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> ---
>  libmultipath/devmapper.c |  26 ++++++--
>  multipathd/main.c        | 128 +++++++++++++++++++++++++--------------
>  2 files changed, 103 insertions(+), 51 deletions(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index e3870f59..324a92cc 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -539,10 +539,15 @@ static uint16_t build_udev_flags(const struct multipath *mpp, int reload)
>  
>  int dm_addmap_create (struct multipath *mpp, char *params)
>  {
> -	int ro;
> +	int ro = mpp->force_readonly ? 1 : 0;
>  	uint16_t udev_flags = build_udev_flags(mpp, 0);
>  
> -	for (ro = mpp->force_readonly ? 1 : 0; ro <= 1; ro++) {
> +	/*
> +	 * force_readonly only applies to this load. Clear it, so that it
> +	 * can't affect later loads, even if this one fails.
> +	 */
> +	mpp->force_readonly = 0;
> +	for (; ro <= 1; ro++) {
>  		int err;
>  
>  		if (dm_addmap(DM_DEVICE_CREATE, TGT_MPATH, mpp, params, ro,
> @@ -578,19 +583,26 @@ int dm_addmap_create (struct multipath *mpp, char *params)
>  int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
>  {
>  	int r = 0;
> +	int force_ro = mpp->force_readonly;
>  	uint16_t udev_flags = build_udev_flags(mpp, 1);
>  
> +	/*
> +	 * force_readonly only applies to this load. Clear it, so that it
> +	 * can't affect later loads, unless this one fails (see below).
> +	 */
> +	mpp->force_readonly = 0;
> +
>  	/*
>  	 * DM_DEVICE_RELOAD cannot wait on a cookie, as
>  	 * the cookie will only ever be released after an
>  	 * DM_DEVICE_RESUME. So call DM_DEVICE_RESUME
>  	 * after each successful call to DM_DEVICE_RELOAD.
>  	 */
> -	if (!mpp->force_readonly)
> +	if (!force_ro)
>  		r = dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params,
>  			      ADDMAP_RW, 0);
>  	if (!r) {
> -		if (!mpp->force_readonly && errno != EROFS)
> +		if (!force_ro && errno != EROFS)
>  			return 0;
>  		r = dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp,
>  			      params, ADDMAP_RO, 0);
> @@ -609,6 +621,12 @@ int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
>  		dm_simplecmd(DM_DEVICE_RESUME, mpp->alias,
>  			     DMFL_NEED_SYNC | (flush ? 0 : DMFL_NO_FLUSH),
>  			     udev_flags);
> +	/*
> +	 * The map still has its old table. If it was supposed to become
> +	 * read-only, keep force_readonly set, so that the next reload
> +	 * tries again.
> +	 */
> +	mpp->force_readonly = force_ro;
>  	return 0;

Unsetting and then resetting force_readonly seems like more work than
necessary. It seems simpler to just clear mpp->force_readonly if we
successfully reload the table and resume the map.

>  }
>  
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 9bce4d6b..ddef64fa 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -709,6 +709,55 @@ void cleanup_reset_vec(struct vector_s **v)
>  	vector_reset(*v);
>  }
>  
> +static int
> +sysfs_get_ro (struct path *pp)
> +{
> +	int ro;
> +	char buff[3]; /* Either "0\n\0" or "1\n\0" */
> +
> +	if (!pp->udev)
> +		return -1;
> +
> +	if (!sysfs_attr_get_value_ok(pp->udev, "ro", buff, sizeof(buff))) {
> +		condlog(3, "%s: Cannot read ro attribute in sysfs", pp->dev);
> +		return -1;
> +	}
> +
> +	if (sscanf(buff, "%d\n", &ro) != 1 || ro < 0 || ro > 1) {
> +		condlog(3, "%s: Cannot parse ro attribute", pp->dev);
> +		return -1;
> +	}
> +
> +	return ro;
> +}
> +
> +/* A map must be loaded read-only if any of its paths is read-only. */
> +static bool
> +has_ro_path(vector paths)
> +{
> +	struct path *pp;
> +	unsigned int i;
> +
> +	vector_foreach_slot (paths, pp, i) {
> +		if (sysfs_get_ro(pp) == 1)
> +			return true;
> +	}
> +	return false;
> +}
> +
> +static bool
> +map_has_ro_path(struct multipath *mpp)
> +{
> +	struct pathgroup *pgp;
> +	unsigned int i;
> +
> +	vector_foreach_slot (mpp->pg, pgp, i) {
> +		if (has_ro_path(pgp->paths))
> +			return true;
> +	}
> +	return false;
> +}
> +
>  static int
>  update_map (struct multipath *mpp, struct vectors *vecs, int new_map)
>  {
> @@ -732,6 +781,14 @@ retry:
>  
>  	mpp->action = ACT_RELOAD;
>  
> +	/*
> +	 * This may be a delayed reload, and the paths' write protect
> +	 * state may have changed since force_readonly was last set.
> +	 * Recompute it from the current paths. mpp->paths is up to date
> +	 * after adopt_paths(), while mpp->pg isn't until setup_map().
> +	 */
> +	mpp->force_readonly = has_ro_path(mpp->paths);
> +
>  	if (setup_map(mpp, &params, vecs)) {
>  		condlog(0, "%s: failed to setup new map in update", mpp->alias);
>  		retries = -1;
> @@ -1270,28 +1327,6 @@ out:
>  	return ret;
>  }
>  
> -static int
> -sysfs_get_ro (struct path *pp)
> -{
> -	int ro;
> -	char buff[3]; /* Either "0\n\0" or "1\n\0" */
> -
> -	if (!pp->udev)
> -		return -1;
> -
> -	if (!sysfs_attr_get_value_ok(pp->udev, "ro", buff, sizeof(buff))) {
> -		condlog(3, "%s: Cannot read ro attribute in sysfs", pp->dev);
> -		return -1;
> -	}
> -
> -	if (sscanf(buff, "%d\n", &ro) != 1 || ro < 0 || ro > 1) {
> -		condlog(3, "%s: Cannot parse ro attribute", pp->dev);
> -		return -1;
> -	}
> -
> -	return ro;
> -}
> -
>  /*
>   * returns:
>   * 0: added
> @@ -1305,7 +1340,6 @@ ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
>  	int retries = 3;
>  	int start_waiter = 0;
>  	int ret;
> -	int ro;
>  	unsigned char prflag = PR_UNSET;
>  
>  	/*
> @@ -1370,14 +1404,16 @@ rescan:
>  			goto fail; /* leave path added to pathvec */
>  	}
>  
> -	/* ro check - if new path is ro, force map to be ro as well */
> -	ro = sysfs_get_ro(pp);
> -	if (ro == 1)
> -		mpp->force_readonly = 1;
> -
>  	if (!need_do_map)
>  		return 0;
>  
> +	/*
> +	 * Load the map read-only if any of its paths is read-only, not
> +	 * just the one being added. mpp->paths is up to date after
> +	 * adopt_paths(), while mpp->pg doesn't have the new paths yet.
> +	 */
> +	mpp->force_readonly = has_ro_path(mpp->paths);
> +
>  	if (!dm_map_present(mpp->alias)) {
>  		mpp->action = ACT_CREATE;
>  		start_waiter = 1;
> @@ -1596,24 +1632,26 @@ finish_path_init(struct path *pp, struct vectors * vecs)
>  static bool
>  needs_ro_update(struct multipath *mpp, int ro)
>  {
> -	struct pathgroup * pgp;
> -	struct path * pp;
> -	unsigned int i, j;
> -
>  	if (!mpp || ro < 0)
>  		return false;

I said we should clear mpp->force_reload when we return false, but we
obviously can't do that when mpp is NULL. Perhaps if ro is -1 in
uev_update_path(), we should check sysfs instead. Something like:

if (ro < 0)
	ro = (sysfs_get_ro == 1);

That way we'd always call needs_ro_update() with a valid value for
ro.

> -	if (!has_dm_info(mpp))
> -		return true;
> -	if (mpp->dmi.read_only == ro)
> +	if (!has_dm_info(mpp) &&
> +	    dm_get_info(mpp->alias, &mpp->dmi) != DMP_OK) {
> +		condlog(2, "%s: failed to get dm info", mpp->alias);
>  		return false;

Not sure it matters what we do here. I supposed that we could check all
the paths and set force_readonly if one of them is read-only.

> -	if (ro == 1)
> -		return true;
> -	vector_foreach_slot (mpp->pg, pgp, i) {
> -		vector_foreach_slot (pgp->paths, pp, j) {
> -			if (sysfs_get_ro(pp) == 1)
> -				return false;
> -		}
>  	}
> +	if (mpp->dmi.read_only == ro) {
> +		/*
> +		 * A failed read-only reload leaves force_readonly set while
> +		 * the map is still read-write. Clear it once no path is
> +		 * read-only any more.
> +		 */
> +		if (ro == 0 && mpp->force_readonly && !map_has_ro_path(mpp))
> +			mpp->force_readonly = 0;

This is correct.

> +		return false;
> +	}
> +	if (ro == 0 && map_has_ro_path(mpp))

If ro is 0 and not equal to mpp->dmi.read_only, then that means the
map is already read-only. We don't need force_readonly here, since
dm_addmap_reload() won't be able to reload the map read-write unless it
can actually re-open the devices read-write (the path devices in the
existing table must be opened read-only since the multipath device is
read-only, so dm can't simply reuse them for the new table that it's
loading).

-Ben

> +		return false;
> +	mpp->force_readonly = ro;
>  	return true;
>  }
>  
> @@ -1732,15 +1770,11 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
>  			if (mpp->wait_for_udev != UDEV_WAIT_DONE)
>  				mpp->wait_for_udev = UDEV_WAIT_RELOAD;
>  			else {
> -				if (ro == 1)
> -					pp->mpp->force_readonly = 1;
>  				retval = reload_and_sync_map(mpp, vecs);
>  				if (retval == 2)
>  					condlog(2, "%s: map removed during reload", pp->dev);
> -				else {
> -					pp->mpp->force_readonly = 0;
> +				else
>  					condlog(2, "%s: map %s reloaded (retval %d)", uev->kernel, mpp->alias, retval);
> -				}
>  			}
>  		}
>  		if (auto_resize != AUTO_RESIZE_NEVER && mpp &&
> -- 
> 2.56.0

