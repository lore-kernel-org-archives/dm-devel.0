Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB1D27701;
	Tue, 25 Feb 2025 15:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740498296; cv=none; b=TV1yiLWZycB42Hpzvchg2ex3xveOZV13iP9ox8wmURorEZWoPz/zv9pBoqsUET+z8DlxruCByIqdK+s7OWC7jwRgVq25W1e9/NbKlWLXjoRMyfylNMxkTW/w6qm5YXwVBMQwLocJz1Bi9AB887fVtgBaR2kKZVoNcvqIty9sEHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740498296; c=relaxed/simple;
	bh=71K0j8Ci1afwiIgNqWfpyYmwZxlbm2XgMUAdLFyv0GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJiEVYCTzV1Y/Db0d+5HWAU64SSzX65GjmopLCVuMkqQjiHNGsaDCANpMvYuUfYmTkUSZe3dtkWUS+FlqduMOzmauXHnL4cvYx1Q3wxiL40tYNRGBDh7oxocrTDIAc2Q9D4rAfDIG/BDkUWeIc/yGkBBCMhY1+0nPFej3t/MMYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BMuO29K4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BMuO29K4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dsYTqNn9ziVuLY+wxCpZw4esC9gTCv/X+7OLCVPr2CY=; b=BMuO29K4s0y7XW80aITLBqdwFo
	nxNoB1hk6oBIBdbxP5ebn8QTYuz7U2jcQ6zfMsE0xVT6/9PLH//z/urtJzkmnFxNhpexzzdtwK8UU
	TkLV7dXWzEehQizkUDHiTCye3KYrMRPgfqzvngTpskQEWFIPXw7T+5pS/ldJf5FIQ4PLEC3P5tzM4
	R9BLv0a50hNHmVao12G3g3x0pVGtoWrcJbl4t9JtAj0pfUqgc6TTFP1ivxm8paXBF0TsNkkw8ZkmO
	dRM+f+e4mwjy5FBTvCsvB4mrE9JWwodwpUcZXSLr4s2gYcM3lK/EyuVoBuMTiX8fVD+LIodS2zDfE
	23VVl/TA==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tmx73-000000006hw-3iXG;
	Tue, 25 Feb 2025 15:44:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	target-devel@vger.kernel.org,
	Anuj Gupta <anuj20.g@samsung.com>,
	Hannes Reinecke <hare@suse.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 1/3] block: mark bounce buffering as incompatible with integrity
Date: Tue, 25 Feb 2025 07:44:31 -0800
Message-ID: <20250225154449.422989-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250225154449.422989-1-hch@lst.de>
References: <20250225154449.422989-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

None of the few drivers still using the legacy block layer bounce
buffering support integrity metadata.  Explicitly mark the features as
incompatible and stop creating the slab and mempool for integrity
buffers for the bounce bio_set.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 block/blk-settings.c | 5 +++++
 block/bounce.c       | 2 --
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index c44dadc35e1e..2763a34a9d56 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -117,6 +117,11 @@ static int blk_validate_integrity_limits(struct queue_limits *lim)
 		return 0;
 	}
 
+	if (lim->features & BLK_FEAT_BOUNCE_HIGH) {
+		pr_warn("no bounce buffer support for integrity metadata\n");
+		return -EINVAL;
+	}
+
 	if (!IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY)) {
 		pr_warn("integrity support disabled.\n");
 		return -EINVAL;
diff --git a/block/bounce.c b/block/bounce.c
index 0d898cd5ec49..09a9616cf209 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -41,8 +41,6 @@ static void init_bounce_bioset(void)
 
 	ret = bioset_init(&bounce_bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
 	BUG_ON(ret);
-	if (bioset_integrity_create(&bounce_bio_set, BIO_POOL_SIZE))
-		BUG_ON(1);
 
 	ret = bioset_init(&bounce_bio_split, BIO_POOL_SIZE, 0, 0);
 	BUG_ON(ret);
-- 
2.45.2

