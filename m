Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E53A450EE
	for <dm-devel@lists.linux.dev>; Mon, 17 Mar 2025 04:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742186722; cv=none; b=iOjIEyGhv997UL1QzvoAkUT+B2KKFgZFwLruCI3IFEMh4qM3RJlll+uAx9odYNhmDTIIeSzj17T+RmataxKbvAywju0QFaXb8Mb37KXKn5z1Bnc7MCzYpwqa0mdKKdVAzjxK0OKWtpWEOr5UnUWc6h5k+0RcPAsUSrXatMim5ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742186722; c=relaxed/simple;
	bh=mLBBrYbSbk2DQV+/TZdd6Icc6RDzDF7/lqHhA8sj5eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTOiUV5gN3NDZs5N3ML/T7+cJkwvTzPH5HYnB4aobHHdmQGdSHiCm/6Atgv8B+jnROgIgYZm1ypnmolJQ75Lm5jOXTbOjkrKZAHXG05BQoulhJ6ntGY5nDl4jASYtJ87tjhM6XdBLM75ESTH+nMc2oWUTzxIDjQkPJ5ITpwHsmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A7ujOZsV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A7ujOZsV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742186719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v75uG4j8z7Addvp3lObGLO4D7RHzJZGZNNgCdcTkhsQ=;
	b=A7ujOZsVfEP24YCR/SD+0hcM7ot7T7DhzkPeutBl8fJ6inxmAI2XOzQZxf2jOfq+/3+gOa
	8awtOQB3lpF5VK+cvyAONLGmr+f8bOUlzZbTwHkZN61W+s1FHXWHV/pXXVcD5v3KxDNQHT
	ZEU89hqM6dtMRUI900OGcysPbNa0FQ8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-397-0d3WAc-MMJu8YwZjVpfwrA-1; Mon,
 17 Mar 2025 00:45:15 -0400
X-MC-Unique: 0d3WAc-MMJu8YwZjVpfwrA-1
X-Mimecast-MFC-AGG-ID: 0d3WAc-MMJu8YwZjVpfwrA_1742186713
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1F4D51800266;
	Mon, 17 Mar 2025 04:45:13 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 893CA18009BC;
	Mon, 17 Mar 2025 04:45:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 52H4jB2T2200874
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 17 Mar 2025 00:45:11 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 52H4jBmB2200873;
	Mon, 17 Mar 2025 00:45:11 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
        Damien Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 3/6] block: make queue_limits_set() optionally return old limits
Date: Mon, 17 Mar 2025 00:45:07 -0400
Message-ID: <20250317044510.2200856-4-bmarzins@redhat.com>
In-Reply-To: <20250317044510.2200856-1-bmarzins@redhat.com>
References: <20250317044510.2200856-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

A future device-mapper patch will make use of this new argument. No
functional changes intended in this patch.

Suggested-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 block/blk-settings.c   | 9 +++++++--
 drivers/md/dm-table.c  | 2 +-
 drivers/md/md-linear.c | 2 +-
 drivers/md/raid0.c     | 2 +-
 drivers/md/raid1.c     | 2 +-
 drivers/md/raid10.c    | 2 +-
 drivers/md/raid5.c     | 2 +-
 include/linux/blkdev.h | 3 ++-
 8 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index c44dadc35e1e..bad690ef8fec 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -476,16 +476,21 @@ EXPORT_SYMBOL_GPL(queue_limits_commit_update_frozen);
  * queue_limits_set - apply queue limits to queue
  * @q:		queue to update
  * @lim:	limits to apply
+ * @old_lim:	store previous limits if non-null.
  *
- * Apply the limits in @lim that were freshly initialized to @q.
+ * Apply the limits in @lim that were freshly initialized to @q, and
+ * optionally return the previous limits in @old_lim.
  * To update existing limits use queue_limits_start_update() and
  * queue_limits_commit_update() instead.
  *
  * Returns 0 if successful, else a negative error code.
  */
-int queue_limits_set(struct request_queue *q, struct queue_limits *lim)
+int queue_limits_set(struct request_queue *q, struct queue_limits *lim,
+		     struct queue_limits *old_lim)
 {
 	mutex_lock(&q->limits_lock);
+	if (old_lim)
+		*old_lim = q->limits;
 	return queue_limits_commit_update(q, lim);
 }
 EXPORT_SYMBOL_GPL(queue_limits_set);
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 0ef5203387b2..77d8459b2f2a 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1883,7 +1883,7 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	if (dm_table_supports_atomic_writes(t))
 		limits->features |= BLK_FEAT_ATOMIC_WRITES;
 
-	r = queue_limits_set(q, limits);
+	r = queue_limits_set(q, limits, NULL);
 	if (r)
 		return r;
 
diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index a382929ce7ba..65ceec5b078f 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -81,7 +81,7 @@ static int linear_set_limits(struct mddev *mddev)
 		return err;
 	}
 
-	return queue_limits_set(mddev->gendisk->queue, &lim);
+	return queue_limits_set(mddev->gendisk->queue, &lim, NULL);
 }
 
 static struct linear_conf *linear_conf(struct mddev *mddev, int raid_disks)
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 8fc9339b00c7..2eb42b2c103b 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -390,7 +390,7 @@ static int raid0_set_limits(struct mddev *mddev)
 		queue_limits_cancel_update(mddev->gendisk->queue);
 		return err;
 	}
-	return queue_limits_set(mddev->gendisk->queue, &lim);
+	return queue_limits_set(mddev->gendisk->queue, &lim, NULL);
 }
 
 static int raid0_run(struct mddev *mddev)
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 9d57a88dbd26..e8103dbc549c 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3223,7 +3223,7 @@ static int raid1_set_limits(struct mddev *mddev)
 		queue_limits_cancel_update(mddev->gendisk->queue);
 		return err;
 	}
-	return queue_limits_set(mddev->gendisk->queue, &lim);
+	return queue_limits_set(mddev->gendisk->queue, &lim, NULL);
 }
 
 static int raid1_run(struct mddev *mddev)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index efe93b979167..dbc2ee70d0d3 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4024,7 +4024,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 		queue_limits_cancel_update(mddev->gendisk->queue);
 		return err;
 	}
-	return queue_limits_set(mddev->gendisk->queue, &lim);
+	return queue_limits_set(mddev->gendisk->queue, &lim, NULL);
 }
 
 static int raid10_run(struct mddev *mddev)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5c79429acc64..a7cc2ec86793 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7774,7 +7774,7 @@ static int raid5_set_limits(struct mddev *mddev)
 	/* No restrictions on the number of segments in the request */
 	lim.max_segments = USHRT_MAX;
 
-	return queue_limits_set(mddev->gendisk->queue, &lim);
+	return queue_limits_set(mddev->gendisk->queue, &lim, NULL);
 }
 
 static int raid5_run(struct mddev *mddev)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 248416ecd01c..bb264fd7b2f2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -953,7 +953,8 @@ int queue_limits_commit_update_frozen(struct request_queue *q,
 		struct queue_limits *lim);
 int queue_limits_commit_update(struct request_queue *q,
 		struct queue_limits *lim);
-int queue_limits_set(struct request_queue *q, struct queue_limits *lim);
+int queue_limits_set(struct request_queue *q, struct queue_limits *lim,
+		     struct queue_limits *old_lim);
 int blk_validate_limits(struct queue_limits *lim);
 
 /**
-- 
2.48.1

