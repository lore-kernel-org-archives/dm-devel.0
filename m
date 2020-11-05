Return-Path: <SRS0=33od=EL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEBF9C4742C
	for <dm-devel@archiver.kernel.org>; Thu,  5 Nov 2020 10:21:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 393DE2087D
	for <dm-devel@archiver.kernel.org>; Thu,  5 Nov 2020 10:21:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 393DE2087D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-71ARmOpxN-uuBQdpm_zHZw-1; Thu, 05 Nov 2020 05:21:02 -0500
X-MC-Unique: 71ARmOpxN-uuBQdpm_zHZw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 123F0186DD22;
	Thu,  5 Nov 2020 10:20:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DF5CD19C4F;
	Thu,  5 Nov 2020 10:20:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 582BD183D021;
	Thu,  5 Nov 2020 10:20:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A5AKtBZ029237 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 5 Nov 2020 05:20:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BA282215672D; Thu,  5 Nov 2020 10:20:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B39712156729
	for <dm-devel@redhat.com>; Thu,  5 Nov 2020 10:20:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7ED47811E82
	for <dm-devel@redhat.com>; Thu,  5 Nov 2020 10:20:53 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-386-FVbQfKlLOkyKWa6XPCBjkw-1;
	Thu, 05 Nov 2020 05:20:48 -0500
X-MC-Unique: FVbQfKlLOkyKWa6XPCBjkw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 45F1EAC55;
	Thu,  5 Nov 2020 10:20:47 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu,  5 Nov 2020 11:20:33 +0100
Message-Id: <20201105102033.18411-3-mwilck@suse.com>
In-Reply-To: <20201105102033.18411-1-mwilck@suse.com>
References: <20201105102033.18411-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0A5AKtBZ029237
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 2/2] libmultipath: dm_task_get_errno() is not
	always available
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

The function was added in LVM2 2.02.122. The DM version is
1.02.99. Fall back to errno if dm_task_get_errno() doesn't exist.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/Makefile    | 4 ++++
 libmultipath/devmapper.c | 2 ++
 libmultipath/devmapper.h | 5 +++++
 multipathd/Makefile      | 4 ++++
 4 files changed, 15 insertions(+)

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index e5dac5e..62ba16e 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -24,6 +24,10 @@ ifneq ($(call check_func,dm_task_no_flush,/usr/include/libdevmapper.h),0)
 	CFLAGS += -DLIBDM_API_FLUSH -D_GNU_SOURCE
 endif
 
+ifneq ($(call check_func,dm_task_get_errno,/usr/include/libdevmapper.h),0)
+	CFLAGS += -DLIBDM_API_GET_ERRNO
+endif
+
 ifneq ($(call check_func,dm_task_set_cookie,/usr/include/libdevmapper.h),0)
 	CFLAGS += -DLIBDM_API_COOKIE
 endif
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index b4d77cb..7f09361 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -119,6 +119,8 @@ dm_lib_prereq (void)
 	int v[3];
 #if defined(LIBDM_API_HOLD_CONTROL)
 	int minv[3] = {1, 2, 111};
+#elif defined(LIBDM_API_GET_ERRNO)
+	int minv[3] = {1, 2, 99};
 #elif defined(LIBDM_API_DEFERRED)
 	int minv[3] = {1, 2, 89};
 #elif defined(DM_SUBSYSTEM_UDEV_FLAG0)
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index f568ab5..f469c98 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -85,6 +85,11 @@ struct multipath *dm_get_multipath(const char *name);
 	((v[0] == minv[0]) && (v[1] == minv[1]) && (v[2] >= minv[2])) \
 )
 
+#ifndef LIBDM_API_GET_ERRNO
+#include <errno.h>
+#define dm_task_get_errno(x) errno
+#endif
+
 #define dm_log_error(lvl, cmd, dmt)			      \
 	condlog(lvl, "%s: libdm task=%d error: %s", __func__, \
 		cmd, strerror(dm_task_get_errno(dmt)))	      \
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 8d90117..632b82b 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -1,5 +1,9 @@
 include ../Makefile.inc
 
+ifneq ($(call check_func,dm_task_get_errno,/usr/include/libdevmapper.h),0)
+	CFLAGS += -DLIBDM_API_GET_ERRNO
+endif
+
 #
 # debugging stuff
 #
-- 
2.29.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

