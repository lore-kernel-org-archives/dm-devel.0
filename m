Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B47DC4332F
	for <dm-devel@archiver.kernel.org>; Wed,  9 Nov 2022 21:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668028233;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6FzEKiQbm+fj7D2YwRMVlsro6l60B0OAmjPwWH72bCk=;
	b=haC3LxdjM4Cp/ORGalNDDNkvMmSMTZZ2l528oTELQ38FPfNRJDBQEYjUcJriWCYNoh2kIP
	WV76HK9bd0PPqJsCC9DJDmQCMoJOWv8akDtQkKahIJ9FswTdMHsZK8sZgLVYg/15GS5HK+
	o0cfc20/mxlH0LrlMU3WAH7b+jaSwqg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-45-qVR3NvoDPTKMjXZAlNpHPg-1; Wed, 09 Nov 2022 16:10:30 -0500
X-MC-Unique: qVR3NvoDPTKMjXZAlNpHPg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1DADE381458F;
	Wed,  9 Nov 2022 21:10:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2AB2D40C6E14;
	Wed,  9 Nov 2022 21:10:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 00D9D1946594;
	Wed,  9 Nov 2022 21:10:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1405F1946588
 for <dm-devel@listman.corp.redhat.com>; Wed,  9 Nov 2022 21:10:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B42F040C6E15; Wed,  9 Nov 2022 21:10:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AC5BC40C6E14
 for <dm-devel@redhat.com>; Wed,  9 Nov 2022 21:10:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12185800186
 for <dm-devel@redhat.com>; Wed,  9 Nov 2022 21:10:24 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-670-W6uZaiubP7KhnAmhxDEJ_w-1; Wed,
 09 Nov 2022 16:10:22 -0500
X-MC-Unique: W6uZaiubP7KhnAmhxDEJ_w-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id AB1BA33747;
 Wed,  9 Nov 2022 21:10:20 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6F5791331F;
 Wed,  9 Nov 2022 21:10:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id O07HGTwXbGNzfQAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 09 Nov 2022 21:10:20 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  9 Nov 2022 22:10:07 +0100
Message-Id: <20221109211007.389-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [RFC PATCH] libmultipath: is_path_valid(): check if
 device is in use
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: fbui@suse.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

To check whether we will be able to add a given device can be part
of a multipath map, we have two tests in check_path_valid():
released_to_systemd() and the O_EXCL test. The former isn't helpful
if "multipath -u" is called for the first time for a given device,
and the latter is only used in the "find_multipaths smart" case, because
actively opening the device with O_EXCL, even for a very short time, is prone
to races with other processes.

It turns out that this may cause issues in some scenarios. We saw problems in
once case where "find_multipaths greedy" was used with a single
non-multipahted root disk and a very large number of multipath LUNs.
The root disk would first be classified as multipath device. multipathd
would try to create a map, fail (because the disk was mounted) and
trigger another uevent. But because of the very large number of multipath
devices, this event was queued up behind thousands of other events, and
the root device timed out eventually.

While a simple workaround for the given problem would be proper blacklisting
or using a different find_multipaths mode, I am proposing a different
solution here. An additional test is added in is_path_valid() which
checks whether the given device is currently in use by 1. sysfs holders,
2. mounts (from /proc/self/mountinfo) or 3. swaps (from /proc/swaps). 2.
and 3. are similar to systemd's device detection after switching root.
This must not only be done for the device itself, but also for all its
partitions. For mountinfo and swaps, libmount is utilized.

With this patch, "multipath -u" will make devices with mounted or otherwise
used partitions available to systemd early, without waiting for multipathd
to fail setting up the map and re-triggering an uevent. This should avoid
the issue described above even without blacklisting. The downside of it
is a longer runtime of "multipath -u" for almost all devices, in particular
for real multipath devices. The runtime required for the new checks was in the
order of 0.1ms-1ms in my tests. Moreover, there is a certain risk that devices may
wrongly classified as non-multipath because of transient mounts or holders
created by other processes.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathutil/libmpathutil.version |   6 +
 libmpathutil/util.c               |  12 ++
 libmpathutil/util.h               |   2 +
 libmultipath/Makefile             |   2 +-
 libmultipath/alias.c              |  11 --
 libmultipath/valid.c              | 253 ++++++++++++++++++++++++++++++
 tests/Makefile                    |   2 +-
 tests/valid.c                     |  46 ++++++
 8 files changed, 321 insertions(+), 13 deletions(-)

diff --git a/libmpathutil/libmpathutil.version b/libmpathutil/libmpathutil.version
index 95b169d..139b9ed 100644
--- a/libmpathutil/libmpathutil.version
+++ b/libmpathutil/libmpathutil.version
@@ -125,3 +125,9 @@ LIBMPATHUTIL_1.1 {
 global:
 	cleanup_fd_ptr;
 } LIBMPATHUTIL_1.0;
+
+LIBMPATHUTIL_1.2 {
+global:
+	cleanup_vector_free;
+	cleanup_fclose;
+} LIBMPATHUTIL_1.0;
diff --git a/libmpathutil/util.c b/libmpathutil/util.c
index 6692ac2..55261a6 100644
--- a/libmpathutil/util.c
+++ b/libmpathutil/util.c
@@ -412,6 +412,18 @@ void cleanup_mutex(void *arg)
 	pthread_mutex_unlock(arg);
 }
 
+void cleanup_vector_free(void *arg)
+{
+	if  (arg)
+		vector_free((vector)arg);
+}
+
+void cleanup_fclose(void *p)
+{
+	if (p)
+		fclose(p);
+}
+
 struct bitfield *alloc_bitfield(unsigned int maxbit)
 {
 	unsigned int n;
diff --git a/libmpathutil/util.h b/libmpathutil/util.h
index 7e34c56..80baaa8 100644
--- a/libmpathutil/util.h
+++ b/libmpathutil/util.h
@@ -49,6 +49,8 @@ int should_exit(void);
 void cleanup_fd_ptr(void *arg);
 void cleanup_free_ptr(void *arg);
 void cleanup_mutex(void *arg);
+void cleanup_vector_free(void *arg);
+void cleanup_fclose(void *p);
 
 struct scandir_result {
 	struct dirent **di;
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 3b60a52..e2c8da9 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -11,7 +11,7 @@ VERSION_SCRIPT := libmultipath.version
 CPPFLAGS += -I$(mpathutildir) -I$(mpathcmddir) -I$(nvmedir) -D_GNU_SOURCE
 CFLAGS += $(LIB_CFLAGS)
 
-LIBDEPS += -lpthread -ldl -ldevmapper -ludev -L$(mpathutildir) -lmpathutil -L$(mpathcmddir) -lmpathcmd -lurcu -laio
+LIBDEPS += -lpthread -ldl -ldevmapper -ludev -L$(mpathutildir) -lmpathutil -L$(mpathcmddir) -lmpathcmd -lmount -lurcu -laio
 
 ifdef SYSTEMD
 	CPPFLAGS += -DUSE_SYSTEMD=$(SYSTEMD)
diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index 0520122..c0139a2 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -667,11 +667,6 @@ static int _check_bindings_file(const struct config *conf, FILE *file,
 	return rc;
 }
 
-static void cleanup_fclose(void *p)
-{
-	fclose(p);
-}
-
 static int alias_compar(const void *p1, const void *p2)
 {
 	const char *alias1 = (*(struct mpentry * const *)p1)->alias;
@@ -684,12 +679,6 @@ static int alias_compar(const void *p1, const void *p2)
 		return alias1 ? -1 : alias2 ? 1 : 0;
 }
 
-static void cleanup_vector_free(void *arg)
-{
-	if  (arg)
-		vector_free((vector)arg);
-}
-
 /*
  * check_alias_settings(): test for inconsistent alias configuration
  *
diff --git a/libmultipath/valid.c b/libmultipath/valid.c
index a6aa921..f8d81b0 100644
--- a/libmultipath/valid.c
+++ b/libmultipath/valid.c
@@ -17,6 +17,8 @@
 #include <stddef.h>
 #include <errno.h>
 #include <libudev.h>
+#include <dirent.h>
+#include <libmount/libmount.h>
 
 #include "vector.h"
 #include "config.h"
@@ -30,12 +32,256 @@
 #include "mpath_cmd.h"
 #include "valid.h"
 
+static int subdir_filter(const struct dirent *ent)
+{
+	unsigned int j;
+	static char const *const skip[] = {
+		".",
+		"..",
+		"holders",
+		"integrity",
+		"mq",
+		"power",
+		"queue",
+		"slaves",
+		"trace",
+	};
+
+	if (ent->d_type != DT_DIR)
+		return 0;
+
+	for (j = 0; j < ARRAY_SIZE(skip); j++)
+		if (!strcmp(skip[j], ent->d_name))
+			return 0;
+	return 1;
+}
+
+static int read_partitions(const char *syspath, vector parts)
+{
+	struct scandir_result sr = { .n = 0 };
+	char path[PATH_MAX], *last;
+	char *prop;
+	int i;
+
+	strlcpy(path, syspath, sizeof(path));
+	sr.n = scandir(path, &sr.di, subdir_filter, NULL);
+	if (sr.n == -1)
+		return -errno;
+
+	pthread_cleanup_push_cast(free_scandir_result, &sr);
+
+	/* parts[0] is the whole disk */
+	if (vector_alloc_slot(parts) &&
+	    (prop = strdup(strrchr(path, '/') + 1)) != NULL)
+		vector_set_slot(parts, prop);
+
+	last = path + strlen(path);
+	for (i = 0; i < sr.n; i++) {
+		struct stat st;
+
+		/* only add dirs that have the "partition" attribute */
+		snprintf(last, sizeof(path) - (last - path), "/%s/partition",
+			 sr.di[i]->d_name);
+
+		if (stat(path, &st) == 0) {
+			prop = strdup(sr.di[i]->d_name);
+
+			if (vector_alloc_slot(parts) && prop != NULL)
+				vector_set_slot(parts, prop);
+		}
+	}
+
+	pthread_cleanup_pop(1);
+	return 0;
+}
+
+static int no_dots(const struct dirent *ent)
+{
+	const char *name = ent->d_name;
+
+	if (name[0] == '.' &&
+	    (name[1] == '\0' || (name[1] == '.' && name[2] == '\0')))
+		return 0;
+	return 1;
+}
+
+static int check_holders(const char *syspath)
+{
+	struct scandir_result __attribute__((cleanup(free_scandir_result)))
+		sr = { .n = 0 };
+
+	sr.n = scandir(syspath, &sr.di, no_dots, NULL);
+	if (sr.n > 0)
+		condlog(4, "%s: found holders under %s", __func__, syspath);
+	return sr.n;
+}
+
+static int check_all_holders(const struct _vector *parts)
+{
+	char syspath[PATH_MAX];
+	const char *sysname;
+	unsigned int j;
+
+	if (VECTOR_SIZE(parts) == 0)
+		return 0;
+
+	if (safe_sprintf(syspath, "/sys/class/block/%s/holders",
+			 (const char *)VECTOR_SLOT(parts, 0)))
+		return -EOVERFLOW;
+
+	if (check_holders(syspath) > 0)
+		return 1;
+
+	j = 1;
+	vector_foreach_slot_after(parts, sysname, j) {
+		if (safe_sprintf(syspath, "/sys/class/block/%s/%s/holders",
+				 (const char *)VECTOR_SLOT(parts, 0), sysname))
+			return -EOVERFLOW;
+		if (check_holders(syspath) > 0)
+			return 1;
+	}
+	return 0;
+}
+
+static void cleanup_table(void *arg)
+{
+	if (arg)
+		mnt_free_table((struct libmnt_table *)arg);
+}
+
+static void cleanup_cache(void *arg)
+{
+	if (arg)
+		mnt_unref_cache((struct libmnt_cache *)arg);
+}
+
+/*
+ * Passed a vector of partitions and a libmount table,
+ * check if any of the partitions in the vector is referenced in the table.
+ * Note that mnt_table_find_srcpath() also resolves mounts by symlinks.
+ */
+static int check_mnt_table(const struct _vector *parts,
+			   struct libmnt_table *tbl,
+			   const char *table_name)
+{
+	unsigned int i;
+	const char *sysname;
+	char devpath[PATH_MAX];
+
+	vector_foreach_slot(parts, sysname, i) {
+		if (!safe_sprintf(devpath, "/dev/%s", sysname) &&
+		    mnt_table_find_srcpath(tbl, devpath,
+					   MNT_ITER_FORWARD) != NULL) {
+			condlog(4, "%s: found %s in %s", __func__,
+				sysname, table_name);
+			return 1;
+		}
+	}
+	return 0;
+}
+
+static int check_mountinfo(const struct _vector *parts)
+{
+	static const char mountinfo[] = "/proc/self/mountinfo";
+	struct libmnt_table *tbl;
+	struct libmnt_cache *cache;
+	FILE *stream;
+	int used = 0, ret;
+
+	tbl = mnt_new_table();
+	if (!tbl )
+		return -errno;
+
+	pthread_cleanup_push(cleanup_table, tbl);
+	cache = mnt_new_cache();
+	if (cache) {
+		pthread_cleanup_push(cleanup_cache, cache);
+		if (mnt_table_set_cache(tbl, cache) == 0) {
+			stream = fopen(mountinfo, "r");
+			if (stream != NULL) {
+				pthread_cleanup_push(cleanup_fclose, stream);
+				ret = mnt_table_parse_stream(tbl, stream, mountinfo);
+				pthread_cleanup_pop(1);
+
+				if (ret == 0 &&
+				    (used = check_mnt_table(parts, tbl, "mountinfo")))
+					break;
+			}
+		}
+		pthread_cleanup_pop(1);
+	}
+	pthread_cleanup_pop(1);
+	return used;
+}
+
+static int check_swaps(const struct _vector *parts)
+{
+	struct libmnt_table *tbl;
+	struct libmnt_cache *cache;
+	int used = 0, ret;
+
+	tbl = mnt_new_table();
+	if (!tbl )
+		return -errno;
+
+	pthread_cleanup_push(cleanup_table, tbl);
+	cache = mnt_new_cache();
+	if (cache) {
+		pthread_cleanup_push(cleanup_cache, cache);
+		if (mnt_table_set_cache(tbl, cache) == 0) {
+			ret = mnt_table_parse_swaps(tbl, NULL);
+			if (ret == 0 &&
+			    (used = check_mnt_table(parts, tbl, "swaps")))
+				break;
+		}
+		pthread_cleanup_pop(1);
+	}
+	pthread_cleanup_pop(1);
+	return used;
+}
+
+/*
+ * Given a block device, check if the device itself or any of its
+ * partitions is in use
+ * - by sysfs holders (e.g. LVM)
+ * - mounted according to /proc/self/mountinfo
+ * - used as swap
+ */
+static int is_device_in_use(struct udev_device *udevice)
+{
+	const char *syspath;
+	vector parts;
+	int used = 0, ret;
+
+	syspath = udev_device_get_syspath(udevice);
+	if (!syspath)
+		return -ENOMEM;
+
+	parts = vector_alloc();
+	if (!parts)
+		return -ENOMEM;
+
+	pthread_cleanup_push_cast(free_strvec, parts);
+	if ((ret = read_partitions(syspath, parts)) == 0)
+		used =  check_all_holders(parts) > 0 ||
+			check_mountinfo(parts) > 0 ||
+			check_swaps(parts) > 0;
+	pthread_cleanup_pop(1);
+
+	if (ret < 0)
+		return ret;
+
+	condlog(3, "%s: %s is %sin use", __func__, syspath, used ? "" : "not ");
+	return used;
+}
+
 int
 is_path_valid(const char *name, struct config *conf, struct path *pp,
 	      bool check_multipathd)
 {
 	int r;
 	int fd;
+	const char *prop;
 
 	if (!pp || !name || !conf)
 		return PATH_IS_ERROR;
@@ -80,6 +326,10 @@ is_path_valid(const char *name, struct config *conf, struct path *pp,
 	if (!pp->udev)
 		return PATH_IS_ERROR;
 
+	prop = udev_device_get_property_value(pp->udev, "DEVTYPE");
+	if (prop == NULL || strcmp(prop, "disk"))
+		return PATH_IS_NOT_VALID;
+
 	r = pathinfo(pp, conf, DI_SYSFS | DI_WWID | DI_BLACKLIST);
 	if (r == PATHINFO_SKIPPED)
 		return PATH_IS_NOT_VALID;
@@ -96,6 +346,9 @@ is_path_valid(const char *name, struct config *conf, struct path *pp,
 		return PATH_IS_ERROR;
 	}
 
+	if (is_device_in_use(pp->udev) > 0)
+		return PATH_IS_NOT_VALID;
+
 	if (conf->find_multipaths == FIND_MULTIPATHS_GREEDY)
 		return PATH_IS_VALID;
 
diff --git a/tests/Makefile b/tests/Makefile
index 3a5b161..a0d3e1b 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -64,7 +64,7 @@ vpd-test_LIBDEPS := -ludev -lpthread -ldl
 alias-test_TESTDEPS := test-log.o
 alias-test_LIBDEPS := -lpthread -ldl
 valid-test_OBJDEPS := $(multipathdir)/valid.o $(multipathdir)/discovery.o
-valid-test_LIBDEPS := -ludev -lpthread -ldl
+valid-test_LIBDEPS := -lmount -ludev -lpthread -ldl
 devt-test_LIBDEPS := -ludev
 mpathvalid-test_LIBDEPS := -ludev -lpthread -ldl
 mpathvalid-test_OBJDEPS := $(mpathvaliddir)/mpath_valid.o
diff --git a/tests/valid.c b/tests/valid.c
index 398b771..9e7f719 100644
--- a/tests/valid.c
+++ b/tests/valid.c
@@ -83,6 +83,13 @@ struct udev_device *__wrap_udev_device_new_from_subsystem_sysname(struct udev *u
 	return NULL;
 }
 
+/* For devtype check */
+const char *__wrap_udev_device_get_property_value(struct udev_device *udev_device, const char *property)
+{
+	check_expected(property);
+	return mock_ptr_type(char *);
+}
+
 /* For the "hidden" check in pathinfo() */
 const char *__wrap_udev_device_get_sysattr_value(struct udev_device *udev_device,
 					 const char *sysattr)
@@ -97,6 +104,12 @@ int __wrap_add_foreign(struct udev_device *udev_device)
 	return mock_type(int);
 }
 
+/* For is_device_used() */
+const char *__wrap_udev_device_get_sysname(struct udev_device *udev_device)
+{
+	return mock_ptr_type(char *);
+}
+
 /* called from pathinfo() */
 int __wrap_filter_devnode(struct config *conf, const struct _vector *elist,
 			  const char *vendor, const char * product, const char *dev)
@@ -165,6 +178,11 @@ int __wrap_is_failed_wwid(const char *wwid)
 	return ret;
 }
 
+const char *__wrap_udev_device_get_syspath(struct udev_device *udevice)
+{
+	return mock_ptr_type(char *);
+}
+
 int __wrap_check_wwids_file(char *wwid, int write_wwid)
 {
 	bool passed = mock_type(bool);
@@ -225,6 +243,8 @@ static void setup_passing(char *name, char *wwid, unsigned int check_multipathd,
 	will_return(__wrap_udev_device_new_from_subsystem_sysname, true);
 	will_return(__wrap_udev_device_new_from_subsystem_sysname,
 		    name);
+	expect_string(__wrap_udev_device_get_property_value, property, "DEVTYPE");
+	will_return(__wrap_udev_device_get_property_value, "disk");
 	if (stage == STAGE_GET_UDEV_DEVICE)
 		return;
 	if  (stage == STAGE_PATHINFO_REAL) {
@@ -250,6 +270,8 @@ static void setup_passing(char *name, char *wwid, unsigned int check_multipathd,
 		return;
 	will_return(__wrap_is_failed_wwid, WWID_IS_NOT_FAILED);
 	will_return(__wrap_is_failed_wwid, wwid);
+	/* avoid real is_device_in_use() check */
+	will_return(__wrap_udev_device_get_syspath, NULL);
 	if (stage == STAGE_IS_FAILED)
 		return;
 	will_return(__wrap_check_wwids_file, false);
@@ -347,6 +369,30 @@ static void test_check_multipathd(void **state)
 	assert_int_equal(is_path_valid(name, &conf, &pp, true),
 			 PATH_IS_ERROR);
 	assert_string_equal(pp.dev, name);
+
+	/* test pass because connect succeeded. succeed getting udev. Wrong DEVTYPE  */
+	memset(&pp, 0, sizeof(pp));
+	setup_passing(name, NULL, CHECK_MPATHD_RUNNING, STAGE_CHECK_MULTIPATHD);
+	will_return(__wrap_udev_device_new_from_subsystem_sysname, true);
+	will_return(__wrap_udev_device_new_from_subsystem_sysname,
+		    name);
+	expect_string(__wrap_udev_device_get_property_value, property, "DEVTYPE");
+	will_return(__wrap_udev_device_get_property_value, "partition");
+	assert_int_equal(is_path_valid(name, &conf, &pp, true),
+			 PATH_IS_NOT_VALID);
+	assert_string_equal(pp.dev, name);
+
+	/* test pass because connect succeeded. succeed getting udev. Bad DEVTYPE  */
+	memset(&pp, 0, sizeof(pp));
+	setup_passing(name, NULL, CHECK_MPATHD_RUNNING, STAGE_CHECK_MULTIPATHD);
+	will_return(__wrap_udev_device_new_from_subsystem_sysname, true);
+	will_return(__wrap_udev_device_new_from_subsystem_sysname,
+		    name);
+	expect_string(__wrap_udev_device_get_property_value, property, "DEVTYPE");
+	will_return(__wrap_udev_device_get_property_value, NULL);
+	assert_int_equal(is_path_valid(name, &conf, &pp, true),
+			 PATH_IS_NOT_VALID);
+	assert_string_equal(pp.dev, name);
 }
 
 static void test_pathinfo(void **state)
-- 
2.38.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

