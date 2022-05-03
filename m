Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B8A1C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  3 May 2022 22:58:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-158-7eu8j0DfONiwCjzc2nIDSw-1; Tue, 03 May 2022 18:58:35 -0400
X-MC-Unique: 7eu8j0DfONiwCjzc2nIDSw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4923818E5389;
	Tue,  3 May 2022 22:58:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 36E9F2166B4E;
	Tue,  3 May 2022 22:58:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C518D1947040;
	Tue,  3 May 2022 22:58:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9E02319466DF
 for <dm-devel@listman.corp.redhat.com>; Tue,  3 May 2022 22:58:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8B405463E15; Tue,  3 May 2022 22:58:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8774D40ED53
 for <dm-devel@redhat.com>; Tue,  3 May 2022 22:58:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F66E3C025B6
 for <dm-devel@redhat.com>; Tue,  3 May 2022 22:58:31 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-zmXe5ffHNRKtgrVcSFR_gg-1; Tue, 03 May 2022 18:07:27 -0400
X-MC-Unique: zmXe5ffHNRKtgrVcSFR_gg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 41DA7210EB;
 Tue,  3 May 2022 22:07:16 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 12A7313ABE;
 Tue,  3 May 2022 22:07:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id KE3nApSncWLfFgAAMHmgww
 (envelope-from <mwilck@suse.com>); Tue, 03 May 2022 22:07:16 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  4 May 2022 00:06:40 +0200
Message-Id: <20220503220646.16925-2-mwilck@suse.com>
In-Reply-To: <20220503220646.16925-1-mwilck@suse.com>
References: <20220503220646.16925-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH 1/7] multipath-tools: enable local configdir and
 plugindir for unit tests
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

After the recent patches disabling the config_dir and multipath_dir
runtime options, we need to take special care while building the
unit tests. Create separate object files to link with the unit tests
(e.g. "config-test.o" instead of "config.o"), using overrides for
"configdir" and "plugindir".

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/Makefile | 24 ++++++++++++++++++------
 tests/Makefile        |  9 ++++++---
 tests/hwtable.c       |  7 +++----
 3 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index b3a48c4..a56dd1e 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -49,17 +49,24 @@ ifneq ($(call check_var,ELS_DTAG_LNK_INTEGRITY,$(LINUX_HEADERS_INCDIR)/scsi/fc/f
 	CFLAGS += -DFPIN_EVENT_HANDLER
 endif
 
+# object files referencing MULTIPATH_DIR or CONFIG_DIR
+# they need to be recompiled for unit tests
+OBJS-U := prio.o checkers.o foreign.o config.o
+OBJS-T := $(patsubst %.o,%-test.o,$(OBJS-U))
 
-OBJS = parser.o vector.o devmapper.o \
-	hwtable.o blacklist.o util.o dmparser.o config.o \
+# other object files
+OBJS-O := parser.o vector.o devmapper.o \
+	hwtable.o blacklist.o util.o dmparser.o \
 	structs.o discovery.o propsel.o dict.o \
 	pgpolicies.o debug.o defaults.o uevent.o time-util.o \
 	switchgroup.o uxsock.o print.o alias.o log_pthread.o \
-	log.o configure.o structs_vec.o sysfs.o prio.o checkers.o \
+	log.o configure.o structs_vec.o sysfs.o \
 	lock.o file.o wwids.o prioritizers/alua_rtpg.o prkey.o \
-	io_err_stat.o dm-generic.o generic.o foreign.o nvme-lib.o \
+	io_err_stat.o dm-generic.o generic.o nvme-lib.o \
 	libsg.o valid.o strbuf.o
 
+OBJS := $(OBJS-O) $(OBJS-U)
+
 all:	$(DEVLIB)
 
 nvme-lib.o: nvme-lib.c nvme-ioctl.c nvme-ioctl.h
@@ -97,11 +104,16 @@ $(LIBS:%.so.$(SONAME)=%-nv.so):	$(OBJS) $(NV_VERSION_SCRIPT)
 
 abi:    $(LIBS:%.so.$(SONAME)=%-nv.abi)
 
-../tests/$(LIBS): $(OBJS) $(VERSION_SCRIPT)
+../tests/$(LIBS): $(OBJS-O) $(OBJS-T) $(VERSION_SCRIPT)
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=`basename $@` \
-		-o $@ $(OBJS) $(LIBDEPS)
+		-o $@ $(OBJS-O) $(OBJS-T) $(LIBDEPS)
 	$(LN) $@ ${@:.so.0=.so}
 
+# This rule is invoked from tests/Makefile, overriding configdir and plugindir
+%-test.o: %.c
+	@echo building $@ because of $?
+	$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<
+
 test-lib:	../tests/$(LIBS)
 
 install: all
diff --git a/tests/Makefile b/tests/Makefile
index 8cbc4b7..7341b7e 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -9,7 +9,7 @@ TEST_MISSING_INITIALIZERS = $(shell \
 W_MISSING_INITIALIZERS := $(call TEST_MISSING_INITIALIZERS)
 
 CFLAGS += $(BIN_CFLAGS) -I$(multipathdir) -I$(mpathcmddir) \
-	-Wno-unused-parameter $(W_MISSING_INITIALIZERS)
+	-Wno-unused-parameter $(W_MISSING_INITIALIZERS) -DTESTCONFDIR=\"$(CURDIR)/conf.d\"
 LIBDEPS += -L. -L$(mpathcmddir) -lmultipath -lmpathcmd -lcmocka
 
 TESTS := uevent parser util dmevents hwtable blacklist unaligned vpd pgpolicy \
@@ -40,6 +40,9 @@ mpathvalid-test_FLAGS := -I$(mpathvaliddir)
 #    That may be necessary if functions called from the object file are wrapped
 #    (wrapping works only for symbols which are undefined after processing a
 #    linker input file).
+#    Some object files, e.g. "config.o", are compiled separately for the
+#    unit tests. Look for OBJS-U in libmultipath/Makefile. Make sure to use the
+#    unit test file, e.g. "config-test.o", in XYZ-test_OBJDEPS
 # XYZ-test_LIBDEPS: Additional libs to link for this test
 
 dmevents-test_OBJDEPS = ../libmultipath/devmapper.o
@@ -91,7 +94,7 @@ valgrind_clean:
 
 clean: test_clean valgrind_clean dep_clean
 	$(RM) $(TESTS:%=%-test) $(OBJS) *.o.wrap
-	$(RM) -rf lib
+	$(RM) -rf lib conf.d
 
 .SECONDARY: $(OBJS)
 
@@ -105,7 +108,7 @@ dep_clean:
 		sort -u | tr '\n' ' ' >$@
 
 libmultipath.so.0:
-	$(MAKE) -C $(multipathdir) test-lib
+	make -C $(multipathdir) configdir=$(CURDIR)/conf.d plugindir=$(CURDIR)/lib test-lib
 
 # COLON will get expanded during second expansion below
 COLON:=:
diff --git a/tests/hwtable.c b/tests/hwtable.c
index 79bfa5f..400e114 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -143,12 +143,11 @@ static int setup(void **state)
 	}
 	hwt->tmpname = strdup(buf);
 
-	snprintf(buf, sizeof(buf), "%s", tmplate);
-	if (mkdtemp(buf) == NULL) {
-		condlog(0, "mkdtemp (2): %s", strerror(errno));
+	hwt->dirname = strdup(TESTCONFDIR);
+	if (mkdir(hwt->dirname, 0744) != 0) {
+		condlog(0, "mkdir %s: %s", hwt->dirname, strerror(errno));
 		goto err;
 	}
-	hwt->dirname = strdup(buf);
 
 	make_config_file_path(buf, sizeof(buf), hwt, -1);
 	hwt->config_file = fopen(buf, "w+");
-- 
2.36.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

