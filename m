Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 991D2C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 18 Jan 2022 07:20:56 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-UkC8Xe_CNwKPChgRJMvlYA-1; Tue, 18 Jan 2022 02:20:52 -0500
X-MC-Unique: UkC8Xe_CNwKPChgRJMvlYA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A489F10168E0;
	Tue, 18 Jan 2022 07:20:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7749816A52;
	Tue, 18 Jan 2022 07:20:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4977C4A7CA;
	Tue, 18 Jan 2022 07:20:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20I7KJOL012944 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 18 Jan 2022 02:20:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EDED4C080B3; Tue, 18 Jan 2022 07:20:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E9A52C080AF
	for <dm-devel@redhat.com>; Tue, 18 Jan 2022 07:20:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D01D2811E78
	for <dm-devel@redhat.com>; Tue, 18 Jan 2022 07:20:18 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-621-0CosxU1UNiitRVur6ycrgw-1; Tue, 18 Jan 2022 02:20:17 -0500
X-MC-Unique: 0CosxU1UNiitRVur6ycrgw-1
Received: from [2001:4bb8:184:72a4:a4a9:19c0:5242:7768] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1n9ims-000ZTk-8m; Tue, 18 Jan 2022 07:20:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue, 18 Jan 2022 08:19:40 +0100
Message-Id: <20220118071952.1243143-8-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
Subject: [dm-devel] [PATCH 07/19] dm-snap: use blkdev_issue_flush instead of
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use blkdev_issue_flush, which uses an on-stack bio instead of an
opencoded version with a bio embedded into struct dm_snapshot.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-snap.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index dcf34c6b05ad3..0d336b5ec5714 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -141,11 +141,6 @@ struct dm_snapshot {
 	 * for them to be committed.
 	 */
 	struct bio_list bios_queued_during_merge;
-
-	/*
-	 * Flush data after merge.
-	 */
-	struct bio flush_bio;
 };
 
 /*
@@ -1127,17 +1122,6 @@ static void snapshot_merge_next_chunks(struct dm_snapshot *s)
 
 static void error_bios(struct bio *bio);
 
-static int flush_data(struct dm_snapshot *s)
-{
-	struct bio *flush_bio = &s->flush_bio;
-
-	bio_reset(flush_bio);
-	bio_set_dev(flush_bio, s->origin->bdev);
-	flush_bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
-
-	return submit_bio_wait(flush_bio);
-}
-
 static void merge_callback(int read_err, unsigned long write_err, void *context)
 {
 	struct dm_snapshot *s = context;
@@ -1151,7 +1135,7 @@ static void merge_callback(int read_err, unsigned long write_err, void *context)
 		goto shut;
 	}
 
-	if (flush_data(s) < 0) {
+	if (blkdev_issue_flush(s->origin->bdev) < 0) {
 		DMERR("Flush after merge failed: shutting down merge");
 		goto shut;
 	}
@@ -1340,7 +1324,6 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	s->first_merging_chunk = 0;
 	s->num_merging_chunks = 0;
 	bio_list_init(&s->bios_queued_during_merge);
-	bio_init(&s->flush_bio, NULL, 0);
 
 	/* Allocate hash table for COW data */
 	if (init_hash_tables(s)) {
@@ -1528,8 +1511,6 @@ static void snapshot_dtr(struct dm_target *ti)
 
 	dm_exception_store_destroy(s->store);
 
-	bio_uninit(&s->flush_bio);
-
 	dm_put_device(ti, s->cow);
 
 	dm_put_device(ti, s->origin);
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

