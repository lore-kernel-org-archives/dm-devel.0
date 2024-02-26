Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C23C2AD11;
	Mon, 26 Feb 2024 10:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708943418; cv=none; b=tqczVISsnwMjMgstGNx7S5PAqt84eYHZxiYNdx5zOWNr4wB9hXu/Acbe2XHT00OaiZFv+Ho+QIttipeBvLNP662M0mk9NqKt24MlMv7KrXu4qbRRyyukVXD7kXseRLUoFRqoIESAnfT7GlWqW3LaJpw98dF4tb6hK6GAnC1bsAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708943418; c=relaxed/simple;
	bh=Yr884w3gRhIkUcrkO7iPb9alAoxqN1T7r99JPoCCW48=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gsX+ApDTu9KG0rrRiTFBgreIqsRxsT91wojqUAt/PeUZPTWY6Fs5hdO5IasBkPTwVTIgXHJHOprOa8o2F5zleNolRZq0cTNWJ6Ihj0ZXHoVKqmIoIWlKObcrjIMpbZKN6i0p3VM05MnaGlAauVX+CbhweCCCMvaOBDqh4uiZzXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RZa2ho0x; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RZa2ho0x"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Vp6cPOGmx7IsY/Gom3ohdEDfNj/bokcwTvb4p5mmNMM=; b=RZa2ho0xmyB83IqBMMG7w6lFMr
	HtfiLLrvvGgbYnKWkZpXYEaSmK+/vQgubvBp20GbBCMb7+L9axatX4gh6CsP3Kqqp8/vZPdQ4jRJk
	4mFexpbZw6bT1T7vmTtZAMOehB7tJW33X7IN3ix8rPFkD9vbTrNtU6402Wf2oyq7BbnVe0gm1Okxz
	mt6Kz4zaPNdwixYoqM8GkO8JpnvqHGbihGFTTNRaXH8wqQmfTs/CeH4Np7VWn/IlcFAk3BYrDLIAz
	2vPbE4qIf8u1/o45E42l4WuJv6c4VC90kbTE0lYo1Y+kQ7JA+kCClVBZ4j8UawmS8Q2JDJHY5mC7O
	DhD8nqUg==;
Received: from 213-147-167-65.nat.highway.webapn.at ([213.147.167.65] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reYFR-000000004Xt-2kh7;
	Mon, 26 Feb 2024 10:30:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>
Cc: drbd-dev@lists.linbit.com,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 01/16] block: add a queue_limits_set helper
Date: Mon, 26 Feb 2024 11:29:49 +0100
Message-Id: <20240226103004.281412-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240226103004.281412-1-hch@lst.de>
References: <20240226103004.281412-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a small wrapper around queue_limits_commit_update for stacking
drivers that don't want to update existing limits, but set an
entirely new set.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-settings.c   | 18 ++++++++++++++++++
 include/linux/blkdev.h |  1 +
 2 files changed, 19 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index b6bbe683d218fa..1989a177be201b 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -266,6 +266,24 @@ int queue_limits_commit_update(struct request_queue *q,
 }
 EXPORT_SYMBOL_GPL(queue_limits_commit_update);
 
+/**
+ * queue_limits_commit_set - apply queue limits to queue
+ * @q:		queue to update
+ * @lim:	limits to apply
+ *
+ * Apply the limits in @lim that were freshly initialized to @q.
+ * To update existing limits use queue_limits_start_update() and
+ * queue_limits_commit_update() instead.
+ *
+ * Returns 0 if successful, else a negative error code.
+ */
+int queue_limits_set(struct request_queue *q, struct queue_limits *lim)
+{
+	mutex_lock(&q->limits_lock);
+	return queue_limits_commit_update(q, lim);
+}
+EXPORT_SYMBOL_GPL(queue_limits_set);
+
 /**
  * blk_queue_bounce_limit - set bounce buffer limit for queue
  * @q: the request queue for the device
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index a14ea934413850..dd510ad7ce4b45 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -889,6 +889,7 @@ queue_limits_start_update(struct request_queue *q)
 }
 int queue_limits_commit_update(struct request_queue *q,
 		struct queue_limits *lim);
+int queue_limits_set(struct request_queue *q, struct queue_limits *lim);
 
 /*
  * Access functions for manipulating queue properties
-- 
2.39.2

