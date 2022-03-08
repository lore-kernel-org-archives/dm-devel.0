Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F556C433F5
	for <dm-devel@archiver.kernel.org>; Tue,  8 Mar 2022 07:01:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-XrUJfg02Ohue7RON359yAQ-1; Tue, 08 Mar 2022 02:01:00 -0500
X-MC-Unique: XrUJfg02Ohue7RON359yAQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A782805F7C;
	Tue,  8 Mar 2022 07:00:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 481B1C08099;
	Tue,  8 Mar 2022 07:00:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1FE821931BEC;
	Tue,  8 Mar 2022 07:00:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C33CE194E109
 for <dm-devel@listman.corp.redhat.com>; Tue,  8 Mar 2022 07:00:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AF43640CFD24; Tue,  8 Mar 2022 07:00:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F9A040CFD12
 for <dm-devel@redhat.com>; Tue,  8 Mar 2022 07:00:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75FF73800E85
 for <dm-devel@redhat.com>; Tue,  8 Mar 2022 07:00:56 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-113-CaTMUT0YOnm4wPkHzDFulw-1; Tue, 08 Mar 2022 02:00:53 -0500
X-MC-Unique: CaTMUT0YOnm4wPkHzDFulw-1
Received: from [2001:4bb8:184:7746:6f50:7a98:3141:c37b] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1nRT8c-002lW2-Ag; Tue, 08 Mar 2022 06:16:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue,  8 Mar 2022 07:15:49 +0100
Message-Id: <20220308061551.737853-4-hch@lst.de>
In-Reply-To: <20220308061551.737853-1-hch@lst.de>
References: <20220308061551.737853-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
index 0fae71ac5cc8a..bd8ae07273f14 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -823,23 +823,6 @@ static void pscsi_bi_endio(struct bio *bio)
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
@@ -880,12 +863,10 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
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
@@ -914,11 +895,6 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
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

