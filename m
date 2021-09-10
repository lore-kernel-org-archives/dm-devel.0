Return-Path: <SRS0=FvAS=OA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66110C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 10 Sep 2021 11:43:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D7AC1611C2
	for <dm-devel@archiver.kernel.org>; Fri, 10 Sep 2021 11:43:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D7AC1611C2
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-giyVe_3rM3-09GWKNq6puw-1; Fri, 10 Sep 2021 07:43:07 -0400
X-MC-Unique: giyVe_3rM3-09GWKNq6puw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C964E1006AA5;
	Fri, 10 Sep 2021 11:43:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9006418FD2;
	Fri, 10 Sep 2021 11:43:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 755E51803B30;
	Fri, 10 Sep 2021 11:42:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18ABgvRi010145 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 10 Sep 2021 07:42:57 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3202B210C6D4; Fri, 10 Sep 2021 11:42:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2CF31210FE3C
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 11:42:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0CE9C800B26
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 11:42:56 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-347-mKzpLzNoMbie-XFXSlAnfQ-1; Fri, 10 Sep 2021 07:42:54 -0400
X-MC-Unique: mKzpLzNoMbie-XFXSlAnfQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BBE5820203;
	Fri, 10 Sep 2021 11:42:52 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 713EF13D34;
	Fri, 10 Sep 2021 11:42:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id aLakGbxEO2GPOAAAMHmgww
	(envelope-from <mwilck@suse.com>); Fri, 10 Sep 2021 11:42:52 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 10 Sep 2021 13:40:53 +0200
Message-Id: <20210910114120.13665-9-mwilck@suse.com>
In-Reply-To: <20210910114120.13665-1-mwilck@suse.com>
References: <20210910114120.13665-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18ABgvRi010145
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 08/35] multipathd: cli.h: formatting improvements
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

No functional changes. Just make the code a little easier to read.

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
2.33.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

