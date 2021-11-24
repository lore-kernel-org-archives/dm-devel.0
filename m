Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D92E1C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 24 Nov 2021 23:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637797735;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NhWF3m4xrKJEKAs+Wa2vVdP0DxzQy1PF/PC61nGEzb0=;
	b=AL/hsF4f6NFs8A9pz49SrA9UiW9OWjuOWJDJQDpgASBtjKcSVHtDdi8sgo3QcEcDLEb56C
	O7vU3ll46ReJdmnQFcFKxJHytS3UPlQY11I4zHGU1f1rmSQRGWapRFI0h00brBLB9iJR9h
	abwyzqcF4MrAXMY8I45hw+9g/1GY1sY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-193-zgacFvUOOAuziTtLTGdVSw-1; Wed, 24 Nov 2021 18:48:52 -0500
X-MC-Unique: zgacFvUOOAuziTtLTGdVSw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E17985B660;
	Wed, 24 Nov 2021 23:48:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 560D360C05;
	Wed, 24 Nov 2021 23:48:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 213B51809C89;
	Wed, 24 Nov 2021 23:48:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AONmgaa000670 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Nov 2021 18:48:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C0F7E67840; Wed, 24 Nov 2021 23:48:42 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4EF156C335;
	Wed, 24 Nov 2021 23:48:36 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AONmUk6023153; 
	Wed, 24 Nov 2021 17:48:30 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AONmSv8023152;
	Wed, 24 Nov 2021 17:48:28 -0600
Date: Wed, 24 Nov 2021 17:48:28 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20211124234828.GS19591@octiron.msp.redhat.com>
References: <20211118225840.19810-1-mwilck@suse.com>
	<20211118225840.19810-30-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20211118225840.19810-30-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH v2 29/48] multipathd: uxlsnr: merge
 uxsock_trigger() into state machine
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

On Thu, Nov 18, 2021 at 11:58:21PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> This patch sets up the bulk of the state machine. client_state_machine()
> is called in a loop, proceeding from state to state until it needs
> to poll for input or wait for a lock, in which case it returns
> STM_BREAK.
> 
> While doing this, switch to negative error codes for the functions
> in uxlsnr.c (e.g. parse_cmd()). Positive return codes are reserved
> for the cli_handler functions themselves. This way we can clearly
> distinguish the error source, and avoid confusion and misleading
> error messages. No cli_handler returns negative values.
> 
> Note: with this patch applied, clients may hang and time out if
> the handler fails to acquire the vecs lock. This will be fixed in the
> follow-up patch "multipathd: uxlsnr: add idle notification".
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/uxlsnr.c | 160 ++++++++++++++++++++++++--------------------
>  1 file changed, 89 insertions(+), 71 deletions(-)
> 
> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index ff9604f..87134d5 100644
> --- a/multipathd/uxlsnr.c
> +++ b/multipathd/uxlsnr.c
> @@ -299,22 +299,13 @@ static int parse_cmd(struct client *c)
>  
>  	r = get_cmdvec(c->cmd, &c->cmdvec);
>  
> -	if (r) {
> -		genhelp_handler(c->cmd, r, &c->reply);
> -		if (get_strbuf_len(&c->reply) == 0)
> -			return EINVAL;
> -		return 0;
> -	}
> +	if (r)
> +		return -r;
>  
>  	c->handler = find_handler_for_cmdvec(c->cmdvec);
>  
> -	if (!c->handler || !c->handler->fn) {
> -		genhelp_handler(c->cmd, EINVAL, &c->reply);
> -		if (get_strbuf_len(&c->reply) == 0)
> -			r = EINVAL;
> -		else
> -			r = 0;
> -	}
> +	if (!c->handler || !c->handler->fn)
> +		return -EINVAL;
>  
>  	return r;
>  }
> @@ -325,7 +316,7 @@ static int execute_handler(struct client *c, struct vectors *vecs, int timeout)
>  	struct timespec tmo;
>  
>  	if (!c->handler)
> -		return EINVAL;
> +		return -EINVAL;
>  
>  	if (clock_gettime(CLOCK_REALTIME, &tmo) == 0) {
>  		tmo.tv_sec += timeout;
> @@ -355,50 +346,30 @@ static int execute_handler(struct client *c, struct vectors *vecs, int timeout)
>  	return r;
>  }
>  
> -static int uxsock_trigger(struct client *c, void *trigger_data)
> +void default_reply(struct client *c, int r)
>  {
> -	struct vectors * vecs;
> -	int r = 1;
> -
> -	vecs = (struct vectors *)trigger_data;
> -
> -	r = parse_cmd(c);
> -
> -	if (r == 0 && c->cmdvec && VECTOR_SIZE(c->cmdvec) > 0) {
> -		struct key *kw = VECTOR_SLOT(c->cmdvec, 0);
> -
> -		if (!c->is_root && kw->code != LIST)
> -			r = EPERM;
> -	}
> -
> -	if (r == 0 && c->handler)
> -		r = execute_handler(c, vecs, uxsock_timeout / 1000);
> -
> -	if (c->cmdvec) {
> -		free_keys(c->cmdvec);
> -		c->cmdvec = NULL;
> -	}
> -
> -	if (r > 0) {
> -		switch(r) {
> -		case ETIMEDOUT:
> -			append_strbuf_str(&c->reply, "timeout\n");
> -			break;
> -		case EPERM:
> -			append_strbuf_str(&c->reply,
> -					  "permission deny: need to be root\n");
> -			break;
> -		default:
> -			append_strbuf_str(&c->reply, "fail\n");
> -			break;
> -		}
> -	}
> -	else if (!r && get_strbuf_len(&c->reply) == 0) {
> +	switch(r) {
> +	case -EINVAL:
> +	case -ESRCH:
> +	case -ENOMEM:
> +		/* return codes from get_cmdvec() */
> +		genhelp_handler(c->cmd, -r, &c->reply);
> +		break;
> +	case -EPERM:
> +		append_strbuf_str(&c->reply,
> +				  "permission deny: need to be root\n");
> +		break;
> +	case -ETIMEDOUT:
> +		append_strbuf_str(&c->reply, "timeout\n");
> +		break;
> +	case 0:
>  		append_strbuf_str(&c->reply, "ok\n");
> -		r = 0;
> +		break;
> +	default:
> +		/* cli_handler functions return 1 on unspecified error */
> +		append_strbuf_str(&c->reply, "fail\n");
> +		break;
>  	}
> -	/* else if (r < 0) leave *reply alone */
> -	return r;
>  }
>  
>  static void set_client_state(struct client *c, int state)
> @@ -409,6 +380,7 @@ static void set_client_state(struct client *c, int state)
>  		reset_strbuf(&c->reply);
>  		memset(c->cmd, '\0', sizeof(c->cmd));
>  		c->expires = ts_zero;
> +		c->error = 0;
>  		/* fallthrough */
>  	case CLT_SEND:
>  		/* reuse these fields for next data transfer */
> @@ -420,11 +392,20 @@ static void set_client_state(struct client *c, int state)
>  	c->state = state;
>  }
>  
> -static void handle_client(struct client *c, void *trigger_data)
> +enum {
> +	STM_CONT,
> +	STM_BREAK,
> +};
> +
> +static int client_state_machine(struct client *c, struct vectors *vecs)
>  {
>  	ssize_t n;
> +	const char *buf;
>  
> -	switch (c->state) {
> +	condlog(4, "%s: cli[%d] state=%d cmd=\"%s\" repl \"%s\"", __func__,
> +		c->fd, c->state, c->cmd, get_strbuf_str(&c->reply));
> +
> +        switch (c->state) {
>  	case CLT_RECV:
>  		if (c->cmd_len == 0) {
>  			/*
> @@ -449,31 +430,59 @@ static void handle_client(struct client *c, void *trigger_data)
>  				condlog(4, "%s: cli[%d]: connected", __func__, c->fd);
>  			}
>  			/* poll for data */
> -			return;
> +			return STM_BREAK;
>  		} else if (c->len < c->cmd_len) {
>  			n = recv(c->fd, c->cmd + c->len, c->cmd_len - c->len, 0);
>  			if (n <= 0 && errno != EINTR && errno != EAGAIN) {
>  				condlog(1, "%s: cli[%d]: error in recv: %m",
>  					__func__, c->fd);
>  				c->error = -ECONNRESET;
> -				return;
> +				return STM_BREAK;
>  			}
>  			c->len += n;
>  			if (c->len < c->cmd_len)
>  				/* continue polling */
> -				return;
> -			set_client_state(c, CLT_PARSE);
> +				return STM_BREAK;
>  		}
> -		break;
> -	default:
> -		break;
> -	}
> +		condlog(4, "cli[%d]: Got request [%s]", c->fd, c->cmd);
> +		set_client_state(c, CLT_PARSE);
> +		return STM_CONT;
>  
> -	condlog(4, "cli[%d]: Got request [%s]", c->fd, c->cmd);
> -	uxsock_trigger(c, trigger_data);
> +	case CLT_PARSE:
> +		c->error = parse_cmd(c);
> +		if (!c->error) {
> +			/* Permission check */
> +			struct key *kw = VECTOR_SLOT(c->cmdvec, 0);
>  
> -	if (get_strbuf_len(&c->reply) > 0) {
> -		const char *buf = get_strbuf_str(&c->reply);
> +			if (!c->is_root && kw->code != LIST) {
> +				c->error = -EPERM;
> +				condlog(0, "%s: cli[%d]: unauthorized cmd \"%s\"",
> +					__func__, c->fd, c->cmd);
> +			}
> +		}
> +		if (c->error)
> +			set_client_state(c, CLT_SEND);
> +		else
> +			set_client_state(c, CLT_WORK);
> +		return STM_CONT;
> +
> +	case CLT_WAIT_LOCK:
> +		/* tbd */
> +		set_client_state(c, CLT_WORK);
> +		return STM_CONT;
> +
> +	case CLT_WORK:
> +		c->error = execute_handler(c, vecs, uxsock_timeout / 1000);
> +		free_keys(c->cmdvec);
> +		c->cmdvec = NULL;
> +		set_client_state(c, CLT_SEND);
> +		return STM_CONT;
> +
> +	case CLT_SEND:
> +		if (get_strbuf_len(&c->reply) == 0)
> +			default_reply(c, c->error);
> +
> +		buf = get_strbuf_str(&c->reply);
>  
>  		if (send_packet(c->fd, buf) != 0)
>  			dead_client(c);
> @@ -481,9 +490,18 @@ static void handle_client(struct client *c, void *trigger_data)
>  			condlog(4, "cli[%d]: Reply [%zu bytes]", c->fd,
>  				get_strbuf_len(&c->reply) + 1);
>  		reset_strbuf(&c->reply);
> -	}
>  
> -	set_client_state(c, CLT_RECV);
> +		set_client_state(c, CLT_RECV);
> +		return STM_BREAK;
> +
> +	default:
> +		return STM_BREAK;
> +	}
> +}
> +
> +static void handle_client(struct client *c, struct vectors *vecs)
> +{
> +	while (client_state_machine(c, vecs) == STM_CONT);
>  }
>  
>  /*
> -- 
> 2.33.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

