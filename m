Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F522DCF55
	for <dm-devel@lists.linux.dev>; Mon, 20 Jul 2026 19:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784574530; cv=none; b=e9FCNh1Dho6PwMwIHy4/lNn1zRWYnNzdPhJ9d4BiEvBaexwDor+ibCiS+9jbmor9zYAJ3E65jGFEgEkW6VAF8QxKhyrv38U61uIt/GSExSqNv0ZWrPKJXjZQ2xPw+iRTIncHqBJljNzGoW7MN2c1Vnzfz1QaGsz9MBaKT69hOCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784574530; c=relaxed/simple;
	bh=Hi/412mpfeotrpj5vlBLfbg8GPZGNJ6EeQh+JMfVTxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Fnm7GURTctcylAjs8YpeK8F4ZlMyeCQF5vTDLzztpl2oaKvNOdf/HaU+pXwaS6OX3A37MxB3IXSVx5OriJLQEHtBWiq9EAnxTQAxW4HDWVpkQuB6/B5Hy9+OkJcVY9SfI2QPSy1yop5MVoXgrwtKK2CLWjs/T45hyKXvg0xcmfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RYZCIMW4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RYZCIMW4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784574527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JV4kvCoSKMChKemhQz0oYdTdruW+AYSOjas9E0pqe+c=;
	b=RYZCIMW4k0udtK0FS3zEq2xY8ql8D5Cws8TRT7bOKskiPrlcjF2pXCiYggneE9jM5pYj8D
	plMzgz2FgTXDS79hVnwIDQmm4WSWxUoFGIYWaxn1fti/Z8/rHyenbNmWvMByBZ8fKjmiXT
	8nd2KgEX7RQsBOdwSqJ4qYF5eH8T0nk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-196-iFJL9sMJNZyqnYSGwV86LA-1; Mon,
 20 Jul 2026 15:08:45 -0400
X-MC-Unique: iFJL9sMJNZyqnYSGwV86LA-1
X-Mimecast-MFC-AGG-ID: iFJL9sMJNZyqnYSGwV86LA_1784574524
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ACC151977016;
	Mon, 20 Jul 2026 19:08:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 620E71955F75;
	Mon, 20 Jul 2026 19:08:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 66KJ8hFW2459764
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 20 Jul 2026 15:08:43 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 66KJ8hbQ2459763;
	Mon, 20 Jul 2026 15:08:43 -0400
Date: Mon, 20 Jul 2026 15:08:43 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Cykang <cykang4830@gmail.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH] libmpathpersist: fix self-preemption when key has no
 active reservation
Message-ID: <al5yOwKrRT3uWzqW@redhat.com>
References: <20260711033107.2318-1-cykang4830@gmail.com>
 <33a65ffb59df981e93d9eb638249dc77fdabf38f.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <33a65ffb59df981e93d9eb638249dc77fdabf38f.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Xrkcn8fw4m8a9uV2MhrmXgk72xnsZxmwyrCZGswKygQ_1784574524
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Jul 16, 2026 at 10:41:27AM +0200, Martin Wilck wrote:
> Thanks for your patch!
> 
> On Sat, 2026-07-11 at 11:31 +0800, Cykang wrote:
> > According to the SCSI-3 Persistent Reservations specification, when a
> > self-preemption is performed with a key that does not currently hold
> > an active reservation, the operation should be treated as an
> > unregister
> > and should not fail.
> > 
> > The current code in do_mpath_persistent_reserve_out() does not check
> > whether the preempting key has a reservation before invoking the
> > self-preemption path. It unconditionally calls preempt_self() and
> > re-registers the key on the local paths, even when the key has no
> > reservation. This violates the SCSI-3 PR spec and can lead to
> > incorrect reservation states.
> > 
> > This patch moves the self-preemption check inside the conditional
> > block so that it only executes when the key matches, but does not
> > bypass the general preemption path for keys without a reservation.
> > With this change, the code will fall through to the common PR_OUT
> > handling (e.g., MPATH_PROUT_RES_SA or CLEAR_SA) when the key is not
> > reserved, allowing the storage target to properly process the
> > operation as an unregister.
> > 
> > Signed-off-by: Cykang <cykang4830@gmail.com>
> 
> Your patch would cause PREEMPT to do nothing at all when it doesn't own
> the reservation (more precisely, when sa_key doesn't match the mpp's
> key). That seems wrong to me. You are right that in this case the keys
> shouldn't be re-registered. But we must take care that the mpp's key is
> unregistered on all paths. AFAICS, this is the effect of the command
> 
> 	status = mpath_prout_common(mpp, rq_servact, rq_scope,
> rq_type,
> 				    &paramp, noisy, &pp, NULL);
> 

With Cykang's patch, this call happens in the
do_mpath_persistent_reserve_out() fallthrough, so it should still work.
And if we are unregistering, then there is no need to suspend while we
are doing the work, so I don't see a need for calling preempt_self() in
this case. The one thing we should do is call

update_prflag(mpp, 0);

on success. Multipathd should still detect that it was preempted if we
don't, but we might as well explicitly tell it.

-Ben

> in preempt_self(), if and only if this command was successful and the
> key of the mpp doesn't hold the current reservation. (According to SPC-
> 6, in this case the storage server should "remove the registrations for
> all I_T nexuses specified by the SERVICE ACTION RESERVATION KEY
> field").
> 
> So IMO what we should do is simply resume and return in preempt_self()
> after the above command if we don't hold the reservation, which we
> should check using check_holding_reservation().
> 
> I guess this requires a new PREE_WORK_ enum value.
> 
> I'll leave the final verdict to Ben, who knows the logic of our PR code
> better than me.
> 
> Regards
> Martin
> 
> 
> > ---
> >  libmpathpersist/mpath_persist_int.c | 13 +++++++------
> >  1 file changed, 7 insertions(+), 6 deletions(-)
> > 
> > diff --git a/libmpathpersist/mpath_persist_int.c
> > b/libmpathpersist/mpath_persist_int.c
> > index 3091c5c2..2ee7fe68 100644
> > --- a/libmpathpersist/mpath_persist_int.c
> > +++ b/libmpathpersist/mpath_persist_int.c
> > @@ -960,14 +960,15 @@ int do_mpath_persistent_reserve_out(vector
> > curmp, vector pathvec, int fd,
> >  				ret = preempt_all(mpp, rq_servact,
> > rq_scope,
> >  						  rq_type, noisy);
> >  				break;
> > +			}
> > +					/* if we are preempting
> > ourself */
> > +			if (memcmp(paramp->sa_key, paramp->key, 8)
> > == 0) {
> > +				ret = preempt_self(mpp, rq_servact,
> > rq_scope, rq_type,
> > +						noisy,
> > PREE_WORK_NONE);
> > +				break;
> >  			}
> >  		}
> > -		/* if we are preempting ourself */
> > -		if (memcmp(paramp->sa_key, paramp->key, 8) == 0) {
> > -			ret = preempt_self(mpp, rq_servact,
> > rq_scope, rq_type,
> > -					   noisy, PREE_WORK_NONE);
> > -			break;
> > -		}
> > +
> >  		/* fallthrough */
> >  	case MPATH_PROUT_RES_SA:
> >  	case MPATH_PROUT_CLEAR_SA: {
> 
> -- 
> Dr. Martin Wilck <mwilck@suse.com>
> SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 Nürnberg,
> Germany
> Geschäftsführer: Jochen Jaser, Andrew McDonald (HRB 36809,AG Nürnberg)

