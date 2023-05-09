Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1C95C77B75
	for <dm-devel@archiver.kernel.org>; Tue,  9 May 2023 16:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683651548;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=legn5PytTSIXizjO4JSCi4NPcfCzgExe0hTNmBXzKlY=;
	b=b229yYiGJv+9CGZM4jycj/JLMQYAow09Sh6VozWRRQuhuFw7ELUqVQb3aXJNSvZKTiYXk3
	DtljvSZW5/hSyVw7kmQ0V/1xnZKE2vR0k2FqxGUTJgEUMhp71HL/qrKRLGe2alL+PXoc8a
	Yeuwns3AerUs0P9JjwmyNtV/AkWXkCQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-0tiiN3lkMmWXAcAtK1lSKQ-1; Tue, 09 May 2023 12:59:05 -0400
X-MC-Unique: 0tiiN3lkMmWXAcAtK1lSKQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D26F867959;
	Tue,  9 May 2023 16:59:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C48CE40C206F;
	Tue,  9 May 2023 16:59:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 77A1619465BD;
	Tue,  9 May 2023 16:59:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CED0219465BC
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 May 2023 16:59:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BE0D0C084BB; Tue,  9 May 2023 16:59:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B61EBC16024
 for <dm-devel@redhat.com>; Tue,  9 May 2023 16:59:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 942983822DEB
 for <dm-devel@redhat.com>; Tue,  9 May 2023 16:59:00 +0000 (UTC)
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com
 [209.85.219.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-22-PcjAXWSbOeGW5JtMgNmegg-1; Tue, 09 May 2023 12:58:52 -0400
X-MC-Unique: PcjAXWSbOeGW5JtMgNmegg-1
Received: by mail-qv1-f47.google.com with SMTP id
 6a1803df08f44-61b6101a1b9so28555936d6.3
 for <dm-devel@redhat.com>; Tue, 09 May 2023 09:58:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1683651532; x=1686243532;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=ZNfiDYylpHckBsTJBtckQjf+FcPfo0wjhkF9b1/i4T8=;
 b=E0lxnhDnTpYpIXmQa2WjoqDQpjGla6pJMGJ73QzsxXLqrqXrrrYCmfq1HALzlfvxsZ
 2AQLOInigOXXwImn44k1XWJtnYPGjtwaueyCUNI03YvoMUY9uCMsH5e7r51gmAWpVUM6
 wE4G75qPOhQnscOj3XXGiPxtgEwxwNlpsgM+12pw2rizJ5rCPNNdbjdl1FPS5F1juHMV
 p/VMR5SwDBvvAqE2UHnPpftHiXLbGUx/RJ6SEfLvVzLDgzEogGXHqXV/4CYfRJpcvbTW
 IAUw+6W0bIEYDOrLXL11wxFpWLK6TetPR75tuxSfx5JAHsVTFLMNTcPqC5HNtH3VqYdh
 zehQ==
X-Gm-Message-State: AC+VfDwc4gqa7Zj0qXtANUXoh0OCbfS4N7ANPDZs+Z2W5S2sknGetJPW
 xRbv9LwY15kNy+JJ9eQBC9ig6uU=
X-Google-Smtp-Source: ACHHUZ6uxzUunep6oGxrhGEI8fJWpdH9biEaIAPK8tnW9no4oBDOuhDxrDrorqXw1bgEv5VB07afuQ==
X-Received: by 2002:a05:6214:528b:b0:621:44ee:7065 with SMTP id
 kj11-20020a056214528b00b0062144ee7065mr1016696qvb.9.1683651532284; 
 Tue, 09 May 2023 09:58:52 -0700 (PDT)
Received: from localhost ([217.138.208.150]) by smtp.gmail.com with ESMTPSA id
 pp16-20020a056214139000b006168277998csm896786qvb.58.2023.05.09.09.58.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 09 May 2023 09:58:51 -0700 (PDT)
Date: Tue, 9 May 2023 12:58:50 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <ZFp7ykxGFUbPG1ON@redhat.com>
References: <20230420004850.297045-1-sarthakkukreti@chromium.org>
 <20230506062909.74601-1-sarthakkukreti@chromium.org>
 <20230506062909.74601-5-sarthakkukreti@chromium.org>
MIME-Version: 1.0
In-Reply-To: <20230506062909.74601-5-sarthakkukreti@chromium.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v6 4/5] dm-thin: Add REQ_OP_PROVISION support
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
 Bart Van Assche <bvanassche@google.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, May 06 2023 at  2:29P -0400,
Sarthak Kukreti <sarthakkukreti@chromium.org> wrote:

> dm-thinpool uses the provision request to provision
> blocks for a dm-thin device. dm-thinpool currently does not
> pass through REQ_OP_PROVISION to underlying devices.
> 
> For shared blocks, provision requests will break sharing and copy the
> contents of the entire block. Additionally, if 'skip_block_zeroing'
> is not set, dm-thin will opt to zero out the entire range as a part
> of provisioning.
> 
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> ---
>  drivers/md/dm-thin.c | 70 +++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 66 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index 2b13c949bd72..3f94f53ac956 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -274,6 +274,7 @@ struct pool {
>  
>  	process_bio_fn process_bio;
>  	process_bio_fn process_discard;
> +	process_bio_fn process_provision;
>  
>  	process_cell_fn process_cell;
>  	process_cell_fn process_discard_cell;
> @@ -913,7 +914,8 @@ static void __inc_remap_and_issue_cell(void *context,
>  	struct bio *bio;
>  
>  	while ((bio = bio_list_pop(&cell->bios))) {
> -		if (op_is_flush(bio->bi_opf) || bio_op(bio) == REQ_OP_DISCARD)
> +		if (op_is_flush(bio->bi_opf) || bio_op(bio) == REQ_OP_DISCARD ||
> +		    bio_op(bio) == REQ_OP_PROVISION)
>  			bio_list_add(&info->defer_bios, bio);
>  		else {
>  			inc_all_io_entry(info->tc->pool, bio);
> @@ -1245,8 +1247,8 @@ static int io_overlaps_block(struct pool *pool, struct bio *bio)
>  
>  static int io_overwrites_block(struct pool *pool, struct bio *bio)
>  {
> -	return (bio_data_dir(bio) == WRITE) &&
> -		io_overlaps_block(pool, bio);
> +	return (bio_data_dir(bio) == WRITE) && io_overlaps_block(pool, bio) &&
> +	       bio_op(bio) != REQ_OP_PROVISION;
>  }
>  
>  static void save_and_set_endio(struct bio *bio, bio_end_io_t **save,
> @@ -1953,6 +1955,51 @@ static void provision_block(struct thin_c *tc, struct bio *bio, dm_block_t block
>  	}
>  }
>  
> +static void process_provision_bio(struct thin_c *tc, struct bio *bio)
> +{
> +	int r;
> +	struct pool *pool = tc->pool;
> +	dm_block_t block = get_bio_block(tc, bio);
> +	struct dm_bio_prison_cell *cell;
> +	struct dm_cell_key key;
> +	struct dm_thin_lookup_result lookup_result;
> +
> +	/*
> +	 * If cell is already occupied, then the block is already
> +	 * being provisioned so we have nothing further to do here.
> +	 */
> +	build_virtual_key(tc->td, block, &key);
> +	if (bio_detain(pool, &key, bio, &cell))
> +		return;
> +
> +	if (tc->requeue_mode) {
> +		cell_requeue(pool, cell);
> +		return;
> +	}
> +
> +	r = dm_thin_find_block(tc->td, block, 1, &lookup_result);
> +	switch (r) {
> +	case 0:
> +		if (lookup_result.shared) {
> +			process_shared_bio(tc, bio, block, &lookup_result, cell);
> +		} else {
> +			bio_endio(bio);
> +			cell_defer_no_holder(tc, cell);
> +		}
> +		break;
> +	case -ENODATA:
> +		provision_block(tc, bio, block, cell);
> +		break;
> +
> +	default:
> +		DMERR_LIMIT("%s: dm_thin_find_block() failed: error = %d",
> +			    __func__, r);
> +		cell_defer_no_holder(tc, cell);
> +		bio_io_error(bio);
> +		break;
> +	}
> +}
> +
>  static void process_cell(struct thin_c *tc, struct dm_bio_prison_cell *cell)
>  {
>  	int r;
> @@ -2228,6 +2275,8 @@ static void process_thin_deferred_bios(struct thin_c *tc)
>  
>  		if (bio_op(bio) == REQ_OP_DISCARD)
>  			pool->process_discard(tc, bio);
> +		else if (bio_op(bio) == REQ_OP_PROVISION)
> +			pool->process_provision(tc, bio);
>  		else
>  			pool->process_bio(tc, bio);
>  
> @@ -2579,6 +2628,7 @@ static void set_pool_mode(struct pool *pool, enum pool_mode new_mode)
>  		dm_pool_metadata_read_only(pool->pmd);
>  		pool->process_bio = process_bio_fail;
>  		pool->process_discard = process_bio_fail;
> +		pool->process_provision = process_bio_fail;
>  		pool->process_cell = process_cell_fail;
>  		pool->process_discard_cell = process_cell_fail;
>  		pool->process_prepared_mapping = process_prepared_mapping_fail;
> @@ -2592,6 +2642,7 @@ static void set_pool_mode(struct pool *pool, enum pool_mode new_mode)
>  		dm_pool_metadata_read_only(pool->pmd);
>  		pool->process_bio = process_bio_read_only;
>  		pool->process_discard = process_bio_success;
> +		pool->process_provision = process_bio_fail;
>  		pool->process_cell = process_cell_read_only;
>  		pool->process_discard_cell = process_cell_success;
>  		pool->process_prepared_mapping = process_prepared_mapping_fail;
> @@ -2612,6 +2663,7 @@ static void set_pool_mode(struct pool *pool, enum pool_mode new_mode)
>  		pool->out_of_data_space = true;
>  		pool->process_bio = process_bio_read_only;
>  		pool->process_discard = process_discard_bio;
> +		pool->process_provision = process_bio_fail;
>  		pool->process_cell = process_cell_read_only;
>  		pool->process_prepared_mapping = process_prepared_mapping;
>  		set_discard_callbacks(pool);
> @@ -2628,6 +2680,7 @@ static void set_pool_mode(struct pool *pool, enum pool_mode new_mode)
>  		dm_pool_metadata_read_write(pool->pmd);
>  		pool->process_bio = process_bio;
>  		pool->process_discard = process_discard_bio;
> +		pool->process_provision = process_provision_bio;
>  		pool->process_cell = process_cell;
>  		pool->process_prepared_mapping = process_prepared_mapping;
>  		set_discard_callbacks(pool);
> @@ -2749,7 +2802,8 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
>  		return DM_MAPIO_SUBMITTED;
>  	}
>  
> -	if (op_is_flush(bio->bi_opf) || bio_op(bio) == REQ_OP_DISCARD) {
> +	if (op_is_flush(bio->bi_opf) || bio_op(bio) == REQ_OP_DISCARD ||
> +	    bio_op(bio) == REQ_OP_PROVISION) {
>  		thin_defer_bio_with_throttle(tc, bio);
>  		return DM_MAPIO_SUBMITTED;
>  	}
> @@ -3396,6 +3450,9 @@ static int pool_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	pt->adjusted_pf = pt->requested_pf = pf;
>  	ti->num_flush_bios = 1;
>  	ti->limit_swap_bios = true;
> +	ti->num_provision_bios = 1;
> +	ti->provision_supported = true;
> +	ti->max_provision_granularity = true;
>  
>  	/*
>  	 * Only need to enable discards if the pool should pass
> @@ -4114,6 +4171,8 @@ static void pool_io_hints(struct dm_target *ti, struct queue_limits *limits)
>  	 * The pool uses the same discard limits as the underlying data
>  	 * device.  DM core has already set this up.
>  	 */
> +
> +	limits->max_provision_sectors = pool->sectors_per_block;
>  }
>  
>  static struct target_type pool_target = {
> @@ -4288,6 +4347,9 @@ static int thin_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  		ti->max_discard_granularity = true;
>  	}
>  
> +	ti->num_provision_bios = 1;
> +	ti->provision_supported = true;
> +

We need this in thin_ctr: ti->max_provision_granularity = true;

More needed in the thin target than thin-pool; otherwise provision bio
issued to thin devices won't be split appropriately.  But I do think
its fine to set in both thin_ctr and pool_ctr.

Otherwise, looks good.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

