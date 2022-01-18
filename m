Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51D15C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 18 Jan 2022 07:20:56 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-K-kDZnerNdy7q_3QiJDa1Q-1; Tue, 18 Jan 2022 02:20:51 -0500
X-MC-Unique: K-kDZnerNdy7q_3QiJDa1Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A20B1926DB6;
	Tue, 18 Jan 2022 07:20:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B1FA4EC7F;
	Tue, 18 Jan 2022 07:20:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 12BD24A7C9;
	Tue, 18 Jan 2022 07:20:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20I7KUMB012987 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 18 Jan 2022 02:20:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1E63953C4; Tue, 18 Jan 2022 07:20:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 198A353D3
	for <dm-devel@redhat.com>; Tue, 18 Jan 2022 07:20:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07134800B21
	for <dm-devel@redhat.com>; Tue, 18 Jan 2022 07:20:27 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-486-UsbUihjhO-GOxfirhN344A-1; Tue, 18 Jan 2022 02:20:25 -0500
X-MC-Unique: UsbUihjhO-GOxfirhN344A-1
Received: from [2001:4bb8:184:72a4:a4a9:19c0:5242:7768] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1n9imv-000ZUu-0D; Tue, 18 Jan 2022 07:20:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue, 18 Jan 2022 08:19:41 +0100
Message-Id: <20220118071952.1243143-9-hch@lst.de>
In-Reply-To: <20220118071952.1243143-1-hch@lst.de>
References: <20220118071952.1243143-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
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
Cc: linux-block@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-nilfs@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.co>,
	dm-devel@redhat.com, "Md . Haris Iqbal " <haris.iqbal@ionos.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	linux-fsdevel@vger.kernel.org, xen-devel@lists.xenproject.org,
	Andrew Morton <akpm@linux-foundation.org>, ntfs3@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>, Pavel Begunkov <asml.silence@gmail.com>,
	drbd-dev@lists.linbit.com
Subject: [dm-devel] [PATCH 08/19] dm-thin: use blkdev_issue_flush instead of
	open coding it
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

Use blkdev_issue_flush, which uses an on-stack bio instead of an
opencoded version with a bio embedded into struct pool.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-thin.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 76a9c2e9aeeea..411a3f56ed90c 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -282,8 +282,6 @@ struct pool {
 	struct dm_bio_prison_cell **cell_sort_array;
 
 	mempool_t mapping_pool;
-
-	struct bio flush_bio;
 };
 
 static void metadata_operation_failed(struct pool *pool, const char *op, int r);
@@ -2906,7 +2904,6 @@ static void __pool_destroy(struct pool *pool)
 	if (pool->next_mapping)
 		mempool_free(pool->next_mapping, &pool->mapping_pool);
 	mempool_exit(&pool->mapping_pool);
-	bio_uninit(&pool->flush_bio);
 	dm_deferred_set_destroy(pool->shared_read_ds);
 	dm_deferred_set_destroy(pool->all_io_ds);
 	kfree(pool);
@@ -2987,7 +2984,6 @@ static struct pool *pool_create(struct mapped_device *pool_md,
 	pool->low_water_triggered = false;
 	pool->suspended = true;
 	pool->out_of_data_space = false;
-	bio_init(&pool->flush_bio, NULL, 0);
 
 	pool->shared_read_ds = dm_deferred_set_create();
 	if (!pool->shared_read_ds) {
@@ -3194,13 +3190,8 @@ static void metadata_low_callback(void *context)
 static int metadata_pre_commit_callback(void *context)
 {
 	struct pool *pool = context;
-	struct bio *flush_bio = &pool->flush_bio;
-
-	bio_reset(flush_bio);
-	bio_set_dev(flush_bio, pool->data_dev);
-	flush_bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
 
-	return submit_bio_wait(flush_bio);
+	return blkdev_issue_flush(pool->data_dev);
 }
 
 static sector_t get_dev_size(struct block_device *bdev)
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

