Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A899178378
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804585; cv=none; b=itLqyvij/YhxoSL8/O1j8sCdtdGUonBUu85iXG/5PZ9r2hSifepxe6A0nOoIAVSfahoCXDSk/9XxD1E4HhxPMvQut7vr9NSK5vD6fjb0bH2OT5x+f5jfiWvZiCI0YXlaybw/rwODEMpypGmJAEAbYw8bOvcI02Z6zuHhg+nWkJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804585; c=relaxed/simple;
	bh=1+XOsrMbSTQr1JMav2K4kPoGyz/fj3/idzqx5iLRkYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1tdB471z+th7awwgYNehQlMjcwpFJXLkorDyv4pooFybx4FlR18Sq5SfLfFhBilK1NJjYry1bHqcC3ZC8DXYOu7a2R7vUhBoR4G1iLMoDXq2kw0+w2ZqzMlg3vN5k8DtxDBPcooRoKVN8gQxGI2rg2Hx+o3Ias3SUdHWSgxLRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Bb28lmVL; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Bb28lmVL"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-58ba3e38027so2503460a12.1
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804582; x=1721409382; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WTyDcYYnKMGgh8T6amsvuE4DGBR56P+VOW9lY2V4/KY=;
        b=Bb28lmVLGp/+ym0wmxXrXbaDsGyh0kFBWfi32Hbzk17VkymAHBTnBintCxW1KHeO+q
         jx+fxlsIX9tMgVfnae75mwICvsd1eU9uq85sKCc3DAW/jUygvO6PqJGyGiouxzLc8OYi
         zi0ClNS1yvDU2G3ONkixCCHNk5pkZAfp0zwcEbb3LTBvfz32XRDmVsXIvNEG6Q2NkSoc
         uYoytecC8kWsBbAkCvabBuZy7jPIXnJgbiJhyBKrT36SAHP362CV9XJ8iM305FsWhHyI
         3WI0CAweziMqJOGZuDerXpbJRGwd2+9hUQH6lxOkFBGwJDgTQRhciFFbvR7DCdP1jqOk
         T5EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804582; x=1721409382;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WTyDcYYnKMGgh8T6amsvuE4DGBR56P+VOW9lY2V4/KY=;
        b=fi+tm6FAAheQQl0BxhKdfqLqAj0PrKi3c1BLSYEYHPKxbRaLDd6S1yEFZdjOYkKJP6
         IRc4Wo6xyG6SMzDb4D6uKjl3SBxIz5MD3D04IqfLByQcBB7OuAZIvVA9KVAbuwMIBr2y
         kHwujSbzBK6xrXiWJxYXmX7WEYDmKkanWBfwrSTPpeDYykX2C8vrX1INvd9CMDf69dPG
         XOaVlwEak2leXt+o3kgvfBmO83+/kET20eruEB/zBpNRtMQwUFWUgMEZ/ohtYQbw8tg8
         I80JBnb+Ci0uxlajWjGFTzhgSHh4PVgwPD5QhwyAOPknpCT2+BmV50DHAnaZA+QTcaUW
         oCJw==
X-Gm-Message-State: AOJu0Yxxs4UxiFXAF1k0lOpvbOVHdhjBnoM8Q7dki2LhoJi8gLs7BFGk
	OJXibsPpWdlc+3kpI7cHyf1nnDezqvYPn/m1+LmvA5o9D5CpVtaNoAuYUIhMFr4=
X-Google-Smtp-Source: AGHT+IFHrAJbte/r9sSFW6u5Vk5ps7/EONN+Ts0v1Ew3x8SF7CNIS0/hZRQKNS4OcFhvAKl/qdAOlg==
X-Received: by 2002:a50:931c:0:b0:57c:db99:a131 with SMTP id 4fb4d7f45d1cf-594bc7c8aa6mr8020083a12.29.1720804581781;
        Fri, 12 Jul 2024 10:16:21 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bbe2ceadsm4778617a12.32.2024.07.12.10.16.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:16:21 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 48/49] libmultipath: Move UUID check into libmp_pathinfo__()
Date: Fri, 12 Jul 2024 19:14:56 +0200
Message-ID: <20240712171458.77611-49-mwilck@suse.com>
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
index d9d96be..bbbadee 100644
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
@@ -734,11 +739,17 @@ static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info, const char *ma
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
+		condlog(3, "%s: UUID mismatch: %s", __func__, uuid);
+		return DMP_NO_MATCH;
+	}
+
 	if (info.name) {
 		strlcpy(info.name, name, WWID_SIZE);
 		condlog(4, "%s: %s: name: \"%s\"", __func__, map_id, info.name);
@@ -808,18 +819,6 @@ int libmp_mapinfo(int flags, mapid_t id, mapinfo_t info)
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
@@ -832,16 +831,14 @@ bool is_mpath_uuid(const char uuid[DM_UUID_LEN])
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
 
@@ -859,16 +856,13 @@ static bool is_mpath_part_uuid(const char part_uuid[DM_UUID_LEN],
 
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
@@ -974,14 +968,10 @@ int _dm_flush_map (const char *mapname, int flags, int retries)
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
index 6eb5ab9..c28991f 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -57,6 +57,8 @@ enum __mapinfo_flags {
 	/* Fail if target type is not "partition" (linear) */
 	MAPINFO_PART_ONLY   = (1 << 4),
 	__MAPINFO_TGT_TYPE  = (MAPINFO_MPATH_ONLY | MAPINFO_PART_ONLY),
+	/* Fail if the UUID doesn't match the multipath UUID format */
+	MAPINFO_CHECK_UUID  = (1 << 8),
 };
 
 typedef union libmp_map_identifier {
@@ -138,7 +140,6 @@ enum {
 	DM_IS_MPATH_ERR,
 };
 
-bool is_mpath_uuid(const char uuid[DM_UUID_LEN]);
 int dm_is_mpath(const char *name);
 
 enum {
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 649c1cb..959f675 100644
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
index 13af94e..386cd07 100644
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

