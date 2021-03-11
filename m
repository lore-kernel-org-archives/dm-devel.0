Return-Path: <SRS0=c+In=IJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AE12C433E6
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 09:23:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 62C5264E5F
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 09:23:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62C5264E5F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-jOfzvEOUNJSBmSDZnUDZEA-1; Thu, 11 Mar 2021 04:23:07 -0500
X-MC-Unique: jOfzvEOUNJSBmSDZnUDZEA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA5F618D6A35;
	Thu, 11 Mar 2021 09:23:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A53FA60CEE;
	Thu, 11 Mar 2021 09:23:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A01A418006D9;
	Thu, 11 Mar 2021 09:22:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12B5hsAa025385 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Mar 2021 00:43:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C6FAA2157F23; Thu, 11 Mar 2021 05:43:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C1BA02166B44
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 05:43:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 653F880122D
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 05:43:52 +0000 (UTC)
Received: from out30-56.freemail.mail.aliyun.com
	(out30-56.freemail.mail.aliyun.com [115.124.30.56]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-170-Hk-2qZafOdq0eKU93MWyPg-1;
	Thu, 11 Mar 2021 00:43:48 -0500
X-MC-Unique: Hk-2qZafOdq0eKU93MWyPg-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R211e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
	TI=SMTPD_---0URPRT.J_1615441421
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0URPRT.J_1615441421) by smtp.aliyun-inc.com(127.0.0.1);
	Thu, 11 Mar 2021 13:43:41 +0800
To: Mike Snitzer <snitzer@redhat.com>
References: <20210303115740.127001-1-jefflexu@linux.alibaba.com>
	<20210303115740.127001-5-jefflexu@linux.alibaba.com>
	<20210310222130.GC23410@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <74101e54-5276-b67a-f275-3214630c9cad@linux.alibaba.com>
Date: Thu, 11 Mar 2021 13:43:41 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210310222130.GC23410@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 11 Mar 2021 04:22:56 -0500
Cc: axboe@kernel.dk, caspar@linux.alibaba.com, linux-block@vger.kernel.org,
	joseph.qi@linux.alibaba.com, dm-devel@redhat.com,
	mpatocka@redhat.com, io-uring@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v5 04/12] block: add poll_capable method to
 support bio-based IO polling
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 3/11/21 6:21 AM, Mike Snitzer wrote:
> On Wed, Mar 03 2021 at  6:57am -0500,
> Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
> 
>> This method can be used to check if bio-based device supports IO polling
>> or not. For mq devices, checking for hw queue in polling mode is
>> adequate, while the sanity check shall be implementation specific for
>> bio-based devices. For example, dm device needs to check if all
>> underlying devices are capable of IO polling.
>>
>> Though bio-based device may have done the sanity check during the
>> device initialization phase, cacheing the result of this sanity check
>> (such as by cacheing in the queue_flags) may not work. Because for dm
> 
> s/cacheing/caching/
> 
>> devices, users could change the state of the underlying devices through
>> '/sys/block/<dev>/io_poll', bypassing the dm device above. In this case,
>> the cached result of the very beginning sanity check could be
>> out-of-date. Thus the sanity check needs to be done every time 'io_poll'
>> is to be modified.
>>
>> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> 
> Ideally QUEUE_FLAG_POLL would be authoritative.. but I appreciate the
> problem you've described.  Though I do wonder if this should be solved
> by bio-based's fops->poll() method clearing the request_queue's
> QUEUE_FLAG_POLL if it finds an underlying device doesn't have
> QUEUE_FLAG_POLL set.  Though making bio-based's fops->poll() always need
> to validate the an underlying device does support polling is pretty
> unfortunate.

Agreed. It should be avoided to do control (slow) path in IO (fast) path
as much as possible.

Besides, considering the following patch [1], you should flush the queue
before clearing QUEUE_FLAG_POLL flag. If we embed the checking and
clearing in the normal IO path, then it may result in deadlock. For
example, once the polling routine finds that one of the underlying
device has cleared QUEUE_FLAG_POLL flag, then it needs to flush the
queue (of dm device) before clearing QUEUE_FLAG_POLL flag (of dm
device), while the polling routine itself is responsible for reaping the
completion events.

Of course the polling routine could defer clearing QUEUE_FLAG_POLL flag
to workqueue or something, but all these will lead to much complexity...


[1]
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v5.12-rc2&id=6b09b4d33bd964f49d07d3cabfb4204d58cf9811

> 
> Either way, queue_poll_store() will need to avoid blk-mq specific poll
> checking for bio-based devices.
> 
> Mike
> 
>> ---
>>  block/blk-sysfs.c      | 14 +++++++++++---
>>  include/linux/blkdev.h |  1 +
>>  2 files changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
>> index 0f4f0c8a7825..367c1d9a55c6 100644
>> --- a/block/blk-sysfs.c
>> +++ b/block/blk-sysfs.c
>> @@ -426,9 +426,17 @@ static ssize_t queue_poll_store(struct request_queue *q, const char *page,
>>  	unsigned long poll_on;
>>  	ssize_t ret;
>>  
>> -	if (!q->tag_set || q->tag_set->nr_maps <= HCTX_TYPE_POLL ||
>> -	    !q->tag_set->map[HCTX_TYPE_POLL].nr_queues)
>> -		return -EINVAL;
>> +	if (queue_is_mq(q)) {
>> +		if (!q->tag_set || q->tag_set->nr_maps <= HCTX_TYPE_POLL ||
>> +		    !q->tag_set->map[HCTX_TYPE_POLL].nr_queues)
>> +			return -EINVAL;
>> +	} else {
>> +		struct gendisk *disk = queue_to_disk(q);
>> +
>> +		if (!disk->fops->poll_capable ||
>> +		    !disk->fops->poll_capable(disk))
>> +			return -EINVAL;
>> +	}
>>  
>>  	ret = queue_var_store(&poll_on, page, count);
>>  	if (ret < 0)
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index 9dc83c30e7bc..7df40792c032 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -1867,6 +1867,7 @@ static inline void blk_ksm_unregister(struct request_queue *q) { }
>>  struct block_device_operations {
>>  	blk_qc_t (*submit_bio) (struct bio *bio);
>>  	int (*poll)(struct request_queue *q, blk_qc_t cookie);
>> +	bool (*poll_capable)(struct gendisk *disk);
>>  	int (*open) (struct block_device *, fmode_t);
>>  	void (*release) (struct gendisk *, fmode_t);
>>  	int (*rw_page)(struct block_device *, sector_t, struct page *, unsigned int);
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

