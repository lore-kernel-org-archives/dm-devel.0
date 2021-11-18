Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAA2CC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 00:08:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8493E61B73
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 00:08:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8493E61B73
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637194093;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ijgwUDEJH9A4M5MOuh19dd2x9SS66TRuFXxmFmKYpVw=;
	b=ZwFKXFJuviEH8iDI1D0OYZgpg+cmJnr4KxuMAnvU15V/+R/YU1LUHQ3G5Y2vHcmczJOzJv
	hiK63Z8cyzNyaM1QgLSZSQoWVB3rUPv7aDerHra7NspH+CZzLNyMrNsTrJXNPQ9DJ6m+cG
	d1x/rrzIpIg9S5/BGx3pmkHl7rU/1CI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-97-dgujI1NUOpmDA9RtJ6IkQA-1; Wed, 17 Nov 2021 19:08:10 -0500
X-MC-Unique: dgujI1NUOpmDA9RtJ6IkQA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFF87102CC4B;
	Thu, 18 Nov 2021 00:08:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AEFEE5F4F4;
	Thu, 18 Nov 2021 00:08:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8B5541832DD4;
	Thu, 18 Nov 2021 00:08:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AI07g4T006777 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 17 Nov 2021 19:07:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 58CC5100EBAD; Thu, 18 Nov 2021 00:07:42 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 10D21101E814;
	Thu, 18 Nov 2021 00:07:39 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AI07bn8006035; 
	Wed, 17 Nov 2021 18:07:37 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AI07bXd006034;
	Wed, 17 Nov 2021 18:07:37 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 17 Nov 2021 18:07:31 -0600
Message-Id: <1637194052-5985-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1637194052-5985-1-git-send-email-bmarzins@redhat.com>
References: <1637194052-5985-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v3 3/4] multipathd: pass in the type of
	reconfigure
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

schedule_reconfigure() now takes the type of reconfigure to do, and that
gets passed down to reconfigure(). If a full reconfigure has already
been requested but not started, weak reconfigure requests will be
upgraded. Currently cli_reconfigure() and the HUP signal request full
reconfigures, while the initial reconfigure, ev_add_map(), and
missing_uev_wait_tick() request weak reconfigures. A future patch will
enable users to control what kind of reconfigures happen.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c  |  2 +-
 multipathd/cli_handlers.c |  2 +-
 multipathd/main.c         | 55 +++++++++++++++++++++------------------
 multipathd/main.h         |  2 +-
 4 files changed, 32 insertions(+), 29 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 7edb355b..eb8ec1bd 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1098,7 +1098,7 @@ out:
  * FORCE_RELOAD_NONE: existing maps aren't touched at all
  * FORCE_RELOAD_YES: all maps are rebuilt from scratch and (re)loaded in DM
  * FORCE_RELOAD_WEAK: existing maps are compared to the current conf and only
- * reloaded in DM if there's a difference. This is useful during startup.
+ * reloaded in DM if there's a difference. This is normally sufficient.
  */
 int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
 		    int force_reload, enum mpath_cmds cmd)
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index f59db3ab..d1656754 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -1012,7 +1012,7 @@ cli_reconfigure(void * v, struct strbuf *reply, void * data)
 {
 	condlog(2, "reconfigure (operator)");
 
-	schedule_reconfigure();
+	schedule_reconfigure(FORCE_RELOAD_YES);
 	return 0;
 }
 
diff --git a/multipathd/main.c b/multipathd/main.c
index 1ead0904..735fdb53 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -162,13 +162,6 @@ static bool get_delayed_reconfig(void)
 	return val;
 }
 
-static void set_delayed_reconfig(bool val)
-{
-	pthread_mutex_lock(&config_lock);
-	__delayed_reconfig = val;
-	pthread_mutex_unlock(&config_lock);
-}
-
 /*
  * global copy of vecs for use in sig handlers
  */
@@ -290,7 +283,18 @@ enum daemon_status wait_for_state_change_if(enum daemon_status oldstate,
 }
 
 /* Don't access this variable without holding config_lock */
-static bool reconfigure_pending;
+static enum force_reload_types reconfigure_pending = FORCE_RELOAD_NONE;
+/* Only set while changing to DAEMON_CONFIGURE, and only access while
+ * reconfiguring or scheduling a delayed reconfig in DAEMON_CONFIGURE */
+static volatile enum force_reload_types reload_type = FORCE_RELOAD_NONE;
+
+static void enable_delayed_reconfig(void)
+{
+	pthread_mutex_lock(&config_lock);
+	reconfigure_pending = reload_type;
+	__delayed_reconfig = true;
+	pthread_mutex_unlock(&config_lock);
+}
 
 /* must be called with config_lock held */
 static void __post_config_state(enum daemon_status state)
@@ -305,7 +309,8 @@ static void __post_config_state(enum daemon_status state)
 		 * In either case, child() will see DAEMON_CONFIGURE
 		 * again and start another reconfigure cycle.
 		 */
-		if (reconfigure_pending && state == DAEMON_IDLE &&
+		if (reconfigure_pending != FORCE_RELOAD_NONE &&
+		    state == DAEMON_IDLE &&
 		    (old_state == DAEMON_CONFIGURE ||
 		     old_state == DAEMON_RUNNING)) {
 			/*
@@ -317,7 +322,8 @@ static void __post_config_state(enum daemon_status state)
 			state = DAEMON_CONFIGURE;
 		}
 		if (state == DAEMON_CONFIGURE) {
-			reconfigure_pending = false;
+			reload_type = (reconfigure_pending == FORCE_RELOAD_YES) ? FORCE_RELOAD_YES : FORCE_RELOAD_WEAK;
+			reconfigure_pending = FORCE_RELOAD_NONE;
 			__delayed_reconfig = false;
 		}
 		running_state = state;
@@ -334,20 +340,26 @@ void post_config_state(enum daemon_status state)
 	pthread_cleanup_pop(1);
 }
 
-void schedule_reconfigure(void)
+void schedule_reconfigure(enum force_reload_types requested_type)
 {
 	pthread_mutex_lock(&config_lock);
 	pthread_cleanup_push(config_cleanup, NULL);
+	enum force_reload_types type;
+
+	type = (reconfigure_pending == FORCE_RELOAD_YES ||
+		requested_type == FORCE_RELOAD_YES) ?
+	       FORCE_RELOAD_YES : FORCE_RELOAD_WEAK;
 	switch (running_state)
 	{
 	case DAEMON_SHUTDOWN:
 		break;
 	case DAEMON_IDLE:
+		reconfigure_pending = type;
 		__post_config_state(DAEMON_CONFIGURE);
 		break;
 	case DAEMON_CONFIGURE:
 	case DAEMON_RUNNING:
-		reconfigure_pending = true;
+		reconfigure_pending = type;
 		break;
 	default:
 		break;
@@ -812,7 +824,7 @@ ev_add_map (char * dev, const char * alias, struct vectors * vecs)
 			if (get_delayed_reconfig() &&
 			    !need_to_delay_reconfig(vecs)) {
 				condlog(2, "reconfigure (delayed)");
-				schedule_reconfigure();
+				schedule_reconfigure(FORCE_RELOAD_WEAK);
 				return 0;
 			}
 		}
@@ -1830,7 +1842,7 @@ missing_uev_wait_tick(struct vectors *vecs)
 	if (timed_out && get_delayed_reconfig() &&
 	    !need_to_delay_reconfig(vecs)) {
 		condlog(2, "reconfigure (delayed)");
-		schedule_reconfigure();
+		schedule_reconfigure(FORCE_RELOAD_WEAK);
 	}
 }
 
@@ -2595,7 +2607,6 @@ configure (struct vectors * vecs)
 	vector mpvec;
 	int i, ret;
 	struct config *conf;
-	static int force_reload = FORCE_RELOAD_WEAK;
 
 	if (!vecs->pathvec && !(vecs->pathvec = vector_alloc())) {
 		condlog(0, "couldn't allocate path vec in configure");
@@ -2643,15 +2654,7 @@ configure (struct vectors * vecs)
 	if (should_exit())
 		goto fail;
 
-	/*
-	 * create new set of maps & push changed ones into dm
-	 * In the first call, use FORCE_RELOAD_WEAK to avoid making
-	 * superfluous ACT_RELOAD ioctls. Later calls are done
-	 * with FORCE_RELOAD_YES.
-	 */
-	ret = coalesce_paths(vecs, mpvec, NULL, force_reload, CMD_NONE);
-	if (force_reload == FORCE_RELOAD_WEAK)
-		force_reload = FORCE_RELOAD_YES;
+	ret = coalesce_paths(vecs, mpvec, NULL, reload_type, CMD_NONE);
 	if (ret != CP_OK) {
 		condlog(0, "configure failed while coalescing paths");
 		goto fail;
@@ -2815,7 +2818,7 @@ handle_signals(bool nonfatal)
 		return;
 	if (reconfig_sig) {
 		condlog(2, "reconfigure (signal)");
-		schedule_reconfigure();
+		schedule_reconfigure(FORCE_RELOAD_YES);
 	}
 	if (log_reset_sig) {
 		condlog(2, "reset log (signal)");
@@ -3276,7 +3279,7 @@ child (__attribute__((unused)) void *param)
 			if (!need_to_delay_reconfig(vecs))
 				reconfigure(vecs);
 			else
-				set_delayed_reconfig(true);
+				enable_delayed_reconfig();
 			lock_cleanup_pop(vecs->lock);
 			post_config_state(DAEMON_IDLE);
 		}
diff --git a/multipathd/main.h b/multipathd/main.h
index a1697a74..c8aac398 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -37,7 +37,7 @@ void exit_daemon(void);
 const char * daemon_status(void);
 enum daemon_status wait_for_state_change_if(enum daemon_status oldstate,
 					    unsigned long ms);
-void schedule_reconfigure(void);
+void schedule_reconfigure(enum force_reload_types requested_type);
 int need_to_delay_reconfig (struct vectors *);
 int ev_add_path (struct path *, struct vectors *, int);
 int ev_remove_path (struct path *, struct vectors *, int);
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

