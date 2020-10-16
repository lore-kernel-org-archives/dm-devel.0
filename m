Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82615C4363D
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:45:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E13A0207F7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:45:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E13A0207F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-k1rDMSSDP-WbhD4byq7v3g-1; Fri, 16 Oct 2020 06:45:47 -0400
X-MC-Unique: k1rDMSSDP-WbhD4byq7v3g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4BC81084D71;
	Fri, 16 Oct 2020 10:45:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CA3EA5D9F3;
	Fri, 16 Oct 2020 10:45:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A3E8558134;
	Fri, 16 Oct 2020 10:45:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GAjMIT020794 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 06:45:22 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id F3B662166B28; Fri, 16 Oct 2020 10:45:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EC9F42156A37
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:45:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2804101A56A
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:45:21 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-194-eYVs35HPMQe2PlDf4PDUKQ-1;
	Fri, 16 Oct 2020 06:45:19 -0400
X-MC-Unique: eYVs35HPMQe2PlDf4PDUKQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 86652AF58;
	Fri, 16 Oct 2020 10:45:17 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 16 Oct 2020 12:44:57 +0200
Message-Id: <20201016104501.8700-26-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09GAjMIT020794
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 25/29] libmultipath: introduce symbolic values
	for logsink
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/debug.c     |  4 ++--
 libmultipath/debug.h     |  7 +++++++
 libmultipath/devmapper.c |  4 ++--
 multipath/main.c         |  4 ++--
 multipathd/main.c        | 17 ++++++++---------
 tests/globals.c          |  3 ++-
 tests/hwtable.c          |  2 +-
 7 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/libmultipath/debug.c b/libmultipath/debug.c
index a1713b9..f9b7755 100644
--- a/libmultipath/debug.c
+++ b/libmultipath/debug.c
@@ -25,8 +25,8 @@ void dlog (int sink, int prio, const char * fmt, ...)
 	va_start(ap, fmt);
 
 	if (prio <= libmp_verbosity) {
-		if (sink < 1) {
-			if (sink == 0) {
+		if (sink != LOGSINK_SYSLOG) {
+			if (sink == LOGSINK_STDERR_WITH_TIME) {
 				time_t t = time(NULL);
 				struct tm *tb = localtime(&t);
 				char buff[16];
diff --git a/libmultipath/debug.h b/libmultipath/debug.h
index 1f3bc8b..91ba02b 100644
--- a/libmultipath/debug.h
+++ b/libmultipath/debug.h
@@ -12,3 +12,10 @@ extern int libmp_verbosity;
 
 #define condlog(prio, fmt, args...) \
 	dlog(logsink, prio, fmt "\n", ##args)
+
+enum {
+	LOGSINK_STDERR_WITH_TIME = 0,
+	LOGSINK_STDERR_WITHOUT_TIME = -1,
+	LOGSINK_SYSLOG = 1,
+};
+
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index a8e0611..78112a9 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -104,8 +104,8 @@ dm_write_log (int level, const char *file, int line, const char *f, ...)
 		return;
 
 	va_start(ap, f);
-	if (logsink < 1) {
-		if (logsink == 0) {
+	if (logsink != LOGSINK_SYSLOG) {
+		if (logsink == LOGSINK_STDERR_WITH_TIME) {
 			time_t t = time(NULL);
 			struct tm *tb = localtime(&t);
 			char buff[16];
diff --git a/multipath/main.c b/multipath/main.c
index 9bdc5d2..46cfa17 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -840,7 +840,7 @@ main (int argc, char *argv[])
 	libmultipath_init();
 	if (atexit(dm_lib_exit) || atexit(libmultipath_exit))
 		condlog(1, "failed to register cleanup handler for libmultipath: %m");
-	logsink = 0;
+	logsink = LOGSINK_STDERR_WITH_TIME;
 	if (init_config(DEFAULT_CONFIGFILE))
 		exit(RTVL_FAIL);
 	if (atexit(uninit_config))
@@ -991,7 +991,7 @@ main (int argc, char *argv[])
 	if (dev_type == DEV_UEVENT) {
 		openlog("multipath", 0, LOG_DAEMON);
 		setlogmask(LOG_UPTO(libmp_verbosity + 3));
-		logsink = 1;
+		logsink = LOGSINK_SYSLOG;
 	}
 
 	set_max_fds(conf->max_fds);
diff --git a/multipathd/main.c b/multipathd/main.c
index fbd354c..725a10b 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2780,7 +2780,7 @@ handle_signals(bool nonfatal)
 	}
 	if (log_reset_sig) {
 		condlog(2, "reset log (signal)");
-		if (logsink == 1)
+		if (logsink == LOGSINK_SYSLOG)
 			log_thread_reset();
 	}
 	reconfig_sig = 0;
@@ -3032,7 +3032,7 @@ static void cleanup_child(void)
 		cleanup_dmevent_waiter();
 
 	cleanup_pidfile();
-	if (logsink == 1)
+	if (logsink == LOGSINK_SYSLOG)
 		log_thread_stop();
 
 	cleanup_conf();
@@ -3078,7 +3078,7 @@ child (__attribute__((unused)) void *param)
 	setup_thread_attr(&uevent_attr, DEFAULT_UEVENT_STACKSIZE * 1024, 0);
 	setup_thread_attr(&waiter_attr, 32 * 1024, 1);
 
-	if (logsink == 1) {
+	if (logsink == LOGSINK_SYSLOG) {
 		setup_thread_attr(&log_attr, 64 * 1024, 0);
 		log_thread_start(&log_attr);
 		pthread_attr_destroy(&log_attr);
@@ -3309,7 +3309,7 @@ main (int argc, char *argv[])
 	ANNOTATE_BENIGN_RACE_SIZED(&uxsock_timeout, sizeof(uxsock_timeout),
 		"Suppress complaints about this scalar variable");
 
-	logsink = 1;
+	logsink = LOGSINK_SYSLOG;
 
 	if (getuid() != 0) {
 		fprintf(stderr, "need to be root\n");
@@ -3336,9 +3336,8 @@ main (int argc, char *argv[])
 		switch(arg) {
 		case 'd':
 			foreground = 1;
-			if (logsink > 0)
-				logsink = 0;
-			//debug=1; /* ### comment me out ### */
+			if (logsink == LOGSINK_SYSLOG)
+				logsink = LOGSINK_STDERR_WITH_TIME;
 			break;
 		case 'v':
 			if (sizeof(optarg) > sizeof(char *) ||
@@ -3348,7 +3347,7 @@ main (int argc, char *argv[])
 			libmp_verbosity = verbosity = atoi(optarg);
 			break;
 		case 's':
-			logsink = -1;
+			logsink = LOGSINK_STDERR_WITHOUT_TIME;
 			break;
 		case 'k':
 			logsink = 0;
@@ -3381,7 +3380,7 @@ main (int argc, char *argv[])
 		char * s = cmd;
 		char * c = s;
 
-		logsink = 0;
+		logsink = LOGSINK_STDERR_WITH_TIME;
 		if (verbosity)
 			libmp_verbosity = verbosity;
 		conf = load_config(DEFAULT_CONFIGFILE);
diff --git a/tests/globals.c b/tests/globals.c
index 8add5eb..fc0c07a 100644
--- a/tests/globals.c
+++ b/tests/globals.c
@@ -1,9 +1,10 @@
 #include "structs.h"
 #include "config.h"
+#include "debug.h"
 
 /* Required globals */
 struct udev *udev;
-int logsink = -1;
+int logsink = LOGSINK_STDERR_WITHOUT_TIME;
 struct config conf = {
 	.verbosity = 4,
 };
diff --git a/tests/hwtable.c b/tests/hwtable.c
index 57f832b..4dd0873 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -53,7 +53,7 @@ struct hwt_state {
 
 static struct config *_conf;
 struct udev *udev;
-int logsink = -1;
+int logsink = LOGSINK_STDERR_WITHOUT_TIME;
 
 struct config *get_multipath_config(void)
 {
-- 
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

