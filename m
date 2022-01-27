Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 835F2C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jan 2022 07:05:32 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-335-WUhRHrhoNwKbFAfOjoiyRg-1; Thu, 27 Jan 2022 02:05:27 -0500
X-MC-Unique: WUhRHrhoNwKbFAfOjoiyRg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 626B384DA44;
	Thu, 27 Jan 2022 07:05:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 365FC607A9;
	Thu, 27 Jan 2022 07:05:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C4CC41809CB8;
	Thu, 27 Jan 2022 07:05:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20R75LNu002364 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 27 Jan 2022 02:05:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F1F3D2026609; Thu, 27 Jan 2022 07:05:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EDAB720268FE
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 07:05:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FA991C05AF3
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 07:05:17 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-46-YqeT-bHePvS5XuYoN97X_Q-1; Thu, 27 Jan 2022 02:05:13 -0500
X-MC-Unique: YqeT-bHePvS5XuYoN97X_Q-1
Received: from 213-225-10-69.nat.highway.a1.net ([213.225.10.69]
	helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nCyOF-00EY94-6F; Thu, 27 Jan 2022 06:36:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Thu, 27 Jan 2022 07:35:39 +0100
Message-Id: <20220127063546.1314111-8-hch@lst.de>
In-Reply-To: <20220127063546.1314111-1-hch@lst.de>
References: <20220127063546.1314111-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Pavel Begunkov <asml.silence@gmail.com>, drbd-dev@lists.linbit.com
Subject: [dm-devel] [PATCH 07/14] dm: retun the clone bio from alloc_tio
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Return the clone bio embedded into the tio as that is what the callers
actually want.  Similar for the free side.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7cc477b2b77e9..030270b770eb0 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -544,7 +544,7 @@ static void free_io(struct mapped_device *md, struct dm_io *io)
 	bio_put(&io->tio.clone);
 }
 
-static struct dm_target_io *alloc_tio(struct clone_info *ci, struct dm_target *ti,
+static struct bio *alloc_tio(struct clone_info *ci, struct dm_target *ti,
 		unsigned target_bio_nr, unsigned *len, gfp_t gfp_mask)
 {
 	struct dm_target_io *tio;
@@ -569,14 +569,14 @@ static struct dm_target_io *alloc_tio(struct clone_info *ci, struct dm_target *t
 	tio->target_bio_nr = target_bio_nr;
 	tio->len_ptr = len;
 
-	return tio;
+	return &tio->clone;
 }
 
-static void free_tio(struct dm_target_io *tio)
+static void free_tio(struct bio *clone)
 {
-	if (tio->inside_dm_io)
+	if (clone_to_tio(clone)->inside_dm_io)
 		return;
-	bio_put(&tio->clone);
+	bio_put(clone);
 }
 
 /*
@@ -932,7 +932,7 @@ static void clone_endio(struct bio *bio)
 		up(&md->swap_bios_semaphore);
 	}
 
-	free_tio(tio);
+	free_tio(bio);
 	dm_io_dec_pending(io, error);
 }
 
@@ -1166,7 +1166,7 @@ static void __map_bio(struct bio *clone)
 			struct mapped_device *md = io->md;
 			up(&md->swap_bios_semaphore);
 		}
-		free_tio(tio);
+		free_tio(clone);
 		dm_io_dec_pending(io, BLK_STS_IOERR);
 		break;
 	case DM_MAPIO_REQUEUE:
@@ -1174,7 +1174,7 @@ static void __map_bio(struct bio *clone)
 			struct mapped_device *md = io->md;
 			up(&md->swap_bios_semaphore);
 		}
-		free_tio(tio);
+		free_tio(clone);
 		dm_io_dec_pending(io, BLK_STS_DM_REQUEUE);
 		break;
 	default:
@@ -1196,17 +1196,17 @@ static int __clone_and_map_data_bio(struct clone_info *ci, struct dm_target *ti,
 				    sector_t sector, unsigned *len)
 {
 	struct bio *bio = ci->bio, *clone;
-	struct dm_target_io *tio;
 	int r;
 
-	tio = alloc_tio(ci, ti, 0, len, GFP_NOIO);
-	clone = &tio->clone;
+	clone = alloc_tio(ci, ti, 0, len, GFP_NOIO);
 
 	r = bio_crypt_clone(clone, bio, GFP_NOIO);
 	if (r < 0)
 		goto free_tio;
 
 	if (bio_integrity(bio)) {
+		struct dm_target_io *tio = clone_to_tio(clone);
+
 		if (unlikely(!dm_target_has_integrity(tio->ti->type) &&
 			     !dm_target_passes_integrity(tio->ti->type))) {
 			DMWARN("%s: the target %s doesn't support integrity data.",
@@ -1230,7 +1230,7 @@ static int __clone_and_map_data_bio(struct clone_info *ci, struct dm_target *ti,
 	__map_bio(clone);
 	return 0;
 free_tio:
-	free_tio(tio);
+	free_tio(clone);
 	return r;
 }
 
@@ -1238,31 +1238,30 @@ static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
 				struct dm_target *ti, unsigned num_bios,
 				unsigned *len)
 {
-	struct dm_target_io *tio;
+	struct bio *bio;
 	int try;
 
 	if (!num_bios)
 		return;
 
 	if (num_bios == 1) {
-		tio = alloc_tio(ci, ti, 0, len, GFP_NOIO);
-		bio_list_add(blist, &tio->clone);
+		bio = alloc_tio(ci, ti, 0, len, GFP_NOIO);
+		bio_list_add(blist, bio);
 		return;
 	}
 
 	for (try = 0; try < 2; try++) {
 		int bio_nr;
-		struct bio *bio;
 
 		if (try)
 			mutex_lock(&ci->io->md->table_devices_lock);
 		for (bio_nr = 0; bio_nr < num_bios; bio_nr++) {
-			tio = alloc_tio(ci, ti, bio_nr, len,
+			bio = alloc_tio(ci, ti, bio_nr, len,
 					try ? GFP_NOIO : GFP_NOWAIT);
-			if (!tio)
+			if (!bio)
 				break;
 
-			bio_list_add(blist, &tio->clone);
+			bio_list_add(blist, bio);
 		}
 		if (try)
 			mutex_unlock(&ci->io->md->table_devices_lock);
@@ -1270,7 +1269,7 @@ static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
 			return;
 
 		while ((bio = bio_list_pop(blist)))
-			free_tio(clone_to_tio(bio));
+			free_tio(bio);
 	}
 }
 
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

