Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8A25ECAAD3
	for <dm-devel@archiver.kernel.org>; Mon, 19 Sep 2022 09:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663580147;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OqUkuJpM09EcFZcHVk6wjPpWVV+sIKQLM6UbBVhkUbQ=;
	b=hNVk1MfOv50vGZXeYFrf8bJ8HSsYGQxpmwvdTpC+KN/OEClI9aY0G/sPELeCuDibbxXnXT
	wDsWMAtnY8N5H+h/jA5DNYYiHjHaJ8YWeQydTsrfTExf21LKkGfpg94CS9qF0duFP5+IDg
	piRcz/tdUKbzoNYst9+lYplMpVbhB7s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-50X_CYZkPjm16c_deoBAZg-1; Mon, 19 Sep 2022 05:35:44 -0400
X-MC-Unique: 50X_CYZkPjm16c_deoBAZg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0FFB285A5B6;
	Mon, 19 Sep 2022 09:35:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5B2C340C6EC3;
	Mon, 19 Sep 2022 09:35:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2B96E1946594;
	Mon, 19 Sep 2022 09:35:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A7FF31946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 19 Sep 2022 09:35:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 98F572087443; Mon, 19 Sep 2022 09:35:40 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 850FD2087440;
 Mon, 19 Sep 2022 09:35:40 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 28J9ZeBF001615; Mon, 19 Sep 2022 05:35:40 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 28J9ZeMX001611; Mon, 19 Sep 2022 05:35:40 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Mon, 19 Sep 2022 05:35:40 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, David Teigland <teigland@redhat.com>
Message-ID: <alpine.LRH.2.02.2209190533540.1511@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH] dm: introduce feature bitmaps
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This commit introduces feature bitmaps for dm targets and for dm core. The
dm-core bitmap is returned in the ioctl field "feature_bitmap" of the
ioctl DM_VERSION_CMD. The per-target bitmap is returned after the target
name in the ioctls DM_LIST_VERSIONS_CMD or DM_GET_TARGET_VERSION.

The bitmaps are empty so far.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-ioctl.c         |   25 ++++++++++++++++---------
 include/linux/device-mapper.h |    1 +
 include/uapi/linux/dm-ioctl.h |    9 ++++++---
 3 files changed, 23 insertions(+), 12 deletions(-)

Index: linux-2.6/include/linux/device-mapper.h
===================================================================
--- linux-2.6.orig/include/linux/device-mapper.h
+++ linux-2.6/include/linux/device-mapper.h
@@ -188,6 +188,7 @@ struct target_type {
 	const char *name;
 	struct module *module;
 	unsigned version[3];
+	uint64_t feature_bitmap;
 	dm_ctr_fn ctr;
 	dm_dtr_fn dtr;
 	dm_map_fn map;
Index: linux-2.6/include/uapi/linux/dm-ioctl.h
===================================================================
--- linux-2.6.orig/include/uapi/linux/dm-ioctl.h
+++ linux-2.6/include/uapi/linux/dm-ioctl.h
@@ -138,7 +138,10 @@ struct dm_ioctl {
 	__u32 event_nr;      	/* in/out */
 	__s32 error;		/* out */
 
-	__u64 dev;		/* in/out */
+	union {
+		__u64 dev;	/* in/out */
+		__u64 feature_bitmap;	/* out */
+	};
 
 	char name[DM_NAME_LEN];	/* device name */
 	char uuid[DM_UUID_LEN];	/* unique identifier for
@@ -286,9 +289,9 @@ enum {
 #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
 
 #define DM_VERSION_MAJOR	4
-#define DM_VERSION_MINOR	48
+#define DM_VERSION_MINOR	49
 #define DM_VERSION_PATCHLEVEL	0
-#define DM_VERSION_EXTRA	"-ioctl (2022-08-24)"
+#define DM_VERSION_EXTRA	"-ioctl (2022-09-16)"
 
 /* Status bits */
 #define DM_READONLY_FLAG	(1 << 0) /* In/Out */
Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c
+++ linux-2.6/drivers/md/dm-ioctl.c
@@ -26,6 +26,8 @@
 #define DM_MSG_PREFIX "ioctl"
 #define DM_DRIVER_EMAIL "dm-devel@redhat.com"
 
+static const __u64 feature_bitmap = 0;
+
 struct dm_file {
 	/*
 	 * poll will wait until the global event number is greater than
@@ -650,6 +652,12 @@ static int list_devices(struct file *fil
 	return 0;
 }
 
+static int version(struct file *filp, struct dm_ioctl *param, size_t param_size)
+{
+	param->feature_bitmap = feature_bitmap;
+	return 0;
+}
+
 static void list_version_get_needed(struct target_type *tt, void *needed_param)
 {
     size_t *needed = needed_param;
@@ -657,11 +665,13 @@ static void list_version_get_needed(stru
     *needed += sizeof(struct dm_target_versions);
     *needed += strlen(tt->name);
     *needed += ALIGN_MASK;
+    *needed += sizeof(__u64);
 }
 
 static void list_version_get_info(struct target_type *tt, void *param)
 {
     struct vers_iter *info = param;
+    __u64 *feature_bitmap;
 
     /* Check space - it might have changed since the first iteration */
     if ((char *)info->vers + sizeof(tt->version) + strlen(tt->name) + 1 >
@@ -680,8 +690,10 @@ static void list_version_get_info(struct
     info->vers->next = 0;
     strcpy(info->vers->name, tt->name);
 
+    feature_bitmap = align_ptr(((void *)(info->vers + 1)) + strlen(tt->name) + 1);
+    *feature_bitmap = tt->feature_bitmap;
     info->old_vers = info->vers;
-    info->vers = align_ptr(((void *) ++info->vers) + strlen(tt->name) + 1);
+    info->vers = (void *)(feature_bitmap + 1);
 }
 
 static int __list_versions(struct dm_ioctl *param, size_t param_size, const char *name)
@@ -1789,7 +1801,7 @@ static ioctl_fn lookup_ioctl(unsigned in
 		int flags;
 		ioctl_fn fn;
 	} _ioctls[] = {
-		{DM_VERSION_CMD, 0, NULL}, /* version is dealt with elsewhere */
+		{DM_VERSION_CMD, IOCTL_FLAGS_NO_PARAMS, version},
 		{DM_REMOVE_ALL_CMD, IOCTL_FLAGS_NO_PARAMS | IOCTL_FLAGS_ISSUE_GLOBAL_EVENT, remove_all},
 		{DM_LIST_DEVICES_CMD, 0, list_devices},
 
@@ -1944,7 +1956,8 @@ static int validate_params(uint cmd, str
 		param->error = 0;
 
 	/* Ignores parameters */
-	if (cmd == DM_REMOVE_ALL_CMD ||
+	if (cmd == DM_VERSION_CMD ||
+	    cmd == DM_REMOVE_ALL_CMD ||
 	    cmd == DM_LIST_DEVICES_CMD ||
 	    cmd == DM_LIST_VERSIONS_CMD)
 		return 0;
@@ -1994,12 +2007,6 @@ static int ctl_ioctl(struct file *file,
 	if (r)
 		return r;
 
-	/*
-	 * Nothing more to do for the version command.
-	 */
-	if (cmd == DM_VERSION_CMD)
-		return 0;
-
 	fn = lookup_ioctl(cmd, &ioctl_flags);
 	if (!fn) {
 		DMERR("dm_ctl_ioctl: unknown command 0x%x", command);
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

