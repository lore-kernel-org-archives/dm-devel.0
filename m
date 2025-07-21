Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A342E1C5B;
	Mon, 21 Jul 2025 17:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753118225; cv=none; b=kzZuN/nOPUn6xRc886nq7WPEFf+aY59+9CcUEYF569KSeEnbtqrxh8sJkt7cxfjkeaqp1hKcy47fI5g7DWXHIb21k6xYMRvLVD6GzR1df0SIdhiD+pm7/mNycYxQPXkjr57AsCGJL/40lsQYShlViPf1OEk4KCk+pUkVCRRMNwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753118225; c=relaxed/simple;
	bh=5pgc4zXOdXGuNX2ZLbAwWqKRstkVZ5qA3HXDdsREGNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mD4DSAGXtycmjMP7wio9ZVoDCSYDCwMOIRsXQrUyqWfLP78FdG5I7mUIt4mTeewQoNzn8bvJMOpR8WwPcoZQ8avEeQcIAjt9VncCc92IihoV5c+0b7jXD8qRd3OSu5d5VnHy24HHCQrm4R9JBDAVSsOmytKBInzrFCQTfi+uLUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=COmKAdqz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="COmKAdqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C475AC4CEF6;
	Mon, 21 Jul 2025 17:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753118225;
	bh=5pgc4zXOdXGuNX2ZLbAwWqKRstkVZ5qA3HXDdsREGNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=COmKAdqzdbVEJjWfOYFrCG39bqVsXgcLAefSlZACWlzZoxbl/PF7TaqNZPwufpKWX
	 dHIkJiVPqiLx62NtwxCT6Yx7LuYGYVEzDIPWnTnLrs9Y5vMrnNMJ8jy5RV0QT6VBm2
	 ubWXTL4Ylj8zpU9k+mBmSF3Ws5n37SGof5YPxroqUWLFfSTyoUrJ9VddjB24GuaIdN
	 jPnFWaGt0BatovlRTMZxDIJgdqjjjkZOxYPfzyFuagDVbMx5Rd+QqvyMrw/SOS+SxO
	 //fYq0AVzFd7fS1nxvzy20pDBO+hfjaExMekjoKxHhbYYKO3GLQzvUOcdqoQrP9zxV
	 tsN2O6iY3xBTg==
From: Yu Kuai <yukuai@kernel.org>
To: corbet@lwn.net,
	agk@redhat.co,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	hch@lst.de,
	song@kernel.org,
	hare@suse.de
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v4 06/11] md/md-bitmap: delay registration of bitmap_ops until creating bitmap
Date: Tue, 22 Jul 2025 01:15:52 +0800
Message-ID: <20250721171557.34587-7-yukuai@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250721171557.34587-1-yukuai@kernel.org>
References: <20250721171557.34587-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

Currently bitmap_ops is registered while allocating mddev, this is fine
when there is only one bitmap_ops.

Delay setting bitmap_ops until creating bitmap, so that user can choose
which bitmap to use before running the array.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 Documentation/admin-guide/md.rst |  3 ++
 drivers/md/md.c                  | 81 ++++++++++++++++++++------------
 2 files changed, 55 insertions(+), 29 deletions(-)

diff --git a/Documentation/admin-guide/md.rst b/Documentation/admin-guide/md.rst
index 356d2a344f08..001363f81850 100644
--- a/Documentation/admin-guide/md.rst
+++ b/Documentation/admin-guide/md.rst
@@ -388,6 +388,9 @@ All md devices contain:
      bitmap
          The default internal bitmap
 
+If bitmap_type is not none, then additional bitmap attributes bitmap/xxx or
+llbitmap/xxx will be created after md device KOBJ_CHANGE event.
+
 If bitmap_type is bitmap, then the md device will also contain:
 
   bitmap/location
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 41da352ccbde..744cac10506b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -671,9 +671,11 @@ static void no_op(struct percpu_ref *r) {}
 
 static bool mddev_set_bitmap_ops(struct mddev *mddev)
 {
+	struct bitmap_operations *old = mddev->bitmap_ops;
 	struct md_submodule_head *head;
 
-	if (mddev->bitmap_id == ID_BITMAP_NONE)
+	if (mddev->bitmap_id == ID_BITMAP_NONE ||
+	    (old && old->head.id == mddev->bitmap_id))
 		return true;
 
 	xa_lock(&md_submodule);
@@ -691,6 +693,18 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev)
 
 	mddev->bitmap_ops = (void *)head;
 	xa_unlock(&md_submodule);
+
+	if (mddev->bitmap_ops->group) {
+		if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
+			pr_warn("md: cannot register extra bitmap attributes for %s\n",
+				mdname(mddev));
+		else
+			/*
+			 * Inform user with KOBJ_CHANGE about new bitmap
+			 * attributes.
+			 */
+			kobject_uevent(&mddev->kobj, KOBJ_CHANGE);
+	}
 	return true;
 
 err:
@@ -700,28 +714,25 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev)
 
 static void mddev_clear_bitmap_ops(struct mddev *mddev)
 {
+	if (mddev->bitmap_ops && mddev->bitmap_ops->group)
+		sysfs_remove_group(&mddev->kobj, mddev->bitmap_ops->group);
+
 	mddev->bitmap_ops = NULL;
 }
 
 int mddev_init(struct mddev *mddev)
 {
-	if (!IS_ENABLED(CONFIG_MD_BITMAP)) {
+	if (!IS_ENABLED(CONFIG_MD_BITMAP))
 		mddev->bitmap_id = ID_BITMAP_NONE;
-	} else {
+	else
 		mddev->bitmap_id = ID_BITMAP;
-		if (!mddev_set_bitmap_ops(mddev))
-			return -EINVAL;
-	}
 
 	if (percpu_ref_init(&mddev->active_io, active_io_release,
-			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
-		mddev_clear_bitmap_ops(mddev);
+			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
 		return -ENOMEM;
-	}
 
 	if (percpu_ref_init(&mddev->writes_pending, no_op,
 			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
-		mddev_clear_bitmap_ops(mddev);
 		percpu_ref_exit(&mddev->active_io);
 		return -ENOMEM;
 	}
@@ -759,7 +770,6 @@ EXPORT_SYMBOL_GPL(mddev_init);
 
 void mddev_destroy(struct mddev *mddev)
 {
-	mddev_clear_bitmap_ops(mddev);
 	percpu_ref_exit(&mddev->active_io);
 	percpu_ref_exit(&mddev->writes_pending);
 }
@@ -6137,11 +6147,6 @@ struct mddev *md_alloc(dev_t dev, char *name)
 		return ERR_PTR(error);
 	}
 
-	if (md_bitmap_registered(mddev) && mddev->bitmap_ops->group)
-		if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
-			pr_warn("md: cannot register extra bitmap attributes for %s\n",
-				mdname(mddev));
-
 	kobject_uevent(&mddev->kobj, KOBJ_ADD);
 	mddev->sysfs_state = sysfs_get_dirent_safe(mddev->kobj.sd, "array_state");
 	mddev->sysfs_level = sysfs_get_dirent_safe(mddev->kobj.sd, "level");
@@ -6217,6 +6222,26 @@ static void md_safemode_timeout(struct timer_list *t)
 
 static int start_dirty_degraded;
 
+static int md_bitmap_create(struct mddev *mddev)
+{
+	if (mddev->bitmap_id == ID_BITMAP_NONE)
+		return -EINVAL;
+
+	if (!mddev_set_bitmap_ops(mddev))
+		return -ENOENT;
+
+	return mddev->bitmap_ops->create(mddev);
+}
+
+static void md_bitmap_destroy(struct mddev *mddev)
+{
+	if (!md_bitmap_registered(mddev))
+		return;
+
+	mddev->bitmap_ops->destroy(mddev);
+	mddev_clear_bitmap_ops(mddev);
+}
+
 int md_run(struct mddev *mddev)
 {
 	int err;
@@ -6381,9 +6406,9 @@ int md_run(struct mddev *mddev)
 			(unsigned long long)pers->size(mddev, 0, 0) / 2);
 		err = -EINVAL;
 	}
-	if (err == 0 && pers->sync_request && md_bitmap_registered(mddev) &&
+	if (err == 0 && pers->sync_request &&
 	    (mddev->bitmap_info.file || mddev->bitmap_info.offset)) {
-		err = mddev->bitmap_ops->create(mddev);
+		err = md_bitmap_create(mddev);
 		if (err)
 			pr_warn("%s: failed to create bitmap (%d)\n",
 				mdname(mddev), err);
@@ -6456,8 +6481,7 @@ int md_run(struct mddev *mddev)
 		pers->free(mddev, mddev->private);
 	mddev->private = NULL;
 	put_pers(pers);
-	if (md_bitmap_registered(mddev))
-		mddev->bitmap_ops->destroy(mddev);
+	md_bitmap_destroy(mddev);
 abort:
 	bioset_exit(&mddev->io_clone_set);
 exit_sync_set:
@@ -6480,7 +6504,7 @@ int do_md_run(struct mddev *mddev)
 	if (md_bitmap_registered(mddev)) {
 		err = mddev->bitmap_ops->load(mddev);
 		if (err) {
-			mddev->bitmap_ops->destroy(mddev);
+			md_bitmap_destroy(mddev);
 			goto out;
 		}
 	}
@@ -6666,8 +6690,7 @@ static void __md_stop(struct mddev *mddev)
 {
 	struct md_personality *pers = mddev->pers;
 
-	if (md_bitmap_registered(mddev))
-		mddev->bitmap_ops->destroy(mddev);
+	md_bitmap_destroy(mddev);
 	mddev_detach(mddev);
 	spin_lock(&mddev->lock);
 	mddev->pers = NULL;
@@ -7443,16 +7466,16 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 	err = 0;
 	if (mddev->pers) {
 		if (fd >= 0) {
-			err = mddev->bitmap_ops->create(mddev);
+			err = md_bitmap_create(mddev);
 			if (!err)
 				err = mddev->bitmap_ops->load(mddev);
 
 			if (err) {
-				mddev->bitmap_ops->destroy(mddev);
+				md_bitmap_destroy(mddev);
 				fd = -1;
 			}
 		} else if (fd < 0) {
-			mddev->bitmap_ops->destroy(mddev);
+			md_bitmap_destroy(mddev);
 		}
 	}
 
@@ -7767,12 +7790,12 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				mddev->bitmap_info.default_offset;
 			mddev->bitmap_info.space =
 				mddev->bitmap_info.default_space;
-			rv = mddev->bitmap_ops->create(mddev);
+			rv = md_bitmap_create(mddev);
 			if (!rv)
 				rv = mddev->bitmap_ops->load(mddev);
 
 			if (rv)
-				mddev->bitmap_ops->destroy(mddev);
+				md_bitmap_destroy(mddev);
 		} else {
 			struct md_bitmap_stats stats;
 
@@ -7798,7 +7821,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				put_cluster_ops(mddev);
 				mddev->safemode_delay = DEFAULT_SAFEMODE_DELAY;
 			}
-			mddev->bitmap_ops->destroy(mddev);
+			md_bitmap_destroy(mddev);
 			mddev->bitmap_info.offset = 0;
 		}
 	}
-- 
2.43.0

