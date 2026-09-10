Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3D542E415
	for <dm-devel@lists.linux.dev>; Thu, 10 Sep 2026 08:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789027891; cv=none; b=Ybm/xS/YSQ4eFIhqHiZUDkTogo7wNCo63UUb2tSHE+wc2eOCi0+Fv2H0LuAOIgo2akr+E3SkdiD0V/dRhnoy6lcOGBwFqI2ajqilvMsSct1q3AWJFlk9KJMiF+XyRUORqsdZHcTj9iw1TDHPNPGX/QcIv6herKu6FvbzPUpc7/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789027891; c=relaxed/simple;
	bh=nnUwbAGw66z8p9c5609SWShTLPj32yaDP8/9sn1ddGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGVnvhR/4C3S6ySvSNtkPlLzhh25KcPk6X6VRyIB7MtAP5y5rzAR0jiVFXG87Bwz8q0beBYRlJ9W5BzJj8COswnvJU9YZcj+VmZ7Ns6KCFCrS59nYCHp+O5LkAN8rJ8xBFc8oGpWWZvzYOtYVdQGi+9PcqQ9r0/H9DTWSSFCCTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=Mhuiq1wY; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="Mhuiq1wY"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-499db1740e4so3233345e9.0
        for <dm-devel@lists.linux.dev>; Thu, 10 Sep 2026 01:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1789027885; x=1789632685; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MhyUVR5/3y9z/7b63ssenZZXMXcVxCwIZBzS9kva6Eg=;
        b=Mhuiq1wYb+i0BCF9GqNOfoGPyZpB+1lUsMJl+AGwuLriEba9KMajPeDbgcvT1bpAQf
         EQCHMO/tv7b24g2/1Qrjcy+r6e4yoe++NGUWMSnWJlgTiMMF137+ieis9wJDFkzdftCA
         cI9Bngha3UtHaaCq0yw9tFWigAJMkq+AbSi13AAVcW+NHkFhsJzrnG5JYg1uqAv3ykQt
         VhH7WXDZ3NBDF1Nfx6T9HYqE80waMF1RQ/DoQSjM+2O23DUwO1/6uEBIC0qHWD7nlITg
         GWIQHG4Sbo0UqeWWKt98hKkyPCmpJcO0PGQcNmLE5rzcSA13UTUgvFDzF+hQyuQ8R6hA
         PTzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789027885; x=1789632685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MhyUVR5/3y9z/7b63ssenZZXMXcVxCwIZBzS9kva6Eg=;
        b=BGlpGxglz4W/jzIhm4V1haJUWQoRbAD+p5PQuZi1sawp7vcnfELhTyFYv17XzEigk6
         1Mx8AdP6iWhclb0/Z8hQ4Zbcfskp8Sza8lRmf1F6vF6cNTlnOhleqmQ3gZpySSmHPgaG
         ZNnxAiJmF60pzfWAUp1RGUco2wvWVS5QvFLHCCoO7dFC+Ycqx3TqSeKbwKlD8UFGusH9
         rtC20rWWUpCbFGo/FN7C1yNguWJeSH3hIGyBMlnN+kTeqGy5zMYq27nMqUxiPUnLwmHy
         nmPMSrLrFMFB0CXDwiSSys+u8kR1W7RNLjvK2uFH5wnM/Co5ma6LkrjO4t7oV1OfolOw
         8TBA==
X-Forwarded-Encrypted: i=1; AKwUvBxiAle+82mWchPJdj98LxqG0iFSNeTGcXY7eV42+otnj1f+m940AKbTcj85UvIYrwQtGGcoHWHXhA==@lists.linux.dev
X-Gm-Message-State: AFuF++lr/U0vHBhc1RBjIiaeFbwTFh6yb17398eRIi49CWtZoAQy8iDG
	x82EdB6qCXjMV+O2wkN15h593WQgXI2jzgsKRPbpktpOPP/l6u88YKCddJrJZH83160=
X-Gm-Gg: AYBFou3KQMmNtbW2CNwSN8cYtSMSgk25NWnBUQXw2nfIeTcg4vaffWXrQelorBMzTha
	yLGubLQr9wtNcXyXezPE0FWt7AyhI4JWb24cTzkqPcWQzRer7mFLpzTAwMKv41d53KjQFcqDn/l
	0Lay8C2n9COvTJfBlUuYHx7ylS047PedjJP2l752bvf3YTfkvMgpgpSnMMipopzrvwCVcw/JSDA
	CLg3shVcCptJ4prX8SIp5l7GmXHzFExveg3tDUTr3DfUqV/aaq0tYziZ/P35gv0FjYIeTJBkEZt
	C/+oQGZ/iBVomaT5296SFxyuTyrH9BnXt5vBcVEjKi/Jbjabtk7tBqKiEIWsKVM9cGATlTDFOdS
	WUjxw4GPbBjmwRg8dXHsgxRSastBnQxwEH3nfsICtVSbwf2CU4k4tcHpA1LAYaxlxingUdZqNLE
	cX+LQj2E/TJmFAO+gYHsJuNioTvoXcTgSIA50NZZXRs/JqGlzH6VIpLTyHMZ3ocgwtku2FuUSXa
	ImGo1DzkJBSw+62cMXFzv8HDQ15V9C5Cpamm43fgH30
X-Received: by 2002:a05:600c:6289:b0:49d:1da4:511b with SMTP id 5b1f17b1804b1-49d27670d04mr24484735e9.1.1789027884500;
        Thu, 10 Sep 2026 01:11:24 -0700 (PDT)
Received: from jwang-ThinkPad-T14-Gen-6.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d20fc1be3sm55261135e9.4.2026.09.10.01.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 01:11:23 -0700 (PDT)
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
Subject: [PATCH v2 6/8] md: pass a queue_limits through ->run()
Date: Thu, 10 Sep 2026 10:11:11 +0200
Message-ID: <20260910081114.1605746-7-jinpu.wang@ionos.com>
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

raid*_run() -> queue_limits_set() takes q->limits_lock with
reconfig_mutex held, the order the previous patches inverted.  With
lockdep on, creating an array and then adding a leg reports it:

  -> #1 (&q->limits_lock):        -> #0 (&mddev->reconfig_mutex):
       queue_limits_set                md_ioctl     <- ADD_NEW_DISK
       raid1_run
       do_md_run
       md_ioctl                   <- RUN_ARRAY

The earlier patch left this for level_store() alone; RUN_ARRAY reaches
it too, so every array creation records the wrong order.

Give ->run() a queue_limits argument and take the update at the entry
points that start an array: md_ioctl() for RUN_ARRAY, level_store(),
autorun_devices(), md_setup_drive(), and array_state_store() for
readonly, read_auto and active -- but only while mddev->pers is NULL,
as with the array running those states go to md_set_readonly(), which
waits in stop_sync_thread() for the work that takes the same lock.

dm-raid passes NULL: with no gendisk the personalities return before
touching any limits.

Assisted-by: LLM
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/md/dm-raid.c       |   2 +-
 drivers/md/md-autodetect.c |  21 ++++++-
 drivers/md/md-linear.c     |   4 +-
 drivers/md/md.c            | 116 +++++++++++++++++++++++++++++++------
 drivers/md/md.h            |  11 +++-
 drivers/md/raid0.c         |  16 ++++-
 drivers/md/raid1.c         |  16 ++++-
 drivers/md/raid10.c        |  16 ++++-
 drivers/md/raid5.c         |  16 ++++-
 9 files changed, 182 insertions(+), 36 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 21a1922bee4f..d043a5c49608 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3258,7 +3258,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	/* Keep array frozen until resume. */
 	md_frozen_sync_thread(&rs->md);
 
-	r = md_run(&rs->md);
+	r = md_run(&rs->md, NULL);
 	rs->md.in_sync = 0; /* Assume already marked dirty */
 	if (r) {
 		ti->error = "Failed to run raid array";
diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
index 929513109657..e15ae2fb58a2 100644
--- a/drivers/md/md-autodetect.c
+++ b/drivers/md/md-autodetect.c
@@ -126,6 +126,9 @@ static void __init md_setup_drive(struct md_setup_args *args)
 	dev_t devices[MD_SB_DISKS + 1], mdev;
 	struct mdu_array_info_s ainfo = { };
 	struct mddev *mddev;
+	struct request_queue *q = NULL;
+	struct queue_limits lim;
+	struct queue_limits *limp = NULL;
 	int err = 0, i;
 	char name[16];
 
@@ -216,11 +219,27 @@ static void __init md_setup_drive(struct md_setup_args *args)
 		md_add_new_disk(mddev, &dinfo, NULL);
 	}
 
+	/*
+	 * do_md_run() restacks the array's limits, and q->limits_lock must
+	 * not nest inside reconfig_mutex, so start the update with the array
+	 * unlocked.  This is __init and the array is not reachable yet.
+	 */
+	if (!err && !mddev_is_dm(mddev)) {
+		mddev_unlock(mddev);
+		q = mddev->gendisk->queue;
+		lim = queue_limits_start_update(q);
+		limp = &lim;
+		mddev_lock_nointr(mddev);
+	}
+
 	if (!err)
-		err = do_md_run(mddev);
+		err = do_md_run(mddev, limp);
 	if (err)
 		pr_warn("md: starting %s failed\n", name);
 out_unlock:
+	/* apply the limits before the array takes I/O */
+	if (limp)
+		queue_limits_commit_update(q, limp);
 	mddev_unlock_and_resume(mddev);
 out_mddev_put:
 	mddev_put(mddev);
diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index da82c313d459..5438c23a7242 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -178,7 +178,7 @@ static struct linear_conf *linear_conf(struct mddev *mddev, int raid_disks,
 	return ERR_PTR(ret);
 }
 
-static int linear_run(struct mddev *mddev)
+static int linear_run(struct mddev *mddev, struct queue_limits *lim)
 {
 	struct linear_conf *conf;
 	int ret;
@@ -186,7 +186,7 @@ static int linear_run(struct mddev *mddev)
 	if (md_check_no_bitmap(mddev))
 		return -EINVAL;
 
-	conf = linear_conf(mddev, mddev->raid_disks, NULL);
+	conf = linear_conf(mddev, mddev->raid_disks, lim);
 	if (IS_ERR(conf))
 		return PTR_ERR(conf);
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0668a048db71..5be956e80563 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4105,13 +4105,30 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	long level;
 	void *priv, *oldpriv;
 	struct md_rdev *rdev;
+	struct request_queue *q = NULL;
+	struct queue_limits lim;
+	struct queue_limits *limp = NULL;
 
 	if (slen == 0 || slen >= sizeof(clevel))
 		return -EINVAL;
 
+	/*
+	 * The new personality restacks the array's queue limits in ->run(),
+	 * and q->limits_lock has to be taken before the array is locked and
+	 * suspended, see md_start_sync().
+	 */
+	if (!mddev_is_dm(mddev)) {
+		q = mddev->gendisk->queue;
+		lim = queue_limits_start_update(q);
+		limp = &lim;
+	}
+
 	rv = mddev_suspend_and_lock(mddev);
-	if (rv)
+	if (rv) {
+		if (limp)
+			queue_limits_cancel_update(q);
 		return rv;
+	}
 	noio_flags = memalloc_noio_save();
 
 	if (mddev->pers == NULL) {
@@ -4280,7 +4297,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->in_sync = 1;
 		timer_delete_sync(&mddev->safemode_timer);
 	}
-	pers->run(mddev);
+	pers->run(mddev, limp);
 	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 	if (!mddev->thread)
 		md_update_sb(mddev, 1);
@@ -4288,6 +4305,9 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	md_new_event();
 	rv = len;
 out_unlock:
+	/* apply the limits before the array takes I/O again */
+	if (limp)
+		rv = queue_limits_commit_update(q, limp) ?: rv;
 	memalloc_noio_restore(noio_flags);
 	mddev_unlock_and_resume(mddev);
 	return rv;
@@ -4708,6 +4728,10 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	int err = 0;
 	enum array_state st = match_word(buf, array_states);
+	bool starts_array, need_lim;
+	struct request_queue *q = NULL;
+	struct queue_limits lim;
+	struct queue_limits *limp = NULL;
 
 	/* No lock dependent actions */
 	switch (st) {
@@ -4753,9 +4777,39 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 		spin_unlock(&mddev->lock);
 		return err ?: len;
 	}
+
+	/*
+	 * These states start the array when it is not running, and ->run()
+	 * restacks its limits, so take q->limits_lock first.  Only then:
+	 * with mddev->pers set they go to md_set_readonly(), which waits for
+	 * the very work that takes the same lock.
+	 */
+	starts_array = (st == readonly || st == read_auto || st == active) &&
+		       !mddev_is_dm(mddev);
+retry:
+	need_lim = starts_array && !READ_ONCE(mddev->pers);
+	if (need_lim) {
+		q = mddev->gendisk->queue;
+		lim = queue_limits_start_update(q);
+		limp = &lim;
+	}
+
 	err = mddev_lock(mddev);
-	if (err)
+	if (err) {
+		if (limp)
+			queue_limits_cancel_update(q);
 		return err;
+	}
+
+	/* mddev->pers was read without the lock, so redo it if it changed */
+	if (need_lim != (starts_array && !mddev->pers)) {
+		mddev_unlock(mddev);
+		if (limp) {
+			queue_limits_cancel_update(q);
+			limp = NULL;
+		}
+		goto retry;
+	}
 
 	switch (st) {
 	case inactive:
@@ -4772,7 +4826,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 		else {
 			mddev->ro = MD_RDONLY;
 			set_disk_ro(mddev->gendisk, 1);
-			err = do_md_run(mddev);
+			err = do_md_run(mddev, limp);
 		}
 		break;
 	case read_auto:
@@ -4787,7 +4841,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 			}
 		} else {
 			mddev->ro = MD_AUTO_READ;
-			err = do_md_run(mddev);
+			err = do_md_run(mddev, limp);
 		}
 		break;
 	case clean:
@@ -4813,7 +4867,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 		} else {
 			mddev->ro = MD_RDWR;
 			set_disk_ro(mddev->gendisk, 0);
-			err = do_md_run(mddev);
+			err = do_md_run(mddev, limp);
 		}
 		break;
 	default:
@@ -4826,6 +4880,9 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 			mddev->hold_active = 0;
 		sysfs_notify_dirent_safe(mddev->sysfs_state);
 	}
+	/* apply the limits before the array takes I/O */
+	if (limp)
+		err = queue_limits_commit_update(q, limp) ?: err;
 	mddev_unlock(mddev);
 
 	if (st == readonly || st == read_auto || st == inactive ||
@@ -6763,7 +6820,7 @@ static void md_bitmap_set_none(struct mddev *mddev)
 		md_bitmap_sysfs_add(mddev);
 }
 
-int md_run(struct mddev *mddev)
+int md_run(struct mddev *mddev, struct queue_limits *lim)
 {
 	int err;
 	struct md_rdev *rdev;
@@ -6892,7 +6949,7 @@ int md_run(struct mddev *mddev)
 	if (start_readonly && md_is_rdwr(mddev))
 		mddev->ro = MD_AUTO_READ; /* read-only, but switch on first write */
 
-	err = pers->run(mddev);
+	err = pers->run(mddev, lim);
 	if (err)
 		pr_warn("md: pers->run() failed ...\n");
 	else if (pers->size(mddev, 0, 0) < mddev->array_sectors) {
@@ -6988,12 +7045,12 @@ int md_run(struct mddev *mddev)
 }
 EXPORT_SYMBOL_GPL(md_run);
 
-int do_md_run(struct mddev *mddev)
+int do_md_run(struct mddev *mddev, struct queue_limits *lim)
 {
 	int err;
 
 	set_bit(MD_NOT_READY, &mddev->flags);
-	err = md_run(mddev);
+	err = md_run(mddev, lim);
 	if (err)
 		goto out;
 
@@ -7349,7 +7406,7 @@ static int do_md_stop(struct mddev *mddev, int mode)
 }
 
 #ifndef MODULE
-static void autorun_array(struct mddev *mddev)
+static void autorun_array(struct mddev *mddev, struct queue_limits *lim)
 {
 	struct md_rdev *rdev;
 	int err;
@@ -7364,7 +7421,7 @@ static void autorun_array(struct mddev *mddev)
 	}
 	pr_cont("\n");
 
-	err = do_md_run(mddev);
+	err = do_md_run(mddev, lim);
 	if (err) {
 		pr_warn("md: do_md_run() returned %d\n", err);
 		do_md_stop(mddev, 0);
@@ -7387,6 +7444,9 @@ static void autorun_devices(int part)
 {
 	struct md_rdev *rdev0, *rdev, *tmp;
 	struct mddev *mddev;
+	struct request_queue *q = NULL;
+	struct queue_limits lim;
+	struct queue_limits *limp = NULL;
 
 	pr_info("md: autorun ...\n");
 	while (!list_empty(&pending_raid_disks)) {
@@ -7427,12 +7487,29 @@ static void autorun_devices(int part)
 		if (IS_ERR(mddev))
 			break;
 
-		if (mddev_suspend_and_lock(mddev))
+		/*
+		 * autorun_array() runs the array, which restacks its limits;
+		 * q->limits_lock has to be taken before the array is locked
+		 * and suspended, see md_start_sync().
+		 */
+		if (!mddev_is_dm(mddev)) {
+			q = mddev->gendisk->queue;
+			lim = queue_limits_start_update(q);
+			limp = &lim;
+		}
+
+		if (mddev_suspend_and_lock(mddev)) {
 			pr_warn("md: %s locked, cannot run\n", mdname(mddev));
-		else if (mddev->raid_disks || mddev->major_version
+			if (limp) {
+				queue_limits_cancel_update(q);
+				limp = NULL;
+			}
+		} else if (mddev->raid_disks || mddev->major_version
 			 || !list_empty(&mddev->disks)) {
 			pr_warn("md: %s already running, cannot run %pg\n",
 				mdname(mddev), rdev0->bdev);
+			if (limp)
+				queue_limits_cancel_update(q);
 			mddev_unlock_and_resume(mddev);
 		} else {
 			pr_debug("md: created %s\n", mdname(mddev));
@@ -7442,9 +7519,13 @@ static void autorun_devices(int part)
 				if (bind_rdev_to_array(rdev, mddev))
 					export_rdev(rdev);
 			}
-			autorun_array(mddev);
+			autorun_array(mddev, limp);
+			if (limp && queue_limits_commit_update(q, limp))
+				pr_warn("md: %s: could not apply queue limits\n",
+					mdname(mddev));
 			mddev_unlock_and_resume(mddev);
 		}
+		limp = NULL;
 		/* on success, candidates will be empty, on error
 		 * it won't...
 		 */
@@ -8536,7 +8617,8 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 		flush_work(&mddev->sync_work);
 
 	/* q->limits_lock nests outside both, see md_start_sync() */
-	if (md_ioctl_may_add_disk(cmd) && !mddev_is_dm(mddev)) {
+	if ((md_ioctl_may_add_disk(cmd) || cmd == RUN_ARRAY) &&
+	    !mddev_is_dm(mddev)) {
 		q = mddev->gendisk->queue;
 		lim = queue_limits_start_update(q);
 		limp = &lim;
@@ -8660,7 +8742,7 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 		goto unlock;
 
 	case RUN_ARRAY:
-		err = do_md_run(mddev);
+		err = do_md_run(mddev, limp);
 		goto unlock;
 
 	case SET_BITMAP_FILE:
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 7f4e3ea8b826..73f6ef20f266 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -760,7 +760,12 @@ struct md_personality
 	 * start up works that do NOT require md_thread. tasks that
 	 * requires md_thread should go into start()
 	 */
-	int (*run)(struct mddev *mddev);
+	/*
+	 * @lim: a queue limits update the caller owns, or NULL.  Non-NULL
+	 * means stack into it rather than take q->limits_lock, which has to
+	 * nest outside reconfig_mutex, see md_start_sync().
+	 */
+	int (*run)(struct mddev *mddev, struct queue_limits *lim);
 	/* start up works that require md threads */
 	int (*start)(struct mddev *mddev);
 	void (*free)(struct mddev *mddev, void *priv);
@@ -959,7 +964,7 @@ extern void mddev_destroy(struct mddev *mddev);
 void md_init_stacking_limits(struct queue_limits *lim);
 struct mddev *md_alloc(dev_t dev, char *name);
 void mddev_put(struct mddev *mddev);
-extern int md_run(struct mddev *mddev);
+extern int md_run(struct mddev *mddev, struct queue_limits *lim);
 extern int md_start(struct mddev *mddev);
 extern void md_stop(struct mddev *mddev);
 extern void md_stop_writes(struct mddev *mddev);
@@ -1048,7 +1053,7 @@ void md_autostart_arrays(int part);
 int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info);
 int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info,
 		    struct queue_limits *lim);
-int do_md_run(struct mddev *mddev);
+int do_md_run(struct mddev *mddev, struct queue_limits *lim);
 #define MDDEV_STACK_INTEGRITY	(1u << 0)
 int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
 		unsigned int flags);
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 35e103f0c2c3..59141e4299a8 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -379,7 +379,8 @@ static void raid0_free(struct mddev *mddev, void *priv)
 	kfree(conf);
 }
 
-static int raid0_set_limits(struct mddev *mddev)
+static int raid0_set_limits(struct mddev *mddev,
+			    struct queue_limits *caller_lim)
 {
 	struct queue_limits lim;
 	int err;
@@ -398,10 +399,19 @@ static int raid0_set_limits(struct mddev *mddev)
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
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
 
-static int raid0_run(struct mddev *mddev)
+static int raid0_run(struct mddev *mddev, struct queue_limits *lim)
 {
 	struct r0conf *conf;
 	int ret;
@@ -414,7 +424,7 @@ static int raid0_run(struct mddev *mddev)
 		return -EINVAL;
 
 	if (!mddev_is_dm(mddev)) {
-		ret = raid0_set_limits(mddev);
+		ret = raid0_set_limits(mddev, lim);
 		if (ret)
 			return ret;
 	}
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 78effcac138d..6713a53fd460 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3170,7 +3170,8 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	return ERR_PTR(err);
 }
 
-static int raid1_set_limits(struct mddev *mddev)
+static int raid1_set_limits(struct mddev *mddev,
+			    struct queue_limits *caller_lim)
 {
 	struct queue_limits lim;
 	int err;
@@ -3185,10 +3186,19 @@ static int raid1_set_limits(struct mddev *mddev)
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
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
 
-static int raid1_run(struct mddev *mddev)
+static int raid1_run(struct mddev *mddev, struct queue_limits *lim)
 {
 	struct r1conf *conf;
 	int i;
@@ -3219,7 +3229,7 @@ static int raid1_run(struct mddev *mddev)
 		return PTR_ERR(conf);
 
 	if (!mddev_is_dm(mddev)) {
-		ret = raid1_set_limits(mddev);
+		ret = raid1_set_limits(mddev, lim);
 		if (ret) {
 			md_unregister_thread(mddev, &conf->thread);
 			if (!mddev->private)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5580ca77ef1e..16143db6085b 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3930,7 +3930,8 @@ static unsigned int raid10_nr_stripes(struct r10conf *conf)
 	return raid_disks / conf->geo.near_copies;
 }
 
-static int raid10_set_queue_limits(struct mddev *mddev)
+static int raid10_set_queue_limits(struct mddev *mddev,
+				   struct queue_limits *caller_lim)
 {
 	struct r10conf *conf = mddev->private;
 	struct queue_limits lim;
@@ -3948,10 +3949,19 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
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
 
-static int raid10_run(struct mddev *mddev)
+static int raid10_run(struct mddev *mddev, struct queue_limits *lim)
 {
 	struct r10conf *conf;
 	int i, disk_idx;
@@ -4020,7 +4030,7 @@ static int raid10_run(struct mddev *mddev)
 	}
 
 	if (!mddev_is_dm(conf->mddev)) {
-		int err = raid10_set_queue_limits(mddev);
+		int err = raid10_set_queue_limits(mddev, lim);
 
 		if (err) {
 			ret = err;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 22759c631c4d..28bd81de86c1 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7944,7 +7944,8 @@ static int raid5_create_ctx_pool(struct r5conf *conf)
 	return conf->ctx_pool ? 0 : -ENOMEM;
 }
 
-static int raid5_set_limits(struct mddev *mddev)
+static int raid5_set_limits(struct mddev *mddev,
+			    struct queue_limits *caller_lim)
 {
 	struct r5conf *conf = mddev->private;
 	struct queue_limits lim;
@@ -7996,10 +7997,19 @@ static int raid5_set_limits(struct mddev *mddev)
 	/* No restrictions on the number of segments in the request */
 	lim.max_segments = USHRT_MAX;
 
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
 
-static int raid5_run(struct mddev *mddev)
+static int raid5_run(struct mddev *mddev, struct queue_limits *lim)
 {
 	struct r5conf *conf;
 	int dirty_parity_disks = 0;
@@ -8259,7 +8269,7 @@ static int raid5_run(struct mddev *mddev)
 	md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
 
 	if (!mddev_is_dm(mddev)) {
-		ret = raid5_set_limits(mddev);
+		ret = raid5_set_limits(mddev, lim);
 		if (ret)
 			goto abort;
 	}
-- 
2.43.0

