Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DC919ABBF
	for <dm-devel@lists.linux.dev>; Thu, 10 Oct 2024 19:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728589564; cv=none; b=sgbCIvMyMuPcyytmXrO8fN/Bn6tlLdldoLpFduzkNkx1vGuY+tQ727RkS4j1VAJI/h2EbRbYss262hWN8yfAaw56I35JJ6951HpmY+W8ZkylEEUjoGGZtGs8/W+SzOWr80pYp4f39zkVQoA7B+AGCSSZXMBewUYtK10WdAzjcIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728589564; c=relaxed/simple;
	bh=2iUoj3kYcRfoq7HMjMm0/Lqgcqa0x0PCfFfqm1pwvX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=CqQtGzpHe4Xgi6mZA7NdcnExdSrGgzGhUdygYyGGVXq0iH1AQSP8reQY9TKKVbuBHbk/eUobkWxsU0lbkoBIm8Bsc0SWrGprUe1IrU4tZML5P1raKfiUrFgODJB1eUXcThz2KL3ECCtx/Zw0T/tlSz8WG7XNxIDT5Ofaam1+a0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KrQLRY50; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KrQLRY50"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728589561;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b7B0pyS0yhT/6/6NuMAvOc3GozDLYv9YhzpKtNbKJ3Y=;
	b=KrQLRY50Gpa700syo8IlvBTJbJpNYqwMxWqEDaJpOOf3bm13UFsDNneXmLZ+fiJcBz6XYG
	gNavTxV3VQKTif2gtSN87y9CzFWgM5l+oJeel/HLCP+xEHpUTAdgB4raVVvKnb3zl5bcbG
	U6CJlozNyZ38j/SCDptecWAMtNjcPOA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-498-q4TeiMOQOgWSSVRy-wM_dQ-1; Thu,
 10 Oct 2024 15:45:59 -0400
X-MC-Unique: q4TeiMOQOgWSSVRy-wM_dQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6F9171956080;
	Thu, 10 Oct 2024 19:45:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E7D4919560A2;
	Thu, 10 Oct 2024 19:45:57 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 49AJjujc2538993
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Oct 2024 15:45:56 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 49AJjupK2538992;
	Thu, 10 Oct 2024 15:45:56 -0400
Date: Thu, 10 Oct 2024 15:45:56 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v4 04/22] libmultipath: remove pending wait code from
 libcheck_check calls
Message-ID: <Zwgu9KvN1ZTkCkJL@redhat.com>
References: <20241009011523.2381575-1-bmarzins@redhat.com>
 <20241009011523.2381575-5-bmarzins@redhat.com>
 <061a44d1ab78bd95b10bd908ffbfeb2bbd436ca0.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <061a44d1ab78bd95b10bd908ffbfeb2bbd436ca0.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Oct 09, 2024 at 05:00:55PM +0200, Martin Wilck wrote:
> On Tue, 2024-10-08 at 21:15 -0400, Benjamin Marzinski wrote:
> > When the tur and directio checkers start an asynchronous checker,
> > they
> > now immediately return with the path in PATH_PENDING, instead of
> > waiting in checker_check(). Instead the wait now happens in
> > checker_get_state().
> > 
> > Additionally, the directio checker now waits for 1 ms, like the tur
> > checker does. Also like the tur checker it now only waits once. If it
> > is still pending after the first call to checker_get_state(). It will
> > not wait at all on future calls, and will just process the already
> > completed IOs.
> > 
> > Reviewed-by: Martin Wilck <mwilck@suse.com>
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/checkers.c          |  7 +++-
> >  libmultipath/checkers/directio.c | 57 +++++++++++++++++-------------
> > --
> >  libmultipath/checkers/tur.c      | 13 +++-----
> >  3 files changed, 41 insertions(+), 36 deletions(-)
> > 
> > diff --git a/libmultipath/checkers/directio.c
> > b/libmultipath/checkers/directio.c
> > index 3f88b40d..904e3071 100644
> > --- a/libmultipath/checkers/directio.c
> > +++ b/libmultipath/checkers/directio.c
> > @@ -60,10 +60,11 @@ const char *libcheck_msgtable[] = {
> >  #define LOG(prio, fmt, args...) condlog(prio, "directio: " fmt,
> > ##args)
> >  
> >  struct directio_context {
> > -	int		running;
> > +	unsigned int	running;
> >  	int		reset_flags;
> >  	struct aio_group *aio_grp;
> >  	struct async_req *req;
> > +	struct timespec endtime;
> >  };
> >  
> >  static struct aio_group *
> > @@ -314,19 +315,16 @@ check_pending(struct directio_context *ct,
> > struct timespec endtime)
> >  static int
> >  check_state(int fd, struct directio_context *ct, int sync, int
> > timeout_secs)
> >  {
> > -	struct timespec	timeout = { .tv_nsec = 1000 };
> >  	struct stat	sb;
> >  	int		rc;
> > +	struct io_event event;
> >  	struct timespec endtime;
> >  
> >  	if (fstat(fd, &sb) == 0) {
> >  		LOG(4, "called for %x", (unsigned) sb.st_rdev);
> >  	}
> > -	if (sync > 0) {
> > +	if (sync > 0)
> >  		LOG(4, "called in synchronous mode");
> > -		timeout.tv_sec  = timeout_secs;
> > -		timeout.tv_nsec = 0;
> > -	}
> >  
> >  	if (ct->running) {
> >  		if (ct->req->state != PATH_PENDING) {
> > @@ -345,31 +343,26 @@ check_state(int fd, struct directio_context
> > *ct, int sync, int timeout_secs)
> >  			LOG(3, "io_submit error %i", -rc);
> >  			return PATH_UNCHECKED;
> >  		}
> > +		get_monotonic_time(&ct->endtime);
> > +		ct->endtime.tv_nsec += 1000 * 1000;
> > +		normalize_timespec(&ct->endtime);
> >  	}
> >  	ct->running++;
> 
> Sorry, I have another concern here, despite my reviewed-by. This very
> old statement, combined with "if (ct->running > c->timeout)" below,
> somehow assumes that "running" counts seconds, which means that this
> code must be called once a second. I guess this has been approximately
> true in the past, when this code was originally written. It has never
> been clean, we should have compared time stamps instead. 

Yeah. That makes sense.

> 
> But now, it seems to be plain wrong, "running" will never have a higher
> value than 1 as it is only called once from libcheck_check(), and the
> (ct->running - c->timeout) statement is broken.
> 
> Am I misreading this code?

Either you are or I am. libcheck_check() is called by start_checker()
each time a path comes up for checking. libcheck_check() calls
check_state() with the number of seconds that the checker should wait
till it times out. If ct->running is non-zero, but the path is still
pending, check_state() increments ct->running and returns PATH_PENDING.

libcheck_pending() is called by get_state() every time a path gets
checked and its state is PATH_PENDING. If ct->running is greater than
c->timeout then the checker has timed out (it assumes that ct->running is
counting seconds) and gets cancelled.

Also, I only see (ct->running > c->timeout), not
(ct->running - c->timeout) are you talking about something else in the
code that I'm missing?

At any rate, I can change this to use actual timestamps instead of our
ct->running assumptions.

-Ben

> 
> Martin

