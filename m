Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 848A5C43334
	for <dm-devel@archiver.kernel.org>; Wed, 15 Jun 2022 20:40:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-47-64anQhpsNKi8hmaBLUfG8Q-1; Wed, 15 Jun 2022 16:40:54 -0400
X-MC-Unique: 64anQhpsNKi8hmaBLUfG8Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED5A0185A7BA;
	Wed, 15 Jun 2022 20:40:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DAF3AC08081;
	Wed, 15 Jun 2022 20:40:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B889F1947041;
	Wed, 15 Jun 2022 20:40:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F3DD519466DF
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Jun 2022 20:40:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E705C1678F; Wed, 15 Jun 2022 20:40:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E2E0E111F5
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 20:40:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C34013C0CD3D
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 20:40:49 +0000 (UTC)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
 [209.85.216.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-J5LzfPCJOL61ojRd1xl9xA-1; Wed, 15 Jun 2022 16:40:47 -0400
X-MC-Unique: J5LzfPCJOL61ojRd1xl9xA-1
Received: by mail-pj1-f53.google.com with SMTP id
 o33-20020a17090a0a2400b001ea806e48c6so3101981pjo.1; 
 Wed, 15 Jun 2022 13:40:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
 :references:mime-version:content-disposition:in-reply-to;
 bh=HXGT1SN8IRUj17QykJ95SQlzGYE/r46PmZhVx6OFLXg=;
 b=0SUvy4TsYGVhomVDY1GHcSykYNdTR9quvQ7TYCjS90hcKlkftIVHoddurJzgjWe2cn
 35o+CcLmfFySprC7sarYj5QZBNGDxIkZAs1K+D9O3ABGNfuaGLdADwE0hL9+huyZl964
 Uxp0a+ITKwRcA/SiOIDJ6lBFFSeAKIXOgYcy2RMAo37Nzyb3fK395b/qK/Z5lCu7AxV9
 v+RQ2F0jkWxmAjip1mue+cDHNcX+Bq28kGOZp96pRYYYPo3YMHh75ZYIPgnE/eDDpZK6
 BAYzMjnLOtxTLfc1w7wQ5ZHq0nrBLaAMdtIrXngGT1aH5Ii0gKJCYPwpRhCZyonMadA0
 vFAQ==
X-Gm-Message-State: AJIora/O/hd+BHYri/Jba4erjPxLY/jSdjK2mgiSgh7+qgDyw7/od760
 76uiCQBhClAIIh0GXCav7t8kXIUEZdQ=
X-Google-Smtp-Source: AGRyM1uLBrJ6qlsZfxfPteK1a3Npd+wMO6H3/cUVtRPfhBYY5qVlt0xTpznwHqgdUkF35d0kjb6dIw==
X-Received: by 2002:a17:90a:2e02:b0:1ea:c661:7507 with SMTP id
 q2-20020a17090a2e0200b001eac6617507mr11055263pjd.133.1655325646116; 
 Wed, 15 Jun 2022 13:40:46 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
 by smtp.gmail.com with ESMTPSA id
 e3-20020a170903240300b0015e8d4eb277sm42109plo.193.2022.06.15.13.40.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 15 Jun 2022 13:40:45 -0700 (PDT)
Date: Wed, 15 Jun 2022 13:40:44 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <20220615204044.GA675578@roeck-us.net>
References: <20220603173816.944766454@linuxfoundation.org>
 <20220610042200.2561917-1-ovt@google.com>
 <YqLTV+5Q72/jBeOG@kroah.com> <YqNfBMOR9SE2TuCm@redhat.com>
 <Yqb/sT205Lrhl6Bv@kroah.com>
 <20220615143642.GA2386944@roeck-us.net>
 <Yqn64AMwoIzQXwXM@redhat.com>
 <50eeff2e-45c5-5eb2-c41d-3e0092a84483@roeck-us.net>
 <Yqo63CvFpTDFnH3x@redhat.com>
MIME-Version: 1.0
In-Reply-To: <Yqo63CvFpTDFnH3x@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 5.4 26/34] dm verity: set DM_TARGET_IMMUTABLE
 feature flag
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
Cc: keescook@chromium.org, sarthakkukreti@google.com,
 Greg KH <gregkh@linuxfoundation.org>, Mike Snitzer <snitzer@kernel.org>,
 stable@vger.kernel.org, Oleksandr Tymoshenko <ovt@google.com>,
 dm-devel@redhat.com, regressions@lists.linux.dev
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jun 15, 2022 at 04:02:36PM -0400, Mike Snitzer wrote:
[ ... ]
> 
> OK, well this is pretty easy to fix in general.  If there are slight
> differences across older trees they are easily resolved.  Fact that
> stable@ couldn't cope with backporting 9c37de297f65 is.. what it is.
> 
> But this will fix the issue on 5.4.y:
> 
> From: Mike Snitzer <snitzer@kernel.org>
> Date: Wed, 15 Jun 2022 14:07:09 -0400
> Subject: [5.4.y PATCH] dm: remove special-casing of bio-based immutable singleton target on NVMe
> 
> Commit 9c37de297f6590937f95a28bec1b7ac68a38618f upstream.
> 
> There is no benefit to DM special-casing NVMe. Remove all code used to
> establish DM_TYPE_NVME_BIO_BASED.
> 
> Signed-off-by: Mike Snitzer <snitzer@kernel.org>

I'll give it a try.

Thanks,
Guenter

> ---
>  drivers/md/dm-table.c         | 32 ++----------------
>  drivers/md/dm.c               | 64 +++--------------------------------
>  include/linux/device-mapper.h |  1 -
>  3 files changed, 7 insertions(+), 90 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 06b382304d92..81bc36a43b32 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -872,8 +872,7 @@ EXPORT_SYMBOL(dm_consume_args);
>  static bool __table_type_bio_based(enum dm_queue_mode table_type)
>  {
>  	return (table_type == DM_TYPE_BIO_BASED ||
> -		table_type == DM_TYPE_DAX_BIO_BASED ||
> -		table_type == DM_TYPE_NVME_BIO_BASED);
> +		table_type == DM_TYPE_DAX_BIO_BASED);
>  }
>  
>  static bool __table_type_request_based(enum dm_queue_mode table_type)
> @@ -929,8 +928,6 @@ bool dm_table_supports_dax(struct dm_table *t,
>  	return true;
>  }
>  
> -static bool dm_table_does_not_support_partial_completion(struct dm_table *t);
> -
>  static int device_is_rq_stackable(struct dm_target *ti, struct dm_dev *dev,
>  				  sector_t start, sector_t len, void *data)
>  {
> @@ -960,7 +957,6 @@ static int dm_table_determine_type(struct dm_table *t)
>  			goto verify_bio_based;
>  		}
>  		BUG_ON(t->type == DM_TYPE_DAX_BIO_BASED);
> -		BUG_ON(t->type == DM_TYPE_NVME_BIO_BASED);
>  		goto verify_rq_based;
>  	}
>  
> @@ -999,15 +995,6 @@ static int dm_table_determine_type(struct dm_table *t)
>  		if (dm_table_supports_dax(t, device_not_dax_capable, &page_size) ||
>  		    (list_empty(devices) && live_md_type == DM_TYPE_DAX_BIO_BASED)) {
>  			t->type = DM_TYPE_DAX_BIO_BASED;
> -		} else {
> -			/* Check if upgrading to NVMe bio-based is valid or required */
> -			tgt = dm_table_get_immutable_target(t);
> -			if (tgt && !tgt->max_io_len && dm_table_does_not_support_partial_completion(t)) {
> -				t->type = DM_TYPE_NVME_BIO_BASED;
> -				goto verify_rq_based; /* must be stacked directly on NVMe (blk-mq) */
> -			} else if (list_empty(devices) && live_md_type == DM_TYPE_NVME_BIO_BASED) {
> -				t->type = DM_TYPE_NVME_BIO_BASED;
> -			}
>  		}
>  		return 0;
>  	}
> @@ -1024,8 +1011,7 @@ static int dm_table_determine_type(struct dm_table *t)
>  	 * (e.g. request completion process for partial completion.)
>  	 */
>  	if (t->num_targets > 1) {
> -		DMERR("%s DM doesn't support multiple targets",
> -		      t->type == DM_TYPE_NVME_BIO_BASED ? "nvme bio-based" : "request-based");
> +		DMERR("request-based DM doesn't support multiple targets");
>  		return -EINVAL;
>  	}
>  
> @@ -1714,20 +1700,6 @@ static int device_is_not_random(struct dm_target *ti, struct dm_dev *dev,
>  	return q && !blk_queue_add_random(q);
>  }
>  
> -static int device_is_partial_completion(struct dm_target *ti, struct dm_dev *dev,
> -					sector_t start, sector_t len, void *data)
> -{
> -	char b[BDEVNAME_SIZE];
> -
> -	/* For now, NVMe devices are the only devices of this class */
> -	return (strncmp(bdevname(dev->bdev, b), "nvme", 4) != 0);
> -}
> -
> -static bool dm_table_does_not_support_partial_completion(struct dm_table *t)
> -{
> -	return !dm_table_any_dev_attr(t, device_is_partial_completion, NULL);
> -}
> -
>  static int device_not_write_same_capable(struct dm_target *ti, struct dm_dev *dev,
>  					 sector_t start, sector_t len, void *data)
>  {
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 37b8bb4d80f0..3c45c389ded9 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1000,7 +1000,7 @@ static void clone_endio(struct bio *bio)
>  	struct mapped_device *md = tio->io->md;
>  	dm_endio_fn endio = tio->ti->type->end_io;
>  
> -	if (unlikely(error == BLK_STS_TARGET) && md->type != DM_TYPE_NVME_BIO_BASED) {
> +	if (unlikely(error == BLK_STS_TARGET)) {
>  		if (bio_op(bio) == REQ_OP_DISCARD &&
>  		    !bio->bi_disk->queue->limits.max_discard_sectors)
>  			disable_discard(md);
> @@ -1340,10 +1340,7 @@ static blk_qc_t __map_bio(struct dm_target_io *tio)
>  		/* the bio has been remapped so dispatch it */
>  		trace_block_bio_remap(clone->bi_disk->queue, clone,
>  				      bio_dev(io->orig_bio), sector);
> -		if (md->type == DM_TYPE_NVME_BIO_BASED)
> -			ret = direct_make_request(clone);
> -		else
> -			ret = generic_make_request(clone);
> +		ret = generic_make_request(clone);
>  		break;
>  	case DM_MAPIO_KILL:
>  		if (unlikely(swap_bios_limit(ti, clone))) {
> @@ -1732,51 +1729,6 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
>  	return ret;
>  }
>  
> -/*
> - * Optimized variant of __split_and_process_bio that leverages the
> - * fact that targets that use it do _not_ have a need to split bios.
> - */
> -static blk_qc_t __process_bio(struct mapped_device *md, struct dm_table *map,
> -			      struct bio *bio, struct dm_target *ti)
> -{
> -	struct clone_info ci;
> -	blk_qc_t ret = BLK_QC_T_NONE;
> -	int error = 0;
> -
> -	init_clone_info(&ci, md, map, bio);
> -
> -	if (bio->bi_opf & REQ_PREFLUSH) {
> -		struct bio flush_bio;
> -
> -		/*
> -		 * Use an on-stack bio for this, it's safe since we don't
> -		 * need to reference it after submit. It's just used as
> -		 * the basis for the clone(s).
> -		 */
> -		bio_init(&flush_bio, NULL, 0);
> -		flush_bio.bi_opf = REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC;
> -		ci.bio = &flush_bio;
> -		ci.sector_count = 0;
> -		error = __send_empty_flush(&ci);
> -		bio_uninit(ci.bio);
> -		/* dec_pending submits any data associated with flush */
> -	} else {
> -		struct dm_target_io *tio;
> -
> -		ci.bio = bio;
> -		ci.sector_count = bio_sectors(bio);
> -		if (__process_abnormal_io(&ci, ti, &error))
> -			goto out;
> -
> -		tio = alloc_tio(&ci, ti, 0, GFP_NOIO);
> -		ret = __clone_and_map_simple_bio(&ci, tio, NULL);
> -	}
> -out:
> -	/* drop the extra reference count */
> -	dec_pending(ci.io, errno_to_blk_status(error));
> -	return ret;
> -}
> -
>  static blk_qc_t dm_process_bio(struct mapped_device *md,
>  			       struct dm_table *map, struct bio *bio)
>  {
> @@ -1807,8 +1759,6 @@ static blk_qc_t dm_process_bio(struct mapped_device *md,
>  		/* regular IO is split by __split_and_process_bio */
>  	}
>  
> -	if (dm_get_md_type(md) == DM_TYPE_NVME_BIO_BASED)
> -		return __process_bio(md, map, bio, ti);
>  	return __split_and_process_bio(md, map, bio);
>  }
>  
> @@ -2200,12 +2150,10 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
>  	if (request_based)
>  		dm_stop_queue(q);
>  
> -	if (request_based || md->type == DM_TYPE_NVME_BIO_BASED) {
> +	if (request_based) {
>  		/*
> -		 * Leverage the fact that request-based DM targets and
> -		 * NVMe bio based targets are immutable singletons
> -		 * - used to optimize both dm_request_fn and dm_mq_queue_rq;
> -		 *   and __process_bio.
> +		 * Leverage the fact that request-based DM targets are
> +		 * immutable singletons - used to optimize dm_mq_queue_rq.
>  		 */
>  		md->immutable_target = dm_table_get_immutable_target(t);
>  	}
> @@ -2334,7 +2282,6 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
>  		break;
>  	case DM_TYPE_BIO_BASED:
>  	case DM_TYPE_DAX_BIO_BASED:
> -	case DM_TYPE_NVME_BIO_BASED:
>  		dm_init_congested_fn(md);
>  		break;
>  	case DM_TYPE_NONE:
> @@ -3070,7 +3017,6 @@ struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, enum dm_qu
>  	switch (type) {
>  	case DM_TYPE_BIO_BASED:
>  	case DM_TYPE_DAX_BIO_BASED:
> -	case DM_TYPE_NVME_BIO_BASED:
>  		pool_size = max(dm_get_reserved_bio_based_ios(), min_pool_size);
>  		front_pad = roundup(per_io_data_size, __alignof__(struct dm_target_io)) + offsetof(struct dm_target_io, clone);
>  		io_front_pad = roundup(front_pad,  __alignof__(struct dm_io)) + offsetof(struct dm_io, tio);
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index a53d7d2c2d95..60631f3abddb 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -28,7 +28,6 @@ enum dm_queue_mode {
>  	DM_TYPE_BIO_BASED	 = 1,
>  	DM_TYPE_REQUEST_BASED	 = 2,
>  	DM_TYPE_DAX_BIO_BASED	 = 3,
> -	DM_TYPE_NVME_BIO_BASED	 = 4,
>  };
>  
>  typedef enum { STATUSTYPE_INFO, STATUSTYPE_TABLE } status_type_t;
> -- 
> 2.30.0
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

