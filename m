Return-Path: <SRS0=YUkt=HE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89D15C433DB
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 22:24:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F08AC64F64
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 22:24:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F08AC64F64
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1612304696;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pmmNL+uf7QP7SBac3hZc+r7RGbYu3BZYwrq6LiFbfCg=;
	b=FyyCCnqmZkgTZabh7y17pGflVjoWHEIpvg5y3MsonlOTcoA3kFzYgPYKMXuCZYR1zoM0Ta
	tmDd9fGEcWngLP+63HkALhgBIK/5gVp/Oz7dPhPfbCIGpC0IZF7F25uRkLm7oMAxedY4yM
	Rx2owGYKzu8MNwetIjrxTCmhfUuzsgk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-NAI-lsbzN4G2SbmlTLGo7A-1; Tue, 02 Feb 2021 17:24:53 -0500
X-MC-Unique: NAI-lsbzN4G2SbmlTLGo7A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69F1C1934101;
	Tue,  2 Feb 2021 22:24:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DB1155C224;
	Tue,  2 Feb 2021 22:24:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 085044E58E;
	Tue,  2 Feb 2021 22:24:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 112MNvH5023212 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Feb 2021 17:23:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 64D2C5D9E8; Tue,  2 Feb 2021 22:23:57 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 500605D9E3;
	Tue,  2 Feb 2021 22:23:54 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 112MNq97010939; 
	Tue, 2 Feb 2021 16:23:52 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 112MNpoV010938;
	Tue, 2 Feb 2021 16:23:51 -0600
Date: Tue, 2 Feb 2021 16:23:51 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210202222351.GX15006@octiron.msp.redhat.com>
References: <20210128210852.23207-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210128210852.23207-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] multipathd: avoid crash in uevent_cleanup()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Thu, Jan 28, 2021 at 10:08:52PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Crashes have been observed in the unwinder stack of uevent_listen().
> This can only be explained by "udev" not being a valid object at that
> time. Be sure to pass a valid pointer, and don't call udev_unref() if
> it has been set to NULL already.
> 
> I'm not quite sure how this would come to pass, as we join the threads
> before setting udev to NULL, but this is unwinder code, so I guess it
> might actually be executed after the thread has terminated.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Assuming that this does resolve the issue,

Reviewed-by: Benjamin Marzinski <bmaizns@redhat.com>
> ---
>  libmultipath/uevent.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
> index d3061bf..4e662ff 100644
> --- a/libmultipath/uevent.c
> +++ b/libmultipath/uevent.c
> @@ -397,10 +397,11 @@ service_uevq(struct list_head *tmpq)
>  
>  static void uevent_cleanup(void *arg)
>  {
> -	struct udev *udev = arg;
> +	struct udev **pudev = arg;
>  
> +	if (*pudev)
> +		udev_unref(*pudev);
>  	condlog(3, "Releasing uevent_listen() resources");
> -	udev_unref(udev);
>  }
>  
>  static void monitor_cleanup(void *arg)
> @@ -560,7 +561,7 @@ int uevent_listen(struct udev *udev)
>  		return 1;
>  	}
>  	udev_ref(udev);
> -	pthread_cleanup_push(uevent_cleanup, udev);
> +	pthread_cleanup_push(uevent_cleanup, &udev);
>  
>  	monitor = udev_monitor_new_from_netlink(udev, "udev");
>  	if (!monitor) {
> -- 
> 2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

