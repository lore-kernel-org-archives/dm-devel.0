Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E47DC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 23:32:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-M_D9kpUsP2aweJ1uQoG1bA-1; Tue, 12 Apr 2022 19:32:00 -0400
X-MC-Unique: M_D9kpUsP2aweJ1uQoG1bA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D15341C068D9;
	Tue, 12 Apr 2022 23:31:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7F553404D2CA;
	Tue, 12 Apr 2022 23:31:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 910221949763;
	Tue, 12 Apr 2022 23:31:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 81B4E1947BBE
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Apr 2022 23:31:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5C7EB401E12; Tue, 12 Apr 2022 23:31:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 57AF354ACA5
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 23:31:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3BAF9800882
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 23:31:53 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-34-88OSq3OKNYG0VO1rg6MQBg-1; Tue, 12 Apr 2022 19:31:49 -0400
X-MC-Unique: 88OSq3OKNYG0VO1rg6MQBg-1
X-IronPort-AV: E=Sophos;i="5.90,254,1643644800"; 
 d="sh'?scan'208";a="198671900"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 13 Apr 2022 07:31:49 +0800
IronPort-SDR: y8YpzmIZF0BV/jXt90l5Wv7j/KtrmSUuVxw2mmCHkPOzrSTmt+L63ftyhqyIszlpvYSgmCb9kR
 /Wwt9ggVDW/aHLmdpBZm0gDimvclgiNuXaQ5M437646ZXnoH7bgjbeLGvpezDBsR7iZ/+A6gUs
 OjQ3jUrSWOho1gc5HNvbbJIOPng5Gz0JrQlj0Vmsphmx1nxEDiGP1/eGOcyrhKQVHYEW3g3gsk
 oVei9UgGtq4E26mD7Qpfrw/UyyiYAjZu2o7x2XqTvI5G1x6U8HBv2Ahz3dzsMAhQv6yFp9/wwY
 W8JOCxQNSVzjNwR1MpX7c3+b
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 12 Apr 2022 16:02:16 -0700
IronPort-SDR: FhCqt+lUfcwHPa53Vq4l4vNewm9QWbRnWJw8uHCdN19OBJhXmA6ZnUPXJieMIZMm8Cy4BqKKdH
 NtlBxV6KFfSmbsiJA3Uqc05xvFw+mTh6QqnVpVSaJSi6tXEOpJFd4qlv/ZBwopro1mU/e84kzo
 BVQH9FMslYXxiHqfEsH6++fuZPiHfMylYvqZAF7ub83mmEgcrhYUBx0HddBY3QhwNCFr5qukc+
 dZtWQjEAtTwrIf+HsH9smxWaYo+iuPb/9HzFk7HV1MapMkzbRd/RvYllD9u5A6crd5SjzSW5Xy
 9/o=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 12 Apr 2022 16:31:48 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KdMSN0kTHz1Rwrw
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 16:31:48 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id Ce6HBNmSZf3s for <dm-devel@redhat.com>;
 Tue, 12 Apr 2022 16:31:47 -0700 (PDT)
Received: from [10.225.163.9] (unknown [10.225.163.9])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KdMSL1G1mz1Rvlx;
 Tue, 12 Apr 2022 16:31:45 -0700 (PDT)
Message-ID: <44a6c5cd-d9ca-e238-4574-73d9140a0d8d@opensource.wdc.com>
Date: Wed, 13 Apr 2022 08:31:44 +0900
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="------------egsgRdPfyYMP0pfbru57ULgc"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------egsgRdPfyYMP0pfbru57ULgc
Content-Type: text/plain; charset=UTF-8
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

OK. Will do right away.

> 
> Really sorry for breaking dm-zone.c; please teach this man how to test
> the basics of all things dm-zoned (is there a testsuite in the tools
> or something?).

We have an internal test suite to check all things related to zone. We run
that weekly on all RC releases. We did not catch the problem earlier as we
do not run against for-next trees in previous cycles. We could add such
runs :)

We would be happy to contribute stuff for testing. Ideally, integrating
that into blktest, with a new DM group, would be nice. That was discussed
in past LSF. Maybe a topic again for this year ? Beside zone stuff, I am
sure we can add more DM tests (I am sure you do also have a test suite ?).

For quick tests, I generally use a zoned nullblk device. I am attaching 2
scripts which allow creating and deleting nullblk devices easily.

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
--------------egsgRdPfyYMP0pfbru57ULgc
Content-Type: application/x-shellscript; name="nullblk-create.sh"
Content-Disposition: attachment; filename="nullblk-create.sh"
Content-Transfer-Encoding: base64

IyEvYmluL2Jhc2gKCnNjcmlwdGRpcj0iJChjZCAiJChkaXJuYW1lICIkMCIpIiAmJiBwd2QpIgoK
ZnVuY3Rpb24gdXNhZ2UoKQp7CgllY2hvICJVc2FnZTogJChiYXNlbmFtZSAkMCkgW29wdGlvbnNd
IgoJZWNobyAiT3B0aW9uczoiCgllY2hvICIgICAgLWggfCAtLWhlbHAgICAgICA6IERpc3BsYXkg
dGhpcyBoZWxwIG1lc3NhZ2UgYW5kIGV4aXQiCgllY2hvICIgICAgLXYgICAgICAgICAgICAgICA6
IEJlIHZlcmJvc2UgKGRpc3BsYXkgZmluYWwgY29uZmlnKSIKCWVjaG8gIiAgICAtY2FwIDxzaXpl
IChHQik+IDogc2V0IGRldmljZSBjYXBhY2l0eSAoZGVmYXVsdDogOCkiCgllY2hvICIgICAgICAg
ICAgICAgICAgICAgICAgIEZvciB6b25lZCBkZXZpY2VzLCBjYXBhY2l0eSBpcyBkZXRlcm1pbmVk
IgoJZWNobyAiICAgICAgICAgICAgICAgICAgICAgICB3aXRoIHpvbmUgc2l6ZSBhbmQgdG90YWwg
bnVtYmVyIG9mIHpvbmVzIgoJZWNobyAiICAgIC1icyA8c2l6ZSAoQik+ICAgOiBzZXQgc2VjdG9y
IHNpemUgKGRlZmF1bHQ6IDUxMikiCgllY2hvICIgICAgLW0gICAgICAgICAgICAgICA6IGVuYWJs
ZSBtZW1vcnkgYmFja2luZyAoZGVmYXVsdDogZmFsc2UpIgoJZWNobyAiICAgIC16ICAgICAgICAg
ICAgICAgOiBjcmVhdGUgYSB6b25lZCBkZXZpY2UgKGRlZmF1bHQ6IGZhbHNlKSIKCWVjaG8gIiAg
ICAtcW0gPG1vZGU+ICAgICAgIDogc2V0IHF1ZXVlIG1vZGUgKGRlZmF1bHQ6IDIpIgoJZWNobyAi
ICAgICAgICAgICAgICAgICAgICAgICAwPWJpbywgMT1ycSwgMj1tdWx0aXF1ZXVlIgoJZWNobyAi
ICAgIC1zcSA8bnVtPiAgICAgICAgOiBzZXQgbnVtYmVyIG9mIHN1Ym1pc3Npb24gcXVldWVzIgoJ
ZWNobyAiICAgICAgICAgICAgICAgICAgICAgICAoZGVmYXVsdDogbnByb2MpIgoJZWNobyAiICAg
IC1xZCA8ZGVwdGg+ICAgICAgOiBzZXQgcXVldWUgZGVwdGggKGRlZmF1bHQ6IDY0KSIKCWVjaG8g
IiAgICAtaW0gPG1vZGU+ICAgICAgIDogc2V0IElSUSBtb2RlIChkZWZhdWx0OiAwKSIKCWVjaG8g
IiAgICAgICAgICAgICAgICAgICAgICAgMD1ub25lLCAxPXNvZnRpcnEsIDI9dGltZXIiCgllY2hv
ICIgICAgLWMgPG5zZWNzPiAgICAgICA6IHNldCBjb21wbGV0aW9uIHRpbWUgZm9yIHRpbWVyIGNv
bXBsZXRpb24iCgllY2hvICIgICAgICAgICAgICAgICAgICAgICAgIChkZWZhdWx0OiAxMDAwMCBu
cykiCgllY2hvICJPcHRpb25zIGZvciB6b25lZCBkZXZpY2VzOiIKCWVjaG8gIiAgICAtenMgPHNp
emUgKE1CKT4gIDogc2V0IHpvbmUgc2l6ZSAoZGVmYXVsdDogOCBNQikiCgllY2hvICIgICAgLXpj
IDxzaXplIChNQik+ICA6IHNldCB6b25lIGNhcGFjaXR5IChkZWZhdWx0OiB6b25lIHNpemUpIgoJ
ZWNobyAiICAgIC16bmMgPG51bT4gICAgICAgOiBzZXQgbnVtYmVyIG9mIGNvbnYgem9uZXMgKGRl
ZmF1bHQ6IDApIgoJZWNobyAiICAgIC16bnMgPG51bT4gICAgICAgOiBzZXQgbnVtYmVyIG9mIHN3
ciB6b25lcyAoZGVmYXVsdDogOCkiCgllY2hvICIgICAgLXpyICAgICAgICAgICAgICA6IGFkZCBh
IHNtYWxsZXIgcnVudCBzd3Igem9uZSAoZGVmYXVsdDogbm9uZSkiCgllY2hvICIgICAgLXptbyA8
bnVtPiAgICAgICA6IHNldCBtYXggb3BlbiB6b25lcyAoZGVmYXVsdDogbm8gbGltaXQpIgoJZWNo
byAiICAgIC16bWEgPG51bT4gICAgICAgOiBzZXQgbWF4IGFjdGl2ZSB6b25lcyAoZGVmYXVsdDog
bm8gbGltaXQpIgoKCWV4aXQgMAp9CgpmdW5jdGlvbiBnZXRfbnVsbGJfaWQoKQp7Cglsb2NhbCBu
aWQ9MAoKCXdoaWxlIFsgMSBdOyBkbwoJCWlmIFsgISAtYiAiL2Rldi9udWxsYiR7bmlkfSIgXTsg
dGhlbgoJCQlicmVhawoJCWZpCgkJbmlkPSQoKCBuaWQgKyAxICkpCglkb25lCgoJZWNobyAiJG5p
ZCIKfQoKIyBTZXQgY29uZmlnIGRlZmF1bHRzCmNhcD04CmJzPTUxMgptPTAKcW09MgpzcT0kKG5w
cm9jKQpxZD02NAppbT0wCmM9MTAwMDAKCno9MAp6cz04CnpjPTAKem5jPTAKem5zPTgKenI9MAp6
bW89MAp6bWE9MAoKdj0wCgojIFBhcnNlIGNvbW1hbmQgbGluZQp3aGlsZSBbWyAkIyAtZ3QgMCBd
XTsgZG8KCWNhc2UgIiQxIiBpbgoJIi1oIiB8ICItLWhlbHAiKQoJCXVzYWdlICIkMCIgOzsKCSIt
diIpCgkJdj0xIDs7CgkiLWNhcCIpCgkJc2hpZnQ7IGNhcD0kMSA7OwoJIi1icyIpCgkJc2hpZnQ7
IGJzPSQxIDs7CgkiLW0iKQoJCW09MSA7OwoJIi1xbSIpCgkJc2hpZnQ7IHFtPSQxIDs7CgkiLXNx
IikKCQlzaGlmdDsgc3E9JDEgOzsKCSItcWQiKQoJCXNoaWZ0OyBxZD0kMSA7OwoJIi1pbSIpCgkJ
c2hpZnQ7IGltPSQxIDs7CgkiLWMiKQoJCXNoaWZ0OyBjPSQxIDs7CgkiLXoiKQoJCXo9MSA7OwoJ
Ii16cyIpCgkJc2hpZnQ7IHpzPSQxIDs7CgkiLXpjIikKCQlzaGlmdDsgemM9JDEgOzsKCSItem5j
IikKCQlzaGlmdDsgem5jPSQxIDs7CgkiLXpucyIpCgkJc2hpZnQ7IHpucz0kMSA7OwoJIi16ciIp
CgkJenI9MSA7OwoJIi16bW8iKQoJCXNoaWZ0OyB6bW89JDEgOzsKCSItem1hIikKCQlzaGlmdDsg
em1hPSQxIDs7CgkqKQoJCWVjaG8gIkludmFsaWQgb3B0aW9uIFwiJDFcIiAodXNlIC1oIG9wdGlv
biBmb3IgaGVscCkiCgkJZXhpdCAxIDs7Cgllc2FjCgoJc2hpZnQKZG9uZQoKIyBDYWxjdWxhdGUg
em9uZWQgZGV2aWNlIGNhcGFjaXR5CmlmIFsgJHogPT0gMSBdOyB0aGVuCgljYXA9JCgoIHpzICog
KHpuYyArIHpucykgKSkKCWlmIFsgJHpyID09IDEgXTsgdGhlbgoJCWNhcD0kKCggZ2IgKyB6bnMg
LSAxICkpCglmaQplbHNlCgljYXA9JCgoIGNhcCAqIDEwMjQgKSkKZmkKCiMgQ3JlYXRlIGRldmlj
ZSBjb25maWcKbW9kcHJvYmUgbnVsbF9ibGsgbnJfZGV2aWNlcz0wIHx8IHJldHVybiAkPwpuaWQ9
JChnZXRfbnVsbGJfaWQpCmRldj0iL3N5cy9rZXJuZWwvY29uZmlnL251bGxiL251bGxiJHtuaWR9
Igpta2RpciAiJHtkZXZ9IgoKZWNobyAkY2FwID4gIiR7ZGV2fSIvc2l6ZQplY2hvICRicyA+ICIk
e2Rldn0iL2Jsb2Nrc2l6ZQplY2hvICRtID4gIiR7ZGV2fSIvbWVtb3J5X2JhY2tlZAplY2hvICRx
bSA+ICIke2Rldn0iL3F1ZXVlX21vZGUKZWNobyAkc3EgPiAiJHtkZXZ9Ii9zdWJtaXRfcXVldWVz
CmVjaG8gJHFkID4gIiR7ZGV2fSIvaHdfcXVldWVfZGVwdGgKZWNobyAkaW0gPiAiJHtkZXZ9Ii9p
cnFtb2RlCmlmIFsgJGltID09IDIgXTsgdGhlbgoJZWNobyAkYyA+ICIke2Rldn0iL2NvbXBsZXRp
b25fbnNlYwpmaQoKZWNobyAkeiA+ICIke2Rldn0iL3pvbmVkCmlmIFsgJHogPT0gMSBdOyB0aGVu
CgllY2hvICR6cyA+ICIke2Rldn0iL3pvbmVfc2l6ZQoJZWNobyAkemMgPiAiJHtkZXZ9Ii96b25l
X2NhcGFjaXR5CgllY2hvICR6bmMgPiAiJHtkZXZ9Ii96b25lX25yX2NvbnYKCWVjaG8gJHptbyA+
ICIke2Rldn0iL3pvbmVfbWF4X29wZW4KCWVjaG8gJHptYSA+ICIke2Rldn0iL3pvbmVfbWF4X2Fj
dGl2ZQpmaQoKIyBFbmFibGUgZGV2aWNlCmVjaG8gMSA+ICIke2Rldn0iL3Bvd2VyCmVjaG8gIkNy
ZWF0ZWQgL2Rldi9udWxsYiR7bmlkfSIKCmlmIFsgJHYgPT0gMSBdOyB0aGVuCgllY2hvICJEZXZp
Y2UgY29uZmlndXJhdGlvbjoiCglncmVwIC1yIC4gJHtkZXZ9CmZpCg==
--------------egsgRdPfyYMP0pfbru57ULgc
Content-Type: application/x-shellscript; name="nullblk-destroy.sh"
Content-Disposition: attachment; filename="nullblk-destroy.sh"
Content-Transfer-Encoding: base64

IyEvYmluL2Jhc2gKCmlmIFsgJCMgIT0gMSBdOyB0aGVuCgllY2hvICJVc2FnZTogJChiYXNlbmFt
ZSAkMCkgPG51bGxiIElEPiIKCWV4aXQgMQpmaQoKbmlkPSQxCgppZiBbICEgLWIgIi9kZXYvbnVs
bGIkbmlkIiBdOyB0aGVuCgllY2hvICIvZGV2L251bGxiJG5pZDogTm8gc3VjaCBkZXZpY2UiCgll
eGl0IDEKZmkKCmVjaG8gMCA+IC9zeXMva2VybmVsL2NvbmZpZy9udWxsYi9udWxsYiRuaWQvcG93
ZXIKcm1kaXIgL3N5cy9rZXJuZWwvY29uZmlnL251bGxiL251bGxiJG5pZAoKZWNobyAiRGVzdHJv
eWVkIC9kZXYvbnVsbGIkbmlkIgoK
--------------egsgRdPfyYMP0pfbru57ULgc
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--------------egsgRdPfyYMP0pfbru57ULgc--

