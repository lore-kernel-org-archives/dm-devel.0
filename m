Return-Path: <SRS0=25Tj=P7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBB7FC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 21:06:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5AF1261073
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 21:06:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5AF1261073
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-WbGIjHMZOB6zouv3CNJf8A-1; Fri, 12 Nov 2021 16:06:35 -0500
X-MC-Unique: WbGIjHMZOB6zouv3CNJf8A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 661BC8799ED;
	Fri, 12 Nov 2021 21:06:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B53860862;
	Fri, 12 Nov 2021 21:06:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 246DB181A1D1;
	Fri, 12 Nov 2021 21:06:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ACL6EpV016422 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 12 Nov 2021 16:06:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 66D09404727D; Fri, 12 Nov 2021 21:06:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5EAEB404727C
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 21:06:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 43F81803D7B
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 21:06:14 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-223-yJjPQesaPb-h8arF5MnHyg-1; Fri, 12 Nov 2021 16:06:08 -0500
X-MC-Unique: yJjPQesaPb-h8arF5MnHyg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 985F21FD5B;
	Fri, 12 Nov 2021 21:06:07 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 52AA713CCC;
	Fri, 12 Nov 2021 21:06:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id Y4B8ET/XjmGyXwAAMHmgww
	(envelope-from <mwilck@suse.com>); Fri, 12 Nov 2021 21:06:07 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 12 Nov 2021 22:05:49 +0100
Message-Id: <20211112210551.12744-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ACL6EpV016422
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 1/3] multipath-tools: support ABI testing with
	libabigail
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Use abidw and abidiff (https://sourceware.org/libabigail/) to
generate a formal representation of our ABI, and check for changes.
This will reduce the amount of attention required to detect and
track library version changes.

To check for differences, run "make abi" on some branch, rename the
"abi" directory to "reference-abi", checkout a different branch,
and run "make abi-test".

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 .gitignore               |  4 +++
 Makefile                 | 55 ++++++++++++++++++++++++++++++++++------
 Makefile.inc             |  6 +++++
 libdmmp/Makefile         |  8 ++++--
 libmpathcmd/Makefile     |  4 ++-
 libmpathpersist/Makefile |  4 ++-
 libmpathvalid/Makefile   |  4 ++-
 libmultipath/Makefile    |  4 ++-
 8 files changed, 75 insertions(+), 14 deletions(-)

diff --git a/.gitignore b/.gitignore
index 087dffc..5dbac39 100644
--- a/.gitignore
+++ b/.gitignore
@@ -3,6 +3,7 @@
 *~
 *.so
 *.so.0
+*.abi
 *.a
 *.gz
 *.d
@@ -13,6 +14,9 @@ kpartx/kpartx
 multipath/multipath
 multipathd/multipathd
 mpathpersist/mpathpersist
+abi.tar.gz
+abi
+abi-test
 .nfs*
 *.swp
 *.patch
diff --git a/Makefile b/Makefile
index 7f21db8..1cec777 100644
--- a/Makefile
+++ b/Makefile
@@ -2,33 +2,70 @@
 # Copyright (C) 2003 Christophe Varoqui, <christophe.varoqui@opensvc.com>
 #
 
-BUILDDIRS := \
+LIB_BUILDDIRS := \
 	libmpathcmd \
 	libmultipath \
+	libmpathpersist \
+	libmpathvalid
+
+ifneq ($(ENABLE_LIBDMMP),0)
+LIB_BUILDDIRS += \
+	libdmmp
+endif
+
+BUILDDIRS := $(LIB_BUILDDIRS) \
 	libmultipath/prioritizers \
 	libmultipath/checkers \
 	libmultipath/foreign \
-	libmpathpersist \
-	libmpathvalid \
 	multipath \
 	multipathd \
 	mpathpersist \
 	kpartx
 
-ifneq ($(ENABLE_LIBDMMP),0)
-BUILDDIRS += \
-	libdmmp
-endif
 
 BUILDDIRS.clean := $(BUILDDIRS:=.clean) tests.clean
 
-.PHONY:	$(BUILDDIRS) $(BUILDDIRS:=.uninstall) $(BUILDDIRS:=.install) $(BUILDDIRS.clean)
+.PHONY:	$(BUILDDIRS) $(BUILDDIRS:=.uninstall) $(BUILDDIRS:=.install) $(BUILDDIRS:=.clean) $(LIB_BUILDDIRS:=.abi)
 
 all:	$(BUILDDIRS)
 
 $(BUILDDIRS):
 	$(MAKE) -C $@
 
+$(LIB_BUILDDIRS:=.abi): $(LIB_BUILDDIRS)
+	$(MAKE) -C ${@:.abi=} abi
+
+# Create formal representation of the ABI
+# Useful for verifying ABI compatibility
+# Requires abidw from the abigail suite (https://sourceware.org/libabigail/)
+.PHONY: abi
+abi:	$(LIB_BUILDDIRS:=.abi)
+	mkdir -p $@
+	ln -ft $@ $(LIB_BUILDDIRS:=/*.abi)
+
+abi.tar.gz:	abi
+	tar cfz $@ abi
+
+# Check the ABI against a reference.
+# This requires the ABI from a previous run to be present
+# in the directory "reference-abi"
+# Requires abidiff from the abigail suite
+abi-test:	abi reference-abi $(wildcard abi/*.abi)
+	@err=0; \
+	for lib in abi/*.abi; do \
+	    diff=$$(abidiff "reference-$$lib" "$$lib") || { \
+	        err=1; \
+		echo "==== ABI differences in for $$lib ===="; \
+		echo "$$diff"; \
+	    }; \
+	done >$@; \
+	if [ $$err -eq 0 ]; then \
+	    echo "*** OK, ABI unchanged ***"; \
+	else \
+	    echo "*** WARNING: ABI has changed, see file $@ ***"; \
+	fi; \
+	[ $$err -eq 0 ]
+
 libmultipath libdmmp: libmpathcmd
 libmpathpersist libmpathvalid multipath multipathd: libmultipath
 libmultipath/prioritizers libmultipath/checkers libmultipath/foreign: libmultipath
@@ -48,6 +85,8 @@ $(BUILDDIRS:=.uninstall):
 	$(MAKE) -C ${@:.uninstall=} uninstall
 
 clean: $(BUILDDIRS.clean)
+	rm -rf abi abi.tar.gz abi-test compile_commands.json
+
 install: all $(BUILDDIRS:=.install)
 uninstall: $(BUILDDIRS:=.uninstall)
 
diff --git a/Makefile.inc b/Makefile.inc
index d0ec9b4..17071ef 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -140,3 +140,9 @@ check_file = $(shell \
 %.o:	%.c
 	@echo building $@ because of $?
 	$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<
+
+%.abi:  %.so.0
+	abidw $< >$@
+
+%.abi:  %.so
+	abidw $< >$@
diff --git a/libdmmp/Makefile b/libdmmp/Makefile
index 79b92fb..c91f0c3 100644
--- a/libdmmp/Makefile
+++ b/libdmmp/Makefile
@@ -25,7 +25,11 @@ all: $(LIBS) doc
 
 $(LIBS): $(OBJS)
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS) $(LIBDEPS)
-	$(LN) $@ $(DEVLIB)
+
+$(DEVLIB): $(LIBS)
+	$(LN) $(LIBS) $@
+
+abi:    $(DEVLIB:%.so=%.abi)
 
 install:	doc.gz
 	mkdir -p $(DESTDIR)$(usrlibdir)
@@ -54,7 +58,7 @@ uninstall:
 	$(RM) $(DESTDIR)$(pkgconfdir)/$(PKGFILE)
 
 clean: dep_clean
-	$(RM) core *.a *.o *.gz *.so *.so.*
+	$(RM) core *.a *.o *.gz *.so *.so.* *.abi
 	$(RM) docs/man/*.gz
 	$(MAKE) -C test clean
 
diff --git a/libmpathcmd/Makefile b/libmpathcmd/Makefile
index 2591019..5a7a6e9 100644
--- a/libmpathcmd/Makefile
+++ b/libmpathcmd/Makefile
@@ -15,6 +15,8 @@ $(LIBS): $(OBJS) $(VERSION_SCRIPT)
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ \
 		-Wl,--version-script=$(VERSION_SCRIPT) -o $@ $(OBJS) $(LIBDEPS)
 
+abi:    $(LIBS:%.so.0=%.abi)
+
 $(DEVLIB): $(LIBS)
 	$(LN) $(LIBS) $@
 
@@ -31,7 +33,7 @@ uninstall:
 	$(RM) $(DESTDIR)$(includedir)/mpath_cmd.h
 
 clean: dep_clean
-	$(RM) core *.a *.o *.so *.so.* *.gz
+	$(RM) core *.a *.o *.so *.so.* *.gz *.abi
 
 include $(wildcard $(OBJS:.o=.d))
 
diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index 57103e5..d76918f 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -18,6 +18,8 @@ $(LIBS): $(OBJS) $(VERSION_SCRIPT)
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ \
 		-Wl,--version-script=$(VERSION_SCRIPT) -o $@ $(OBJS) $(LIBDEPS)
 
+abi:    $(LIBS:%.so.0=%.abi)
+
 $(DEVLIB): $(LIBS)
 	$(LN) $(LIBS) $@
 
@@ -44,7 +46,7 @@ uninstall:
 	$(RM) $(DESTDIR)$(syslibdir)/$(DEVLIB)
 
 clean: dep_clean
-	$(RM) core *.a *.o *.so *.so.* *.gz
+	$(RM) core *.a *.o *.so *.so.* *.gz *.abi
 
 include $(wildcard $(OBJS:.o=.d))
 
diff --git a/libmpathvalid/Makefile b/libmpathvalid/Makefile
index 6bea4bc..b579535 100644
--- a/libmpathvalid/Makefile
+++ b/libmpathvalid/Makefile
@@ -18,6 +18,8 @@ $(LIBS): $(OBJS) $(VERSION_SCRIPT)
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS) $(LIBDEPS) -Wl,--version-script=libmpathvalid.version
 	$(LN) $(LIBS) $(DEVLIB)
 
+abi:    $(LIBS:%.so.0=%.abi)
+
 install: $(LIBS)
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(syslibdir)
 	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
@@ -31,7 +33,7 @@ uninstall:
 	$(RM) $(DESTDIR)$(includedir)/mpath_valid.h
 
 clean: dep_clean
-	$(RM) core *.a *.o *.so *.so.* *.gz
+	$(RM) core *.a *.o *.so *.so.* *.gz *.abi
 
 include $(wildcard $(OBJS:.o=.d))
 
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 7f3921c..42692b3 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -81,6 +81,8 @@ $(LIBS): $(OBJS) $(VERSION_SCRIPT)
 $(DEVLIB): $(LIBS)
 	$(LN) $(LIBS) $@
 
+abi:    $(LIBS:%.so.0=%.abi)
+
 ../tests/$(LIBS): $(OBJS) $(VERSION_SCRIPT)
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=`basename $@` \
 		-o $@ $(OBJS) $(LIBDEPS)
@@ -99,7 +101,7 @@ uninstall:
 	$(RM) $(DESTDIR)$(syslibdir)/$(DEVLIB)
 
 clean: dep_clean
-	$(RM) core *.a *.o *.so *.so.* *.gz nvme-ioctl.c nvme-ioctl.h
+	$(RM) core *.a *.o *.so *.so.* *.gz *.abi nvme-ioctl.c nvme-ioctl.h
 
 include $(wildcard $(OBJS:.o=.d))
 
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

