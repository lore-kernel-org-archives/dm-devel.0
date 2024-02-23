Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB90823CD;
	Fri, 23 Feb 2024 16:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708704785; cv=none; b=tfSHojcvwIRxtxnUzva6YubTt2p6ToFSVtDPkBVdMMcBBfUb9bXj2eiaMW4TgxGDb6rsgDxh9PkIHiXDimSeEUbNTK/eqUVomndTwCtPpQPrsgKlvDP3Pn7aAYhQ6FXuYWS/S2uCz/tHhmX6ym/V71dZMCfHt86PWMCCyuKj4qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708704785; c=relaxed/simple;
	bh=Yr884w3gRhIkUcrkO7iPb9alAoxqN1T7r99JPoCCW48=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dXGDrWeMXuK584qK88UHWLC3nG7UpF/ohkdjqXw+vhoLAhltX9hNA6s6J7719JQ+p7sd99AJBfYnxnXc0RUQCChuzuPhh6x9JIqOfx6FVJ7fP/tkSkXIVA0i+AikzjYbHTnZdT/dyLyXulUQ1htiIaT9pXTwMB9MttJGVkhNfmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=I1z9YdCI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="I1z9YdCI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Vp6cPOGmx7IsY/Gom3ohdEDfNj/bokcwTvb4p5mmNMM=; b=I1z9YdCIeN5gNvoFqo5EjeaFe9
	vp916yJEPBhp76UwPjAvIeKiM5vtEqADqSqy15BZRqGVzzs4E84OB326imp89pkHy6RQXDdFUH47K
	pEZ5xOvUqh/SGJ3PIolrLoDHzWHtUNHr6Mlb+FqlGPMAELZpt8KHJSHSaeDI1T6vnfDu0yoJ1yF1d
	uy9fMU8kuURuiEpmIRK0Qt43zD56JlORlQOAjsPwZV1ltgAUGDzCbI2amE0ukNmF61cvEVLCRsXLh
	PPN1GwIoMk7jMYdGSyJlHzxHQC58/wwO69fRnYPuPWkatvJk0X9kD6KxSve6W5j9YY3wRGuPFk2ex
	+fz+xtFw==;
Received: from [2001:4bb8:19a:62b2:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rdYAP-0000000AAfO-1zOz;
	Fri, 23 Feb 2024 16:12:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 1/9] block: add a queue_limits_set helper
Date: Fri, 23 Feb 2024 17:12:39 +0100
Message-Id: <20240223161247.3998821-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240223161247.3998821-1-hch@lst.de>
References: <20240223161247.3998821-1-hch@lst.de>
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

