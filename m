Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06542C43219
	for <dm-devel@archiver.kernel.org>; Tue,  1 Mar 2022 08:46:22 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-328-E8FMgB93N4WaeK_0CROCmw-1; Tue, 01 Mar 2022 03:46:18 -0500
X-MC-Unique: E8FMgB93N4WaeK_0CROCmw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED9B01006AA6;
	Tue,  1 Mar 2022 08:46:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 80DAC5ED36;
	Tue,  1 Mar 2022 08:46:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6F5A84ED27;
	Tue,  1 Mar 2022 08:46:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2218k9fD028959 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Mar 2022 03:46:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CD3ECC50942; Tue,  1 Mar 2022 08:46:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C946CC50941
	for <dm-devel@redhat.com>; Tue,  1 Mar 2022 08:46:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF64138041C5
	for <dm-devel@redhat.com>; Tue,  1 Mar 2022 08:46:08 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-655-Xqe9H0opME2a1LdHDrl9ew-1; Tue, 01 Mar 2022 03:46:06 -0500
X-MC-Unique: Xqe9H0opME2a1LdHDrl9ew-1
Received: from [2.53.44.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nOy8x-00FfPs-7Z; Tue, 01 Mar 2022 08:46:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue,  1 Mar 2022 10:45:49 +0200
Message-Id: <20220301084552.880256-3-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
Cc: linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
	Mike Snitzer <snitzer@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	target-devel@vger.kernel.org, David Sterba <dsterba@suse.com>,
	Phillip Lougher <phillip@squashfs.org.uk>, linux-btrfs@vger.kernel.org
Subject: [dm-devel] [PATCH 2/5] squashfs: always use bio_kmalloc in
	squashfs_bio_read
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

If a plain kmalloc that is not backed by a mempool is safe here for a
large read (and the actual page allocations), it must also be for a
small one, so simplify the code a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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

