Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF04C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:05:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6D33A6128E
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:05:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6D33A6128E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-346-41jSVJKYOMykYn9AvBDJmA-1; Thu, 18 Nov 2021 18:05:44 -0500
X-MC-Unique: 41jSVJKYOMykYn9AvBDJmA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 794571060D79;
	Thu, 18 Nov 2021 23:05:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E6CC5D6B1;
	Thu, 18 Nov 2021 23:05:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 399151832DD2;
	Thu, 18 Nov 2021 23:05:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIMx6SQ002076 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 17:59:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9934240CFD12; Thu, 18 Nov 2021 22:59:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9108B40CFD11
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75DD3805B0A
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:06 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-34-Mp2_IRsmN86PxmWamnd-Pg-1; Thu, 18 Nov 2021 17:59:00 -0500
X-MC-Unique: Mp2_IRsmN86PxmWamnd-Pg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9E1AE218E0;
	Thu, 18 Nov 2021 22:58:59 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4B14513B11;
	Thu, 18 Nov 2021 22:58:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id YP9YELPalmGHPAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 22:58:59 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 18 Nov 2021 23:58:00 +0100
Message-Id: <20211118225840.19810-9-mwilck@suse.com>
In-Reply-To: <20211118225840.19810-1-mwilck@suse.com>
References: <20211118225840.19810-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AIMx6SQ002076
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 08/48] multipathd: cli.h: formatting
	improvements
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

No functional changes. Just make the code a little easier to read.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/cli.h | 82 ++++++++++++++++++++++++------------------------
 1 file changed, 41 insertions(+), 41 deletions(-)

diff --git a/multipathd/cli.h b/multipathd/cli.h
index fdfb9ae..1e8948a 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -4,83 +4,83 @@
 #include <stdint.h>
 
 enum {
-	__LIST,
+	__LIST,			/*  0 */
 	__ADD,
 	__DEL,
 	__SWITCH,
 	__SUSPEND,
-	__RESUME,
+	__RESUME,			/*  5 */
 	__REINSTATE,
 	__FAIL,
 	__RESIZE,
 	__RESET,
-	__RELOAD,
+	__RELOAD,			/* 10 */
 	__FORCEQ,
 	__DISABLEQ,
 	__RESTOREQ,
 	__PATHS,
-	__MAPS,
+	__MAPS,			/* 15 */
 	__PATH,
 	__MAP,
 	__GROUP,
 	__RECONFIGURE,
-	__DAEMON,
+	__DAEMON,			/* 20 */
 	__STATUS,
 	__STATS,
 	__TOPOLOGY,
 	__CONFIG,
-	__BLACKLIST,
+	__BLACKLIST,			/* 25 */
 	__DEVICES,
 	__RAW,
 	__WILDCARDS,
 	__QUIT,
-	__SHUTDOWN,
+	__SHUTDOWN,			/* 30 */
 	__GETPRSTATUS,
 	__SETPRSTATUS,
 	__UNSETPRSTATUS,
 	__FMT,
-	__JSON,
+	__JSON,			/* 35 */
 	__GETPRKEY,
 	__SETPRKEY,
 	__UNSETPRKEY,
 	__KEY,
-	__LOCAL,
+	__LOCAL,			/* 40 */
 	__SETMARGINAL,
 	__UNSETMARGINAL,
 };
 
-#define LIST		(1 << __LIST)
-#define ADD		(1 << __ADD)
-#define DEL		(1 << __DEL)
-#define SWITCH		(1 << __SWITCH)
-#define SUSPEND		(1 << __SUSPEND)
-#define RESUME		(1 << __RESUME)
-#define REINSTATE	(1 << __REINSTATE)
-#define FAIL		(1 << __FAIL)
-#define RESIZE		(1 << __RESIZE)
-#define RESET		(1 << __RESET)
-#define RELOAD		(1 << __RELOAD)
-#define FORCEQ		(1 << __FORCEQ)
-#define DISABLEQ	(1 << __DISABLEQ)
-#define RESTOREQ	(1 << __RESTOREQ)
-#define PATHS		(1 << __PATHS)
-#define MAPS		(1 << __MAPS)
-#define PATH		(1 << __PATH)
-#define MAP		(1 << __MAP)
-#define GROUP		(1 << __GROUP)
-#define RECONFIGURE	(1 << __RECONFIGURE)
-#define DAEMON		(1 << __DAEMON)
-#define STATUS		(1 << __STATUS)
-#define STATS		(1 << __STATS)
-#define TOPOLOGY	(1 << __TOPOLOGY)
-#define CONFIG		(1 << __CONFIG)
-#define BLACKLIST	(1 << __BLACKLIST)
-#define DEVICES		(1 << __DEVICES)
-#define RAW		(1 << __RAW)
-#define COUNT		(1 << __COUNT)
-#define WILDCARDS	(1 << __WILDCARDS)
-#define QUIT		(1 << __QUIT)
-#define SHUTDOWN	(1 << __SHUTDOWN)
+#define LIST		(1ULL << __LIST)
+#define ADD		(1ULL << __ADD)
+#define DEL		(1ULL << __DEL)
+#define SWITCH		(1ULL << __SWITCH)
+#define SUSPEND	(1ULL << __SUSPEND)
+#define RESUME		(1ULL << __RESUME)
+#define REINSTATE	(1ULL << __REINSTATE)
+#define FAIL		(1ULL << __FAIL)
+#define RESIZE		(1ULL << __RESIZE)
+#define RESET		(1ULL << __RESET)
+#define RELOAD		(1ULL << __RELOAD)
+#define FORCEQ		(1ULL << __FORCEQ)
+#define DISABLEQ	(1ULL << __DISABLEQ)
+#define RESTOREQ	(1ULL << __RESTOREQ)
+#define PATHS		(1ULL << __PATHS)
+#define MAPS		(1ULL << __MAPS)
+#define PATH		(1ULL << __PATH)
+#define MAP		(1ULL << __MAP)
+#define GROUP		(1ULL << __GROUP)
+#define RECONFIGURE	(1ULL << __RECONFIGURE)
+#define DAEMON		(1ULL << __DAEMON)
+#define STATUS		(1ULL << __STATUS)
+#define STATS		(1ULL << __STATS)
+#define TOPOLOGY	(1ULL << __TOPOLOGY)
+#define CONFIG		(1ULL << __CONFIG)
+#define BLACKLIST	(1ULL << __BLACKLIST)
+#define DEVICES	(1ULL << __DEVICES)
+#define RAW		(1ULL << __RAW)
+#define COUNT		(1ULL << __COUNT)
+#define WILDCARDS	(1ULL << __WILDCARDS)
+#define QUIT		(1ULL << __QUIT)
+#define SHUTDOWN	(1ULL << __SHUTDOWN)
 #define GETPRSTATUS	(1ULL << __GETPRSTATUS)
 #define SETPRSTATUS	(1ULL << __SETPRSTATUS)
 #define UNSETPRSTATUS	(1ULL << __UNSETPRSTATUS)
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

