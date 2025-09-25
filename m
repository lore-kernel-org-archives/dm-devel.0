Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78AE1DF27D
	for <dm-devel@lists.linux.dev>; Thu, 25 Sep 2025 19:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758828908; cv=none; b=VpgnSEWH7NdlwRduWLn5f1bblEdk1J8dZIPg8bcM5zz4Ym3MNWx2sNZtwGxamTulLARkvZoMll+rT8DpoW22lHAJ1K8cpQUkuBvGCBN1VrJl4hqjabWERnVTOTLFH+bwjd3r8vvhdUXr7dBnBEcBVIeLmaH8SogcgWx5kyQoghc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758828908; c=relaxed/simple;
	bh=adOhpnSlU3VaEi9OvfR62BO3XQHS0y6Al3Eocp6HSXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=ay/YKC8cODDfJvCOtKDeKM7etNmF68Kf3v2TvExG7jC9BX/qtvGcdMTHmYR3GKsTyiFxcI0YExIQWWbMF9OvKkdwWrCbUVqlXFNbNhTbDNcLV2PyzZZSr3NQpHOjKEHD3o6O2POUrNEwWED8cE+6xDDjpotvXFQonDM2Z7cGdIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TRFNEd+6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TRFNEd+6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758828905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bjwzI/aux7g4n+cNZi0+cHs1rhAiJwBOhxyjZ+d0+zM=;
	b=TRFNEd+6NKRAf1tZKw+i6F0p00tPzTP5JSFc4+7oD1b+5GKM19XDqgbpU7qVya5xu6oyCZ
	18HMSWsOOwqMENj2g7uTaMIb0LkOVNFju0BXA+0nB7zm6g+C6McnQ1keOD65HbZK3aKPr4
	c7dljKGCL2rMVEPD3NI3aO2jGPVHMKs=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-269-xEc2Cr_mP3uGnyQtU1Wy0w-1; Thu,
 25 Sep 2025 15:35:01 -0400
X-MC-Unique: xEc2Cr_mP3uGnyQtU1Wy0w-1
X-Mimecast-MFC-AGG-ID: xEc2Cr_mP3uGnyQtU1Wy0w_1758828899
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A320219560B0;
	Thu, 25 Sep 2025 19:34:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 28EA019560A2;
	Thu, 25 Sep 2025 19:34:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 58PJYvAs1504686
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 25 Sep 2025 15:34:57 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 58PJYvva1504685;
	Thu, 25 Sep 2025 15:34:57 -0400
Date: Thu, 25 Sep 2025 15:34:57 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 4/4] libmpathpersist: Fix unregistering while holding the
 reservation
Message-ID: <aNWZYbXRWDmHvPu8@redhat.com>
References: <20250923221252.1411687-1-bmarzins@redhat.com>
 <20250923221252.1411687-5-bmarzins@redhat.com>
 <7a57bdf8bac354ac3548728afa1d72141fe900c9.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <7a57bdf8bac354ac3548728afa1d72141fe900c9.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ldVad1_FoFeOHRowpmQhUMeeTVkf2TUGaWR5Y-hGzgY_1758828899
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Sep 24, 2025 at 09:12:26PM +0200, Martin Wilck wrote:
> On Tue, 2025-09-23 at 18:12 -0400, Benjamin Marzinski wrote:
> > There were two problems with how libmpathpersist handled
> > unregistering
> > a key while holding the reseravation (which should also release the
> > reservation).
> > 1. If the path holding the reservation is not unregistered first,
> > there
> >    will be unregistered paths, while a reservation is still held,
> > which
> >    would cause IO to those paths to fail, when it shouldn't.
> > 2. If the path that holds the reservation is down, libmpathpersist
> > was
> >    not clearing the resrvation, since the there were no registered
> > keys
> >    it could use for the PREEMPT command workaround
> > 
> > To fix these, libmpathpersist now releases the reservation first when
> > trying to unregister a key that is holding the reservation.
> > mpath_prout_rel() has a new option so that if it needs to self
> > preempt
> > to clear the reservation, it won't re-register the paths when called
> > as part of unregistering a key. Also, instead of checking if the
> > device
> > is currently holding a reservation using mpp->reservation_key in
> > check_holding_reservation() (which will already be set to 0 when
> > called
> > as part of unregistering a key), pass in the key to check.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmpathpersist/mpath_persist_int.c | 101 +++++++++++++++++++-------
> > --
> >  1 file changed, 70 insertions(+), 31 deletions(-)
> > 
> > diff --git a/libmpathpersist/mpath_persist_int.c
> > b/libmpathpersist/mpath_persist_int.c
> > index 9c71011f..f130f5f5 100644
> > --- a/libmpathpersist/mpath_persist_int.c
> > +++ b/libmpathpersist/mpath_persist_int.c
> > @@ -564,18 +564,23 @@ static int mpath_prout_reg(struct multipath
> > *mpp,int rq_servact, int rq_scope,
> >  	return status;
> >  }
> >  
> > +enum preempt_work {
> > +	PREE_WORK_NONE,
> > +	PREE_WORK_REL,
> > +	PREE_WORK_REL_UNREG,
> > +};
> >  /*
> >   * Called to make a multipath device preempt its own reservation
> > (and
> > - * optionally release the reservation). Doing this causes the
> > reservation
> > - * keys to be removed from all the device paths except that path
> > used to issue
> > - * the preempt, so they need to be restored. To avoid the chance
> > that IO
> > - * goes to these paths when they don't have a registered key, the
> > device
> > - * is suspended before issuing the preemption, and the keys are
> > reregistered
> > - * before resuming it.
> > + * optional extra work). Doing this causes the reservation keys to
> > be removed
> > + * from all the device paths except that path used to issue the
> > preempt, so
> > + * they may need to be restored. To avoid the chance that IO goes to
> > these
> > + * paths when they don't have a registered key and a reservation
> > exists, the
> > + * device is suspended before issuing the preemption, and the keys
> > are
> > + * reregistered (or the reservation is released) before resuming it.
> >   */
> >  static int do_preempt_self(struct multipath *mpp, struct be64
> > sa_key,
> >  			   int rq_servact, int rq_scope, unsigned
> > int rq_type,
> > -			   int noisy, bool do_release)
> > +			   int noisy, enum preempt_work work)
> >  {
> >  	int status, rel_status = MPATH_PR_SUCCESS;
> >  	struct path *pp = NULL;
> > @@ -596,7 +601,7 @@ static int do_preempt_self(struct multipath *mpp,
> > struct be64 sa_key,
> >  		goto fail_resume;
> >  	}
> >  
> > -	if (do_release) {
> > +	if (work != PREE_WORK_NONE) {
> >  		memset(&paramp, 0, sizeof(paramp));
> >  		memcpy(paramp.key, &mpp->reservation_key, 8);
> >  		rel_status = prout_do_scsi_ioctl(pp->dev,
> > MPATH_PROUT_REL_SA,
> > @@ -604,15 +609,26 @@ static int do_preempt_self(struct multipath
> > *mpp, struct be64 sa_key,
> >  		if (rel_status != MPATH_PR_SUCCESS)
> >  			condlog(0, "%s: release on alternate path
> > failed.",
> >  				mpp->wwid);
> > +		else if (work == PREE_WORK_REL_UNREG) {
> > +			/* unregister the last path */
> > +			rel_status = prout_do_scsi_ioctl(pp->dev,
> > +							
> > MPATH_PROUT_REG_IGN_SA,
> > +							 rq_scope,
> > rq_type,
> > +							 &paramp,
> > noisy);
> > +			if (rel_status != MPATH_PR_SUCCESS)
> > +				condlog(0, "%s: final self preempt
> > unregister failed,",
> > +					mpp->wwid);
> > +		}
> > +	}
> > +	if (work != PREE_WORK_REL_UNREG) {
> > +		memset(&paramp, 0, sizeof(paramp));
> > +		memcpy(paramp.sa_key, &mpp->reservation_key, 8);
> > +		status = mpath_prout_reg(mpp,
> > MPATH_PROUT_REG_IGN_SA, rq_scope,
> > +					 rq_type, &paramp, noisy);
> > +		if (status != MPATH_PR_SUCCESS)
> > +			condlog(0, "%s: self preempt failed to
> > reregister paths.",
> > +				mpp->wwid);
> >  	}
> > -
> > -	memset(&paramp, 0, sizeof(paramp));
> > -	memcpy(paramp.sa_key, &mpp->reservation_key, 8);
> > -	status = mpath_prout_reg(mpp, MPATH_PROUT_REG_IGN_SA,
> > rq_scope,
> > -				 rq_type, &paramp, noisy);
> > -	if (status != MPATH_PR_SUCCESS)
> > -		condlog(0, "%s: self preempt failed to reregister
> > paths.",
> > -			mpp->wwid);
> >  
> >  fail_resume:
> >  	if (!dm_simplecmd_noflush(DM_DEVICE_RESUME, mpp->alias,
> > udev_flags)) {
> > @@ -625,10 +641,10 @@ fail_resume:
> >  }
> >  
> >  static int preempt_self(struct multipath *mpp, int rq_servact, int
> > rq_scope,
> > -			unsigned int rq_type, int noisy, bool
> > do_release)
> > +			unsigned int rq_type, int noisy, enum
> > preempt_work work)
> >  {
> >  	return do_preempt_self(mpp, mpp->reservation_key,
> > rq_servact, rq_scope,
> > -			       rq_type, noisy, do_release);
> > +			       rq_type, noisy, work);
> >  }
> >  
> >  static int preempt_all(struct multipath *mpp, int rq_servact, int
> > rq_scope,
> > @@ -636,7 +652,7 @@ static int preempt_all(struct multipath *mpp, int
> > rq_servact, int rq_scope,
> >  {
> >  	struct be64 zerokey = {0};
> >  	return do_preempt_self(mpp, zerokey, rq_servact, rq_scope,
> > rq_type,
> > -			       noisy, false);
> > +			       noisy, PREE_WORK_NONE);
> >  }
> >  
> >  static int reservation_key_matches(struct multipath *mpp, uint8_t
> > *key,
> > @@ -661,18 +677,21 @@ static int reservation_key_matches(struct
> > multipath *mpp, uint8_t *key,
> >  	return YNU_NO;
> >  }
> >  
> > -static bool check_holding_reservation(struct multipath *mpp,
> > unsigned int *type)
> > +static bool check_holding_reservation(struct multipath *mpp, uint8_t
> > *curr_key,
> > +				      unsigned int *type)
> >  {
> > -	if (get_be64(mpp->reservation_key) &&
> > +	uint64_t zerokey = 0;
> > +	if (memcmp(curr_key, &zerokey, 8) != 0 &&
> >  	    get_prhold(mpp->alias) == PR_SET &&
> > -	    reservation_key_matches(mpp, (uint8_t *)&mpp-
> > >reservation_key, type) == YNU_YES)
> > +	    reservation_key_matches(mpp, curr_key, type) == YNU_YES)
> >  		return true;
> >  	return false;
> >  }
> >  
> > -static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int
> > rq_scope,
> > +static int mpath_prout_rel(struct multipath *mpp, int rq_servact,
> > int rq_scope,
> >  			   unsigned int rq_type,
> > -			   struct prout_param_descriptor * paramp,
> > int noisy)
> > +			   struct prout_param_descriptor *paramp,
> > int noisy,
> > +			   bool *unregistered)
> >  {
> >  	int i, j;
> >  	struct pathgroup *pgp = NULL;
> > @@ -685,6 +704,8 @@ static int mpath_prout_rel(struct multipath
> > *mpp,int rq_servact, int rq_scope,
> >  	bool all_threads_failed;
> >  	unsigned int res_type;
> >  
> > +	if (unregistered)
> > +		*unregistered = false;
> >  	if (!mpp)
> >  		return MPATH_PR_DMMP_ERROR;
> >  
> > @@ -762,7 +783,8 @@ static int mpath_prout_rel(struct multipath
> > *mpp,int rq_servact, int rq_scope,
> >  		return status;
> >  	}
> >  
> > -	if (!check_holding_reservation(mpp, &res_type)) {
> > +	if (!check_holding_reservation(mpp, (uint8_t *)&mpp-
> > >reservation_key,
> > +				       &res_type)) {
> >  		condlog(2, "%s: Releasing key not holding
> > reservation.", mpp->wwid);
> >  		return MPATH_PR_SUCCESS;
> >  	}
> > @@ -785,7 +807,10 @@ static int mpath_prout_rel(struct multipath
> > *mpp,int rq_servact, int rq_scope,
> >  	 * 4. Reregistering keys on all the paths
> >  	 * 5. Resuming the device
> >  	 */
> > -	return preempt_self(mpp, MPATH_PROUT_PREE_SA, rq_scope,
> > rq_type, noisy, true);
> > +	if (unregistered)
> > +		*unregistered = true;
> > +	return preempt_self(mpp, MPATH_PROUT_PREE_SA, rq_scope,
> > rq_type, noisy,
> > +			    unregistered ? PREE_WORK_REL_UNREG :
> > PREE_WORK_REL);
> 
> This is hard to understand and possibly error-prone in the future.
> 
> You use the pointer "unregistered" as a boolean, which looks like a
> typo (missing "*") in the first place. It turns out that it's
> intentional, and that (unregistered != NULL) indicates that this code
> was called from the MPATH_PROUT_REG_IGN_SA case in
> do_mpath_persistent_reserve_out() (as opposed to the MPATH_PROUT_REL_SA
> case).
> 
> Could you write this in a somewhat more obvious way, please; perhaps by
> passing a preempt_work parameter to mpath_prout_rel()?
> 

Sure.

> 
> >  }
> >  
> >  /*
> > @@ -828,7 +853,7 @@ int do_mpath_persistent_reserve_out(vector curmp,
> > vector pathvec, int fd,
> >  	select_reservation_key(conf, mpp);
> >  	put_multipath_config(conf);
> >  
> > -	memcpy(&oldkey, &mpp->reservation_key, 8);
> > +	oldkey = mpp->reservation_key;
> >  	unregistering = (memcmp(&zerokey, paramp->sa_key, 8) == 0);
> >  	if (mpp->prkey_source == PRKEY_SOURCE_FILE &&
> >  	    (rq_servact == MPATH_PROUT_REG_IGN_SA ||
> > @@ -905,7 +930,21 @@ int do_mpath_persistent_reserve_out(vector
> > curmp, vector pathvec, int fd,
> >  	{
> >  	case MPATH_PROUT_REG_SA:
> >  	case MPATH_PROUT_REG_IGN_SA:
> > -		ret= mpath_prout_reg(mpp, rq_servact, rq_scope,
> > rq_type, paramp, noisy);
> > +		if (unregistering && check_holding_reservation(mpp,
> > (uint8_t *)&oldkey, &rq_type)) {
> > +			bool unregistered = false;
> > +			struct be64 newkey = mpp->reservation_key;
> > +			/* temporarily restore reservation key */
> > +			mpp->reservation_key = oldkey;
> > +			ret = mpath_prout_rel(mpp,
> > MPATH_PROUT_REL_SA, rq_scope,
> > +					      rq_type, paramp,
> > noisy,
> > +					      &unregistered);
> > +			mpp->reservation_key = newkey;
> > +			if (ret == MPATH_PR_SUCCESS &&
> > !unregistered)
> > +				ret = mpath_prout_reg(mpp,
> > rq_servact, rq_scope,
> > +						      rq_type,
> > paramp, noisy);
> 
> I comment stating that mpp->reservation_key is zero here and that
> mpath_prout_reg() actually unregisters the key would help readers of
> this code.

Sure.

-Ben
 
> Regards
> Martin
> 
> > +		} else
> > +			ret = mpath_prout_reg(mpp, rq_servact,
> > rq_scope,
> > +					      rq_type, paramp,
> > noisy);
> >  		break;
> >  	case MPATH_PROUT_PREE_SA:
> >  	case MPATH_PROUT_PREE_AB_SA:
> > @@ -921,7 +960,7 @@ int do_mpath_persistent_reserve_out(vector curmp,
> > vector pathvec, int fd,
> >  		/* if we are preempting ourself */
> >  		if (memcmp(paramp->sa_key, paramp->key, 8) == 0) {
> >  			ret = preempt_self(mpp, rq_servact,
> > rq_scope, rq_type,
> > -					   noisy, false);
> > +					   noisy, PREE_WORK_NONE);
> >  			break;
> >  		}
> >  		/* fallthrough */
> > @@ -932,14 +971,14 @@ int do_mpath_persistent_reserve_out(vector
> > curmp, vector pathvec, int fd,
> >  					 paramp, noisy, NULL,
> > &failed_paths);
> >  		if (rq_servact == MPATH_PROUT_RES_SA &&
> >  		    ret != MPATH_PR_SUCCESS && failed_paths &&
> > -		    check_holding_reservation(mpp, &res_type) &&
> > +		    check_holding_reservation(mpp, paramp->key,
> > &res_type) &&
> >  		    res_type == rq_type)
> >  			/* The reserve failed, but multipathd says
> > we hold it */
> >  			ret = MPATH_PR_SUCCESS;
> >  		break;
> >  	}
> >  	case MPATH_PROUT_REL_SA:
> > -		ret = mpath_prout_rel(mpp, rq_servact, rq_scope,
> > rq_type, paramp, noisy);
> > +		ret = mpath_prout_rel(mpp, rq_servact, rq_scope,
> > rq_type, paramp, noisy, NULL);
> >  		break;
> >  	default:
> >  		return MPATH_PR_OTHER;

