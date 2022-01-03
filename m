Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1204EC433F5
	for <dm-devel@archiver.kernel.org>; Tue,  4 Jan 2022 08:08:55 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-sacoG2M1P3eEDUHZve390g-1; Tue, 04 Jan 2022 03:08:51 -0500
X-MC-Unique: sacoG2M1P3eEDUHZve390g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A415E101AFAA;
	Tue,  4 Jan 2022 08:08:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A3C8F6DA;
	Tue,  4 Jan 2022 08:08:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1B4931809CB9;
	Tue,  4 Jan 2022 08:08:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 203BPARJ006679 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 3 Jan 2022 06:25:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 79300112131E; Mon,  3 Jan 2022 11:25:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 740FA112131B
	for <dm-devel@redhat.com>; Mon,  3 Jan 2022 11:25:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F0832BD19E2
	for <dm-devel@redhat.com>; Mon,  3 Jan 2022 11:25:07 +0000 (UTC)
Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-550-4673Phw6OOOcVQdiuW8iZQ-1; Mon, 03 Jan 2022 06:25:05 -0500
X-MC-Unique: 4673Phw6OOOcVQdiuW8iZQ-1
From: Sam James <sam@gentoo.org>
To: dm-devel@redhat.com
Date: Mon,  3 Jan 2022 11:14:42 +0000
Message-Id: <20220103111442.3117310-1-sam@gentoo.org>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 203BPARJ006679
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 04 Jan 2022 03:08:38 -0500
Cc: mwilck@suse.com, Sam James <sam@gentoo.org>
Subject: [dm-devel] [PATCH] build: don't compress man pages
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

This tends to complicate packaging for downstreams as we may choose to
not compress man pages at all, use a different tool, or use different
options.

Most projects don't therefore bother compressing, so this change
brings multipath-tool in line with others.

Signed-off-by: Sam James <sam@gentoo.org>
---
 kpartx/Makefile          |  7 +++----
 libdmmp/Makefile         | 14 ++++----------
 libmpathcmd/Makefile     |  2 +-
 libmpathpersist/Makefile | 16 ++++++----------
 libmpathvalid/Makefile   |  2 +-
 libmultipath/Makefile    |  2 +-
 mpathpersist/Makefile    |  7 +++----
 multipath/Makefile       | 12 +++++-------
 multipathd/Makefile      |  7 +++----
 9 files changed, 27 insertions(+), 42 deletions(-)

diff --git a/kpartx/Makefile b/kpartx/Makefile
index 2906a984..dadf11b9 100644
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -21,7 +21,6 @@ all: $(EXEC)
 
 $(EXEC): $(OBJS)
 	$(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS) $(LIBDEPS)
-	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
 
 install: $(EXEC) $(EXEC).8
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(bindir)
@@ -33,11 +32,11 @@ install: $(EXEC) $(EXEC).8
 	$(INSTALL_PROGRAM) -m 644 kpartx.rules $(DESTDIR)$(libudevdir)/rules.d/66-kpartx.rules
 	$(INSTALL_PROGRAM) -m 644 del-part-nodes.rules $(DESTDIR)$(libudevdir)/rules.d/68-del-part-nodes.rules
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(man8dir)
-	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(man8dir)
+	$(INSTALL_PROGRAM) -m 644 $(EXEC).8 $(DESTDIR)$(man8dir)
 
 uninstall:
 	$(RM) $(DESTDIR)$(bindir)/$(EXEC)
-	$(RM) $(DESTDIR)$(man8dir)/$(EXEC).8.gz
+	$(RM) $(DESTDIR)$(man8dir)/$(EXEC).8
 	$(RM) $(DESTDIR)$(libudevdir)/kpartx_id
 	$(RM) $(DESTDIR)$(libudevdir)/rules.d/11-dm-parts.rules
 	$(RM) $(DESTDIR)$(libudevdir)/rules.d/66-kpartx.rules
@@ -45,7 +44,7 @@ uninstall:
 	$(RM) $(DESTDIR)$(libudevdir)/rules.d/68-del-part-nodes.rules
 
 clean: dep_clean
-	$(RM) core *.o $(EXEC) *.gz
+	$(RM) core *.o $(EXEC)
 
 include $(wildcard $(OBJS:.o=.d))
 
diff --git a/libdmmp/Makefile b/libdmmp/Makefile
index de616689..00fc8529 100644
--- a/libdmmp/Makefile
+++ b/libdmmp/Makefile
@@ -21,7 +21,7 @@ CFLAGS += $(LIB_CFLAGS) -fvisibility=hidden -I$(libdmmpdir) -I$(mpathcmddir) \
 LIBDEPS += $(shell $(PKGCONFIG) --libs json-c) -L$(mpathcmddir) -lmpathcmd -lpthread
 
 all: $(LIBS) doc
-.PHONY:	doc doc.gz clean install uninstall check speed_test dep_clean
+.PHONY:	doc clean install uninstall check speed_test dep_clean
 
 $(LIBS): $(OBJS)
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS) $(LIBDEPS)
@@ -31,7 +31,7 @@ $(DEVLIB): $(LIBS)
 
 abi:    $(DEVLIB:%.so=%.abi)
 
-install:	doc.gz
+install:
 	mkdir -p $(DESTDIR)$(usrlibdir)
 	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(usrlibdir)/$(LIBS)
 	$(INSTALL_PROGRAM) -m 644 -D \
@@ -45,7 +45,7 @@ install:	doc.gz
 		$(DESTDIR)$(pkgconfdir)/$(PKGFILE)
 	perl -i -pe 's|__INCLUDEDIR__|$(includedir)|g' \
 		$(DESTDIR)$(pkgconfdir)/$(PKGFILE)
-	$(INSTALL_PROGRAM) -m 644 -t $(DESTDIR)$(man3dir) docs/man/*.3.gz
+	$(INSTALL_PROGRAM) -m 644 -t $(DESTDIR)$(man3dir) docs/man/*.3
 
 uninstall:
 	$(RM) $(DESTDIR)$(usrlibdir)/$(LIBS)
@@ -58,8 +58,7 @@ uninstall:
 	$(RM) $(DESTDIR)$(pkgconfdir)/$(PKGFILE)
 
 clean: dep_clean
-	$(RM) core *.a *.o *.gz *.so *.so.* *.abi $(NV_VERSION_SCRIPT)
-	$(RM) docs/man/*.gz
+	$(RM) core *.a *.o *.so *.so.* *.abi $(NV_VERSION_SCRIPT)
 	$(MAKE) -C test clean
 
 include $(wildcard $(OBJS:.o=.d))
@@ -70,13 +69,8 @@ check: all
 speed_test: all
 	$(MAKE) -C test speed_test
 
-doc.gz:	doc $(patsubst %,%.gz,$(wildcard docs/man/*.3))
-
 doc: docs/man/dmmp_strerror.3
 
-docs/man/%.3.gz:	docs/man/%.3
-	gzip -c $< >$@
-
 docs/man/dmmp_strerror.3:	$(HEADERS)
 	TEMPFILE=$(shell mktemp); \
 	cat $^ | perl docs/doc-preclean.pl >$$TEMPFILE; \
diff --git a/libmpathcmd/Makefile b/libmpathcmd/Makefile
index 72cab1e3..0f83fe7b 100644
--- a/libmpathcmd/Makefile
+++ b/libmpathcmd/Makefile
@@ -42,7 +42,7 @@ uninstall:
 	$(RM) $(DESTDIR)$(includedir)/mpath_cmd.h
 
 clean: dep_clean
-	$(RM) core *.a *.o *.so *.so.* *.gz *.abi $(NV_VERSION_SCRIPT)
+	$(RM) core *.a *.o *.so *.so.* *.abi $(NV_VERSION_SCRIPT)
 
 include $(wildcard $(OBJS:.o=.d))
 
diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index 1e6399d6..07eed57d 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -12,7 +12,7 @@ LIBDEPS += -lmultipath -lmpathcmd -ldevmapper -lpthread -ldl
 
 OBJS = mpath_persist.o mpath_updatepr.o mpath_pr_ioctl.o
 
-all: $(DEVLIB) man
+all: $(DEVLIB)
 
 $(LIBS): $(OBJS) $(VERSION_SCRIPT)
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ \
@@ -32,10 +32,6 @@ abi:    $(LIBS:%.so.$(SONAME)=%-nv.abi)
 $(DEVLIB): $(LIBS)
 	$(LN) $(LIBS) $@
 
-man:
-	$(GZIP) mpath_persistent_reserve_in.3 > mpath_persistent_reserve_in.3.gz
-	$(GZIP) mpath_persistent_reserve_out.3 > mpath_persistent_reserve_out.3.gz
-
 install: all
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(syslibdir)
 	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
@@ -43,19 +39,19 @@ install: all
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(man3dir)
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(includedir)
 	$(LN) $(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
-	$(INSTALL_PROGRAM) -m 644 mpath_persistent_reserve_in.3.gz $(DESTDIR)$(man3dir)
-	$(INSTALL_PROGRAM) -m 644 mpath_persistent_reserve_out.3.gz $(DESTDIR)$(man3dir)
+	$(INSTALL_PROGRAM) -m 644 mpath_persistent_reserve_in.3 $(DESTDIR)$(man3dir)
+	$(INSTALL_PROGRAM) -m 644 mpath_persistent_reserve_out.3 $(DESTDIR)$(man3dir)
 	$(INSTALL_PROGRAM) -m 644 mpath_persist.h $(DESTDIR)$(includedir)
 
 uninstall:
 	$(RM) $(DESTDIR)$(syslibdir)/$(LIBS)
-	$(RM) $(DESTDIR)$(man3dir)/mpath_persistent_reserve_in.3.gz
-	$(RM) $(DESTDIR)$(man3dir)/mpath_persistent_reserve_out.3.gz
+	$(RM) $(DESTDIR)$(man3dir)/mpath_persistent_reserve_in.3
+	$(RM) $(DESTDIR)$(man3dir)/mpath_persistent_reserve_out.3
 	$(RM) $(DESTDIR)$(includedir)/mpath_persist.h
 	$(RM) $(DESTDIR)$(syslibdir)/$(DEVLIB)
 
 clean: dep_clean
-	$(RM) core *.a *.o *.so *.so.* *.gz *.abi $(NV_VERSION_SCRIPT)
+	$(RM) core *.a *.o *.so *.so.* *.abi $(NV_VERSION_SCRIPT)
 
 include $(wildcard $(OBJS:.o=.d))
 
diff --git a/libmpathvalid/Makefile b/libmpathvalid/Makefile
index dce26103..fefeb2a3 100644
--- a/libmpathvalid/Makefile
+++ b/libmpathvalid/Makefile
@@ -43,7 +43,7 @@ uninstall:
 	$(RM) $(DESTDIR)$(includedir)/mpath_valid.h
 
 clean: dep_clean
-	$(RM) core *.a *.o *.so *.so.* *.gz *.abi $(NV_VERSION_SCRIPT)
+	$(RM) core *.a *.o *.so *.so.* *.abi $(NV_VERSION_SCRIPT)
 
 include $(wildcard $(OBJS:.o=.d))
 
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index d4af1a54..ba8af194 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -110,7 +110,7 @@ uninstall:
 	$(RM) $(DESTDIR)$(syslibdir)/$(DEVLIB)
 
 clean: dep_clean
-	$(RM) core *.a *.o *.so *.so.* *.gz *.abi nvme-ioctl.c nvme-ioctl.h $(NV_VERSION_SCRIPT)
+	$(RM) core *.a *.o *.so *.so.* *.abi nvme-ioctl.c nvme-ioctl.h $(NV_VERSION_SCRIPT)
 
 include $(wildcard $(OBJS:.o=.d))
 
diff --git a/mpathpersist/Makefile b/mpathpersist/Makefile
index 51268010..eb26970f 100644
--- a/mpathpersist/Makefile
+++ b/mpathpersist/Makefile
@@ -14,22 +14,21 @@ all: $(EXEC)
 
 $(EXEC): $(OBJS)
 	$(CC) $(OBJS) -o $(EXEC) $(LDFLAGS) $(CFLAGS) $(LIBDEPS)
-	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
 
 install:
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(bindir)
 	$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)/
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(man8dir)
-	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(man8dir)
+	$(INSTALL_PROGRAM) -m 644 $(EXEC).8 $(DESTDIR)$(man8dir)
 
 clean: dep_clean
-	$(RM) core *.o $(EXEC) *.gz
+	$(RM) core *.o $(EXEC)
 
 include $(wildcard $(OBJS:.o=.d))
 
 uninstall:
 	$(RM) $(DESTDIR)$(bindir)/$(EXEC)
-	$(RM) $(DESTDIR)$(man8dir)/$(EXEC).8.gz
+	$(RM) $(DESTDIR)$(man8dir)/$(EXEC).8
 
 dep_clean:
 	$(RM) $(OBJS:.o=.d)
diff --git a/multipath/Makefile b/multipath/Makefile
index 0828a8f7..76735537 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -16,8 +16,6 @@ all: $(EXEC)
 
 $(EXEC): $(OBJS) $(multipathdir)/libmultipath.so $(mpathcmddir)/libmpathcmd.so
 	$(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS) $(LIBDEPS)
-	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
-	$(GZIP) $(EXEC).conf.5 > $(EXEC).conf.5.gz
 
 install:
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(bindir)
@@ -26,19 +24,19 @@ install:
 	$(INSTALL_PROGRAM) -m 644 11-dm-mpath.rules $(DESTDIR)$(udevrulesdir)
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).rules $(DESTDIR)$(libudevdir)/rules.d/56-multipath.rules
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(man8dir)
-	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(man8dir)
+	$(INSTALL_PROGRAM) -m 644 $(EXEC).8 $(DESTDIR)$(man8dir)
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(man5dir)
-	$(INSTALL_PROGRAM) -m 644 $(EXEC).conf.5.gz $(DESTDIR)$(man5dir)
+	$(INSTALL_PROGRAM) -m 644 $(EXEC).conf.5 $(DESTDIR)$(man5dir)
 
 uninstall:
 	$(RM) $(DESTDIR)$(bindir)/$(EXEC)
 	$(RM) $(DESTDIR)$(udevrulesdir)/11-dm-mpath.rules
 	$(RM) $(DESTDIR)$(libudevdir)/rules.d/56-multipath.rules
-	$(RM) $(DESTDIR)$(man8dir)/$(EXEC).8.gz
-	$(RM) $(DESTDIR)$(man5dir)/$(EXEC).conf.5.gz
+	$(RM) $(DESTDIR)$(man8dir)/$(EXEC).8
+	$(RM) $(DESTDIR)$(man5dir)/$(EXEC).conf.5
 
 clean: dep_clean
-	$(RM) core *.o $(EXEC) *.gz
+	$(RM) core *.o $(EXEC)
 
 include $(wildcard $(OBJS:.o=.d))
 
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 393b6cbb..8ea58180 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -40,7 +40,6 @@ all : $(EXEC)
 
 $(EXEC): $(OBJS) $(multipathdir)/libmultipath.so $(mpathcmddir)/libmpathcmd.so
 	$(CC) $(CFLAGS) $(OBJS) $(LDFLAGS) -o $(EXEC) $(LIBDEPS)
-	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
 
 cli_handlers.o:	cli_handlers.c
 	$(CC) $(CFLAGS) -Wno-unused-parameter -c -o $@ $<
@@ -54,16 +53,16 @@ ifdef SYSTEMD
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).socket $(DESTDIR)$(unitdir)
 endif
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(man8dir)
-	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(man8dir)
+	$(INSTALL_PROGRAM) -m 644 $(EXEC).8 $(DESTDIR)$(man8dir)
 
 uninstall:
 	$(RM) $(DESTDIR)$(bindir)/$(EXEC)
-	$(RM) $(DESTDIR)$(man8dir)/$(EXEC).8.gz
+	$(RM) $(DESTDIR)$(man8dir)/$(EXEC).8
 	$(RM) $(DESTDIR)$(unitdir)/$(EXEC).service
 	$(RM) $(DESTDIR)$(unitdir)/$(EXEC).socket
 
 clean: dep_clean
-	$(RM) core *.o $(EXEC) *.gz
+	$(RM) core *.o $(EXEC)
 
 include $(wildcard $(OBJS:.o=.d))
 
-- 
2.34.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

