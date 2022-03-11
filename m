Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D608C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 11 Mar 2022 02:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1646964207;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RKsB+y1IVdZ7uUzveeOUdaARL/gI9Q1PSxObeSDF9gQ=;
	b=HgakCe9pLzQ58X8Qrx72lY39+RuzV+CX+I3oKKyAhG6XGNztGPVdvef9q3xwRF+eFgPfHf
	vzuec3xXyqxoa3W/XCEAXJG7Zdmdf3rEHHdqDJH4UAzHA1tLi8hSR2+bLAqD2ZKZ/EnDLa
	ooPb8l9+KYmjXtbBD0qb1fueRywXU6U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-jVUJMLNHN4GIDzRlK_9QBA-1; Thu, 10 Mar 2022 21:03:26 -0500
X-MC-Unique: jVUJMLNHN4GIDzRlK_9QBA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42E0E101AA45;
	Fri, 11 Mar 2022 02:03:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2C08C4428F2;
	Fri, 11 Mar 2022 02:02:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B7F7D19679FF;
	Fri, 11 Mar 2022 02:02:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 252E4194F4AE
 for <dm-devel@listman.corp.redhat.com>; Fri, 11 Mar 2022 02:02:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 76A143058F; Fri, 11 Mar 2022 02:02:28 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EFAD83058D;
 Fri, 11 Mar 2022 02:02:13 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 22B22CCb021842;
 Thu, 10 Mar 2022 20:02:12 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 22B22BuW021841;
 Thu, 10 Mar 2022 20:02:11 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu, 10 Mar 2022 20:02:09 -0600
Message-Id: <1646964130-21800-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1646964130-21800-1-git-send-email-bmarzins@redhat.com>
References: <1646964130-21800-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Subject: [dm-devel] [PATCH 1/2] multipathd: set reload_type in when calling
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
Cc: device-mapper development <dm-devel@redhat.com>,
 Guozhonghua <guozh88@chinatelecom.cn>, Martin Wilck <mwilck@suse.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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
 multipathd/main.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index f2c0b280..86b1745a 100644
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
@@ -3406,13 +3396,21 @@ child (__attribute__((unused)) void *param)
 			break;
 		if (state == DAEMON_CONFIGURE) {
 			int rc = 0;
+			enum force_reload_types reload_type;
 
 			pthread_cleanup_push(cleanup_lock, &vecs->lock);
 			lock(&vecs->lock);
 			pthread_testcancel();
-			if (!need_to_delay_reconfig(vecs))
-				rc = reconfigure(vecs);
-			else
+			if (!need_to_delay_reconfig(vecs)) {
+				pthread_mutex_lock(&config_lock);
+				reload_type = reconfigure_pending == FORCE_RELOAD_YES ?
+					FORCE_RELOAD_YES : FORCE_RELOAD_WEAK;
+				reconfigure_pending = FORCE_RELOAD_NONE;
+				__delayed_reconfig = false;
+				pthread_mutex_unlock(&config_lock);
+
+				rc = reconfigure(vecs, reload_type);
+			} else
 				enable_delayed_reconfig();
 			lock_cleanup_pop(vecs->lock);
 			if (!rc)
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

