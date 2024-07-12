Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48ADB176FDF
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804562; cv=none; b=IoMKV7PTB7jmnLSypGGUcCwbbcA69B00HSADO7qNhi8BKbtf4TXw3pXoyhSnyqYA12wgqVq3use9Rix1xyyAhOmASKH8+HNHEV8kPNEBeji1gHeZ8IrPhVqEpTMU+HFseLy3reGssx27OBfziR4p/lIWxGvZ30vZAOZyQX18LyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804562; c=relaxed/simple;
	bh=H3lbTgafBwE3FdhWe5HVIIU74OtJhuUVMb2JQCJ/2Ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VTPq6dlZQ3jHLsb/gGa1MLdcCWTRyPpzKQBB1cAfCXQFQbXp648kDSstHbYlUt+n3hB8YIiQMudBrIJV5PjG1B1Dl2kMxwNvIJ6SHuQAZ/iweP3JMSkSAEGwVQHqU6WwYxAyI/crrJhmPA2BFYxieEeARoDt0TKNfKpYMdexUv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=G705/Alr; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="G705/Alr"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-52ea929ea56so4443126e87.0
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804558; x=1721409358; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=USesQfSeVdBwIDVYLPok92k5IMH0ABwZ/Vwmqq5x8bk=;
        b=G705/Alr/1j4QBcRx5H6BXWHeZCtBh031xTpp+Dpvr9CsNJJRiuAS1jekYx94Fdc5S
         L+3nzzPXIau6WuX5lsJXDb+RKD828dSx+FOQN5rss5hUnRx5+advcdeCPVNQ0Aj8fgEG
         JK3rXsrzdX/60RMLwZGDOSX4qF1OhvPWzQqKogo5Gzzqzy5rWLDW0CsDr0CgIMGXq10a
         CDu1T7Hq2JoeQa6bWbY8yNHJgRfyqFIfnk1TMQ3utZ1sefqt0emKx8svTZjvrV08aCnW
         dQMYZBF57lfihoM4aj2pRJGuN20uFSKRPyga5A1rp5uOopoCLPXIm/efQixQkzFhJnIb
         AV7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804558; x=1721409358;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=USesQfSeVdBwIDVYLPok92k5IMH0ABwZ/Vwmqq5x8bk=;
        b=uEDIMuxyrufg+CvmLkDKvV9W7gNL2qfjeZe6UiqbTfRVPB/v6szBk8RJ4Z63FcLOGm
         BbN6aPnaN6jLmcdPOmkquJ/uBUgB7iuDWqkkKzKJ1AT/s+/70Da7bFItkSu/2Z1aHZGj
         k4Z8NJvtUY+p4F6G9J4SVQWYkVkEjUFfwZD2ub4MWHFbRUlpah9YW2s4RXRqxzMx/2J+
         OzPj4PinwcWFHz59k1KkS9wNSC33uwpJElv95GtEkhHjjbJzfOG63fPYWujsw577G7FE
         V4+5I8Y8n/7EacbVyyvPJtrjonZTiBwqXCNcrfKhzyEar9HpH2m5whnhjJsln9XCVNEN
         r89A==
X-Gm-Message-State: AOJu0YxIKKdApCxN44Mbvu/40PNi7BBNhhb6aglqvwGt4GcZqbL2k/oU
	HH0mKOkCqCYYRrJ+14glOWeRz/S7zCvm5iEVHDxa4116Im2w22ESeavgNYzLwk0=
X-Google-Smtp-Source: AGHT+IE5IltU5Fl3275ShY3BBch2lNKEjjXZNShGvY18YdMLombzYI2EOsyyk1g3W1tFEWmrHJKQCw==
X-Received: by 2002:ac2:4db5:0:b0:52e:932d:88ab with SMTP id 2adb3069b0e04-52eb999c206mr8476336e87.23.1720804558372;
        Fri, 12 Jul 2024 10:15:58 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a854368sm359363666b.155.2024.07.12.10.15.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:15:58 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 27/49] libmultipath: reimplement dm_map_present_by_uuid()
Date: Fri, 12 Jul 2024 19:14:35 +0200
Message-ID: <20240712171458.77611-28-mwilck@suse.com>
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

... and rename it to dm_map_present_by_wwid().

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 47 ++++++----------------------------------
 libmultipath/devmapper.h |  2 +-
 libmultipath/valid.c     |  2 +-
 tests/valid.c            | 10 ++++-----
 4 files changed, 14 insertions(+), 47 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 8af4167..5cada4c 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1023,49 +1023,16 @@ out:
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
index 25e0504..4c8f345 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -127,7 +127,7 @@ int dm_simplecmd_flush (int task, const char *name, uint16_t udev_flags);
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

