Return-Path: <SRS0=NZHG=FV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 818B8C2BB48
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 11:00:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E6B202389E
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 11:00:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E6B202389E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-qZkUty35N4CUefN3JDvhoQ-1; Thu, 17 Dec 2020 06:00:50 -0500
X-MC-Unique: qZkUty35N4CUefN3JDvhoQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD781801B36;
	Thu, 17 Dec 2020 11:00:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1832110013C0;
	Thu, 17 Dec 2020 11:00:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2F82C4BB7B;
	Thu, 17 Dec 2020 11:00:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BHB0f8T030256 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Dec 2020 06:00:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 685C310F2710; Thu, 17 Dec 2020 11:00:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 648A410F2715
	for <dm-devel@redhat.com>; Thu, 17 Dec 2020 11:00:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE84B8001B8
	for <dm-devel@redhat.com>; Thu, 17 Dec 2020 11:00:38 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-595-02gHmHmcPQu3yUbdimCPxA-1;
	Thu, 17 Dec 2020 06:00:34 -0500
X-MC-Unique: 02gHmHmcPQu3yUbdimCPxA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 2CED0AD0B;
	Thu, 17 Dec 2020 11:00:33 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 17 Dec 2020 12:00:13 +0100
Message-Id: <20201217110018.3347-3-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BHB0f8T030256
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 2/7] libmultipath: protect logarea with logq_lock
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Make sure the global logarea (la) is only allocated and freed
hile holding logq_lock. This avoids invalid memory access.

This patch makes free_logarea() static. libmultipath.version
is unchanged, as free_logarea() wasn't exported anyway.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/log.c | 32 +++++++++++++++++++++++---------
 libmultipath/log.h |  1 -
 2 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/libmultipath/log.c b/libmultipath/log.c
index 7f33787..95c8f01 100644
--- a/libmultipath/log.c
+++ b/libmultipath/log.c
@@ -77,16 +77,23 @@ static int logarea_init (int size)
 
 int log_init(char *program_name, int size)
 {
+	int ret = 1;
+
 	logdbg(stderr,"enter log_init\n");
+
+	pthread_mutex_lock(&logq_lock);
+	pthread_cleanup_push(cleanup_mutex, &logq_lock);
+
 	openlog(program_name, 0, LOG_DAEMON);
+	if (!la)
+		ret = logarea_init(size);
 
-	if (logarea_init(size))
-		return 1;
+	pthread_cleanup_pop(1);
 
-	return 0;
+	return ret;
 }
 
-void free_logarea (void)
+static void free_logarea (void)
 {
 	FREE(la->start);
 	FREE(la->buff);
@@ -96,9 +103,14 @@ void free_logarea (void)
 
 void log_close (void)
 {
-	free_logarea();
+	pthread_mutex_lock(&logq_lock);
+	pthread_cleanup_push(cleanup_mutex, &logq_lock);
+
+	if (la)
+		free_logarea();
 	closelog();
 
+	pthread_cleanup_pop(1);
 	return;
 }
 
@@ -175,11 +187,12 @@ static int _log_enqueue(int prio, const char * fmt, va_list ap)
 
 int log_enqueue(int prio, const char *fmt, va_list ap)
 {
-	int ret;
+	int ret = 1;
 
 	pthread_mutex_lock(&logq_lock);
 	pthread_cleanup_push(cleanup_mutex, &logq_lock);
-	ret = _log_enqueue(prio, fmt, ap);
+	if (la)
+		ret = _log_enqueue(prio, fmt, ap);
 	pthread_cleanup_pop(1);
 	return ret;
 }
@@ -215,11 +228,12 @@ static int _log_dequeue(void *buff)
 
 int log_dequeue(void *buff)
 {
-	int ret;
+	int ret = 1;
 
 	pthread_mutex_lock(&logq_lock);
 	pthread_cleanup_push(cleanup_mutex, &logq_lock);
-	ret = _log_dequeue(buff);
+	if (la)
+		ret = _log_dequeue(buff);
 	pthread_cleanup_pop(1);
 	return ret;
 }
diff --git a/libmultipath/log.h b/libmultipath/log.h
index d2448f6..fa224e4 100644
--- a/libmultipath/log.h
+++ b/libmultipath/log.h
@@ -39,6 +39,5 @@ int log_enqueue (int prio, const char * fmt, va_list ap)
 int log_dequeue (void *);
 void log_syslog (void *);
 void dump_logmsg (void *);
-void free_logarea (void);
 
 #endif /* LOG_H */
-- 
2.29.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

