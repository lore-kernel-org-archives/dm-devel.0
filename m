Return-Path: <SRS0=t70f=OG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96D92C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 02:31:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0DFA360FC0
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 02:31:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0DFA360FC0
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1631759515;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rLXHNoCybCg3FcvEkjj3WsPKyAiZtXBoqY8SdrSeH6c=;
	b=diIS5iLVztjAuGuWg0WDHufjox6oTnvUKQ0L3bN2TrM9Mb2yWTf5GWbcfDt0A5IVOTTJeH
	+HIZmQwz/SplOYi+j5Z7UhaZ6nnBt9horRQUpSaji3ZyRZg8LqMI1AZK3/wX+QZ0Vbm0sR
	xhV7/SwdVqPn7Ii1c+3N9O5SmeRJKoc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-SINLQsjeMM-fZdAB-By1JQ-1; Wed, 15 Sep 2021 22:31:53 -0400
X-MC-Unique: SINLQsjeMM-fZdAB-By1JQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0EF58362FB;
	Thu, 16 Sep 2021 02:31:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B1AC65D9CA;
	Thu, 16 Sep 2021 02:31:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4889E4EA2A;
	Thu, 16 Sep 2021 02:31:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18G2T5Di028500 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 15 Sep 2021 22:29:05 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CA53D5C1D1; Thu, 16 Sep 2021 02:29:05 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A5C255C1C5;
	Thu, 16 Sep 2021 02:29:01 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 18G2Sxtg007421; 
	Wed, 15 Sep 2021 21:29:00 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 18G2SxMZ007420;
	Wed, 15 Sep 2021 21:28:59 -0500
Date: Wed, 15 Sep 2021 21:28:59 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210916022859.GN3087@octiron.msp.redhat.com>
References: <20210910114120.13665-1-mwilck@suse.com>
	<20210910114120.13665-29-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210910114120.13665-29-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH 28/35] multipathd: uxlsnr: move handler
 execution to separate function
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 10, 2021 at 01:41:13PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Move the actual execution of the handler out of parse_cmd(). For now,
> we do it in uxsock_trigger().
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/uxlsnr.c | 47 ++++++++++++++++++++++++++++-----------------
>  1 file changed, 29 insertions(+), 18 deletions(-)
> 
> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index 65cb5ca..cfff0ae 100644
> --- a/multipathd/uxlsnr.c
> +++ b/multipathd/uxlsnr.c
> @@ -293,11 +293,9 @@ static void handle_inotify(int fd, struct watch_descriptors *wds)
>  
>  static const struct timespec ts_zero = { .tv_sec = 0, };
>  
> -static int parse_cmd (struct client *c, void *data, int timeout)
> +static int parse_cmd(struct client *c)
>  {
>  	int r;
> -	struct handler * h;
> -	struct timespec tmo;
>  
>  	r = get_cmdvec(c->cmd, &c->cmdvec);
>  
> @@ -308,26 +306,35 @@ static int parse_cmd (struct client *c, void *data, int timeout)
>  		return 0;
>  	}
>  
> -	h = find_handler_for_cmdvec(c->cmdvec);
> +	c->handler = find_handler_for_cmdvec(c->cmdvec);
>  
> -	if (!h || !h->fn) {
> +	if (!c->handler || !c->handler->fn) {
>  		genhelp_handler(c->cmd, EINVAL, &c->reply);
>  		if (get_strbuf_len(&c->reply) == 0)
>  			r = EINVAL;
> -		goto free_cmdvec;
> +		else
> +			r = 0;
>  	}
>  
> -	/*
> -	 * execute handler
> -	 */
> +	return r;
> +}
> +
> +static int execute_handler(struct client *c, struct vectors *vecs, int timeout)
> +{
> +	int r;
> +	struct timespec tmo;
> +
> +	if (!c->handler)
> +		return EINVAL;
> +
>  	if (clock_gettime(CLOCK_REALTIME, &tmo) == 0) {
>  		tmo.tv_sec += timeout;
>  	} else {
>  		tmo.tv_sec = 0;
>  	}
> -	if (h->locked) {
> +
> +	if (c->handler->locked) {
>  		int locked = 0;
> -		struct vectors * vecs = (struct vectors *)data;
>  
>  		pthread_cleanup_push(cleanup_lock, &vecs->lock);
>  		if (tmo.tv_sec) {
> @@ -339,15 +346,11 @@ static int parse_cmd (struct client *c, void *data, int timeout)
>  		if (r == 0) {
>  			locked = 1;
>  			pthread_testcancel();
> -			r = h->fn(c->cmdvec, &c->reply, data);
> +			r = c->handler->fn(c->cmdvec, &c->reply, vecs);
>  		}
>  		pthread_cleanup_pop(locked);
>  	} else
> -		r = h->fn(c->cmdvec, &c->reply, data);
> -
> -free_cmdvec:
> -	free_keys(c->cmdvec);
> -	c->cmdvec = NULL;
> +		r = c->handler->fn(c->cmdvec, &c->reply, vecs);
>  
>  	return r;
>  }
> @@ -367,7 +370,15 @@ static int uxsock_trigger(struct client *c, void *trigger_data)
>  		return r;
>  	}
>  
> -	r = parse_cmd(c, vecs, uxsock_timeout / 1000);
> +	r = parse_cmd(c);
> +
> +	if (r == 0 && c->handler)
> +		r = execute_handler(c, vecs, uxsock_timeout / 1000);
> +
> +	if (c->cmdvec) {
> +		free_keys(c->cmdvec);
> +		c->cmdvec = NULL;
> +	}
>  
>  	if (r > 0) {
>  		if (r == ETIMEDOUT)
> -- 
> 2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

