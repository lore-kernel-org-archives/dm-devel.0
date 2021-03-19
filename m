Return-Path: <SRS0=pJ9r=IR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCD0CC433E0
	for <dm-devel@archiver.kernel.org>; Fri, 19 Mar 2021 08:50:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 08D0964D9D
	for <dm-devel@archiver.kernel.org>; Fri, 19 Mar 2021 08:50:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08D0964D9D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-RWWl9H-SOey60zxqpJbiGg-1; Fri, 19 Mar 2021 04:50:36 -0400
X-MC-Unique: RWWl9H-SOey60zxqpJbiGg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 129DB108BD09;
	Fri, 19 Mar 2021 08:50:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E86265C1D1;
	Fri, 19 Mar 2021 08:50:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B2D881800215;
	Fri, 19 Mar 2021 08:50:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12J5u1e5032729 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 19 Mar 2021 01:56:01 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 73BA7FA73D; Fri, 19 Mar 2021 05:56:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6E0BEFA735
	for <dm-devel@redhat.com>; Fri, 19 Mar 2021 05:55:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E04B811E7A
	for <dm-devel@redhat.com>; Fri, 19 Mar 2021 05:55:58 +0000 (UTC)
Received: from out30-132.freemail.mail.aliyun.com
	(out30-132.freemail.mail.aliyun.com [115.124.30.132]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-102-qU4a4uPhNrCAhz3db_O5nQ-1;
	Fri, 19 Mar 2021 01:55:53 -0400
X-MC-Unique: qU4a4uPhNrCAhz3db_O5nQ-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R661e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e01424;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
	TI=SMTPD_---0USWV5kS_1616133030
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0USWV5kS_1616133030) by smtp.aliyun-inc.com(127.0.0.1);
	Fri, 19 Mar 2021 13:50:30 +0800
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
References: <20210318164827.1481133-1-ming.lei@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <ca04d070-55b6-a156-3a18-68e0fe38269b@linux.alibaba.com>
Date: Fri, 19 Mar 2021 13:50:30 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210318164827.1481133-1-ming.lei@redhat.com>
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
X-Mailman-Approved-At: Fri, 19 Mar 2021 04:50:24 -0400
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [RFC PATCH V2 00/13] block: support bio based io
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 3/19/21 12:48 AM, Ming Lei wrote:
> Hi,
> 
> Add per-task io poll context for holding HIPRI blk-mq/underlying bios
> queued from bio based driver's io submission context, and reuse one bio
> padding field for storing 'cookie' returned from submit_bio() for these
> bios. Also explicitly end these bios in poll context by adding two
> new bio flags.
> 
> In this way, we needn't to poll all underlying hw queues any more,
> which is implemented in Jeffle's patches. And we can just poll hw queues
> in which there is HIPRI IO queued.
> 
> Usually io submission and io poll share same context, so the added io
> poll context data is just like one stack variable, and the cost for
> saving bios is cheap.
> 
> Any comments are welcome.
> 
> V2:
> 	- address queue depth scalability issue reported by Jeffle via bio
> 	group list. Reuse .bi_end_io for linking bios which share same
> 	.bi_end_io, and support 32 such groups in submit queue. With this way,
> 	the scalability issue caused by kfifio is solved. Before really
> 	ending bio, .bi_end_io is recovered from the group head.

I have retested this latest version, and it seems the scaling issue has
been fixed at the first glance.

Test results with the latest version:
3-threads  dm-stripe-3 targets  (12k randread IOPS, unit K)
317 -> 409 (iodepth=128)

Compared to the test results of v1:
3-threads  dm-stripe-3 targets  (12k randread IOPS, unit K)
313 -> 349 (iodepth=128, kfifo queue depth =128)
313 -> 409 (iodepth=32, kfifo queue depth =128)
314 -> 409 (iodepth=128, kfifo queue depth =512)

> 
> 
> Jeffle Xu (4):
>   block/mq: extract one helper function polling hw queue
>   block: add queue_to_disk() to get gendisk from request_queue
>   block: add poll_capable method to support bio-based IO polling
>   dm: support IO polling for bio-based dm device
> 
> Ming Lei (9):
>   block: add helper of blk_queue_poll
>   block: add one helper to free io_context
>   block: add helper of blk_create_io_context
>   block: create io poll context for submission and poll task
>   block: add req flag of REQ_TAG
>   block: add new field into 'struct bvec_iter'
>   block: prepare for supporting bio_list via other link
>   block: use per-task poll context to implement bio based io poll
>   blk-mq: limit hw queues to be polled in each blk_poll()
> 
>  block/bio.c                   |   5 +
>  block/blk-core.c              | 248 ++++++++++++++++++++++++++++++++--
>  block/blk-ioc.c               |  12 +-
>  block/blk-mq.c                | 232 ++++++++++++++++++++++++++++++-
>  block/blk-sysfs.c             |  14 +-
>  block/blk.h                   |  55 ++++++++
>  drivers/md/dm-table.c         |  24 ++++
>  drivers/md/dm.c               |  14 ++
>  drivers/nvme/host/core.c      |   2 +-
>  include/linux/bio.h           | 132 +++++++++---------
>  include/linux/blk_types.h     |  20 ++-
>  include/linux/blkdev.h        |   4 +
>  include/linux/bvec.h          |   9 ++
>  include/linux/device-mapper.h |   1 +
>  include/linux/iocontext.h     |   2 +
>  include/trace/events/kyber.h  |   6 +-
>  16 files changed, 686 insertions(+), 94 deletions(-)
> 

-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

