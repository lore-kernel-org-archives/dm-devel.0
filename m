Return-Path: <SRS0=XDEt=G7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF317C433DB
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 20:52:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 297A864DE7
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 20:52:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 297A864DE7
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-YYyX2nurOum3xojP89HSJw-1; Thu, 28 Jan 2021 15:52:08 -0500
X-MC-Unique: YYyX2nurOum3xojP89HSJw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CEF1719251A2;
	Thu, 28 Jan 2021 20:52:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A579860CF1;
	Thu, 28 Jan 2021 20:52:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1C3C91809CA1;
	Thu, 28 Jan 2021 20:52:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10SKl5Xu014971 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 15:47:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2E14E10D16B5; Thu, 28 Jan 2021 20:47:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 27D0710D16B6
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 20:47:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BFC1D805BD9
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 20:47:02 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-531-1Gcs1jMMPoCDSiYeT-6ltw-1;
	Thu, 28 Jan 2021 15:46:00 -0500
X-MC-Unique: 1Gcs1jMMPoCDSiYeT-6ltw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 3CD4CAF99;
	Thu, 28 Jan 2021 20:45:59 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 28 Jan 2021 21:45:44 +0100
Message-Id: <20210128204544.18563-4-mwilck@suse.com>
In-Reply-To: <20210128204544.18563-1-mwilck@suse.com>
References: <20210128204544.18563-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10SKl5Xu014971
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 3/3] multipathd: add code to initalize unwinder
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

glibc's implementation of pthread_cancel() loads symbols from
libgcc_s.so using dlopen() when pthread_cancel() is called
for the first time. This happens even with LD_BIND_NOW=1.
This may imply the need for file system access when a thread is
cancelled, which in the case of multipath-tools might be in a
dangerous situation where multipathd must avoid blocking.

Call load_unwinder() during startup to make sure the dynamic
linker has all necessary symbols resolved early on.

This implementation simply creates a dummy thread and cancels
it. This way all necessary symbols for thread cancellation
will be loaded, no matter what the C library needs to implement
cancellation.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/Makefile        |  2 +-
 multipathd/init_unwinder.c | 34 ++++++++++++++++++++++++++++++++++
 multipathd/init_unwinder.h | 21 +++++++++++++++++++++
 multipathd/main.c          |  2 ++
 4 files changed, 58 insertions(+), 1 deletion(-)
 create mode 100644 multipathd/init_unwinder.c
 create mode 100644 multipathd/init_unwinder.h

diff --git a/multipathd/Makefile b/multipathd/Makefile
index 632b82b..d053c1e 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -30,7 +30,7 @@ ifeq ($(ENABLE_DMEVENTS_POLL),0)
 endif
 
 OBJS = main.o pidfile.o uxlsnr.o uxclnt.o cli.o cli_handlers.o waiter.o \
-       dmevents.o
+       dmevents.o init_unwinder.o
 
 EXEC = multipathd
 
diff --git a/multipathd/init_unwinder.c b/multipathd/init_unwinder.c
new file mode 100644
index 0000000..14467f3
--- /dev/null
+++ b/multipathd/init_unwinder.c
@@ -0,0 +1,34 @@
+#include <pthread.h>
+#include <unistd.h>
+#include "init_unwinder.h"
+
+static pthread_mutex_t dummy_mtx = PTHREAD_MUTEX_INITIALIZER;
+static pthread_cond_t dummy_cond = PTHREAD_COND_INITIALIZER;
+
+static void *dummy_thread(void *arg __attribute__((unused)))
+{
+	pthread_mutex_lock(&dummy_mtx);
+	pthread_cond_broadcast(&dummy_cond);
+	pthread_mutex_unlock(&dummy_mtx);
+	pause();
+	return NULL;
+}
+
+int init_unwinder(void)
+{
+	pthread_t dummy;
+	int rc;
+
+	pthread_mutex_lock(&dummy_mtx);
+
+	rc = pthread_create(&dummy, NULL, dummy_thread, NULL);
+	if (rc != 0) {
+		pthread_mutex_unlock(&dummy_mtx);
+		return rc;
+	}
+
+	pthread_cond_wait(&dummy_cond, &dummy_mtx);
+	pthread_mutex_unlock(&dummy_mtx);
+
+	return pthread_cancel(dummy);
+}
diff --git a/multipathd/init_unwinder.h b/multipathd/init_unwinder.h
new file mode 100644
index 0000000..ada09f8
--- /dev/null
+++ b/multipathd/init_unwinder.h
@@ -0,0 +1,21 @@
+#ifndef _INIT_UNWINDER_H
+#define _INIT_UNWINDER_H 1
+
+/*
+ * init_unwinder(): make sure unwinder symbols are loaded
+ *
+ * libc's implementation of pthread_cancel() loads symbols from
+ * libgcc_s.so using dlopen() when pthread_cancel() is called
+ * for the first time. This happens even with LD_BIND_NOW=1.
+ * This may imply the need for file system access when a thread is
+ * cancelled, which in the case of multipath-tools might be in a
+ * dangerous situation where multipathd must avoid blocking.
+ *
+ * Call load_unwinder() during startup to make sure the dynamic
+ * linker has all necessary symbols resolved early on.
+ *
+ * Return: 0 if successful, an error number otherwise.
+ */
+int init_unwinder(void);
+
+#endif
diff --git a/multipathd/main.c b/multipathd/main.c
index 99a89a6..6f851ae 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -83,6 +83,7 @@
 #include "wwids.h"
 #include "foreign.h"
 #include "../third-party/valgrind/drd.h"
+#include "init_unwinder.h"
 
 #define FILE_NAME_SIZE 256
 #define CMDSIZE 160
@@ -3041,6 +3042,7 @@ child (__attribute__((unused)) void *param)
 	enum daemon_status state;
 	int exit_code = 1;
 
+	init_unwinder();
 	mlockall(MCL_CURRENT | MCL_FUTURE);
 	signal_init();
 	mp_rcu_data = setup_rcu();
-- 
2.29.2


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

