Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E4C8C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 29 Nov 2021 20:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1638217771;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=e0wzt/bfgQNUO11msJqbzCJvTnRWxgswCyai7Ii2PXY=;
	b=Cs7OeIyKO/BPaEhhBjBz0zOd6EvWjnziFX8KuGWZA3xpuWm5xNapUjpmp91LiaPB5/ju+j
	bM19wGtlbK2Osjt9i++9lQKKXAz1LYqJfT29FEiALnVc9Y5UBSZD53uRaDyqkAXXwI1kcD
	LBVMAYLTbltf/LXoSA94yoNeNiyo/OY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-333-a8XV-qS8Nc6YMwiIAwz63g-1; Mon, 29 Nov 2021 15:29:27 -0500
X-MC-Unique: a8XV-qS8Nc6YMwiIAwz63g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 592FB1006AA4;
	Mon, 29 Nov 2021 20:29:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F37A419729;
	Mon, 29 Nov 2021 20:29:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0459B4A700;
	Mon, 29 Nov 2021 20:29:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ATKTKH9003649 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Nov 2021 15:29:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 92B5610114AE; Mon, 29 Nov 2021 20:29:20 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 59F44100EBAD;
	Mon, 29 Nov 2021 20:29:11 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1ATKT96L022395; 
	Mon, 29 Nov 2021 14:29:09 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1ATKT9Jt022394;
	Mon, 29 Nov 2021 14:29:09 -0600
Date: Mon, 29 Nov 2021 14:29:08 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20211129202908.GF19591@octiron.msp.redhat.com>
References: <20211127151929.7727-1-mwilck@suse.com>
	<20211127151929.7727-34-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20211127151929.7727-34-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH v3 32/35] multipathd: uxlsnr: use poll loop
 for sending, too
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

On Sat, Nov 27, 2021 at 04:19:26PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> send_packet() may busy-loop. By polling for POLLOUT, we can
> avoid that, even if it's very unlikely in practice.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipathd/uxlsnr.c | 41 ++++++++++++++++++++++++++++++-----------
>  1 file changed, 30 insertions(+), 11 deletions(-)
> 
> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index 1ebcf10..c5da569 100644
> --- a/multipathd/uxlsnr.c
> +++ b/multipathd/uxlsnr.c
> @@ -447,7 +447,6 @@ static int client_state_machine(struct client *c, struct vectors *vecs,
>  				short revents)
>  {
>  	ssize_t n;
> -	const char *buf;
>  
>  	condlog(4, "%s: cli[%d] poll=%x state=%d cmd=\"%s\" repl \"%s\"", __func__,
>  		c->fd, revents, c->state, c->cmd, get_strbuf_str(&c->reply));
> @@ -527,7 +526,8 @@ static int client_state_machine(struct client *c, struct vectors *vecs,
>  			free_keys(c->cmdvec);
>  			c->cmdvec = NULL;
>  			set_client_state(c, CLT_SEND);
> -			return STM_CONT;
> +			/* Wait for POLLOUT */
> +			return STM_BREAK;
>  		} else {
>  			condlog(4, "%s: cli[%d] waiting for lock", __func__, c->fd);
>  			return STM_BREAK;
> @@ -538,22 +538,38 @@ static int client_state_machine(struct client *c, struct vectors *vecs,
>  		free_keys(c->cmdvec);
>  		c->cmdvec = NULL;
>  		set_client_state(c, CLT_SEND);
> -		return STM_CONT;
> +		/* Wait for POLLOUT */
> +		return STM_BREAK;
>  
>  	case CLT_SEND:
>  		if (get_strbuf_len(&c->reply) == 0)
>  			default_reply(c, c->error);
>  
> -		buf = get_strbuf_str(&c->reply);
> +		if (c->cmd_len == 0) {
> +			size_t len = get_strbuf_len(&c->reply) + 1;
>  
> -		if (send_packet(c->fd, buf) != 0)
> -			dead_client(c);
> -		else
> -			condlog(4, "cli[%d]: Reply [%zu bytes]", c->fd,
> -				get_strbuf_len(&c->reply) + 1);
> -		reset_strbuf(&c->reply);
> +			if (send(c->fd, &len, sizeof(len), MSG_NOSIGNAL)
> +			    != sizeof(len))
> +				c->error = -ECONNRESET;
> +			c->cmd_len = len;
> +			return STM_BREAK;
> +		}
>  
> -		set_client_state(c, CLT_RECV);
> +		if (c->len < c->cmd_len) {
> +			const char *buf = get_strbuf_str(&c->reply);
> +
> +			n = send(c->fd, buf + c->len, c->cmd_len, MSG_NOSIGNAL);
> +			if (n == -1) {
> +				if (!(errno == EAGAIN || errno == EINTR))
> +					c->error = -ECONNRESET;
> +			} else
> +				c->len += n;
> +		}
> +
> +                if (c->len >= c->cmd_len) {
> +			condlog(4, "cli[%d]: Reply [%zu bytes]", c->fd, c->cmd_len);
> +			set_client_state(c, CLT_RECV);
> +		}
>  		return STM_BREAK;
>  
>  	default:
> @@ -687,6 +703,9 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
>  			case CLT_RECV:
>  				polls[i].events = POLLIN;
>  				break;
> +			case CLT_SEND:
> +				polls[i].events = POLLOUT;
> +				break;
>  			default:
>  				/* don't poll for this client */
>  				continue;
> -- 
> 2.33.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

