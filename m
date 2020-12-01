Return-Path: <SRS0=byOr=FF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BB3EC64E7B
	for <dm-devel@archiver.kernel.org>; Tue,  1 Dec 2020 17:02:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 448EB206B7
	for <dm-devel@archiver.kernel.org>; Tue,  1 Dec 2020 17:02:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 448EB206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-Ud-U9vnbMte-GkzNhJQg8g-1; Tue, 01 Dec 2020 12:02:08 -0500
X-MC-Unique: Ud-U9vnbMte-GkzNhJQg8g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2F901005D7C;
	Tue,  1 Dec 2020 17:02:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F6E118A9E;
	Tue,  1 Dec 2020 17:02:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 46C905002C;
	Tue,  1 Dec 2020 17:02:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B1H1x0I032224 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Dec 2020 12:02:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2C10E94596; Tue,  1 Dec 2020 17:01:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 26A6394585
	for <dm-devel@redhat.com>; Tue,  1 Dec 2020 17:01:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA2668007DF
	for <dm-devel@redhat.com>; Tue,  1 Dec 2020 17:01:56 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-51-IubMmAVtNBG8DfK4LR0Gfw-1; Tue, 01 Dec 2020 12:01:54 -0500
X-MC-Unique: IubMmAVtNBG8DfK4LR0Gfw-1
Received: from [2001:4bb8:184:6389:bbd8:a1c2:99e0:f58a] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kk8v9-0005ZH-8n; Tue, 01 Dec 2020 16:54:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue,  1 Dec 2020 17:54:19 +0100
Message-Id: <20201201165424.2030647-5-hch@lst.de>
In-Reply-To: <20201201165424.2030647-1-hch@lst.de>
References: <20201201165424.2030647-1-hch@lst.de>
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
Cc: linux-s390@vger.kernel.org, linux-bcache@vger.kernel.org,
	Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-block@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [dm-devel] [PATCH 4/9] block: simplify submit_bio_checks a bit
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

Merge a few checks for whole devices vs partitions to streamline the
sanity checks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c | 40 ++++++++++++++--------------------------
 1 file changed, 14 insertions(+), 26 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 95005a8db5ab2f..3a8fef64d36bc1 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -691,11 +691,9 @@ static inline bool should_fail_request(struct block_device *part,
 
 #endif /* CONFIG_FAIL_MAKE_REQUEST */
 
-static inline bool bio_check_ro(struct bio *bio, struct block_device *part)
+static inline bool bio_check_ro(struct bio *bio)
 {
-	const int op = bio_op(bio);
-
-	if (part->bd_read_only && op_is_write(op)) {
+	if (op_is_write(bio_op(bio)) && bio->bi_bdev->bd_read_only) {
 		char b[BDEVNAME_SIZE];
 
 		if (op_is_flush(bio->bi_opf) && !bio_sectors(bio))
@@ -703,7 +701,7 @@ static inline bool bio_check_ro(struct bio *bio, struct block_device *part)
 
 		WARN_ONCE(1,
 		       "Trying to write to read-only block-device %s (partno %d)\n",
-			bio_devname(bio, b), part->bd_partno);
+			bio_devname(bio, b), bio->bi_bdev->bd_partno);
 		/* Older lvm-tools actually trigger this */
 		return false;
 	}
@@ -724,8 +722,9 @@ ALLOW_ERROR_INJECTION(should_fail_bio, ERRNO);
  * This may well happen - the kernel calls bread() without checking the size of
  * the device, e.g., when mounting a file system.
  */
-static inline int bio_check_eod(struct bio *bio, sector_t maxsector)
+static inline int bio_check_eod(struct bio *bio)
 {
+	sector_t maxsector = bdev_nr_sectors(bio->bi_bdev);
 	unsigned int nr_sectors = bio_sectors(bio);
 
 	if (nr_sectors && maxsector &&
@@ -740,27 +739,20 @@ static inline int bio_check_eod(struct bio *bio, sector_t maxsector)
 /*
  * Remap block n of partition p to block n+start(p) of the disk.
  */
-static inline int blk_partition_remap(struct bio *bio)
+static int blk_partition_remap(struct bio *bio)
 {
 	struct block_device *p = bio->bi_bdev;
-	int ret = -EIO;
 
 	if (unlikely(should_fail_request(p, bio->bi_iter.bi_size)))
-		goto out;
-	if (unlikely(bio_check_ro(bio, p)))
-		goto out;
+		return -EIO;
 
 	if (bio_sectors(bio)) {
-		if (bio_check_eod(bio, bdev_nr_sectors(p)))
-			goto out;
 		bio->bi_iter.bi_sector += p->bd_start_sect;
 		trace_block_bio_remap(bio, p->bd_dev,
 				      bio->bi_iter.bi_sector -
 				      p->bd_start_sect);
 	}
-	ret = 0;
-out:
-	return ret;
+	return 0;
 }
 
 /*
@@ -820,16 +812,12 @@ static noinline_for_stack bool submit_bio_checks(struct bio *bio)
 
 	if (should_fail_bio(bio))
 		goto end_io;
-
-	if (bio->bi_bdev->bd_partno) {
-		if (unlikely(blk_partition_remap(bio)))
-			goto end_io;
-	} else {
-		if (unlikely(bio_check_ro(bio, bdev_whole(bdev))))
-			goto end_io;
-		if (unlikely(bio_check_eod(bio, get_capacity(bdev->bd_disk))))
-			goto end_io;
-	}
+	if (unlikely(bio_check_ro(bio)))
+		goto end_io;
+	if (unlikely(bio_check_eod(bio)))
+		goto end_io;
+	if (bio->bi_bdev->bd_partno && unlikely(blk_partition_remap(bio)))
+		goto end_io;
 
 	/*
 	 * Filter flush bio's early so that bio based drivers without flush
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

