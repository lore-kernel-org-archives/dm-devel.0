Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21C6CC433F5
	for <dm-devel@archiver.kernel.org>; Thu,  2 Dec 2021 16:10:45 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-Btt9nvflMTWvUHpwEOlaSw-1; Thu, 02 Dec 2021 11:10:40 -0500
X-MC-Unique: Btt9nvflMTWvUHpwEOlaSw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB1D31006AA3;
	Thu,  2 Dec 2021 16:10:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A4AE05F4ED;
	Thu,  2 Dec 2021 16:10:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4E76F4A705;
	Thu,  2 Dec 2021 16:10:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B2G7XRE006792 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 2 Dec 2021 11:07:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8B7B8401E56; Thu,  2 Dec 2021 16:07:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8794A401E2A
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 16:07:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F03A805BDE
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 16:07:33 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-2-lpWJCr0aNCGVaN3USSH75w-1; Thu, 02 Dec 2021 11:07:31 -0500
X-MC-Unique: lpWJCr0aNCGVaN3USSH75w-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1CF9D21891;
	Thu,  2 Dec 2021 16:07:30 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D80F113E82;
	Thu,  2 Dec 2021 16:07:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id AEmnMkHvqGGnEgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 02 Dec 2021 16:07:29 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu,  2 Dec 2021 17:06:42 +0100
Message-Id: <20211202160652.4576-3-mwilck@suse.com>
In-Reply-To: <20211202160652.4576-1-mwilck@suse.com>
References: <20211202160652.4576-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B2G7XRE006792
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 02/11] multipath-tools: generate abi with dummy
	version script
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

The purpose of the "abi" makefile target is to detect ABI changes.  If using
the version script the way we do (bumping major or minor versions), abigail
detects a completely different ABI with every bump. This makes it very
difficult to figure out actual changes in the code.

This patch fixes that by  using "versionless version scripts" for ABI
generation. These version scripts just list all exported symbols, using
just a single dummy version string. This is better than using no version
script at all, because only exported symbols will be compared, whereas
without a version script we'd be comparing non-exported symbols, too.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc             |  1 +
 libdmmp/Makefile         |  2 +-
 libmpathcmd/Makefile     | 13 +++++++++++--
 libmpathpersist/Makefile | 15 ++++++++++++---
 libmpathvalid/Makefile   | 16 +++++++++++++---
 libmultipath/Makefile    | 13 +++++++++++--
 6 files changed, 49 insertions(+), 11 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 17071ef..b340f2a 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -79,6 +79,7 @@ GZIP		= gzip -9 -c
 RM		= rm -f
 LN		= ln -sf
 INSTALL_PROGRAM	= install
+NV_VERSION_SCRIPT = $(VERSION_SCRIPT:%.version=%-nv.version)
 
 # $(call TEST_CC_OPTION,option,fallback)
 # Test if the C compiler supports the option.
diff --git a/libdmmp/Makefile b/libdmmp/Makefile
index c91f0c3..de61668 100644
--- a/libdmmp/Makefile
+++ b/libdmmp/Makefile
@@ -58,7 +58,7 @@ uninstall:
 	$(RM) $(DESTDIR)$(pkgconfdir)/$(PKGFILE)
 
 clean: dep_clean
-	$(RM) core *.a *.o *.gz *.so *.so.* *.abi
+	$(RM) core *.a *.o *.gz *.so *.so.* *.abi $(NV_VERSION_SCRIPT)
 	$(RM) docs/man/*.gz
 	$(MAKE) -C test clean
 
diff --git a/libmpathcmd/Makefile b/libmpathcmd/Makefile
index 5a7a6e9..72cab1e 100644
--- a/libmpathcmd/Makefile
+++ b/libmpathcmd/Makefile
@@ -15,7 +15,16 @@ $(LIBS): $(OBJS) $(VERSION_SCRIPT)
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ \
 		-Wl,--version-script=$(VERSION_SCRIPT) -o $@ $(OBJS) $(LIBDEPS)
 
-abi:    $(LIBS:%.so.0=%.abi)
+$(NV_VERSION_SCRIPT):	$(VERSION_SCRIPT)
+	@printf 'NOVERSION {\nglobal:\n' >$@
+	@grep -P '^[ \t]+[a-zA-Z_][a-zA-Z0-9_]*;' $< >>$@
+	@printf 'local:\n\t*;\n};\n' >>$@
+
+$(LIBS:%.so.$(SONAME)=%-nv.so):	$(OBJS) $(NV_VERSION_SCRIPT)
+	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ \
+		-Wl,--version-script=$(NV_VERSION_SCRIPT) -o $@ $(OBJS) $(LIBDEPS)
+
+abi:    $(LIBS:%.so.$(SONAME)=%-nv.abi)
 
 $(DEVLIB): $(LIBS)
 	$(LN) $(LIBS) $@
@@ -33,7 +42,7 @@ uninstall:
 	$(RM) $(DESTDIR)$(includedir)/mpath_cmd.h
 
 clean: dep_clean
-	$(RM) core *.a *.o *.so *.so.* *.gz *.abi
+	$(RM) core *.a *.o *.so *.so.* *.gz *.abi $(NV_VERSION_SCRIPT)
 
 include $(wildcard $(OBJS:.o=.d))
 
diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index d76918f..1e6399d 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -3,7 +3,7 @@ include ../Makefile.inc
 SONAME = 0
 DEVLIB = libmpathpersist.so
 LIBS = $(DEVLIB).$(SONAME)
-VERSION_SCRIPT := libmpathpersist.version
+VERSION_SCRIPT:= libmpathpersist.version
 
 CFLAGS += $(LIB_CFLAGS) -I$(multipathdir) -I$(mpathpersistdir) -I$(mpathcmddir)
 LDFLAGS += -L$(multipathdir) -L$(mpathcmddir)
@@ -18,7 +18,16 @@ $(LIBS): $(OBJS) $(VERSION_SCRIPT)
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ \
 		-Wl,--version-script=$(VERSION_SCRIPT) -o $@ $(OBJS) $(LIBDEPS)
 
-abi:    $(LIBS:%.so.0=%.abi)
+$(NV_VERSION_SCRIPT):	$(VERSION_SCRIPT)
+	@printf 'NOVERSION {\nglobal:\n' >$@
+	@grep -P '^[ \t]+[a-zA-Z_][a-zA-Z0-9_]*;' $< >>$@
+	@printf 'local:\n\t*;\n};\n' >>$@
+
+$(LIBS:%.so.$(SONAME)=%-nv.so):	$(OBJS) $(NV_VERSION_SCRIPT)
+	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ \
+		-Wl,--version-script=$(NV_VERSION_SCRIPT) -o $@ $(OBJS) $(LIBDEPS)
+
+abi:    $(LIBS:%.so.$(SONAME)=%-nv.abi)
 
 $(DEVLIB): $(LIBS)
 	$(LN) $(LIBS) $@
@@ -46,7 +55,7 @@ uninstall:
 	$(RM) $(DESTDIR)$(syslibdir)/$(DEVLIB)
 
 clean: dep_clean
-	$(RM) core *.a *.o *.so *.so.* *.gz *.abi
+	$(RM) core *.a *.o *.so *.so.* *.gz *.abi $(NV_VERSION_SCRIPT)
 
 include $(wildcard $(OBJS:.o=.d))
 
diff --git a/libmpathvalid/Makefile b/libmpathvalid/Makefile
index b579535..dce2610 100644
--- a/libmpathvalid/Makefile
+++ b/libmpathvalid/Makefile
@@ -15,10 +15,20 @@ OBJS = mpath_valid.o
 all: $(LIBS)
 
 $(LIBS): $(OBJS) $(VERSION_SCRIPT)
-	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS) $(LIBDEPS) -Wl,--version-script=libmpathvalid.version
+	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS) $(LIBDEPS) \
+		-Wl,--version-script=$(VERSION_SCRIPT)
 	$(LN) $(LIBS) $(DEVLIB)
 
-abi:    $(LIBS:%.so.0=%.abi)
+$(NV_VERSION_SCRIPT):	$(VERSION_SCRIPT)
+	@printf 'NOVERSION {\nglobal:\n' >$@
+	@grep -P '^[ \t]+[a-zA-Z_][a-zA-Z0-9_]*;' $< >>$@
+	@printf 'local:\n\t*;\n};\n' >>$@
+
+$(LIBS:%.so.$(SONAME)=%-nv.so):	$(OBJS) $(NV_VERSION_SCRIPT)
+	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ \
+		-Wl,--version-script=$(NV_VERSION_SCRIPT) -o $@ $(OBJS) $(LIBDEPS)
+
+abi:    $(LIBS:%.so.$(SONAME)=%-nv.abi)
 
 install: $(LIBS)
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(syslibdir)
@@ -33,7 +43,7 @@ uninstall:
 	$(RM) $(DESTDIR)$(includedir)/mpath_valid.h
 
 clean: dep_clean
-	$(RM) core *.a *.o *.so *.so.* *.gz *.abi
+	$(RM) core *.a *.o *.so *.so.* *.gz *.abi $(NV_VERSION_SCRIPT)
 
 include $(wildcard $(OBJS:.o=.d))
 
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index e8fd749..d4af1a5 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -81,7 +81,16 @@ $(LIBS): $(OBJS) $(VERSION_SCRIPT)
 $(DEVLIB): $(LIBS)
 	$(LN) $(LIBS) $@
 
-abi:    $(LIBS:%.so.0=%.abi)
+$(NV_VERSION_SCRIPT):	$(VERSION_SCRIPT)
+	@printf 'NOVERSION {\nglobal:\n' >$@
+	@grep -P '^[ \t]+[a-zA-Z_][a-zA-Z0-9_]*;' $< >>$@
+	@printf 'local:\n\t*;\n};\n' >>$@
+
+$(LIBS:%.so.$(SONAME)=%-nv.so):	$(OBJS) $(NV_VERSION_SCRIPT)
+	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ \
+		-Wl,--version-script=$(NV_VERSION_SCRIPT) -o $@ $(OBJS) $(LIBDEPS)
+
+abi:    $(LIBS:%.so.$(SONAME)=%-nv.abi)
 
 ../tests/$(LIBS): $(OBJS) $(VERSION_SCRIPT)
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=`basename $@` \
@@ -101,7 +110,7 @@ uninstall:
 	$(RM) $(DESTDIR)$(syslibdir)/$(DEVLIB)
 
 clean: dep_clean
-	$(RM) core *.a *.o *.so *.so.* *.gz *.abi nvme-ioctl.c nvme-ioctl.h
+	$(RM) core *.a *.o *.so *.so.* *.gz *.abi nvme-ioctl.c nvme-ioctl.h $(NV_VERSION_SCRIPT)
 
 include $(wildcard $(OBJS:.o=.d))
 
-- 
2.34.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

