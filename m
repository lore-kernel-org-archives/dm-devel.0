Received: from va-2-39.ptr.blmpb.com (va-2-39.ptr.blmpb.com [209.127.231.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566081DF75B
	for <dm-devel@lists.linux.dev>; Sat, 11 Jul 2026 06:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783752628; cv=none; b=WouGtHJqGsUp13qx8A31OfMtM6jPXhNfEPML/PcuFVYPhpNIz7amrpbFeC6AaVCQ1Qop4EEM1FpqwBKAXoXRrv13BpST5pWMZvRSbwQ8huF33FR3kG2SIl0h8kDXgXWeEC7jeDWoNSy3bP7vdGTMIYYL65gZqepA7XHCWMcY4vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783752628; c=relaxed/simple;
	bh=G5NYO02dkpAym3zoJezC5OkKuaKhwQHAWliyfy/EA80=;
	h=In-Reply-To:References:Content-Type:Message-Id:Date:Mime-Version:
	 To:Subject:From; b=EyI6ujFPgnyX8DzvFuEIDkBAC/Buik7TrZkP4N7Xi19+/Cu7s5YW2sMHAvO7IQ+MXv8Qau5fSEVYDwQrg1or29EuammtEKFUzAQ71NuJ1fnkYz5q/jBSw8oAPfs2xx3b1jz2tSd3dtbxvRZgoCfBYOhlGwoyBU2ze09/hle6Tac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=ySfwRahT; arc=none smtp.client-ip=209.127.231.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="ySfwRahT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1783752613;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=64KzHQ8mhJkQ29nZmRRVu+UHmWGcALXMei7GYjXvwds=;
 b=ySfwRahT5UCD+2X82zui2XLkefxKirVx2U55LDIN4ijpS2WKtWaQPCtlx5f8aPZxhK7yWa
 8+cDkhixrszVWyYc0sr7ljSHLDW5ZG6kbb2OZSNIFsFXH0KIopJCyM1TUEtySXvU8mWC2/
 v/Y6i/IJjgEraRL0bZCG4KgLrRZB/OrpIXwZpFbcxT7Tl5EAwnPCVNTr7KBBHGWY1CSFcB
 ud00VSaIURNgCG2MNJJ0xqVpT0EO3/JFMh1rnXwssrPbBffIXjCCUUR3wI12ql7u0yl6Oq
 CulWMYx6NkWYM0v70zmP6K/pTxQfanapxhN0CyqfI1jYSmL/pagD/Fsnru+eOg==
In-Reply-To: <20260711064845.155682-1-chencheng@fnnas.com>
References: <20260711064845.155682-1-chencheng@fnnas.com>
X-Lms-Return-Path: <lba+26a51e7a3+f05ac6+lists.linux.dev+chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <7665105a-38fb-41a1-abcf-89e678acfef6@fnnas.com>
Date: Sat, 11 Jul 2026 14:50:09 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Original-From: Chen Cheng <chencheng@fnnas.com>
To: <dm-devel@lists.linux.dev>
Subject: Fwd: [PATCH v1] md,dm: caller-owned memalloc_noio token in mddev_suspend()/resume()
Received: from [192.168.8.91] ([183.34.162.102]) by smtp.feishu.cn with ESMTPS; Sat, 11 Jul 2026 14:50:10 +0800
From: "Chen Cheng" <chencheng@fnnas.com>
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
X-Forwarded-Message-Id: <20260711064845.155682-1-chencheng@fnnas.com>

CC dm-devel  .

-------- =E8=BD=AC=E5=8F=91=E7=9A=84=E6=B6=88=E6=81=AF --------
=E4=B8=BB=E9=A2=98: [PATCH v1] md,dm: caller-owned memalloc_noio token in=
=20
mddev_suspend()/resume()
=E6=97=A5=E6=9C=9F: Sat, 11 Jul 2026 14:48:45 +0800
=E5=8F=91=E4=BB=B6=E4=BA=BA: Chen Cheng <chencheng@fnnas.com>
=E6=94=B6=E4=BB=B6=E4=BA=BA: linux-raid@vger.kernel.org, yukuai@fygo.io
=E6=8A=84=E9=80=81: chencheng@fnnas.com, linux-kernel@vger.kernel.org

From: Chen Cheng <chencheng@fnnas.com>

Save token as mddev-scoped in mddev->noio_flags cause PF_MEMALLOC_NOIO
leak into task A, while task B restores a token that it never saved.

scenario:

task A                          mddev                       task B
=3D=3D=3D=3D=3D=3D                          =3D=3D=3D=3D=3D=3D=3D          =
           =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
write suspend_lo
mddev_suspend()
                                 suspended =3D=3D 0
                                 drain active_io
                                 suspended =3D 1
A: noio_A =3D memalloc_noio_save()
A returns with PF_MEMALLOC_NOIO set

                                                             write=20
suspend_hi
                                                             mddev_suspend(=
)
                                 suspended =3D=3D 1
                                 suspended =3D 2
                                                             B returns
                                                             (no save)

mddev_resume()
                                 suspended =3D 1
                                 not last resume
A returns
A still has PF_MEMALLOC_NOIO   <-- leaked

                                                             mddev_resume()
                                 suspended =3D 0
 =20
memalloc_noio_restore(noio_A)
                                                             (restores=20
A's token in B)

Fixed by:
   for md-raid side:
	  - return each caller's noio_flags from mddev_suspend()
	  - pass that token back into mddev_resume()
	  - update the suspend-and-lock helpers to carry the token
   for dm-raid side:
	  - just bypass because: dm-raid call suspend() or resume() will return to
		userland, so is not paired in the same task context.

Validation:
repeatedly updates the array's suspend_lo and suspend_hi sysfs from many
concurrent userspace workers. That makes multiple tasks to call
mddev_suspend()/mddev_resume() concurrently.

Each worker:
   - reads its initial /proc/self/stat flags and verifies that=20
PF_MEMALLOC_NOIO is not already
     set
   - writes 0 to either suspend_lo or suspend_hi
   - immediately reads its own task flags again
   - reports success if flags & PF_MEMALLOC_NOIO is true after the write=20
returns

Link:=20
https://github.com/chencheng-fnnas/reproducer/blob/main/repro-md-noio-token=
-leak.sh

Fixes: 78f57ef9d50a ("md: use memalloc scope APIs in=20
mddev_suspend()/mddev_resume()")

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---

rfc -> v1:
         - dm-raid side just bypass because suspend and resume not in the
           same task context..

---
  drivers/md/dm-raid.c       |  6 +--
  drivers/md/md-autodetect.c |  5 ++-
  drivers/md/md-bitmap.c     | 12 ++---
  drivers/md/md.c            | 90 +++++++++++++++++++++++---------------
  drivers/md/md.h            | 23 +++++-----
  drivers/md/raid5-cache.c   | 11 +++--
  drivers/md/raid5.c         | 24 +++++-----
  7 files changed, 101 insertions(+), 70 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 8f5a5e1342a9..ce0f562c5da3 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3251,11 +3251,11 @@ static int raid_ctr(struct dm_target *ti,=20
unsigned int argc, char **argv)
  	/* Start raid set read-only and assumed clean to change in=20
raid_resume() */
  	rs->md.ro =3D MD_RDONLY;
  	rs->md.in_sync =3D 1;
   	/* Has to be held on running the array */
-	mddev_suspend_and_lock_nointr(&rs->md);
+	mddev_suspend_and_lock_nointr(&rs->md, NULL);
   	/* Keep array frozen until resume. */
  	md_frozen_sync_thread(&rs->md);
   	r =3D md_run(&rs->md);
@@ -3863,11 +3863,11 @@ static void raid_postsuspend(struct dm_target *ti)
  		/*
  		 * sync_thread must be stopped during suspend, and writes have
  		 * to be stopped before suspending to avoid deadlocks.
  		 */
  		md_stop_writes(&rs->md);
-		mddev_suspend(&rs->md, false);
+		mddev_suspend(&rs->md, false, NULL);
  		rs->md.ro =3D MD_RDONLY;
  	}
  	clear_bit(MD_DM_SUSPENDING, &mddev->flags);
   }
@@ -4141,11 +4141,11 @@ static void raid_resume(struct dm_target *ti)
  						       lockdep_is_held(&mddev->reconfig_mutex)));
  		clear_bit(RT_FLAG_RS_FROZEN, &rs->runtime_flags);
  		mddev->ro =3D MD_RDWR;
  		mddev->in_sync =3D 0;
  		md_unfrozen_sync_thread(mddev);
-		mddev_unlock_and_resume(mddev);
+		mddev_unlock_and_resume(mddev, 0);
  	}
  }
   static struct target_type raid_target =3D {
  	.name =3D "raid",
diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
index 4b80165afd23..58e062cd0580 100644
--- a/drivers/md/md-autodetect.c
+++ b/drivers/md/md-autodetect.c
@@ -126,10 +126,11 @@ static void __init md_setup_drive(struct=20
md_setup_args *args)
  	dev_t devices[MD_SB_DISKS + 1], mdev;
  	struct mdu_array_info_s ainfo =3D { };
  	struct mddev *mddev;
  	int err =3D 0, i;
  	char name[16];
+	unsigned int noio_flags;
   	if (args->partitioned) {
  		mdev =3D MKDEV(mdp_major, args->minor << MdpMinorShift);
  		sprintf(name, "md_d%d", args->minor);
  	} else {
@@ -173,11 +174,11 @@ static void __init md_setup_drive(struct=20
md_setup_args *args)
  	if (IS_ERR(mddev)) {
  		pr_err("md: md_alloc failed - cannot start array %s\n", name);
  		return;
  	}
  -	err =3D mddev_suspend_and_lock(mddev);
+	err =3D mddev_suspend_and_lock(mddev, &noio_flags);
  	if (err) {
  		pr_err("md: failed to lock array %s\n", name);
  		goto out_mddev_put;
  	}
  @@ -219,11 +220,11 @@ static void __init md_setup_drive(struct=20
md_setup_args *args)
  	if (!err)
  		err =3D do_md_run(mddev);
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
  -	rv =3D mddev_suspend_and_lock(mddev);
+	rv =3D mddev_suspend_and_lock(mddev, &noio_flags);
  	if (rv)
  		return rv;
   	if (mddev->pers) {
  		if (mddev->recovery || mddev->sync_thread) {
@@ -2711,11 +2712,11 @@ location_store(struct mddev *mddev, const char=20
*buf, size_t len)
  		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
  		md_wakeup_thread(mddev->thread);
  	}
  	rv =3D 0;
  out:
-	mddev_unlock_and_resume(mddev);
+	mddev_unlock_and_resume(mddev, noio_flags);
  	if (rv)
  		return rv;
  	return len;
   merge_err:
@@ -2831,17 +2832,18 @@ backlog_store(struct mddev *mddev, const char=20
*buf, size_t len)
  {
  	unsigned long backlog;
  	unsigned long old_mwb =3D mddev->bitmap_info.max_write_behind;
  	struct md_rdev *rdev;
  	bool has_write_mostly =3D false;
+	unsigned int noio_flags;
  	int rv =3D kstrtoul(buf, 10, &backlog);
  	if (rv)
  		return rv;
  	if (backlog > COUNTER_MAX)
  		return -EINVAL;
  -	rv =3D mddev_suspend_and_lock(mddev);
+	rv =3D mddev_suspend_and_lock(mddev, &noio_flags);
  	if (rv)
  		return rv;
   	/*
  	 * Without write mostly device, it doesn't make sense to set
@@ -2854,11 +2856,11 @@ backlog_store(struct mddev *mddev, const char=20
*buf, size_t len)
  		}
  	}
  	if (!has_write_mostly) {
  		pr_warn_ratelimited("%s: can't set backlog, no write mostly device=20
available\n",
  				    mdname(mddev));
-		mddev_unlock(mddev);
+		mddev_unlock_and_resume(mddev, noio_flags);
  		return -EINVAL;
  	}
   	mddev->bitmap_info.max_write_behind =3D backlog;
  	if (!backlog && mddev->serial_info_pool) {
@@ -2871,11 +2873,11 @@ backlog_store(struct mddev *mddev, const char=20
*buf, size_t len)
  			mddev_create_serial_pool(mddev, rdev);
  	}
  	if (old_mwb !=3D backlog)
  		bitmap_update_sb(mddev->bitmap);
  -	mddev_unlock_and_resume(mddev);
+	mddev_unlock_and_resume(mddev, noio_flags);
  	return len;
  }
   static struct md_sysfs_entry bitmap_backlog =3D
  __ATTR(backlog, S_IRUGO|S_IWUSR, backlog_show, backlog_store);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1377c407614c..04e10769d5c6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -459,11 +459,12 @@ static void md_submit_bio(struct bio *bio)
   /*
   * Make sure no new requests are submitted to the device, and any=20
requests that
   * have been submitted are completely handled.
   */
-int mddev_suspend(struct mddev *mddev, bool interruptible)
+int mddev_suspend(struct mddev *mddev, bool interruptible,
+		  unsigned int *noio_flags)
  {
  	int err =3D 0;
   	/*
  	 * hold reconfig_mutex to wait for normal io will deadlock, because
@@ -477,11 +478,16 @@ int mddev_suspend(struct mddev *mddev, bool=20
interruptible)
  	else
  		mutex_lock(&mddev->suspend_mutex);
  	if (err)
  		return err;
  +	if (noio_flags)
+		*noio_flags =3D 0;
+
  	if (mddev->suspended) {
+		if (noio_flags && !mddev_is_dm(mddev))
+			*noio_flags =3D memalloc_noio_save();
  		WRITE_ONCE(mddev->suspended, mddev->suspended + 1);
  		mutex_unlock(&mddev->suspend_mutex);
  		return 0;
  	}
  @@ -515,31 +521,31 @@ int mddev_suspend(struct mddev *mddev, bool=20
interruptible)
  	 * prevent deadlock.
  	 */
  	WRITE_ONCE(mddev->suspended, mddev->suspended + 1);
   	/* restrict memory reclaim I/O during raid array is suspend */
-	mddev->noio_flag =3D memalloc_noio_save();
+	if (noio_flags && !mddev_is_dm(mddev))
+		*noio_flags =3D memalloc_noio_save();
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
@@ -547,13 +553,13 @@ static void __mddev_resume(struct mddev *mddev,=20
bool recovery_needed)
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
  static int mddev_set_closing_and_sync_blockdev(struct mddev *mddev,=20
int opener_num)
@@ -3737,10 +3743,11 @@ rdev_attr_store(struct kobject *kobj, struct=20
attribute *attr,
  {
  	struct rdev_sysfs_entry *entry =3D container_of(attr, struct=20
rdev_sysfs_entry, attr);
  	struct md_rdev *rdev =3D container_of(kobj, struct md_rdev, kobj);
  	struct kernfs_node *kn =3D NULL;
  	bool suspend =3D false;
+	unsigned int noio_flags =3D 0;
  	ssize_t rv;
  	struct mddev *mddev =3D READ_ONCE(rdev->mddev);
   	if (!entry->store)
  		return -EIO;
@@ -3756,17 +3763,17 @@ rdev_attr_store(struct kobject *kobj, struct=20
attribute *attr,
  		    cmd_match(page, "writemostly") ||
  		    cmd_match(page, "-writemostly"))
  			suspend =3D true;
  	}
  -	rv =3D suspend ? mddev_suspend_and_lock(mddev) : mddev_lock(mddev);
+	rv =3D suspend ? mddev_suspend_and_lock(mddev, &noio_flags) :=20
mddev_lock(mddev);
  	if (!rv) {
  		if (rdev->mddev =3D=3D NULL)
  			rv =3D -ENODEV;
  		else
  			rv =3D entry->store(rdev, page, length);
-		suspend ? mddev_unlock_and_resume(mddev) : mddev_unlock(mddev);
+		suspend ? mddev_unlock_and_resume(mddev, noio_flags) :=20
mddev_unlock(mddev);
  	}
   	if (kn)
  		sysfs_unbreak_active_protection(kn);
  @@ -4049,15 +4056,16 @@ level_store(struct mddev *mddev, const char=20
*buf, size_t len)
  	size_t slen =3D len;
  	struct md_personality *pers, *oldpers;
  	long level;
  	void *priv, *oldpriv;
  	struct md_rdev *rdev;
+	unsigned int noio_flags;
   	if (slen =3D=3D 0 || slen >=3D sizeof(clevel))
  		return -EINVAL;
  -	rv =3D mddev_suspend_and_lock(mddev);
+	rv =3D mddev_suspend_and_lock(mddev, &noio_flags);
  	if (rv)
  		return rv;
   	if (mddev->pers =3D=3D NULL) {
  		memcpy(mddev->clevel, buf, slen);
@@ -4231,11 +4239,11 @@ level_store(struct mddev *mddev, const char=20
*buf, size_t len)
  		md_update_sb(mddev, 1);
  	sysfs_notify_dirent_safe(mddev->sysfs_level);
  	md_new_event();
  	rv =3D len;
  out_unlock:
-	mddev_unlock_and_resume(mddev);
+	mddev_unlock_and_resume(mddev, noio_flags);
  	return rv;
  }
   static struct md_sysfs_entry md_level =3D
  __ATTR(level, S_IRUGO|S_IWUSR, level_show, level_store);
@@ -4410,17 +4418,18 @@ static int update_raid_disks(struct mddev=20
*mddev, int raid_disks);
   static ssize_t
  raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
  {
  	unsigned int n;
+	unsigned int noio_flags;
  	int err;
   	err =3D kstrtouint(buf, 10, &n);
  	if (err < 0)
  		return err;
  -	err =3D mddev_suspend_and_lock(mddev);
+	err =3D mddev_suspend_and_lock(mddev, &noio_flags);
  	if (err)
  		return err;
  	if (mddev->pers) {
  		if (n !=3D mddev->raid_disks)
  			err =3D update_raid_disks(mddev, n);
@@ -4442,11 +4451,11 @@ raid_disks_store(struct mddev *mddev, const char=20
*buf, size_t len)
  		mddev->raid_disks =3D n;
  		mddev->reshape_backwards =3D (mddev->delta_disks < 0);
  	} else
  		mddev->raid_disks =3D n;
  out_unlock:
-	mddev_unlock_and_resume(mddev);
+	mddev_unlock_and_resume(mddev, noio_flags);
  	return err ? err : len;
  }
  static struct md_sysfs_entry md_raid_disks =3D
  __ATTR(raid_disks, S_IRUGO|S_IWUSR, raid_disks_show, raid_disks_store);
  @@ -4822,10 +4831,11 @@ new_dev_store(struct mddev *mddev, const char=20
*buf, size_t len)
  	char *e;
  	int major =3D simple_strtoul(buf, &e, 10);
  	int minor;
  	dev_t dev;
  	struct md_rdev *rdev;
+	unsigned int noio_flags;
  	int err;
   	if (!*buf || *e !=3D ':' || !e[1] || e[1] =3D=3D '\n')
  		return -EINVAL;
  	minor =3D simple_strtoul(e+1, &e, 10);
@@ -4834,11 +4844,11 @@ new_dev_store(struct mddev *mddev, const char=20
*buf, size_t len)
  	dev =3D MKDEV(major, minor);
  	if (major !=3D MAJOR(dev) ||
  	    minor !=3D MINOR(dev))
  		return -EOVERFLOW;
  -	err =3D mddev_suspend_and_lock(mddev);
+	err =3D mddev_suspend_and_lock(mddev, &noio_flags);
  	if (err)
  		return err;
  	if (mddev->persistent) {
  		rdev =3D md_import_device(dev, mddev->major_version,
  					mddev->minor_version);
@@ -4855,18 +4865,18 @@ new_dev_store(struct mddev *mddev, const char=20
*buf, size_t len)
  		rdev =3D md_import_device(dev, -2, -1);
  	else
  		rdev =3D md_import_device(dev, -1, -1);
   	if (IS_ERR(rdev)) {
-		mddev_unlock_and_resume(mddev);
+		mddev_unlock_and_resume(mddev, noio_flags);
  		return PTR_ERR(rdev);
  	}
  	err =3D bind_rdev_to_array(rdev, mddev);
   out:
  	if (err)
  		export_rdev(rdev);
-	mddev_unlock_and_resume(mddev);
+	mddev_unlock_and_resume(mddev, noio_flags);
  	if (!err)
  		md_new_event();
  	return err ? err : len;
  }
  @@ -5257,28 +5267,29 @@ static int mddev_start_reshape(struct mddev=20
*mddev)
  static ssize_t
  action_store(struct mddev *mddev, const char *page, size_t len)
  {
  	int ret;
  	enum sync_action action;
+	unsigned int noio_flags =3D 0;
   	if (!mddev->pers || !mddev->pers->sync_request)
  		return -EINVAL;
   	action =3D md_sync_action_by_name(page);
  retry:
  	if (work_busy(&mddev->sync_work))
  		flush_work(&mddev->sync_work);
   	ret =3D (action =3D=3D ACTION_RESHAPE) ?
-		mddev_suspend_and_lock(mddev) :
+		mddev_suspend_and_lock(mddev, &noio_flags) :
  		mddev_lock(mddev);
  	if (ret)
  		return ret;
   	if (work_busy(&mddev->sync_work)) {
  		if (action =3D=3D ACTION_RESHAPE)
-			mddev_unlock_and_resume(mddev);
+			mddev_unlock_and_resume(mddev, noio_flags);
  		else
  			mddev_unlock(mddev);
  		goto retry;
  	}
  @@ -5349,11 +5360,11 @@ action_store(struct mddev *mddev, const char=20
*page, size_t len)
  	sysfs_notify_dirent_safe(mddev->sysfs_action);
  	ret =3D len;
   out:
  	if (action =3D=3D ACTION_RESHAPE)
-		mddev_unlock_and_resume(mddev);
+		mddev_unlock_and_resume(mddev, noio_flags);
  	else
  		mddev_unlock(mddev);
  	return ret;
  }
  @@ -5640,24 +5651,25 @@ suspend_lo_show(struct mddev *mddev, char *page)
   static ssize_t
  suspend_lo_store(struct mddev *mddev, const char *buf, size_t len)
  {
  	unsigned long long new;
+	unsigned int noio_flags;
  	int err;
   	err =3D kstrtoull(buf, 10, &new);
  	if (err < 0)
  		return err;
  	if (new !=3D (sector_t)new)
  		return -EINVAL;
  -	err =3D mddev_suspend(mddev, true);
+	err =3D mddev_suspend(mddev, true, &noio_flags);
  	if (err)
  		return err;
   	WRITE_ONCE(mddev->suspend_lo, new);
-	mddev_resume(mddev);
+	mddev_resume(mddev, noio_flags);
   	return len;
  }
  static struct md_sysfs_entry md_suspend_lo =3D
  __ATTR(suspend_lo, S_IRUGO|S_IWUSR, suspend_lo_show, suspend_lo_store);
@@ -5671,24 +5683,25 @@ suspend_hi_show(struct mddev *mddev, char *page)
   static ssize_t
  suspend_hi_store(struct mddev *mddev, const char *buf, size_t len)
  {
  	unsigned long long new;
+	unsigned int noio_flags;
  	int err;
   	err =3D kstrtoull(buf, 10, &new);
  	if (err < 0)
  		return err;
  	if (new !=3D (sector_t)new)
  		return -EINVAL;
  -	err =3D mddev_suspend(mddev, true);
+	err =3D mddev_suspend(mddev, true, &noio_flags);
  	if (err)
  		return err;
   	WRITE_ONCE(mddev->suspend_hi, new);
-	mddev_resume(mddev);
+	mddev_resume(mddev, noio_flags);
   	return len;
  }
  static struct md_sysfs_entry md_suspend_hi =3D
  __ATTR(suspend_hi, S_IRUGO|S_IWUSR, suspend_hi_show, suspend_hi_store);
@@ -5928,19 +5941,20 @@ static ssize_t serialize_policy_show(struct=20
mddev *mddev, char *page)
  static ssize_t
  serialize_policy_store(struct mddev *mddev, const char *buf, size_t len)
  {
  	int err;
  	bool value;
+	unsigned int noio_flags;
   	err =3D kstrtobool(buf, &value);
  	if (err)
  		return err;
   	if (value =3D=3D test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
  		return len;
  -	err =3D mddev_suspend_and_lock(mddev);
+	err =3D mddev_suspend_and_lock(mddev, &noio_flags);
  	if (err)
  		return err;
  	if (mddev->pers =3D=3D NULL || (mddev->pers->head.id !=3D ID_RAID1)) {
  		pr_err("md: serialize_policy is only effective for raid1\n");
  		err =3D -EINVAL;
@@ -5953,11 +5967,11 @@ serialize_policy_store(struct mddev *mddev,=20
const char *buf, size_t len)
  	} else {
  		mddev_destroy_serial_pool(mddev, NULL);
  		clear_bit(MD_SERIALIZE_POLICY, &mddev->flags);
  	}
  unlock:
-	mddev_unlock_and_resume(mddev);
+	mddev_unlock_and_resume(mddev, noio_flags);
  	return err ?: len;
  }
   static struct md_sysfs_entry md_serialize_policy =3D
  __ATTR(serialize_policy, S_IRUGO | S_IWUSR, serialize_policy_show,
@@ -6263,21 +6277,22 @@ EXPORT_SYMBOL_GPL(mddev_stack_new_rdev);
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
  	lim =3D queue_limits_start_update(mddev->gendisk->queue);
  	lim.io_opt =3D lim.io_min * nr_stripes;
  	queue_limits_commit_update(mddev->gendisk->queue, &lim);
-	mddev_resume(mddev);
+	mddev_resume(mddev, noio_flags);
  }
  EXPORT_SYMBOL_GPL(mddev_update_io_opt);
   static void mddev_delayed_delete(struct work_struct *ws)
  {
@@ -7255,10 +7270,11 @@ static void autorun_array(struct mddev *mddev)
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
@@ -7295,27 +7311,27 @@ static void autorun_devices(int part)
   		mddev =3D md_alloc(dev, NULL);
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
  			mddev->persistent =3D 1;
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
@@ -8329,10 +8345,11 @@ static int __md_set_array_info(struct mddev=20
*mddev, void __user *argp)
   static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
  			unsigned int cmd, unsigned long arg)
  {
  	int err =3D 0;
+	unsigned int noio_flags =3D 0;
  	void __user *argp =3D (void __user *)arg;
  	struct mddev *mddev =3D NULL;
   	err =3D md_ioctl_valid(cmd);
  	if (err)
@@ -8380,11 +8397,11 @@ static int md_ioctl(struct block_device *bdev,=20
blk_mode_t mode,
  	}
   	if (!md_is_rdwr(mddev))
  		flush_work(&mddev->sync_work);
  -	err =3D md_ioctl_need_suspend(cmd) ? mddev_suspend_and_lock(mddev) :
+	err =3D md_ioctl_need_suspend(cmd) ? mddev_suspend_and_lock(mddev,=20
&noio_flags) :
  					   mddev_lock(mddev);
  	if (err) {
  		pr_debug("md: ioctl lock interrupted, reason %d, cmd %d\n",
  			 err, cmd);
  		goto out;
@@ -8511,11 +8528,11 @@ static int md_ioctl(struct block_device *bdev,=20
blk_mode_t mode,
  unlock:
  	if (mddev->hold_active =3D=3D UNTIL_IOCTL &&
  	    err !=3D -EINVAL)
  		mddev->hold_active =3D 0;
  -	md_ioctl_need_suspend(cmd) ? mddev_unlock_and_resume(mddev) :
+	md_ioctl_need_suspend(cmd) ? mddev_unlock_and_resume(mddev, noio_flags) :
  				     mddev_unlock(mddev);
   out:
  	if (cmd =3D=3D STOP_ARRAY_RO || (err && cmd =3D=3D STOP_ARRAY))
  		clear_bit(MD_CLOSING, &mddev->flags);
@@ -10180,20 +10197,21 @@ static bool md_choose_sync_action(struct mddev=20
*mddev, int *spares)
  static void md_start_sync(struct work_struct *ws)
  {
  	struct mddev *mddev =3D container_of(ws, struct mddev, sync_work);
  	int spares =3D 0;
  	bool suspend =3D false;
+	unsigned int noio_flags =3D 0;
  	char *name;
   	/*
  	 * If reshape is still in progress, spares won't be added or removed
  	 * from conf until reshape is done.
  	 */
  	if (mddev->reshape_position =3D=3D MaxSector &&
  	    md_spares_need_change(mddev)) {
  		suspend =3D true;
-		mddev_suspend(mddev, false);
+		mddev_suspend(mddev, false, &noio_flags);
  	}
   	mddev_lock_nointr(mddev);
  	if (!md_is_rdwr(mddev)) {
  		/*
@@ -10237,11 +10255,11 @@ static void md_start_sync(struct work_struct *ws)
  	 * not set it again. Otherwise, we may cause issue like this one:
  	 *     https://bugzilla.kernel.org/show_bug.cgi?id=3D218200
  	 * Therefore, use __mddev_resume(mddev, false).
  	 */
  	if (suspend)
-		__mddev_resume(mddev, false);
+		__mddev_resume(mddev, false, noio_flags);
  	md_wakeup_thread(mddev->sync_thread);
  	sysfs_notify_dirent_safe(mddev->sysfs_action);
  	md_new_event();
  	return;
  @@ -10257,11 +10275,11 @@ static void md_start_sync(struct work_struct=20
*ws)
  	 * not set it again. Otherwise, we may cause issue like this one:
  	 *     https://bugzilla.kernel.org/show_bug.cgi?id=3D218200
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
index d8daf0f75cbb..7d92deea34f2 100644
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
@@ -999,35 +999,38 @@ static inline void mddev_check_write_zeroes(struct=20
mddev *mddev, struct bio *bio
  	if (bio_op(bio) =3D=3D REQ_OP_WRITE_ZEROES &&
  	    !bio->bi_bdev->bd_disk->queue->limits.max_write_zeroes_sectors)
  		mddev->gendisk->queue->limits.max_write_zeroes_sectors =3D 0;
  }
  -static inline int mddev_suspend_and_lock(struct mddev *mddev)
+static inline int mddev_suspend_and_lock(struct mddev *mddev,
+					 unsigned int *noio_flags)
  {
  	int ret;
  -	ret =3D mddev_suspend(mddev, true);
+	ret =3D mddev_suspend(mddev, true, noio_flags);
  	if (ret)
  		return ret;
   	ret =3D mddev_lock(mddev);
  	if (ret)
-		mddev_resume(mddev);
+		mddev_resume(mddev, noio_flags ? *noio_flags : 0);
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
@@ -693,13 +693,15 @@ static void r5c_disable_writeback_async(struct=20
work_struct *work)
  		   !READ_ONCE(conf->log) ||
  		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
   	log =3D READ_ONCE(conf->log);
  	if (log) {
-		mddev_suspend(mddev, false);
+		unsigned int noio_flags;
+
+		mddev_suspend(mddev, false, &noio_flags);
  		log->r5c_journal_mode =3D R5C_JOURNAL_MODE_WRITE_THROUGH;
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
  	int mode =3D ARRAY_SIZE(r5c_journal_mode_str);
  	size_t len =3D length;
+	unsigned int noio_flags;
  	int ret;
   	if (len < 2)
  		return -EINVAL;
  @@ -2615,15 +2618,15 @@ static ssize_t r5c_journal_mode_store(struct=20
mddev *mddev,
   	while (mode--)
  		if (strlen(r5c_journal_mode_str[mode]) =3D=3D len &&
  		    !strncmp(page, r5c_journal_mode_str[mode], len))
  			break;
-	ret =3D mddev_suspend_and_lock(mddev);
+	ret =3D mddev_suspend_and_lock(mddev, &noio_flags);
  	if (ret)
  		return ret;
  	ret =3D r5c_journal_mode_set(mddev, mode);
-	mddev_unlock_and_resume(mddev);
+	mddev_unlock_and_resume(mddev, noio_flags);
  	return ret ?: length;
  }
   struct md_sysfs_entry
  r5c_journal_mode =3D __ATTR(journal_mode, 0644,
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 65ae7d8930fc..482872ae7198 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6993,10 +6993,11 @@ raid5_show_stripe_size(struct mddev  *mddev,=20
char *page)
  static ssize_t
  raid5_store_stripe_size(struct mddev  *mddev, const char *page, size_t=20
len)
  {
  	struct r5conf *conf;
  	unsigned long new;
+	unsigned int noio_flags;
  	int err;
  	int size;
   	if (len >=3D PAGE_SIZE)
  		return -EINVAL;
@@ -7011,11 +7012,11 @@ raid5_store_stripe_size(struct mddev  *mddev,=20
const char *page, size_t len)
  	if (new % DEFAULT_STRIPE_SIZE !=3D 0 ||
  			new > PAGE_SIZE || new =3D=3D 0 ||
  			new !=3D roundup_pow_of_two(new))
  		return -EINVAL;
  -	err =3D mddev_suspend_and_lock(mddev);
+	err =3D mddev_suspend_and_lock(mddev, &noio_flags);
  	if (err)
  		return err;
   	conf =3D mddev->private;
  	if (!conf) {
@@ -7049,11 +7050,11 @@ raid5_store_stripe_size(struct mddev  *mddev,=20
const char *page, size_t len)
  		err =3D -ENOMEM;
  	}
  	mutex_unlock(&conf->cache_size_mutex);
   out_unlock:
-	mddev_unlock_and_resume(mddev);
+	mddev_unlock_and_resume(mddev, noio_flags);
  	return err ?: len;
  }
   static struct md_sysfs_entry
  raid5_stripe_size =3D __ATTR(stripe_size, 0644,
@@ -7127,19 +7128,20 @@ raid5_show_skip_copy(struct mddev *mddev, char=20
*page)
  static ssize_t
  raid5_store_skip_copy(struct mddev *mddev, const char *page, size_t len)
  {
  	struct r5conf *conf;
  	unsigned long new;
+	unsigned int noio_flags;
  	int err;
   	if (len >=3D PAGE_SIZE)
  		return -EINVAL;
  	if (kstrtoul(page, 10, &new))
  		return -EINVAL;
  	new =3D !!new;
  -	err =3D mddev_suspend_and_lock(mddev);
+	err =3D mddev_suspend_and_lock(mddev, &noio_flags);
  	if (err)
  		return err;
  	conf =3D mddev->private;
  	if (!conf)
  		err =3D -ENODEV;
@@ -7152,11 +7154,11 @@ raid5_store_skip_copy(struct mddev *mddev, const=20
char *page, size_t len)
  			lim.features |=3D BLK_FEAT_STABLE_WRITES;
  		else
  			lim.features &=3D ~BLK_FEAT_STABLE_WRITES;
  		err =3D queue_limits_commit_update(q, &lim);
  	}
-	mddev_unlock_and_resume(mddev);
+	mddev_unlock_and_resume(mddev, noio_flags);
  	return err ?: len;
  }
   static struct md_sysfs_entry
  raid5_skip_copy =3D __ATTR(skip_copy, S_IRUGO | S_IWUSR,
@@ -7195,10 +7197,11 @@ static int alloc_thread_groups(struct r5conf=20
*conf, int cnt,
  static ssize_t
  raid5_store_group_thread_cnt(struct mddev *mddev, const char *page,=20
size_t len)
  {
  	struct r5conf *conf;
  	unsigned int new;
+	unsigned int noio_flags;
  	int err;
  	struct r5worker_group *new_groups, *old_groups;
  	int group_cnt;
   	if (len >=3D PAGE_SIZE)
@@ -7207,16 +7210,16 @@ raid5_store_group_thread_cnt(struct mddev=20
*mddev, const char *page, size_t len)
  		return -EINVAL;
  	/* 8192 should be big enough */
  	if (new > 8192)
  		return -EINVAL;
  -	err =3D mddev_suspend_and_lock(mddev);
+	err =3D mddev_suspend_and_lock(mddev, &noio_flags);
  	if (err)
  		return err;
  	conf =3D mddev->private;
  	if (!conf) {
-		mddev_unlock_and_resume(mddev);
+		mddev_unlock_and_resume(mddev, noio_flags);
  		return -ENODEV;
  	}
  	raid5_quiesce(mddev, true);
   	if (new !=3D conf->worker_cnt_per_group) {
@@ -7237,11 +7240,11 @@ raid5_store_group_thread_cnt(struct mddev=20
*mddev, const char *page, size_t len)
  			kfree(old_groups);
  		}
  	}
   	raid5_quiesce(mddev, false);
-	mddev_unlock_and_resume(mddev);
+	mddev_unlock_and_resume(mddev, noio_flags);
   	return err ?: len;
  }
   static struct md_sysfs_entry
@@ -8940,18 +8943,19 @@ static void *raid6_takeover(struct mddev *mddev)
  }
   static int raid5_change_consistency_policy(struct mddev *mddev, const=20
char *buf)
  {
  	struct r5conf *conf;
+	unsigned int noio_flags;
  	int err;
  -	err =3D mddev_suspend_and_lock(mddev);
+	err =3D mddev_suspend_and_lock(mddev, &noio_flags);
  	if (err)
  		return err;
  	conf =3D mddev->private;
  	if (!conf) {
-		mddev_unlock_and_resume(mddev);
+		mddev_unlock_and_resume(mddev, noio_flags);
  		return -ENODEV;
  	}
   	if (strncmp(buf, "ppl", 3) =3D=3D 0) {
  		/* ppl only works with RAID 5 */
@@ -8990,11 +8994,11 @@ static int=20
raid5_change_consistency_policy(struct mddev *mddev, const char *buf)
  	}
   	if (!err)
  		md_update_sb(mddev, 1);
  -	mddev_unlock_and_resume(mddev);
+	mddev_unlock_and_resume(mddev, noio_flags);
   	return err;
  }
   static int raid5_start(struct mddev *mddev)
--=20
2.54.0
