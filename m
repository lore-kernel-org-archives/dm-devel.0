Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01D742AF9A
	for <dm-devel@lists.linux.dev>; Thu, 10 Sep 2026 08:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789027889; cv=none; b=cEL0g7U2W4svsd3oNyT0JNms938Gbd/koP36VBv/XQN3pOQ2SXYe0dlxjsIgqkF9uxu/rXkla9HhdEa7/svnXrOuXx7y30TieZhLYIWgvF6mt9+m624dJcIb7nmEcc1A192zI6WKNr7AOyMvHdGw3d2LFoteEB+/rZ0dLkWoEaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789027889; c=relaxed/simple;
	bh=ynYT4EzKnNUSkgWF8hXf0jG1Wiv30hWQLHY1SYDfJJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dODCRQDSz83rILc/IyvC5mSlhRbpPORcqQm2ATRx44Ouen3HK2IM4ILRU9TdkpEr5UEEL0lMvK08dDb+RmlAIVq4uycLrkBhApKpeuB7brW9fGShH90L2AA35hEZi8rHbU6rp1XNOI8Qe23xdPlaAKaw7ybZyWbO+yahXp7M1jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=KGud+rXy; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="KGud+rXy"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b0dd3e1d0so2385955e9.0
        for <dm-devel@lists.linux.dev>; Thu, 10 Sep 2026 01:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1789027883; x=1789632683; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j936Hj+jQ6YcD/IvnzaDTxAfd7nwTnGHxjharHQeJpA=;
        b=KGud+rXy1tIcP7LiC9Gerd26uX4PPIB1fCDC5XHkYxIZOAqKu3XvqVAQlBCmXZ50dT
         pl8aHQmgblaWehF9/gjW2v7/laBuuO6ke4tnmELyTvQJU8s65LMwJklJlLBCck0kZXEz
         n/ffy3xGrQ/Q0qyoPc6EjCnAPJuhstVhjrFbzLkOyJTX0IsMlCNx4gbT3Cpj2xeCVVUx
         Bv7MB0aeOdbp05Y8bFaJxId+7Kq3eL8DDSmdyoWOI5FeQMOEYm/J1fZXpEFLfd5pewqX
         Z9XMnuPgsXIt96ODaIpe2L3YorWjedKSWa9QcHP/A+tvq9wEjJXXqB8v/QGsllGPZBHO
         Pz9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789027883; x=1789632683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=j936Hj+jQ6YcD/IvnzaDTxAfd7nwTnGHxjharHQeJpA=;
        b=CxDbK0Dw5GNCzuWqExI+TKnk4CByc9r0cqQHv+V9Fl0BEph5G6zzkD75Ad79iJYctc
         XUVcluyEJDw3JoSrdJTplFrsNFCPMBcy7BsgJVZ9ycKM8ANmq85LWN3rfb13FtXClr+H
         P41AFLtE0MVmPEN8MOj+Vqm55gLrDIEe45HIe9lCdUrlRJkGQu5xwKX/aQ5jJNNMkFo5
         y/uOpIWtg16d3Ez1bXnTDeG0ZDp+15taab9DbGhwUlxRRpZlZzsWfiu7NsdMYzWsU9EP
         Gj1nEGhSYMRiUnNWXeyerBCdxVwMi9i9OBjmwvbrTNdQ4d3f8l83OWmnzaO9TflItRaL
         RWiA==
X-Forwarded-Encrypted: i=1; AKwUvBzRVYgshaZxuoT0CaCrkiGgEnWUuhBTNPs3nfAzABxqax65KipPzsSdOkV3cICSy6r94AWd/f1zzw==@lists.linux.dev
X-Gm-Message-State: AFuF++mezp8+/LutsyWtQENJg5GDhX4IuM3CX21YzKJJkGlY+f1sUnV5
	JxwHc91I5bQ5p9bPSZRu1u96FCuUzX3hb9lhB8dXgvRW8gbxzMQEi+CW2C07cEK3NIc=
X-Gm-Gg: AYBFou0Zr/Qv7IxttEJK9WmfN0Hz625ye141BVzY9pE9qWBHvCYW7m59D91yFBPVkA/
	lfauupu8xRvMavpb6cwNqFhiuWdMfPFyPDRjUn96ffX6hM118EETv8wCdNIvc3UP0hyWxYUZbU1
	efm/6rFbCKLRlhKavXZZcdpKZyvNyBsjcFMWNT/HZd69g3Y/F87ZOiUPVucNjm9E9W3ZIeOaEpH
	HmtkZMEmmj4y/64qzO39pRwm641hfGncjVJ0QInfSVDWY9j22y60mtSzLgFb85rc12BENkF8vB+
	zKcCWcdPUgV+7uADknCcmOI+4+qxWdY7V7s7/mNk7He9RWRzkB6fFcSVaMwGbFQXxe3vK2p+Y5a
	yhD7v0/fnGoGu9Bt+XVwQWWutV+LY8NXPnEn/hOWDnV9qBnPIhVPEm8zH+fYeAG37YTPEb0rXTL
	HSLCVDsIZ9TpIOCFybTctE5ngSoxGaoPILV7uj15/mJl64qER5HZ8tDig0jCi6aH98/+prdfm54
	Z3hCghF+CZczkeLGin8uyfqIC1g1XSidcgLobw5u1xP
X-Received: by 2002:a05:600c:c494:b0:499:d95a:41f with SMTP id 5b1f17b1804b1-49d010c3969mr295917585e9.0.1789027882630;
        Thu, 10 Sep 2026 01:11:22 -0700 (PDT)
Received: from jwang-ThinkPad-T14-Gen-6.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d20fc1be3sm55261135e9.4.2026.09.10.01.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 01:11:21 -0700 (PDT)
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
Subject: [PATCH v2 5/8] md: take q->limits_lock before locking and suspending the array
Date: Thu, 10 Sep 2026 10:11:10 +0200
Message-ID: <20260910081114.1605746-6-jinpu.wang@ionos.com>
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

Writing a queue limits attribute while a spare is re-added deadlocks the
array:

  udev-worker    queue_attr_store() holds q->limits_lock, waits in
                 blk_mq_freeze_queue() for q_usage_counter to drain
  fio            holds a q_usage_counter reference, parked in
                 md_handle_request()'s is_suspended() loop
  mdadm          suspended the array, waits for reconfig_mutex
  md_start_sync  holds reconfig_mutex, waits for q->limits_lock

Blocking on q->limits_lock while holding reconfig_mutex, or with the
array suspended, is waiting for normal I/O, which mddev_suspend()
already warns about with lockdep_assert_not_held().  So q->limits_lock
has to nest outside both.

Take the update before the array is locked and suspended, and pass it
down so the personality stacks into it:

  - md_start_sync(), at both suspend points
  - md_ioctl() for ADD_NEW_DISK and HOT_REMOVE_DISK
  - rdev_attr_store(), for slot and for state "remove"/"re-add"
  - raid5 skip_copy_store(), which took the lock while suspended

They are converted together because a mix of the two orders is an ABBA.
All of them commit while the array is still quiesced.

Two callers still take the lock inside reconfig_mutex with the array
suspended: ->start_reshape() from action_store(), which suspends before
flushing sync_work so the update cannot be held across it, and
raid*_run() from level_store(), which a later patch converts.

Verified with a raid1 of two ram devices, fio in flight and a loop
writing queue/max_sectors_kb: 20 fail/remove/add cycles complete, where
the same test wedges the array before the change.

Fixes: c99f66e4084a ("block: fix queue freeze vs limits lock order in sysfs store methods")
Assisted-by: LLM
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/md/md-autodetect.c |   2 +-
 drivers/md/md.c            | 120 +++++++++++++++++++++++++++++++------
 drivers/md/md.h            |   3 +-
 drivers/md/raid5.c         |  31 +++++++---
 4 files changed, 128 insertions(+), 28 deletions(-)

diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
index 4b80165afd23..929513109657 100644
--- a/drivers/md/md-autodetect.c
+++ b/drivers/md/md-autodetect.c
@@ -213,7 +213,7 @@ static void __init md_setup_drive(struct md_setup_args *args)
 				(1 << MD_DISK_ACTIVE) | (1 << MD_DISK_SYNC);
 		}
 
-		md_add_new_disk(mddev, &dinfo);
+		md_add_new_disk(mddev, &dinfo, NULL);
 	}
 
 	if (!err)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 87e17ba86d93..0668a048db71 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2983,7 +2983,7 @@ void md_update_sb(struct mddev *mddev, int force_change)
 }
 EXPORT_SYMBOL(md_update_sb);
 
-static int add_bound_rdev(struct md_rdev *rdev)
+static int add_bound_rdev(struct md_rdev *rdev, struct queue_limits *lim)
 {
 	struct mddev *mddev = rdev->mddev;
 	int err = 0;
@@ -2996,7 +2996,7 @@ static int add_bound_rdev(struct md_rdev *rdev)
 		 */
 		super_types[mddev->major_version].
 			validate_super(mddev, NULL/*freshest*/, rdev);
-		err = mddev->pers->hot_add_disk(mddev, rdev, NULL);
+		err = mddev->pers->hot_add_disk(mddev, rdev, lim);
 		if (err) {
 			md_kick_rdev_from_array(rdev);
 			return err;
@@ -3119,7 +3119,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len,
 	} else if (cmd_match(buf, "remove")) {
 		if (rdev->mddev->pers) {
 			clear_bit(Blocked, &rdev->flags);
-			remove_and_add_spares(rdev->mddev, rdev, NULL);
+			remove_and_add_spares(rdev->mddev, rdev, lim);
 		}
 		if (rdev->raid_disk >= 0)
 			err = -EBUSY;
@@ -3238,7 +3238,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len,
 			if (!mddev_is_clustered(rdev->mddev) ||
 			    (err = mddev->cluster_ops->gather_bitmaps(rdev)) == 0) {
 				clear_bit(Faulty, &rdev->flags);
-				err = add_bound_rdev(rdev);
+				err = add_bound_rdev(rdev, lim);
 			}
 		} else
 			err = -EBUSY;
@@ -3325,7 +3325,7 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len,
 		if (rdev->mddev->pers->hot_remove_disk == NULL)
 			return -EINVAL;
 		clear_bit(Blocked, &rdev->flags);
-		remove_and_add_spares(rdev->mddev, rdev, NULL);
+		remove_and_add_spares(rdev->mddev, rdev, lim);
 		if (rdev->raid_disk >= 0)
 			return -EBUSY;
 		set_bit(MD_RECOVERY_NEEDED, &rdev->mddev->recovery);
@@ -3356,7 +3356,7 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len,
 		clear_bit(In_sync, &rdev->flags);
 		clear_bit(Bitmap_sync, &rdev->flags);
 		err = rdev->mddev->pers->hot_add_disk(rdev->mddev, rdev,
-						     NULL);
+						     lim);
 		if (err) {
 			rdev->raid_disk = -1;
 			return err;
@@ -3762,6 +3762,9 @@ rdev_attr_store(struct kobject *kobj, struct attribute *attr,
 	struct rdev_sysfs_entry *entry = container_of(attr, struct rdev_sysfs_entry, attr);
 	struct md_rdev *rdev = container_of(kobj, struct md_rdev, kobj);
 	struct kernfs_node *kn = NULL;
+	struct request_queue *q = NULL;
+	struct queue_limits lim;
+	struct queue_limits *limp = NULL;
 	bool suspend = false;
 	ssize_t rv;
 	struct mddev *mddev = READ_ONCE(rdev->mddev);
@@ -3782,15 +3785,41 @@ rdev_attr_store(struct kobject *kobj, struct attribute *attr,
 			suspend = true;
 	}
 
+	/*
+	 * These can add a leg back, which stacks its limits; the other
+	 * state_store() values never reach ->hot_add_disk().  q->limits_lock
+	 * nests outside the lock and the suspend, see md_start_sync().
+	 */
+	if ((entry->store == slot_store ||
+	     (entry->store == state_store &&
+	      (cmd_match(page, "remove") || cmd_match(page, "re-add")))) &&
+	    !mddev_is_dm(mddev)) {
+		q = mddev->gendisk->queue;
+		lim = queue_limits_start_update(q);
+		limp = &lim;
+	}
+
 	rv = suspend ? mddev_suspend_and_lock(mddev) : mddev_lock(mddev);
 	if (!rv) {
 		if (rdev->mddev == NULL)
 			rv = -ENODEV;
 		else
-			rv = entry->store(rdev, page, length, NULL);
+			rv = entry->store(rdev, page, length, limp);
+		/* apply the limits before the array takes I/O again */
+		if (limp) {
+			int err = queue_limits_commit_update(q, limp);
+
+			limp = NULL;
+			if (err && rv >= 0)
+				rv = err;
+		}
 		suspend ? mddev_unlock_and_resume(mddev) : mddev_unlock(mddev);
 	}
 
+	/* only reached when the lock failed, so nothing was stacked */
+	if (limp)
+		queue_limits_cancel_update(q);
+
 	if (kn)
 		sysfs_unbreak_active_protection(kn);
 
@@ -7575,7 +7604,8 @@ static int get_disk_info(struct mddev *mddev, void __user * arg)
 	return 0;
 }
 
-int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
+int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info,
+		    struct queue_limits *lim)
 {
 	struct md_rdev *rdev;
 	dev_t dev = MKDEV(info->major,info->minor);
@@ -7723,11 +7753,11 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
 				if (err)
 					mddev->cluster_ops->add_new_disk_cancel(mddev);
 				else
-					err = add_bound_rdev(rdev);
+					err = add_bound_rdev(rdev, lim);
 			}
 
 		} else if (!err)
-			err = add_bound_rdev(rdev);
+			err = add_bound_rdev(rdev, lim);
 
 		return err;
 	}
@@ -7780,7 +7810,8 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
 	return 0;
 }
 
-static int hot_remove_disk(struct mddev *mddev, dev_t dev)
+static int hot_remove_disk(struct mddev *mddev, dev_t dev,
+			   struct queue_limits *lim)
 {
 	struct md_rdev *rdev;
 
@@ -7795,7 +7826,7 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 		goto kick_rdev;
 
 	clear_bit(Blocked, &rdev->flags);
-	remove_and_add_spares(mddev, rdev, NULL);
+	remove_and_add_spares(mddev, rdev, lim);
 
 	if (rdev->raid_disk >= 0)
 		goto busy;
@@ -8380,6 +8411,22 @@ static inline int md_ioctl_valid(unsigned int cmd)
 	}
 }
 
+/*
+ * Commands that can reach ->hot_add_disk().  ADD_NEW_DISK only does so for a
+ * journal device or a personality without ->hot_remove_disk, but that depends
+ * on disk info still in user memory here, so it is included as a whole.
+ */
+static bool md_ioctl_may_add_disk(unsigned int cmd)
+{
+	switch (cmd) {
+	case ADD_NEW_DISK:
+	case HOT_REMOVE_DISK:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static bool md_ioctl_need_suspend(unsigned int cmd)
 {
 	switch (cmd) {
@@ -8435,6 +8482,9 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 	unsigned int noio_flags = 0;
 	void __user *argp = (void __user *)arg;
 	struct mddev *mddev = NULL;
+	struct request_queue *q = NULL;
+	struct queue_limits lim;
+	struct queue_limits *limp = NULL;
 	bool suspend;
 
 	err = md_ioctl_valid(cmd);
@@ -8485,11 +8535,20 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 	if (!md_is_rdwr(mddev))
 		flush_work(&mddev->sync_work);
 
+	/* q->limits_lock nests outside both, see md_start_sync() */
+	if (md_ioctl_may_add_disk(cmd) && !mddev_is_dm(mddev)) {
+		q = mddev->gendisk->queue;
+		lim = queue_limits_start_update(q);
+		limp = &lim;
+	}
+
 	suspend = md_ioctl_need_suspend(cmd);
 	err = suspend ? mddev_suspend_and_lock(mddev) : mddev_lock(mddev);
 	if (err) {
 		pr_debug("md: ioctl lock interrupted, reason %d, cmd %d\n",
 			 err, cmd);
+		if (limp)
+			queue_limits_cancel_update(q);
 		goto out;
 	}
 	if (suspend)
@@ -8531,7 +8590,7 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 		goto unlock;
 
 	case HOT_REMOVE_DISK:
-		err = hot_remove_disk(mddev, new_decode_dev(arg));
+		err = hot_remove_disk(mddev, new_decode_dev(arg), limp);
 		goto unlock;
 
 	case ADD_NEW_DISK:
@@ -8547,7 +8606,7 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 				/* Need to clear read-only for this */
 				break;
 			else
-				err = md_add_new_disk(mddev, &info);
+				err = md_add_new_disk(mddev, &info, limp);
 			goto unlock;
 		}
 		break;
@@ -8585,7 +8644,7 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 		if (copy_from_user(&info, argp, sizeof(info)))
 			err = -EFAULT;
 		else
-			err = md_add_new_disk(mddev, &info);
+			err = md_add_new_disk(mddev, &info, limp);
 		goto unlock;
 	}
 
@@ -8618,6 +8677,9 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 	    err != -EINVAL)
 		mddev->hold_active = 0;
 
+	if (limp)
+		err = queue_limits_commit_update(q, limp) ?: err;
+
 	if (suspend) {
 		memalloc_noio_restore(noio_flags);
 		mddev_unlock_and_resume(mddev);
@@ -10346,6 +10408,9 @@ static bool md_choose_sync_action(struct mddev *mddev, int *spares,
 static void md_start_sync(struct work_struct *ws)
 {
 	struct mddev *mddev = container_of(ws, struct mddev, sync_work);
+	struct request_queue *q = NULL;
+	struct queue_limits lim;
+	struct queue_limits *limp = NULL;
 	int spares = 0;
 	bool suspend = false;
 	unsigned int noio_flags = 0;
@@ -10357,6 +10422,17 @@ static void md_start_sync(struct work_struct *ws)
 	 */
 	if ((mddev->reshape_position == MaxSector || !md_is_rdwr(mddev)) &&
 	    md_spares_need_change(mddev)) {
+		/*
+		 * Adding a spare below stacks its limits, which needs
+		 * q->limits_lock.  Take it before suspending: its holder
+		 * waits in blk_mq_freeze_queue() for I/O that
+		 * mddev->suspended holds back, so the other order deadlocks.
+		 */
+		if (!mddev_is_dm(mddev)) {
+			q = mddev->gendisk->queue;
+			lim = queue_limits_start_update(q);
+			limp = &lim;
+		}
 		suspend = true;
 		mddev_suspend(mddev, false);
 		noio_flags = memalloc_noio_save();
@@ -10371,6 +10447,12 @@ static void md_start_sync(struct work_struct *ws)
 	if (!suspend && (mddev->reshape_position == MaxSector || !md_is_rdwr(mddev)) &&
 	    md_spares_need_change(mddev)) {
 		mddev_unlock(mddev);
+		/* see above: q->limits_lock nests outside both */
+		if (!mddev_is_dm(mddev)) {
+			q = mddev->gendisk->queue;
+			lim = queue_limits_start_update(q);
+			limp = &lim;
+		}
 		mddev_suspend_and_lock_nointr(mddev);
 		suspend = true;
 		noio_flags = memalloc_noio_save();
@@ -10384,11 +10466,11 @@ static void md_start_sync(struct work_struct *ws)
 		 * As we only add devices that are already in-sync, we can
 		 * activate the spares immediately.
 		 */
-		remove_and_add_spares(mddev, NULL, NULL);
+		remove_and_add_spares(mddev, NULL, limp);
 		goto not_running;
 	}
 
-	if (!md_choose_sync_action(mddev, &spares, NULL))
+	if (!md_choose_sync_action(mddev, &spares, limp))
 		goto not_running;
 
 	if (!mddev->pers->sync_request)
@@ -10419,6 +10501,8 @@ static void md_start_sync(struct work_struct *ws)
 	 *     https://bugzilla.kernel.org/show_bug.cgi?id=218200
 	 * Therefore, use __mddev_resume(mddev, false).
 	 */
+	if (limp && queue_limits_commit_update(q, limp))
+		pr_err("%s: could not apply queue limits\n", mdname(mddev));
 	if (suspend) {
 		memalloc_noio_restore(noio_flags);
 		__mddev_resume(mddev, false);
@@ -10441,6 +10525,8 @@ static void md_start_sync(struct work_struct *ws)
 	 *     https://bugzilla.kernel.org/show_bug.cgi?id=218200
 	 * Therefore, use __mddev_resume(mddev, false).
 	 */
+	if (limp && queue_limits_commit_update(q, limp))
+		pr_err("%s: could not apply queue limits\n", mdname(mddev));
 	if (suspend) {
 		memalloc_noio_restore(noio_flags);
 		__mddev_resume(mddev, false);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 1b2e8720f0d1..7f4e3ea8b826 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -1046,7 +1046,8 @@ struct mdu_disk_info_s;
 extern int mdp_major;
 void md_autostart_arrays(int part);
 int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info);
-int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info);
+int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info,
+		    struct queue_limits *lim);
 int do_md_run(struct mddev *mddev);
 #define MDDEV_STACK_INTEGRITY	(1u << 0)
 int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3faa2a94c03b..22759c631c4d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7288,6 +7288,9 @@ static ssize_t
 raid5_store_skip_copy(struct mddev *mddev, const char *page, size_t len)
 {
 	struct r5conf *conf;
+	struct request_queue *q = NULL;
+	struct queue_limits lim;
+	struct queue_limits *limp = NULL;
 	unsigned long new;
 	int err;
 
@@ -7297,23 +7300,33 @@ raid5_store_skip_copy(struct mddev *mddev, const char *page, size_t len)
 		return -EINVAL;
 	new = !!new;
 
+	/* q->limits_lock nests outside both, see md_start_sync() */
+	if (!mddev_is_dm(mddev)) {
+		q = mddev->gendisk->queue;
+		lim = queue_limits_start_update(q);
+		limp = &lim;
+	}
+
 	err = mddev_suspend_and_lock(mddev);
-	if (err)
+	if (err) {
+		if (limp)
+			queue_limits_cancel_update(q);
 		return err;
+	}
 	conf = mddev->private;
 	if (!conf)
 		err = -ENODEV;
 	else if (new != conf->skip_copy) {
-		struct request_queue *q = mddev->gendisk->queue;
-		struct queue_limits lim = queue_limits_start_update(q);
-
 		conf->skip_copy = new;
-		if (new)
-			lim.features |= BLK_FEAT_STABLE_WRITES;
-		else
-			lim.features &= ~BLK_FEAT_STABLE_WRITES;
-		err = queue_limits_commit_update(q, &lim);
+		if (limp) {
+			if (new)
+				limp->features |= BLK_FEAT_STABLE_WRITES;
+			else
+				limp->features &= ~BLK_FEAT_STABLE_WRITES;
+		}
 	}
+	if (limp)
+		err = queue_limits_commit_update(q, limp) ?: err;
 	mddev_unlock_and_resume(mddev);
 	return err ?: len;
 }
-- 
2.43.0

