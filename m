Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3A5BC433EF
	for <dm-devel@archiver.kernel.org>; Tue,  8 Mar 2022 07:03:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-C4y8eGkxOyeZvP7xhlPk9A-1; Tue, 08 Mar 2022 02:03:23 -0500
X-MC-Unique: C4y8eGkxOyeZvP7xhlPk9A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 652F9811E78;
	Tue,  8 Mar 2022 07:03:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0DB6B40D2823;
	Tue,  8 Mar 2022 07:03:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B57971931BEC;
	Tue,  8 Mar 2022 07:03:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A9EA0194E109
 for <dm-devel@listman.corp.redhat.com>; Tue,  8 Mar 2022 07:03:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 52D9C400E43E; Tue,  8 Mar 2022 07:03:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4EDCF400E43D
 for <dm-devel@redhat.com>; Tue,  8 Mar 2022 07:03:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 360C7101AA48
 for <dm-devel@redhat.com>; Tue,  8 Mar 2022 07:03:19 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-225-3EIwaCMOObO-PtaXu-gAog-1; Tue, 08 Mar 2022 02:03:15 -0500
X-MC-Unique: 3EIwaCMOObO-PtaXu-gAog-1
Received: from [2001:4bb8:184:7746:6f50:7a98:3141:c37b] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1nRT8Z-002lVi-IG; Tue, 08 Mar 2022 06:16:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue,  8 Mar 2022 07:15:48 +0100
Message-Id: <20220308061551.737853-3-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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

