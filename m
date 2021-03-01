Return-Path: <SRS0=9wY3=H7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEE84C433DB
	for <dm-devel@archiver.kernel.org>; Mon,  1 Mar 2021 09:59:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3D4EC64E40
	for <dm-devel@archiver.kernel.org>; Mon,  1 Mar 2021 09:59:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D4EC64E40
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1614592748;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/CWdM+Nj7ZqUtAFkmPEuJSWKUi5YsoIhxNVXHD/Hdqg=;
	b=JHp7nMbntLC6jwz1VJ6GmHe0gzMCwORUagnWs075vUiofyvEGjS3bqv8rvS0yomvtRCYOs
	jwxbBbrnkX+hpZhhPcUkCHKFrnNJObYVJJ//GxMq9IaT/8asBHl1VIF2hO0vqDEzdzCqrK
	YkaPnm8OwEv54aj3HbaLONwddeuD25E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-O0etXLhyM8KxHP-6qBVxgw-1; Mon, 01 Mar 2021 04:59:06 -0500
X-MC-Unique: O0etXLhyM8KxHP-6qBVxgw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8963580197A;
	Mon,  1 Mar 2021 09:59:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A77266FFF;
	Mon,  1 Mar 2021 09:58:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 98C944EEF6;
	Mon,  1 Mar 2021 09:58:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1219wqPw016272 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 1 Mar 2021 04:58:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 22012385; Mon,  1 Mar 2021 09:58:52 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 01B1419C78;
	Mon,  1 Mar 2021 09:58:44 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 1219wigt004615; Mon, 1 Mar 2021 04:58:44 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 1219whi2004611; Mon, 1 Mar 2021 04:58:43 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Mon, 1 Mar 2021 04:58:43 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Message-ID: <alpine.LRH.2.02.2103010457510.631@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: [dm-devel] [PATCH] dm: remove useless loop in
	__split_and_process_bio
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

Remove useless "while" loop. If the condition ci.sector_count && !error is
true, we go to a branch that ends with "break". If this condition is
false, the "while" loop will not be executed again. So, the loop can't be
executed more than once.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   57 ++++++++++++++++++++++++++------------------------------
 1 file changed, 27 insertions(+), 30 deletions(-)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2021-02-23 17:18:54.000000000 +0100
+++ linux-2.6/drivers/md/dm.c	2021-02-26 19:10:31.000000000 +0100
@@ -1584,38 +1584,35 @@ static blk_qc_t __split_and_process_bio(
 	} else {
 		ci.bio = bio;
 		ci.sector_count = bio_sectors(bio);
-		while (ci.sector_count && !error) {
-			error = __split_and_process_non_flush(&ci);
-			if (ci.sector_count && !error) {
-				/*
-				 * Remainder must be passed to submit_bio_noacct()
-				 * so that it gets handled *after* bios already submitted
-				 * have been completely processed.
-				 * We take a clone of the original to store in
-				 * ci.io->orig_bio to be used by end_io_acct() and
-				 * for dec_pending to use for completion handling.
-				 */
-				struct bio *b = bio_split(bio, bio_sectors(bio) - ci.sector_count,
-							  GFP_NOIO, &md->queue->bio_split);
-				ci.io->orig_bio = b;
+		error = __split_and_process_non_flush(&ci);
+		if (ci.sector_count && !error) {
+			/*
+			 * Remainder must be passed to submit_bio_noacct()
+			 * so that it gets handled *after* bios already submitted
+			 * have been completely processed.
+			 * We take a clone of the original to store in
+			 * ci.io->orig_bio to be used by end_io_acct() and
+			 * for dec_pending to use for completion handling.
+			 */
+			struct bio *b = bio_split(bio, bio_sectors(bio) - ci.sector_count,
+						  GFP_NOIO, &md->queue->bio_split);
+			ci.io->orig_bio = b;
 
-				/*
-				 * Adjust IO stats for each split, otherwise upon queue
-				 * reentry there will be redundant IO accounting.
-				 * NOTE: this is a stop-gap fix, a proper fix involves
-				 * significant refactoring of DM core's bio splitting
-				 * (by eliminating DM's splitting and just using bio_split)
-				 */
-				part_stat_lock();
-				__dm_part_stat_sub(dm_disk(md)->part0,
-						   sectors[op_stat_group(bio_op(bio))], ci.sector_count);
-				part_stat_unlock();
+			/*
+			 * Adjust IO stats for each split, otherwise upon queue
+			 * reentry there will be redundant IO accounting.
+			 * NOTE: this is a stop-gap fix, a proper fix involves
+			 * significant refactoring of DM core's bio splitting
+			 * (by eliminating DM's splitting and just using bio_split)
+			 */
+			part_stat_lock();
+			__dm_part_stat_sub(dm_disk(md)->part0,
+					   sectors[op_stat_group(bio_op(bio))], ci.sector_count);
+			part_stat_unlock();
 
-				bio_chain(b, bio);
-				trace_block_split(b, bio->bi_iter.bi_sector);
-				ret = submit_bio_noacct(bio);
-				break;
-			}
+			bio_chain(b, bio);
+			trace_block_split(b, bio->bi_iter.bi_sector);
+			ret = submit_bio_noacct(bio);
 		}
 	}
 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

