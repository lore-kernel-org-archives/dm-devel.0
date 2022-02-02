Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C14C8C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  2 Feb 2022 16:01:57 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-1Ct4AsiWOW28dy_nj_0ZpQ-1; Wed, 02 Feb 2022 11:01:51 -0500
X-MC-Unique: 1Ct4AsiWOW28dy_nj_0ZpQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9310F61197;
	Wed,  2 Feb 2022 16:01:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6EC362377E;
	Wed,  2 Feb 2022 16:01:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 138931806D2C;
	Wed,  2 Feb 2022 16:01:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 212G1VNi018669 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Feb 2022 11:01:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4FFA040885B8; Wed,  2 Feb 2022 16:01:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BC2440885B5
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 16:01:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3267B811E80
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 16:01:31 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-549-RIlgC_k0Mpykj4wYQyTkdQ-1; Wed, 02 Feb 2022 11:01:29 -0500
X-MC-Unique: RIlgC_k0Mpykj4wYQyTkdQ-1
Received: from [2001:4bb8:191:327d:b3e5:1ccd:eaac:6609] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nFI4S-00G81a-UW; Wed, 02 Feb 2022 16:01:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  2 Feb 2022 17:01:01 +0100
Message-Id: <20220202160109.108149-6-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Pavel Begunkov <asml.silence@gmail.com>, drbd-dev@lists.linbit.com
Subject: [dm-devel] [PATCH 05/13] dm: move cloning the bio into alloc_tio
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

Move the call to __bio_clone_fast and the assignment of ->len_ptr from
the callers into alloc_tio to prepare for changes to the bio clone API.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2527b287ead0f..90341b7fa5809 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -545,7 +545,7 @@ static void free_io(struct mapped_device *md, struct dm_io *io)
 }
 
 static struct dm_target_io *alloc_tio(struct clone_info *ci, struct dm_target *ti,
-				      unsigned target_bio_nr, gfp_t gfp_mask)
+		unsigned target_bio_nr, unsigned *len, gfp_t gfp_mask)
 {
 	struct dm_target_io *tio;
 
@@ -561,11 +561,13 @@ static struct dm_target_io *alloc_tio(struct clone_info *ci, struct dm_target *t
 		tio = clone_to_tio(clone);
 		tio->inside_dm_io = false;
 	}
+	__bio_clone_fast(&tio->clone, ci->bio);
 
 	tio->magic = DM_TIO_MAGIC;
 	tio->io = ci->io;
 	tio->ti = ti;
 	tio->target_bio_nr = target_bio_nr;
+	tio->len_ptr = len;
 
 	return tio;
 }
@@ -1197,11 +1199,8 @@ static int __clone_and_map_data_bio(struct clone_info *ci, struct dm_target *ti,
 	struct dm_target_io *tio;
 	int r;
 
-	tio = alloc_tio(ci, ti, 0, GFP_NOIO);
-	tio->len_ptr = len;
-
+	tio = alloc_tio(ci, ti, 0, len, GFP_NOIO);
 	clone = &tio->clone;
-	__bio_clone_fast(clone, bio);
 
 	r = bio_crypt_clone(clone, bio, GFP_NOIO);
 	if (r < 0)
@@ -1236,7 +1235,8 @@ static int __clone_and_map_data_bio(struct clone_info *ci, struct dm_target *ti,
 }
 
 static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
-				struct dm_target *ti, unsigned num_bios)
+				struct dm_target *ti, unsigned num_bios,
+				unsigned *len)
 {
 	struct dm_target_io *tio;
 	int try;
@@ -1245,7 +1245,7 @@ static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
 		return;
 
 	if (num_bios == 1) {
-		tio = alloc_tio(ci, ti, 0, GFP_NOIO);
+		tio = alloc_tio(ci, ti, 0, len, GFP_NOIO);
 		bio_list_add(blist, &tio->clone);
 		return;
 	}
@@ -1257,7 +1257,8 @@ static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
 		if (try)
 			mutex_lock(&ci->io->md->table_devices_lock);
 		for (bio_nr = 0; bio_nr < num_bios; bio_nr++) {
-			tio = alloc_tio(ci, ti, bio_nr, try ? GFP_NOIO : GFP_NOWAIT);
+			tio = alloc_tio(ci, ti, bio_nr, len,
+					try ? GFP_NOIO : GFP_NOWAIT);
 			if (!tio)
 				break;
 
@@ -1279,14 +1280,11 @@ static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
 	struct bio_list blist = BIO_EMPTY_LIST;
 	struct bio *clone;
 
-	alloc_multiple_bios(&blist, ci, ti, num_bios);
+	alloc_multiple_bios(&blist, ci, ti, num_bios, len);
 
 	while ((clone = bio_list_pop(&blist))) {
 		struct dm_target_io *tio = clone_to_tio(clone);
 
-		tio->len_ptr = len;
-
-		__bio_clone_fast(clone, ci->bio);
 		if (len)
 			bio_setup_sector(clone, ci->sector, *len);
 		__map_bio(tio);
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

