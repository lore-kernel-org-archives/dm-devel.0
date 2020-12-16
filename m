Return-Path: <SRS0=g9U1=FU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8746C2BBCA
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 18:19:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1FAF125CAA
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 18:19:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1FAF125CAA
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-16XN1MnVOf-F7ytUqtalXg-1; Wed, 16 Dec 2020 13:19:02 -0500
X-MC-Unique: 16XN1MnVOf-F7ytUqtalXg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C75C107ACF8;
	Wed, 16 Dec 2020 18:18:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F2D7B18796;
	Wed, 16 Dec 2020 18:18:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C55CC1809CA3;
	Wed, 16 Dec 2020 18:18:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BGIIcvD018041 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Dec 2020 13:18:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0964C2026D5D; Wed, 16 Dec 2020 18:18:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 041DD2026D48
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 18:18:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E45A9811E85
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 18:18:37 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-541-TK2LHLOuMY647OhZx4mxsA-1;
	Wed, 16 Dec 2020 13:18:33 -0500
X-MC-Unique: TK2LHLOuMY647OhZx4mxsA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id CC005B066;
	Wed, 16 Dec 2020 18:18:31 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 16 Dec 2020 19:16:53 +0100
Message-Id: <20201216181708.22224-15-mwilck@suse.com>
In-Reply-To: <20201216181708.22224-1-mwilck@suse.com>
References: <20201216181708.22224-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BGIIcvD018041
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 14/29] libmultipath: add libmp_dm_exit()
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

This function prepares for calling dm_lib_exit() on program exit.
It undoes changes to libdm internals done by libmultipath.
It doesn't call dm_lib_exit(), as the caller may want to keep
libdm active.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c    |  1 +
 libmultipath/config.h    |  2 ++
 libmultipath/devmapper.c | 15 +++++++++++++++
 libmultipath/devmapper.h |  1 +
 4 files changed, 19 insertions(+)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index f74417c..b9cb413 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -60,6 +60,7 @@ int libmultipath_init(void)
 static void _libmultipath_exit(void)
 {
 	libmultipath_exit_called = true;
+	libmp_dm_exit();
 	udev_unref(udev);
 }
 
diff --git a/libmultipath/config.h b/libmultipath/config.h
index f478df7..5d46035 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -271,6 +271,8 @@ int libmultipath_init(void);
  *
  * This function un-initializes libmultipath data structures.
  * It is recommended to call this function at program exit.
+ * If the application also calls dm_lib_exit(), it should do so
+ * after libmultipath_exit().
  *
  * Calls to libmultipath_init() after libmultipath_exit() will fail
  * (in other words, libmultipath can't be re-initialized).
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 4eb6f53..e60ab49 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -335,6 +335,20 @@ void libmp_udev_set_sync_support(int on)
 	libmp_dm_udev_sync = !!on;
 }
 
+static bool libmp_dm_init_called;
+void libmp_dm_exit(void)
+{
+	if (!libmp_dm_init_called)
+		return;
+
+	/* switch back to default libdm logging */
+	dm_log_init(NULL);
+#ifdef LIBDM_API_HOLD_CONTROL
+	/* make sure control fd is closed in dm_lib_release() */
+	dm_hold_control_dev(0);
+#endif
+}
+
 static void libmp_dm_init(void)
 {
 	struct config *conf;
@@ -351,6 +365,7 @@ static void libmp_dm_init(void)
 	dm_hold_control_dev(1);
 #endif
 	dm_udev_set_sync_support(libmp_dm_udev_sync);
+	libmp_dm_init_called = true;
 }
 
 static void _do_skip_libmp_dm_init(void)
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index fa6b3c5..e29b4d4 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -35,6 +35,7 @@ enum {
 
 int dm_prereq(unsigned int *v);
 void skip_libmp_dm_init(void);
+void libmp_dm_exit(void);
 void libmp_udev_set_sync_support(int on);
 struct dm_task *libmp_dm_task_create(int task);
 int dm_simplecmd_flush (int, const char *, uint16_t);
-- 
2.29.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

