Return-Path: <SRS0=1Ivj=GK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC18C433DB
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jan 2021 21:54:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2DB7423447
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jan 2021 21:54:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2DB7423447
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1610056469;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VLKAO59DdpO3mt4944WpxWxjG6kE7LKyktsxA0KfBqA=;
	b=NfSCCIbUdu1JriiPsULluZDxKKppNGN9bJTH4CBkBe1I7lIis0UbDe4Y6pI5h46Zyuh+7o
	+0d5jlKpqggCw/7LyoUVnQ8MHiP7LeN5I65m3Vy8MlUfKoq1rkG4WVTLP9I2YIL4Gi+sU5
	GYpSl5ELc8uqs9x+O5Q/s9rRDx6AiJY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-VmtP85nLPpWgVS43ltaT4A-1; Thu, 07 Jan 2021 16:54:26 -0500
X-MC-Unique: VmtP85nLPpWgVS43ltaT4A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE5F4801817;
	Thu,  7 Jan 2021 21:54:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 68CF35D9DD;
	Thu,  7 Jan 2021 21:54:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CB93F180954D;
	Thu,  7 Jan 2021 21:54:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 107LsJ0o024676 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 7 Jan 2021 16:54:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 370BE60C0F; Thu,  7 Jan 2021 21:54:19 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A06360BF1;
	Thu,  7 Jan 2021 21:54:15 +0000 (UTC)
Date: Thu, 7 Jan 2021 16:54:15 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Jeffle Xu <jefflexu@linux.alibaba.com>
Message-ID: <20210107215415.GE21239@redhat.com>
References: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
	<20201223112624.78955-6-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <20201223112624.78955-6-jefflexu@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, io-uring@vger.kernel.org
Subject: Re: [dm-devel] [PATCH RFC 5/7] dm: always return BLK_QC_T_NONE for
 bio-based device
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Dec 23 2020 at  6:26am -0500,
Jeffle Xu <jefflexu@linux.alibaba.com> wrote:

> Currently the returned cookie of bio-based device is not used at all.
> 
> In the following patches, bio-based device will actually return a
> pointer to a specific object as the returned cookie.

In the following patch, ...

> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

> ---
>  drivers/md/dm.c | 26 ++++++++++----------------
>  1 file changed, 10 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 5b2f371ec4bb..03c2b867acaa 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1252,14 +1252,13 @@ void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors)
>  }
>  EXPORT_SYMBOL_GPL(dm_accept_partial_bio);
>  
> -static blk_qc_t __map_bio(struct dm_target_io *tio)
> +static void __map_bio(struct dm_target_io *tio)
>  {
>  	int r;
>  	sector_t sector;
>  	struct bio *clone = &tio->clone;
>  	struct dm_io *io = tio->io;
>  	struct dm_target *ti = tio->ti;
> -	blk_qc_t ret = BLK_QC_T_NONE;
>  
>  	clone->bi_end_io = clone_endio;
>  
> @@ -1278,7 +1277,7 @@ static blk_qc_t __map_bio(struct dm_target_io *tio)
>  	case DM_MAPIO_REMAPPED:
>  		/* the bio has been remapped so dispatch it */
>  		trace_block_bio_remap(clone, bio_dev(io->orig_bio), sector);
> -		ret = submit_bio_noacct(clone);
> +		submit_bio_noacct(clone);
>  		break;
>  	case DM_MAPIO_KILL:
>  		free_tio(tio);
> @@ -1292,8 +1291,6 @@ static blk_qc_t __map_bio(struct dm_target_io *tio)
>  		DMWARN("unimplemented target map return value: %d", r);
>  		BUG();
>  	}
> -
> -	return ret;
>  }
>  
>  static void bio_setup_sector(struct bio *bio, sector_t sector, unsigned len)
> @@ -1380,7 +1377,7 @@ static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
>  	}
>  }
>  
> -static blk_qc_t __clone_and_map_simple_bio(struct clone_info *ci,
> +static void __clone_and_map_simple_bio(struct clone_info *ci,
>  					   struct dm_target_io *tio, unsigned *len)
>  {
>  	struct bio *clone = &tio->clone;
> @@ -1391,7 +1388,7 @@ static blk_qc_t __clone_and_map_simple_bio(struct clone_info *ci,
>  	if (len)
>  		bio_setup_sector(clone, ci->sector, *len);
>  
> -	return __map_bio(tio);
> +	__map_bio(tio);
>  }
>  
>  static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
> @@ -1405,7 +1402,7 @@ static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
>  
>  	while ((bio = bio_list_pop(&blist))) {
>  		tio = container_of(bio, struct dm_target_io, clone);
> -		(void) __clone_and_map_simple_bio(ci, tio, len);
> +		__clone_and_map_simple_bio(ci, tio, len);
>  	}
>  }
>  
> @@ -1450,7 +1447,7 @@ static int __clone_and_map_data_bio(struct clone_info *ci, struct dm_target *ti,
>  		free_tio(tio);
>  		return r;
>  	}
> -	(void) __map_bio(tio);
> +	__map_bio(tio);
>  
>  	return 0;
>  }
> @@ -1565,11 +1562,10 @@ static void init_clone_info(struct clone_info *ci, struct mapped_device *md,
>  /*
>   * Entry point to split a bio into clones and submit them to the targets.
>   */
> -static blk_qc_t __split_and_process_bio(struct mapped_device *md,
> +static void __split_and_process_bio(struct mapped_device *md,
>  					struct dm_table *map, struct bio *bio)
>  {
>  	struct clone_info ci;
> -	blk_qc_t ret = BLK_QC_T_NONE;
>  	int error = 0;
>  
>  	init_clone_info(&ci, md, map, bio);
> @@ -1613,7 +1609,7 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
>  
>  				bio_chain(b, bio);
>  				trace_block_split(b, bio->bi_iter.bi_sector);
> -				ret = submit_bio_noacct(bio);
> +				submit_bio_noacct(bio);
>  				break;
>  			}
>  		}
> @@ -1621,13 +1617,11 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
>  
>  	/* drop the extra reference count */
>  	dec_pending(ci.io, errno_to_blk_status(error));
> -	return ret;
>  }
>  
>  static blk_qc_t dm_submit_bio(struct bio *bio)
>  {
>  	struct mapped_device *md = bio->bi_disk->private_data;
> -	blk_qc_t ret = BLK_QC_T_NONE;
>  	int srcu_idx;
>  	struct dm_table *map;
>  
> @@ -1657,10 +1651,10 @@ static blk_qc_t dm_submit_bio(struct bio *bio)
>  	if (is_abnormal_io(bio))
>  		blk_queue_split(&bio);
>  
> -	ret = __split_and_process_bio(md, map, bio);
> +	__split_and_process_bio(md, map, bio);
>  out:
>  	dm_put_live_table(md, srcu_idx);
> -	return ret;
> +	return BLK_QC_T_NONE;
>  }
>  
>  /*-----------------------------------------------------------------
> -- 
> 2.27.0
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

