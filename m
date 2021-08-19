Return-Path: <SRS0=6+Yd=NK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20975C4338F
	for <dm-devel@archiver.kernel.org>; Thu, 19 Aug 2021 22:09:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C9AC960FDA
	for <dm-devel@archiver.kernel.org>; Thu, 19 Aug 2021 22:09:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C9AC960FDA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1629410940;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7a77Z0mHKlIzJpVqnP+wXVtXObfqzIjM7BAcfMXNFA0=;
	b=XdLOPEz0jCgSL4ILV3ogOexPaq0oNaO9HgHdsdAZsyCTOX3TH2eJImxElwy81l6JCMzdQ8
	Vu6ngdWiEneKYmT06UwmyxOcIBZTCHxxcvnarkfWxRSx6Dk+99gT77CEVCWA6qa+2GMEED
	9lPQycvxTriYIVjgUtRpj2fXS3gII+E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-vlNuKDmsPFKeb4ty4erX-g-1; Thu, 19 Aug 2021 18:08:57 -0400
X-MC-Unique: vlNuKDmsPFKeb4ty4erX-g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F01C48799E0;
	Thu, 19 Aug 2021 22:08:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 49C805C3E0;
	Thu, 19 Aug 2021 22:08:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7F574181A0F8;
	Thu, 19 Aug 2021 22:08:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17JM8kIB025444 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Aug 2021 18:08:46 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3008C107665; Thu, 19 Aug 2021 22:08:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2985810728D
	for <dm-devel@redhat.com>; Thu, 19 Aug 2021 22:08:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F41548007BB
	for <dm-devel@redhat.com>; Thu, 19 Aug 2021 22:08:39 +0000 (UTC)
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
	[209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-46-RPL6su2bOsih49u9eYPUuA-1; Thu, 19 Aug 2021 18:08:38 -0400
X-MC-Unique: RPL6su2bOsih49u9eYPUuA-1
Received: by mail-qv1-f70.google.com with SMTP id
	u8-20020a0cec880000b029035825559ec4so5491325qvo.22
	for <dm-devel@redhat.com>; Thu, 19 Aug 2021 15:08:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=xkspXG8hxbvDqLFevLus8MJ8WZKNmd5YtLC8hca/MbA=;
	b=kAu4k0Ez53xsa0rZF6mTTwJdrKR7FXNNdKP9YDiO0qjU+CU6HFVudeUHyjS1Fu4AVx
	me8gKNydecPGrpJu+uCjrpN7vQ+kzwSH8nsF0EoZe7HbqdUgoJvhBLd6eBVYKDx9sdj4
	SrYa5sxPn1nwW6gIJUbdEfcDjiNR6E3gBvCN9Se2C+xUQO9ZP8rYzIDgqat7bVz4AWhF
	c5cF3bAw47sQ3IDLEru3tUOJ94qX6zfWD43kbyXdMOwfbagLf5Kg96ENVYObwDJftnIO
	NJxUmj6M2j3BlJpp5+fHM7q8WWWdVc7KRZ089m72NIoZ1PFrImolsavBcOAdg103isTg
	YlCA==
X-Gm-Message-State: AOAM530XDgvnPTuFuRrCef7z817QCHHlrUviVDhO9YJGAouKexB43Ag1
	qVfO+ZQNrVDyJvzTfjdPyZBUCcWKLDbrPhbKvy6H0GuUKq0eIJy3T4UyK4HDHcnVOtGxKn9Ge+W
	KiWWw7ZuKCS/DEw==
X-Received: by 2002:a05:6214:aa8:: with SMTP id
	ew8mr16900250qvb.43.1629410918166; 
	Thu, 19 Aug 2021 15:08:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJywm4rLEeaipm0n2jLzSiRC/vpgsoEKNvs8yaeY/GnmilqaKXYkZjRRVU1i4zcMh9j7mDyFlg==
X-Received: by 2002:a05:6214:aa8:: with SMTP id
	ew8mr16900225qvb.43.1629410917907; 
	Thu, 19 Aug 2021 15:08:37 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	s185sm2291159qkd.2.2021.08.19.15.08.37
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 19 Aug 2021 15:08:37 -0700 (PDT)
Date: Thu, 19 Aug 2021 18:08:36 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YR7WZEZgxw6hI369@redhat.com>
References: <20210804094147.459763-1-hch@lst.de> <YR5/wMEkr1TwV7FD@redhat.com>
	<20210819180559.GA14001@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210819180559.GA14001@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Tushar Sugandhi <tusharsu@linux.microsoft.com>
Subject: Re: [dm-devel] holders not working properly,
 regression [was: Re: use regular gendisk registration in device
 mapper v2]
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Aug 19 2021 at  2:05P -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Manually reverting "block: remove the extra kobject reference in
> bd_link_disk_holder" as show below fixed the issue for me.  I'll spend
> some more time tomorrow trying to fully understan the life time rules
> tomorrow before sending a patch, though.
> 
> ---
> From 6b94f5435900d23769db8d07ff47415aab4ac63e Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Thu, 19 Aug 2021 20:01:43 +0200
> Subject: Revert "block: remove the extra kobject reference in
>  bd_link_disk_holder"
> 
> This reverts commit fbd9a39542ecdd2ade55869c13856b2590db3df8.
> ---
>  block/holder.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/block/holder.c b/block/holder.c
> index 4568cc4f6827..ecbc6941e7d8 100644
> --- a/block/holder.c
> +++ b/block/holder.c
> @@ -106,6 +106,12 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
>  	}
>  
>  	list_add(&holder->list, &disk->slave_bdevs);
> +	/*
> +	 * bdev could be deleted beneath us which would implicitly destroy
> +	 * the holder directory.  Hold on to it.
> +	 */
> +	kobject_get(bdev->bd_holder_dir);
> +
>  out_unlock:
>  	mutex_unlock(&disk->open_mutex);
>  	return ret;
> @@ -138,6 +144,7 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
>  	if (!WARN_ON_ONCE(holder == NULL) && !--holder->refcnt) {
>  		if (disk->slave_dir)
>  			__unlink_disk_holder(bdev, disk);
> +		kobject_put(bdev->bd_holder_dir);
>  		list_del_init(&holder->list);
>  		kfree(holder);
>  	}
> -- 
> 2.30.2
> 

OK, this fixed it for me too, thanks.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

