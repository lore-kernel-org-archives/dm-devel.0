Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FE520CCFD
	for <dm-devel@lists.linux.dev>; Tue,  8 Oct 2024 19:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728416016; cv=none; b=pFNcbWhULllXI2YkaDDxUovpdOPAPL8pjV2/xfEv3mueZrJ4yyR4/DjjUJ5cjKhrivoCgq8q6XxNfd/4TdXbmMw5Vx2yEZQX52cO2xOaKz4Ldm3kGRlJqPgcIC0nBHykE8u55Evclf/bOKoBodNkX8tghKJpnROpfmUbfxm2Cq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728416016; c=relaxed/simple;
	bh=sKSPQX4rkkaFz2+tA4VDYs61KDS58CChg4x2lIx1z2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Et85bxXBzEqypLy5Wn8cjWn3BsHYDFCsc3vl6AURxYCMlLBytaBPB0q0QBeUy3227AZrf4HaGFNGKJ8kLdB4yJjIOTmjS6LmKY6H7cLyZZ8yoA160Bb7TRbt1ikuLPftTG0v11JPYITgRMl3OtP1SyopByZISM84nWbnig2/pFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d/jb/zfC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d/jb/zfC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728416013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QPKydCUX1T2K54wlurH55LjI67uYeJdSMJo5A7uMDrk=;
	b=d/jb/zfClPojJaP2CWYLTYv8XKANWJNf6Qedx/fYNW4MCehBm1MGKSPk2TO8iYjHgJQzZF
	6taleK7zcOkpRhXNM1GxIe5z4jfze7u+TbAn6bxbefLlWSEtWa6VOS+Aq/NbuHKVbs86s/
	3THnZjGcVdNRxXXjFvJ8QwXEwiLD1XA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-510-vie_XncIMAq8uzKQ7oC0PA-1; Tue,
 08 Oct 2024 15:33:29 -0400
X-MC-Unique: vie_XncIMAq8uzKQ7oC0PA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A474C195608C;
	Tue,  8 Oct 2024 19:33:28 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 424F2300018D;
	Tue,  8 Oct 2024 19:33:28 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 498JXQWU2369919
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 8 Oct 2024 15:33:26 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 498JXQUl2369918;
	Tue, 8 Oct 2024 15:33:26 -0400
Date: Tue, 8 Oct 2024 15:33:26 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v2 19/22] libmultipath: add libcheck_need_wait checker
 function
Message-ID: <ZwWJBhwOnrUmtEa_@redhat.com>
References: <20240912214947.783819-1-bmarzins@redhat.com>
 <20240912214947.783819-20-bmarzins@redhat.com>
 <e46270826de9a255d6e16bcae56e984dfde346ac.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <e46270826de9a255d6e16bcae56e984dfde346ac.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Oct 03, 2024 at 11:15:21PM +0200, Martin Wilck wrote:
> On Thu, 2024-09-12 at 17:49 -0400, Benjamin Marzinski wrote:
> > Add a new optional checker class function, libcheck_need_wait() and a
> > new function to call it, checker_need_wait(). This can be used to see
> > if
> > a path_checker is currently running. This will be used to determine
> > if
> > there are pending checkers that need to be waited for.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/checkers.c          | 12 +++++++++++-
> >  libmultipath/checkers.h          |  4 +++-
> >  libmultipath/checkers/directio.c | 10 ++++++++++
> >  libmultipath/checkers/tur.c      | 10 ++++++++++
> >  4 files changed, 34 insertions(+), 2 deletions(-)
> > 
> > diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
> > index f3e98352..e2eda58d 100644
> > --- a/libmultipath/checkers.c
> > +++ b/libmultipath/checkers.c
> > @@ -27,6 +27,7 @@ struct checker_class {
> >  	void (*reset)(void);		     /* to reset the global
> > variables */
> >  	void *(*thread)(void *);	     /* async thread entry
> > point */
> >  	int (*pending)(struct checker *);    /* to recheck pending
> > paths */
> > +	bool (*need_wait)(struct checker *); /* checker needs
> > waiting for */
> >  	const char **msgtable;
> >  	short msgtable_size;
> >  };
> > @@ -182,7 +183,8 @@ static struct checker_class
> > *add_checker_class(const char *name)
> >  	c->reset = (void (*)(void)) dlsym(c->handle,
> > "libcheck_reset");
> >  	c->thread = (void *(*)(void*)) dlsym(c->handle,
> > "libcheck_thread");
> >  	c->pending = (int (*)(struct checker *)) dlsym(c->handle,
> > "libcheck_pending");
> > -	/* These 4 functions can be NULL. call dlerror() to clear
> > out any
> > +	c->need_wait = (bool (*)(struct checker *)) dlsym(c->handle,
> > "libcheck_need_wait");
> > +	/* These 5 functions can be NULL. call dlerror() to clear
> > out any
> >  	 * error string */
> >  	dlerror();
> >  
> > @@ -313,6 +315,14 @@ int checker_get_state(struct checker *c)
> >  	return c->path_state;
> >  }
> >  
> > +bool checker_need_wait(struct checker *c)
> > +{
> > +	if (!c || !c->cls || c->path_state != PATH_PENDING ||
> > +	    !c->cls->need_wait)
> > +		return false;
> > +	return c->cls->need_wait(c);
> > +}
> > +
> >  void checker_check (struct checker * c, int path_state)
> >  {
> >  	if (!c)
> > diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
> > index b2342a1b..da91f499 100644
> > --- a/libmultipath/checkers.h
> > +++ b/libmultipath/checkers.h
> > @@ -2,6 +2,7 @@
> >  #define CHECKERS_H_INCLUDED
> >  
> >  #include <pthread.h>
> > +#include <stdbool.h>
> >  #include "list.h"
> >  #include "defaults.h"
> >  
> > @@ -171,6 +172,7 @@ struct checker_context {
> >  int start_checker_thread (pthread_t *thread, const pthread_attr_t
> > *attr,
> >  			  struct checker_context *ctx);
> >  int checker_get_state(struct checker *c);
> > +bool checker_need_wait(struct checker *c);
> >  void checker_check (struct checker *, int);
> >  int checker_is_sync(const struct checker *);
> >  const char *checker_name (const struct checker *);
> > @@ -191,7 +193,7 @@ void *libcheck_thread(struct checker_context
> > *ctx);
> >  void libcheck_reset(void);
> >  int libcheck_mp_init(struct checker *);
> >  int libcheck_pending(struct checker *c);
> > -
> > +bool libcheck_need_wait(struct checker *c);
> >  
> >  /*
> >   * msgid => message map.
> > diff --git a/libmultipath/checkers/directio.c
> > b/libmultipath/checkers/directio.c
> > index 904e3071..4beed02e 100644
> > --- a/libmultipath/checkers/directio.c
> > +++ b/libmultipath/checkers/directio.c
> > @@ -65,6 +65,7 @@ struct directio_context {
> >  	struct aio_group *aio_grp;
> >  	struct async_req *req;
> >  	struct timespec endtime;
> > +	bool waited_for;
> >  };
> >  
> >  static struct aio_group *
> > @@ -295,6 +296,7 @@ check_pending(struct directio_context *ct, struct
> > timespec endtime)
> >  	int r;
> >  	struct timespec currtime, timeout;
> >  
> > +	ct->waited_for = true;
> 
> Not sure if it's important, but strictly speaking, we have only waited
> for the checker if the endtime was in the future, which is often not
> the case. Otherwise we'd just have polled.

But we always set the endtime in the future when we're starting a new
request, so the first time the we call check_pending() we don't return
till we either get an answer or endtime has passed, which is what we
want waited_for to check (that we've give the checker till endtime to
respond).

-Ben

> 
> Martin
> 
> 
> >  	while(1) {
> >  		get_monotonic_time(&currtime);
> >  		timespecsub(&endtime, &currtime, &timeout);
> > @@ -346,6 +348,7 @@ check_state(int fd, struct directio_context *ct,
> > int sync, int timeout_secs)
> >  		get_monotonic_time(&ct->endtime);
> >  		ct->endtime.tv_nsec += 1000 * 1000;
> >  		normalize_timespec(&ct->endtime);
> > +		ct->waited_for = false;
> >  	}
> >  	ct->running++;
> >  	if (!sync)
> > @@ -386,6 +389,13 @@ static void set_msgid(struct checker *c, int
> > state)
> >  	}
> >  }
> >  
> > +bool libcheck_need_wait(struct checker *c)
> > +{
> > +	struct directio_context *ct = (struct directio_context *)c-
> > >context;
> > +	return (ct && ct->running && ct->req->state == PATH_PENDING
> > &&
> > +		!ct->waited_for);
> > +}
> > +
> >  int libcheck_pending(struct checker *c)
> >  {
> >  	int rc;
> > diff --git a/libmultipath/checkers/tur.c
> > b/libmultipath/checkers/tur.c
> > index 81db565b..41d6b9c3 100644
> > --- a/libmultipath/checkers/tur.c
> > +++ b/libmultipath/checkers/tur.c
> > @@ -59,6 +59,7 @@ struct tur_checker_context {
> >  	struct checker_context ctx;
> >  	unsigned int nr_timeouts;
> >  	struct timespec endtime;
> > +	bool waited_for;
> >  };
> >  
> >  int libcheck_init (struct checker * c)
> > @@ -351,9 +352,17 @@ int check_pending(struct checker *c)
> >  		ct->thread = 0;
> >  	}
> >  
> > +	ct->waited_for = true;
> >  	return tur_status;
> >  }
> >  
> > +bool libcheck_need_wait(struct checker *c)
> > +{
> > +	struct tur_checker_context *ct = c->context;
> > +	return (ct && ct->thread && uatomic_read(&ct->running) != 0
> > &&
> > +		!ct->waited_for);
> > +}
> > +
> >  int libcheck_pending(struct checker *c)
> >  {
> >  	struct tur_checker_context *ct = c->context;
> > @@ -463,6 +472,7 @@ int libcheck_check(struct checker * c)
> >  		pthread_mutex_unlock(&ct->lock);
> >  		ct->fd = c->fd;
> >  		ct->timeout = c->timeout;
> > +		ct->waited_for = false;
> >  		uatomic_add(&ct->holders, 1);
> >  		uatomic_set(&ct->running, 1);
> >  		tur_set_async_timeout(c);

