Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 180B2C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 25 Nov 2021 01:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637804611;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qZdNB23UhkA5KA5X/LE/FOrp4n7n4eaJemZ5z2z7tXo=;
	b=UVo+rN9cIr9tsnTrN9Jw428eqvRLqicEjA5nVQD37IYIX0s3x/nsjnA8vGRGn1NlbqW57I
	KBC4L5mlfLCysS2Jw3pbHR8CRkvQwJbGGMA1oAwktjZugDP+cqhJYFfwCwx175k7rIEyAD
	FmarRHFPuCk8CRzg+M6+sPVjH5EJwpY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-565-n-FbXS6zP4ibTUi1unRxrw-1; Wed, 24 Nov 2021 20:43:27 -0500
X-MC-Unique: n-FbXS6zP4ibTUi1unRxrw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5132B100C660;
	Thu, 25 Nov 2021 01:43:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 922686929D;
	Thu, 25 Nov 2021 01:43:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 790281809C89;
	Thu, 25 Nov 2021 01:43:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AP1hHmV010165 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Nov 2021 20:43:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 649A94D73A; Thu, 25 Nov 2021 01:43:17 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C95E6929D;
	Thu, 25 Nov 2021 01:43:14 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AP1hBfB023724; 
	Wed, 24 Nov 2021 19:43:11 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AP1hA3N023723;
	Wed, 24 Nov 2021 19:43:10 -0600
Date: Wed, 24 Nov 2021 19:43:10 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20211125014310.GW19591@octiron.msp.redhat.com>
References: <20211118225840.19810-1-mwilck@suse.com>
	<20211118225840.19810-33-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20211118225840.19810-33-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH v2 32/48] multipathd: uxlsnr: use poll loop
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 18, 2021 at 11:58:24PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> send_packet() may busy-loop. By polling for POLLOUT, we can
> avoid that, even if it's very unlikely in practice.
> 

The last time I reviewed this, I mentioned that when we fall through
from CLT_WORK to CLT_SEND, the client hasn't checked for a POLLOUT
revent, so it's possible to block here. I'm not sure that we care.
If not

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/uxlsnr.c | 35 ++++++++++++++++++++++++++---------
>  1 file changed, 26 insertions(+), 9 deletions(-)
> 
> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index 45fe7b5..6213454 100644
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
> @@ -544,16 +543,31 @@ static int client_state_machine(struct client *c, struct vectors *vecs,
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
> @@ -686,6 +700,9 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
>                          case CLT_RECV:
>                                  polls[i].events = POLLIN;
>                                  break;
> +			case CLT_SEND:
> +				polls[i].events = POLLOUT;
> +				break;
>                          default:
>  				/* don't poll for this client */
>                                  continue;
> -- 
> 2.33.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

