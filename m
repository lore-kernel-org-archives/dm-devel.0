Return-Path: <SRS0=5DIA=HG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE236C433DB
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 09:15:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 52DDA64E34
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 09:15:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 52DDA64E34
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-iseb6_zcOdG8DMEO9wNyUw-1; Thu, 04 Feb 2021 04:15:10 -0500
X-MC-Unique: iseb6_zcOdG8DMEO9wNyUw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A070801965;
	Thu,  4 Feb 2021 09:15:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A4485D9C9;
	Thu,  4 Feb 2021 09:15:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 11EF71809C92;
	Thu,  4 Feb 2021 09:15:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1146gWP3028856 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Feb 2021 01:42:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 257A42026D46; Thu,  4 Feb 2021 06:42:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 204EE2026D11
	for <dm-devel@redhat.com>; Thu,  4 Feb 2021 06:42:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 770E8811E88
	for <dm-devel@redhat.com>; Thu,  4 Feb 2021 06:42:29 +0000 (UTC)
Received: from out30-131.freemail.mail.aliyun.com
	(out30-131.freemail.mail.aliyun.com [115.124.30.131]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-71-dq82QDIiMqyfvT7MLSzmaA-1;
	Thu, 04 Feb 2021 01:42:24 -0500
X-MC-Unique: dq82QDIiMqyfvT7MLSzmaA-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R101e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
	TI=SMTPD_---0UNpW.4x_1612420936
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UNpW.4x_1612420936) by smtp.aliyun-inc.com(127.0.0.1);
	Thu, 04 Feb 2021 14:42:17 +0800
From: JeffleXu <jefflexu@linux.alibaba.com>
To: snitzer@redhat.com
References: <20210202033528.76166-1-jefflexu@linux.alibaba.com>
Message-ID: <b12bf9f6-c815-c97a-87c4-884b0e13542e@linux.alibaba.com>
Date: Thu, 4 Feb 2021 14:42:16 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210202033528.76166-1-jefflexu@linux.alibaba.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 04 Feb 2021 04:14:38 -0500
Cc: joseph.qi@linux.alibaba.com, msb@chromium.org, dm-devel@redhat.com,
	toshi.kani@hpe.com, mbroz@redhat.com
Subject: Re: [dm-devel] [PATCH] dm: fix iterate_device sanity check
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
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Any comment?

Thanks,
Jeffle


On 2/2/21 11:35 AM, Jeffle Xu wrote:
> According to the definition of dm_iterate_devices_fn:
>  * This function must iterate through each section of device used by the
>  * target until it encounters a non-zero return code, which it then returns.
>  * Returns zero if no callout returned non-zero.
> 
> For some target type (e.g., dm-stripe), one call of iterate_devices() may
> iterate multiple underlying devices internally, in which case a non-zero
> return code returned by iterate_devices_callout_fn will stop the iteration
> in advance.
> 
> Thus if we want to ensure that _all_ underlying devices support some kind of
> attribute, the iteration structure like dm_table_supports_nowait() should be
> used, while the input iterate_devices_callout_fn should handle the 'not
> support' semantics. On the opposite, the iteration structure like
> dm_table_any_device_attribute() should be used if _any_ underlying device
> supporting this attibute is sufficient. In this case, the input
> iterate_devices_callout_fn should handle the 'support' semantics.
> 
> Fixes: 545ed20e6df6 ("dm: add infrastructure for DAX support")
> Fixes: c3c4555edd10 ("dm table: clear add_random unless all devices have it set")
> Fixes: 4693c9668fdc ("dm table: propagate non rotational flag")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
>  drivers/md/dm-table.c | 84 ++++++++++++++++++++++---------------------
>  drivers/md/dm.c       |  2 +-
>  drivers/md/dm.h       |  2 +-
>  3 files changed, 46 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 4acf2342f7ad..53dcbf75eda9 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -820,24 +820,24 @@ void dm_table_set_type(struct dm_table *t, enum dm_queue_mode type)
>  EXPORT_SYMBOL_GPL(dm_table_set_type);
>  
>  /* validate the dax capability of the target device span */
> -int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
> +int device_not_dax_capable(struct dm_target *ti, struct dm_dev *dev,
>  			sector_t start, sector_t len, void *data)
>  {
>  	int blocksize = *(int *) data, id;
>  	bool rc;
>  
>  	id = dax_read_lock();
> -	rc = dax_supported(dev->dax_dev, dev->bdev, blocksize, start, len);
> +	rc = !dax_supported(dev->dax_dev, dev->bdev, blocksize, start, len);
>  	dax_read_unlock(id);
>  
>  	return rc;
>  }
>  
>  /* Check devices support synchronous DAX */
> -static int device_dax_synchronous(struct dm_target *ti, struct dm_dev *dev,
> +static int device_not_dax_synchronous_capable(struct dm_target *ti, struct dm_dev *dev,
>  				  sector_t start, sector_t len, void *data)
>  {
> -	return dev->dax_dev && dax_synchronous(dev->dax_dev);
> +	return !dev->dax_dev || !dax_synchronous(dev->dax_dev);
>  }
>  
>  bool dm_table_supports_dax(struct dm_table *t,
> @@ -854,7 +854,7 @@ bool dm_table_supports_dax(struct dm_table *t,
>  			return false;
>  
>  		if (!ti->type->iterate_devices ||
> -		    !ti->type->iterate_devices(ti, iterate_fn, blocksize))
> +		    ti->type->iterate_devices(ti, iterate_fn, blocksize))
>  			return false;
>  	}
>  
> @@ -925,7 +925,7 @@ static int dm_table_determine_type(struct dm_table *t)
>  verify_bio_based:
>  		/* We must use this table as bio-based */
>  		t->type = DM_TYPE_BIO_BASED;
> -		if (dm_table_supports_dax(t, device_supports_dax, &page_size) ||
> +		if (dm_table_supports_dax(t, device_not_dax_capable, &page_size) ||
>  		    (list_empty(devices) && live_md_type == DM_TYPE_DAX_BIO_BASED)) {
>  			t->type = DM_TYPE_DAX_BIO_BASED;
>  		}
> @@ -1595,12 +1595,12 @@ static int dm_table_supports_dax_write_cache(struct dm_table *t)
>  	return false;
>  }
>  
> -static int device_is_nonrot(struct dm_target *ti, struct dm_dev *dev,
> +static int device_is_rot(struct dm_target *ti, struct dm_dev *dev,
>  			    sector_t start, sector_t len, void *data)
>  {
>  	struct request_queue *q = bdev_get_queue(dev->bdev);
>  
> -	return q && blk_queue_nonrot(q);
> +	return q && !blk_queue_nonrot(q);
>  }
>  
>  static int device_is_not_random(struct dm_target *ti, struct dm_dev *dev,
> @@ -1611,8 +1611,8 @@ static int device_is_not_random(struct dm_target *ti, struct dm_dev *dev,
>  	return q && !blk_queue_add_random(q);
>  }
>  
> -static bool dm_table_all_devices_attribute(struct dm_table *t,
> -					   iterate_devices_callout_fn func)
> +static bool dm_table_any_device_attribute(struct dm_table *t,
> +					  iterate_devices_callout_fn func)
>  {
>  	struct dm_target *ti;
>  	unsigned i;
> @@ -1620,12 +1620,12 @@ static bool dm_table_all_devices_attribute(struct dm_table *t,
>  	for (i = 0; i < dm_table_get_num_targets(t); i++) {
>  		ti = dm_table_get_target(t, i);
>  
> -		if (!ti->type->iterate_devices ||
> -		    !ti->type->iterate_devices(ti, func, NULL))
> -			return false;
> +		if (ti->type->iterate_devices &&
> +		    ti->type->iterate_devices(ti, func, NULL))
> +			return true;
>  	}
>  
> -	return true;
> +	return false;
>  }
>  
>  static int device_not_write_same_capable(struct dm_target *ti, struct dm_dev *dev,
> @@ -1780,26 +1780,25 @@ static int device_requires_stable_pages(struct dm_target *ti,
>  }
>  
>  /*
> - * If any underlying device requires stable pages, a table must require
> - * them as well.  Only targets that support iterate_devices are considered:
> - * don't want error, zero, etc to require stable pages.
> + * type->iterate_devices() should be called when the sanity check needs to
> + * iterate and check all underlying data devices. iterate_devices() will
> + * iterate all underlying data devices until it encounters a non-zero return
> + * code, returned by whether the input iterate_devices_callout_fn, or
> + * iterate_devices() itself internally.
> + *
> + * For some target type (e.g., dm-stripe), one call of iterate_devices() may
> + * iterate multiple underlying devices internally, in which case a non-zero
> + * return code returned by iterate_devices_callout_fn will stop the iteration
> + * in advance.
> + *
> + * Thus if we want to ensure that _all_ underlying devices support some kind of
> + * attribute, the iteration structure like dm_table_supports_nowait() should be
> + * used, while the input iterate_devices_callout_fn should handle the 'not
> + * support' semantics. On the opposite, the iteration structure like
> + * dm_table_any_device_attribute() should be used if _any_ underlying device
> + * supporting this attibute is sufficient. In this case, the input
> + * iterate_devices_callout_fn should handle the 'support' semantics.
>   */
> -static bool dm_table_requires_stable_pages(struct dm_table *t)
> -{
> -	struct dm_target *ti;
> -	unsigned i;
> -
> -	for (i = 0; i < dm_table_get_num_targets(t); i++) {
> -		ti = dm_table_get_target(t, i);
> -
> -		if (ti->type->iterate_devices &&
> -		    ti->type->iterate_devices(ti, device_requires_stable_pages, NULL))
> -			return true;
> -	}
> -
> -	return false;
> -}
> -
>  void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  			       struct queue_limits *limits)
>  {
> @@ -1837,9 +1836,9 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  	}
>  	blk_queue_write_cache(q, wc, fua);
>  
> -	if (dm_table_supports_dax(t, device_supports_dax, &page_size)) {
> +	if (dm_table_supports_dax(t, device_not_dax_capable, &page_size)) {
>  		blk_queue_flag_set(QUEUE_FLAG_DAX, q);
> -		if (dm_table_supports_dax(t, device_dax_synchronous, NULL))
> +		if (dm_table_supports_dax(t, device_not_dax_synchronous_capable, NULL))
>  			set_dax_synchronous(t->md->dax_dev);
>  	}
>  	else
> @@ -1849,10 +1848,10 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  		dax_write_cache(t->md->dax_dev, true);
>  
>  	/* Ensure that all underlying devices are non-rotational. */
> -	if (dm_table_all_devices_attribute(t, device_is_nonrot))
> -		blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
> -	else
> +	if (dm_table_any_device_attribute(t, device_is_rot))
>  		blk_queue_flag_clear(QUEUE_FLAG_NONROT, q);
> +	else
> +		blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
>  
>  	if (!dm_table_supports_write_same(t))
>  		q->limits.max_write_same_sectors = 0;
> @@ -1864,8 +1863,11 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  	/*
>  	 * Some devices don't use blk_integrity but still want stable pages
>  	 * because they do their own checksumming.
> +	 * If any underlying device requires stable pages, a table must require
> +	 * them as well.  Only targets that support iterate_devices are considered:
> +	 * don't want error, zero, etc to require stable pages.
>  	 */
> -	if (dm_table_requires_stable_pages(t))
> +	if (dm_table_any_device_attribute(t, device_requires_stable_pages))
>  		blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, q);
>  	else
>  		blk_queue_flag_clear(QUEUE_FLAG_STABLE_WRITES, q);
> @@ -1876,8 +1878,10 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  	 * Clear QUEUE_FLAG_ADD_RANDOM if any underlying device does not
>  	 * have it set.
>  	 */
> -	if (blk_queue_add_random(q) && dm_table_all_devices_attribute(t, device_is_not_random))
> +	if (dm_table_any_device_attribute(t, device_is_not_random))
>  		blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, q);
> +	else
> +		blk_queue_flag_set(QUEUE_FLAG_ADD_RANDOM, q);
>  
>  	/*
>  	 * For a zoned target, the number of zones should be updated for the
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 7bac564f3faa..8a3d73efb9dd 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1128,7 +1128,7 @@ static bool dm_dax_supported(struct dax_device *dax_dev, struct block_device *bd
>  	if (!map)
>  		goto out;
>  
> -	ret = dm_table_supports_dax(map, device_supports_dax, &blocksize);
> +	ret = dm_table_supports_dax(map, device_not_dax_capable, &blocksize);
>  
>  out:
>  	dm_put_live_table(md, srcu_idx);
> diff --git a/drivers/md/dm.h b/drivers/md/dm.h
> index fffe1e289c53..b441ad772c18 100644
> --- a/drivers/md/dm.h
> +++ b/drivers/md/dm.h
> @@ -73,7 +73,7 @@ void dm_table_free_md_mempools(struct dm_table *t);
>  struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
>  bool dm_table_supports_dax(struct dm_table *t, iterate_devices_callout_fn fn,
>  			   int *blocksize);
> -int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
> +int device_not_dax_capable(struct dm_target *ti, struct dm_dev *dev,
>  			   sector_t start, sector_t len, void *data);
>  
>  void dm_lock_md_type(struct mapped_device *md);
> 

-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

