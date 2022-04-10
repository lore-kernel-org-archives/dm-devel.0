Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E28BC433EF
	for <dm-devel@archiver.kernel.org>; Sun, 10 Apr 2022 02:12:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-84-8bMRiusfPR65YGzntgqA_A-1; Sat, 09 Apr 2022 22:12:18 -0400
X-MC-Unique: 8bMRiusfPR65YGzntgqA_A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3FFC3806649;
	Sun, 10 Apr 2022 02:12:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A131CC44AE2;
	Sun, 10 Apr 2022 02:12:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4265419451F1;
	Sun, 10 Apr 2022 02:12:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 756F819451EF
 for <dm-devel@listman.corp.redhat.com>; Sun, 10 Apr 2022 02:12:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5639840470D0; Sun, 10 Apr 2022 02:12:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 52814404778D
 for <dm-devel@redhat.com>; Sun, 10 Apr 2022 02:12:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 395F380B71C
 for <dm-devel@redhat.com>; Sun, 10 Apr 2022 02:12:15 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-457-5L7gaUSqNtWc-kEfJJ3V5Q-1; Sat, 09 Apr 2022 22:12:11 -0400
X-MC-Unique: 5L7gaUSqNtWc-kEfJJ3V5Q-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 571C760E8C;
 Sun, 10 Apr 2022 02:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F25C385A4;
 Sun, 10 Apr 2022 02:12:09 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	snitzer@redhat.com
Date: Sat,  9 Apr 2022 22:12:07 -0400
Message-Id: <20220410021207.101184-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] Patch "dm: requeue IO if mapping table not yet
 available" has been added to the 5.17-stable tree
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
Cc: dm-devel@redhat.com, Shaohua Li <shli@kernel.org>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is a note to let you know that I've just added the patch titled

    dm: requeue IO if mapping table not yet available

to the 5.17-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-requeue-io-if-mapping-table-not-yet-available.patch
and it can be found in the queue-5.17 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 9e2572a0cf4482e4d9101470f1f5d9c024f0b0cf
Author: Mike Snitzer <snitzer@redhat.com>
Date:   Tue Feb 22 13:28:12 2022 -0500

    dm: requeue IO if mapping table not yet available
    
    [ Upstream commit fa247089de9936a46e290d4724cb5f0b845600f5 ]
    
    Update both bio-based and request-based DM to requeue IO if the
    mapping table not available.
    
    This race of IO being submitted before the DM device ready is so
    narrow, yet possible for initial table load given that the DM device's
    request_queue is created prior, that it best to requeue IO to handle
    this unlikely case.
    
    Reported-by: Zhang Yi <yi.zhang@huawei.com>
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 579ab6183d4d..dffeb47a9efb 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -499,8 +499,13 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 	if (unlikely(!ti)) {
 		int srcu_idx;
-		struct dm_table *map = dm_get_live_table(md, &srcu_idx);
+		struct dm_table *map;
 
+		map = dm_get_live_table(md, &srcu_idx);
+		if (unlikely(!map)) {
+			dm_put_live_table(md, srcu_idx);
+			return BLK_STS_RESOURCE;
+		}
 		ti = dm_table_find_target(map, 0);
 		dm_put_live_table(md, srcu_idx);
 	}
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 394778d8bf54..dcb8d8fc7877 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1519,15 +1519,10 @@ static void dm_submit_bio(struct bio *bio)
 	struct dm_table *map;
 
 	map = dm_get_live_table(md, &srcu_idx);
-	if (unlikely(!map)) {
-		DMERR_LIMIT("%s: mapping table unavailable, erroring io",
-			    dm_device_name(md));
-		bio_io_error(bio);
-		goto out;
-	}
 
-	/* If suspended, queue this IO for later */
-	if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags))) {
+	/* If suspended, or map not yet available, queue this IO for later */
+	if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) ||
+	    unlikely(!map)) {
 		if (bio->bi_opf & REQ_NOWAIT)
 			bio_wouldblock_error(bio);
 		else if (bio->bi_opf & REQ_RAHEAD)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

