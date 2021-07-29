Return-Path: <SRS0=hAiq=MV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BCDBC4338F
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 16:35:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AB1AF60F43
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 16:35:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AB1AF60F43
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1627576509;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Jilz4o6YA7o6Se1AiuR/NmadFtmenP8/79MI3v3LYE0=;
	b=DzijIm/aZLxQusLQKeajoFhWcDO1BVG21bORivlGM/3I+8kjFdH+LJrMjW65lpef13FQwL
	OQvk1+ANQMPDI3lYqKT4Jo8imZmCqRgNDJhCuAyDiOOySGIW5sBqjUquexXWyMne4RTzBX
	DV5EGHoTjSkHKsxKbSfEH2mbe0By3JQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-JUt4oMTROAqd5A2YTjgGng-1; Thu, 29 Jul 2021 12:35:08 -0400
X-MC-Unique: JUt4oMTROAqd5A2YTjgGng-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B04171008061;
	Thu, 29 Jul 2021 16:35:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 919675D9CA;
	Thu, 29 Jul 2021 16:35:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5A00A4BB7C;
	Thu, 29 Jul 2021 16:35:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16TGZ1t6012574 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 29 Jul 2021 12:35:01 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 27770203574C; Thu, 29 Jul 2021 16:35:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 22E5F2033B63
	for <dm-devel@redhat.com>; Thu, 29 Jul 2021 16:34:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52F6389B849
	for <dm-devel@redhat.com>; Thu, 29 Jul 2021 16:34:58 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
	[209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-29-6Z2SwEVpNH2_RdckkIlzOA-1; Thu, 29 Jul 2021 12:34:56 -0400
X-MC-Unique: 6Z2SwEVpNH2_RdckkIlzOA-1
Received: by mail-qk1-f200.google.com with SMTP id
	h5-20020a05620a0525b02903b861bec838so4110509qkh.7
	for <dm-devel@redhat.com>; Thu, 29 Jul 2021 09:34:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=b2IWwV+PjfZiDcM190e0ccbCR/0z9UClDJHKuhIKns0=;
	b=YTIwRnPq5mIUDu7Mx07BDlzhKTQxy1Zri4LLVwexKbKNCI3sd6cUbLqyGBPV3XTJ8p
	OeO1+E1NH1mWEApRaJwyOhZtyp9WZp+wRg28lTzwcY2X/qkjVcrj16WDdJnRQw9XUyRh
	kBXUkPFLO6pSQ+O/EQHi28FXYPFLBOPWo4BihnADaeSnum+vCq0vzoLruQRAIZv4rHHC
	eIS0Lm761wd7A+DYzlGfLvtEN3jcNLtaiwz1bVTtKsTMOOCMQxeCopjFvdEu0md67jK8
	Q7f41ODXC1/nJsPdd/gsn215gWw8cvT/LcXFYuMhIWVyWKjN2UMkZT1d16BC+jG6lRTv
	WLUA==
X-Gm-Message-State: AOAM533GRsy0g3+wLULKrLZfAQW9kUSnDBqkP+//Eub88Fo/KkimWLBu
	uZFtniwFP5degePAWMM1CxviqKKKY3AzjaovmBSq+lPPf3XWckdZfM9kWZ/7CxrxuFVSD1e/8Jf
	W4AREO6S7QRjt7A==
X-Received: by 2002:ac8:7761:: with SMTP id h1mr4912066qtu.159.1627576496376; 
	Thu, 29 Jul 2021 09:34:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyHxljridQsjw0BYRtgO1Mx01oOVyqUfXt1fBaQTGhmMkYIV2eOi47yUtKaP8H2Wj1Qtgd3kg==
X-Received: by 2002:ac8:7761:: with SMTP id h1mr4912050qtu.159.1627576496126; 
	Thu, 29 Jul 2021 09:34:56 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	f12sm1966118qke.37.2021.07.29.09.34.55
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 29 Jul 2021 09:34:55 -0700 (PDT)
Date: Thu, 29 Jul 2021 12:34:54 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YQLYrqxKf3cLBhit@redhat.com>
References: <20210725055458.29008-1-hch@lst.de>
	<20210725055458.29008-7-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210725055458.29008-7-hch@lst.de>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 6/8] dm: move setting md->type into
	dm_setup_md_queue
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, Jul 25 2021 at  1:54P -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Move setting md->type from both callers into dm_setup_md_queue.
> This ensures that md->type is only set to a valid value after the queue
> has been fully setup, something we'll rely on future changes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

> ---
>  drivers/md/dm-ioctl.c | 4 ----
>  drivers/md/dm.c       | 5 +++--
>  2 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index 2209cbcd84db..2575074a2204 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -1436,9 +1436,6 @@ static int table_load(struct file *filp, struct dm_ioctl *param, size_t param_si
>  	}
>  
>  	if (dm_get_md_type(md) == DM_TYPE_NONE) {
> -		/* Initial table load: acquire type of table. */
> -		dm_set_md_type(md, dm_table_get_type(t));
> -
>  		/* setup md->queue to reflect md's type (may block) */
>  		r = dm_setup_md_queue(md, t);
>  		if (r) {
> @@ -2187,7 +2184,6 @@ int __init dm_early_create(struct dm_ioctl *dmi,
>  	if (r)
>  		goto err_destroy_table;
>  
> -	md->type = dm_table_get_type(t);
>  	/* setup md->queue to reflect md's type (may block) */
>  	r = dm_setup_md_queue(md, t);
>  	if (r) {
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 7971ec8ce677..f003bd5b93ce 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2052,9 +2052,9 @@ EXPORT_SYMBOL_GPL(dm_get_queue_limits);
>   */
>  int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
>  {
> -	int r;
> +	enum dm_queue_mode type = dm_table_get_type(t);
>  	struct queue_limits limits;
> -	enum dm_queue_mode type = dm_get_md_type(md);
> +	int r;
>  
>  	switch (type) {
>  	case DM_TYPE_REQUEST_BASED:
> @@ -2081,6 +2081,7 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
>  	r = dm_table_set_restrictions(t, md->queue, &limits);
>  	if (r)
>  		return r;
> +	md->type = type;
>  
>  	blk_register_queue(md->disk);
>  
> -- 
> 2.30.2
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

