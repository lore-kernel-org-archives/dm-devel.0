Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16966C433E7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:44:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 61A31207F7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:44:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 61A31207F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-XEyCUm-1NwOAbPY1r4vM3Q-1; Fri, 16 Oct 2020 06:44:17 -0400
X-MC-Unique: XEyCUm-1NwOAbPY1r4vM3Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19F1918A0781;
	Fri, 16 Oct 2020 10:44:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F034D5C22D;
	Fri, 16 Oct 2020 10:44:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C7A375812B;
	Fri, 16 Oct 2020 10:44:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GAhua8020280 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 06:43:56 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 655A52156A3B; Fri, 16 Oct 2020 10:43:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B44C2166B28
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 33967800969
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:56 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-326-PU_vY6NzOiiKKtB7oYuzow-1;
	Fri, 16 Oct 2020 06:43:51 -0400
X-MC-Unique: PU_vY6NzOiiKKtB7oYuzow-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 68C11B2B2;
	Fri, 16 Oct 2020 10:43:49 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 16 Oct 2020 12:43:25 +0200
Message-Id: <20201016104329.8337-18-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09GAhua8020280
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 17/21] libmultipath: add udev and logsink
	symbols
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

With these symbols added, applications using libmultipath don't
need to define global variables "udev" and "logsink" any more.
This comes at the cost of having to call an init function.
Currently, libmultipath_init() does nothing but initialize
"udev".

The linker's symbol lookup order still allows applications to use
their own "logsink" and "udev" variables, which will take precendence
over libmultipath's internal ones. In this case, calling
libmultipath_init() can be skipped, but like before,
udev should be initialized (using udev_new()) before making any
libmultipath calls.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c             | 41 +++++++++++++++++++++++++++
 libmultipath/config.h             | 46 ++++++++++++++++++++++++++++++-
 libmultipath/debug.c              |  2 ++
 libmultipath/libmultipath.version |  8 ++++++
 4 files changed, 96 insertions(+), 1 deletion(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 01b77df..f74417c 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -27,6 +27,47 @@
 #include "mpath_cmd.h"
 #include "propsel.h"
 
+/*
+ * We don't support re-initialization after
+ * libmultipath_exit().
+ */
+static bool libmultipath_exit_called;
+static pthread_once_t _init_once = PTHREAD_ONCE_INIT;
+static pthread_once_t _exit_once = PTHREAD_ONCE_INIT;
+struct udev *udev;
+
+static void _udev_init(void)
+{
+	if (udev)
+		udev_ref(udev);
+	else
+		udev = udev_new();
+	if (!udev)
+		condlog(0, "%s: failed to initialize udev", __func__);
+}
+
+static bool _is_libmultipath_initialized(void)
+{
+	return !libmultipath_exit_called && !!udev;
+}
+
+int libmultipath_init(void)
+{
+	pthread_once(&_init_once, _udev_init);
+	return !_is_libmultipath_initialized();
+}
+
+static void _libmultipath_exit(void)
+{
+	libmultipath_exit_called = true;
+	udev_unref(udev);
+}
+
+void libmultipath_exit(void)
+{
+	pthread_once(&_exit_once, _libmultipath_exit);
+}
+
 static struct config __internal_config;
 struct config *libmp_get_multipath_config(void)
 {
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 0329de2..f478df7 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -233,7 +233,51 @@ struct config {
 	char *enable_foreign;
 };
 
-extern struct udev * udev;
+/**
+ * extern variable: udev
+ *
+ * A &struct udev instance used by libmultipath. libmultipath expects
+ * a valid, initialized &struct udev in this variable.
+ * An application can define this variable itself, in which case
+ * the applications's instance will take precedence.
+ * The application can initialize and destroy this variable by
+ * calling libmultipath_init() and libmultipath_exit(), respectively,
+ * whether or not it defines the variable itself.
+ * An application can initialize udev with udev_new() before calling
+ * libmultipath_init(), e.g. if it has to make libudev calls before
+ * libmultipath calls. If an application wants to keep using the
+ * udev variable after calling libmultipath_exit(), it should have taken
+ * an additional reference on it beforehand. This is the case e.g.
+ * after initiazing udev with udev_new().
+ */
+extern struct udev *udev;
+
+/**
+ * libmultipath_init() - library initialization
+ *
+ * This function initializes libmultipath data structures.
+ * It is light-weight; some other initializations, like device-mapper
+ * initialization, are done lazily when the respective functionality
+ * is required.
+ *
+ * Clean up by libmultipath_exit() when the program terminates.
+ * It is an error to call libmultipath_init() after libmultipath_exit().
+ * Return: 0 on success, 1 on failure.
+ */
+int libmultipath_init(void);
+
+/**
+ * libmultipath_exit() - library un-initialization
+ *
+ * This function un-initializes libmultipath data structures.
+ * It is recommended to call this function at program exit.
+ *
+ * Calls to libmultipath_init() after libmultipath_exit() will fail
+ * (in other words, libmultipath can't be re-initialized).
+ * Any other libmultipath calls after libmultipath_exit() may cause
+ * undefined behavior.
+ */
+void libmultipath_exit(void);
 
 int find_hwe (const struct _vector *hwtable,
 	      const char * vendor, const char * product, const char *revision,
diff --git a/libmultipath/debug.c b/libmultipath/debug.c
index 4128cb9..b3a1de9 100644
--- a/libmultipath/debug.c
+++ b/libmultipath/debug.c
@@ -15,6 +15,8 @@
 #include "defaults.h"
 #include "debug.h"
 
+int logsink;
+
 void dlog (int sink, int prio, const char * fmt, ...)
 {
 	va_list ap;
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 3e780fc..0c300c8 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -261,3 +261,11 @@ global:
 	init_config;
 	uninit_config;
 } LIBMULTIPATH_2.1.0;
+
+LIBMULTIPATH_2.3.0 {
+global:
+	udev;
+	logsink;
+	libmultipath_init;
+	libmultipath_exit;
+} LIBMULTIPATH_2.2.0;
-- 
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

