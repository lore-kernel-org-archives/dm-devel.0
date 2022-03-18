Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6A5FC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 18 Mar 2022 22:34:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-Nlbl_eABPH6FvVBWmdmU1A-1; Fri, 18 Mar 2022 18:34:03 -0400
X-MC-Unique: Nlbl_eABPH6FvVBWmdmU1A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2A3A3C02B91;
	Fri, 18 Mar 2022 22:34:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9276A145B978;
	Fri, 18 Mar 2022 22:34:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0AFC8192B828;
	Fri, 18 Mar 2022 22:33:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 69CCF194035B
 for <dm-devel@listman.corp.redhat.com>; Fri, 18 Mar 2022 22:33:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 544C933250; Fri, 18 Mar 2022 22:33:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F084420A9
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 22:33:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F1E585A5A8
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 22:33:55 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-203-zYif-XeRN4qcxJIGwRkqzQ-1; Fri, 18 Mar 2022 18:33:50 -0400
X-MC-Unique: zYif-XeRN4qcxJIGwRkqzQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id BAFF71F37F;
 Fri, 18 Mar 2022 22:33:48 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7BA31132D4;
 Fri, 18 Mar 2022 22:33:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id YPZQHMwINWLSdwAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 18 Mar 2022 22:33:48 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Guozhonghua <guozh88@chinatelecom.cn>
Date: Fri, 18 Mar 2022 23:33:29 +0100
Message-Id: <20220318223339.4226-2-mwilck@suse.com>
In-Reply-To: <20220318223339.4226-1-mwilck@suse.com>
References: <20220318223339.4226-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [PATCH v2 01/11] multipathd: child(): remove superfluous
 if condition
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

No need to test for state == DAEMON_CONFIGURE at this point, we
know that this is the case.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index f2c0b28..1c8839d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3395,6 +3395,8 @@ child (__attribute__((unused)) void *param)
 	pthread_attr_destroy(&misc_attr);
 
 	while (1) {
+		int rc = 0;
+
 		pthread_cleanup_push(config_cleanup, NULL);
 		pthread_mutex_lock(&config_lock);
 		while (running_state != DAEMON_CONFIGURE &&
@@ -3404,23 +3406,21 @@ child (__attribute__((unused)) void *param)
 		pthread_cleanup_pop(1);
 		if (state == DAEMON_SHUTDOWN)
 			break;
-		if (state == DAEMON_CONFIGURE) {
-			int rc = 0;
 
-			pthread_cleanup_push(cleanup_lock, &vecs->lock);
-			lock(&vecs->lock);
-			pthread_testcancel();
-			if (!need_to_delay_reconfig(vecs))
-				rc = reconfigure(vecs);
-			else
-				enable_delayed_reconfig();
-			lock_cleanup_pop(vecs->lock);
-			if (!rc)
-				post_config_state(DAEMON_IDLE);
-			else {
-				condlog(0, "fatal error applying configuration - aborting");
-				exit_daemon();
-			}
+		/* handle DAEMON_CONFIGURE */
+		pthread_cleanup_push(cleanup_lock, &vecs->lock);
+		lock(&vecs->lock);
+		pthread_testcancel();
+		if (!need_to_delay_reconfig(vecs))
+			rc = reconfigure(vecs);
+		else
+			enable_delayed_reconfig();
+		lock_cleanup_pop(vecs->lock);
+		if (!rc)
+			post_config_state(DAEMON_IDLE);
+		else {
+			condlog(0, "fatal error applying configuration - aborting");
+			exit_daemon();
 		}
 	}
 
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

