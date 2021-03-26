Return-Path: <SRS0=sRxI=IY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D07FC433DB
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 21:31:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B3629619D3
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 21:31:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B3629619D3
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-cjq3DjryP0aAUiP9nvy40Q-1; Fri, 26 Mar 2021 17:31:01 -0400
X-MC-Unique: cjq3DjryP0aAUiP9nvy40Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F7BC814256;
	Fri, 26 Mar 2021 21:30:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 603261725E;
	Fri, 26 Mar 2021 21:30:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 305FE4BB7C;
	Fri, 26 Mar 2021 21:30:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12QLU93Z001679 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 26 Mar 2021 17:30:09 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 002142026D2D; Fri, 26 Mar 2021 21:30:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EEF972026D6A
	for <dm-devel@redhat.com>; Fri, 26 Mar 2021 21:30:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 89C43185A7B4
	for <dm-devel@redhat.com>; Fri, 26 Mar 2021 21:30:05 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-486-Kbppyf2qMHS2rU0pLQsTkQ-1;
	Fri, 26 Mar 2021 17:30:00 -0400
X-MC-Unique: Kbppyf2qMHS2rU0pLQsTkQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 0C3A5AD8D;
	Fri, 26 Mar 2021 21:29:59 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 26 Mar 2021 22:29:38 +0100
Message-Id: <20210326212944.3136-2-mwilck@suse.com>
In-Reply-To: <20210326212944.3136-1-mwilck@suse.com>
References: <20210326212944.3136-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12QLU93Z001679
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 1/7] multipath-tools Makefiles: make pkg-config
	configurable
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

This is useful for building in a cross-compilation environment.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc     | 6 ++++--
 libdmmp/Makefile | 4 ++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 0542930..f1e2313 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -15,6 +15,8 @@
 # Uncomment to disable dmevents polling support
 # ENABLE_DMEVENTS_POLL = 0
 
+PKGCONFIG	?= pkg-config
+
 ifeq ($(TOPDIR),)
 	TOPDIR	= ..
 endif
@@ -36,8 +38,8 @@ ifndef RUN
 endif
 
 ifndef SYSTEMD
-	ifeq ($(shell pkg-config --modversion libsystemd >/dev/null 2>&1 && echo 1), 1)
-		SYSTEMD = $(shell pkg-config --modversion libsystemd | awk '{print $$1}')
+	ifeq ($(shell $(PKGCONFIG) --modversion libsystemd >/dev/null 2>&1 && echo 1), 1)
+		SYSTEMD = $(shell $(PKGCONFIG) --modversion libsystemd | awk '{print $$1}')
 	else
 		ifeq ($(shell systemctl --version >/dev/null 2>&1 && echo 1), 1)
 			SYSTEMD = $(shell systemctl --version 2> /dev/null | \
diff --git a/libdmmp/Makefile b/libdmmp/Makefile
index 1dd3f34..4175c3f 100644
--- a/libdmmp/Makefile
+++ b/libdmmp/Makefile
@@ -16,9 +16,9 @@ HEADERS = libdmmp/libdmmp.h
 OBJS = libdmmp.o libdmmp_mp.o libdmmp_pg.o libdmmp_path.o libdmmp_misc.o
 
 CFLAGS += $(LIB_CFLAGS) -fvisibility=hidden -I$(libdmmpdir) -I$(mpathcmddir) \
-	  $(shell pkg-config --cflags json-c)
+	  $(shell $(PKGCONFIG) --cflags json-c)
 
-LIBDEPS += $(shell pkg-config --libs json-c) -L$(mpathcmddir) -lmpathcmd -lpthread
+LIBDEPS += $(shell $(PKGCONFIG) --libs json-c) -L$(mpathcmddir) -lmpathcmd -lpthread
 
 all: $(LIBS) doc
 
-- 
2.30.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

