Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C2F0C433EF
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:20:52 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-477-fzYppcuvOzW01sT64X_35A-1; Sat, 27 Nov 2021 10:20:47 -0500
X-MC-Unique: fzYppcuvOzW01sT64X_35A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B50F1853030;
	Sat, 27 Nov 2021 15:20:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 530065D6D7;
	Sat, 27 Nov 2021 15:20:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2E4FB4A709;
	Sat, 27 Nov 2021 15:20:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFJtYP000338 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:19:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0D2A52166B2F; Sat, 27 Nov 2021 15:19:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 07BA62166B2D
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 98A64101AA73
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:49 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-400-s9OshIv_Ou-U_h1cVqEkrQ-1; Sat, 27 Nov 2021 10:19:45 -0500
X-MC-Unique: s9OshIv_Ou-U_h1cVqEkrQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 32BEB212FE;
	Sat, 27 Nov 2021 15:19:44 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DCE8A13AAD;
	Sat, 27 Nov 2021 15:19:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id cL3QM49MomErFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:19:43 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:19:00 +0100
Message-Id: <20211127151929.7727-8-mwilck@suse.com>
In-Reply-To: <20211127151929.7727-1-mwilck@suse.com>
References: <20211127151929.7727-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFJtYP000338
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 07/35] multipathd: improve delayed reconfigure
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

When a reconfigure operation is requested, either by the admin
or by some condition multipathd encounters, the current code
attempts to set DAEMON_CONFIGURE state and gives up after a second
if it doesn't succeed. Apart from shutdown, this happens only
if multipathd is either already reconfiguring, or busy in the
path checker loop.

This patch modifies the logic as follows: rather than waiting,
we set a flag that requests a reconfigure operation asap, i.e.
when the current operation is finished and the status switched
to DAEMON_IDLE. In this case, multipathd will not switch to IDLE
but start another reconfigure cycle.

This assumes that if a reconfigure is requested while one is already
running, the admin has made some (additional) changes and wants
multipathd to pull them in. As we can't be sure that the currently
running reconfigure has seen the configuration changes, we need
to start over again.

A positive side effect is less waiting in clients and multipathd.

After this change, the only caller of set_config_state() is
checkerloop(). Waking up every second just to see that DAEMON_RUNNING
couldn't be set makes no sense. Therefore set_config_state() is
changed to wait "forever", or until shutdown is requested. Unless
multipathd completely hangs, the wait will terminate sooner or
later.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/cli_handlers.c | 10 +----
 multipathd/main.c         | 92 +++++++++++++++++++++++++++++----------
 multipathd/main.h         |  2 +-
 3 files changed, 70 insertions(+), 34 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index b674a14..f283e95 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -1075,17 +1075,9 @@ cli_switch_group(void * v, char ** reply, int * len, void * data)
 int
 cli_reconfigure(void * v, char ** reply, int * len, void * data)
 {
-	int rc;
-
 	condlog(2, "reconfigure (operator)");
 
-	rc = set_config_state(DAEMON_CONFIGURE);
-	if (rc == ETIMEDOUT) {
-		condlog(2, "timeout starting reconfiguration");
-		return 1;
-	} else if (rc == EINVAL)
-		/* daemon shutting down */
-		return 1;
+	schedule_reconfigure();
 	return 0;
 }
 
diff --git a/multipathd/main.c b/multipathd/main.c
index 8f2940e..6054fd5 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -220,6 +220,10 @@ static void do_sd_notify(enum daemon_status old_state,
 	} else if (new_state == DAEMON_CONFIGURE && startup_done)
 		sd_notify(0, "RELOADING=1");
 }
+#else
+static void do_sd_notify(__attribute__((unused)) enum daemon_status old_state,
+			 __attribute__((unused)) enum daemon_status new_state)
+{}
 #endif
 
 static void config_cleanup(__attribute__((unused)) void *arg)
@@ -265,19 +269,38 @@ enum daemon_status wait_for_state_change_if(enum daemon_status oldstate,
 	return st;
 }
 
+/* Don't access this variable without holding config_lock */
+static bool reconfigure_pending;
+
 /* must be called with config_lock held */
 static void __post_config_state(enum daemon_status state)
 {
 	if (state != running_state && running_state != DAEMON_SHUTDOWN) {
-#ifdef USE_SYSTEMD
 		enum daemon_status old_state = running_state;
-#endif
 
+		/*
+		 * Handle a pending reconfigure request.
+		 * DAEMON_IDLE is set from child() after reconfigure(),
+		 * or from checkerloop() after completing checkers.
+		 * In either case, child() will see DAEMON_CONFIGURE
+		 * again and start another reconfigure cycle.
+		 */
+		if (reconfigure_pending && state == DAEMON_IDLE &&
+		    (old_state == DAEMON_CONFIGURE ||
+		     old_state == DAEMON_RUNNING)) {
+			/*
+			 * notify systemd of transient idle state, lest systemd
+			 * thinks the reload lasts forever.
+			 */
+			do_sd_notify(old_state, DAEMON_IDLE);
+			old_state = DAEMON_IDLE;
+			state = DAEMON_CONFIGURE;
+		}
+		if (reconfigure_pending && state == DAEMON_CONFIGURE)
+			reconfigure_pending = false;
 		running_state = state;
 		pthread_cond_broadcast(&config_cond);
-#ifdef USE_SYSTEMD
 		do_sd_notify(old_state, state);
-#endif
 	}
 }
 
@@ -289,24 +312,48 @@ void post_config_state(enum daemon_status state)
 	pthread_cleanup_pop(1);
 }
 
-int set_config_state(enum daemon_status state)
+void schedule_reconfigure(void)
+{
+	pthread_mutex_lock(&config_lock);
+	pthread_cleanup_push(config_cleanup, NULL);
+	switch (running_state)
+	{
+	case DAEMON_SHUTDOWN:
+		break;
+	case DAEMON_IDLE:
+		__post_config_state(DAEMON_CONFIGURE);
+		break;
+	case DAEMON_CONFIGURE:
+	case DAEMON_RUNNING:
+		reconfigure_pending = true;
+		break;
+	default:
+		break;
+	}
+	pthread_cleanup_pop(1);
+}
+
+static enum daemon_status set_config_state(enum daemon_status state)
 {
 	int rc = 0;
+	enum daemon_status st;
 
 	pthread_cleanup_push(config_cleanup, NULL);
 	pthread_mutex_lock(&config_lock);
-	if (running_state != state) {
 
-		if (running_state == DAEMON_SHUTDOWN)
-			rc = EINVAL;
-		else
-			rc = __wait_for_state_change(
-				running_state != DAEMON_IDLE, 1000);
-		if (!rc)
-			__post_config_state(state);
+	while (rc == 0 &&
+	       running_state != state &&
+	       running_state != DAEMON_SHUTDOWN &&
+	       running_state != DAEMON_IDLE) {
+		rc = pthread_cond_wait(&config_cond, &config_lock);
 	}
+
+	if (rc == 0 && running_state == DAEMON_IDLE && state != DAEMON_IDLE)
+		__post_config_state(state);
+	st = running_state;
+
 	pthread_cleanup_pop(1);
-	return rc;
+	return st;
 }
 
 struct config *get_multipath_config(void)
@@ -744,7 +791,7 @@ ev_add_map (char * dev, const char * alias, struct vectors * vecs)
 			if (delayed_reconfig &&
 			    !need_to_delay_reconfig(vecs)) {
 				condlog(2, "reconfigure (delayed)");
-				set_config_state(DAEMON_CONFIGURE);
+				schedule_reconfigure();
 				return 0;
 			}
 		}
@@ -1855,7 +1902,7 @@ missing_uev_wait_tick(struct vectors *vecs)
 	if (timed_out && delayed_reconfig &&
 	    !need_to_delay_reconfig(vecs)) {
 		condlog(2, "reconfigure (delayed)");
-		set_config_state(DAEMON_CONFIGURE);
+		schedule_reconfigure();
 	}
 }
 
@@ -2494,6 +2541,10 @@ checkerloop (void *ap)
 		int num_paths = 0, strict_timing, rc = 0;
 		unsigned int ticks = 0;
 
+		if (set_config_state(DAEMON_RUNNING) != DAEMON_RUNNING)
+			/* daemon shutdown */
+			break;
+
 		get_monotonic_time(&start_time);
 		if (start_time.tv_sec && last_time.tv_sec) {
 			timespecsub(&start_time, &last_time, &diff_time);
@@ -2509,13 +2560,6 @@ checkerloop (void *ap)
 		if (use_watchdog)
 			sd_notify(0, "WATCHDOG=1");
 #endif
-		rc = set_config_state(DAEMON_RUNNING);
-		if (rc == ETIMEDOUT) {
-			condlog(4, "timeout waiting for DAEMON_IDLE");
-			continue;
-		} else if (rc == EINVAL)
-			/* daemon shutdown */
-			break;
 
 		pthread_cleanup_push(cleanup_lock, &vecs->lock);
 		lock(&vecs->lock);
@@ -2843,7 +2887,7 @@ handle_signals(bool nonfatal)
 		return;
 	if (reconfig_sig) {
 		condlog(2, "reconfigure (signal)");
-		set_config_state(DAEMON_CONFIGURE);
+		schedule_reconfigure();
 	}
 	if (log_reset_sig) {
 		condlog(2, "reset log (signal)");
diff --git a/multipathd/main.h b/multipathd/main.h
index bc1f938..2960a4d 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -37,6 +37,7 @@ void exit_daemon(void);
 const char * daemon_status(void);
 enum daemon_status wait_for_state_change_if(enum daemon_status oldstate,
 					    unsigned long ms);
+void schedule_reconfigure(void);
 int need_to_delay_reconfig (struct vectors *);
 int reconfigure (struct vectors *);
 int ev_add_path (struct path *, struct vectors *, int);
@@ -44,7 +45,6 @@ int ev_remove_path (struct path *, struct vectors *, int);
 int ev_add_map (char *, const char *, struct vectors *);
 int ev_remove_map (char *, char *, int, struct vectors *);
 int flush_map(struct multipath *, struct vectors *, int);
-int set_config_state(enum daemon_status);
 void * mpath_alloc_prin_response(int prin_sa);
 int prin_do_scsi_ioctl(char *, int rq_servact, struct prin_resp * resp,
 		       int noisy);
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

