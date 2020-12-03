Return-Path: <SRS0=8v/u=FH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3488C433FE
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 16:34:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 03DDA206EC
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 16:34:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 03DDA206EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-QtxZULJZMlORpAyPsXJ-jw-1; Thu, 03 Dec 2020 11:34:36 -0500
X-MC-Unique: QtxZULJZMlORpAyPsXJ-jw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA36E1800D41;
	Thu,  3 Dec 2020 16:34:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AD6EB189A5;
	Thu,  3 Dec 2020 16:34:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8136F1809CA0;
	Thu,  3 Dec 2020 16:34:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B3GVo3Z031461 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 11:31:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 56CFFEAFAF; Thu,  3 Dec 2020 16:31:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 515E0EAFAA
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 16:31:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08FEC80018D
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 16:31:48 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-447-8FKnFzl5M8OJ4PwYrwjiSA-1; Thu, 03 Dec 2020 11:31:45 -0500
X-MC-Unique: 8FKnFzl5M8OJ4PwYrwjiSA-1
Received: from 213-225-0-143.nat.highway.a1.net ([213.225.0.143]
	helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kkrMZ-0005dN-KE; Thu, 03 Dec 2020 16:21:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Thu,  3 Dec 2020 17:21:37 +0100
Message-Id: <20201203162139.2110977-4-hch@lst.de>
In-Reply-To: <20201203162139.2110977-1-hch@lst.de>
References: <20201203162139.2110977-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
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
Cc: linux-raid@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
	linux-s390@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [dm-devel] [PATCH 3/5] block: remove the request_queue argument to
	the block_split tracepoint
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The request_queue can trivially be derived from the bio.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-merge.c            |  2 +-
 drivers/md/dm.c              |  2 +-
 include/trace/events/block.h | 14 ++++++--------
 kernel/trace/blktrace.c      |  5 ++---
 4 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 1a46d5bbd399e3..4071daa88a5eaf 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -338,7 +338,7 @@ void __blk_queue_split(struct bio **bio, unsigned int *nr_segs)
 		split->bi_opf |= REQ_NOMERGE;
 
 		bio_chain(split, *bio);
-		trace_block_split(q, split, (*bio)->bi_iter.bi_sector);
+		trace_block_split(split, (*bio)->bi_iter.bi_sector);
 		submit_bio_noacct(*bio);
 		*bio = split;
 	}
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ed7e836efbcdbc..9a5bd90779c7c4 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1612,7 +1612,7 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
 				part_stat_unlock();
 
 				bio_chain(b, bio);
-				trace_block_split(md->queue, b, bio->bi_iter.bi_sector);
+				trace_block_split(b, bio->bi_iter.bi_sector);
 				ret = submit_bio_noacct(bio);
 				break;
 			}
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 506c29dc7c76fd..b415e4cba84304 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -411,21 +411,19 @@ DEFINE_EVENT(block_unplug, block_unplug,
 
 /**
  * block_split - split a single bio struct into two bio structs
- * @q: queue containing the bio
  * @bio: block operation being split
  * @new_sector: The starting sector for the new bio
  *
- * The bio request @bio in request queue @q needs to be split into two
- * bio requests. The newly created @bio request starts at
- * @new_sector. This split may be required due to hardware limitation
- * such as operation crossing device boundaries in a RAID system.
+ * The bio request @bio needs to be split into two bio requests.  The newly
+ * created @bio request starts at @new_sector. This split may be required due to
+ * hardware limitations such as operation crossing device boundaries in a RAID
+ * system.
  */
 TRACE_EVENT(block_split,
 
-	TP_PROTO(struct request_queue *q, struct bio *bio,
-		 unsigned int new_sector),
+	TP_PROTO(struct bio *bio, unsigned int new_sector),
 
-	TP_ARGS(q, bio, new_sector),
+	TP_ARGS(bio, new_sector),
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev				)
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 7ab88e00c15765..3ca6d62114f461 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -970,10 +970,9 @@ static void blk_add_trace_unplug(void *ignore, struct request_queue *q,
 	rcu_read_unlock();
 }
 
-static void blk_add_trace_split(void *ignore,
-				struct request_queue *q, struct bio *bio,
-				unsigned int pdu)
+static void blk_add_trace_split(void *ignore, struct bio *bio, unsigned int pdu)
 {
+	struct request_queue *q = bio->bi_disk->queue;
 	struct blk_trace *bt;
 
 	rcu_read_lock();
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

