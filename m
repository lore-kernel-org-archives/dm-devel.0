Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB786C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Apr 2022 06:12:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-157-85kEtOAuPTejroAfQK_mJg-1; Wed, 06 Apr 2022 02:12:52 -0400
X-MC-Unique: 85kEtOAuPTejroAfQK_mJg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50726811E78;
	Wed,  6 Apr 2022 06:12:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3EFBA40CF905;
	Wed,  6 Apr 2022 06:12:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EE2631947BBB;
	Wed,  6 Apr 2022 06:12:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 43B721940372
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Apr 2022 06:12:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 246EB2166B2F; Wed,  6 Apr 2022 06:12:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2014A2166B41
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 06:12:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63F733803509
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 06:12:45 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-248-EAMdJcLJMvaKfdtEUKd4Ew-1; Wed, 06 Apr 2022 02:12:42 -0400
X-MC-Unique: EAMdJcLJMvaKfdtEUKd4Ew-1
Received: from 213-225-3-188.nat.highway.a1.net ([213.225.3.188]
 helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1nbyuE-003zKG-M9; Wed, 06 Apr 2022 06:12:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  6 Apr 2022 08:12:25 +0200
Message-Id: <20220406061228.410163-3-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: [dm-devel] [PATCH 2/5] squashfs: always use bio_kmalloc in
 squashfs_bio_read
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If a plain kmalloc that is not backed by a mempool is safe here for a
large read (and the actual page allocations), it must also be for a
small one, so simplify the code a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Phillip Lougher <phillip@squashfs.org.uk>
---
 fs/squashfs/block.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index 622c844f6d118..4311a32218928 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -86,16 +86,11 @@ static int squashfs_bio_read(struct super_block *sb, u64 index, int length,
 	int error, i;
 	struct bio *bio;
 
-	if (page_count <= BIO_MAX_VECS) {
-		bio = bio_alloc(sb->s_bdev, page_count, REQ_OP_READ, GFP_NOIO);
-	} else {
-		bio = bio_kmalloc(GFP_NOIO, page_count);
-		bio_set_dev(bio, sb->s_bdev);
-		bio->bi_opf = REQ_OP_READ;
-	}
-
+	bio = bio_kmalloc(GFP_NOIO, page_count);
 	if (!bio)
 		return -ENOMEM;
+	bio_set_dev(bio, sb->s_bdev);
+	bio->bi_opf = REQ_OP_READ;
 
 	bio->bi_iter.bi_sector = block * (msblk->devblksize >> SECTOR_SHIFT);
 
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

