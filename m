Return-Path: <SRS0=t70f=OG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31D92C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 04:22:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9AF50610A4
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 04:22:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9AF50610A4
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1631766143;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zXpTtng+HIaYdxWE9Yeqsjyv+ujQXTVCLW38Ib5HHx8=;
	b=AlUbFP22DpBWtI8pIJQsXhoKb3U0lHYuR80ZKvlxTwEx91rXxun7f3qq1LFaHXJuTBryQD
	KcGNVIqvRfUoC6zUO8dMextnWzgNKJsIIq+uN+iMwprlIMeLoqiXSKr9JPfam3d/NEuGF/
	++pGU2a5j/Blhg6taFvsJhwtlYRA9JE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-FRZ4eiojOpmJEN01SrjMKg-1; Thu, 16 Sep 2021 00:22:22 -0400
X-MC-Unique: FRZ4eiojOpmJEN01SrjMKg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4F641084683;
	Thu, 16 Sep 2021 04:22:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5BE8F18B5E;
	Thu, 16 Sep 2021 04:22:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C59D74E58F;
	Thu, 16 Sep 2021 04:22:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18G4HeV9004485 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 16 Sep 2021 00:17:40 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 73C3F5C1C5; Thu, 16 Sep 2021 04:17:40 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F8235C1A1;
	Thu, 16 Sep 2021 04:17:37 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 18G4HZjv007908; 
	Wed, 15 Sep 2021 23:17:36 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 18G4HYW0007907;
	Wed, 15 Sep 2021 23:17:34 -0500
Date: Wed, 15 Sep 2021 23:17:34 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210916041734.GR3087@octiron.msp.redhat.com>
References: <20210910114120.13665-1-mwilck@suse.com>
	<20210910114120.13665-33-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210910114120.13665-33-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH 32/35] multipathd: uxlsnr: add timeout
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 10, 2021 at 01:41:17PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Our ppoll() call needs to wake up when a client request times out.
> This logic can be added by determining the first client that's about
> to time out. The logic in handle_client() will then cause a timeout
> reply to be sent to the client. This is more client-friendly
> as the client timing out without receiving a reply.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/uxlsnr.c | 58 +++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 53 insertions(+), 5 deletions(-)
> 
> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index 4637954..1bf4126 100644
> --- a/multipathd/uxlsnr.c
> +++ b/multipathd/uxlsnr.c
> @@ -320,6 +320,35 @@ static void handle_inotify(int fd, struct watch_descriptors *wds)
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
>  static bool __need_lock(void)
> @@ -422,6 +451,24 @@ static void set_client_state(struct client *c, int state)
>  	c->state = state;
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
>  	ssize_t n;
> @@ -435,6 +482,8 @@ static void handle_client(struct client *c, struct vectors *vecs, short revents)
>  		return;
>  	}
>  
> +	check_timeout(c);
> +
>  	condlog(4, "%s: cli[%d] poll=%x state=%d cmd=\"%s\" repl \"%s\"", __func__,
>  		c->fd, revents, c->state, c->cmd, get_strbuf_str(&c->reply));
>  
> @@ -594,6 +643,7 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
>  	while (1) {
>  		struct client *c, *tmp;
>  		int i, n_pfds, poll_count, num_clients;
> +		struct timespec __timeout, *timeout;

Maybe it's just too late to be looking at code, but I'm missing why we
need a separate variable that it a pointer to __timeout.

-Ben

>  
>  		/* setup for a poll */
>  		pthread_mutex_lock(&client_lock);
> @@ -661,10 +711,12 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
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
> @@ -679,10 +731,6 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
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
> 2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

