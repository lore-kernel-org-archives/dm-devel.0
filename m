Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2640C433DF
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:44:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4E6512084C
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:44:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E6512084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-dv39RzKnPh-bcNNf8FQg4Q-1; Fri, 16 Oct 2020 06:44:12 -0400
X-MC-Unique: dv39RzKnPh-bcNNf8FQg4Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CCB1D18A0757;
	Fri, 16 Oct 2020 10:44:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AE9315C1BD;
	Fri, 16 Oct 2020 10:44:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 84F1B58118;
	Fri, 16 Oct 2020 10:44:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GAhr5A020166 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 06:43:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8199316C2DA; Fri, 16 Oct 2020 10:43:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7BD0A16C2DD
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4CDC4101A568
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:53 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-160-F1o6Sr3QN52PIg16jyYK1Q-1;
	Fri, 16 Oct 2020 06:43:49 -0400
X-MC-Unique: F1o6Sr3QN52PIg16jyYK1Q-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id B277DAF45;
	Fri, 16 Oct 2020 10:43:47 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 16 Oct 2020 12:43:19 +0200
Message-Id: <20201016104329.8337-12-mwilck@suse.com>
In-Reply-To: <20201016104329.8337-1-mwilck@suse.com>
References: <20201016104329.8337-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09GAhr5A020166
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 11/21] libmultipath: protect racy libdevmapper
	calls with a mutex
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

dm_udev_wait() and dm_task_run() may access global / static state
in libdevmapper. They need to be protected by a lock in in our
multithreaded library.

The modified call sequence requires fixing the dmevents test:
devmapper.c must be added to dmevents-test_OBJDEPS to catch calls
to dm_task_run(). Also, the call to dmevent_poll_supported() in
setup() will cause init_versions() to be called, which requires
bypassing the wrappers in the test setup phase.

Cc: lixiaokeng@huawei.com
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c          | 73 +++++++++++++++++++------------
 libmultipath/devmapper.h          |  2 +
 libmultipath/libmultipath.version |  6 +++
 libmultipath/util.c               |  5 +++
 libmultipath/util.h               |  1 +
 multipathd/dmevents.c             |  2 +-
 multipathd/waiter.c               |  2 +-
 tests/Makefile                    |  1 +
 tests/dmevents.c                  | 12 +++++
 9 files changed, 75 insertions(+), 29 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 08aa09f..2e3ae8a 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -42,6 +42,7 @@ static unsigned int dm_mpath_target_version[3] = { INVALID_VERSION, };
 
 static pthread_once_t dm_initialized = PTHREAD_ONCE_INIT;
 static pthread_once_t versions_initialized = PTHREAD_ONCE_INIT;
+static pthread_mutex_t libmp_dm_lock = PTHREAD_MUTEX_INITIALIZER;
 
 static int dm_conf_verbosity;
 
@@ -59,16 +60,34 @@ static inline int dm_task_set_cookie(struct dm_task *dmt, uint32_t *c, int a)
 	return 1;
 }
 
-void dm_udev_wait(unsigned int c)
+static void libmp_udev_wait(unsigned int c)
 {
 }
 
-void dm_udev_set_sync_support(int c)
+static void dm_udev_set_sync_support(int c)
 {
 }
-
+#else
+static void libmp_udev_wait(unsigned int c)
+{
+	pthread_mutex_lock(&libmp_dm_lock);
+	pthread_cleanup_push(cleanup_mutex, &libmp_dm_lock);
+	dm_udev_wait(c);
+	pthread_cleanup_pop(1);
+}
 #endif
 
+int libmp_dm_task_run(struct dm_task *dmt)
+{
+	int r;
+
+	pthread_mutex_lock(&libmp_dm_lock);
+	pthread_cleanup_push(cleanup_mutex, &libmp_dm_lock);
+	r = dm_task_run(dmt);
+	pthread_cleanup_pop(1);
+	return r;
+}
+
 __attribute__((format(printf, 4, 5))) static void
 dm_write_log (int level, const char *file, int line, const char *f, ...)
 {
@@ -196,7 +215,7 @@ static int dm_tgt_version (unsigned int *version, char *str)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run(dmt)) {
+	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(2, DM_DEVICE_LIST_VERSIONS, dmt);
 		condlog(0, "Can not communicate with kernel DM");
 		goto out;
@@ -380,12 +399,12 @@ dm_simplecmd (int task, const char *name, int no_flush, int need_sync, uint16_t
 				DM_UDEV_DISABLE_LIBRARY_FALLBACK | udev_flags))
 		goto out;
 
-	r = dm_task_run (dmt);
+	r = libmp_dm_task_run (dmt);
 	if (!r)
 		dm_log_error(2, task, dmt);
 
 	if (udev_wait_flag)
-			dm_udev_wait(cookie);
+			libmp_udev_wait(cookie);
 out:
 	dm_task_destroy (dmt);
 	return r;
@@ -472,12 +491,12 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
 	    !dm_task_set_cookie(dmt, &cookie, udev_flags))
 		goto freeout;
 
-	r = dm_task_run (dmt);
+	r = libmp_dm_task_run (dmt);
 	if (!r)
 		dm_log_error(2, task, dmt);
 
 	if (task == DM_DEVICE_CREATE)
-			dm_udev_wait(cookie);
+			libmp_udev_wait(cookie);
 freeout:
 	if (prefixed_uuid)
 		FREE(prefixed_uuid);
@@ -587,7 +606,7 @@ do_get_info(const char *name, struct dm_info *info)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run(dmt)) {
+	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_INFO, dmt);
 		goto out;
 	}
@@ -628,7 +647,7 @@ int dm_get_map(const char *name, unsigned long long *size, char *outparams)
 	dm_task_no_open_count(dmt);
 
 	errno = 0;
-	if (!dm_task_run(dmt)) {
+	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_TABLE, dmt);
 		if (dm_task_get_errno(dmt) == ENXIO)
 			r = DMP_NOT_FOUND;
@@ -670,7 +689,7 @@ dm_get_prefixed_uuid(const char *name, char *uuid, int uuid_len)
 	if (!dm_task_set_name (dmt, name))
 		goto uuidout;
 
-	if (!dm_task_run(dmt)) {
+	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_INFO, dmt);
 		goto uuidout;
 	}
@@ -741,7 +760,7 @@ int dm_get_status(const char *name, char *outstatus)
 	dm_task_no_open_count(dmt);
 
 	errno = 0;
-	if (!dm_task_run(dmt)) {
+	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_STATUS, dmt);
 		if (dm_task_get_errno(dmt) == ENXIO)
 			r = DMP_NOT_FOUND;
@@ -794,7 +813,7 @@ int dm_type(const char *name, char *type)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run(dmt)) {
+	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_TABLE, dmt);
 		goto out;
 	}
@@ -838,7 +857,7 @@ int dm_is_mpath(const char *name)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run(dmt)) {
+	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_TABLE, dmt);
 		goto out_task;
 	}
@@ -902,7 +921,7 @@ dm_map_present_by_uuid(const char *uuid)
 	if (!dm_task_set_uuid(dmt, prefixed_uuid))
 		goto out_task;
 
-	if (!dm_task_run(dmt)) {
+	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_INFO, dmt);
 		goto out_task;
 	}
@@ -948,7 +967,7 @@ dm_get_opencount (const char * mapname)
 	if (!dm_task_set_name(dmt, mapname))
 		goto out;
 
-	if (!dm_task_run(dmt)) {
+	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_INFO, dmt);
 		goto out;
 	}
@@ -1108,7 +1127,7 @@ int dm_flush_maps (int need_suspend, int retries)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run (dmt)) {
+	if (!libmp_dm_task_run (dmt)) {
 		dm_log_error(3, DM_DEVICE_LIST, dmt);
 		goto out;
 	}
@@ -1154,7 +1173,7 @@ dm_message(const char * mapname, char * message)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run(dmt)) {
+	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(2, DM_DEVICE_TARGET_MSG, dmt);
 		goto out;
 	}
@@ -1274,7 +1293,7 @@ dm_get_maps (vector mp)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run(dmt)) {
+	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_LIST, dmt);
 		goto out;
 	}
@@ -1359,7 +1378,7 @@ dm_mapname(int major, int minor)
 	 * daemon uev_trigger -> uev_add_map
 	 */
 	while (--loop) {
-		r = dm_task_run(dmt);
+		r = libmp_dm_task_run(dmt);
 
 		if (r)
 			break;
@@ -1404,7 +1423,7 @@ do_foreach_partmaps (const char * mapname,
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run(dmt)) {
+	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_LIST, dmt);
 		goto out;
 	}
@@ -1639,11 +1658,11 @@ dm_rename (const char * old, char * new, char *delim, int skip_kpartx)
 
 	if (!dm_task_set_cookie(dmt, &cookie, udev_flags))
 		goto out;
-	r = dm_task_run(dmt);
+	r = libmp_dm_task_run(dmt);
 	if (!r)
 		dm_log_error(2, DM_DEVICE_RENAME, dmt);
 
-	dm_udev_wait(cookie);
+	libmp_udev_wait(cookie);
 
 out:
 	dm_task_destroy(dmt);
@@ -1685,7 +1704,7 @@ int dm_reassign_table(const char *name, char *old, char *new)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run(dmt)) {
+	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_TABLE, dmt);
 		goto out;
 	}
@@ -1718,7 +1737,7 @@ int dm_reassign_table(const char *name, char *old, char *new)
 	if (modified) {
 		dm_task_no_open_count(reload_dmt);
 
-		if (!dm_task_run(reload_dmt)) {
+		if (!libmp_dm_task_run(reload_dmt)) {
 			dm_log_error(3, DM_DEVICE_RELOAD, reload_dmt);
 			condlog(3, "%s: failed to reassign targets", name);
 			goto out_reload;
@@ -1765,7 +1784,7 @@ int dm_reassign(const char *mapname)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run(dmt)) {
+	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_DEPS, dmt);
 		goto out;
 	}
@@ -1833,7 +1852,7 @@ int dm_setgeometry(struct multipath *mpp)
 		goto out;
 	}
 
-	r = dm_task_run(dmt);
+	r = libmp_dm_task_run(dmt);
 	if (!r)
 		dm_log_error(3, DM_DEVICE_SET_GEOMETRY, dmt);
 out:
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index c8b37e1..158057e 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -89,6 +89,8 @@ enum {
 	MULTIPATH_VERSION
 };
 int libmp_get_version(int which, unsigned int version[3]);
+struct dm_task;
+int libmp_dm_task_run(struct dm_task *dmt);
 
 #define dm_log_error(lvl, cmd, dmt)			      \
 	condlog(lvl, "%s: libdm task=%d error: %s", __func__, \
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index ab5bb0a..97acdbb 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -245,3 +245,9 @@ global:
 local:
 	*;
 };
+
+LIBMULTIPATH_2.1.0 {
+global:
+	libmp_dm_task_run;
+	cleanup_mutex;
+} LIBMULTIPATH_2.0.0;
diff --git a/libmultipath/util.c b/libmultipath/util.c
index 66cd721..41da6ce 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -409,6 +409,11 @@ void cleanup_free_ptr(void *arg)
 		free(*p);
 }
 
+void cleanup_mutex(void *arg)
+{
+	pthread_mutex_unlock(arg);
+}
+
 struct bitfield *alloc_bitfield(unsigned int maxbit)
 {
 	unsigned int n;
diff --git a/libmultipath/util.h b/libmultipath/util.h
index c1ae878..b8481af 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -49,6 +49,7 @@ int should_exit(void);
 
 void close_fd(void *arg);
 void cleanup_free_ptr(void *arg);
+void cleanup_mutex(void *arg);
 
 struct scandir_result {
 	struct dirent **di;
diff --git a/multipathd/dmevents.c b/multipathd/dmevents.c
index fc97c8a..b561cbf 100644
--- a/multipathd/dmevents.c
+++ b/multipathd/dmevents.c
@@ -156,7 +156,7 @@ static int dm_get_events(void)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run(dmt)) {
+	if (!libmp_dm_task_run(dmt)) {
 		dm_log_error(3, DM_DEVICE_LIST, dmt);
 		goto fail;
 	}
diff --git a/multipathd/waiter.c b/multipathd/waiter.c
index 16fbdc8..620bfa7 100644
--- a/multipathd/waiter.c
+++ b/multipathd/waiter.c
@@ -118,7 +118,7 @@ static int waiteventloop (struct event_thread *waiter)
 	pthread_sigmask(SIG_UNBLOCK, &set, &oldset);
 
 	pthread_testcancel();
-	r = dm_task_run(waiter->dmt);
+	r = libmp_dm_task_run(waiter->dmt);
 	if (!r)
 		dm_log_error(2, DM_DEVICE_WAITEVENT, waiter->dmt);
 	pthread_testcancel();
diff --git a/tests/Makefile b/tests/Makefile
index 7a73869..73ff0f5 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -39,6 +39,7 @@ endif
 #    linker input file).
 # XYZ-test_LIBDEPS: Additional libs to link for this test
 
+dmevents-test_OBJDEPS = ../libmultipath/devmapper.o
 dmevents-test_LIBDEPS = -lpthread -ldevmapper -lurcu
 hwtable-test_TESTDEPS := test-lib.o
 hwtable-test_OBJDEPS := ../libmultipath/discovery.o ../libmultipath/blacklist.o \
diff --git a/tests/dmevents.c b/tests/dmevents.c
index bee117a..b7c5122 100644
--- a/tests/dmevents.c
+++ b/tests/dmevents.c
@@ -179,6 +179,8 @@ struct dm_names *build_dm_names(void)
 	return names;
 }
 
+static bool setup_done;
+
 static int setup(void **state)
 {
 	if (dmevent_poll_supported()) {
@@ -186,6 +188,7 @@ static int setup(void **state)
 		*state = &data;
 	} else
 		*state = NULL;
+	setup_done = true;
 	return 0;
 }
 
@@ -262,14 +265,20 @@ struct dm_task *__wrap_libmp_dm_task_create(int task)
 	return mock_type(struct dm_task *);
 }
 
+int __real_dm_task_no_open_count(struct dm_task *dmt);
 int __wrap_dm_task_no_open_count(struct dm_task *dmt)
 {
+	if (!setup_done)
+		return __real_dm_task_no_open_count(dmt);
 	assert_ptr_equal((struct test_data *)dmt, &data);
 	return mock_type(int);
 }
 
+int __real_dm_task_run(struct dm_task *dmt);
 int __wrap_dm_task_run(struct dm_task *dmt)
 {
+	if (!setup_done)
+		return __real_dm_task_run(dmt);
 	assert_ptr_equal((struct test_data *)dmt, &data);
 	return mock_type(int);
 }
@@ -291,8 +300,11 @@ struct dm_names * __wrap_dm_task_get_names(struct dm_task *dmt)
 	return data.names;
 }
 
+void __real_dm_task_destroy(struct dm_task *dmt);
 void __wrap_dm_task_destroy(struct dm_task *dmt)
 {
+	if (!setup_done)
+		return __real_dm_task_destroy(dmt);
 	assert_ptr_equal((struct test_data *)dmt, &data);
 
 	if (data.names) {
-- 
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

