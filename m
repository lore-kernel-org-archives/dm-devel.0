Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB8955887
	for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 20:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721163250; cv=none; b=oAcgd+MaSIaFugtbtpquenKMEeArtz6fCX5fKXXq63HApPQ9wFM7gY+R3nakHNVR5LsrCjzPpGLcIoxxJB2OzGSuX6QNapcDz9ZVlq9pZPcKZobjLz/4tmbdHlAvWYt7FhGJ0uELF5nhoQ8XLA15rP1E/g3ueLwXZhDdvqkr7JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721163250; c=relaxed/simple;
	bh=KBNzzxmp9Uwvhd7LoNNhnjnllY3aB3qc6HqzdfhXcEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPOnIWpmeBx4ZTo2kOIsnfRdlF3UTVi1H6YCZYDRdEPrYHLG6tHlBvPGg4xshgty3PMxl/E4lPzq0pCQaEYG3B8PPnFH6m2Dmrfvfe/hv7JZIOyLrzyxypZ3YjEfE9efrZfGcsK7vTHRDMElxYWbwvyU3An66PsP/zeZT0jZdnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=O+O90UrI; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="O+O90UrI"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-59f9f59b88cso1133579a12.3
        for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 13:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721163246; x=1721768046; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3HPjIPC9OfQF0ldr5LtaR56w9OpZppFU3pyXpUE5ngQ=;
        b=O+O90UrI7pdK21sBanwVNgWaDqzOghRNCfAy/xLiKQgupdRV8TYqExP2BNLFMq9zCL
         SdtFSG+4C7HN1rJ3Wti30fYutVWh8djpEaN+mtpIElyQfiz7Qn3L3nDfC5QDcdNw80xk
         E+UzrcUtVX79zGjx4WRUwCmxtCbjcwTSonEawPpAysJN1NKWVAPX2U1HCe89O6Cwi1dn
         b2gtXme12jV1bHOQ34Yp0CNPTe5EL1N/YTeHUR89Y9jZtsg63yqxOuKX5Ep9auMYUx4X
         AXOT1PWBzlLWOlEBs12YlzSOfPkUdVetAEfiD2kFIPTa0mOCS/F4RQAjVRoQRaCWFLyK
         B5HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721163246; x=1721768046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3HPjIPC9OfQF0ldr5LtaR56w9OpZppFU3pyXpUE5ngQ=;
        b=bjjIv44Wz927PIutdb4yF9zb8UCgFVTZzflapcKg0ZmuYEGRRA1gsLPzJ1zC+2Gt6w
         nMjH3DlXuM8e1JRbf/GGRcZOftgllH+TKyTF43XlAnU2Y5lp51mmuDQQuuRnM+2qa//f
         L9M4oalToJIKXqMqfxjTsnMPFP/3IPFx0UgunInaquwpOR60XxV5O+rRfmD1Ak9aqnFh
         kU6VXlxthzdOE9jAvZGhlXaFPhEalXUmIPOrgCplo6Xf4j36lK8ttES0Bb0h1AR/Z7pS
         cyYXKlkp7PMaidvzv24uesX7Qv4T9BK9e41TZVS/x7kBXTT6965VqYTQg3QVRgwyMCJc
         lOVA==
X-Gm-Message-State: AOJu0Yx7gRbgddAa9XEUBWsIGaRdxQ6gL9c80yf5LHz5TJTpMPym3ykB
	lv+AGAI/JOFz0/6dfoLdG/w1ojy8Tj2SSLJFOTmOER6iYBtwXC5JAabDONG/dn0H5ESEkbh5Gb7
	S
X-Google-Smtp-Source: AGHT+IG/HcupBLQp60I42pcZkYrJ9r8Pt7m2TD57sXAtHOO3L0NjkFKeWRFUYVcnFW9Voecrik7fKQ==
X-Received: by 2002:a05:6402:510b:b0:57c:610a:6e7f with SMTP id 4fb4d7f45d1cf-59eeed2967emr2441488a12.11.1721163245741;
        Tue, 16 Jul 2024 13:54:05 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-59b223b3321sm5541465a12.0.2024.07.16.13.54.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jul 2024 13:54:05 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH v3 47/49] libmultipath: Move UUID check into libmp_pathinfo__()
Date: Tue, 16 Jul 2024 22:53:43 +0200
Message-ID: <20240716205344.146310-6-mwilck@suse.com>
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

We have a couple of callers that check whether the map UUID conforms
to the multipath convention ("mpath-xyz"). Move this check into
libmp_mapinfo__(). Add another flag MAPINFO_CHECK_UUID for this
purpose. This allows to simplify some callers, which only fetched
the UUID in order to check it.

Note that the UUID check is orthogonal to MAPINFO_MPATH_ONLY, which
tests the target type. We shold make sure that both tests are in
agreement, but this is postponed to a later patch set.

is_mpath_uuid() can now be converted to a static function.

Also add some unit tests for the WWID check.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c |  11 +-
 libmultipath/devmapper.c            |  52 +++----
 libmultipath/devmapper.h            |   3 +-
 libmultipath/libmultipath.version   |   1 -
 multipath/main.c                    |   5 +-
 multipathd/main.c                   |   7 +-
 tests/mapinfo.c                     | 226 ++++++++++++++++++++++++++++
 7 files changed, 256 insertions(+), 49 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 807415f..f4d9e7c 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -158,7 +158,7 @@ static int mpath_get_map(vector curmp, vector pathvec, int fd, struct multipath
 {
 	int rc;
 	struct stat info;
-	char alias[WWID_SIZE], uuid[DM_UUID_LEN];
+	char alias[WWID_SIZE];
 	struct multipath *mpp;
 
 	if (fstat(fd, &info) != 0){
@@ -171,14 +171,11 @@ static int mpath_get_map(vector curmp, vector pathvec, int fd, struct multipath
 	}
 
 	/* get alias from major:minor*/
-	rc = libmp_mapinfo(DM_MAP_BY_DEVT | MAPINFO_MPATH_ONLY,
+	rc = libmp_mapinfo(DM_MAP_BY_DEVT | MAPINFO_MPATH_ONLY | MAPINFO_CHECK_UUID,
 			   (mapid_t) { .devt = info.st_rdev },
-			   (mapinfo_t) {
-				   .name = alias,
-				   .uuid = uuid,
-			   });
+			   (mapinfo_t) { .name = alias });
 
-	if (rc == DMP_NO_MATCH || !is_mpath_uuid(uuid)) {
+	if (rc == DMP_NO_MATCH) {
 		condlog(3, "%s: not a multipath device.", alias);
 		return MPATH_PR_DMMP_ERROR;
 	} else if (rc != DMP_OK) {
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index e96b83e..455905a 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -611,6 +611,11 @@ int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
 	return 0;
 }
 
+static bool is_mpath_uuid(const char uuid[DM_UUID_LEN])
+{
+	return !strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN);
+}
+
 bool
 has_dm_info(const struct multipath *mpp)
 {
@@ -736,11 +741,17 @@ static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info, const char *ma
 	 * If error is returned, don't touch any output parameters.
 	 */
 	if ((info.name && !(name = dm_task_get_name(dmt)))
-	    || (info.uuid && !(uuid = dm_task_get_uuid(dmt)))
+	    || ((info.uuid || flags & MAPINFO_CHECK_UUID)
+		&& !(uuid = dm_task_get_uuid(dmt)))
 	    || (info.status && !(tmp_status = strdup(params)))
 	    || (info.target && !tmp_target && !(tmp_target = strdup(params))))
 		return DMP_ERR;
 
+	if (flags & MAPINFO_CHECK_UUID && !is_mpath_uuid(uuid)) {
+		condlog(3, "%s: UUID mismatch: %s", fname__, uuid);
+		return DMP_NO_MATCH;
+	}
+
 	if (info.name) {
 		strlcpy(info.name, name, WWID_SIZE);
 		condlog(4, "%s: %s: name: \"%s\"", fname__, map_id, info.name);
@@ -810,18 +821,6 @@ int libmp_mapinfo(int flags, mapid_t id, mapinfo_t info)
 			       libmp_map_identifier(flags, id, idbuf));
 }
 
-static int dm_get_dm_uuid(const char *mapname, char uuid[DM_UUID_LEN])
-{
-	return libmp_mapinfo(DM_MAP_BY_NAME,
-			     (mapid_t) { .str = mapname },
-			     (mapinfo_t) { .uuid = uuid });
-}
-
-bool is_mpath_uuid(const char uuid[DM_UUID_LEN])
-{
-	return !strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN);
-}
-
 /**
  * dm_get_wwid(): return WWID for a multipath map
  * @returns:
@@ -834,16 +833,14 @@ bool is_mpath_uuid(const char uuid[DM_UUID_LEN])
 int dm_get_wwid(const char *name, char *uuid, int uuid_len)
 {
 	char tmp[DM_UUID_LEN];
-	int rc = dm_get_dm_uuid(name, tmp);
+	int rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,
+			       (mapid_t) { .str = name },
+			       (mapinfo_t) { .uuid = tmp });
 
 	if (rc != DMP_OK)
 		return rc;
 
-	if (is_mpath_uuid(tmp))
-		strlcpy(uuid, tmp + UUID_PREFIX_LEN, uuid_len);
-	else
-		return DMP_NO_MATCH;
-
+	strlcpy(uuid, tmp + UUID_PREFIX_LEN, uuid_len);
 	return DMP_OK;
 }
 
@@ -861,16 +858,13 @@ static bool is_mpath_part_uuid(const char part_uuid[DM_UUID_LEN],
 
 int dm_is_mpath(const char *name)
 {
-	char uuid[DM_UUID_LEN];
-	int rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
+	int rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY | MAPINFO_CHECK_UUID,
 			       (mapid_t) { .str = name },
-			       (mapinfo_t) { .uuid = uuid });
+			       (mapinfo_t) { .uuid = NULL });
 
 	switch (rc) {
 	case DMP_OK:
-		if (is_mpath_uuid(uuid))
-			return DM_IS_MPATH_YES;
-		/* fallthrough */
+		return DM_IS_MPATH_YES;
 	case DMP_NOT_FOUND:
 	case DMP_NO_MATCH:
 		return DM_IS_MPATH_NO;
@@ -961,14 +955,10 @@ int _dm_flush_map (const char *mapname, int flags, int retries)
 	int queue_if_no_path = 0;
 	int udev_flags = 0;
 	char *params __attribute__((cleanup(cleanup_charp))) = NULL;
-	char uuid[DM_UUID_LEN];
 
-	if (libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
+	if (libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY | MAPINFO_CHECK_UUID,
 			  (mapid_t) { .str = mapname },
-			  (mapinfo_t) {
-				  .uuid = uuid,
-				  .target = &params }) != DMP_OK
-	    || !is_mpath_uuid(uuid))
+			  (mapinfo_t) { .target = &params }) != DMP_OK)
 		return DM_FLUSH_OK; /* nothing to do */
 
 	/* if the device currently has no partitions, do not
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index d0e20bf..7a551d9 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -57,6 +57,8 @@ enum __mapinfo_flags {
 	/* Fail if target type is not "partition" (linear) */
 	MAPINFO_PART_ONLY   = (1 << 9),
 	__MAPINFO_TGT_TYPE  = (MAPINFO_MPATH_ONLY | MAPINFO_PART_ONLY),
+	/* Fail if the UUID doesn't match the multipath UUID format */
+	MAPINFO_CHECK_UUID  = (1 << 10),
 };
 
 typedef union libmp_map_identifier {
@@ -138,7 +140,6 @@ enum {
 	DM_IS_MPATH_ERR,
 };
 
-bool is_mpath_uuid(const char uuid[DM_UUID_LEN]);
 int dm_is_mpath(const char *name);
 
 enum {
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 54b5a23..292a330 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -127,7 +127,6 @@ global:
 	init_foreign;
 	init_prio;
 	io_err_stat_handle_pathfail;
-	is_mpath_uuid;
 	is_path_valid;
 	libmp_dm_task_create;
 	libmp_get_version;
diff --git a/multipath/main.c b/multipath/main.c
index 0d989dc..4b19d2e 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -254,7 +254,7 @@ static int check_usable_paths(struct config *conf,
 	if (pathvec == NULL)
 		return r;
 
-	if (libmp_mapinfo(DM_MAP_BY_DEVT | MAPINFO_MPATH_ONLY,
+	if (libmp_mapinfo(DM_MAP_BY_DEVT | MAPINFO_MPATH_ONLY | MAPINFO_CHECK_UUID,
 			  (mapid_t) { .devt = devt },
 			  (mapinfo_t) {
 			      .name = mpp->alias,
@@ -266,9 +266,6 @@ static int check_usable_paths(struct config *conf,
 		      }) != DMP_OK)
 		return r;
 
-	if (!is_mpath_uuid(uuid))
-		return r;
-
 	strlcpy(mpp->wwid, uuid + UUID_PREFIX_LEN, sizeof(mpp->wwid));
 
 	if (update_multipath_table__(mpp, pathvec, 0, params, status) != DMP_OK)
diff --git a/multipathd/main.c b/multipathd/main.c
index 32011c9..833c1e2 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -720,7 +720,7 @@ static int add_map_without_path (struct vectors *vecs, const char *alias)
 	if (!mpp || !(mpp->alias = strdup(alias)))
 		return DMP_ERR;
 
-	if ((rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
+	if ((rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY | MAPINFO_CHECK_UUID,
 				(mapid_t) { .str = mpp->alias },
 				(mapinfo_t) {
 					.uuid = uuid,
@@ -731,10 +731,7 @@ static int add_map_without_path (struct vectors *vecs, const char *alias)
 				})) != DMP_OK)
 		return rc;
 
-	if (!is_mpath_uuid(uuid))
-		return DMP_NO_MATCH;
-	else
-		strlcpy(mpp->wwid, uuid + UUID_PREFIX_LEN, sizeof(mpp->wwid));
+	strlcpy(mpp->wwid, uuid + UUID_PREFIX_LEN, sizeof(mpp->wwid));
 
 	if (!strlen(mpp->wwid))
 		condlog(1, "%s: adding map with empty WWID", mpp->alias);
diff --git a/tests/mapinfo.c b/tests/mapinfo.c
index f3a8440..f7ad868 100644
--- a/tests/mapinfo.c
+++ b/tests/mapinfo.c
@@ -54,6 +54,16 @@ static const char MPATH_STATUS_01[] =
 	"A 0 3 2 65:32 A 0 0 1 67:64 A 0 0 1 69:96 A 0 0 1 "
 	"E 0 3 2 8:16 A 0 0 1 66:48 A 0 0 1 68:80 A 0 0 1 ";
 
+static const char BAD_UUID_01[] = "";
+static const char BAD_UUID_02[] = "mpath3600a098038302d414b2b4d4453474f62";
+static const char BAD_UUID_03[] = " mpath-3600a098038302d414b2b4d4453474f62";
+static const char BAD_UUID_04[] = "-mpath-3600a098038302d414b2b4d4453474f62";
+static const char BAD_UUID_05[] = "mpth-3600a098038302d414b2b4d4453474f62";
+static const char BAD_UUID_06[] = "part1-mpath-3600a098038302d414b2b4d4453474f62";
+static const char BAD_UUID_07[] = "mpath 3600a098038302d414b2b4d4453474f62";
+static const char BAD_UUID_08[] = "mpath";
+static const char BAD_UUID_09[] = "mpath-";
+
 char *__real_strdup(const char *str);
 char *__wrap_strdup(const char *str)
 {
@@ -413,6 +423,208 @@ static void test_mapinfo_good_exists(void **state)
 	assert_int_equal(rc, DMP_OK);
 }
 
+static void test_mapinfo_bad_check_uuid_00(void **state)
+{
+	int rc;
+
+	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	will_return(__wrap_dm_task_get_uuid, NULL);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_ERR);
+}
+
+static void test_mapinfo_bad_check_uuid_01(void **state)
+{
+	int rc;
+
+	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	will_return(__wrap_dm_task_get_uuid, BAD_UUID_01);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_NO_MATCH);
+}
+
+static void test_mapinfo_bad_check_uuid_02(void **state)
+{
+	int rc;
+
+	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	will_return(__wrap_dm_task_get_uuid, BAD_UUID_02);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_NO_MATCH);
+}
+
+static void test_mapinfo_bad_check_uuid_03(void **state)
+{
+	int rc;
+
+	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	will_return(__wrap_dm_task_get_uuid, BAD_UUID_03);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_NO_MATCH);
+}
+
+static void test_mapinfo_bad_check_uuid_04(void **state)
+{
+	int rc;
+
+	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	will_return(__wrap_dm_task_get_uuid, BAD_UUID_04);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_NO_MATCH);
+}
+
+static void test_mapinfo_bad_check_uuid_05(void **state)
+{
+	int rc;
+
+	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	will_return(__wrap_dm_task_get_uuid, BAD_UUID_05);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_NO_MATCH);
+}
+
+static void test_mapinfo_bad_check_uuid_06(void **state)
+{
+	int rc;
+
+	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	will_return(__wrap_dm_task_get_uuid, BAD_UUID_06);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_NO_MATCH);
+}
+
+static void test_mapinfo_bad_check_uuid_07(void **state)
+{
+	int rc;
+
+	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	will_return(__wrap_dm_task_get_uuid, BAD_UUID_07);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_NO_MATCH);
+}
+
+static void test_mapinfo_bad_check_uuid_08(void **state)
+{
+	int rc;
+
+	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	will_return(__wrap_dm_task_get_uuid, BAD_UUID_08);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_NO_MATCH);
+}
+
+static void test_mapinfo_bad_check_uuid_09(void **state)
+{
+	int rc;
+
+	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	will_return(__wrap_dm_task_get_uuid, BAD_UUID_09);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_OK);
+}
+
+static void test_mapinfo_good_check_uuid_01(void **state)
+{
+	int rc;
+
+	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	will_return(__wrap_dm_task_get_uuid, MPATH_UUID_01);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_OK);
+}
+
+static void test_mapinfo_good_check_uuid_02(void **state)
+{
+	int rc;
+	char uuid[DM_UUID_LEN];
+
+	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	will_return(__wrap_dm_task_get_uuid, MPATH_UUID_01);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .uuid = uuid });
+	assert_int_equal(rc, DMP_OK);
+}
+
+static void test_mapinfo_good_check_uuid_03(void **state)
+{
+	int rc;
+
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	mock_dm_get_next_target(12345, TGT_MPATH, MPATH_STATUS_01, NULL);
+	will_return(__wrap_dm_task_get_uuid, MPATH_UUID_01);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY | MAPINFO_CHECK_UUID,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = NULL });
+	assert_int_equal(rc, DMP_OK);
+}
+
+static void test_mapinfo_good_check_uuid_04(void **state)
+{
+	char __attribute__((cleanup(cleanup_charp))) *target = NULL;
+	int rc;
+
+	mock_mapinfo_name_1(DM_DEVICE_TABLE, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	mock_dm_get_next_target(12345, TGT_MPATH, MPATH_STATUS_01, NULL);
+	will_return(__wrap_dm_task_get_uuid, MPATH_UUID_01);
+	will_return(__wrap_strdup, 1);
+
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY | MAPINFO_CHECK_UUID,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .target = &target });
+	assert_int_equal(rc, DMP_OK);
+}
+
 static void test_mapinfo_bad_set_uuid(void **state)
 {
 	int rc;
@@ -1126,6 +1338,20 @@ static int test_mapinfo(void)
 		cmocka_unit_test(test_mapinfo_bad_get_info_03),
 		cmocka_unit_test(test_mapinfo_bad_get_info_04),
 		cmocka_unit_test(test_mapinfo_good_exists),
+		cmocka_unit_test(test_mapinfo_bad_check_uuid_00),
+		cmocka_unit_test(test_mapinfo_bad_check_uuid_01),
+		cmocka_unit_test(test_mapinfo_bad_check_uuid_02),
+		cmocka_unit_test(test_mapinfo_bad_check_uuid_03),
+		cmocka_unit_test(test_mapinfo_bad_check_uuid_04),
+		cmocka_unit_test(test_mapinfo_bad_check_uuid_05),
+		cmocka_unit_test(test_mapinfo_bad_check_uuid_06),
+		cmocka_unit_test(test_mapinfo_bad_check_uuid_07),
+		cmocka_unit_test(test_mapinfo_bad_check_uuid_08),
+		cmocka_unit_test(test_mapinfo_bad_check_uuid_09),
+		cmocka_unit_test(test_mapinfo_good_check_uuid_01),
+		cmocka_unit_test(test_mapinfo_good_check_uuid_02),
+		cmocka_unit_test(test_mapinfo_good_check_uuid_03),
+		cmocka_unit_test(test_mapinfo_good_check_uuid_04),
 		cmocka_unit_test(test_mapinfo_bad_set_uuid),
 		cmocka_unit_test(test_mapinfo_bad_set_dev_01),
 		cmocka_unit_test(test_mapinfo_bad_set_dev_02),
-- 
2.45.2

