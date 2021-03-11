Return-Path: <SRS0=c+In=IJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62ABAC433E6
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 09:23:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 816F064FB8
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 09:23:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 816F064FB8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-dxp27U3SPSmDiQCdD1vLLA-1; Thu, 11 Mar 2021 04:23:24 -0500
X-MC-Unique: dxp27U3SPSmDiQCdD1vLLA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F1438189D2;
	Thu, 11 Mar 2021 09:23:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 814C169320;
	Thu, 11 Mar 2021 09:23:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2654257DC5;
	Thu, 11 Mar 2021 09:23:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12B6aPlt030124 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Mar 2021 01:36:25 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5AC9E2157F23; Thu, 11 Mar 2021 06:36:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 550962166B44
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 06:36:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0FC2280A1D1
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 06:36:23 +0000 (UTC)
Received: from out30-42.freemail.mail.aliyun.com
	(out30-42.freemail.mail.aliyun.com [115.124.30.42]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-484-mEqCGWfwOseYW-0TYH83qw-1;
	Thu, 11 Mar 2021 01:36:19 -0500
X-MC-Unique: mEqCGWfwOseYW-0TYH83qw-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R651e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1;
	HT=alimailimapcm10staff010182156082;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
	TI=SMTPD_---0URPRb1e_1615444571
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0URPRb1e_1615444571) by smtp.aliyun-inc.com(127.0.0.1);
	Thu, 11 Mar 2021 14:36:12 +0800
To: Mike Snitzer <snitzer@redhat.com>
References: <20210303115740.127001-1-jefflexu@linux.alibaba.com>
	<20210303115740.127001-11-jefflexu@linux.alibaba.com>
	<20210310231808.GD23410@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <b6f0799a-1a11-3778-9b8a-702c3c103db5@linux.alibaba.com>
Date: Thu, 11 Mar 2021 14:36:11 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210310231808.GD23410@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 11 Mar 2021 04:22:56 -0500
Cc: axboe@kernel.dk, caspar@linux.alibaba.com, linux-block@vger.kernel.org,
	joseph.qi@linux.alibaba.com, dm-devel@redhat.com,
	mpatocka@redhat.com, io-uring@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v5 10/12] block: fastpath for bio-based
	polling
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 3/11/21 7:18 AM, Mike Snitzer wrote:
> On Wed, Mar 03 2021 at  6:57am -0500,
> Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
> 
>> Offer one fastpath for bio-based polling when bio submitted to dm
>> device is not split.
>>
>> In this case, there will be only one bio submitted to only one polling
>> hw queue of one underlying mq device, and thus we don't need to track
>> all split bios or iterate through all polling hw queues. The pointer to
>> the polling hw queue the bio submitted to is returned here as the
>> returned cookie. In this case, the polling routine will call
>> mq_ops->poll() directly with the hw queue converted from the input
>> cookie.
>>
>> If the original bio submitted to dm device is split to multiple bios and
>> thus submitted to multiple polling hw queues, the polling routine will
>> fall back to iterating all hw queues (in polling mode) of all underlying
>> mq devices.
>>
>> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
>> ---
>>  block/blk-core.c          | 73 +++++++++++++++++++++++++++++++++++++--
>>  include/linux/blk_types.h | 66 +++++++++++++++++++++++++++++++++--
>>  include/linux/types.h     |  2 +-
>>  3 files changed, 135 insertions(+), 6 deletions(-)
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 6d7d53030d7c..e5cd4ff08f5c 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -947,14 +947,22 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
>>  {
>>  	struct bio_list bio_list_on_stack[2];
>>  	blk_qc_t ret = BLK_QC_T_NONE;
>> +	struct request_queue *top_q;
>> +	bool poll_on;
>>  
>>  	BUG_ON(bio->bi_next);
>>  
>>  	bio_list_init(&bio_list_on_stack[0]);
>>  	current->bio_list = bio_list_on_stack;
>>  
>> +	top_q = bio->bi_bdev->bd_disk->queue;
>> +	poll_on = test_bit(QUEUE_FLAG_POLL, &top_q->queue_flags) &&
>> +		  (bio->bi_opf & REQ_HIPRI);
>> +
>>  	do {
>> -		struct request_queue *q = bio->bi_bdev->bd_disk->queue;
>> +		blk_qc_t cookie;
>> +		struct block_device *bdev = bio->bi_bdev;
>> +		struct request_queue *q = bdev->bd_disk->queue;
>>  		struct bio_list lower, same;
>>  
>>  		if (unlikely(bio_queue_enter(bio) != 0))
>> @@ -966,7 +974,23 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
>>  		bio_list_on_stack[1] = bio_list_on_stack[0];
>>  		bio_list_init(&bio_list_on_stack[0]);
>>  
>> -		ret = __submit_bio(bio);
>> +		cookie = __submit_bio(bio);
>> +
>> +		if (poll_on && blk_qc_t_valid(cookie)) {
>> +			unsigned int queue_num = blk_qc_t_to_queue_num(cookie);
>> +			unsigned int devt = bdev_whole(bdev)->bd_dev;
>> +
>> +			cookie = blk_qc_t_get_by_devt(devt, queue_num);
> 
> The need to rebuild the cookie here is pretty awkward.  This
> optimization living in block core may be worthwhile but the duality of
> block core conditionally overriding the driver's returned cookie (that
> is meant to be opaque to upper layer) is not great.

I agree that currently this design pattern has caused blk-core and dm
being tightly coupled together. Maybe it's the most serous problem of
this patchset, personally.

I can explain it though... Since the nature of the IO path of dm, dm
itself doesn't know if the original bio be split to multiple split bios
and thus submitted to multiple underlying devices or not. Currently I
can only get this information in __submit_bio_noacct(), and that's why
there's so much logic specific to dm is coupled with blk-core here.

Besides, as you just pointed out, it's not compatible once other
bio-based devices start to support polling.

> 
>> +
>> +			if (!blk_qc_t_valid(ret)) {
>> +				/* set initial value */
>> +				ret = cookie;
>> +			} else if (ret != cookie) {
>> +				/* bio gets split and enqueued to multi hctxs */
>> +				ret = BLK_QC_T_BIO_POLL_ALL;
>> +				poll_on = false;
>> +			}
>> +		}
>>  
>>  		/*
>>  		 * Sort new bios into those for a lower level and those for the
>> @@ -989,6 +1013,7 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
>>  	} while ((bio = bio_list_pop(&bio_list_on_stack[0])));
>>  
>>  	current->bio_list = NULL;
>> +
>>  	return ret;
>>  }
> 
> Nit: Not seeing need to alter white space here.

Regards.

> 
>>  
>> @@ -1119,6 +1144,44 @@ blk_qc_t submit_bio(struct bio *bio)
>>  }
>>  EXPORT_SYMBOL(submit_bio);
>>  
>> +static int blk_poll_bio(blk_qc_t cookie)
>> +{
>> +	unsigned int devt = blk_qc_t_to_devt(cookie);
>> +	unsigned int queue_num = blk_qc_t_to_queue_num(cookie);
>> +	struct block_device *bdev;
>> +	struct request_queue *q;
>> +	struct blk_mq_hw_ctx *hctx;
>> +	int ret;
>> +
>> +	bdev = blkdev_get_no_open(devt);
> 
> As you pointed out to me in private, but for the benefit of others,
> blkdev_get_no_open()'s need to take inode lock is not ideal here.

Regards.

> 
>> +
>> +	/*
>> +	 * One such case is that dm device has reloaded table and the original
>> +	 * underlying device the bio submitted to has been detached. When
>> +	 * reloading table, dm will ensure that previously submitted IOs have
>> +	 * all completed, thus return directly here.
>> +	 */
>> +	if (!bdev)
>> +		return 1;
>> +
>> +	q = bdev->bd_disk->queue;
>> +	hctx = q->queue_hw_ctx[queue_num];
>> +
>> +	/*
>> +	 * Similar to the case described in the above comment, that dm device
>> +	 * has reloaded table and the original underlying device the bio
>> +	 * submitted to has been detached. Thus the dev_t stored in cookie may
>> +	 * be reused by another blkdev, and if that's the case, return directly
>> +	 * here.
>> +	 */
>> +	if (hctx->type != HCTX_TYPE_POLL)
>> +		return 1;
> 
> These checks really aren't authoritative or safe enough.  If the bdev
> may have changed then it may not have queue_num hctxs (so you'd access
> out-of-bounds). Similarly, a new bdev may have queue_num hctxs and may
> just so happen to have its type be HCTX_TYPE_POLL.. but in reality it
> isn't the same bdev the cookie was generated from.

Agreed. More checks shall be needed here.

> 
> And I'm now curious how blk-mq's polling code isn't subject to async io
> polling tripping over the possibility of the underlying device having
> been changed out from under it -- meaning should this extra validation
> be common to bio and request-based?  If not, why not?

Blk-mq doesn't have this issue. Io_uring will do fget() for input files
that need do IO. fput() will be deferred until the IO has completed.
Thus the polling routine is guarded by fget() and fput(). fget() will
ensure that the underlying disk (struct block_device, struct disk,
struct request_queue, etc.) is pinned there.

In terms for dm, the above can only guarantee that dm device itself is
pinned, while there's no guarantee for the underlying devices once dm
table reload happens.


> 
>> +
>> +	ret = blk_mq_poll_hctx(q, hctx);
>> +
>> +	blkdev_put_no_open(bdev);
>> +	return ret;
>> +}
>>  
>>  static int blk_bio_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
>>  {
>> @@ -1129,7 +1192,11 @@ static int blk_bio_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
>>  	do {
>>  		int ret;
>>  
>> -		ret = disk->fops->poll(q, cookie);
>> +		if (unlikely(blk_qc_t_is_poll_multi(cookie)))
>> +			ret = disk->fops->poll(q, cookie);
>> +		else
>> +			ret = blk_poll_bio(cookie);
>> +
> 
> Again, this just seems too limiting. Would rather always call into
> disk->fops->poll and have it optimize for single hctx based on cookie it
> established.
> 
> Not seeing why all this needs to be driven by block core _yet_.
> Could be I'm just wanting some flexibility for the design to harden (and
> potential for optimization left as a driver concern.. as I mentioned in
> my reply to the 0th patch header for this v5 patchset).

The reason why all these are mixed is explained as above.

> 
>>  		if (ret > 0) {
>>  			__set_current_state(TASK_RUNNING);
>>  			return ret;
>> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
>> index fb429daaa909..8f970e026be9 100644
>> --- a/include/linux/blk_types.h
>> +++ b/include/linux/blk_types.h
>> @@ -505,10 +505,19 @@ static inline int op_stat_group(unsigned int op)
>>  	return op_is_write(op);
>>  }
>>  
>> -/* Macros for blk_qc_t */
>> +/*
>> + * blk_qc_t for request-based mq devices.
>> + * 63                    31 30          15          0 (bit)
>> + * +----------------------+-+-----------+-----------+
>> + * |      reserved        | | queue_num |    tag    |
>> + * +----------------------+-+-----------+-----------+
>> + *                         ^
>> + *                         BLK_QC_T_INTERNAL
>> + */
>>  #define BLK_QC_T_NONE		-1U
>>  #define BLK_QC_T_SHIFT		16
>>  #define BLK_QC_T_INTERNAL	(1U << 31)
>> +#define BLK_QC_T_QUEUE_NUM_SIZE	15
>>  
>>  static inline bool blk_qc_t_valid(blk_qc_t cookie)
>>  {
>> @@ -517,7 +526,8 @@ static inline bool blk_qc_t_valid(blk_qc_t cookie)
>>  
>>  static inline unsigned int blk_qc_t_to_queue_num(blk_qc_t cookie)
>>  {
>> -	return (cookie & ~BLK_QC_T_INTERNAL) >> BLK_QC_T_SHIFT;
>> +	return (cookie >> BLK_QC_T_SHIFT) &
>> +	       ((1u << BLK_QC_T_QUEUE_NUM_SIZE) - 1);
>>  }
>>  
>>  static inline unsigned int blk_qc_t_to_tag(blk_qc_t cookie)
>> @@ -530,6 +540,58 @@ static inline bool blk_qc_t_is_internal(blk_qc_t cookie)
>>  	return (cookie & BLK_QC_T_INTERNAL) != 0;
>>  }
>>  
>> +/*
>> + * blk_qc_t for bio-based devices.
>> + *
>> + * 1. When @bio is not split, the returned cookie has following format.
>> + *    @dev_t specifies the dev_t number of the underlying device the bio
>> + *    submitted to, while @queue_num specifies the hw queue the bio submitted
>> + *    to.
>> + *
>> + * 63                    31 30          15          0 (bit)
>> + * +----------------------+-+-----------+-----------+
>> + * |        dev_t         | | queue_num |  reserved |
>> + * +----------------------+-+-----------+-----------+
>> + *                         ^
>> + *                         reserved for compatibility with mq
>> + *
>> + * 2. When @bio gets split and enqueued into multi hw queues, the returned
>> + *    cookie is just BLK_QC_T_BIO_POLL_ALL flag.
>> + *
>> + * 63                                              0 (bit)
>> + * +----------------------------------------------+-+
>> + * |                                              |1|
>> + * +----------------------------------------------+-+
>> + *                                                 ^
>> + *                                                 BLK_QC_T_BIO_POLL_ALL
>> + *
>> + * 3. Otherwise, return BLK_QC_T_NONE as the cookie.
>> + *
>> + * 63                                              0 (bit)
>> + * +-----------------------------------------------+
>> + * |                  BLK_QC_T_NONE                |
>> + * +-----------------------------------------------+
>> + */
>> +#define BLK_QC_T_HIGH_SHIFT	32
>> +#define BLK_QC_T_BIO_POLL_ALL	1U
> 
> Pulling on same thread I raised above, the cookie is meant to be
> opaque.  Pinning down how the cookie is (ab)used in block core seems to
> undermine the intended flexibility.
> 
> I'd much rather these details be pushed into drivers/md/bio-poll.h or
> something for the near-term.  We can always elevate it to block core
> if/when there is sufficient justification.
> 
> Just feels we're getting too constraining too quickly.
> 
> Mike
> 
> 
>> +
>> +static inline unsigned int blk_qc_t_to_devt(blk_qc_t cookie)
>> +{
>> +	return cookie >> BLK_QC_T_HIGH_SHIFT;
>> +}
>> +
>> +static inline blk_qc_t blk_qc_t_get_by_devt(unsigned int dev,
>> +					    unsigned int queue_num)
>> +{
>> +	return ((blk_qc_t)dev << BLK_QC_T_HIGH_SHIFT) |
>> +	       (queue_num << BLK_QC_T_SHIFT);
>> +}
>> +
>> +static inline bool blk_qc_t_is_poll_multi(blk_qc_t cookie)
>> +{
>> +	return cookie & BLK_QC_T_BIO_POLL_ALL;
>> +}
>> +
>>  struct blk_rq_stat {
>>  	u64 mean;
>>  	u64 min;
>> diff --git a/include/linux/types.h b/include/linux/types.h
>> index 52a54ed6ffac..7ff4bb96e0ea 100644
>> --- a/include/linux/types.h
>> +++ b/include/linux/types.h
>> @@ -126,7 +126,7 @@ typedef u64 sector_t;
>>  typedef u64 blkcnt_t;
>>  
>>  /* cookie used for IO polling */
>> -typedef unsigned int blk_qc_t;
>> +typedef u64 blk_qc_t;
>>  
>>  /*
>>   * The type of an index into the pagecache.
>> -- 
>> 2.27.0
>>
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
> 

-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

