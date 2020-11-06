Return-Path: <SRS0=owAl=EM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8DC8C388F7
	for <dm-devel@archiver.kernel.org>; Fri,  6 Nov 2020 00:41:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 337C120719
	for <dm-devel@archiver.kernel.org>; Fri,  6 Nov 2020 00:41:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fVFQ1+Lw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 337C120719
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1604623294;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8osu6SKDtgaIUe5GC2wVnZLBV+Im4/j4DUzuFTshQDA=;
	b=fVFQ1+Lwy9RD229s7NGgVjgMWE3ixQhsovQhNAj0e7R12abPg9jNAxUSQ4MAP4cUqWZfBw
	xcZVTQXvq20cRVWiekkvexIZr94F0BQMcOkOCV2JqbGaJQN3Nwxi1MOFYFqUDy5yWeHkDl
	AAr8dXJGtXYTGftfQI7W2uOKzS2uNOU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-wubWXc5mNhGQksw48mCwUg-1; Thu, 05 Nov 2020 19:41:32 -0500
X-MC-Unique: wubWXc5mNhGQksw48mCwUg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11234805EFD;
	Fri,  6 Nov 2020 00:41:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 27ADA5C1CF;
	Fri,  6 Nov 2020 00:41:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5F588180B658;
	Fri,  6 Nov 2020 00:41:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A60fLSm024100 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 5 Nov 2020 19:41:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1A31625261; Fri,  6 Nov 2020 00:41:21 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D3F7219D61;
	Fri,  6 Nov 2020 00:41:17 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0A60fGjl005765; 
	Thu, 5 Nov 2020 18:41:16 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0A60fFAf005764;
	Thu, 5 Nov 2020 18:41:15 -0600
Date: Thu, 5 Nov 2020 18:41:15 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20201106004115.GH3384@octiron.msp.redhat.com>
References: <20201105114952.1059-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20201105114952.1059-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [RFC PATCH] libmultipath: prevent DSO unloading with
 astray checker threads
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 05, 2020 at 12:49:52PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> The multipathd tur checker thread is designed to be able to finish at
> any time, even after the tur checker itself has been freed. The
> multipathd shutdown code makes sure all the checkers have been freed
> before freeing the checker_class and calling dlclose() to unload the
> DSO, but this doesn't guarantee that the checker threads have finished.
> If one hasn't, the DSO will get unloaded while the thread still running
> code from it, causing a segfault.
> 
> This patch fixes the issue by further incrementing the DSO's refcount
> for every running thread. To avoid race conditions leading to segfaults,
> the thread's entrypoint must be in libmultipath, not in the DSO itself.
> Therefore we add a new optional checker method, libcheck_thread().
> Checkers defining this method may create a detached thread with
> entrypoint checker_thread_entry(), which will call the DSO's
> libcheck_thread and take care of the refcount handling.

I can't make this segfault. So that looks good, but it does need
libmultipath.version updated to include checker_thread_entry()

-Ben

> 
> Reported-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/checkers.c     | 55 ++++++++++++++++++++++++++++++++-----
>  libmultipath/checkers.h     | 17 ++++++++++++
>  libmultipath/checkers/tur.c |  7 ++---
>  3 files changed, 67 insertions(+), 12 deletions(-)
> 
> diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
> index f7ddd53..7d10f2a 100644
> --- a/libmultipath/checkers.c
> +++ b/libmultipath/checkers.c
> @@ -3,6 +3,9 @@
>  #include <stddef.h>
>  #include <dlfcn.h>
>  #include <sys/stat.h>
> +#include <pthread.h>
> +#include <urcu.h>
> +#include <urcu/uatomic.h>
>  
>  #include "debug.h"
>  #include "checkers.h"
> @@ -19,6 +22,7 @@ struct checker_class {
>  	int (*mp_init)(struct checker *);    /* to allocate the mpcontext */
>  	void (*free)(struct checker *);      /* to free the context */
>  	void (*reset)(void);		     /* to reset the global variables */
> +	void *(*thread)(void *);	     /* async thread entry point */
>  	const char **msgtable;
>  	short msgtable_size;
>  };
> @@ -54,19 +58,32 @@ static struct checker_class *alloc_checker_class(void)
>  	c = MALLOC(sizeof(struct checker_class));
>  	if (c) {
>  		INIT_LIST_HEAD(&c->node);
> -		c->refcount = 1;
> +		uatomic_set(&c->refcount, 1);
>  	}
>  	return c;
>  }
>  
> +/* Use uatomic_{sub,add}_return() to ensure proper memory barriers */
> +static int checker_class_ref(struct checker_class *cls)
> +{
> +	return uatomic_add_return(&cls->refcount, 1);
> +}
> +
> +static int checker_class_unref(struct checker_class *cls)
> +{
> +	return uatomic_sub_return(&cls->refcount, 1);
> +}
> +
>  void free_checker_class(struct checker_class *c)
>  {
> +	int cnt;
> +
>  	if (!c)
>  		return;
> -	c->refcount--;
> -	if (c->refcount) {
> -		condlog(4, "%s checker refcount %d",
> -			c->name, c->refcount);
> +	cnt = checker_class_unref(c);
> +	if (cnt != 0) {
> +		condlog(cnt < 0 ? 1 : 4, "%s checker refcount %d",
> +			c->name, cnt);
>  		return;
>  	}
>  	condlog(3, "unloading %s checker", c->name);
> @@ -160,7 +177,8 @@ static struct checker_class *add_checker_class(const char *multipath_dir,
>  
>  	c->mp_init = (int (*)(struct checker *)) dlsym(c->handle, "libcheck_mp_init");
>  	c->reset = (void (*)(void)) dlsym(c->handle, "libcheck_reset");
> -	/* These 2 functions can be NULL. call dlerror() to clear out any
> +	c->thread = (void *(*)(void*)) dlsym(c->handle, "libcheck_thread");
> +	/* These 3 functions can be NULL. call dlerror() to clear out any
>  	 * error string */
>  	dlerror();
>  
> @@ -346,6 +364,29 @@ bad_id:
>  	return generic_msg[CHECKER_MSGID_NONE];
>  }
>  
> +static void checker_cleanup_thread(void *arg)
> +{
> +	struct checker_class *cls = arg;
> +
> +	(void)checker_class_unref(cls);
> +	rcu_unregister_thread();
> +}
> +
> +void *checker_thread_entry(void *arg)
> +{
> +	struct checker *chk = arg;
> +	void *rv;
> +
> +	assert(chk && chk->cls && chk->cls->thread);
> +
> +	rcu_register_thread();
> +	(void)checker_class_ref(chk->cls);
> +	pthread_cleanup_push(checker_cleanup_thread, chk->cls);
> +	rv = chk->cls->thread(chk->context);
> +	pthread_cleanup_pop(1);
> +	return rv;
> +}
> +
>  void checker_clear_message (struct checker *c)
>  {
>  	if (!c)
> @@ -370,7 +411,7 @@ void checker_get(const char *multipath_dir, struct checker *dst,
>  	if (!src)
>  		return;
>  
> -	src->refcount++;
> +	(void)checker_class_ref(dst->cls);
>  }
>  
>  int init_checkers(const char *multipath_dir)
> diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
> index 9d5f90b..01af02d 100644
> --- a/libmultipath/checkers.h
> +++ b/libmultipath/checkers.h
> @@ -148,6 +148,23 @@ void checker_set_async (struct checker *);
>  void checker_set_fd (struct checker *, int);
>  void checker_enable (struct checker *);
>  void checker_disable (struct checker *);
> +/*
> + * checker_thread_entry(): entry point for async path checker thread
> + *
> + * Path checkers that do I/O may hang forever. To avoid blocking, some
> + * checkers therefore use asyncronous, detached threads for checking
> + * the paths. These threads may continue hanging if multipathd is stopped.
> + * In this case, we can't unload the checker DSO at exit. In order to
> + * avoid race conditions and crashes, the entry point of the thread
> + * needs to be in libmultipath, not in the DSO itself.
> + * Checker threads must use this function as entry point. It will call
> + * the DSO's "libcheck_thread" function with the checker context as
> + * argument. When libcheck_thread() returns, it will clean up and
> + * decrement the DSO's refcount. See the tur checker for a usage example.
> + *
> + * @param arg: pointer to struct checker, must have non-NULL cls->thread
> + */
> +void *checker_thread_entry (void *);
>  int checker_check (struct checker *, int);
>  int checker_is_sync(const struct checker *);
>  const char *checker_name (const struct checker *);
> diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
> index e886fcf..063c419 100644
> --- a/libmultipath/checkers/tur.c
> +++ b/libmultipath/checkers/tur.c
> @@ -15,7 +15,6 @@
>  #include <errno.h>
>  #include <sys/time.h>
>  #include <pthread.h>
> -#include <urcu.h>
>  #include <urcu/uatomic.h>
>  
>  #include "checkers.h"
> @@ -204,7 +203,6 @@ static void cleanup_func(void *data)
>  	holders = uatomic_sub_return(&ct->holders, 1);
>  	if (!holders)
>  		cleanup_context(ct);
> -	rcu_unregister_thread();
>  }
>  
>  /*
> @@ -251,7 +249,7 @@ static void tur_deep_sleep(const struct tur_checker_context *ct)
>  #define tur_deep_sleep(x) do {} while (0)
>  #endif /* TUR_TEST_MAJOR */
>  
> -static void *tur_thread(void *ctx)
> +void *libcheck_thread(void *ctx)
>  {
>  	struct tur_checker_context *ct = ctx;
>  	int state, running;
> @@ -259,7 +257,6 @@ static void *tur_thread(void *ctx)
>  
>  	/* This thread can be canceled, so setup clean up */
>  	tur_thread_cleanup_push(ct);
> -	rcu_register_thread();
>  
>  	condlog(4, "%d:%d : tur checker starting up", major(ct->devt),
>  		minor(ct->devt));
> @@ -394,7 +391,7 @@ int libcheck_check(struct checker * c)
>  		uatomic_set(&ct->running, 1);
>  		tur_set_async_timeout(c);
>  		setup_thread_attr(&attr, 32 * 1024, 1);
> -		r = pthread_create(&ct->thread, &attr, tur_thread, ct);
> +		r = pthread_create(&ct->thread, &attr, checker_thread_entry, c);
>  		pthread_attr_destroy(&attr);
>  		if (r) {
>  			uatomic_sub(&ct->holders, 1);
> -- 
> 2.29.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

