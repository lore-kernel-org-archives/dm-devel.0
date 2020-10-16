Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE86FC35265
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:45:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 298FD2084C
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:45:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 298FD2084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-jL-UJVbsNpW3vth6YS2tVg-1; Fri, 16 Oct 2020 06:45:47 -0400
X-MC-Unique: jL-UJVbsNpW3vth6YS2tVg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0B6D1084D67;
	Fri, 16 Oct 2020 10:45:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AE75F1992F;
	Fri, 16 Oct 2020 10:45:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 81A8058135;
	Fri, 16 Oct 2020 10:45:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GAjMCK020805 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 06:45:22 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 261792011561; Fri, 16 Oct 2020 10:45:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F67D2011559
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:45:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 044D11823613
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:45:22 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-207-Ag1qrBqlOpOLaLm9c7BOhg-1;
	Fri, 16 Oct 2020 06:45:17 -0400
X-MC-Unique: Ag1qrBqlOpOLaLm9c7BOhg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id C3CECB2B4;
	Fri, 16 Oct 2020 10:45:15 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 16 Oct 2020 12:44:51 +0200
Message-Id: <20201016104501.8700-20-mwilck@suse.com>
In-Reply-To: <20201016104501.8700-1-mwilck@suse.com>
References: <20201016104501.8700-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09GAjMCK020805
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 19/29] multipathd: move cleanup_{prio, checkers,
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
index 0578445..33277d5 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3027,9 +3027,6 @@ static void cleanup_child(void)
 {
 	cleanup_threads();
 	cleanup_vecs();
-	cleanup_foreign();
-	cleanup_checkers();
-	cleanup_prio();
 	if (poll_dmevents)
 		cleanup_dmevent_waiter();
 
-- 
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

