Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27553185602
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561205; cv=none; b=M7XVfH9YAO8RtwXuArGoaO7ix4MMDhGCPetYmL52NYPJJ2zwalHZyFtAvNdZrF6ZjCekF07TaTsQyyc9pslYM79PtNGyftsfFY771Q+7K9YKTf6OX4hegHxsSLngxSOXorCPov8e+10mjxh04n+nHY9WbCesYSdOGQckv9VcQg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561205; c=relaxed/simple;
	bh=abYD7k/hphhsBt0hmt16d31cF2HJN6EndnDQjh1NVXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iy+ij1HteWiLj5gZw4+U1mhtOrTH6rd1cp+sCYoe9zwUxoJrwLuhMkN/ID/DlipFRWaHxnvXzdly1Rg73TIcwoJD0i5eCptznbE9yj8FCbxwHfMbPkaiXiwQD6zTFPveCErTN4CManNrcj6nk1Q3osYRzX3va/DjZMahSOfdV5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZlNeQnCt; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZlNeQnCt"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-58ef19aa6c4so6083954a12.2
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561200; x=1721166000; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ri/Bzz3gSkKtt1pC1l8Tr5Cek4REYDNL4bmTIyFMAz8=;
        b=ZlNeQnCtrpSBOYtutGlP4X9uCyfzNXkhS6T+u1KtM2tNFr9btcOnJlfkfppZql6HZN
         ztZQ4JkS9I3k2dJcdG8QW8MLDFpb5xRwwelVumCSsieb07zwD7il/jM/sDkyy4eOGBam
         K2e8oQ8zCe9VzkBNY2PJE5ZDJ7SzOwAytldADxOWJcG2VgRrIx4Z4hUKy3fW1I5n7GqX
         +SUtG3JFpSC729lOiHso1mWLNvup+TcK7kVjeY1qaIfz/CtBeSZNFEpoGau6Rw+m8Ydc
         Js4Fb58sj2hPa5d3EOdpQgnaq3uTZWRmPv8IIEdZwDchI4UYguBAvnx14Yhh8jey1do4
         ysng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561200; x=1721166000;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ri/Bzz3gSkKtt1pC1l8Tr5Cek4REYDNL4bmTIyFMAz8=;
        b=tzIFil0Ao7IX7T6yTPJAznbjYyCSSCo8CDeGRJMIsEc++n+M3SZfVfXTbDguNdnuD+
         aHakEaCkAoddm8j4yKdQyEOORbsalRErDes7yLtsXliDuTFuzfFab11DN3/YkT6RCy17
         tBzdnS7FkkblUMHkmdAgoa6hONxKjvEnpVH7pHLZFVVdGj66kR7RjjH0frKJOAyzGhy0
         xcgJN1hhTWhlMDc7Gb1KSD2V+dm+2nwAo80TSVf3n4tt7adhsWn2CxNBoTrVq5PMOnNc
         ulUMpkSIr6VtU2QUw2P26i2G/PCfJWsH9hiu6rNKot3qZlKssoHPDer/nYj84xwyrgZj
         cagA==
X-Gm-Message-State: AOJu0Yz4qS1LMiyYV4Cts8UjeZf5teOnS7U40vybRqHhJOLh3d3rainQ
	Jamv0B+ulKfXDAdfCvNTlDFqh6ybGUGEEG3L2tK3sG6OjkCdY6GD4m8aDUYBtnhtL4QG1wyacWc
	G
X-Google-Smtp-Source: AGHT+IFBezBy/qdVPSmqftU1fzbEkUIkS4EskYHAMMdS6x46EBnvBSGwiGBETHB8j4hoJNvyqvYe8A==
X-Received: by 2002:a17:906:50c:b0:a72:8296:ca1f with SMTP id a640c23a62f3a-a780b881d0amr253271366b.50.1720561200134;
        Tue, 09 Jul 2024 14:40:00 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a6dc5e4sm108523566b.48.2024.07.09.14.39.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:39:59 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 16/44] libmultipath: add cleanup_dm_task(), and use it in devmapper.c
Date: Tue,  9 Jul 2024 23:39:07 +0200
Message-ID: <20240709213935.177028-17-mwilck@suse.com>
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

This allows us to get rid of a lot of goto statements, and generally
obtain cleaner code.

Additional small changes:

 - simplify the logic of dm_tgt_version(); the only caller isn't interested
   in the nature of the error if the version couldn't be obtained.
 - libmultipath: rename dm_type() to the more fitting dm_type_match()
 - use symbolic return values in dm_is_mpath()

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist_int.c |   2 +-
 libmultipath/devmapper.c            | 315 ++++++++++++----------------
 libmultipath/devmapper.h            |   7 +-
 multipath/main.c                    |   4 +-
 multipathd/dmevents.c               |   4 +-
 multipathd/main.c                   |   2 +-
 6 files changed, 145 insertions(+), 189 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 178c2f5..6da0401 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -185,7 +185,7 @@ static int mpath_get_map(vector curmp, vector pathvec, int fd, char **palias,
 
 	condlog(3, "alias = %s", alias);
 
-	if (dm_map_present(alias) && dm_is_mpath(alias) != 1){
+	if (dm_map_present(alias) && dm_is_mpath(alias) != DM_IS_MPATH_YES) {
 		condlog(3, "%s: not a multipath device.", alias);
 		goto out;
 	}
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 8996c1d..3685ef7 100644
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
 
@@ -808,62 +800,56 @@ int dm_get_status(const char *name, char **outstatus)
 	}
 out:
 	if (r != DMP_OK)
-		condlog(0, "%s: error getting map status string", name);
+		condlog(0, "%s: %s: error getting map status string: %d",
+			__func__, name, r);
 
-	dm_task_destroy(dmt);
 	return r;
 }
 
-/*
- * returns:
- *    1 : match
- *    0 : no match
- *   -1 : empty map, or more than 1 target
- */
-int dm_type(const char *name, char *type)
+enum {
+	DM_TYPE_NOMATCH = 0,
+	DM_TYPE_MATCH,
+	/* more than 1 target */
+	DM_TYPE_MULTI,
+	/* empty map */
+	DM_TYPE_EMPTY,
+	DM_TYPE_ERR,
+};
+static int dm_type_match(const char *name, char *type)
 {
-	int r = 0;
-	struct dm_task *dmt;
+	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
 	uint64_t start, length;
 	char *target_type = NULL;
 	char *params;
 
 	if (!(dmt = libmp_dm_task_create(DM_DEVICE_TABLE)))
-		return 0;
+		return DM_TYPE_ERR;
 
 	if (!dm_task_set_name(dmt, name))
-		goto out;
+		return DM_TYPE_ERR;
 
 	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_TABLE, dmt);
-		goto out;
+		return DM_TYPE_ERR;
 	}
 
 	/* Fetch 1st target */
 	if (dm_get_next_target(dmt, NULL, &start, &length,
 			       &target_type, &params) != NULL)
 		/* multiple targets */
-		r = -1;
+		return DM_TYPE_MULTI;
 	else if (!target_type)
-		r = -1;
+		return DM_TYPE_EMPTY;
 	else if (!strcmp(target_type, type))
-		r = 1;
-
-out:
-	dm_task_destroy(dmt);
-	return r;
+		return DM_TYPE_MATCH;
+	else
+		return DM_TYPE_NOMATCH;
 }
 
-/*
- * returns:
- * 1  : is multipath device
- * 0  : is not multipath device
- * -1 : error
- */
 int dm_is_mpath(const char *name)
 {
-	int r = -1;
-	struct dm_task *dmt;
+	int r = DM_IS_MPATH_ERR;
+	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
 	struct dm_info info;
 	uint64_t start, length;
 	char *target_type = NULL;
@@ -874,41 +860,39 @@ int dm_is_mpath(const char *name)
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
 
-	r = 0;
+	r = DM_IS_MPATH_NO;
 
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
 
-	r = 1;
-out_task:
-	dm_task_destroy(dmt);
+	r = DM_IS_MPATH_YES;
 out:
 	if (r < 0)
-		condlog(3, "%s: dm command failed in %s: %s", name, __FUNCTION__, strerror(errno));
+		condlog(3, "%s: dm command failed in %s: %s", name, __func__, strerror(errno));
 	return r;
 }
 
@@ -1049,7 +1033,7 @@ int _dm_flush_map (const char *mapname, int flags, int retries)
 	unsigned long long mapsize;
 	char *params = NULL;
 
-	if (dm_is_mpath(mapname) != 1)
+	if (dm_is_mpath(mapname) != DM_IS_MPATH_YES)
 		return DM_FLUSH_OK; /* nothing to do */
 
 	/* if the device currently has no partitions, do not
@@ -1096,7 +1080,7 @@ int _dm_flush_map (const char *mapname, int flags, int retries)
 			}
 			condlog(4, "multipath map %s removed", mapname);
 			return DM_FLUSH_OK;
-		} else if (dm_is_mpath(mapname) != 1) {
+		} else if (dm_is_mpath(mapname) != DM_IS_MPATH_YES) {
 			condlog(4, "multipath map %s removed externally",
 				mapname);
 			return DM_FLUSH_OK; /* raced. someone else removed it */
@@ -1131,10 +1115,10 @@ dm_flush_map_nopaths(const char *mapname, int deferred_remove __DR_UNUSED__)
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
 
@@ -1143,15 +1127,15 @@ int dm_flush_maps (int retries)
 
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
@@ -1163,16 +1147,13 @@ int dm_flush_maps (int retries)
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
@@ -1191,13 +1172,10 @@ dm_message(const char * mapname, char * message)
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
@@ -1305,12 +1283,10 @@ out:
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
 
@@ -1322,28 +1298,28 @@ dm_get_maps (vector mp)
 
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
-		if (dm_is_mpath(names->name) != 1)
+		if (dm_is_mpath(names->name) != DM_IS_MPATH_YES)
 			goto next;
 
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
@@ -1352,11 +1328,7 @@ next:
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
@@ -1419,10 +1391,10 @@ do_foreach_partmaps (const char * mapname,
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
@@ -1431,28 +1403,25 @@ do_foreach_partmaps (const char * mapname,
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
 		    /*
 		     * if there is only a single "linear" target
 		     */
-		    (dm_type(names->name, TGT_PART) == 1) &&
+		    (dm_type_match(names->name, TGT_PART) == DM_TYPE_MATCH) &&
 
 		    /*
 		     * and the uuid of the target is a partition of the
@@ -1472,7 +1441,7 @@ do_foreach_partmaps (const char * mapname,
 		    !isdigit(*(p + strlen(dev_t)))
 		   ) {
 			if ((r = partmap_func(names->name, data)) != 0)
-				goto out;
+				return 1;
 		}
 
 		free(params);
@@ -1481,11 +1450,7 @@ do_foreach_partmaps (const char * mapname,
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
@@ -1623,7 +1588,7 @@ int
 dm_rename (const char * old, char * new, char *delim, int skip_kpartx)
 {
 	int r = 0;
-	struct dm_task *dmt;
+	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
 	uint32_t cookie = 0;
 	uint16_t udev_flags = DM_UDEV_DISABLE_LIBRARY_FALLBACK | ((skip_kpartx == SKIP_KPARTX_ON)? MPATH_UDEV_NO_KPARTX_FLAG : 0);
 
@@ -1634,22 +1599,19 @@ dm_rename (const char * old, char * new, char *delim, int skip_kpartx)
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
 
@@ -1672,9 +1634,10 @@ void dm_reassign_deps(char *table, const char *dep, const char *newdep)
 
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
@@ -1683,16 +1646,16 @@ int dm_reassign_table(const char *name, char *old, char *new)
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
@@ -1705,13 +1668,13 @@ int dm_reassign_table(const char *name, char *old, char *new)
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
@@ -1729,18 +1692,12 @@ int dm_reassign_table(const char *name, char *old, char *new)
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
 
 
@@ -1752,10 +1709,9 @@ out:
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
@@ -1769,21 +1725,21 @@ int dm_reassign(const char *mapname)
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
@@ -1792,15 +1748,12 @@ int dm_reassign(const char *mapname)
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
@@ -1825,7 +1778,7 @@ int dm_setgeometry(struct multipath *mpp)
 		return 0;
 
 	if (!dm_task_set_name(dmt, mpp->alias))
-		goto out;
+		return 0;
 
 	/* What a sick interface ... */
 	snprintf(heads, 4, "%u", pp->geom.heads);
@@ -1834,14 +1787,12 @@ int dm_setgeometry(struct multipath *mpp)
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
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 19b79c5..9438c2d 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -46,7 +46,12 @@ int dm_map_present (const char *name);
 int dm_map_present_by_uuid(const char *uuid);
 int dm_get_map(const char *name, unsigned long long *size, char **outparams);
 int dm_get_status(const char *name, char **outstatus);
-int dm_type(const char *name, char *type);
+
+enum {
+	DM_IS_MPATH_NO,
+	DM_IS_MPATH_YES,
+	DM_IS_MPATH_ERR,
+};
 int dm_is_mpath(const char *name);
 
 enum {
diff --git a/multipath/main.c b/multipath/main.c
index ce702e7..c82bc86 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -247,7 +247,7 @@ static int check_usable_paths(struct config *conf,
 		goto out;
 	}
 
-	if (dm_is_mpath(mapname) != 1) {
+	if (dm_is_mpath(mapname) != DM_IS_MPATH_YES) {
 		condlog(1, "%s is not a multipath map", devpath);
 		goto free;
 	}
@@ -1080,7 +1080,7 @@ main (int argc, char *argv[])
 		goto out;
 	}
 	if (cmd == CMD_FLUSH_ONE) {
-		if (dm_is_mpath(dev) != 1) {
+		if (dm_is_mpath(dev) != DM_IS_MPATH_YES) {
 			condlog(0, "%s is not a multipath device", dev);
 			r = RTVL_FAIL;
 			goto out;
diff --git a/multipathd/dmevents.c b/multipathd/dmevents.c
index 3fbdc55..605219e 100644
--- a/multipathd/dmevents.c
+++ b/multipathd/dmevents.c
@@ -170,7 +170,7 @@ static int dm_get_events(void)
 
 		/* Don't delete device if dm_is_mpath() fails without
 		 * checking the device type */
-		if (dm_is_mpath(names->name) == 0)
+		if (dm_is_mpath(names->name) != DM_IS_MPATH_YES)
 			goto next;
 
 		event_nr = dm_event_nr(names);
@@ -208,7 +208,7 @@ int watch_dmevents(char *name)
 
 	/* We know that this is a multipath device, so only fail if
 	 * device-mapper tells us that we're wrong */
-	if (dm_is_mpath(name) == 0) {
+	if (dm_is_mpath(name) != DM_IS_MPATH_YES) {
 		condlog(0, "%s: not a multipath device. can't watch events",
 			name);
 		return -1;
diff --git a/multipathd/main.c b/multipathd/main.c
index 58afe14..132bb2e 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -865,7 +865,7 @@ ev_add_map (char * dev, const char * alias, struct vectors * vecs)
 	int reassign_maps;
 	struct config *conf;
 
-	if (dm_is_mpath(alias) != 1) {
+	if (dm_is_mpath(alias) != DM_IS_MPATH_YES) {
 		condlog(4, "%s: not a multipath map", alias);
 		return 0;
 	}
-- 
2.45.2

