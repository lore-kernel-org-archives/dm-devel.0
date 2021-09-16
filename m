Return-Path: <SRS0=t70f=OG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1F0BC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 02:18:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5B745611CA
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 02:18:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5B745611CA
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1631758703;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LiDPv7CxPNDDg8g+wWkHcMBinpVqALKuKASyJrmjbWM=;
	b=ZEn+5OrVnMujKI8E4Hkz3XkJMYAy2kiDT1wSf1rHic/RObii5dc/J9G4K13JGmZ+t1fadV
	f2PBe/yAW3APtyvsAcfMTOMGWh2v8Qbz9s4dF4TO/uYKLSPyYYwwJGiZtpkxM81IoFcF0i
	i3FZ2DysrvyhtSRZHTLyvRfykF4tSH4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-xQPsngPDPJeHHwhCyddDXQ-1; Wed, 15 Sep 2021 22:18:21 -0400
X-MC-Unique: xQPsngPDPJeHHwhCyddDXQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 859DE802B9F;
	Thu, 16 Sep 2021 02:18:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D24F6B555;
	Thu, 16 Sep 2021 02:18:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AECE54E58F;
	Thu, 16 Sep 2021 02:18:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18G2IEWJ027668 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 15 Sep 2021 22:18:14 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C8877100E107; Thu, 16 Sep 2021 02:18:14 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C8FC10016FF;
	Thu, 16 Sep 2021 02:18:11 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 18G2I9d9007337; 
	Wed, 15 Sep 2021 21:18:09 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 18G2I9Jj007336;
	Wed, 15 Sep 2021 21:18:09 -0500
Date: Wed, 15 Sep 2021 21:18:08 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210916021808.GC3087@octiron.msp.redhat.com>
References: <20210910114120.13665-1-mwilck@suse.com>
	<20210910114120.13665-18-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210910114120.13665-18-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH 17/35] multipathd: uxlsnr: use symbolic
 values for pollfd indices
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

On Fri, Sep 10, 2021 at 01:41:02PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Avoid hardcoding the indices as 0, 1, 2...
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/uxlsnr.c | 25 +++++++++++++++----------
>  1 file changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index 7e88538..6506109 100644
> --- a/multipathd/uxlsnr.c
> +++ b/multipathd/uxlsnr.c
> @@ -46,8 +46,13 @@ struct client {
>  	int fd;
>  };
>  
> -/* The number of fds we poll on, other than individual client connections */
> -#define POLLFDS_BASE 2
> +/* Indices for array of poll fds */
> +enum {
> +	POLLFD_UX = 0,
> +	POLLFD_NOTIFY,
> +	POLLFDS_BASE,
> +};
> +
>  #define POLLFD_CHUNK (4096 / sizeof(struct pollfd))
>  /* Minimum mumber of pollfds to reserve for clients */
>  #define MIN_POLLS (POLLFD_CHUNK - POLLFDS_BASE)
> @@ -339,8 +344,8 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
>  			}
>  		}
>  		if (num_clients < MAX_CLIENTS) {
> -			polls[0].fd = ux_sock;
> -			polls[0].events = POLLIN;
> +			polls[POLLFD_UX].fd = ux_sock;
> +			polls[POLLFD_UX].events = POLLIN;
>  		} else {
>  			/*
>  			 * New clients can't connect, num_clients won't grow
> @@ -348,15 +353,15 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
>  			 */
>  			condlog(1, "%s: max client connections reached, pausing polling",
>  				__func__);
> -			polls[0].fd = -1;
> +			polls[POLLFD_UX].fd = -1;
>  		}
>  
>  		reset_watch(notify_fd, &wds, &sequence_nr);
>  		if (notify_fd == -1 || (wds.conf_wd == -1 && wds.dir_wd == -1))
> -			polls[1].fd = -1;
> +			polls[POLLFD_NOTIFY].fd = -1;
>  		else
> -			polls[1].fd = notify_fd;
> -		polls[1].events = POLLIN;
> +			polls[POLLFD_NOTIFY].fd = notify_fd;
> +		polls[POLLFD_NOTIFY].events = POLLIN;
>  
>  		/* setup the clients */
>  		i = POLLFDS_BASE;
> @@ -454,12 +459,12 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
>  		handle_signals(true);
>  
>  		/* see if we got a new client */
> -		if (polls[0].revents & POLLIN) {
> +		if (polls[POLLFD_UX].revents & POLLIN) {
>  			new_client(ux_sock);
>  		}
>  
>  		/* handle inotify events on config files */
> -		if (polls[1].revents & POLLIN)
> +		if (polls[POLLFD_NOTIFY].revents & POLLIN)
>  			handle_inotify(notify_fd, &wds);
>  	}
>  
> -- 
> 2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

