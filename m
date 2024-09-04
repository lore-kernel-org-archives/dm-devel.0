Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175A71E00B6
	for <dm-devel@lists.linux.dev>; Wed,  4 Sep 2024 18:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725473772; cv=none; b=Sz0j0o+zyk8S4WH5y+UPTxCVJNUxYaMyK1O3K40Ee46ZMP4+imqJBLYgci+PheihU9xTmV7HGtqV3i4B/zdqQf/numQYJQ3ZL5eEcHJB7jPEuRaKWAO5x0uEtgJNF4BsqYZ1j7DiLaPO02PwceEQ2S1bE+s/sXH8F/FkXYpUk+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725473772; c=relaxed/simple;
	bh=EZRA2KxAOzQ/nwALbCUGAUkn6umzm9MKFd85o8yr6YM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=UkNLKxufNaUDxfdSIYTcyTHswyKztf39jVE3cYleYSOSIr3AsX/Hg3x6IMUfuqfuhgAPvDcVNfTtBBQfYPlOPOgVfjm06OXNxxsOpx3Z2vXo1KT6UdvLHu59BLeG/0ucMY0j0g+lqWW5orL9X+7waLiQqv7uerN077DdibwWnkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W7ionsF+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W7ionsF+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725473770;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=03q2IVOnt19BSulu++Cxx2aMEMviWVUSz+dXzZomDbY=;
	b=W7ionsF+g3Ye32bFhpQuRuk93a/aQVzMcUzHRL5nOWxFNd30SgtHMDnhoccR+EjrdF1SPw
	pH9opJ3BmBet2fqtgAjIPCex36C7a/qfFwYtoz5zMpytfzWfVyrKiVTERat5u029xyjdw3
	2T8OY9OHGZJ3rPITYUbUXdIokrvFIjc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-497-Bhu1gTjQMLqXeDtUnzzJtQ-1; Wed,
 04 Sep 2024 14:16:08 -0400
X-MC-Unique: Bhu1gTjQMLqXeDtUnzzJtQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 46FD71955D45;
	Wed,  4 Sep 2024 18:16:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E5DE11956052;
	Wed,  4 Sep 2024 18:16:06 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 484IG5g8476720
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 4 Sep 2024 14:16:05 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 484IG4Xp476719;
	Wed, 4 Sep 2024 14:16:04 -0400
Date: Wed, 4 Sep 2024 14:16:04 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 03/15] libmultipath: split out the code to wait for
 pending checkers
Message-ID: <Ztij5HLMXmw1apYh@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
 <20240828221757.4060548-4-bmarzins@redhat.com>
 <43945011477a7fb65c6bd267c8302d91961d4c59.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <43945011477a7fb65c6bd267c8302d91961d4c59.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Sep 04, 2024 at 05:01:39PM +0200, Martin Wilck wrote:
> On Wed, 2024-08-28 at 18:17 -0400, Benjamin Marzinski wrote:

<snip>

> > diff --git a/libmultipath/checkers/tur.c
> > b/libmultipath/checkers/tur.c
> > index a2905af5..95af5214 100644
> > --- a/libmultipath/checkers/tur.c
> > +++ b/libmultipath/checkers/tur.c
> > @@ -323,6 +323,49 @@ static int tur_check_async_timeout(struct
> > checker *c)
> >  	return (now.tv_sec > ct->time);
> >  }
> >  
> > +int check_pending(struct checker *c, struct timespec endtime)
> > +{
> > +	struct tur_checker_context *ct = c->context;
> > +	int r, tur_status = PATH_PENDING;
> > +
> > +	pthread_mutex_lock(&ct->lock);
> > +
> > +	for (r = 0;
> > +	     r == 0 && ct->state == PATH_PENDING &&
> > +	     ct->msgid == MSG_TUR_RUNNING;
> > +	     r = pthread_cond_timedwait(&ct->active, &ct->lock,
> > &endtime));
> > +
> > +	if (!r) {
> > +		tur_status = ct->state;
> > +		c->msgid = ct->msgid;
> > +	}
> > +	pthread_mutex_unlock(&ct->lock);
> > +	if (tur_status == PATH_PENDING && c->msgid ==
> > MSG_TUR_RUNNING) {
> > +		condlog(4, "%d:%d : tur checker still running",
> > +			major(ct->devt), minor(ct->devt));
> > +	} else {
> > +		int running = uatomic_xchg(&ct->running, 0);
> > +		if (running)
> > +			pthread_cancel(ct->thread);
> > +		ct->thread = 0;
> > +	}
> > +
> > +	return tur_status;
> > +}
> > +
> > +int libcheck_pending(struct checker *c)
> > +{
> > +	struct timespec endtime;
> > +	struct tur_checker_context *ct = c->context;
> > +
> > +	/* The if path checker isn't running, just return the
> > exiting value. */
> > +	if (!ct || !ct->thread)
> > +		return c->path_state;
> > +
> > +	get_monotonic_time(&endtime);
> > +	return check_pending(c, endtime);
> 
> Does this work? 
> 
> https://pubs.opengroup.org/onlinepubs/009695299/functions/pthread_cond_timedwait.html
> says that "an error is returned [...] if the absolute time specified by
> abstime has already been passed at the time of the call".
> 
> Which would always be the case if you pass a timestamp that you 
> fetched previously unmodified, meaning that you'd always get ETIMEDOUT.
> Or am I misreading the docs?

No. You are reading the docs right.  I'm just don't understand why
that's a problem.  When you start the checker, you set a timeout that
you want to wait for, to give the checker a chance to complete in this
checker loop. Once that timeout has passed, if the thread is still
running, then libcheck_pending should return PATH_PENDING.
pthread_cond_timedwait() doesn't get called unless the thread is
running. So I would argue that pthread_cond_timedwait() always failing
once that timeout has passed is the correct thing to do.

Or are you arguing for having check_pending() manually check if the
timeout has passed, and skipping the call to pthread_cond_timedwait() in
that case? 

With the directio checker, we need to call get_events() even once our
timeout has passed, since we need to handle any async IOs that have
completed since the last call to check_pending(). But in there's no need
to call pthread_cond_timedwait() for the tur checker, so we could skip
it if we saw that the timeout had already passed. I would argue that
this is just duplicating the check from pthread_cond_timedwait() in
check_pending() for no real benfit though.

Or am I missing something here?

-Ben

> Martin
> 
> 
> 
> 
> 
> 
> 
> > +}
> > +
> >  int libcheck_check(struct checker * c)
> >  {
> >  	struct tur_checker_context *ct = c->context;
> > @@ -437,27 +480,7 @@ int libcheck_check(struct checker * c)
> >  			return tur_check(c->fd, c->timeout, &c-
> > >msgid);
> >  		}
> >  		tur_timeout(&tsp);
> > -		pthread_mutex_lock(&ct->lock);
> > -
> > -		for (r = 0;
> > -		     r == 0 && ct->state == PATH_PENDING &&
> > -			     ct->msgid == MSG_TUR_RUNNING;
> > -		     r = pthread_cond_timedwait(&ct->active, &ct-
> > >lock, &tsp));
> > -
> > -		if (!r) {
> > -			tur_status = ct->state;
> > -			c->msgid = ct->msgid;
> > -	}
> > -		pthread_mutex_unlock(&ct->lock);
> > -		if (tur_status == PATH_PENDING && c->msgid ==
> > MSG_TUR_RUNNING) {
> > -			condlog(4, "%d:%d : tur checker still
> > running",
> > -				major(ct->devt), minor(ct->devt));
> > -		} else {
> > -			int running = uatomic_xchg(&ct->running, 0);
> > -			if (running)
> > -				pthread_cancel(ct->thread);
> > -			ct->thread = 0;
> > -		}
> > +		tur_status = check_pending(c, tsp);
> >  	}
> >  
> >  	return tur_status;

