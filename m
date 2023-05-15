Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 270B4C7EE22
	for <dm-devel@archiver.kernel.org>; Mon, 15 May 2023 12:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684154274;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jJtmHGX3H+hNXAcItmU5k6onGrfxl5hwcQQyz5YJxP0=;
	b=ZWUeuAwjUaNHCninOvGWXW5oRdiFz5cjddodQ4gFd3Q/My5zNeX/YvAASd700d4i7sFSWB
	qVI5Q1FwasiTuvUhtAU+PadjGa7031ZPOoLriE7qPfzje4h/QO0SYcXNoMkzvCSaI6PGJP
	u4pI8Vg4naevphOOIuLKov6nA1qqHv8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-91-AejdUT1cNK6_en67WR5mVA-1; Mon, 15 May 2023 08:37:51 -0400
X-MC-Unique: AejdUT1cNK6_en67WR5mVA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09A7D88B76F;
	Mon, 15 May 2023 12:37:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9EDDB463EE7;
	Mon, 15 May 2023 12:37:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5EFE61946595;
	Mon, 15 May 2023 12:37:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 01BC9194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 15 May 2023 12:37:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D8A734078906; Mon, 15 May 2023 12:37:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D0DBE40C6EC4
 for <dm-devel@redhat.com>; Mon, 15 May 2023 12:37:44 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B25A43855565
 for <dm-devel@redhat.com>; Mon, 15 May 2023 12:37:44 +0000 (UTC)
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-P-x2H4fkNWuAQHGF3PxVpg-1; Mon, 15 May 2023 08:37:43 -0400
X-MC-Unique: P-x2H4fkNWuAQHGF3PxVpg-1
Received: by mail-qv1-f70.google.com with SMTP id
 6a1803df08f44-61abb7cd89cso70282796d6.3
 for <dm-devel@redhat.com>; Mon, 15 May 2023 05:37:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684154262; x=1686746262;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=GMaiL4YHC7uUUhHJ2ubX8SKdgheUKgR6Z34QRTwNRu8=;
 b=bIcdIsCMioeOGY5EBz60psjkBLhVhZZw2B0uTJKHvCCiUw9EK6oC3xA6/XG3DUHIPG
 6DHuQFcZLLjHvRaxIWEfFwwXQ36z+1l9wY1ikS/KgeOTZF8jAs2UHdbLIUx+bARver9C
 YpfsS682yMW5+UMHO5oq/5twU+uypLCAEU74lcCIyQCM7VHXsMWWEFD64vSKbUCyMi7K
 MLGPkNdTZHUZGLS9j9weX9ASJOQKQZoQI74LpEJPYTxIr10qWmC62HWA9SwHJwnWJ2kL
 JVHSnJPPG4YoIrvIifNV/THAdLqGDEjD5fbAidFjA1qJQPJbHnEeATh5PEEMb7XDDuIw
 4R5A==
X-Gm-Message-State: AC+VfDz767iRoLeJcCbhknvB2Z8bxgZ0q1mKg7uM6tmCfFG4M2C5ngjq
 +D8s4ndaQPg35jtjAEHhZwvIx9Vka/Ue4qhHfUQeXioRyW41D6M8AJqyPXHOWFbMSBP9PhHpxi2
 C20OJa2oMlbOrPl+Z+Ba7APzWYQ==
X-Received: by 2002:a05:6214:5007:b0:61b:743c:34f6 with SMTP id
 jo7-20020a056214500700b0061b743c34f6mr60348756qvb.30.1684154262693; 
 Mon, 15 May 2023 05:37:42 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4f8e8bF39OseS5tHDGrQC563VXoeZlOAQEHKuj4FHMfFjvY/smfMQU9ypBiwBc9fk5VyO5gw==
X-Received: by 2002:a05:6214:5007:b0:61b:743c:34f6 with SMTP id
 jo7-20020a056214500700b0061b743c34f6mr60348721qvb.30.1684154262451; 
 Mon, 15 May 2023 05:37:42 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
 by smtp.gmail.com with ESMTPSA id
 mm9-20020a0562145e8900b0062138a50d42sm4586271qvb.1.2023.05.15.05.37.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 15 May 2023 05:37:41 -0700 (PDT)
Date: Mon, 15 May 2023 08:40:10 -0400
From: Brian Foster <bfoster@redhat.com>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <ZGIoKi7d5bKcMWw4@bfoster>
References: <20230420004850.297045-1-sarthakkukreti@chromium.org>
 <20230506062909.74601-1-sarthakkukreti@chromium.org>
 <20230506062909.74601-6-sarthakkukreti@chromium.org>
MIME-Version: 1.0
In-Reply-To: <20230506062909.74601-6-sarthakkukreti@chromium.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v6 5/5] loop: Add support for provision
 requests
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Theodore Ts'o <tytso@mit.edu>, "Michael S. Tsirkin" <mst@redhat.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Wang <jasowang@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, May 05, 2023 at 11:29:09PM -0700, Sarthak Kukreti wrote:
> Add support for provision requests to loopback devices.
> Loop devices will configure provision support based on
> whether the underlying block device/file can support
> the provision request and upon receiving a provision bio,
> will map it to the backing device/storage. For loop devices
> over files, a REQ_OP_PROVISION request will translate to
> an fallocate mode 0 call on the backing file.
> 
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> ---
>  drivers/block/loop.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index bc31bb7072a2..13c4b4f8b9c1 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -327,6 +327,24 @@ static int lo_fallocate(struct loop_device *lo, struct request *rq, loff_t pos,
>  	return ret;
>  }
>  
> +static int lo_req_provision(struct loop_device *lo, struct request *rq, loff_t pos)
> +{
> +	struct file *file = lo->lo_backing_file;
> +	struct request_queue *q = lo->lo_queue;
> +	int ret;
> +
> +	if (!q->limits.max_provision_sectors) {
> +		ret = -EOPNOTSUPP;
> +		goto out;
> +	}
> +
> +	ret = file->f_op->fallocate(file, 0, pos, blk_rq_bytes(rq));
> +	if (unlikely(ret && ret != -EINVAL && ret != -EOPNOTSUPP))
> +		ret = -EIO;
> + out:
> +	return ret;
> +}
> +
>  static int lo_req_flush(struct loop_device *lo, struct request *rq)
>  {
>  	int ret = vfs_fsync(lo->lo_backing_file, 0);
> @@ -488,6 +506,8 @@ static int do_req_filebacked(struct loop_device *lo, struct request *rq)
>  				FALLOC_FL_PUNCH_HOLE);
>  	case REQ_OP_DISCARD:
>  		return lo_fallocate(lo, rq, pos, FALLOC_FL_PUNCH_HOLE);
> +	case REQ_OP_PROVISION:
> +		return lo_req_provision(lo, rq, pos);

Hi Sarthak,

The only thing that stands out to me is the separate lo_req_provision()
helper here. It seems it might be a little cleaner to extend and reuse
lo_req_fallocate()..? But that's not something I feel strongly about, so
this all looks pretty good to me either way, FWIW.

Brian

>  	case REQ_OP_WRITE:
>  		if (cmd->use_aio)
>  			return lo_rw_aio(lo, cmd, pos, ITER_SOURCE);
> @@ -754,6 +774,25 @@ static void loop_sysfs_exit(struct loop_device *lo)
>  				   &loop_attribute_group);
>  }
>  
> +static void loop_config_provision(struct loop_device *lo)
> +{
> +	struct file *file = lo->lo_backing_file;
> +	struct inode *inode = file->f_mapping->host;
> +
> +	/*
> +	 * If the backing device is a block device, mirror its provisioning
> +	 * capability.
> +	 */
> +	if (S_ISBLK(inode->i_mode)) {
> +		blk_queue_max_provision_sectors(lo->lo_queue,
> +			bdev_max_provision_sectors(I_BDEV(inode)));
> +	} else if (file->f_op->fallocate) {
> +		blk_queue_max_provision_sectors(lo->lo_queue, UINT_MAX >> 9);
> +	} else {
> +		blk_queue_max_provision_sectors(lo->lo_queue, 0);
> +	}
> +}
> +
>  static void loop_config_discard(struct loop_device *lo)
>  {
>  	struct file *file = lo->lo_backing_file;
> @@ -1092,6 +1131,7 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
>  	blk_queue_io_min(lo->lo_queue, bsize);
>  
>  	loop_config_discard(lo);
> +	loop_config_provision(lo);
>  	loop_update_rotational(lo);
>  	loop_update_dio(lo);
>  	loop_sysfs_init(lo);
> @@ -1304,6 +1344,7 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
>  	}
>  
>  	loop_config_discard(lo);
> +	loop_config_provision(lo);
>  
>  	/* update dio if lo_offset or transfer is changed */
>  	__loop_update_dio(lo, lo->use_dio);
> @@ -1830,6 +1871,7 @@ static blk_status_t loop_queue_rq(struct blk_mq_hw_ctx *hctx,
>  	case REQ_OP_FLUSH:
>  	case REQ_OP_DISCARD:
>  	case REQ_OP_WRITE_ZEROES:
> +	case REQ_OP_PROVISION:
>  		cmd->use_aio = false;
>  		break;
>  	default:
> -- 
> 2.40.1.521.gf1e218fcd8-goog
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

