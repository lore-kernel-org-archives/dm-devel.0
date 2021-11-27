Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54D87C4332F
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:20:44 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-188-LT0RnbYVPB2u8SQzkeVOMg-1; Sat, 27 Nov 2021 10:20:39 -0500
X-MC-Unique: LT0RnbYVPB2u8SQzkeVOMg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A49CD39393;
	Sat, 27 Nov 2021 15:20:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8BC0917D72;
	Sat, 27 Nov 2021 15:20:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 658364A7CB;
	Sat, 27 Nov 2021 15:20:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFJo6m032701 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:19:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 07A52404727A; Sat, 27 Nov 2021 15:19:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 03B434047272
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E1A69811E78
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:49 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-376-PLAmQX-ePDSh1Q5s3Cjzyw-1; Sat, 27 Nov 2021 10:19:46 -0500
X-MC-Unique: PLAmQX-ePDSh1Q5s3Cjzyw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8CF0921637;
	Sat, 27 Nov 2021 15:19:44 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 40FF513AAD;
	Sat, 27 Nov 2021 15:19:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 6JG+DZBMomErFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:19:44 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:19:01 +0100
Message-Id: <20211127151929.7727-9-mwilck@suse.com>
In-Reply-To: <20211127151929.7727-1-mwilck@suse.com>
References: <20211127151929.7727-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFJo6m032701
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 08/35] multipathd: cli.h: formatting
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
index d224a2d..6a68107 100644
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

