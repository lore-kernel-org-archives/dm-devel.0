Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DACC6C6FA82
	for <dm-devel@archiver.kernel.org>; Thu, 29 Sep 2022 07:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664435223;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=x17rGzlRqXoMu/ZO9R2/KSWE7GekLdX8cXaS7kHkXNc=;
	b=atqNsYHo+J6BvfaXMQda09RJLrq+g2qqmfwL6xrmCZw5R+RkGh2miFH5dn/XjQVL//cOAX
	rfgRTgbpajjpsNnZHP1b+aJVA2XZH98qTc8SgisHGw7uLI+N8FSm6K2Z+VB2q2jSqz0elp
	1JTPa4MhyjfGP7+0soZ/oI+s291Kb7Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-rsGCMIEpNSqmv5llzGhzRQ-1; Thu, 29 Sep 2022 03:07:00 -0400
X-MC-Unique: rsGCMIEpNSqmv5llzGhzRQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10BF6855421;
	Thu, 29 Sep 2022 07:06:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B99DA1402BDC;
	Thu, 29 Sep 2022 07:06:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 84E4B1946A45;
	Thu, 29 Sep 2022 07:06:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 687E91946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 27 Sep 2022 21:38:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 23359492B05; Tue, 27 Sep 2022 21:38:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B3F7492B04
 for <dm-devel@redhat.com>; Tue, 27 Sep 2022 21:38:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F3AB4811E67
 for <dm-devel@redhat.com>; Tue, 27 Sep 2022 21:38:00 +0000 (UTC)
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-218-nALOMiyJOHycYQBWVexCYg-1; Tue, 27 Sep 2022 17:37:59 -0400
X-MC-Unique: nALOMiyJOHycYQBWVexCYg-1
Received: by mail-wr1-f72.google.com with SMTP id
 q2-20020adfab02000000b0022cc38d5a8fso526377wrc.6
 for <dm-devel@redhat.com>; Tue, 27 Sep 2022 14:37:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=D5ZIksmGurvYC/iOAqtPVWbeUblsOdJ5xwGtu/IzOWI=;
 b=acRoWKKHdEb6SpJghovU9vCTdJnFyNZBvG1bFGfZqglVlJRqUUxM5V5QgA3rVJbOgB
 vn5q9B58gWE4xhPTNdJdq6hDS/+Fz4mRB+nppF/6VQVRVZzCzn0eTrAMZY3DM2Ai8sgY
 Y3WAOtOInLWpAsQhwzBCmjyj4SQDmfUUDAoF+XMRJXXfEbPgnY6xoyVvx0HluKDJ9rDK
 5DH+x/CnwGcCSzV7BlLaHgvWWvVwhmnkumrWFbUiz4Fvb2SKFDpSxJwbkjPuc+/x90dA
 l3WhT8Q4ERsTpcmyZeDi1yKZhdxGOWmtkXh0msJvpyiML8B6r4kbY4JssncAgFfi5Rbk
 glxg==
X-Gm-Message-State: ACrzQf0Ohz9AO5CDGOne4UjLhWlCDplbUtp8e1k2yd9JJSpfsCz0T24C
 +/h/lpDxpgjm+gzzeDDxcRfCejmv4GtwhUGxsEfi4ZN/q7snBXh4RTdl/4IqOAC7EMjUuDcNgWO
 aTf18fM1CKBEXl9A=
X-Received: by 2002:a05:6000:2ce:b0:22a:f2dc:1531 with SMTP id
 o14-20020a05600002ce00b0022af2dc1531mr18614987wry.370.1664314677225; 
 Tue, 27 Sep 2022 14:37:57 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM75GZrpOIjx3Y8daQH5gD30RRG235Fd/YqvwBOi/XGXrLC5i+WLs9D44hdtjOnyVVgkm68Sog==
X-Received: by 2002:a05:6000:2ce:b0:22a:f2dc:1531 with SMTP id
 o14-20020a05600002ce00b0022af2dc1531mr18614976wry.370.1664314677008; 
 Tue, 27 Sep 2022 14:37:57 -0700 (PDT)
Received: from redhat.com ([2.55.47.213]) by smtp.gmail.com with ESMTPSA id
 n3-20020a5d4203000000b0022acb7195aesm2708029wrq.33.2022.09.27.14.37.52
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 27 Sep 2022 14:37:56 -0700 (PDT)
Date: Tue, 27 Sep 2022 17:37:50 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <20220927173658-mutt-send-email-mst@kernel.org>
References: <20220915164826.1396245-1-sarthakkukreti@google.com>
 <20220915164826.1396245-4-sarthakkukreti@google.com>
MIME-Version: 1.0
In-Reply-To: <20220915164826.1396245-4-sarthakkukreti@google.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Thu, 29 Sep 2022 07:06:56 +0000
Subject: Re: [dm-devel] [PATCH RFC 3/8] virtio_blk: Add support for
 provision requests
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
Cc: Jens Axboe <axboe@kernel.dk>, Gwendal Grignou <gwendal@google.com>,
 Theodore Ts'o <tytso@mit.edu>, Jason Wang <jasowang@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-ext4@vger.kernel.org, Evan Green <evgreen@google.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Sep 15, 2022 at 09:48:21AM -0700, Sarthak Kukreti wrote:
> From: Sarthak Kukreti <sarthakkukreti@chromium.org>
> 
> Adds support for provision requests. Provision requests act like
> the inverse of discards.
> 
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> ---
>  drivers/block/virtio_blk.c      | 48 +++++++++++++++++++++++++++++++++
>  include/uapi/linux/virtio_blk.h |  9 +++++++
>  2 files changed, 57 insertions(+)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 30255fcaf181..eacc2bffe1d1 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -178,6 +178,39 @@ static int virtblk_setup_discard_write_zeroes(struct request *req, bool unmap)
>  	return 0;
>  }
>  
> +static int virtblk_setup_provision(struct request *req)
> +{
> +	unsigned short segments = blk_rq_nr_discard_segments(req);
> +	unsigned short n = 0;
> +
> +	struct virtio_blk_discard_write_zeroes *range;
> +	struct bio *bio;
> +	u32 flags = 0;
> +
> +	range = kmalloc_array(segments, sizeof(*range), GFP_ATOMIC);
> +	if (!range)
> +		return -ENOMEM;
> +
> +	__rq_for_each_bio(bio, req) {
> +		u64 sector = bio->bi_iter.bi_sector;
> +		u32 num_sectors = bio->bi_iter.bi_size >> SECTOR_SHIFT;
> +
> +		range[n].flags = cpu_to_le32(flags);
> +		range[n].num_sectors = cpu_to_le32(num_sectors);
> +		range[n].sector = cpu_to_le64(sector);
> +		n++;
> +	}
> +
> +	WARN_ON_ONCE(n != segments);
> +
> +	req->special_vec.bv_page = virt_to_page(range);
> +	req->special_vec.bv_offset = offset_in_page(range);
> +	req->special_vec.bv_len = sizeof(*range) * segments;
> +	req->rq_flags |= RQF_SPECIAL_PAYLOAD;
> +
> +	return 0;
> +}
> +
>  static void virtblk_unmap_data(struct request *req, struct virtblk_req *vbr)
>  {
>  	if (blk_rq_nr_phys_segments(req))
> @@ -243,6 +276,9 @@ static blk_status_t virtblk_setup_cmd(struct virtio_device *vdev,
>  	case REQ_OP_DRV_IN:
>  		type = VIRTIO_BLK_T_GET_ID;
>  		break;
> +	case REQ_OP_PROVISION:
> +		type = VIRTIO_BLK_T_PROVISION;
> +		break;
>  	default:
>  		WARN_ON_ONCE(1);
>  		return BLK_STS_IOERR;
> @@ -256,6 +292,11 @@ static blk_status_t virtblk_setup_cmd(struct virtio_device *vdev,
>  			return BLK_STS_RESOURCE;
>  	}
>  
> +	if (type == VIRTIO_BLK_T_PROVISION) {
> +		if (virtblk_setup_provision(req))
> +			return BLK_STS_RESOURCE;
> +	}
> +
>  	return 0;
>  }
>  
> @@ -1075,6 +1116,12 @@ static int virtblk_probe(struct virtio_device *vdev)
>  		blk_queue_max_write_zeroes_sectors(q, v ? v : UINT_MAX);
>  	}
>  
> +	if (virtio_has_feature(vdev, VIRTIO_BLK_F_PROVISION)) {
> +		virtio_cread(vdev, struct virtio_blk_config,
> +			     max_provision_sectors, &v);
> +		q->limits.max_provision_sectors = v ? v : UINT_MAX;
> +	}
> +
>  	virtblk_update_capacity(vblk, false);
>  	virtio_device_ready(vdev);
>  
> @@ -1177,6 +1224,7 @@ static unsigned int features[] = {
>  	VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE,
>  	VIRTIO_BLK_F_FLUSH, VIRTIO_BLK_F_TOPOLOGY, VIRTIO_BLK_F_CONFIG_WCE,
>  	VIRTIO_BLK_F_MQ, VIRTIO_BLK_F_DISCARD, VIRTIO_BLK_F_WRITE_ZEROES,
> +	VIRTIO_BLK_F_PROVISION,
>  };
>  
>  static struct virtio_driver virtio_blk = {
> diff --git a/include/uapi/linux/virtio_blk.h b/include/uapi/linux/virtio_blk.h
> index d888f013d9ff..184f8cf6d185 100644
> --- a/include/uapi/linux/virtio_blk.h
> +++ b/include/uapi/linux/virtio_blk.h
> @@ -40,6 +40,7 @@
>  #define VIRTIO_BLK_F_MQ		12	/* support more than one vq */
>  #define VIRTIO_BLK_F_DISCARD	13	/* DISCARD is supported */
>  #define VIRTIO_BLK_F_WRITE_ZEROES	14	/* WRITE ZEROES is supported */
> +#define VIRTIO_BLK_F_PROVISION	15	/* provision is supported */
>  
>  /* Legacy feature bits */
>  #ifndef VIRTIO_BLK_NO_LEGACY
> @@ -120,6 +121,11 @@ struct virtio_blk_config {
>  	 */
>  	__u8 write_zeroes_may_unmap;
>  
> +	/*
> +	 * The maximum number of sectors in a provision request.
> +	 */
> +	__virtio32 max_provision_sectors;
> +
>  	__u8 unused1[3];
>  } __attribute__((packed));
>  
> @@ -155,6 +161,9 @@ struct virtio_blk_config {
>  /* Write zeroes command */
>  #define VIRTIO_BLK_T_WRITE_ZEROES	13
>  
> +/* Provision command */
> +#define VIRTIO_BLK_T_PROVISION	14
> +
>  #ifndef VIRTIO_BLK_NO_LEGACY
>  /* Barrier before this op. */
>  #define VIRTIO_BLK_T_BARRIER	0x80000000


Feature bit has to be reserved in the virtio spec.
Pls do this through the virtio TC mailing list.

> -- 
> 2.31.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

