Return-Path: <SRS0=MR+g=QE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2FECC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 20:34:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 76D326135E
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 20:34:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 76D326135E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637181240;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kI7sPz9O3RW5yZ5GKdHF5Lih1V8OIa0O+LDskAG6ZNc=;
	b=IPrOdX6MxoRdlJchqS6c0BpT4acSqrfhMb5HHYUYkqtrihVzKYLYNJYOd06IyJWYXg8S37
	8yzCufO/Xp5VpaHo6VBeIJzpJj69wBHD9S0Sdl+7V77VW4s5/oK9cWwFfgFyv4b4AuHphI
	BvXQgYsFaoKzTFWrjF6554LoKOpZ0/g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-6-mqJ9ZSZbPBaAREQhbbrKmw-1; Wed, 17 Nov 2021 15:33:57 -0500
X-MC-Unique: mqJ9ZSZbPBaAREQhbbrKmw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4962E1023F4E;
	Wed, 17 Nov 2021 20:33:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CEE25C1BB;
	Wed, 17 Nov 2021 20:33:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DFEE64EA29;
	Wed, 17 Nov 2021 20:33:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AHKXiP7018127 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 17 Nov 2021 15:33:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4FD225C232; Wed, 17 Nov 2021 20:33:44 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 288EE5C1BB;
	Wed, 17 Nov 2021 20:33:44 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AHKXgSY004473; 
	Wed, 17 Nov 2021 14:33:42 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AHKXf2M004472;
	Wed, 17 Nov 2021 14:33:41 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 17 Nov 2021 14:33:36 -0600
Message-Id: <1637181217-4423-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1637181217-4423-1-git-send-email-bmarzins@redhat.com>
References: <1637181217-4423-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 3/4] multipathd: pass in the type of
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
 multipathd/main.c         | 62 ++++++++++++++++++++-------------------
 multipathd/main.h         |  2 +-
 4 files changed, 35 insertions(+), 33 deletions(-)

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
index f59db3ab..b12a4e7e 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -1012,7 +1012,7 @@ cli_reconfigure(void * v, struct strbuf *reply, void * data)
 {
 	condlog(2, "reconfigure (operator)");
 
-	schedule_reconfigure();
+	schedule_reconfigure(true);
 	return 0;
 }
 
diff --git a/multipathd/main.c b/multipathd/main.c
index 1ead0904..5c831e8d 100644
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
+ * reconfiguring in DAEMON_CONFIGURE */
+static volatile enum force_reload_types reload_type = FORCE_RELOAD_NONE;
+
+static void enable_delayed_reconfig(enum force_reload_types type)
+{
+	pthread_mutex_lock(&config_lock);
+	reconfigure_pending = type;
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
@@ -334,20 +340,25 @@ void post_config_state(enum daemon_status state)
 	pthread_cleanup_pop(1);
 }
 
-void schedule_reconfigure(void)
+void schedule_reconfigure(bool force_reload_yes)
 {
 	pthread_mutex_lock(&config_lock);
 	pthread_cleanup_push(config_cleanup, NULL);
+	enum force_reload_types type;
+
+	type = (reconfigure_pending == FORCE_RELOAD_YES || force_reload_yes) ?
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
@@ -812,7 +823,7 @@ ev_add_map (char * dev, const char * alias, struct vectors * vecs)
 			if (get_delayed_reconfig() &&
 			    !need_to_delay_reconfig(vecs)) {
 				condlog(2, "reconfigure (delayed)");
-				schedule_reconfigure();
+				schedule_reconfigure(false);
 				return 0;
 			}
 		}
@@ -1830,7 +1841,7 @@ missing_uev_wait_tick(struct vectors *vecs)
 	if (timed_out && get_delayed_reconfig() &&
 	    !need_to_delay_reconfig(vecs)) {
 		condlog(2, "reconfigure (delayed)");
-		schedule_reconfigure();
+		schedule_reconfigure(false);
 	}
 }
 
@@ -2588,14 +2599,13 @@ checkerloop (void *ap)
 }
 
 int
-configure (struct vectors * vecs)
+configure (struct vectors * vecs, enum force_reload_types type)
 {
 	struct multipath * mpp;
 	struct path * pp;
 	vector mpvec;
 	int i, ret;
 	struct config *conf;
-	static int force_reload = FORCE_RELOAD_WEAK;
 
 	if (!vecs->pathvec && !(vecs->pathvec = vector_alloc())) {
 		condlog(0, "couldn't allocate path vec in configure");
@@ -2643,15 +2653,7 @@ configure (struct vectors * vecs)
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
+	ret = coalesce_paths(vecs, mpvec, NULL, type, CMD_NONE);
 	if (ret != CP_OK) {
 		condlog(0, "configure failed while coalescing paths");
 		goto fail;
@@ -2729,7 +2731,7 @@ void rcu_free_config(struct rcu_head *head)
 }
 
 int
-reconfigure (struct vectors * vecs)
+reconfigure (struct vectors * vecs, enum force_reload_types type)
 {
 	struct config * old, *conf;
 
@@ -2763,7 +2765,7 @@ reconfigure (struct vectors * vecs)
 	rcu_assign_pointer(multipath_conf, conf);
 	call_rcu(&old->rcu, rcu_free_config);
 
-	configure(vecs);
+	configure(vecs, type);
 
 
 	return 0;
@@ -2815,7 +2817,7 @@ handle_signals(bool nonfatal)
 		return;
 	if (reconfig_sig) {
 		condlog(2, "reconfigure (signal)");
-		schedule_reconfigure();
+		schedule_reconfigure(true);
 	}
 	if (log_reset_sig) {
 		condlog(2, "reset log (signal)");
@@ -3274,9 +3276,9 @@ child (__attribute__((unused)) void *param)
 			lock(&vecs->lock);
 			pthread_testcancel();
 			if (!need_to_delay_reconfig(vecs))
-				reconfigure(vecs);
+				reconfigure(vecs, reload_type);
 			else
-				set_delayed_reconfig(true);
+				enable_delayed_reconfig(reload_type);
 			lock_cleanup_pop(vecs->lock);
 			post_config_state(DAEMON_IDLE);
 		}
diff --git a/multipathd/main.h b/multipathd/main.h
index a1697a74..c8a1ce92 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -37,7 +37,7 @@ void exit_daemon(void);
 const char * daemon_status(void);
 enum daemon_status wait_for_state_change_if(enum daemon_status oldstate,
 					    unsigned long ms);
-void schedule_reconfigure(void);
+void schedule_reconfigure(bool reconfig_all);
 int need_to_delay_reconfig (struct vectors *);
 int ev_add_path (struct path *, struct vectors *, int);
 int ev_remove_path (struct path *, struct vectors *, int);
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

