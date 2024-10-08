Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86F41FEFC9
	for <dm-devel@lists.linux.dev>; Tue,  8 Oct 2024 19:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728414982; cv=none; b=eWiRul0okVH1KqAf2P7ncIDvY87rC+wqtLj7ccKLWs482OH9jhQoPCUgT45L36qpWI7lm6x/9fymN8aON6YAK8lUdN8/xaLzlB9aRoErFcThWIVZqYPEXGBG0x2AK0Wp4dZDvEKWP5Oc5sZWJ51mncJPW2xTAXOyujILI9mtQsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728414982; c=relaxed/simple;
	bh=7rVqTzrd1fuHWoRVSUe9e3j6vjx4Cv5JoMsVtXvzMBY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=B+iOdRNb7TOvmg0CToNelNmReC1I+QdMTPdbgvpcJ+xduhXTQnjM8DWjuEONgS5NgwWyzvrGbH5Q6ySGAITlvP402hYCrLV3NEFQrxeymrwSGvzOWPMrZ3qBT0zOwHjsXzWm3c6N7Wa7g7cBLJM6Eg/tfTdukkWOV62biYI9lkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JTIxDfUD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JTIxDfUD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728414979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gFJguITKpi5EDCjuIXv0HXQK7Va0j7jY1Uxmb3pDCXw=;
	b=JTIxDfUDCa2pxQ6fxHDK4maXz6jkLsUT4jeRwUdJRulIOKBlHDPue6p4y3Bqf0I2GMhwVG
	df8Dxf9FUXEVuzLsRiAqeUmk2hZavVI5Y+Eh6LKFbSsYN++AzGRIS29exItUtx6b1KkrHG
	khAGNcRLHNaf9x7Mn779+jpGIgaoFq4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-170-GvvckyQYPvC2V9sdj9Cs6A-1; Tue,
 08 Oct 2024 15:16:14 -0400
X-MC-Unique: GvvckyQYPvC2V9sdj9Cs6A-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EFAC51956046;
	Tue,  8 Oct 2024 19:16:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AD9E719560AE;
	Tue,  8 Oct 2024 19:16:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 498JGBjx2369462
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 8 Oct 2024 15:16:11 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 498JGBuO2369461;
	Tue, 8 Oct 2024 15:16:11 -0400
Date: Tue, 8 Oct 2024 15:16:11 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v2 12/22] multipathd: split check_paths into two functions
Message-ID: <ZwWE--JLpEMyqOwx@redhat.com>
References: <20240912214947.783819-1-bmarzins@redhat.com>
 <20240912214947.783819-13-bmarzins@redhat.com>
 <eb63e364321e7af634dc9aa8296e1820d3355e45.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <eb63e364321e7af634dc9aa8296e1820d3355e45.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Oct 03, 2024 at 10:41:20PM +0200, Martin Wilck wrote:
> On Thu, 2024-09-12 at 17:49 -0400, Benjamin Marzinski wrote:
> > Instead of checking and updating each path, the checkerloop now
> > starts
> > the checkers on all the paths in check_paths(), and then goes back
> > and
> > updates all the paths in update_paths(). Since the async checkers use
> > an
> > absolute time to wait for before returning PATH_PENDING, only one
> > checker actually needs to be waited for in update_paths(). The rest
> > will
> > already have reached their timeout when update_path() is called for
> > them.
> > 
> > The check_paths() and update_paths() loop over the pathvec instead of
> > looping through the multipath device paths to avoid having to restart
> > checking of the device paths when the multipath device needs to be
> > resynced while updating the paths.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/structs.h |  10 +++-
> >  multipathd/main.c      | 105 +++++++++++++++++++--------------------
> > --
> >  2 files changed, 57 insertions(+), 58 deletions(-)
> > 
> > diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> > index d8231e95..af8e31e9 100644
> > --- a/libmultipath/structs.h
> > +++ b/libmultipath/structs.h
> > @@ -314,6 +314,14 @@ enum recheck_wwid_states {
> >  	RECHECK_WWID_ON = YNU_YES,
> >  };
> >  
> > +enum check_path_states {
> > +	CHECK_PATH_UNCHECKED,
> > +	CHECK_PATH_STARTED,
> > +	CHECK_PATH_CHECKED,
> > +	CHECK_PATH_SKIPPED,
> > +	CHECK_PATH_REMOVED,
> > +};
> > +
> >  struct vpd_vendor_page {
> >  	int pg;
> >  	const char *name;
> > @@ -395,7 +403,7 @@ struct path {
> >  	int fast_io_fail;
> >  	unsigned int dev_loss;
> >  	int eh_deadline;
> > -	bool is_checked;
> > +	enum check_path_states is_checked;
> >  	bool can_use_env_uid;
> >  	unsigned int checker_timeout;
> >  	/* configlet pointers */
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 45d40559..9519b6c5 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -2389,13 +2389,6 @@ sync_mpp(struct vectors * vecs, struct
> > multipath *mpp, unsigned int ticks)
> >  	do_sync_mpp(vecs, mpp);
> >  }
> >  
> > -enum check_path_return {
> > -	CHECK_PATH_STARTED,
> > -	CHECK_PATH_CHECKED,
> > -	CHECK_PATH_SKIPPED,
> > -	CHECK_PATH_REMOVED,
> > -};
> > -
> >  static int
> >  update_path_state (struct vectors * vecs, struct path * pp)
> >  {
> > @@ -2735,6 +2728,7 @@ check_uninitialized_path(struct path * pp,
> > unsigned int ticks)
> >  	conf = get_multipath_config();
> >  	retrigger_tries = conf->retrigger_tries;
> >  	pp->tick = conf->max_checkint;
> > +	pp->checkint = conf->checkint;
> >  	put_multipath_config(conf);
> >  
> >  	if (pp->initialized == INIT_MISSING_UDEV) {
> > @@ -2778,6 +2772,10 @@ update_uninitialized_path(struct vectors *
> > vecs, struct path * pp)
> >  	int newstate, ret;
> >  	struct config *conf;
> >  
> > +	if (pp->initialized != INIT_NEW && pp->initialized !=
> > INIT_FAILED &&
> > +	    pp->initialized != INIT_MISSING_UDEV)
> > +		return CHECK_PATH_SKIPPED;
> > +
> >  	newstate = get_new_state(pp);
> >  
> 
> It seems to me that this hunk and the previous one belong into 11/22.

Setting pp->checkint could certainly go in the earlier patch. It's just
there to match check_path(), although to be honest, I'm still not sure
that there is any way for either check_path() or
check_uninitialized_path() to get called with pp->checkint unset.
 
The checking the path->initialized state in update_uninitialized_path()
makes less sense. That code is already in check_unintialized_path(). In
11/22, update_uninitialized_path() is always called immediately after
check_unintialized_path() if it's called at all, and pp->initialized
never has a chance to change.

In this patch, check_unintialized_path() is called in check_paths(), and
it's possible that path checking takes too long, and we need take a
break and yield to other vecs lock waiters before we call
update_paths(), where update_uninitialized_path() is called. In this
case, it's possible that a uevent got processed and changed
pp->initialized, so we need to recheck it in
update_uninitialized_path().

-Ben

> Martin

