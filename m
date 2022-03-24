Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F364C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 24 Mar 2022 21:19:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-550-b802UrsTMdKVrlo3HZ3aaw-1; Thu, 24 Mar 2022 17:19:46 -0400
X-MC-Unique: b802UrsTMdKVrlo3HZ3aaw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C6F2C804183;
	Thu, 24 Mar 2022 21:19:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B2D49400F73B;
	Thu, 24 Mar 2022 21:19:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 60C9F194034B;
	Thu, 24 Mar 2022 21:19:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3AE971940341
 for <dm-devel@listman.corp.redhat.com>; Thu, 24 Mar 2022 21:19:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0AC9C1454559; Thu, 24 Mar 2022 21:19:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 071661454539
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 21:19:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E0F42185A79C
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 21:19:37 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-241-2cSeLWFcNfWQ5j-njXsw3Q-1; Thu, 24 Mar 2022 17:19:36 -0400
X-MC-Unique: 2cSeLWFcNfWQ5j-njXsw3Q-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id F161C1F745;
 Thu, 24 Mar 2022 21:19:34 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B1FE112FF7;
 Thu, 24 Mar 2022 21:19:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id MIF/KWbgPGLBJwAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 24 Mar 2022 21:19:34 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Guozhonghua <guozh88@chinatelecom.cn>
Date: Thu, 24 Mar 2022 22:19:26 +0100
Message-Id: <20220324211927.7152-2-mwilck@suse.com>
In-Reply-To: <20220324211927.7152-1-mwilck@suse.com>
References: <20220324211927.7152-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH v3 11/12] multipathd: make startup / shutdown
 messages less noisy
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

These messages are noisy in the system log without being actually helpful.
Print the version number on startup.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 9ef3197..aee0953 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -37,6 +37,7 @@
 /*
  * libmultipath
  */
+#include "version.h"
 #include "parser.h"
 #include "vector.h"
 #include "config.h"
@@ -2566,7 +2567,6 @@ checkerloop (void *ap)
 	rcu_register_thread();
 	mlockall(MCL_CURRENT | MCL_FUTURE);
 	vecs = (struct vectors *)ap;
-	condlog(2, "path checkers start up");
 
 	/* Tweak start time for initial path check */
 	get_monotonic_time(&last_time);
@@ -3247,8 +3247,8 @@ child (__attribute__((unused)) void *param)
 
 	post_config_state(DAEMON_START);
 
-	condlog(2, "--------start up--------");
-	condlog(2, "read " DEFAULT_CONFIGFILE);
+	condlog(2, "multipathd v%d.%d.%d: start up", MULTIPATH_VERSION(VERSION_CODE));
+	condlog(3, "read " DEFAULT_CONFIGFILE);
 
 	if (verbosity)
 		libmp_verbosity = verbosity;
@@ -3441,7 +3441,7 @@ child (__attribute__((unused)) void *param)
 
 	exit_code = 0;
 failed:
-	condlog(2, "--------shut down-------");
+	condlog(2, "multipathd: shut down");
 	/* All cleanup is done in the cleanup_child() exit handler */
 	return sd_notify_exit(exit_code);
 }
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

