Return-Path: <SRS0=g9U1=FU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA99C0018C
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 18:19:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4BFA024AF6
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 18:19:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4BFA024AF6
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-PZMmw4HAO7Ksaz_YXoJUZQ-1; Wed, 16 Dec 2020 13:19:05 -0500
X-MC-Unique: PZMmw4HAO7Ksaz_YXoJUZQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 626C61934117;
	Wed, 16 Dec 2020 18:18:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D003FE715;
	Wed, 16 Dec 2020 18:18:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 98C531809CA5;
	Wed, 16 Dec 2020 18:18:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BGIIcis018038 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Dec 2020 13:18:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E842294624; Wed, 16 Dec 2020 18:18:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E3455CF616
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 18:18:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D092280088F
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 18:18:37 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-44-lFeAmc3xO1ebnECoWuJaOg-1;
	Wed, 16 Dec 2020 13:18:34 -0500
X-MC-Unique: lFeAmc3xO1ebnECoWuJaOg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 2F4F7AF4C;
	Wed, 16 Dec 2020 18:18:33 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 16 Dec 2020 19:16:58 +0100
Message-Id: <20201216181708.22224-20-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BGIIcis018038
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 19/29] multipathd: move cleanup_{prio, checkers,
	foreign} to libmultipath_exit
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

This requires another major ABI bump.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist.c   | 2 --
 libmultipath/config.c             | 4 ++++
 libmultipath/libmultipath.version | 5 +----
 multipathd/main.c                 | 3 ---
 4 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index e1d1cb7..9ebf91d 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -78,8 +78,6 @@ mpath_lib_init (void)
 
 static void libmpathpersist_cleanup(void)
 {
-	cleanup_prio();
-	cleanup_checkers();
 	libmultipath_exit();
 	dm_lib_exit();
 }
diff --git a/libmultipath/config.c b/libmultipath/config.c
index b9cb413..52b1447 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -26,6 +26,7 @@
 #include "devmapper.h"
 #include "mpath_cmd.h"
 #include "propsel.h"
+#include "foreign.h"
 
 /*
  * We don't support re-initialization after
@@ -60,6 +61,9 @@ int libmultipath_init(void)
 static void _libmultipath_exit(void)
 {
 	libmultipath_exit_called = true;
+	cleanup_foreign();
+	cleanup_checkers();
+	cleanup_prio();
 	libmp_dm_exit();
 	udev_unref(udev);
 }
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 84beb7f..800cff2 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -31,7 +31,7 @@
  *   The new version inherits the previous ones.
  */
 
-LIBMULTIPATH_3.0.0 {
+LIBMULTIPATH_4.0.0 {
 global:
 	/* symbols referenced by multipath and multipathd */
 	add_foreign;
@@ -51,10 +51,7 @@ global:
 	checker_name;
 	checker_state_name;
 	check_foreign;
-	cleanup_checkers;
-	cleanup_foreign;
 	cleanup_lock;
-	cleanup_prio;
 	close_fd;
 	coalesce_paths;
 	convert_dev;
diff --git a/multipathd/main.c b/multipathd/main.c
index 50cc335..4de0978 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3028,9 +3028,6 @@ static void cleanup_child(void)
 {
 	cleanup_threads();
 	cleanup_vecs();
-	cleanup_foreign();
-	cleanup_checkers();
-	cleanup_prio();
 	if (poll_dmevents)
 		cleanup_dmevent_waiter();
 
-- 
2.29.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

