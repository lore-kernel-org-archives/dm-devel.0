Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C13118785E
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561215; cv=none; b=qMFuZ9k38BaJkTgFXyirlVtbL+J5bYSbZiWVcz5xmz+GlzodYS4nRDYegWjhQGsv7nwDngB6FuHrMns2lBSZUSFrrWcnCXP+s6oY3qxvia0BLKZ1kFGFHOVRgk7BnPJrYW+NDefqgv8xzmnd3xHS1pzlaZ/MJjJ79WksQl5YbAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561215; c=relaxed/simple;
	bh=9VSycf6Q+k221LeK1oQlx84SNM5Dw6Pd+iKQBdxpMfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etjZ8ptoiGwCBQ9q/zyhNbkCpzo37QFXJOvQaeOt7+eafprkSipBRfCdQ2RKY330mI7M8CYrAjZJIKS9/5/03Rl2hI3nkxW6cmq5sMOO//ccfANFD9Hoxwd0C0nLm1d4ZbkcIXzhuqpFS++btTPZu9OviFB3snEZl52VFHH59JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EFz6a7g7; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EFz6a7g7"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-58b447c513aso6798827a12.2
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561212; x=1721166012; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LN1fbjZFmnUsldYWJZV1+VPh4sqgs+Zz76f7Q0BIp4I=;
        b=EFz6a7g7HnAAkKc7W0CtNrWRwU+T3+n2x0pqpcEWzF8C5tzvV97pinsCJ9K66Rf7Vn
         Adh4lEkgbUZbZo49VVmwXmxIlRdmrnTqT3EmS9yz4jfiVIybhD54BQ3T38Rw/Echa4W/
         /ctyTsQAldol+6Ho8Rybo+rXf0aTTrib5pOqz7NwCa2k1wmDRq/Wg+Ys6Xqbjs2FvDDx
         w9gSRETaQ8EZ4xL7mypj3n/sOqEPesRjNoqFrXl53Jl19muysT63Z/Uv5sNurIPAbFS/
         DbZ26Nt2w1NHJtienmEmrUDe0wXflqBT0WJzKaBE574wcFbtmmoUniWOd2VytwjkbC0X
         META==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561212; x=1721166012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LN1fbjZFmnUsldYWJZV1+VPh4sqgs+Zz76f7Q0BIp4I=;
        b=WSJy+eyEPj63EsDKxtDbPtpI3G6AkVTLah53efCHgl+gfuzDn5uK9tmRNZPHXMsdoS
         Tu8TsnR9wSN7fZMqDcMNRPuRaINiAhVU6GOem1NaFujLQjWSotvc4LaFP/J1hrXUQULY
         tffFcXJc23KUuSc0Cf+WZ2wBVuaZ7CqZ6IOmn4mUmkYUvcx/2eJx1YCkNPRj8Eov/AFL
         IPFaIXJAHhbaWwkTtrpM5BOTh80JUzSp3RxTq0Ri6IG4IPeINTIs9iyfR77DX41K4GYG
         BZrJj8el/MfuODmFOZ0bosq48qH0HWVUQoAvZvA5TpJ7tFk2s0WTMG6aio4nsl+tpcIv
         Ks5A==
X-Gm-Message-State: AOJu0YwVl08Ml11q5zWHfsXCMFOmujEBESYdkLDMHhzEzLd4lu4dFsm7
	ZmsT3dCj+91n9X/vqOEMpDU0WMxE4TAbOkvehLq47Y9NGJIr25ubXiWTCsBDxTCuLVaTx1sOR8E
	c
X-Google-Smtp-Source: AGHT+IGvVoWN6t/hjd0ZIyLmTrOSDzl8nTS7mG1kwlP02nLmjdHzGRrasCqW90khEmOuJ2T1B/MMsw==
X-Received: by 2002:a50:8e15:0:b0:57d:524:8818 with SMTP id 4fb4d7f45d1cf-594ba5a0330mr2288688a12.20.1720561211665;
        Tue, 09 Jul 2024 14:40:11 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bb9604f7sm1476885a12.15.2024.07.09.14.40.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:40:11 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 25/44] libmultipath: reimplement dm_map_present_by_uuid()
Date: Tue,  9 Jul 2024 23:39:16 +0200
Message-ID: <20240709213935.177028-26-mwilck@suse.com>
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

... and rename it to dm_map_present_by_wwid().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 47 ++++++----------------------------------
 libmultipath/devmapper.h |  2 +-
 libmultipath/valid.c     |  2 +-
 tests/valid.c            | 10 ++++-----
 4 files changed, 14 insertions(+), 47 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index caa8385..8a0578e 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1013,49 +1013,16 @@ out:
 	return r;
 }
 
-/*
- * Return
- *   1 : map with uuid exists
- *   0 : map with uuid doesn't exist
- *  -1 : error
- */
-int
-dm_map_present_by_uuid(const char *uuid)
+int dm_map_present_by_wwid(const char *wwid)
 {
-	struct dm_task *dmt;
-	struct dm_info info;
-	char prefixed_uuid[WWID_SIZE + UUID_PREFIX_LEN];
-	int r = -1;
+	char tmp[DM_UUID_LEN];
 
-	if (!uuid || uuid[0] == '\0')
-		return 0;
+	if (safe_sprintf(tmp, UUID_PREFIX "%s", wwid))
+		return DMP_ERR;
 
-	if (safe_sprintf(prefixed_uuid, UUID_PREFIX "%s", uuid))
-		goto out;
-
-	if (!(dmt = libmp_dm_task_create(DM_DEVICE_INFO)))
-		goto out;
-
-	if (!dm_task_set_uuid(dmt, prefixed_uuid))
-		goto out_task;
-
-	if (!libmp_dm_task_run(dmt)) {
-		dm_log_error(3, DM_DEVICE_INFO, dmt);
-		goto out_task;
-	}
-
-	if (!dm_task_get_info(dmt, &info))
-		goto out_task;
-
-	r = !!info.exists;
-
-out_task:
-	dm_task_destroy(dmt);
-out:
-	if (r < 0)
-		condlog(3, "%s: dm command failed in %s: %s", uuid,
-			__FUNCTION__, strerror(errno));
-	return r;
+	return libmp_mapinfo(DM_MAP_BY_UUID,
+			     (mapid_t) { .str = tmp },
+			     (mapinfo_t) { .name = NULL });
 }
 
 static int dm_dev_t (const char *mapname, char *dev_t, int len)
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 0043812..db5c5fd 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -122,7 +122,7 @@ int dm_simplecmd_flush (int task, const char *name, uint16_t udev_flags);
 int dm_simplecmd_noflush (int task, const char *name, uint16_t udev_flags);
 int dm_addmap_create (struct multipath *mpp, char *params);
 int dm_addmap_reload (struct multipath *mpp, char *params, int flush);
-int dm_map_present_by_uuid(const char *uuid);
+int dm_map_present_by_wwid(const char *uuid);
 int dm_get_map(const char *name, unsigned long long *size, char **outparams);
 int dm_get_status(const char *name, char **outstatus);
 
diff --git a/libmultipath/valid.c b/libmultipath/valid.c
index f223778..9267cef 100644
--- a/libmultipath/valid.c
+++ b/libmultipath/valid.c
@@ -360,7 +360,7 @@ is_path_valid(const char *name, struct config *conf, struct path *pp,
 	if (check_wwids_file(pp->wwid, 0) == 0)
 		return PATH_IS_VALID_NO_CHECK;
 
-	if (dm_map_present_by_uuid(pp->wwid) == 1)
+	if (dm_map_present_by_wwid(pp->wwid) == DMP_OK)
 		return PATH_IS_VALID;
 
 	/* all these act like FIND_MULTIPATHS_STRICT for finding if a
diff --git a/tests/valid.c b/tests/valid.c
index 18a5a7b..a93bbe5 100644
--- a/tests/valid.c
+++ b/tests/valid.c
@@ -189,7 +189,7 @@ int __wrap_check_wwids_file(char *wwid, int write_wwid)
 		return -1;
 }
 
-int __wrap_dm_map_present_by_uuid(const char *uuid)
+int __wrap_dm_map_present_by_wwid(const char *uuid)
 {
 	int ret = mock_type(int);
 	assert_string_equal(uuid, mock_ptr_type(char *));
@@ -271,8 +271,8 @@ static void setup_passing(char *name, char *wwid, unsigned int check_multipathd,
 	will_return(__wrap_check_wwids_file, wwid);
 	if (stage == STAGE_CHECK_WWIDS)
 		return;
-	will_return(__wrap_dm_map_present_by_uuid, 0);
-	will_return(__wrap_dm_map_present_by_uuid, wwid);
+	will_return(__wrap_dm_map_present_by_wwid, 0);
+	will_return(__wrap_dm_map_present_by_wwid, wwid);
 }
 
 static void test_bad_arguments(void **state)
@@ -516,8 +516,8 @@ static void test_check_uuid_present(void **state)
 	memset(&pp, 0, sizeof(pp));
 	conf.find_multipaths = FIND_MULTIPATHS_STRICT;
 	setup_passing(name, wwid, CHECK_MPATHD_RUNNING, STAGE_CHECK_WWIDS);
-	will_return(__wrap_dm_map_present_by_uuid, 1);
-	will_return(__wrap_dm_map_present_by_uuid, wwid);
+	will_return(__wrap_dm_map_present_by_wwid, 1);
+	will_return(__wrap_dm_map_present_by_wwid, wwid);
 	assert_int_equal(is_path_valid(name, &conf, &pp, true),
 			 PATH_IS_VALID);
 	assert_string_equal(pp.dev, name);
-- 
2.45.2

