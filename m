Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72F9AC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:06:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1424061A7D
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:06:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1424061A7D
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-242-IpejgEHkNVigs69EsS9pLA-1; Thu, 18 Nov 2021 18:06:07 -0500
X-MC-Unique: IpejgEHkNVigs69EsS9pLA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5456410151F8;
	Thu, 18 Nov 2021 23:06:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 391455F4EF;
	Thu, 18 Nov 2021 23:06:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 109E54EA30;
	Thu, 18 Nov 2021 23:06:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIMxCLP002279 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 17:59:13 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CFAB92026D60; Thu, 18 Nov 2021 22:59:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CAC552026D46
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B06118011A5
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:12 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-329-VAHg2PdSO7uMXWPsG-Ic8A-1; Thu, 18 Nov 2021 17:59:10 -0500
X-MC-Unique: VAHg2PdSO7uMXWPsG-Ic8A-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 80D561FD38;
	Thu, 18 Nov 2021 22:59:09 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 38E9B13DC0;
	Thu, 18 Nov 2021 22:59:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id ADTZC73almGHPAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 22:59:09 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 18 Nov 2021 23:58:28 +0100
Message-Id: <20211118225840.19810-37-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AIMxCLP002279
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 36/48] multipathd: move delayed_reconfig out
	of struct config
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

delayed_reconfig was inside the config struct, but it wasn't updated
during an RCU write section, so there's no synchronization on it.
Instead, pull it out of the config structure, and use the config_lock
to synchronize it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/libmpathpersist.version | 12 +++----
 libmultipath/config.h                   |  1 -
 libmultipath/libmultipath.version       |  9 ++---
 multipathd/main.c                       | 45 ++++++++++++++++---------
 4 files changed, 37 insertions(+), 30 deletions(-)

diff --git a/libmpathpersist/libmpathpersist.version b/libmpathpersist/libmpathpersist.version
index e074813..b52b750 100644
--- a/libmpathpersist/libmpathpersist.version
+++ b/libmpathpersist/libmpathpersist.version
@@ -10,7 +10,7 @@
  *
  * See libmultipath.version for general policy about version numbers.
  */
-LIBMPATHPERSIST_1.0.0 {
+LIBMPATHPERSIST_2.0.0 {
 global:
 
 	__mpath_persistent_reserve_in;
@@ -28,11 +28,9 @@ global:
 	prout_do_scsi_ioctl;
 	update_map_pr;
 
-local: *;
-};
-
-LIBMPATHPERSIST_1.1.0 {
-global:
+	/* added int 1.1.0 */
 	libmpathpersist_init;
 	libmpathpersist_exit;
-} LIBMPATHPERSIST_1.0.0;
+
+local: *;
+};
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 933fe0d..c73389b 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -178,7 +178,6 @@ struct config {
 	int strict_timing;
 	int retrigger_tries;
 	int retrigger_delay;
-	int delayed_reconfig;
 	int uev_wait_timeout;
 	int skip_kpartx;
 	int remove_retries;
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 2fb2547..4f6fa1d 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -31,7 +31,7 @@
  *   The new version inherits the previous ones.
  */
 
-LIBMULTIPATH_10.0.0 {
+LIBMULTIPATH_11.0.0 {
 global:
 	/* symbols referenced by multipath and multipathd */
 	add_foreign;
@@ -290,11 +290,8 @@ global:
 	/* added in 9.2.0 */
 	set_wakeup_fn;
 
+	/* added in 10.1.0 */
+	__snprint_config;
 local:
 	*;
 };
-
-LIBMULTIPATH_10.1.0 {
-global:
-	__snprint_config;
-} LIBMULTIPATH_10.0.0;
diff --git a/multipathd/main.c b/multipathd/main.c
index 7c3e9b2..57c572d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -127,6 +127,8 @@ static int poll_dmevents = 1;
 #endif
 /* Don't access this variable without holding config_lock */
 static volatile enum daemon_status running_state = DAEMON_INIT;
+/* Don't access this variable without holding config_lock */
+static bool __delayed_reconfig;
 pid_t daemon_pid;
 static pthread_mutex_t config_lock = PTHREAD_MUTEX_INITIALIZER;
 static pthread_cond_t config_cond;
@@ -150,6 +152,23 @@ int should_exit(void)
 	return get_running_state() == DAEMON_SHUTDOWN;
 }
 
+static bool get_delayed_reconfig(void)
+{
+	bool val;
+
+	pthread_mutex_lock(&config_lock);
+	val = __delayed_reconfig;
+	pthread_mutex_unlock(&config_lock);
+	return val;
+}
+
+static void set_delayed_reconfig(bool val)
+{
+	pthread_mutex_lock(&config_lock);
+	__delayed_reconfig = val;
+	pthread_mutex_unlock(&config_lock);
+}
+
 /*
  * global copy of vecs for use in sig handlers
  */
@@ -297,8 +316,10 @@ static void __post_config_state(enum daemon_status state)
 			old_state = DAEMON_IDLE;
 			state = DAEMON_CONFIGURE;
 		}
-		if (reconfigure_pending && state == DAEMON_CONFIGURE)
+		if (state == DAEMON_CONFIGURE) {
 			reconfigure_pending = false;
+			__delayed_reconfig = false;
+		}
 		running_state = state;
 		pthread_cond_broadcast(&config_cond);
 		do_sd_notify(old_state, state);
@@ -765,7 +786,7 @@ int
 ev_add_map (char * dev, const char * alias, struct vectors * vecs)
 {
 	struct multipath * mpp;
-	int delayed_reconfig, reassign_maps;
+	int reassign_maps;
 	struct config *conf;
 
 	if (dm_is_mpath(alias) != 1) {
@@ -784,12 +805,11 @@ ev_add_map (char * dev, const char * alias, struct vectors * vecs)
 				return 1;
 		}
 		conf = get_multipath_config();
-		delayed_reconfig = conf->delayed_reconfig;
 		reassign_maps = conf->reassign_maps;
 		put_multipath_config(conf);
 		if (mpp->wait_for_udev) {
 			mpp->wait_for_udev = 0;
-			if (delayed_reconfig &&
+			if (get_delayed_reconfig() &&
 			    !need_to_delay_reconfig(vecs)) {
 				condlog(2, "reconfigure (delayed)");
 				schedule_reconfigure();
@@ -1791,8 +1811,7 @@ missing_uev_wait_tick(struct vectors *vecs)
 {
 	struct multipath * mpp;
 	unsigned int i;
-	int timed_out = 0, delayed_reconfig;
-	struct config *conf;
+	int timed_out = 0;
 
 	vector_foreach_slot (vecs->mpvec, mpp, i) {
 		if (mpp->wait_for_udev && --mpp->uev_wait_tick <= 0) {
@@ -1808,10 +1827,7 @@ missing_uev_wait_tick(struct vectors *vecs)
 		}
 	}
 
-	conf = get_multipath_config();
-	delayed_reconfig = conf->delayed_reconfig;
-	put_multipath_config(conf);
-	if (timed_out && delayed_reconfig &&
+	if (timed_out && get_delayed_reconfig() &&
 	    !need_to_delay_reconfig(vecs)) {
 		condlog(2, "reconfigure (delayed)");
 		schedule_reconfigure();
@@ -3257,13 +3273,10 @@ child (__attribute__((unused)) void *param)
 			pthread_cleanup_push(cleanup_lock, &vecs->lock);
 			lock(&vecs->lock);
 			pthread_testcancel();
-			if (!need_to_delay_reconfig(vecs)) {
+			if (!need_to_delay_reconfig(vecs))
 				reconfigure(vecs);
-			} else {
-				conf = get_multipath_config();
-				conf->delayed_reconfig = 1;
-				put_multipath_config(conf);
-			}
+			else
+				set_delayed_reconfig(true);
 			lock_cleanup_pop(vecs->lock);
 			post_config_state(DAEMON_IDLE);
 		}
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

