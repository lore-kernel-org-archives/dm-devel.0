Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9D90C4332F
	for <dm-devel@archiver.kernel.org>; Wed,  2 Feb 2022 16:01:51 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-260-ni43XARpOG6pHC2T26aEnQ-1; Wed, 02 Feb 2022 11:01:49 -0500
X-MC-Unique: ni43XARpOG6pHC2T26aEnQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A81D51091DB3;
	Wed,  2 Feb 2022 16:01:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A77826573;
	Wed,  2 Feb 2022 16:01:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4DC3B4CA93;
	Wed,  2 Feb 2022 16:01:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 212G1RQe018657 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Feb 2022 11:01:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2EA1714582F5; Wed,  2 Feb 2022 16:01:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AE0514582F2
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 16:01:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10FB81078464
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 16:01:27 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-259-g7jPxMGAMTq3tZP28dznrw-1; Wed, 02 Feb 2022 11:01:25 -0500
X-MC-Unique: g7jPxMGAMTq3tZP28dznrw-1
Received: from [2001:4bb8:191:327d:b3e5:1ccd:eaac:6609] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nFI4Q-00G80Z-AJ; Wed, 02 Feb 2022 16:01:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  2 Feb 2022 17:01:00 +0100
Message-Id: <20220202160109.108149-5-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Pavel Begunkov <asml.silence@gmail.com>, drbd-dev@lists.linbit.com
Subject: [dm-devel] [PATCH 04/13] dm: fold __send_duplicate_bios into
	__clone_and_map_simple_bio
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

Fold __send_duplicate_bios into its only caller to prepare for
refactoring.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9384d250a3e4e..2527b287ead0f 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1273,29 +1273,24 @@ static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
 	}
 }
 
-static void __clone_and_map_simple_bio(struct clone_info *ci,
-					   struct dm_target_io *tio, unsigned *len)
-{
-	struct bio *clone = &tio->clone;
-
-	tio->len_ptr = len;
-
-	__bio_clone_fast(clone, ci->bio);
-	if (len)
-		bio_setup_sector(clone, ci->sector, *len);
-	__map_bio(tio);
-}
-
 static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
 				  unsigned num_bios, unsigned *len)
 {
 	struct bio_list blist = BIO_EMPTY_LIST;
-	struct bio *bio;
+	struct bio *clone;
 
 	alloc_multiple_bios(&blist, ci, ti, num_bios);
 
-	while ((bio = bio_list_pop(&blist)))
-		__clone_and_map_simple_bio(ci, clone_to_tio(bio), len);
+	while ((clone = bio_list_pop(&blist))) {
+		struct dm_target_io *tio = clone_to_tio(clone);
+
+		tio->len_ptr = len;
+
+		__bio_clone_fast(clone, ci->bio);
+		if (len)
+			bio_setup_sector(clone, ci->sector, *len);
+		__map_bio(tio);
+	}
 }
 
 static int __send_empty_flush(struct clone_info *ci)
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

