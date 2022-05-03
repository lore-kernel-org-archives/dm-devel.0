Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 356F6C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  3 May 2022 22:09:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-216-w0mHmEtWMgSRguu8ma68Dg-1; Tue, 03 May 2022 18:09:44 -0400
X-MC-Unique: w0mHmEtWMgSRguu8ma68Dg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC85894A2AA;
	Tue,  3 May 2022 22:07:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AACB2C27EA6;
	Tue,  3 May 2022 22:07:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 40B821947040;
	Tue,  3 May 2022 22:07:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1137819466DF
 for <dm-devel@listman.corp.redhat.com>; Tue,  3 May 2022 22:07:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D135F9E89; Tue,  3 May 2022 22:07:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CCC389E84
 for <dm-devel@redhat.com>; Tue,  3 May 2022 22:07:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68EC794A29C
 for <dm-devel@redhat.com>; Tue,  3 May 2022 22:07:34 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-489-ZBnqoL-AM_21O0Zawc1NTQ-1; Tue, 03 May 2022 18:07:25 -0400
X-MC-Unique: ZBnqoL-AM_21O0Zawc1NTQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 80915210F4;
 Tue,  3 May 2022 22:07:17 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 50E9C13ABE;
 Tue,  3 May 2022 22:07:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id UGQMEpWncWLfFgAAMHmgww
 (envelope-from <mwilck@suse.com>); Tue, 03 May 2022 22:07:17 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  4 May 2022 00:06:45 +0200
Message-Id: <20220503220646.16925-7-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [PATCH 6/7] tests/Makefile: make TESTDIR configurable
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

This is required for the "foreign arch" workflow, where build
and test dir aren't necessarily equal.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/Makefile | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tests/Makefile b/tests/Makefile
index 7341b7e..0b39c30 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -1,5 +1,8 @@
 include ../Makefile.inc
 
+# directory where to run the tests
+TESTDIR := $(CURDIR)
+
 # Test special behavior of gcc 4.8 with nested initializers
 # gcc 4.8 compiles blacklist.c only with -Wno-missing-field-initializers
 TEST_MISSING_INITIALIZERS = $(shell \
@@ -9,7 +12,7 @@ TEST_MISSING_INITIALIZERS = $(shell \
 W_MISSING_INITIALIZERS := $(call TEST_MISSING_INITIALIZERS)
 
 CFLAGS += $(BIN_CFLAGS) -I$(multipathdir) -I$(mpathcmddir) \
-	-Wno-unused-parameter $(W_MISSING_INITIALIZERS) -DTESTCONFDIR=\"$(CURDIR)/conf.d\"
+	-Wno-unused-parameter $(W_MISSING_INITIALIZERS) -DTESTCONFDIR=\"$(TESTDIR)/conf.d\"
 LIBDEPS += -L. -L$(mpathcmddir) -lmultipath -lmpathcmd -lcmocka
 
 TESTS := uevent parser util dmevents hwtable blacklist unaligned vpd pgpolicy \
@@ -108,7 +111,7 @@ dep_clean:
 		sort -u | tr '\n' ' ' >$@
 
 libmultipath.so.0:
-	make -C $(multipathdir) configdir=$(CURDIR)/conf.d plugindir=$(CURDIR)/lib test-lib
+	make -C $(multipathdir) configdir=$(TESTDIR)/conf.d plugindir=$(TESTDIR)/lib test-lib
 
 # COLON will get expanded during second expansion below
 COLON:=:
-- 
2.36.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

