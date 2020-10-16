Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D141C43467
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:44:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 66C7F207F7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:44:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 66C7F207F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-Y4yHF3e9NcOPsimSLYwGSg-1; Fri, 16 Oct 2020 06:44:19 -0400
X-MC-Unique: Y4yHF3e9NcOPsimSLYwGSg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93F00803652;
	Fri, 16 Oct 2020 10:44:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7BFDC50B44;
	Fri, 16 Oct 2020 10:44:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2C68D58133;
	Fri, 16 Oct 2020 10:44:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GAhtpK020243 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 06:43:55 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 522022011557; Fri, 16 Oct 2020 10:43:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D4792011559
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24FC9182360F
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:55 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-592-RpEYVGdjM7ujjs8Q75tIeg-1;
	Fri, 16 Oct 2020 06:43:50 -0400
X-MC-Unique: RpEYVGdjM7ujjs8Q75tIeg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 9A28EAF48;
	Fri, 16 Oct 2020 10:43:48 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 16 Oct 2020 12:43:22 +0200
Message-Id: <20201016104329.8337-15-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09GAhtpK020243
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 14/21] libmpathpersist: allow using
	libmultipath {get, put}_multipath_config
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Provide an alternative init function libmpathpersist_init() which
avoids allocating a new struct config, simply using libmultipath's
internal implementation. This causes a minor version bump for
libmpathpersist.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/libmpathpersist.version |  6 ++++
 libmpathpersist/mpath_persist.c         | 42 +++++++++++++++++++++----
 libmpathpersist/mpath_persist.h         | 28 +++++++++++++++++
 3 files changed, 70 insertions(+), 6 deletions(-)

diff --git a/libmpathpersist/libmpathpersist.version b/libmpathpersist/libmpathpersist.version
index dc648ce..e074813 100644
--- a/libmpathpersist/libmpathpersist.version
+++ b/libmpathpersist/libmpathpersist.version
@@ -30,3 +30,9 @@ global:
 
 local: *;
 };
+
+LIBMPATHPERSIST_1.1.0 {
+global:
+	libmpathpersist_init;
+	libmpathpersist_exit;
+} LIBMPATHPERSIST_1.0.0;
diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index cc4a088..febf475 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -37,6 +37,27 @@
 
 extern struct udev *udev;
 
+static void adapt_config(struct config *conf)
+{
+	conf->force_sync = 1;
+	set_max_fds(conf->max_fds);
+}
+
+int libmpathpersist_init(void)
+{
+	struct config *conf;
+	int rc = 0;
+
+	if (init_config(DEFAULT_CONFIGFILE)) {
+		condlog(0, "Failed to initialize multipath config.");
+		return 1;
+	}
+	conf = libmp_get_multipath_config();
+	adapt_config(conf);
+	libmp_put_multipath_config(conf);
+	return rc;
+}
+
 struct config *
 mpath_lib_init (void)
 {
@@ -47,20 +68,29 @@ mpath_lib_init (void)
 		condlog(0, "Failed to initialize multipath config.");
 		return NULL;
 	}
-	conf->force_sync = 1;
-	set_max_fds(conf->max_fds);
-
+	adapt_config(conf);
 	return conf;
 }
 
-int
-mpath_lib_exit (struct config *conf)
+static void libmpathpersist_cleanup(void)
 {
 	dm_lib_exit();
 	cleanup_prio();
 	cleanup_checkers();
+}
+
+int
+mpath_lib_exit (struct config *conf)
+{
+	libmpathpersist_cleanup();
 	free_config(conf);
-	conf = NULL;
+	return 0;
+}
+
+int libmpathpersist_exit(void)
+{
+	libmpathpersist_cleanup();
+	uninit_config();
 	return 0;
 }
 
diff --git a/libmpathpersist/mpath_persist.h b/libmpathpersist/mpath_persist.h
index 7cf4faf..91606ef 100644
--- a/libmpathpersist/mpath_persist.h
+++ b/libmpathpersist/mpath_persist.h
@@ -175,6 +175,22 @@ struct prout_param_descriptor {		/* PROUT parameter descriptor */
  * DESCRIPTION :
  *	Initialize device mapper multipath configuration. This function must be invoked first
  *	before performing reservation management functions.
+ *	Either this function or mpath_lib_init() may be used.
+ *	Use this function to work with libmultipath's internal "struct config".
+ *	Call libmpathpersist_exit() for cleanup.
+ * RESTRICTIONS:
+ *
+ * RETURNS: 0->Success, 1->Failed.
+ */
+extern int libmpathpersist_init (void);
+
+/*
+ * DESCRIPTION :
+ *	Initialize device mapper multipath configuration. This function must be invoked first
+ *	before performing reservation management functions.
+ *	Either this function or libmpathpersist_init() may be used.
+ *	Use this function to work with an application-specific "struct config".
+ *	Call mpath_lib_exit() for cleanup.
  * RESTRICTIONS:
  *
  * RETURNS: struct config ->Success, NULL->Failed.
@@ -186,12 +202,24 @@ extern struct config * mpath_lib_init (void);
  * DESCRIPTION :
  *	Release device mapper multipath configuration. This function must be invoked after
  *	performing reservation management functions.
+ *	Use this after initialization with mpath_lib_init().
  * RESTRICTIONS:
  *
  * RETURNS: 0->Success, 1->Failed.
  */
 extern int mpath_lib_exit (struct config *conf);
 
+/*
+ * DESCRIPTION :
+ *	Release device mapper multipath configuration. This function must be invoked after
+ *	performing reservation management functions.
+ *	Use this after initialization with libmpathpersist_init().
+ * RESTRICTIONS:
+ *
+ * RETURNS: 0->Success, 1->Failed.
+ */
+extern int libmpathpersist_exit (void);
+
 
 /*
  * DESCRIPTION :
-- 
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

