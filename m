Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7CF1C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 18 Mar 2022 22:34:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-RpgbhqxAMb-qRgff0XFKYg-1; Fri, 18 Mar 2022 18:34:07 -0400
X-MC-Unique: RpgbhqxAMb-qRgff0XFKYg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 658BB3804078;
	Fri, 18 Mar 2022 22:34:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 52C57404D91D;
	Fri, 18 Mar 2022 22:34:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BE06419641A3;
	Fri, 18 Mar 2022 22:34:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9BC68196634F
 for <dm-devel@listman.corp.redhat.com>; Fri, 18 Mar 2022 22:33:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 84D50200B696; Fri, 18 Mar 2022 22:33:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 80404200B419
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 22:33:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D329811E75
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 22:33:52 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-65-dhGX8sJiPZaVh_fNssyojg-1; Fri, 18 Mar 2022 18:33:50 -0400
X-MC-Unique: dhGX8sJiPZaVh_fNssyojg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 5D8061F38F;
 Fri, 18 Mar 2022 22:33:49 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1F71F132D4;
 Fri, 18 Mar 2022 22:33:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id gDqzBc0INWLSdwAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 18 Mar 2022 22:33:49 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Guozhonghua <guozh88@chinatelecom.cn>
Date: Fri, 18 Mar 2022 23:33:31 +0100
Message-Id: <20220318223339.4226-4-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: [dm-devel] [PATCH v2 03/11] multipathd: avoid busy loop in child()
 for delayed reconfigure
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

If need_to_delay_reconfig() returned true, the logic introduced
by 250708c ("multipathd: improve delayed reconfigure") and
4b104e6 ("multipathd: pass in the type of reconfigure") could cause
child() to run in a tight loop, switching back and forth between
DAEMON_CONFIGURE and DAEMON_IDLE states without actually calling
reconfigure().

Move the logic to postpone reconfigure() calls from __post_config_state()
into child(), entirely, to avoid this situation. This means that child()
needs to poll for reconfigure_pending besides running_state changes.

Fixes: 250708c ("multipathd: improve delayed reconfigure")
Fixes: 4b104e6 ("multipathd: pass in the type of reconfigure")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 48 +++++++++++++++++++----------------------------
 1 file changed, 19 insertions(+), 29 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 7ecf3bd..d033a9a 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -288,38 +288,12 @@ enum daemon_status wait_for_state_change_if(enum daemon_status oldstate,
 /* Don't access this variable without holding config_lock */
 static enum force_reload_types reconfigure_pending = FORCE_RELOAD_NONE;
 
-static void enable_delayed_reconfig(void)
-{
-	pthread_mutex_lock(&config_lock);
-	__delayed_reconfig = true;
-	pthread_mutex_unlock(&config_lock);
-}
-
 /* must be called with config_lock held */
 static void __post_config_state(enum daemon_status state)
 {
 	if (state != running_state && running_state != DAEMON_SHUTDOWN) {
 		enum daemon_status old_state = running_state;
 
-		/*
-		 * Handle a pending reconfigure request.
-		 * DAEMON_IDLE is set from child() after reconfigure(),
-		 * or from checkerloop() after completing checkers.
-		 * In either case, child() will see DAEMON_CONFIGURE
-		 * again and start another reconfigure cycle.
-		 */
-		if (reconfigure_pending != FORCE_RELOAD_NONE &&
-		    state == DAEMON_IDLE &&
-		    (old_state == DAEMON_CONFIGURE ||
-		     old_state == DAEMON_RUNNING)) {
-			/*
-			 * notify systemd of transient idle state, lest systemd
-			 * thinks the reload lasts forever.
-			 */
-			do_sd_notify(old_state, DAEMON_IDLE);
-			old_state = DAEMON_IDLE;
-			state = DAEMON_CONFIGURE;
-		}
 		running_state = state;
 		pthread_cond_broadcast(&config_cond);
 		do_sd_notify(old_state, state);
@@ -3390,8 +3364,21 @@ child (__attribute__((unused)) void *param)
 		pthread_cleanup_push(config_cleanup, NULL);
 		pthread_mutex_lock(&config_lock);
 		while (running_state != DAEMON_CONFIGURE &&
-		       running_state != DAEMON_SHUTDOWN)
+		       running_state != DAEMON_SHUTDOWN &&
+		       /*
+			* Check if another reconfigure request was scheduled
+			* while we last ran reconfigure().
+			* We have to test __delayed_reconfig here
+			* to avoid a busy loop
+			*/
+		       (reconfigure_pending == FORCE_RELOAD_NONE
+			 || __delayed_reconfig))
 			pthread_cond_wait(&config_cond, &config_lock);
+
+		if (running_state != DAEMON_CONFIGURE &&
+		    running_state != DAEMON_SHUTDOWN)
+			/* This sets running_state to DAEMON_CONFIGURE */
+			__post_config_state(DAEMON_CONFIGURE);
 		state = running_state;
 		pthread_cleanup_pop(1);
 		if (state == DAEMON_SHUTDOWN)
@@ -3412,8 +3399,11 @@ child (__attribute__((unused)) void *param)
 			pthread_mutex_unlock(&config_lock);
 
 			rc = reconfigure(vecs, reload_type);
-		} else
-			enable_delayed_reconfig();
+		} else {
+			pthread_mutex_lock(&config_lock);
+			__delayed_reconfig = true;
+			pthread_mutex_unlock(&config_lock);
+		}
 		lock_cleanup_pop(vecs->lock);
 		if (!rc)
 			post_config_state(DAEMON_IDLE);
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

