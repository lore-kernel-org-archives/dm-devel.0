Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC48FC77B75
	for <dm-devel@archiver.kernel.org>; Tue, 18 Apr 2023 19:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681847842;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+uWXaxir2v7wy99Rk8imJD1MrREAT5LjkB5uLS8oXTc=;
	b=Yy+L9lA7pP4YE1Nr15Uh87UkHeqQp7hhF8Ux8QauSP/VvxmC3Smm2VD8AbHByyedvbfIGu
	BcOvW7pI8eYW7jirsiXZEiqKIPKgJhSsEoqdHCIbmKbfjayTH3qEcPcza73b+SsXSsGN9W
	p1+UTW4HlJqaVW5VMu0IcvJqF0CAHNA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-125-MqRalTB5M1-J0s95ZYgg1Q-1; Tue, 18 Apr 2023 15:57:19 -0400
X-MC-Unique: MqRalTB5M1-J0s95ZYgg1Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D77C85A588;
	Tue, 18 Apr 2023 19:57:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6AB2FC15BAD;
	Tue, 18 Apr 2023 19:57:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 407531946594;
	Tue, 18 Apr 2023 19:57:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 016D8194658F
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Apr 2023 19:57:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C763A202A42B; Tue, 18 Apr 2023 19:57:15 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B7A64202A428;
 Tue, 18 Apr 2023 19:57:15 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 33IJvFZ9030262; Tue, 18 Apr 2023 15:57:15 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 33IJvF16030258; Tue, 18 Apr 2023 15:57:15 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Tue, 18 Apr 2023 15:57:15 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Message-ID: <alpine.LRH.2.21.2304181556460.30044@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH 3/5] dm flakey: clone pages on write bio before
 corrupting them
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

dm-flakey has an option to corrupt write bios. It corrupts the memory that
is being written. This can cause system crashes or security bugs - for
example, if the user writes a shared library code with O_DIRECT flag to a
dm-flakey device, it corrupts the memory for all users that have the
shared library mapped.

We fix this bug by cloning the bio and corrupting the clone rather than
the original.

We also drop the test for ZERO_PAGE(0) - it can't happen because we write
the cloned pages.

This patch needs
https://listman.redhat.com/archives/dm-devel/2023-April/053913.html as a
prerequisite.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-flakey.c |  106 +++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 95 insertions(+), 11 deletions(-)

Index: linux-2.6/drivers/md/dm-flakey.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-flakey.c
+++ linux-2.6/drivers/md/dm-flakey.c
@@ -322,11 +322,7 @@ static void corrupt_bio_data(struct bio
 	 */
 	bio_for_each_segment(bvec, bio, iter) {
 		if (bio_iter_len(bio, iter) > corrupt_bio_byte) {
-			char *segment;
-			struct page *page = bio_iter_page(bio, iter);
-			if (unlikely(page == ZERO_PAGE(0)))
-				break;
-			segment = bvec_kmap_local(&bvec);
+			char *segment = bvec_kmap_local(&bvec);
 			segment[corrupt_bio_byte] = fc->corrupt_bio_value;
 			kunmap_local(segment);
 			DMDEBUG("Corrupting data bio=%p by writing %u to byte %u "
@@ -340,6 +336,90 @@ static void corrupt_bio_data(struct bio
 	}
 }
 
+static void clone_free(struct bio *clone)
+{
+	struct folio_iter fi;
+
+	bio_for_each_folio_all(fi, clone)
+		folio_put(fi.folio);
+
+	bio_uninit(clone);
+	kfree(clone);
+}
+
+static void clone_endio(struct bio *clone)
+{
+	struct bio *bio = clone->bi_private;
+	bio->bi_status = clone->bi_status;
+	clone_free(clone);
+	bio_endio(bio);
+}
+
+static struct bio *clone_bio(struct dm_target *ti, struct flakey_c *fc, struct bio *bio)
+{
+	struct bio *clone;
+	unsigned size, remaining_size, nr_iovecs, order;
+	struct bvec_iter iter = bio->bi_iter;
+
+	if (unlikely(bio->bi_iter.bi_size > UIO_MAXIOV << PAGE_SHIFT))
+		dm_accept_partial_bio(bio, UIO_MAXIOV << PAGE_SHIFT >> SECTOR_SHIFT);
+
+	size = bio->bi_iter.bi_size;
+	nr_iovecs = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
+
+	clone = bio_kmalloc(nr_iovecs, GFP_NOIO | __GFP_NORETRY | __GFP_NOWARN);
+	if (!clone)
+		return NULL;
+
+	bio_init(clone, fc->dev->bdev, bio->bi_inline_vecs, nr_iovecs, bio->bi_opf);
+
+	clone->bi_iter.bi_sector = flakey_map_sector(ti, bio->bi_iter.bi_sector);
+	clone->bi_private = bio;
+	clone->bi_end_io = clone_endio;
+
+	remaining_size = size;
+
+	order = MAX_ORDER - 1;
+	while (remaining_size) {
+		struct page *pages;
+		unsigned size_to_add, to_copy;
+		unsigned char *virt;
+		unsigned remaining_order = __fls((remaining_size + PAGE_SIZE - 1) >> PAGE_SHIFT);
+		order = min(order, remaining_order);
+
+retry_alloc_pages:
+		pages = alloc_pages(GFP_NOIO | __GFP_NORETRY | __GFP_NOWARN | __GFP_COMP, order);
+		if (unlikely(!pages)) {
+			if (order) {
+				order--;
+				goto retry_alloc_pages;
+			}
+			clone_free(clone);
+			return NULL;
+		}
+		size_to_add = min((unsigned)PAGE_SIZE << order, remaining_size);
+
+		virt = page_to_virt(pages);
+		to_copy = size_to_add;
+		do {
+			struct bio_vec bvec = bvec_iter_bvec(bio->bi_io_vec, iter);
+			unsigned this_step = min(bvec.bv_len, to_copy);
+			void *map = bvec_kmap_local(&bvec);
+			memcpy(virt, map, this_step);
+			kunmap_local(map);
+
+			bvec_iter_advance(bio->bi_io_vec, &iter, this_step);
+			to_copy -= this_step;
+			virt += this_step;
+		} while (to_copy);
+
+		bio_add_page(clone, pages, size_to_add, 0);
+		remaining_size -= size_to_add;
+	}
+
+	return clone;
+}
+
 static int flakey_map(struct dm_target *ti, struct bio *bio)
 {
 	struct flakey_c *fc = ti->private;
@@ -383,12 +463,16 @@ static int flakey_map(struct dm_target *
 		/*
 		 * Corrupt matching writes.
 		 */
-		if (fc->corrupt_bio_byte) {
-			if (fc->corrupt_bio_rw == WRITE) {
-				if (all_corrupt_bio_flags_match(bio, fc))
-					corrupt_bio_data(bio, fc);
-			}
-			goto map_bio;
+		if (fc->corrupt_bio_byte && fc->corrupt_bio_rw == WRITE) {
+			if (all_corrupt_bio_flags_match(bio, fc)) {
+				struct bio *clone = clone_bio(ti, fc, bio);
+				if (clone) {
+					corrupt_bio_data(clone, fc);
+					submit_bio(clone);
+					return DM_MAPIO_SUBMITTED;
+				}
+ 			}
+ 			goto map_bio;
 		}
 	}
 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

