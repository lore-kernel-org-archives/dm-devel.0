Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 894B7C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  9 Feb 2022 09:15:15 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-550-pcSiELLpMc2UWqZCANhYDg-1; Wed, 09 Feb 2022 04:15:10 -0500
X-MC-Unique: pcSiELLpMc2UWqZCANhYDg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2C7D84DA4E;
	Wed,  9 Feb 2022 09:15:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B5D975DBB4;
	Wed,  9 Feb 2022 09:15:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ED37E1809CB9;
	Wed,  9 Feb 2022 09:15:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2199F3im023112 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 9 Feb 2022 04:15:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 716EF40885A0; Wed,  9 Feb 2022 09:15:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6CAD64010A08
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 09:15:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54EFA800B21
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 09:15:03 +0000 (UTC)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-198-xd_mo7BdMgigvOrYYr_RCw-1; Wed, 09 Feb 2022 04:15:01 -0500
X-MC-Unique: xd_mo7BdMgigvOrYYr_RCw-1
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
	include these headers.
From: Guoqing Jiang <guoqing.jiang@linux.dev>
To: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk,
	martin.petersen@oracle.com, philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com, target-devel@vger.kernel.org,
	haris.iqbal@ionos.com, jinpu.wang@ionos.com, manoj@linux.ibm.com,
	mrochs@linux.ibm.com, ukrishn@linux.ibm.com
References: <20220209082828.2629273-1-hch@lst.de>
	<20220209082828.2629273-4-hch@lst.de>
Message-ID: <4f1565b2-0f83-0cfa-58bd-86d5dee48e51@linux.dev>
Date: Wed, 9 Feb 2022 17:05:36 +0800
MIME-Version: 1.0
In-Reply-To: <20220209082828.2629273-4-hch@lst.de>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: Re: [dm-devel] [PATCH 3/7] rnbd: drop WRITE_SAME support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2/9/22 4:28 PM, Christoph Hellwig wrote:
> REQ_OP_WRITE_SAME was only ever submitted by the legacy Linux zeroing
> code, which has switched to use REQ_OP_WRITE_ZEROES long before rnbd was
> even merged.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> ---
>   drivers/block/rnbd/rnbd-clt.c   | 7 ++-----
>   drivers/block/rnbd/rnbd-clt.h   | 1 -
>   drivers/block/rnbd/rnbd-proto.h | 6 ------
>   drivers/block/rnbd/rnbd-srv.c   | 3 +--
>   4 files changed, 3 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/block/rnbd/rnbd-clt.c b/drivers/block/rnbd/rnbd-clt.c
> index c08971de369fc..dc192d2738854 100644
> --- a/drivers/block/rnbd/rnbd-clt.c
> +++ b/drivers/block/rnbd/rnbd-clt.c
> @@ -82,7 +82,6 @@ static int rnbd_clt_set_dev_attr(struct rnbd_clt_dev *dev,
>   	dev->nsectors		    = le64_to_cpu(rsp->nsectors);
>   	dev->logical_block_size	    = le16_to_cpu(rsp->logical_block_size);
>   	dev->physical_block_size    = le16_to_cpu(rsp->physical_block_size);
> -	dev->max_write_same_sectors = le32_to_cpu(rsp->max_write_same_sectors);
>   	dev->max_discard_sectors    = le32_to_cpu(rsp->max_discard_sectors);
>   	dev->discard_granularity    = le32_to_cpu(rsp->discard_granularity);
>   	dev->discard_alignment	    = le32_to_cpu(rsp->discard_alignment);
> @@ -1359,8 +1358,6 @@ static void setup_request_queue(struct rnbd_clt_dev *dev)
>   	blk_queue_logical_block_size(dev->queue, dev->logical_block_size);
>   	blk_queue_physical_block_size(dev->queue, dev->physical_block_size);
>   	blk_queue_max_hw_sectors(dev->queue, dev->max_hw_sectors);
> -	blk_queue_max_write_same_sectors(dev->queue,
> -					 dev->max_write_same_sectors);
>   
>   	/*
>   	 * we don't support discards to "discontiguous" segments
> @@ -1610,10 +1607,10 @@ struct rnbd_clt_dev *rnbd_clt_map_device(const char *sessname,
>   	}
>   
>   	rnbd_clt_info(dev,
> -		       "map_device: Device mapped as %s (nsectors: %zu, logical_block_size: %d, physical_block_size: %d, max_write_same_sectors: %d, max_discard_sectors: %d, discard_granularity: %d, discard_alignment: %d, secure_discard: %d, max_segments: %d, max_hw_sectors: %d, rotational: %d, wc: %d, fua: %d)\n",
> +		       "map_device: Device mapped as %s (nsectors: %zu, logical_block_size: %d, physical_block_size: %d, max_discard_sectors: %d, discard_granularity: %d, discard_alignment: %d, secure_discard: %d, max_segments: %d, max_hw_sectors: %d, rotational: %d, wc: %d, fua: %d)\n",
>   		       dev->gd->disk_name, dev->nsectors,
>   		       dev->logical_block_size, dev->physical_block_size,
> -		       dev->max_write_same_sectors, dev->max_discard_sectors,
> +		       dev->max_discard_sectors,
>   		       dev->discard_granularity, dev->discard_alignment,
>   		       dev->secure_discard, dev->max_segments,
>   		       dev->max_hw_sectors, dev->rotational, dev->wc, dev->fua);
> diff --git a/drivers/block/rnbd/rnbd-clt.h b/drivers/block/rnbd/rnbd-clt.h
> index 0c2cae7f39b9f..6946ba23d62e5 100644
> --- a/drivers/block/rnbd/rnbd-clt.h
> +++ b/drivers/block/rnbd/rnbd-clt.h
> @@ -122,7 +122,6 @@ struct rnbd_clt_dev {
>   	bool			wc;
>   	bool			fua;
>   	u32			max_hw_sectors;
> -	u32			max_write_same_sectors;
>   	u32			max_discard_sectors;
>   	u32			discard_granularity;
>   	u32			discard_alignment;

I am planning to remove more members inside struct rnbd_clt_dev.

> diff --git a/drivers/block/rnbd/rnbd-proto.h b/drivers/block/rnbd/rnbd-proto.h
> index de5d5a8df81d7..3eb8b34bd1886 100644
> --- a/drivers/block/rnbd/rnbd-proto.h
> +++ b/drivers/block/rnbd/rnbd-proto.h
> @@ -249,9 +249,6 @@ static inline u32 rnbd_to_bio_flags(u32 rnbd_opf)
>   	case RNBD_OP_SECURE_ERASE:
>   		bio_opf = REQ_OP_SECURE_ERASE;
>   		break;
> -	case RNBD_OP_WRITE_SAME:
> -		bio_opf = REQ_OP_WRITE_SAME;
> -		break;
>   	default:
>   		WARN(1, "Unknown RNBD type: %d (flags %d)\n",
>   		     rnbd_op(rnbd_opf), rnbd_opf);
> @@ -284,9 +281,6 @@ static inline u32 rq_to_rnbd_flags(struct request *rq)
>   	case REQ_OP_SECURE_ERASE:
>   		rnbd_opf = RNBD_OP_SECURE_ERASE;
>   		break;
> -	case REQ_OP_WRITE_SAME:
> -		rnbd_opf = RNBD_OP_WRITE_SAME;
> -		break;
>   	case REQ_OP_FLUSH:
>   		rnbd_opf = RNBD_OP_FLUSH;
>   		break;
> diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.c
> index 132e950685d59..0e6b5687f8321 100644
> --- a/drivers/block/rnbd/rnbd-srv.c
> +++ b/drivers/block/rnbd/rnbd-srv.c
> @@ -548,8 +548,7 @@ static void rnbd_srv_fill_msg_open_rsp(struct rnbd_msg_open_rsp *rsp,
>   		cpu_to_le16(rnbd_dev_get_max_segs(rnbd_dev));
>   	rsp->max_hw_sectors =
>   		cpu_to_le32(rnbd_dev_get_max_hw_sects(rnbd_dev));
> -	rsp->max_write_same_sectors =
> -		cpu_to_le32(bdev_write_same(rnbd_dev->bdev));
> +	rsp->max_write_same_sectors = 0;

IIUC, I think we can delete max_write_same_sectors from rsp as well given
the earlier change in setup_request_queue and rnbd_clt_set_dev_attr.

Thanks,
Guoqing

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

