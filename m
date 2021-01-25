Return-Path: <SRS0=BcWr=G4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87296C433E0
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 21:46:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0BF092083E
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 21:46:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0BF092083E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1611611194;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tmk8UaoXfOvFTDnjxVORmYrWW4gtI8BwmuV8NB74jFk=;
	b=C3JwOMUOB03wSEzDqg4HRIkTFbkMcPSMNkQCsQ3nZNEg6BWuo4E6jaEHcZvvuhLw5MUU/B
	fKwJK/b3fl8+3+6jDnAmCMXQcz9zQrZEtKQsPDjHB/SkC0B4qwJB+PgtZ4eQ0blvPdNhqV
	78K02mJ1vNZEJMXPEobUtaVtAtEcxEs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-F7eeYHL8P1CreNLEH2qNWw-1; Mon, 25 Jan 2021 16:46:32 -0500
X-MC-Unique: F7eeYHL8P1CreNLEH2qNWw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98AABCC630;
	Mon, 25 Jan 2021 21:46:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 60D0A6315F;
	Mon, 25 Jan 2021 21:46:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 14E014BB7B;
	Mon, 25 Jan 2021 21:46:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10PLkAiU029591 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 25 Jan 2021 16:46:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3DE905D6DC; Mon, 25 Jan 2021 21:46:10 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D5DD15D6AB;
	Mon, 25 Jan 2021 21:46:09 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 10PLk8bn005324; 
	Mon, 25 Jan 2021 15:46:08 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 10PLk6rq005323;
	Mon, 25 Jan 2021 15:46:06 -0600
Date: Mon, 25 Jan 2021 15:46:06 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210125214606.GD15006@octiron.msp.redhat.com>
References: <20210125152304.28024-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210125152304.28024-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] libmultipath: snprint_devices(): avoid NULL
	dereference
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

On Mon, Jan 25, 2021 at 04:23:04PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> All libudev functions may return NULL. Watch out for it.
> 
> Fixes: d041258 ("libmultipath: snprint_devices(): use udev_enumerate"
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/print.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index 19de2c7..8151e11 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -2055,8 +2055,16 @@ int snprint_devices(struct config *conf, char *buff, size_t len,
>  		struct udev_device *u_dev;
>  
>  		path = udev_list_entry_get_name(item);
> +		if (!path)
> +			continue;
>  		u_dev = udev_device_new_from_syspath(udev, path);
> +		if (!u_dev)
> +			continue;
>  		devname = udev_device_get_sysname(u_dev);
> +		if (!devname) {
> +			udev_device_unref(u_dev);
> +			continue;
> +		}
>  
>  		fwd += snprintf(buff + fwd, len - fwd, "    %s", devname);
>  		if (fwd >= len)
> -- 
> 2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

