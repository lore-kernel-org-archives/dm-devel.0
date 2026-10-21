Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792618531;
	b=JX+x/t5eZEG6emUzlTM+REarDArhstYqEVLWnDEwRgrxjtzoil1UiHZBRP3Gshhnj3ce
	 n2UkvnucgrOoj32K5C9XuxCVvDpeGVUjtV3X4q5NLs/FZH6qreZdpJ7pC5ZsHv9afWobI
	 HcT3TgQIAbv9BsAmX6bOyrygl2dRo59zRpTQt8LVQoNsr0W5ZFJLEKTfdbUp+SpXDVWFH
	 kwrgOje+E62pKMWzoRRnI8buLxQhdv+4pDE/7WA7HRRqos1S8y7yK6ByonfVdZrR1wgIR
	 hlSZhxFBhRf+D00vYPHThkzvGADiP0pnBv23MzBzYLMKEwtvY+23NVYUsHgXewD67Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792618531;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Subject:From:To:Cc:In-Reply-To:References:
	 Date:Message-Id:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=dZG3BAITcjhQ06AuDBSjaCmXP3Bw/HByGvYDjpEnpkQ=;
	b=2wVegsNxEhFTn86djPxpBTW9If7skefnIA871kAHOfuNc3T/HCHF84PHPd0Y6R86X1e7
	 z1PkAh0hNwG2sQAtFAG0bCz4dyhrwx7HboYkq/hzwABf5c9UGX+NEEqLPksk9q/dBpq/1
	 1jLrIA89egWY3PaIwQcKJX5fbTJnFhEFkf7sl2x6wkgdVgC/N6ylmn23KgHoTuFhtpOiK
	 4HnMVJH3GKJnKY8NBd7EbfMMDn41OmGQri3CAsqtkAVZkW9EQRau0uh6Wcp7i6+hIsvF8
	 EWsLpERvC8kngIMijO7GGV9ADptu5VdaFyOrkhj/1xbwSC0szyLHte3N2Yq0c3RjkEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=m7CDCtjb;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=476rtb8q;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=m7CDCtjb;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=476rtb8q;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665AA606A31D
	for <dm-devel@lists.linux.dev>; Wed, 21 Oct 2026 21:35:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 665AA606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=m7CDCtjb;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=476rtb8q;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=m7CDCtjb;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=476rtb8q
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 49C9921E57;
	Wed, 21 Oct 2026 21:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792618523; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dZG3BAITcjhQ06AuDBSjaCmXP3Bw/HByGvYDjpEnpkQ=;
	b=m7CDCtjbpaqqBh9acxQ6Rz+2rkri9YTEZ0KpqHgsuDkjIc36sFFDWcEOjm4ytu5/31k+7J
	1C3ishxpEQDvFcLzpaqWyIMBtkYbhGqX/NONXHmoF1NXNybS00CiU8fg0UAle7FwEuv17j
	UrFen+Smz9faI+Dryqp6x907BUMsfDs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792618523;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dZG3BAITcjhQ06AuDBSjaCmXP3Bw/HByGvYDjpEnpkQ=;
	b=476rtb8qRuc4ptN9DcTkDnn7iy2s5qIoKAcr+Xgi4Uju9k8LWZl+fiSyOLEgsve/vnu6N/
	LCfmO6c29fTb1UBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792618523; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dZG3BAITcjhQ06AuDBSjaCmXP3Bw/HByGvYDjpEnpkQ=;
	b=m7CDCtjbpaqqBh9acxQ6Rz+2rkri9YTEZ0KpqHgsuDkjIc36sFFDWcEOjm4ytu5/31k+7J
	1C3ishxpEQDvFcLzpaqWyIMBtkYbhGqX/NONXHmoF1NXNybS00CiU8fg0UAle7FwEuv17j
	UrFen+Smz9faI+Dryqp6x907BUMsfDs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792618523;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dZG3BAITcjhQ06AuDBSjaCmXP3Bw/HByGvYDjpEnpkQ=;
	b=476rtb8qRuc4ptN9DcTkDnn7iy2s5qIoKAcr+Xgi4Uju9k8LWZl+fiSyOLEgsve/vnu6N/
	LCfmO6c29fTb1UBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 08260134A5;
	Wed, 21 Oct 2026 21:35:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BKoPCPsv2WoYDQAAD6G6ig
	(envelope-from <mwilck@suse.de>); Wed, 21 Oct 2026 21:35:23 +0000
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/1] multipathd: don't leave maps read-only after
 write protect is cleared
From: mwilck@suse.de
To: Brian Bunker <brian@purestorage.com>
Cc: dm-devel@lists.linux.dev, Benjamin Marzinski <bmarzins@redhat.com>, 
 Martin Wilck <mwilck@suse.com>, 
 Christophe Varoqui <christophe.varoqui@opensvc.com>
In-Reply-To: <20261021182759.30106-2-brian@purestorage.com>
References: <20261021182759.30106-1-brian@purestorage.com>
 <20261021182759.30106-2-brian@purestorage.com>
Date: Wed, 21 Oct 2026 23:34:45 +0200
Message-Id: <179261848556.617150.17378002460197797656.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6968; i=mwilck@suse.com;
 h=from:subject:message-id; bh=3xtiOK/Or2ZDIfwRSv73rQKKo5dW/48721iRHHAjZXo=;
 b=owEBCQL2/ZANAwAIAaFOxj0gAPzbAcsmYgBq2S/74s14mLpdQTg3UdkAbofEzxa6dL2a4u5u9
 Gs43XUzF2KJAc8EAAEIADkWIQT9/H021zOM2230IgahTsY9IAD82wUCatkv+xsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQoU7GPSAA/NtPLAwAiPsqSeoOL75noLjj/u2YGXNXIrDmEkU
 EARWwiLDUCTfLADNHzUjzaATopaI5dNJednxnLJp1wAes/+qlA/trlF92b5f8vZ/cyYWr4RQfnW
 spLVGnZRun4XY0inFUune6zwhH81Gq5+U6Pp5hCWJE1yj1ThtqcVRXMIGKlvVMCJuAINQ/yxKyX
 dRHonlK1+hm+YKIYa3B2yyXR81H4SNZP7dRi4diH8zF2flOb/CFmV2qOSscOT28MOCa4v0/cE2B
 YhsMKDdkMHS10D+nkemdEn/d4wPxFXv7HzQzayJpq/tNu3C0B6jDjNHOkzlez43ISzEldmpFWSA
 V2ei3Sc6ITrmF6CEN/5GR8ZDpa0Lqy/3Btrrtyh+a041yFCsYuq2q2h1D0qQOrk/ZGI49YNxG+T
 0PTt4Cw/3C7YxLZ58scADtZTp/+6vuBzNujDzYuGO3rK1Ys6VpQz/IP8CZv0YfN5xWnFH5SYieS
 iymtUrGcX105Q8xjkdLx9eYgy/nS/ZE
X-Developer-Key: i=mwilck@suse.com; a=openpgp;
 fpr=750EAD4B2EDEB1A545D4F5F467C586E685569754
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-12.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FROM_NO_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,purestorage.com:email]
X-Spam-Score: -12.80

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
> when a load succeeds:
> 
> - needs_ro_update() now sets force_readonly whenever it returns true:
>   to 1 for a DISK_RO=1 uevent, to 0 when all of the map's paths are
>   writable, and from the paths' state when the map has no dm info.
>   uev_update_path() no longer sets or clears it itself.
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
> - dm_addmap() clears it after a successful load, as it does for
>   need_reload, so it can't outlive the load it was set for.
> 
> Signed-off-by: Brian Bunker <brian@purestorage.com>
>
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index e3870f5..c2939dc 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -520,8 +520,10 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
>  	if (task == DM_DEVICE_CREATE)
>  		libmp_udev_wait(cookie);
>  
> -	if (r)
> +	if (r) {
>  		mpp->need_reload = false;
> +		mpp->force_readonly = 0;
> +	}
>  	return r;
>  }
>  
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 9bce4d6..605e24a 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -709,6 +709,42 @@ void cleanup_reset_vec(struct vector_s **v)
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
>  static int
>  update_map (struct multipath *mpp, struct vectors *vecs, int new_map)
>  {
> @@ -732,6 +768,14 @@ retry:
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
> @@ -1270,28 +1314,6 @@ out:
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
> @@ -1305,7 +1327,6 @@ ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
>  	int retries = 3;
>  	int start_waiter = 0;
>  	int ret;
> -	int ro;
>  	unsigned char prflag = PR_UNSET;
>  
>  	/*
> @@ -1370,14 +1391,16 @@ rescan:
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
> @@ -1597,23 +1620,35 @@ static bool
>  needs_ro_update(struct multipath *mpp, int ro)
>  {
>  	struct pathgroup * pgp;
> -	struct path * pp;
> -	unsigned int i, j;
> +	unsigned int i;
>  
>  	if (!mpp || ro < 0)
>  		return false;
> -	if (!has_dm_info(mpp))
> +	if (!has_dm_info(mpp)) {

This should never happen. But as we test the condition,
wonder why we don't just call dm_get_info(mpp, &mpp->dmi) to obtain
the missing information?

If that fails, I am not sure it makes sense to return true any more.
It would indicate a severe problem with the map at hand.

> +		mpp->force_readonly = 0;
> +		vector_foreach_slot (mpp->pg, pgp, i) {

if (ro == 1), you can skip this loop, as you already know that there's one
ro path.

> +			if (has_ro_path(pgp->paths)) {
> +				mpp->force_readonly = 1;
> +				break;
> +			}
> +		}
>  		return true;
> +	}
>  	if (mpp->dmi.read_only == ro)
>  		return false;

Should mpp->force_readonly be reset here? After all, there seems to be no
need for reloading. That would be a similar condition as what you fix
by resetting force_readonly below.

Actually, as we don't seem to trust our internal state anyway, we might
simply obtain the sysfs attribute for all paths, always, and compare it
to dmi.read_only. That might be somewhat slow-ish, though.

The alternative would be to improve our internal tracking, e.g. by saving
a "ro" flag for paths when we add them or receive an uevents for them.
That way we could save the effort to check sysfs repeatedly.

Thanks,
Martin

-- 
Martin Wilck <mwilck@suse.com>
