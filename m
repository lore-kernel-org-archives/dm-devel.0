Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A975D2E92DA
	for <dm-devel@lists.linux.dev>; Thu,  6 Nov 2025 21:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762466400; cv=none; b=RrabS08Shsr6ZPVcuQGQw06LLZtKIx/mwQpcSFaZDnV7uLUPonapz2Xp+8eBwA/SE6eHych9QYdCv0tm8iqQKdatIn7fX3hLIk1sqVWLACn/ndfCEXOrfn9fQpwaUS/CcZ772nQwAWH373s0xVhsq/uv24CiAOkIXtMA0vdCZ2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762466400; c=relaxed/simple;
	bh=0HxxP/FK/H5zr2MAlPNsdcHJR20qqvTKraCLViFSmPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=BeRkHyoUTJMMWenT6ml9smiRMZrW1+UGsfn/hPl5e4jn4eMAUSxpqzuRhBp5lX95GS5v9BuAYIlAtAp5Osjsr8lRTN6fOV5+x4RrUl3ERBszsiX8Zyxby875UBIIbfwslcysGOW7muWXNIQ7kV4XwqZwLWrERYdVqbNG3yP0T3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M7fBeU8V; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M7fBeU8V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762466397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U3wg8ZgXFxB9IE4kwtUIRx/lW/SZJw/93TAeYIKMgA4=;
	b=M7fBeU8VcmpFcWEyEH7QDuA83cREADGaKpEMnoE8X7GlTIg8INKAyF7mypNaWTUIO1SwCc
	AOmBeRhGPytRATzk7kMCJIUJvb3G3UF540pybgadmxTzY8hzpTKMlD3pE9e9YfeKVO8Etl
	Kcwy5iQZMBLVpk7F90JXEJ8PXF1Krh4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-562-nxRffnAmPOiiPSuEfUdlWw-1; Thu,
 06 Nov 2025 16:59:54 -0500
X-MC-Unique: nxRffnAmPOiiPSuEfUdlWw-1
X-Mimecast-MFC-AGG-ID: nxRffnAmPOiiPSuEfUdlWw_1762466393
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5B5871956080;
	Thu,  6 Nov 2025 21:59:53 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EFF0C19560A7;
	Thu,  6 Nov 2025 21:59:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5A6LxpUk441041
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 6 Nov 2025 16:59:51 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5A6LxpTo441040;
	Thu, 6 Nov 2025 16:59:51 -0500
Date: Thu, 6 Nov 2025 16:59:51 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH] multipathd: Fix race while registering PR key
Message-ID: <aQ0aV0VsQVcn56W8@redhat.com>
References: <20251031191935.186170-1-bmarzins@redhat.com>
 <f3932800e329c528e9f28275c656cc5fb7fa8a57.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <f3932800e329c528e9f28275c656cc5fb7fa8a57.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BWGm1uwA8iREOKxesM16J86pYJAz0NepU2dkrRmmdD4_1762466393
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Nov 06, 2025 at 09:15:48PM +0100, Martin Wilck wrote:
> On Fri, 2025-10-31 at 15:19 -0400, Benjamin Marzinski wrote:
> > When libmpathpersist registers a key, It first checks which paths are
> > active, then registers the key on those paths, and then tells
> > multipathd
> > that the key has been registered, and it should start tracking it. If
> > a path comes up after libmpathpersist checks for active paths, but
> > before
> > it tells multipathd that the key has been registered, multipathd will
> > not
> > register a key no that path (since it hasn't been told to that the
> > device
> > has a registered key yet). This can leave the device with a path that
> > is
> > missing a key.
> > 
> > To solve this, when multipathd is told that a key has been
> > registered,
> > it checks if there are the same number of registered keys as active
> > paths.  If there aren't, it registers keys on all the paths (at least
> > until the number of registered keys and active paths are equal).
> 
> You may want to mention here that the nr_key_wanted check in
> mpath_pr_event_handle() and the nr_active check in 
> pr_register_active_paths actually allow us to short-circuit a couple of
> PR operations.

Sure. I sort of alude to it, but admittedly, it's not at all obvious
that the first call to update_map_pr() in mpath_pr_event_handle(), when
nr_keys_wanted is set, is what I'm referring to when I say that "it
checks if there are the same number of registered keys as active paths."

> 
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  multipathd/cli_handlers.c |  6 ++++-
> >  multipathd/main.c         | 47 ++++++++++++++++++++++++++++---------
> > --
> >  multipathd/main.h         |  1 +
> >  3 files changed, 40 insertions(+), 14 deletions(-)
> > 
> > diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> > index 7f572fb4..2812d01e 100644
> > --- a/multipathd/cli_handlers.c
> > +++ b/multipathd/cli_handlers.c
> > @@ -1291,7 +1291,11 @@ cli_setprstatus(void * v, struct strbuf
> > *reply, void * data)
> >  
> >  	if (mpp->prflag != PR_SET) {
> >  		set_pr(mpp);
> > -		condlog(2, "%s: prflag set", param);
> > +		pr_register_active_paths(mpp, true);
> > +		if (mpp->prflag == PR_SET)
> > +			condlog(2, "%s: prflag set", param);
> > +		else
> > +			condlog(0, "%s: Failed to set prflag",
> > param);
> >  	}
> >  	memset(&mpp->old_pr_key, 0, 8);
> >  
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index d11a8576..70268d98 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -90,7 +90,8 @@
> >  #define MSG_SIZE 32
> >  
> >  static unsigned int
> > -mpath_pr_event_handle(struct path *pp, unsigned int nr_keys_needed);
> > +mpath_pr_event_handle(struct path *pp, unsigned int nr_keys_needed,
> > +		      unsigned int nr_keys_wanted);
> >  
> >  #define LOG_MSG(lvl, pp)					\
> >  do {								\
> > @@ -629,19 +630,28 @@ flush_map_nopaths(struct multipath *mpp, struct
> > vectors *vecs) {
> >  	return true;
> >  }
> >  
> > -static void
> > -pr_register_active_paths(struct multipath *mpp)
> > +void pr_register_active_paths(struct multipath *mpp, bool
> > check_nr_active)
> >  {
> >  	unsigned int i, j, nr_keys = 0;
> > +	unsigned int nr_active = 0;
> >  	struct path *pp;
> >  	struct pathgroup *pgp;
> >  
> > +	if (check_nr_active) {
> > +		nr_active = count_active_paths(mpp);
> > +		if (!nr_active)
> > +			return;
> > +	}
> > +
> >  	vector_foreach_slot (mpp->pg, pgp, i) {
> >  		vector_foreach_slot (pgp->paths, pp, j) {
> >  			if (mpp->prflag == PR_UNSET)
> >  				return;
> > -			if ((pp->state == PATH_UP) || (pp->state ==
> > PATH_GHOST))
> > -				nr_keys = mpath_pr_event_handle(pp,
> > nr_keys);
> > +			if (pp->state == PATH_UP || pp->state ==
> > PATH_GHOST) {
> > +				nr_keys = mpath_pr_event_handle(pp,
> > nr_keys, nr_active);
> > +				if (check_nr_active && nr_keys ==
> > nr_active)
> > +					return;
> > +			}
> >  		}
> >  	}
> >  }
> > @@ -729,7 +739,7 @@ fail:
> >  
> >  	sync_map_state(mpp, false);
> >  
> > -	pr_register_active_paths(mpp);
> > +	pr_register_active_paths(mpp, false);
> >  
> >  	if (VECTOR_SIZE(offline_paths) != 0)
> >  		handle_orphaned_offline_paths(offline_paths);
> > @@ -1319,7 +1329,7 @@ rescan:
> >  		verify_paths(mpp);
> >  		mpp->action = ACT_RELOAD;
> >  		prflag = mpp->prflag;
> > -		mpath_pr_event_handle(pp, 0);
> > +		mpath_pr_event_handle(pp, 0, 0);
> >  	} else {
> >  		if (!should_multipath(pp, vecs->pathvec, vecs-
> > >mpvec)) {
> >  			orphan_path(pp, "only one path");
> > @@ -1403,7 +1413,7 @@ rescan:
> >  
> >  	if (retries >= 0) {
> >  		if ((mpp->prflag == PR_SET && prflag != PR_SET) ||
> > start_waiter)
> > -			pr_register_active_paths(mpp);
> > +			pr_register_active_paths(mpp, false);
> >  		condlog(2, "%s [%s]: path added to devmap %s",
> >  			pp->dev, pp->dev_t, mpp->alias);
> >  		return 0;
> > @@ -2646,9 +2656,9 @@ update_path_state (struct vectors * vecs,
> > struct path * pp)
> >  			 */
> >  			condlog(2, "%s: checking persistent "
> >  				"reservation registration", pp-
> > >dev);
> > -			mpath_pr_event_handle(pp, 0);
> > +			mpath_pr_event_handle(pp, 0, 0);
> >  			if (pp->mpp->prflag == PR_SET && prflag !=
> > PR_SET)
> > -				pr_register_active_paths(pp->mpp);
> > +				pr_register_active_paths(pp->mpp,
> > false);
> >  		}
> >  
> >  		/*
> > @@ -3309,7 +3319,7 @@ configure (struct vectors * vecs, enum
> > force_reload_types reload_type)
> >  	vector_foreach_slot(mpvec, mpp, i){
> >  		if (remember_wwid(mpp->wwid) == 1)
> >  			trigger_paths_udev_change(mpp, true);
> > -		pr_register_active_paths(mpp);
> > +		pr_register_active_paths(mpp, false);
> >  	}
> >  
> >  	/*
> > @@ -4341,16 +4351,25 @@ static int update_map_pr(struct multipath
> > *mpp, struct path *pp, unsigned int *n
> >  }
> >  
> >  /*
> > - * This function is called with the number of registered keys that
> > should be
> > + * This function is called with two numbers
> > + *
> > + * nr_keys_needed: the number of registered keys that should be
> >   * seen for this device to know that the key has not been preempted
> > while the
> >   * path was getting registered. If 0 is passed in, update_mpath_pr
> > is called
> >   * before registering the key to figure out the number, assuming
> > that at
> >   * least one key must exist.
> >   *
> > + * nr_keys_wanted: Only used if nr_keys_needed is 0, so we don't
> > know how
> > + * many keys we currently have. If nr_keys_wanted in non-zero and
> > the
> > + * number of keys found by the initial call to update_map_pr()
> > matches it,
> > + * exit early, since we have all the keys we are expecting.
> > + *
> >   * The function returns the number of keys that are registered or 0
> > if
> >   * it's unknown.
> >   */
> > -static unsigned int mpath_pr_event_handle(struct path *pp, unsigned
> > int nr_keys_needed)
> > +static unsigned int
> > +mpath_pr_event_handle(struct path *pp, unsigned int nr_keys_needed,
> > +		      unsigned int nr_keys_wanted)
> >  {
> >  	struct multipath *mpp = pp->mpp;
> >  	int ret;
> > @@ -4366,6 +4385,8 @@ static unsigned int
> > mpath_pr_event_handle(struct path *pp, unsigned int nr_keys_
> >  		nr_keys_needed = 1;
> >  		if (update_map_pr(mpp, pp, &nr_keys_needed) !=
> > MPATH_PR_SUCCESS)
> >  			return 0;
> > +		if (nr_keys_wanted && nr_keys_wanted ==
> > nr_keys_needed)
> > +			return nr_keys_needed;
> 
> I am wondering about the case that prflag gets unset by update_map_pr()
> while nr_active is 1. In this case we'd return early without clearing
> the registration. Is that correct?
> 
> I get it that this must mean that update_map_pr() has found 0 paths
> with this key registered. But the comment below in the mpp->prflag !=
> PR_SET suggests that maybe the registration should still be cleared.
> 
> Please explain.

Ah. When update_map_pr() unsets prflag, it leaves nr_keys_needed alone,
meaning that you could exit via the shortcut when called with
nr_keys_wanted set to 1, instead running the clear code. I didn't think
about that. Good catch. The number of things that would have to go just
perfectly wrong for this to cause a problem is pretty staggering
(everything necessary for the bug I'm trying to fix, plus a preempt
coming in, and then the path that libmpathpersist did register the key
on failing in multipathd, all between when libmpathpersist starts
registering the key, and when multipathd processes the "setprstatus"
command). But it is, at least in theory, possible.

I'll send an updated patch that adds some explanation to the commit
message and sets *nr_keys to zero in update_map_pr()
when we return with mpp->prflag unset. That will make us run the code
to clear any old registration from the path.

-Ben

> 
> Regards
> Martin
> 
> 
> >  	}
> >  
> >  	check_prhold(mpp, pp);
> > diff --git a/multipathd/main.h b/multipathd/main.h
> > index 29b57e3d..6d60ee81 100644
> > --- a/multipathd/main.h
> > +++ b/multipathd/main.h
> > @@ -54,4 +54,5 @@ int resize_map(struct multipath *mpp, unsigned long
> > long size,
> >  	       struct vectors *vecs);
> >  void set_pr(struct multipath *mpp);
> >  void unset_pr(struct multipath *mpp);
> > +void pr_register_active_paths(struct multipath *mpp, bool
> > check_active_nr);
> >  #endif /* MAIN_H_INCLUDED */

