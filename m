Return-Path: <SRS0=PkBB=IC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E20FC433E0
	for <dm-devel@archiver.kernel.org>; Thu,  4 Mar 2021 17:14:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1C09164F5C
	for <dm-devel@archiver.kernel.org>; Thu,  4 Mar 2021 17:14:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C09164F5C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=veeam.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-95-VSCEwjEfO8KTX75MGVKQjQ-1; Thu, 04 Mar 2021 12:14:24 -0500
X-MC-Unique: VSCEwjEfO8KTX75MGVKQjQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F0FB801814;
	Thu,  4 Mar 2021 17:14:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 30EDE60C66;
	Thu,  4 Mar 2021 17:14:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BFEF55002E;
	Thu,  4 Mar 2021 17:14:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 124HDx7Y031388 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Mar 2021 12:13:59 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 01C131423BEE; Thu,  4 Mar 2021 17:13:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F168D1422B9F
	for <dm-devel@redhat.com>; Thu,  4 Mar 2021 17:13:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB04E802BF5
	for <dm-devel@redhat.com>; Thu,  4 Mar 2021 17:13:58 +0000 (UTC)
Received: from mx4.veeam.com (mx4.veeam.com [104.41.138.86]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-202-yS_bEfqfPYOOwvKLst1LnQ-1;
	Thu, 04 Mar 2021 12:13:54 -0500
X-MC-Unique: yS_bEfqfPYOOwvKLst1LnQ-1
Received: from mail.veeam.com (prgmbx01.amust.local [172.24.0.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx4.veeam.com (Postfix) with ESMTPS id 354FE114A94;
	Thu,  4 Mar 2021 20:13:52 +0300 (MSK)
Received: from prgdevlinuxpatch01.amust.local (172.24.14.5) by
	prgmbx01.amust.local (172.24.0.171) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.2.721.2; Thu, 4 Mar 2021 18:13:50 +0100
From: Sergei Shtepa <sergei.shtepa@veeam.com>
To: <snitzer@redhat.com>, <agk@redhat.com>, <hare@suse.de>,
	<dm-devel@redhat.com>, <linux-block@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Date: Thu, 4 Mar 2021 20:13:38 +0300
Message-ID: <1614878018-23278-2-git-send-email-sergei.shtepa@veeam.com>
In-Reply-To: <1614878018-23278-1-git-send-email-sergei.shtepa@veeam.com>
References: <1614878018-23278-1-git-send-email-sergei.shtepa@veeam.com>
MIME-Version: 1.0
X-Originating-IP: [172.24.14.5]
X-ClientProxiedBy: prgmbx02.amust.local (172.24.0.172) To prgmbx01.amust.local
	(172.24.0.171)
X-EsetResult: clean, is OK
X-EsetId: 37303A29D2A50B58637265
X-Veeam-MMEX: True
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: pavel.tide@veeam.com, sergei.shtepa@veeam.com
Subject: [dm-devel] [PATCH 1/1] dm: adds an IOCTL to work with device-filters
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The four simplest IOCTL's allow to create new filters, remove them
and pass control commands specific to each target.

Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>
---
 drivers/md/Makefile           |  2 +-
 drivers/md/dm-ioctl.c         | 22 ++++++++++++++++++++++
 drivers/md/flt-ctl.c          | 25 +++++++++++++++++++++++++
 drivers/md/flt-ctl.h          | 10 ++++++++++
 include/uapi/linux/dm-ioctl.h | 18 ++++++++++++++++--
 5 files changed, 74 insertions(+), 3 deletions(-)
 create mode 100644 drivers/md/flt-ctl.c
 create mode 100644 drivers/md/flt-ctl.h

diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index bd5b38bee82e..1b650950adc1 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -5,7 +5,7 @@
 
 dm-mod-y	+= dm.o dm-table.o dm-target.o dm-linear.o dm-stripe.o \
 		   dm-ioctl.o dm-io.o dm-kcopyd.o dm-sysfs.o dm-stats.o \
-		   dm-rq.o dm-interposer.o
+		   dm-rq.o dm-interposer.o flt-ctl.o
 dm-multipath-y	+= dm-path-selector.o dm-mpath.o
 dm-historical-service-time-y += dm-ps-historical-service-time.o
 dm-io-affinity-y += dm-ps-io-affinity.o
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 2bcb316144a1..f5f0c9377752 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -6,6 +6,7 @@
  */
 
 #include "dm-core.h"
+#include "flt-control.h"
 
 #include <linux/module.h>
 #include <linux/vmalloc.h>
@@ -1700,6 +1701,27 @@ static ioctl_fn lookup_ioctl(unsigned int cmd, int *ioctl_flags)
 		{DM_GET_TARGET_VERSION, 0, get_target_version},
 	};
 
+	static const struct {
+		int cmd;
+		int flags;
+		ioctl_fn fn;
+	} _flt_ioctls[] = {
+		{FLT_REMOVE_ALL_CMD, IOCTL_FLAGS_NO_PARAMS | IOCTL_FLAGS_ISSUE_GLOBAL_EVENT, filter_remove_all},
+		{FLT_CREATE_CMD, IOCTL_FLAGS_NO_PARAMS | IOCTL_FLAGS_ISSUE_GLOBAL_EVENT, filter_create},
+		{FLT_REMOVE_CMD, IOCTL_FLAGS_NO_PARAMS | IOCTL_FLAGS_ISSUE_GLOBAL_EVENT, filter_remove},
+		{FLT_CONTROL_CMD, 0, filter_control},
+	};
+
+	if (cmd >= DM_FILTER_CMD) {
+		cmd -= DM_FILTER_CMD;
+
+		if (unlikely(cmd >= ARRAY_SIZE(_flt_ioctls)))
+			return NULL;
+
+		*ioctl_flags = _flt_ioctls[cmd].flags;
+		return _flt_ioctls[cmd].fn;
+	}
+
 	if (unlikely(cmd >= ARRAY_SIZE(_ioctls)))
 		return NULL;
 
diff --git a/drivers/md/flt-ctl.c b/drivers/md/flt-ctl.c
new file mode 100644
index 000000000000..aadf04be1438
--- /dev/null
+++ b/drivers/md/flt-ctl.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/dm-ioctl.h>
+
+#include "flt-ctl.h"
+
+int filter_remove_all(struct file *filp, struct dm_ioctl *param, size_t param_size)
+{
+	return 0;
+};
+int filter_create(struct file *filp, struct dm_ioctl *param, size_t param_size)
+{
+	return 0;
+};
+int filter_remove(struct file *filp, struct dm_ioctl *param, size_t param_size)
+{
+	return 0;
+};
+int filter_control(struct file *filp, struct dm_ioctl *param, size_t param_size)
+{
+	return 0;
+};
+
diff --git a/drivers/md/flt-ctl.h b/drivers/md/flt-ctl.h
new file mode 100644
index 000000000000..61a80184abae
--- /dev/null
+++ b/drivers/md/flt-ctl.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: LGPL-2.0+ WITH Linux-syscall-note */
+#ifndef FLT_CTL_H
+#define FLT_CTL_H
+
+int filter_remove_all(struct file *filp, struct dm_ioctl *param, size_t param_size);
+int filter_create(struct file *filp, struct dm_ioctl *param, size_t param_size);
+int filter_remove(struct file *filp, struct dm_ioctl *param, size_t param_size);
+int filter_control(struct file *filp, struct dm_ioctl *param, size_t param_size);
+
+#endif
diff --git a/include/uapi/linux/dm-ioctl.h b/include/uapi/linux/dm-ioctl.h
index e942e7d7c594..012e16761ba9 100644
--- a/include/uapi/linux/dm-ioctl.h
+++ b/include/uapi/linux/dm-ioctl.h
@@ -16,6 +16,7 @@
 #define DM_MAX_TYPE_NAME 16
 #define DM_NAME_LEN 128
 #define DM_UUID_LEN 129
+#define DM_FILTER_CMD 128	/* First filters command */
 
 /*
  * A traditional ioctl interface for the device mapper.
@@ -244,6 +245,14 @@ enum {
 	DM_DEV_SET_GEOMETRY_CMD,
 	DM_DEV_ARM_POLL_CMD,
 	DM_GET_TARGET_VERSION_CMD,
+
+	/* Reserved space for additional DM ioctl */
+
+	/* Filters commands */
+	FLT_REMOVE_ALL_CMD = DM_FILTER_CMD, /* Cleanup all filters */
+	FLT_CREATE_CMD,		/* Create new filter */
+	FLT_REMOVE_CMD,		/* Remove filter */
+	FLT_CONTROL_CMD,	/* Send a filter-specific command */
 };
 
 #define DM_IOCTL 0xfd
@@ -271,10 +280,15 @@ enum {
 #define DM_TARGET_MSG	 _IOWR(DM_IOCTL, DM_TARGET_MSG_CMD, struct dm_ioctl)
 #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
 
+#define FLT_REMOVE_ALL   _IOWR(DM_IOCTL, FLT_REMOVE_ALL_CMD, struct dm_ioctl)
+#define FLT_CREATE       _IOWR(DM_IOCTL, FLT_CREATE_CMD, struct dm_ioctl)
+#define FLT_REMOVE       _IOWR(DM_IOCTL, FLT_REMOVE_CMD, struct dm_ioctl)
+#define FLT_CONTROL      _IOWR(DM_IOCTL, FLT_CONTROL_CMD, struct dm_ioctl)
+
 #define DM_VERSION_MAJOR	4
-#define DM_VERSION_MINOR	43
+#define DM_VERSION_MINOR	44
 #define DM_VERSION_PATCHLEVEL	0
-#define DM_VERSION_EXTRA	"-ioctl (2020-10-01)"
+#define DM_VERSION_EXTRA	"-ioctl (2021-03-03)"
 
 /* Status bits */
 #define DM_READONLY_FLAG	(1 << 0) /* In/Out */
-- 
2.20.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

