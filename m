Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81989C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 24 Mar 2022 21:19:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-5-WhlMdPqnP7Kn7qwac0Pe9Q-1; Thu, 24 Mar 2022 17:19:44 -0400
X-MC-Unique: WhlMdPqnP7Kn7qwac0Pe9Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8040E802819;
	Thu, 24 Mar 2022 21:19:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 32CC3C27D8E;
	Thu, 24 Mar 2022 21:19:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0164B194034E;
	Thu, 24 Mar 2022 21:19:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 90DF0194034E
 for <dm-devel@listman.corp.redhat.com>; Thu, 24 Mar 2022 21:19:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5919E5B49BB; Thu, 24 Mar 2022 21:19:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 559905B4983
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 21:19:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3EC00185A7A4
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 21:19:39 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-450-JPT2UvJQN6e2LedFKXyXBw-1; Thu, 24 Mar 2022 17:19:36 -0400
X-MC-Unique: JPT2UvJQN6e2LedFKXyXBw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 47A83210FC;
 Thu, 24 Mar 2022 21:19:35 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 090D612FF7;
 Thu, 24 Mar 2022 21:19:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id AF0vAGfgPGLBJwAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 24 Mar 2022 21:19:35 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Guozhonghua <guozh88@chinatelecom.cn>
Date: Thu, 24 Mar 2022 22:19:27 +0100
Message-Id: <20220324211927.7152-3-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH v3 12/12] multipathd: decrease verbosity of
 handle_signal()
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

The "reset log" message isn't very important, and the others will
be followed by more meaningful messages when multipathd actually
exits, or reconfigures itself.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index aee0953..1406251 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2927,18 +2927,18 @@ void
 handle_signals(bool nonfatal)
 {
 	if (exit_sig) {
-		condlog(2, "exit (signal)");
+		condlog(3, "exit (signal)");
 		exit_sig = 0;
 		exit_daemon();
 	}
 	if (!nonfatal)
 		return;
 	if (reconfig_sig) {
-		condlog(2, "reconfigure (signal)");
+		condlog(3, "reconfigure (signal)");
 		schedule_reconfigure(FORCE_RELOAD_WEAK);
 	}
 	if (log_reset_sig) {
-		condlog(2, "reset log (signal)");
+		condlog(3, "reset log (signal)");
 		if (logsink == LOGSINK_SYSLOG)
 			log_thread_reset();
 	}
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

