Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D01FC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 25 Nov 2021 01:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637804725;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KdWbkCWmxikwXBJ3spKLtbVaGSOm1RXQ8Fknh9LF6wE=;
	b=ZhUhHDxLkEIrMPVMv0dmvt/TSoOtpJqzynhTXD4N9dT2PLxOrJKB4oqvJaZXU19SfvLN9H
	MEgnkKiPo3EUvkQ4LUwWvHo3sgjWyApRR/EW35b2VnAPjmgAz+xLUFzYtDmgfiPhI0muwb
	V61HJZVmt1Gjy5AvftSJCwPUC71qDsg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-5p3YKPZOOd-kn0GWOr956w-1; Wed, 24 Nov 2021 20:45:21 -0500
X-MC-Unique: 5p3YKPZOOd-kn0GWOr956w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 713CB18009E4;
	Thu, 25 Nov 2021 01:45:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 017256060F;
	Thu, 25 Nov 2021 01:45:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8ED181809C8A;
	Thu, 25 Nov 2021 01:45:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AP1jGfa010297 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Nov 2021 20:45:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2E8114D73A; Thu, 25 Nov 2021 01:45:16 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BE33577E21;
	Thu, 25 Nov 2021 01:45:07 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AP1j6jT023733; 
	Wed, 24 Nov 2021 19:45:06 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AP1j5pR023732;
	Wed, 24 Nov 2021 19:45:05 -0600
Date: Wed, 24 Nov 2021 19:45:05 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20211125014505.GX19591@octiron.msp.redhat.com>
References: <20211118225840.19810-1-mwilck@suse.com>
	<20211118225840.19810-34-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20211118225840.19810-34-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH v2 33/48] multipathd: uxlsnr: drop client_lock
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 18, 2021 at 11:58:25PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> The list of clients is never changed anywhere except in
> uxsock_listen(). No need to lock.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipathd/uxlsnr.c | 33 ++++++---------------------------
>  1 file changed, 6 insertions(+), 27 deletions(-)
> 
> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index 6213454..24db377 100644
> --- a/multipathd/uxlsnr.c
> +++ b/multipathd/uxlsnr.c
> @@ -89,7 +89,6 @@ enum {
>  static __attribute__((unused)) char ___a[-(MIN_POLLS <= 0)];
>  
>  static LIST_HEAD(clients);
> -static pthread_mutex_t client_lock = PTHREAD_MUTEX_INITIALIZER;
>  static struct pollfd *polls;
>  static int notify_fd = -1;
>  static int idle_fd = -1;
> @@ -136,15 +135,13 @@ static void new_client(int ux_sock)
>  	c->is_root = _socket_client_is_root(c->fd);
>  
>  	/* put it in our linked list */
> -	pthread_mutex_lock(&client_lock);
>  	list_add_tail(&c->node, &clients);
> -	pthread_mutex_unlock(&client_lock);
>  }
>  
>  /*
>   * kill off a dead client
>   */
> -static void _dead_client(struct client *c)
> +static void dead_client(struct client *c)
>  {
>  	int fd = c->fd;
>  	list_del_init(&c->node);
> @@ -156,14 +153,6 @@ static void _dead_client(struct client *c)
>  	close(fd);
>  }
>  
> -static void dead_client(struct client *c)
> -{
> -	pthread_cleanup_push(cleanup_mutex, &client_lock);
> -	pthread_mutex_lock(&client_lock);
> -	_dead_client(c);
> -	pthread_cleanup_pop(1);
> -}
> -
>  static void free_polls (void)
>  {
>  	if (polls)
> @@ -180,11 +169,9 @@ void uxsock_cleanup(void *arg)
>  	close(notify_fd);
>  	free(watch_config_dir);
>  
> -	pthread_mutex_lock(&client_lock);
>  	list_for_each_entry_safe(client_loop, client_tmp, &clients, node) {
> -		_dead_client(client_loop);
> +		dead_client(client_loop);
>  	}
> -	pthread_mutex_unlock(&client_lock);
>  
>  	cli_exit();
>  	free_polls();
> @@ -308,8 +295,7 @@ static void handle_inotify(int fd, struct watch_descriptors *wds)
>  static const struct timespec ts_zero = { .tv_sec = 0, };
>  static const struct timespec ts_max = { .tv_sec = LONG_MAX, .tv_nsec = 999999999 };
>  
> -/* call with clients lock held */
> -static struct timespec *__get_soonest_timeout(struct timespec *ts)
> +static struct timespec *get_soonest_timeout(struct timespec *ts)
>  {
>  	struct timespec ts_min = ts_max, now;
>  	bool any = false;
> @@ -336,8 +322,7 @@ static struct timespec *__get_soonest_timeout(struct timespec *ts)
>  	return ts;
>  }
>  
> -/* call with clients lock held */
> -static bool __need_vecs_lock(void)
> +static bool need_vecs_lock(void)
>  {
>  	struct client *c;
>  
> @@ -614,7 +599,6 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
>  	/* conf->sequence_nr will be 1 when uxsock_listen is first called */
>  	unsigned int sequence_nr = 0;
>  	struct watch_descriptors wds = { .conf_wd = -1, .dir_wd = -1 };
> -	bool need_lock = false;
>  	struct vectors *vecs = trigger_data;
>  
>  	condlog(3, "uxsock: startup listener");
> @@ -645,8 +629,6 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
>  		struct timespec __timeout, *timeout;
>  
>  		/* setup for a poll */
> -		pthread_mutex_lock(&client_lock);
> -		pthread_cleanup_push(cleanup_mutex, &client_lock);
>  		num_clients = 0;
>  		list_for_each_entry(c, &clients, node) {
>  			num_clients++;
> @@ -686,9 +668,8 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
>  		else
>  			polls[POLLFD_NOTIFY].events = POLLIN;
>  
> -		need_lock = __need_vecs_lock();
>  		polls[POLLFD_IDLE].fd = idle_fd;
> -		if (need_lock)
> +		if (need_vecs_lock())
>  			polls[POLLFD_IDLE].events = POLLIN;
>  		else
>  			polls[POLLFD_IDLE].events = 0;
> @@ -713,9 +694,7 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
>                                  break;
>                  }
>                  n_pfds = i;
> -		timeout = __get_soonest_timeout(&__timeout);
> -
> -		pthread_cleanup_pop(1);
> +		timeout = get_soonest_timeout(&__timeout);
>  
>  		/* most of our life is spent in this call */
>  		poll_count = ppoll(polls, n_pfds, timeout, &mask);
> -- 
> 2.33.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

