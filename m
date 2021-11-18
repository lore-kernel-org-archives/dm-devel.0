Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5EF0C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:05:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5536461A7D
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:05:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5536461A7D
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1-qeRKYyogNOGimKkCIfTO7w-1; Thu, 18 Nov 2021 18:05:03 -0500
X-MC-Unique: qeRKYyogNOGimKkCIfTO7w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 657948799E0;
	Thu, 18 Nov 2021 23:04:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A66D5D6B1;
	Thu, 18 Nov 2021 23:04:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2196B4EA38;
	Thu, 18 Nov 2021 23:04:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIMxDFI002301 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 17:59:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D2584404727A; Thu, 18 Nov 2021 22:59:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CEDDA4047279
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8CE285A5B5
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:13 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-220-iCl14WGiMdObA8pVwZeO_Q-1; Thu, 18 Nov 2021 17:59:11 -0500
X-MC-Unique: iCl14WGiMdObA8pVwZeO_Q-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3216A212CC;
	Thu, 18 Nov 2021 22:59:10 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DFD6B13B11;
	Thu, 18 Nov 2021 22:59:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id oOCuNL3almGHPAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 22:59:09 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 18 Nov 2021 23:58:30 +0100
Message-Id: <20211118225840.19810-39-mwilck@suse.com>
In-Reply-To: <20211118225840.19810-1-mwilck@suse.com>
References: <20211118225840.19810-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AIMxDFI002301
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 38/48] multipathd: pass in the type of
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Benjamin Marzinski <bmarzins@redhat.com>

schedule_reconfigure() now takes the type of reconfigure to do, and that
gets passed down to reconfigure(). If a full reconfigure has already
been requested but not started, weak reconfigure requests will be
upgraded. Currently cli_reconfigure() and the HUP signal request full
reconfigures, while the initial reconfigure, ev_add_map(), and
missing_uev_wait_tick() request weak reconfigures. A future patch will
enable users to control what kind of reconfigures happen.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c  |  2 +-
 multipathd/cli_handlers.c |  2 +-
 multipathd/main.c         | 55 +++++++++++++++++++++------------------
 multipathd/main.h         |  2 +-
 4 files changed, 32 insertions(+), 29 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 7edb355..eb8ec1b 100644
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
index f59db3a..d165675 100644
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
index 57c572d..1efbaab 100644
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
index 7017380..c91f9f9 100644
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
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

