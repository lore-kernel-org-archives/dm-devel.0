Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13200C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 10 May 2022 09:36:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-44-bzkmf70QMrmYu_lUc50Zfw-1; Tue, 10 May 2022 05:36:06 -0400
X-MC-Unique: bzkmf70QMrmYu_lUc50Zfw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EEC7F3C138C7;
	Tue, 10 May 2022 09:36:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 23417403D164;
	Tue, 10 May 2022 09:36:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D950C1947055;
	Tue, 10 May 2022 09:36:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AD8071947052
 for <dm-devel@listman.corp.redhat.com>; Tue, 10 May 2022 09:36:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8EA09C28101; Tue, 10 May 2022 09:36:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B02AC28100
 for <dm-devel@redhat.com>; Tue, 10 May 2022 09:36:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 725521010362
 for <dm-devel@redhat.com>; Tue, 10 May 2022 09:36:01 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-iODw5-K7N8WM0cMZk291mw-1; Tue, 10 May 2022 05:36:00 -0400
X-MC-Unique: iODw5-K7N8WM0cMZk291mw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 9A35B21BB5;
 Tue, 10 May 2022 09:35:58 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 633B613AA5;
 Tue, 10 May 2022 09:35:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id IcxnFv4xemIANQAAMHmgww
 (envelope-from <mwilck@suse.com>); Tue, 10 May 2022 09:35:58 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 =?UTF-8?q?Martin=20Li=C5=A1ka?= <mliska@suse.cz>
Date: Tue, 10 May 2022 11:35:37 +0200
Message-Id: <20220510093538.25199-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH 1/2] multipath-tools: move CPPFLAGS before CFLAGS
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Distributions may want to override -D_FORTIFY_SOURCE in the generic
OPTFLAGS variable. That requires that the autodected setting is
evaluated before OPTFLAGS on the compiler command line.
This way, distributions can use OPTFLAGS="-U_FORTIFY_SOURCE
-D_FORTIFY_SOURCE=3 ..." without causing compilation errors.
(Note that the "-U" is required).

Move CPPFLAGS before CFLAGS in the compiler command line. Moreover, make sure
CPPFLAGS is referenced in all compilation steps.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc          | 2 +-
 libmultipath/Makefile | 6 +++---
 multipathd/Makefile   | 2 +-
 tests/Makefile        | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index b915c06..7422666 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -191,7 +191,7 @@ check_var = $(shell \
 
 %.o:	%.c
 	@echo building $@ because of $?
-	$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<
+	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<
 
 %.abi:  %.so.0
 	abidw $< >$@
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index a56dd1e..2fc3f3b 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -70,12 +70,12 @@ OBJS := $(OBJS-O) $(OBJS-U)
 all:	$(DEVLIB)
 
 nvme-lib.o: nvme-lib.c nvme-ioctl.c nvme-ioctl.h
-	$(CC) $(CFLAGS) -Wno-unused-function -c -o $@ $<
+	$(CC) $(CPPFLAGS) $(CFLAGS) -Wno-unused-function -c -o $@ $<
 
 # there are lots of "unused parameters" in dict.c
 # because not all handler / snprint methods need all parameters
 dict.o:	dict.c
-	$(CC) $(CFLAGS) -Wno-unused-parameter -c -o $@ $<
+	$(CC) $(CPPFLAGS) $(CFLAGS) -Wno-unused-parameter -c -o $@ $<
 
 make_static = $(shell sed '/^static/!s/^\([a-z]\{1,\} \)/static \1/' <$1 >$2)
 
@@ -112,7 +112,7 @@ abi:    $(LIBS:%.so.$(SONAME)=%-nv.abi)
 # This rule is invoked from tests/Makefile, overriding configdir and plugindir
 %-test.o: %.c
 	@echo building $@ because of $?
-	$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<
+	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<
 
 test-lib:	../tests/$(LIBS)
 
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 9a49144..1449080 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -52,7 +52,7 @@ $(EXEC): $(OBJS) $(multipathdir)/libmultipath.so $(mpathcmddir)/libmpathcmd.so
 	$(CC) $(CFLAGS) $(OBJS) $(LDFLAGS) -o $(EXEC) $(LIBDEPS)
 
 cli_handlers.o:	cli_handlers.c
-	$(CC) $(CFLAGS) -Wno-unused-parameter -c -o $@ $<
+	$(CC) $(CPPFLAGS) $(CFLAGS) -Wno-unused-parameter -c -o $@ $<
 
 install:
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(bindir)
diff --git a/tests/Makefile b/tests/Makefile
index 0b39c30..a069e37 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -72,7 +72,7 @@ endif
 strbuf-test_OBJDEPS := ../libmultipath/strbuf.o
 
 %.o: %.c
-	$(CC) $(CFLAGS) $($*-test_FLAGS) -c -o $@ $<
+	$(CC) $(CPPFLAGS) $(CFLAGS) $($*-test_FLAGS) -c -o $@ $<
 
 lib/libchecktur.so:
 	mkdir -p lib
-- 
2.36.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

