Return-Path: <SRS0=t70f=OG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7DD4C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 02:17:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4CBEB611EE
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 02:17:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4CBEB611EE
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1631758677;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5wZeIkxtDbuJOWvIhDQzI1KoQpUlwBJ1xVayZLKMPS4=;
	b=CscQ0EYkHgdkvGZH0nMaQODw6OQwhXxLcZarx9rFgxMr4smVWLnqUFH3pnZwZKMbaSecNK
	3VAdheZGnqxOvFAdlRUCgEE0u50sf6VxFLuRpZUlIYfWhMcpyoRzzya0Xe6/6G+g7xO9g4
	ZPlW/J6gF+yhEvjQJs3ZryydFERAX+k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-599-__-c9367OYeD2R7y1hHYwQ-1; Wed, 15 Sep 2021 22:17:55 -0400
X-MC-Unique: __-c9367OYeD2R7y1hHYwQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C872800FF4;
	Thu, 16 Sep 2021 02:17:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 497466B555;
	Thu, 16 Sep 2021 02:17:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 201B31803B30;
	Thu, 16 Sep 2021 02:17:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18G2Ho2f027646 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 15 Sep 2021 22:17:50 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3BDF2604CC; Thu, 16 Sep 2021 02:17:50 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7277760583;
	Thu, 16 Sep 2021 02:17:47 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 18G2HiBY007330; 
	Wed, 15 Sep 2021 21:17:44 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 18G2Hiue007329;
	Wed, 15 Sep 2021 21:17:44 -0500
Date: Wed, 15 Sep 2021 21:17:44 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210916021744.GB3087@octiron.msp.redhat.com>
References: <20210910114120.13665-1-mwilck@suse.com>
	<20210910114120.13665-17-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210910114120.13665-17-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH 16/35] multipathd: uxlsnr: handle client HUP
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

On Fri, Sep 10, 2021 at 01:41:01PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> The unix socket listener thread doesn't even look at the revents
> returned by poll() while the daemon is configuring. This may cause a
> closed client socket to be kept open for a long time by the server,
> while the listener basically performs a busy loop, as ppoll() always
> returns immediately as long as the POLLHUP condition exists.
> 
> Worse, it can happen that multipathd reads data from such a closed
> client socket after the client has disconnected. See the description
> of POLLHUP in poll(2).
> 
> Close connections immediately if HUP is received.
> 
> Also, use the fd in log messages to identify the client rather
> than the random index.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/uxlsnr.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index 20efbd3..7e88538 100644
> --- a/multipathd/uxlsnr.c
> +++ b/multipathd/uxlsnr.c
> @@ -393,7 +393,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
>  
>  		/* see if a client wants to speak to us */
>  		for (i = POLLFDS_BASE; i < n_pfds; i++) {
> -			if (polls[i].revents & POLLIN) {
> +			if (polls[i].revents & (POLLIN|POLLHUP|POLLERR)) {
>  				struct timespec start_time;
>  
>  				c = NULL;
> @@ -410,6 +410,12 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
>  						i, polls[i].fd);
>  					continue;
>  				}
> +				if (polls[i].revents & (POLLHUP|POLLERR)) {
> +					condlog(4, "cli[%d]: Disconnected",
> +						c->fd);
> +					dead_client(c);
> +					continue;
> +				}
>  				get_monotonic_time(&start_time);
>  				if (recv_packet_from_client(c->fd, &inbuf,
>  							    uxsock_timeout)
> @@ -423,7 +429,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
>  					continue;
>  				}
>  				condlog(4, "cli[%d]: Got request [%s]",
> -					i, inbuf);
> +					polls[i].fd, inbuf);
>  				uxsock_trigger(inbuf, &reply, &rlen,
>  					       _socket_client_is_root(c->fd),
>  					       trigger_data);
> @@ -434,7 +440,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
>  					} else {
>  						condlog(4, "cli[%d]: "
>  							"Reply [%d bytes]",
> -							i, rlen);
> +							polls[i].fd, rlen);
>  					}
>  					FREE(reply);
>  					reply = NULL;
> -- 
> 2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

