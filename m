Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5E23195F5
	for <dm-devel@lists.linux.dev>; Mon, 22 Sep 2025 18:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758564601; cv=none; b=mYqJf/mmseIdClGmBClSgJfiyl+pdzBWeEi4OYe6c6L/iIqL/sTewC64iyHhooiddNXk5GtLtmrdB0e0w87dyR64GVgjrLY7yslSYBmz+yASu+wgDQye+KAS9Us60kYUbrT7FwDufLIVwVj6IaAuaXdkPKxv5O+UYMflhfXcHaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758564601; c=relaxed/simple;
	bh=Ar4RhvC7oL71omDp7+sZNhXGqfLUVwqeAf8T2lHFoRc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=LXzyExo/3dbaNha+M6j+0s+8+pcjVatsRs6dJHwzpMn1tjxEQxfNFHOiEDuErXR7EZizjtSORtCObCA3aZQ9Tnn0gGKhaxeT5BurooFNIyCJzuEvvXWxGpOOb284SthReBIBFBq1XNr1P4zBNlntjmDf+3eAmd+iV1YtPlXRCz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kka9HICn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kka9HICn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758564598;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=do2HC+k0lPFJGzntCh+Sd3iUjOL5k48tdmzfMFKpZak=;
	b=Kka9HICnH3ChSmpMcXbrKUEMoqjsOGWqXpR2SYInvjfbFFxm1za2yifAi/MS3SmSKYeqvR
	aLSiZzRYYd6DBTyD8kQu67ABaZjRTLDeZsBmQCdjisswJg/rcSqEWoC/TPs7uevOEJcrA/
	zprcwjEA+ZiGIPEpfZRRNsc7sWIaxPc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-319-D8guD3DGM4eho-YHyD75MA-1; Mon,
 22 Sep 2025 14:09:52 -0400
X-MC-Unique: D8guD3DGM4eho-YHyD75MA-1
X-Mimecast-MFC-AGG-ID: D8guD3DGM4eho-YHyD75MA_1758564592
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D21211956046;
	Mon, 22 Sep 2025 18:09:51 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7FAB13000198;
	Mon, 22 Sep 2025 18:09:51 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 58MI9oOt1353884
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Sep 2025 14:09:50 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 58MI9nC61353883;
	Mon, 22 Sep 2025 14:09:49 -0400
Date: Mon, 22 Sep 2025 14:09:49 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 2/2] libmpathpersist: handle preempting all registrants
 reservations
Message-ID: <aNGQ7ZqwHEwA27L8@redhat.com>
References: <20250910225812.829847-1-bmarzins@redhat.com>
 <20250910225812.829847-3-bmarzins@redhat.com>
 <82a83835794202de7fe4f2093802d51df888a50d.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <82a83835794202de7fe4f2093802d51df888a50d.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: L01bPGzmAWFmENTFEXPVL0DFwXpg4W0Mvhy4UqhNs9w_1758564592
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Sep 22, 2025 at 06:53:05PM +0200, Martin Wilck wrote:
> On Wed, 2025-09-10 at 18:58 -0400, Benjamin Marzinski wrote:
> > All Registrants reservations (types 7 and 8) are held by key 0x0.
> > When
> > preempting one, all registrations are cleared, except for the one on
> > the
> > path that issued the PREEMPT. libmpathpersist needs to handle this
> > just
> > like the other cases of self-preemption, so that all the paths of the
> > preempting multipath device have their registrations restored while
> > the
> > device is suspended.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmpathpersist/mpath_persist_int.c | 31 +++++++++++++++++++++++++--
> > --
> >  1 file changed, 27 insertions(+), 4 deletions(-)
> > 
> > diff --git a/libmpathpersist/mpath_persist_int.c
> > b/libmpathpersist/mpath_persist_int.c
> > index 9f301859..ab3d70cd 100644
> > --- a/libmpathpersist/mpath_persist_int.c
> > +++ b/libmpathpersist/mpath_persist_int.c
> > @@ -569,8 +569,9 @@ static int mpath_prout_reg(struct multipath
> > *mpp,int rq_servact, int rq_scope,
> >   * is suspended before issuing the preemption, and the keys are
> > reregistered
> >   * before resuming it.
> >   */
> > -static int preempt_self(struct multipath *mpp, int rq_servact, int
> > rq_scope,
> > -			unsigned int rq_type, int noisy, bool
> > do_release)
> > +static int do_preempt_self(struct multipath *mpp, struct be64
> > sa_key,
> > +			   int rq_servact, int rq_scope, unsigned
> > int rq_type,
> > +			   int noisy, bool do_release)
> >  {
> >  	int status, rel_status = MPATH_PR_SUCCESS;
> >  	struct path *pp = NULL;
> > @@ -583,7 +584,7 @@ static int preempt_self(struct multipath *mpp,
> > int rq_servact, int rq_scope,
> >  	}
> >  
> >  	memcpy(paramp.key, &mpp->reservation_key, 8);
> > -	memcpy(paramp.sa_key, &mpp->reservation_key, 8);
> > +	memcpy(paramp.sa_key, &sa_key, 8);
> >  	status = mpath_prout_common(mpp, rq_servact, rq_scope,
> > rq_type,
> >  				    &paramp, noisy, &pp);
> >  	if (status != MPATH_PR_SUCCESS) {
> > @@ -619,6 +620,21 @@ fail_resume:
> >  	return (rel_status != MPATH_PR_SUCCESS) ? rel_status :
> > status;
> >  }
> >  
> > +static int preempt_self(struct multipath *mpp, int rq_servact, int
> > rq_scope,
> > +			unsigned int rq_type, int noisy, bool
> > do_release)
> > +{
> > +	return do_preempt_self(mpp, mpp->reservation_key,
> > rq_servact, rq_scope,
> > +			       rq_type, noisy, do_release);
> > +}
> > +
> > +static int preempt_all(struct multipath *mpp, int rq_servact, int
> > rq_scope,
> > +		       unsigned int rq_type, int noisy)
> > +{
> > +	struct be64 zerokey = {0};
> > +	return do_preempt_self(mpp, zerokey, rq_servact, rq_scope,
> > rq_type,
> > +			       noisy, false);
> > +}
> > +
> >  static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int
> > rq_scope,
> >  			   unsigned int rq_type,
> >  			   struct prout_param_descriptor * paramp,
> > int noisy)
> > @@ -889,8 +905,15 @@ int do_mpath_persistent_reserve_out(vector
> > curmp, vector pathvec, int fd,
> >  		break;
> >  	case MPATH_PROUT_PREE_SA:
> >  	case MPATH_PROUT_PREE_AB_SA:
> > -		if (reservation_key_matches(mpp, paramp->sa_key,
> > noisy) == YNU_YES)
> > +		if (reservation_key_matches(mpp, paramp->sa_key,
> > noisy) == YNU_YES) {
> >  			preempting_reservation = true;
> > +			if (memcmp(paramp->sa_key, &zerokey, 8) ==
> > 0) {
> 
> 
> Don't you need to check if pr_type is 7 or 8 here?

I don't think so. When we get here, we know that the reservation is
reported to be held by the key 0x0. That's obviously not a valid
registered key. I'm pretty sure that a SCSI device will only report this
reservation key in the "all registrants" case, and that "all
registrants" reservations will always report 0x0 as the key.

That being said, I needed to make reservation_key_matches() return the
reservation type to handle a different issue, so it's pretty trivial to
make this code double-check it for this case.

-Ben 

> 
> > +				/* all registrants case */
> > +				ret = preempt_all(mpp, rq_servact,
> > rq_scope,
> > +						  rq_type, noisy);
> > +				break;
> > +			}
> > +		}
> >  		/* if we are preempting ourself */
> >  		if (memcmp(paramp->sa_key, paramp->key, 8) == 0) {
> >  			ret = preempt_self(mpp, rq_servact,
> > rq_scope, rq_type,

