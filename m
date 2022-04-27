Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E5C3C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 27 Apr 2022 22:04:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-oSaSE1rLPlCgHyb8GCUqPQ-1; Wed, 27 Apr 2022 18:04:32 -0400
X-MC-Unique: oSaSE1rLPlCgHyb8GCUqPQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61DEF1C04B69;
	Wed, 27 Apr 2022 22:04:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 128AB145BA47;
	Wed, 27 Apr 2022 22:04:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AEF901947046;
	Wed, 27 Apr 2022 22:04:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 489D51947041
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 22:04:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D0DE3463E1F; Wed, 27 Apr 2022 22:04:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CCA79463E1A
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 22:04:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2D85299E74F
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 22:04:27 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-217-dzCtBxykPjeU4cBhxoHq2A-1; Wed, 27 Apr 2022 18:04:17 -0400
X-MC-Unique: dzCtBxykPjeU4cBhxoHq2A-1
X-IronPort-AV: E=Sophos;i="5.90,294,1643644800"; d="scan'208";a="303207528"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 28 Apr 2022 06:04:16 +0800
IronPort-SDR: NBa8IRoVCw4EUI5gDQG5CYUnaA9GHV8j0NJflnp6QtGR2oCIsMHkg3eZ1pcuL3qtiEZfvggMHh
 myu4Mold/5+RhTWuQUnY+xPpns8siDD8QBV2y6j2DH3m+aDFuM1f6e0Zhit1uh0h9jt2Xu6sxo
 yLRmI9zE+jXQJZS+oWhwCEzERwPy2h3GiQ8NF74e5SYDmG0DEGOI5mBSeWaddhX05dJFWzhkeM
 5wVvAt2EfXDAppYuGS7579jU6jQ3vqI0oNyTEOHpe+lOmgZDVYqOyQWxw0ySNEPD05v25Cxu8C
 Zgfa4RpxXuB+r5DgyN7XJRO5
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Apr 2022 14:35:08 -0700
IronPort-SDR: 67zgCYgw8X2hXH8hczWIGIrFDcHsOTcvEI0MkFcH1BgC/IElMJRj83vyd3+dL1GSc0LkG/Sllk
 cJJLuDOUNDWeb0iezDxyIQRy50TNdZDovPD9VoShIOLSt91dDZDlvVOmBFfLsoY34cuZJO7VxB
 Eq6V4GLtlEC9RD6usEM9t3kJ9yoZNbcbdUf4UMRxj89iE3RIPG7nS7hQIs9ExeqjXhDEdum4zM
 fjze+S/CqbLaacfAQo0UJj7yXMo3eh/vYXVlt+K5xDVpt+Tm9GKZPZiryv5sWSzI2Jucu3l2Fz
 P7U=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Apr 2022 15:04:16 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KpXpS357Gz1Rvlx
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 15:04:16 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id MIlXkaVjuRYw for <dm-devel@redhat.com>;
 Wed, 27 Apr 2022 15:04:15 -0700 (PDT)
Received: from [10.225.163.27] (unknown [10.225.163.27])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KpXpQ3gm7z1Rvlc;
 Wed, 27 Apr 2022 15:04:14 -0700 (PDT)
Message-ID: <0d3b0a6b-825d-1b01-094a-911f81f5f354@opensource.wdc.com>
Date: Thu, 28 Apr 2022 07:04:13 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
To: Nitesh Shetty <nj.shetty@samsung.com>
References: <20220426101241.30100-1-nj.shetty@samsung.com>
 <CGME20220426101921epcas5p341707619b5e836490284a42c92762083@epcas5p3.samsung.com>
 <20220426101241.30100-3-nj.shetty@samsung.com>
 <7d1fdd1e-c854-4744-8bec-7d222fb9be76@opensource.wdc.com>
 <20220427151535.GC9558@test-zns>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220427151535.GC9558@test-zns>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v4 02/10] block: Add copy offload support
 infrastructure
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
Cc: linux-scsi@vger.kernel.org, nitheshshetty@gmail.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/28/22 00:15, Nitesh Shetty wrote:
> On Wed, Apr 27, 2022 at 11:45:26AM +0900, Damien Le Moal wrote:
>> On 4/26/22 19:12, Nitesh Shetty wrote:
>>> Introduce blkdev_issue_copy which supports source and destination bdevs,
>>> and an array of (source, destination and copy length) tuples.
>>> Introduce REQ_COPY copy offload operation flag. Create a read-write
>>> bio pair with a token as payload and submitted to the device in order.
>>> Read request populates token with source specific information which
>>> is then passed with write request.
>>> This design is courtesy Mikulas Patocka's token based copy
>>>
>>> Larger copy will be divided, based on max_copy_sectors,
>>> max_copy_range_sector limits.
>>>
>>> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
>>> Signed-off-by: Arnav Dawn <arnav.dawn@samsung.com>
>>> ---
>>>  block/blk-lib.c           | 232 ++++++++++++++++++++++++++++++++++++++
>>>  block/blk.h               |   2 +
>>>  include/linux/blk_types.h |  21 ++++
>>>  include/linux/blkdev.h    |   2 +
>>>  include/uapi/linux/fs.h   |  14 +++
>>>  5 files changed, 271 insertions(+)
>>>
>>> diff --git a/block/blk-lib.c b/block/blk-lib.c
>>> index 09b7e1200c0f..ba9da2d2f429 100644
>>> --- a/block/blk-lib.c
>>> +++ b/block/blk-lib.c
>>> @@ -117,6 +117,238 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>>>  }
>>>  EXPORT_SYMBOL(blkdev_issue_discard);
>>>  
>>> +/*
>>> + * Wait on and process all in-flight BIOs.  This must only be called once
>>> + * all bios have been issued so that the refcount can only decrease.
>>> + * This just waits for all bios to make it through bio_copy_end_io. IO
>>> + * errors are propagated through cio->io_error.
>>> + */
>>> +static int cio_await_completion(struct cio *cio)
>>> +{
>>> +	int ret = 0;
>>> +	unsigned long flags;
>>> +
>>> +	spin_lock_irqsave(&cio->lock, flags);
>>> +	if (cio->refcount) {
>>> +		cio->waiter = current;
>>> +		__set_current_state(TASK_UNINTERRUPTIBLE);
>>> +		spin_unlock_irqrestore(&cio->lock, flags);
>>> +		blk_io_schedule();
>>> +		/* wake up sets us TASK_RUNNING */
>>> +		spin_lock_irqsave(&cio->lock, flags);
>>> +		cio->waiter = NULL;
>>> +		ret = cio->io_err;
>>> +	}
>>> +	spin_unlock_irqrestore(&cio->lock, flags);
>>> +	kvfree(cio);
>>
>> cio is allocated with kzalloc() == kmalloc(). So why the kvfree() here ?
>>
> 
> acked.
> 
>>> +
>>> +	return ret;
>>> +}
>>> +
>>> +static void bio_copy_end_io(struct bio *bio)
>>> +{
>>> +	struct copy_ctx *ctx = bio->bi_private;
>>> +	struct cio *cio = ctx->cio;
>>> +	sector_t clen;
>>> +	int ri = ctx->range_idx;
>>> +	unsigned long flags;
>>> +	bool wake = false;
>>> +
>>> +	if (bio->bi_status) {
>>> +		cio->io_err = bio->bi_status;
>>> +		clen = (bio->bi_iter.bi_sector << SECTOR_SHIFT) - ctx->start_sec;
>>> +		cio->rlist[ri].comp_len = min_t(sector_t, clen, cio->rlist[ri].comp_len);
>>
>> long line.
> 
> Is it because line is more than 80 character, I thought limit is 100 now, so
> went with longer lines ?

When it is easy to wrap the lines without readability loss, please do to
keep things under 80 char per line.


>>> +{
>>> +	struct request_queue *src_q = bdev_get_queue(src_bdev);
>>> +	struct request_queue *dest_q = bdev_get_queue(dest_bdev);
>>> +	int ret = -EINVAL;
>>> +
>>> +	if (!src_q || !dest_q)
>>> +		return -ENXIO;
>>> +
>>> +	if (!nr)
>>> +		return -EINVAL;
>>> +
>>> +	if (nr >= MAX_COPY_NR_RANGE)
>>> +		return -EINVAL;
>>
>> Where do you check the number of ranges against what the device can do ?
>>
> 
> The present implementation submits only one range at a time. This was done to 
> make copy offload generic, so that other types of copy implementation such as
> XCOPY should be able to use same infrastructure. Downside at present being
> NVMe copy offload is not optimal.

If you issue one range at a time without checking the number of ranges,
what is the point of the nr ranges queue limit ? The user can submit a
copy ioctl request exceeding it. Please use that limit and enforce it or
remove it entirely.


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

