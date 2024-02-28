Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0C070055;
	Wed, 28 Feb 2024 22:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709161017; cv=none; b=OSw9BB19xuqOhYDJ6/hMSvgUIMWZFYXeqbHTJoaNSMOD+ayg/8oEkP9wGBbD+C5mSRhv6YTfD8M1+5W/a69quldwwrp3SYQYxUymETVHECLnmMgBxSfIMHDYYpJ3iM1UnqUjHcmw3OSVGvF3qvTDCA0R3gUbH1Ag+8t13NjQNkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709161017; c=relaxed/simple;
	bh=Yr884w3gRhIkUcrkO7iPb9alAoxqN1T7r99JPoCCW48=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KwMjjjeAxTTQDfdlSJdoj4rfOsAaxYLEo6RBLI4D3n1EH7QA21kQN8fwIZLawgz9vm/dmeT2JB85Vqr6LtMbv8rEz6GtnnVUU3HfmmEuCNfxnnH/UVSKDT3GZ2v1o2KQLv8hVkL+zvSDHgWr3CrAnhgQk6ewAk4vJNqPewDetic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=u9eozA0Q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="u9eozA0Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Vp6cPOGmx7IsY/Gom3ohdEDfNj/bokcwTvb4p5mmNMM=; b=u9eozA0Qn28jKb49Mfz27fnc8T
	vwsdKkHbxjzM9kSW+X5yjG8hlgtggF4BI6t/GFmEqnDdPwMTqjdeFvxBTW1hTn4QYUUd/gvMobg3S
	b2BczzfKEdpTX1UCJI1+/hRGPdL5asBoqr4hIg9ntrN/1UqG1zQFpIJzlYyDAfDdbBXMDZE6WaETz
	fK6azL4fPHlFCySIpTx8igiaq0qthjtsIrkZX1lFkgYnhncuWOOsSnKhyq/4XYD6h58xSGHS80SLc
	aA047lq6t49cls1yhIhmC0WrEu6d/LHgW99K0bfiAcOeVMma9yvw787cb2wL0XIR8A37UauQGcs+8
	tQ+jUGaA==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfSr7-0000000BCNY-3QNd;
	Wed, 28 Feb 2024 22:56:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 01/14] block: add a queue_limits_set helper
Date: Wed, 28 Feb 2024 14:56:40 -0800
Message-Id: <20240228225653.947152-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240228225653.947152-1-hch@lst.de>
References: <20240228225653.947152-1-hch@lst.de>
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

