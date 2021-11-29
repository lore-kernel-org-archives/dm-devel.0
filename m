Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C86EC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 30 Nov 2021 06:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1638252750;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HYSUhJ1YchhTWi4e7YyLQGZESKUcdtVMg+cUzIB3Zw4=;
	b=BkE7+JNTL5Ml+IN3v8pEd3sHgrhgF9k0xImqa/rmkQZ8OjTfXHceMxXm4YDxOoygFwSBVB
	cs9axCluKveFGQAQTVS11bGdzQa4Y8qGxQFBY7oOHYUKuwX559xefSJUYJUEHuFzgoUkw0
	0LnW0lXUtjtCF9oNHWSOEtAsa4KBYus=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-449-Ert9NecDOdq9ZBdI42n58w-1; Tue, 30 Nov 2021 01:12:28 -0500
X-MC-Unique: Ert9NecDOdq9ZBdI42n58w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2FC1F180FD78;
	Tue, 30 Nov 2021 06:12:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 14B7A60BF1;
	Tue, 30 Nov 2021 06:12:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CAA054A7C8;
	Tue, 30 Nov 2021 06:12:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ATKGBnN002870 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Nov 2021 15:16:11 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A778E45D61; Mon, 29 Nov 2021 20:16:11 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6028B45D60;
	Mon, 29 Nov 2021 20:16:11 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1ATKG9OP022381; 
	Mon, 29 Nov 2021 14:16:09 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1ATKG97p022380;
	Mon, 29 Nov 2021 14:16:09 -0600
Date: Mon, 29 Nov 2021 14:16:08 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20211129201608.GE19591@octiron.msp.redhat.com>
References: <20211127151929.7727-1-mwilck@suse.com>
	<20211127151929.7727-31-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20211127151929.7727-31-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 30 Nov 2021 01:11:05 -0500
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH v3 30/35] multipathd: uxlsnr: add idle
	notification
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Nov 27, 2021 at 04:19:23PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> The previous patches added the state machine and the timeout handling,
> but there was no wakeup mechanism for the uxlsnr for cases where
> client connections were waiting for the vecs lock.
> 
> This patch uses the previously introduced wakeup mechanism of
> struct mutex_lock for this purpose. Processes which unlock the
> "global" vecs lock send an event in an eventfd which the uxlsnr
> loop is polling for.
> 
> As we are now woken up for servicing client handlers that don't
> wait for input but for the lock, we need to set up the pollfds
> differently, and iterate over all clients when handling events,
> not only over the ones that are receiving. The hangup handling
> is changed, too. We have to look at every client, even if one has
> hung up. Note that I don't take client_lock for the loop in
> uxsock_listen(), it's not necessary and will be removed elsewhere
> in a follow-up patch.
> 
> With this in place, the lock need not be taken in execute_handler()
> any more. The uxlsnr only ever calls trylock() on the vecs lock,
> avoiding any waiting for other threads to finish.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipathd/uxlsnr.c | 183 +++++++++++++++++++++++++++++---------------
>  1 file changed, 121 insertions(+), 62 deletions(-)
> 
> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index c393477..f559a23 100644
> --- a/multipathd/uxlsnr.c
> +++ b/multipathd/uxlsnr.c
> @@ -24,6 +24,7 @@
>  #include <signal.h>
>  #include <stdbool.h>
>  #include <sys/inotify.h>
> +#include <sys/eventfd.h>
>  #include "checkers.h"
>  #include "debug.h"
>  #include "vector.h"
> @@ -69,6 +70,7 @@ struct client {
>  enum {
>  	POLLFD_UX = 0,
>  	POLLFD_NOTIFY,
> +	POLLFD_IDLE,
>  	POLLFDS_BASE,
>  };
>  
> @@ -89,6 +91,7 @@ static LIST_HEAD(clients);
>  static pthread_mutex_t client_lock = PTHREAD_MUTEX_INITIALIZER;
>  static struct pollfd *polls;
>  static int notify_fd = -1;
> +static int idle_fd = -1;
>  static char *watch_config_dir;
>  
>  static bool _socket_client_is_root(int fd)
> @@ -187,6 +190,17 @@ void uxsock_cleanup(void *arg)
>  	free_polls();
>  }
>  
> +void wakeup_cleanup(void *arg)
> +{
> +	struct mutex_lock *lck = arg;
> +	int fd = idle_fd;
> +
> +	idle_fd = -1;
> +	set_wakeup_fn(lck, NULL);
> +	if (fd != -1)
> +		close(fd);
> +}
> +
>  struct watch_descriptors {
>  	int conf_wd;
>  	int dir_wd;
> @@ -293,6 +307,18 @@ static void handle_inotify(int fd, struct watch_descriptors *wds)
>  
>  static const struct timespec ts_zero = { .tv_sec = 0, };
>  
> +/* call with clients lock held */
> +static bool __need_vecs_lock(void)
> +{
> +	struct client *c;
> +
> +	list_for_each_entry(c, &clients, node) {
> +		if (c->state == CLT_LOCKED_WORK)
> +			return true;
> +	}
> +	return false;
> +}
> +
>  static int parse_cmd(struct client *c)
>  {
>  	int r;
> @@ -310,40 +336,31 @@ static int parse_cmd(struct client *c)
>  	return r;
>  }
>  
> -static int execute_handler(struct client *c, struct vectors *vecs, int timeout)
> +static int execute_handler(struct client *c, struct vectors *vecs)
>  {
> -	int r;
> -	struct timespec tmo;
>  
> -	if (!c->handler)
> +	if (!c->handler || !c->handler->fn)
>  		return -EINVAL;
>  
> -	if (clock_gettime(CLOCK_REALTIME, &tmo) == 0) {
> -		tmo.tv_sec += timeout;
> -	} else {
> -		tmo.tv_sec = 0;
> -	}
> +	return c->handler->fn(c->cmdvec, &c->reply, vecs);
> +}
>  
> -	if (c->handler->locked) {
> -		int locked = 0;
> +static void wakeup_listener(void)
> +{
> +	uint64_t one = 1;
>  
> -		pthread_cleanup_push(cleanup_lock, &vecs->lock);
> -		if (tmo.tv_sec) {
> -			r = timedlock(&vecs->lock, &tmo);
> -		} else {
> -			lock(&vecs->lock);
> -			r = 0;
> -		}
> -		if (r == 0) {
> -			locked = 1;
> -			pthread_testcancel();
> -			r = c->handler->fn(c->cmdvec, &c->reply, vecs);
> -		}
> -		pthread_cleanup_pop(locked);
> -	} else
> -		r = c->handler->fn(c->cmdvec, &c->reply, vecs);
> +	if (idle_fd != -1 &&
> +	    write(idle_fd, &one, sizeof(one)) != sizeof(one))
> +		condlog(1, "%s: failed", __func__);
> +}
>  
> -	return r;
> +static void drain_idle_fd(int fd)
> +{
> +	uint64_t val;
> +	int rc;
> +
> +	rc = read(fd, &val, sizeof(val));
> +	condlog(4, "%s: %d, %"PRIu64, __func__, rc, val);
>  }
>  
>  void default_reply(struct client *c, int r)
> @@ -397,16 +414,19 @@ enum {
>  	STM_BREAK,
>  };
>  
> -static int client_state_machine(struct client *c, struct vectors *vecs)
> +static int client_state_machine(struct client *c, struct vectors *vecs,
> +				short revents)
>  {
>  	ssize_t n;
>  	const char *buf;
>  
> -	condlog(4, "%s: cli[%d] state=%d cmd=\"%s\" repl \"%s\"", __func__,
> -		c->fd, c->state, c->cmd, get_strbuf_str(&c->reply));
> +	condlog(4, "%s: cli[%d] poll=%x state=%d cmd=\"%s\" repl \"%s\"", __func__,
> +		c->fd, revents, c->state, c->cmd, get_strbuf_str(&c->reply));
>  
>  	switch (c->state) {
>  	case CLT_RECV:
> +		if (!(revents & POLLIN))
> +			return STM_BREAK;
>  		if (c->cmd_len == 0) {
>  			/*
>  			 * We got POLLIN; assume that at least the length can
> @@ -462,17 +482,30 @@ static int client_state_machine(struct client *c, struct vectors *vecs)
>  		}
>  		if (c->error)
>  			set_client_state(c, CLT_SEND);
> +		else if (c->handler->locked)
> +			set_client_state(c, CLT_LOCKED_WORK);
>  		else
>  			set_client_state(c, CLT_WORK);
>  		return STM_CONT;
>  
>  	case CLT_LOCKED_WORK:
> -		/* tbd */
> -		set_client_state(c, CLT_WORK);
> -		return STM_CONT;
> +                if (trylock(&vecs->lock) == 0) {
> +			/* don't use cleanup_lock(), lest we wakeup ourselves */
> +			pthread_cleanup_push_cast(__unlock, &vecs->lock);
> +			c->error = execute_handler(c, vecs);
> +			pthread_cleanup_pop(1);
> +			condlog(4, "%s: cli[%d] grabbed lock", __func__, c->fd);
> +			free_keys(c->cmdvec);
> +			c->cmdvec = NULL;
> +			set_client_state(c, CLT_SEND);
> +			return STM_CONT;
> +		} else {
> +			condlog(4, "%s: cli[%d] waiting for lock", __func__, c->fd);
> +			return STM_BREAK;
> +		}
>  
>  	case CLT_WORK:
> -		c->error = execute_handler(c, vecs, uxsock_timeout / 1000);
> +		c->error = execute_handler(c, vecs);
>  		free_keys(c->cmdvec);
>  		c->cmdvec = NULL;
>  		set_client_state(c, CLT_SEND);
> @@ -499,9 +532,14 @@ static int client_state_machine(struct client *c, struct vectors *vecs)
>  	}
>  }
>  
> -static void handle_client(struct client *c, struct vectors *vecs)
> +static void handle_client(struct client *c, struct vectors *vecs, short revents)
>  {
> -	while (client_state_machine(c, vecs) == STM_CONT);
> +	if (revents & (POLLHUP|POLLERR)) {
> +		c->error = -ECONNRESET;
> +		return;
> +	}
> +
> +        while (client_state_machine(c, vecs, revents) == STM_CONT);
>  }
>  
>  /*
> @@ -514,6 +552,8 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
>  	/* conf->sequence_nr will be 1 when uxsock_listen is first called */
>  	unsigned int sequence_nr = 0;
>  	struct watch_descriptors wds = { .conf_wd = -1, .dir_wd = -1 };
> +	bool need_lock = false;
> +	struct vectors *vecs = trigger_data;
>  
>  	condlog(3, "uxsock: startup listener");
>  	polls = calloc(1, max_pfds * sizeof(*polls));
> @@ -524,6 +564,15 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
>  	notify_fd = inotify_init1(IN_NONBLOCK);
>  	if (notify_fd == -1) /* it's fine if notifications fail */
>  		condlog(3, "failed to start up configuration notifications");
> +
> +	pthread_cleanup_push(wakeup_cleanup, &vecs->lock);
> +	idle_fd = eventfd(0, EFD_NONBLOCK|EFD_CLOEXEC);
> +	if (idle_fd == -1) {
> +		condlog(1, "failed to create idle fd");
> +		exit_daemon();
> +	} else
> +		set_wakeup_fn(&vecs->lock, wakeup_listener);
> +
>  	sigfillset(&mask);
>  	sigdelset(&mask, SIGINT);
>  	sigdelset(&mask, SIGTERM);
> @@ -575,11 +624,25 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
>  		else
>  			polls[POLLFD_NOTIFY].events = POLLIN;
>  
> +		need_lock = __need_vecs_lock();
> +		polls[POLLFD_IDLE].fd = idle_fd;
> +		if (need_lock)
> +			polls[POLLFD_IDLE].events = POLLIN;
> +		else
> +			polls[POLLFD_IDLE].events = 0;
> +
>  		/* setup the clients */
>  		i = POLLFDS_BASE;
>  		list_for_each_entry(c, &clients, node) {
> +			switch(c->state) {
> +			case CLT_RECV:
> +				polls[i].events = POLLIN;
> +				break;
> +			default:
> +				/* don't poll for this client */
> +				continue;
> +			}
>  			polls[i].fd = c->fd;
> -			polls[i].events = POLLIN;
>  			i++;
>  			if (i >= max_pfds)
>  				break;
> @@ -607,33 +670,28 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
>  			handle_signals(true);
>  			continue;
>  		}
> +		if (polls[POLLFD_IDLE].fd != -1 &&
> +		    polls[POLLFD_IDLE].revents & POLLIN)
> +			drain_idle_fd(idle_fd);
>  
> -		/* see if a client wants to speak to us */
> -		for (i = POLLFDS_BASE; i < n_pfds; i++) {
> -			if (polls[i].revents & (POLLIN|POLLHUP|POLLERR)) {
> -				c = NULL;
> -				pthread_mutex_lock(&client_lock);
> -				list_for_each_entry(tmp, &clients, node) {
> -					if (tmp->fd == polls[i].fd) {
> -						c = tmp;
> -						break;
> -					}
> +		/* see if a client needs handling */
> +		list_for_each_entry_safe(c, tmp, &clients, node) {
> +			short revents = 0;
> +
> +			for (i = POLLFDS_BASE; i < n_pfds; i++) {
> +				if (polls[i].fd == c->fd) {
> +					revents = polls[i].revents;
> +					break;
>  				}
> -				pthread_mutex_unlock(&client_lock);
> -				if (!c) {
> -					condlog(4, "cli%d: new fd %d",
> -						i, polls[i].fd);
> -					continue;
> -				}
> -				if (polls[i].revents & (POLLHUP|POLLERR)) {
> -					condlog(4, "cli[%d]: Disconnected",
> -						c->fd);
> -					dead_client(c);
> -					continue;
> -				}
> -				handle_client(c, trigger_data);
> -				if (c->error == -ECONNRESET)
> -					dead_client(c);
> +			}
> +
> +			handle_client(c, trigger_data, revents);
> +
> +			if (c->error == -ECONNRESET) {
> +				condlog(4, "cli[%d]: disconnected", c->fd);
> +				dead_client(c);
> +				if (i < n_pfds)
> +					polls[i].fd = -1;
>  			}
>  		}
>  		/* see if we got a non-fatal signal */
> @@ -649,5 +707,6 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
>  			handle_inotify(notify_fd, &wds);
>  	}
>  
> +	pthread_cleanup_pop(1);
>  	return NULL;
>  }
> -- 
> 2.33.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

