Return-Path: <SRS0=l+U7=HY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09905C433DB
	for <dm-devel@archiver.kernel.org>; Mon, 22 Feb 2021 08:52:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 69AC464EBE
	for <dm-devel@archiver.kernel.org>; Mon, 22 Feb 2021 08:52:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69AC464EBE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-ooDlqmfwOsWHz1KDFzj-Iw-1; Mon, 22 Feb 2021 03:52:41 -0500
X-MC-Unique: ooDlqmfwOsWHz1KDFzj-Iw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02321801979;
	Mon, 22 Feb 2021 08:52:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D71DC629C0;
	Mon, 22 Feb 2021 08:52:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A502B57DFC;
	Mon, 22 Feb 2021 08:52:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11KB6p1E010439 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 20 Feb 2021 06:06:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 88F9F200ACC4; Sat, 20 Feb 2021 11:06:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 824E3200BFD3
	for <dm-devel@redhat.com>; Sat, 20 Feb 2021 11:06:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53E7D8007D9
	for <dm-devel@redhat.com>; Sat, 20 Feb 2021 11:06:48 +0000 (UTC)
Received: from out30-45.freemail.mail.aliyun.com
	(out30-45.freemail.mail.aliyun.com [115.124.30.45]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-409-jAYO1aoNPveV3GevL6HRLA-1;
	Sat, 20 Feb 2021 06:06:44 -0500
X-MC-Unique: jAYO1aoNPveV3GevL6HRLA-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R141e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04395;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=9; SR=0;
	TI=SMTPD_---0UP1N.Dc_1613819197
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UP1N.Dc_1613819197) by smtp.aliyun-inc.com(127.0.0.1);
	Sat, 20 Feb 2021 19:06:37 +0800
From: Jeffle Xu <jefflexu@linux.alibaba.com>
To: snitzer@redhat.com, axboe@kernel.dk
Date: Sat, 20 Feb 2021 19:06:25 +0800
Message-Id: <20210220110637.50305-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
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
X-Mailman-Approved-At: Mon, 22 Feb 2021 03:49:50 -0500
Cc: caspar@linux.alibaba.com, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, ming.lei@redhat.com, hch@lst.de
Subject: [dm-devel] [PATCH v4 00/12] dm: support IO polling
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

[Changes since v3]
- newly add patch 7 and patch 11, as a new optimization improving
performance of multiple polling processes. Now performance of multiple
polling processes can be as scalable as single polling process (~30%).
Refer to the following [Performance] chapter for more details.


[Intention]
Bio-based polling (e.g., for dm/md devices) is one indispensable part of
high performance IO stack. As far as I know, dm (e.g., dm-stripe) is
widely used in database, splicing several NVMe disks as one whole disk,
in hope of achieving better performance. With this patch set, io_uring
could be used upon dm devices.


[Optimizations]
Basically, there are three paths for IO polling.

1. fastpath (patch 9/10)
The polling routine will go into this path when bio submitted to dm
device is not split.

In this case, there will be only one bio submitted to only one polling
hw queue of one underlying mq device, and thus we don't need to track
all split bios or iterate through all polling hw queues. The pointer to
the polling hw queue the bio submitted to is returned here as the
returned cookie. In this case, the polling routine will call
mq_ops->poll() directly with the hw queue converted from the input
cookie.


- One process reading dm-linear (mapping to three underlying NVMe devices,
with one polling hw queue per NVMe device).

(ioengine=io_uring, iodepth=128, numjobs=1, rw=randread, sqthread_poll=0
direct=1, bs=4k)

	    	 | IOPS (IRQ mode) | IOPS (iopoll=1 mode) | diff
---------------- | --------------- | -------------------- | ----
with patchset    |	      212k |		     284k | ~32%


- Three processes reading dm-linear (mapping to three underlying NVMe
devices, with one polling hw queue per NVMe device).

(ioengine=io_uring, iodepth=128, numjobs=3, rw=randread, sqthread_poll=0
direct=1, bs=4k)

	    	 | IOPS (IRQ mode) | IOPS (iopoll=1 mode) | diff
---------------- | --------------- | -------------------- | ----
with patchset    |	      615k |		     735k | ~16%


- Three processes reading dm-linear (mapping to three underlying NVMe
devices, with three polling hw queues per NVMe device), with every
process pinned to one CPU and mapped to one exclusive hw queue.

(ioengine=io_uring, iodepth=128, numjobs=3, rw=randread, sqthread_poll=0
direct=1, bs=4k)

	    	 | IOPS (IRQ mode) | IOPS (iopoll=1 mode) | diff
---------------- | --------------- | -------------------- | ----
with patchset    |	      631k |		     833k | ~32%



2. sub-fastpath (patch 7/11)

The polling routine will go into this path when bio submitted to dm
device gets split and enqueued into multiple hw queues, while the IO
submission process has not been migrated to another CPU.

In this case, the IO submission routine will return the CPU number on
which the IO submission happened as the returned cookie, while the
polling routine will only iterate and poll on hw queues that this CPU
number maps, instead of iterating *all* hw queues.

This optimization can dramatically reduce cache ping-pong and thus
improve the polling performance, when multiple hw queues in polling mode
per device could be reserved when there are multiple polling processes.

- Three processes reading dm-stripe (mapping to three underlying NVMe
devices, with three polling hw queues per NVMe device), with every
process pinned to one CPU and mapped to one exclusive hw queue.

(ioengine=io_uring, iodepth=128, numjobs=3, rw=randread, sqthread_poll=0
direct=1, bs=12k(4k for every NVMe device))

	    	 | IOPS (IRQ mode) | IOPS (iopoll=1 mode) | diff
---------------- | --------------- | -------------------- | ----
with patchset    |	      307k |		     412k | ~34%


3. default path

It will fall back to iterating all hw queues in polling mode, once bio
submitted to dm device gets split and enqueued into multiple hw queues,
and the IO process has ever been migrated to another CPU during the IO
submission phase.


[Remained Issue]
It has been mentioned in patch 4 that, users could change the state of
the underlying devices through '/sys/block/<dev>/io_poll', bypassing
the dm device above. Thus it can cause a situation where QUEUE_FLAG_POLL
is still set for the request_queue of dm device, while one of the
underlying mq device may has cleared this flag.

In this case, it will pass the 'test_bit(QUEUE_FLAG_POLL, &q->queue_flags)'
check in blk_poll(), while the input cookie may actually points to a hw
queue in IRQ mode since patch 11. Thus for this hw queue (in IRQ mode),
the bio-based polling routine will handle this hw queue acquiring
'spin_lock(&nvmeq->cq_poll_lock)' (refer
drivers/nvme/host/pci.c:nvme_poll), which is not adequate since this hw
queue may also be accessed in IRQ context. In other words,
spin_lock_irq() should be used here.

I have not come up one simple way to fix it. I don't want to do sanity
check (e.g., the type of the hw queue is HCTX_TYPE_POLL or not) in the
IO path (submit_bio()/blk_poll()), i.e., fast path.

We'd better fix it in the control path, i.e., dm could be aware of the
change when attribute (e.g., support io_poll or not) of one of the
underlying devices changed at runtime.




[Changes since v2]

Patchset v2 caches all hw queues (in polling mode) of underlying mq
devices in dm layer. The polling routine actually iterates through all
these cached hw queues.

However, mq may change the queue mapping at runtime (e.g., NVMe RESET
command), thus the cached hw queues in dm layer may be out-of-date. Thus
patchset v3 falls back to the implementation of the very first RFC
version, in which the mq layer needs to export one interface iterating
all polling hw queues (patch 5), and the bio-based polling routine just
calls this interface to iterate all polling hw queues.

Besides, several new optimization is proposed.


- patch 1,2,7
same as v2, untouched

- patch 3
Considering advice from Christoph Hellwig, while refactoring blk_poll(),
split mq and bio-based polling routine from the very beginning. Now
blk_poll() is just a simple entry. blk_bio_poll() is simply copied from
blk_mq_poll(), while the loop structure is some sort of duplication
though.

- patch 4
This patch is newly added to support turning on/off polling through
'/sys/block/<dev>/queue/io_poll' dynamiclly for bio-based devices.
Patchset v2 implemented this functionality by added one new queue flag,
which is not preferred since the queue flag resource is quite short of
nowadays.

- patch 5
This patch is newly added, preparing for the following bio-based
polling. The following bio-based polling will call this helper function,
accounting on the corresponding hw queue.

- patch 6
It's from the very first RFC version, preparing for the following
bio-based polling.

- patch 8
One fixing patch needed by the following bio-based polling. It's
actually a v2 of [1]. I had sent the v2 singly in-reply-to [1], though
it has not been visible on the mailing list maybe due to the delay.

- patch 9
It's from the very first RFC version.

- patch 10
This patch is newly added. Patchset v2 had ever proposed one
optimization that, skipping the **busy** hw queues during the iteration
phase. Back upon that time, one flag of 'atomic_t' is specifically
maintained in dm layer, representing if the corresponding hw queue is
busy or not. The idea is inherited, while the implementation changes.
Now @nvmeq->cq_poll_lock is used directly here, no need for extra flag
anymore.

This optimization can significantly reduce the competition for one hw
queue between multiple polling instances. Following statistics is the
test result when 3 threads concurrently randread (bs=4k, direct=1) one
dm-linear device, which is built upon 3 nvme devices, with one polling
hw queue per nvme device.

	    | IOPS (IRQ mode) | IOPS (iopoll=1 mode) | diff
----------- | --------------- | -------------------- | ----
without opt | 		 318k |		 	256k | ~-20%
with opt    |		 314k |		 	354k | ~13%
							

- patch 11
This is another newly added optimizatin for bio-based polling.

One intuitive insight is that, when the original bio submitted to dm
device doesn't get split, then the bio gets enqueued into only one hw
queue of one of the underlying mq devices. In this case, we no longer
need to track all split bios, and one cookie (for the only split bio)
is enough. It is implemented by returning the pointer to the
corresponding hw queue in this case.

It should be safe by directly returning the pointer to the hw queue,
since 'struct blk_mq_hw_ctx' won't be freed during the whole lifetime of
'struct request_queue'. Even when the number of hw queues may decrease
when NVMe RESET happens, the 'struct request_queue' structure of decreased
hw queues won't be freed, instead it's buffered into
&q->unused_hctx_list list.

Though this optimization seems quite intuitive, the performance test
shows that it does no benefit nor harm to the performance, while 3
threads concurrently randreading (bs=4k, direct=1) one dm-linear
device, which is built upon 3 nvme devices, with one polling hw queue
per nvme device.

I'm not sure why it doesn't work, maybe because the number of devices,
or the depth of the devcice stack is to low in my test case?


changes since v1:
- patch 1,2,4 is the same as v1 and have already been reviewed
- patch 3 is refactored a bit on the basis of suggestions from
Mike Snitzer.
- patch 5 is newly added and introduces one new queue flag
representing if the queue is capable of IO polling. This mainly
simplifies the logic in queue_poll_store().
- patch 6 implements the core mechanism supporting IO polling.
The sanity check checking if the dm device supports IO polling is
also folded into this patch, and the queue flag will be cleared if
it doesn't support, in case of table reloading.




Jeffle Xu (12):
  block: move definition of blk_qc_t to types.h
  block: add queue_to_disk() to get gendisk from request_queue
  block: add poll method to support bio-based IO polling
  block: add poll_capable method to support bio-based IO polling
  blk-mq: extract one helper function polling hw queue
  blk-mq: add iterator for polling hw queues
  blk-mq: add one helper function getting hw queue
  dm: always return BLK_QC_T_NONE for bio-based device
  nvme/pci: don't wait for locked polling queue
  block: fastpath for bio-based polling
  block: sub-fastpath for bio-based polling
  dm: support IO polling for bio-based dm device

 block/blk-core.c              | 112 +++++++++++++++++++++++++++++++++-
 block/blk-mq.c                |  37 ++++-------
 block/blk-sysfs.c             |  14 ++++-
 drivers/md/dm-table.c         |  26 ++++++++
 drivers/md/dm.c               | 102 ++++++++++++++++++++++++++-----
 drivers/nvme/host/pci.c       |   4 +-
 include/linux/blk-mq.h        |  23 +++++++
 include/linux/blk_types.h     |  66 +++++++++++++++++++-
 include/linux/blkdev.h        |   4 ++
 include/linux/device-mapper.h |   1 +
 include/linux/fs.h            |   2 +-
 include/linux/types.h         |   3 +
 include/trace/events/kyber.h  |   6 +-
 13 files changed, 350 insertions(+), 50 deletions(-)

-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

