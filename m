Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4D73C433E7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:44:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 23F13207F7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:44:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 23F13207F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-Su-FcKW0MoyjV9wZY4TXeQ-1; Fri, 16 Oct 2020 06:44:22 -0400
X-MC-Unique: Su-FcKW0MoyjV9wZY4TXeQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4871C9CC0D;
	Fri, 16 Oct 2020 10:44:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C06260C15;
	Fri, 16 Oct 2020 10:44:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F2ABE1826D35;
	Fri, 16 Oct 2020 10:44:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GAhuBC020281 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 06:43:56 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 682A02166B28; Fri, 16 Oct 2020 10:43:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 620742156A39
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1A50811E79
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:54 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-410-tN6LnudrO3ywu3k6KcozYA-1;
	Fri, 16 Oct 2020 06:43:51 -0400
X-MC-Unique: tN6LnudrO3ywu3k6KcozYA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id DE045B2B4;
	Fri, 16 Oct 2020 10:43:49 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 16 Oct 2020 12:43:27 +0200
Message-Id: <20201016104329.8337-20-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09GAhuBC020281
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 19/21] libmpathpersist: call
	libmultipath_{init, exit}()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Have libmpathpersist_{init,exit} do the udev initialization, too.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist.c | 11 ++++++++---
 libmpathpersist/mpath_persist.h |  9 ++++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index febf475..e1d1cb7 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -48,6 +48,10 @@ int libmpathpersist_init(void)
 	struct config *conf;
 	int rc = 0;
 
+	if (libmultipath_init()) {
+		condlog(0, "Failed to initialize libmultipath.");
+		return 1;
+	}
 	if (init_config(DEFAULT_CONFIGFILE)) {
 		condlog(0, "Failed to initialize multipath config.");
 		return 1;
@@ -74,23 +78,24 @@ mpath_lib_init (void)
 
 static void libmpathpersist_cleanup(void)
 {
-	dm_lib_exit();
 	cleanup_prio();
 	cleanup_checkers();
+	libmultipath_exit();
+	dm_lib_exit();
 }
 
 int
 mpath_lib_exit (struct config *conf)
 {
-	libmpathpersist_cleanup();
 	free_config(conf);
+	libmpathpersist_cleanup();
 	return 0;
 }
 
 int libmpathpersist_exit(void)
 {
-	libmpathpersist_cleanup();
 	uninit_config();
+	libmpathpersist_cleanup();
 	return 0;
 }
 
diff --git a/libmpathpersist/mpath_persist.h b/libmpathpersist/mpath_persist.h
index 91606ef..5435eae 100644
--- a/libmpathpersist/mpath_persist.h
+++ b/libmpathpersist/mpath_persist.h
@@ -176,7 +176,8 @@ struct prout_param_descriptor {		/* PROUT parameter descriptor */
  *	Initialize device mapper multipath configuration. This function must be invoked first
  *	before performing reservation management functions.
  *	Either this function or mpath_lib_init() may be used.
- *	Use this function to work with libmultipath's internal "struct config".
+ *	Use this function to work with libmultipath's internal "struct config"
+ *	and "struct udev". The latter will be initialized automatically.
  *	Call libmpathpersist_exit() for cleanup.
  * RESTRICTIONS:
  *
@@ -189,7 +190,8 @@ extern int libmpathpersist_init (void);
  *	Initialize device mapper multipath configuration. This function must be invoked first
  *	before performing reservation management functions.
  *	Either this function or libmpathpersist_init() may be used.
- *	Use this function to work with an application-specific "struct config".
+ *	Use this function to work with an application-specific "struct config"
+ *	and "struct udev". The latter must be initialized by the application.
  *	Call mpath_lib_exit() for cleanup.
  * RESTRICTIONS:
  *
@@ -211,9 +213,10 @@ extern int mpath_lib_exit (struct config *conf);
 
 /*
  * DESCRIPTION :
- *	Release device mapper multipath configuration. This function must be invoked after
+ *	Release device mapper multipath configuration a. This function must be invoked after
  *	performing reservation management functions.
  *	Use this after initialization with libmpathpersist_init().
+ *	Calling libmpathpersist_init() after libmpathpersist_exit() will fail.
  * RESTRICTIONS:
  *
  * RETURNS: 0->Success, 1->Failed.
-- 
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

