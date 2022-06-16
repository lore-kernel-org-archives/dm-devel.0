Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F338C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 16 Jun 2022 17:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1655400557;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qsWQpfP+NOGO1f+KOCTAtC8/IGVxol1nF8ZaCTB/5lw=;
	b=PteFp5dRHTuXz1EKvUYbkbMRlezCMWv4UfZkZWoec8NY9piq8TmeCBMlewD5WwRycgnoEk
	iEm3qCXkWX3iieLegxzARpvCwMkcu5BTp6XXw3htasLU500Z3Ou4tsSIf4qfzATrT0kG1N
	McWjKbbrAdWvxZiQjmtw3uJFaxAcMHE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-U-0OGuGuPLmWYF7oEb14yg-1; Thu, 16 Jun 2022 13:29:14 -0400
X-MC-Unique: U-0OGuGuPLmWYF7oEb14yg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4BC03101A56D;
	Thu, 16 Jun 2022 17:29:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ED9A01415106;
	Thu, 16 Jun 2022 17:29:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D192C1947062;
	Thu, 16 Jun 2022 17:29:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CF310194705D
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Jun 2022 17:21:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9B0BA40E80E2; Thu, 16 Jun 2022 17:21:27 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 93E4140E80E1;
 Thu, 16 Jun 2022 17:21:27 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 25GHLRnt024919; Thu, 16 Jun 2022 13:21:27 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 25GHLRRV024915; Thu, 16 Jun 2022 13:21:27 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Thu, 16 Jun 2022 13:21:27 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Message-ID: <alpine.LRH.2.02.2206161222001.22594@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH] dm: fix accessing of freed memory in
 dm_put_live_table_bio
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

dm_put_live_table_bio is called from the end of dm_submit_bio. However, at
this point, the bio may be already finished and the caller may have freed
the bio. Consequently, dm_put_live_table_bio accesses the stale "bio"
pointer.

This patch fixes the bug by loading the bi_opf value and passing this
value to dm_get_live_table_bio and dm_put_live_table_bio
instead of the bio.

This bug was found by running the lvm testsuite with kasan.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 563a225c9fd20 ("dm: introduce dm_{get,put}_live_table_bio called from dm_submit_bio")

---
 drivers/md/dm.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2022-06-13 13:01:16.000000000 +0200
+++ linux-2.6/drivers/md/dm.c	2022-06-16 09:20:45.000000000 +0200
@@ -711,18 +711,18 @@ static void dm_put_live_table_fast(struc
 }
 
 static inline struct dm_table *dm_get_live_table_bio(struct mapped_device *md,
-						     int *srcu_idx, struct bio *bio)
+						     int *srcu_idx, unsigned bio_opf)
 {
-	if (bio->bi_opf & REQ_NOWAIT)
+	if (bio_opf & REQ_NOWAIT)
 		return dm_get_live_table_fast(md);
 	else
 		return dm_get_live_table(md, srcu_idx);
 }
 
 static inline void dm_put_live_table_bio(struct mapped_device *md, int srcu_idx,
-					 struct bio *bio)
+					 unsigned bio_opf)
 {
-	if (bio->bi_opf & REQ_NOWAIT)
+	if (bio_opf & REQ_NOWAIT)
 		dm_put_live_table_fast(md);
 	else
 		dm_put_live_table(md, srcu_idx);
@@ -1711,8 +1711,9 @@ static void dm_submit_bio(struct bio *bi
 	struct mapped_device *md = bio->bi_bdev->bd_disk->private_data;
 	int srcu_idx;
 	struct dm_table *map;
+	unsigned bio_opf = bio->bi_opf;
 
-	map = dm_get_live_table_bio(md, &srcu_idx, bio);
+	map = dm_get_live_table_bio(md, &srcu_idx, bio_opf);
 
 	/* If suspended, or map not yet available, queue this IO for later */
 	if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) ||
@@ -1728,7 +1729,7 @@ static void dm_submit_bio(struct bio *bi
 
 	dm_split_and_process_bio(md, map, bio);
 out:
-	dm_put_live_table_bio(md, srcu_idx, bio);
+	dm_put_live_table_bio(md, srcu_idx, bio_opf);
 }
 
 static bool dm_poll_dm_io(struct dm_io *io, struct io_comp_batch *iob,
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

