Return-Path: <SRS0=CL6l=HT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96F26C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:38:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1484A64D9F
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:38:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1484A64D9F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-G5GzAqMfMEOuKUxriUUbmw-1; Wed, 17 Feb 2021 10:38:33 -0500
X-MC-Unique: G5GzAqMfMEOuKUxriUUbmw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FD48100CCC1;
	Wed, 17 Feb 2021 15:38:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F30E10016FD;
	Wed, 17 Feb 2021 15:38:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0DDF218095CB;
	Wed, 17 Feb 2021 15:38:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1196DpZZ003321 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Feb 2021 01:13:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8C4CF6D9DB; Tue,  9 Feb 2021 06:13:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 85EB4906B4
	for <dm-devel@redhat.com>; Tue,  9 Feb 2021 06:13:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7339101A54E
	for <dm-devel@redhat.com>; Tue,  9 Feb 2021 06:13:48 +0000 (UTC)
Received: from out30-45.freemail.mail.aliyun.com
	(out30-45.freemail.mail.aliyun.com [115.124.30.45]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-323-F2IIfDcCOjK7j0Ztxna20w-1;
	Tue, 09 Feb 2021 01:13:45 -0500
X-MC-Unique: F2IIfDcCOjK7j0Ztxna20w-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R151e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1;
	HT=alimailimapcm10staff010182156082;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=9; SR=0;
	TI=SMTPD_---0UOH.b00_1612851218
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UOH.b00_1612851218) by smtp.aliyun-inc.com(127.0.0.1);
	Tue, 09 Feb 2021 14:13:38 +0800
To: Ming Lei <ming.lei@redhat.com>
References: <20210208085243.82367-1-jefflexu@linux.alibaba.com>
	<20210208085243.82367-10-jefflexu@linux.alibaba.com>
	<20210209031122.GA63798@T590>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <a499a33f-da2e-b5aa-5266-9e7c76a34b48@linux.alibaba.com>
Date: Tue, 9 Feb 2021 14:13:38 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210209031122.GA63798@T590>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 17 Feb 2021 10:31:26 -0500
Cc: axboe@kernel.dk, snitzer@redhat.com, caspar@linux.alibaba.com,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	joseph.qi@linux.alibaba.com, dm-devel@redhat.com, hch@lst.de
Subject: Re: [dm-devel] [PATCH v3 09/11] dm: support IO polling for
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 2/9/21 11:11 AM, Ming Lei wrote:
> On Mon, Feb 08, 2021 at 04:52:41PM +0800, Jeffle Xu wrote:
>> DM will iterate and poll all polling hardware queues of all target mq
>> devices when polling IO for dm device. To mitigate the race introduced
>> by iterating all target hw queues, a per-hw-queue flag is maintained
> 
> What is the per-hw-queue flag?

Sorry I forgot to update the commit message as the implementation
changed. Actually this mechanism is implemented by patch 10 of this
patch set.

> 
>> to indicate whether this polling hw queue currently being polled on or
>> not. Every polling hw queue is exclusive to one polling instance, i.e.,
>> the polling instance will skip this polling hw queue if this hw queue
>> currently is being polled by another polling instance, and start
>> polling on the next hw queue.
> 
> Not see such skip in dm_poll_one_dev() in which
> queue_for_each_poll_hw_ctx() is called directly for polling all POLL
> hctxs of the request queue, so can you explain it a bit more about this
> skip mechanism?
> 

It is implemented as patch 10 of this patch set. When spin_trylock()
fails, the polling instance will return immediately, instead of busy
waiting.


> Even though such skipping is implemented, not sure if good performance
> can be reached because hctx poll may be done in ping-pong style
> among several CPUs. But blk-mq hctx is supposed to have its cpu affinities.
> 

Yes, the mechanism of iterating all hw queues can make the competition
worse.

If every underlying data device has **only** one polling hw queue, then
this ping-pong style polling still exist, even when we implement split
bio tracking mechanism, i.e., acquiring the specific hw queue the bio
enqueued into. Because multiple polling instance has to compete for the
only polling hw queue.

But if multiple polling hw queues per device are reserved for multiple
polling instances, (e.g., every underlying data device has 3 polling hw
queues when there are 3 polling instances), just as what we practice on
mq polling, then the current implementation of iterating all hw queues
will indeed works in a ping-pong style, while this issue shall not exist
when accurate split bio tracking mechanism could be implemented.

As for the performance, I cite the test results here, as summarized in
the cover-letter
(https://lore.kernel.org/io-uring/20210208085243.82367-1-jefflexu@linux.alibaba.com/)

	    | IOPS (IRQ mode) | IOPS (iopoll=1 mode) | diff
----------- | --------------- | -------------------- | ----
without opt | 		 318k |		 	256k | ~-20%
with opt    |		 314k |		 	354k | ~13%

The 'opt' refers to the optimization of patch 10, i.e., the skipping
mechanism. There are 3 polling instances (i.e., 3 CPUs) in this test case.


Indeed the current implementation of iterating all hw queues is some
sort of compromise, as I find it really difficult to implement the
accurate split bio mechanism, and to achieve high performance at the
same time. Thus I turn to optimizing the original implementation of
iterating all hw queues, such as optimization of patch 10 and 11.


-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

