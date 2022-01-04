Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB101C433F5
	for <dm-devel@archiver.kernel.org>; Tue,  4 Jan 2022 18:34:54 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-235-k7_11NYtPsq5sznFCd_z2A-1; Tue, 04 Jan 2022 13:34:52 -0500
X-MC-Unique: k7_11NYtPsq5sznFCd_z2A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37FFF18C89CF;
	Tue,  4 Jan 2022 18:34:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9516C34D50;
	Tue,  4 Jan 2022 18:34:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 834B94BB7C;
	Tue,  4 Jan 2022 18:34:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 204IYd10011895 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 4 Jan 2022 13:34:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EB61A1410F3B; Tue,  4 Jan 2022 18:34:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E6F43140EBFE
	for <dm-devel@redhat.com>; Tue,  4 Jan 2022 18:34:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD24B10184A5
	for <dm-devel@redhat.com>; Tue,  4 Jan 2022 18:34:38 +0000 (UTC)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com
	[209.85.221.45]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-121-KAUpaNGmOGmqHHqNtWqu9Q-1; Tue, 04 Jan 2022 13:34:34 -0500
X-MC-Unique: KAUpaNGmOGmqHHqNtWqu9Q-1
Received: by mail-wr1-f45.google.com with SMTP id v7so77853492wrv.12;
	Tue, 04 Jan 2022 10:34:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=Ad5/72t7lbZ3cp1vRKy77TwSOFcBvCb7eprv+uyFrOQ=;
	b=comz/DTnhHY3JfvZX2O5SOq2qn2H5k1HTsDeBy6FCGQowB0snx0NEMd6TW5znxl/wW
	/imYLqVa6bwDMnDlgTeYLe65qAoriJwwawH56IiBE3rb08b8Y6Q8wKrYTk4OVp+uvR+/
	v0ItX1Xozc2dsXYt1xWIO8esMD45Sz8IQGAxGQfxIF0vZXjs9rF0qtusoyjjF7uFubqV
	bueK8GHNPAiz+TjriGItIAd3mNx/c5XigftRunCm7Tlt1jUP+eVkvC2Jn+pyfqmC4CwC
	kyEuc9GBTdCaBVf/MlyrHOb2HAUw35nPwkRVNM5LHFUxUe9Uc6xxU99dZtLdczzmU+Qx
	xLaQ==
X-Gm-Message-State: AOAM532sCwIMXtDMEdcrFA32anJsp/2RQmDJrAoUQDGvY/tYC9Yls5xm
	tSyisdJ0DfPxGAGiXZjtzQ==
X-Google-Smtp-Source: ABdhPJxQpFFy/RULMEycFGwrY6G0rLKWuZsoz8JLuKFcI+zwwJf9U7qKj9IZgifJIqBumeUNepGhBA==
X-Received: by 2002:a5d:58ef:: with SMTP id f15mr43202598wrd.108.1641321272797;
	Tue, 04 Jan 2022 10:34:32 -0800 (PST)
Received: from localhost (220.red-81-32-171.dynamicip.rima-tde.net.
	[81.32.171.220])
	by smtp.gmail.com with ESMTPSA id i8sm204364wmq.4.2022.01.04.10.34.32
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 04 Jan 2022 10:34:32 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Tue,  4 Jan 2022 19:34:28 +0100
Message-Id: <20220104183428.19189-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
	DM-DEVEL ML <dm-devel@redhat.com>
Subject: [dm-devel] [PATCH] multipath-tools: remove duplicate headers
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
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

Minimal clean up done with scripts/checkincludes.pl

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
./libdmmp/libdmmp.c: stdbool.h is included more than once.
./libmpathpersist/mpath_pr_ioctl.c: unistd.h is included more than once.
./libmultipath/alias.c: errno.h is included more than once.
./libmultipath/alias.c: stdlib.h is included more than once.
./libmultipath/alias.c: util.h is included more than once.
./libmultipath/checkers/directio.c: unistd.h is included more than once.
./libmultipath/checkers/tur.c: ../libmultipath/util.h is included more than once.
./libmultipath/print.c: string.h is included more than once.
./libmultipath/uevent.c: errno.h is included more than once.
./multipath/main.c: alias.h is included more than once.
./multipathd/main.c: uevent.h is included more than once.
./multipathd/main.c: wwids.h is included more than once.
./tests/strbuf.c: stdbool.h is included more than once.
---
 libdmmp/libdmmp.c                | 1 -
 libmpathpersist/mpath_pr_ioctl.c | 1 -
 libmultipath/alias.c             | 3 ---
 libmultipath/checkers/directio.c | 1 -
 libmultipath/checkers/tur.c      | 1 -
 libmultipath/print.c             | 1 -
 libmultipath/uevent.c            | 1 -
 multipath/main.c                 | 1 -
 multipathd/main.c                | 2 --
 tests/strbuf.c                   | 1 -
 10 files changed, 13 deletions(-)

diff --git a/libdmmp/libdmmp.c b/libdmmp/libdmmp.c
index 51f1d8fc..0025e66d 100644
--- a/libdmmp/libdmmp.c
+++ b/libdmmp/libdmmp.c
@@ -26,7 +26,6 @@
 #include <libudev.h>
 #include <errno.h>
 #include <libdevmapper.h>
-#include <stdbool.h>
 #include <unistd.h>
 #include <assert.h>
 #include <json.h>
diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index 17c52848..093ec71b 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -10,7 +10,6 @@
 #include <unistd.h>
 #include <string.h>
 #include <sys/ioctl.h>
-#include <unistd.h>
 #include <libudev.h>
 #include "mpath_pr_ioctl.h"
 #include "mpath_persist.h"
diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index 87c33afc..548a1184 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -4,7 +4,6 @@
  */
 #include <stdlib.h>
 #include <errno.h>
-#include <stdlib.h>
 #include <unistd.h>
 #include <string.h>
 #include <limits.h>
@@ -19,8 +18,6 @@
 #include "checkers.h"
 #include "structs.h"
 #include "config.h"
-#include "util.h"
-#include "errno.h"
 #include "devmapper.h"
 #include "strbuf.h"
 
diff --git a/libmultipath/checkers/directio.c b/libmultipath/checkers/directio.c
index 28b0cf51..bc7b7be5 100644
--- a/libmultipath/checkers/directio.c
+++ b/libmultipath/checkers/directio.c
@@ -12,7 +12,6 @@
 #include <sys/ioctl.h>
 #include <linux/fs.h>
 #include <errno.h>
-#include <unistd.h>
 #include <libaio.h>
 
 #include "checkers.h"
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index a4b4a213..c93e4625 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -23,7 +23,6 @@
 #include "../libmultipath/sg_include.h"
 #include "../libmultipath/util.h"
 #include "../libmultipath/time-util.h"
-#include "../libmultipath/util.h"
 
 #define TUR_CMD_LEN 6
 #define HEAVY_CHECK_COUNT       10
diff --git a/libmultipath/print.c b/libmultipath/print.c
index c93fffd4..ef4e05d2 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -8,7 +8,6 @@
 #include <sys/stat.h>
 #include <dirent.h>
 #include <unistd.h>
-#include <string.h>
 #include <errno.h>
 #include <assert.h>
 #include <libudev.h>
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index b1f00b3e..29e25572 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -41,7 +41,6 @@
 #include <sys/mman.h>
 #include <sys/time.h>
 #include <libudev.h>
-#include <errno.h>
 
 #include "debug.h"
 #include "list.h"
diff --git a/multipath/main.c b/multipath/main.c
index 0a9377e5..d09f62db 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -63,7 +63,6 @@
 #include "time-util.h"
 #include "file.h"
 #include "valid.h"
-#include "alias.h"
 
 /*
  * Return values of configure(), check_path_valid(), and main().
diff --git a/multipathd/main.c b/multipathd/main.c
index 4d611647..c241dad5 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -59,7 +59,6 @@
 #include "prio.h"
 #include "wwids.h"
 #include "pgpolicies.h"
-#include "uevent.h"
 #include "log.h"
 #include "uxsock.h"
 #include "alias.h"
@@ -80,7 +79,6 @@
 #include "waiter.h"
 #include "dmevents.h"
 #include "io_err_stat.h"
-#include "wwids.h"
 #include "foreign.h"
 #include "../third-party/valgrind/drd.h"
 #include "init_unwinder.h"
diff --git a/tests/strbuf.c b/tests/strbuf.c
index 43a477db..f8554da5 100644
--- a/tests/strbuf.c
+++ b/tests/strbuf.c
@@ -9,7 +9,6 @@
 #include <stddef.h>
 #include <setjmp.h>
 #include <stdlib.h>
-#include <stdbool.h>
 #include <cmocka.h>
 #include <errno.h>
 #include "strbuf.h"
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

