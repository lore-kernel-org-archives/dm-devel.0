Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74567C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 25 Nov 2021 01:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637805276;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0U5VZ5Viydw6q0t/PPgaiy7/oDab+dGIecdKT8uaUD0=;
	b=QGqfE/5ZxyYPVNt703UUZeyApsnmg62k56RDQTayJpbIgGTPI/Y01k4VcdM0mrjpwQGPnl
	gl+h7iYrgr9Am0OT9bh1eQhjJGsS2Hho8G6RshRCwMBGXRMfeTtJE93sXesnDlxiDLfWEB
	UntyR6OGTKSfToPHZ5itP3aegLMKwR8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-OMAGjOcvNWuOiWBmMeaixg-1; Wed, 24 Nov 2021 20:54:33 -0500
X-MC-Unique: OMAGjOcvNWuOiWBmMeaixg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A2FD1006AA0;
	Thu, 25 Nov 2021 01:54:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9EE945445B;
	Thu, 25 Nov 2021 01:54:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 212DF1809C89;
	Thu, 25 Nov 2021 01:54:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AP1sQCZ010784 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Nov 2021 20:54:26 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8FA5E1970F; Thu, 25 Nov 2021 01:54:26 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C8BAD19730;
	Thu, 25 Nov 2021 01:54:21 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AP1sJGP023746; 
	Wed, 24 Nov 2021 19:54:20 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AP1sJYG023745;
	Wed, 24 Nov 2021 19:54:19 -0600
Date: Wed, 24 Nov 2021 19:54:19 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20211125015419.GY19591@octiron.msp.redhat.com>
References: <20211118225840.19810-1-mwilck@suse.com>
	<20211118225840.19810-36-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20211118225840.19810-36-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH v2 35/48] multipathd: uxlsnr: use recv() for
 command length
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

On Thu, Nov 18, 2021 at 11:58:27PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> If the peer uses libmpathcmd, we can be certain that the first
> 8 bytes are being sent in a single chunk of data. It's overkill
> to try and receive the command length byte-by-byte.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/uxlsnr.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index 24db377..6355279 100644
> --- a/multipathd/uxlsnr.c
> +++ b/multipathd/uxlsnr.c
> @@ -441,6 +441,7 @@ static int client_state_machine(struct client *c, struct vectors *vecs,
>  		if (!(revents & POLLIN))
>  			return STM_BREAK;
>  		if (c->cmd_len == 0) {
> +			size_t len;
>  			/*
>  			 * We got POLLIN; assume that at least the length can
>  			 * be read immediately.
> @@ -449,17 +450,17 @@ static int client_state_machine(struct client *c, struct vectors *vecs,
>  			c->expires.tv_sec += uxsock_timeout / 1000;
>  			c->expires.tv_nsec += (uxsock_timeout % 1000) * 1000000;
>  			normalize_timespec(&c->expires);
> -			n = mpath_recv_reply_len(c->fd, 0);
> -			if (n == -1) {
> -				condlog(1, "%s: cli[%d]: failed to receive reply len",
> -					__func__, c->fd);
> -				c->error = -ECONNRESET;
> -			} else if (n > _MAX_CMD_LEN) {
> -				condlog(1, "%s: cli[%d]: overlong command (%zd bytes)",
> +			n = recv(c->fd, &len, sizeof(len), 0);
> +			if (n < (ssize_t)sizeof(len)) {
> +				condlog(1, "%s: cli[%d]: failed to receive reply len: %zd",
>  					__func__, c->fd, n);
>  				c->error = -ECONNRESET;
> +			} else if (len <= 0 || len > _MAX_CMD_LEN) {
> +				condlog(1, "%s: cli[%d]: invalid command length (%zu bytes)",
> +					__func__, c->fd, len);
> +				c->error = -ECONNRESET;
>  			} else {
> -				c->cmd_len = n;
> +				c->cmd_len = len;
>  				condlog(4, "%s: cli[%d]: connected", __func__, c->fd);
>  			}
>  			/* poll for data */
> -- 
> 2.33.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

