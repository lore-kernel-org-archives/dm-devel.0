Return-Path: <SRS0=NZHG=FV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81883C2BB48
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 11:01:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DB6222389B
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 11:01:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB6222389B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-3jKgOkpiMiK7bKRiFf4_mA-1; Thu, 17 Dec 2020 06:01:08 -0500
X-MC-Unique: 3jKgOkpiMiK7bKRiFf4_mA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7310515730;
	Thu, 17 Dec 2020 11:01:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4EC601C92F;
	Thu, 17 Dec 2020 11:01:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 206E84E590;
	Thu, 17 Dec 2020 11:01:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BHB0fxP030251 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Dec 2020 06:00:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 008DCD7B3C; Thu, 17 Dec 2020 11:00:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EE5CED7E05
	for <dm-devel@redhat.com>; Thu, 17 Dec 2020 11:00:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA06A1871CCA
	for <dm-devel@redhat.com>; Thu, 17 Dec 2020 11:00:40 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-402-KvY0ihKSO6-QQWX4d2mryQ-1;
	Thu, 17 Dec 2020 06:00:36 -0500
X-MC-Unique: KvY0ihKSO6-QQWX4d2mryQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 02CE5AD45;
	Thu, 17 Dec 2020 11:00:34 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 17 Dec 2020 12:00:17 +0100
Message-Id: <20201217110018.3347-7-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BHB0fxP030251
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 6/7] multipath-tools: make sure plugin DSOs use
	symbol versions
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

By adding -Wl,-z,defs, we'll get warnings about unresolved symbols
at the linking stage. This way we make sure our plugins (checkers etc.)
will use versioned symbols from libmultipath, and incompatible plugins
can't be loaded any more. Doing this requires explicitly linking
the plugins with all libraries they use, in particular libmultipath.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile                           | 1 +
 Makefile.inc                       | 2 +-
 libmpathpersist/Makefile           | 8 ++++----
 libmultipath/checkers/Makefile     | 7 +++----
 libmultipath/foreign/Makefile      | 4 +++-
 libmultipath/prioritizers/Makefile | 7 +++----
 6 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/Makefile b/Makefile
index f127ff9..bddb2bf 100644
--- a/Makefile
+++ b/Makefile
@@ -31,6 +31,7 @@ $(BUILDDIRS):
 
 libmultipath libdmmp: libmpathcmd
 libmpathpersist libmpathvalid multipath multipathd: libmultipath
+libmultipath/prioritizers libmultipath/checkers libmultipath/foreign: libmultipath
 mpathpersist multipathd:  libmpathpersist
 
 libmultipath/checkers.install \
diff --git a/Makefile.inc b/Makefile.inc
index 13587a9..0542930 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -105,7 +105,7 @@ CFLAGS		:= --std=gnu99 $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe \
 BIN_CFLAGS	= -fPIE -DPIE
 LIB_CFLAGS	= -fPIC
 SHARED_FLAGS	= -shared
-LDFLAGS		:= $(LDFLAGS) -Wl,-z,relro -Wl,-z,now
+LDFLAGS		:= $(LDFLAGS) -Wl,-z,relro -Wl,-z,now -Wl,-z,defs
 BIN_LDFLAGS	= -pie
 
 # Check whether a function with name $1 has been declared in header file $2.
diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index 456ce4c..57103e5 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -6,17 +6,17 @@ LIBS = $(DEVLIB).$(SONAME)
 VERSION_SCRIPT := libmpathpersist.version
 
 CFLAGS += $(LIB_CFLAGS) -I$(multipathdir) -I$(mpathpersistdir) -I$(mpathcmddir)
+LDFLAGS += -L$(multipathdir) -L$(mpathcmddir)
 
-LIBDEPS += -lpthread -ldevmapper -ldl -L$(multipathdir) -lmultipath \
-	   -L$(mpathcmddir) -lmpathcmd
+LIBDEPS += -lmultipath -lmpathcmd -ldevmapper -lpthread -ldl
 
 OBJS = mpath_persist.o mpath_updatepr.o mpath_pr_ioctl.o
 
 all: $(DEVLIB) man
 
 $(LIBS): $(OBJS) $(VERSION_SCRIPT)
-	$(CC) $(LDFLAGS) $(SHARED_FLAGS) $(LIBDEPS) -Wl,-soname=$@ \
-		-Wl,--version-script=$(VERSION_SCRIPT) -o $@ $(OBJS)
+	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ \
+		-Wl,--version-script=$(VERSION_SCRIPT) -o $@ $(OBJS) $(LIBDEPS)
 
 $(DEVLIB): $(LIBS)
 	$(LN) $(LIBS) $@
diff --git a/libmultipath/checkers/Makefile b/libmultipath/checkers/Makefile
index 01c0451..8e0ed5e 100644
--- a/libmultipath/checkers/Makefile
+++ b/libmultipath/checkers/Makefile
@@ -4,6 +4,8 @@
 include ../../Makefile.inc
 
 CFLAGS += $(LIB_CFLAGS) -I..
+LDFLAGS += -L.. -lmultipath
+LIBDEPS = -lmultipath -laio -lpthread -lrt
 
 # If you add or remove a checker also update multipath/multipath.conf.5
 LIBS= \
@@ -17,11 +19,8 @@ LIBS= \
 
 all: $(LIBS)
 
-libcheckdirectio.so: directio.o
-	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -laio
-
 libcheck%.so: %.o
-	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
+	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ $(LIBDEPS)
 
 install:
 	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(libdir)
diff --git a/libmultipath/foreign/Makefile b/libmultipath/foreign/Makefile
index fae58a0..f447a1c 100644
--- a/libmultipath/foreign/Makefile
+++ b/libmultipath/foreign/Makefile
@@ -5,13 +5,15 @@ TOPDIR=../..
 include ../../Makefile.inc
 
 CFLAGS += $(LIB_CFLAGS) -I.. -I$(nvmedir)
+LDFLAGS += -L..
+LIBDEPS = -lmultipath -ludev -lpthread -lrt
 
 LIBS = libforeign-nvme.so
 
 all: $(LIBS)
 
 libforeign-%.so: %.o
-	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
+	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ $(LIBDEPS)
 
 install:
 	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(libdir)
diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
index fc6e0e0..8d34ae3 100644
--- a/libmultipath/prioritizers/Makefile
+++ b/libmultipath/prioritizers/Makefile
@@ -4,6 +4,8 @@
 include ../../Makefile.inc
 
 CFLAGS += $(LIB_CFLAGS) -I..
+LDFLAGS += -L..
+LIBDEPS = -lmultipath -lm -lpthread -lrt
 
 # If you add or remove a prioritizer also update multipath/multipath.conf.5
 LIBS = \
@@ -28,11 +30,8 @@ endif
 
 all: $(LIBS)
 
-libpriopath_latency.so: path_latency.o
-	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -lm
-
 libprio%.so: %.o
-	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
+	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ $(LIBDEPS)
 
 install: $(LIBS)
 	$(INSTALL_PROGRAM) -m 755 libprio*.so $(DESTDIR)$(libdir)
-- 
2.29.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

