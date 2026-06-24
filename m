Received: from va-2-26.ptr.blmpb.com (va-2-26.ptr.blmpb.com [209.127.231.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435C1156F45
	for <dm-devel@lists.linux.dev>; Wed, 24 Jun 2026 10:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782296205; cv=none; b=K1cJ66jlycu4TiWVqrevK0BgBceTa+qml321UKkLgYHCaB9yw+vDviN+UkegDzheyrDrkF7JAzaTB1TGGiMn5dwcV0YkQkQDD5R7mQ3IpWGgV/nkTITCqkhxiQ3/kC2HVINGtP7d9mAHts2TXtKpuAakNOQajzj/9OvZFNq+w+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782296205; c=relaxed/simple;
	bh=3GMbJvbooAPYDaZlfDhK0MVgY/W0y7K78346d0EWnBk=;
	h=Cc:Message-Id:Content-Type:To:Subject:Mime-Version:From:Date; b=sJPyu261UZ7wEUJ7ZYXlTVQdjuSJz9PZEk6bye4MFgmvBDutc/qkF2c0+UYxDqFYh6ps3P5+u16IXCVQ9kFABgOXQrCwc1KJxkyP3NF3J1dWAcwopKn2EVEO4+eXvsnSL1G8cWBOrr1kW6uH3tIH+y7Om89o2l8aIeG68WsokDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=cGAhJGOm; arc=none smtp.client-ip=209.127.231.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="cGAhJGOm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1782296046;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=f5UPUXThGsINPDNxiIeyYq1ayvvryLh1BHA0V8rHdtQ=;
 b=cGAhJGOm485Ise43YtfixDblSI0Xl6FEEFz1Wzokso0IqN4cR/HBjtprryDgvQ3oM0DGNp
 Sg6i3+I6Zls5/ERY1Lvrpik4g3ShziZh7c9RGzm+QI7zr8kgo05UTbrTT2e5G4uPHVJv1m
 By7rJYP29woOiHBUWEloIIbMEd0cBBa4tsvE8GnQ2nhvgkLQE/U8wo4EOu0iK/ZmM5P0Ys
 JZggfg4pN8ITGuUoYS9bJ7FLNIuyxuilpUMxmXj1uX2hRM8GvrsY1g6bNE215/J2XhP5Lr
 jQhC3xv+zDBtAziUy1mLIL6xOFFNltt2bEEBGzRaZkHfNq6No+blTRqqBzYgtg==
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
Message-Id: <20260624101353.2678126-1-chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, 
	<dm-devel@lists.linux.dev>
X-Mailer: git-send-email 2.54.0
X-Lms-Return-Path: <lba+26a3badec+068741+lists.linux.dev+chencheng@fnnas.com>
Received: from localhost.localdomain ([183.34.163.186]) by smtp.feishu.cn with ESMTPS; Wed, 24 Jun 2026 18:14:03 +0800
Subject: [RFC PATCH] md,dm: caller-owned memalloc_noio token in mddev_suspend()/resume()
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
From: "Chen Cheng" <chencheng@fnnas.com>
Date: Wed, 24 Jun 2026 18:13:53 +0800
X-Original-From: chencheng@fnnas.com

From: Chen Cheng <chencheng@fnnas.com>

Save token as mddev-scoped in mddev->noio_flags cause PF_MEMALLOC_NOIO
leak into task A, while task B restores a token that it never saved.

scenario:

task A                          mddev                         task B
======                          =======                       ============
write suspend_lo
mddev_suspend()
                                suspended == 0
                                drain active_io
                                suspended = 1
A: noio_A = memalloc_noio_save()
A returns with PF_MEMALLOC_NOIO set

                                                              write suspend_hi
                                                              mddev_suspend()
                                suspended == 1
                                suspended = 2
                                                              B returns
                                                              (no save)

mddev_resume()
                                suspended = 1
                                not last resume
A returns
A still has PF_MEMALLOC_NOIO   <-- leaked

                                                              mddev_resume()
                                suspended = 0
                                                              memalloc_noio_restore(noio_A)
                                                              (restores A's token in B)

Fixed by:
  - return each caller's noio_flags from mddev_suspend()
  - pass that token back into mddev_resume()
  - update the suspend-and-lock helpers to carry the token
  - store the token in struct raid_set for dm-raid paths where suspend
    and resume are paired across callbacks

Validation:
repeatedly updates the array's suspend_lo and suspend_hi sysfs from many
concurrent userspace workers. That makes multiple tasks to call
mddev_suspend()/mddev_resume() concurrently.

Each worker:
  - reads its initial /proc/self/stat flags and verifies that PF_MEMALLOC_NOIO is not already
    set
  - writes 0 to either suspend_lo or suspend_hi
  - immediately reads its own task flags again
  - reports success if flags & PF_MEMALLOC_NOIO is true after the write returns

Link: https://github.com/chencheng-fnnas/reproducer/blob/main/repro-md-noio-token-leak.sh

Fixes: 78f57ef9d50a ("md: use memalloc scope APIs in mddev_suspend()/mddev_resume()")

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/dm-raid.c       |  7 ++--
 drivers/md/md-autodetect.c |  5 ++-
 drivers/md/md-bitmap.c     | 12 +++---
 drivers/md/md.c            | 85 ++++++++++++++++++++++----------------
 drivers/md/md.h            | 23 ++++++-----
 drivers/md/raid5-cache.c   | 11 +++--
 drivers/md/raid5.c         | 25 ++++++-----
 7 files changed, 97 insertions(+), 71 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 8f5a5e1342a9..d89207e3722a 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -239,10 +239,11 @@ struct raid_set {
 	int raid_disks;
 	int delta_disks;
 	int data_offset;
 	int raid10_copies;
 	int requested_bitmap_chunk_sectors;
+	unsigned int suspend_noio_flags;
 
 	struct mddev md;
 	struct raid_type *raid_type;
 
 	sector_t array_sectors;
@@ -3251,11 +3252,11 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	/* Start raid set read-only and assumed clean to change in raid_resume() */
 	rs->md.ro = MD_RDONLY;
 	rs->md.in_sync = 1;
 
 	/* Has to be held on running the array */
-	mddev_suspend_and_lock_nointr(&rs->md);
+	mddev_suspend_and_lock_nointr(&rs->md, &rs->suspend_noio_flags);
 
 	/* Keep array frozen until resume. */
 	md_frozen_sync_thread(&rs->md);
 
 	r = md_run(&rs->md);
@@ -3863,11 +3864,11 @@ static void raid_postsuspend(struct dm_target *ti)
 		/*
 		 * sync_thread must be stopped during suspend, and writes have
 		 * to be stopped before suspending to avoid deadlocks.
 		 */
 		md_stop_writes(&rs->md);
-		mddev_suspend(&rs->md, false);
+		mddev_suspend(&rs->md, false, &rs->suspend_noio_flags);
 		rs->md.ro = MD_RDONLY;
 	}
 	clear_bit(MD_DM_SUSPENDING, &mddev->flags);
 
 }
@@ -4141,11 +4142,11 @@ static void raid_resume(struct dm_target *ti)
 						       lockdep_is_held(&mddev->reconfig_mutex)));
 		clear_bit(RT_FLAG_RS_FROZEN, &rs->runtime_flags);
 		mddev->ro = MD_RDWR;
 		mddev->in_sync = 0;
 		md_unfrozen_sync_thread(mddev);
-		mddev_unlock_and_resume(mddev);
+		mddev_unlock_and_resume(mddev, rs->suspend_noio_flags);
 	}
 }
 
 static struct target_type raid_target = {
 	.name = "raid",
diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
index 4b80165afd23..58e062cd0580 100644
--- a/drivers/md/md-autodetect.c
+++ b/drivers/md/md-autodetect.c
@@ -126,10 +126,11 @@ static void __init md_setup_drive(struct md_setup_args *args)
 	dev_t devices[MD_SB_DISKS + 1], mdev;
 	struct mdu_array_info_s ainfo = { };
 	struct mddev *mddev;
 	int err = 0, i;
 	char name[16];
+	unsigned int noio_flags;
 
 	if (args->partitioned) {
 		mdev = MKDEV(mdp_major, args->minor << MdpMinorShift);
 		sprintf(name, "md_d%d", args->minor);
 	} else {
@@ -173,11 +174,11 @@ static void __init md_setup_drive(struct md_setup_args *args)
 	if (IS_ERR(mddev)) {
 		pr_err("md: md_alloc failed - cannot start array %s\n", name);
 		return;
 	}
 
-	err = mddev_suspend_and_lock(mddev);
+	err = mddev_suspend_and_lock(mddev, &noio_flags);
 	if (err) {
 		pr_err("md: failed to lock array %s\n", name);
 		goto out_mddev_put;
 	}
 
@@ -219,11 +220,11 @@ static void __init md_setup_drive(struct md_setup_args *args)
 	if (!err)
 		err = do_md_run(mddev);
 	if (err)
 		pr_warn("md: starting %s failed\n", name);
 out_unlock:
-	mddev_unlock_and_resume(mddev);
+	mddev_unlock_and_resume(mddev, noio_flags);
 out_mddev_put:
 	mddev_put(mddev);
 }
 
 static int __init raid_setup(char *str)
diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 028b9ca8ce52..74b7f569a3f4 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2620,13 +2620,14 @@ location_show(struct mddev *mddev, char *page)
 }
 
 static ssize_t
 location_store(struct mddev *mddev, const char *buf, size_t len)
 {
+	unsigned int noio_flags;
 	int rv;
 
-	rv = mddev_suspend_and_lock(mddev);
+	rv = mddev_suspend_and_lock(mddev, &noio_flags);
 	if (rv)
 		return rv;
 
 	if (mddev->pers) {
 		if (mddev->recovery || mddev->sync_thread) {
@@ -2711,11 +2712,11 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 		md_wakeup_thread(mddev->thread);
 	}
 	rv = 0;
 out:
-	mddev_unlock_and_resume(mddev);
+	mddev_unlock_and_resume(mddev, noio_flags);
 	if (rv)
 		return rv;
 	return len;
 
 merge_err:
@@ -2831,17 +2832,18 @@ backlog_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	unsigned long backlog;
 	unsigned long old_mwb = mddev->bitmap_info.max_write_behind;
 	struct md_rdev *rdev;
 	bool has_write_mostly = false;
+	unsigned int noio_flags;
 	int rv = kstrtoul(buf, 10, &backlog);
 	if (rv)
 		return rv;
 	if (backlog > COUNTER_MAX)
 		return -EINVAL;
 
-	rv = mddev_suspend_and_lock(mddev);
+	rv = mddev_suspend_and_lock(mddev, &noio_flags);
 	if (rv)
 		return rv;
 
 	/*
 	 * Without write mostly device, it doesn't make sense to set
@@ -2854,11 +2856,11 @@ backlog_store(struct mddev *mddev, const char *buf, size_t len)
 		}
 	}
 	if (!has_write_mostly) {
 		pr_warn_ratelimited("%s: can't set backlog, no write mostly device available\n",
 				    mdname(mddev));
-		mddev_unlock(mddev);
+		mddev_unlock_and_resume(mddev, noio_flags);
 		return -EINVAL;
 	}
 
 	mddev->bitmap_info.max_write_behind = backlog;
 	if (!backlog && mddev->serial_info_pool) {
@@ -2871,11 +2873,11 @@ backlog_store(struct mddev *mddev, const char *buf, size_t len)
 			mddev_create_serial_pool(mddev, rdev);
 	}
 	if (old_mwb != backlog)
 		bitmap_update_sb(mddev->bitmap);
 
-	mddev_unlock_and_resume(mddev);
+	mddev_unlock_and_resume(mddev, noio_flags);
 	return len;
 }
 
 static struct md_sysfs_entry bitmap_backlog =
 __ATTR(backlog, S_IRUGO|S_IWUSR, backlog_show, backlog_store);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1377c407614c..86d938dee50a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -459,11 +459,12 @@ static void md_submit_bio(struct bio *bio)
 
 /*
  * Make sure no new requests are submitted to the device, and any requests that
  * have been submitted are completely handled.
  */
-int mddev_suspend(struct mddev *mddev, bool interruptible)
+int mddev_suspend(struct mddev *mddev, bool interruptible,
+		  unsigned int *noio_flags)
 {
 	int err = 0;
 
 	/*
 	 * hold reconfig_mutex to wait for normal io will deadlock, because
@@ -478,10 +479,11 @@ int mddev_suspend(struct mddev *mddev, bool interruptible)
 		mutex_lock(&mddev->suspend_mutex);
 	if (err)
 		return err;
 
 	if (mddev->suspended) {
+		*noio_flags = memalloc_noio_save();
 		WRITE_ONCE(mddev->suspended, mddev->suspended + 1);
 		mutex_unlock(&mddev->suspend_mutex);
 		return 0;
 	}
 
@@ -515,31 +517,30 @@ int mddev_suspend(struct mddev *mddev, bool interruptible)
 	 * prevent deadlock.
 	 */
 	WRITE_ONCE(mddev->suspended, mddev->suspended + 1);
 
 	/* restrict memory reclaim I/O during raid array is suspend */
-	mddev->noio_flag = memalloc_noio_save();
+	*noio_flags = memalloc_noio_save();
 
 	mutex_unlock(&mddev->suspend_mutex);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mddev_suspend);
 
-static void __mddev_resume(struct mddev *mddev, bool recovery_needed)
+static void __mddev_resume(struct mddev *mddev, bool recovery_needed,
+			   unsigned int noio_flags)
 {
 	lockdep_assert_not_held(&mddev->reconfig_mutex);
 
 	mutex_lock(&mddev->suspend_mutex);
+	memalloc_noio_restore(noio_flags);
 	WRITE_ONCE(mddev->suspended, mddev->suspended - 1);
 	if (mddev->suspended) {
 		mutex_unlock(&mddev->suspend_mutex);
 		return;
 	}
 
-	/* entred the memalloc scope from mddev_suspend() */
-	memalloc_noio_restore(mddev->noio_flag);
-
 	percpu_ref_resurrect(&mddev->active_io);
 	wake_up(&mddev->sb_wait);
 
 	if (recovery_needed)
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
@@ -547,13 +548,13 @@ static void __mddev_resume(struct mddev *mddev, bool recovery_needed)
 	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */
 
 	mutex_unlock(&mddev->suspend_mutex);
 }
 
-void mddev_resume(struct mddev *mddev)
+void mddev_resume(struct mddev *mddev, unsigned int noio_flags)
 {
-	return __mddev_resume(mddev, true);
+	return __mddev_resume(mddev, true, noio_flags);
 }
 EXPORT_SYMBOL_GPL(mddev_resume);
 
 /* sync bdev before setting device to readonly or stopping raid*/
 static int mddev_set_closing_and_sync_blockdev(struct mddev *mddev, int opener_num)
@@ -3737,10 +3738,11 @@ rdev_attr_store(struct kobject *kobj, struct attribute *attr,
 {
 	struct rdev_sysfs_entry *entry = container_of(attr, struct rdev_sysfs_entry, attr);
 	struct md_rdev *rdev = container_of(kobj, struct md_rdev, kobj);
 	struct kernfs_node *kn = NULL;
 	bool suspend = false;
+	unsigned int noio_flags = 0;
 	ssize_t rv;
 	struct mddev *mddev = READ_ONCE(rdev->mddev);
 
 	if (!entry->store)
 		return -EIO;
@@ -3756,17 +3758,17 @@ rdev_attr_store(struct kobject *kobj, struct attribute *attr,
 		    cmd_match(page, "writemostly") ||
 		    cmd_match(page, "-writemostly"))
 			suspend = true;
 	}
 
-	rv = suspend ? mddev_suspend_and_lock(mddev) : mddev_lock(mddev);
+	rv = suspend ? mddev_suspend_and_lock(mddev, &noio_flags) : mddev_lock(mddev);
 	if (!rv) {
 		if (rdev->mddev == NULL)
 			rv = -ENODEV;
 		else
 			rv = entry->store(rdev, page, length);
-		suspend ? mddev_unlock_and_resume(mddev) : mddev_unlock(mddev);
+		suspend ? mddev_unlock_and_resume(mddev, noio_flags) : mddev_unlock(mddev);
 	}
 
 	if (kn)
 		sysfs_unbreak_active_protection(kn);
 
@@ -4049,15 +4051,16 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	size_t slen = len;
 	struct md_personality *pers, *oldpers;
 	long level;
 	void *priv, *oldpriv;
 	struct md_rdev *rdev;
+	unsigned int noio_flags;
 
 	if (slen == 0 || slen >= sizeof(clevel))
 		return -EINVAL;
 
-	rv = mddev_suspend_and_lock(mddev);
+	rv = mddev_suspend_and_lock(mddev, &noio_flags);
 	if (rv)
 		return rv;
 
 	if (mddev->pers == NULL) {
 		memcpy(mddev->clevel, buf, slen);
@@ -4231,11 +4234,11 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 		md_update_sb(mddev, 1);
 	sysfs_notify_dirent_safe(mddev->sysfs_level);
 	md_new_event();
 	rv = len;
 out_unlock:
-	mddev_unlock_and_resume(mddev);
+	mddev_unlock_and_resume(mddev, noio_flags);
 	return rv;
 }
 
 static struct md_sysfs_entry md_level =
 __ATTR(level, S_IRUGO|S_IWUSR, level_show, level_store);
@@ -4410,17 +4413,18 @@ static int update_raid_disks(struct mddev *mddev, int raid_disks);
 
 static ssize_t
 raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	unsigned int n;
+	unsigned int noio_flags;
 	int err;
 
 	err = kstrtouint(buf, 10, &n);
 	if (err < 0)
 		return err;
 
-	err = mddev_suspend_and_lock(mddev);
+	err = mddev_suspend_and_lock(mddev, &noio_flags);
 	if (err)
 		return err;
 	if (mddev->pers) {
 		if (n != mddev->raid_disks)
 			err = update_raid_disks(mddev, n);
@@ -4442,11 +4446,11 @@ raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->raid_disks = n;
 		mddev->reshape_backwards = (mddev->delta_disks < 0);
 	} else
 		mddev->raid_disks = n;
 out_unlock:
-	mddev_unlock_and_resume(mddev);
+	mddev_unlock_and_resume(mddev, noio_flags);
 	return err ? err : len;
 }
 static struct md_sysfs_entry md_raid_disks =
 __ATTR(raid_disks, S_IRUGO|S_IWUSR, raid_disks_show, raid_disks_store);
 
@@ -4822,10 +4826,11 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
 	char *e;
 	int major = simple_strtoul(buf, &e, 10);
 	int minor;
 	dev_t dev;
 	struct md_rdev *rdev;
+	unsigned int noio_flags;
 	int err;
 
 	if (!*buf || *e != ':' || !e[1] || e[1] == '\n')
 		return -EINVAL;
 	minor = simple_strtoul(e+1, &e, 10);
@@ -4834,11 +4839,11 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
 	dev = MKDEV(major, minor);
 	if (major != MAJOR(dev) ||
 	    minor != MINOR(dev))
 		return -EOVERFLOW;
 
-	err = mddev_suspend_and_lock(mddev);
+	err = mddev_suspend_and_lock(mddev, &noio_flags);
 	if (err)
 		return err;
 	if (mddev->persistent) {
 		rdev = md_import_device(dev, mddev->major_version,
 					mddev->minor_version);
@@ -4855,18 +4860,18 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
 		rdev = md_import_device(dev, -2, -1);
 	else
 		rdev = md_import_device(dev, -1, -1);
 
 	if (IS_ERR(rdev)) {
-		mddev_unlock_and_resume(mddev);
+		mddev_unlock_and_resume(mddev, noio_flags);
 		return PTR_ERR(rdev);
 	}
 	err = bind_rdev_to_array(rdev, mddev);
  out:
 	if (err)
 		export_rdev(rdev);
-	mddev_unlock_and_resume(mddev);
+	mddev_unlock_and_resume(mddev, noio_flags);
 	if (!err)
 		md_new_event();
 	return err ? err : len;
 }
 
@@ -5257,28 +5262,29 @@ static int mddev_start_reshape(struct mddev *mddev)
 static ssize_t
 action_store(struct mddev *mddev, const char *page, size_t len)
 {
 	int ret;
 	enum sync_action action;
+	unsigned int noio_flags = 0;
 
 	if (!mddev->pers || !mddev->pers->sync_request)
 		return -EINVAL;
 
 	action = md_sync_action_by_name(page);
 retry:
 	if (work_busy(&mddev->sync_work))
 		flush_work(&mddev->sync_work);
 
 	ret = (action == ACTION_RESHAPE) ?
-		mddev_suspend_and_lock(mddev) :
+		mddev_suspend_and_lock(mddev, &noio_flags) :
 		mddev_lock(mddev);
 	if (ret)
 		return ret;
 
 	if (work_busy(&mddev->sync_work)) {
 		if (action == ACTION_RESHAPE)
-			mddev_unlock_and_resume(mddev);
+			mddev_unlock_and_resume(mddev, noio_flags);
 		else
 			mddev_unlock(mddev);
 		goto retry;
 	}
 
@@ -5349,11 +5355,11 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
 	ret = len;
 
 out:
 	if (action == ACTION_RESHAPE)
-		mddev_unlock_and_resume(mddev);
+		mddev_unlock_and_resume(mddev, noio_flags);
 	else
 		mddev_unlock(mddev);
 	return ret;
 }
 
@@ -5640,24 +5646,25 @@ suspend_lo_show(struct mddev *mddev, char *page)
 
 static ssize_t
 suspend_lo_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	unsigned long long new;
+	unsigned int noio_flags;
 	int err;
 
 	err = kstrtoull(buf, 10, &new);
 	if (err < 0)
 		return err;
 	if (new != (sector_t)new)
 		return -EINVAL;
 
-	err = mddev_suspend(mddev, true);
+	err = mddev_suspend(mddev, true, &noio_flags);
 	if (err)
 		return err;
 
 	WRITE_ONCE(mddev->suspend_lo, new);
-	mddev_resume(mddev);
+	mddev_resume(mddev, noio_flags);
 
 	return len;
 }
 static struct md_sysfs_entry md_suspend_lo =
 __ATTR(suspend_lo, S_IRUGO|S_IWUSR, suspend_lo_show, suspend_lo_store);
@@ -5671,24 +5678,25 @@ suspend_hi_show(struct mddev *mddev, char *page)
 
 static ssize_t
 suspend_hi_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	unsigned long long new;
+	unsigned int noio_flags;
 	int err;
 
 	err = kstrtoull(buf, 10, &new);
 	if (err < 0)
 		return err;
 	if (new != (sector_t)new)
 		return -EINVAL;
 
-	err = mddev_suspend(mddev, true);
+	err = mddev_suspend(mddev, true, &noio_flags);
 	if (err)
 		return err;
 
 	WRITE_ONCE(mddev->suspend_hi, new);
-	mddev_resume(mddev);
+	mddev_resume(mddev, noio_flags);
 
 	return len;
 }
 static struct md_sysfs_entry md_suspend_hi =
 __ATTR(suspend_hi, S_IRUGO|S_IWUSR, suspend_hi_show, suspend_hi_store);
@@ -5928,19 +5936,20 @@ static ssize_t serialize_policy_show(struct mddev *mddev, char *page)
 static ssize_t
 serialize_policy_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	int err;
 	bool value;
+	unsigned int noio_flags;
 
 	err = kstrtobool(buf, &value);
 	if (err)
 		return err;
 
 	if (value == test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
 		return len;
 
-	err = mddev_suspend_and_lock(mddev);
+	err = mddev_suspend_and_lock(mddev, &noio_flags);
 	if (err)
 		return err;
 	if (mddev->pers == NULL || (mddev->pers->head.id != ID_RAID1)) {
 		pr_err("md: serialize_policy is only effective for raid1\n");
 		err = -EINVAL;
@@ -5953,11 +5962,11 @@ serialize_policy_store(struct mddev *mddev, const char *buf, size_t len)
 	} else {
 		mddev_destroy_serial_pool(mddev, NULL);
 		clear_bit(MD_SERIALIZE_POLICY, &mddev->flags);
 	}
 unlock:
-	mddev_unlock_and_resume(mddev);
+	mddev_unlock_and_resume(mddev, noio_flags);
 	return err ?: len;
 }
 
 static struct md_sysfs_entry md_serialize_policy =
 __ATTR(serialize_policy, S_IRUGO | S_IWUSR, serialize_policy_show,
@@ -6263,21 +6272,22 @@ EXPORT_SYMBOL_GPL(mddev_stack_new_rdev);
 
 /* update the optimal I/O size after a reshape */
 void mddev_update_io_opt(struct mddev *mddev, unsigned int nr_stripes)
 {
 	struct queue_limits lim;
+	unsigned int noio_flags;
 
 	if (mddev_is_dm(mddev))
 		return;
 
 	/* don't bother updating io_opt if we can't suspend the array */
-	if (mddev_suspend(mddev, false) < 0)
+	if (mddev_suspend(mddev, false, &noio_flags) < 0)
 		return;
 	lim = queue_limits_start_update(mddev->gendisk->queue);
 	lim.io_opt = lim.io_min * nr_stripes;
 	queue_limits_commit_update(mddev->gendisk->queue, &lim);
-	mddev_resume(mddev);
+	mddev_resume(mddev, noio_flags);
 }
 EXPORT_SYMBOL_GPL(mddev_update_io_opt);
 
 static void mddev_delayed_delete(struct work_struct *ws)
 {
@@ -7255,10 +7265,11 @@ static void autorun_array(struct mddev *mddev)
  */
 static void autorun_devices(int part)
 {
 	struct md_rdev *rdev0, *rdev, *tmp;
 	struct mddev *mddev;
+	unsigned int noio_flags;
 
 	pr_info("md: autorun ...\n");
 	while (!list_empty(&pending_raid_disks)) {
 		int unit;
 		dev_t dev;
@@ -7295,27 +7306,27 @@ static void autorun_devices(int part)
 
 		mddev = md_alloc(dev, NULL);
 		if (IS_ERR(mddev))
 			break;
 
-		if (mddev_suspend_and_lock(mddev))
+		if (mddev_suspend_and_lock(mddev, &noio_flags))
 			pr_warn("md: %s locked, cannot run\n", mdname(mddev));
 		else if (mddev->raid_disks || mddev->major_version
 			 || !list_empty(&mddev->disks)) {
 			pr_warn("md: %s already running, cannot run %pg\n",
 				mdname(mddev), rdev0->bdev);
-			mddev_unlock_and_resume(mddev);
+			mddev_unlock_and_resume(mddev, noio_flags);
 		} else {
 			pr_debug("md: created %s\n", mdname(mddev));
 			mddev->persistent = 1;
 			rdev_for_each_list(rdev, tmp, &candidates) {
 				list_del_init(&rdev->same_set);
 				if (bind_rdev_to_array(rdev, mddev))
 					export_rdev(rdev);
 			}
 			autorun_array(mddev);
-			mddev_unlock_and_resume(mddev);
+			mddev_unlock_and_resume(mddev, noio_flags);
 		}
 		/* on success, candidates will be empty, on error
 		 * it won't...
 		 */
 		rdev_for_each_list(rdev, tmp, &candidates) {
@@ -8329,10 +8340,11 @@ static int __md_set_array_info(struct mddev *mddev, void __user *argp)
 
 static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 			unsigned int cmd, unsigned long arg)
 {
 	int err = 0;
+	unsigned int noio_flags = 0;
 	void __user *argp = (void __user *)arg;
 	struct mddev *mddev = NULL;
 
 	err = md_ioctl_valid(cmd);
 	if (err)
@@ -8380,11 +8392,11 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 	}
 
 	if (!md_is_rdwr(mddev))
 		flush_work(&mddev->sync_work);
 
-	err = md_ioctl_need_suspend(cmd) ? mddev_suspend_and_lock(mddev) :
+	err = md_ioctl_need_suspend(cmd) ? mddev_suspend_and_lock(mddev, &noio_flags) :
 					   mddev_lock(mddev);
 	if (err) {
 		pr_debug("md: ioctl lock interrupted, reason %d, cmd %d\n",
 			 err, cmd);
 		goto out;
@@ -8511,11 +8523,11 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 unlock:
 	if (mddev->hold_active == UNTIL_IOCTL &&
 	    err != -EINVAL)
 		mddev->hold_active = 0;
 
-	md_ioctl_need_suspend(cmd) ? mddev_unlock_and_resume(mddev) :
+	md_ioctl_need_suspend(cmd) ? mddev_unlock_and_resume(mddev, noio_flags) :
 				     mddev_unlock(mddev);
 
 out:
 	if (cmd == STOP_ARRAY_RO || (err && cmd == STOP_ARRAY))
 		clear_bit(MD_CLOSING, &mddev->flags);
@@ -10180,20 +10192,21 @@ static bool md_choose_sync_action(struct mddev *mddev, int *spares)
 static void md_start_sync(struct work_struct *ws)
 {
 	struct mddev *mddev = container_of(ws, struct mddev, sync_work);
 	int spares = 0;
 	bool suspend = false;
+	unsigned int noio_flags = 0;
 	char *name;
 
 	/*
 	 * If reshape is still in progress, spares won't be added or removed
 	 * from conf until reshape is done.
 	 */
 	if (mddev->reshape_position == MaxSector &&
 	    md_spares_need_change(mddev)) {
 		suspend = true;
-		mddev_suspend(mddev, false);
+		mddev_suspend(mddev, false, &noio_flags);
 	}
 
 	mddev_lock_nointr(mddev);
 	if (!md_is_rdwr(mddev)) {
 		/*
@@ -10237,11 +10250,11 @@ static void md_start_sync(struct work_struct *ws)
 	 * not set it again. Otherwise, we may cause issue like this one:
 	 *     https://bugzilla.kernel.org/show_bug.cgi?id=218200
 	 * Therefore, use __mddev_resume(mddev, false).
 	 */
 	if (suspend)
-		__mddev_resume(mddev, false);
+		__mddev_resume(mddev, false, noio_flags);
 	md_wakeup_thread(mddev->sync_thread);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
 	md_new_event();
 	return;
 
@@ -10257,11 +10270,11 @@ static void md_start_sync(struct work_struct *ws)
 	 * not set it again. Otherwise, we may cause issue like this one:
 	 *     https://bugzilla.kernel.org/show_bug.cgi?id=218200
 	 * Therefore, use __mddev_resume(mddev, false).
 	 */
 	if (suspend)
-		__mddev_resume(mddev, false);
+		__mddev_resume(mddev, false, noio_flags);
 
 	wake_up(&resync_wait);
 	if (test_and_clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery) &&
 	    mddev->sysfs_action)
 		sysfs_notify_dirent_safe(mddev->sysfs_action);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index d8daf0f75cbb..3337cd21eb30 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -619,11 +619,10 @@ struct mddev {
 	mempool_t *serial_info_pool;
 	void (*sync_super)(struct mddev *mddev, struct md_rdev *rdev);
 	struct md_cluster_info		*cluster_info;
 	struct md_cluster_operations *cluster_ops;
 	unsigned int			good_device_nr;	/* good device num within cluster raid */
-	unsigned int			noio_flag; /* for memalloc scope API */
 
 	/*
 	 * Temporarily store rdev that will be finally removed when
 	 * reconfig_mutex is unlocked, protected by reconfig_mutex.
 	 */
@@ -953,12 +952,13 @@ extern void md_stop(struct mddev *mddev);
 extern void md_stop_writes(struct mddev *mddev);
 extern int md_rdev_init(struct md_rdev *rdev);
 extern void md_rdev_clear(struct md_rdev *rdev);
 
 extern bool md_handle_request(struct mddev *mddev, struct bio *bio);
-extern int mddev_suspend(struct mddev *mddev, bool interruptible);
-extern void mddev_resume(struct mddev *mddev);
+extern int mddev_suspend(struct mddev *mddev, bool interruptible,
+			 unsigned int *noio_flags);
+extern void mddev_resume(struct mddev *mddev, unsigned int noio_flags);
 extern void md_idle_sync_thread(struct mddev *mddev);
 extern void md_frozen_sync_thread(struct mddev *mddev);
 extern void md_unfrozen_sync_thread(struct mddev *mddev);
 
 extern void md_update_sb(struct mddev *mddev, int force);
@@ -999,35 +999,38 @@ static inline void mddev_check_write_zeroes(struct mddev *mddev, struct bio *bio
 	if (bio_op(bio) == REQ_OP_WRITE_ZEROES &&
 	    !bio->bi_bdev->bd_disk->queue->limits.max_write_zeroes_sectors)
 		mddev->gendisk->queue->limits.max_write_zeroes_sectors = 0;
 }
 
-static inline int mddev_suspend_and_lock(struct mddev *mddev)
+static inline int mddev_suspend_and_lock(struct mddev *mddev,
+					 unsigned int *noio_flags)
 {
 	int ret;
 
-	ret = mddev_suspend(mddev, true);
+	ret = mddev_suspend(mddev, true, noio_flags);
 	if (ret)
 		return ret;
 
 	ret = mddev_lock(mddev);
 	if (ret)
-		mddev_resume(mddev);
+		mddev_resume(mddev, *noio_flags);
 
 	return ret;
 }
 
-static inline void mddev_suspend_and_lock_nointr(struct mddev *mddev)
+static inline void mddev_suspend_and_lock_nointr(struct mddev *mddev,
+						 unsigned int *noio_flags)
 {
-	mddev_suspend(mddev, false);
+	mddev_suspend(mddev, false, noio_flags);
 	mddev_lock_nointr(mddev);
 }
 
-static inline void mddev_unlock_and_resume(struct mddev *mddev)
+static inline void mddev_unlock_and_resume(struct mddev *mddev,
+					   unsigned int noio_flags)
 {
 	mddev_unlock(mddev);
-	mddev_resume(mddev);
+	mddev_resume(mddev, noio_flags);
 }
 
 struct mdu_array_info_s;
 struct mdu_disk_info_s;
 
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 7b7546bfa21f..6f8e3a624456 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -693,13 +693,15 @@ static void r5c_disable_writeback_async(struct work_struct *work)
 		   !READ_ONCE(conf->log) ||
 		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
 
 	log = READ_ONCE(conf->log);
 	if (log) {
-		mddev_suspend(mddev, false);
+		unsigned int noio_flags;
+
+		mddev_suspend(mddev, false, &noio_flags);
 		log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_THROUGH;
-		mddev_resume(mddev);
+		mddev_resume(mddev, noio_flags);
 	}
 }
 
 static void r5l_submit_current_io(struct r5l_log *log)
 {
@@ -2603,10 +2605,11 @@ EXPORT_SYMBOL(r5c_journal_mode_set);
 static ssize_t r5c_journal_mode_store(struct mddev *mddev,
 				      const char *page, size_t length)
 {
 	int mode = ARRAY_SIZE(r5c_journal_mode_str);
 	size_t len = length;
+	unsigned int noio_flags;
 	int ret;
 
 	if (len < 2)
 		return -EINVAL;
 
@@ -2615,15 +2618,15 @@ static ssize_t r5c_journal_mode_store(struct mddev *mddev,
 
 	while (mode--)
 		if (strlen(r5c_journal_mode_str[mode]) == len &&
 		    !strncmp(page, r5c_journal_mode_str[mode], len))
 			break;
-	ret = mddev_suspend_and_lock(mddev);
+	ret = mddev_suspend_and_lock(mddev, &noio_flags);
 	if (ret)
 		return ret;
 	ret = r5c_journal_mode_set(mddev, mode);
-	mddev_unlock_and_resume(mddev);
+	mddev_unlock_and_resume(mddev, noio_flags);
 	return ret ?: length;
 }
 
 struct md_sysfs_entry
 r5c_journal_mode = __ATTR(journal_mode, 0644,
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 65ae7d8930fc..6062c4b62cc8 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6992,11 +6992,11 @@ raid5_show_stripe_size(struct mddev  *mddev, char *page)
 #if PAGE_SIZE != DEFAULT_STRIPE_SIZE
 static ssize_t
 raid5_store_stripe_size(struct mddev  *mddev, const char *page, size_t len)
 {
 	struct r5conf *conf;
-	unsigned long new;
+	unsigned long new, noio_flags;
 	int err;
 	int size;
 
 	if (len >= PAGE_SIZE)
 		return -EINVAL;
@@ -7011,11 +7011,11 @@ raid5_store_stripe_size(struct mddev  *mddev, const char *page, size_t len)
 	if (new % DEFAULT_STRIPE_SIZE != 0 ||
 			new > PAGE_SIZE || new == 0 ||
 			new != roundup_pow_of_two(new))
 		return -EINVAL;
 
-	err = mddev_suspend_and_lock(mddev);
+	err = mddev_suspend_and_lock(mddev, &noio_flags);
 	if (err)
 		return err;
 
 	conf = mddev->private;
 	if (!conf) {
@@ -7049,11 +7049,11 @@ raid5_store_stripe_size(struct mddev  *mddev, const char *page, size_t len)
 		err = -ENOMEM;
 	}
 	mutex_unlock(&conf->cache_size_mutex);
 
 out_unlock:
-	mddev_unlock_and_resume(mddev);
+	mddev_unlock_and_resume(mddev, noio_flags);
 	return err ?: len;
 }
 
 static struct md_sysfs_entry
 raid5_stripe_size = __ATTR(stripe_size, 0644,
@@ -7127,19 +7127,20 @@ raid5_show_skip_copy(struct mddev *mddev, char *page)
 static ssize_t
 raid5_store_skip_copy(struct mddev *mddev, const char *page, size_t len)
 {
 	struct r5conf *conf;
 	unsigned long new;
+	unsigned int noio_flags;
 	int err;
 
 	if (len >= PAGE_SIZE)
 		return -EINVAL;
 	if (kstrtoul(page, 10, &new))
 		return -EINVAL;
 	new = !!new;
 
-	err = mddev_suspend_and_lock(mddev);
+	err = mddev_suspend_and_lock(mddev, &noio_flags);
 	if (err)
 		return err;
 	conf = mddev->private;
 	if (!conf)
 		err = -ENODEV;
@@ -7152,11 +7153,11 @@ raid5_store_skip_copy(struct mddev *mddev, const char *page, size_t len)
 			lim.features |= BLK_FEAT_STABLE_WRITES;
 		else
 			lim.features &= ~BLK_FEAT_STABLE_WRITES;
 		err = queue_limits_commit_update(q, &lim);
 	}
-	mddev_unlock_and_resume(mddev);
+	mddev_unlock_and_resume(mddev, noio_flags);
 	return err ?: len;
 }
 
 static struct md_sysfs_entry
 raid5_skip_copy = __ATTR(skip_copy, S_IRUGO | S_IWUSR,
@@ -7195,10 +7196,11 @@ static int alloc_thread_groups(struct r5conf *conf, int cnt,
 static ssize_t
 raid5_store_group_thread_cnt(struct mddev *mddev, const char *page, size_t len)
 {
 	struct r5conf *conf;
 	unsigned int new;
+	unsigned int noio_flags;
 	int err;
 	struct r5worker_group *new_groups, *old_groups;
 	int group_cnt;
 
 	if (len >= PAGE_SIZE)
@@ -7207,16 +7209,16 @@ raid5_store_group_thread_cnt(struct mddev *mddev, const char *page, size_t len)
 		return -EINVAL;
 	/* 8192 should be big enough */
 	if (new > 8192)
 		return -EINVAL;
 
-	err = mddev_suspend_and_lock(mddev);
+	err = mddev_suspend_and_lock(mddev, &noio_flags);
 	if (err)
 		return err;
 	conf = mddev->private;
 	if (!conf) {
-		mddev_unlock_and_resume(mddev);
+		mddev_unlock_and_resume(mddev, noio_flags);
 		return -ENODEV;
 	}
 	raid5_quiesce(mddev, true);
 
 	if (new != conf->worker_cnt_per_group) {
@@ -7237,11 +7239,11 @@ raid5_store_group_thread_cnt(struct mddev *mddev, const char *page, size_t len)
 			kfree(old_groups);
 		}
 	}
 
 	raid5_quiesce(mddev, false);
-	mddev_unlock_and_resume(mddev);
+	mddev_unlock_and_resume(mddev, noio_flags);
 
 	return err ?: len;
 }
 
 static struct md_sysfs_entry
@@ -8940,18 +8942,19 @@ static void *raid6_takeover(struct mddev *mddev)
 }
 
 static int raid5_change_consistency_policy(struct mddev *mddev, const char *buf)
 {
 	struct r5conf *conf;
+	unsigned int noio_flags;
 	int err;
 
-	err = mddev_suspend_and_lock(mddev);
+	err = mddev_suspend_and_lock(mddev, &noio_flags);
 	if (err)
 		return err;
 	conf = mddev->private;
 	if (!conf) {
-		mddev_unlock_and_resume(mddev);
+		mddev_unlock_and_resume(mddev, noio_flags);
 		return -ENODEV;
 	}
 
 	if (strncmp(buf, "ppl", 3) == 0) {
 		/* ppl only works with RAID 5 */
@@ -8990,11 +8993,11 @@ static int raid5_change_consistency_policy(struct mddev *mddev, const char *buf)
 	}
 
 	if (!err)
 		md_update_sb(mddev, 1);
 
-	mddev_unlock_and_resume(mddev);
+	mddev_unlock_and_resume(mddev, noio_flags);
 
 	return err;
 }
 
 static int raid5_start(struct mddev *mddev)
-- 
2.54.0
