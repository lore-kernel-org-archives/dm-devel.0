Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EE61E1A3D
	for <dm-devel@lists.linux.dev>; Wed,  4 Sep 2024 18:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725475388; cv=none; b=Dw2h8cGeft4uAXIbQSCqcpNuLVENjc4Dxa72OQej1/2MZ4322ku4CthYIjOaHJ4oWkamD5EiSbkRxK/B5YFvyPZo5vEHlosOmCaa7fxO+2edug4jEEujPVdp3EZuGnMdU6XiHIY8o0YrnppnDp6FM0NfqUgQY3orty/Ll4pOYAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725475388; c=relaxed/simple;
	bh=8pI8+RNhUNNXgoG3QZB5TL5tuIukSZVFPy/RQZhdoMY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=S0KAL3gKZgEj6PY6QDcJeuw/lCFHS9gQjhzpruL+cKPHxg58kyapzy3CPVf0yQaK5g3TLv+4Zp9Jt9wzZtjv5OxnK3iq/VEdggknTorqYTqH6aWAGOHUd3rIIBCyC/Pskn6gNs9nPzO0s82XsikWjUnuZG5Okzpf3sYwLK0q44w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FdwCL4LM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FdwCL4LM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725475385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M5Omqnsg2w+Gpy9CilYiy2UVwI329Rer8A9w/0j3UHg=;
	b=FdwCL4LM4jX3NzNVtD11xdPosy0d4o2T25XzM44TilUW5NPEWyK+UpzNnik46Mz8Ctdeyv
	530PcHChiyJsU7gAX9hQVePPLGYoPGIggxNX89hP143fevS5ZmwhZZqgwjM0UP/ZbBYCLp
	GKJl/+dh1hihqyI0OT+Ls7XBtw7nQh4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-693-vnu7RtXbMUy2hY7FPXyQhg-1; Wed,
 04 Sep 2024 14:43:04 -0400
X-MC-Unique: vnu7RtXbMUy2hY7FPXyQhg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6ADC81944AA7;
	Wed,  4 Sep 2024 18:43:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 32C9E1955F44;
	Wed,  4 Sep 2024 18:43:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 484Ih2PA480395
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 4 Sep 2024 14:43:02 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 484Ih17t480394;
	Wed, 4 Sep 2024 14:43:01 -0400
Date: Wed, 4 Sep 2024 14:43:01 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 06/15] libmultipath: split get_state into two functions
Message-ID: <ZtiqNcKZLJxAH1Dg@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
 <20240828221757.4060548-7-bmarzins@redhat.com>
 <acde3728e780c2d0437487d76b932294ae7206d1.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <acde3728e780c2d0437487d76b932294ae7206d1.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Sep 04, 2024 at 05:14:32PM +0200, Martin Wilck wrote:
> On Wed, 2024-08-28 at 18:17 -0400, Benjamin Marzinski wrote:
> > get_state() is now split into start_checker(), which runs the checker
> > but doesn't wait for async checkers, and get_state(), which returns
> > the
> > state from the checker, after waiting for async checkers if
> > necessary.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/discovery.c | 22 ++++++++++++++++------
> >  libmultipath/discovery.h |  4 +++-
> >  libmultipath/propsel.c   |  1 +
> >  multipathd/main.c        |  4 +++-
> >  4 files changed, 23 insertions(+), 8 deletions(-)
> > 
> > diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> > index 5648be60..e0f46ff2 100644
> > --- a/libmultipath/discovery.c
> > +++ b/libmultipath/discovery.c
> > @@ -1974,30 +1974,29 @@ cciss_ioctl_pathinfo(struct path *pp)
> >  }
> >  
> >  int
> > -get_state (struct path * pp, struct config *conf, int daemon, int
> > oldstate)
> > +start_checker (struct path * pp, struct config *conf, int daemon,
> > int oldstate)
> >  {
> >  	struct checker * c = &pp->checker;
> > -	int state;
> >  
> >  	if (!checker_selected(c)) {
> >  		if (daemon) {
> >  			if (pathinfo(pp, conf, DI_SYSFS) !=
> > PATHINFO_OK) {
> >  				condlog(3, "%s: couldn't get sysfs
> > pathinfo",
> >  					pp->dev);
> > -				return PATH_UNCHECKED;
> > +				return -1;
> >  			}
> >  		}
> >  		select_detect_checker(conf, pp);
> >  		select_checker(conf, pp);
> >  		if (!checker_selected(c)) {
> >  			condlog(3, "%s: No checker selected", pp-
> > >dev);
> > -			return PATH_UNCHECKED;
> > +			return -1;
> >  		}
> >  		checker_set_fd(c, pp->fd);
> >  		if (checker_init(c, pp->mpp?&pp->mpp-
> > >mpcontext:NULL)) {
> >  			checker_clear(c);
> >  			condlog(3, "%s: checker init failed", pp-
> > >dev);
> > -			return PATH_UNCHECKED;
> > +			return -1;
> >  		}
> >  	}
> >  	if (pp->mpp && !c->mpcontext)
> > @@ -2008,6 +2007,15 @@ get_state (struct path * pp, struct config
> > *conf, int daemon, int oldstate)
> >  	else
> >  		checker_set_sync(c);
> >  	checker_check(c, oldstate);
> > +	return 0;
> > +}
> > +
> > +int
> > +get_state (struct path * pp)
> > +{
> > +	struct checker * c = &pp->checker;
> > +	int state;
> > +
> >  	state = checker_get_state(c);
> >  	condlog(3, "%s: %s state = %s", pp->dev,
> >  		checker_name(c), checker_state_name(state));
> > @@ -2455,7 +2463,9 @@ int pathinfo(struct path *pp, struct config
> > *conf, int mask)
> >  
> >  	if (mask & DI_CHECKER) {
> >  		if (path_state == PATH_UP) {
> > -			int newstate = get_state(pp, conf, 0,
> > path_state);
> > +			int newstate = PATH_UNCHECKED;
> > +			if (start_checker(pp, conf, 0, path_state)
> > == 0)
> > +				newstate = get_state(pp);
> >  			if (newstate != PATH_PENDING ||
> >  			    pp->state == PATH_UNCHECKED ||
> >  			    pp->state == PATH_WILD)
> > diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
> > index c93abf1c..f3e0c618 100644
> > --- a/libmultipath/discovery.h
> > +++ b/libmultipath/discovery.h
> > @@ -34,7 +34,9 @@ int path_discovery (vector pathvec, int flag);
> >  int path_get_tpgs(struct path *pp); /* This function never returns
> > TPGS_UNDEF */
> >  int do_tur (char *);
> >  int path_offline (struct path *);
> > -int get_state (struct path * pp, struct config * conf, int daemon,
> > int state);
> > +int start_checker(struct path * pp, struct config * conf, int
> > daemon,
> > +		  int state);
> > +int get_state(struct path * pp);
> >  int get_vpd_sgio (int fd, int pg, int vend_id, char * str, int
> > maxlen);
> >  int pathinfo (struct path * pp, struct config * conf, int mask);
> >  int alloc_path_with_pathinfo (struct config *conf, struct
> > udev_device *udevice,
> > diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> > index a3fce203..ad771d35 100644
> > --- a/libmultipath/propsel.c
> > +++ b/libmultipath/propsel.c
> > @@ -700,6 +700,7 @@ out:
> >  	condlog(3, "%s: path_checker = %s %s", pp->dev,
> >  		checker_name(c), origin);
> >  	c->timeout = pp->checker_timeout;
> > +	c->path_state = PATH_UNCHECKED;
> 
> Should this be in 01/15 already?

Yeah. That makes sense.

-Ben

> 
> Martin

