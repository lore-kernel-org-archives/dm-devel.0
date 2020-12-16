Return-Path: <SRS0=g9U1=FU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D674C4361B
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 18:20:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BBCEE25CFA
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 18:20:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BBCEE25CFA
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-bxz4NizfMD2FhWC-3eeyrg-1; Wed, 16 Dec 2020 13:19:21 -0500
X-MC-Unique: bxz4NizfMD2FhWC-3eeyrg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73087814501;
	Wed, 16 Dec 2020 18:19:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 573C718770;
	Wed, 16 Dec 2020 18:19:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2CD6D1809CAD;
	Wed, 16 Dec 2020 18:19:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BGIIfAB018114 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Dec 2020 13:18:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EFDEF2026D5D; Wed, 16 Dec 2020 18:18:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EB24A2026D48
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 18:18:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7250800183
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 18:18:40 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-100-LFSbPNLMN-eXGZxez8FXhg-1;
	Wed, 16 Dec 2020 13:18:36 -0500
X-MC-Unique: LFSbPNLMN-eXGZxez8FXhg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id ED392B1A1;
	Wed, 16 Dec 2020 18:18:34 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 16 Dec 2020 19:17:04 +0100
Message-Id: <20201216181708.22224-26-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BGIIfAB018114
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 25/29] libmultipath: introduce symbolic values
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
 libmultipath/debug.h     |  6 ++++++
 libmultipath/devmapper.c |  4 ++--
 multipath/main.c         |  4 ++--
 multipathd/main.c        | 17 ++++++++---------
 tests/globals.c          |  3 ++-
 tests/hwtable.c          |  2 +-
 7 files changed, 23 insertions(+), 17 deletions(-)

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
index 1f3bc8b..b6ce70a 100644
--- a/libmultipath/debug.h
+++ b/libmultipath/debug.h
@@ -12,3 +12,9 @@ extern int libmp_verbosity;
 
 #define condlog(prio, fmt, args...) \
 	dlog(logsink, prio, fmt "\n", ##args)
+
+enum {
+	LOGSINK_STDERR_WITH_TIME = 0,
+	LOGSINK_STDERR_WITHOUT_TIME = -1,
+	LOGSINK_SYSLOG = 1,
+};
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index dfe95d2..f8b180e 100644
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
index 371be2a..c94bb26 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -816,7 +816,7 @@ main (int argc, char *argv[])
 	libmultipath_init();
 	if (atexit(dm_lib_exit) || atexit(libmultipath_exit))
 		condlog(1, "failed to register cleanup handler for libmultipath: %m");
-	logsink = 0;
+	logsink = LOGSINK_STDERR_WITH_TIME;
 	if (init_config(DEFAULT_CONFIGFILE))
 		exit(RTVL_FAIL);
 	if (atexit(uninit_config))
@@ -967,7 +967,7 @@ main (int argc, char *argv[])
 	if (dev_type == DEV_UEVENT) {
 		openlog("multipath", 0, LOG_DAEMON);
 		setlogmask(LOG_UPTO(libmp_verbosity + 3));
-		logsink = 1;
+		logsink = LOGSINK_SYSLOG;
 	}
 
 	set_max_fds(conf->max_fds);
diff --git a/multipathd/main.c b/multipathd/main.c
index ba25751..867f0f8 100644
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
@@ -3033,7 +3033,7 @@ static void cleanup_child(void)
 		cleanup_dmevent_waiter();
 
 	cleanup_pidfile();
-	if (logsink == 1)
+	if (logsink == LOGSINK_SYSLOG)
 		log_thread_stop();
 
 	cleanup_conf();
@@ -3076,7 +3076,7 @@ child (__attribute__((unused)) void *param)
 	setup_thread_attr(&uevent_attr, DEFAULT_UEVENT_STACKSIZE * 1024, 0);
 	setup_thread_attr(&waiter_attr, 32 * 1024, 1);
 
-	if (logsink == 1) {
+	if (logsink == LOGSINK_SYSLOG) {
 		setup_thread_attr(&log_attr, 64 * 1024, 0);
 		log_thread_start(&log_attr);
 		pthread_attr_destroy(&log_attr);
@@ -3307,7 +3307,7 @@ main (int argc, char *argv[])
 	ANNOTATE_BENIGN_RACE_SIZED(&uxsock_timeout, sizeof(uxsock_timeout),
 		"Suppress complaints about this scalar variable");
 
-	logsink = 1;
+	logsink = LOGSINK_SYSLOG;
 
 	if (getuid() != 0) {
 		fprintf(stderr, "need to be root\n");
@@ -3334,9 +3334,8 @@ main (int argc, char *argv[])
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
@@ -3346,7 +3345,7 @@ main (int argc, char *argv[])
 			libmp_verbosity = verbosity = atoi(optarg);
 			break;
 		case 's':
-			logsink = -1;
+			logsink = LOGSINK_STDERR_WITHOUT_TIME;
 			break;
 		case 'k':
 			logsink = 0;
@@ -3379,7 +3378,7 @@ main (int argc, char *argv[])
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
2.29.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

