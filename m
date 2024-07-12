Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6817F175564
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804551; cv=none; b=Vt6btEXfySOcrLgXNwezUuKIb4c253BOodsbRaLyqJ5y+RqEHFMBpWIvTzXr+ADkOqPAM5LCdPY7fIQPSD/VbkmxpUa807Z9kOzefCZg3SFyROff4xhiJZlTWpG/q5o9rA+WHJeDIZS9Xn7rrzI/j/q8qpsIDM2h+VWtrY/L0+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804551; c=relaxed/simple;
	bh=WPSsU/iAWY+FKRl7GSeIc9EL+o4M4xsGcc/QFuPcYZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZkvzrfnEKmsyxGJIsiXCazRRxlj+7/f6vcQjHs3FuwbrKE7GIyyfz5O70IYjWdJyHFJFSQEiVvJwbaD31kNBUcO1C5FomD9jvNeYyrwXM1z7fYHfHuEXx1JTpjT7yt8w9fSyCy9DNLrj0CWyThxntzTzw9xPslccyctKs7i/3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=L8O/rRqg; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="L8O/rRqg"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-58b0dddab63so3612911a12.3
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804547; x=1721409347; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mb0B7Hd7jBO2MYoksoGxVz1RYZrGwifSFfR0TgGjfro=;
        b=L8O/rRqgl+wr+6QeV4/TSVBMtLcbR1bg7wxpTBnjJDigXQa7mszpo5FKRgWAKkSlKN
         JDN32dtec9dWu0PPOcEGrHF6vi+CuFR/DhMx0UwSptxyVWfp7eyJHtFfm13hi1kCm0Qr
         Rpq9BqN1ri6Qs05uWYFTg6i2QuVpeKDVQovYUAmgfyrSoa6z8qQr45RxzxI54v68dM2e
         PI+EzNISDFtUV8qL7L5BrOsgC2XwohLULlVxtLdM6H38p+F/CkdfYq+bl4kkWfCgHqDk
         9UG3DF1+EruXL4pdTUtIC3EoMk5rXruxJEr8UGYMGDGi5GXdgLyaji5duQQ8HK9QURSD
         lsDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804547; x=1721409347;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mb0B7Hd7jBO2MYoksoGxVz1RYZrGwifSFfR0TgGjfro=;
        b=Be7KStIbKo56dXdcSbqNH5VFeFIS8Qs0u3xa+L76NTdzwUTigUMAQ4YonOGj38xkjS
         E36pjmMK06exdHmVpiL20MA84h5zye5hLwkWRQFOTo5bHYUvZ+PlGZp406ixnVtxewal
         KZIprjVXDPnDtYmmqA6DmZenAaUkXBlfs5qQZ+DIptn0U4uxkefulVpE6LzRy0dwN4Sh
         YPwGT1J7FmZhTxeZDjbG2k2f0LLVYJG+9Y29Y7snBqvUd8Pj/4vTuMOujnfOvnLh7kd6
         3QuwH9uQTn/Qct2v0/F2cn0YxoBf68TiIchrIzZXp6EJrSEySzTU3JSP0LfNkiVKacw0
         a11w==
X-Gm-Message-State: AOJu0Yxvk3tpiq9ug6vOQt1sYdPsqXUaOg7FN9Z8l2kX6ceHndu0M96i
	IIGdRly2+O2ZExRHHx2Ucql/55B0Ro5Eg9aN0pU9yi8wisXtIjXN9oV7u8p2U64=
X-Google-Smtp-Source: AGHT+IGxeTpLhstx/yTRvo8mJf1MeKlHarO+jUb7Fm6D5SOYshzvQv+CRgJCbYIhBkROFF2Jv6b3Bg==
X-Received: by 2002:a05:6402:2071:b0:58b:565d:ac92 with SMTP id 4fb4d7f45d1cf-594ba6953c2mr7144965a12.22.1720804546426;
        Fri, 12 Jul 2024 10:15:46 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bd459e1esm4706923a12.73.2024.07.12.10.15.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:15:46 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 16/49] libmultipath: add cleanup_dm_task(), and use it in devmapper.c
Date: Fri, 12 Jul 2024 19:14:24 +0200
Message-ID: <20240712171458.77611-17-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240712171458.77611-1-mwilck@suse.com>
References: <20240712171458.77611-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This allows us to get rid of a lot of goto statements, and generally
obtain cleaner code.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 258 ++++++++++++++++-----------------------
 1 file changed, 107 insertions(+), 151 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 8996c1d..4bff62d 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -91,6 +91,12 @@ int libmp_dm_task_run(struct dm_task *dmt)
 	return r;
 }
 
+static void cleanup_dm_task(struct dm_task **pdmt)
+{
+	if (*pdmt)
+		dm_task_destroy(*pdmt);
+}
+
 __attribute__((format(printf, 4, 5))) static void
 dm_write_log (int level, const char *file, int line, const char *f, ...)
 {
@@ -203,8 +209,8 @@ static void init_dm_drv_version(void)
 
 static int dm_tgt_version (unsigned int *version, char *str)
 {
-	int r = 2;
-	struct dm_task *dmt;
+	bool found = false;
+	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
 	struct dm_versions *target;
 	struct dm_versions *last_target;
 	unsigned int *v;
@@ -220,31 +226,28 @@ static int dm_tgt_version (unsigned int *version, char *str)
 	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(2, DM_DEVICE_LIST_VERSIONS, dmt);
 		condlog(0, "Cannot communicate with kernel DM");
-		goto out;
+		return 1;
 	}
 	target = dm_task_get_versions(dmt);
 
 	do {
 		last_target = target;
 		if (!strncmp(str, target->name, strlen(str))) {
-			r = 1;
+			found = true;
 			break;
 		}
 		target = (void *) target + target->next;
 	} while (last_target != target);
 
-	if (r == 2) {
+	if (!found) {
 		condlog(0, "DM %s kernel driver not loaded", str);
-		goto out;
+		return 1;
 	}
 	v = target->version;
 	version[0] = v[0];
 	version[1] = v[1];
 	version[2] = v[2];
-	r = 0;
-out:
-	dm_task_destroy(dmt);
-	return r;
+	return 0;
 }
 
 static void init_dm_mpath_version(void)
@@ -383,18 +386,18 @@ libmp_dm_task_create(int task)
 
 static int
 dm_simplecmd (int task, const char *name, int flags, uint16_t udev_flags) {
-	int r = 0;
+	int r;
 	int udev_wait_flag = (((flags & DMFL_NEED_SYNC) || udev_flags) &&
 			      (task == DM_DEVICE_RESUME ||
 			       task == DM_DEVICE_REMOVE));
 	uint32_t cookie = 0;
-	struct dm_task *dmt;
+	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
 
 	if (!(dmt = libmp_dm_task_create (task)))
 		return 0;
 
 	if (!dm_task_set_name (dmt, name))
-		goto out;
+		return 0;
 
 	dm_task_skip_lockfs(dmt);	/* for DM_DEVICE_RESUME */
 #ifdef LIBDM_API_FLUSH
@@ -408,7 +411,7 @@ dm_simplecmd (int task, const char *name, int flags, uint16_t udev_flags) {
 	if (udev_wait_flag &&
 	    !dm_task_set_cookie(dmt, &cookie,
 				DM_UDEV_DISABLE_LIBRARY_FALLBACK | udev_flags))
-		goto out;
+		return 0;
 
 	r = libmp_dm_task_run (dmt);
 	if (!r)
@@ -416,8 +419,6 @@ dm_simplecmd (int task, const char *name, int flags, uint16_t udev_flags) {
 
 	if (udev_wait_flag)
 			libmp_udev_wait(cookie);
-out:
-	dm_task_destroy (dmt);
 	return r;
 }
 
@@ -440,8 +441,9 @@ static int
 dm_addmap (int task, const char *target, struct multipath *mpp,
 	   char * params, int ro, uint16_t udev_flags) {
 	int r = 0;
-	struct dm_task *dmt;
-	char *prefixed_uuid = NULL;
+	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
+	char __attribute__((cleanup(cleanup_charp))) *prefixed_uuid = NULL;
+
 	uint32_t cookie = 0;
 
 	if (task == DM_DEVICE_CREATE && strlen(mpp->wwid) == 0) {
@@ -457,10 +459,10 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
 		return 0;
 
 	if (!dm_task_set_name (dmt, mpp->alias))
-		goto addout;
+		return 0;
 
 	if (!dm_task_add_target (dmt, 0, mpp->size, target, params))
-		goto addout;
+		return 0;
 
 	if (ro)
 		dm_task_set_ro(dmt);
@@ -469,10 +471,10 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
 		if (asprintf(&prefixed_uuid, UUID_PREFIX "%s", mpp->wwid) < 0) {
 			condlog(0, "cannot create prefixed uuid : %s",
 				strerror(errno));
-			goto addout;
+			return 0;
 		}
 		if (!dm_task_set_uuid(dmt, prefixed_uuid))
-			goto freeout;
+			return 0;
 		dm_task_skip_lockfs(dmt);
 #ifdef LIBDM_API_FLUSH
 		dm_task_no_flush(dmt);
@@ -481,33 +483,28 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
 
 	if (mpp->attribute_flags & (1 << ATTR_MODE) &&
 	    !dm_task_set_mode(dmt, mpp->mode))
-		goto freeout;
+		return 0;
 	if (mpp->attribute_flags & (1 << ATTR_UID) &&
 	    !dm_task_set_uid(dmt, mpp->uid))
-		goto freeout;
+		return 0;
 	if (mpp->attribute_flags & (1 << ATTR_GID) &&
 	    !dm_task_set_gid(dmt, mpp->gid))
-		goto freeout;
+		return 0;
+
 	condlog(2, "%s: %s [0 %llu %s %s]", mpp->alias,
 		task == DM_DEVICE_RELOAD ? "reload" : "addmap", mpp->size,
 		target, params);
 
 	if (task == DM_DEVICE_CREATE &&
 	    !dm_task_set_cookie(dmt, &cookie, udev_flags))
-		goto freeout;
+		return 0;
 
 	r = libmp_dm_task_run (dmt);
 	if (!r)
 		dm_log_error(2, task, dmt);
 
 	if (task == DM_DEVICE_CREATE)
-			libmp_udev_wait(cookie);
-freeout:
-	if (prefixed_uuid)
-		free(prefixed_uuid);
-
-addout:
-	dm_task_destroy (dmt);
+		libmp_udev_wait(cookie);
 
 	if (r)
 		mpp->need_reload = false;
@@ -648,46 +645,41 @@ int dm_map_present(const char * str)
 
 int dm_get_map(const char *name, unsigned long long *size, char **outparams)
 {
-	int r = DMP_ERR;
-	struct dm_task *dmt;
+	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
 	uint64_t start, length;
 	char *target_type = NULL;
 	char *params = NULL;
 
 	if (!(dmt = libmp_dm_task_create(DM_DEVICE_TABLE)))
-		return r;
+		return DMP_ERR;
 
 	if (!dm_task_set_name(dmt, name))
-		goto out;
+		return DMP_ERR;
 
 	errno = 0;
 	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_TABLE, dmt);
 		if (dm_task_get_errno(dmt) == ENXIO)
-			r = DMP_NOT_FOUND;
-		goto out;
+			return DMP_NOT_FOUND;
+		else
+			return DMP_ERR;
 	}
 
-	r = DMP_NOT_FOUND;
 	/* Fetch 1st target */
 	if (dm_get_next_target(dmt, NULL, &start, &length,
 			       &target_type, &params) != NULL || !params)
 		/* more than one target or not found target */
-		goto out;
+		return DMP_NOT_FOUND;
 
 	if (size)
 		*size = length;
 
 	if (!outparams)
-		r = DMP_OK;
+		return DMP_OK;
 	else {
 		*outparams = strdup(params);
-		r = *outparams ? DMP_OK : DMP_ERR;
+		return *outparams ? DMP_OK : DMP_ERR;
 	}
-
-out:
-	dm_task_destroy(dmt);
-	return r;
 }
 
 static int
@@ -767,7 +759,7 @@ is_mpath_part(const char *part_name, const char *map_name)
 int dm_get_status(const char *name, char **outstatus)
 {
 	int r = DMP_ERR;
-	struct dm_task *dmt;
+	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
 	uint64_t start, length;
 	char *target_type = NULL;
 	char *status = NULL;
@@ -796,7 +788,7 @@ int dm_get_status(const char *name, char **outstatus)
 		goto out;
 
 	if (!status) {
-		condlog(2, "get null status.");
+		condlog(2, "got null status.");
 		goto out;
 	}
 
@@ -808,9 +800,9 @@ int dm_get_status(const char *name, char **outstatus)
 	}
 out:
 	if (r != DMP_OK)
-		condlog(0, "%s: error getting map status string", name);
+		condlog(0, "%s: %s: error getting map status string: %d",
+			__func__, name, r);
 
-	dm_task_destroy(dmt);
 	return r;
 }
 
@@ -823,7 +815,7 @@ out:
 int dm_type(const char *name, char *type)
 {
 	int r = 0;
-	struct dm_task *dmt;
+	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
 	uint64_t start, length;
 	char *target_type = NULL;
 	char *params;
@@ -850,7 +842,6 @@ int dm_type(const char *name, char *type)
 		r = 1;
 
 out:
-	dm_task_destroy(dmt);
 	return r;
 }
 
@@ -863,7 +854,7 @@ out:
 int dm_is_mpath(const char *name)
 {
 	int r = -1;
-	struct dm_task *dmt;
+	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
 	struct dm_info info;
 	uint64_t start, length;
 	char *target_type = NULL;
@@ -874,38 +865,36 @@ int dm_is_mpath(const char *name)
 		goto out;
 
 	if (!dm_task_set_name(dmt, name))
-		goto out_task;
+		goto out;
 
 	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_TABLE, dmt);
-		goto out_task;
+		goto out;
 	}
 
 	if (!dm_task_get_info(dmt, &info))
-		goto out_task;
+		goto out;
 
 	r = 0;
 
 	if (!info.exists)
-		goto out_task;
+		goto out;
 
 	uuid = dm_task_get_uuid(dmt);
 
 	if (!uuid || strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN) != 0)
-		goto out_task;
+		goto out;
 
 	/* Fetch 1st target */
 	if (dm_get_next_target(dmt, NULL, &start, &length, &target_type,
 			       &params) != NULL)
 		/* multiple targets */
-		goto out_task;
+		goto out;
 
 	if (!target_type || strcmp(target_type, TGT_MPATH) != 0)
-		goto out_task;
+		goto out;
 
 	r = 1;
-out_task:
-	dm_task_destroy(dmt);
 out:
 	if (r < 0)
 		condlog(3, "%s: dm command failed in %s: %s", name, __FUNCTION__, strerror(errno));
@@ -1131,10 +1120,10 @@ dm_flush_map_nopaths(const char *mapname, int deferred_remove __DR_UNUSED__)
 	return _dm_flush_map(mapname, flags, 0);
 }
 
-int dm_flush_maps (int retries)
+int dm_flush_maps(int retries)
 {
 	int r = DM_FLUSH_FAIL;
-	struct dm_task *dmt;
+	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
 	struct dm_names *names;
 	unsigned next = 0;
 
@@ -1143,15 +1132,15 @@ int dm_flush_maps (int retries)
 
 	if (!libmp_dm_task_run (dmt)) {
 		dm_log_error(3, DM_DEVICE_LIST, dmt);
-		goto out;
+		return r;
 	}
 
 	if (!(names = dm_task_get_names (dmt)))
-		goto out;
+		return r;
 
 	r = DM_FLUSH_OK;
 	if (!names->dev)
-		goto out;
+		return r;
 
 	do {
 		int ret;
@@ -1163,16 +1152,13 @@ int dm_flush_maps (int retries)
 		names = (void *) names + next;
 	} while (next);
 
-out:
-	dm_task_destroy (dmt);
 	return r;
 }
 
 int
 dm_message(const char * mapname, char * message)
 {
-	int r = 1;
-	struct dm_task *dmt;
+	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
 
 	if (!(dmt = libmp_dm_task_create(DM_DEVICE_TARGET_MSG)))
 		return 1;
@@ -1191,13 +1177,10 @@ dm_message(const char * mapname, char * message)
 		goto out;
 	}
 
-	r = 0;
+	return 0;
 out:
-	if (r)
-		condlog(0, "DM message failed [%s]", message);
-
-	dm_task_destroy(dmt);
-	return r;
+	condlog(0, "DM message failed [%s]", message);
+	return 1;
 }
 
 int
@@ -1305,12 +1288,10 @@ out:
 	return NULL;
 }
 
-int
-dm_get_maps (vector mp)
+int dm_get_maps(vector mp)
 {
 	struct multipath * mpp;
-	int r = 1;
-	struct dm_task *dmt;
+	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
 	struct dm_names *names;
 	unsigned next = 0;
 
@@ -1322,15 +1303,15 @@ dm_get_maps (vector mp)
 
 	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_LIST, dmt);
-		goto out;
+		return 1;
 	}
 
 	if (!(names = dm_task_get_names(dmt)))
-		goto out;
+		return 1;
 
 	if (!names->dev) {
-		r = 0; /* this is perfectly valid */
-		goto out;
+		/* this is perfectly valid */
+		return 0;
 	}
 
 	do {
@@ -1339,11 +1320,11 @@ dm_get_maps (vector mp)
 
 		mpp = dm_get_multipath(names->name);
 		if (!mpp)
-			goto out;
+			return 1;
 
 		if (!vector_alloc_slot(mp)) {
 			free_multipath(mpp, KEEP_PATHS);
-			goto out;
+			return 1;
 		}
 
 		vector_set_slot(mp, mpp);
@@ -1352,11 +1333,7 @@ next:
 		names = (void *) names + next;
 	} while (next);
 
-	r = 0;
-	goto out;
-out:
-	dm_task_destroy (dmt);
-	return r;
+	return 0;
 }
 
 int
@@ -1419,10 +1396,10 @@ do_foreach_partmaps (const char * mapname,
 		     int (*partmap_func)(const char *, void *),
 		     void *data)
 {
-	struct dm_task *dmt;
+	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
+	char __attribute__((cleanup(cleanup_charp))) *params = NULL;
 	struct dm_names *names;
 	unsigned next = 0;
-	char *params = NULL;
 	unsigned long long size;
 	char dev_t[32];
 	int r = 1;
@@ -1431,21 +1408,18 @@ do_foreach_partmaps (const char * mapname,
 	if (!(dmt = libmp_dm_task_create(DM_DEVICE_LIST)))
 		return 1;
 
-	if (!libmp_dm_task_run(dmt)) {
-		dm_log_error(3, DM_DEVICE_LIST, dmt);
-		goto out;
-	}
+	if (!libmp_dm_task_run(dmt))
+		return 1;
 
 	if (!(names = dm_task_get_names(dmt)))
-		goto out;
+		return 1;
 
-	if (!names->dev) {
-		r = 0; /* this is perfectly valid */
-		goto out;
-	}
+	if (!names->dev)
+		/* this is perfectly valid */
+		return 0;
 
 	if (dm_dev_t(mapname, &dev_t[0], 32))
-		goto out;
+		return 1;
 
 	do {
 		if (
@@ -1472,7 +1446,7 @@ do_foreach_partmaps (const char * mapname,
 		    !isdigit(*(p + strlen(dev_t)))
 		   ) {
 			if ((r = partmap_func(names->name, data)) != 0)
-				goto out;
+				return 1;
 		}
 
 		free(params);
@@ -1481,11 +1455,7 @@ do_foreach_partmaps (const char * mapname,
 		names = (void *) names + next;
 	} while (next);
 
-	r = 0;
-out:
-	free(params);
-	dm_task_destroy (dmt);
-	return r;
+	return 0;
 }
 
 struct remove_data {
@@ -1623,7 +1593,7 @@ int
 dm_rename (const char * old, char * new, char *delim, int skip_kpartx)
 {
 	int r = 0;
-	struct dm_task *dmt;
+	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
 	uint32_t cookie = 0;
 	uint16_t udev_flags = DM_UDEV_DISABLE_LIBRARY_FALLBACK | ((skip_kpartx == SKIP_KPARTX_ON)? MPATH_UDEV_NO_KPARTX_FLAG : 0);
 
@@ -1634,22 +1604,19 @@ dm_rename (const char * old, char * new, char *delim, int skip_kpartx)
 		return r;
 
 	if (!dm_task_set_name(dmt, old))
-		goto out;
+		return r;
 
 	if (!dm_task_set_newname(dmt, new))
-		goto out;
+		return r;
 
 	if (!dm_task_set_cookie(dmt, &cookie, udev_flags))
-		goto out;
+		return r;
+
 	r = libmp_dm_task_run(dmt);
 	if (!r)
 		dm_log_error(2, DM_DEVICE_RENAME, dmt);
 
 	libmp_udev_wait(cookie);
-
-out:
-	dm_task_destroy(dmt);
-
 	return r;
 }
 
@@ -1672,9 +1639,10 @@ void dm_reassign_deps(char *table, const char *dep, const char *newdep)
 
 int dm_reassign_table(const char *name, char *old, char *new)
 {
-	int r = 0, modified = 0;
+	int modified = 0;
 	uint64_t start, length;
-	struct dm_task *dmt, *reload_dmt;
+	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
+	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *reload_dmt = NULL;
 	char *target, *params = NULL;
 	char *buff;
 	void *next = NULL;
@@ -1683,16 +1651,16 @@ int dm_reassign_table(const char *name, char *old, char *new)
 		return 0;
 
 	if (!dm_task_set_name(dmt, name))
-		goto out;
+		return 0;
 
 	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_TABLE, dmt);
-		goto out;
+		return 0;
 	}
 	if (!(reload_dmt = libmp_dm_task_create(DM_DEVICE_RELOAD)))
-		goto out;
+		return 0;
 	if (!dm_task_set_name(reload_dmt, name))
-		goto out_reload;
+		return 0;
 
 	do {
 		next = dm_get_next_target(dmt, next, &start, &length,
@@ -1705,13 +1673,13 @@ int dm_reassign_table(const char *name, char *old, char *new)
 			 */
 			condlog(1, "%s: invalid target found in map %s",
 				__func__, name);
-			goto out_reload;
+			return 0;
 		}
 		buff = strdup(params);
 		if (!buff) {
 			condlog(3, "%s: failed to replace target %s, "
 				"out of memory", name, target);
-			goto out_reload;
+			return 0;
 		}
 		if (strcmp(target, TGT_MPATH) && strstr(params, old)) {
 			condlog(3, "%s: replace target %s %s",
@@ -1729,18 +1697,12 @@ int dm_reassign_table(const char *name, char *old, char *new)
 		if (!libmp_dm_task_run(reload_dmt)) {
 			dm_log_error(3, DM_DEVICE_RELOAD, reload_dmt);
 			condlog(3, "%s: failed to reassign targets", name);
-			goto out_reload;
+			return 0;
 		}
 		dm_simplecmd_noflush(DM_DEVICE_RESUME, name,
 				     MPATH_UDEV_RELOAD_FLAG);
 	}
-	r = 1;
-
-out_reload:
-	dm_task_destroy(reload_dmt);
-out:
-	dm_task_destroy(dmt);
-	return r;
+	return 1;
 }
 
 
@@ -1752,10 +1714,9 @@ out:
 int dm_reassign(const char *mapname)
 {
 	struct dm_deps *deps;
-	struct dm_task *dmt;
+	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
 	struct dm_info info;
 	char dev_t[32], dm_dep[32];
-	int r = 0;
 	unsigned int i;
 
 	if (dm_dev_t(mapname, &dev_t[0], 32)) {
@@ -1769,21 +1730,21 @@ int dm_reassign(const char *mapname)
 	}
 
 	if (!dm_task_set_name(dmt, mapname))
-		goto out;
+		return 0;
 
 	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_DEPS, dmt);
-		goto out;
+		return 0;
 	}
 
 	if (!dm_task_get_info(dmt, &info))
-		goto out;
+		return 0;
 
 	if (!(deps = dm_task_get_deps(dmt)))
-		goto out;
+		return 0;
 
 	if (!info.exists)
-		goto out;
+		return 0;
 
 	for (i = 0; i < deps->count; i++) {
 		sprintf(dm_dep, "%d:%d",
@@ -1792,15 +1753,12 @@ int dm_reassign(const char *mapname)
 		sysfs_check_holders(dm_dep, dev_t);
 	}
 
-	r = 1;
-out:
-	dm_task_destroy (dmt);
-	return r;
+	return 1;
 }
 
 int dm_setgeometry(struct multipath *mpp)
 {
-	struct dm_task *dmt;
+	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
 	struct path *pp;
 	char heads[4], sectors[4];
 	char cylinders[10], start[32];
@@ -1825,7 +1783,7 @@ int dm_setgeometry(struct multipath *mpp)
 		return 0;
 
 	if (!dm_task_set_name(dmt, mpp->alias))
-		goto out;
+		return 0;
 
 	/* What a sick interface ... */
 	snprintf(heads, 4, "%u", pp->geom.heads);
@@ -1834,14 +1792,12 @@ int dm_setgeometry(struct multipath *mpp)
 	snprintf(start, 32, "%lu", pp->geom.start);
 	if (!dm_task_set_geometry(dmt, cylinders, heads, sectors, start)) {
 		condlog(3, "%s: Failed to set geometry", mpp->alias);
-		goto out;
+		return 0;
 	}
 
 	r = libmp_dm_task_run(dmt);
 	if (!r)
 		dm_log_error(3, DM_DEVICE_SET_GEOMETRY, dmt);
-out:
-	dm_task_destroy(dmt);
 
 	return r;
 }
-- 
2.45.2

