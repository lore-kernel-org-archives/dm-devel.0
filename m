Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89461C433F5
	for <dm-devel@archiver.kernel.org>; Tue,  8 Mar 2022 06:58:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-392-BYEic7IuMOGXD-tM2KDh7w-1; Tue, 08 Mar 2022 01:58:22 -0500
X-MC-Unique: BYEic7IuMOGXD-tM2KDh7w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 419C12999B4B;
	Tue,  8 Mar 2022 06:58:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2BBA7400F3EF;
	Tue,  8 Mar 2022 06:58:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D922A1931BEC;
	Tue,  8 Mar 2022 06:58:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C8F52194E109
 for <dm-devel@listman.corp.redhat.com>; Tue,  8 Mar 2022 06:58:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B4D551121332; Tue,  8 Mar 2022 06:58:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B05B61121331
 for <dm-devel@redhat.com>; Tue,  8 Mar 2022 06:58:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A349E3C153A0
 for <dm-devel@redhat.com>; Tue,  8 Mar 2022 06:58:15 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-mn59Ymf2PiSuIuOUzXgFpw-1; Tue, 08 Mar 2022 01:58:13 -0500
X-MC-Unique: mn59Ymf2PiSuIuOUzXgFpw-1
Received: from [2001:4bb8:184:7746:6f50:7a98:3141:c37b] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1nRT8W-002lVU-KM; Tue, 08 Mar 2022 06:15:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue,  8 Mar 2022 07:15:47 +0100
Message-Id: <20220308061551.737853-2-hch@lst.de>
In-Reply-To: <20220308061551.737853-1-hch@lst.de>
References: <20220308061551.737853-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [PATCH 1/5] btrfs: simplify ->flush_bio handling
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
Cc: linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
 Mike Snitzer <snitzer@redhat.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
 Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com, target-devel@vger.kernel.org,
 David Sterba <dsterba@suse.com>, Phillip Lougher <phillip@squashfs.org.uk>,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use and embedded bios that is initialized when used instead of
bio_kmalloc plus bio_reset.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c |  8 +++++---
 fs/btrfs/volumes.c | 11 -----------
 fs/btrfs/volumes.h |  4 ++--
 3 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 505ba21230b1f..7d4229c769ac6 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4127,6 +4127,7 @@ static int wait_dev_supers(struct btrfs_device *device, int max_mirrors)
  */
 static void btrfs_end_empty_barrier(struct bio *bio)
 {
+	bio_uninit(bio);
 	complete(bio->bi_private);
 }
 
@@ -4136,7 +4137,7 @@ static void btrfs_end_empty_barrier(struct bio *bio)
  */
 static void write_dev_flush(struct btrfs_device *device)
 {
-	struct bio *bio = device->flush_bio;
+	struct bio *bio = &device->flush_bio;
 
 #ifndef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 	/*
@@ -4154,7 +4155,8 @@ static void write_dev_flush(struct btrfs_device *device)
 		return;
 #endif
 
-	bio_reset(bio, device->bdev, REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH);
+	bio_init(bio, device->bdev, NULL, 0,
+		 REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH);
 	bio->bi_end_io = btrfs_end_empty_barrier;
 	init_completion(&device->flush_wait);
 	bio->bi_private = &device->flush_wait;
@@ -4168,7 +4170,7 @@ static void write_dev_flush(struct btrfs_device *device)
  */
 static blk_status_t wait_dev_flush(struct btrfs_device *device)
 {
-	struct bio *bio = device->flush_bio;
+	struct bio *bio = &device->flush_bio;
 
 	if (!test_bit(BTRFS_DEV_STATE_FLUSH_SENT, &device->dev_state))
 		return BLK_STS_OK;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b07d382d53a86..7015b3096f724 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -405,7 +405,6 @@ void btrfs_free_device(struct btrfs_device *device)
 	WARN_ON(!list_empty(&device->post_commit_list));
 	rcu_string_free(device->name);
 	extent_io_tree_release(&device->alloc_state);
-	bio_put(device->flush_bio);
 	btrfs_destroy_dev_zone_info(device);
 	kfree(device);
 }
@@ -6962,16 +6961,6 @@ struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
 
-	/*
-	 * Preallocate a bio that's always going to be used for flushing device
-	 * barriers and matches the device lifespan
-	 */
-	dev->flush_bio = bio_kmalloc(GFP_KERNEL, 0);
-	if (!dev->flush_bio) {
-		kfree(dev);
-		return ERR_PTR(-ENOMEM);
-	}
-
 	INIT_LIST_HEAD(&dev->dev_list);
 	INIT_LIST_HEAD(&dev->dev_alloc_list);
 	INIT_LIST_HEAD(&dev->post_commit_list);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 005c9e2a491a1..dbd6cc5e5cd3b 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -116,8 +116,8 @@ struct btrfs_device {
 	/* bytes used on the current transaction */
 	u64 commit_bytes_used;
 
-	/* for sending down flush barriers */
-	struct bio *flush_bio;
+	/* Bio used for flushing device barriers */
+	struct bio flush_bio;
 	struct completion flush_wait;
 
 	/* per-device scrub information */
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

