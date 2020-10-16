Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2DBEC433E7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:43:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1BBCC207F7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:43:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1BBCC207F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-01wkbOilPhuo2Gaa_Mwz2g-1; Fri, 16 Oct 2020 06:43:37 -0400
X-MC-Unique: 01wkbOilPhuo2Gaa_Mwz2g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 436DD1074645;
	Fri, 16 Oct 2020 10:43:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 257FF5D9D5;
	Fri, 16 Oct 2020 10:43:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F20A192F4F;
	Fri, 16 Oct 2020 10:43:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GAhDIr019956 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 06:43:14 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B7B4A2166B28; Fri, 16 Oct 2020 10:43:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B01CF2156A38
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4ED15182360B
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:13 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-482-6Xjagoy1NamVHFZqRQKxaQ-1;
	Fri, 16 Oct 2020 06:43:08 -0400
X-MC-Unique: 6Xjagoy1NamVHFZqRQKxaQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 4166FAB5C;
	Fri, 16 Oct 2020 10:43:06 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 16 Oct 2020 12:42:37 +0200
Message-Id: <20201016104239.8217-11-mwilck@suse.com>
In-Reply-To: <20201016104239.8217-1-mwilck@suse.com>
References: <20201016104239.8217-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09GAhDIr019956
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 10/12] libmpathpersist: add linker version
	script
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

This defines the ABI of libmpathpersist in the current state.
The initial version is set to "LIBMPATHPERSIST_1.0.0".

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/Makefile                |  6 +++--
 libmpathpersist/libmpathpersist.version | 32 +++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 2 deletions(-)
 create mode 100644 libmpathpersist/libmpathpersist.version

diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index 9e869fd..456ce4c 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -3,6 +3,7 @@ include ../Makefile.inc
 SONAME = 0
 DEVLIB = libmpathpersist.so
 LIBS = $(DEVLIB).$(SONAME)
+VERSION_SCRIPT := libmpathpersist.version
 
 CFLAGS += $(LIB_CFLAGS) -I$(multipathdir) -I$(mpathpersistdir) -I$(mpathcmddir)
 
@@ -13,8 +14,9 @@ OBJS = mpath_persist.o mpath_updatepr.o mpath_pr_ioctl.o
 
 all: $(DEVLIB) man
 
-$(LIBS): $(OBJS)
-	$(CC) $(LDFLAGS) $(SHARED_FLAGS) $(LIBDEPS) -Wl,-soname=$@ -o $@ $(OBJS)
+$(LIBS): $(OBJS) $(VERSION_SCRIPT)
+	$(CC) $(LDFLAGS) $(SHARED_FLAGS) $(LIBDEPS) -Wl,-soname=$@ \
+		-Wl,--version-script=$(VERSION_SCRIPT) -o $@ $(OBJS)
 
 $(DEVLIB): $(LIBS)
 	$(LN) $(LIBS) $@
diff --git a/libmpathpersist/libmpathpersist.version b/libmpathpersist/libmpathpersist.version
new file mode 100644
index 0000000..dc648ce
--- /dev/null
+++ b/libmpathpersist/libmpathpersist.version
@@ -0,0 +1,32 @@
+/*
+ * Copyright (c) 2020 SUSE LLC
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ *
+ * libmpathpersist ABI
+ *
+ * The ABI of libmpathpersist is supposed to remain stable. Removing symbols
+ * or altering existing symbols' semantics is not allowed. When changing a
+ * a symbol, either use a new name, or explicit symver directives.
+ *
+ * See libmultipath.version for general policy about version numbers.
+ */
+LIBMPATHPERSIST_1.0.0 {
+global:
+
+	__mpath_persistent_reserve_in;
+	__mpath_persistent_reserve_out;
+	dumpHex;
+	mpath_alloc_prin_response;
+	mpath_lib_exit;
+	mpath_lib_init;
+	mpath_mx_alloc_len;
+	mpath_persistent_reserve_in;
+	mpath_persistent_reserve_init_vecs;
+	mpath_persistent_reserve_out;
+	mpath_persistent_reserve_free_vecs;
+	prin_do_scsi_ioctl;
+	prout_do_scsi_ioctl;
+	update_map_pr;
+
+local: *;
+};
-- 
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

