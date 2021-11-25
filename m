Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92F4EC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 25 Nov 2021 06:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637822655;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=t4IuIQLeAmjb6js7ztDNXIbCN6fYzAN5lvwCzyf4SxQ=;
	b=h2ofB7rd+yaiXK5w027x/Nl8w9Egr+UdlYxVEfOgYpluuuVTbri4YLUnVpO9QH0ajf2KOh
	8jr3Yr680Od8EwwNP0UQv5DaOaQBHSLXWcJzNgZCXAxahHgo6rdNuP/6a6S/0ltpyRNNSw
	n8fiEQfu6EbJca47P2svkQvk3CSleOc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-401-645ZYpGKPCy2wM-N1hhNKw-1; Thu, 25 Nov 2021 01:44:12 -0500
X-MC-Unique: 645ZYpGKPCy2wM-N1hhNKw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE56D100C661;
	Thu, 25 Nov 2021 06:44:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 278FD5D6B1;
	Thu, 25 Nov 2021 06:44:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D0E541809C8A;
	Thu, 25 Nov 2021 06:44:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AP18LdS007264 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Nov 2021 20:08:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3ED10171FF; Thu, 25 Nov 2021 01:08:21 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BA1005C25A;
	Thu, 25 Nov 2021 01:08:16 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AP18E4f023668; 
	Wed, 24 Nov 2021 19:08:15 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AP18EjW023667;
	Wed, 24 Nov 2021 19:08:14 -0600
Date: Wed, 24 Nov 2021 19:08:13 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20211125010813.GU19591@octiron.msp.redhat.com>
References: <20211118225840.19810-1-mwilck@suse.com>
	<20211118225840.19810-31-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20211118225840.19810-31-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 25 Nov 2021 01:44:00 -0500
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH v2 30/48] multipathd: uxlsnr: add idle
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 18, 2021 at 11:58:22PM +0100, mwilck@suse.com wrote:
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
> ---
>  multipathd/uxlsnr.c | 200 ++++++++++++++++++++++++++++----------------
>  1 file changed, 129 insertions(+), 71 deletions(-)
> 
> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index 87134d5..bf9780d 100644
> --- a/multipathd/uxlsnr.c
> +++ b/multipathd/uxlsnr.c
> @@ -24,6 +24,7 @@
>  #include <signal.h>
>  #include <stdbool.h>
>  #include <sys/inotify.h>
> +#include <sys/eventfd.h>
>  #include "checkers.h"
>  #include "memory.h"
>  #include "debug.h"
> @@ -70,6 +71,7 @@ struct client {
>  enum {
>  	POLLFD_UX = 0,
>  	POLLFD_NOTIFY,
> +	POLLFD_IDLE,
>  	POLLFDS_BASE,
>  };
>  
> @@ -90,6 +92,7 @@ static LIST_HEAD(clients);
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
> +		if (c->state == CLT_WAIT_LOCK)
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
>          switch (c->state) {
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
> +			set_client_state(c, CLT_WAIT_LOCK);
>  		else
>  			set_client_state(c, CLT_WORK);
>  		return STM_CONT;
>  
>  	case CLT_WAIT_LOCK:

It's not a big deal, but I would prefer a name like CLT_LOCKED_WORK
instead of CLT_WAIT_LOCK, to make it obvious that these are alternate
possibilites.


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
>  	polls = MALLOC(max_pfds * sizeof(*polls));
> @@ -524,6 +564,14 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
>  	notify_fd = inotify_init1(IN_NONBLOCK);
>  	if (notify_fd == -1) /* it's fine if notifications fail */
>  		condlog(3, "failed to start up configuration notifications");
> +
> +	pthread_cleanup_push(wakeup_cleanup, &vecs->lock);
> +	idle_fd = eventfd(0, EFD_NONBLOCK|EFD_CLOEXEC);
> +	if (idle_fd == -1)
> +		condlog(1, "failed to create idle fd");

If the idle_fd doesn't get correctly set, that seems like a fatal error
to me.

> +	else
> +		set_wakeup_fn(&vecs->lock, wakeup_listener);
> +
>  	sigfillset(&mask);
>  	sigdelset(&mask, SIGINT);
>  	sigdelset(&mask, SIGTERM);
> @@ -575,16 +623,30 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
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
> -		i = POLLFDS_BASE;
> -		list_for_each_entry(c, &clients, node) {
> -			polls[i].fd = c->fd;
> -			polls[i].events = POLLIN;
> -			i++;
> -			if (i >= max_pfds)
> -				break;
> -		}
> -		n_pfds = i;
> +                i = POLLFDS_BASE;
> +                list_for_each_entry(c, &clients, node) {

Nitpick: This would look clearer to me if, instead of a switch
statement, it was just

if (c->state != CLT_RECV)
        continue;

polls[i].events = POLLIN;
polls[i].fd = c->fd;
...


-Ben

> +                        switch(c->state) {
> +                        case CLT_RECV:
> +                                polls[i].events = POLLIN;
> +                                break;
> +                        default:
> +				/* don't poll for this client */
> +                                continue;
> +                        }
> +                        polls[i].fd = c->fd;
> +                        i++;
> +                        if (i >= max_pfds)
> +                                break;
> +                }
> +                n_pfds = i;
>  		pthread_cleanup_pop(1);
>  
>  		/* most of our life is spent in this call */
> @@ -607,33 +669,28 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
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
> -				}
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
> +		/* see if a client needs handling */
> +		list_for_each_entry_safe(c, tmp, &clients, node) {
> +			short revents = 0;
> +
> +			for (i = POLLFDS_BASE; i < n_pfds; i++) {
> +                                if (polls[i].fd == c->fd) {
> +                                        revents = polls[i].revents;
> +                                        break;
> +                                }
> +                        }
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
> @@ -649,5 +706,6 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
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

