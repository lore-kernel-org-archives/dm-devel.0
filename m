Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4A82C433E6
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2EA7A21D1B
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2EA7A21D1B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-XjUHewAqMeus90xlHL0vJA-1; Mon, 04 Jan 2021 14:03:55 -0500
X-MC-Unique: XjUHewAqMeus90xlHL0vJA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EFED68144EC;
	Mon,  4 Jan 2021 19:03:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CDAAC271B1;
	Mon,  4 Jan 2021 19:03:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9DBC31809CAF;
	Mon,  4 Jan 2021 19:03:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BNBQakP019556 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 23 Dec 2020 06:26:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 68D77110E988; Wed, 23 Dec 2020 11:26:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 651E7110E987
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 11:26:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52F33858280
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 11:26:36 +0000 (UTC)
Received: from out30-131.freemail.mail.aliyun.com
	(out30-131.freemail.mail.aliyun.com [115.124.30.131]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-218-UlfaRnjfMcKHpqTmBzKx5A-1;
	Wed, 23 Dec 2020 06:26:33 -0500
X-MC-Unique: UlfaRnjfMcKHpqTmBzKx5A-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R221e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04357;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=4; SR=0;
	TI=SMTPD_---0UJXS7XR_1608722786
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UJXS7XR_1608722786) by smtp.aliyun-inc.com(127.0.0.1);
	Wed, 23 Dec 2020 19:26:26 +0800
From: Jeffle Xu <jefflexu@linux.alibaba.com>
To: snitzer@redhat.com
Date: Wed, 23 Dec 2020 19:26:22 +0800
Message-Id: <20201223112624.78955-6-jefflexu@linux.alibaba.com>
In-Reply-To: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
References: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
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
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:12 -0500
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, io-uring@vger.kernel.org
Subject: [dm-devel] [PATCH RFC 5/7] dm: always return BLK_QC_T_NONE for
	bio-based device
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Currently the returned cookie of bio-based device is not used at all.

In the following patches, bio-based device will actually return a
pointer to a specific object as the returned cookie.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 drivers/md/dm.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 5b2f371ec4bb..03c2b867acaa 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1252,14 +1252,13 @@ void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors)
 }
 EXPORT_SYMBOL_GPL(dm_accept_partial_bio);
 
-static blk_qc_t __map_bio(struct dm_target_io *tio)
+static void __map_bio(struct dm_target_io *tio)
 {
 	int r;
 	sector_t sector;
 	struct bio *clone = &tio->clone;
 	struct dm_io *io = tio->io;
 	struct dm_target *ti = tio->ti;
-	blk_qc_t ret = BLK_QC_T_NONE;
 
 	clone->bi_end_io = clone_endio;
 
@@ -1278,7 +1277,7 @@ static blk_qc_t __map_bio(struct dm_target_io *tio)
 	case DM_MAPIO_REMAPPED:
 		/* the bio has been remapped so dispatch it */
 		trace_block_bio_remap(clone, bio_dev(io->orig_bio), sector);
-		ret = submit_bio_noacct(clone);
+		submit_bio_noacct(clone);
 		break;
 	case DM_MAPIO_KILL:
 		free_tio(tio);
@@ -1292,8 +1291,6 @@ static blk_qc_t __map_bio(struct dm_target_io *tio)
 		DMWARN("unimplemented target map return value: %d", r);
 		BUG();
 	}
-
-	return ret;
 }
 
 static void bio_setup_sector(struct bio *bio, sector_t sector, unsigned len)
@@ -1380,7 +1377,7 @@ static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
 	}
 }
 
-static blk_qc_t __clone_and_map_simple_bio(struct clone_info *ci,
+static void __clone_and_map_simple_bio(struct clone_info *ci,
 					   struct dm_target_io *tio, unsigned *len)
 {
 	struct bio *clone = &tio->clone;
@@ -1391,7 +1388,7 @@ static blk_qc_t __clone_and_map_simple_bio(struct clone_info *ci,
 	if (len)
 		bio_setup_sector(clone, ci->sector, *len);
 
-	return __map_bio(tio);
+	__map_bio(tio);
 }
 
 static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
@@ -1405,7 +1402,7 @@ static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
 
 	while ((bio = bio_list_pop(&blist))) {
 		tio = container_of(bio, struct dm_target_io, clone);
-		(void) __clone_and_map_simple_bio(ci, tio, len);
+		__clone_and_map_simple_bio(ci, tio, len);
 	}
 }
 
@@ -1450,7 +1447,7 @@ static int __clone_and_map_data_bio(struct clone_info *ci, struct dm_target *ti,
 		free_tio(tio);
 		return r;
 	}
-	(void) __map_bio(tio);
+	__map_bio(tio);
 
 	return 0;
 }
@@ -1565,11 +1562,10 @@ static void init_clone_info(struct clone_info *ci, struct mapped_device *md,
 /*
  * Entry point to split a bio into clones and submit them to the targets.
  */
-static blk_qc_t __split_and_process_bio(struct mapped_device *md,
+static void __split_and_process_bio(struct mapped_device *md,
 					struct dm_table *map, struct bio *bio)
 {
 	struct clone_info ci;
-	blk_qc_t ret = BLK_QC_T_NONE;
 	int error = 0;
 
 	init_clone_info(&ci, md, map, bio);
@@ -1613,7 +1609,7 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
 
 				bio_chain(b, bio);
 				trace_block_split(b, bio->bi_iter.bi_sector);
-				ret = submit_bio_noacct(bio);
+				submit_bio_noacct(bio);
 				break;
 			}
 		}
@@ -1621,13 +1617,11 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
 
 	/* drop the extra reference count */
 	dec_pending(ci.io, errno_to_blk_status(error));
-	return ret;
 }
 
 static blk_qc_t dm_submit_bio(struct bio *bio)
 {
 	struct mapped_device *md = bio->bi_disk->private_data;
-	blk_qc_t ret = BLK_QC_T_NONE;
 	int srcu_idx;
 	struct dm_table *map;
 
@@ -1657,10 +1651,10 @@ static blk_qc_t dm_submit_bio(struct bio *bio)
 	if (is_abnormal_io(bio))
 		blk_queue_split(&bio);
 
-	ret = __split_and_process_bio(md, map, bio);
+	__split_and_process_bio(md, map, bio);
 out:
 	dm_put_live_table(md, srcu_idx);
-	return ret;
+	return BLK_QC_T_NONE;
 }
 
 /*-----------------------------------------------------------------
-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

