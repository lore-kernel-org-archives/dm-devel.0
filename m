Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4115CC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 14 Mar 2022 21:31:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-399-EDiRT-nROSGeTu5ywDvGwA-1; Mon, 14 Mar 2022 17:31:27 -0400
X-MC-Unique: EDiRT-nROSGeTu5ywDvGwA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C01C18AE947;
	Mon, 14 Mar 2022 21:31:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3CB7E1410DD8;
	Mon, 14 Mar 2022 21:31:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2EC121932104;
	Mon, 14 Mar 2022 21:31:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B3F33195354F
 for <dm-devel@listman.corp.redhat.com>; Mon, 14 Mar 2022 21:31:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 91AB77BB86B; Mon, 14 Mar 2022 21:31:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8DC9D5B173B
 for <dm-devel@redhat.com>; Mon, 14 Mar 2022 21:31:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73F63185A7A4
 for <dm-devel@redhat.com>; Mon, 14 Mar 2022 21:31:22 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-117-YFe-i5i_NIe167CEINwHdQ-1; Mon, 14 Mar 2022 17:31:20 -0400
X-MC-Unique: YFe-i5i_NIe167CEINwHdQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 682CC218FF;
 Mon, 14 Mar 2022 21:31:19 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 27C8013B9A;
 Mon, 14 Mar 2022 21:31:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id iEqyBye0L2JBGwAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 14 Mar 2022 21:31:19 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Guozhonghua <guozh88@chinatelecom.cn>
Date: Mon, 14 Mar 2022 22:30:35 +0100
Message-Id: <20220314213036.12074-5-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH 4/5] multipathd: reset __delayed_reconfig from
 ev_add_map()
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

With the previous patch, one race condition between child() and
the uevent handler (ev_add_map()) remains: 1. child() sets
__delayed_reconfig, 2. ev_add_map() calls schedule_reconfigure() and
thus DAEMON_CONFIGURE, 3. child() sets DAEMON_IDLE. This would cause
the pending reconfigure request to be missed.

To fix this, reset __delayed_reconfig immediately from ev_add_map()
(and likewise, missing_uev_wait_tick()). This way the wait loop in
child() terminates on the reconfigure_pending condition.

Also, these schedule_reconfigure() callers don't really request a
reconfigure() call; they just unblock processing previously requested
reconfigure() calls. Add a new helper, unblock_reconfigure(), that
does just that.

Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index d033a9a..2424db7 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -155,16 +155,6 @@ int should_exit(void)
 	return get_running_state() == DAEMON_SHUTDOWN;
 }
 
-static bool get_delayed_reconfig(void)
-{
-	bool val;
-
-	pthread_mutex_lock(&config_lock);
-	val = __delayed_reconfig;
-	pthread_mutex_unlock(&config_lock);
-	return val;
-}
-
 /*
  * global copy of vecs for use in sig handlers
  */
@@ -308,6 +298,22 @@ void post_config_state(enum daemon_status state)
 	pthread_cleanup_pop(1);
 }
 
+static bool unblock_reconfigure(void)
+{
+	bool was_delayed;
+
+	pthread_mutex_lock(&config_lock);
+	was_delayed = __delayed_reconfig;
+	if (was_delayed) {
+		__delayed_reconfig = false;
+		__post_config_state(DAEMON_CONFIGURE);
+	}
+	pthread_mutex_unlock(&config_lock);
+	if (was_delayed)
+		condlog(2, "reconfigure (delayed)");
+	return was_delayed;
+}
+
 void schedule_reconfigure(enum force_reload_types requested_type)
 {
 	pthread_mutex_lock(&config_lock);
@@ -790,12 +796,9 @@ ev_add_map (char * dev, const char * alias, struct vectors * vecs)
 		dm_get_info(mpp->alias, &mpp->dmi);
 		if (mpp->wait_for_udev) {
 			mpp->wait_for_udev = 0;
-			if (get_delayed_reconfig() &&
-			    !need_to_delay_reconfig(vecs)) {
-				condlog(2, "reconfigure (delayed)");
-				schedule_reconfigure(FORCE_RELOAD_WEAK);
+			if (!need_to_delay_reconfig(vecs) &&
+			    unblock_reconfigure())
 				return 0;
-			}
 		}
 		/*
 		 * Not really an error -- we generate our own uevent
@@ -1899,11 +1902,8 @@ missing_uev_wait_tick(struct vectors *vecs)
 		}
 	}
 
-	if (timed_out && get_delayed_reconfig() &&
-	    !need_to_delay_reconfig(vecs)) {
-		condlog(2, "reconfigure (delayed)");
-		schedule_reconfigure(FORCE_RELOAD_WEAK);
-	}
+	if (timed_out && !need_to_delay_reconfig(vecs))
+		unblock_reconfigure();
 }
 
 static void
@@ -3395,7 +3395,6 @@ child (__attribute__((unused)) void *param)
 			reload_type = reconfigure_pending == FORCE_RELOAD_YES ?
 				FORCE_RELOAD_YES : FORCE_RELOAD_WEAK;
 			reconfigure_pending = FORCE_RELOAD_NONE;
-			__delayed_reconfig = false;
 			pthread_mutex_unlock(&config_lock);
 
 			rc = reconfigure(vecs, reload_type);
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

