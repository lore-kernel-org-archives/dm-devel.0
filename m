Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7518190497
	for <dm-devel@lists.linux.dev>; Fri, 15 Nov 2024 23:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731712986; cv=none; b=VBIkxZCd56sDN0dChaw5WefiOF+JFonijjmQ2uJetEJVh1BKjqduDooJJ6vF5uqo7ELnBmIen6L7smW/XFmI/FN5zKR+jpwoSXs5HSO8TFTQdFaGN0i+qBlmWpRCLQllycJM4IWZhoCs0FiwHxxlsx1Fkyb6YF/nrtf0GQ8yO3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731712986; c=relaxed/simple;
	bh=obMWWhOGLTqybL0WOXC8WHGqjF5h4nczWyLp6Q08FWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pRYlDS368dTDkMAmRreIQvW0umsA4aT8HDVgyVmMLwm4Tk2ChhIrwlNp/hC0MCOOdGXpiMZyR5GWoJtzuPpXeqUgl9eY3UHrpyDJld1r9iz+1rMRQKO3686XoVB1f5pQy2vwBfctPNrtU1Jb5HsSy6EwCIwgNC7Jso+Ugp6ZSJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sbs2ptOp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sbs2ptOp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731712983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cl5X1XtdBeeUSeRnglrhSlI4Mewb5bVavrffhDe3xYs=;
	b=Sbs2ptOpSX7gmIkQMWCB3GAs/sob5U2D6TliGYM6y3JuUM14zt/AR75HOGQ4Mug9NFvWQc
	QmNmMC9MKOWxMPSC02zJUg0nFBg88wkJLwPsK8Lr0loqlVaxlLiq7qzc/UWlQ8DqEX0daM
	/EARcVPEzr/BkHU7u9vYUXthcsH2Vxg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-425-7SPMq8WRPma8_i3674FL-w-1; Fri,
 15 Nov 2024 18:23:00 -0500
X-MC-Unique: 7SPMq8WRPma8_i3674FL-w-1
X-Mimecast-MFC-AGG-ID: 7SPMq8WRPma8_i3674FL-w
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A73301956083;
	Fri, 15 Nov 2024 23:22:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 540C4196BC05;
	Fri, 15 Nov 2024 23:22:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AFNMvvV627964
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 18:22:57 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AFNMvt6627963;
	Fri, 15 Nov 2024 18:22:57 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 4/6] libmultipath: Add flag to always return device ID when found
Date: Fri, 15 Nov 2024 18:22:54 -0500
Message-ID: <20241115232256.627933-5-bmarzins@redhat.com>
In-Reply-To: <20241115232256.627933-1-bmarzins@redhat.com>
References: <20241115232256.627933-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kHvkXNGIWPgZWw92YLCLp0AiJJhm6F4n-RjWu_PvSVs_1731712979
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Normally, libmp_mapinfo will only return the name and uuid of a device
if the device matches all the check requirements. Add a flag,
MAPINFO_ID_IF_FOUND, to make it return the name and uuid as long as
the result isn't DMP_ERR or DMP_NOT_FOUND. This will be used by
a future patch.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c |  33 +++++++++----
 libmultipath/devmapper.h |   5 ++
 tests/mapinfo.c          | 100 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 130 insertions(+), 8 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 842e7c80..42dcbc77 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -663,6 +663,19 @@ static int libmp_set_map_identifier(int flags, mapid_t id, struct dm_task *dmt)
 	}
 }
 
+static void write_ids(char *dst_name, const char *src_name,
+		      char *dst_uuid, const char *src_uuid, const char *map_id)
+{
+	if (dst_name) {
+		strlcpy(dst_name, src_name, WWID_SIZE);
+		condlog(4, "libmp_mapinfo: %s: name: \"%s\"", map_id, dst_name);
+	}
+	if (dst_uuid) {
+		strlcpy(dst_uuid, src_uuid, DM_UUID_LEN);
+		condlog(4, "libmp_mapinfo: %s: uuid: \"%s\"", map_id, dst_uuid);
+	}
+}
+
 static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info, const char *map_id)
 {
 	/* avoid libmp_mapinfo__ in log messages */
@@ -740,6 +753,8 @@ static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info, const char *ma
 	    ((flags & MAPINFO_PART_ONLY && !is_mpath_part_uuid(uuid, NULL)) ||
 	     !is_mpath_uuid(uuid))) {
 		condlog(4, "%s: UUID mismatch: %s", fname__, uuid);
+		if (flags & MAPINFO_ID_IF_FOUND)
+			write_ids(info.name, name, info.uuid, uuid, map_id);
 		return DMP_NO_MATCH;
 	}
 
@@ -749,10 +764,16 @@ static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info, const char *ma
 		if (dm_get_next_target(dmt, NULL, &start, &length,
 				       &target_type, &params) != NULL) {
 			condlog(lvl, "%s: map %s has multiple targets", fname__, map_id);
+			if (flags & MAPINFO_ID_IF_FOUND)
+				write_ids(info.name, name, info.uuid, uuid,
+					  map_id);
 			return DMP_NO_MATCH;
 		}
 		if (!params || !target_type) {
 			condlog(lvl, "%s: map %s has no targets", fname__, map_id);
+			if (flags & MAPINFO_ID_IF_FOUND)
+				write_ids(info.name, name, info.uuid, uuid,
+					  map_id);
 			return DMP_EMPTY;
 		}
 		if (flags & MAPINFO_TGT_TYPE__) {
@@ -761,6 +782,9 @@ static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info, const char *ma
 			if (strcmp(target_type, tgt_type)) {
 				condlog(lvl, "%s: target type mismatch: \"%s\" != \"%s\"",
 					fname__, tgt_type, target_type);
+				if (flags & MAPINFO_ID_IF_FOUND)
+					write_ids(info.name, name, info.uuid,
+						  uuid, map_id);
 				return DMP_NO_MATCH;
 			}
 		}
@@ -774,14 +798,7 @@ static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info, const char *ma
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
+	write_ids(info.name, name, info.uuid, uuid, map_id);
 
 	if (info.size) {
 		*info.size = length;
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 0bd2b907..630dd7b6 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -67,6 +67,11 @@ enum {
 	 * multipath UUID format ("mpath-xyz").
 	 */
 	MAPINFO_CHECK_UUID  = (1 << 10),
+	/*
+	 * If a device is found and info.name or info.uuid are non-NULL
+	 * they will be set, even if the device doesn't match
+	 */
+	MAPINFO_ID_IF_FOUND = (1 << 11),
 };
 
 typedef union libmp_map_identifier {
diff --git a/tests/mapinfo.c b/tests/mapinfo.c
index ee487989..1bfa1201 100644
--- a/tests/mapinfo.c
+++ b/tests/mapinfo.c
@@ -381,6 +381,23 @@ static void test_mapinfo_bad_get_info_01(void **state)
 	assert_int_equal(rc, DMP_ERR);
 }
 
+static void test_mapinfo_bad_get_with_ids(void **state)
+{
+	int rc;
+	char name[WWID_SIZE] = { 0 };
+	struct dm_info dmi = { .suspended = 0 };
+
+	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&dmi);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_ID_IF_FOUND,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .name = name });
+	assert_int_equal(rc, DMP_NOT_FOUND);
+	/* verify that name isn't set */
+	assert_memory_equal(&name, &((char[WWID_SIZE]) { 0 }), WWID_SIZE);
+}
+
 static void test_mapinfo_bad_get_info_02(void **state)
 {
 	int rc;
@@ -574,6 +591,22 @@ static void test_mapinfo_bad_check_uuid_09(void **state)
 	assert_int_equal(rc, DMP_OK);
 }
 
+static void test_mapinfo_bad_check_uuid_with_ids(void **state)
+{
+	int rc;
+	char uuid[DM_UUID_LEN] = { 0 };
+
+	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	will_return(__wrap_dm_task_get_uuid, BAD_UUID_01);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID | MAPINFO_ID_IF_FOUND,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .uuid = uuid });
+	assert_int_equal(rc, DMP_NO_MATCH);
+	assert_true(!strcmp(uuid, BAD_UUID_01));
+}
+
 static void test_mapinfo_good_check_uuid_01(void **state)
 {
 	int rc;
@@ -884,6 +917,25 @@ static void test_mapinfo_bad_next_target_01(void **state)
 	assert_int_equal(rc, DMP_NO_MATCH);
 }
 
+static void test_mapinfo_bad_next_target_with_ids(void **state)
+{
+	int rc;
+	unsigned long long size;
+	char uuid[DM_UUID_LEN] = { 0 };
+
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	will_return(__wrap_dm_task_get_uuid, MPATH_UUID_01);
+	/* multiple targets */
+	mock_dm_get_next_target(12345, NULL, MPATH_STATUS_01, (void *)1);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_ID_IF_FOUND,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .size = &size, .uuid = uuid });
+	assert_int_equal(rc, DMP_NO_MATCH);
+	assert_true(!strcmp(uuid, MPATH_UUID_01));
+}
+
 static void test_mapinfo_bad_next_target_02(void **state)
 {
 	int rc;
@@ -900,6 +952,29 @@ static void test_mapinfo_bad_next_target_02(void **state)
 	assert_int_equal(rc, DMP_EMPTY);
 }
 
+static void test_mapinfo_no_target_with_ids(void **state)
+{
+	int rc;
+	unsigned long long size;
+	char name[WWID_SIZE] = { 0 };
+
+	expect_value(__wrap_dm_task_create, task, DM_DEVICE_STATUS);
+	will_return(__wrap_dm_task_create, 1);
+	expect_value(__wrap_dm_task_set_uuid, uuid, MPATH_UUID_01);
+	will_return(__wrap_dm_task_set_uuid, 1);
+	will_return(__wrap_dm_task_run, 1);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_02);
+	will_return(__wrap_dm_task_get_name, MPATH_NAME_01);
+	/* no targets */
+	mock_dm_get_next_target(0, NULL, NULL, NULL);
+	rc = libmp_mapinfo(DM_MAP_BY_UUID | MAPINFO_ID_IF_FOUND,
+			   (mapid_t) { .str = MPATH_UUID_01, },
+			   (mapinfo_t) { .size = &size, .name = name });
+	assert_int_equal(rc, DMP_EMPTY);
+	assert_true(!strcmp(name, MPATH_NAME_01));
+}
+
 /* libmp_mapinfo needs to do a DM_DEVICE_STATUS ioctl */
 static void test_mapinfo_bad_target_type_01(void **state)
 {
@@ -915,6 +990,26 @@ static void test_mapinfo_bad_target_type_01(void **state)
 	assert_int_equal(rc, DMP_NO_MATCH);
 }
 
+static void test_mapinfo_bad_target_with_ids(void **state)
+{
+	int rc;
+	char uuid[DM_UUID_LEN] = { 0 };
+	struct dm_info dmi = { .suspended = 0 };
+
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	will_return(__wrap_dm_task_get_uuid, MPATH_UUID_01);
+	mock_dm_get_next_target(12345, "linear", MPATH_STATUS_01, NULL);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY | MAPINFO_ID_IF_FOUND,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .uuid = uuid, .dmi = &dmi });
+	assert_int_equal(rc, DMP_NO_MATCH);
+	assert_true(!strcmp(uuid, MPATH_UUID_01));
+	/* Verify the dmi isn't geting set */
+	assert_memory_equal(&dmi, &((struct dm_info) { .exists = 0 }), sizeof(dmi));
+}
+
 static void test_mapinfo_bad_target_type_02(void **state)
 {
 	int rc;
@@ -1376,6 +1471,7 @@ static int test_mapinfo(void)
 		cmocka_unit_test(test_mapinfo_bad_task_run_10),
 		cmocka_unit_test(test_mapinfo_bad_task_run_11),
 		cmocka_unit_test(test_mapinfo_bad_get_info_01),
+		cmocka_unit_test(test_mapinfo_bad_get_with_ids),
 		cmocka_unit_test(test_mapinfo_bad_get_info_02),
 		cmocka_unit_test(test_mapinfo_bad_get_info_03),
 		cmocka_unit_test(test_mapinfo_bad_get_info_04),
@@ -1390,6 +1486,7 @@ static int test_mapinfo(void)
 		cmocka_unit_test(test_mapinfo_bad_check_uuid_07),
 		cmocka_unit_test(test_mapinfo_bad_check_uuid_08),
 		cmocka_unit_test(test_mapinfo_bad_check_uuid_09),
+		cmocka_unit_test(test_mapinfo_bad_check_uuid_with_ids),
 		cmocka_unit_test(test_mapinfo_good_check_uuid_01),
 		cmocka_unit_test(test_mapinfo_good_check_uuid_02),
 		cmocka_unit_test(test_mapinfo_good_check_uuid_03),
@@ -1409,8 +1506,11 @@ static int test_mapinfo(void)
 		cmocka_unit_test(test_mapinfo_good_uuid),
 		cmocka_unit_test(test_mapinfo_good_size),
 		cmocka_unit_test(test_mapinfo_bad_next_target_01),
+		cmocka_unit_test(test_mapinfo_bad_next_target_with_ids),
 		cmocka_unit_test(test_mapinfo_bad_next_target_02),
+		cmocka_unit_test(test_mapinfo_no_target_with_ids),
 		cmocka_unit_test(test_mapinfo_bad_target_type_01),
+		cmocka_unit_test(test_mapinfo_bad_target_with_ids),
 		cmocka_unit_test(test_mapinfo_bad_target_type_02),
 		cmocka_unit_test(test_mapinfo_bad_target_type_03),
 		cmocka_unit_test(test_mapinfo_bad_target_type_04),
-- 
2.46.2

