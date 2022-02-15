Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA7CAC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 15 Feb 2022 11:00:14 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-281-XGPJkycsPMGVyUPtOkUchA-1; Tue, 15 Feb 2022 06:00:12 -0500
X-MC-Unique: XGPJkycsPMGVyUPtOkUchA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED62B1091DA2;
	Tue, 15 Feb 2022 11:00:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B99431086483;
	Tue, 15 Feb 2022 11:00:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4E1621809C88;
	Tue, 15 Feb 2022 11:00:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21FAxwO9014586 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Feb 2022 05:59:58 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EA7802166B4D; Tue, 15 Feb 2022 10:59:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E629A2166B2F
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 10:59:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C22F85A5A8
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 10:59:54 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-557-ua2CR371MeCqNFIBjIExqQ-1; Tue, 15 Feb 2022 05:59:52 -0500
X-MC-Unique: ua2CR371MeCqNFIBjIExqQ-1
Received: from [2001:4bb8:184:543c:6bdf:22f4:7f0a:fe97] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nJuia-002E73-9Y; Tue, 15 Feb 2022 10:05:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
Date: Tue, 15 Feb 2022 11:05:40 +0100
Message-Id: <20220215100540.3892965-6-hch@lst.de>
In-Reply-To: <20220215100540.3892965-1-hch@lst.de>
References: <20220215100540.3892965-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH 5/5] dm: remove dm_dispatch_clone_request
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Fold dm_dispatch_clone_request into it's only caller, and use a switch
statement to single dispatch for the handling of the different return
values from blk_insert_cloned_request.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-rq.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 8f6117342d322..6948d5db90925 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -303,17 +303,6 @@ static void end_clone_request(struct request *clone, blk_status_t error)
 	dm_complete_request(tio->orig, error);
 }
 
-static blk_status_t dm_dispatch_clone_request(struct request *clone, struct request *rq)
-{
-	blk_status_t r;
-
-	r = blk_insert_cloned_request(clone);
-	if (r != BLK_STS_OK && r != BLK_STS_RESOURCE && r != BLK_STS_DEV_RESOURCE)
-		/* must complete clone in terms of original request */
-		dm_complete_request(rq, r);
-	return r;
-}
-
 static int dm_rq_bio_constructor(struct bio *bio, struct bio *bio_orig,
 				 void *data)
 {
@@ -394,13 +383,20 @@ static int map_request(struct dm_rq_target_io *tio)
 		/* The target has remapped the I/O so dispatch it */
 		trace_block_rq_remap(clone, disk_devt(dm_disk(md)),
 				     blk_rq_pos(rq));
-		ret = dm_dispatch_clone_request(clone, rq);
-		if (ret == BLK_STS_RESOURCE || ret == BLK_STS_DEV_RESOURCE) {
+		ret = blk_insert_cloned_request(clone);
+		switch (ret) {
+		case BLK_STS_OK:
+			break;
+		case BLK_STS_RESOURCE:
+		case BLK_STS_DEV_RESOURCE:
 			blk_rq_unprep_clone(clone);
 			blk_mq_cleanup_rq(clone);
 			tio->ti->type->release_clone_rq(clone, &tio->info);
 			tio->clone = NULL;
 			return DM_MAPIO_REQUEUE;
+		default:
+			/* must complete clone in terms of original request */
+			dm_complete_request(rq, ret);
 		}
 		break;
 	case DM_MAPIO_REQUEUE:
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

