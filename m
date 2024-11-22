Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05DF18784C
	for <dm-devel@lists.linux.dev>; Fri, 22 Nov 2024 21:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732309904; cv=none; b=OvJW1KK2DUo4pDYB+p1NP6VpGr9AGBoS0cgx4D8UbMllm6FXtv0++UCs0L3KyfUc42VeYj1TlIQWzOzjGwfgUfz8toGtoNBWpb3Ow1GTtDJqvWVs0eRbHRWcB12PKynHo28VC6NwZqgD7433Lk54itmmxXAj1D52q0agCmv5+Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732309904; c=relaxed/simple;
	bh=P8I73uIvErG1CVcnSjIv84jZCfTY/0oo7ixlvdEfgIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=WHidvoWKHoJ5fNKhoieBated9eW6rR3+tSUkz7DUCbcprT+2fGRwPtG/2zJBg8vqHXuE687JwXm3W4CPHESJYlwKdDPTVZhHQwRl2Zy36mXG9K1eTAl6fxi8mKMXjWkoWVkFH4miankuFYMKqeG1db6T6p3z/ZtwHX61yVz3XUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JgqZnVub; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JgqZnVub"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732309900;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KtO4U6DgST+uXeO+I3VPivYpV51EwBMvYq0UBnZN7d8=;
	b=JgqZnVub+euGTMhhc1hdi9kaWpQDQsUcgi8kqyMW6xrWz2tnWclIJsKN3wYDBFlOSnoB9R
	NLk7r6Kq/kyGN8uxGR3Xq+LYbY7h/nUDlXURF7FB5tjADGCj0RjmCq3nzKShrKi3BSECig
	9qbTjRCxQrJqNFWw1d2Udk3bsLvPEOM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-29-NxYjii1XNj6g2oR85OvXgw-1; Fri,
 22 Nov 2024 16:11:37 -0500
X-MC-Unique: NxYjii1XNj6g2oR85OvXgw-1
X-Mimecast-MFC-AGG-ID: NxYjii1XNj6g2oR85OvXgw
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 42F42195609E;
	Fri, 22 Nov 2024 21:11:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BBE0E1955F43;
	Fri, 22 Nov 2024 21:11:35 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AMLBYTf718891
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 22 Nov 2024 16:11:34 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AMLBYW1718890;
	Fri, 22 Nov 2024 16:11:34 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 02/13] multipath-tools tests: fix mapinfo tests
Date: Fri, 22 Nov 2024 16:11:22 -0500
Message-ID: <20241122211133.718861-3-bmarzins@redhat.com>
In-Reply-To: <20241122211133.718861-1-bmarzins@redhat.com>
References: <20241122211133.718861-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: P5Ts7rbOgnv-LYWnlSNwVuadPUPUXA7W0MX96eqRFoQ_1732309896
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Martin Wilck <mwilck@suse.com>

Add tests for the check for empty table introduced in ("libmultipath:
signal device with no table in libmp_mapinfo").

Signed-off-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 tests/mapinfo.c | 49 +++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 6 deletions(-)

diff --git a/tests/mapinfo.c b/tests/mapinfo.c
index 4362cdb0..ee487989 100644
--- a/tests/mapinfo.c
+++ b/tests/mapinfo.c
@@ -47,11 +47,13 @@ static const struct dm_info __attribute__((unused)) MPATH_DMI_02 = {
 	.exists = 1,
 	.live_table = 0,
 	.open_count = 1,
-	.target_count = 1,
+	.target_count = 0,
 	.major = 254,
 	.minor = 123,
 };
 
+#define TGT_ANY "any"
+
 static const char MPATH_NAME_01[] = "mpathx";
 static const char MPATH_UUID_01[] = "mpath-3600a098038302d414b2b4d4453474f62";
 static const char MPATH_TARGET_01[] =
@@ -858,7 +860,7 @@ static void test_mapinfo_good_size(void **state)
 	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
 	WRAP_DM_TASK_GET_INFO(1);
 	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
-	mock_dm_get_next_target(12345, NULL, MPATH_TARGET_01, NULL);
+	mock_dm_get_next_target(12345, TGT_ANY, MPATH_TARGET_01, NULL);
 	rc = libmp_mapinfo(DM_MAP_BY_NAME,
 			   (mapid_t) { .str = "foo", },
 			   (mapinfo_t) { .size = &size });
@@ -889,13 +891,13 @@ static void test_mapinfo_bad_next_target_02(void **state)
 
 	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
 	WRAP_DM_TASK_GET_INFO(1);
-	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_02);
 	/* no targets */
-	mock_dm_get_next_target(12345, NULL, NULL, NULL);
+	mock_dm_get_next_target(0, NULL, NULL, NULL);
 	rc = libmp_mapinfo(DM_MAP_BY_NAME,
 			   (mapid_t) { .str = "foo", },
 			   (mapinfo_t) { .size = &size });
-	assert_int_equal(rc, DMP_NOT_FOUND);
+	assert_int_equal(rc, DMP_EMPTY);
 }
 
 /* libmp_mapinfo needs to do a DM_DEVICE_STATUS ioctl */
@@ -1049,6 +1051,39 @@ static void test_mapinfo_good_target_type_04(void **state)
 	assert_true(!strcmp(uuid, MPATH_UUID_01));
 }
 
+static void test_mapinfo_no_table_01(void **state)
+{
+	int rc;
+	struct dm_info dmi = { .suspended = 0 };
+
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	/* DMI with no live table, MAPINFO_CHECK_UUID not set */
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_02);
+	mock_dm_get_next_target(0, NULL, NULL, NULL);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .dmi = &dmi });
+	assert_int_equal(rc, DMP_EMPTY);
+}
+
+static void test_mapinfo_no_table_02(void **state)
+{
+	int rc;
+	struct dm_info dmi = { .suspended = 0 };
+
+	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
+	WRAP_DM_TASK_GET_INFO(1);
+	/* DMI with no live table, MAPINFO_CHECK_UUID set */
+	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_02);
+	mock_dm_get_next_target(0, NULL, NULL, NULL);
+	will_return(__wrap_dm_task_get_uuid, MPATH_UUID_01);
+	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID | MAPINFO_MPATH_ONLY,
+			   (mapid_t) { .str = "foo", },
+			   (mapinfo_t) { .dmi = &dmi });
+	assert_int_equal(rc, DMP_EMPTY);
+}
+
 static void test_mapinfo_good_status_01(void **state)
 {
 	int rc;
@@ -1142,7 +1177,7 @@ static void test_mapinfo_bad_task_run_11(void **state)
 	mock_mapinfo_name_1(DM_DEVICE_TABLE, 1, "foo", 1, 1, 0);
 	WRAP_DM_TASK_GET_INFO(1);
 	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
-	mock_dm_get_next_target(12345, NULL, MPATH_TARGET_01, NULL);
+	mock_dm_get_next_target(12345, TGT_ANY, MPATH_TARGET_01, NULL);
 	will_return(__wrap_strdup, 1);
 	/* error in 2nd dm_task_run */
 	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 0, EINVAL);
@@ -1384,6 +1419,8 @@ static int test_mapinfo(void)
 		cmocka_unit_test(test_mapinfo_good_target_type_02),
 		cmocka_unit_test(test_mapinfo_good_target_type_03),
 		cmocka_unit_test(test_mapinfo_good_target_type_04),
+		cmocka_unit_test(test_mapinfo_no_table_01),
+		cmocka_unit_test(test_mapinfo_no_table_02),
 		cmocka_unit_test(test_mapinfo_good_status_01),
 		cmocka_unit_test(test_mapinfo_bad_get_name_01),
 		cmocka_unit_test(test_mapinfo_bad_get_uuid_01),
-- 
2.46.2

