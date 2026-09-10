Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F032DB7B8
	for <dm-devel@lists.linux.dev>; Thu, 10 Sep 2026 08:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789027881; cv=none; b=Mnmgbf4oyWL/bLi3sUWVE462DWmrPGVAcfXjSSgfqNX4gHV9RetePH2XYs8cYcJ9EAsRcN0zXvgvM1Kt/MhuGXzRAF3y06oyblAUceX1ZO0JtJBLsAcTiPVosXYYzb/wHxhx62uxFEHj7A+Rru80Ffz3/1IBTUQWJnlbGMR8N/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789027881; c=relaxed/simple;
	bh=vvSIYJQObR1nDYB8lJ4RbBMp3hmCIa0DaCci/koCzZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cCWnMdllxDg/KGuRY+wcYKRmZ13OqfqN+6keKqJUHtXNIJliU72VTnzwKDa5KwuLQC02v7KulMsc8Fb1jY3/d473WEBzZIjG3saIt4k0HRgt/drlDnWwS9aNVFZ6/wvCYoMjTanjmPP+Xa0HusHLbPOmV/B3QegKtFh/9TBoh4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=fwnlA3G+; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="fwnlA3G+"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cfbdac7a1so3233825e9.1
        for <dm-devel@lists.linux.dev>; Thu, 10 Sep 2026 01:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1789027878; x=1789632678; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hZ0/qzbC4prOZzDrke+CQgOkg3IeDQ8d9wlQhN5ktvw=;
        b=fwnlA3G+WzJrpHnPBdoAHDixj38ClATOdnWdKJ8En1srAVHjYD1BW14qY+H3ktnAkB
         VjDkeNPMdCNKT1wiy6+Bzz6LWPt8pSPt7HRO3ZrtzcLx8bS2IAIScUyMkSvSkEoPbNuZ
         nE76ifrJSfkngkvUEoE7lHsAhxefzXQ0uVI+0zRLMn+DFxlrhsfkHc5Sv47AID8bcOw3
         X62rY3XQYNaI7zKHpTPemf9Xu1uW2Om/Q0c3fGBCCfn5lEAFyebj1RZ4iRlPtfsRLhXu
         +HqhhmvV/HzUJWhrJW0s5rJzC8c+0rOsclhfb8b62qxXwKPIyEM6HqLyUGA0mVW1bPZL
         43iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789027878; x=1789632678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hZ0/qzbC4prOZzDrke+CQgOkg3IeDQ8d9wlQhN5ktvw=;
        b=Es0NktVujk1lcZa3u4o7vuwTB8RI3BsUvHvkN+ZxyaTAZd2DmbzCjs1olg0KxU7iHL
         EL2OssSekW/i0HjDObYsrPNi3kTWcgNZHSwE+7kp7C6biVcTFPPM6dnkcWaPl+CSSp2c
         Rkre6jfF4jx3jfydRByVrEw6vrGNW01tbL8EC5XCoz9w6VJN5UCxjLfeaIFYcP5519kR
         DB8A5IqXolKM6ZtsJ/y/hd4Q5iaRbclxdKMLoKUD7gYl95gyCPQsfrnDJH1khn8JpBUL
         C2CQWWrZhLjQa59fzsqn2Mc4TrCTfjXX0RffXlr1JJrlH9VTUda7zZxiT6T/i71KwdPp
         X+gQ==
X-Forwarded-Encrypted: i=1; AKwUvBxIHnbvXlJUSJRBaxwDyLSSlA3cCLqZwtOyAJfcoAmBmKF2MuvX+GzYyFS82PFyEQx9DbQIq6d3bQ==@lists.linux.dev
X-Gm-Message-State: AFuF++l2y6ba4BAOOUYhSFUzB4iesA2cKUvHhIzGO00Ncyz2bEFlr8AQ
	V2E6lhpCu9m1DOCnPsqAZVRFo/U48mYCKgmx2mTnNemevaPXMFDUlSksggPTa5xBAh4=
X-Gm-Gg: AYBFou0FptxPQGp5AwsSfIin3mJJc7kw5k8pl4tC1FO1w1thuixR1tD9hVkRVW3VcDp
	nzZv5jGI+Cu5tv9OhNnoN+7pCXJi0Em9lGDKSCnJoePn5QCsFUkRI1dioi/MN6AlC2p0Zi/t96m
	UDOSA2yILNyt+JXDBgdo6pAV3ScNkDyA6VCj6VCDdltRtYetxCk2i8SjvGn/I507B0Jke4c3Wb2
	ffDuyFI7xfnjfBCgQZeuJO/HzIblIn7bL4rNtZnN9Kb4QOrJ1Zwfwq6VtyQZQ5/RIVzCYFygnaD
	pleuwsY9oQVsJ4AifDx1qXjs4Q+VjnEqKVcBG6dx2C8F10Vf9cHC6LothEVaucxYjrelNhm0UJA
	tRTRxuRxOY+yBHmcSBrrlVycgAtmIHsu6vFG4LD7QHj7aMpUJ4qymXrWDh/HnM25EJA2UN7mZXT
	UeEfyFHqymQlYYmjZQsi4PNq/jtALiV7YPNWJFKyNPd58KY2ilnqj9tVgY/kNaa2TANeFjE6Ufs
	1L7T4bNjn+4GYEpakizXHeH3/79N4VUlRJL0fU2GTwI
X-Received: by 2002:a05:600c:c48f:b0:49b:9241:7ff0 with SMTP id 5b1f17b1804b1-49d010c4f64mr288748745e9.0.1789027877469;
        Thu, 10 Sep 2026 01:11:17 -0700 (PDT)
Received: from jwang-ThinkPad-T14-Gen-6.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d20fc1be3sm55261135e9.4.2026.09.10.01.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 01:11:16 -0700 (PDT)
From: Jack Wang <jinpu.wang@ionos.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	Nilay Shroff <nilay@linux.ibm.com>,
	abd.masalkhi@gmail.com
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Ming Lei <tom.leiming@gmail.com>,
	Xiao Ni <xiao@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v2 1/8] md: pass a queue_limits down to ->hot_add_disk()
Date: Thu, 10 Sep 2026 10:11:06 +0200
Message-ID: <20260910081114.1605746-2-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260910081114.1605746-1-jinpu.wang@ionos.com>
References: <20260910081114.1605746-1-jinpu.wang@ionos.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Wang <jinpu.wang@cloud.ionos.com>

Adding a leg stacks its queue limits, which mddev_stack_new_rdev() does
by taking q->limits_lock itself.  Callers holding reconfig_mutex or a
suspended array cannot allow that, and must own the update instead.

Give ->hot_add_disk(), remove_and_add_spares() and
md_choose_sync_action() a struct queue_limits argument with three
states: an update to stack into, NULL to let the personality take the
lock as before, or MDDEV_STACK_SKIP to add the leg without touching the
limits, for callers that can do neither.  mddev_stack_rdev_into() stacks
into a caller-owned update without the lock.

Every caller still passes NULL and nothing passes the sentinel yet, so
there is no functional change; the users follow.

Assisted-by: LLM
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/md/dm-raid.c   |  2 +-
 drivers/md/md-linear.c | 28 ++++++++++++++----
 drivers/md/md.c        | 66 ++++++++++++++++++++++++++++++++----------
 drivers/md/md.h        | 11 ++++++-
 drivers/md/raid1.c     | 10 +++++--
 drivers/md/raid10.c    | 19 +++++++++---
 drivers/md/raid5.c     |  5 ++--
 7 files changed, 110 insertions(+), 31 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 8f5a5e1342a9..21a1922bee4f 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3923,7 +3923,7 @@ static void attempt_restore_of_faulty_devices(struct raid_set *rs)
 			clear_bit(Faulty, &r->flags);
 			clear_bit(WriteErrorSeen, &r->flags);
 
-			if (mddev->pers->hot_add_disk(mddev, r)) {
+			if (mddev->pers->hot_add_disk(mddev, r, NULL)) {
 				/* Failed to revive this device, try next */
 				r->raid_disk = r->saved_raid_disk = -1;
 				r->flags = flags;
diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index 73b367b61b87..da82c313d459 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -65,11 +65,16 @@ static sector_t linear_size(struct mddev *mddev, sector_t sectors, int raid_disk
 	return array_sectors;
 }
 
-static int linear_set_limits(struct mddev *mddev)
+static int linear_set_limits(struct mddev *mddev,
+			     struct queue_limits *caller_lim)
 {
 	struct queue_limits lim;
 	int err;
 
+	/* the caller can neither stack nor take q->limits_lock */
+	if (caller_lim == MDDEV_STACK_SKIP)
+		return 0;
+
 	md_init_stacking_limits(&lim);
 	lim.features |= BLK_FEAT_NOWAIT;
 	lim.max_hw_sectors = mddev->chunk_sectors;
@@ -82,10 +87,20 @@ static int linear_set_limits(struct mddev *mddev)
 	if (err)
 		return err;
 
+	/*
+	 * The caller owns an update and commits it itself; taking
+	 * q->limits_lock here would take it a second time.
+	 */
+	if (caller_lim) {
+		*caller_lim = lim;
+		return 0;
+	}
+
 	return queue_limits_set(mddev->gendisk->queue, &lim);
 }
 
-static struct linear_conf *linear_conf(struct mddev *mddev, int raid_disks)
+static struct linear_conf *linear_conf(struct mddev *mddev, int raid_disks,
+				       struct queue_limits *lim)
 {
 	struct linear_conf *conf;
 	struct md_rdev *rdev;
@@ -151,7 +166,7 @@ static struct linear_conf *linear_conf(struct mddev *mddev, int raid_disks)
 			conf->disks[i].rdev->sectors;
 
 	if (!mddev_is_dm(mddev)) {
-		ret = linear_set_limits(mddev);
+		ret = linear_set_limits(mddev, lim);
 		if (ret)
 			goto out;
 	}
@@ -171,7 +186,7 @@ static int linear_run(struct mddev *mddev)
 	if (md_check_no_bitmap(mddev))
 		return -EINVAL;
 
-	conf = linear_conf(mddev, mddev->raid_disks);
+	conf = linear_conf(mddev, mddev->raid_disks, NULL);
 	if (IS_ERR(conf))
 		return PTR_ERR(conf);
 
@@ -186,7 +201,8 @@ static int linear_run(struct mddev *mddev)
 	return ret;
 }
 
-static int linear_add(struct mddev *mddev, struct md_rdev *rdev)
+static int linear_add(struct mddev *mddev, struct md_rdev *rdev,
+		      struct queue_limits *lim)
 {
 	/* Adding a drive to a linear array allows the array to grow.
 	 * It is permitted if the new drive has a matching superblock
@@ -204,7 +220,7 @@ static int linear_add(struct mddev *mddev, struct md_rdev *rdev)
 	rdev->raid_disk = rdev->saved_raid_disk;
 	rdev->saved_raid_disk = -1;
 
-	newconf = linear_conf(mddev, mddev->raid_disks + 1);
+	newconf = linear_conf(mddev, mddev->raid_disks + 1, lim);
 	if (IS_ERR(newconf))
 		return PTR_ERR(newconf);
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 680b34a63cb3..28fc903ffeea 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -94,8 +94,8 @@ static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
  */
 static struct workqueue_struct *md_misc_wq;
 
-static int remove_and_add_spares(struct mddev *mddev,
-				 struct md_rdev *this);
+static int remove_and_add_spares(struct mddev *mddev, struct md_rdev *this,
+				 struct queue_limits *lim);
 static void mddev_detach(struct mddev *mddev);
 static void export_rdev(struct md_rdev *rdev);
 static void md_wakeup_thread_directly(struct md_thread __rcu **thread);
@@ -2994,7 +2994,7 @@ static int add_bound_rdev(struct md_rdev *rdev)
 		 */
 		super_types[mddev->major_version].
 			validate_super(mddev, NULL/*freshest*/, rdev);
-		err = mddev->pers->hot_add_disk(mddev, rdev);
+		err = mddev->pers->hot_add_disk(mddev, rdev, NULL);
 		if (err) {
 			md_kick_rdev_from_array(rdev);
 			return err;
@@ -3110,7 +3110,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 	} else if (cmd_match(buf, "remove")) {
 		if (rdev->mddev->pers) {
 			clear_bit(Blocked, &rdev->flags);
-			remove_and_add_spares(rdev->mddev, rdev);
+			remove_and_add_spares(rdev->mddev, rdev, NULL);
 		}
 		if (rdev->raid_disk >= 0)
 			err = -EBUSY;
@@ -3314,7 +3314,7 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 		if (rdev->mddev->pers->hot_remove_disk == NULL)
 			return -EINVAL;
 		clear_bit(Blocked, &rdev->flags);
-		remove_and_add_spares(rdev->mddev, rdev);
+		remove_and_add_spares(rdev->mddev, rdev, NULL);
 		if (rdev->raid_disk >= 0)
 			return -EBUSY;
 		set_bit(MD_RECOVERY_NEEDED, &rdev->mddev->recovery);
@@ -3344,7 +3344,8 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 			rdev->saved_raid_disk = -1;
 		clear_bit(In_sync, &rdev->flags);
 		clear_bit(Bitmap_sync, &rdev->flags);
-		err = rdev->mddev->pers->hot_add_disk(rdev->mddev, rdev);
+		err = rdev->mddev->pers->hot_add_disk(rdev->mddev, rdev,
+						     NULL);
 		if (err) {
 			rdev->raid_disk = -1;
 			return err;
@@ -6275,6 +6276,40 @@ int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev)
 }
 EXPORT_SYMBOL_GPL(mddev_stack_new_rdev);
 
+/*
+ * Stack a new rdev into limits the caller already holds limits_lock for and
+ * will commit itself.  Used from paths that must take limits_lock before
+ * quiescing the array, see md_start_sync().
+ */
+int mddev_stack_rdev_into(struct mddev *mddev, struct md_rdev *rdev,
+			  struct queue_limits *lim)
+{
+	struct queue_limits tmp = *lim;
+
+	if (mddev_is_dm(mddev))
+		return 0;
+
+	if (queue_logical_block_size(rdev->bdev->bd_disk->queue) >
+	    queue_logical_block_size(mddev->gendisk->queue)) {
+		pr_err("%s: incompatible logical_block_size, can not add\n",
+		       mdname(mddev));
+		return -EINVAL;
+	}
+
+	queue_limits_stack_bdev(&tmp, rdev->bdev, rdev->data_offset,
+				mddev->gendisk->disk_name);
+
+	if (!queue_limits_stack_integrity_bdev(&tmp, rdev->bdev)) {
+		pr_err("%s: incompatible integrity profile for %pg\n",
+		       mdname(mddev), rdev->bdev);
+		return -ENXIO;
+	}
+
+	*lim = tmp;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mddev_stack_rdev_into);
+
 /* update the optimal I/O size after a reshape */
 void mddev_update_io_opt(struct mddev *mddev, unsigned int nr_stripes)
 {
@@ -7706,7 +7741,7 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 		goto kick_rdev;
 
 	clear_bit(Blocked, &rdev->flags);
-	remove_and_add_spares(mddev, rdev);
+	remove_and_add_spares(mddev, rdev, NULL);
 
 	if (rdev->raid_disk >= 0)
 		goto busy;
@@ -10167,8 +10202,8 @@ static int remove_spares(struct mddev *mddev, struct md_rdev *this)
 	return removed;
 }
 
-static int remove_and_add_spares(struct mddev *mddev,
-				 struct md_rdev *this)
+static int remove_and_add_spares(struct mddev *mddev, struct md_rdev *this,
+				 struct queue_limits *lim)
 {
 	struct md_rdev *rdev;
 	int spares = 0;
@@ -10191,7 +10226,7 @@ static int remove_and_add_spares(struct mddev *mddev,
 			continue;
 		if (!test_bit(Journal, &rdev->flags))
 			rdev->recovery_offset = 0;
-		if (mddev->pers->hot_add_disk(mddev, rdev) == 0) {
+		if (mddev->pers->hot_add_disk(mddev, rdev, lim) == 0) {
 			/* failure here is OK */
 			sysfs_link_rdev(mddev, rdev);
 			if (!test_bit(Journal, &rdev->flags))
@@ -10206,7 +10241,8 @@ static int remove_and_add_spares(struct mddev *mddev,
 	return spares;
 }
 
-static bool md_choose_sync_action(struct mddev *mddev, int *spares)
+static bool md_choose_sync_action(struct mddev *mddev, int *spares,
+				  struct queue_limits *lim)
 {
 	/* Check if reshape is in progress first. */
 	if (mddev->reshape_position != MaxSector) {
@@ -10234,7 +10270,7 @@ static bool md_choose_sync_action(struct mddev *mddev, int *spares)
 	 * also removed and re-added, to allow the personality to fail the
 	 * re-add.
 	 */
-	*spares = remove_and_add_spares(mddev, NULL);
+	*spares = remove_and_add_spares(mddev, NULL, lim);
 	if (*spares || test_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery)) {
 		clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 		clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
@@ -10294,11 +10330,11 @@ static void md_start_sync(struct work_struct *ws)
 		 * As we only add devices that are already in-sync, we can
 		 * activate the spares immediately.
 		 */
-		remove_and_add_spares(mddev, NULL);
+		remove_and_add_spares(mddev, NULL, NULL);
 		goto not_running;
 	}
 
-	if (!md_choose_sync_action(mddev, &spares))
+	if (!md_choose_sync_action(mddev, &spares, NULL))
 		goto not_running;
 
 	if (!mddev->pers->sync_request)
@@ -10849,7 +10885,7 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 					rdev2->saved_raid_disk = -1;
 				else
 					rdev2->saved_raid_disk = role;
-				ret = remove_and_add_spares(mddev, rdev2);
+				ret = remove_and_add_spares(mddev, rdev2, NULL);
 				pr_info("Activated spare: %pg\n",
 					rdev2->bdev);
 				/* wakeup mddev->thread here, so array could
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b6d2e8929a0f..ebdd57677062 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -765,7 +765,8 @@ struct md_personality
 	 * if appropriate, and should abort recovery if needed
 	 */
 	void (*error_handler)(struct mddev *mddev, struct md_rdev *rdev);
-	int (*hot_add_disk) (struct mddev *mddev, struct md_rdev *rdev);
+	int (*hot_add_disk)(struct mddev *mddev, struct md_rdev *rdev,
+			    struct queue_limits *lim);
 	int (*hot_remove_disk) (struct mddev *mddev, struct md_rdev *rdev);
 	int (*spare_active) (struct mddev *mddev);
 	sector_t (*sync_request)(struct mddev *mddev, sector_t sector_nr,
@@ -1047,6 +1048,14 @@ int do_md_run(struct mddev *mddev);
 int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
 		unsigned int flags);
 int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev);
+int mddev_stack_rdev_into(struct mddev *mddev, struct md_rdev *rdev,
+			  struct queue_limits *lim);
+/*
+ * Sentinel for the queue_limits argument of ->hot_add_disk().  The caller has
+ * no update to stack into and must not take q->limits_lock itself, so the leg
+ * is added with the array's current limits.
+ */
+#define MDDEV_STACK_SKIP	((struct queue_limits *)ERR_PTR(-EAGAIN))
 void mddev_update_io_opt(struct mddev *mddev, unsigned int nr_stripes);
 
 extern const struct block_device_operations md_fops;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f0646fb24371..78effcac138d 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1898,7 +1898,8 @@ static bool raid1_remove_conf(struct r1conf *conf, int disk)
 	return true;
 }
 
-static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
+static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev,
+			  struct queue_limits *lim)
 {
 	struct r1conf *conf = mddev->private;
 	int err = -EEXIST;
@@ -1923,7 +1924,12 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	for (mirror = first; mirror <= last; mirror++) {
 		p = conf->mirrors + mirror;
 		if (!p->rdev) {
-			err = mddev_stack_new_rdev(mddev, rdev);
+			if (lim == MDDEV_STACK_SKIP)
+				err = 0;
+			else if (lim)
+				err = mddev_stack_rdev_into(mddev, rdev, lim);
+			else
+				err = mddev_stack_new_rdev(mddev, rdev);
 			if (err)
 				return err;
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 1093c798d9dd..222bd7badcff 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2095,7 +2095,8 @@ static int raid10_spare_active(struct mddev *mddev)
 	return count;
 }
 
-static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
+static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev,
+			   struct queue_limits *lim)
 {
 	struct r10conf *conf = mddev->private;
 	int err = -EEXIST;
@@ -2130,7 +2131,12 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 			continue;
 		}
 
-		err = mddev_stack_new_rdev(mddev, rdev);
+		if (lim == MDDEV_STACK_SKIP)
+			err = 0;
+		else if (lim)
+			err = mddev_stack_rdev_into(mddev, rdev, lim);
+		else
+			err = mddev_stack_new_rdev(mddev, rdev);
 		if (err)
 			return err;
 		p->head_position = 0;
@@ -2147,7 +2153,12 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		clear_bit(In_sync, &rdev->flags);
 		set_bit(Replacement, &rdev->flags);
 		rdev->raid_disk = repl_slot;
-		err = mddev_stack_new_rdev(mddev, rdev);
+		if (lim == MDDEV_STACK_SKIP)
+			err = 0;
+		else if (lim)
+			err = mddev_stack_rdev_into(mddev, rdev, lim);
+		else
+			err = mddev_stack_new_rdev(mddev, rdev);
 		if (err)
 			return err;
 		conf->fullsync = 1;
@@ -4484,7 +4495,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 		rdev_for_each(rdev, mddev)
 			if (rdev->raid_disk < 0 &&
 			    !test_bit(Faulty, &rdev->flags)) {
-				if (raid10_add_disk(mddev, rdev) == 0) {
+				if (raid10_add_disk(mddev, rdev, NULL) == 0) {
 					if (rdev->raid_disk >=
 					    conf->prev.raid_disks)
 						set_bit(In_sync, &rdev->flags);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b91545ce090d..0ec555ada64a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8441,7 +8441,8 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 	return err;
 }
 
-static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
+static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev,
+			  struct queue_limits *lim)
 {
 	struct r5conf *conf = mddev->private;
 	int ret, err = -EEXIST;
@@ -8728,7 +8729,7 @@ static int raid5_start_reshape(struct mddev *mddev)
 		rdev_for_each(rdev, mddev)
 			if (rdev->raid_disk < 0 &&
 			    !test_bit(Faulty, &rdev->flags)) {
-				if (raid5_add_disk(mddev, rdev) == 0) {
+				if (raid5_add_disk(mddev, rdev, NULL) == 0) {
 					if (rdev->raid_disk
 					    >= conf->previous_raid_disks)
 						set_bit(In_sync, &rdev->flags);
-- 
2.43.0

