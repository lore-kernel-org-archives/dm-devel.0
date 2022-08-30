Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0192C0502A
	for <dm-devel@archiver.kernel.org>; Tue, 30 Aug 2022 19:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661887710;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bEbaDg7Ty9aK2zQR6sK31snsI0kkUMiJkzE/0mrYkJA=;
	b=e8Vig+LT/2QGqXyQBfKOJz6C76/b2UL0v/OyVEXFJJA9nIbenbiab5Z56nwht7S49D4e3y
	S8/03uTPPfRj94Hm+GBWIz1b0o7JJXHi0R5lHViBr4qn26y1bHlzUxcjojwjPrIZio0FS6
	5H8GC05n4f3z1aFjpxMWgib1Qc+ys38=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-151-oDVd8MChObOsVgt2j9nDGg-1; Tue, 30 Aug 2022 15:28:27 -0400
X-MC-Unique: oDVd8MChObOsVgt2j9nDGg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 099BD3802BAA;
	Tue, 30 Aug 2022 19:28:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9A050401473;
	Tue, 30 Aug 2022 19:28:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B1A7E1946A5B;
	Tue, 30 Aug 2022 19:28:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2AD9C1946A40
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 Aug 2022 19:28:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1DB061410F37; Tue, 30 Aug 2022 19:28:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 19E8F1410DD5
 for <dm-devel@redhat.com>; Tue, 30 Aug 2022 19:28:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 03BC9823F11
 for <dm-devel@redhat.com>; Tue, 30 Aug 2022 19:28:17 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-284-nR0N_Hl0OQy7g5WDoyI-Kg-1; Tue,
 30 Aug 2022 15:28:14 -0400
X-MC-Unique: nR0N_Hl0OQy7g5WDoyI-Kg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 916961FB23;
 Tue, 30 Aug 2022 19:28:11 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5426913B22;
 Tue, 30 Aug 2022 19:28:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id GLfXEstkDmO5GgAAMHmgww
 (envelope-from <mwilck@suse.com>); Tue, 30 Aug 2022 19:28:11 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Tue, 30 Aug 2022 21:27:07 +0200
Message-Id: <20220830192713.19778-7-mwilck@suse.com>
In-Reply-To: <20220830192713.19778-1-mwilck@suse.com>
References: <20220830192713.19778-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH v4 06/12] libmultipath checkers/prioritizers:
 search for includes in libmultipath
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Set TOPDIR correctly rather than using hard-coded "../".
Also remove duplicate -lmultipath in checkers makefile.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers/Makefile        | 5 +++--
 libmultipath/checkers/directio.c      | 4 ++--
 libmultipath/checkers/emc_clariion.c  | 2 +-
 libmultipath/checkers/hp_sw.c         | 4 ++--
 libmultipath/checkers/rdac.c          | 2 +-
 libmultipath/checkers/tur.c           | 8 ++++----
 libmultipath/foreign/Makefile         | 4 ++--
 libmultipath/prioritizers/Makefile    | 6 ++++--
 libmultipath/prioritizers/alua_rtpg.c | 2 +-
 9 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/libmultipath/checkers/Makefile b/libmultipath/checkers/Makefile
index 8d8e45e..69de1ed 100644
--- a/libmultipath/checkers/Makefile
+++ b/libmultipath/checkers/Makefile
@@ -1,11 +1,12 @@
 #
 # Copyright (C) 2003 Christophe Varoqui, <christophe.varoqui@opensvc.com>
 #
+TOPDIR = ../..
 include ../../Makefile.inc
 
-CPPFLAGS += -I..
+CPPFLAGS += -I$(multipathdir)
 CFLAGS += $(LIB_CFLAGS)
-LDFLAGS += -L.. -lmultipath
+LDFLAGS += -L$(multipathdir)
 LIBDEPS = -lmultipath -laio -lpthread -lrt
 
 # If you add or remove a checker also update multipath/multipath.conf.5
diff --git a/libmultipath/checkers/directio.c b/libmultipath/checkers/directio.c
index a326e37..2f3ece0 100644
--- a/libmultipath/checkers/directio.c
+++ b/libmultipath/checkers/directio.c
@@ -15,8 +15,8 @@
 #include <libaio.h>
 
 #include "checkers.h"
-#include "../libmultipath/debug.h"
-#include "../libmultipath/time-util.h"
+#include "debug.h"
+#include "time-util.h"
 
 #define AIO_GROUP_SIZE 1024
 
diff --git a/libmultipath/checkers/emc_clariion.c b/libmultipath/checkers/emc_clariion.c
index aa636e7..04635b5 100644
--- a/libmultipath/checkers/emc_clariion.c
+++ b/libmultipath/checkers/emc_clariion.c
@@ -11,7 +11,7 @@
 #include <sys/ioctl.h>
 #include <errno.h>
 
-#include "../libmultipath/sg_include.h"
+#include "sg_include.h"
 #include "libsg.h"
 #include "checkers.h"
 #include "debug.h"
diff --git a/libmultipath/checkers/hp_sw.c b/libmultipath/checkers/hp_sw.c
index 915918c..1ab7909 100644
--- a/libmultipath/checkers/hp_sw.c
+++ b/libmultipath/checkers/hp_sw.c
@@ -13,8 +13,8 @@
 
 #include "checkers.h"
 
-#include "../libmultipath/sg_include.h"
-#include "../libmultipath/unaligned.h"
+#include "sg_include.h"
+#include "unaligned.h"
 
 #define TUR_CMD_LEN		6
 #define INQUIRY_CMDLEN		6
diff --git a/libmultipath/checkers/rdac.c b/libmultipath/checkers/rdac.c
index f7aaa30..9a3860f 100644
--- a/libmultipath/checkers/rdac.c
+++ b/libmultipath/checkers/rdac.c
@@ -14,7 +14,7 @@
 #include "checkers.h"
 #include "debug.h"
 
-#include "../libmultipath/sg_include.h"
+#include "sg_include.h"
 
 #define INQUIRY_CMDLEN		6
 #define INQUIRY_CMD		0x12
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 1bcb757..551dc4f 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -19,10 +19,10 @@
 
 #include "checkers.h"
 
-#include "../libmultipath/debug.h"
-#include "../libmultipath/sg_include.h"
-#include "../libmultipath/util.h"
-#include "../libmultipath/time-util.h"
+#include "debug.h"
+#include "sg_include.h"
+#include "util.h"
+#include "time-util.h"
 
 #define TUR_CMD_LEN 6
 #define HEAVY_CHECK_COUNT       10
diff --git a/libmultipath/foreign/Makefile b/libmultipath/foreign/Makefile
index 42cea4d..3d4491a 100644
--- a/libmultipath/foreign/Makefile
+++ b/libmultipath/foreign/Makefile
@@ -4,9 +4,9 @@
 TOPDIR=../..
 include ../../Makefile.inc
 
-CPPFLAGS += -I.. -I$(nvmedir)
+CPPFLAGS += -I$(multipathdir) -I$(nvmedir)
 CFLAGS += $(LIB_CFLAGS)
-LDFLAGS += -L..
+LDFLAGS += -L$(multipathdir)
 LIBDEPS = -lmultipath -ludev -lpthread -lrt
 
 LIBS = libforeign-nvme.so
diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
index a5ab5e1..eb6f03b 100644
--- a/libmultipath/prioritizers/Makefile
+++ b/libmultipath/prioritizers/Makefile
@@ -1,11 +1,13 @@
 #
 # Copyright (C) 2007 Christophe Varoqui, <christophe.varoqui@opensvc.com>
 #
+TOPDIR=../..
+
 include ../../Makefile.inc
 
-CPPFLAGS += -I..
+CPPFLAGS += -I$(multipathdir)
 CFLAGS += $(LIB_CFLAGS)
-LDFLAGS += -L..
+LDFLAGS += -L$(multipathdir)
 LIBDEPS = -lmultipath -lm -lpthread -lrt
 
 # If you add or remove a prioritizer also update multipath/multipath.conf.5
diff --git a/libmultipath/prioritizers/alua_rtpg.c b/libmultipath/prioritizers/alua_rtpg.c
index 4db13c2..2db9153 100644
--- a/libmultipath/prioritizers/alua_rtpg.c
+++ b/libmultipath/prioritizers/alua_rtpg.c
@@ -27,7 +27,7 @@
 #include "../structs.h"
 #include "../prio.h"
 #include "../discovery.h"
-#include "../debug.h"
+#include "debug.h"
 #include "alua_rtpg.h"
 
 #define SENSE_BUFF_LEN  32
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

