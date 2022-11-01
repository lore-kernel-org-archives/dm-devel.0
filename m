Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 094B1C433FE
	for <dm-devel@archiver.kernel.org>; Tue,  1 Nov 2022 20:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667336108;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sfp02hoVNGYVhbjppxAYd4wdDnraLknA34oMXM9MlsY=;
	b=g/JChytiNnYVGI0RPBW+nDYB8xxYo7H1OjY2TDnl7/ZLQ9AjEgZpmiUFQEkgjns8C7BIEu
	p7WAGPTwrgjMTe8emlM2VGuME8DWyekTmCOyd9CbBq1LvIKEp25HCAyjhfFuAyOxLWI56J
	mV9vCmAmBGPUXuLIsfMKf63VVO/smNk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-iyzpDnbzON-1kIxdmhQadQ-1; Tue, 01 Nov 2022 16:55:05 -0400
X-MC-Unique: iyzpDnbzON-1kIxdmhQadQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0CF88811E84;
	Tue,  1 Nov 2022 20:55:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EF9352166B2D;
	Tue,  1 Nov 2022 20:55:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9CEF719465B3;
	Tue,  1 Nov 2022 20:55:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F21051946594
 for <dm-devel@listman.corp.redhat.com>; Tue,  1 Nov 2022 20:55:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E43D74EA49; Tue,  1 Nov 2022 20:55:00 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D2D2442220;
 Tue,  1 Nov 2022 20:55:00 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 2A1Kt0jx007903; Tue, 1 Nov 2022 16:55:00 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 2A1Kt0j5007899; Tue, 1 Nov 2022 16:55:00 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Tue, 1 Nov 2022 16:55:00 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Message-ID: <alpine.LRH.2.21.2211011654340.7766@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH 4/4] dm: support global feature string and
 per-target feature strings
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch enables support for feature strings that may be returned from
the kernel to userspace and may be used instead of version numbers to
determine if the kernel supports a particular feature.

So far, all the strings are empty. When new features will be introduced,
they will be added to the device mapper feature string or target feature
string.

We add a new ioctl DM_GET_FEATURE_STRING that returns device-mapper
feature string in it's data area. If the buffer has insufficient size, the
flag DM_BUFFER_FULL_FLAG is set.

Per-target feature strings are returned after a target name in the
existing ioctls DM_LIST_VERSIONS and DM_GET_TARGET_VERSION. The current
libdevmapper code does not user the bytes after the name's terminating 0,
so this change is backward-compatible.

This patch increases minor version to 48 to notify userspace that feature
strings are supported.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-ioctl.c         |   36 ++++++++++++++++++++++++++++++++----
 include/linux/device-mapper.h |    1 +
 include/uapi/linux/dm-ioctl.h |    6 ++++--
 3 files changed, 37 insertions(+), 6 deletions(-)

Index: linux-2.6/include/linux/device-mapper.h
===================================================================
--- linux-2.6.orig/include/linux/device-mapper.h	2022-11-01 19:36:06.000000000 +0100
+++ linux-2.6/include/linux/device-mapper.h	2022-11-01 19:36:06.000000000 +0100
@@ -188,6 +188,7 @@ struct target_type {
 	const char *name;
 	struct module *module;
 	unsigned version[3];
+	const char *feature_string;
 	dm_ctr_fn ctr;
 	dm_dtr_fn dtr;
 	dm_map_fn map;
Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c	2022-11-01 19:36:06.000000000 +0100
+++ linux-2.6/drivers/md/dm-ioctl.c	2022-11-01 19:36:06.000000000 +0100
@@ -26,6 +26,8 @@
 #define DM_MSG_PREFIX "ioctl"
 #define DM_DRIVER_EMAIL "dm-devel@redhat.com"
 
+static const char dm_feature_string[] = "";
+
 struct dm_file {
 	/*
 	 * poll will wait until the global event number is greater than
@@ -653,19 +655,23 @@ static int list_devices(struct file *fil
 static void list_version_get_needed(struct target_type *tt, void *needed_param)
 {
     size_t *needed = needed_param;
+    const char *feature_string = tt->feature_string ? : "";
 
     *needed += sizeof(struct dm_target_versions);
     *needed += strlen(tt->name) + 1;
+    *needed += strlen(feature_string) + 1;
     *needed += ALIGN_MASK;
 }
 
 static void list_version_get_info(struct target_type *tt, void *param)
 {
     struct vers_iter *info = param;
+    const char *feature_string = tt->feature_string ? : "";
+    char *ptr;
 
     /* Check space - it might have changed since the first iteration */
-    if ((char *)info->vers + sizeof(tt->version) + strlen(tt->name) + 1 >
-	info->end) {
+    if ((char *)info->vers + sizeof(tt->version) + strlen(tt->name) + 1 +
+	strlen(feature_string) + 1 > info->end) {
 
 	info->flags = DM_BUFFER_FULL_FLAG;
 	return;
@@ -674,14 +680,18 @@ static void list_version_get_info(struct
     if (info->old_vers)
 	info->old_vers->next = (uint32_t) ((void *)info->vers -
 					   (void *)info->old_vers);
+    info->old_vers = info->vers;
+
     info->vers->version[0] = tt->version[0];
     info->vers->version[1] = tt->version[1];
     info->vers->version[2] = tt->version[2];
     info->vers->next = 0;
     strcpy(info->vers->name, tt->name);
+    ptr = (char *)(info->vers + 1) + strlen(tt->name) + 1;
+    strcpy(ptr, feature_string);
+    ptr += strlen(feature_string) + 1;
 
-    info->old_vers = info->vers;
-    info->vers = align_ptr((void *)(info->vers + 1) + strlen(tt->name) + 1);
+    info->vers = align_ptr(ptr);
 }
 
 static int __list_versions(struct dm_ioctl *param, size_t param_size, const char *name)
@@ -747,6 +757,23 @@ static int get_target_version(struct fil
 	return __list_versions(param, param_size, param->name);
 }
 
+static int get_feature_string(struct file *filp, struct dm_ioctl *param, size_t param_size)
+{
+	size_t len;
+	size_t needed = strlen(dm_feature_string) + 1;
+	char *res;
+
+	res = get_result_buffer(param, param_size, &len);
+	if (len < needed) {
+		param->flags |= DM_BUFFER_FULL_FLAG;
+		return 0;
+	}
+
+	param->data_size = param->data_start + needed;
+	strcpy(res, dm_feature_string);
+	return 0;
+}
+
 static int check_name(const char *name)
 {
 	if (strchr(name, '/')) {
@@ -1790,6 +1817,7 @@ static ioctl_fn lookup_ioctl(unsigned in
 		{DM_DEV_SET_GEOMETRY_CMD, 0, dev_set_geometry},
 		{DM_DEV_ARM_POLL_CMD, IOCTL_FLAGS_NO_PARAMS, dev_arm_poll},
 		{DM_GET_TARGET_VERSION_CMD, 0, get_target_version},
+		{DM_GET_FEATURE_STRING_CMD, 0, get_feature_string},
 	};
 
 	if (unlikely(cmd >= ARRAY_SIZE(_ioctls)))
Index: linux-2.6/include/uapi/linux/dm-ioctl.h
===================================================================
--- linux-2.6.orig/include/uapi/linux/dm-ioctl.h	2022-11-01 19:36:06.000000000 +0100
+++ linux-2.6/include/uapi/linux/dm-ioctl.h	2022-11-01 19:50:58.000000000 +0100
@@ -258,6 +258,7 @@ enum {
 	DM_DEV_SET_GEOMETRY_CMD,
 	DM_DEV_ARM_POLL_CMD,
 	DM_GET_TARGET_VERSION_CMD,
+	DM_GET_FEATURE_STRING_CMD,
 };
 
 #define DM_IOCTL 0xfd
@@ -281,14 +282,15 @@ enum {
 
 #define DM_LIST_VERSIONS _IOWR(DM_IOCTL, DM_LIST_VERSIONS_CMD, struct dm_ioctl)
 #define DM_GET_TARGET_VERSION _IOWR(DM_IOCTL, DM_GET_TARGET_VERSION_CMD, struct dm_ioctl)
+#define DM_GET_FEATURE_STRING _IOWR(DM_IOCTL, DM_GET_FEATURE_STRING_CMD, struct dm_ioctl)
 
 #define DM_TARGET_MSG	 _IOWR(DM_IOCTL, DM_TARGET_MSG_CMD, struct dm_ioctl)
 #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
 
 #define DM_VERSION_MAJOR	4
-#define DM_VERSION_MINOR	47
+#define DM_VERSION_MINOR	48
 #define DM_VERSION_PATCHLEVEL	0
-#define DM_VERSION_EXTRA	"-ioctl (2022-07-28)"
+#define DM_VERSION_EXTRA	"-ioctl (2022-11-01)"
 
 /* Status bits */
 #define DM_READONLY_FLAG	(1 << 0) /* In/Out */
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

