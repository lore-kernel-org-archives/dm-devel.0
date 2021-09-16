Return-Path: <SRS0=t70f=OG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3927C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 03:32:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4AAFD611C8
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 03:32:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4AAFD611C8
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1631763175;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9Qd3/oeDF778tIGZxsdV8X5DjsaVqo5u1shRznMitHQ=;
	b=iL4HPoDAW8tvaalYB6HfemgHNvUWXtJ5Ks7LbtSlPqt76ixmOrsIXegWZlBOIiPhwGGxuz
	mqgMHXRsqjSvDYPOKhpIZ96/jL7jPuMd1HMtdrwcjqMwXP+s3h/V++3cLOH06bCTcsYYzd
	3DtM5pK8kQsISBcp78QxJe/gqJTxxrA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-fHO0dW3fNjqhcj8Rc2EYCg-1; Wed, 15 Sep 2021 23:32:53 -0400
X-MC-Unique: fHO0dW3fNjqhcj8Rc2EYCg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A626D362F9;
	Thu, 16 Sep 2021 03:32:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A6E8360583;
	Thu, 16 Sep 2021 03:32:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 14D474E58F;
	Thu, 16 Sep 2021 03:32:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18G3Witr000795 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 15 Sep 2021 23:32:44 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4F0C55C25A; Thu, 16 Sep 2021 03:32:44 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 00BAC5C1A1;
	Thu, 16 Sep 2021 03:32:39 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 18G3WcmK007675; 
	Wed, 15 Sep 2021 22:32:38 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 18G3Wbil007674;
	Wed, 15 Sep 2021 22:32:37 -0500
Date: Wed, 15 Sep 2021 22:32:37 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210916033237.GP3087@octiron.msp.redhat.com>
References: <20210910114120.13665-1-mwilck@suse.com>
	<20210910114120.13665-31-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210910114120.13665-31-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH 30/35] multipathd: uxlsnr: merge
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 10, 2021 at 01:41:15PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> This patch sets up the bulk of the state machine. The idea is to
> fall through the case labels as long as possible (when steps succeed)
> and return to the caller if either an error occurs, or it becomes
> necessary to wait for some pollable condition.
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
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/uxlsnr.c | 145 ++++++++++++++++++++++++--------------------
>  1 file changed, 80 insertions(+), 65 deletions(-)
> 
> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index ff9604f..553274b 100644
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
> @@ -355,50 +346,29 @@ static int execute_handler(struct client *c, struct vectors *vecs, int timeout)
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

get_cmdvec() returns positive errors and do_genhelp() expects positive
errors, but this expects negative errors.

> +		/* return codes from get_cmdvec() */
> +		genhelp_handler(c->cmd, r, &c->reply);
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
> +		append_strbuf_str(&c->reply, "fail\n");
> +		break;
>  	}
> -	/* else if (r < 0) leave *reply alone */
> -	return r;
>  }
>  
>  static void set_client_state(struct client *c, int state)
> @@ -409,6 +379,7 @@ static void set_client_state(struct client *c, int state)
>  		reset_strbuf(&c->reply);
>  		memset(c->cmd, '\0', sizeof(c->cmd));
>  		c->expires = ts_zero;
> +		c->error = 0;
>  		/* fallthrough */
>  	case CLT_SEND:
>  		/* reuse these fields for next data transfer */
> @@ -420,10 +391,13 @@ static void set_client_state(struct client *c, int state)
>  	c->state = state;
>  }
>  
> -static void handle_client(struct client *c, void *trigger_data)
> +static void handle_client(struct client *c, struct vectors *vecs)
>  {
>  	ssize_t n;
>  
> +	condlog(4, "%s: cli[%d] state=%d cmd=\"%s\" repl \"%s\"", __func__,
> +		c->fd, c->state, c->cmd, get_strbuf_str(&c->reply));
> +
>  	switch (c->state) {
>  	case CLT_RECV:
>  		if (c->cmd_len == 0) {
> @@ -464,15 +438,52 @@ static void handle_client(struct client *c, void *trigger_data)
>  				return;
>  			set_client_state(c, CLT_PARSE);
>  		}
> -		break;
> -	default:
> -		break;
> -	}
> +		condlog(4, "cli[%d]: Got request [%s]", c->fd, c->cmd);
> +		/* fallthrough */
>  
> -	condlog(4, "cli[%d]: Got request [%s]", c->fd, c->cmd);
> -	uxsock_trigger(c, trigger_data);
> +	case CLT_PARSE:

Since you already print this information at the top of the function, it
seems liek it would make more sense to put these prints before the
followthroughs, so that they get double printed immediately when the
function is called for devices not in CLT_RECV.

> +		condlog(4, "%s: cli[%d] state=%d cmd=\"%s\" repl \"%s\"", __func__,
> +			c->fd, c->state, c->cmd,  get_strbuf_str(&c->reply));
> +		c->error = parse_cmd(c);
> +
> +		/* Permission check */
> +		if (c->error == 0 && c->cmdvec && VECTOR_SIZE(c->cmdvec) > 0) {
> +			struct key *kw = VECTOR_SLOT(c->cmdvec, 0);
> +
> +			if (!c->is_root && kw->code != LIST) {
> +				/* this will fall through to CLT_SEND */
> +				c->error = -EPERM;
> +				condlog(0, "%s: cli[%d]: unauthorized cmd \"%s\"",
> +					__func__, c->fd, c->cmd);
> +			}
> +		}
> +		set_client_state(c, CLT_WAIT_LOCK);

I don't have strong feelings about this, but this state machine doesn't
want to always fall through. sometimes, like if you get -EPERM, you want
to swith from CLT_PARSE to CLT_SEND.  If instead of fallthroughs, you
just put the switch statement in a loop, and simply returned when you
wanted to break out to uxsock_listen, you could jump from any state to
any other state, and wouldn't need to have code to skip the actions of
some states, to enable the follow throughs. Just a thought.

-Ben

> +		/* fallthrough */
> +
> +	case CLT_WAIT_LOCK:
> +		condlog(4, "%s: cli[%d] state=%d cmd=\"%s\" repl \"%s\"", __func__,
> +			c->fd, c->state, c->cmd, get_strbuf_str(&c->reply));
> +		/* tbd */
> +		set_client_state(c, CLT_WORK);
> +		/* fallthrough */
> +
> +	case CLT_WORK:
> +		condlog(4, "%s: cli[%d] state=%d cmd=\"%s\" repl \"%s\"", __func__,
> +			c->fd, c->state, c->cmd, get_strbuf_str(&c->reply));
> +		if (c->error == 0 && c->handler)
> +			c->error = execute_handler(c, vecs, uxsock_timeout / 1000);
> +
> +		if (c->cmdvec) {
> +			free_keys(c->cmdvec);
> +			c->cmdvec = NULL;
> +		}
> +		set_client_state(c, CLT_SEND);
> +		/* fallthrough */
> +
> +	case CLT_SEND:
> +		if (get_strbuf_len(&c->reply) == 0)
> +			default_reply(c, c->error);
>  
> -	if (get_strbuf_len(&c->reply) > 0) {
>  		const char *buf = get_strbuf_str(&c->reply);
>  
>  		if (send_packet(c->fd, buf) != 0)
> @@ -481,9 +492,13 @@ static void handle_client(struct client *c, void *trigger_data)
>  			condlog(4, "cli[%d]: Reply [%zu bytes]", c->fd,
>  				get_strbuf_len(&c->reply) + 1);
>  		reset_strbuf(&c->reply);
> -	}
>  
> -	set_client_state(c, CLT_RECV);
> +		set_client_state(c, CLT_RECV);
> +		break;
> +
> +	default:
> +		break;
> +	}
>  }
>  
>  /*
> -- 
> 2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

