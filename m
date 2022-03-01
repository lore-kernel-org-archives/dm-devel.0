Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EE64C433FE
	for <dm-devel@archiver.kernel.org>; Tue,  1 Mar 2022 08:46:40 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-r8CLDyYFOGCQYnnkBfvwCw-1; Tue, 01 Mar 2022 03:46:35 -0500
X-MC-Unique: r8CLDyYFOGCQYnnkBfvwCw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C145521C;
	Tue,  1 Mar 2022 08:46:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E1451F43B;
	Tue,  1 Mar 2022 08:46:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 56FC21809CB2;
	Tue,  1 Mar 2022 08:46:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2218kTfX029028 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Mar 2022 03:46:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0EA7D53B3; Tue,  1 Mar 2022 08:46:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A81276EB
	for <dm-devel@redhat.com>; Tue,  1 Mar 2022 08:46:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B450238041D7
	for <dm-devel@redhat.com>; Tue,  1 Mar 2022 08:46:25 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-26-0_PiSuN5P_y3KSbJIYp0vw-1; Tue, 01 Mar 2022 03:46:24 -0500
X-MC-Unique: 0_PiSuN5P_y3KSbJIYp0vw-1
Received: from [2.53.44.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nOy99-00FfSF-3j; Tue, 01 Mar 2022 08:46:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue,  1 Mar 2022 10:45:52 +0200
Message-Id: <20220301084552.880256-6-hch@lst.de>
In-Reply-To: <20220301084552.880256-1-hch@lst.de>
References: <20220301084552.880256-1-hch@lst.de>
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
Cc: linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
	Mike Snitzer <snitzer@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	target-devel@vger.kernel.org, David Sterba <dsterba@suse.com>,
	Phillip Lougher <phillip@squashfs.org.uk>, linux-btrfs@vger.kernel.org
Subject: [dm-devel] [PATCH 5/5] pktcdvd: stop using bio_reset
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

Just initialize the bios on-demand.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/pktcdvd.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 6aec11ed185d8..e4ee7856483cf 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -525,7 +525,6 @@ static struct packet_data *pkt_alloc_packet_data(int frames)
 	pkt->w_bio = bio_kmalloc(frames, GFP_KERNEL);
 	if (!pkt->w_bio)
 		goto no_bio;
-	bio_init(pkt->w_bio, NULL, pkt->w_bio->bi_inline_vecs, frames, 0);
 
 	for (i = 0; i < frames / FRAMES_PER_PAGE; i++) {
 		pkt->pages[i] = alloc_page(GFP_KERNEL|__GFP_ZERO);
@@ -537,26 +536,20 @@ static struct packet_data *pkt_alloc_packet_data(int frames)
 	bio_list_init(&pkt->orig_bios);
 
 	for (i = 0; i < frames; i++) {
-		struct bio *bio = bio_kmalloc(1, GFP_KERNEL);
-		if (!bio)
+		pkt->r_bios[i] = bio_kmalloc(1, GFP_KERNEL);
+		if (!pkt->r_bios[i])
 			goto no_rd_bio;
-		bio_init(bio, NULL, bio->bi_inline_vecs, 1, 0);
-		pkt->r_bios[i] = bio;
 	}
 
 	return pkt;
 
 no_rd_bio:
-	for (i = 0; i < frames; i++) {
-		if (pkt->r_bios[i])
-			bio_uninit(pkt->r_bios[i]);
+	for (i = 0; i < frames; i++)
 		kfree(pkt->r_bios[i]);
-	}
 no_page:
 	for (i = 0; i < frames / FRAMES_PER_PAGE; i++)
 		if (pkt->pages[i])
 			__free_page(pkt->pages[i]);
-	bio_uninit(pkt->w_bio);
 	kfree(pkt->w_bio);
 no_bio:
 	kfree(pkt);
@@ -571,13 +564,10 @@ static void pkt_free_packet_data(struct packet_data *pkt)
 {
 	int i;
 
-	for (i = 0; i < pkt->frames; i++) {
-		bio_uninit(pkt->r_bios[i]);
+	for (i = 0; i < pkt->frames; i++)
 		kfree(pkt->r_bios[i]);
-	}
 	for (i = 0; i < pkt->frames / FRAMES_PER_PAGE; i++)
 		__free_page(pkt->pages[i]);
-	bio_uninit(pkt->w_bio);
 	kfree(pkt->w_bio);
 	kfree(pkt);
 }
@@ -950,6 +940,7 @@ static void pkt_end_io_read(struct bio *bio)
 
 	if (bio->bi_status)
 		atomic_inc(&pkt->io_errors);
+	bio_uninit(bio);
 	if (atomic_dec_and_test(&pkt->io_wait)) {
 		atomic_inc(&pkt->run_sm);
 		wake_up(&pd->wqueue);
@@ -967,6 +958,7 @@ static void pkt_end_io_packet_write(struct bio *bio)
 
 	pd->stats.pkt_ended++;
 
+	bio_uninit(bio);
 	pkt_bio_finished(pd);
 	atomic_dec(&pkt->io_wait);
 	atomic_inc(&pkt->run_sm);
@@ -1021,7 +1013,7 @@ static void pkt_gather_data(struct pktcdvd_device *pd, struct packet_data *pkt)
 			continue;
 
 		bio = pkt->r_bios[f];
-		bio_reset(bio, pd->bdev, REQ_OP_READ);
+		bio_init(bio, pd->bdev, bio->bi_inline_vecs, 1, REQ_OP_READ);
 		bio->bi_iter.bi_sector = pkt->sector + f * (CD_FRAMESIZE >> 9);
 		bio->bi_end_io = pkt_end_io_read;
 		bio->bi_private = pkt;
@@ -1234,7 +1226,8 @@ static void pkt_start_write(struct pktcdvd_device *pd, struct packet_data *pkt)
 {
 	int f;
 
-	bio_reset(pkt->w_bio, pd->bdev, REQ_OP_WRITE);
+	bio_init(pkt->w_bio, pd->bdev, pkt->w_bio->bi_inline_vecs, pkt->frames,
+		 REQ_OP_WRITE);
 	pkt->w_bio->bi_iter.bi_sector = pkt->sector;
 	pkt->w_bio->bi_end_io = pkt_end_io_packet_write;
 	pkt->w_bio->bi_private = pkt;
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

