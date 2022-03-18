Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C11AC433FE
	for <dm-devel@archiver.kernel.org>; Fri, 18 Mar 2022 22:34:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-8mZWj-LFOii1Po1w5BdMKQ-1; Fri, 18 Mar 2022 18:34:01 -0400
X-MC-Unique: 8mZWj-LFOii1Po1w5BdMKQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F0CA29DD9BF;
	Fri, 18 Mar 2022 22:33:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6A156145B978;
	Fri, 18 Mar 2022 22:33:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BAC9F1940370;
	Fri, 18 Mar 2022 22:33:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BCA6A194035B
 for <dm-devel@listman.corp.redhat.com>; Fri, 18 Mar 2022 22:33:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4D0BEC27E81; Fri, 18 Mar 2022 22:33:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 48DBFC27E80
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 22:33:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2CAB03804062
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 22:33:52 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-494-zD7V5Nw7MXmUQ88Nhxg0EA-1; Fri, 18 Mar 2022 18:33:50 -0400
X-MC-Unique: zD7V5Nw7MXmUQ88Nhxg0EA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 1210D1F37D;
 Fri, 18 Mar 2022 22:33:49 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C81AD132D4;
 Fri, 18 Mar 2022 22:33:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id UIz+LswINWLSdwAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 18 Mar 2022 22:33:48 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Guozhonghua <guozh88@chinatelecom.cn>
Date: Fri, 18 Mar 2022 23:33:30 +0100
Message-Id: <20220318223339.4226-3-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH v2 02/11] multipathd: set reload_type in when
 calling reconfigure()
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

