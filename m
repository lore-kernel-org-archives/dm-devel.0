Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D510112D76F
	for <dm-devel@lists.linux.dev>; Fri, 19 Jul 2024 18:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721413881; cv=none; b=uSQJyOpHlivRL0fM+UI2iMgIj6CmrdGLO+cipw3jzjkOOSwZlLXJ0jEtA1LuEj0QVqRLq72vnsQmdBwTqacobwspVyaSnmS9LANn1nr76Wlmwvw05c7FBuA9aTLXUgR2fVi/WYh2ZFxJV7wzHMHr5hZTQpIuAFfZTV1U+zhn+vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721413881; c=relaxed/simple;
	bh=uGNOGmF9jebORiPtYWkA+ympEBbyekzLJ82VbgNgWgs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=KUTPXR5+k8dhTKeu9f12LVbhQM9KSOjydzt+tzsST7Nj9GLKNgvYMqF+4BuVTeLUN4aFhc84n+FZpijG/e4Zy7HTNmEr3d+Ez7xG4S6ouS9Zkvu748fgWZcv0a2F7ns3QoOvQ10dYFVrxwdpe+w36VTnN3mW0yd2xR6+1/5LXR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U0D01hWC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U0D01hWC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721413878;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O6tWk34JUwTT2xEUFGy+eE0PW3W8g6WWhULEEVmi8as=;
	b=U0D01hWCsYjrUkKfM12tZx8JDYIJWA0W4060yQnAMmSaO/P+xTf8IX3tbfy2QQPInqNZGV
	mWNgHUvTXDg4OVC1UQrNppI4SUbn4pAsn8WP7LWvt8T50PjVVRje/v1NOGVVOAyI7S7brp
	94SWEf8gOh0hAzRJJF9xI0aiVpKC7fc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-282-oYXcPDh0NtS-pj8l0VJoFw-1; Fri,
 19 Jul 2024 14:31:17 -0400
X-MC-Unique: oYXcPDh0NtS-pj8l0VJoFw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2D88919560B1;
	Fri, 19 Jul 2024 18:31:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7111D1955D47;
	Fri, 19 Jul 2024 18:31:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46JIVEaF2369426
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 19 Jul 2024 14:31:14 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46JIVDrN2369425;
	Fri, 19 Jul 2024 14:31:13 -0400
Date: Fri, 19 Jul 2024 14:31:13 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v2 17/20] multipathd: make multipath devices manage their
 path check times
Message-ID: <Zpqw8Saic5Ec-pXG@redhat.com>
References: <20240717181106.2173527-1-bmarzins@redhat.com>
 <20240717181106.2173527-18-bmarzins@redhat.com>
 <745dd5f5611bc3e571af1d03a563c370f9161c9c.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <745dd5f5611bc3e571af1d03a563c370f9161c9c.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Jul 18, 2024 at 10:24:13PM +0200, Martin Wilck wrote:
> On Wed, 2024-07-17 at 14:11 -0400, Benjamin Marzinski wrote:
> > multipathd's path checking can be very bursty, with all the paths
> > running their path checkers at the same time, and then all doing
> > nothing
> > while waiting for the next check time. Alternatively, the paths in a
> > multipath device might all run their path checkers at a different
> > time,
> > which can keep the multipath device from having a coherent view of
> > the
> > state of all of its paths.
> > 
> > This patch makes all the paths of a multipath device converge to
> > running
> > their checkers at the same time, and spreads out when this time is
> > for
> > the different multipath devices.
> > 
> > To do this, the checking time is divided into adjustment intervals
> > (conf->adjust_int), so that the checkers run at some index within
> > this
> > interval. conf->adjust_int is chosen so that it is a multiple of all
> > possible pp->checkint values. This means that regardless of
> > pp->checkint, the path should always be checked on the same indexes,
> > each adjustement interval.
> > 
> > Each multipath device has a goal index. These are evenly spread out
> > between 0 and conf->max_checkint. Every conf->adjust_int seconds,
> > each
> > multipath device should try to check all of its paths on its goal
> > index.
> > If the multipath device's check times are not aligned with the goal
> > index, then pp->tick for the next check will be decremented by one,
> > to
> > align it over time.
> > 
> > In order for the path checkers to run every pp->checkint seconds,
> > multipathd needs to track how long a path check has been pending for,
> > and subtract that time from the number of ticks till the checker is
> > run
> > again. If the checker has been pending for more that pp->checkint,
> > the path will be rechecked on the next tick after the checker
> > returns.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/config.c  | 12 ++++++
> >  libmultipath/config.h  |  1 +
> >  libmultipath/structs.c |  1 +
> >  libmultipath/structs.h |  1 +
> >  multipathd/main.c      | 91 ++++++++++++++++++++++++++++++++++------
> > --
> >  5 files changed, 89 insertions(+), 17 deletions(-)
> > 
> > diff --git a/libmultipath/config.c b/libmultipath/config.c
> > index 83fa7369..a59533b5 100644
> > --- a/libmultipath/config.c
> > +++ b/libmultipath/config.c
> > @@ -982,6 +982,18 @@ int _init_config (const char *file, struct
> > config *conf)
> >  		conf->checkint = conf->max_checkint;
> >  	condlog(3, "polling interval: %d, max: %d",
> >  		conf->checkint, conf->max_checkint);
> > +	/*
> > +	 * make sure that that adjust_int is a multiple of all
> > possible values
> > +	 * of pp->checkint.
> > +	 */
> > +	if (conf->max_checkint % conf->checkint == 0) {
> > +		conf->adjust_int = conf->max_checkint;
> > +	} else {
> > +		conf->adjust_int = conf->checkint;
> > +		while (2 * conf->adjust_int < conf->max_checkint)
> > +			conf->adjust_int *= 2;
> > +		conf->adjust_int *= conf->max_checkint;
> > +	}
> >  
> >  	if (conf->blist_devnode == NULL) {
> >  		conf->blist_devnode = vector_alloc();
> > diff --git a/libmultipath/config.h b/libmultipath/config.h
> > index 384193ab..800c0ca9 100644
> > --- a/libmultipath/config.h
> > +++ b/libmultipath/config.h
> > @@ -147,6 +147,7 @@ struct config {
> >  	int minio_rq;
> >  	unsigned int checkint;
> >  	unsigned int max_checkint;
> > +	unsigned int adjust_int;
> >  	bool use_watchdog;
> >  	int pgfailback;
> >  	int rr_weight;
> > diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> > index 0a26096a..232b4230 100644
> > --- a/libmultipath/structs.c
> > +++ b/libmultipath/structs.c
> > @@ -149,6 +149,7 @@ uninitialize_path(struct path *pp)
> >  	pp->state = PATH_UNCHECKED;
> >  	pp->uid_attribute = NULL;
> >  	pp->checker_timeout = 0;
> > +	pp->pending_ticks = 0;
> >  
> >  	if (checker_selected(&pp->checker))
> >  		checker_put(&pp->checker);
> > diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> > index 002eeae1..457d7836 100644
> > --- a/libmultipath/structs.h
> > +++ b/libmultipath/structs.h
> > @@ -360,6 +360,7 @@ struct path {
> >  	unsigned long long size;
> >  	unsigned int checkint;
> >  	unsigned int tick;
> > +	unsigned int pending_ticks;
> >  	int bus;
> >  	int offline;
> >  	int state;
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 84450906..87ddb101 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -2388,7 +2388,7 @@ enum check_path_return {
> >  };
> >  
> >  static int
> > -check_path (struct vectors * vecs, struct path * pp, unsigned int
> > ticks)
> > +do_check_path (struct vectors * vecs, struct path * pp)
> >  {
> >  	int newstate;
> >  	int new_path_up = 0;
> > @@ -2400,14 +2400,6 @@ check_path (struct vectors * vecs, struct path
> > * pp, unsigned int ticks)
> >  	int marginal_pathgroups, marginal_changed = 0;
> >  	bool need_reload;
> >  
> > -	if (pp->initialized == INIT_REMOVED)
> > -		return CHECK_PATH_SKIPPED;
> > -
> > -	if (pp->tick)
> > -		pp->tick -= (pp->tick > ticks) ? ticks : pp->tick;
> > -	if (pp->tick)
> > -		return CHECK_PATH_SKIPPED;
> > -
> >  	conf = get_multipath_config();
> >  	checkint = conf->checkint;
> >  	max_checkint = conf->max_checkint;
> > @@ -2419,12 +2411,6 @@ check_path (struct vectors * vecs, struct path
> > * pp, unsigned int ticks)
> >  		pp->checkint = checkint;
> >  	};
> >  
> > -	/*
> > -	 * provision a next check soonest,
> > -	 * in case we exit abnormally from here
> > -	 */
> > -	pp->tick = checkint;
> > -
> >  	newstate = check_path_state(pp);
> >  	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED)
> >  		return CHECK_PATH_SKIPPED;
> > @@ -2587,7 +2573,6 @@ check_path (struct vectors * vecs, struct path
> > * pp, unsigned int ticks)
> >  				condlog(4, "%s: delay next check
> > %is",
> >  					pp->dev_t, pp->checkint);
> >  			}
> > -			pp->tick = pp->checkint;
> >  		}
> >  	}
> >  	else if (newstate != PATH_UP && newstate != PATH_GHOST) {
> > @@ -2640,6 +2625,77 @@ check_path (struct vectors * vecs, struct path
> > * pp, unsigned int ticks)
> >  	return CHECK_PATH_CHECKED;
> >  }
> >  
> > +static int
> > +check_path (struct vectors * vecs, struct path * pp, unsigned int
> > ticks,
> > +	    time_t start_secs)
> > +{
> > +	int r;
> > +	unsigned int adjust_int, max_checkint;
> > +	struct config *conf;
> > +	time_t next_idx, goal_idx;
> > +
> > +	if (pp->initialized == INIT_REMOVED)
> > +		return CHECK_PATH_SKIPPED;
> > +
> > +	if (pp->tick)
> > +		pp->tick -= (pp->tick > ticks) ? ticks : pp->tick;
> > +	if (pp->tick)
> > +		return CHECK_PATH_SKIPPED;
> > +
> > +	conf = get_multipath_config();
> > +	max_checkint = conf->max_checkint;
> > +	adjust_int = conf->adjust_int;
> > +	put_multipath_config(conf);
> > +
> > +	r = do_check_path(vecs, pp);
> > +
> > +	/*
> > +	 * do_check_path() removed or orphaned the path.
> > +	 */
> > +	if (r < 0 || !pp->mpp)
> > +		return r;
> 
> do_check_path() returns an enum now, so this should be r ==
> CHECK_PATH_REMOVED.

Oops. Good catch.
-Ben

> 

