Return-Path: <SRS0=NZHG=FV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7431AC4361B
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 11:00:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D17262389B
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 11:00:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D17262389B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-UJKRMcXsPjS2CgxnSy2_Zw-1; Thu, 17 Dec 2020 06:00:50 -0500
X-MC-Unique: UJKRMcXsPjS2CgxnSy2_Zw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B524D801B2D;
	Thu, 17 Dec 2020 11:00:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2BAC460C89;
	Thu, 17 Dec 2020 11:00:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B8BFC180954D;
	Thu, 17 Dec 2020 11:00:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BHB0dES030234 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Dec 2020 06:00:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B4555D7B3C; Thu, 17 Dec 2020 11:00:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ACE7DD7E0D
	for <dm-devel@redhat.com>; Thu, 17 Dec 2020 11:00:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2AA4E858EEC
	for <dm-devel@redhat.com>; Thu, 17 Dec 2020 11:00:37 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-557-15hoDqgcMIiW5ISJGBWPfA-1;
	Thu, 17 Dec 2020 06:00:34 -0500
X-MC-Unique: 15hoDqgcMIiW5ISJGBWPfA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id E4891AC90;
	Thu, 17 Dec 2020 11:00:32 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 17 Dec 2020 12:00:12 +0100
Message-Id: <20201217110018.3347-2-mwilck@suse.com>
In-Reply-To: <20201217110018.3347-1-mwilck@suse.com>
References: <20201217110018.3347-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BHB0dES030234
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 1/7] libmultipath: move logq_lock handling to
	log.c
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

logq_lock protects internal data structures of log.c, and should
be handled there. This patch doesn't change functionality, except
improving cancel-safety somewhat.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/log.c         | 34 ++++++++++++++++++++++++++++++++--
 libmultipath/log_pthread.c |  9 ---------
 2 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/libmultipath/log.c b/libmultipath/log.c
index debd36d..7f33787 100644
--- a/libmultipath/log.c
+++ b/libmultipath/log.c
@@ -9,13 +9,16 @@
 #include <string.h>
 #include <syslog.h>
 #include <time.h>
+#include <pthread.h>
 
 #include "memory.h"
 #include "log.h"
+#include "util.h"
 
 #define ALIGN(len, s) (((len)+(s)-1)/(s)*(s))
 
 struct logarea* la;
+static pthread_mutex_t logq_lock = PTHREAD_MUTEX_INITIALIZER;
 
 #if LOGDBG
 static void dump_logarea (void)
@@ -101,12 +104,17 @@ void log_close (void)
 
 void log_reset (char *program_name)
 {
+	pthread_mutex_lock(&logq_lock);
+	pthread_cleanup_push(cleanup_mutex, &logq_lock);
+
 	closelog();
 	tzset();
 	openlog(program_name, 0, LOG_DAEMON);
+
+	pthread_cleanup_pop(1);
 }
 
-int log_enqueue (int prio, const char * fmt, va_list ap)
+static int _log_enqueue(int prio, const char * fmt, va_list ap)
 {
 	int len, fwd;
 	char buff[MAX_MSG_SIZE];
@@ -165,7 +173,18 @@ int log_enqueue (int prio, const char * fmt, va_list ap)
 	return 0;
 }
 
-int log_dequeue (void * buff)
+int log_enqueue(int prio, const char *fmt, va_list ap)
+{
+	int ret;
+
+	pthread_mutex_lock(&logq_lock);
+	pthread_cleanup_push(cleanup_mutex, &logq_lock);
+	ret = _log_enqueue(prio, fmt, ap);
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+static int _log_dequeue(void *buff)
 {
 	struct logmsg * src = (struct logmsg *)la->head;
 	struct logmsg * dst = (struct logmsg *)buff;
@@ -194,6 +213,17 @@ int log_dequeue (void * buff)
 	return 0;
 }
 
+int log_dequeue(void *buff)
+{
+	int ret;
+
+	pthread_mutex_lock(&logq_lock);
+	pthread_cleanup_push(cleanup_mutex, &logq_lock);
+	ret = _log_dequeue(buff);
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
 /*
  * this one can block under memory pressure
  */
diff --git a/libmultipath/log_pthread.c b/libmultipath/log_pthread.c
index 0d48c52..6599210 100644
--- a/libmultipath/log_pthread.c
+++ b/libmultipath/log_pthread.c
@@ -18,7 +18,6 @@
 static pthread_t log_thr;
 
 /* logev_lock must not be taken with logq_lock held */
-static pthread_mutex_t logq_lock = PTHREAD_MUTEX_INITIALIZER;
 static pthread_mutex_t logev_lock = PTHREAD_MUTEX_INITIALIZER;
 static pthread_cond_t logev_cond = PTHREAD_COND_INITIALIZER;
 
@@ -41,10 +40,7 @@ void log_safe (int prio, const char * fmt, va_list ap)
 	running = logq_running;
 
 	if (running) {
-		pthread_mutex_lock(&logq_lock);
-		pthread_cleanup_push(cleanup_mutex, &logq_lock);
 		log_enqueue(prio, fmt, ap);
-		pthread_cleanup_pop(1);
 
 		log_messages_pending = 1;
 		pthread_cond_signal(&logev_cond);
@@ -60,9 +56,7 @@ static void flush_logqueue (void)
 	int empty;
 
 	do {
-		pthread_mutex_lock(&logq_lock);
 		empty = log_dequeue(la->buff);
-		pthread_mutex_unlock(&logq_lock);
 		if (!empty)
 			log_syslog(la->buff);
 	} while (empty == 0);
@@ -138,10 +132,7 @@ void log_thread_start (pthread_attr_t *attr)
 void log_thread_reset (void)
 {
 	logdbg(stderr,"resetting log\n");
-
-	pthread_mutex_lock(&logq_lock);
 	log_reset("multipathd");
-	pthread_mutex_unlock(&logq_lock);
 }
 
 void log_thread_stop (void)
-- 
2.29.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

