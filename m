Return-Path: <SRS0=t70f=OG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21ACBC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 02:17:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BF7AB611C6
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 02:17:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BF7AB611C6
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1631758650;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WH23cCZcyZsIZ/8d0oXl4UyWmt3ZTrOfOjCT1txRJ6g=;
	b=WRP5zu3uGqRVgVvCQpHx8tCTfjh0INffR27l7Z4+ABUFu4BkmCxDpIhGxbuU3NZohiC0TQ
	XWiyiuVzW/kfPce11wZIM3PkQGBbQtq2bQnmZwkct51NNBpa1siyDWCQMswyK71Oq3sbtU
	Z4YpZGH0fzqVlCkMighBYT/vlvX/JAo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-XcdDhQ8gM6G_K7yGqZ3Pvg-1; Wed, 15 Sep 2021 22:17:29 -0400
X-MC-Unique: XcdDhQ8gM6G_K7yGqZ3Pvg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A60B11006AA0;
	Thu, 16 Sep 2021 02:17:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 507C810074FD;
	Thu, 16 Sep 2021 02:17:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CEE06180142F;
	Thu, 16 Sep 2021 02:17:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18G2HHb6027618 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 15 Sep 2021 22:17:17 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E54825D9D3; Thu, 16 Sep 2021 02:17:17 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8AF655D9F4;
	Thu, 16 Sep 2021 02:17:13 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 18G2HB7E007324; 
	Wed, 15 Sep 2021 21:17:11 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 18G2HAP7007323;
	Wed, 15 Sep 2021 21:17:10 -0500
Date: Wed, 15 Sep 2021 21:17:10 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210916021709.GA3087@octiron.msp.redhat.com>
References: <20210910114120.13665-1-mwilck@suse.com>
	<20210910114120.13665-16-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210910114120.13665-16-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH 15/35] multipathd: uxlsnr: avoid stalled
 clients during reconfigure
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 10, 2021 at 01:41:00PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Since 47cc1d3 ("multipathd: fix client response for socket
> activation"), we hold back clients while reconfigure is running.
> The idea of 47cc1d3 was to fix the behavior during initial
> start up. When multipathd reconfigures itself during runtime,
> and the reconfiguration takes a long time (a minute or more is
> not unusual in big configurations), clients will time out with
> no response ("timeout receiving packet"). Waiting for reconfigure
> to finish breaks our timeout handling.
> 
> Therefore we should only apply the logic of 47cc1d3 during initial
> configuration. In this case, the client that triggered socket
> activation may still encounter a timeout, but there's not much we can
> do about that.
> 
> Fixes: 47cc1d3 ("multipathd: fix client response for socket activation")
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c   |  9 +++++++++
>  multipathd/uxlsnr.c | 12 ------------
>  2 files changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 6d7c8c9..c6357ef 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1695,6 +1695,15 @@ uxlsnrloop (void * ap)
>  
>  	init_handler_callbacks();
>  	umask(077);
> +
> +	/*
> +	 * Wait for initial reconfiguration to finish, while
> +	 * hadling signals
> +	 */
> +	while (wait_for_state_change_if(DAEMON_CONFIGURE, 50)
> +	       == DAEMON_CONFIGURE)
> +		handle_signals(false);
> +
>  	uxsock_listen(&uxsock_trigger, ux_sock, ap);
>  
>  out_sock:
> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index dbee0d6..20efbd3 100644
> --- a/multipathd/uxlsnr.c
> +++ b/multipathd/uxlsnr.c
> @@ -391,18 +391,6 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
>  			continue;
>  		}
>  
> -		/*
> -		 * Client connection. We shouldn't answer while we're
> -		 * configuring - nothing may be configured yet.
> -		 * But we can't wait forever either, because this thread
> -		 * must handle signals. So wait a short while only.
> -		 */
> -		if (wait_for_state_change_if(DAEMON_CONFIGURE, 10)
> -		    == DAEMON_CONFIGURE) {
> -			handle_signals(false);
> -			continue;
> -		}
> -
>  		/* see if a client wants to speak to us */
>  		for (i = POLLFDS_BASE; i < n_pfds; i++) {
>  			if (polls[i].revents & POLLIN) {
> -- 
> 2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

