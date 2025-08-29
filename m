Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0261733985
	for <dm-devel@lists.linux.dev>; Fri, 29 Aug 2025 03:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756437796; cv=none; b=ieotSAdEFmSH1sE+cprQGxWS2WuXpcot0c7IMiIIrYVUmT62wS4k5lDFDw2cfUdra7/mf4r5zmYVce8xKGAJNgOht2B5QyNms6jdTvAxeRkSUJSmPy1KyrP5+0D/RdeLffryC1E+GvIFSF5TH86QQEj+X4ZhlpKc9oc7PgmIARI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756437796; c=relaxed/simple;
	bh=pIYFRzI3CKpnYHvjqEYSGY3rvJ6wbulPvQ3lnsTExqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=ikZfPb8eL+Tmj5OWjZ6sjXnCoPQ1TBmoPJd85GyjP71hOLJxotYhmlnYo6Ag9vDFg7aK/yqadrTlxSXcf3C5ZtwuzS4KQ7ekt8BYyVed5CJOI36Wqcor67P0Y9dOAHQylaro9Apz6Uun2/VGEVETyV/KS0OVrmJ4xCcF0GfEW1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g4+RboVh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g4+RboVh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756437792;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xR4KVncengnIEQat2xSGa62YfLPNFSMEva+CYUtBeCw=;
	b=g4+RboVho8jUNHpetKAUEw6tNiGDtWxs2kqLKLFPWEuUK8merxYjwj+FF7dTBoLg8y48TV
	e0joKDe0Mc6CI/rG3Y2bUxw9rw3jHUKHA+tdPgEC+PTj8qc0nXQ0jWfGuOCotpaRmVl/KO
	XYh2rgV9b0yfR/btEn61U9X8+zEUxzU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-561-79dGoS89M0W_5tBO6H-ZjA-1; Thu,
 28 Aug 2025 23:23:10 -0400
X-MC-Unique: 79dGoS89M0W_5tBO6H-ZjA-1
X-Mimecast-MFC-AGG-ID: 79dGoS89M0W_5tBO6H-ZjA_1756437789
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5DA5F18003FD;
	Fri, 29 Aug 2025 03:23:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1185119560B4;
	Fri, 29 Aug 2025 03:23:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 57T3N7RM348657
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 28 Aug 2025 23:23:07 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 57T3N7bg348656;
	Thu, 28 Aug 2025 23:23:07 -0400
Date: Thu, 28 Aug 2025 23:23:07 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 10/15] libmpathpersist: fail the release if all threads
 fail
Message-ID: <aLEdG_pKGS-BKzRq@redhat.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
 <20250710181100.3997759-11-bmarzins@redhat.com>
 <897959294c661240be74a785b7790c95af4c010d.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <897959294c661240be74a785b7790c95af4c010d.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WO8DM643wEiw3-6TuEYIXCPJUFgewNQkSwMQd8ch7AU_1756437789
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sun, Aug 24, 2025 at 05:33:07PM +0200, Martin Wilck wrote:
> On Thu, 2025-07-10 at 14:10 -0400, Benjamin Marzinski wrote:
> > If none of the threads succeeds in issuing the release, simply return
> > failure, instead of trying the workaround.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmpathpersist/mpath_persist_int.c | 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> > 
> > diff --git a/libmpathpersist/mpath_persist_int.c
> > b/libmpathpersist/mpath_persist_int.c
> > index 7fb08b2e..ad5a4ee7 100644
> > --- a/libmpathpersist/mpath_persist_int.c
> > +++ b/libmpathpersist/mpath_persist_int.c
> > @@ -475,15 +475,21 @@ static int mpath_prout_rel(struct multipath
> > *mpp,int rq_servact, int rq_scope,
> >  		}
> >  	}
> >  
> > +	rc = MPATH_PR_DMMP_ERROR;
> 
> I find the relationship between "status" and "rc" a bit confusing in
> this patch. Can we use something like "bool all_failed" instead?

Sure.

-Ben

> 
> Martin
> 
> 
> >  	for (i = 0; i < count; i++){
> >  		/*  check thread status here and return the status
> > */
> >  
> > -		if (thread[i].param.status ==
> > MPATH_PR_RESERV_CONFLICT)
> > +		if (thread[i].param.status == MPATH_PR_SUCCESS)
> > +			rc = MPATH_PR_SUCCESS;
> > +		else if (thread[i].param.status ==
> > MPATH_PR_RESERV_CONFLICT)
> >  			status = MPATH_PR_RESERV_CONFLICT;
> > -		else if (status == MPATH_PR_SUCCESS
> > -				&& thread[i].param.status !=
> > MPATH_PR_RESERV_CONFLICT)
> > +		else if (status == MPATH_PR_SUCCESS)
> >  			status = thread[i].param.status;
> >  	}
> > +	if (rc != MPATH_PR_SUCCESS) {
> > +		condlog(0, "%s: all threads failed to release
> > reservation.", mpp->wwid);
> > +		return status;
> > +	}
> >  
> >  	status = mpath_prin_activepath (mpp, MPATH_PRIN_RRES_SA,
> > &resp, noisy);
> >  	if (status != MPATH_PR_SUCCESS){

