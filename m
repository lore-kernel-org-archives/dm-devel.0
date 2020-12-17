Return-Path: <SRS0=NZHG=FV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E83C2BB40
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 11:01:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 700602389B
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 11:01:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 700602389B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537-bo-06abOM9aOMlGkT-Hgzw-1; Thu, 17 Dec 2020 06:01:15 -0500
X-MC-Unique: bo-06abOM9aOMlGkT-Hgzw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 91FE71005D44;
	Thu, 17 Dec 2020 11:01:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7035F710DC;
	Thu, 17 Dec 2020 11:01:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0AC181809CA0;
	Thu, 17 Dec 2020 11:01:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BHB0h0h030285 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Dec 2020 06:00:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 81F18D7B3C; Thu, 17 Dec 2020 11:00:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CCD5D7E0F
	for <dm-devel@redhat.com>; Thu, 17 Dec 2020 11:00:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A017185A794
	for <dm-devel@redhat.com>; Thu, 17 Dec 2020 11:00:43 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-402-1BF4hknnPmSRHeA5Ed9xJA-1;
	Thu, 17 Dec 2020 06:00:36 -0500
X-MC-Unique: 1BF4hknnPmSRHeA5Ed9xJA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id C1D0FAD41;
	Thu, 17 Dec 2020 11:00:33 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 17 Dec 2020 12:00:16 +0100
Message-Id: <20201217110018.3347-6-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BHB0h0h030285
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 5/7] multipath-tools: avoid access to
	/etc/localtime
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

If the root file system is multipathed, and IO is queued because all paths
are failed, multipathd may block trying to access the root FS, and thus be
unable to reinstate paths. One file that is frequently accessed is
/etc/localtime. Avoid that by printing monotonic timestamps instead.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/debug.c     | 14 ++++++++------
 libmultipath/devmapper.c | 12 ++++++------
 libmultipath/log.c       |  1 -
 multipathd/main.c        |  3 ---
 4 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/libmultipath/debug.c b/libmultipath/debug.c
index 429f269..510e15e 100644
--- a/libmultipath/debug.c
+++ b/libmultipath/debug.c
@@ -14,6 +14,8 @@
 #include "config.h"
 #include "defaults.h"
 #include "debug.h"
+#include "time-util.h"
+#include "util.h"
 
 int logsink;
 int libmp_verbosity = DEFAULT_VERBOSITY;
@@ -25,13 +27,13 @@ void dlog(int prio, const char * fmt, ...)
 	va_start(ap, fmt);
 	if (logsink != LOGSINK_SYSLOG) {
 		if (logsink == LOGSINK_STDERR_WITH_TIME) {
-			time_t t = time(NULL);
-			struct tm *tb = localtime(&t);
-			char buff[16];
+			struct timespec ts;
+			char buff[32];
 
-			strftime(buff, sizeof(buff),
-				 "%b %d %H:%M:%S", tb);
-			buff[sizeof(buff)-1] = '\0';
+			get_monotonic_time(&ts);
+			safe_sprintf(buff, "%ld.%06ld",
+				     (long)ts.tv_sec,
+				     ts.tv_nsec/1000);
 			fprintf(stderr, "%s | ", buff);
 		}
 		vfprintf(stderr, fmt, ap);
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 4977b31..095cbc0 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -27,6 +27,7 @@
 #include "config.h"
 #include "wwids.h"
 #include "version.h"
+#include "time-util.h"
 
 #include "log_pthread.h"
 #include <sys/types.h>
@@ -106,13 +107,12 @@ dm_write_log (int level, const char *file, int line, const char *f, ...)
 	va_start(ap, f);
 	if (logsink != LOGSINK_SYSLOG) {
 		if (logsink == LOGSINK_STDERR_WITH_TIME) {
-			time_t t = time(NULL);
-			struct tm *tb = localtime(&t);
-			char buff[16];
-
-			strftime(buff, sizeof(buff), "%b %d %H:%M:%S", tb);
-			buff[sizeof(buff)-1] = '\0';
+			struct timespec ts;
+			char buff[32];
 
+			get_monotonic_time(&ts);
+			safe_sprintf(buff, "%ld.%06ld",
+				     (long)ts.tv_sec, ts.tv_nsec/1000);
 			fprintf(stderr, "%s | ", buff);
 		}
 		fprintf(stderr, "libdevmapper: %s(%i): ", file, line);
diff --git a/libmultipath/log.c b/libmultipath/log.c
index 95c8f01..6498c88 100644
--- a/libmultipath/log.c
+++ b/libmultipath/log.c
@@ -120,7 +120,6 @@ void log_reset (char *program_name)
 	pthread_cleanup_push(cleanup_mutex, &logq_lock);
 
 	closelog();
-	tzset();
 	openlog(program_name, 0, LOG_DAEMON);
 
 	pthread_cleanup_pop(1);
diff --git a/multipathd/main.c b/multipathd/main.c
index b6a5f5b..28c147b 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2710,9 +2710,6 @@ reconfigure (struct vectors * vecs)
 	delete_all_foreign();
 
 	reset_checker_classes();
-	/* Re-read any timezone changes */
-	tzset();
-
 	if (bindings_read_only)
 		conf->bindings_read_only = bindings_read_only;
 	check_alias_settings(conf);
-- 
2.29.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

