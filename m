Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7741BD038;
	Fri, 31 Jan 2025 12:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738326285; cv=none; b=nJoAf3GRTqSXIXtqKGGBI+3pg/1hVqawEZt7CMvVhfVzAbFbgNh3lFKlDfnYx4RfeOz8ip+1DuwMIifw4yWHjmEOnBepv8a3DAweGDB3hz7kImBE1WSQGcnlMU1uF/X1F8tpyaIVyC3mfbn52E851/LuH6aiXR/7u8PIAJ8TuNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738326285; c=relaxed/simple;
	bh=35W+or7RRv+OI7TszaLQelbgvXd3n/sycu8PZ40nDpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubC7eEDGY2JhC8rlvU9NEfT+rR3fb0hZ4Xr9bBibUkFAhFXw+NeUWK1P/mS+OpdtQ+oNPHzCihdh7XXqlwH4nvl18ks7JZGzM/elRFgXgoyv/GObVIdcLR14GQAqzxS3PzxiwS5nTPf3wUgfGX8T2KHeQ8kavFE6u0Pzj2TcPfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bZOxlrYG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bZOxlrYG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QoMptQMl4UhcTIqeDnDU4fWrwFKzVXlsxWnSCdt6BXQ=; b=bZOxlrYGe61Cnk9znd06Hp+Voh
	IMt3xynDXyaR3kINgQ/8yzCfvFZPpIqxUF5OIC5sfJzSLcoOc+pxV2zbdoS/9+4tO2sXKd8bop1Cr
	G3sVtIg6Tw6iN9E1MH9KcXIZSJxTd27rDWom4Z2aWnqBTroI2ipkU8RWpFYoB/NwUgsw2nYKXOsFi
	I8mkN1LvrK9p2Eql2RCKuN/pP9cJTZZCgPtNbTzZrLaB91cI12R3o0H8A2bPC8WuNfcjUBFYN1BXu
	eD22W86f8VnaNf8AaSaxEyfVyRKyvwBCFVuyYgS+vNxV5qcZA0ysJfIQdiZpiZhljB+jFqhAejNys
	o/AUQeoQ==;
Received: from 2a02-8389-2341-5b80-85a0-dd45-e939-a129.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:85a0:dd45:e939:a129] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tdq4f-0000000Ab1p-2DJK;
	Fri, 31 Jan 2025 12:24:42 +0000
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
	target-devel@vger.kernel.org
Subject: [PATCH 1/3] block: mark bounce buffering as incompatible with integrity
Date: Fri, 31 Jan 2025 13:24:16 +0100
Message-ID: <20250131122436.1317268-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250131122436.1317268-1-hch@lst.de>
References: <20250131122436.1317268-1-hch@lst.de>
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
---
 block/blk-settings.c | 5 +++++
 block/bounce.c       | 2 --
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index db12396ff5c7..83e9d71001bd 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -117,6 +117,11 @@ static int blk_validate_integrity_limits(struct queue_limits *lim)
 		return 0;
 	}
 
+	if (lim->features & BLK_FEAT_BOUNCE_HIGH) {
+		pr_warn("no bounce buffer support for integruty metadata\n");
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

