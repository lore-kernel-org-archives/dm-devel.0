Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 988DDC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 25 Nov 2021 01:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637803512;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=c1iDgFhusIIRhrd9jbWYjAtbeoFHxsEKTrVHO6YGZko=;
	b=jU8bdsIbtdcS1DNfWjLCAs09/lESK235MbEObTPU9K0aWgkPB/8OT8pydBlThYfrY6q9Kr
	C7W0wm46XrbqHIBc9W7U0qih+YmaBiSUfCtAep7YFFl1gcy75gj1Xgc0LwHB8/Kev6rkX7
	bDI0njEpluABAKXUTiokXgV4l4liFJA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-uEYQj0-COA2I_Ur0V-V-dA-1; Wed, 24 Nov 2021 20:25:09 -0500
X-MC-Unique: uEYQj0-COA2I_Ur0V-V-dA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E120281CCB4;
	Thu, 25 Nov 2021 01:25:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DC3326DEA;
	Thu, 25 Nov 2021 01:25:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 49A941809C89;
	Thu, 25 Nov 2021 01:25:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AP1NDnh007990 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Nov 2021 20:23:13 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 74E56ADC8; Thu, 25 Nov 2021 01:23:13 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9016E5D9C0;
	Thu, 25 Nov 2021 01:23:10 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AP1N8EY023705; 
	Wed, 24 Nov 2021 19:23:08 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AP1N86S023704;
	Wed, 24 Nov 2021 19:23:08 -0600
Date: Wed, 24 Nov 2021 19:23:07 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20211125012307.GV19591@octiron.msp.redhat.com>
References: <20211118225840.19810-1-mwilck@suse.com>
	<20211118225840.19810-32-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20211118225840.19810-32-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH v2 31/48] multipathd: uxlsnr: add timeout
	handling
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 18, 2021 at 11:58:23PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Our ppoll() call needs to wake up when a client request times out.
> This logic can be added by determining the first client that's about
> to time out. The logic in handle_client() will then cause a timeout
> reply to be sent to the client. This is more client-friendly
> as the client timing out without receiving a reply.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/uxlsnr.c | 57 +++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 52 insertions(+), 5 deletions(-)
> 
> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index bf9780d..45fe7b5 100644
> --- a/multipathd/uxlsnr.c
> +++ b/multipathd/uxlsnr.c
> @@ -306,6 +306,35 @@ static void handle_inotify(int fd, struct watch_descriptors *wds)
>  }
>  
>  static const struct timespec ts_zero = { .tv_sec = 0, };
> +static const struct timespec ts_max = { .tv_sec = LONG_MAX, .tv_nsec = 999999999 };
> +
> +/* call with clients lock held */
> +static struct timespec *__get_soonest_timeout(struct timespec *ts)
> +{
> +	struct timespec ts_min = ts_max, now;
> +	bool any = false;
> +	struct client *c;
> +
> +	list_for_each_entry(c, &clients, node) {
> +		if (timespeccmp(&c->expires, &ts_zero) != 0 &&
> +		    timespeccmp(&c->expires, &ts_min) < 0) {
> +			ts_min = c->expires;
> +			any = true;
> +		}
> +	}
> +
> +	if (!any)
> +		return NULL;
> +
> +	get_monotonic_time(&now);
> +	timespecsub(&ts_min, &now, ts);
> +	if (timespeccmp(ts, &ts_zero) < 0)
> +		*ts = ts_zero;
> +
> +	condlog(4, "%s: next client expires in %ld.%03lds", __func__,
> +		(long)ts->tv_sec, ts->tv_nsec / 1000000);
> +	return ts;
> +}
>  
>  /* call with clients lock held */
>  static bool __need_vecs_lock(void)
> @@ -532,6 +561,24 @@ static int client_state_machine(struct client *c, struct vectors *vecs,
>  	}
>  }
>  
> +static void check_timeout(struct client *c)
> +{
> +	struct timespec now;
> +
> +	if (timespeccmp(&c->expires, &ts_zero) == 0)
> +		return;
> +
> +	get_monotonic_time(&now);
> +	if (timespeccmp(&c->expires, &now) > 0)
> +		return;
> +
> +	condlog(2, "%s: cli[%d]: timed out at %ld.%03ld", __func__,
> +		c->fd, (long)c->expires.tv_sec, c->expires.tv_nsec / 1000000);
> +
> +	c->error = -ETIMEDOUT;
> +	set_client_state(c, CLT_SEND);
> +}
> +
>  static void handle_client(struct client *c, struct vectors *vecs, short revents)
>  {
>  	if (revents & (POLLHUP|POLLERR)) {
> @@ -539,6 +586,7 @@ static void handle_client(struct client *c, struct vectors *vecs, short revents)
>  		return;
>  	}
>  
> +	check_timeout(c);
>          while (client_state_machine(c, vecs, revents) == STM_CONT);
>  }
>  
> @@ -580,6 +628,7 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
>  	while (1) {
>  		struct client *c, *tmp;
>  		int i, n_pfds, poll_count, num_clients;
> +		struct timespec __timeout, *timeout;
>  
>  		/* setup for a poll */
>  		pthread_mutex_lock(&client_lock);
> @@ -647,10 +696,12 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
>                                  break;
>                  }
>                  n_pfds = i;
> +		timeout = __get_soonest_timeout(&__timeout);
> +
>  		pthread_cleanup_pop(1);
>  
>  		/* most of our life is spent in this call */
> -		poll_count = ppoll(polls, n_pfds, NULL, &mask);
> +		poll_count = ppoll(polls, n_pfds, timeout, &mask);
>  
>  		handle_signals(false);
>  		if (poll_count == -1) {
> @@ -665,10 +716,6 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
>  			break;
>  		}
>  
> -		if (poll_count == 0) {
> -			handle_signals(true);
> -			continue;
> -		}
>  		if (polls[POLLFD_IDLE].fd != -1 &&
>  		    polls[POLLFD_IDLE].revents & POLLIN)
>  			drain_idle_fd(idle_fd);
> -- 
> 2.33.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

