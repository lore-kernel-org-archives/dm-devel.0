Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6037D18785C
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561200; cv=none; b=AzLOgTCd7NfXrfXZBXPThC3FnxwpMe+1qh/Jcgj5DCNel2SQ2IsN+8xazHaEcynX5pomin00glA+aISZFHOu7NmdSR9WPf/C6rjaSdVopZErGHfuvkcOiCK4TbWYrulmfqmmQL7h2fr/JmJ9j4j7Sz7/lezbUFEv4PcYEGvds40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561200; c=relaxed/simple;
	bh=bDYDRN/D8Xo+k0wT/YuLcg4LMyzeZpfxPQRRTvn9BL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OL7trqP7LBHzxYuLJwSfy0a8rP1HUdYkhXc2dXDVL+jLbGKgaw5W8Ma+PqAYwbPA9rSkI6rM7Cw9n1dOvAE416bDM5TdDadORVLKmzsPW3Ptcj8OPAu06btIBoqNN6u23rjzgpgZ0tam+e7VbHCrK3sVb2kP8ZZruAwNqjGK8Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Nv4SbeEY; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Nv4SbeEY"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-58bac81f40bso7514019a12.1
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561197; x=1721165997; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EPVx26GVW4NPvGvPuX5l81GMdUPQzDeIAhO2nHsQav8=;
        b=Nv4SbeEYORXJGI0VExA5HOOkA7ySU6tZXBIPxbZ2gJTMN3jW/yUeviOC4HXctpXqhR
         MjPT4LQz7JAXOw68P1xgCKaZHO6LZJrAZ5G4yeOPwmO+HN7YNvcx15JFmewsrjpXmeCR
         qPiyrWuz2I7zz5YMwGLXH0mQDE+AXcW+31ITXiaPbU3aqWH2ndMgB87iNEMlAKrU0vdV
         2JMZBgH30WjzsLcFAggX7NcscLYgfXXz/8ead4R1pQuQ6BIz3betERnN3ogYKx4v4AUV
         IYYRjVsST4xGWjvD5xwtlxIyyLMhJssdQVuD8v/B7vac6mVu/U46FWrj+e59qap7U5Ig
         Datg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561197; x=1721165997;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EPVx26GVW4NPvGvPuX5l81GMdUPQzDeIAhO2nHsQav8=;
        b=azadnwlOkI9aOf26aoBHr/+lH+lWgNNDjFZpkdcBJ4x4V9KpuSUz4WoJM1lkD8gHqj
         EB1LV0h8ZtvsO99yBYJ6dLRm2TYuMlI9dL6K06PomB9uUMBIsRWCypBvwKAyYFgKTHuS
         m37kzIWrq50fBYQBYgPVEdwDv20FeKZw8x+CviEo6TEjP5AFFLupoGRx8tgGA5yytKXK
         FMGUcIAR4dlYcaQqJvsP4xb9wDimsn5H1sWtnJdz1Tt6aL6E9EdNxMeQ6Wgs2ceinZn7
         CkzD5VwcoAEcR2R5W2wI4Z7NSMkcdb4kWr2JR55lCc+8pJ5333MJ/qpwDKfwrnwrgX7A
         XaZw==
X-Gm-Message-State: AOJu0YxXPiT+BSSZ4wPwiFqNhGVPakNQ8q4YOnJY0ZazYSZegjmPBQwT
	DQNCBiiUkhjymMLhC1Poim3KsMJXQV7zpOFRHvEC3nM2/X4S6H9D7FD0+1Bubr27RICCUAldI2k
	9
X-Google-Smtp-Source: AGHT+IEI1En732rbFn0matw/C39ai/sS5PzGt6PKoqTCbm1NG3Ak7CFriFIIo3UnoQYUrxyaGc1QMw==
X-Received: by 2002:a17:907:94c7:b0:a72:8a75:6559 with SMTP id a640c23a62f3a-a780b884495mr316197166b.47.1720561196566;
        Tue, 09 Jul 2024 14:39:56 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a7ff213sm107923766b.107.2024.07.09.14.39.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:39:56 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 12/44] multipath-tools: don't call dm_task_no_open_count()
Date: Tue,  9 Jul 2024 23:39:03 +0200
Message-ID: <20240709213935.177028-13-mwilck@suse.com>
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

dm_task_no_open_count() only sets DM_SKIP_BDGET_FLAG in the dm task,
which has been ignored by the kernel since 5c6bd75d06db ("[PATCH] dm: prevent
removal if open") (v2.6.18 / 2006). Even for older kernels, not setting
this flag has only a minor, performance-related effect (skipping one call
to bdget_disk()). Don't use this dead API any more.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/devmapper.c       | 15 ---------------
 libmultipath/devmapper.c | 36 ------------------------------------
 multipathd/dmevents.c    |  2 --
 multipathd/waiter.c      |  2 --
 tests/dmevents.c         | 13 -------------
 5 files changed, 68 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index f12762c..bf07838 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -35,8 +35,6 @@ int dm_prereq(char * str, uint32_t x, uint32_t y, uint32_t z)
 	if (!(dmt = dm_task_create(DM_DEVICE_LIST_VERSIONS)))
 		return 1;
 
-	dm_task_no_open_count(dmt);
-
 	if (!dm_task_run(dmt))
 		goto out;
 
@@ -78,7 +76,6 @@ int dm_simplecmd(int task, const char *name, int no_flush, __DM_API_COOKIE_UNUSE
 	if (!dm_task_set_name(dmt, name))
 		goto out;
 
-	dm_task_no_open_count(dmt);
 	dm_task_skip_lockfs(dmt);
 
 	if (no_flush)
@@ -175,8 +172,6 @@ int dm_addmap(int task, const char *name, const char *target,
 	if (!dm_task_set_gid(dmt, gid))
 		goto addout;
 
-	dm_task_no_open_count(dmt);
-
 #ifdef LIBDM_API_COOKIE
 	if (!udev_sync)
 		udev_flags = DM_UDEV_DISABLE_LIBRARY_FALLBACK;
@@ -212,8 +207,6 @@ static int dm_map_present(char *str, char **uuid)
 	if (!dm_task_set_name(dmt, str))
 		goto out;
 
-	dm_task_no_open_count(dmt);
-
 	if (!dm_task_run(dmt))
 		goto out;
 
@@ -247,7 +240,6 @@ static int dm_rename (const char *old, const char *new)
 
 	if (!dm_task_set_name(dmt, old) ||
 	    !dm_task_set_newname(dmt, new) ||
-	    !dm_task_no_open_count(dmt) ||
 	    !dm_task_set_cookie(dmt, &cookie, udev_flags))
 		goto out;
 
@@ -291,7 +283,6 @@ dm_mapname(int major, int minor)
 	if (!(dmt = dm_task_create(DM_DEVICE_INFO)))
 		return NULL;
 
-	dm_task_no_open_count(dmt);
 	dm_task_set_major(dmt, major);
 	dm_task_set_minor(dmt, minor);
 
@@ -352,7 +343,6 @@ dm_mapuuid(const char *mapname)
 
 	if (!dm_task_set_name(dmt, mapname))
 		goto out;
-	dm_task_no_open_count(dmt);
 
 	if (!dm_task_run(dmt))
 		goto out;
@@ -407,7 +397,6 @@ dm_get_map(const char *mapname, char * outparams)
 
 	if (!dm_task_set_name(dmt, mapname))
 		goto out;
-	dm_task_no_open_count(dmt);
 
 	if (!dm_task_run(dmt))
 		goto out;
@@ -474,8 +463,6 @@ dm_type(const char * name, char * type)
 	if (!dm_task_set_name(dmt, name))
 		goto out;
 
-	dm_task_no_open_count(dmt);
-
 	if (!dm_task_run(dmt))
 		goto out;
 
@@ -545,8 +532,6 @@ do_foreach_partmaps (const char * mapname, const char *uuid,
 	if (!(dmt = dm_task_create(DM_DEVICE_LIST)))
 		return 1;
 
-	dm_task_no_open_count(dmt);
-
 	if (!dm_task_run(dmt))
 		goto out;
 
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index baa1ead..8996c1d 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -217,8 +217,6 @@ static int dm_tgt_version (unsigned int *version, char *str)
 	if (!(dmt = dm_task_create(DM_DEVICE_LIST_VERSIONS)))
 		return 1;
 
-	dm_task_no_open_count(dmt);
-
 	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(2, DM_DEVICE_LIST_VERSIONS, dmt);
 		condlog(0, "Cannot communicate with kernel DM");
@@ -398,7 +396,6 @@ dm_simplecmd (int task, const char *name, int flags, uint16_t udev_flags) {
 	if (!dm_task_set_name (dmt, name))
 		goto out;
 
-	dm_task_no_open_count(dmt);
 	dm_task_skip_lockfs(dmt);	/* for DM_DEVICE_RESUME */
 #ifdef LIBDM_API_FLUSH
 	if (flags & DMFL_NO_FLUSH)
@@ -495,8 +492,6 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
 		task == DM_DEVICE_RELOAD ? "reload" : "addmap", mpp->size,
 		target, params);
 
-	dm_task_no_open_count(dmt);
-
 	if (task == DM_DEVICE_CREATE &&
 	    !dm_task_set_cookie(dmt, &cookie, udev_flags))
 		goto freeout;
@@ -627,8 +622,6 @@ dm_get_info(const char *name, struct dm_info *info)
 	if (!dm_task_set_name(dmt, name))
 		goto out;
 
-	dm_task_no_open_count(dmt);
-
 	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_INFO, dmt);
 		goto out;
@@ -667,8 +660,6 @@ int dm_get_map(const char *name, unsigned long long *size, char **outparams)
 	if (!dm_task_set_name(dmt, name))
 		goto out;
 
-	dm_task_no_open_count(dmt);
-
 	errno = 0;
 	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_TABLE, dmt);
@@ -787,8 +778,6 @@ int dm_get_status(const char *name, char **outstatus)
 	if (!dm_task_set_name(dmt, name))
 		goto out;
 
-	dm_task_no_open_count(dmt);
-
 	errno = 0;
 	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_STATUS, dmt);
@@ -845,8 +834,6 @@ int dm_type(const char *name, char *type)
 	if (!dm_task_set_name(dmt, name))
 		goto out;
 
-	dm_task_no_open_count(dmt);
-
 	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_TABLE, dmt);
 		goto out;
@@ -889,8 +876,6 @@ int dm_is_mpath(const char *name)
 	if (!dm_task_set_name(dmt, name))
 		goto out_task;
 
-	dm_task_no_open_count(dmt);
-
 	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_TABLE, dmt);
 		goto out_task;
@@ -950,8 +935,6 @@ dm_map_present_by_uuid(const char *uuid)
 	if (!(dmt = libmp_dm_task_create(DM_DEVICE_INFO)))
 		goto out;
 
-	dm_task_no_open_count(dmt);
-
 	if (!dm_task_set_uuid(dmt, prefixed_uuid))
 		goto out_task;
 
@@ -1158,8 +1141,6 @@ int dm_flush_maps (int retries)
 	if (!(dmt = libmp_dm_task_create (DM_DEVICE_LIST)))
 		return r;
 
-	dm_task_no_open_count(dmt);
-
 	if (!libmp_dm_task_run (dmt)) {
 		dm_log_error(3, DM_DEVICE_LIST, dmt);
 		goto out;
@@ -1205,8 +1186,6 @@ dm_message(const char * mapname, char * message)
 	if (!dm_task_set_message(dmt, message))
 		goto out;
 
-	dm_task_no_open_count(dmt);
-
 	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(2, DM_DEVICE_TARGET_MSG, dmt);
 		goto out;
@@ -1341,8 +1320,6 @@ dm_get_maps (vector mp)
 	if (!(dmt = libmp_dm_task_create(DM_DEVICE_LIST)))
 		return 1;
 
-	dm_task_no_open_count(dmt);
-
 	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_LIST, dmt);
 		goto out;
@@ -1419,7 +1396,6 @@ dm_mapname(int major, int minor)
 	    !dm_task_set_minor(dmt, minor))
 		goto bad;
 
-	dm_task_no_open_count(dmt);
 	r = libmp_dm_task_run(dmt);
 	if (!r) {
 		dm_log_error(2, DM_DEVICE_INFO, dmt);
@@ -1455,8 +1431,6 @@ do_foreach_partmaps (const char * mapname,
 	if (!(dmt = libmp_dm_task_create(DM_DEVICE_LIST)))
 		return 1;
 
-	dm_task_no_open_count(dmt);
-
 	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_LIST, dmt);
 		goto out;
@@ -1665,8 +1639,6 @@ dm_rename (const char * old, char * new, char *delim, int skip_kpartx)
 	if (!dm_task_set_newname(dmt, new))
 		goto out;
 
-	dm_task_no_open_count(dmt);
-
 	if (!dm_task_set_cookie(dmt, &cookie, udev_flags))
 		goto out;
 	r = libmp_dm_task_run(dmt);
@@ -1713,8 +1685,6 @@ int dm_reassign_table(const char *name, char *old, char *new)
 	if (!dm_task_set_name(dmt, name))
 		goto out;
 
-	dm_task_no_open_count(dmt);
-
 	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_TABLE, dmt);
 		goto out;
@@ -1756,8 +1726,6 @@ int dm_reassign_table(const char *name, char *old, char *new)
 	} while (next);
 
 	if (modified) {
-		dm_task_no_open_count(reload_dmt);
-
 		if (!libmp_dm_task_run(reload_dmt)) {
 			dm_log_error(3, DM_DEVICE_RELOAD, reload_dmt);
 			condlog(3, "%s: failed to reassign targets", name);
@@ -1803,8 +1771,6 @@ int dm_reassign(const char *mapname)
 	if (!dm_task_set_name(dmt, mapname))
 		goto out;
 
-	dm_task_no_open_count(dmt);
-
 	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_DEPS, dmt);
 		goto out;
@@ -1861,8 +1827,6 @@ int dm_setgeometry(struct multipath *mpp)
 	if (!dm_task_set_name(dmt, mpp->alias))
 		goto out;
 
-	dm_task_no_open_count(dmt);
-
 	/* What a sick interface ... */
 	snprintf(heads, 4, "%u", pp->geom.heads);
 	snprintf(sectors, 4, "%u", pp->geom.sectors);
diff --git a/multipathd/dmevents.c b/multipathd/dmevents.c
index 5657000..3fbdc55 100644
--- a/multipathd/dmevents.c
+++ b/multipathd/dmevents.c
@@ -154,8 +154,6 @@ static int dm_get_events(void)
 	if (!(dmt = libmp_dm_task_create(DM_DEVICE_LIST)))
 		return -1;
 
-	dm_task_no_open_count(dmt);
-
 	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_LIST, dmt);
 		goto fail;
diff --git a/multipathd/waiter.c b/multipathd/waiter.c
index d1f344b..1dd93c5 100644
--- a/multipathd/waiter.c
+++ b/multipathd/waiter.c
@@ -108,8 +108,6 @@ static int waiteventloop (struct event_thread *waiter)
 		return 1;
 	}
 
-	dm_task_no_open_count(waiter->dmt);
-
 	/* wait */
 	sigemptyset(&set);
 	sigaddset(&set, SIGUSR2);
diff --git a/tests/dmevents.c b/tests/dmevents.c
index 668e6d2..2f98173 100644
--- a/tests/dmevents.c
+++ b/tests/dmevents.c
@@ -267,15 +267,6 @@ struct dm_task *__wrap_libmp_dm_task_create(int task)
 	return mock_type(struct dm_task *);
 }
 
-int __real_dm_task_no_open_count(struct dm_task *dmt);
-int __wrap_dm_task_no_open_count(struct dm_task *dmt)
-{
-	if (!setup_done)
-		return __real_dm_task_no_open_count(dmt);
-	assert_ptr_equal((struct test_data *)dmt, &data);
-	return mock_type(int);
-}
-
 int __real_dm_task_run(struct dm_task *dmt);
 int __wrap_dm_task_run(struct dm_task *dmt)
 {
@@ -554,7 +545,6 @@ static void test_get_events_bad1(void **state)
 		skip();
 
 	will_return(__wrap_libmp_dm_task_create, &data);
-	will_return(__wrap_dm_task_no_open_count, 1);
 	will_return(__wrap_dm_task_run, 0);
 	assert_int_equal(dm_get_events(), -1);
 }
@@ -567,7 +557,6 @@ static void test_get_events_bad2(void **state)
 		skip();
 
 	will_return(__wrap_libmp_dm_task_create, &data);
-	will_return(__wrap_dm_task_no_open_count, 1);
 	will_return(__wrap_dm_task_run, 1);
 	will_return(__wrap_dm_task_get_names, 0);
 	assert_int_equal(dm_get_events(), -1);
@@ -582,7 +571,6 @@ static void test_get_events_good0(void **state)
 
 	assert_int_equal(add_dm_device_event("foo", 1, 5), 0);
 	will_return(__wrap_libmp_dm_task_create, &data);
-	will_return(__wrap_dm_task_no_open_count, 1);
 	will_return(__wrap_dm_task_run, 1);
 	will_return(__wrap_dm_task_get_names, 1);
 	assert_int_equal(dm_get_events(), 0);
@@ -617,7 +605,6 @@ static void test_get_events_good1(void **state)
 	assert_int_equal(add_dm_device_event("foo", 1, 6), 0);
 	assert_int_equal(remove_dm_device_event("xyzzy"), 0);
 	will_return(__wrap_libmp_dm_task_create, &data);
-	will_return(__wrap_dm_task_no_open_count, 1);
 	will_return(__wrap_dm_task_run, 1);
 	will_return(__wrap_dm_task_get_names, 1);
 	assert_int_equal(dm_get_events(), 0);
-- 
2.45.2

