Return-Path: <SRS0=56Wl=GB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9438C433E9
	for <dm-devel@archiver.kernel.org>; Tue, 29 Dec 2020 09:28:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 079A2208D5
	for <dm-devel@archiver.kernel.org>; Tue, 29 Dec 2020 09:28:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 079A2208D5
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=synology.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-Fxku0a7YNluAIUaoSMhkrg-1; Tue, 29 Dec 2020 04:28:50 -0500
X-MC-Unique: Fxku0a7YNluAIUaoSMhkrg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D00B425C9;
	Tue, 29 Dec 2020 09:28:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FED071CBE;
	Tue, 29 Dec 2020 09:28:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 49DD8180954D;
	Tue, 29 Dec 2020 09:28:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BT9Sbjb013083 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 29 Dec 2020 04:28:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 84C3C111286D; Tue, 29 Dec 2020 09:28:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 802BF1112870
	for <dm-devel@redhat.com>; Tue, 29 Dec 2020 09:28:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B266A101A560
	for <dm-devel@redhat.com>; Tue, 29 Dec 2020 09:28:36 +0000 (UTC)
Received: from synology.com (mail.synology.com [211.23.38.101]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-157-MYFnKmrTNDiotIEbS83sfg-1;
	Tue, 29 Dec 2020 04:28:31 -0500
X-MC-Unique: MYFnKmrTNDiotIEbS83sfg-1
Received: from localhost.localdomain (unknown [10.17.198.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by synology.com (Postfix) with ESMTPSA id 1876FCE781A7;
	Tue, 29 Dec 2020 17:21:11 +0800 (CST)
From: dannyshih <dannyshih@synology.com>
To: axboe@kernel.dk
Date: Tue, 29 Dec 2020 17:18:39 +0800
Message-Id: <1609233522-25837-2-git-send-email-dannyshih@synology.com>
In-Reply-To: <1609233522-25837-1-git-send-email-dannyshih@synology.com>
References: <1609233522-25837-1-git-send-email-dannyshih@synology.com>
X-Synology-MCP-Status: no
X-Synology-Spam-Flag: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Virus-Status: no
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
Cc: linux-raid@vger.kernel.org, snitzer@redhat.com, linux-block@vger.kernel.org,
	song@kernel.org, dm-devel@redhat.com,
	Danny Shih <dannyshih@synology.com>, agk@redhat.com
Subject: [dm-devel] [PATCH 1/4] block: introduce submit_bio_noacct_add_head
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Danny Shih <dannyshih@synology.com>

Porvide a way for stacking block device to re-submit the bio
which sholud be handled firstly.

Signed-off-by: Danny Shih <dannyshih@synology.com>
Reviewed-by: Allen Peng <allenpeng@synology.com>
Reviewed-by: Alex Wu <alexwu@synology.com>
---
 block/blk-core.c       | 44 +++++++++++++++++++++++++++++++++-----------
 include/linux/blkdev.h |  1 +
 2 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 96e5fcd..693dc83 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1031,16 +1031,7 @@ static blk_qc_t __submit_bio_noacct_mq(struct bio *bio)
 	return ret;
 }
 
-/**
- * submit_bio_noacct - re-submit a bio to the block device layer for I/O
- * @bio:  The bio describing the location in memory and on the device.
- *
- * This is a version of submit_bio() that shall only be used for I/O that is
- * resubmitted to lower level drivers by stacking block drivers.  All file
- * systems and other upper level users of the block layer should use
- * submit_bio() instead.
- */
-blk_qc_t submit_bio_noacct(struct bio *bio)
+static blk_qc_t do_submit_bio_noacct(struct bio *bio, bool add_head)
 {
 	if (!submit_bio_checks(bio))
 		return BLK_QC_T_NONE;
@@ -1052,7 +1043,10 @@ blk_qc_t submit_bio_noacct(struct bio *bio)
 	 * it is active, and then process them after it returned.
 	 */
 	if (current->bio_list) {
-		bio_list_add(&current->bio_list[0], bio);
+		if (add_head)
+			bio_list_add_head(&current->bio_list[0], bio);
+		else
+			bio_list_add(&current->bio_list[0], bio);
 		return BLK_QC_T_NONE;
 	}
 
@@ -1060,9 +1054,37 @@ blk_qc_t submit_bio_noacct(struct bio *bio)
 		return __submit_bio_noacct_mq(bio);
 	return __submit_bio_noacct(bio);
 }
+
+/**
+ * submit_bio_noacct - re-submit a bio to the block device layer for I/O
+ * @bio:  The bio describing the location in memory and on the device.
+ *
+ * This is a version of submit_bio() that shall only be used for I/O that is
+ * resubmitted to lower level drivers by stacking block drivers.  All file
+ * systems and other upper level users of the block layer should use
+ * submit_bio() instead.
+ */
+blk_qc_t submit_bio_noacct(struct bio *bio)
+{
+	return do_submit_bio_noacct(bio, false);
+}
 EXPORT_SYMBOL(submit_bio_noacct);
 
 /**
+ * submit_bio_noacct - re-submit a bio, which needs to be handle firstly,
+ *                     to the block device layer for I/O
+ * @bio:  The bio describing the location in memory and on the device.
+ *
+ * alternative submit_bio_noacct() which add bio to the head of
+ * current->bio_list.
+ */
+blk_qc_t submit_bio_noacct_add_head(struct bio *bio)
+{
+	return do_submit_bio_noacct(bio, true);
+}
+EXPORT_SYMBOL(submit_bio_noacct_add_head);
+
+/**
  * submit_bio - submit a bio to the block device layer for I/O
  * @bio: The &struct bio which describes the I/O
  *
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 070de09..b0080d0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -905,6 +905,7 @@ static inline void rq_flush_dcache_pages(struct request *rq)
 extern int blk_register_queue(struct gendisk *disk);
 extern void blk_unregister_queue(struct gendisk *disk);
 blk_qc_t submit_bio_noacct(struct bio *bio);
+blk_qc_t submit_bio_noacct_add_head(struct bio *bio);
 extern void blk_rq_init(struct request_queue *q, struct request *rq);
 extern void blk_put_request(struct request *);
 extern struct request *blk_get_request(struct request_queue *, unsigned int op,
-- 
2.7.4

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

