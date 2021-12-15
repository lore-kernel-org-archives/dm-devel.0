Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31B3FC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 15 Dec 2021 17:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1639590270;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5JyeGrThbZ8tHnYl+WFC5JTr+Kvv/WmCL/0cgZ2iodY=;
	b=YzhJUSM5a2dB5CMFeEv6WQsHgfZ1eYhk7edZeSXRFv6OyJlI+CkGKhyCKbGBKglQ8NrRFl
	DF0Kl3yUd2vwcYcqFXFsRWL7ItOQDxOBrFBYbY/5IZS0Z+qj4dlmJrJcKUFnfdx0rGpyMz
	05sw4bmfPaDIdByi1JKBQHBvpwSFhXA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-284-RPF7AK-3PtK0YwVLFJMP7Q-1; Wed, 15 Dec 2021 12:44:27 -0500
X-MC-Unique: RPF7AK-3PtK0YwVLFJMP7Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7637802E39;
	Wed, 15 Dec 2021 17:44:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CA96679C59;
	Wed, 15 Dec 2021 17:44:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A5AB84CA9B;
	Wed, 15 Dec 2021 17:44:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BFHiI0W018396 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 15 Dec 2021 12:44:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 884DF78DA0; Wed, 15 Dec 2021 17:44:18 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BA3B78C26;
	Wed, 15 Dec 2021 17:44:15 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1BFHiDD7011335; 
	Wed, 15 Dec 2021 11:44:13 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1BFHiCwI011334;
	Wed, 15 Dec 2021 11:44:12 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 15 Dec 2021 11:44:08 -0600
Message-Id: <1639590250-11293-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1639590250-11293-1-git-send-email-bmarzins@redhat.com>
References: <1639590250-11293-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 1/3] libmultipath: embed dm_info in multipath
	structure
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Instead of having multipath allocate its dm_info structure, it should
just embed it to save on the extra allocations. This also lets us have
only one function that all callers use to fill a dm_info structure.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c          |  7 +++--
 libmultipath/devmapper.c          | 51 +++++++++++--------------------
 libmultipath/devmapper.h          |  3 +-
 libmultipath/libmultipath.version |  1 +
 libmultipath/print.c              | 12 +++++---
 libmultipath/structs.c            | 10 ++----
 libmultipath/structs.h            |  3 +-
 multipathd/main.c                 |  2 +-
 8 files changed, 37 insertions(+), 52 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 67459769..ec38f325 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -450,12 +450,12 @@ get_udev_for_mpp(const struct multipath *mpp)
 	dev_t devnum;
 	struct udev_device *udd;
 
-	if (!mpp || !mpp->dmi) {
+	if (!mpp || !has_dm_info(mpp)) {
 		condlog(1, "%s called with empty mpp", __func__);
 		return NULL;
 	}
 
-	devnum = makedev(mpp->dmi->major, mpp->dmi->minor);
+	devnum = makedev(mpp->dmi.major, mpp->dmi.minor);
 	udd = udev_device_new_from_devnum(udev, 'b', devnum);
 	if (!udd) {
 		condlog(1, "failed to get udev device for %s", mpp->alias);
@@ -574,7 +574,8 @@ sysfs_set_max_sectors_kb(struct multipath *mpp, int is_reload)
 		return 0;
 	max_sectors_kb = mpp->max_sectors_kb;
 	if (is_reload) {
-		if (!mpp->dmi && dm_get_info(mpp->alias, &mpp->dmi) != 0) {
+		if (!has_dm_info(mpp) &&
+		    dm_get_info(mpp->alias, &mpp->dmi) != 0) {
 			condlog(1, "failed to get dm info for %s", mpp->alias);
 			return 1;
 		}
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index c0eb3351..36038150 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -611,12 +611,21 @@ int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
 	return 0;
 }
 
-static int
-do_get_info(const char *name, struct dm_info *info)
+bool
+has_dm_info(const struct multipath *mpp)
+{
+	return (mpp && mpp->dmi.exists != 0);
+}
+
+int
+dm_get_info(const char *name, struct dm_info *info)
 {
 	int r = -1;
 	struct dm_task *dmt;
 
+	if (!name || !info)
+		return r;
+
 	if (!(dmt = libmp_dm_task_create(DM_DEVICE_INFO)))
 		return r;
 
@@ -646,7 +655,7 @@ int dm_map_present(const char * str)
 {
 	struct dm_info info;
 
-	return (do_get_info(str, &info) == 0);
+	return (dm_get_info(str, &info) == 0);
 }
 
 int dm_get_map(const char *name, unsigned long long *size, char **outparams)
@@ -969,7 +978,7 @@ dm_dev_t (const char * mapname, char * dev_t, int len)
 {
 	struct dm_info info;
 
-	if (do_get_info(mapname, &info) != 0)
+	if (dm_get_info(mapname, &info) != 0)
 		return 1;
 
 	if (snprintf(dev_t, len, "%i:%i", info.major, info.minor) > len)
@@ -1013,7 +1022,7 @@ dm_get_major_minor(const char *name, int *major, int *minor)
 {
 	struct dm_info info;
 
-	if (do_get_info(name, &info) != 0)
+	if (dm_get_info(name, &info) != 0)
 		return -1;
 
 	*major = info.major;
@@ -1367,7 +1376,7 @@ dm_geteventnr (const char *name)
 {
 	struct dm_info info;
 
-	if (do_get_info(name, &info) != 0)
+	if (dm_get_info(name, &info) != 0)
 		return -1;
 
 	return info.event_nr;
@@ -1378,7 +1387,7 @@ dm_is_suspended(const char *name)
 {
 	struct dm_info info;
 
-	if (do_get_info(name, &info) != 0)
+	if (dm_get_info(name, &info) != 0)
 		return -1;
 
 	return info.suspended;
@@ -1542,7 +1551,7 @@ dm_get_deferred_remove (const char * mapname)
 {
 	struct dm_info info;
 
-	if (do_get_info(mapname, &info) != 0)
+	if (dm_get_info(mapname, &info) != 0)
 		return -1;
 
 	return info.deferred_remove;
@@ -1583,32 +1592,6 @@ dm_cancel_deferred_remove (struct multipath *mpp __attribute__((unused)))
 
 #endif
 
-static struct dm_info *
-alloc_dminfo (void)
-{
-	return calloc(1, sizeof(struct dm_info));
-}
-
-int
-dm_get_info (const char * mapname, struct dm_info ** dmi)
-{
-	if (!mapname)
-		return 1;
-
-	if (!*dmi)
-		*dmi = alloc_dminfo();
-
-	if (!*dmi)
-		return 1;
-
-	if (do_get_info(mapname, *dmi) != 0) {
-		free(*dmi);
-		*dmi = NULL;
-		return 1;
-	}
-	return 0;
-}
-
 struct rename_data {
 	const char *old;
 	char *new;
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 45a676de..703f3bf8 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -70,7 +70,8 @@ char * dm_mapname(int major, int minor);
 int dm_remove_partmaps (const char * mapname, int need_sync,
 			int deferred_remove);
 int dm_get_uuid(const char *name, char *uuid, int uuid_len);
-int dm_get_info (const char * mapname, struct dm_info ** dmi);
+bool has_dm_info(const struct multipath *mpp);
+int dm_get_info (const char * mapname, struct dm_info *dmi);
 int dm_rename (const char * old, char * new, char * delim, int skip_kpartx);
 int dm_reassign(const char * mapname);
 int dm_reassign_table(const char *name, char *old, char *new);
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 9c7ffa71..7cdce9fc 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -121,6 +121,7 @@ global:
 	get_used_hwes;
 	get_vpd_sgio;
 	group_by_prio;
+	has_dm_info;
 	init_checkers;
 	init_config;
 	init_foreign;
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 221b515f..c93fffd4 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -171,8 +171,8 @@ snprint_name (struct strbuf *buff, const struct multipath * mpp)
 static int
 snprint_sysfs (struct strbuf *buff, const struct multipath * mpp)
 {
-	if (mpp->dmi)
-		return print_strbuf(buff, "dm-%i", mpp->dmi->minor);
+	if (has_dm_info(mpp))
+		return print_strbuf(buff, "dm-%i", mpp->dmi.minor);
 	else
 		return append_strbuf_str(buff, "undef");
 }
@@ -180,9 +180,9 @@ snprint_sysfs (struct strbuf *buff, const struct multipath * mpp)
 static int
 snprint_ro (struct strbuf *buff, const struct multipath * mpp)
 {
-	if (!mpp->dmi)
+	if (!has_dm_info(mpp))
 		return append_strbuf_str(buff, "undef");
-	if (mpp->dmi->read_only)
+	if (mpp->dmi.read_only)
 		return append_strbuf_str(buff, "ro");
 	else
 		return append_strbuf_str(buff, "rw");
@@ -256,7 +256,9 @@ snprint_nb_paths (struct strbuf *buff, const struct multipath * mpp)
 static int
 snprint_dm_map_state (struct strbuf *buff, const struct multipath * mpp)
 {
-	if (mpp->dmi && mpp->dmi->suspended)
+	if (!has_dm_info(mpp))
+		return append_strbuf_str(buff, "undef");
+	else if (mpp->dmi.suspended)
 		return append_strbuf_str(buff, "suspend");
 	else
 		return append_strbuf_str(buff, "active");
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index d1b8aa33..17f4baf6 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -18,6 +18,7 @@
 #include "prio.h"
 #include "prioritizers/alua_spc3.h"
 #include "dm-generic.h"
+#include "devmapper.h"
 
 struct adapter_group *
 alloc_adaptergroup(void)
@@ -278,11 +279,6 @@ free_multipath (struct multipath * mpp, enum free_path_mode free_paths)
 		mpp->alias = NULL;
 	}
 
-	if (mpp->dmi) {
-		free(mpp->dmi);
-		mpp->dmi = NULL;
-	}
-
 	if (!free_paths && mpp->pg) {
 		struct pathgroup *pgp;
 		struct path *pp;
@@ -407,10 +403,10 @@ find_mp_by_minor (const struct _vector *mpvec, unsigned int minor)
 		return NULL;
 
 	vector_foreach_slot (mpvec, mpp, i) {
-		if (!mpp->dmi)
+		if (!has_dm_info(mpp))
 			continue;
 
-		if (mpp->dmi->minor == minor)
+		if (mpp->dmi.minor == minor)
 			return mpp;
 	}
 	return NULL;
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index c0f8929c..7f621941 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -4,6 +4,7 @@
 #include <sys/types.h>
 #include <inttypes.h>
 #include <stdbool.h>
+#include <libdevmapper.h>
 
 #include "prio.h"
 #include "byteorder.h"
@@ -386,7 +387,7 @@ struct multipath {
 	unsigned long long size;
 	vector paths;
 	vector pg;
-	struct dm_info * dmi;
+	struct dm_info dmi;
 
 	/* configlet pointers */
 	char * alias;
diff --git a/multipathd/main.c b/multipathd/main.c
index 7a57a798..fe40f6e3 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -908,7 +908,7 @@ ev_remove_map (char * devname, char * alias, int minor, struct vectors * vecs)
 	}
 	if (strcmp(mpp->alias, alias)) {
 		condlog(2, "%s: minor number mismatch (map %d, event %d)",
-			mpp->alias, mpp->dmi->minor, minor);
+			mpp->alias, mpp->dmi.minor, minor);
 		return 1;
 	}
 	return flush_map(mpp, vecs, 0);
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

