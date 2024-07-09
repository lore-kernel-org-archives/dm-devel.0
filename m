Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71C4187867
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561205; cv=none; b=PhdElxO0O0TOT6jwahdF4UiMniX8VSkfXkVsAyCCiw71E0KzzzN/duwGMuxSXMqRIxBC00vkRIwPU4fKnNzeBCewb1le7/JmO4535mrtBHqRoHCasE6wWa3nZhjbLfm24Vs3BPXxq3ZeWxgQvCvGpZLGr1CraAYeXETsxnxErGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561205; c=relaxed/simple;
	bh=lv7X91vB/g3zoouvV+zEy6KpbpmNclGkjnQDY50nNjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PyhjIL9L+QWgzgx59rxtKTaFqSX8Ny3PzC+ZdTd5EVqM2n78twTf96f4adxKr6cdGpVC5F8MMnFWMjhLkN4GL9Eqssk3z+GNImN9WgJreaBeuSrRWufNlqVnKSFdgcXsWtWp23PwZ6kMoq8wJ4qPOVV9/J6EXogL352vYcgg4Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AjMLb93j; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AjMLb93j"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a77d9217e6fso484803666b.2
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561201; x=1721166001; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4gart813SrB6C4gBDtgwOalqto2PTBfsZC2HLpdYR9M=;
        b=AjMLb93jAF1DYYBPiCv9Rh8EvfqnazJNGCW9qk9T/Ljh/166jf87PoiCRER7dYoHhf
         kdsJJBWPjafyhkvG9OKFpZMn7KoLvpeKMJ4vnqUQk6Ah3BvlCZMQe9t0HBByr+x/KrZ0
         VwjbRWs7DmIeoX6lA34/OOw4MwAMVZsODqu1Tt9+t8IK3BiMd0S9+hoi3JG3XGjOLB7L
         RuoFQAjOA6yufFBJ6LiOrfMPEoHefxh4mKTxits29DiXvSQ+BJt46I5ZksykENRpPUei
         T9gHelfX3Yp63Pnt9buESB5+O1liec/Zkqg/aqkBItUBH7xK4Qrfglg6hMEkDP7s28dl
         D8eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561201; x=1721166001;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4gart813SrB6C4gBDtgwOalqto2PTBfsZC2HLpdYR9M=;
        b=NxqHNdhdWVSxvA+Kaa1srBT0x81cCLjYpBRG0j1RI8iVllXxyuTY4R3ESLkFqXmL+k
         IC2jNOzJRgHfpgX3OQKZ1HrLpgvJ3NnZnWSM5+PJt0JsQ/6dDtgjVFzggWwCxZoYAl+8
         jLc/LTI5r4EGV+gNLvV2AQCx1oYnomcoFthbQId7qvGG6/K+iWH0cSwoxZo2mmaJHu9x
         m6Y/xsQe+YdsPdjkLlaJoX0BKU9bk2aiSMZ/q4OA3NekHJRjrPxUZRAiIK3qJHw7wva2
         OmSTgseKeUtsuMiDy9uUasVjf+e4zatBa1J0mmXSADTyF7eGLD7IY8LZeLPq8jy2Ocy5
         Ru0w==
X-Gm-Message-State: AOJu0YwrZrsxiZp9sHgqa1hD2Ez3DxnWfZBU8n7YNNk//3VHG3bra1Fm
	yqEcTg8u4u/wQJ78KRQpEs7ZL+ZDywPq81iyGbKzDiUGZGPUQMFGVruPMjkAcfY=
X-Google-Smtp-Source: AGHT+IF9t7ItbB9ZZGQQ3WerxBXBE7AMjQ1ZAbZkKKfZiXigTo07oLJQv8ZgYEMxXSomJv4bJKE7Nw==
X-Received: by 2002:a17:906:d29b:b0:a6f:f1bc:21ce with SMTP id a640c23a62f3a-a780b885e92mr255193366b.47.1720561200993;
        Tue, 09 Jul 2024 14:40:00 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bba548ddsm1479295a12.16.2024.07.09.14.40.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:40:00 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 17/44] libmultipath: add libmp_mapinfo()
Date: Tue,  9 Jul 2024 23:39:08 +0200
Message-ID: <20240709213935.177028-18-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709213935.177028-1-mwilck@suse.com>
References: <20240709213935.177028-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

libmp_mapinfo() is intended as a generic abstraction for retrieving information from
the kernel device-mapper driver. It retrieves the information that the caller
needs, with a minimal set of DM ioctls, and never more then 2 ioctl calls.

libdm's DM_DEVICE_TABLE and DM_DEVICE_STATUS calls map to the kernel's
DM_TABLE_STATUS ioctl, with or without the DM_STATUS_TABLE_FLAG set,
respectively. DM_TABLE_STATUS always retrieves the basic map status (struct
dm_info) and the map UUID and name, too.

Note: I'd prefer to use an unnamed struct instead of _u in
union libmp_map_identifer. But doing using an unnamed struct and and
initializing the union like this in a function argument:

  func((mapid_t) { .major = major, .minor = minor })

is not part of C99, and not supported in gcc 4.8, which we still support.

Likewise, the following syntax for initializing an empty struct:

  (mapinfo_t) { 0 }

is not supported on all architectures we support (notably clang 3.5 under
Debian Jessie).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c          | 181 +++++++++++++++++++++++++++++-
 libmultipath/devmapper.h          |  66 +++++++++++
 libmultipath/libmultipath.version |   3 +-
 3 files changed, 248 insertions(+), 2 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 3685ef7..5c9f9d8 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -14,7 +14,6 @@
 #include <errno.h>
 #include <syslog.h>
 #include <sys/sysmacros.h>
-#include <linux/dm-ioctl.h>
 
 #include "util.h"
 #include "vector.h"
@@ -604,6 +603,186 @@ has_dm_info(const struct multipath *mpp)
 	return (mpp && mpp->dmi.exists != 0);
 }
 
+static int libmp_set_map_identifier(int flags, mapid_t id, struct dm_task *dmt)
+{
+	switch (flags & __DM_MAP_BY_MASK) {
+	case DM_MAP_BY_UUID:
+		if (!id.str || !(*id.str))
+			return 0;
+		return dm_task_set_uuid(dmt, id.str);
+	case DM_MAP_BY_NAME:
+		if (!id.str || !(*id.str))
+			return 0;
+		return dm_task_set_name(dmt, id.str);
+	case DM_MAP_BY_DEV:
+		if (!dm_task_set_major(dmt, id._u.major))
+			return 0;
+		return  dm_task_set_minor(dmt, id._u.minor);
+	default:
+		condlog(0, "%s: invalid by_id", __func__);
+		return 0;
+	}
+}
+
+static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info, const char *map_id)
+{
+	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
+	struct dm_info dmi;
+	int rc, ioctl_nr;
+	uint64_t start, length = 0;
+	char *target_type = NULL, *params = NULL;
+	const char *name = NULL, *uuid = NULL;
+	char __attribute__((cleanup(cleanup_charp))) *tmp_target = NULL;
+	char __attribute__((cleanup(cleanup_charp))) *tmp_status = NULL;
+	bool tgt_set = false;
+
+	/*
+	 * If both info.target and info.status are set, we need two
+	 * ioctls. Call this function recursively.
+	 * If successful, tmp_target will be non-NULL.
+	 */
+	if (info.target && info.status) {
+		rc = libmp_mapinfo__(flags, id,
+				     (mapinfo_t) {
+					     .target = &tmp_target,
+					     .tgt_type = info.tgt_type,
+				     },
+				     map_id);
+		if (rc != DMP_OK)
+			return rc;
+		tgt_set = true;
+	}
+
+	/*
+	 * The DM_DEVICE_TABLE and DM_DEVICE_STATUS ioctls both fetch the basic
+	 * information from DM_DEVICE_INFO, too.
+	 * Choose the most lightweight ioctl to fetch all requested info.
+	 */
+	if (info.target && !info.status)
+		ioctl_nr = DM_DEVICE_TABLE;
+	else if (info.status || info.size || info.tgt_type)
+		ioctl_nr = DM_DEVICE_STATUS;
+	else
+		ioctl_nr = DM_DEVICE_INFO;
+
+	if (!(dmt = libmp_dm_task_create(ioctl_nr)))
+		return DMP_ERR;
+
+	if (!libmp_set_map_identifier(flags, id, dmt)) {
+		condlog(2, "%s: failed to set map identifier to %s", __func__, map_id);
+		return DMP_ERR;
+	}
+
+	if (!libmp_dm_task_run(dmt)) {
+		dm_log_error(3, ioctl_nr, dmt);
+		if (dm_task_get_errno(dmt) == ENXIO) {
+			condlog(2, "%s: map %s not found", __func__, map_id);
+			return DMP_NOT_FOUND;
+		} else
+			return DMP_ERR;
+	}
+
+	condlog(4, "%s: DM ioctl %d succeeded for %s",
+		__func__, ioctl_nr, map_id);
+
+	if (!dm_task_get_info(dmt, &dmi) || !dmi.exists) {
+		condlog(2, "%s: map %s doesn't exist", __func__, map_id);
+		return DMP_NOT_FOUND;
+	}
+
+	if (info.target || info.status || info.size || info.tgt_type) {
+		if (dm_get_next_target(dmt, NULL, &start, &length,
+				       &target_type, &params) != NULL) {
+			condlog(2, "%s: map %s has multiple targets", __func__, map_id);
+			return DMP_NOT_FOUND;
+		}
+		if (!params) {
+			condlog(2, "%s: map %s has no targets", __func__, map_id);
+			return DMP_NOT_FOUND;
+		}
+		if (info.tgt_type && strcmp(info.tgt_type, target_type)) {
+			condlog(3, "%s: target type mismatch: \"%s\" != \"%s\"",
+				__func__, info.tgt_type, target_type);
+			return DMP_NO_MATCH;
+		}
+	}
+
+	/*
+	 * Check possible error conditions.
+	 * If error is returned, don't touch any output parameters.
+	 */
+	if ((info.name && !(name = dm_task_get_name(dmt)))
+	    || (info.uuid && !(uuid = dm_task_get_uuid(dmt)))
+	    || (info.status && !(tmp_status = strdup(params)))
+	    || (info.target && !tmp_target && !(tmp_target = strdup(params))))
+		return DMP_ERR;
+
+	if (info.name) {
+		strlcpy(info.name, name, WWID_SIZE);
+		condlog(4, "%s: %s: name: \"%s\"", __func__, map_id, info.name);
+	}
+	if (info.uuid) {
+		strlcpy(info.uuid, uuid, DM_UUID_LEN);
+		condlog(4, "%s: %s: uuid: \"%s\"", __func__, map_id, info.uuid);
+	}
+
+	if (info.size) {
+		*info.size = length;
+		condlog(4, "%s: %s: size: %lld", __func__, map_id, *info.size);
+	}
+
+	if (info.dmi) {
+		memcpy(info.dmi, &dmi, sizeof(*info.dmi));
+		condlog(4, "%s: %s %d:%d, %d targets, %s table, %s, %s, %d opened, %u events",
+			__func__, map_id,
+			info.dmi->major, info.dmi->minor,
+			info.dmi->target_count,
+			info.dmi->live_table ? "live" :
+				info.dmi->inactive_table ? "inactive" : "no",
+			info.dmi->suspended ? "suspended" : "active",
+			info.dmi->read_only ? "ro" : "rw",
+			info.dmi->open_count,
+			info.dmi->event_nr);
+	}
+
+	if (info.target) {
+		*info.target = steal_ptr(tmp_target);
+		if (!tgt_set)
+			condlog(4, "%s: %s: target: \"%s\"", __func__, map_id, *info.target);
+	}
+
+	if (info.status) {
+		*info.status = steal_ptr(tmp_status);
+		condlog(4, "%s: %s: status: \"%s\"", __func__, map_id, *info.status);
+	}
+
+	return DMP_OK;
+}
+
+/* Helper: format a string describing the map for log messages */
+static const char* libmp_map_identifier(int flags, mapid_t id, char buf[BLK_DEV_SIZE])
+{
+	switch (flags & __DM_MAP_BY_MASK) {
+	case DM_MAP_BY_NAME:
+	case DM_MAP_BY_UUID:
+		return id.str;
+	case DM_MAP_BY_DEV:
+		safe_snprintf(buf, BLK_DEV_SIZE, "%d:%d", id._u.major, id._u.minor);
+		return buf;
+	default:
+		safe_snprintf(buf, BLK_DEV_SIZE, "*invalid*");
+		return buf;
+	}
+}
+
+int libmp_mapinfo(int flags, mapid_t id, mapinfo_t info)
+{
+	char idbuf[BLK_DEV_SIZE];
+
+	return libmp_mapinfo__(flags, id, info,
+			       libmp_map_identifier(flags, id, idbuf));
+}
+
 int
 dm_get_info(const char *name, struct dm_info *info)
 {
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 9438c2d..269389b 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -1,5 +1,6 @@
 #ifndef _DEVMAPPER_H
 #define _DEVMAPPER_H
+#include <linux/dm-ioctl.h>
 #include "autoconfig.h"
 #include "structs.h"
 
@@ -31,8 +32,73 @@ enum {
 	DMP_ERR,
 	DMP_OK,
 	DMP_NOT_FOUND,
+	DMP_NO_MATCH,
 };
 
+/**
+ * enum mapinfo_flags: input flags for libmp_mapinfo()
+ */
+enum __mapinfo_flags {
+	/** DM_MAP_BY_NAME: identify map by device-mapper name from @name */
+	DM_MAP_BY_NAME      = 0,
+	/** DM_MAP_BY_UUID: identify map by device-mapper UUID from @uuid */
+	DM_MAP_BY_UUID,
+	/** DM_MAP_BY_DEV: identify map by major/minor number from @dmi */
+	DM_MAP_BY_DEV,
+	__DM_MAP_BY_MASK    = (1 << 3) - 1,
+};
+
+typedef union libmp_map_identifier {
+	const char *str;
+	struct {
+		int major;
+		int minor;
+	} _u;
+} mapid_t;
+
+typedef struct libmp_map_info {
+	/** @name: name of the map.
+	 * If non-NULL, it must point to an array of WWID_SIZE bytes
+	 */
+	char *name;
+	/** @uuid: UUID of the map.
+	 * If non-NULL it must point to an array of DM_UUID_LEN bytes
+	 */
+	char *uuid;
+	/** @dmi: Basic info, must point to a valid dm_info buffer if non-NULL */
+	struct dm_info *dmi;
+	/** @target: target params, *@target will be allocated if @target is non-NULL*/
+	char **target;
+	/** @size: target size. Will be ignored if @target is NULL */
+	unsigned long long *size;
+	/** @status: target status, *@status will be allocated if @status is non-NULL */
+	char **status;
+	/** @tgt_type: (input) set to a target type, e.g. "multipath" to limit
+	 * successful return to just this target type in libmp_mapinfo().
+	 */
+	const char *tgt_type;
+} mapinfo_t;
+
+/**
+ * libmp_mapinfo(): obtain information about a map from the kernel
+ * @param flags: see __mapinfo_flags above.
+ *     Exactly one of DM_MAP_BY_NAME, DM_MAP_BY_UUID, and DM_MAP_BY_DEV must be set.
+ * @param id: string or major/minor to identify the map to query
+ * @param info: output parameters, see above. Non-NULL elements will be filled in.
+ * @returns:
+ *     DMP_OK if successful.
+ *     DMP_NOT_FOUND if the map wasn't found, or has no or multiple targets.
+ *     DMP_NO_MATCH if the map didn't match @tgt_type (see above).
+ *     DMP_ERR if some other error occurred.
+ *
+ * This function obtains the requested information for the device-mapper map
+ * identified by the input parameters.
+ * Output parameters are only filled in if the return value is DMP_OK.
+ * For target / status / size information, the  map's table should contain
+ * only one target (usually multipath or linear).
+ */
+int libmp_mapinfo(int flags, mapid_t id, mapinfo_t info);
+
 int dm_prereq(unsigned int *v);
 void skip_libmp_dm_init(void);
 void libmp_dm_exit(void);
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index f58cb1d..48c2b67 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -43,7 +43,7 @@ LIBMPATHCOMMON_1.0.0 {
 	put_multipath_config;
 };
 
-LIBMULTIPATH_24.0.0 {
+LIBMULTIPATH_25.0.0 {
 global:
 	/* symbols referenced by multipath and multipathd */
 	add_foreign;
@@ -134,6 +134,7 @@ global:
 	libmp_get_version;
 	libmp_get_multipath_config;
 	libmp_dm_task_run;
+	libmp_mapinfo;
 	libmp_put_multipath_config;
 	libmp_udev_set_sync_support;
 	libmultipath_exit;
-- 
2.45.2

