Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821F81CD2C
	for <dm-devel@lists.linux.dev>; Mon,  1 Dec 2025 23:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764633571; cv=none; b=aF5Q9PVO4IOUAwj+zbUxO+MZfy/gWzvU7++FpyAm6ywccnljdsZ3G7htqI7x2tK28BFmju2r7hcZ6p33MDAook+Kai79VLfiDyzUIXpFjCMACWwXFuTGEsB8DSVQ5zqEcJod0Vsboe2LOK5C9Gz28humVOhgTBUtqEf7pIf/5nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764633571; c=relaxed/simple;
	bh=UGt6IpCBpo8ozza4HkQjmCfQT15qXL4QO0efQfElv+g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Omot5gTq2rtHBEtJqOdfeWDtMtlsBJFkKaxgrxFrS72f4OquJewU3xAPN/XOxNH7D9+WP583GGij4Wt2N8PErMdr7wtX+A9yyK/IIB94VAUAFOpdAhYiST02GGKKz4HFhftMQacn6yv8RAUoo+n72AGhCS05nUWgbf4CTIyssnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=bdabgpCA; arc=none smtp.client-ip=74.125.224.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="bdabgpCA"
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-64107188baeso4335464d50.3
        for <dm-devel@lists.linux.dev>; Mon, 01 Dec 2025 15:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1764633568; x=1765238368; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GUKsHCpubiKWQ2tOZNiZ9dmQDUX8wlWXJdrcCEg/lWA=;
        b=bdabgpCAaFotc2e/XjI5zDGL0WovH4LuI/36BRYcEyohFfVbGus7iO3KGgvsitGHvG
         ZvWB7E9YvMF3Sj3hd2R1wk5cfT0jKn3cHJYQLnuQRxwLJgm3R0DrQAjmbkR/XGLWRxAk
         R3bgkdGD7YggCIwyQ4jfyqAznaW70dzWbAj7PVW5o6sGxIsQlggszZzopVk0SFrw8cLa
         9hg7Cta7HuqRnGX56ZsWnGgrPIC0H7jJWThKsWjfe8W/ixcciDqCEDFqIy0PMhwlVkPI
         HnO363A1Vh9Z7ptCk7Y/SHGfxyxLObRSEHR/WLjRuUs3GUbwv4DYINhrdCstrODJkJG8
         W0zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764633568; x=1765238368;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GUKsHCpubiKWQ2tOZNiZ9dmQDUX8wlWXJdrcCEg/lWA=;
        b=Ke9JD519TcXn8dNWh0r9g6Z9Yld72Myy2oIBV+uVjXihdJ512J+ANECFtyHcXyNr6c
         XBc8h4dWEoPuSxaDalf/+Onc1p0Dtty/iEFrVmLulUXjF3y2qdHRTE6ndadkyWVKgkdj
         be8o/VtcA5k7N3H3E1W/Arioolf1Lt4Qewa8QFGpCU2LAravhQqXHNFSzBsKk5GCf54V
         yT5F2YyC507Z0d9odegH+j/2F7bENACn40nFtH3Ujx/udJqWvyt/4+bwnsatibj5wvAJ
         UqRiio4xy0B9NSrGOb21CQB7brT6uSwPeQ2x6cDxjtMhnXalboxi1o2vBFzSEnNAJHDv
         BFPQ==
X-Gm-Message-State: AOJu0Yyh+Sd8mXIwxU6VEUYJncW4ItwEM/J33IILSGMXGY4uG21A0bDG
	UKCUVqIWO58t6BEDNcb+b6VEGTEofPf6Uz+ILSMzSdlrfeAbpDpxtaV2Iw+Owq7Cjud240aUI2y
	CDowhWw+eJUxGt7PZC92LTnoHT0idYA7epjarz8JHJPOpA7V2jqfTI6seP6DNGn8lvQ4RpWyOEt
	wU51VBmiSo5AFTCZiEe/kJ4BWJfwPXURAkVYK4qjPutnmxV80=
X-Gm-Gg: ASbGnct6USceSVayuYqBSAqcWwX96w3KDPU515dy5L4lEaNkAKL+507uf2HvMuA5P/z
	DN2pJXUgxJ9HREdRzh2gmipvwX8m0l3OVB5B5Yr/mEnseQ5Nwvg14oQhrBPwsnYDqvYlkbi9h3b
	OPbJuZmmf+WR4aJg+z8ac7YospFszML6fs8BFd8nmPWRk/naDlM0o2apFAgkB4kMSdPnHrDylS/
	G6eE9D4pUC+D7b+Q6150GzYI4xDxiQ/wFV50QsmsVVqqKB91OawTj8/ZIrCfxsMk0/WcPqHPvWH
	8eo5EGvQveNp4lAqQezkqU3FGiFsnTMu+6XQ5l81caHiLEcPJ1ZaqJzG7QvVY7KbZ8BGN0sZxeK
	q0j3tR9LkdNDX3nrgyxC8qcd7gYdWOykpf2RLhG7MaVKk+YIzE/n85O9sMcwSjLyDb+494E7Oq0
	467CakOI0sdHfElGS+jp3SU69aYu8onSQZ5yX5oxsx1GSF40xQjrRwJVeVWxI+ok/ndkplJpseL
	crfEuzgQPi5IvUluyNcbYx2Pu+GgXuutHFNlfO1E0fF
X-Google-Smtp-Source: AGHT+IET66CUI1UUftr+nywQOA0SUPDPHGI3eE40LJ1U1fVIV7MKIMpDrLOgeubswfTa3IwJXQ0kTQ==
X-Received: by 2002:a53:c043:0:20b0:641:f5bc:6962 with SMTP id 956f58d0204a3-64302b3f5afmr25604208d50.78.1764633567660;
        Mon, 01 Dec 2025 15:59:27 -0800 (PST)
Received: from brian--MacBookPro18.purestorage.com ([136.226.79.101])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6433c0897dasm5564990d50.11.2025.12.01.15.59.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 01 Dec 2025 15:59:27 -0800 (PST)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com,
	mwilck@suse.com,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH] Release lock before scsi_remove_device and don't block
Date: Mon,  1 Dec 2025 15:59:08 -0800
Message-ID: <20251201235908.43162-1-brian@purestorage.com>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Martin, I have added a couple of changes to the patch. Here is the diff
from the v2 that I posted. I have made the scsi_remove_device a non-blocking
call. I also release the lock before removing the device decreasing the
potential for lock contention since what is done under the lock is minimal.

I definitely would prefer multipath-tools to be the mechanism for the purging.
Any other option would be in competetion with multipath-tools in obtaining
the path state and acting on it. A single point of control seems advantagous.

There are two issues where multipath-tools is a victim. The first one is
addressed in the recheck_wwid function. The second one however also leads
to an unexpected I/O error when running I/O to the multipath device. There
are issues in volume mobility between two arrays where the inquiry data changes
and the resurrection of the path with its original inquiry data with the now
incorrect inquiry data also leads to an I/O error. In this case multipath-tools
is the victim of the kernel not being able to update inquiry data with either
inquiry data changed unit attentions or rescans. If you needd more details
please letme know.

There may be other reasons to have a purge of disconnected (orphaned sd
devices) that we have not encountered. Having a way to purge them seems like
a nice step forward.

I also made the man page more clear as to what is happening with the option.
---
 libmultipath/libmultipath.version |   1 +
 libmultipath/sysfs.c              |  58 ++++++-
 libmultipath/sysfs.h              |   2 +
 multipath/multipath.conf.5.in     |  11 +-
 multipathd/main.c                 | 250 +++++++++++++++++++++++-------
 5 files changed, 260 insertions(+), 62 deletions(-)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 89ae2a3c..c435847f 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -239,6 +239,7 @@ global:
 	snprint_tgt_wwnn;
 	snprint_tgt_wwpn;
 	sysfs_attr_set_value;
+	sysfs_attr_set_value_nonblock;
 	sysfs_attr_get_value;
 	sysfs_get_asymmetric_access_state;
 
diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index af27d107..2160d7fd 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -134,7 +134,7 @@ ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
 	size = write(fd, value, value_len);
 	if (size < 0) {
 		size = -errno;
-		condlog(3, "%s: write to %s failed: %s", __func__, 
+		condlog(3, "%s: write to %s failed: %s", __func__,
 			devpath, strerror(errno));
 	} else if (size < (ssize_t)value_len)
 		condlog(3, "%s: underflow writing %zu bytes to %s. Wrote %zd bytes",
@@ -144,6 +144,62 @@ ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
 	return size;
 }
 
+/*
+ * Non-blocking version of sysfs_attr_set_value for use with potentially
+ * blocking sysfs attributes (like SCSI "delete").
+ *
+ * Returns:
+ *   > 0: number of bytes written (success)
+ *   -EAGAIN: write would block, caller should retry or wait for completion
+ *   < 0: other error (negative errno)
+ */
+ssize_t sysfs_attr_set_value_nonblock(struct udev_device *dev, const char *attr_name,
+				      const char * value, size_t value_len)
+{
+	const char *syspath;
+	char devpath[PATH_MAX];
+	int fd = -1;
+	ssize_t size = -1;
+
+	if (!dev || !attr_name || !value || !value_len) {
+		condlog(1, "%s: invalid parameters", __func__);
+		return -EINVAL;
+	}
+
+	syspath = udev_device_get_syspath(dev);
+	if (!syspath) {
+		condlog(3, "%s: invalid udevice", __func__);
+		return -EINVAL;
+	}
+	if (safe_sprintf(devpath, "%s/%s", syspath, attr_name)) {
+		condlog(3, "%s: devpath overflow", __func__);
+		return -EOVERFLOW;
+	}
+
+	condlog(4, "open '%s' (non-blocking)", devpath);
+	/* Open with O_NONBLOCK to avoid blocking in open() or write() */
+	fd = open(devpath, O_WRONLY | O_NONBLOCK);
+	if (fd < 0) {
+		condlog(3, "%s: attribute '%s' cannot be opened: %s",
+			__func__, devpath, strerror(errno));
+		return -errno;
+	}
+	pthread_cleanup_push(cleanup_fd_ptr, &fd);
+
+	size = write(fd, value, value_len);
+	if (size < 0) {
+		size = -errno;
+		if (errno != EAGAIN)
+			condlog(3, "%s: write to %s failed: %s", __func__,
+				devpath, strerror(errno));
+	} else if (size < (ssize_t)value_len)
+		condlog(3, "%s: underflow writing %zu bytes to %s. Wrote %zd bytes",
+			__func__, value_len, devpath, size);
+
+	pthread_cleanup_pop(1);
+	return size;
+}
+
 int
 sysfs_get_size (struct path *pp, unsigned long long * size)
 {
diff --git a/libmultipath/sysfs.h b/libmultipath/sysfs.h
index 45f24c37..da2deaa3 100644
--- a/libmultipath/sysfs.h
+++ b/libmultipath/sysfs.h
@@ -10,6 +10,8 @@
 int devt2devname (char *, int, const char *);
 ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
 			     const char * value, size_t value_len);
+ssize_t sysfs_attr_set_value_nonblock(struct udev_device *dev, const char *attr_name,
+				      const char * value, size_t value_len);
 ssize_t sysfs_attr_get_value(struct udev_device *dev, const char *attr_name,
 			     char * value, size_t value_len);
 ssize_t sysfs_bin_attr_get_value(struct udev_device *dev, const char *attr_name,
diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index 1f806da8..84cd1a0a 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -1309,11 +1309,12 @@ The default is: \fBno\fR
 .B purge_disconnected
 If set to
 .I yes
-, multipathd will automatically remove paths that are in the disconnected state
-by writing to the SCSI device's sysfs delete attribute. This triggers kernel-level
-device removal. Paths are retried multiple times before being forcibly cleaned up
-if the kernel removal fails. This option is useful for cleaning up stale paths
-from storage arrays that have been disconnected or removed.
+, multipathd will automatically remove devices that are in a disconnected state.
+A path is considered disconnected when the TUR (Test Unit Ready) path checker
+receives the SCSI sense code "LOGICAL UNIT NOT SUPPORTED" (sense key 0x5,
+ASC/ASCQ 0x25/0x00). This typically indicates that the LUN has been unmapped
+or is no longer presented by the storage array. This option helps clean up
+stale device entries that would otherwise remain in the system.
 .RS
 .TP
 The default is: \fBno\fR
diff --git a/multipathd/main.c b/multipathd/main.c
index 0e7ed9b5..b105cd56 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1092,32 +1092,107 @@ check_path_wwid_change(struct path *pp)
 	return false;
 }
 
+/*
+ * Information needed to delete a path via sysfs, copied while holding the lock
+ * so that the actual sysfs write can be done without holding vecs->lock.
+ */
+struct purge_path_info {
+	struct udev_device *udev;  /* Reference to udev device (refcounted) */
+	char dev_t[BLK_DEV_SIZE];  /* For logging */
+	char alias[WWID_SIZE];     /* mpp alias for logging */
+	struct path *pp;           /* Path pointer for updating purge_path flag */
+};
+
 /*
  * Attempt to delete a path by writing to the SCSI device's sysfs delete attribute.
  * This triggers kernel-level device removal. The actual cleanup of the path structure
  * from pathvec happens later when a uevent arrives (handled by uev_remove_path).
  *
+ * This function does NOT require vecs->lock to be held, as it operates on copied data.
+ * Uses non-blocking I/O to avoid blocking in scsi_remove_device().
+ *
  * Returns:
- *   true  - sysfs write succeeded, uevent expected
- *   false - sysfs write failed or device not found
+ *   true  - sysfs write succeeded or device already being deleted
+ *   false - sysfs write would block (EAGAIN), caller should retry
+ *
+ * Note: Errors other than EAGAIN are treated as success, because they typically
+ * indicate the device is already in SDEV_DEL or SDEV_CANCEL state, or the sysfs
+ * file doesn't exist (device already removed).
  */
 static bool
-delete_path(struct path * pp)
+delete_path_sysfs(struct purge_path_info *info)
 {
-	struct udev_device *ud = udev_device_get_parent_with_subsystem_devtype(pp->udev,
+	struct udev_device *ud;
+	ssize_t ret;
+
+	if (!info->udev)
+		return true;  /* No device, treat as success */
+
+	ud = udev_device_get_parent_with_subsystem_devtype(info->udev,
 		"scsi", "scsi_device");
 
-	if (ud) {
-		if (sysfs_attr_set_value(ud, "delete", "1", strlen("1")) < 0) {
-			condlog(1, "failed to remove path %s from %s",
-				pp->dev_t, pp->mpp->alias);
-			return false;
-		}
-		condlog(2, "removed path %s from %s", pp->dev_t, pp->mpp->alias);
-		pp->purge_path = false;
+	if (!ud) {
+		/* No SCSI parent device, likely already removed */
+		condlog(4, "%s: no SCSI parent device found, likely already removed",
+			info->dev_t);
 		return true;
 	}
-	return false;
+
+	ret = sysfs_attr_set_value_nonblock(ud, "delete", "1", strlen("1"));
+
+	if (ret == -EAGAIN) {
+		/* Write would block, caller should retry */
+		condlog(4, "%s: delete would block, will retry", info->dev_t);
+		return false;
+	}
+
+	if (ret < 0) {
+		/*
+		 * Other errors (ENOENT, EINVAL, etc.) typically mean the device
+		 * is already being deleted or is in SDEV_DEL/SDEV_CANCEL state.
+		 * Treat as success since the end result is what we want.
+		 */
+		condlog(3, "%s: sysfs delete returned %zd (%s), treating as success",
+			info->dev_t, ret, strerror((int)-ret));
+		return true;
+	}
+
+	/* Success */
+	condlog(2, "%s: initiated removal from %s", info->dev_t, info->alias);
+	return true;
+}
+
+/*
+ * Prepare purge info for a path while holding vecs->lock.
+ * Takes a reference on the udev device so it remains valid after unlocking.
+ * Returns true if info was successfully prepared, false otherwise.
+ */
+static bool
+prepare_purge_path_info(struct path *pp, struct purge_path_info *info)
+{
+	if (!pp->udev || !pp->mpp)
+		return false;
+
+	info->udev = udev_device_ref(pp->udev);
+	if (!info->udev)
+		return false;
+
+	strlcpy(info->dev_t, pp->dev_t, sizeof(info->dev_t));
+	strlcpy(info->alias, pp->mpp->alias, sizeof(info->alias));
+	info->pp = pp;
+	return true;
+}
+
+/*
+ * Clean up purge info after use.
+ */
+static void
+cleanup_purge_path_info(struct purge_path_info *info)
+{
+	if (info->udev) {
+		udev_device_unref(info->udev);
+		info->udev = NULL;
+	}
 }
 
 /*
@@ -3346,6 +3421,7 @@ purgeloop (void *ap)
 	unsigned int devices_failed_total = 0;
 	unsigned int devices_pending_total = 0;
 	bool found_path_this_cycle = false;
+	bool cycle_complete_logged = false;
 	vecs = (struct vectors *)ap;
 
 	pthread_cleanup_push(rcu_unregister, NULL);
@@ -3354,11 +3430,14 @@ purgeloop (void *ap)
 
 	while (1) {
 		bool path_handled = false;
+		struct purge_path_info purge_info = { .udev = NULL };
+		bool do_purge = false;
+		char dev_name[FILE_NAME_SIZE];
 
 		/*
 		 * Lock and search for one path that needs processing.
-		 * We search from the beginning each time since the list
-		 * may have changed while we didn't hold the lock.
+		 * Copy the necessary info while holding the lock, then
+		 * release the lock before doing any blocking sysfs operations.
 		 */
 		pthread_cleanup_push(cleanup_lock, &vecs->lock);
 		lock(&vecs->lock);
@@ -3374,44 +3453,96 @@ purgeloop (void *ap)
 			/* Increment timeout counter for this purge attempt */
 			pp->purge_retries++;
 
-			if (delete_path(pp)) {
-				/* Success: sysfs write succeeded, uevent expected */
-				devices_purged_total++;
-				pp->purge_retries = 0;
-				condlog(3, "%s: path purge successful", pp->dev);
-			} else if (pp->purge_retries >= PURGE_TIMEOUT_CYCLES) {
+			if (pp->purge_retries >= PURGE_TIMEOUT_CYCLES) {
 				/*
 				 * Timeout: path couldn't be deleted after multiple attempts.
-				 * Force cleanup by calling ev_remove_path() to properly
-				 * remove the path from its multipath device and handle
-				 * all references correctly.
+				 * This likely means the device still exists in the kernel
+				 * (perhaps it came back online, or the delete is stuck).
+				 *
+				 * We should NOT force-remove it from multipathd's state,
+				 * as that would create a mismatch between multipathd's view
+				 * and the kernel's view of existing devices.
+				 *
+				 * Instead, clear the purge flag and stop trying. The path
+				 * will remain in multipathd. If it's truly disconnected,
+				 * it will be marked for purge again on the next check cycle.
 				 */
-				condlog(1, "%s: purge timeout after %d attempts, forcing removal",
+				condlog(1, "%s: purge timeout after %d attempts, giving up. "
+					"Device may still exist in kernel.",
 					pp->dev, pp->purge_retries);
-				if (ev_remove_path(pp, vecs, 1) & REMOVE_PATH_SUCCESS)
-					devices_failed_total++;
-				else {
-					/*
-					 * ev_remove_path failed to remove the path immediately.
-					 * The path is now marked INIT_REMOVED and will be
-					 * cleaned up when the map is reloaded or removed.
-					 */
-					condlog(1, "%s: failed to remove path, marked for later removal",
+				pp->purge_path = false;
+				pp->purge_retries = 0;
+				devices_failed_total++;
+			} else {
+				/*
+				 * Prepare info for sysfs deletion.
+				 * Copy all needed data while holding the lock.
+				 */
+				if (prepare_purge_path_info(pp, &purge_info)) {
+					do_purge = true;
+					strlcpy(dev_name, pp->dev, sizeof(dev_name));
+				} else {
+					/* Can't prepare info, will retry next cycle */
+					devices_pending_total++;
+					condlog(4, "%s: failed to prepare purge info, will retry",
 						pp->dev);
-					devices_failed_total++;
 				}
-			} else {
-				/* Will retry on next cycle */
-				devices_pending_total++;
-				condlog(4, "%s: path purge failed, will retry (attempt %d/%d)",
-					pp->dev, pp->purge_retries,
-					PURGE_TIMEOUT_CYCLES);
 			}
 			break;
 		}
 
 		lock_cleanup_pop(vecs->lock);
 
+		/*
+		 * Now we've released the lock. Do the non-blocking sysfs operation
+		 * without holding vecs->lock.
+		 */
+		if (do_purge) {
+			bool success = delete_path_sysfs(&purge_info);
+
+			/*
+			 * Re-acquire lock to update path state.
+			 * The path might have been removed while we didn't hold the lock,
+			 * so we need to verify it still exists.
+			 */
+			pthread_cleanup_push(cleanup_lock, &vecs->lock);
+			lock(&vecs->lock);
+			pthread_testcancel();
+
+			/* Verify the path still exists in pathvec */
+			if (find_slot(vecs->pathvec, purge_info.pp) != -1) {
+				if (success) {
+					/* Success: sysfs write succeeded, uevent expected */
+					devices_purged_total++;
+					purge_info.pp->purge_path = false;
+					purge_info.pp->purge_retries = 0;
+					condlog(3, "%s: path purge successful", dev_name);
+				} else {
+					/* Will retry on next cycle */
+					devices_pending_total++;
+					condlog(4, "%s: path purge failed, will retry (attempt %d/%d)",
+						dev_name, purge_info.pp->purge_retries,
+						PURGE_TIMEOUT_CYCLES);
+				}
+			} else {
+				/*
+				 * Path was removed while we were doing sysfs write.
+				 * This is actually success - the path is gone, which is what we wanted.
+				 */
+				if (success) {
+					devices_purged_total++;
+					condlog(3, "%s: path removed during purge operation (counted as success)",
+						dev_name);
+				} else {
+					/* Path removed but our sysfs write failed - don't count it */
+					condlog(4, "%s: path removed during failed purge operation", dev_name);
+				}
+			}
+
+			lock_cleanup_pop(vecs->lock);
+			cleanup_purge_path_info(&purge_info);
+		}
+
 		/*
 		 * If we didn't find any path to process, we've completed a cycle.
 		 * Check if we should wait for more work or start a new cycle.
@@ -3419,11 +3550,12 @@ purgeloop (void *ap)
 		if (path_handled)
 			found_path_this_cycle = true;
 		else {
-			if (found_path_this_cycle) {
+			if (found_path_this_cycle && !cycle_complete_logged) {
 				/* Completed a cycle, log statistics */
 				condlog(2, "purge cycle %u complete: %u purged, %u failed, %u pending",
 					current_cycle, devices_purged_total,
 					devices_failed_total, devices_pending_total);
+				cycle_complete_logged = true;
 
 				/* Check if we need to retry pending paths */
 				if (devices_pending_total > 0) {
@@ -3445,26 +3577,32 @@ purgeloop (void *ap)
 								&devices_failed_total,
 								&devices_pending_total,
 								&found_path_this_cycle);
+					cycle_complete_logged = false;
+					condlog(3, "starting purge cycle %u", current_cycle);
 					continue;
 				}
+
+				/* No pending paths, prepare for next cycle */
+				current_cycle++;
+				reset_purge_cycle_stats(&devices_purged_total,
+							&devices_failed_total,
+							&devices_pending_total,
+							&found_path_this_cycle);
+				cycle_complete_logged = false;
 			}
 
 			/* No paths to process, wait for signal */
-			pthread_mutex_lock(&purge_mutex);
-			while (!devices_to_purge) {
-				condlog(3, "waiting on devices to purge");
-				pthread_cond_wait(&purge_cond, &purge_mutex);
-			}
-			devices_to_purge = 0;
-			pthread_mutex_unlock(&purge_mutex);
+			if (cycle_complete_logged) {
+				pthread_mutex_lock(&purge_mutex);
+				while (!devices_to_purge) {
+					condlog(3, "waiting on devices to purge");
+					pthread_cond_wait(&purge_cond, &purge_mutex);
+				}
+				devices_to_purge = 0;
+				pthread_mutex_unlock(&purge_mutex);
 
-			/* Start a new cycle */
-			current_cycle++;
-			reset_purge_cycle_stats(&devices_purged_total,
-						&devices_failed_total,
-						&devices_pending_total,
-						&found_path_this_cycle);
-			condlog(3, "starting purge cycle %u", current_cycle);
+				condlog(3, "starting purge cycle %u", current_cycle);
+			}
 		}
 	}
 
-- 
2.51.2

