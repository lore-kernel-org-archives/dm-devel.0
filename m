Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516E03C13F1
	for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 06:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774334312; cv=none; b=WnXJ6JypEyG7BYfEMav2Q7cdNNXdLwOSIrcN98s49mTTay5H23h/fl3ZowdV2Y+YPjUd0Mxw/QmYKizq4QQ9X/M4xyZGD/R3x5LgqqaspL5F+cbv2TmIJjnjedehPcna0bpssYJKOTngk0mPorMXiWGCfXxAZpi5i26KoDP5WNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774334312; c=relaxed/simple;
	bh=5ZLl7gEWMPyKw+L/2HRGS6wnk7FeRwQi9CUa+y+tUsY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Yu3P0gxQ4SNr7ixjaZAoudciY56Ty7lP23fDTFHGcoy5J7zfvnUCpUoECtJIlY4PPZWX1Rf0I2VjmuQh3NGLhaGZ0GJcAkkD9RyneRgSCh9gVNUz+n2n4cppH9dgjKGgB3FRUI1C3prXwt+vo28zcRSHMlZ+U7qVMpMbNVtc2rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e+KyAIyK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e+KyAIyK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774334309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GBQAb3wjqvBNjd7x/KGa+Y60ncfNH8ftsGCEsXnoyzY=;
	b=e+KyAIyKK3HZvi/lePegPM17mZV6WxvnBA8oAYaWIjcwxuEUI1V9BnOfVR0T0fxQA8xxT7
	CzkfZpEAV6m8EZz+4td/Rbal3e52Y1XzsMRPaxVIa46QTpsT/M/AWHu+n0mp61uGhyKUVp
	Wri4VhR6rH/YHsxw9xy9ZjrqqHE9yTw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-477-l1LoZzKBOMCsmnqoKCzagQ-1; Tue,
 24 Mar 2026 02:38:25 -0400
X-MC-Unique: l1LoZzKBOMCsmnqoKCzagQ-1
X-Mimecast-MFC-AGG-ID: l1LoZzKBOMCsmnqoKCzagQ_1774334304
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 29612195607B;
	Tue, 24 Mar 2026 06:38:24 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E67D9300019F;
	Tue, 24 Mar 2026 06:38:23 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 62O6cMVJ1048752
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 24 Mar 2026 02:38:22 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 62O6cMqJ1048751;
	Tue, 24 Mar 2026 02:38:22 -0400
Date: Tue, 24 Mar 2026 02:38:22 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 4/4] libmultipath: TUR checker: use runner threads
Message-ID: <acIxXt69d6JkDtlQ@redhat.com>
References: <20260319221344.753790-1-mwilck@suse.com>
 <20260319221344.753790-5-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260319221344.753790-5-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Mr-jLMz_ZtaUBIy1VGYLnrA3_QevKFs5bLSWBt_GboM_1774334304
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 19, 2026 at 11:13:44PM +0100, Martin Wilck wrote:
> Use the generic runners to simplify the TUR checker code.
> 
> The logic is the same as before, with one exception: the runner API does
> not allow to track a thread after it has been cancelled, like our current
> code does. The current code used this to determine when a previously
> cancelled thread eventually did complete. The use case for doing this in
> the current code was the MAX_NR_RUNNERS logic: the code waited "forever"
> for the "last" checker to complete. This is not possible with runners;
> once a runner is cancelled, it is off limits. (Waiting for a zombie thread to
> write to memory belonging to the main program, as the current code does,
> doesn't seem to be the best idea, anyway).
> 
> Therefore this patch implements a different logic for MAX_NR_RUNNERS. When
> nr_timeouts reaches the limit, the last checker is spawned with an infinite
> timeout. Like before, no new checker thread will be spawned until this last
> checker eventually completes. One difference to the previous code is that
> this last checker thread is never cancelled (after all, it never times
> out). But this code is meant for the case where cancellation is not
> effective, anyway. Another difference is that the new code will report
> PATH_TIMEOUT state as soon as this last thread is started rather than
> PATH_PENDING. That seems reasonable given that the checker previously timed
> out for this thread.

I'm not super enthused about this way of handling the misbehaving
threads. It's probably o.k. But what if the issue is that the checker
isn't completing by itself at all, but it would eventually get
cancelled, just not till after we timeout. In this case, we should be
cancelling that last runner. Admittedly, it's kinda hard to believe that
a new runner would work correctly, while the old one still is stuck
needing to be cancelled, but what we had before definitely worked.

I don't really see why we can't continue with roughly what we had
before. We just need a new state for check_runner_state() to return.
Something like RUNNER_STOPPING. cancel_runner() would cmpxchg with
RUNNER_STOPPING, and not free the runner_context. In check_runner(), if
the state was RUNNER_STOPPING or you just called cancel_runner(), you
would check the ctx->refcount. If it was already 1, you would release
the context and return RUNNER_CANCELLED. This way RUNNER_CANCELLED still
means that the context has been freed, but it would only happen when the
thread has ended. If you want to stop paying attention to a runner in
RUNNER_STOPPING, you just call release_context() manually to drop your
reference without waiting for it to finish.

Then, if you still have a runner in RUNNER_STOPPING after calling
check_runner_state() at the start of libcheck_check(), you drop your
reference to it if ct->nr_timeouts < MAX_NR_TIMEOUTS. Otherwise you just
return PATH_TIMEOUT.

Thoughts? Like I said, I think what you have will probably be fine.
I just know what we had before worked.

More comments below.

> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/checkers/tur.c | 341 +++++++++++-------------------------
>  1 file changed, 103 insertions(+), 238 deletions(-)
> 
> diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
> index ba4ca68..6f22c45 100644
> --- a/libmultipath/checkers/tur.c
> +++ b/libmultipath/checkers/tur.c
> @@ -3,7 +3,6 @@
>   *
>   * Copyright (c) 2004 Christophe Varoqui
>   */
> -#include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
>  #include <sys/types.h>
> @@ -17,13 +16,13 @@
>  #include <pthread.h>
>  #include <urcu.h>
>  #include <urcu/uatomic.h>
> +#include <assert.h>
>  
>  #include "checkers.h"
>  
>  #include "debug.h"
>  #include "sg_include.h"
> -#include "util.h"
> -#include "time-util.h"
> +#include "runner.h"
>  
>  #define TUR_CMD_LEN 6
>  #define HEAVY_CHECK_COUNT       10
> @@ -45,21 +44,20 @@ const char *libcheck_msgtable[] = {
>  	NULL,
>  };
>  
> -struct tur_checker_context {
> -	dev_t devt;
> -	int state;
> -	int running; /* uatomic access only */
> +struct tur_context {
>  	int fd;
> +	dev_t devt;
>  	unsigned int timeout;
> -	time_t time;
> -	pthread_t thread;
> -	pthread_mutex_t lock;
> -	pthread_cond_t active;
> -	int holders; /* uatomic access only */
> -	int msgid;
> +	int state;
> +	short msgid;
> +};
> +
> +struct tur_checker_context {
>  	struct checker_context ctx;
> +	int last_runner_state;
>  	unsigned int nr_timeouts;
> -	bool checked_state;
> +	struct runner_context *rtx;
> +	struct tur_context tcx;

There are lots of structures named *_context with names like *tx.
Perhaps we could rename the tur_context something like tur_data?

Also, ctx is the checker_context here, and the runner_contect in the
runner.c code. I think it would be easier to follow and grep if we kept
the runner_context named rtx in both places.

>  };
>  
>  int libcheck_init (struct checker * c)
> @@ -67,48 +65,26 @@ int libcheck_init (struct checker * c)
>  	struct tur_checker_context *ct;

Also the tur_checker_context is tcc in every function but this one. I
think it helpful to always have the same name.

>  	struct stat sb;
>  
> -	ct = malloc(sizeof(struct tur_checker_context));
> -	if (!ct)
> -		return 1;
> -	memset(ct, 0, sizeof(struct tur_checker_context));
> -
> -	ct->state = PATH_UNCHECKED;
> -	ct->fd = -1;
> -	uatomic_set(&ct->holders, 1);
> -	pthread_cond_init_mono(&ct->active);
> -	pthread_mutex_init(&ct->lock, NULL);
> +	ct = calloc(1, sizeof(*ct));
> +	ct->tcx.state = PATH_UNCHECKED;
> +	ct->tcx.fd = -1;
>  	if (fstat(c->fd, &sb) == 0)
> -		ct->devt = sb.st_rdev;
> +		ct->tcx.devt = sb.st_rdev;
>  	ct->ctx.cls = c->cls;
>  	c->context = ct;
> -
>  	return 0;
>  }
>  
> -static void cleanup_context(struct tur_checker_context *ct)
> -{
> -	pthread_mutex_destroy(&ct->lock);
> -	pthread_cond_destroy(&ct->active);
> -	free(ct);
> -}
> -
>  void libcheck_free (struct checker * c)
>  {
> -	if (c->context) {
> -		struct tur_checker_context *ct = c->context;
> -		int holders;
> -		int running;
> +	struct tur_checker_context *tcc = c->context;
>  
> -		running = uatomic_xchg(&ct->running, 0);
> -		if (running)
> -			pthread_cancel(ct->thread);
> -		ct->thread = 0;
> -		holders = uatomic_sub_return(&ct->holders, 1);
> -		if (!holders)
> -			cleanup_context(ct);
> -		c->context = NULL;
> -	}
> -	return;
> +	if (!tcc)
> +		return;
> +	c->context = NULL;
> +	if (tcc->rtx)
> +		cancel_runner(tcc->rtx);
> +	free(tcc);
>  }
>  
>  static int
> @@ -216,19 +192,6 @@ retry:
>  	return PATH_UP;
>  }
>  
> -#define tur_thread_cleanup_push(ct) pthread_cleanup_push(cleanup_func, ct)
> -#define tur_thread_cleanup_pop(ct) pthread_cleanup_pop(1)
> -
> -static void cleanup_func(void *data)
> -{
> -	int holders;
> -	struct tur_checker_context *ct = data;
> -
> -	holders = uatomic_sub_return(&ct->holders, 1);
> -	if (!holders)
> -		cleanup_context(ct);
> -}
> -
>  /*
>   * Test code for "zombie tur thread" handling.
>   * Compile e.g. with CFLAGS=-DTUR_TEST_MAJOR=8
> @@ -273,110 +236,82 @@ static void tur_deep_sleep(const struct tur_checker_context *ct)
>  #define tur_deep_sleep(x) do {} while (0)
>  #endif /* TUR_TEST_MAJOR */
>  
> -void *libcheck_thread(struct checker_context *ctx)
> +void runner_callback(void *arg)
>  {
> -	struct tur_checker_context *ct =
> -		container_of(ctx, struct tur_checker_context, ctx);
> -	int state, running;
> -	short msgid;
> +	struct tur_context *tcx = arg;
> +	int state;
>  
> -	/* This thread can be canceled, so setup clean up */
> -	tur_thread_cleanup_push(ct);
> +	condlog(4, "%d:%d : tur checker starting up", major(tcx->devt),
> +		minor(tcx->devt));
>  
> -	condlog(4, "%d:%d : tur checker starting up", major(ct->devt),
> -		minor(ct->devt));
> -
> -	tur_deep_sleep(ct);
> -	state = tur_check(ct->fd, ct->timeout, &msgid);
> +	tur_deep_sleep(tcx);
> +	state = tur_check(tcx->fd, tcx->timeout, &tcx->msgid);
> +	tcx->state = state;
>  	pthread_testcancel();
> -
> -	/* TUR checker done */
> -	pthread_mutex_lock(&ct->lock);
> -	ct->state = state;
> -	ct->msgid = msgid;
> -	pthread_cond_signal(&ct->active);
> -	pthread_mutex_unlock(&ct->lock);
> -
> -	condlog(4, "%d:%d : tur checker finished, state %s", major(ct->devt),
> -		minor(ct->devt), checker_state_name(state));
> -
> -	running = uatomic_xchg(&ct->running, 0);
> -	if (!running)
> -		pause();
> -
> -	tur_thread_cleanup_pop(ct);
> -
> -	return ((void *)0);
> +	condlog(4, "%d:%d : tur checker finished, state %s", major(tcx->devt),
> +		minor(tcx->devt), checker_state_name(state));
>  }
>  
> -static void tur_set_async_timeout(struct checker *c)
> +static int check_runner_state(struct tur_checker_context *tcc)
>  {
> -	struct tur_checker_context *ct = c->context;
> -	struct timespec now;
> +	struct runner_context *rtx = tcc->rtx;
> +	int rc;
>  
> -	get_monotonic_time(&now);
> -	ct->time = now.tv_sec + c->timeout;
> -}
> -
> -static int tur_check_async_timeout(struct checker *c)
> -{
> -	struct tur_checker_context *ct = c->context;
> -	struct timespec now;
> -
> -	get_monotonic_time(&now);
> -	return (now.tv_sec > ct->time);
> -}
> -
> -int check_pending(struct checker *c)
> -{
> -	struct tur_checker_context *ct = c->context;
> -	int tur_status = PATH_PENDING;
> -
> -	pthread_mutex_lock(&ct->lock);
> -
> -	if (ct->state != PATH_PENDING || ct->msgid != MSG_TUR_RUNNING)
> -	{
> -		tur_status = ct->state;
> -		c->msgid = ct->msgid;
> -	}
> -	pthread_mutex_unlock(&ct->lock);
> -	if (tur_status == PATH_PENDING && c->msgid == MSG_TUR_RUNNING) {
> +	rc = check_runner(rtx, &tcc->tcx, sizeof(tcc->tcx));
> +	switch (rc) {
> +	case RUNNER_DONE:
> +		tcc->last_runner_state = rc;
> +		tcc->rtx = NULL;
> +		tcc->nr_timeouts = 0;
> +		condlog(3, "%d:%d : tur checker finished, state %s",
> +			major(tcc->tcx.devt), minor(tcc->tcx.devt),
> +			checker_state_name(tcc->tcx.state));
> +		break;
> +	case RUNNER_CANCELLED:
> +		tcc->last_runner_state = rc;
> +		tcc->rtx = NULL;
> +		tcc->tcx.state = PATH_TIMEOUT;
> +		tcc->tcx.msgid = MSG_TUR_TIMEOUT;
> +		if (tcc->nr_timeouts < MAX_NR_TIMEOUTS)
> +			tcc->nr_timeouts++;
> +		condlog(3, "%d:%d : tur checker timed out",
> +			major(tcc->tcx.devt), minor(tcc->tcx.devt));
> +		break;
> +	case RUNNER_RUNNING:
>  		condlog(4, "%d:%d : tur checker still running",
> -			major(ct->devt), minor(ct->devt));
> -	} else {
> -		int running = uatomic_xchg(&ct->running, 0);
> -		if (running)
> -			pthread_cancel(ct->thread);
> -		ct->thread = 0;
> +			major(tcc->tcx.devt), minor(tcc->tcx.devt));
> +		tcc->tcx.msgid = MSG_TUR_RUNNING;
> +		break;
> +	default:
> +		assert(false);
> +		break;
>  	}
> -
> -	ct->checked_state = true;
> -	return tur_status;
> +	return rc;
>  }
>  
>  bool libcheck_need_wait(struct checker *c)
>  {
>  	struct tur_checker_context *ct = c->context;
> -	return (ct && ct->thread && uatomic_read(&ct->running) != 0 &&
> -		!ct->checked_state);
> +
> +	return ct && ct->rtx;
>  }
>  
>  int libcheck_pending(struct checker *c)
>  {
>  	struct tur_checker_context *ct = c->context;
> -
>  	/* The if path checker isn't running, just return the exiting value. */
> -	if (!ct || !ct->thread)
> +	if (!ct || !ct->rtx)
>  		return c->path_state;
>  
> -	return check_pending(c);
> +	/* This may nullify ct->rtx */
> +	check_runner_state(ct);
> +	c->msgid = ct->tcx.msgid;
> +	return ct->tcx.state;
>  }
>  
>  int libcheck_check(struct checker * c)
>  {
>  	struct tur_checker_context *ct = c->context;
> -	pthread_attr_t attr;
> -	int tur_status, r;
>  
>  	if (!ct)
>  		return PATH_UNCHECKED;
> @@ -384,109 +319,39 @@ int libcheck_check(struct checker * c)
>  	if (checker_is_sync(c))
>  		return tur_check(c->fd, c->timeout, &c->msgid);
>  
> -	/*
> -	 * Async mode
> -	 */
> -	if (ct->thread) {
> -		ct->checked_state = true;
> -		if (tur_check_async_timeout(c)) {
> -			int running = uatomic_xchg(&ct->running, 0);
> -			if (running) {
> -				pthread_cancel(ct->thread);
> -				condlog(3, "%d:%d : tur checker timeout",
> -					major(ct->devt), minor(ct->devt));
> -				c->msgid = MSG_TUR_TIMEOUT;
> -				tur_status = PATH_TIMEOUT;
> -			} else {
> -				pthread_mutex_lock(&ct->lock);
> -				tur_status = ct->state;
> -				c->msgid = ct->msgid;
> -				pthread_mutex_unlock(&ct->lock);
> -			}
> -			ct->thread = 0;
> -		} else if (uatomic_read(&ct->running) != 0) {
> +	/* Handle the case that the checker just completed */
> +	if (ct->rtx) {
> +		if (check_runner_state(ct) == RUNNER_RUNNING)
>  			condlog(3, "%d:%d : tur checker not finished",
> -				major(ct->devt), minor(ct->devt));
> -			tur_status = PATH_PENDING;
> -			c->msgid = MSG_TUR_RUNNING;
> -		} else {
> -			/* TUR checker done */
> -			ct->thread = 0;
> -			pthread_mutex_lock(&ct->lock);
> -			tur_status = ct->state;
> -			c->msgid = ct->msgid;
> -			pthread_mutex_unlock(&ct->lock);
> -		}
> -	} else {
> -		if (uatomic_read(&ct->holders) > 1) {
> -			/* The thread has been cancelled but hasn't quit. */
> -			if (ct->nr_timeouts == MAX_NR_TIMEOUTS) {
> -				condlog(2, "%d:%d : waiting for stalled tur thread to finish",
> -					major(ct->devt), minor(ct->devt));
> -				ct->nr_timeouts++;
> -			}
> -			/*
> -			 * Don't start new threads until the last once has
> -			 * finished.
> -			 */
> -			if (ct->nr_timeouts > MAX_NR_TIMEOUTS) {
> -				c->msgid = MSG_TUR_TIMEOUT;
> -				return PATH_TIMEOUT;
> -			}
> -			ct->nr_timeouts++;
> -			/*
> -			 * Start a new thread while the old one is stalled.
> -			 * We have to prevent it from interfering with the new
> -			 * thread. We create a new context and leave the old
> -			 * one with the stale thread, hoping it will clean up
> -			 * eventually.
> -			 */
> -			condlog(3, "%d:%d : tur thread not responding",
> -				major(ct->devt), minor(ct->devt));
> -
> -			/*
> -			 * libcheck_init will replace c->context.
> -			 * It fails only in OOM situations. In this case, return
> -			 * PATH_UNCHECKED to avoid prematurely failing the path.
> -			 */
> -			if (libcheck_init(c) != 0) {
> -				c->msgid = MSG_TUR_FAILED;
> -				return PATH_UNCHECKED;
> -			}
> -			((struct tur_checker_context *)c->context)->nr_timeouts = ct->nr_timeouts;
> -
> -			if (!uatomic_sub_return(&ct->holders, 1)) {
> -				/* It did terminate, eventually */
> -				cleanup_context(ct);
> -				((struct tur_checker_context *)c->context)->nr_timeouts = 0;
> -			}
> -
> -			ct = c->context;
> -		} else
> -			ct->nr_timeouts = 0;
> -		/* Start new TUR checker */
> -		pthread_mutex_lock(&ct->lock);
> -		tur_status = ct->state = PATH_PENDING;
> -		c->msgid = ct->msgid = MSG_TUR_RUNNING;
> -		pthread_mutex_unlock(&ct->lock);
> -		ct->fd = c->fd;
> -		ct->timeout = c->timeout;
> -		ct->checked_state = false;
> -		uatomic_add(&ct->holders, 1);
> -		uatomic_set(&ct->running, 1);
> -		tur_set_async_timeout(c);
> -		setup_thread_attr(&attr, 32 * 1024, 1);
> -		r = start_checker_thread(&ct->thread, &attr, &ct->ctx);
> -		pthread_attr_destroy(&attr);
> -		if (r) {
> -			uatomic_sub(&ct->holders, 1);
> -			uatomic_set(&ct->running, 0);
> -			ct->thread = 0;
> -			condlog(3, "%d:%d : failed to start tur thread, using"
> -				" sync mode", major(ct->devt), minor(ct->devt));
> -			return tur_check(c->fd, c->timeout, &c->msgid);
> -		}
> +				major(ct->tcx.devt), minor(ct->tcx.devt));
> +		c->msgid = ct->tcx.msgid;
> +		return ct->tcx.state;
>  	}
>  
> -	return tur_status;
> +	/* create new checker thread */
> +	ct->tcx.fd = c->fd;
> +	ct->tcx.timeout = c->timeout;
> +
> +	if (ct->nr_timeouts < MAX_NR_TIMEOUTS) {
> +		condlog(3, "%d:%d : starting checker with timeout",
> +			major(ct->tcx.devt), minor(ct->tcx.devt));
> +		ct->tcx.state = PATH_PENDING;
> +		ct->tcx.msgid = MSG_TUR_RUNNING;
> +		ct->rtx = get_runner(runner_callback, &ct->tcx,
> +				     sizeof(ct->tcx), 1000000 * c->timeout);
> +	} else {
> +		condlog(3, "%d:%d : starting checker without timeout",
> +			major(ct->tcx.devt), minor(ct->tcx.devt));
> +		ct->tcx.state = PATH_TIMEOUT;

shouldn't we set ct->tcx.msgid = MSG_TUR_MSG_TUR_TIMEOUT here?

-Ben

> +		ct->rtx = get_runner(runner_callback, &ct->tcx, sizeof(ct->tcx), 0);
> +	}
> +
> +	if (ct->rtx) {
> +		c->msgid = ct->tcx.msgid;
> +		return ct->tcx.state;
> +	} else {
> +		condlog(3, "%d:%d : failed to start tur thread, using sync mode",
> +			major(ct->tcx.devt), minor(ct->tcx.devt));
> +		return tur_check(c->fd, c->timeout, &c->msgid);
> +	}
>  }
> -- 
> 2.53.0

