Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6856C43457
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:43:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1FEEF212CC
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:43:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1FEEF212CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-EVKqg7hPMium36nLMeR4ZQ-1; Fri, 16 Oct 2020 06:43:31 -0400
X-MC-Unique: EVKqg7hPMium36nLMeR4ZQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A13FF107B470;
	Fri, 16 Oct 2020 10:43:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 83CBB5C1D0;
	Fri, 16 Oct 2020 10:43:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 57C03181A2E5;
	Fri, 16 Oct 2020 10:43:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GAhCC3019931 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 06:43:13 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C09EC16C2DD; Fri, 16 Oct 2020 10:43:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B870416C2DE
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 03314182360F
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:11 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-523-lK4qnxt1NsasIIPnLr9Iww-1;
	Fri, 16 Oct 2020 06:43:08 -0400
X-MC-Unique: lK4qnxt1NsasIIPnLr9Iww-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id BF5C0B2B4;
	Fri, 16 Oct 2020 10:43:05 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 16 Oct 2020 12:42:35 +0200
Message-Id: <20201016104239.8217-9-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09GAhCC3019931
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 08/12] libmultipath: create separate .so for
	unit tests
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

The unit tests use a lot of internal symbols that we don't want
to add to the ABI if we don't have to. As long as we don't
have to make incompatible changes to functions, we can work around
that by simply using a non-versioned library for the unit tests.
Therefore we add a seperate rule here. Do this before actually
adding a version script, to avoid breakage during bisection.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/Makefile |  7 +++++++
 tests/Makefile        | 10 ++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index af5bb77..cf13561 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -74,6 +74,13 @@ $(LIBS): $(OBJS)
 $(DEVLIB): $(LIBS)
 	$(LN) $(LIBS) $@
 
+../tests/$(LIBS): $(OBJS) $(VERSION_SCRIPT)
+	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=`basename $@` \
+		-o $@ $(OBJS) $(LIBDEPS)
+	$(LN) $@ ${@:.so.0=.so}
+
+test-lib:	../tests/$(LIBS)
+
 install: all
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(syslibdir)
 	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
diff --git a/tests/Makefile b/tests/Makefile
index 502377f..f6ef16a 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -10,7 +10,7 @@ W_MISSING_INITIALIZERS := $(call TEST_MISSING_INITIALIZERS)
 
 CFLAGS += $(BIN_CFLAGS) -I$(multipathdir) -I$(mpathcmddir) \
 	-Wno-unused-parameter $(W_MISSING_INITIALIZERS)
-LIBDEPS += -L$(multipathdir) -L$(mpathcmddir) -lmultipath -lmpathcmd -lcmocka
+LIBDEPS += -L. -L$(mpathcmddir) -lmultipath -lmpathcmd -lcmocka
 
 TESTS := uevent parser util dmevents hwtable blacklist unaligned vpd pgpolicy \
 	 alias directio valid devt
@@ -67,7 +67,7 @@ lib/libchecktur.so:
 
 %.out:	%-test lib/libchecktur.so
 	@echo == running $< ==
-	@LD_LIBRARY_PATH=$(multipathdir):$(mpathcmddir) ./$< >$@
+	@LD_LIBRARY_PATH=.:$(mpathcmddir) ./$< >$@
 
 %.vgr:  %-test lib/libchecktur.so
 	@echo == running valgrind for $< ==
@@ -77,7 +77,7 @@ lib/libchecktur.so:
 OBJS = $(TESTS:%=%.o) test-lib.o
 
 test_clean:
-	$(RM) $(TESTS:%=%.out) $(TESTS:%=%.vgr)
+	$(RM) $(TESTS:%=%.out) $(TESTS:%=%.vgr) *.so*
 
 valgrind_clean:
 	$(RM) $(TESTS:%=%.vgr)
@@ -97,12 +97,14 @@ dep_clean:
 	@sed -n 's/^.*__wrap_\([a-zA-Z0-9_]*\).*$$/-Wl,--wrap=\1/p' $< | \
 		sort -u | tr '\n' ' ' >$@
 
+libmultipath.so.0:
+	$(MAKE) -C $(multipathdir) test-lib
 
 # COLON will get expanded during second expansion below
 COLON:=:
 .SECONDEXPANSION:
 %-test:	%.o %.o.wrap $$($$@_OBJDEPS) $$($$@_TESTDEPS) $$($$@_TESTDEPS$$(COLON).o=.o.wrap) \
-		$(multipathdir)/libmultipath.so Makefile
+		libmultipath.so.0 Makefile
 	$(CC) $(CFLAGS) -o $@ $(LDFLAGS) $< $($@_TESTDEPS) $($@_OBJDEPS) \
 		$(LIBDEPS) $($@_LIBDEPS) \
 		$(shell cat $<.wrap) $(foreach dep,$($@_TESTDEPS),$(shell cat $(dep).wrap))
-- 
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

