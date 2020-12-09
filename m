Return-Path: <SRS0=UIu2=FN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DA6BC4361B
	for <dm-devel@archiver.kernel.org>; Wed,  9 Dec 2020 02:53:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 14B8423888
	for <dm-devel@archiver.kernel.org>; Wed,  9 Dec 2020 02:53:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 14B8423888
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1607482387;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wnbiIpE7TC5/zaB04AAtI2ovw0ejbyRfFdWyATAV3v8=;
	b=AxrU+3sQQ+2yC0poMRshxzKg0XzpdL7wxvWScavJfBCjnm0K31e+FAF8+PRqq50SWkYhTh
	3rhy8sKxbVcu/F07kN3RVxpddrNXYJs6Ig/RxxZwDLhW4BPjadhbDRy+yJm6iV8RCHGSda
	YMCpBzD0zP+PTdgFPel9HIF+UswfzXw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-_zfr6ycyP-qlOr1NMdJObA-1; Tue, 08 Dec 2020 21:53:05 -0500
X-MC-Unique: _zfr6ycyP-qlOr1NMdJObA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65A9A10054FF;
	Wed,  9 Dec 2020 02:53:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 318BE10013C0;
	Wed,  9 Dec 2020 02:53:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7C2014BB7B;
	Wed,  9 Dec 2020 02:52:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B92qvNX016890 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Dec 2020 21:52:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7800E60BD8; Wed,  9 Dec 2020 02:52:57 +0000 (UTC)
Received: from T590 (ovpn-12-139.pek2.redhat.com [10.72.12.139])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 84BED6064B;
	Wed,  9 Dec 2020 02:52:41 +0000 (UTC)
Date: Wed, 9 Dec 2020 10:52:36 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201209025236.GE1217988@T590>
References: <20201208162829.2424563-1-hch@lst.de>
	<20201208162829.2424563-6-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201208162829.2424563-6-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>,
	Mike Snitzer <snitzer@redhat.com>, Oleksii Kurochko <olkuroch@cisco.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-nvme@lists.infradead.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 5/6] rbd: remove the ->set_read_only method
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Dec 08, 2020 at 05:28:28PM +0100, Christoph Hellwig wrote:
> Now that the hardware read-only state can't be changed by the BLKROSET
> ioctl, the code in this method is not required anymore.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Acked-by: Ilya Dryomov <idryomov@gmail.com>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  drivers/block/rbd.c | 19 -------------------
>  1 file changed, 19 deletions(-)
> 
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 2ed79b09439a82..2c64ca15ca079f 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -692,29 +692,10 @@ static void rbd_release(struct gendisk *disk, fmode_t mode)
>  	put_device(&rbd_dev->dev);
>  }
>  
> -static int rbd_set_read_only(struct block_device *bdev, bool ro)
> -{
> -	struct rbd_device *rbd_dev = bdev->bd_disk->private_data;
> -
> -	/*
> -	 * Both images mapped read-only and snapshots can't be marked
> -	 * read-write.
> -	 */
> -	if (!ro) {
> -		if (rbd_is_ro(rbd_dev))
> -			return -EROFS;
> -
> -		rbd_assert(!rbd_is_snap(rbd_dev));
> -	}
> -
> -	return 0;
> -}
> -
>  static const struct block_device_operations rbd_bd_ops = {
>  	.owner			= THIS_MODULE,
>  	.open			= rbd_open,
>  	.release		= rbd_release,
> -	.set_read_only		= rbd_set_read_only,
>  };
>  
>  /*
> -- 
> 2.29.2
> 

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

