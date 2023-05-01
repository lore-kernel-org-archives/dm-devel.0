Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D90AC77B61
	for <dm-devel@archiver.kernel.org>; Mon,  1 May 2023 13:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682947192;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pUGq7EpK9Ua6wILIyOGLMURnMsIruqJ7tb0+48iqf8s=;
	b=Qx9KNNWF8jHiAoUqsJjERez6nL7ZrJkBWjdr0rzdxyPcqrdrXvTvY9JTWm+4Kv5xtIlVLK
	GqudkMo0iBdsEmZDybS8URRlb0jfu+LlijVqmjdF35hnZ/KguT4cgq0JdxLCbaCUYXKHql
	ADqv7gnj/umsHfWQ8WP71zhUnAYkEu8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-k5_pyuwNNbisq4pCXYfwrA-1; Mon, 01 May 2023 09:19:49 -0400
X-MC-Unique: k5_pyuwNNbisq4pCXYfwrA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BBDA01C08787;
	Mon,  1 May 2023 13:19:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AAAAF40C6E69;
	Mon,  1 May 2023 13:19:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9418C1946589;
	Mon,  1 May 2023 13:19:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 090ED1946587
 for <dm-devel@listman.corp.redhat.com>; Mon,  1 May 2023 13:19:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EB3932166B2B; Mon,  1 May 2023 13:19:45 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DBC812166B29;
 Mon,  1 May 2023 13:19:45 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 341DJj32009214; Mon, 1 May 2023 09:19:45 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 341DJjtZ009210; Mon, 1 May 2023 09:19:45 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Mon, 1 May 2023 09:19:45 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Message-ID: <alpine.LRH.2.21.2305010919200.8207@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH 2/3] dm flakey: clone pages on write bio before
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-flakey.c |  108 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 97 insertions(+), 11 deletions(-)

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
@@ -340,6 +336,92 @@ static void corrupt_bio_data(struct bio
 	}
 }
 
+static void clone_free(struct bio *clone)
+{
+	struct folio_iter fi;
+
+	if (clone->bi_vcnt > 0) { /* bio_for_each_folio_all crashes with an empty bio */
+		bio_for_each_folio_all(fi, clone)
+			folio_put(fi.folio);
+	}
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
@@ -383,12 +465,16 @@ static int flakey_map(struct dm_target *
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

