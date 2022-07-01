Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46BA3C43334
	for <dm-devel@archiver.kernel.org>; Fri,  1 Jul 2022 03:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656647937;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VbssMnBVGaxi6PbupR20i9ffQL4bNuWBQ0Cj/aqZwl8=;
	b=eiyrEFHE0QoT8sOFSXP7X/yVppCH6j7MXn0m0fx7cwDwBDzy8d7tb5ZNsoh9syAwiFSVi1
	HD1Hf0HqXiK0hy6WqmRsggyPIGn5yoYr1NSM2sKcccqdk73xE8fzpQcB5UfzzdPZTWk+x7
	CTbwt8bArj1ICZP+L+8LmMIICPt8zsk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-Jzd4Nzk4OXW-kVdw0N68zg-1; Thu, 30 Jun 2022 23:58:53 -0400
X-MC-Unique: Jzd4Nzk4OXW-kVdw0N68zg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37B1796EE43;
	Fri,  1 Jul 2022 03:58:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E1B5F492C3B;
	Fri,  1 Jul 2022 03:58:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A2A741947060;
	Fri,  1 Jul 2022 03:58:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E43EF1947058
 for <dm-devel@listman.corp.redhat.com>; Fri,  1 Jul 2022 03:58:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C8C43492C3B; Fri,  1 Jul 2022 03:58:47 +0000 (UTC)
Received: from T590 (ovpn-8-22.pek2.redhat.com [10.72.8.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E7DD2492CA3;
 Fri,  1 Jul 2022 03:58:40 +0000 (UTC)
Date: Fri, 1 Jul 2022 11:58:35 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Kent Overstreet <kent.overstreet@gmail.com>
Message-ID: <Yr5w6+/AAYSxcHaf@T590>
References: <Yrld9rLPY6L3MhlZ@T590>
 <20220628042610.wuittagsycyl4uwa@moria.home.lan>
 <YrqyiCcnvPCqsn8F@T590>
 <20220628163617.h3bmq3opd7yuiaop@moria.home.lan>
 <Yrs9OLNZ8xUs98OB@redhat.com>
 <20220628175253.s2ghizfucumpot5l@moria.home.lan>
 <YrvsDNltq+h6mphN@redhat.com>
 <20220629181154.eejrlfhj5n4la446@moria.home.lan>
 <YrzykX0jTWpq5DYQ@T590>
 <20220630011454.c6djuzkwsn33x7y6@moria.home.lan>
MIME-Version: 1.0
In-Reply-To: <20220630011454.c6djuzkwsn33x7y6@moria.home.lan>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 5.20 1/4] block: add bio_rewind() API
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
Cc: Jens Axboe <axboe@kernel.dk>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Mike Snitzer <snitzer@redhat.com>, Eric Biggers <ebiggers@google.com>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Dmitry Monakhov <dmonakhov@openvz.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jun 29, 2022 at 09:14:54PM -0400, Kent Overstreet wrote:
> On Thu, Jun 30, 2022 at 08:47:13AM +0800, Ming Lei wrote:
> > Or if I misunderstood your point, please cook a patch and I am happy to
> > take a close look, and posting one very raw idea with random data
> > structure looks not helpful much for this discussion technically.
> 
> Based it on your bio_rewind() patch - what do you think of this?
> 
> -- >8 --
> From: Kent Overstreet <kent.overstreet@gmail.com>
> Subject: [PATCH] block: add bio_(get|set)_pos()
> 
> Commit 7759eb23fd98 ("block: remove bio_rewind_iter()") removes
> the similar API because the following reasons:
> 
>     ```
>     It is pointed that bio_rewind_iter() is one very bad API[1]:
> 
>     1) bio size may not be restored after rewinding
> 
>     2) it causes some bogus change, such as 5151842b9d8732 (block: reset
>     bi_iter.bi_done after splitting bio)
> 
>     3) rewinding really makes things complicated wrt. bio splitting
> 
>     4) unnecessary updating of .bi_done in fast path
> 
>     [1] https://marc.info/?t=153549924200005&r=1&w=2
> 
>     So this patch takes Kent's suggestion to restore one bio into its original
>     state via saving bio iterator(struct bvec_iter) in bio_integrity_prep(),
>     given now bio_rewind_iter() is only used by bio integrity code.
>     ```
> 
> However, saving and restoring bi_iter isn't sufficient anymore, because
> of integrity and now per-bio crypt context.
> 
> This patch implements the same functionality as bio_rewind(), based on a
> patch by Ming, but with a different (safer!) interface.
> 
>  - bio_get_pos() gets the current state of a a bio, i.e. how far it has
>    been advanced and its current (remaining) size
>  - bio_set_pos() restores a bio to a previous state, advancing or
>    rewinding it as needed
> 
> Co-authored-by: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
> ---
>  block/bio-integrity.c       | 19 +++++++++++++++++++
>  block/bio.c                 | 26 ++++++++++++++++++++++++++
>  block/blk-crypto-internal.h |  7 +++++++
>  block/blk-crypto.c          | 25 +++++++++++++++++++++++++
>  include/linux/bio.h         | 22 ++++++++++++++++++++++
>  include/linux/blk_types.h   | 19 +++++++++++++++++++
>  include/linux/bvec.h        | 36 +++++++++++++++++++++++++++++++++++-
>  7 files changed, 153 insertions(+), 1 deletion(-)
> 
> diff --git a/block/bio-integrity.c b/block/bio-integrity.c
> index 32929c89ba..06c2fe81fd 100644
> --- a/block/bio-integrity.c
> +++ b/block/bio-integrity.c
> @@ -378,6 +378,25 @@ void bio_integrity_advance(struct bio *bio, unsigned int bytes_done)
>  	bvec_iter_advance(bip->bip_vec, &bip->bip_iter, bytes);
>  }
>  
> +/**
> + * bio_integrity_rewind - Rewind integrity vector
> + * @bio:	bio whose integrity vector to update
> + * @bytes_done:	number of data bytes to rewind
> + *
> + * Description: This function calculates how many integrity bytes the
> + * number of completed data bytes correspond to and rewind the
> + * integrity vector accordingly.
> + */
> +void bio_integrity_rewind(struct bio *bio, unsigned int bytes_done)
> +{
> +	struct bio_integrity_payload *bip = bio_integrity(bio);
> +	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
> +	unsigned bytes = bio_integrity_bytes(bi, bytes_done >> 9);
> +
> +	bip->bip_iter.bi_sector -= bio_integrity_intervals(bi, bytes_done >> 9);
> +	bvec_iter_rewind(bip->bip_vec, &bip->bip_iter, bytes);
> +}
> +
>  /**
>   * bio_integrity_trim - Trim integrity vector
>   * @bio:	bio whose integrity vector to update
> diff --git a/block/bio.c b/block/bio.c
> index b2425b8d88..bbf8aa4e62 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1329,6 +1329,32 @@ void __bio_advance(struct bio *bio, unsigned bytes)
>  }
>  EXPORT_SYMBOL(__bio_advance);
>  
> +/**
> + * bio_set_pos - restore a bio to a previous state, after having been iterated
> + * or trimmed
> + * @bio: bio to reset
> + * @pos: pos to reset it to, from bio_get_pos()
> + */
> +void bio_set_pos(struct bio *bio, struct bio_pos pos)
> +{
> +	int delta = bio->bi_iter.bi_done - pos.bi_done;
> +
> +	if (delta > 0) {
> +		if (bio_integrity(bio))
> +			bio_integrity_rewind(bio, delta);
> +		bio_crypt_rewind(bio, delta);
> +		bio_rewind_iter(bio, &bio->bi_iter, delta);
> +	} else {
> +		bio_advance(bio, -delta);
> +	}
> +
> +	bio->bi_iter.bi_size = pos.bi_size;
> +
> +	if (bio_integrity(bio))
> +		bio_integrity_trim(bio);
> +}
> +EXPORT_SYMBOL(bio_set_pos);
> +
>  void bio_copy_data_iter(struct bio *dst, struct bvec_iter *dst_iter,
>  			struct bio *src, struct bvec_iter *src_iter)
>  {
> diff --git a/block/blk-crypto-internal.h b/block/blk-crypto-internal.h
> index e6818ffadd..b723599bbf 100644
> --- a/block/blk-crypto-internal.h
> +++ b/block/blk-crypto-internal.h
> @@ -114,6 +114,13 @@ static inline void bio_crypt_advance(struct bio *bio, unsigned int bytes)
>  		__bio_crypt_advance(bio, bytes);
>  }
>  
> +void __bio_crypt_rewind(struct bio *bio, unsigned int bytes);
> +static inline void bio_crypt_rewind(struct bio *bio, unsigned int bytes)
> +{
> +	if (bio_has_crypt_ctx(bio))
> +		__bio_crypt_rewind(bio, bytes);
> +}
> +
>  void __bio_crypt_free_ctx(struct bio *bio);
>  static inline void bio_crypt_free_ctx(struct bio *bio)
>  {
> diff --git a/block/blk-crypto.c b/block/blk-crypto.c
> index a496aaef85..e3584b5a68 100644
> --- a/block/blk-crypto.c
> +++ b/block/blk-crypto.c
> @@ -134,6 +134,23 @@ void bio_crypt_dun_increment(u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE],
>  	}
>  }
>  
> +/* Decrements @dun by @dec, treating @dun as a multi-limb integer. */
> +void bio_crypt_dun_decrement(u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE],
> +			     unsigned int dec)
> +{
> +	int i;
> +
> +	for (i = 0; dec && i < BLK_CRYPTO_DUN_ARRAY_SIZE; i++) {
> +		u64 prev = dun[i];
> +
> +		dun[i] -= dec;
> +		if (dun[i] > prev)
> +			dec = 1;
> +		else
> +			dec = 0;
> +	}
> +}
> +
>  void __bio_crypt_advance(struct bio *bio, unsigned int bytes)
>  {
>  	struct bio_crypt_ctx *bc = bio->bi_crypt_context;
> @@ -142,6 +159,14 @@ void __bio_crypt_advance(struct bio *bio, unsigned int bytes)
>  				bytes >> bc->bc_key->data_unit_size_bits);
>  }
>  
> +void __bio_crypt_rewind(struct bio *bio, unsigned int bytes)
> +{
> +	struct bio_crypt_ctx *bc = bio->bi_crypt_context;
> +
> +	bio_crypt_dun_decrement(bc->bc_dun,
> +				bytes >> bc->bc_key->data_unit_size_bits);
> +}
> +
>  /*
>   * Returns true if @bc->bc_dun plus @bytes converted to data units is equal to
>   * @next_dun, treating the DUNs as multi-limb integers.
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index c11103a872..5fff008913 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -105,6 +105,19 @@ static inline void bio_advance_iter(const struct bio *bio,
>  		/* TODO: It is reasonable to complete bio with error here. */
>  }
>  
> +static inline void bio_rewind_iter(const struct bio *bio,
> +				    struct bvec_iter *iter, unsigned int bytes)
> +{
> +	iter->bi_sector -= bytes >> 9;
> +
> +	/* No advance means no rewind */
> +	if (bio_no_advance_iter(bio))
> +		iter->bi_size += bytes;
> +	else
> +		bvec_iter_rewind(bio->bi_io_vec, iter, bytes);
> +		/* TODO: It is reasonable to complete bio with error here. */
> +}
> +
>  /* @bytes should be less or equal to bvec[i->bi_idx].bv_len */
>  static inline void bio_advance_iter_single(const struct bio *bio,
>  					   struct bvec_iter *iter,
> @@ -133,6 +146,8 @@ void __bio_advance(struct bio *, unsigned bytes);
>   */
>  static inline void bio_advance(struct bio *bio, unsigned int nbytes)
>  {
> +	bio->bi_iter.bi_done += nbytes;

Why do we need to pay the cost(4 bytes added to bio and the updating
in absolutely fast path) if rewind isn't used? So far, only dm requeue
needs it, and it is one very unusual event.

Assuming fixed bio end sector should cover most of cases, especially
if bio_rewind is only for dm or driver.

I'd suggest to not take this way until turning out bio_rewind() is not
enough for new requirement or usages.

Thanks 
Ming
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

