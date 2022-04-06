Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1753DC433FE
	for <dm-devel@archiver.kernel.org>; Wed,  6 Apr 2022 06:13:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-pjh3DzxKOaaviFu-cRrcQQ-1; Wed, 06 Apr 2022 02:12:56 -0400
X-MC-Unique: pjh3DzxKOaaviFu-cRrcQQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64623811E78;
	Wed,  6 Apr 2022 06:12:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 506442166B26;
	Wed,  6 Apr 2022 06:12:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F28251947BBB;
	Wed,  6 Apr 2022 06:12:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D802519451F3
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Apr 2022 06:12:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BAEF6C26E9C; Wed,  6 Apr 2022 06:12:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B7459C15E71
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 06:12:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E00B85A5BC
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 06:12:53 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-308-1WfYpIVvOcaG3MiWF9gPrA-1; Wed, 06 Apr 2022 02:12:51 -0400
X-MC-Unique: 1WfYpIVvOcaG3MiWF9gPrA-1
Received: from 213-225-3-188.nat.highway.a1.net ([213.225.3.188]
 helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1nbyuI-003zMC-Aw; Wed, 06 Apr 2022 06:12:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  6 Apr 2022 08:12:26 +0200
Message-Id: <20220406061228.410163-4-hch@lst.de>
In-Reply-To: <20220406061228.410163-1-hch@lst.de>
References: <20220406061228.410163-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH 3/5] target/pscsi: remove pscsi_get_bio
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
Cc: linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
 Mike Snitzer <snitzer@redhat.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
 Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com, target-devel@vger.kernel.org,
 David Sterba <dsterba@suse.com>, Phillip Lougher <phillip@squashfs.org.uk>,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Remove pscsi_get_bio and simplify the code flow in the only caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/target/target_core_pscsi.c | 28 ++--------------------------
 1 file changed, 2 insertions(+), 26 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index ff292b75e23f9..77bd3af4b2bf8 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -821,23 +821,6 @@ static void pscsi_bi_endio(struct bio *bio)
 	bio_put(bio);
 }
 
-static inline struct bio *pscsi_get_bio(int nr_vecs)
-{
-	struct bio *bio;
-	/*
-	 * Use bio_malloc() following the comment in for bio -> struct request
-	 * in block/blk-core.c:blk_make_request()
-	 */
-	bio = bio_kmalloc(GFP_KERNEL, nr_vecs);
-	if (!bio) {
-		pr_err("PSCSI: bio_kmalloc() failed\n");
-		return NULL;
-	}
-	bio->bi_end_io = pscsi_bi_endio;
-
-	return bio;
-}
-
 static sense_reason_t
 pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		struct request *req)
@@ -878,12 +861,10 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 			if (!bio) {
 new_bio:
 				nr_vecs = bio_max_segs(nr_pages);
-				/*
-				 * Calls bio_kmalloc() and sets bio->bi_end_io()
-				 */
-				bio = pscsi_get_bio(nr_vecs);
+				bio = bio_kmalloc(GFP_KERNEL, nr_vecs);
 				if (!bio)
 					goto fail;
+				bio->bi_end_io = pscsi_bi_endio;
 
 				if (rw)
 					bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
@@ -912,11 +893,6 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 					goto fail;
 				}
 
-				/*
-				 * Clear the pointer so that another bio will
-				 * be allocated with pscsi_get_bio() above.
-				 */
-				bio = NULL;
 				goto new_bio;
 			}
 
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

