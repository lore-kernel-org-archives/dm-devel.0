Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A053C185936
	for <dm-devel@lists.linux.dev>; Fri, 22 Nov 2024 21:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732309903; cv=none; b=tblHI+L305K2Ze7LXX502XU1wRquQ1ux45gPcfisRPs3n7yA4qhr7Yk2g6Lh0HH/3xDrk27ZLKPeN/O5izh2oEV6VL0wniLPbMr6Apsg1eCR2IlBdzzoHiIAKNbgFudW4CudRrRaLCKSBsrssUrg1itwZg1dQUStlVjyh6Y32o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732309903; c=relaxed/simple;
	bh=ZHEbH2zltBPlRUp9gFe/V7HuDPN8hjq5jMF0vgHfHIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Js2gqBxU6vk+E/Ytkv76icUQBfQpnI3a1nVMVyqF/q9GSofC0zMT0oWcMLshmwjVa4Cek1giqrKwk6Sv91CsIZZHnctwBCmMgEcy2L58qMgep2ijxmr58CP8IzYassA1QTcihgjZnVTwoXAP3SGghMtwSacN0m+U6UhKOp+GIeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RGTVexd2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RGTVexd2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732309900;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0cBUyxg/lEmULLdMvyTi1lemOd67kYzhAOdr5NaelIo=;
	b=RGTVexd2y9wQRaDZAhd0kp7jJsSL6zc1DRuGueP0j/xwJfHkUbVC6eHtAbcogD9RsAuHXb
	KInuuo2Yxf4SsOjsfFnIU8yqdDB8OVLepZd1dMNxBq9pGmWjRjmePCYNJTTMyTwBljkcs8
	ozoRlYZOygPLSOoqiygEFRwoiZfAfQQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-611-p_QZr7g1MbyvjFHg6y3Atw-1; Fri,
 22 Nov 2024 16:11:37 -0500
X-MC-Unique: p_QZr7g1MbyvjFHg6y3Atw-1
X-Mimecast-MFC-AGG-ID: p_QZr7g1MbyvjFHg6y3Atw
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 573BB1955F41;
	Fri, 22 Nov 2024 21:11:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 139D230000DF;
	Fri, 22 Nov 2024 21:11:35 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AMLBYHp718899
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 22 Nov 2024 16:11:34 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AMLBY8J718898;
	Fri, 22 Nov 2024 16:11:34 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 04/13] libmultipath: set uuid, name, and dmi if a device is found
Date: Fri, 22 Nov 2024 16:11:24 -0500
Message-ID: <20241122211133.718861-5-bmarzins@redhat.com>
In-Reply-To: <20241122211133.718861-1-bmarzins@redhat.com>
References: <20241122211133.718861-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1DfCS5X_QfDj0_suIEst4jvyf4DFWeSoCe7wmLekC8E_1732309896
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Instead of only setting the uuid, name, and dmi on DMP_OK, return them
whenever we find a device, even if that device doesn't match. To make the
code simpler, we set these values before checks that could possibly return
DMP_ERR.

The only caller of libmp_mapinfo() that could update a multipath value
incorrectly because of this is update_multipath_table(). Fix that.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c   | 47 +++++++++++++++++++-------------------
 libmultipath/devmapper.h   |  5 +++-
 libmultipath/structs_vec.c |  5 +++-
 tests/mapinfo.c            | 45 +++++++++++++++++++++++++-----------
 4 files changed, 63 insertions(+), 39 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 42176667..38c49bd5 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -736,6 +736,29 @@ static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info, const char *ma
 		&& !(uuid = dm_task_get_uuid(dmt))))
 		return DMP_ERR;
 
+	if (info.name) {
+		strlcpy(info.name, name, WWID_SIZE);
+		condlog(4, "%s: %s: name: \"%s\"", fname__, map_id, info.name);
+	}
+	if (info.uuid) {
+		strlcpy(info.uuid, uuid, DM_UUID_LEN);
+		condlog(4, "%s: %s: uuid: \"%s\"", fname__, map_id, info.uuid);
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
 	if (flags & MAPINFO_CHECK_UUID &&
 	    ((flags & MAPINFO_PART_ONLY && !is_mpath_part_uuid(uuid, NULL)) ||
 	     (!(flags & MAPINFO_PART_ONLY) && !is_mpath_uuid(uuid)))) {
@@ -768,40 +791,16 @@ static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info, const char *ma
 
 	/*
 	 * Check possible error conditions.
-	 * If error is returned, don't touch any output parameters.
 	 */
 	if ((info.status && !(tmp_status = strdup(params)))
 	    || (info.target && !tmp_target && !(tmp_target = strdup(params))))
 		return DMP_ERR;
 
-	if (info.name) {
-		strlcpy(info.name, name, WWID_SIZE);
-		condlog(4, "%s: %s: name: \"%s\"", fname__, map_id, info.name);
-	}
-	if (info.uuid) {
-		strlcpy(info.uuid, uuid, DM_UUID_LEN);
-		condlog(4, "%s: %s: uuid: \"%s\"", fname__, map_id, info.uuid);
-	}
-
 	if (info.size) {
 		*info.size = length;
 		condlog(4, "%s: %s: size: %lld", fname__, map_id, *info.size);
 	}
 
-	if (info.dmi) {
-		memcpy(info.dmi, &dmi, sizeof(*info.dmi));
-		condlog(4, "%s: %s %d:%d, %d targets, %s table, %s, %s, %d opened, %u events",
-			fname__, map_id,
-			info.dmi->major, info.dmi->minor,
-			info.dmi->target_count,
-			info.dmi->live_table ? "live" :
-				info.dmi->inactive_table ? "inactive" : "no",
-			info.dmi->suspended ? "suspended" : "active",
-			info.dmi->read_only ? "ro" : "rw",
-			info.dmi->open_count,
-			info.dmi->event_nr);
-	}
-
 	if (info.target) {
 		*info.target = steal_ptr(tmp_target);
 		if (!tgt_set)
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 0bd2b907..4aeefad1 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -115,7 +115,10 @@ typedef struct libmp_map_info {
  *
  * This function obtains the requested information for the device-mapper map
  * identified by the input parameters.
- * Output parameters are only filled in if the return value is DMP_OK.
+ * If non-NULL, the name, uuid, and dmi output paramters may be filled in for
+ * any return value besides DMP_NOT_FOUND and will always be filled in for
+ * return values other than DMP_NOT_FOUND and DMP_ERR.
+ * The other parameters are only filled in if the return value is DMP_OK.
  * For target / status / size information, the  map's table should contain
  * only one target (usually multipath or linear).
  */
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 5df495b3..d22056ca 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -504,6 +504,8 @@ update_multipath_table (struct multipath *mpp, vector pathvec, int flags)
 	int r = DMP_ERR;
 	char __attribute__((cleanup(cleanup_charp))) *params = NULL;
 	char __attribute__((cleanup(cleanup_charp))) *status = NULL;
+	/* only set the actual mpp->dmi if libmp_mapinfo returns DMP_OK */
+	struct dm_info dmi;
 	unsigned long long size;
 	struct config *conf;
 
@@ -522,7 +524,7 @@ update_multipath_table (struct multipath *mpp, vector pathvec, int flags)
 				  .target = &params,
 				  .status = &status,
 				  .size = &mpp->size,
-				  .dmi = &mpp->dmi,
+				  .dmi = &dmi,
 			  });
 
 	if (r != DMP_OK) {
@@ -531,6 +533,7 @@ update_multipath_table (struct multipath *mpp, vector pathvec, int flags)
 	} else if (size != mpp->size)
 		condlog(0, "%s: size changed from %llu to %llu", mpp->alias, size, mpp->size);
 
+	mpp->dmi = dmi;
 	return update_multipath_table__(mpp, pathvec, flags, params, status);
 }
 
diff --git a/tests/mapinfo.c b/tests/mapinfo.c
index ee487989..36511607 100644
--- a/tests/mapinfo.c
+++ b/tests/mapinfo.c
@@ -451,15 +451,21 @@ static void test_mapinfo_bad_check_uuid_00(void **state)
 static void test_mapinfo_bad_check_uuid_01(void **state)
 {
 	int rc;
+	struct dm_info dmi = { .suspended = 0 };
+	char name[WWID_SIZE] = { 0 };
+	char uuid[DM_UUID_LEN] = { 0 };
 
 	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
 	WRAP_DM_TASK_GET_INFO(1);
 	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	will_return(__wrap_dm_task_get_name, MPATH_NAME_01);
 	will_return(__wrap_dm_task_get_uuid, BAD_UUID_01);
 	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,
 			   (mapid_t) { .str = "foo", },
-			   (mapinfo_t) { .name = NULL });
+			   (mapinfo_t) { .dmi = &dmi, .name = name, .uuid = uuid });
 	assert_int_equal(rc, DMP_NO_MATCH);
+	assert_true(!strcmp(name, MPATH_NAME_01));
+	assert_true(!strcmp(uuid, BAD_UUID_01));
 }
 
 static void test_mapinfo_bad_check_uuid_02(void **state)
@@ -887,17 +893,26 @@ static void test_mapinfo_bad_next_target_01(void **state)
 static void test_mapinfo_bad_next_target_02(void **state)
 {
 	int rc;
-	unsigned long long size;
+	struct dm_info dmi = { .suspended = 0 };
+	char name[WWID_SIZE] = { 0 };
+	char uuid[DM_UUID_LEN] = { 0 };
+	unsigned long long size = 0;
 
 	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
 	WRAP_DM_TASK_GET_INFO(1);
 	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_02);
+	will_return(__wrap_dm_task_get_name, MPATH_NAME_01);
+	will_return(__wrap_dm_task_get_uuid, MPATH_UUID_01);
 	/* no targets */
 	mock_dm_get_next_target(0, NULL, NULL, NULL);
 	rc = libmp_mapinfo(DM_MAP_BY_NAME,
 			   (mapid_t) { .str = "foo", },
-			   (mapinfo_t) { .size = &size });
+			   (mapinfo_t) { .dmi = &dmi, .name = name, .uuid = uuid, .size = &size });
 	assert_int_equal(rc, DMP_EMPTY);
+	assert_int_equal(size, 0);
+	assert_memory_equal(&dmi, &MPATH_DMI_02, sizeof(dmi));
+	assert_true(!strcmp(name, MPATH_NAME_01));
+	assert_true(!strcmp(uuid, MPATH_UUID_01));
 }
 
 /* libmp_mapinfo needs to do a DM_DEVICE_STATUS ioctl */
@@ -946,10 +961,10 @@ static void test_mapinfo_bad_target_type_03(void **state)
 			   (mapid_t) { .str = "foo", },
 			   (mapinfo_t) { .dmi = &dmi, .name = name, .uuid = uuid });
 	assert_int_equal(rc, DMP_NO_MATCH);
-	/* make sure memory content is not changed */
-	assert_memory_equal(&dmi, &((struct dm_info) { .exists = 0 }), sizeof(dmi));
-	assert_memory_equal(&name, &((char[WWID_SIZE]) { 0 }), WWID_SIZE);
-	assert_memory_equal(&uuid, &((char[DM_UUID_LEN]) { 0 }), DM_UUID_LEN);
+	/* make sure that the ouput was filled in */
+	assert_memory_equal(&dmi, &MPATH_DMI_01, sizeof(dmi));
+	assert_true(!strcmp(name, MPATH_NAME_01));
+	assert_true(!strcmp(uuid, MPATH_UUID_01));
 }
 
 static void test_mapinfo_bad_target_type_04(void **state)
@@ -1065,23 +1080,32 @@ static void test_mapinfo_no_table_01(void **state)
 			   (mapid_t) { .str = "foo", },
 			   (mapinfo_t) { .dmi = &dmi });
 	assert_int_equal(rc, DMP_EMPTY);
+	assert_memory_equal(&dmi, &MPATH_DMI_02, sizeof(dmi));
 }
 
 static void test_mapinfo_no_table_02(void **state)
 {
 	int rc;
 	struct dm_info dmi = { .suspended = 0 };
+	char name[WWID_SIZE] = { 0 };
+	char uuid[DM_UUID_LEN] = { 0 };
+	unsigned long long size = 0;
 
 	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
 	WRAP_DM_TASK_GET_INFO(1);
 	/* DMI with no live table, MAPINFO_CHECK_UUID set */
 	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_02);
+	will_return(__wrap_dm_task_get_name, MPATH_NAME_01);
 	mock_dm_get_next_target(0, NULL, NULL, NULL);
 	will_return(__wrap_dm_task_get_uuid, MPATH_UUID_01);
 	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID | MAPINFO_MPATH_ONLY,
 			   (mapid_t) { .str = "foo", },
-			   (mapinfo_t) { .dmi = &dmi });
+			   (mapinfo_t) { .dmi = &dmi, .name = name, .uuid = uuid, .size = &size });
 	assert_int_equal(rc, DMP_EMPTY);
+	assert_int_equal(size, 0);
+	assert_memory_equal(&dmi, &MPATH_DMI_02, sizeof(dmi));
+	assert_true(!strcmp(name, MPATH_NAME_01));
+	assert_true(!strcmp(uuid, MPATH_UUID_01));
 }
 
 static void test_mapinfo_good_status_01(void **state)
@@ -1121,8 +1145,6 @@ static void test_mapinfo_bad_strdup_01(void **state)
 			   (mapinfo_t) { .status = &status, .uuid = uuid, .name = name });
 	assert_int_equal(rc, DMP_ERR);
 	assert_null(status);
-	assert_memory_equal(&name, &((char[WWID_SIZE]) { 0 }), WWID_SIZE);
-	assert_memory_equal(&uuid, &((char[DM_UUID_LEN]) { 0 }), DM_UUID_LEN);
 
 }
 
@@ -1284,9 +1306,6 @@ static void test_mapinfo_bad_strdup_02(void **state)
 	assert_int_equal(rc, DMP_ERR);
 	assert_null(status);
 	assert_null(target);
-	assert_memory_equal(&dmi, &((struct dm_info) { .suspended = 0 }), sizeof(dmi));
-	assert_memory_equal(&name, &((char[WWID_SIZE]) { 0 }), WWID_SIZE);
-	assert_memory_equal(&uuid, &((char[DM_UUID_LEN]) { 0 }), DM_UUID_LEN);
 }
 
 static void test_mapinfo_bad_strdup_03(void **state)
-- 
2.46.2

