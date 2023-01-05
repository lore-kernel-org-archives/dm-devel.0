Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1137C3DA7A
	for <dm-devel@archiver.kernel.org>; Thu,  5 Jan 2023 14:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1672929748;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZkUjq61qBjYS9QOIPkOG+eB2wN2DSyxBqaKFHEsjd1I=;
	b=LVsHEieyX2nCLmO/Q8z1k6sIxp5qboolo3AHh0rL1h9eg8cPNtp+cyeug1CSccrKRFeepX
	MzsG2tRnZjkb+RYly+hIjq/aGzbit2GHfyWopjK68tRMFI+sWyVmF5ChCFNQS2qFeK5KvT
	iDdGkEG+iG5+andKlHb26Qqy7JdA5+g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-OahfKumGPPqoKiYaRgZsoA-1; Thu, 05 Jan 2023 09:42:25 -0500
X-MC-Unique: OahfKumGPPqoKiYaRgZsoA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8938A3811F3F;
	Thu,  5 Jan 2023 14:42:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DF12D140EBF6;
	Thu,  5 Jan 2023 14:42:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 87FA81946589;
	Thu,  5 Jan 2023 14:42:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6D7091946586
 for <dm-devel@listman.corp.redhat.com>; Thu,  5 Jan 2023 14:42:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4F838400E40A; Thu,  5 Jan 2023 14:42:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4886640C115E
 for <dm-devel@redhat.com>; Thu,  5 Jan 2023 14:42:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27ACF1C0759A
 for <dm-devel@redhat.com>; Thu,  5 Jan 2023 14:42:19 +0000 (UTC)
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-150-xqGPwHdHOQqL_9gp8bXG1A-1; Thu, 05 Jan 2023 09:42:16 -0500
X-MC-Unique: xqGPwHdHOQqL_9gp8bXG1A-1
Received: by mail-yw1-f200.google.com with SMTP id
 00721157ae682-473b193ada5so297254697b3.2
 for <dm-devel@redhat.com>; Thu, 05 Jan 2023 06:42:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=wjyslnCj3ZEltR7C79+zwgm2T1VJBZSXYdTg0fe8CHE=;
 b=xZskLxnBxV3AQ9lpkvja3qretGC88YwztTHl2B6FevqvTotJ0HMtqFMWASu/JR1ggG
 HiOVaoab9grIAPxe8FYpab2tYsUXPqgKV3f6Bd2rP96Q2vXo01d9hpVTLQp5D36ujo3X
 TATmxo0rk3/6qWCoe8JZkA4m8uxaEoe7IOAb8ox2pS+zSML3V7pQzmjufnikj6RX1j7d
 yFqQuMtoLcmS+B/TKbo+xVxSoi5oDjsgr+0O9dB4HQFeMlWLUguL/VBzm+m3cF74eFng
 k0qj42tzgRZDnfi7OXG7e9V5vrbJSjX++43Gdoy9R9E/+f7Wd9STLgIEzV0BJbE61L3d
 tTIg==
X-Gm-Message-State: AFqh2kqbFIeW2HWTwybOY5HzooOzarIRF3t1JLuShif3uEAPrqqxeEJA
 7MIgZg4i3QH82YG0FkzZ42RI0XydmrUrzDER5NlAOhqQOcDl3YGB2smFD/jnCMH3RVFhkB//ky1
 /V7rbZwSbEZAANyU=
X-Received: by 2002:a05:690c:d84:b0:4b5:c61:1c02 with SMTP id
 da4-20020a05690c0d8400b004b50c611c02mr9863320ywb.22.1672929736358; 
 Thu, 05 Jan 2023 06:42:16 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtgZGayMfn5T2A3YgNPQf9Hcxwo0jOEuaE/UPyg5j2hL0RrzHck6nvnDV5RBSK1tNEA18Dwmw==
X-Received: by 2002:a05:690c:d84:b0:4b5:c61:1c02 with SMTP id
 da4-20020a05690c0d8400b004b50c611c02mr9863296ywb.22.1672929736089; 
 Thu, 05 Jan 2023 06:42:16 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
 by smtp.gmail.com with ESMTPSA id
 ay34-20020a05620a17a200b006b929a56a2bsm25634809qkb.3.2023.01.05.06.42.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 05 Jan 2023 06:42:15 -0800 (PST)
Date: Thu, 5 Jan 2023 09:43:13 -0500
From: Brian Foster <bfoster@redhat.com>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <Y7biAQyLKJDjsAlz@bfoster>
References: <20221229081252.452240-1-sarthakkukreti@chromium.org>
 <20221229081252.452240-3-sarthakkukreti@chromium.org>
MIME-Version: 1.0
In-Reply-To: <20221229081252.452240-3-sarthakkukreti@chromium.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v2 2/7] dm: Add support for block provisioning
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
 sarthakkukreti@google.com, "Darrick J. Wong" <djwong@kernel.org>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Dec 29, 2022 at 12:12:47AM -0800, Sarthak Kukreti wrote:
> Add support to dm devices for REQ_OP_PROVISION. The default mode
> is to pass through the request and dm-thin will utilize it to provision
> blocks.
> 
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> ---
>  drivers/md/dm-crypt.c         |  4 +-
>  drivers/md/dm-linear.c        |  1 +
>  drivers/md/dm-snap.c          |  7 +++
>  drivers/md/dm-table.c         | 25 ++++++++++
>  drivers/md/dm-thin.c          | 90 ++++++++++++++++++++++++++++++++++-
>  drivers/md/dm.c               |  4 ++
>  include/linux/device-mapper.h | 11 +++++
>  7 files changed, 139 insertions(+), 3 deletions(-)
> 
...
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index 64cfcf46881d..ab3f1abfabaf 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
...
> @@ -1980,6 +1992,70 @@ static void process_cell(struct thin_c *tc, struct dm_bio_prison_cell *cell)
>  	}
>  }
>  
> +static void process_provision_cell(struct thin_c *tc, struct dm_bio_prison_cell *cell)
> +{
> +	int r;
> +	struct pool *pool = tc->pool;
> +	struct bio *bio = cell->holder;
> +	dm_block_t begin, end;
> +	struct dm_thin_lookup_result lookup_result;
> +
> +	if (tc->requeue_mode) {
> +		cell_requeue(pool, cell);
> +		return;
> +	}
> +
> +	get_bio_block_range(tc, bio, &begin, &end);
> +
> +	while (begin != end) {
> +		r = ensure_next_mapping(pool);
> +		if (r)
> +			/* we did our best */
> +			return;
> +
> +		r = dm_thin_find_block(tc->td, begin, 1, &lookup_result);

Hi Sarthak,

I think we discussed this before.. but remind me if/how we wanted to
handle the case if the thin blocks are shared..? Would a provision op
carry enough information to distinguish an FALLOC_FL_UNSHARE_RANGE
request from upper layers to conditionally provision in that case?

Brian

> +		switch (r) {
> +		case 0:
> +			begin++;
> +			break;
> +		case -ENODATA:
> +			bio_inc_remaining(bio);
> +			provision_block(tc, bio, begin, cell);
> +			begin++;
> +			break;
> +		default:
> +			DMERR_LIMIT(
> +				"%s: dm_thin_find_block() failed: error = %d",
> +				__func__, r);
> +			cell_defer_no_holder(tc, cell);
> +			bio_io_error(bio);
> +			begin++;
> +			break;
> +		}
> +	}
> +	bio_endio(bio);
> +	cell_defer_no_holder(tc, cell);
> +}
> +
> +static void process_provision_bio(struct thin_c *tc, struct bio *bio)
> +{
> +	dm_block_t begin, end;
> +	struct dm_cell_key virt_key;
> +	struct dm_bio_prison_cell *virt_cell;
> +
> +	get_bio_block_range(tc, bio, &begin, &end);
> +	if (begin == end) {
> +		bio_endio(bio);
> +		return;
> +	}
> +
> +	build_key(tc->td, VIRTUAL, begin, end, &virt_key);
> +	if (bio_detain(tc->pool, &virt_key, bio, &virt_cell))
> +		return;
> +
> +	process_provision_cell(tc, virt_cell);
> +}
> +
>  static void process_bio(struct thin_c *tc, struct bio *bio)
>  {
>  	struct pool *pool = tc->pool;
> @@ -2200,6 +2276,8 @@ static void process_thin_deferred_bios(struct thin_c *tc)
>  
>  		if (bio_op(bio) == REQ_OP_DISCARD)
>  			pool->process_discard(tc, bio);
> +		else if (bio_op(bio) == REQ_OP_PROVISION)
> +			process_provision_bio(tc, bio);
>  		else
>  			pool->process_bio(tc, bio);
>  
> @@ -2716,7 +2794,8 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
>  		return DM_MAPIO_SUBMITTED;
>  	}
>  
> -	if (op_is_flush(bio->bi_opf) || bio_op(bio) == REQ_OP_DISCARD) {
> +	if (op_is_flush(bio->bi_opf) || bio_op(bio) == REQ_OP_DISCARD ||
> +	    bio_op(bio) == REQ_OP_PROVISION) {
>  		thin_defer_bio_with_throttle(tc, bio);
>  		return DM_MAPIO_SUBMITTED;
>  	}
> @@ -3355,6 +3434,8 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
>  	pt->low_water_blocks = low_water_blocks;
>  	pt->adjusted_pf = pt->requested_pf = pf;
>  	ti->num_flush_bios = 1;
> +	ti->num_provision_bios = 1;
> +	ti->provision_supported = true;
>  
>  	/*
>  	 * Only need to enable discards if the pool should pass
> @@ -4053,6 +4134,7 @@ static void pool_io_hints(struct dm_target *ti, struct queue_limits *limits)
>  		blk_limits_io_opt(limits, pool->sectors_per_block << SECTOR_SHIFT);
>  	}
>  
> +
>  	/*
>  	 * pt->adjusted_pf is a staging area for the actual features to use.
>  	 * They get transferred to the live pool in bind_control_target()
> @@ -4243,6 +4325,9 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
>  		ti->num_discard_bios = 1;
>  	}
>  
> +	ti->num_provision_bios = 1;
> +	ti->provision_supported = true;
> +
>  	mutex_unlock(&dm_thin_pool_table.mutex);
>  
>  	spin_lock_irq(&tc->pool->lock);
> @@ -4457,6 +4542,7 @@ static void thin_io_hints(struct dm_target *ti, struct queue_limits *limits)
>  
>  	limits->discard_granularity = pool->sectors_per_block << SECTOR_SHIFT;
>  	limits->max_discard_sectors = 2048 * 1024 * 16; /* 16G */
> +	limits->max_provision_sectors = 2048 * 1024 * 16; /* 16G */
>  }
>  
>  static struct target_type thin_target = {
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index e1ea3a7bd9d9..4d19bae9da4a 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1587,6 +1587,7 @@ static bool is_abnormal_io(struct bio *bio)
>  		case REQ_OP_DISCARD:
>  		case REQ_OP_SECURE_ERASE:
>  		case REQ_OP_WRITE_ZEROES:
> +		case REQ_OP_PROVISION:
>  			return true;
>  		default:
>  			break;
> @@ -1611,6 +1612,9 @@ static blk_status_t __process_abnormal_io(struct clone_info *ci,
>  	case REQ_OP_WRITE_ZEROES:
>  		num_bios = ti->num_write_zeroes_bios;
>  		break;
> +	case REQ_OP_PROVISION:
> +		num_bios = ti->num_provision_bios;
> +		break;
>  	default:
>  		break;
>  	}
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index 04c6acf7faaa..b4d97d5d75b8 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -333,6 +333,12 @@ struct dm_target {
>  	 */
>  	unsigned num_write_zeroes_bios;
>  
> +	/*
> +	 * The number of PROVISION bios that will be submitted to the target.
> +	 * The bio number can be accessed with dm_bio_get_target_bio_nr.
> +	 */
> +	unsigned num_provision_bios;
> +
>  	/*
>  	 * The minimum number of extra bytes allocated in each io for the
>  	 * target to use.
> @@ -357,6 +363,11 @@ struct dm_target {
>  	 */
>  	bool discards_supported:1;
>  
> +	/* Set if this target needs to receive provision requests regardless of
> +	 * whether or not its underlying devices have support.
> +	 */
> +	bool provision_supported:1;
> +
>  	/*
>  	 * Set if we need to limit the number of in-flight bios when swapping.
>  	 */
> -- 
> 2.37.3
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

