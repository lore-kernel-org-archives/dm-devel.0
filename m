Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794972417C2
	for <dm-devel@lists.linux.dev>; Thu, 25 Sep 2025 19:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758829111; cv=none; b=NnwOLvzgqZeFkrayZbmkWtD2uiQYWa4qYjohaKukkdzEfXoAZGy4Zwogxp4sJAlNuZcZt+if5rPzXCU7ebkWf/U8ykRKVDpb5L/b7/T/zsk5ZAXxNbrz4lo1WZfl7MKBAyGd+Wj9WuajxlGTyzxGxr4F+kGCQzt/G4i3KN1lvug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758829111; c=relaxed/simple;
	bh=EuuTEqXET/VHme0qDa85kei1ApOv8OItOlZDXHWQIfs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=pSgduRaaeyQE6dsXLtpu2Yfao948/o09D6T5DTbBcKvx+bzgoq666D+VfM9uaKo9ficxPrKLiWSJgy89TH5qNW1KQRG+6YYecPbFnYXwfHWZ32UPsY6jknEuCEKulTI3T1GQCDfGRhrGr08ovGWRPBNrWrCV8eHSQofjbTf0tGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VIbaxpSP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VIbaxpSP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758829108;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QnG2qelKwtqBpeAhY0oZCezC7sh9aJpOwIkHPyA5dtA=;
	b=VIbaxpSP5GrpN4Je81edD9OMyEZ56t0Dv+hXAJa9+4PdVGBRmQWSupl/MosOjy+HiVtz6n
	ZYuOD0w/C9X0vPPgm7OVOiXxot7UtrcpL5sj7UkE2NH36S/qGJjZ1JP2PmZGs+FMFzNCvV
	3GpeRL2Wi3om53FJcDf8oA9OEPBHlss=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-596-D416FQIzNCSN7KHhtG4k-g-1; Thu,
 25 Sep 2025 15:38:27 -0400
X-MC-Unique: D416FQIzNCSN7KHhtG4k-g-1
X-Mimecast-MFC-AGG-ID: D416FQIzNCSN7KHhtG4k-g_1758829106
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1E5921800378;
	Thu, 25 Sep 2025 19:38:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C792E300021A;
	Thu, 25 Sep 2025 19:38:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 58PJcOmQ1504791
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 25 Sep 2025 15:38:24 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 58PJcOWx1504790;
	Thu, 25 Sep 2025 15:38:24 -0400
Date: Thu, 25 Sep 2025 15:38:24 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 3/4] libmpathpersist: use check_holding_reservation in
 mpath_prout_rel
Message-ID: <aNWaMA1vw5BK-Wzz@redhat.com>
References: <20250923221252.1411687-1-bmarzins@redhat.com>
 <20250923221252.1411687-4-bmarzins@redhat.com>
 <bc551cc3e2bf5df5b9ed823f89259f2df3aea64b.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <bc551cc3e2bf5df5b9ed823f89259f2df3aea64b.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lgr68jtobYx3BznWQrTqrncsYDtXKC8W4Xx8kHHW53E_1758829106
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Sep 24, 2025 at 08:37:36PM +0200, Martin Wilck wrote:
> On Tue, 2025-09-23 at 18:12 -0400, Benjamin Marzinski wrote:
> > Instead of open-coding mostly the same work, just make
> > mpath_prout_rel()
> > call check_holding_reservation().
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmpathpersist/mpath_persist_int.c | 86 ++++++++++++---------------
> > --
> >  1 file changed, 35 insertions(+), 51 deletions(-)
> > 
> > diff --git a/libmpathpersist/mpath_persist_int.c
> > b/libmpathpersist/mpath_persist_int.c
> > index 33c9e57a..9c71011f 100644
> > --- a/libmpathpersist/mpath_persist_int.c
> > +++ b/libmpathpersist/mpath_persist_int.c
> > @@ -639,12 +639,42 @@ static int preempt_all(struct multipath *mpp,
> > int rq_servact, int rq_scope,
> >  			       noisy, false);
> >  }
> >  
> > +static int reservation_key_matches(struct multipath *mpp, uint8_t
> > *key,
> > +				   unsigned int *type)
> > +{
> > +	struct prin_resp resp = {{{.prgeneration = 0}}};
> > +	int status;
> > +
> > +	status = mpath_prin_activepath(mpp, MPATH_PRIN_RRES_SA,
> > &resp, 0);
> > +	if (status != MPATH_PR_SUCCESS) {
> > +		condlog(0, "%s: pr in read reservation command
> > failed.", mpp->wwid);
> > +		return YNU_UNDEF;
> > +	}
> > +	if (!resp.prin_descriptor.prin_readresv.additional_length)
> > +		return YNU_NO;
> > +	if (memcmp(key, resp.prin_descriptor.prin_readresv.key, 8)
> > == 0) {
> > +		if (type)
> > +			*type =
> > resp.prin_descriptor.prin_readresv.scope_type &
> > +				MPATH_PR_TYPE_MASK;
> > +		return YNU_YES;
> > +	}
> > +	return YNU_NO;
> > +}
> > +
> > +static bool check_holding_reservation(struct multipath *mpp,
> > unsigned int *type)
> > +{
> > +	if (get_be64(mpp->reservation_key) &&
> > +	    get_prhold(mpp->alias) == PR_SET &&
> > +	    reservation_key_matches(mpp, (uint8_t *)&mpp-
> > >reservation_key, type) == YNU_YES)
> > +		return true;
> > +	return false;
> > +}
> > +
> >  static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int
> > rq_scope,
> >  			   unsigned int rq_type,
> >  			   struct prout_param_descriptor * paramp,
> > int noisy)
> >  {
> >  	int i, j;
> > -	int num = 0;
> >  	struct pathgroup *pgp = NULL;
> >  	struct path *pp = NULL;
> >  	int active_pathcount = 0;
> > @@ -652,9 +682,8 @@ static int mpath_prout_rel(struct multipath
> > *mpp,int rq_servact, int rq_scope,
> >  	int rc;
> >  	int count = 0;
> >  	int status = MPATH_PR_SUCCESS;
> > -	struct prin_resp resp = {{{.prgeneration = 0}}};
> >  	bool all_threads_failed;
> > -	unsigned int scope_type;
> > +	unsigned int res_type;
> >  
> >  	if (!mpp)
> >  		return MPATH_PR_DMMP_ERROR;
> > @@ -733,27 +762,13 @@ static int mpath_prout_rel(struct multipath
> > *mpp,int rq_servact, int rq_scope,
> >  		return status;
> >  	}
> >  
> > -	status = mpath_prin_activepath (mpp, MPATH_PRIN_RRES_SA,
> > &resp, noisy);
> > -	if (status != MPATH_PR_SUCCESS){
> > -		condlog (0, "%s: pr in read reservation command
> > failed.", mpp->wwid);
> > -		return MPATH_PR_OTHER;
> > -	}
> > -
> > -	num = resp.prin_descriptor.prin_readresv.additional_length /
> > 8;
> > -	if (num == 0){
> > -		condlog (2, "%s: Path holding reservation is
> > released.", mpp->wwid);
> > -		return MPATH_PR_SUCCESS;
> > -	}
> > -	if (!get_be64(mpp->reservation_key) ||
> > -	    memcmp(&mpp->reservation_key,
> > resp.prin_descriptor.prin_readresv.key, 8)) {
> > +	if (!check_holding_reservation(mpp, &res_type)) {
> 
> The old code didn't call check_prhold() while
> check_holding_reservation() does.
> 
> Is it possible that get_prhold() would return a "false negative" and
> thus we'd wrongly skip releasing the reservation?

At the point where we check this, we've already done the RELEASE and
gotten a success, but the reservation is still held. This means that
either an unavailable path on this device is holding it, or another
device that is using the same key is holding it. These checks are to
determine whether or not we PREEMPT the key to force-clear the
reservation. What we are adding here is a requirement that multipathd
says we are holding the reservation. 

I'm not sure how we would get a false negative. When multipathd first
starts tracking a device (when it starts up, creates a new device, or is
reconfigured) it assumes that there aren't multiple devices holding the
same key. So if it sees that its configured key is holding the
reservation, it assumes that this device is holding the reservation. It
will only unset the holding state if it notices that the devices key is
not registered, or it is told to drop the reservation. Once it is
started the only way it will set the holding state on a device is when
libmpathpersist tells it to, but that should always happen when
libmpathpersist grabs a reservation.

Now, this code is admittedly complex, and there are lots of corner cases
that I might not have thought through which could produce a false
negative, and it is always possible that libmpathpersist fails to
communicate with multipathd to set prhold.  Also, I don't think we really
need to worry much about another device holding a duplicate key when we
are explicitly asked to release the reservation (that means whoever is
issuing this command also thinks we own the device).

So I'm fine with backing this change out. I was on the fence about it
myself. If I do, check_holding_reservation() and
reservation_key_matches() will still need to be moved earlier in the
code for the next patch. That patch also makes changes to
check_holding_reservation(). Do you prefer moving the functions in a
separate patch from editting them. Or are you fine with doing both in
the same patch, as long as I call it out.

-Ben
 
> Martin

