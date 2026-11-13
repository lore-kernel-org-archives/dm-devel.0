Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794592830;
	b=zdBxyvKAc3jc3pBFGY2BxvenUrj+0ME2tWgfw27kFpaxCLSZg+8azYek8io/dUZZr3T+
	 z741hBQ3euO2AQoNHJD9PrJySKGh4Cm8Znzzt7AN4Y//Mo05AIDlYBGjloZvboWrkE+XL
	 LnmQHRZDRa9IZ0sI8Yi2zMlQxADkUOFUpKz8SdP9GITQMIXGuQF7s8t1xdP65CZJtcfil
	 +Y4MJ/vrh+YIigBPvI9KWBMa7akPbw0Pa2t63LPYu5IszJL2ZbhsbRmrO3BWvEr5Do3fw
	 /1b5kimtUmkGgx46LjpsEDhQ4AodZG+9YToZcNRAdEpUnc0U5ZULkLDQjoSrNbTtzpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794592830;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition;
	bh=JPsOqEHpF76PmNqKk1ZMs/2WaPhAmTZ74gwsK2fiL5w=;
	b=AP4pZcmhEd0g9Fz3IjH5CFSTelK0uJJqB6bbJD2lwJNiufQuP9eu/70VmtMRsOSsVSyv
	 9gkmZ1mhUpJ/moseB8hbBCVcSLVC5TN6sDfBbz/Ye5ICSAPqorIjA/QOO1nXQ5OT2BYYV
	 0sQ3ziVLF2eASS7+ueEjh0LQ2PUJy30k1eoYhCO3R2xcUECx5CrmzjaumCDWv6fk+2KYO
	 vVoYptBX1IDJQVmOrfunbmOx/kP2cjUWJ/WOPwVFk/DBRgXR7a+FhmnIyhMv+AZjT7OrK
	 hujRW7IzjQsD5ku1Uf4Kcm+scinIQw+JuG0mIsR0cHrCq3dMGo8B5LLvTMnybcbZOXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=B69VZi1X;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAFE606A337
	for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 18:00:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CEAFE606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=B69VZi1X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794592828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JPsOqEHpF76PmNqKk1ZMs/2WaPhAmTZ74gwsK2fiL5w=;
	b=B69VZi1X+UjGXQHDKul1quuP5/2kBH5Qutio/6CUbm8HQx6hOcMVG4qrq/RN0b51r917eg
	8SSXXnHWi7kIXljvEfUmDO9JKZbzYUP68m03p5D+SBrF6TawOh3xB9brEJMCMvsvqGje9R
	b+GW3eeCebTFewAK/yTA9oZFbTXolI8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-533-AAlI3fXKMwuqnumKlajXzg-1; Fri,
 13 Nov 2026 13:00:25 -0500
X-MC-Unique: AAlI3fXKMwuqnumKlajXzg-1
X-Mimecast-MFC-AGG-ID: AAlI3fXKMwuqnumKlajXzg_1794592824
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 870301956057;
	Fri, 13 Nov 2026 18:00:24 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 19FEB180054A;
	Fri, 13 Nov 2026 18:00:24 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6ADI0Mtj2049879
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 13 Nov 2026 13:00:22 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6ADI0Mwu2049861;
	Fri, 13 Nov 2026 13:00:22 -0500
Date: Fri, 13 Nov 2026 13:00:22 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Brian Bunker <brian@purestorage.com>, Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH v4 1/1] multipathd: recheck WWIDs of re-added paths with
 the device
Message-ID: <avdQNjzddtu7o18n@redhat.com>
References: <20261111181642.51912-1-brian@purestorage.com>
 <20261111181642.51912-2-brian@purestorage.com>
 <179452227264.147392.9708937185980533136.b4-review@b4>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <179452227264.147392.9708937185980533136.b4-review@b4>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NWtSe0lga2eBpvmvwz4OKpmCdQnT5WMUWYtTKeMdDjI_1794592824
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 12, 2026 at 11:24:32PM +0100, Martin Wilck wrote:
> > multipathd takes a path's WWID from udev. When a change uevent reports
> > a different WWID, uev_update_path() removes the path from its map and
> > re-adds it through uev_add_path(), which places it in whatever map owns
> > the new WWID. The removal can block for seconds while the map is
> > suspended, so by the time the path is re-added, the WWID in the uevent
> > may no longer be what the device reports. If it is wrong, the path goes
> > into the map of a different LUN and I/O for one LUN is silently sent to
> > another.
> > 
> > If recheck_wwid is set, confirm the WWID with the device over SG_IO
> > before such a re-add puts the path into a map, as recheck_wwid already
> > does when a failed path comes back. If the device doesn't confirm it,
> > leave the path out of the map: orphan it, clear its WWID and mark it
> > INIT_MISSING_UDEV, so the checker retriggers udev and the path is
> > re-added from fresh data.
> > 
> > To tell re-adds from ordinary adds, turn the need_do_map argument of
> > uev_add_path() and ev_add_path() into enum path_add_mode, with a new
> > PATH_ADD_REINIT value that behaves like PATH_ADD_MAP and is passed only
> > for the re-add at the end of uev_update_path(). Ordinary adds are
> > unchanged.
> > 
> > Document the new case under recheck_wwid in multipath.conf(5).
> 
> As Ben pointed out in his previous email:
> 
> 
> It may make sense to convert the "recheck_wwid" option from a boolean
> to a multi-value option, to make it possible to choose between the old
> and new behavior.
> 
> @Ben, what do you think?

Like I mentioned in that other email thread, I think limiting this to
only run on paths that are up will make it no more risky than
recheck_wwid already is. recheck_wwid exists because people are worried
that their device my change wwid unexpectedly. We could have multiple
levels of worry, but I'm not sure we need to give users such fine
grained control, and this check only gets tripped when something already
went wrong.

more comments below.

> 
> > 
> > Signed-off-by: Brian Bunker <brian@purestorage.com>
> 
> I still have some more comments, see below.
> (In case you wonder: I used AI to assist with this review).
> 
> > diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
> > index a577dfc..8f35880 100644
> > --- a/multipath/multipath.conf.5.in
> > +++ b/multipath/multipath.conf.5.in
> > @@ -1382,9 +1382,11 @@ The default is: \fB\(dqNONE\(dq\fR
> >  If set to \fIyes\fR, when a failed path is restored, its wwid is rechecked. If
> >  the wwid has changed, the path is removed from the current multipath device,
> >  and re-added as a new path. Multipathd will also recheck a path's wwid if it is
> > -manually re-added. This option only works for SCSI devices that are configured
> > -to use the default uid_attribute, \fIID_SERIAL\fR, or sysfs for getting their
> > -wwid.
> > +manually re-added, and before re-adding a path whose wwid udev reported as
> > +changed. If the device doesn't confirm the new wwid, the path is left out of
> > +the multipath device and udev is asked to report its wwid again. This option
> > +only works for SCSI devices that are configured to use the default
> > +uid_attribute, \fIID_SERIAL\fR, or sysfs for getting their wwid.
> >  .RS
> >  .TP
> >  The default is: \fBno\fR
> > diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> > index f5a13c4..9b4a04c 100644
> > --- a/multipathd/cli_handlers.c
> > +++ b/multipathd/cli_handlers.c
> > @@ -673,7 +673,7 @@ cli_add_path (void *v, struct strbuf *reply, void *data)
> >  			return 1;
> >  		}
> >  	}
> > -	return ev_add_path(pp, vecs, 1);
> > +	return ev_add_path(pp, vecs, PATH_ADD_MAP);
> >  blacklisted:
> >  	append_strbuf_str(reply, "blacklisted\n");
> >  	condlog(2, "%s: path blacklisted", param);
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 9bce4d6..fdf5503 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -1128,7 +1128,7 @@ check_path_wwid_change(struct path *pp)
> >  static int uev_update_path (struct uevent *uev, struct vectors * vecs);
> >  
> >  static int
> > -uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
> > +uev_add_path(struct uevent *uev, struct vectors *vecs, enum path_add_mode mode)
> >  {
> >  	struct path *pp;
> >  	int ret = 0, i;
> > @@ -1180,7 +1180,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
> >  				     DI_ALL | DI_BLACKLIST);
> >  			pthread_cleanup_pop(1);
> >  			if (r == PATHINFO_OK && !prev_mpp)
> > -				ret = ev_add_path(pp, vecs, need_do_map);
> > +				ret = ev_add_path(pp, vecs, mode);
> >  			else if (r == PATHINFO_OK &&
> >  				 !strncmp(pp->wwid, prev_mpp->wwid, WWID_SIZE)) {
> >  				/*
> > @@ -1255,7 +1255,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
> >  		conf = get_multipath_config();
> >  		pp->checkint = conf->checkint;
> >  		put_multipath_config(conf);
> > -		ret = ev_add_path(pp, vecs, need_do_map);
> > +		ret = ev_add_path(pp, vecs, mode);
> >  	} else {
> >  		condlog(0, "%s: failed to store path info, "
> >  			"dropping event",
> > @@ -1297,8 +1297,7 @@ sysfs_get_ro (struct path *pp)
> >   * 0: added
> >   * 1: error
> >   */
> > -int
> > -ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
> > +int ev_add_path(struct path *pp, struct vectors *vecs, enum path_add_mode mode)
> >  {
> >  	struct multipath * mpp;
> >  	char *params __attribute__((cleanup(cleanup_charp))) = NULL;
> > @@ -1315,6 +1314,22 @@ ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
> >  		condlog(0, "%s: failed to get path uid", pp->dev);
> >  		goto fail; /* leave path added to pathvec */
> >  	}
> > +	/*
> > +	 * This path is being re-added because its udev data was missing or
> > +	 * changed. The uevent may have been queued long before we got here,
> > +	 * and adding a path to the map of a different LUN corrupts data. If
> > +	 * recheck_wwid is set, confirm the WWID with the device first. On a
> > +	 * mismatch, leave the path out and let the checker retrigger udev
> > +	 * to get a fresh WWID.
> > +	 */
> > +	if (mode == PATH_ADD_REINIT && pp->recheck_wwid == RECHECK_WWID_ON &&
> > +	    check_path_wwid_change(pp)) {
> 
> check_path_wwid_change() returns false when it fails, is it correct to keep the
> path in that case? IMHO we should treat this like the strlen(pp->wwid) == 0 case
> above.

Not sure I agree with this. It's a paranoia check. If it fails, I don't
have a problem with just trusting the data that was given to us. I'm
willing to be convinced otherwise, however.

> > +		condlog(0, "%s: not adding path, wwid '%s' not confirmed by device",
> > +			pp->dev, pp->wwid);
> 
> check_path_wwid_change() already logs at verbosity 0.
> 2 or even 3 should be enough here.

makes sense.

> > +		memset(pp->wwid, 0, WWID_SIZE);
> > +		pp->initialized = INIT_MISSING_UDEV;
> > +		goto fail;
> 
> In pathinfo(), we also set pp->tick = conf->retrigger_delay. Is there a reason we
> don't do it here?

makes sense.

> But more generally: as this indicates a possible mismatch between kernel and device
> state, should we handle this similar to  handle_path_wwid_change() instead,
> i.e. also call rescan_path()? I guess that would need to be done in uev_update_path(),
> i.e. it would touch the regular "wwid changed in uevent" path.

Is this not another place were we are opening ourselves up for commands
blocking? If we want to do a rescan and it can block, it makes more
sense to do it only if recheck_wwids is set, and we know that the path
is up. 

> > +	}
> >  	mpp = find_mp_by_wwid(vecs->mpvec, pp->wwid);
> >  	if (mpp && pp->size && mpp->size != pp->size) {
> >  		condlog(0, "%s: failed to add new path %s, device size mismatch", mpp->alias, pp->dev);
> > @@ -1375,7 +1390,7 @@ rescan:
> >  	if (ro == 1)
> >  		mpp->force_readonly = 1;
> >  
> > -	if (!need_do_map)
> > +	if (mode == PATH_ADD_NO_MAP)
> >  		return 0;
> >  
> >  	if (!dm_map_present(mpp->alias)) {
> > @@ -1789,7 +1804,7 @@ out:
> >  	}
> >  	/* pp->initialized must not be INIT_PARTIAL if needs_reinit is set */
> >  	if (needs_reinit)
> > -		retval = uev_add_path(uev, vecs, 1);
> > +		retval = uev_add_path(uev, vecs, PATH_ADD_REINIT);
> 
> Is it correct to take this branch also if needs_reinit is set because
> INIT_REQUESTED_UDEV was set? I don't think so.

This is a little tricky. I agree that we don't need to add the extra
layer of paranoid checking when the path never got a wwid. In that case,
what most likely what happened is that the udev worker thread timed out
on the previous uevent, so we couldn't get the WWID from uevent
variables. However, if we don't recheck on INIT_REQUESTED_UDEV, then we
can get into a situation where:
1. uev_update_path() notices that the wwid has changed
2. ev_add_path() confirms that the wwid we got from udev doesn't match
   the wwid we get directly asking the device
3. We trigger a new uevent
4. We blindly trust udev's wwid.

Perhaps we need more initialization states or a path device flag to
distinguish between the two cases (never having gotten a WWID, or having
our WWID . Or we can decide that we are o.k. with extra checking
whenever something goes wrong with getting the wwid from udev (when you
have recheck_wwid set). Or am I misunderstanding something about why
doing this is wrong? Are we intentionally only double-checking once
here?

-Ben

> -- 
> Martin Wilck <mwilck@suse.com>

