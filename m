Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03E02356AA;
	Tue, 18 Feb 2025 18:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739902938; cv=none; b=oO2B/T38dQoOiLrWu5kE0EHLLAHVT6MJbvv5TDrEuNCENIZHr6qwpu3zHvHqUqoX/cCZZ8N4iZphRI7E0D1jW53AEm7NiKIJvno1/xayBkDLHeCANYoXnSL+fEUHCo3m10CGGK0MlAlIcwAK0/IvDX4mz8MggGg2vjs75p03aWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739902938; c=relaxed/simple;
	bh=4MfHtqBWbgQLJTl4bu2ACTjodT+jGskOI9VYAOuRxBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A53IghPBEkCjGU5h/RF79BFNKOSXHMu0qItTCoLhEK/47XpDiZhUEAsVCmJ5p5I9HOsAahfBZ8shxbWplFi6Vh3KZ0i9cGCndJkPBXSfwTi6QP/UUUMKN1dqUm8Y9a/ijdf6XYyjqxhW8goMkeRX8a2eJt/6FdnvkOpyUNJ88io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Bayi6dW5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Bayi6dW5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=59blbwT0DViS586kEgOSRoSlITfONEreTX314PUT9z4=; b=Bayi6dW5rVKJMk0OOpWYOcCJfy
	43/9YDna8awuiIWgjvQc77ZaOUTFOSVUySy8Bq0xt7nM2jaNvtvvurjSP7998o0gYI+JIOPUbM8a3
	7Y8sXLWSmtw8tTKspt76P1b1ditg/SQFW59btO/RPN94l4Gl7m2bMVXjD8nXZK0aLs9FLGXaBxCM4
	qIfQEN61lKnXkh9WSvmvjQouLMWIzDR4Mg4EN6jUzch0kTuZ36S6cP+2K25ntQCQextB/NGdVtJeZ
	65CHsnk9XmKUace1b1aoEZT7er4QkFOdS0v5TRe2i0Y8+eVuejiFxI0D9K4/ujcA3aPrTIbXqEeBZ
	XteFRZbA==;
Received: from 2a02-8389-2341-5b80-8ced-6946-2068-0fcd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8ced:6946:2068:fcd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkSEX-00000009KG9-2NPP;
	Tue, 18 Feb 2025 18:22:14 +0000
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
Date: Tue, 18 Feb 2025 19:21:56 +0100
Message-ID: <20250218182207.3982214-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250218182207.3982214-1-hch@lst.de>
References: <20250218182207.3982214-1-hch@lst.de>
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
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
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

