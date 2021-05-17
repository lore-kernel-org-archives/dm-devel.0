Return-Path: <SRS0=cSVF=KM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B05E1C433B4
	for <dm-devel@archiver.kernel.org>; Mon, 17 May 2021 21:20:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3A9B2611ED
	for <dm-devel@archiver.kernel.org>; Mon, 17 May 2021 21:20:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A9B2611ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-sPldbXLnNkme4YzesBd0iA-1; Mon, 17 May 2021 17:20:09 -0400
X-MC-Unique: sPldbXLnNkme4YzesBd0iA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA6486D253;
	Mon, 17 May 2021 21:20:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A0D495D6A8;
	Mon, 17 May 2021 21:20:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6E24055353;
	Mon, 17 May 2021 21:20:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14HLJppj030516 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 17 May 2021 17:19:51 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 911E91102E3F; Mon, 17 May 2021 21:19:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C76D1111A76
	for <dm-devel@redhat.com>; Mon, 17 May 2021 21:19:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8EE5C800B29
	for <dm-devel@redhat.com>; Mon, 17 May 2021 21:19:45 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-600-nDUv5rWuOd-iJOzl8Y5u6g-1;
	Mon, 17 May 2021 17:19:40 -0400
X-MC-Unique: nDUv5rWuOd-iJOzl8Y5u6g-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 96CE5B12C;
	Mon, 17 May 2021 21:19:39 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Mon, 17 May 2021 23:19:08 +0200
Message-Id: <20210517211909.21776-3-mwilck@suse.com>
In-Reply-To: <20210517211909.21776-1-mwilck@suse.com>
References: <20210517211909.21776-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14HLJppj030516
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 3/4] multipath-tools: enable -Wformat-overflow=2
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

Allow the compiler to catch possible format string overflows.
Two were found by gcc 10.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc             | 2 +-
 libmultipath/discovery.c | 2 +-
 libmultipath/print.c     | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index f1e2313..8a7a648 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -97,7 +97,7 @@ ERROR_DISCARDED_QUALIFIERS := $(call TEST_CC_OPTION,-Werror=discarded-qualifiers
 WNOCLOBBERED := $(call TEST_CC_OPTION,-Wno-clobbered -Wno-error=clobbered,)
 
 OPTFLAGS	:= -O2 -g $(STACKPROT) --param=ssp-buffer-size=4
-WARNFLAGS	:= -Werror -Wall -Wextra -Wformat=2 -Werror=implicit-int \
+WARNFLAGS	:= -Werror -Wall -Wextra -Wformat=2 -Wformat-overflow=2 -Werror=implicit-int \
 		  -Werror=implicit-function-declaration -Werror=format-security \
 		  $(WNOCLOBBERED) -Werror=cast-qual $(ERROR_DISCARDED_QUALIFIERS)
 CPPFLAGS	:= -Wp,-D_FORTIFY_SOURCE=2 
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index ec99a7a..bfe2f56 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -635,7 +635,7 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 {
 	struct udev_device *rport_dev = NULL;
 	char value[16], *eptr;
-	char rport_id[32];
+	char rport_id[42];
 	unsigned int tmo;
 	int ret;
 
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 8151e11..3c69bf4 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -1,4 +1,4 @@
-/*
+ /*
  * Copyright (c) 2005 Christophe Varoqui
  */
 #include <stdio.h>
@@ -594,7 +594,7 @@ int
 snprint_tgt_wwpn (char * buff, size_t len, const struct path * pp)
 {
 	struct udev_device *rport_dev = NULL;
-	char rport_id[32];
+	char rport_id[42];
 	const char *value = NULL;
 	int ret;
 
-- 
2.31.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

