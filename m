Return-Path: <SRS0=sZ2e=JU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F1EAC433ED
	for <dm-devel@archiver.kernel.org>; Fri, 23 Apr 2021 08:14:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F0002613AD
	for <dm-devel@archiver.kernel.org>; Fri, 23 Apr 2021 08:14:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F0002613AD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-zSTzqhJdN0GndmeVejOgKQ-1; Fri, 23 Apr 2021 04:14:06 -0400
X-MC-Unique: zSTzqhJdN0GndmeVejOgKQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A85DC102CB72;
	Fri, 23 Apr 2021 08:14:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AD645D9C6;
	Fri, 23 Apr 2021 08:13:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 606A01806D1A;
	Fri, 23 Apr 2021 08:13:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13N1WqPr025113 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 22 Apr 2021 21:32:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 883221054FCC; Fri, 23 Apr 2021 01:32:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 83DF51054FD3
	for <dm-devel@redhat.com>; Fri, 23 Apr 2021 01:32:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9AE0F101A529
	for <dm-devel@redhat.com>; Fri, 23 Apr 2021 01:32:47 +0000 (UTC)
Received: from out30-133.freemail.mail.aliyun.com
	(out30-133.freemail.mail.aliyun.com [115.124.30.133]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-108-SledjYOuM4Kc3rHx717pzw-1;
	Thu, 22 Apr 2021 21:32:42 -0400
X-MC-Unique: SledjYOuM4Kc3rHx717pzw-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R171e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04423;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
	TI=SMTPD_---0UWS0UzP_1619141558
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UWS0UzP_1619141558) by smtp.aliyun-inc.com(127.0.0.1);
	Fri, 23 Apr 2021 09:32:38 +0800
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
References: <20210422122038.2192933-1-ming.lei@redhat.com>
	<20210422122038.2192933-13-ming.lei@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <3681e443-0381-b916-101d-f5e6cc2c8d7a@linux.alibaba.com>
Date: Fri, 23 Apr 2021 09:32:38 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210422122038.2192933-13-ming.lei@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 23 Apr 2021 04:13:54 -0400
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH V6 12/12] dm: support IO polling for
	bio-based dm device
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 4/22/21 8:20 PM, Ming Lei wrote:
> From: Jeffle Xu <jefflexu@linux.alibaba.com>
> 
> IO polling is enabled when all underlying target devices are capable
> of IO polling. The sanity check supports the stacked device model, in
> which one dm device may be build upon another dm device. In this case,
> the mapped device will check if the underlying dm target device
> supports IO polling.
> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/md/dm-table.c         | 24 ++++++++++++++++++++++++
>  drivers/md/dm.c               |  2 ++
>  include/linux/device-mapper.h |  1 +
>  3 files changed, 27 insertions(+)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 95391f78b8d5..a8f3575fb118 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1509,6 +1509,12 @@ struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector)
>  	return &t->targets[(KEYS_PER_NODE * n) + k];
>  }
>  
> +static int device_not_poll_capable(struct dm_target *ti, struct dm_dev *dev,
> +				   sector_t start, sector_t len, void *data)
> +{
> +	return !blk_queue_poll(bdev_get_queue(dev->bdev));
> +}
> +
>  /*
>   * type->iterate_devices() should be called when the sanity check needs to
>   * iterate and check all underlying data devices. iterate_devices() will
> @@ -1559,6 +1565,11 @@ static int count_device(struct dm_target *ti, struct dm_dev *dev,
>  	return 0;
>  }
>  
> +int dm_table_supports_poll(struct dm_table *t)
> +{
> +	return !dm_table_any_dev_attr(t, device_not_poll_capable, NULL);
> +}
> +

Since .poll_capable() has been dropped, dm_table_supports_poll() can be
declared as 'static' here.

>  /*
>   * Check whether a table has no data devices attached using each
>   * target's iterate_devices method.
> @@ -2079,6 +2090,19 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  
>  	dm_update_keyslot_manager(q, t);
>  	blk_queue_update_readahead(q);
> +
> +	/*
> +	 * Check for request-based device is remained to
> +	 * dm_mq_init_request_queue()->blk_mq_init_allocated_queue().
> +	 * For bio-based device, only set QUEUE_FLAG_POLL when all underlying
> +	 * devices supporting polling.
> +	 */
> +	if (__table_type_bio_based(t->type)) {
> +		if (dm_table_supports_poll(t))
> +			blk_queue_flag_set(QUEUE_FLAG_POLL, q);
> +		else
> +			blk_queue_flag_clear(QUEUE_FLAG_POLL, q);
> +	}
>  }
>  
>  unsigned int dm_table_get_num_targets(struct dm_table *t)
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 50b693d776d6..1b160e4e6446 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2175,6 +2175,8 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
>  		}
>  		break;
>  	case DM_TYPE_BIO_BASED:
> +		/* tell block layer we are capable of bio polling */
> +		md->disk->flags |= GENHD_FL_CAP_BIO_POLL;
>  	case DM_TYPE_DAX_BIO_BASED:
>  		break;
>  	case DM_TYPE_NONE:


> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index 7f4ac87c0b32..31bfd6f70013 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -538,6 +538,7 @@ unsigned int dm_table_get_num_targets(struct dm_table *t);
>  fmode_t dm_table_get_mode(struct dm_table *t);
>  struct mapped_device *dm_table_get_md(struct dm_table *t);
>  const char *dm_table_device_name(struct dm_table *t);
> +int dm_table_supports_poll(struct dm_table *t);

Similarly, dm_table_supports_poll() doesn't need to be exported.

-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

