Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D751202F9E
	for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 15:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731423759; cv=none; b=HYnMeyWzZrpBkXqidLbDFulzK8tsU9I7Dr/ozV41MRV8Nph12B5c+posUWCxS7toG1FkkDnHnwsTnpXLqSv+b5BJy+g16uqKC+alPwlxP/J2X+a3uGDqMSc/z4arxucubTvjpJiW8V9yrbD2A2X+UznBqFB3mDShhFnDZPKi3vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731423759; c=relaxed/simple;
	bh=4XHTKgsq0ewjstUZzsLq7uJE566Tj7F3r29td0h24vE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqNnxg5stQXrHuIwZJR9ti2N/8hMEoL4xI1UWhYwlhXkW2ypKwTCN+o/RPoWFH5Tefwr1TDzvKcve3TjQwWuSupjFHRfwxtC21KZMN/O/0K26V7GDEP6WQPXOisw0Fc55K9+WBxJDeL+e+VmDmkXShGf+fdkfh42/soKTYlnBFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RG6l4+hg; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RG6l4+hg"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43193678216so55178275e9.0
        for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 07:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731423755; x=1732028555; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oM9G4+Y/UUNSnI92ytGGI9bTNUrGAHaIcfobgWz451Q=;
        b=RG6l4+hgfCuOBqo+eyAp7OGyhy06qbGc8eJ6lC21ZxFxVMl+cNQSV+cqWrikkfG70d
         kQEGYUFpKqVSubKGT3tgyAdxh2uXVIuIKOywM+TdVndsfYgl8IhX6Bz0q2TXZLqMWYb7
         7cB6zMumaJv+Gk2U1ilT6vD6eXu7aJwBzYUwSsbcfOnFK02zONWeYDDE5XOsojCPX++l
         X2wc0T14Jzu1lzU+qlw/yciAWhPjgZ+m/QF1ZE7iRhtCn4UEoQac1bETWpD8ZSaL9d08
         S9hl8CMJr3fPJThhVRtGsNK6a9Qg+zS1k2Pg4uBEDkBYLZPQcmoVXnFcM7K2Ra4w+9Ee
         gLgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731423755; x=1732028555;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oM9G4+Y/UUNSnI92ytGGI9bTNUrGAHaIcfobgWz451Q=;
        b=ckk8UwlaN2fJrqzqEEyc5GYF0gJcfkcRRWDOwU7Bk0a2cbX/v0hhwo4Uo8ZsEIsDGq
         8uNiz7QQkXi0XWL38TuJrIV4nETTeqmgM1wKAJWCQnkozQS9A/E96gGTMugpVxR7Aa2a
         D7UwKVfi0Jnp5OQldc5O2B/nMCgdzFrHbIV+GyelMi7yE/J2tI3O/YxQzHJLh7vjhFfW
         TAvUcPM2rGTkzi1m7pERNHHB9ZMM9lqBbSRPHzrpyXi2LKE8s2DntG7b253raUCurq9K
         aXqJvmNTYdQHnMQeth2KdQyZNlXiA5n7cMV7L93DxPwmyNoiuJ5QbsYB7irRH+uXXc0Q
         TuUQ==
X-Gm-Message-State: AOJu0Yw5EQahjU0i+hkld9w6Hp7ZvDKA0vKOWKtmBpEFsTFjlctoJdeK
	tCAlJGXHlb19CfPPTijvIj3xmjwf4FRWK5Bq6/MPxTfWYo68PGp3CCylTRFb24Y=
X-Google-Smtp-Source: AGHT+IG4myLadnuziydGP5txJQiHuEFSCtMLjCjoxaeSr/vXVizSL0pWkjP4L8zTUqT48w1aiQhfFA==
X-Received: by 2002:a05:600c:3ca8:b0:42c:c003:edd1 with SMTP id 5b1f17b1804b1-432b7501d59mr144266325e9.10.1731423754669;
        Tue, 12 Nov 2024 07:02:34 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-432aa6b35c0sm256276535e9.16.2024.11.12.07.02.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 07:02:34 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 03/12] libmultipath: check DM UUID earlier in libmp_mapinfo__
Date: Tue, 12 Nov 2024 16:02:06 +0100
Message-ID: <20241112150215.90182-4-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112150215.90182-1-mwilck@suse.com>
References: <20241112150215.90182-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Benjamin Marzinski <bmarzins@redhat.com>

Before checking the target details, first check that the device has a
"mpath-" dm uuid prefix. If it doesn't then we can just ignore the
device. This keeps multipath from printing error messages for
non-multipath devices with multiple targets for instance.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 20 +++++++++++---------
 tests/mapinfo.c          | 15 +++++++++++----
 2 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index ab6eefc..93fbc4a 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -715,6 +715,16 @@ static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info, const char *ma
 		return DMP_NOT_FOUND;
 	}
 
+	if ((info.name && !(name = dm_task_get_name(dmt)))
+	    || ((info.uuid || flags & MAPINFO_CHECK_UUID)
+		&& !(uuid = dm_task_get_uuid(dmt))))
+		return DMP_ERR;
+
+	if (flags & MAPINFO_CHECK_UUID && !is_mpath_uuid(uuid)) {
+		condlog(3, "%s: UUID mismatch: %s", fname__, uuid);
+		return DMP_NO_MATCH;
+	}
+
 	if (info.target || info.status || info.size || flags & MAPINFO_TGT_TYPE__) {
 		if (dm_get_next_target(dmt, NULL, &start, &length,
 				       &target_type, &params) != NULL) {
@@ -740,18 +750,10 @@ static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info, const char *ma
 	 * Check possible error conditions.
 	 * If error is returned, don't touch any output parameters.
 	 */
-	if ((info.name && !(name = dm_task_get_name(dmt)))
-	    || ((info.uuid || flags & MAPINFO_CHECK_UUID)
-		&& !(uuid = dm_task_get_uuid(dmt)))
-	    || (info.status && !(tmp_status = strdup(params)))
+	if ((info.status && !(tmp_status = strdup(params)))
 	    || (info.target && !tmp_target && !(tmp_target = strdup(params))))
 		return DMP_ERR;
 
-	if (flags & MAPINFO_CHECK_UUID && !is_mpath_uuid(uuid)) {
-		condlog(3, "%s: UUID mismatch: %s", fname__, uuid);
-		return DMP_NO_MATCH;
-	}
-
 	if (info.name) {
 		strlcpy(info.name, name, WWID_SIZE);
 		condlog(4, "%s: %s: name: \"%s\"", fname__, map_id, info.name);
diff --git a/tests/mapinfo.c b/tests/mapinfo.c
index 66c81e8..4362cdb 100644
--- a/tests/mapinfo.c
+++ b/tests/mapinfo.c
@@ -43,6 +43,15 @@ static const struct dm_info __attribute__((unused)) MPATH_DMI_01 = {
 	.minor = 123,
 };
 
+static const struct dm_info __attribute__((unused)) MPATH_DMI_02 = {
+	.exists = 1,
+	.live_table = 0,
+	.open_count = 1,
+	.target_count = 1,
+	.major = 254,
+	.minor = 123,
+};
+
 static const char MPATH_NAME_01[] = "mpathx";
 static const char MPATH_UUID_01[] = "mpath-3600a098038302d414b2b4d4453474f62";
 static const char MPATH_TARGET_01[] =
@@ -928,6 +937,8 @@ static void test_mapinfo_bad_target_type_03(void **state)
 	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
 	WRAP_DM_TASK_GET_INFO(1);
 	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
+	will_return(__wrap_dm_task_get_name, MPATH_NAME_01);
+	will_return(__wrap_dm_task_get_uuid, MPATH_UUID_01);
 	mock_dm_get_next_target(12345, TGT_PART, MPATH_STATUS_01, NULL);
 	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
 			   (mapid_t) { .str = "foo", },
@@ -1090,7 +1101,6 @@ static void test_mapinfo_bad_get_name_01(void **state)
 	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
 	WRAP_DM_TASK_GET_INFO(1);
 	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
-	mock_dm_get_next_target(12345, TGT_MPATH, MPATH_STATUS_01, NULL);
 	will_return(__wrap_dm_task_get_name, NULL);
 	rc = libmp_mapinfo(DM_MAP_BY_NAME,
 			   (mapid_t) { .str = "foo", },
@@ -1112,7 +1122,6 @@ static void test_mapinfo_bad_get_uuid_01(void **state)
 	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
 	WRAP_DM_TASK_GET_INFO(1);
 	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
-	mock_dm_get_next_target(12345, TGT_MPATH, MPATH_STATUS_01, NULL);
 	will_return(__wrap_dm_task_get_name, MPATH_NAME_01);
 	will_return(__wrap_dm_task_get_uuid, NULL);
 	rc = libmp_mapinfo(DM_MAP_BY_NAME,
@@ -1162,7 +1171,6 @@ static void test_mapinfo_bad_get_name_02(void **state)
 	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
 	WRAP_DM_TASK_GET_INFO(1);
 	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
-	mock_dm_get_next_target(12345, TGT_MPATH, MPATH_STATUS_01, NULL);
 	will_return(__wrap_dm_task_get_name, NULL);
 
 	rc = libmp_mapinfo(DM_MAP_BY_NAME,
@@ -1195,7 +1203,6 @@ static void test_mapinfo_bad_get_uuid_02(void **state)
 	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
 	WRAP_DM_TASK_GET_INFO(1);
 	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
-	mock_dm_get_next_target(12345, TGT_MPATH, MPATH_STATUS_01, NULL);
 	will_return(__wrap_dm_task_get_name, MPATH_NAME_01);
 	will_return(__wrap_dm_task_get_uuid, NULL);
 
-- 
2.47.0

