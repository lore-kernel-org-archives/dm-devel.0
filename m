Return-Path: <SRS0=tK5J=PU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44AA7C433F5
	for <dm-devel@archiver.kernel.org>; Mon,  1 Nov 2021 16:28:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DF25C61105
	for <dm-devel@archiver.kernel.org>; Mon,  1 Nov 2021 16:28:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DF25C61105
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1635784133;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0VQkgcQC6y3rcdKjNg5BmkD6tCj3O1iLxQLgsIxRkCI=;
	b=Ra58x8qzyS8hpv629C1vTk0k8jOxplTmYO41tBYPMBc+L9XdMtR28XtNsxVmmTO9XciJYl
	agK1SIJI/Sy2CiXWj/QHKV0u79LQrF8xFARouY5veT3ZF5zmm2h5h0EsGAenez678gS8Ir
	IIx4jseLg5QAjDEdff04dztIMgtgZA4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-lfbBE6PGMHadix7J0AnepQ-1; Mon, 01 Nov 2021 12:28:49 -0400
X-MC-Unique: lfbBE6PGMHadix7J0AnepQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2665101F000;
	Mon,  1 Nov 2021 16:28:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CB63510016F5;
	Mon,  1 Nov 2021 16:28:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 51C811806D03;
	Mon,  1 Nov 2021 16:28:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A1GSgji003934 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 1 Nov 2021 12:28:42 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5EDCD40C1252; Mon,  1 Nov 2021 16:28:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B4AF400F3EC
	for <dm-devel@redhat.com>; Mon,  1 Nov 2021 16:28:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4177C8022F4
	for <dm-devel@redhat.com>; Mon,  1 Nov 2021 16:28:42 +0000 (UTC)
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
	[209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-533-kAoPFbYdMFeMBCDZqFuE1Q-1; Mon, 01 Nov 2021 12:28:41 -0400
X-MC-Unique: kAoPFbYdMFeMBCDZqFuE1Q-1
Received: by mail-qt1-f197.google.com with SMTP id
	100-20020aed30ed000000b002a6b3dc6465so12414824qtf.13
	for <dm-devel@redhat.com>; Mon, 01 Nov 2021 09:28:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=vSSeiEsgy4ZRAwPPYMh123Zf4LHs8XHr2NNVii6Qq7o=;
	b=qxfKE7uylJJU+yKRH9nFNlg8+pJIsaPsezt8JfiOsPuMBg4vHBzYg7ihUpaWfd8iB2
	F0pXBDCVBWNoHfUd9F2kpunwpuDTgxG/ZB+uu/25XMW+2JslZrtIgFjNFo68CRWBMqPr
	am7OG9YCFo/tGmxYnAfiNx0vBCyIZ9yoARXHseWunS1+sQ36ao/sNk30x2pVgTPjS4x8
	H7i0S4ogucpvKpO1TjXAJnLJe1Hfmijs/SB3nm1jLFxwwUnLa/e5OaQe67eZvLy3xGtt
	qmyw8sRXSSiHIuriQPWQ0Ltv3F3Qu2X2OsnO3l+bDDg2UYttCTuRWoin+l1OB5MXAqHr
	DEAw==
X-Gm-Message-State: AOAM5323X5X6s8NqQqidfyf2I1FuO78avYoS6zeT+oe4E1fWfz8FNyPv
	2ZUN4JKCMAPb/a/TkoYRpcKVy2AIcVgIhuzBttb6us0W2gXUASdaACys+B6Qn/pJtY/SoEtzx94
	+h2xZuNnJs3LXWw==
X-Received: by 2002:a05:6214:e4a:: with SMTP id
	o10mr29863868qvc.58.1635784120293; 
	Mon, 01 Nov 2021 09:28:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwnnToYfIdlwewHO/8stJwOwIrIwZDJizj1Vl7BOinzg8bNzbcfCyJ9R9K4APUV9a9jX59VOw==
X-Received: by 2002:a05:6214:e4a:: with SMTP id
	o10mr29863844qvc.58.1635784120140; 
	Mon, 01 Nov 2021 09:28:40 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	u185sm10250817qkd.48.2021.11.01.09.28.39
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 01 Nov 2021 09:28:39 -0700 (PDT)
Date: Mon, 1 Nov 2021 12:28:38 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YYAVtv6kiqVHDjQH@redhat.com>
References: <20211018044054.1779424-1-hch@lst.de>
	<20211018044054.1779424-4-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211018044054.1779424-4-hch@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, linux-s390@vger.kernel.org,
	linux-erofs@lists.ozlabs.org, virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
	linux-ext4@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] [PATCH 03/11] dax: simplify the dax_device <->
 gendisk association
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

On Mon, Oct 18 2021 at 12:40P -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Replace the dax_host_hash with an xarray indexed by the pointer value
> of the gendisk, and require explicitl calls from the block drivers that
> want to associate their gendisk with a dax_device.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

...

> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 79737aee516b1..a0a4703620650 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1683,6 +1683,7 @@ static void cleanup_mapped_device(struct mapped_device *md)
>  	bioset_exit(&md->io_bs);
>  
>  	if (md->dax_dev) {
> +		dax_remove_host(md->disk);
>  		kill_dax(md->dax_dev);
>  		put_dax(md->dax_dev);
>  		md->dax_dev = NULL;
> @@ -1784,10 +1785,11 @@ static struct mapped_device *alloc_dev(int minor)
>  	sprintf(md->disk->disk_name, "dm-%d", minor);
>  
>  	if (IS_ENABLED(CONFIG_FS_DAX)) {
> -		md->dax_dev = alloc_dax(md, md->disk->disk_name,
> -					&dm_dax_ops, 0);
> +		md->dax_dev = alloc_dax(md, &dm_dax_ops, 0);
>  		if (IS_ERR(md->dax_dev))
>  			goto bad;
> +		if (dax_add_host(md->dax_dev, md->disk))
> +			goto bad;
>  	}
>  
>  	format_dev_t(md->name, MKDEV(_major, minor));

Acked-by: Mike Snitzer <snitzer@redhat.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

