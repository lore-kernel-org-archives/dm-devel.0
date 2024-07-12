Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39A1175564
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804547; cv=none; b=XgBUQzLPDqqUBsuzo2jt7yUmNgoXZpe+CTI3n5iwniVmnJnKM+SRbmxwq8nJzwhoTvmi6KTID72A8G7f6SldJRckDvsZLHe6AKO1KVwhBnmhdhjYguJJcTFISNw6vxgi2hoaM7MmQ6MhJ5yOxxa+Hh6rL/i45NBrIEkW+KvtjNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804547; c=relaxed/simple;
	bh=kqoHTm86gv/Ca7roOU+R0hbIeb0+3e5T6+ngMIqwAFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u++TWK/OCGtZCIeZ7uRA3/LVGFcgBFZK5ILxaJvBoDk6WaWsxbB9LBxWbpPc2VVcJDIBU/tkDnoBKSPHrcqyvQGomJIRkvG2R1poDKQX8kvMD2lp19yoHyEiJhYJtJIpqEsICcNciSnkGLkRb1bxhYivEFObfs80RgsvWbzjVSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eIIDAxN/; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eIIDAxN/"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a77e392f59fso300502166b.1
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804542; x=1721409342; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AtjsweYUUStq+L7WMe0F66Ap1LoZbG1z5BU3NOgCkgM=;
        b=eIIDAxN/J1Qgi3aqhbzCqTRQc4vFtqw/wIMAi2/PCgDKKYNxI0NUZ/tsntdXJ9c/y/
         NlJUEelvSmzAVaRCZXvW5W75d6cH9ccZvJf7QzOCmsH6qU9l87IWRqBdBHRAWQwGzGjk
         OTA0P/VsxnObz/AJXIFuYl9GA4OVSicToOcP14h3sIsU+QU7ondLqBJ+dd1GL48ZbEi+
         c0bKW/rSSy3jWVvGP4iLOSvx+Cb2UC0tYQbnUGG6UjazUvMBty17JeRHyBwNwD7QzAzA
         F0qr3DxVcBwZTk2NDtBz9gBvYTsdPbhRuWLVeAUXHi0qkfPDs3ZF4bc19KOpCrkBuNDk
         3cjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804542; x=1721409342;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AtjsweYUUStq+L7WMe0F66Ap1LoZbG1z5BU3NOgCkgM=;
        b=KyMhmIIXfkx9JygKidKiCoPr25rl6JSF1YDHHiNHy9zWVVm4H+nsiDTpmLzCJME5jJ
         QtVqO4MRVkFE63Wpq6rnc/+S5qxtVkGNPirdVBC1f+unj00avvQTJyU8CU1BFuFboiWD
         cKdzb74iovmwMkQ9IcCKBnlCwgXo3ktRz9hgTbFUxe7xVJWLqRqQ2URR1vuZR9XN9h7o
         5kWkxjICHRqhYFLM78N9zUTDrEi+uTM2ltHOL5P6cv5uwEuC6n8iOWfM5OpBzqauCoEh
         LPYisoJyolOzwF249bwlJ+J8MlaJ6aurUaigrL1DezKrcaEjM2TE0sH++uK2f3g28rhX
         b3rw==
X-Gm-Message-State: AOJu0YysuzKqqdwuPseJelANYxjhRlkIwuHXo/5A8JbI1EOV7+Loo9Bz
	QxNbHE/VrW0kM6xiqT2BS9++lgHMU5GJBSqacfTZ45GsHmTh9IXJ5AXFf+ukVEoPclolv2cmiY8
	6
X-Google-Smtp-Source: AGHT+IHlSPClHOJxxLZGvv3pg8Qj0r+u/7jQZToigUkugCpFZdoj0vDGjCR3XQNZ0mHwXJCi5TH9AA==
X-Received: by 2002:a17:906:dfc3:b0:a75:360a:6cb0 with SMTP id a640c23a62f3a-a780b6b3644mr757314066b.29.1720804542231;
        Fri, 12 Jul 2024 10:15:42 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a86ed05sm362569566b.188.2024.07.12.10.15.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:15:42 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 12/49] multipath-tools: don't call dm_task_no_open_count()
Date: Fri, 12 Jul 2024 19:14:20 +0200
Message-ID: <20240712171458.77611-13-mwilck@suse.com>
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

dm_task_no_open_count() only sets DM_SKIP_BDGET_FLAG in the dm task,
which has been ignored by the kernel since 5c6bd75d06db ("[PATCH] dm: prevent
removal if open") (v2.6.18 / 2006). Even for older kernels, not setting
this flag has only a minor, performance-related effect (skipping one call
to bdget_disk()). Don't use this dead API any more.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
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

