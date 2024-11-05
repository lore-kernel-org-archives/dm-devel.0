Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8D644C81
	for <dm-devel@lists.linux.dev>; Tue,  5 Nov 2024 03:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730775651; cv=none; b=ToVXAJh7wRDCbiDIgxA13MttvulFJAzV/i9kAvOH90Z9qtogA/AvQye6/zmdpITRl8XOHmbTB79lh68YNc4tMFN9UKmUh1+MKgCeFMGujrmtBeOfkmU4OYdlNunLpypvpzJW312HEkPCoYpXR37V9MnREF7GDrC4BVWfd9bIvtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730775651; c=relaxed/simple;
	bh=+RXjeL6VjoT8W/ji8SGsqbTFKlzTKHG4k6ZaNr85j2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=hwze7XrqRE3elrH5YVUNt0+RNtRoC7kksdV0/OQaHVmz/jVajJaDg985OxWiobt3vXEdM1u8oP8k+G888cN2KJ5sE6nTlvW8KXxlao0zoSG1rcT5Sp6lY6Q088VAWxuPY19YjOrNhQFwJ3z2ojqxl4oPSW6BFKfXNyjck3EQJk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ER3EgaUb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ER3EgaUb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730775648;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uwsBIP3+HfdNXSkpd38j9b8VTUy4JdI0qv8HblIOMDw=;
	b=ER3EgaUbo6zCG/zZC9sB5GjTxt2SuMK2lnLpp6G/+rJFc/RA6iAwqqw7j6d6HpGJOcpFBn
	hh0ZJmfatn5rAurBUknjRUd69BZrly0Gu4/5cpGLPkGicC/Cs8ztwkOI6g9iIXHFPKGZky
	eDj2EbcoFNdutfUa2w49nnNgpM75TlQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-626-Klv9indPOg6OyagycCv9jQ-1; Mon,
 04 Nov 2024 22:00:45 -0500
X-MC-Unique: Klv9indPOg6OyagycCv9jQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 493841956095;
	Tue,  5 Nov 2024 03:00:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CC13B1956086;
	Tue,  5 Nov 2024 03:00:43 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4A530g1k450489
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 4 Nov 2024 22:00:42 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4A530gfi450488;
	Mon, 4 Nov 2024 22:00:42 -0500
Date: Mon, 4 Nov 2024 22:00:42 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v5 23/23] multipathd: use timestamps to tell when the
 directio checker timed out
Message-ID: <ZymKWtzy2TqA1O4l@redhat.com>
References: <20241015032835.2693247-1-bmarzins@redhat.com>
 <20241015032835.2693247-24-bmarzins@redhat.com>
 <f13217ad2bca4c8a013251471fccdf296d925818.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <f13217ad2bca4c8a013251471fccdf296d925818.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sun, Nov 03, 2024 at 09:56:40PM +0100, Martin Wilck wrote:
> On Mon, 2024-10-14 at 23:28 -0400, Benjamin Marzinski wrote:
> > Instead of counting the number of times the path checker has been
> > called and treating that as the number of seconds that have passed,
> > calculate the actual timestamp when the checker will time out, and
> > check that instead.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/checkers/directio.c | 44 ++++++++++++++++++++++--------
> > --
> >  1 file changed, 31 insertions(+), 13 deletions(-)
> > 
> > diff --git a/libmultipath/checkers/directio.c
> > b/libmultipath/checkers/directio.c
> > index 27227894..d35a6bac 100644
> > --- a/libmultipath/checkers/directio.c
> > +++ b/libmultipath/checkers/directio.c
> > @@ -60,13 +60,28 @@ const char *libcheck_msgtable[] = {
> >  #define LOG(prio, fmt, args...) condlog(prio, "directio: " fmt,
> > ##args)
> >  
> >  struct directio_context {
> > -	unsigned int	running;
> > -	int		reset_flags;
> > +	time_t timeout;
> 
> 
> I'd have used a struct timespec here rather than time_t.

Sure.

> 
> > +	int reset_flags;
> >  	struct aio_group *aio_grp;
> >  	struct async_req *req;
> >  	bool checked_state;
> >  };
> >  
> > +bool is_running(struct directio_context *ct) {
> > +	return (ct->timeout != 0);
> > +}
> > +
> > +void start_running(struct directio_context *ct, int timeout_secs) {
> > +	struct timespec now;
> > +
> > +	get_monotonic_time(&now);
> > +	ct->timeout = now.tv_sec + timeout_secs;
> > +}
> > +
> > +void stop_running(struct directio_context *ct) {
> > +	ct->timeout = 0;
> > +}
> > +
> 
> I think the 3 functions above should be static.

Oops. Yeah. Sending a new version.

-Ben

> 
> >  static struct aio_group *
> >  add_aio_group(void)
> >  {
> > @@ -234,9 +249,9 @@ void libcheck_free (struct checker * c)
> >  		}
> >  	}
> >  
> > -	if (ct->running && ct->req->state != PATH_PENDING)
> > -		ct->running = 0;
> > -	if (!ct->running) {
> > +	if (is_running(ct) && ct->req->state != PATH_PENDING)
> > +		stop_running(ct);
> > +	if (!is_running(ct)) {
> >  		free(ct->req->buf);
> >  		free(ct->req);
> >  		ct->aio_grp->holders--;
> > @@ -304,7 +319,7 @@ check_pending(struct directio_context *ct, struct
> > timespec timeout)
> >  		r = get_events(ct->aio_grp, &timeout);
> >  
> >  		if (ct->req->state != PATH_PENDING) {
> > -			ct->running = 0;
> > +			stop_running(ct);
> >  			return;
> >  		} else if (r == 0 ||
> >  			   (timeout.tv_sec == 0 && timeout.tv_nsec
> > == 0))
> > @@ -330,10 +345,10 @@ check_state(int fd, struct directio_context
> > *ct, int sync, int timeout_secs)
> >  	if (sync > 0)
> >  		LOG(4, "called in synchronous mode");
> >  
> > -	if (ct->running) {
> > +	if (is_running(ct)) {
> >  		ct->checked_state = true;
> >  		if (ct->req->state != PATH_PENDING) {
> > -			ct->running = 0;
> > +			stop_running(ct);
> >  			return ct->req->state;
> >  		}
> >  	} else {
> > @@ -348,9 +363,9 @@ check_state(int fd, struct directio_context *ct,
> > int sync, int timeout_secs)
> >  			LOG(3, "io_submit error %i", -rc);
> >  			return PATH_UNCHECKED;
> >  		}
> > +		start_running(ct, timeout_secs);
> >  		ct->checked_state = false;
> >  	}
> > -	ct->running++;
> >  	if (!sync)
> >  		return PATH_PENDING;
> >  
> > @@ -388,7 +403,7 @@ static void set_msgid(struct checker *c, int
> > state)
> >  bool libcheck_need_wait(struct checker *c)
> >  {
> >  	struct directio_context *ct = (struct directio_context *)c-
> > >context;
> > -	return (ct && ct->running && ct->req->state == PATH_PENDING
> > &&
> > +	return (ct && is_running(ct) && ct->req->state ==
> > PATH_PENDING &&
> >  		!ct->checked_state);
> >  }
> >  
> > @@ -400,7 +415,7 @@ int libcheck_pending(struct checker *c)
> >  	struct timespec no_wait = { .tv_sec = 0 };
> >  
> >  	/* The if path checker isn't running, just return the
> > exiting value. */
> > -	if (!ct || !ct->running) {
> > +	if (!ct || !is_running(ct)) {
> >  		rc = c->path_state;
> >  		goto out;
> >  	}
> > @@ -408,10 +423,13 @@ int libcheck_pending(struct checker *c)
> >  	if (ct->req->state == PATH_PENDING)
> >  		check_pending(ct, no_wait);
> >  	else
> > -		ct->running = 0;
> > +		stop_running(ct);
> >  	rc = ct->req->state;
> >  	if (rc == PATH_PENDING) {
> > -		if (ct->running > c->timeout) {
> > +		struct timespec now;
> > +
> > +		get_monotonic_time(&now);
> > +		if (now.tv_sec > ct->timeout) {
> 
> We could timeout a second too late here, that's why I'd suggest using
> timespec.
> 
> >  			LOG(3, "abort check on timeout");
> >  			io_cancel(ct->aio_grp->ioctx, &ct->req->io,
> > &event);
> >  			rc = PATH_DOWN;
> 
> Regards
> Martin

