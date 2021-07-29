Return-Path: <SRS0=hAiq=MV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF52C4338F
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 16:36:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AD6A860F43
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 16:36:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AD6A860F43
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1627576613;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JmM6NcGjNJ1n//dVuONL7HTCSdmgqMdM+ynaISucVKQ=;
	b=aj2PVi8kMxgna5cwzWH1il9H1925rnitvmx6dWHx1hc/ha0OLCkcg1ND0lhyYCbqS6huWq
	9OdtJikOT9GOABj0sQkX4k0xKfDXS6D+Vw/tzehQtSZ3I1vo6WeaGlCP4JyZifl7VmIAzs
	pB8JqXWrIBKi2FPrN9z7ZrktNdpNUJA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304--RdU2m4zPeig0uBF_a_6PQ-1; Thu, 29 Jul 2021 12:36:52 -0400
X-MC-Unique: -RdU2m4zPeig0uBF_a_6PQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03E08107ACF5;
	Thu, 29 Jul 2021 16:36:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DE3AF60875;
	Thu, 29 Jul 2021 16:36:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AE3E04BB7C;
	Thu, 29 Jul 2021 16:36:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16TGakov012792 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 29 Jul 2021 12:36:46 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2C62A2033B63; Thu, 29 Jul 2021 16:36:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E068B2051B60
	for <dm-devel@redhat.com>; Thu, 29 Jul 2021 16:36:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D1058CA946
	for <dm-devel@redhat.com>; Thu, 29 Jul 2021 16:36:38 +0000 (UTC)
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
	[209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-591-18H6LVvENTaY6F7RQNkmCQ-1; Thu, 29 Jul 2021 12:36:34 -0400
X-MC-Unique: 18H6LVvENTaY6F7RQNkmCQ-1
Received: by mail-qt1-f199.google.com with SMTP id
	o7-20020ac87c470000b029025f8084df09so2985879qtv.6
	for <dm-devel@redhat.com>; Thu, 29 Jul 2021 09:36:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=u3NGgM0zE4A2LSlCrpEkhVObgSJ7qzXv7ezeOeUxp8Y=;
	b=CGuxaDlSLK1muwvf8jCb41/TfswxkW//ep9yqoEwRGppr7j2ZK6jWMQ53371MOVAN8
	XR1lUYmVxxBCI9srp3iXbB5AmHRu3OYz4DwJyJj6Y31oqZ2qS/GzmJV2C5oPIHYdQjA5
	3wXBWuIO1t1YmJ7BjLXC5XnPxo+Ygo9//2EtlA3nhTDZpIjNTQKzpJo66WfGrPa1rCX8
	SVkp0z1jUW3mwR7gW3xWW8o+nFTYbJ1YyZhO7Hl9Wgx+1uj6gi8SPa7Vx2cRgYJK2rUx
	xScwSaNdgOFr9p+h3oGXTvhzMGtAKKg8MCGHThBlTwp3Baf31DTSxT+IdPX3YBxufBVb
	n8pA==
X-Gm-Message-State: AOAM5337c7KvvKuTLW9wtXrLSixaEC6csMU5ZAWjYTD87cfO6LjDDzK8
	2+flSw4OCcFHHntg2MkGk2DOkM3Ql1Qtclr8bQOsaoF8KWIZNSzwTDgwnRvgIKCv/6eDC0pbPQz
	XqHwJTgf9fBL9NQ==
X-Received: by 2002:a05:620a:a8d:: with SMTP id
	v13mr6071734qkg.468.1627576594252; 
	Thu, 29 Jul 2021 09:36:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxnrTD1/OHkbii+EetzwAeTe2yeiaR0KQGof9csNyzw4D4QxOACApZHPviP2cdwLh7xlzut1w==
X-Received: by 2002:a05:620a:a8d:: with SMTP id
	v13mr6071718qkg.468.1627576594086; 
	Thu, 29 Jul 2021 09:36:34 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id t6sm1995462qkg.75.2021.07.29.09.36.33
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 29 Jul 2021 09:36:33 -0700 (PDT)
Date: Thu, 29 Jul 2021 12:36:33 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YQLZEAIKbMrveJR0@redhat.com>
References: <20210725055458.29008-1-hch@lst.de>
	<20210725055458.29008-8-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210725055458.29008-8-hch@lst.de>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 7/8] dm: delay registering the gendisk
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

> device mapper is currently the only outlier that tries to call
> register_disk after add_disk, leading to fairly inconsistent state
> of these block layer data structures.  Instead change device-mapper
> to just register the gendisk later now that the holder mechanism
> can cope with that.
> 
> Note that this introduces a user visible change: the dm kobject is
> now only visible after the initial table has been loaded.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

Jens, feel free to pick this series up once you're comfortable with it.

Thanks,
Mike


> ---
>  drivers/md/dm-rq.c |  1 -
>  drivers/md/dm.c    | 23 +++++++++++------------
>  2 files changed, 11 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> index 0dbd48cbdff9..5b95eea517d1 100644
> --- a/drivers/md/dm-rq.c
> +++ b/drivers/md/dm-rq.c
> @@ -559,7 +559,6 @@ int dm_mq_init_request_queue(struct mapped_device *md, struct dm_table *t)
>  	err = blk_mq_init_allocated_queue(md->tag_set, md->queue);
>  	if (err)
>  		goto out_tag_set;
> -	elevator_init_mq(md->queue);
>  	return 0;
>  
>  out_tag_set:
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index f003bd5b93ce..7981b7287628 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1693,7 +1693,10 @@ static void cleanup_mapped_device(struct mapped_device *md)
>  		spin_lock(&_minor_lock);
>  		md->disk->private_data = NULL;
>  		spin_unlock(&_minor_lock);
> -		del_gendisk(md->disk);
> +		if (dm_get_md_type(md) != DM_TYPE_NONE) {
> +			dm_sysfs_exit(md);
> +			del_gendisk(md->disk);
> +		}
>  		dm_queue_destroy_keyslot_manager(md->queue);
>  		blk_cleanup_disk(md->disk);
>  	}
> @@ -1788,7 +1791,6 @@ static struct mapped_device *alloc_dev(int minor)
>  			goto bad;
>  	}
>  
> -	add_disk_no_queue_reg(md->disk);
>  	format_dev_t(md->name, MKDEV(_major, minor));
>  
>  	md->wq = alloc_workqueue("kdmflush", WQ_MEM_RECLAIM, 0);
> @@ -1989,19 +1991,12 @@ static struct dm_table *__unbind(struct mapped_device *md)
>   */
>  int dm_create(int minor, struct mapped_device **result)
>  {
> -	int r;
>  	struct mapped_device *md;
>  
>  	md = alloc_dev(minor);
>  	if (!md)
>  		return -ENXIO;
>  
> -	r = dm_sysfs_init(md);
> -	if (r) {
> -		free_dev(md);
> -		return r;
> -	}
> -
>  	*result = md;
>  	return 0;
>  }
> @@ -2081,10 +2076,15 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
>  	r = dm_table_set_restrictions(t, md->queue, &limits);
>  	if (r)
>  		return r;
> -	md->type = type;
>  
> -	blk_register_queue(md->disk);
> +	add_disk(md->disk);
>  
> +	r = dm_sysfs_init(md);
> +	if (r) {
> +		del_gendisk(md->disk);
> +		return r;
> +	}
> +	md->type = type;
>  	return 0;
>  }
>  
> @@ -2190,7 +2190,6 @@ static void __dm_destroy(struct mapped_device *md, bool wait)
>  		DMWARN("%s: Forcibly removing mapped_device still in use! (%d users)",
>  		       dm_device_name(md), atomic_read(&md->holders));
>  
> -	dm_sysfs_exit(md);
>  	dm_table_destroy(__unbind(md));
>  	free_dev(md);
>  }
> -- 
> 2.30.2
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

