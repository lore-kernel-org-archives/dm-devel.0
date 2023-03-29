Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58A24C6FD18
	for <dm-devel@archiver.kernel.org>; Wed, 29 Mar 2023 09:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680080421;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dITnyWxzYa6xWx7BFwShXJ0+poCD+Xc6tzkPD13qYys=;
	b=Yg4NGazXv8ese9emJ02eTHAFr0dQM3F+gxYWpl3fB03juGr0rlOHQBkjz0deUR55c4pB3f
	Qo8AA/uW92ajnSi0rcInFjkIbT5bIu871NM5c1a611oAp13jZgqTj2i4j8KtOn71SVU5HL
	joy1q4aiWQNtPPXbs5mhDap6mRZ/Y9E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-pJwgxC08MIKHejx36pQyeQ-1; Wed, 29 Mar 2023 05:00:17 -0400
X-MC-Unique: pJwgxC08MIKHejx36pQyeQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A0111C09504;
	Wed, 29 Mar 2023 09:00:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6817418EC6;
	Wed, 29 Mar 2023 09:00:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5470B194658D;
	Wed, 29 Mar 2023 09:00:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 939D4194658F
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 09:00:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CEF6C4042AC5; Wed, 29 Mar 2023 09:00:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C6B304042AC0
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 09:00:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A9C02101A550
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 09:00:00 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-OaszXkc0NpKfs7P3jY-yLQ-2; Wed, 29 Mar 2023 04:59:59 -0400
X-MC-Unique: OaszXkc0NpKfs7P3jY-yLQ-2
X-IronPort-AV: E=Sophos;i="5.98,300,1673884800"; d="scan'208";a="231750557"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 29 Mar 2023 16:59:56 +0800
IronPort-SDR: A3NIwD7MH0CpX86i55f1CiRUw01w/bq9aE/spvNv/5qzCaDtTSDlBctPJVNmh7VH2QGtDS4XKh
 9XPgomn3bD/WuQmcgey4WraUClscVfK+Sexp3VvAUMb32CMiBaCP/MjdaefMKabnaR856g/2F8
 kh2PHcfgsZUhTjjCAGNwAzKcY1+6l1jq9rzMHGfFZ+/G080ZTPeivFkbyxZ+UdCZdvzEMFLzDv
 YAfKck4KR8GGWrlIbQUvUqm2Exy2jUzhJayniNWgAq5UoIJa2fbU2KC517hzOBslOSTuQKAF+K
 QsE=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 01:10:25 -0700
IronPort-SDR: LQ66/XxMPmkNfYIcnNxH3+g6QfNfhKvS321AtMPgLMLlaI6mudpvTekDOnXQ6W/O1G1/A4KsZu
 uJZ6v2exrkQfyrw5+uxQyWtqpJUNY4aAqBK0y0iSr3utLsSjswkS3UUJlLhKfgl/zSU+QtXlYS
 xuCzNdLbO4WXnjQZYCGnUwn8PUHCDQjLIcG7a1+unZDcxrgFSF1hC8fb+2TWj0o1yBCJ51hDO3
 hfa/Ju54uMbxhQvC7geG8572UBSNjZZSrOaS1Wy3ih9zK4nCfei3nyQyVT912Qw3UkjC1fObxc
 Qt8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 01:59:57 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PmgVN09knz1RtVw
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 01:59:55 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id 9A17r_cgKWb9 for <dm-devel@redhat.com>;
 Wed, 29 Mar 2023 01:59:54 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PmgVH0M2xz1RtVm;
 Wed, 29 Mar 2023 01:59:50 -0700 (PDT)
Message-ID: <3b9adeb6-4295-6e6a-9e93-7c5a06441830@opensource.wdc.com>
Date: Wed, 29 Mar 2023 17:59:49 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To: Anuj Gupta <anuj20.g@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 James Smart <james.smart@broadcom.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
References: <20230327084103.21601-1-anuj20.g@samsung.com>
 <CGME20230327084312epcas5p377810b172aa6048519591518f8c308d0@epcas5p3.samsung.com>
 <20230327084103.21601-8-anuj20.g@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20230327084103.21601-8-anuj20.g@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v8 7/9] dm: Add support for copy offload.
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
Cc: bvanassche@acm.org, joshi.k@samsung.com, gost.dev@samsung.com,
 nitheshshetty@gmail.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, ming.lei@redhat.com,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: opensource.wdc.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/27/23 17:40, Anuj Gupta wrote:
> From: Nitesh Shetty <nj.shetty@samsung.com>
> 

Drop the period at the end of the patch title.

> Before enabling copy for dm target, check if underlying devices and
> dm target support copy. Avoid split happening inside dm target.
> Fail early if the request needs split, currently splitting copy
> request is not supported.
> 
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> ---
>  drivers/md/dm-table.c         | 42 +++++++++++++++++++++++++++++++++++
>  drivers/md/dm.c               |  7 ++++++
>  include/linux/device-mapper.h |  5 +++++
>  3 files changed, 54 insertions(+)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 7899f5fb4c13..45e894b9e3be 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1863,6 +1863,39 @@ static bool dm_table_supports_nowait(struct dm_table *t)
>  	return true;
>  }
>  
> +static int device_not_copy_capable(struct dm_target *ti, struct dm_dev *dev,
> +				      sector_t start, sector_t len, void *data)
> +{
> +	struct request_queue *q = bdev_get_queue(dev->bdev);
> +
> +	return !blk_queue_copy(q);
> +}
> +
> +static bool dm_table_supports_copy(struct dm_table *t)
> +{
> +	struct dm_target *ti;
> +	unsigned int i;
> +
> +	for (i = 0; i < t->num_targets; i++) {
> +		ti = dm_table_get_target(t, i);
> +
> +		if (!ti->copy_offload_supported)
> +			return false;
> +
> +		/*
> +		 * target provides copy support (as implied by setting
> +		 * 'copy_offload_supported')
> +		 * and it relies on _all_ data devices having copy support.
> +		 */
> +		if (!ti->type->iterate_devices ||
> +		     ti->type->iterate_devices(ti,
> +			     device_not_copy_capable, NULL))
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
>  static int device_not_discard_capable(struct dm_target *ti, struct dm_dev *dev,
>  				      sector_t start, sector_t len, void *data)
>  {
> @@ -1945,6 +1978,15 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  		q->limits.discard_misaligned = 0;
>  	}
>  
> +	if (!dm_table_supports_copy(t)) {
> +		blk_queue_flag_clear(QUEUE_FLAG_COPY, q);
> +		/* Must also clear copy limits... */

Not a useful comment. The code is clear.

> +		q->limits.max_copy_sectors = 0;
> +		q->limits.max_copy_sectors_hw = 0;
> +	} else {
> +		blk_queue_flag_set(QUEUE_FLAG_COPY, q);
> +	}
> +
>  	if (!dm_table_supports_secure_erase(t))
>  		q->limits.max_secure_erase_sectors = 0;
>  
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 2d0f934ba6e6..08ec51000af8 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1693,6 +1693,13 @@ static blk_status_t __split_and_process_bio(struct clone_info *ci)
>  	if (unlikely(ci->is_abnormal_io))
>  		return __process_abnormal_io(ci, ti);
>  
> +	if ((unlikely(op_is_copy(ci->bio->bi_opf)) &&
> +			max_io_len(ti, ci->sector) < ci->sector_count)) {
> +		DMERR("Error, IO size(%u) > max target size(%llu)\n",
> +			ci->sector_count, max_io_len(ti, ci->sector));
> +		return BLK_STS_IOERR;
> +	}
> +
>  	/*
>  	 * Only support bio polling for normal IO, and the target io is
>  	 * exactly inside the dm_io instance (verified in dm_poll_dm_io)
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index 7975483816e4..44969a20295e 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -380,6 +380,11 @@ struct dm_target {
>  	 * bio_set_dev(). NOTE: ideally a target should _not_ need this.
>  	 */
>  	bool needs_bio_set_dev:1;
> +
> +	/*
> +	 * copy offload is supported
> +	 */
> +	bool copy_offload_supported:1;
>  };
>  
>  void *dm_per_bio_data(struct bio *bio, size_t data_size);

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

