Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9454EC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 14 Mar 2022 21:31:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-530-JxrQt7glMuuaKxIyTWbb4g-1; Mon, 14 Mar 2022 17:31:27 -0400
X-MC-Unique: JxrQt7glMuuaKxIyTWbb4g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B90D29A9CCC;
	Mon, 14 Mar 2022 21:31:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DEB3DC44AE5;
	Mon, 14 Mar 2022 21:31:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AC4A8195354B;
	Mon, 14 Mar 2022 21:31:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E50C5195354A
 for <dm-devel@listman.corp.redhat.com>; Mon, 14 Mar 2022 21:31:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C3A35C44AE6; Mon, 14 Mar 2022 21:31:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BFA67C44AE3
 for <dm-devel@redhat.com>; Mon, 14 Mar 2022 21:31:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A78CA185A7B2
 for <dm-devel@redhat.com>; Mon, 14 Mar 2022 21:31:21 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-G2wjzhbmODuZ-QDFQmYB2Q-1; Mon, 14 Mar 2022 17:31:20 -0400
X-MC-Unique: G2wjzhbmODuZ-QDFQmYB2Q-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id C22A61F37E;
 Mon, 14 Mar 2022 21:31:18 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8188513B3D;
 Mon, 14 Mar 2022 21:31:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id CKGnHSa0L2JBGwAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 14 Mar 2022 21:31:18 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Guozhonghua <guozh88@chinatelecom.cn>
Date: Mon, 14 Mar 2022 22:30:33 +0100
Message-Id: <20220314213036.12074-3-mwilck@suse.com>
In-Reply-To: <20220314213036.12074-1-mwilck@suse.com>
References: <20220314213036.12074-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH 2/5] multipathd: set reload_type in when calling
 reconfigure()
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

Only set reload_type (and reset reconfigure_pending) immediately
before we actually call reconfigure(). This allows us to get rid of
the reload_type global variable, and makes sure that reconfigure()
is called with the reload type that was last requested.

While at it, convert configure() and reconfigure() to static functions.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 1c8839d..7ecf3bd 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -287,14 +287,10 @@ enum daemon_status wait_for_state_change_if(enum daemon_status oldstate,
 
 /* Don't access this variable without holding config_lock */
 static enum force_reload_types reconfigure_pending = FORCE_RELOAD_NONE;
-/* Only set while changing to DAEMON_CONFIGURE, and only access while
- * reconfiguring or scheduling a delayed reconfig in DAEMON_CONFIGURE */
-static volatile enum force_reload_types reload_type = FORCE_RELOAD_NONE;
 
 static void enable_delayed_reconfig(void)
 {
 	pthread_mutex_lock(&config_lock);
-	reconfigure_pending = reload_type;
 	__delayed_reconfig = true;
 	pthread_mutex_unlock(&config_lock);
 }
@@ -324,11 +320,6 @@ static void __post_config_state(enum daemon_status state)
 			old_state = DAEMON_IDLE;
 			state = DAEMON_CONFIGURE;
 		}
-		if (state == DAEMON_CONFIGURE) {
-			reload_type = (reconfigure_pending == FORCE_RELOAD_YES) ? FORCE_RELOAD_YES : FORCE_RELOAD_WEAK;
-			reconfigure_pending = FORCE_RELOAD_NONE;
-			__delayed_reconfig = false;
-		}
 		running_state = state;
 		pthread_cond_broadcast(&config_cond);
 		do_sd_notify(old_state, state);
@@ -2714,8 +2705,8 @@ checkerloop (void *ap)
 	return NULL;
 }
 
-int
-configure (struct vectors * vecs)
+static int
+configure (struct vectors * vecs, enum force_reload_types reload_type)
 {
 	struct multipath * mpp;
 	struct path * pp;
@@ -2846,8 +2837,8 @@ void rcu_free_config(struct rcu_head *head)
 	free_config(conf);
 }
 
-int
-reconfigure (struct vectors * vecs)
+static int
+reconfigure (struct vectors *vecs, enum force_reload_types reload_type)
 {
 	struct config * old, *conf;
 	int old_marginal_pathgroups;
@@ -2894,8 +2885,7 @@ reconfigure (struct vectors * vecs)
 #ifdef FPIN_EVENT_HANDLER
 	fpin_clean_marginal_dev_list(NULL);
 #endif
-	configure(vecs);
-
+	configure(vecs, reload_type);
 
 	return 0;
 }
@@ -3411,9 +3401,18 @@ child (__attribute__((unused)) void *param)
 		pthread_cleanup_push(cleanup_lock, &vecs->lock);
 		lock(&vecs->lock);
 		pthread_testcancel();
-		if (!need_to_delay_reconfig(vecs))
-			rc = reconfigure(vecs);
-		else
+		if (!need_to_delay_reconfig(vecs)) {
+			enum force_reload_types reload_type;
+
+			pthread_mutex_lock(&config_lock);
+			reload_type = reconfigure_pending == FORCE_RELOAD_YES ?
+				FORCE_RELOAD_YES : FORCE_RELOAD_WEAK;
+			reconfigure_pending = FORCE_RELOAD_NONE;
+			__delayed_reconfig = false;
+			pthread_mutex_unlock(&config_lock);
+
+			rc = reconfigure(vecs, reload_type);
+		} else
 			enable_delayed_reconfig();
 		lock_cleanup_pop(vecs->lock);
 		if (!rc)
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

