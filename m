Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F275355814
	for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 05:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774331055; cv=none; b=A8Aa73fnuO0dTeMIJSLVeWoE8TtAIlgr1at4UHXIejxnaqudg9gLlJiCneFE6WWiDY3RBr6iRvzVr0zaUq4vT9C1c4r1QUVsAxGTMW6j0ioQ8GQ+7pvOj5pJzbJ805NJv12nSl9odkj7WQdymkOzAX87yQTSfrqx2Ee4R0DSp5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774331055; c=relaxed/simple;
	bh=xVAHk58Pig3+1nkn216lim4xwVTKqfiEbFPoqdslBt8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=k9aqomUKubbaAnz2qPzDm33jlbkcZ6tg12wA/l0t6zPvBfr46hJbLQ9SlHsziBXSffNZFtDLItuBD/72gmd8ntnn2lc5LcdCRIbGATsE8zeSW5HGQS6BF5nKW9camn2OGLmSOJOW4yJIxF/B3jL9bZr2CBxpTZ6gTfCVHVWdsc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WLgL3WdL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WLgL3WdL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774331052;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k8OY63hOM8lzB4lyTdK6WM20jDg6ErWPyWDRjPqHGv8=;
	b=WLgL3WdLFIdt8codR5GYiIBUeKNXJ7Iw+QQHlL0Bv5yXBc34pNTP3a9BeaNRYkNRneLDOV
	M4mrFrv18CcBKXbb7BMNva/JLK8SLTWYsBsZfJ+za3My8bVK8tjjXXV871Xt9WmRQ7RbbP
	Q26KvO12YS/LrgJMs7XMRp3X2iUcr4Y=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-574-NIb-xQsrOJyiWad6BAXX-A-1; Tue,
 24 Mar 2026 01:44:08 -0400
X-MC-Unique: NIb-xQsrOJyiWad6BAXX-A-1
X-Mimecast-MFC-AGG-ID: NIb-xQsrOJyiWad6BAXX-A_1774331047
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6ED4318005B4;
	Tue, 24 Mar 2026 05:44:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 30FB61955D71;
	Tue, 24 Mar 2026 05:44:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 62O5i5ab1047404
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 24 Mar 2026 01:44:05 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 62O5i5fl1047403;
	Tue, 24 Mar 2026 01:44:05 -0400
Date: Tue, 24 Mar 2026 01:44:05 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 2/4] libmpathutil: add generic implementation for checker
 thread runners
Message-ID: <acIkpYcxYE3-VaCf@redhat.com>
References: <20260319221344.753790-1-mwilck@suse.com>
 <20260319221344.753790-3-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260319221344.753790-3-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3bRV1anGvaWUx199J-mlW2zxaVXDfSBEOAXDjNF0N5A_1774331047
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 19, 2026 at 11:13:42PM +0100, Martin Wilck wrote:
> This code adds a generic, abstract implementation of the kind of threads we
> need for checkers: detached threads that may time out. The design is such
> that these threads never access any memory of the calling program, strongly
> simplifying the management of lifetimes of objects.
> 
> See the documentation of the API in "runner.h".
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmpathutil/Makefile             |   2 +-
>  libmpathutil/libmpathutil.version |   6 +-
>  libmpathutil/runner.c             | 205 ++++++++++++++++++++++++++++++
>  libmpathutil/runner.h             |  84 ++++++++++++
>  4 files changed, 295 insertions(+), 2 deletions(-)
>  create mode 100644 libmpathutil/runner.c
>  create mode 100644 libmpathutil/runner.h
> 
> diff --git a/libmpathutil/Makefile b/libmpathutil/Makefile
> index e1cc2c6..bdd7063 100644
> --- a/libmpathutil/Makefile
> +++ b/libmpathutil/Makefile
> @@ -13,7 +13,7 @@ LIBDEPS += -lpthread -ldl -ludev -L$(mpathcmddir) -lmpathcmd $(SYSTEMD_LIBDEPS)
>  
>  # other object files
>  OBJS := mt-libudev.o parser.o vector.o util.o debug.o time-util.o \
> -	uxsock.o log_pthread.o log.o strbuf.o globals.o msort.o
> +	uxsock.o log_pthread.o log.o strbuf.o globals.o msort.o runner.o
>  
>  all:	$(DEVLIB)
>  
> diff --git a/libmpathutil/libmpathutil.version b/libmpathutil/libmpathutil.version
> index 22ef994..5a7df82 100644
> --- a/libmpathutil/libmpathutil.version
> +++ b/libmpathutil/libmpathutil.version
> @@ -43,7 +43,7 @@ LIBMPATHCOMMON_1.0.0 {
>  	put_multipath_config;
>  };
>  
> -LIBMPATHUTIL_5.0 {
> +LIBMPATHUTIL_6.0 {
>  global:
>  	alloc_bitfield;
>  	alloc_strvec;
> @@ -62,6 +62,8 @@ global:
>  	cleanup_vector;
>  	cleanup_vector_free;
>  	convert_dev;
> +	cancel_runner;
> +	check_runner;
>  	dlog;
>  	filepresent;
>  	fill_strbuf;
> @@ -72,6 +74,7 @@ global:
>  	free_strvec;
>  	get_linux_version_code;
>  	get_monotonic_time;
> +	get_runner;
>  	get_strbuf_buf__;
>  	get_next_string;
>  	get_strbuf_len;
> @@ -162,6 +165,7 @@ global:
>  	pthread_cond_init_mono;
>  	recv_packet;
>  	reset_strbuf;
> +	runner_state_name;
>  	safe_write;
>  	send_packet;
>  	set_max_fds;
> diff --git a/libmpathutil/runner.c b/libmpathutil/runner.c
> new file mode 100644
> index 0000000..8a49d92
> --- /dev/null
> +++ b/libmpathutil/runner.c
> @@ -0,0 +1,205 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +// Copyright (c) 2026 SUSE LLC
> +#include <assert.h>
> +#include <time.h>
> +#include <pthread.h>
> +#include <urcu/uatomic.h>
> +#include "util.h"
> +#include "debug.h"
> +#include "time-util.h"
> +#include "runner.h"
> +
> +#define STACK_SIZE (4 * 1024)
> +#define MILLION 1000000
> +
> +const char *runner_state_name(int state)
> +{
> +	// clang-format off
> +	static const char * const state_name_[] = {
> +		[RUNNER_IDLE] = "idle",
> +		[RUNNER_RUNNING] = "running",
> +		[RUNNER_DONE] = "done",
> +		[RUNNER_CANCELLED] = "cancelled"
> +	};
> +	// clang-format on
> +
> +	if (state < RUNNER_IDLE || state > RUNNER_CANCELLED)
> +		return "unknown";
> +	return state_name_[state];
> +}
> +
> +struct runner_context {
> +	int refcount;
> +	int status;
> +	struct timespec deadline;
> +	pthread_t thr;
> +	void (*func)(void *data);
> +	/* User data will be copied into this area */

The data array is currently pointer aligned. We might want to put a
comment mentioning that it must stay that way, or force an alignment on
it.

> +	char data[];
> +};
> +
> +static void release_context(struct runner_context *ctx)
> +{
> +	int n;
> +
> +	n = uatomic_sub_return(&ctx->refcount, 1);
> +	assert(n >= 0);
> +
> +	if (n == 0)
> +		free(ctx);
> +}
> +
> +static void cleanup_context(struct runner_context **ctx)
> +{
> +	if (*ctx)
> +		release_context(*ctx);
> +}
> +
> +static void *runner_thread(void *arg)
> +{
> +	int st, refcount;
> +	/*
> +	 * The cleanup function makes sure memory is freed if the thread is
> +	 * cancelled (-fexceptions).
> +	 */
> +	struct runner_context *ctx __attribute__((cleanup(cleanup_context))) = arg;
> +
> +	refcount = uatomic_add_return(&ctx->refcount, 1);
> +	assert(refcount == 2);
> +
> +	st = uatomic_cmpxchg(&ctx->status, RUNNER_IDLE, RUNNER_RUNNING);
> +	/*
> +	 * The thread has already been cancelled before it was even started.
> +	 * In this case, cancel_runner() doesn't release the context.
> +	 * Do it here. See comments for RUNNER_IDLE in cancel_runner().
> +	 */
> +	if (st != RUNNER_IDLE) {
> +		release_context(ctx);
> +		return NULL;
> +	}
> +
> +	(*ctx->func)(ctx->data);
> +	uatomic_cmpxchg(&ctx->status, RUNNER_RUNNING, RUNNER_DONE);
> +	return NULL;
> +}
> +
> +void cancel_runner(struct runner_context *ctx)
> +{
> +	int st = uatomic_cmpxchg(&ctx->status, RUNNER_RUNNING, RUNNER_CANCELLED);
> +	int level = 4, retry = 1;
> +
> +repeat:
> +	switch (st) {
> +	case RUNNER_IDLE:
> +		/*
> +		 * Race with thread startup.
> +		 *
> +		 * If after the following cmpxchg st is still IDLE, the cmpxchg
> +		 * in runner_thread() will return CANCELLED, and the context
> +		 * will be relased there. Otherwise, the thread has switched
> +		 * to RUNNING in the meantime, and we will be able to cancel
> +		 * it regularly if we retry.
> +		 */
> +		if (retry--) {
> +			st = uatomic_cmpxchg(&ctx->status, RUNNER_IDLE,
> +					     RUNNER_CANCELLED);
> +			goto repeat;
> +		}
> +		level = 3;
> +		break;
> +	case RUNNER_RUNNING:
> +		pthread_cancel(ctx->thr);
> +		/* Caller has no interest in the data any more */
> +		release_context(ctx);
> +		return;
> +	case RUNNER_DONE:
> +		/* Caller has no interest in the data any more */
> +		release_context(ctx);
> +		/* fallthrough */
> +	default:
> +		level = 3;
> +		break;
> +	}
> +	condlog(level, "%s: runner cancelled in state '%s', ctx=%p", __func__,
> +		runner_state_name(st), ctx);
> +}
> +
> +struct runner_context *get_runner(runner_func func, void *data,
> +				  unsigned int size, unsigned long timeout_usec)
> +{
> +	static const struct timespec time_zero = {.tv_sec = 0};
> +	struct runner_context *ctx;
> +	pthread_attr_t attr;
> +	int rc;
> +
> +	assert(func);
> +	assert(data);
> +	assert(size > 0);

Why asserts? We already need to deal with this function failing. I'd
prefer error messages and failure, instead of crashing later when a null
value gets dereferenced, for instance. I admit, it's unlikley that these
arguments will be set wrong, but if there is a bug that makes it into
production code, these asserts will be disabled, and a log message
telling me what went wrong would be helpful.

> +
> +	ctx = malloc(sizeof(*ctx) + size);
> +	if (!ctx)
> +		return NULL;
> +
> +	ctx->func = func;
> +	uatomic_set(&ctx->refcount, 1);
> +	uatomic_set(&ctx->status, RUNNER_IDLE);
> +	memcpy(ctx->data, data, size);
> +
> +	if (timeout_usec) {
> +		get_monotonic_time(&ctx->deadline);
> +		ctx->deadline.tv_sec += timeout_usec / MILLION;
> +		ctx->deadline.tv_nsec += (timeout_usec % MILLION) * 1000;
> +	} else
> +		ctx->deadline = time_zero;
> +

Don't think we need the smm_smp_wmb(). From
https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html#tag_04_15_02
"The following functions synchronize memory with respect to other threads:" 
lists pthread_create().

-Ben

> +	/*
> +	 * This pairs with the implicit barrier in uatomic_add_return()
> +	 * in runner_thread()
> +	 */
> +	cmm_smp_wmb();
> +
> +	setup_thread_attr(&attr, STACK_SIZE, 1);
> +	rc = pthread_create(&ctx->thr, &attr, runner_thread, ctx);
> +	pthread_attr_destroy(&attr);
> +
> +	if (rc) {
> +		condlog(1, "%s: pthread_create(): %s", __func__, strerror(rc));
> +		release_context(ctx);
> +		return NULL;
> +	}
> +	return ctx;
> +}
> +
> +int check_runner(struct runner_context *ctx, void *data, unsigned int size)
> +{
> +	int st = uatomic_read(&ctx->status);
> +
> +	switch (st) {
> +	case RUNNER_DONE:
> +		if (data)
> +			/* hand back the data to the caller */
> +			memcpy(data, ctx->data, size);
> +		/* caller is done with this context */
> +		release_context(ctx);
> +		/* fallthrough */
> +	case RUNNER_CANCELLED:
> +		return st;
> +	case RUNNER_IDLE:
> +	case RUNNER_RUNNING:
> +		if (ctx->deadline.tv_sec != 0 || ctx->deadline.tv_nsec != 0) {
> +			struct timespec now;
> +
> +			get_monotonic_time(&now);
> +			if (timespeccmp(&ctx->deadline, &now) <= 0) {
> +				cancel_runner(ctx);
> +				return RUNNER_CANCELLED;
> +			}
> +		}
> +		return RUNNER_RUNNING;
> +	default:
> +		condlog(1, "%s: runner in impossible state '%s'", __func__,
> +			runner_state_name(st));
> +		assert(false);
> +		return st;
> +	}
> +}
> diff --git a/libmpathutil/runner.h b/libmpathutil/runner.h
> new file mode 100644
> index 0000000..0c9cf80
> --- /dev/null
> +++ b/libmpathutil/runner.h
> @@ -0,0 +1,84 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +// Copyright (c) 2026 SUSE LLC
> +#ifndef RUNNER_H_INCLUDED
> +#define RUNNER_H_INCLUDED
> +
> +enum runner_status {
> +	RUNNER_IDLE,
> +	RUNNER_RUNNING,
> +	RUNNER_DONE,
> +	RUNNER_CANCELLED,
> +};
> +
> +typedef void (*runner_func)(void *data);
> +struct runner_context;
> +
> +/**
> + * runner_state_name(): helper for printing runner states
> + *
> + * @param state: a valid @runner_status value
> + * @returns: a string describing the status
> + */
> +const char *runner_state_name(int state);
> +
> +/**
> + * get_runner(): start a runner thread
> + *
> + * This function starts a runner thread that calls @func(@data).
> + * The thread is created as detached thread.
> + * @data will be copied to thread-private memory, which will be freed when
> + * the runner terminates.
> + * Output values can be retrieved with @check_runner().
> + *
> + * @param func: the worker function to invoke
> + *        This parameter must not be NULL.
> + * @param data: pointer the data to pass to the function (input and output)
> + *        This parameter must not be NULL.
> + * @param size: the size (in bytes) of the data passed to the function
> + *        This parameter must be positive.
> + * @param timeout_sec: timeout (in seconds) after which to cancel the runner.
> + *        If it is 0, the runner will not time out.
> + * @returns: a runner context that must be passed to the functions below.
> + */
> +struct runner_context *get_runner(runner_func func, void *data,
> +				  unsigned int size, unsigned long timeout_usec);
> +
> +/**
> + * cancel_runner(): cancel a runner thread.
> + *
> + * This function should be called to terminate runners on program exit,
> + * or to terminate runners that have no timeout set in @get_runner,
> + * and haven't completed.
> + * Upon return of this function, @ctx becomes stale and shouldn't accessed
> + * any more.
> + *
> + * @param ctx: the context of the runner to be cancelled.
> + */
> +void cancel_runner(struct runner_context *ctx);
> +
> +/**
> + * check_runner(): query the state of a runner thread and obtain results
> + *
> + * Check the state of a runner previously started with @get_runner. If the
> + * thread function has completed, @RUNNER_DONE will be returned, and the
> + * user data will be copied into the @data argument. If @check_runner returns
> + * anything else, @data contains no valid data. The @size argument
> + * will typically be the same as the @size passed to @get_runner (meaning
> + * that @data represents an object of the same type as the @data argument
> + * passed to @get_runner previously).
> + * If @check_runner returns @RUNNER_CANCELLED or @RUNNER_DONE, the @ctx object
> + * has become stale and must not be used any more.
> + * @RUNNER_CANCELLED is returned if the timeout set in @get_runner has passed
> + * and the worker function hasn't returned yet.
> + *
> + * @param ctx: the context of the runner to be queried
> + * @param data: memory pointer that will receive results of the worker
> + * function. Can be NULL, in which case no data will be copied.
> + * @param size: size of the memory pointed to by data. It must be no bigger
> + *        than the size of the memory passed to @get_runner for this runner.
> + *        It can be smaller, but no more than @size bytes will be copied.
> + * @returns: @RUNNER_RUNNING, @RUNNER_DONE, or @RUNNER_CANCELLED.
> + */
> +int check_runner(struct runner_context *ctx, void *data, unsigned int size);
> +
> +#endif /* RUNNER_H_INCLUDED */
> -- 
> 2.53.0

