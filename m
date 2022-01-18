Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A72D5C43217
	for <dm-devel@archiver.kernel.org>; Tue, 18 Jan 2022 07:20:25 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-bQa6hwsFNrC6cHBWr-qakA-1; Tue, 18 Jan 2022 02:20:20 -0500
X-MC-Unique: bQa6hwsFNrC6cHBWr-qakA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8434F81E20A;
	Tue, 18 Jan 2022 07:20:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C8196E1EA;
	Tue, 18 Jan 2022 07:20:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 763794CA9B;
	Tue, 18 Jan 2022 07:20:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20I7KAoR012899 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 18 Jan 2022 02:20:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B8E93400E10D; Tue, 18 Jan 2022 07:20:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B506740E4308
	for <dm-devel@redhat.com>; Tue, 18 Jan 2022 07:20:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D1873C1D8BC
	for <dm-devel@redhat.com>; Tue, 18 Jan 2022 07:20:10 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-571-Tp706S54MK6D6oFyebv3bA-1; Tue, 18 Jan 2022 02:20:08 -0500
X-MC-Unique: Tp706S54MK6D6oFyebv3bA-1
Received: from [2001:4bb8:184:72a4:a4a9:19c0:5242:7768] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1n9imk-000ZPF-0i; Tue, 18 Jan 2022 07:20:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue, 18 Jan 2022 08:19:37 +0100
Message-Id: <20220118071952.1243143-5-hch@lst.de>
In-Reply-To: <20220118071952.1243143-1-hch@lst.de>
References: <20220118071952.1243143-1-hch@lst.de>
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
Cc: linux-block@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-nilfs@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.co>,
	dm-devel@redhat.com, "Md . Haris Iqbal " <haris.iqbal@ionos.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	linux-fsdevel@vger.kernel.org, xen-devel@lists.xenproject.org,
	Andrew Morton <akpm@linux-foundation.org>, ntfs3@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>, Pavel Begunkov <asml.silence@gmail.com>,
	drbd-dev@lists.linbit.com
Subject: [dm-devel] [PATCH 04/19] ntfs3: remove ntfs_alloc_bio
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

bio_alloc will never fail if it is allowed to sleep, so there is no
need for this loop.  Also remove the __GFP_HIGH specifier as it doesn't
make sense here given that we'll always fall back to the mempool anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ntfs3/fsntfs.c | 23 ++---------------------
 1 file changed, 2 insertions(+), 21 deletions(-)

diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index 4de9acb169689..4a255e21ecf5f 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -1443,17 +1443,6 @@ int ntfs_write_bh(struct ntfs_sb_info *sbi, struct NTFS_RECORD_HEADER *rhdr,
 	return err;
 }
 
-static inline struct bio *ntfs_alloc_bio(u32 nr_vecs)
-{
-	struct bio *bio = bio_alloc(GFP_NOFS | __GFP_HIGH, nr_vecs);
-
-	if (!bio && (current->flags & PF_MEMALLOC)) {
-		while (!bio && (nr_vecs /= 2))
-			bio = bio_alloc(GFP_NOFS | __GFP_HIGH, nr_vecs);
-	}
-	return bio;
-}
-
 /*
  * ntfs_bio_pages - Read/write pages from/to disk.
  */
@@ -1496,11 +1485,7 @@ int ntfs_bio_pages(struct ntfs_sb_info *sbi, const struct runs_tree *run,
 		lbo = ((u64)lcn << cluster_bits) + off;
 		len = ((u64)clen << cluster_bits) - off;
 new_bio:
-		new = ntfs_alloc_bio(nr_pages - page_idx);
-		if (!new) {
-			err = -ENOMEM;
-			goto out;
-		}
+		new = bio_alloc(GFP_NOFS, nr_pages - page_idx);
 		if (bio) {
 			bio_chain(bio, new);
 			submit_bio(bio);
@@ -1599,11 +1584,7 @@ int ntfs_bio_fill_1(struct ntfs_sb_info *sbi, const struct runs_tree *run)
 		lbo = (u64)lcn << cluster_bits;
 		len = (u64)clen << cluster_bits;
 new_bio:
-		new = ntfs_alloc_bio(BIO_MAX_VECS);
-		if (!new) {
-			err = -ENOMEM;
-			break;
-		}
+		new = bio_alloc(GFP_NOFS, BIO_MAX_VECS);
 		if (bio) {
 			bio_chain(bio, new);
 			submit_bio(bio);
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

