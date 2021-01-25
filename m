Return-Path: <SRS0=Cj1z=G5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E03CC433E0
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 09:10:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B48CB2310B
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 09:10:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B48CB2310B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-oikn8wIqOyuTbF5gLF5h2Q-1; Tue, 26 Jan 2021 04:10:29 -0500
X-MC-Unique: oikn8wIqOyuTbF5gLF5h2Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B8981936B60;
	Tue, 26 Jan 2021 09:10:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2BCF810023AB;
	Tue, 26 Jan 2021 09:10:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CA2A31809C9F;
	Tue, 26 Jan 2021 09:10:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10PCDra5021879 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 25 Jan 2021 07:13:54 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 23ECA1111A5E; Mon, 25 Jan 2021 12:13:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E7BF1000DBB
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 12:13:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EAA89187504B
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 12:13:50 +0000 (UTC)
Received: from out30-42.freemail.mail.aliyun.com
	(out30-42.freemail.mail.aliyun.com [115.124.30.42]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-356-52d8-K4EO5m_PmNAxkfryA-1;
	Mon, 25 Jan 2021 07:13:48 -0500
X-MC-Unique: 52d8-K4EO5m_PmNAxkfryA-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R711e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e01424;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=5; SR=0;
	TI=SMTPD_---0UMpeZ6G_1611576820
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UMpeZ6G_1611576820) by smtp.aliyun-inc.com(127.0.0.1);
	Mon, 25 Jan 2021 20:13:41 +0800
From: Jeffle Xu <jefflexu@linux.alibaba.com>
To: snitzer@redhat.com
Date: Mon, 25 Jan 2021 20:13:34 +0800
Message-Id: <20210125121340.70459-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 26 Jan 2021 04:10:04 -0500
Cc: linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, io-uring@vger.kernel.org
Subject: [dm-devel] [PATCH v2 0/6] dm: support IO polling for bio-based dm
	device
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Since currently we have no simple but efficient way to implement the
bio-based IO polling in the split-bio tracking style, this patch set
turns to the original implementation mechanism that iterates and
polls all underlying hw queues in polling mode. One optimization is
introduced to mitigate the race of one hw queue among multiple polling
instances.

I'm still open to the split bio tracking mechanism, if there's
reasonable way to implement it.


[Performance Test]
The performance is tested by fio (engine=io_uring) 4k randread on
dm-linear device. The dm-linear device is built upon nvme devices,
and every nvme device has one polling hw queue (nvme.poll_queues=1).

Test Case		    | IOPS in IRQ mode | IOPS in polling mode | Diff
			    | (hipri=0)	       | (hipri=1)	      |
--------------------------- | ---------------- | -------------------- | ----
3 target nvme, num_jobs = 1 | 198k 	       | 276k		      | ~40%
3 target nvme, num_jobs = 3 | 608k 	       | 705k		      | ~16%
6 target nvme, num_jobs = 6 | 1197k 	       | 1347k		      | ~13%
3 target nvme, num_jobs = 6 | 1285k 	       | 1293k		      | ~0%

As the number of polling instances (num_jobs) increases, the
performance improvement decreases, though it's still positive
compared to the IRQ mode.

[Optimization]
To mitigate the race when iterating all the underlying hw queues, one
flag is maintained on a per-hw-queue basis. This flag is used to
indicate whether this polling hw queue currently being polled on or
not. Every polling hw queue is exclusive to one polling instance, i.e.,
the polling instance will skip this polling hw queue if this hw queue
currently is being polled by another polling instance, and start
polling on the next hw queue.

This per-hw-queue flag map is currently maintained in dm layer. In
the table load phase, a table describing all underlying polling hw
queues is built and stored in 'struct dm_table'. It is safe when
reloading the mapping table.


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


Jeffle Xu (6):
  block: move definition of blk_qc_t to types.h
  block: add queue_to_disk() to get gendisk from request_queue
  block: add iopoll method to support bio-based IO polling
  dm: always return BLK_QC_T_NONE for bio-based device
  block: add QUEUE_FLAG_POLL_CAP flag
  dm: support IO polling for bio-based dm device

 block/blk-core.c             |  76 +++++++++++++++++++++
 block/blk-mq.c               |  76 +++------------------
 block/blk-sysfs.c            |   3 +-
 drivers/md/dm-core.h         |  21 ++++++
 drivers/md/dm-table.c        | 127 +++++++++++++++++++++++++++++++++++
 drivers/md/dm.c              |  61 ++++++++++++-----
 include/linux/blk-mq.h       |   3 +
 include/linux/blk_types.h    |   2 +-
 include/linux/blkdev.h       |   9 +++
 include/linux/fs.h           |   2 +-
 include/linux/types.h        |   3 +
 include/trace/events/kyber.h |   6 +-
 12 files changed, 302 insertions(+), 87 deletions(-)

-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

