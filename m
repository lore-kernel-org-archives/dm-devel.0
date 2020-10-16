Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 221CEC4363A
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:43:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7DB492084C
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:43:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7DB492084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-Zo3rWry1NkawhsHqqpBfyA-1; Fri, 16 Oct 2020 06:43:33 -0400
X-MC-Unique: Zo3rWry1NkawhsHqqpBfyA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75929100A247;
	Fri, 16 Oct 2020 10:43:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5151D1992F;
	Fri, 16 Oct 2020 10:43:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 25D8044A62;
	Fri, 16 Oct 2020 10:43:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GAhD79019950 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 06:43:13 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3E96611CC25B; Fri, 16 Oct 2020 10:43:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A7AF11CC237
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 14DB1182360B
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:13 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-288-NuConzf2P5CTj44FIy_tFw-1;
	Fri, 16 Oct 2020 06:43:08 -0400
X-MC-Unique: NuConzf2P5CTj44FIy_tFw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 8571FB2B3;
	Fri, 16 Oct 2020 10:43:05 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 16 Oct 2020 12:42:34 +0200
Message-Id: <20201016104239.8217-8-mwilck@suse.com>
In-Reply-To: <20201016104239.8217-1-mwilck@suse.com>
References: <20201016104239.8217-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09GAhD79019950
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 07/12] multipath-tools Makefiles: separate
	rules for .so and man pages
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

Rely more on "make" functionality than on sequential command execution.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathcmd/Makefile     |  8 +++++---
 libmpathpersist/Makefile | 10 +++++++---
 libmultipath/Makefile    |  8 +++++---
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/libmpathcmd/Makefile b/libmpathcmd/Makefile
index 0f6b816..08ccb81 100644
--- a/libmpathcmd/Makefile
+++ b/libmpathcmd/Makefile
@@ -8,13 +8,15 @@ CFLAGS += $(LIB_CFLAGS)
 
 OBJS = mpath_cmd.o
 
-all: $(LIBS)
+all:	$(DEVLIB)
 
 $(LIBS): $(OBJS)
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS) $(LIBDEPS)
-	$(LN) $@ $(DEVLIB)
 
-install: $(LIBS)
+$(DEVLIB): $(LIBS)
+	$(LN) $(LIBS) $@
+
+install: all
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(syslibdir)
 	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
 	$(LN) $(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index 21fdad8..9e869fd 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -11,15 +11,19 @@ LIBDEPS += -lpthread -ldevmapper -ldl -L$(multipathdir) -lmultipath \
 
 OBJS = mpath_persist.o mpath_updatepr.o mpath_pr_ioctl.o
 
-all: $(LIBS)
+all: $(DEVLIB) man
 
 $(LIBS): $(OBJS)
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) $(LIBDEPS) -Wl,-soname=$@ -o $@ $(OBJS)
-	$(LN) $(LIBS) $(DEVLIB)
+
+$(DEVLIB): $(LIBS)
+	$(LN) $(LIBS) $@
+
+man:
 	$(GZIP) mpath_persistent_reserve_in.3 > mpath_persistent_reserve_in.3.gz
 	$(GZIP) mpath_persistent_reserve_out.3 > mpath_persistent_reserve_out.3.gz
 
-install: $(LIBS)
+install: all
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(syslibdir)
 	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(syslibdir)
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index e5dac5e..af5bb77 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -50,7 +50,7 @@ OBJS = memory.o parser.o vector.o devmapper.o callout.o \
 	io_err_stat.o dm-generic.o generic.o foreign.o nvme-lib.o \
 	libsg.o valid.o
 
-all: $(LIBS)
+all:	$(DEVLIB)
 
 nvme-lib.o: nvme-lib.c nvme-ioctl.c nvme-ioctl.h
 	$(CC) $(CFLAGS) -Wno-unused-function -c -o $@ $<
@@ -70,9 +70,11 @@ nvme-ioctl.h: nvme/nvme-ioctl.h
 
 $(LIBS): $(OBJS)
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS) $(LIBDEPS)
-	$(LN) $@ $(DEVLIB)
 
-install:
+$(DEVLIB): $(LIBS)
+	$(LN) $(LIBS) $@
+
+install: all
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(syslibdir)
 	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(libdir)
-- 
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

