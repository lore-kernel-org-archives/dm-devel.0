Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D13AAC433E7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:45:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3C7E2207F7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:45:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C7E2207F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-HBsJ5fPZO1eDboU-8_IGnw-1; Fri, 16 Oct 2020 06:45:30 -0400
X-MC-Unique: HBsJ5fPZO1eDboU-8_IGnw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3ED6C18A8238;
	Fri, 16 Oct 2020 10:45:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E9395D9D5;
	Fri, 16 Oct 2020 10:45:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E60C81826D37;
	Fri, 16 Oct 2020 10:45:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GAjJHC020686 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 06:45:19 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4483B2156A38; Fri, 16 Oct 2020 10:45:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 374122156A3A
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:45:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FFFE800186
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:45:17 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-389-7A2Z0EO4OnSwEWhyQO2TnQ-1;
	Fri, 16 Oct 2020 06:45:12 -0400
X-MC-Unique: 7A2Z0EO4OnSwEWhyQO2TnQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 03ED5AF4F;
	Fri, 16 Oct 2020 10:45:11 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 16 Oct 2020 12:44:35 +0200
Message-Id: <20201016104501.8700-4-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09GAjJHC020686
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 03/29] multipathd: move handling of
	io_err_stat_attr into libmultipath
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

This thread attribute can be dynamically initialized and destroyed.
No need to carry it along in multipathd. Removal of the symbol
requires to bump the ABI version to 3.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/io_err_stat.c        |  7 +++++--
 libmultipath/libmultipath.version | 23 ++++++++---------------
 multipathd/main.c                 |  2 --
 3 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
index 58bc1dd..5363049 100644
--- a/libmultipath/io_err_stat.c
+++ b/libmultipath/io_err_stat.c
@@ -34,6 +34,7 @@
 #include "lock.h"
 #include "time-util.h"
 #include "io_err_stat.h"
+#include "util.h"
 
 #define TIMEOUT_NO_IO_NSEC		10000000 /*10ms = 10000000ns*/
 #define FLAKY_PATHFAIL_THRESHOLD	2
@@ -70,8 +71,7 @@ struct io_err_stat_path {
 	int		err_rate_threshold;
 };
 
-pthread_t		io_err_stat_thr;
-pthread_attr_t		io_err_stat_attr;
+static pthread_t	io_err_stat_thr;
 
 static pthread_mutex_t io_err_thread_lock = PTHREAD_MUTEX_INITIALIZER;
 static pthread_cond_t io_err_thread_cond = PTHREAD_COND_INITIALIZER;
@@ -727,6 +727,7 @@ static void *io_err_stat_loop(void *data)
 int start_io_err_stat_thread(void *data)
 {
 	int ret;
+	pthread_attr_t io_err_stat_attr;
 
 	if (uatomic_read(&io_err_thread_running) == 1)
 		return 0;
@@ -739,6 +740,7 @@ int start_io_err_stat_thread(void *data)
 	if (!paths)
 		goto destroy_ctx;
 
+	setup_thread_attr(&io_err_stat_attr, 32 * 1024, 0);
 	pthread_mutex_lock(&io_err_thread_lock);
 	pthread_cleanup_push(cleanup_unlock, &io_err_thread_lock);
 
@@ -750,6 +752,7 @@ int start_io_err_stat_thread(void *data)
 				 &io_err_thread_lock) == 0);
 
 	pthread_cleanup_pop(1);
+	pthread_attr_destroy(&io_err_stat_attr);
 
 	if (ret) {
 		io_err_stat_log(0, "cannot create io_error statistic thread");
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 0c300c8..84beb7f 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -31,7 +31,7 @@
  *   The new version inherits the previous ones.
  */
 
-LIBMULTIPATH_2.0.0 {
+LIBMULTIPATH_3.0.0 {
 global:
 	/* symbols referenced by multipath and multipathd */
 	add_foreign;
@@ -121,7 +121,6 @@ global:
 	init_checkers;
 	init_foreign;
 	init_prio;
-	io_err_stat_attr;
 	io_err_stat_handle_pathfail;
 	is_path_valid;
 	is_quote;
@@ -242,30 +241,24 @@ global:
 	free_scandir_result;
 	sysfs_attr_get_value;
 
-local:
-	*;
-};
-
-LIBMULTIPATH_2.1.0 {
-global:
+	/* added in 2.1.0 */
 	libmp_dm_task_run;
 	cleanup_mutex;
-} LIBMULTIPATH_2.0.0;
 
-LIBMULTIPATH_2.2.0 {
-global:
+	/* added in 2.2.0 */
 	libmp_get_multipath_config;
 	get_multipath_config;
 	libmp_put_multipath_config;
 	put_multipath_config;
 	init_config;
 	uninit_config;
-} LIBMULTIPATH_2.1.0;
 
-LIBMULTIPATH_2.3.0 {
-global:
+	/* added in 2.3.0 */
 	udev;
 	logsink;
 	libmultipath_init;
 	libmultipath_exit;
-} LIBMULTIPATH_2.2.0;
+
+local:
+	*;
+};
diff --git a/multipathd/main.c b/multipathd/main.c
index be1b5ae..4d714e8 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2954,7 +2954,6 @@ child (__attribute__((unused)) void *param)
 	setup_thread_attr(&misc_attr, 64 * 1024, 0);
 	setup_thread_attr(&uevent_attr, DEFAULT_UEVENT_STACKSIZE * 1024, 0);
 	setup_thread_attr(&waiter_attr, 32 * 1024, 1);
-	setup_thread_attr(&io_err_stat_attr, 32 * 1024, 0);
 
 	if (logsink == 1) {
 		setup_thread_attr(&log_attr, 64 * 1024, 0);
@@ -3164,7 +3163,6 @@ child (__attribute__((unused)) void *param)
 	rcu_assign_pointer(multipath_conf, NULL);
 	call_rcu(&conf->rcu, rcu_free_config);
 	pthread_attr_destroy(&waiter_attr);
-	pthread_attr_destroy(&io_err_stat_attr);
 #ifdef _DEBUG_
 	dbg_free_final(NULL);
 #endif
-- 
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

