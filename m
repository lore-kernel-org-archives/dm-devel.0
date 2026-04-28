Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739BD1A683B
	for <dm-devel@lists.linux.dev>; Tue, 28 Apr 2026 00:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777335647; cv=none; b=aUrXDEo1qjY8YbwBsDVWRHsCJHeHKylv5Xe4EKmAMQJpdon0qV1d9OwxeKmhWGjn7A7U+4flc00MChqKZ3yu8Bl7EkWWkeGbRilxOWaJUnZIBPyg7IH3+62e+dicphYGipXZJAxkMskCvwURytgPAW+DGDPASv3wP2KvI2lCV1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777335647; c=relaxed/simple;
	bh=rzo5EGw3Ih6GayUoZiufcocBeQrNX6Xou4oenwtsPuM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=dmL9Nt+CRx0LAl4+JRMXHrYWmHT+Z+8RfBgM52ccWxWZEQSpQHjVYs91pOm+FqXNuiXBPC5Y1t2j4Wt8zHlX3krFOo2PlE8lMra2tfT7rYxkKE2VVE6ytrGPOGwK8ELPDJqPwK9d6UVS7j8aVDG2/Z+zupVjFuEMlFMx77IfRfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PNI6B5sF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PNI6B5sF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777335644;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mb4/waZx9rLBjYrfbrTKf2JYMb3xhAxWSNVMUeQF/Uo=;
	b=PNI6B5sFQbvuyuG6mrJS1UqaN1YjrydlmbWEyTEHlnbA26ij+FoGQjQ2KqD5NDUiHgW+oo
	vl/M51dbWy9492HRN5VT+nHt0tFt0pMkBSjRv+QGXOEZMaDRgEnLch8ghrbveLXqFtMN2t
	0PFOfdTDpxtdfhZexQx6gS0hglckL+I=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-171-k3rixBdsPtuvei9mQ-hNRg-1; Mon,
 27 Apr 2026 20:20:38 -0400
X-MC-Unique: k3rixBdsPtuvei9mQ-hNRg-1
X-Mimecast-MFC-AGG-ID: k3rixBdsPtuvei9mQ-hNRg_1777335637
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 928911800473;
	Tue, 28 Apr 2026 00:20:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 337811800349;
	Tue, 28 Apr 2026 00:20:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 63S0Kavo2748281
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 27 Apr 2026 20:20:36 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 63S0KZHx2748280;
	Mon, 27 Apr 2026 20:20:35 -0400
Date: Mon, 27 Apr 2026 20:20:35 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 2/5] libmpathutil: add generic implementation for
 checker thread runners
Message-ID: <ae_9U_JAoiihraT4@redhat.com>
References: <20260423204446.472642-1-mwilck@suse.com>
 <20260423204446.472642-3-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260423204446.472642-3-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: d6ypSuTgwWxnSoW-mjnKUvVpeFtjpVHxxG-4H8la5BM_1777335637
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 23, 2026 at 10:44:43PM +0200, Martin Wilck wrote:
> This code adds a generic, abstract implementation of the kind of threads we
> need for checkers: detached threads that may time out. The design is such
> that these threads never access any memory of the calling program,
> simplifying the management of lifetimes of objects.
> 
> See the documentation of the API in "runner.h".
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmpathutil/Makefile             |   2 +-
>  libmpathutil/libmpathutil.version |   7 +-
>  libmpathutil/runner.c             | 221 ++++++++++++++++++++++++++++++
>  libmpathutil/runner.h             | 102 ++++++++++++++
>  4 files changed, 330 insertions(+), 2 deletions(-)
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
> index 22ef994..c69120d 100644
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
> @@ -62,6 +62,7 @@ global:
>  	cleanup_vector;
>  	cleanup_vector_free;
>  	convert_dev;
> +	check_runner;
>  	dlog;
>  	filepresent;
>  	fill_strbuf;
> @@ -72,6 +73,8 @@ global:
>  	free_strvec;
>  	get_linux_version_code;
>  	get_monotonic_time;
> +	get_persistent_runner;
> +	get_runner;
>  	get_strbuf_buf__;
>  	get_next_string;
>  	get_strbuf_len;
> @@ -161,7 +164,9 @@ global:
>  	process_file;
>  	pthread_cond_init_mono;
>  	recv_packet;
> +	release_runner;
>  	reset_strbuf;
> +	runner_state_name;
>  	safe_write;
>  	send_packet;
>  	set_max_fds;
> diff --git a/libmpathutil/runner.c b/libmpathutil/runner.c
> new file mode 100644
> index 0000000..f5c5482
> --- /dev/null
> +++ b/libmpathutil/runner.c
> @@ -0,0 +1,221 @@
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
> +		[RUNNER_CANCELLED] = "cancelled",
> +		[RUNNER_DEAD] = "dead"
> +	};
> +	// clang-format on
> +
> +	if (state < RUNNER_IDLE || state > RUNNER_DEAD)
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
> +	char __attribute__((aligned(sizeof(void *)))) data[];
> +};
> +
> +static void release_context(struct runner_context *rctx)
> +{
> +	int n;
> +
> +	n = uatomic_sub_return(&rctx->refcount, 1);
> +	assert(n >= 0);
> +
> +	if (n == 0)
> +		free(rctx);
> +}
> +
> +static void cleanup_context(struct runner_context **prctx)
> +{
> +	struct runner_context *rctx = *prctx;
> +	int st;
> +
> +	if (!rctx)
> +		return;
> +
> +	st = uatomic_cmpxchg(&rctx->status, RUNNER_RUNNING, RUNNER_DONE);
> +	if (st != RUNNER_RUNNING) {
> +		uatomic_cmpxchg(&rctx->status, st, RUNNER_DEAD);
> +		if (st != RUNNER_CANCELLED)
> +			condlog(2, "%s: runner %p finished in state %s",
> +				__func__, rctx, runner_state_name(st));
> +	}
> +	release_context(rctx);
> +}
> +
> +static void *runner_thread(void *arg)
> +{
> +	int st, refcount;
> +	/*
> +	 * The cleanup function makes sure memory is freed if the thread is
> +	 * cancelled (-fexceptions).
> +	 */
> +	struct runner_context *rctx __attribute__((cleanup(cleanup_context))) = arg;
> +
> +	refcount = uatomic_add_return(&rctx->refcount, 1);
> +	assert(refcount == 2);
> +
> +	st = uatomic_cmpxchg(&rctx->status, RUNNER_IDLE, RUNNER_RUNNING);
> +	/*
> +	 * The thread has already been cancelled before it was even started.
> +	 * In this case, cancel_runner() doesn't release the context.
> +	 * Do it here. See comments for RUNNER_IDLE in cancel_runner().
> +	 */

I'm confused about this, and AFAICS, it doesn't appear to be true. If
you call check_runner() and it returns RUNNER_CANCELLED, you have no
idea if the runner was previously in RUNNER_IDLE, which means that you
cannot touch the context anymore, or if the runner was in
RUNNER_RUNNING, in which case it's your job to release the context.
In the TUR checker, check_runner_state() just calls release_runner(),
which will cause a UAF error if the runner was in RUNNER_IDLE before
it got cancelled.

It seems to me that the correct way to do this would be to set
rctx->refcount to 2 before creating the runner thread, and not even have
a RUNNER_IDLE state. Perhaps I'm just being stupid, but I don't see the
necessity. If you set a thread to deferred cancellation, I don't believe
it can get cancelled between when you create it, and when it hits it's
first cancellation point, so you shouldn't have to worry about getting
cancelled before the runner's cleanup_context handler isset up. I'm
pretty sure that if the thread gets created successfully, it should
always drop its reference count when it exits, regardless of if/when it
gets cancelled. And if you fail to create the thread, you can just drop
the refcount back to 1 before calling release_context() in get_runner().

-Ben

> +	if (st != RUNNER_IDLE) {
> +		release_context(rctx);
> +		return NULL;
> +	}
> +
> +	(*rctx->func)(rctx->data);
> +	return NULL;
> +}
> +
> +static int cancel_runner(struct runner_context *rctx)
> +{
> +	int st, st_new;
> +	int level = 4, retry = 1;
> +
> +repeat:
> +	st = uatomic_cmpxchg(&rctx->status, RUNNER_RUNNING, RUNNER_CANCELLED);
> +	st_new = st;
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
> +			st = uatomic_cmpxchg(&rctx->status, RUNNER_IDLE,
> +					     RUNNER_CANCELLED);
> +			if (st == RUNNER_IDLE)
> +				st_new = RUNNER_CANCELLED;
> +			else
> +				goto repeat;
> +		}
> +		break;
> +	case RUNNER_RUNNING:
> +		pthread_cancel(rctx->thr);
> +		st_new = RUNNER_CANCELLED;
> +		/* fallthrough */
> +	case RUNNER_CANCELLED:
> +		break;
> +	case RUNNER_DONE:
> +		st_new = RUNNER_DEAD;
> +		/* fallthrough */
> +	case RUNNER_DEAD:
> +		level = 3;
> +		break;
> +	}
> +	condlog(level, "%s: runner %p cancelled in state '%s'", __func__, rctx,
> +		runner_state_name(st));
> +	return st_new;
> +}
> +
> +void release_runner(struct runner_context *rctx)
> +{
> +	cancel_runner(rctx);
> +	release_context(rctx);
> +}
> +
> +int check_runner(struct runner_context *rctx, void *data, unsigned int size)
> +{
> +	int st = uatomic_read(&rctx->status);
> +
> +	switch (st) {
> +	case RUNNER_DONE:
> +		if (data)
> +			/* hand back the data to the caller */
> +			memcpy(data, rctx->data, size);
> +		/* fallthrough */
> +	case RUNNER_DEAD:
> +	case RUNNER_CANCELLED:
> +		return st;
> +	case RUNNER_IDLE:
> +	case RUNNER_RUNNING:
> +		if (rctx->deadline.tv_sec != 0 || rctx->deadline.tv_nsec != 0) {
> +			struct timespec now;
> +
> +			get_monotonic_time(&now);
> +			if (timespeccmp(&rctx->deadline, &now) <= 0)
> +				return cancel_runner(rctx);
> +		}
> +		/* don't bother the caller with RUNNER_IDLE */
> +		return RUNNER_RUNNING;
> +	default:
> +		condlog(1, "%s: runner in impossible state '%s'", __func__,
> +			runner_state_name(st));
> +		assert(false);
> +		return st;
> +	}
> +}
> +
> +struct runner_context *get_runner(runner_func func, void *data,
> +				  unsigned int size, unsigned long timeout_usec)
> +{
> +	static const struct timespec time_zero = {.tv_sec = 0};
> +	struct runner_context *rctx;
> +	pthread_attr_t attr;
> +	int rc;
> +
> +	if (!func || !data || size <= 0) {
> +		condlog(0, "%s: illegal arguments", __func__);
> +		return NULL;
> +	}
> +
> +	rctx = malloc(sizeof(*rctx) + size);
> +	if (!rctx)
> +		return NULL;
> +
> +	rctx->func = func;
> +	uatomic_set(&rctx->refcount, 1);
> +	uatomic_set(&rctx->status, RUNNER_IDLE);
> +	memcpy(rctx->data, data, size);
> +
> +	if (timeout_usec) {
> +		get_monotonic_time(&rctx->deadline);
> +		rctx->deadline.tv_sec += timeout_usec / MILLION;
> +		rctx->deadline.tv_nsec += (timeout_usec % MILLION) * 1000;
> +	} else
> +		rctx->deadline = time_zero;
> +
> +	setup_thread_attr(&attr, STACK_SIZE, 1);
> +	rc = pthread_create(&rctx->thr, &attr, runner_thread, rctx);
> +	pthread_attr_destroy(&attr);
> +
> +	if (rc) {
> +		condlog(1, "%s: pthread_create(): %s", __func__, strerror(rc));
> +		release_context(rctx);
> +		return NULL;
> +	}
> +	return rctx;
> +}
> diff --git a/libmpathutil/runner.h b/libmpathutil/runner.h
> new file mode 100644
> index 0000000..cb2ad94
> --- /dev/null
> +++ b/libmpathutil/runner.h
> @@ -0,0 +1,102 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +// Copyright (c) 2026 SUSE LLC
> +#ifndef RUNNER_H_INCLUDED
> +#define RUNNER_H_INCLUDED
> +
> +enum runner_status {
> +	/**
> +	 * Initial state. Runner thread has not started yet.
> +	 */
> +	RUNNER_IDLE,
> +	/**
> +	 * The runner thread is running in @runner_func (see below).
> +	 */
> +	RUNNER_RUNNING,
> +	/**
> +	 * @runner_func has terminated. This is the only only state
> +	 * in which @check_runner can obtain user data in the @data
> +	 * parameter.
> +	 */
> +	RUNNER_DONE,
> +	/**
> +	 * The runner thread has been cancelled (usually because of a timeout),
> +	 * but @runner_func is still running.
> +	 */
> +	RUNNER_CANCELLED,
> +	/**
> +	 * The runner thread has terminated without providing user data
> +	 * (usually after a timeout).
> +	 */
> +	RUNNER_DEAD,
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
> + * @param timeout_usec: timeout (in microseconds) after which to cancel the
> + * runner. If it is 0, the runner will not time out.
> + * @returns: a runner context that must be passed to the functions below.
> + */
> +struct runner_context *get_runner(runner_func func, void *data,
> +				  unsigned int size, unsigned long timeout_usec);
> +
> +/**
> + * release_runner(): release a runner context
> + *
> + * This function should be called when the caller has no interest to
> + * operate on the given @runner_context any more.
> + * If necessary, the runner thread will be cancelled.
> + * Upon return of this function, @rctx becomes stale and shouldn't accessed
> + * any more.
> + *
> + * @param rctx: the context of the runner to be released.
> + */
> +void release_runner(struct runner_context *rctx);
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
> + *
> + * Side effect: If the runner has timed out, the thread will be cancelled.
> + *
> + * @param rctx: the context of the runner to be queried
> + * @param data: memory pointer that will receive results of the worker
> + * function. Can be NULL, in which case no data will be copied.
> + * @param size: size of the memory pointed to by data. It must be no bigger
> + *        than the size of the memory passed to @get_runner for this runner.
> + *        It can be smaller, but no more than @size bytes will be copied.
> + * @returns: @RUNNER_RUNNING, @RUNNER_DONE, @RUNNER_CANCELLED, or @RUNNER_DEAD.
> + */
> +int check_runner(struct runner_context *rctx, void *data, unsigned int size);
> +
> +#endif /* RUNNER_H_INCLUDED */
> -- 
> 2.53.0

