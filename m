Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169AF24BD02
	for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 16:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945539; cv=none; b=IiT5JW9wQiKaRcFntkL/d13kNskHzn1ElvmwXjWbVlgshL0muoQWyP5ECTq4du95pTjFuQTN4L0fEtrru+G2P1EhjcJeYXhMdUDGFi5YIdI3nIC3mY/xeVgXcisjuTZzvnpr9zpxu90WvLx4ysZEHnkBEby5a6ZsXzhSugErOqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945539; c=relaxed/simple;
	bh=8wzVPnQBzqZHuHZJ13js/haaaiGlfCgs4ahOVLlrbfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVIo7h4FL3sURWa3bqc9BCQ69x1grjxmgWoT93Tjm1kfItTuiSXL+05p+5o6ypYSNOKqPfm9A4/Jc/iy9TNqwAUIhKlc++lva+afDmJbZ5rJtprZAq/16d/fCtIBStTLlPiFUuGJrYjxQsS0hN/zXoNdWBGt/W0Np8FjZQuY1OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L6qQvaqP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L6qQvaqP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745945536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JripGfRv86s8YrwJ8gkd+o3MrSxA3aSVFaX4RLxjwxM=;
	b=L6qQvaqP4kI0qjt+P9cVbyoK8Y3xtO+W1/KSwB2yUM6wBbw489ghgGVYAG4K5EslD789JX
	qSbuCAs0S5LJfQ/w8tbz+zJtTPegm3ysSmXeRQsU+LkkBBeLk4O1Ep15X9a8PzEGuf9ro0
	OGTcfbty0oDZoTg63tldn2YD2PDYF0k=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-21-HGm6B3gpMDC6jq1lET9QJA-1; Tue,
 29 Apr 2025 12:52:12 -0400
X-MC-Unique: HGm6B3gpMDC6jq1lET9QJA-1
X-Mimecast-MFC-AGG-ID: HGm6B3gpMDC6jq1lET9QJA_1745945531
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1E6B7180048E;
	Tue, 29 Apr 2025 16:52:11 +0000 (UTC)
Received: from merkur.redhat.com (unknown [10.44.34.64])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4649A1956094;
	Tue, 29 Apr 2025 16:52:07 +0000 (UTC)
From: Kevin Wolf <kwolf@redhat.com>
To: dm-devel@lists.linux.dev
Cc: kwolf@redhat.com,
	hreitz@redhat.com,
	mpatocka@redhat.com,
	snitzer@kernel.org,
	bmarzins@redhat.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] dm: Allow .prepare_ioctl to handle ioctls directly
Date: Tue, 29 Apr 2025 18:50:17 +0200
Message-ID: <20250429165018.112999-2-kwolf@redhat.com>
In-Reply-To: <20250429165018.112999-1-kwolf@redhat.com>
References: <20250429165018.112999-1-kwolf@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

This adds a 'bool *forward' parameter to .prepare_ioctl, which allows
device mapper targets to accept ioctls to themselves instead of the
underlying device. If the target already fully handled the ioctl, it
sets *forward to false and device mapper won't forward it to the
underlying device any more.

In order for targets to actually know what the ioctl is about and how to
handle it, pass also cmd and arg.

As long as targets restrict themselves to interpreting ioctls of type
DM_IOCTL, this is a backwards compatible change because previously, any
such ioctl would have been passed down through all device mapper layers
until it reached a device that can't understand the ioctl and would
return an error.

Signed-off-by: Kevin Wolf <kwolf@redhat.com>
---
 include/linux/device-mapper.h |  9 ++++++++-
 drivers/md/dm-dust.c          |  4 +++-
 drivers/md/dm-ebs-target.c    |  3 ++-
 drivers/md/dm-flakey.c        |  4 +++-
 drivers/md/dm-linear.c        |  4 +++-
 drivers/md/dm-log-writes.c    |  4 +++-
 drivers/md/dm-mpath.c         |  4 +++-
 drivers/md/dm-switch.c        |  4 +++-
 drivers/md/dm-verity-target.c |  4 +++-
 drivers/md/dm-zoned-target.c  |  3 ++-
 drivers/md/dm.c               | 17 +++++++++++------
 11 files changed, 44 insertions(+), 16 deletions(-)

diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index bcc6d7b69470..cb95951547ab 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -93,7 +93,14 @@ typedef void (*dm_status_fn) (struct dm_target *ti, status_type_t status_type,
 typedef int (*dm_message_fn) (struct dm_target *ti, unsigned int argc, char **argv,
 			      char *result, unsigned int maxlen);
 
-typedef int (*dm_prepare_ioctl_fn) (struct dm_target *ti, struct block_device **bdev);
+/*
+ * Called with *forward == true. If it remains true, the ioctl should be
+ * forwarded to bdev. If it is reset to false, the target already fully handled
+ * the ioctl and the return value is the return value for the whole ioctl.
+ */
+typedef int (*dm_prepare_ioctl_fn) (struct dm_target *ti, struct block_device **bdev,
+				    unsigned int cmd, unsigned long arg,
+				    bool *forward);
 
 #ifdef CONFIG_BLK_DEV_ZONED
 typedef int (*dm_report_zones_fn) (struct dm_target *ti,
diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
index 1a33820c9f46..e75310232bbf 100644
--- a/drivers/md/dm-dust.c
+++ b/drivers/md/dm-dust.c
@@ -534,7 +534,9 @@ static void dust_status(struct dm_target *ti, status_type_t type,
 	}
 }
 
-static int dust_prepare_ioctl(struct dm_target *ti, struct block_device **bdev)
+static int dust_prepare_ioctl(struct dm_target *ti, struct block_device **bdev,
+			      unsigned int cmd, unsigned long arg,
+			      bool *forward)
 {
 	struct dust_device *dd = ti->private;
 	struct dm_dev *dev = dd->dev;
diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
index b19b0142a690..6abb31ca9662 100644
--- a/drivers/md/dm-ebs-target.c
+++ b/drivers/md/dm-ebs-target.c
@@ -415,7 +415,8 @@ static void ebs_status(struct dm_target *ti, status_type_t type,
 	}
 }
 
-static int ebs_prepare_ioctl(struct dm_target *ti, struct block_device **bdev)
+static int ebs_prepare_ioctl(struct dm_target *ti, struct block_device **bdev,
+			     unsigned int cmd, unsigned long arg, bool *forward)
 {
 	struct ebs_c *ec = ti->private;
 	struct dm_dev *dev = ec->dev;
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index b690905ab89f..0fceb08f4622 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -638,7 +638,9 @@ static void flakey_status(struct dm_target *ti, status_type_t type,
 	}
 }
 
-static int flakey_prepare_ioctl(struct dm_target *ti, struct block_device **bdev)
+static int flakey_prepare_ioctl(struct dm_target *ti, struct block_device **bdev,
+				unsigned int cmd, unsigned long arg,
+				bool *forward)
 {
 	struct flakey_c *fc = ti->private;
 
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 66318aba4bdb..15538ec58f8e 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -119,7 +119,9 @@ static void linear_status(struct dm_target *ti, status_type_t type,
 	}
 }
 
-static int linear_prepare_ioctl(struct dm_target *ti, struct block_device **bdev)
+static int linear_prepare_ioctl(struct dm_target *ti, struct block_device **bdev,
+				unsigned int cmd, unsigned long arg,
+				bool *forward)
 {
 	struct linear_c *lc = ti->private;
 	struct dm_dev *dev = lc->dev;
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 8d7df8303d0a..d484e8e1d48a 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -818,7 +818,9 @@ static void log_writes_status(struct dm_target *ti, status_type_t type,
 }
 
 static int log_writes_prepare_ioctl(struct dm_target *ti,
-				    struct block_device **bdev)
+				    struct block_device **bdev,
+				    unsigned int cmd, unsigned long arg,
+				    bool *forward)
 {
 	struct log_writes_c *lc = ti->private;
 	struct dm_dev *dev = lc->dev;
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 6c98f4ae5ea9..909ed6890ba5 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -2022,7 +2022,9 @@ static int multipath_message(struct dm_target *ti, unsigned int argc, char **arg
 }
 
 static int multipath_prepare_ioctl(struct dm_target *ti,
-				   struct block_device **bdev)
+				   struct block_device **bdev,
+				   unsigned int cmd, unsigned long arg,
+				   bool *forward)
 {
 	struct multipath *m = ti->private;
 	struct pgpath *pgpath;
diff --git a/drivers/md/dm-switch.c b/drivers/md/dm-switch.c
index dfd9fb52a6f3..bb1a70b5a215 100644
--- a/drivers/md/dm-switch.c
+++ b/drivers/md/dm-switch.c
@@ -517,7 +517,9 @@ static void switch_status(struct dm_target *ti, status_type_t type,
  *
  * Passthrough all ioctls to the path for sector 0
  */
-static int switch_prepare_ioctl(struct dm_target *ti, struct block_device **bdev)
+static int switch_prepare_ioctl(struct dm_target *ti, struct block_device **bdev,
+				unsigned int cmd, unsigned long arg,
+				bool *forward)
 {
 	struct switch_ctx *sctx = ti->private;
 	unsigned int path_nr;
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 4de2c226ac9d..34a9f9fbd0d1 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -994,7 +994,9 @@ static void verity_status(struct dm_target *ti, status_type_t type,
 	}
 }
 
-static int verity_prepare_ioctl(struct dm_target *ti, struct block_device **bdev)
+static int verity_prepare_ioctl(struct dm_target *ti, struct block_device **bdev,
+				unsigned int cmd, unsigned long arg,
+				bool *forward)
 {
 	struct dm_verity *v = ti->private;
 
diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index 6141fc25d842..5da3db06da10 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -1015,7 +1015,8 @@ static void dmz_io_hints(struct dm_target *ti, struct queue_limits *limits)
 /*
  * Pass on ioctl to the backend device.
  */
-static int dmz_prepare_ioctl(struct dm_target *ti, struct block_device **bdev)
+static int dmz_prepare_ioctl(struct dm_target *ti, struct block_device **bdev,
+			     unsigned int cmd, unsigned long arg, bool *forward)
 {
 	struct dmz_target *dmz = ti->private;
 	struct dmz_dev *dev = &dmz->dev[0];
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ccccc098b30e..1726f0f828cc 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -411,7 +411,8 @@ static int dm_blk_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 }
 
 static int dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
-			    struct block_device **bdev)
+			    struct block_device **bdev, unsigned int cmd,
+			    unsigned long arg, bool *forward)
 {
 	struct dm_target *ti;
 	struct dm_table *map;
@@ -434,8 +435,8 @@ static int dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
 	if (dm_suspended_md(md))
 		return -EAGAIN;
 
-	r = ti->type->prepare_ioctl(ti, bdev);
-	if (r == -ENOTCONN && !fatal_signal_pending(current)) {
+	r = ti->type->prepare_ioctl(ti, bdev, cmd, arg, forward);
+	if (r == -ENOTCONN && *forward && !fatal_signal_pending(current)) {
 		dm_put_live_table(md, *srcu_idx);
 		fsleep(10000);
 		goto retry;
@@ -454,9 +455,10 @@ static int dm_blk_ioctl(struct block_device *bdev, blk_mode_t mode,
 {
 	struct mapped_device *md = bdev->bd_disk->private_data;
 	int r, srcu_idx;
+	bool forward = true;
 
-	r = dm_prepare_ioctl(md, &srcu_idx, &bdev);
-	if (r < 0)
+	r = dm_prepare_ioctl(md, &srcu_idx, &bdev, cmd, arg, &forward);
+	if (!forward || r < 0)
 		goto out;
 
 	if (r > 0) {
@@ -3630,10 +3632,13 @@ static int dm_pr_clear(struct block_device *bdev, u64 key)
 	struct mapped_device *md = bdev->bd_disk->private_data;
 	const struct pr_ops *ops;
 	int r, srcu_idx;
+	bool forward = true;
 
-	r = dm_prepare_ioctl(md, &srcu_idx, &bdev);
+	/* Not a real ioctl, but targets must not interpret non-DM ioctls */
+	r = dm_prepare_ioctl(md, &srcu_idx, &bdev, 0, 0, &forward);
 	if (r < 0)
 		goto out;
+	WARN_ON_ONCE(!forward);
 
 	ops = bdev->bd_disk->fops->pr_ops;
 	if (ops && ops->pr_clear)
-- 
2.49.0

