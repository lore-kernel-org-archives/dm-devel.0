Return-Path: <SRS0=tK5J=PU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C566C433EF
	for <dm-devel@archiver.kernel.org>; Mon,  1 Nov 2021 16:57:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CFC64611ED
	for <dm-devel@archiver.kernel.org>; Mon,  1 Nov 2021 16:57:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CFC64611ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1635785854;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4wPJjUj0TTfzg21pRz4w7+aiAeHXA9HB36o/Mzo3HMk=;
	b=NKZiuuK+i+wJU3AqH/PqVmHwjyrzqleYTobQukfs+w9xvblGgEKxdJDmu2aGv9G2+bMhQw
	72FBz/ddVMaYYKOOk/XYE/32Iy7KdZzMfVQvwGVmTCip0tMknxZwufjd/i2QnnOcKJvGNZ
	bT4pf+UR3rPOBD/DWrImMIwabE4n/Z0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-5JvgbrXIOG2RXv4Lwz31mQ-1; Mon, 01 Nov 2021 12:57:29 -0400
X-MC-Unique: 5JvgbrXIOG2RXv4Lwz31mQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4950A10B3942;
	Mon,  1 Nov 2021 16:57:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 15C6A60C17;
	Mon,  1 Nov 2021 16:57:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9BC1B1806D03;
	Mon,  1 Nov 2021 16:57:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A1Guatm007684 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 1 Nov 2021 12:56:37 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BB2F41121319; Mon,  1 Nov 2021 16:56:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B41961121314
	for <dm-devel@redhat.com>; Mon,  1 Nov 2021 16:56:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30FAB800882
	for <dm-devel@redhat.com>; Mon,  1 Nov 2021 16:56:31 +0000 (UTC)
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
	[209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-383-kczSoo0dPi2bJx_s48ti7Q-1; Mon, 01 Nov 2021 12:56:30 -0400
X-MC-Unique: kczSoo0dPi2bJx_s48ti7Q-1
Received: by mail-qt1-f199.google.com with SMTP id
	w14-20020ac87e8e000000b002ac1791f633so8913017qtj.21
	for <dm-devel@redhat.com>; Mon, 01 Nov 2021 09:56:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=mfuVTEKtPZu4oGKU5CQj62mdS9UTfznANVeOzt6yo5M=;
	b=rmSOC4vrIBBBYt8sqlshhSjMHHslw/HSZLm0/8AjJ9AJBXFr1LVEAuFlPcx9XJh0M5
	gNgdjAK1CIXGm+gyCL6iKxFNWjyd+pMTHlFfkc9KFALB0hOu++UnFZ61jIWlCRZXBHX2
	dMAbvHGwsG0bysHlejCFZWPkR4oRQ73ofyPEpLGpIwtPz78HiqzxvyHUOCMKksugq1+N
	vF6H48J0obhCJ8qPhxnQZTJdwhMsVrB5K9ZXbH2tN2W0L/hbAGSkTc/Qzs1sUg4AJC0V
	80GTDB7SttpkQ6YYWlGVt7bsiZNNoNUng3RewvwbDfIyijUl1OXr1Lf2f9r+1q54Z6HO
	iR+A==
X-Gm-Message-State: AOAM531jKAiefWw60AenXdZQ6YblFfKQO/uYIoTKSWhbnH8Dn5F4ZBRo
	46OGn9AslVj2fmDuf9FRMfq/3hUSUHfPYVbyRDGSNJ4syONe0yJczEhR8cV++yrP4CJhlK2o7BC
	4Asn39nZ9foJl4A==
X-Received: by 2002:a0c:fa07:: with SMTP id q7mr29081306qvn.18.1635785789551; 
	Mon, 01 Nov 2021 09:56:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxh4wJKFaHJKXShFvRsJDDiN/gGiV8SeRubZYTL3eGqZM/PtHnVS+1hVdsIppxoO3JwPYaACw==
X-Received: by 2002:a0c:fa07:: with SMTP id q7mr29081280qvn.18.1635785789312; 
	Mon, 01 Nov 2021 09:56:29 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id i1sm114002qkn.67.2021.11.01.09.56.28
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 01 Nov 2021 09:56:28 -0700 (PDT)
Date: Mon, 1 Nov 2021 12:56:27 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <YYAcO1GAEGK7f3XI@redhat.com>
References: <20211021145918.2691762-1-ming.lei@redhat.com>
	<20211021145918.2691762-4-ming.lei@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20211021145918.2691762-4-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Yi Zhang <yi.zhang@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 3/3] dm: don't stop request queue after the
 dm device is suspended
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Oct 21 2021 at 10:59P -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> For fixing queue quiesce race between driver and block layer(elevator
> switch, update nr_requests, ...), we need to support concurrent quiesce
> and unquiesce, which requires the two call to be balanced.
> 
> __bind() is only called from dm_swap_table() in which dm device has been
> suspended already, so not necessary to stop queue again. With this way,
> request queue quiesce and unquiesce can be balanced.
> 
> Reported-by: Yi Zhang <yi.zhang@redhat.com>
> Fixes: e70feb8b3e68 ("blk-mq: support concurrent queue quiesce/unquiesce")
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/md/dm.c | 10 ----------
>  1 file changed, 10 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 7870e6460633..727282d79b26 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1927,16 +1927,6 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
>  
>  	dm_table_event_callback(t, event_callback, md);
>  
> -	/*
> -	 * The queue hasn't been stopped yet, if the old table type wasn't
> -	 * for request-based during suspension.  So stop it to prevent
> -	 * I/O mapping before resume.
> -	 * This must be done before setting the queue restrictions,
> -	 * because request-based dm may be run just after the setting.
> -	 */
> -	if (request_based)
> -		dm_stop_queue(q);
> -
>  	if (request_based) {
>  		/*
>  		 * Leverage the fact that request-based DM targets are
> -- 
> 2.31.1
> 

I think this is fine given your previous commit (b4459b11e8f dm rq:
don't queue request to blk-mq during DM suspend).

Acked-by: Mike Snitzer <snitzer@redhat.com>

Jens: given this series fixes a 5.16 regression in srp test, please
pick it up for 5.16-rc

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

