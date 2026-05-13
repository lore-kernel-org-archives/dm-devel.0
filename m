Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFCD299929
	for <dm-devel@lists.linux.dev>; Wed, 13 May 2026 00:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778633411; cv=none; b=nwVHcxQozdJdJosp+Ob+CdDxy4jafTvO0EJ3aju6KUZ8px0xxFqKAdXYVMoYpz0JVeNp4j+cAMxoe5JqyZuMMpZ5ZbnYzTu2TDXfYVs57rLKvG9gFhdiVYTLMVF0SVLb8rWJNUFCVGGCJNpgQpDeVObWGaHbwXWqUi97m+xectY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778633411; c=relaxed/simple;
	bh=vwPc3Th2AA2LFl1XGF1CBZDAjgowDEeKsjihWfWvTaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=fcnLYhCRF3dvBWAAjg84df46MSpk8BDDZTld7xZNlJIghHjeZoTgTtjfzua4J/CvsaQftuzruszxeh1rWiPjfufIET7QGKHETnIG2Sk4478MUU9NeUgKscPP0AnM3m61vtAPYz0hK9S9sZdlgfeHnXZ9U+JQuR3UN0noxtbjIzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jRKOsrlc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jRKOsrlc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778633408;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JV5ihHVYucGwURWz9rr2liZGhAivy86DS0S1HrTWx1k=;
	b=jRKOsrlcUVbAHhsKnrqTq/0rSsOgLbCKy3SfteKJ2zcOZeRQko/8chqhZpK1H5N/qirryk
	vyJ1UmL58lH3qX0TsOHvY7bzvFw9M8xRRaks8qcca7bIQgEcMWefSb4GnCqIMD00ehOzgP
	M9S5utO6jty2EByjMno1Ol07se74hkY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-H0Nmnd57P6O9OLMC1O-04A-1; Tue,
 12 May 2026 20:50:05 -0400
X-MC-Unique: H0Nmnd57P6O9OLMC1O-04A-1
X-Mimecast-MFC-AGG-ID: H0Nmnd57P6O9OLMC1O-04A_1778633402
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 22D0E1955F27;
	Wed, 13 May 2026 00:50:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 09B6630030EE;
	Wed, 13 May 2026 00:49:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 64D0nwZL3331828
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 12 May 2026 20:49:58 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 64D0nw7D3331827;
	Tue, 12 May 2026 20:49:58 -0400
Date: Tue, 12 May 2026 20:49:58 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 06/18] libmultipath: use shared_ptr for checker classes
Message-ID: <agPKtqVRFSIsxerR@redhat.com>
References: <20260505154332.448054-1-mwilck@suse.com>
 <20260505154332.448054-7-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260505154332.448054-7-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aMPKQcDvjD9BRUNZeA_yob8JPJAcjUnGMsz2mWTIuHQ_1778633402
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 05, 2026 at 05:43:20PM +0200, Martin Wilck wrote:
> Utilize the share_ptr code for tracking the refcount of checker classes.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/checkers.c | 98 +++++++++--------------------------------
>  libmultipath/checkers.h |  2 -
>  2 files changed, 20 insertions(+), 80 deletions(-)
> 
> diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
> index 8f18ca6..a3b9cc8 100644
> --- a/libmultipath/checkers.c
> +++ b/libmultipath/checkers.c
[...]
> @@ -163,8 +143,7 @@ static struct checker_class *add_checker_class(const char *name)
>  		goto out;
>  
>  	c->mp_init = (int (*)(struct checker *)) dlsym(c->handle, "libcheck_mp_init");
> -	c->reset = (void (*)(void)) dlsym(c->handle, "libcheck_reset");
> -	c->thread = (void *(*)(void*)) dlsym(c->handle, "libcheck_thread");
> +	c->reset = (void (*)(void))dlsym(c->handle, "libcheck_reset");

Nitpick. Dropped a space here.

>  	c->pending = (int (*)(struct checker *)) dlsym(c->handle, "libcheck_pending");
>  	c->need_wait = (bool (*)(struct checker *)) dlsym(c->handle, "libcheck_need_wait");
>  	/* These 5 functions can be NULL. call dlerror() to clear out any
[...]
> @@ -371,43 +350,6 @@ bad_id:
>  	return generic_msg[CHECKER_MSGID_NONE];
>  }

Removing the checker thread stuff is more of a cleanup from d1ebd977. It
should probably either be it's own cleanup patch, or it should at least
get mentioned in the commit message.
  
> -static void checker_cleanup_thread(void *arg)
> -{
> -	struct checker_class *cls = arg;
> -
> -	free_checker_class(cls);
> -	rcu_unregister_thread();
> -}
> -
> -static void *checker_thread_entry(void *arg)
> -{
> -	struct checker_context *ctx = arg;
> -	void *rv;
> -
> -	rcu_register_thread();
> -	pthread_cleanup_push(checker_cleanup_thread, ctx->cls);
> -	rv = ctx->cls->thread(ctx);
> -	pthread_cleanup_pop(1);
> -	return rv;
> -}
> -

Also, start_checker_thread() is stil declared in libmultipath/checkers.h,
along with a comment.

-Ben

> -int start_checker_thread(pthread_t *thread, const pthread_attr_t *attr,
> -			 struct checker_context *ctx)
> -{
> -	int rv;
> -
> -	assert(ctx && ctx->cls && ctx->cls->thread);
> -	/* Take a ref here, lest the class be freed before the thread starts */
> -	(void)checker_class_ref(ctx->cls);
> -	rv = pthread_create(thread, attr, checker_thread_entry, ctx);
> -	if (rv != 0) {
> -		condlog(1, "failed to start checker thread for %s: %m",
> -			ctx->cls->name);
> -		checker_class_unref(ctx->cls);
> -	}
> -	return rv;
> -}
> -
>  void checker_clear_message (struct checker *c)
>  {
>  	if (!c)

