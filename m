Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E257824E00D
	for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 16:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945539; cv=none; b=lEUxE3wccJyKV/zO8RzfGAEjNx3dlOB858/U2SYog2GKKEHdBXkxLUTG8jl+jVB7mdaCsRvGUW0rJ67nDof/Vz2GjMe0fToLIAsNzZMUDxgTB+Z2eVjDAIA1tPCM2x2TMvrsBLwWCI4ldmKMKJCBKQLDiQ16ICIPYwgrTVpSBsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945539; c=relaxed/simple;
	bh=EfD/o66GX0OKRvbZSaNzNHske3QcGjcjuQjaULquzI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TK3EDnfzwuqAT8otg44wE/iggeZKOZ5jyGeeQnEU6laFpmdvK1Sx3SY/Z5IIdoHH8CU9Lmhh9dhdKvYlD3KUlJFipQf1/wRpaf1POXjfWuElMfJ2B5X3NVLXg28J8tyBK9AOwTBqFsz5qiaixfmu/mYTSOC1YsfT+yVFsOjAFCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D3EV/UUV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D3EV/UUV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745945536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pvlclyJOdlodk0vJ4LxFoHs9tOLTNVW8rNQpOB1HHMg=;
	b=D3EV/UUVq4jkCeN/3M4rM8xkobDu5aC5Vo4oC6czyS9NwqoDf0MG3wCjOAfIBKHBafq0m1
	LDTtp7mpQGylQ38q7V7vQQOBcNfZpBEAZN2yzABLfQdvxE1veK4MhRyE2e9QJp1LUP6loN
	yUivCmyVpgVryC0gU1nuYywq8PxVGNM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-259-Miky6MDoPh2AYYmMSFCl3Q-1; Tue,
 29 Apr 2025 12:52:14 -0400
X-MC-Unique: Miky6MDoPh2AYYmMSFCl3Q-1
X-Mimecast-MFC-AGG-ID: Miky6MDoPh2AYYmMSFCl3Q_1745945533
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BD6AF195609F;
	Tue, 29 Apr 2025 16:52:13 +0000 (UTC)
Received: from merkur.redhat.com (unknown [10.44.34.64])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AA8A21956094;
	Tue, 29 Apr 2025 16:52:11 +0000 (UTC)
From: Kevin Wolf <kwolf@redhat.com>
To: dm-devel@lists.linux.dev
Cc: kwolf@redhat.com,
	hreitz@redhat.com,
	mpatocka@redhat.com,
	snitzer@kernel.org,
	bmarzins@redhat.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] dm mpath: Interface for explicit probing of active paths
Date: Tue, 29 Apr 2025 18:50:18 +0200
Message-ID: <20250429165018.112999-3-kwolf@redhat.com>
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

Multipath cannot directly provide failover for ioctls in the kernel
because it doesn't know what each ioctl means and which result could
indicate a path error. Userspace generally knows what the ioctl it
issued means and if it might be a path error, but neither does it know
which path the ioctl took nor does it necessarily have the privileges to
fail a path using the control device.

In order to allow userspace to address this situation, implement a
DM_MPATH_PROBE_PATHS ioctl that prompts the dm-mpath driver to probe all
active paths in the current path group to see whether they still work,
and fail them if not. If this returns success, userspace can retry the
ioctl and expect that the previously hit bad path is now failed (or
working again).

The immediate motivation for this is the use of SG_IO in QEMU for SCSI
passthrough. Following a failed SG_IO ioctl, QEMU will trigger probing
to ensure that all active paths are actually alive, so that retrying
SG_IO at least has a lower chance of failing due to a path error.
However, the problem is broader than just SG_IO (it affects any ioctl),
and if applications need failover support for other ioctls, the same
probing can be used.

This is not implemented on the DM control device, but on the DM mpath
block devices, to allow all users who have access to such a block device
to make use of this interface, specifically to implement failover for
ioctls. For the same reason, it is also unprivileged. Its implementation
is effectively just a bunch of reads, which could already be issued by
userspace, just without any guarantee that all the rights paths are
selected.

The probing implemented here is done fully synchronously path by path;
probing all paths concurrently is left as an improvement for the future.

Co-developed-by: Hanna Czenczek <hreitz@redhat.com>
Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
Signed-off-by: Kevin Wolf <kwolf@redhat.com>
---
 include/uapi/linux/dm-ioctl.h |  9 +++-
 drivers/md/dm-ioctl.c         |  1 +
 drivers/md/dm-mpath.c         | 91 ++++++++++++++++++++++++++++++++++-
 3 files changed, 98 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/dm-ioctl.h b/include/uapi/linux/dm-ioctl.h
index b08c7378164d..3225e025e30e 100644
--- a/include/uapi/linux/dm-ioctl.h
+++ b/include/uapi/linux/dm-ioctl.h
@@ -258,10 +258,12 @@ enum {
 	DM_DEV_SET_GEOMETRY_CMD,
 	DM_DEV_ARM_POLL_CMD,
 	DM_GET_TARGET_VERSION_CMD,
+	DM_MPATH_PROBE_PATHS_CMD,
 };
 
 #define DM_IOCTL 0xfd
 
+/* Control device ioctls */
 #define DM_VERSION       _IOWR(DM_IOCTL, DM_VERSION_CMD, struct dm_ioctl)
 #define DM_REMOVE_ALL    _IOWR(DM_IOCTL, DM_REMOVE_ALL_CMD, struct dm_ioctl)
 #define DM_LIST_DEVICES  _IOWR(DM_IOCTL, DM_LIST_DEVICES_CMD, struct dm_ioctl)
@@ -285,10 +287,13 @@ enum {
 #define DM_TARGET_MSG	 _IOWR(DM_IOCTL, DM_TARGET_MSG_CMD, struct dm_ioctl)
 #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
 
+/* Block device ioctls */
+#define DM_MPATH_PROBE_PATHS _IO(DM_IOCTL, DM_MPATH_PROBE_PATHS_CMD)
+
 #define DM_VERSION_MAJOR	4
-#define DM_VERSION_MINOR	49
+#define DM_VERSION_MINOR	50
 #define DM_VERSION_PATCHLEVEL	0
-#define DM_VERSION_EXTRA	"-ioctl (2025-01-17)"
+#define DM_VERSION_EXTRA	"-ioctl (2025-04-28)"
 
 /* Status bits */
 #define DM_READONLY_FLAG	(1 << 0) /* In/Out */
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index d42eac944eb5..4165fef4c170 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1885,6 +1885,7 @@ static ioctl_fn lookup_ioctl(unsigned int cmd, int *ioctl_flags)
 		{DM_DEV_SET_GEOMETRY_CMD, 0, dev_set_geometry},
 		{DM_DEV_ARM_POLL_CMD, IOCTL_FLAGS_NO_PARAMS, dev_arm_poll},
 		{DM_GET_TARGET_VERSION_CMD, 0, get_target_version},
+		{DM_MPATH_PROBE_PATHS_CMD, 0, NULL}, /* block device ioctl */
 	};
 
 	if (unlikely(cmd >= ARRAY_SIZE(_ioctls)))
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 909ed6890ba5..af17a35c6457 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -2021,6 +2021,85 @@ static int multipath_message(struct dm_target *ti, unsigned int argc, char **arg
 	return r;
 }
 
+/*
+ * Perform a minimal read from the given path to find out whether the
+ * path still works.  If a path error occurs, fail it.
+ */
+static int probe_path(struct pgpath *pgpath)
+{
+	struct block_device *bdev = pgpath->path.dev->bdev;
+	unsigned int read_size = bdev_logical_block_size(bdev);
+	struct page *page;
+	struct bio *bio;
+	blk_status_t status;
+	int r = 0;
+
+	if (WARN_ON_ONCE(read_size > PAGE_SIZE))
+		return -EINVAL;
+
+	page = alloc_page(GFP_KERNEL);
+	if (!page)
+		return -ENOMEM;
+
+	/* Perform a minimal read: Sector 0, length read_size */
+	bio = bio_alloc(bdev, 1, REQ_OP_READ, GFP_KERNEL);
+	if (!bio) {
+		r = -ENOMEM;
+		goto out;
+	}
+
+	bio->bi_iter.bi_sector = 0;
+	__bio_add_page(bio, page, read_size, 0);
+	submit_bio_wait(bio);
+	status = bio->bi_status;
+	bio_put(bio);
+
+	if (status && blk_path_error(status))
+		fail_path(pgpath);
+
+out:
+	__free_page(page);
+	return r;
+}
+
+/*
+ * Probe all active paths in current_pg to find out whether they still work.
+ * Fail all paths that do not work.
+ *
+ * Return -ENOTCONN if no valid path is left (even outside of current_pg). We
+ * cannot probe paths in other pgs without switching current_pg, so if valid
+ * paths are only in different pgs, they may or may not work. Userspace can
+ * submit a request and we'll switch. If the request fails, it may need to
+ * probe again.
+ */
+static int probe_active_paths(struct multipath *m)
+{
+	struct pgpath *pgpath;
+	struct priority_group *pg;
+	int r = 0;
+
+	mutex_lock(&m->work_mutex);
+
+	pg = READ_ONCE(m->current_pg);
+	if (pg) {
+		list_for_each_entry(pgpath, &pg->pgpaths, list) {
+			if (!pgpath->is_active)
+				continue;
+
+			r = probe_path(pgpath);
+			if (r < 0)
+				goto out;
+		}
+	}
+
+	if (!atomic_read(&m->nr_valid_paths))
+		r = -ENOTCONN;
+
+out:
+	mutex_unlock(&m->work_mutex);
+	return r;
+}
+
 static int multipath_prepare_ioctl(struct dm_target *ti,
 				   struct block_device **bdev,
 				   unsigned int cmd, unsigned long arg,
@@ -2031,6 +2110,16 @@ static int multipath_prepare_ioctl(struct dm_target *ti,
 	unsigned long flags;
 	int r;
 
+	if (_IOC_TYPE(cmd) == DM_IOCTL) {
+		*forward = false;
+		switch (cmd) {
+		case DM_MPATH_PROBE_PATHS:
+			return probe_active_paths(m);
+		default:
+			return -ENOTTY;
+		}
+	}
+
 	pgpath = READ_ONCE(m->current_pgpath);
 	if (!pgpath || !mpath_double_check_test_bit(MPATHF_QUEUE_IO, m))
 		pgpath = choose_pgpath(m, 0);
@@ -2182,7 +2271,7 @@ static int multipath_busy(struct dm_target *ti)
  */
 static struct target_type multipath_target = {
 	.name = "multipath",
-	.version = {1, 14, 0},
+	.version = {1, 15, 0},
 	.features = DM_TARGET_SINGLETON | DM_TARGET_IMMUTABLE |
 		    DM_TARGET_PASSES_INTEGRITY,
 	.module = THIS_MODULE,
-- 
2.49.0

