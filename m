Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D94DC433FE
	for <dm-devel@archiver.kernel.org>; Fri, 18 Mar 2022 22:34:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-166-GizOBY6BPcazkct0EAODwg-1; Fri, 18 Mar 2022 18:34:11 -0400
X-MC-Unique: GizOBY6BPcazkct0EAODwg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A3A33804094;
	Fri, 18 Mar 2022 22:34:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 468024066C86;
	Fri, 18 Mar 2022 22:34:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F34D51966341;
	Fri, 18 Mar 2022 22:34:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D216A193058E
 for <dm-devel@listman.corp.redhat.com>; Fri, 18 Mar 2022 22:33:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AFD9958BAB2; Fri, 18 Mar 2022 22:33:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AC391492CAE
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 22:33:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9523F1C0515A
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 22:33:54 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-pfvk7oPtN0G0gknNzrD6SQ-1; Fri, 18 Mar 2022 18:33:51 -0400
X-MC-Unique: pfvk7oPtN0G0gknNzrD6SQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id B50EF1F390;
 Fri, 18 Mar 2022 22:33:49 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6A791132D4;
 Fri, 18 Mar 2022 22:33:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 6GEHGM0INWLSdwAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 18 Mar 2022 22:33:49 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Guozhonghua <guozh88@chinatelecom.cn>
Date: Fri, 18 Mar 2022 23:33:32 +0100
Message-Id: <20220318223339.4226-5-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH v2 04/11] multipathd: reset __delayed_reconfig
 from ev_add_map()
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
 multipathd/main.c | 45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index d033a9a..1454a18 100644
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
@@ -308,6 +298,27 @@ void post_config_state(enum daemon_status state)
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
+		/*
+		 * In IDLE state, make sure child() is woken up
+		 * Otherwise it will wake up when state switches to IDLE
+		 */
+		if (running_state == DAEMON_IDLE)
+			__post_config_state(DAEMON_CONFIGURE);
+	}
+	pthread_mutex_unlock(&config_lock);
+	if (was_delayed)
+		condlog(3, "unblocked delayed reconfigure");
+	return was_delayed;
+}
+
 void schedule_reconfigure(enum force_reload_types requested_type)
 {
 	pthread_mutex_lock(&config_lock);
@@ -790,12 +801,9 @@ ev_add_map (char * dev, const char * alias, struct vectors * vecs)
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
@@ -1899,11 +1907,8 @@ missing_uev_wait_tick(struct vectors *vecs)
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
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

