Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD3B1C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 13 Apr 2022 00:00:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-ggM4qMnnPDWOvVt36y87QA-1; Tue, 12 Apr 2022 20:00:42 -0400
X-MC-Unique: ggM4qMnnPDWOvVt36y87QA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B214F802803;
	Wed, 13 Apr 2022 00:00:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5C115432021;
	Wed, 13 Apr 2022 00:00:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0F52F1949763;
	Wed, 13 Apr 2022 00:00:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 97F921947BBE
 for <dm-devel@listman.corp.redhat.com>; Wed, 13 Apr 2022 00:00:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 848724047780; Wed, 13 Apr 2022 00:00:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 804D2404776B
 for <dm-devel@redhat.com>; Wed, 13 Apr 2022 00:00:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6424E866DF4
 for <dm-devel@redhat.com>; Wed, 13 Apr 2022 00:00:39 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-2trVxtwKP4y_dI8km7_SYg-1; Tue, 12 Apr 2022 20:00:37 -0400
X-MC-Unique: 2trVxtwKP4y_dI8km7_SYg-1
X-IronPort-AV: E=Sophos;i="5.90,254,1643644800"; d="scan'208";a="197774540"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 13 Apr 2022 08:00:29 +0800
IronPort-SDR: m1Q50vebpc+JmIAc7OUq1aNPul82OGhJmabtx5D9L0FEdiA05uD4nFBgJkVVFStchbNeMuPTD6
 LBqFvHSRDvEYE7tNO7Z5a2uKwwjbWaZQcirlgnIEUSf3hsw26hO8NgzvL9JODCF5cBSUJE/Zm6
 8K1ebgqXPLShlTdctZ7uMsY+p8X/08DO+F0JhbeGBf7qHM9t883Qcouv1l4rQNXju4mjy3tt1J
 3/AdzzNRl36ldXS8mqS+twGgVdV6NiOiVD8tH43s2XVGavpqFx5ViikFV7tkrrwyIOmpvRDvA2
 l0H25kJOrxA3JKsc/lkLLdDz
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 12 Apr 2022 16:30:57 -0700
IronPort-SDR: xbM41a29T0aFz6eDYobA6+EJgBtQFLB55b9owgeF463AZ5DDChTXahIJW6BTtge2XG3ns1EKuz
 gN/TfCh/bVitiHqN0PkYy4jK56u42QqBCRJB9RIOG//KjfxIx+VfmT/JVoDLPrn2W36tXMSJQE
 pBVVM75/FPhFQv6sM8UBIqQAVjmUvp2+VSMpBfqWkQtLx6Y6OJQTQfF2TycCeIP5BXABX5cUUn
 rjUj3XWVbP/BbDZxtAqhbq3jEDbv3pbs0G/a/0zIDIhdiCRxr8Ih199ACYDBuzgxdUSd4FVqKn
 lI0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 12 Apr 2022 17:00:31 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KdN5T5pxLz1SVp1
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 17:00:29 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id BiJk7N5P1Gbz for <dm-devel@redhat.com>;
 Tue, 12 Apr 2022 17:00:28 -0700 (PDT)
Received: from [10.225.163.9] (unknown [10.225.163.9])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KdN5R53wzz1Rvlx;
 Tue, 12 Apr 2022 17:00:27 -0700 (PDT)
Message-ID: <34597cd1-cb19-c5de-8c44-b8c5a0a07cf7@opensource.wdc.com>
Date: Wed, 13 Apr 2022 09:00:26 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Mike Snitzer <snitzer@redhat.com>
References: <20220412085616.1409626-1-ming.lei@redhat.com>
 <20220412085616.1409626-6-ming.lei@redhat.com> <YlXmmB6IO7usz2c1@redhat.com>
 <c4c83c0f-a4fc-2b37-180f-ccb272085fca@opensource.wdc.com>
 <YlYEq0XC2XL6bv2b@redhat.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <YlYEq0XC2XL6bv2b@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 5/8] dm: always setup ->orig_bio in alloc_io
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Ming Lei <ming.lei@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/13/22 08:00, Mike Snitzer wrote:
> On Tue, Apr 12 2022 at  6:38P -0400,
> Damien Le Moal <damien.lemoal@opensource.wdc.com> wrote:
> 
>> On 4/13/22 05:52, Mike Snitzer wrote:
>>> On Tue, Apr 12 2022 at  4:56P -0400,
>>> Ming Lei <ming.lei@redhat.com> wrote:
>>>
>>>> The current DM codes setup ->orig_bio after __map_bio() returns,
>>>> and not only cause kernel panic for dm zone, but also a bit ugly
>>>> and tricky, especially the waiting until ->orig_bio is set in
>>>> dm_submit_bio_remap().
>>>>
>>>> The reason is that one new bio is cloned from original FS bio to
>>>> represent the mapped part, which just serves io accounting.
>>>>
>>>> Now we have switched to bdev based io accounting interface, and we
>>>> can retrieve sectors/bio_op from both the real original bio and the
>>>> added fields of .sector_offset & .sectors easily, so the new cloned
>>>> bio isn't necessary any more.
>>>>
>>>> Not only fixes dm-zone's kernel panic, but also cleans up dm io
>>>> accounting & split a bit.
>>>
>>> You're conflating quite a few things here.  DM zone really has no
>>> business accessing io->orig_bio (dm-zone.c can just as easily inspect
>>> the tio->clone, because it hasn't been remapped yet it reflects the
>>> io->origin_bio, so there is no need to look at io->orig_bio) -- but
>>> yes I clearly broke things during the 5.18 merge and it needs fixing
>>> ASAP.
>>
>> Problem is that we need to look at the BIO op in submission AND completion
>> path to handle zone append requests. So looking at the clone on submission
>> is OK since its op is still the original one. But on the completion path,
>> the clone may now be a regular write emulating a zone append op. And
>> looking at the clone only does not allow detecting that zone append.
>>
>> We could have the orig_bio op saved in dm_io to avoid completely looking
>> at the orig_bio for detecting zone append.
> 
> Can you please try the following patch?

This works. I tested with a zoned nullblk + dm-crypt, forcing the zone
append emulation code to be used. I ran zonefs tests on top of that with
no issues. I will run btrfs tests too later today to exercise things a
little more.

> 
> Really sorry for breaking dm-zone.c; please teach this man how to test
> the basics of all things dm-zoned (is there a testsuite in the tools
> or something?).
> 
> Thanks,
> Mike
> 
> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> index c1ca9be4b79e..896127366000 100644
> --- a/drivers/md/dm-zone.c
> +++ b/drivers/md/dm-zone.c
> @@ -360,16 +360,20 @@ static int dm_update_zone_wp_offset(struct mapped_device *md, unsigned int zno,
>  	return 0;
>  }
>  
> +struct orig_bio_details {
> +	unsigned int op;
> +	unsigned int nr_sectors;
> +};
> +
>  /*
>   * First phase of BIO mapping for targets with zone append emulation:
>   * check all BIO that change a zone writer pointer and change zone
>   * append operations into regular write operations.
>   */
> -static bool dm_zone_map_bio_begin(struct mapped_device *md,
> -				  struct bio *orig_bio, struct bio *clone)
> +static bool dm_zone_map_bio_begin(struct mapped_device *md, unsigned int zno,
> +				  struct bio *clone)
>  {
>  	sector_t zsectors = blk_queue_zone_sectors(md->queue);
> -	unsigned int zno = bio_zone_no(orig_bio);
>  	unsigned int zwp_offset = READ_ONCE(md->zwp_offset[zno]);
>  
>  	/*
> @@ -384,7 +388,7 @@ static bool dm_zone_map_bio_begin(struct mapped_device *md,
>  		WRITE_ONCE(md->zwp_offset[zno], zwp_offset);
>  	}
>  
> -	switch (bio_op(orig_bio)) {
> +	switch (bio_op(clone)) {
>  	case REQ_OP_ZONE_RESET:
>  	case REQ_OP_ZONE_FINISH:
>  		return true;
> @@ -401,9 +405,8 @@ static bool dm_zone_map_bio_begin(struct mapped_device *md,
>  		 * target zone.
>  		 */
>  		clone->bi_opf = REQ_OP_WRITE | REQ_NOMERGE |
> -			(orig_bio->bi_opf & (~REQ_OP_MASK));
> -		clone->bi_iter.bi_sector =
> -			orig_bio->bi_iter.bi_sector + zwp_offset;
> +			(clone->bi_opf & (~REQ_OP_MASK));
> +		clone->bi_iter.bi_sector += zwp_offset;
>  		break;
>  	default:
>  		DMWARN_LIMIT("Invalid BIO operation");
> @@ -423,11 +426,10 @@ static bool dm_zone_map_bio_begin(struct mapped_device *md,
>   * data written to a zone. Note that at this point, the remapped clone BIO
>   * may already have completed, so we do not touch it.
>   */
> -static blk_status_t dm_zone_map_bio_end(struct mapped_device *md,
> -					struct bio *orig_bio,
> +static blk_status_t dm_zone_map_bio_end(struct mapped_device *md, unsigned int zno,
> +					struct orig_bio_details *orig_bio_details,
>  					unsigned int nr_sectors)
>  {
> -	unsigned int zno = bio_zone_no(orig_bio);
>  	unsigned int zwp_offset = READ_ONCE(md->zwp_offset[zno]);
>  
>  	/* The clone BIO may already have been completed and failed */
> @@ -435,7 +437,7 @@ static blk_status_t dm_zone_map_bio_end(struct mapped_device *md,
>  		return BLK_STS_IOERR;
>  
>  	/* Update the zone wp offset */
> -	switch (bio_op(orig_bio)) {
> +	switch (orig_bio_details->op) {
>  	case REQ_OP_ZONE_RESET:
>  		WRITE_ONCE(md->zwp_offset[zno], 0);
>  		return BLK_STS_OK;
> @@ -452,7 +454,7 @@ static blk_status_t dm_zone_map_bio_end(struct mapped_device *md,
>  		 * Check that the target did not truncate the write operation
>  		 * emulating a zone append.
>  		 */
> -		if (nr_sectors != bio_sectors(orig_bio)) {
> +		if (nr_sectors != orig_bio_details->nr_sectors) {
>  			DMWARN_LIMIT("Truncated write for zone append");
>  			return BLK_STS_IOERR;
>  		}
> @@ -488,7 +490,7 @@ static inline void dm_zone_unlock(struct request_queue *q,
>  	bio_clear_flag(clone, BIO_ZONE_WRITE_LOCKED);
>  }
>  
> -static bool dm_need_zone_wp_tracking(struct bio *orig_bio)
> +static bool dm_need_zone_wp_tracking(struct bio *clone)
>  {
>  	/*
>  	 * Special processing is not needed for operations that do not need the
> @@ -496,15 +498,15 @@ static bool dm_need_zone_wp_tracking(struct bio *orig_bio)
>  	 * zones and all operations that do not modify directly a sequential
>  	 * zone write pointer.
>  	 */
> -	if (op_is_flush(orig_bio->bi_opf) && !bio_sectors(orig_bio))
> +	if (op_is_flush(clone->bi_opf) && !bio_sectors(clone))
>  		return false;
> -	switch (bio_op(orig_bio)) {
> +	switch (bio_op(clone)) {
>  	case REQ_OP_WRITE_ZEROES:
>  	case REQ_OP_WRITE:
>  	case REQ_OP_ZONE_RESET:
>  	case REQ_OP_ZONE_FINISH:
>  	case REQ_OP_ZONE_APPEND:
> -		return bio_zone_is_seq(orig_bio);
> +		return bio_zone_is_seq(clone);
>  	default:
>  		return false;
>  	}
> @@ -519,8 +521,8 @@ int dm_zone_map_bio(struct dm_target_io *tio)
>  	struct dm_target *ti = tio->ti;
>  	struct mapped_device *md = io->md;
>  	struct request_queue *q = md->queue;
> -	struct bio *orig_bio = io->orig_bio;
>  	struct bio *clone = &tio->clone;
> +	struct orig_bio_details orig_bio_details;
>  	unsigned int zno;
>  	blk_status_t sts;
>  	int r;
> @@ -529,18 +531,21 @@ int dm_zone_map_bio(struct dm_target_io *tio)
>  	 * IOs that do not change a zone write pointer do not need
>  	 * any additional special processing.
>  	 */
> -	if (!dm_need_zone_wp_tracking(orig_bio))
> +	if (!dm_need_zone_wp_tracking(clone))
>  		return ti->type->map(ti, clone);
>  
>  	/* Lock the target zone */
> -	zno = bio_zone_no(orig_bio);
> +	zno = bio_zone_no(clone);
>  	dm_zone_lock(q, zno, clone);
>  
> +	orig_bio_details.nr_sectors = bio_sectors(clone);
> +	orig_bio_details.op = bio_op(clone);
> +
>  	/*
>  	 * Check that the bio and the target zone write pointer offset are
>  	 * both valid, and if the bio is a zone append, remap it to a write.
>  	 */
> -	if (!dm_zone_map_bio_begin(md, orig_bio, clone)) {
> +	if (!dm_zone_map_bio_begin(md, zno, clone)) {
>  		dm_zone_unlock(q, zno, clone);
>  		return DM_MAPIO_KILL;
>  	}
> @@ -560,7 +565,8 @@ int dm_zone_map_bio(struct dm_target_io *tio)
>  		 * The target submitted the clone BIO. The target zone will
>  		 * be unlocked on completion of the clone.
>  		 */
> -		sts = dm_zone_map_bio_end(md, orig_bio, *tio->len_ptr);
> +		sts = dm_zone_map_bio_end(md, zno, &orig_bio_details,
> +					  *tio->len_ptr);
>  		break;
>  	case DM_MAPIO_REMAPPED:
>  		/*
> @@ -568,7 +574,8 @@ int dm_zone_map_bio(struct dm_target_io *tio)
>  		 * unlock the target zone here as the clone will not be
>  		 * submitted.
>  		 */
> -		sts = dm_zone_map_bio_end(md, orig_bio, *tio->len_ptr);
> +		sts = dm_zone_map_bio_end(md, zno, &orig_bio_details,
> +					  *tio->len_ptr);
>  		if (sts != BLK_STS_OK)
>  			dm_zone_unlock(q, zno, clone);
>  		break;
> 


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

