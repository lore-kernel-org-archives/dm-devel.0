Return-Path: <SRS0=hAiq=MV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E79C6C4338F
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 16:37:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7764860F43
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 16:37:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7764860F43
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1627576649;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nXZs8zJrQ0HDoQailyftDAVAdfS5KrxSr8xKlX1xK00=;
	b=Dc0OwMtNIGfw54IiRnQZ3qnQQf9LV6cdPEAQ4+z1igreUCGIng/6N4sjAJXCwp+6kd8Kam
	9/Px5Y8IkOKXALnESIQketTRzGZcmr1EqlPEz93GK0O49d4ApwVfsm/o2ujVZgtNCKorZk
	Vgr8/qYj2aCU1mAqRHGyma7WxOKL4nY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-E3F-rAAiP-mJc7roDJHepw-1; Thu, 29 Jul 2021 12:37:27 -0400
X-MC-Unique: E3F-rAAiP-mJc7roDJHepw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5C34801AE7;
	Thu, 29 Jul 2021 16:37:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8986F5C1D1;
	Thu, 29 Jul 2021 16:37:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5579F180B7A2;
	Thu, 29 Jul 2021 16:37:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16TGbLil012865 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 29 Jul 2021 12:37:21 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2D47D20B6626; Thu, 29 Jul 2021 16:37:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2695720B662F
	for <dm-devel@redhat.com>; Thu, 29 Jul 2021 16:37:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C6E8389C7DC
	for <dm-devel@redhat.com>; Thu, 29 Jul 2021 16:37:15 +0000 (UTC)
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
	[209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-403-jjInh58lMVyvJ7FVWXkHtA-1; Thu, 29 Jul 2021 12:37:14 -0400
X-MC-Unique: jjInh58lMVyvJ7FVWXkHtA-1
Received: by mail-qk1-f199.google.com with SMTP id
	b9-20020a05620a1269b02903b8bd5c7d95so4113546qkl.12
	for <dm-devel@redhat.com>; Thu, 29 Jul 2021 09:37:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=1RSuBssQi+q7cm+z6CE0tczu7IpqjYbm4lf0fu8TZ1I=;
	b=OOewXsP6qDzEuwI5Z/b6iS1LhxENAYh3rRUpPJzmOS3WnhyB4Huc/5ifhgwdCokyi9
	iUyQCj8nuKuZu/qavVgFePtULj6I6yTUWZaL389Ury9Wb1wg0oV8xQM5S9LiH1NDkdql
	BbxHhAc4IHxjy8/Lp2Xju69r6X5eKj0xMe/u+pRNcUyWOZqeqVKMOggdETAbWpARRrxI
	B/FfkkSwLV36j70kGSfJIPzaniRX130MUINN+Cn+djcFSN1qn4rZl1lhbUdKrg09NV8m
	hIAgySm5oV/GkkxPLDx6Th+KHDRD9fO8zB8L6IbnUFGiW1BcfCdOXj8EpOVsZpw8OhjS
	AYQA==
X-Gm-Message-State: AOAM530GgA7YlMdyehme/0W4SYysxQ0udrLUnPPOzaXR9Ev4oXwM628u
	XQYW0RVRcAGuNiJFVCMRJngZxzY9lIK/2W9lycOREBxsS1kAyee1J9zFAYahoyFNol/xpg6QLfY
	jJB35e/KDRJJHjg==
X-Received: by 2002:a05:620a:140a:: with SMTP id
	d10mr6139105qkj.171.1627576633983; 
	Thu, 29 Jul 2021 09:37:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzc0wxWpfaIl7vXBoFkjNjlCwXG9APADqkFM5GGd2jrBukPuBRpblzl0nmz+pSqYXMAlreiLg==
X-Received: by 2002:a05:620a:140a:: with SMTP id
	d10mr6139092qkj.171.1627576633830; 
	Thu, 29 Jul 2021 09:37:13 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id m3sm2010655qkk.0.2021.07.29.09.37.13
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 29 Jul 2021 09:37:13 -0700 (PDT)
Date: Thu, 29 Jul 2021 12:37:12 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YQLZOMfbV0BCkMsJ@redhat.com>
References: <20210725055458.29008-1-hch@lst.de>
	<20210725055458.29008-9-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210725055458.29008-9-hch@lst.de>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 8/8] block: remove support for delayed queue
	registrations
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

On Sun, Jul 25 2021 at  1:54P -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Now that device mapper has been changed to register the disk once
> it is fully ready all this code is unused.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Mike Snitzer <snitzer@redhat.com>


> ---
>  block/elevator.c      |  1 -
>  block/genhd.c         | 29 +++++++----------------------
>  include/linux/genhd.h |  6 ------
>  3 files changed, 7 insertions(+), 29 deletions(-)
> 
> diff --git a/block/elevator.c b/block/elevator.c
> index 52ada14cfe45..706d5a64508d 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -702,7 +702,6 @@ void elevator_init_mq(struct request_queue *q)
>  		elevator_put(e);
>  	}
>  }
> -EXPORT_SYMBOL_GPL(elevator_init_mq); /* only for dm-rq */
>  
>  /*
>   * switch to new_e io scheduler. be careful not to introduce deadlocks -
> diff --git a/block/genhd.c b/block/genhd.c
> index e3d93b868ec5..3cd9f165a5a7 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -457,20 +457,20 @@ static void register_disk(struct device *parent, struct gendisk *disk,
>  }
>  
>  /**
> - * __device_add_disk - add disk information to kernel list
> + * device_add_disk - add disk information to kernel list
>   * @parent: parent device for the disk
>   * @disk: per-device partitioning information
>   * @groups: Additional per-device sysfs groups
> - * @register_queue: register the queue if set to true
>   *
>   * This function registers the partitioning information in @disk
>   * with the kernel.
>   *
>   * FIXME: error handling
>   */
> -static void __device_add_disk(struct device *parent, struct gendisk *disk,
> -			      const struct attribute_group **groups,
> -			      bool register_queue)
> +
> +void device_add_disk(struct device *parent, struct gendisk *disk,
> +		     const struct attribute_group **groups)
> +
>  {
>  	int ret;
>  
> @@ -480,8 +480,7 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
>  	 * elevator if one is needed, that is, for devices requesting queue
>  	 * registration.
>  	 */
> -	if (register_queue)
> -		elevator_init_mq(disk->queue);
> +	elevator_init_mq(disk->queue);
>  
>  	/*
>  	 * If the driver provides an explicit major number it also must provide
> @@ -535,8 +534,7 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
>  		bdev_add(disk->part0, dev->devt);
>  	}
>  	register_disk(parent, disk, groups);
> -	if (register_queue)
> -		blk_register_queue(disk);
> +	blk_register_queue(disk);
>  
>  	/*
>  	 * Take an extra ref on queue which will be put on disk_release()
> @@ -550,21 +548,8 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
>  	disk_add_events(disk);
>  	blk_integrity_add(disk);
>  }
> -
> -void device_add_disk(struct device *parent, struct gendisk *disk,
> -		     const struct attribute_group **groups)
> -
> -{
> -	__device_add_disk(parent, disk, groups, true);
> -}
>  EXPORT_SYMBOL(device_add_disk);
>  
> -void device_add_disk_no_queue_reg(struct device *parent, struct gendisk *disk)
> -{
> -	__device_add_disk(parent, disk, NULL, false);
> -}
> -EXPORT_SYMBOL(device_add_disk_no_queue_reg);
> -
>  /**
>   * del_gendisk - remove the gendisk
>   * @disk: the struct gendisk to remove
> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> index dd95d53c75fa..fbc4bf269f63 100644
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -218,12 +218,6 @@ static inline void add_disk(struct gendisk *disk)
>  {
>  	device_add_disk(NULL, disk, NULL);
>  }
> -extern void device_add_disk_no_queue_reg(struct device *parent, struct gendisk *disk);
> -static inline void add_disk_no_queue_reg(struct gendisk *disk)
> -{
> -	device_add_disk_no_queue_reg(NULL, disk);
> -}
> -
>  extern void del_gendisk(struct gendisk *gp);
>  
>  void set_disk_ro(struct gendisk *disk, bool read_only);
> -- 
> 2.30.2
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

