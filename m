Return-Path: <SRS0=hAiq=MV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60710C4338F
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 16:34:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0CDAE60F0F
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 16:34:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0CDAE60F0F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1627576454;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=50WZV1ChcgvcdK89dqUkvencWzdUmF5USsWJkmaZwj0=;
	b=XMmxjWeBPZnmzxuWG5OPETxWtwc3jHZkZRgAVbaokmzV98f+/fNhHPAWcF6rpEFTCLtaRs
	qeJraDsZ6KjdKgMPXuP259SXJBsEgXJoMiEdm/9tWd11W5vGCXppH7VPias+BPpETn+hd/
	14N7yRSnb8AM+l8MhPwkNER0XjHASIU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-rYXdOTxKPX-CaE8qlLi7Ug-1; Thu, 29 Jul 2021 12:34:12 -0400
X-MC-Unique: rYXdOTxKPX-CaE8qlLi7Ug-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48A1A1008063;
	Thu, 29 Jul 2021 16:34:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E2CA60875;
	Thu, 29 Jul 2021 16:34:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E71F0180B7A2;
	Thu, 29 Jul 2021 16:34:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16TGY51g012463 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 29 Jul 2021 12:34:05 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7604C11E5C7; Thu, 29 Jul 2021 16:34:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 710D311E5BD
	for <dm-devel@redhat.com>; Thu, 29 Jul 2021 16:34:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6859866DFB
	for <dm-devel@redhat.com>; Thu, 29 Jul 2021 16:34:02 +0000 (UTC)
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
	[209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-559-sQWOzXlBNPitc1XPBmXsYQ-1; Thu, 29 Jul 2021 12:34:01 -0400
X-MC-Unique: sQWOzXlBNPitc1XPBmXsYQ-1
Received: by mail-qv1-f72.google.com with SMTP id
	15-20020a0562140dcfb02902e558bb7a04so4193171qvt.10
	for <dm-devel@redhat.com>; Thu, 29 Jul 2021 09:34:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=DgXxi6D01R6oKUlD2nkhQCbT4XAjmQsHUMsVJ3OLl1M=;
	b=D4qWbtdfS2U/jetEdfoDof00/98wN3hTzAJN6WZpWsnD3MTN9ReyyOh2dse3OBRIMV
	6vNW9tCK6PYwr9/hckS0Mtx9CbLGIKLJI6/VMMA4z+NwJUbM8AUZOSBPV2ayUTPeFBXB
	mBJhn8TgnRfrhaYQT6GPDUI8rirvGNPf9PhKGZq3wSMqEJ7JJmreFoENJ9TRGBaqTmRs
	hLecyxm0+t34NfDgsVGKN5fBJT0qjzg9bct7tpHMWcHVidgO9hOWwYZr5edBr/vNGQgF
	lfXIKJTxm0PybU7jePbBBdXG/XGxotu77myohhzMmdjEluAurwuZeORIxPDmo+/wluXM
	yiog==
X-Gm-Message-State: AOAM533fslnWaMD1zLObN7clh/8B7PZyhyemKe85UcDc2FoP6FrFjULL
	ZIdWrjg7jc8YTyixl6l6ADZy2LvI65XlyegckC9P7EAcu1luPEvvff1GdzqJFoW4iyR9fCkuLCR
	JOn176ueDKj2vjQ==
X-Received: by 2002:a05:6214:3a4:: with SMTP id
	m4mr6063687qvy.17.1627576440739; 
	Thu, 29 Jul 2021 09:34:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxv1S4jWuxGbYYg+j5zXIOLgd53p4g7zvBIyfaJi4vITOLDVn0ErbgJkGs/edEleml6VmwnIQ==
X-Received: by 2002:a05:6214:3a4:: with SMTP id
	m4mr6063679qvy.17.1627576440600; 
	Thu, 29 Jul 2021 09:34:00 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	e12sm1951965qkm.65.2021.07.29.09.34.00
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 29 Jul 2021 09:34:00 -0700 (PDT)
Date: Thu, 29 Jul 2021 12:33:59 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YQLYd2DKQIVVWtuQ@redhat.com>
References: <20210725055458.29008-1-hch@lst.de>
	<20210725055458.29008-6-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210725055458.29008-6-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 5/8] dm: cleanup cleanup_mapped_device
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, Jul 25 2021 at  1:54P -0400,
Christoph Hellwig <hch@lst.de> wrote:

> md->queue is not always set when md->disk is set, so simplify the
> conditionas a bit.

s/not/now/
s/conditionas/conditionals/

>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

> ---
>  drivers/md/dm.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 2c5f9e585211..7971ec8ce677 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1694,13 +1694,9 @@ static void cleanup_mapped_device(struct mapped_device *md)
>  		md->disk->private_data = NULL;
>  		spin_unlock(&_minor_lock);
>  		del_gendisk(md->disk);
> -	}
> -
> -	if (md->queue)
>  		dm_queue_destroy_keyslot_manager(md->queue);
> -
> -	if (md->disk)
>  		blk_cleanup_disk(md->disk);
> +	}
>  
>  	cleanup_srcu_struct(&md->io_barrier);
>  
> -- 
> 2.30.2
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

