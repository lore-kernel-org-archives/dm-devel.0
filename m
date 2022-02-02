Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93ADFC433EF
	for <dm-devel@archiver.kernel.org>; Wed,  2 Feb 2022 16:01:50 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-peNjbAuCMliaJhkH2jEbhg-1; Wed, 02 Feb 2022 11:01:47 -0500
X-MC-Unique: peNjbAuCMliaJhkH2jEbhg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5CB1188E3C8;
	Wed,  2 Feb 2022 16:01:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 78B5B22E0A;
	Wed,  2 Feb 2022 16:01:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4EAAB1806D2B;
	Wed,  2 Feb 2022 16:01:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 212G1OCY018647 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Feb 2022 11:01:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7EBF54021D8; Wed,  2 Feb 2022 16:01:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B305401E4A
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 16:01:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 62F0F2A5954B
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 16:01:24 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-626-IlCaEaWcPsWpHRmavXvgsg-1; Wed, 02 Feb 2022 11:01:19 -0500
X-MC-Unique: IlCaEaWcPsWpHRmavXvgsg-1
Received: from [2001:4bb8:191:327d:b3e5:1ccd:eaac:6609] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nFI4L-00G7xZ-0B; Wed, 02 Feb 2022 16:01:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  2 Feb 2022 17:00:58 +0100
Message-Id: <20220202160109.108149-3-hch@lst.de>
In-Reply-To: <20220202160109.108149-1-hch@lst.de>
References: <20220202160109.108149-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Pavel Begunkov <asml.silence@gmail.com>, drbd-dev@lists.linbit.com
Subject: [dm-devel] [PATCH 02/13] dm: add a clone_to_tio helper
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

Add a helper to stop open coding the container_of operations to get
from the clone bio to the tio structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm.c | 34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index fa596b654c99c..5543e18f3c3bc 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -79,10 +79,14 @@ struct clone_info {
 #define DM_IO_BIO_OFFSET \
 	(offsetof(struct dm_target_io, clone) + offsetof(struct dm_io, tio))
 
+static inline struct dm_target_io *clone_to_tio(struct bio *clone)
+{
+	return container_of(clone, struct dm_target_io, clone);
+}
+
 void *dm_per_bio_data(struct bio *bio, size_t data_size)
 {
-	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
-	if (!tio->inside_dm_io)
+	if (!clone_to_tio(bio)->inside_dm_io)
 		return (char *)bio - DM_TARGET_IO_BIO_OFFSET - data_size;
 	return (char *)bio - DM_IO_BIO_OFFSET - data_size;
 }
@@ -477,10 +481,7 @@ static int dm_blk_ioctl(struct block_device *bdev, fmode_t mode,
 
 u64 dm_start_time_ns_from_clone(struct bio *bio)
 {
-	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
-	struct dm_io *io = tio->io;
-
-	return jiffies_to_nsecs(io->start_time);
+	return jiffies_to_nsecs(clone_to_tio(bio)->io->start_time);
 }
 EXPORT_SYMBOL_GPL(dm_start_time_ns_from_clone);
 
@@ -521,7 +522,7 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 
 	clone = bio_alloc_bioset(NULL, 0, 0, GFP_NOIO, &md->io_bs);
 
-	tio = container_of(clone, struct dm_target_io, clone);
+	tio = clone_to_tio(clone);
 	tio->inside_dm_io = true;
 	tio->io = NULL;
 
@@ -557,7 +558,7 @@ static struct dm_target_io *alloc_tio(struct clone_info *ci, struct dm_target *t
 		if (!clone)
 			return NULL;
 
-		tio = container_of(clone, struct dm_target_io, clone);
+		tio = clone_to_tio(clone);
 		tio->inside_dm_io = false;
 	}
 
@@ -878,7 +879,7 @@ static bool swap_bios_limit(struct dm_target *ti, struct bio *bio)
 static void clone_endio(struct bio *bio)
 {
 	blk_status_t error = bio->bi_status;
-	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
+	struct dm_target_io *tio = clone_to_tio(bio);
 	struct dm_io *io = tio->io;
 	struct mapped_device *md = tio->io->md;
 	dm_endio_fn endio = tio->ti->type->end_io;
@@ -1084,7 +1085,7 @@ static int dm_dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
  */
 void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors)
 {
-	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
+	struct dm_target_io *tio = clone_to_tio(bio);
 	unsigned bi_size = bio->bi_iter.bi_size >> SECTOR_SHIFT;
 
 	BUG_ON(bio->bi_opf & REQ_PREFLUSH);
@@ -1257,10 +1258,8 @@ static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
 		if (bio_nr == num_bios)
 			return;
 
-		while ((bio = bio_list_pop(blist))) {
-			tio = container_of(bio, struct dm_target_io, clone);
-			free_tio(tio);
-		}
+		while ((bio = bio_list_pop(blist)))
+			free_tio(clone_to_tio(bio));
 	}
 }
 
@@ -1282,14 +1281,11 @@ static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
 {
 	struct bio_list blist = BIO_EMPTY_LIST;
 	struct bio *bio;
-	struct dm_target_io *tio;
 
 	alloc_multiple_bios(&blist, ci, ti, num_bios);
 
-	while ((bio = bio_list_pop(&blist))) {
-		tio = container_of(bio, struct dm_target_io, clone);
-		__clone_and_map_simple_bio(ci, tio, len);
-	}
+	while ((bio = bio_list_pop(&blist)))
+		__clone_and_map_simple_bio(ci, clone_to_tio(bio), len);
 }
 
 static int __send_empty_flush(struct clone_info *ci)
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

