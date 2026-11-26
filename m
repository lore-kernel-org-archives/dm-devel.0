Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795693326;
	b=R3d44G9sAzOc0cyOUf3Ax72uH/wwLBOU+dZQiH/cbkyWOBkrptPDseiu7NuyVOtOQ2dt
	 jjG8+hYH8k2BuXeB9zcXD2IhFZt0XVizUO1GLPF3jQyfIOjp9BWboKGao2SFZQSWJwmxc
	 soZScMl2eI0MASnBQlPi2wfNMhGnAgyfOVtZb2Yn+/CfqAnNQPiVX4nAwqYQRkb9ni/RG
	 Vp7TMVT/mGbEl6/c1g21pjeZmn5VSzG6y6EzeYK4wZzG7e7+7r6TKvLD4WxKbuE8N6/YS
	 W7Iq1G7ldreIPuy5dABcJccVYEbsS1yKa+voZRkCcAEoBPQoaZ7z3rMcrfl7Q1Xr3jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795693326;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Subject:To:Cc:In-Reply-To:References:Date:
	 Message-Id:X-Mailer;
	bh=4IjrLifJLSI8ZnL16pkx3xqE5lRyeUrT09iWSbheLhE=;
	b=4+FndHqnvLJgGkNl6nY9RHUS8IjZNGN3esLBUOj/eITY1EUQ9G/qrR9w5cc0viPr2Dfj
	 XDAX7mopNCATTiChgAn2DZQgYdQ/SUv0SkN+k6qMn5nIuJ99b3h0NJoVJ7HiH6I1ift2d
	 AA8GaWd/NxKLBcL0qcTLhPl7RwS3uXrXpyy3HUm7R35S2C7K0bXrDixVhb9wbfWqWg0nW
	 iPjQMx/k/wwerwRs3YFx/nP+K+XP746o7nV+pOSf5reLnbFyxt6vEyozR+wV+mZP0j8Cm
	 SgCVLIWsCI6jfmVHaCoStFLSD7gtwunuWYGN+xI77gDn3lsswWGGefbgm/mWYiXdOpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=M0192QKz;
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60C2606A321
	for <dm-devel@lists.linux.dev>; Thu, 26 Nov 2026 11:42:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E60C2606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=M0192QKz
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-498f5fa5103so4100236f8f.2
        for <dm-devel@lists.linux.dev>; Thu, 26 Nov 2026 03:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795693324; x=1796298124; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:cc:to:subject
         :content-transfer-encoding:content-type:mime-version:from:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=4IjrLifJLSI8ZnL16pkx3xqE5lRyeUrT09iWSbheLhE=;
        b=M0192QKzO5+rtrkXBSPH4HOI9exfkZiQus2cj0Y6KNJJi7ED3iQ3Oifd3G8HDfws6t
         MYkN9v/mqZWYyqxL9SpKPsnMY8tVwkk1TAPxDBTT4VIxL4OUW+oyexyhuVH8ERfKDqvd
         unYtpKglhlIUNtCBzDIa41S9lxIlt2aGFmMP/Kq3nCjnvr+7u/Jk0GHEC5MJ/roCfwdr
         gZZcZk07pMLVyYBHPqgWQRpNZkqYP7ebRPXYnEqFVl6W4UxCZ4icidbsDvpUlhHwuVYS
         PZt3pr7niGJy68xiEldR99lm/TNGQcNE4FKM9ErFrHWL/bntMlJpIu/g3uVZ6Z7lGBKT
         +BqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795693324; x=1796298124;
        h=message-id:date:references:in-reply-to:cc:to:subject
         :content-transfer-encoding:content-type:mime-version:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4IjrLifJLSI8ZnL16pkx3xqE5lRyeUrT09iWSbheLhE=;
        b=bTd76Kp+dch5IbbDOiPjxi2hEhnUgO7uU/iIEVsjLY0Pe7mJ+Hn9goMntrHT9ffnQs
         CnT7VZ5aJCLxlQ/X5tfCA2+posgUcTY4Am3aj9acTXjh3Wuw8v4xk4DCgKFbHZgFgHCp
         SOgMIgpS/jtsyPSReltxa9WZ/8X6osXisDNmnMU9cmCXDDqS00R/QGWiLFk7yJC9AgGN
         RBWFkwBZrJGpqeXy5K1QXHiYhnh22GM2T3eCq8NOpVWGM1p2+9aZCp/DWEmn6xns0vyo
         fMCg8hq1mEe1XuQbC+vWoQzccybRt/ol92J/ilFSO9zAUioTibzH8/OOwgjBGlUeQIUZ
         V9qQ==
X-Forwarded-Encrypted: i=1; AL+hErGkenAWHKwRKTYrXtcMxopRX+SOXfI1LZMoHj+7YnT8JUiw6aRXqIL/SFC5Vp39YG6cUCeUE7B0Pw==@lists.linux.dev
X-Gm-Message-State: APuU4Z9YS75uEkeamHm62pMYRNZYBQQdOPTnbMv86kxEBMgvwtzTUknN
	STv06y0O0LYyXpbBFPyYOgo/pwr8sC3gKQp2EE4nRVuzn2KatjaWflke3aqDaX5PkiHh+qmpsI0
	HHsFPWr0=
X-Gm-Gg: AZFdTZdJ8t9RviqE6TD+qqXykyYerwjX6D2+Xi03xH7u6V0krxM/0X//HKwsbE8chA9
	2+zhw/s5ofm7XX4bgZRlJaKA5lIzhVeCkXu0ygnmOOkdVoTtSW7zNPpSsYw6iLAWluvdGjuqU7A
	QXiZZmGl2RIu9f//HWcYKQ7rANdkNlUzI1UIyz/KO0pss2p1svFvNFUfye+6TLWumfH5j3uxe8j
	TDU0pq4Oa26BKQjcQvkox5z8jmUhDNAnI7jLsPq7uGMC7gc1gtOzI8IGA1nJchgSsorTP9dBibY
	DwycBGKEtIbad6UB85OAeQO97RhHxkYASkjKZVRmYjB5FE4VVKMnH0PLn2IWC58OTXEG2fd0yp0
	pc2XKZ74A+mMYEPX+94fwFN5aBXXpC8ESYuSmq5b2Ltdhdk62yFeH/e3gSmm/tVtCYyhFix5aV8
	hXeV1Nr+Ps4Oxe287WFDm0tnGL/ivW4cvRAXZil4Gz5Emv518FvPlEQ3nJIVocJIZ3Rpx9qx6Io
	p1ukvjkA7tv7h0v5ED0wUD2xml6IInxEWsgavnWyCXpzUp49t2VS7WsB2GgUJq/DUKSOweC4APQ
	+6EXPZSXyObORtvfYuL6QX5WSvv47DR8owXWqPd15Ez8WAKnsTEXyPSFhxYhLKF2rps0bUXYCS0
	Fl3VL/rLJw6KadDPfog==
X-Received: by 2002:adf:e197:0:b0:48e:7a41:d78e with SMTP id ffacd0b85a97d-4abb36787bamr35191203f8f.19.1795693324111;
        Thu, 26 Nov 2026 03:42:04 -0800 (PST)
Received: from localhost (p200300de37172700e7f885d729fa4be7.dip0.t-ipconnect.de. [2003:de:3717:2700:e7f8:85d7:29fa:4be7])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4ab658e2e6dsm39164007f8f.6.2026.11.26.03.42.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 03:42:03 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/4] multipathd: add infrastructure for uxlsnr waiting
 on events
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
 device-mapper development <dm-devel@lists.linux.dev>, 
 Martin Wilck <Martin.Wilck@suse.com>
In-Reply-To: <20261126052434.725762-3-bmarzins@redhat.com>
References: <20261126052434.725762-1-bmarzins@redhat.com>
 <20261126052434.725762-3-bmarzins@redhat.com>
Date: Thu, 26 Nov 2026 12:42:00 +0100
Message-Id: <179569332052.310906.11503714620320054070.b4-review@b4>
X-Mailer: b4 0.16.0

> There are multiple things that can happen to multipathd and the
> devices it tracks, that multipathd only finishes handling later. User
> programs may need to wait for these changes to complete before
> continuing.
> 
> This commit add the architecture for waiting for events to occur. A
> future patch will add the ability to actually register these wait
> events. uxlnsr clients waiting for events will put themselves on a wait
> list with wait_for_event(). If they exit early, they will take
> themselves off with stop_waiting_for_event(). When the event occurs, the
> thread processing the event will call wakeup_event_waiter() to remove
> all clients from that wait list, and send a wakeup to the uslsnr thread.
> This works via an eventfd, using the same code as idle_fd currently
> does. Waiting clients check if their event has occured by checking if
> they are still on a wait list.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 9bce4d6..1bb8eac 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2009,6 +2009,12 @@ uxlsnrloop (void * ap)
>  		goto out_sock;
>  	}
>  
> +	if (init_wait_fd() < 0) {
> +		condlog(1, "Failed to open wait_fd: %m");
> +		exit_daemon();
> +		goto out_sock;
> +	}
> +
>  	/* Tell main thread that thread has started */
>  	post_config_state(DAEMON_CONFIGURE);
>  
> @@ -3917,6 +3923,7 @@ static void cleanup_child(void)
>  	cleanup_threads();
>  	cleanup_vecs();
>  	cleanup_bindings();
> +	cleanup_wait_fd();
>  	if (poll_dmevents)
>  		cleanup_dmevent_waiter();
>  
> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index e92784e..0930691 100644
> --- a/multipathd/uxlsnr.c
> +++ b/multipathd/uxlsnr.c
> @@ -49,11 +49,13 @@ enum {
>  	CLT_PARSE,
>  	CLT_LOCKED_WORK,
>  	CLT_WORK,
> +	CLT_WAIT,
>  	CLT_SEND,
>  };
>  
>  struct client {
>  	struct list_head node;
> +	struct list_head wait_node; /* for clients waiting on an event */
>  	struct timespec expires;
>  	int state;
>  	int fd;
> @@ -73,9 +75,13 @@ enum {
>  	POLLFD_UX2,
>  	POLLFD_NOTIFY,
>  	POLLFD_IDLE,
> +	POLLFD_WAIT,
>  	POLLFDS_BASE,
>  };
>  
> +/* Add a new revents value to signal that a waiter wakeup event occurred */
> +#define POLLWAIT 0x10000
> +
>  #define POLLFD_CHUNK (4096 / sizeof(struct pollfd))
>  /* Minimum number of pollfds to reserve for clients */
>  #define MIN_POLLS (POLLFD_CHUNK - POLLFDS_BASE)
> @@ -99,6 +105,8 @@ static LIST_HEAD(clients);
>  static struct pollfd *polls;
>  static int notify_fd = -1;
>  static int idle_fd = -1;
> +static int wait_fd = -1;
> +static pthread_mutex_t client_wait_lock = PTHREAD_MUTEX_INITIALIZER;
>  static bool clients_need_lock = false;
>  
>  static bool _socket_client_is_root(int fd)
> @@ -116,6 +124,8 @@ static bool _socket_client_is_root(int fd)
>  	return false;
>  }
>  
> +static void stop_waiting_for_event(struct client *c);
> +
>  /*
>   * kill off a dead client
>   */
> @@ -123,6 +133,7 @@ static void dead_client(struct client *c)
>  {
>  	int fd = c->fd;
>  	list_del_init(&c->node);
> +	stop_waiting_for_event(c);
>  	c->fd = -1;
>  	reset_strbuf(&c->reply);
>  	if (c->cmdvec)
> @@ -152,6 +163,7 @@ static void new_client(int ux_sock, int non_root_clients)
>  		return;
>  	}
>  	INIT_LIST_HEAD(&c->node);
> +	INIT_LIST_HEAD(&c->wait_node);
>  	c->fd = fd;
>  	c->state = CLT_RECV;
>  	c->is_root = _socket_client_is_root(c->fd);
> @@ -384,6 +396,21 @@ static int execute_handler(struct client *c, struct vectors *vecs)
>  	return c->handler->fn(c->cmdvec, &c->reply, vecs);
>  }
>  
> +int init_wait_fd(void)
> +{
> +	wait_fd = eventfd(0, EFD_NONBLOCK | EFD_CLOEXEC);
> +
> +	if (wait_fd < 0)
> +		return -1;
> +	return 0;
> +}
> +
> +void cleanup_wait_fd(void)
> +{
> +	if (wait_fd >= 0)
> +		close(wait_fd);

Nit: set wait_fd = -1 after closing.

> +}
> +
>  static void wakeup_listener(int event_fd)
>  {
>  	uint64_t one = 1;
> @@ -397,6 +424,55 @@ static void wakeup_idle_listener(void)
>  	wakeup_listener(idle_fd);
>  }
>  
> +void wait_for_event(struct list_head *wait_node, struct list_head *wait_list)
> +{
> +	pthread_mutex_lock(&client_wait_lock);
> +	list_add(wait_node, wait_list);
> +	pthread_mutex_unlock(&client_wait_lock);
> +}
> +
> +void wakeup_event_waiter(struct list_head *wait_list)
> +{
> +	bool have_waiter = false;
> +
> +	pthread_mutex_lock(&client_wait_lock);
> +	while (list_pop(wait_list))
> +		have_waiter = true;
> +	pthread_mutex_unlock(&client_wait_lock);
> +	if (have_waiter)
> +		wakeup_listener(wait_fd);
> +}

This function "wakes up" all waiters, even though the waiters may be waiting
for different conditions to come true.

> +
> +/* must only be called by uxlsnr_thr */
> +static void stop_waiting_for_event(struct client *c)
> +{
> +	/*
> +	 * As long as clients will only be added to wait lists by uxlsnr_thr
> +	 * and only removed with list_del_init(), it is safe to check if
> +	 * wait_node is empty without holding client_wait_lock. uxlsnr_thr
> +	 * can't miss a client being added to the list, since a process is
> +	 * guaranteed to see all memory changes it did. It can miss a client
> +	 * being removed from the list or see a torn write from a concurrent
> +	 * removal, but this will just cause it to unnecessarily grab the lock
> +	 * and redo the removal.
> +	 */
> +	if (!list_empty(&c->wait_node)) {

Tbh, I don't like this super-smart optimization. I would prefer just taking
the lock. If we find this to hurt performance, we could  change the
implementation to RCU.

> +		pthread_mutex_lock(&client_wait_lock);
> +		list_del_init(&c->wait_node);
> +		pthread_mutex_unlock(&client_wait_lock);
> +	}
> +}
> +
> +static bool finished_waiting(struct client *c)
> +{
> +	bool ret;
> +
> +	pthread_mutex_lock(&client_wait_lock);
> +	ret = list_empty(&c->wait_node);
> +	pthread_mutex_unlock(&client_wait_lock);
> +	return ret;
> +}

wakeup_event_waiter() will remove the wait_node from the list, regardless whether
the specific condition this thread is waiting for has come true. So the client
may return prematurely.

> +
>  static void drain_event_fd(int event_fd)
>  {
>  	uint64_t val;
> @@ -466,8 +542,7 @@ enum {
>  	STM_BREAK,
>  };
>  
> -static int client_state_machine(struct client *c, struct vectors *vecs,
> -				short revents)
> +static int client_state_machine(struct client *c, struct vectors *vecs, int revents)
>  {
>  	ssize_t n;
>  
> @@ -549,8 +624,15 @@ static int client_state_machine(struct client *c, struct vectors *vecs,
>  			check_for_locked_work(c);
>  			pthread_cleanup_pop(1);
>  			condlog(4, "%s: cli[%d] grabbed lock", __func__, c->fd);
> -			set_client_state(c, CLT_SEND);
> -			/* Wait for POLLOUT */
> +			/*
> +			 * This list_empty() is safe to test without a lock for
> +			 * the same reason as in stop_waiting_for_event().
> +			 */
> +			if (!c->error && !list_empty(&c->wait_node))

See above about the lock optimization.

> +				set_client_state(c, CLT_WAIT);
> +			else
> +				set_client_state(c, CLT_SEND);
> +			/* Wait for POLLOUT or POLLWAIT */
>  			return STM_BREAK;
>  		} else {
>  			condlog(4, "%s: cli[%d] waiting for lock", __func__, c->fd);
> @@ -559,8 +641,18 @@ static int client_state_machine(struct client *c, struct vectors *vecs,
>  
>  	case CLT_WORK:
>  		c->error = execute_handler(c, vecs);
> -		set_client_state(c, CLT_SEND);
> -		/* Wait for POLLOUT */
> +		if (!c->error && !list_empty(&c->wait_node))
> +			set_client_state(c, CLT_WAIT);
> +		else
> +			set_client_state(c, CLT_SEND);
> +		/* Wait for POLLOUT or POLLWAIT */
> +		return STM_BREAK;
> +
> +	case CLT_WAIT:
> +		if (!(revents & POLLWAIT))
> +			return STM_BREAK;
> +		if (finished_waiting(c))
> +			set_client_state(c, CLT_SEND);

As noted above, any call to wakeup_event_waiter() will wake up this client and
make finished_waiting() return true. This is fine as long we have just a
single condition to wait for, but as soon as we use this mechanism more
widely, we will need a way to check whether our wait condition is actually
true and keep waiting otherwise, like __wait_event() in the kernel.

Or am I overlooking something here?

-- 
Martin Wilck <mwilck@suse.com>
