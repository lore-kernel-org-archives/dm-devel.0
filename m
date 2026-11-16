Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794858372;
	b=2bLQPRTs8OsuqnHG4iZWY+/JfjZsWkXcrduCwIfHS2OAMWkDH8aBK46texEtfF1S8dhs
	 VlGHk1B+Fr3FAmEiFFdtmNA7z6E6+D0g9s82NKDoxT5RPIWKktSvWMAV+NEaGgSNn6VvN
	 XETVekI7D4qSAlxSYmFMCzYhDWYn8ML3n0OvAJm1l0x58EyltAHBdQois8EvrwIMh99XJ
	 2mCzEY1rzWzOD3TzmrWhh4hBR7WNHwbvRLnCmx9RKJ1Ku2c/RAjmPOwZFL1DThihYLpUV
	 hcUTcq2SZ/a9Rzyj0mvYN/nI58aRdDhsZQFZGF1A5Lt2EsYt1tpyQg1YUMTEXGA8wYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794858372;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding;
	bh=PY1XTm1QUotiSuYUkwshcOHiWqiNawsH3MYUexOBGbk=;
	b=xgy/pObvpZHUGkobyyDaLxIVmQlA0fJ7r6hgQR/ARbiSxxf/L/FoU1asmlcCDHJz0PAZ
	 aCjQYk70p1fRwsEcm0fVPohnUXEs7fpRz+DBJrkkfRI7tlt/Lk4U70VfkD2eFso1KPSR4
	 HQMo1OMFBwG2TkTxMg4l+GV5ecmP35BY73QJNmVywksx/j0KcnbtuahC2rs7CqiaTH5up
	 UO1LBOqyLGvhsqcsAteGMikuIJRa7Rr+cUwG9IZKFF7wXC58sfK87ghvvmqDfaMTPGS8s
	 ZAWWAouOhSbo6UVc5CGm+5uktG52udyYU+ifI1ltpcV2ExzXil60HiZpDuFH3fw8+rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="Vd84DCz/";
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5D4606A31C
	for <dm-devel@lists.linux.dev>; Mon, 16 Nov 2026 19:46:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC5D4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Vd84DCz/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794858370;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PY1XTm1QUotiSuYUkwshcOHiWqiNawsH3MYUexOBGbk=;
	b=Vd84DCz/RR67SJpNSVc/YDnIlzYhqNgMRGw6NGFQdTNgNkxKuL7efjOTXoBKtXeLF/oWH3
	pln8Snreh1/zxbWbSz8Re1O44WIkuRBcAxsYm0iFUg3eeH0od5MvzBb9blW1fjaJkfzf/H
	yq0SBd0tYUsWcHfPlK71wWtKoL2JBlQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-322-V4TAySTsM_a9W5eRLdHZwA-1; Mon,
 16 Nov 2026 14:46:07 -0500
X-MC-Unique: V4TAySTsM_a9W5eRLdHZwA-1
X-Mimecast-MFC-AGG-ID: V4TAySTsM_a9W5eRLdHZwA_1794858366
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C768C180060B;
	Mon, 16 Nov 2026 19:46:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6065D3001DAC;
	Mon, 16 Nov 2026 19:46:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6AGJk4HK3204805
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 16 Nov 2026 14:46:04 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6AGJk30N3204804;
	Mon, 16 Nov 2026 14:46:03 -0500
Date: Mon, 16 Nov 2026 14:46:03 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Brian Bunker <brian@purestorage.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH v4 1/1] multipathd: recheck WWIDs of re-added paths with
 the device
Message-ID: <avtdexYN1B3pJLmL@redhat.com>
References: <20261111181642.51912-1-brian@purestorage.com>
 <20261111181642.51912-2-brian@purestorage.com>
 <179452227264.147392.9708937185980533136.b4-review@b4>
 <avdQNjzddtu7o18n@redhat.com>
 <9259d20188a042cb280bad95f8be9783d1b9c1fd.camel@suse.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <9259d20188a042cb280bad95f8be9783d1b9c1fd.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Nd3ycuAn11mEuIQSeftJ6hVSLWcIQpmcSPalXT0s8FI_1794858366
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Nov 13, 2026 at 09:52:23PM +0100, Martin Wilck wrote:
> On Fri, 2026-11-13 at 13:00 -0500, Benjamin Marzinski wrote:
> > On Thu, Nov 12, 2026 at 11:24:32PM +0100, Martin Wilck wrote:
> > > 
> > > >  	}
> > > > +	/*
> > > > +	 * This path is being re-added because its udev data was
> > > > missing or
> > > > +	 * changed. The uevent may have been queued long before
> > > > we got here,
> > > > +	 * and adding a path to the map of a different LUN
> > > > corrupts data. If
> > > > +	 * recheck_wwid is set, confirm the WWID with the device
> > > > first. On a
> > > > +	 * mismatch, leave the path out and let the checker
> > > > retrigger udev
> > > > +	 * to get a fresh WWID.
> > > > +	 */
> > > > +	if (mode == PATH_ADD_REINIT && pp->recheck_wwid ==
> > > > RECHECK_WWID_ON &&
> > > > +	    check_path_wwid_change(pp)) {
> > > 
> > > check_path_wwid_change() returns false when it fails, is it correct
> > > to keep the
> > > path in that case? IMHO we should treat this like the strlen(pp-
> > > >wwid) == 0 case
> > > above.
> > 
> > Not sure I agree with this. It's a paranoia check. If it fails, I
> > don't
> > have a problem with just trusting the data that was given to us. I'm
> > willing to be convinced otherwise, however.
> 
> In my mind, a changed WWID followed by a failure to obtain the WWID
> from the device shows that something is really fishy about the path in
> question.
> 
> Moreover: 
> 
> I realize that uev_update_path() calls get_uid() with allow_fallback=0.
> This goes back to your commit ffaf947 ("multipathd: Don't use fallback
> code after getting wwid"), where the rationale you provided was 
> 
> > once the
> > devices are set up, udev is the definitive source of this information
> > ...
> > Working under the assumption that udev will either never give us this
> > information, or that it usually will. 
> 
> We have given up this assumption, at least partly. In view of the late
> discussions, it seems reasonable to me to allow fallback to SG_IO if
> udev failed, at least if pp->wwid was non-zero before.
> 
> Then, if the fallback failed, the situation would really be almost
> identical to the failing paranoia check.

I wrote my objection assuming that this code would also be called when
when we simply hadn't gotten the WWID on the first uevent. If we
retrigger a uevent and then get the WWID, but the SG_IO fails, we could
end up not creating the multipath device at all, despite the the path
existing with a WWID (albeit with some issues). Perhaps that's the
correct answer for an obviously flakey device. If this code was only run
when we got a wwid before and then it changed, then requiring a matching
WWID from the device seems much more reasonable. 
 
> > 
> > makes sense.
> > 
> > > But more generally: as this indicates a possible mismatch between
> > > kernel and device
> > > state, should we handle this similar to  handle_path_wwid_change()
> > > instead,
> > > i.e. also call rescan_path()? I guess that would need to be done in
> > > uev_update_path(),
> > > i.e. it would touch the regular "wwid changed in uevent" path.
> > 
> > Is this not another place were we are opening ourselves up for
> > commands
> > blocking? If we want to do a rescan and it can block, it makes more
> > sense to do it only if recheck_wwids is set, and we know that the
> > path
> > is up. 
> > 
> 
> Right, I didn't consider that rescan_path() may block. But still, why
> do we need to rescan in handle_path_wwid_change(), but not here? 
> 
> AFAICS, the likelihood that the kernel is using stale information is
> quite high when we handle this situation. I'm not sure if testing
> whether the path is up makes much sense. There are many situations in
> which the path would be down, but rescan/inquiry would still work. The
> only thing that would really hurt us are timeouts during the kernel's
> probing procedure, but I am not aware of an easy way to predict whether
> that will happen.
> 
> I suppose we could rescan asynchronously in this case. After all, we
> already have obtained the real WWID from the device, therefore we don't
> need to wait for the rescan to finish.

I'm not against the rescan, I just thought it made more sense in
ev_add_path(), although running it asynchronously works too.
 
> > > > 
> > > > +	}
> > > >  	mpp = find_mp_by_wwid(vecs->mpvec, pp->wwid);
> > > >  	if (mpp && pp->size && mpp->size != pp->size) {
> > > >  		condlog(0, "%s: failed to add new path %s,
> > > > device size mismatch", mpp->alias, pp->dev);
> > > > @@ -1375,7 +1390,7 @@ rescan:
> > > >  	if (ro == 1)
> > > >  		mpp->force_readonly = 1;
> > > >  
> > > > -	if (!need_do_map)
> > > > +	if (mode == PATH_ADD_NO_MAP)
> > > >  		return 0;
> > > >  
> > > >  	if (!dm_map_present(mpp->alias)) {
> > > > @@ -1789,7 +1804,7 @@ out:
> > > >  	}
> > > >  	/* pp->initialized must not be INIT_PARTIAL if
> > > > needs_reinit is set */
> > > >  	if (needs_reinit)
> > > > -		retval = uev_add_path(uev, vecs, 1);
> > > > +		retval = uev_add_path(uev, vecs,
> > > > PATH_ADD_REINIT);
> > > 
> > > Is it correct to take this branch also if needs_reinit is set
> > > because
> > > INIT_REQUESTED_UDEV was set? I don't think so.
> > 
> > This is a little tricky. I agree that we don't need to add the extra
> > layer of paranoid checking when the path never got a wwid. In that
> > case,
> > what most likely what happened is that the udev worker thread timed
> > out
> > on the previous uevent, so we couldn't get the WWID from uevent
> > variables. However, if we don't recheck on INIT_REQUESTED_UDEV, then
> > we
> > can get into a situation where:
> > 1. uev_update_path() notices that the wwid has changed
> > 2. ev_add_path() confirms that the wwid we got from udev doesn't
> > match
> >    the wwid we get directly asking the device
> > 3. We trigger a new uevent
> > 4. We blindly trust udev's wwid.
> 
> We need to trust udev at some point, don't we? Assume
> 
> 4. we double check again 
> 5. ev_add_path() confirms that the wwid we got from udev doesn't match
> 6. goto 3 
> 
> At least we'd need to avoid getting stuck in a loop.

This will only loop for retrigger_tries. Then it will give up and trust
udev without double-checking. Athough we never reset pp->retriggers once
we have a reasonable WWID, so we only get retrigger_tries for the entire
lifetime of the path. It seems like the retries when we couldn't get a
WWID from udev are different than the retries when the WWIDs don't
match.
 
> AFAICS there are 2 reasons to do the SG_IO check:
> 
> 1) vpd info from sysfs may be stale (affects SUSE only)
> 2) something changed between the VPD detection in udev rules and our
> event handling
> 
> Then there is
> 
> 3) a bug e.g. in an udev rule causes ID_SERIAL to be consistently
> wrong.
> 
> Case 1) would be fixed triggering a rescan (see above). In case 2), it
> makes a certain amount of sense to trust udev the next time. Case 3)
> would cause an infinite loop if we keep double-checking.
> 
> > Perhaps we need more initialization states or a path device flag to
> > distinguish between the two cases (never having gotten a WWID, or
> > having
> > our WWID . Or we can decide that we are o.k. with extra checking
> > whenever something goes wrong with getting the wwid from udev (when
> > you
> > have recheck_wwid set). Or am I misunderstanding something about why
> > doing this is wrong? Are we intentionally only double-checking once
> > here?
> 
> I don't like the idea of checking the first time around very much, but
> I agree it isn't a big deal. OTOH, see above.

If it's fine to only do one double-check before trusting udev, then
PATH_ADD_REINIT is just for that one recheck, and what to do in that
case is less ambiguous.
 
> Yet another possibility is to introduce a new mode where we just never
> trust udev. That'd be a 180" turn, but it might be worth trying.
> The longer we discuss this, the more attractive it seems to me. Rather
> than guessing whether or not we can trust udev, just use a "zero trust"
> model :-)

I wouldn't be against it. Device WWIDs could potentially switch between
modes. But as long as users know that they would need to be careful when
switching modes, that should be fine. Were you thinking of always
getting the wwid through SG_IO, or were you thinking of using something
like sysfs that could still potentially give you a stale value?

-Ben

> Regards
> Martin
> 
> -- 
> Dr. Martin Wilck <mwilck@suse.com>
> SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 Nürnberg,
> Germany
> Geschäftsführer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
> 36809,AG Nürnberg)

