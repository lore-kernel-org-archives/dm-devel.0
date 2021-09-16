Return-Path: <SRS0=t70f=OG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA710C433FE
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 06:50:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 44C15610A4
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 06:50:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 44C15610A4
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1631775030;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Bm6VCzkQzXBiyv2A+rtG3Lh/k3PlCY/0ZWYSbWsrSao=;
	b=F0czGyitleRLBYQ0ZFUQx4XPQsJWQWZh7Z8sl5pJa5p0Sl+OqEBgIESnTfSrn/Sn9vorvK
	wEwM72HMtiTB56b0u4wzC6fvoxxRcZYXqPwLyXT8gsMIcOtVpijB6lftEP42U/4AANWYgQ
	hKlWzz5P2UJI19UhtaI5XoCEA7VcCC0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-P3cYQlyqOLKjE70HiztL6g-1; Thu, 16 Sep 2021 02:50:28 -0400
X-MC-Unique: P3cYQlyqOLKjE70HiztL6g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 421EE835DE0;
	Thu, 16 Sep 2021 06:50:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 11D407BE45;
	Thu, 16 Sep 2021 06:50:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BF6434EA30;
	Thu, 16 Sep 2021 06:50:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18G4F0j6004329 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 16 Sep 2021 00:15:00 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8E3C318EC5; Thu, 16 Sep 2021 04:15:00 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A12E7A8D2;
	Thu, 16 Sep 2021 04:14:56 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 18G4Er8S007901; 
	Wed, 15 Sep 2021 23:14:54 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 18G4Ernp007900;
	Wed, 15 Sep 2021 23:14:53 -0500
Date: Wed, 15 Sep 2021 23:14:52 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210916041452.GQ3087@octiron.msp.redhat.com>
References: <20210910114120.13665-1-mwilck@suse.com>
	<20210910114120.13665-32-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210910114120.13665-32-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 16 Sep 2021 02:50:07 -0400
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH 31/35] multipathd: uxlsnr: add idle
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 10, 2021 at 01:41:16PM +0200, mwilck@suse.com wrote:
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
>  multipathd/uxlsnr.c | 211 ++++++++++++++++++++++++++++++--------------
>  1 file changed, 143 insertions(+), 68 deletions(-)
> 
> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index 553274b..4637954 100644
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
> @@ -90,8 +92,23 @@ static LIST_HEAD(clients);
>  static pthread_mutex_t client_lock = PTHREAD_MUTEX_INITIALIZER;
>  static struct pollfd *polls;
>  static int notify_fd = -1;
> +static int idle_fd = -1;
>  static char *watch_config_dir;
>  
> +struct possible_lock {
> +	struct mutex_lock *lock;
> +	bool held;
> +};
> +
> +static void unlock_if_held(void *arg)
> +{
> +	struct possible_lock *pl = arg;
> +
> +	/* don't call unlock_wakeup() here, lest we wakeup ourselves */
> +	if (pl->held)
> +		__unlock(pl->lock);
> +}
> +
>  static bool _socket_client_is_root(int fd)
>  {
>  	socklen_t len = 0;
> @@ -187,6 +204,17 @@ void uxsock_cleanup(void *arg)
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
> @@ -293,6 +321,18 @@ static void handle_inotify(int fd, struct watch_descriptors *wds)
>  
>  static const struct timespec ts_zero = { .tv_sec = 0, };
>  
> +/* call with clients lock held */
> +static bool __need_lock(void)
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
> @@ -310,40 +350,31 @@ static int parse_cmd(struct client *c)
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
> @@ -391,15 +422,26 @@ static void set_client_state(struct client *c, int state)
>  	c->state = state;
>  }
>  
> -static void handle_client(struct client *c, struct vectors *vecs)
> +static void handle_client(struct client *c, struct vectors *vecs, short revents)
>  {
>  	ssize_t n;
> +	struct possible_lock pl = {
> +		.lock = &vecs->lock,
> +		.held = false,
> +	};
>  
> -	condlog(4, "%s: cli[%d] state=%d cmd=\"%s\" repl \"%s\"", __func__,
> -		c->fd, c->state, c->cmd, get_strbuf_str(&c->reply));
> +	if (revents & (POLLHUP|POLLERR)) {
> +		c->error = -ECONNRESET;
> +		return;
> +	}
> +
> +	condlog(4, "%s: cli[%d] poll=%x state=%d cmd=\"%s\" repl \"%s\"", __func__,
> +		c->fd, revents, c->state, c->cmd, get_strbuf_str(&c->reply));
>  
>  	switch (c->state) {
>  	case CLT_RECV:
> +		if (!(revents & POLLIN))
> +			return;
>  		if (c->cmd_len == 0) {
>  			/*
>  			 * We got POLLIN; assume that at least the length can
> @@ -463,15 +505,28 @@ static void handle_client(struct client *c, struct vectors *vecs)
>  	case CLT_WAIT_LOCK:
>  		condlog(4, "%s: cli[%d] state=%d cmd=\"%s\" repl \"%s\"", __func__,
>  			c->fd, c->state, c->cmd, get_strbuf_str(&c->reply));
> -		/* tbd */
> +
> +		if (c->error == 0 && c->handler && c->handler->locked) {
> +			pl.held = trylock(pl.lock) == 0;

I do worry that if there are, for instance, a lot of uevents coming in,
this could starve the uxlsnr thread, since other threads could be
grabbing and releasing the vecs lock, but if it's usually being held,
then the uxlsnr thread might never try to grab it when it's free, and it
will keep losing its place in line. Also, every time that the vecs lock
is dropped between ppoll() calls, a wakeup will get triggered, even if
the lock was grabbed by something else before the ppoll thread runs.

I suppose the only way to deal with that would be to move the locking
commands to a list handled by a separate thread, so that it could block
without stalling the non-locking commands.

> +			if (!pl.held) {
> +				condlog(4, "%s: cli[%d] waiting for lock",
> +					__func__, c->fd);
> +				return;
> +			} else
> +				condlog(4, "%s: cli[%d] grabbed lock",
> +					__func__, c->fd);
> +		}
>  		set_client_state(c, CLT_WORK);
>  		/* fallthrough */
>  

We should never return to uxsock_listen() while the lock is held. The
code doesn't, but the fact that CLT_WORK is a separate state makes it
look like this could be possible.  Since we must never be in CLT_WORK
without first being in CLT_WAIT_LOCK, I don't see any point for having a
separate CLT_WAIT_LOCK state.  CLT_WORK should do both the locking if
necessary, and calling the handler.

>  	case CLT_WORK:
>  		condlog(4, "%s: cli[%d] state=%d cmd=\"%s\" repl \"%s\"", __func__,
>  			c->fd, c->state, c->cmd, get_strbuf_str(&c->reply));
> -		if (c->error == 0 && c->handler)
> -			c->error = execute_handler(c, vecs, uxsock_timeout / 1000);
> +		if (c->error == 0 && c->handler) {
> +			pthread_cleanup_push(unlock_if_held, &pl);
> +			c->error = execute_handler(c, vecs);
> +			pthread_cleanup_pop(1);
> +		}
>  
>  		if (c->cmdvec) {
>  			free_keys(c->cmdvec);
> @@ -511,6 +566,8 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
>  	/* conf->sequence_nr will be 1 when uxsock_listen is first called */
>  	unsigned int sequence_nr = 0;
>  	struct watch_descriptors wds = { .conf_wd = -1, .dir_wd = -1 };
> +	bool need_lock = false;
> +	struct vectors *vecs = trigger_data;
>  
>  	condlog(3, "uxsock: startup listener");
>  	polls = MALLOC(max_pfds * sizeof(*polls));
> @@ -521,6 +578,14 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
>  	notify_fd = inotify_init1(IN_NONBLOCK);
>  	if (notify_fd == -1) /* it's fine if notifications fail */
>  		condlog(3, "failed to start up configuration notifications");
> +
> +	pthread_cleanup_push(wakeup_cleanup, &vecs->lock);
> +	idle_fd = eventfd(0, EFD_NONBLOCK|EFD_CLOEXEC);
> +	if (idle_fd == -1)
> +		condlog(1, "failed to create idle fd");
> +	else
> +		set_wakeup_fn(&vecs->lock, wakeup_listener);
> +
>  	sigfillset(&mask);
>  	sigdelset(&mask, SIGINT);
>  	sigdelset(&mask, SIGTERM);
> @@ -572,16 +637,30 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
>  		else
>  			polls[POLLFD_NOTIFY].events = POLLIN;
>  
> +		need_lock = __need_lock();
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
> @@ -604,33 +683,28 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
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
> @@ -646,5 +720,6 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
>  			handle_inotify(notify_fd, &wds);
>  	}
>  
> +	pthread_cleanup_pop(1);
>  	return NULL;
>  }
> -- 
> 2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

