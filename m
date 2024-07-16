Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C29F54F95
	for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 20:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721163247; cv=none; b=VXLyfnYfSS7u4GF7WHQoA0r846zzTNo2u6s8vl3pfeKeMxjVC1yK7QhVbiIVKWNhlYW2DJ8e5IcLL5TsGZg6Fbo94a0IBo/GZrvuX3uhsja4loquJR+KOED6Y/JoxzNDYiy8mX76frttpd/yNxaVKVuI3Q+sgRjMg+sTUJKcOSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721163247; c=relaxed/simple;
	bh=25aTLBSwx45Y2cW6TD/Eca/s3A1eufYBGFvwt3cI56M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDlys19j+JCSTtUrXpPBqKBzFKwrvTGlc7aHAN736e6QRFZgcQdf6S9AK5m1IDORtju9lmO+WEKUcOxLxXqkKLx1IspXgxcPuMKyaeyfWmyAph/aUUdRJOA66VyUFKfbiLOyW4WtwLlV2LERT++zeVMG4YuWb7T8OPB+8ECZ3Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SxatAP2L; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SxatAP2L"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a797c62565aso632191666b.2
        for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 13:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721163243; x=1721768043; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iHfDgT4SGfrlVm8O8aF0oJ2gK3X/pDDi8cs2q4aF/Ew=;
        b=SxatAP2LYKCRH6FQV+MGr35Gm6PABpnJY244RFFlKdio4s7moCbbqGuDYv3hXTNoGO
         p9TVy8TqncBo9dXk0HpXbSdnaLY+EgXY+nIdB4YulQavSpuxTN78BkwTgWCCalWUXl4U
         WrZATQSdS9EWtEvRlNWQjl9cUthfGNDFifSsfA+hVPEtfVagvnc9U6Am8CdiH59FkPzI
         0nOlPY5XSRliZ59JuB6xhxUihADo03d2vSzYJBwFbUuzQA1gNo9SDihe3urqHpOcLLtD
         XvuwBAsHBfV8jqs9N+qTTI5ML+zjDu1iojUIGumPYIAI7TkJPXbVC00RQwdLeepbRRtW
         K3Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721163243; x=1721768043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iHfDgT4SGfrlVm8O8aF0oJ2gK3X/pDDi8cs2q4aF/Ew=;
        b=eeE7wI2oEmBsmYoQcTVyJ8yPO7x4oLYiEcUsiQt0n8fBuPj6IHkb55UIJ4v7HXCj72
         39wVgDKdigBTq7Ig7c3MM9OW1EUTLI5p9QhKKmHwhbz4ocdMAygvg3gowYFJlvbAObdC
         uTQG2qVK4Ee+Ehtq4VvlRaEIYE00FWPLKkcUetpeBpJTACFqLI+XuVZTlpBXDioCpY9e
         RDlsAMfv6cpLlaZkhbnDIh5GaAWcb0nzrAMA5KqJx/z9aJY44H7sScyuoO0sT8K21vvP
         73FLBp3qqOJ4FCXdJ4nG6YtZhrK0Vu8LOssJ7bD3HqMaCdttdW6lDC/aauVNB4ch4wRQ
         erJQ==
X-Gm-Message-State: AOJu0Yx/j9JO2GDED1u+ZTVm6qXuRD/EPpOfViyKq4nzewJ5TQqsfaTZ
	vcreH5gVSd+sCyHpbc6SOVD3wWjRhni1XrIO4NNJkOTGpoVe3xfkZFvmL8B0/oA=
X-Google-Smtp-Source: AGHT+IEgsGAvQCVnUXsZxr0HARjwdXisHHjlQ+vcK+CPcbAmqFHnUVJFQ+k6TjATmlYBrqdzZhT3gQ==
X-Received: by 2002:a17:906:6819:b0:a6e:d339:c095 with SMTP id a640c23a62f3a-a79eaa71843mr219668866b.47.1721163242593;
        Tue, 16 Jul 2024 13:54:02 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a79bc80101fsm367345066b.179.2024.07.16.13.54.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jul 2024 13:54:02 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH v3 19/49] libmultipath: add libmp_mapinfo()
Date: Tue, 16 Jul 2024 22:53:40 +0200
Message-ID: <20240716205344.146310-3-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716205344.146310-1-mwilck@suse.com>
References: <20240716205344.146310-1-mwilck@suse.com>
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
 libmultipath/devmapper.c          | 194 +++++++++++++++++++++++++++++-
 libmultipath/devmapper.h          |  70 +++++++++++
 libmultipath/libmultipath.version |   3 +-
 3 files changed, 265 insertions(+), 2 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 5492a86..f90a8df 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -14,7 +14,6 @@
 #include <errno.h>
 #include <syslog.h>
 #include <sys/sysmacros.h>
-#include <linux/dm-ioctl.h>
 
 #include "util.h"
 #include "vector.h"
@@ -604,6 +603,199 @@ has_dm_info(const struct multipath *mpp)
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
+		return dm_task_set_minor(dmt, id._u.minor);
+	case DM_MAP_BY_DEVT:
+		if (!dm_task_set_major(dmt, major(id.devt)))
+			return 0;
+		return dm_task_set_minor(dmt, minor(id.devt));
+	default:
+		condlog(0, "%s: invalid by_id", __func__);
+		return 0;
+	}
+}
+
+static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info, const char *map_id)
+{
+	/* avoid libmp_mapinfo__ in log messages */
+	static const char fname__[] = "libmp_mapinfo";
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
+				     (mapinfo_t) { .target = &tmp_target },
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
+	else if (info.status || info.size || flags & __MAPINFO_TGT_TYPE)
+		ioctl_nr = DM_DEVICE_STATUS;
+	else
+		ioctl_nr = DM_DEVICE_INFO;
+
+	if (!(dmt = libmp_dm_task_create(ioctl_nr)))
+		return DMP_ERR;
+
+	if (!libmp_set_map_identifier(flags, id, dmt)) {
+		condlog(2, "%s: failed to set map identifier to %s", fname__, map_id);
+		return DMP_ERR;
+	}
+
+	if (!libmp_dm_task_run(dmt)) {
+		dm_log_error(3, ioctl_nr, dmt);
+		if (dm_task_get_errno(dmt) == ENXIO) {
+			condlog(2, "%s: map %s not found", fname__, map_id);
+			return DMP_NOT_FOUND;
+		} else
+			return DMP_ERR;
+	}
+
+	condlog(4, "%s: DM ioctl %d succeeded for %s",
+		fname__, ioctl_nr, map_id);
+
+	if (!dm_task_get_info(dmt, &dmi)) {
+		condlog(2, "%s: dm_task_get_info() failed for %s ", fname__, map_id);
+		return DMP_ERR;
+	} else if(!dmi.exists) {
+		condlog(2, "%s: map %s doesn't exist", fname__, map_id);
+		return DMP_NOT_FOUND;
+	}
+
+	if (info.target || info.status || info.size || flags & __MAPINFO_TGT_TYPE) {
+		if (dm_get_next_target(dmt, NULL, &start, &length,
+				       &target_type, &params) != NULL) {
+			condlog(2, "%s: map %s has multiple targets", fname__, map_id);
+			return DMP_NOT_FOUND;
+		}
+		if (!params) {
+			condlog(2, "%s: map %s has no targets", fname__, map_id);
+			return DMP_NOT_FOUND;
+		}
+		if (flags & __MAPINFO_TGT_TYPE) {
+			const char *tgt_type = flags & MAPINFO_MPATH_ONLY ? TGT_MPATH : TGT_PART;
+
+			if (strcmp(target_type, tgt_type)) {
+				condlog(3, "%s: target type mismatch: \"%s\" != \"%s\"",
+					fname__, tgt_type, target_type);
+				return DMP_NO_MATCH;
+			}
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
+		condlog(4, "%s: %s: name: \"%s\"", fname__, map_id, info.name);
+	}
+	if (info.uuid) {
+		strlcpy(info.uuid, uuid, DM_UUID_LEN);
+		condlog(4, "%s: %s: uuid: \"%s\"", fname__, map_id, info.uuid);
+	}
+
+	if (info.size) {
+		*info.size = length;
+		condlog(4, "%s: %s: size: %lld", fname__, map_id, *info.size);
+	}
+
+	if (info.dmi) {
+		memcpy(info.dmi, &dmi, sizeof(*info.dmi));
+		condlog(4, "%s: %s %d:%d, %d targets, %s table, %s, %s, %d opened, %u events",
+			fname__, map_id,
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
+			condlog(4, "%s: %s: target: \"%s\"", fname__, map_id, *info.target);
+	}
+
+	if (info.status) {
+		*info.status = steal_ptr(tmp_status);
+		condlog(4, "%s: %s: status: \"%s\"", fname__, map_id, *info.status);
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
+	case DM_MAP_BY_DEVT:
+		safe_snprintf(buf, BLK_DEV_SIZE, "%d:%d", major(id.devt), minor(id.devt));
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
index 9438c2d..4ccaaa7 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -1,5 +1,6 @@
 #ifndef _DEVMAPPER_H
 #define _DEVMAPPER_H
+#include <linux/dm-ioctl.h>
 #include "autoconfig.h"
 #include "structs.h"
 
@@ -31,8 +32,77 @@ enum {
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
+	/** DM_MAP_BY_DEVT: identify map by a dev_t */
+	DM_MAP_BY_DEVT,
+	__DM_MAP_BY_MASK    = (1 << 8) - 1,
+	/* Fail if target type is not multipath */
+	MAPINFO_MPATH_ONLY  = (1 << 8),
+	/* Fail if target type is not "partition" (linear) */
+	MAPINFO_PART_ONLY   = (1 << 9),
+	__MAPINFO_TGT_TYPE  = (MAPINFO_MPATH_ONLY | MAPINFO_PART_ONLY),
+};
+
+typedef union libmp_map_identifier {
+	const char *str;
+	struct {
+		int major;
+		int minor;
+	} _u;
+	dev_t devt;
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
+	/** @size: target size. */
+	unsigned long long *size;
+	/** @status: target status, *@status will be allocated if @status is non-NULL */
+	char **status;
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

