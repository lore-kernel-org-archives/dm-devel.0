Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1019DC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 00:07:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A1F7261BA1
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 00:07:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A1F7261BA1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637194071;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=n96Qx5p0hQHkZQ9cWVkN5mrKOtOYWOsLkEmXXeDEkEI=;
	b=a4Cfhz4HpHoi5uuanjRupRoSwJm6lk98pH9SQyz4xQ7C5eo+YloXnclgWJDlFGtbcCcNar
	ll0aDR+chwlJgo+255N1nUXfqGAtGr6Z0MLLHRRTI9KQHIuhLg5cZ/6H3MKu5OssmPfXof
	OJlEc++ODv4drUtdMJAZQ3JR/lBg2rM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-LYa_b1rqMeq-FzVd1KLd1g-1; Wed, 17 Nov 2021 19:07:48 -0500
X-MC-Unique: LYa_b1rqMeq-FzVd1KLd1g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CD55DF8A0;
	Thu, 18 Nov 2021 00:07:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4814960C4A;
	Thu, 18 Nov 2021 00:07:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 106604A703;
	Thu, 18 Nov 2021 00:07:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AI07eR5006772 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 17 Nov 2021 19:07:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B03105DAA5; Thu, 18 Nov 2021 00:07:40 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 818A1ADCD;
	Thu, 18 Nov 2021 00:07:36 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AI07YPr006027; 
	Wed, 17 Nov 2021 18:07:35 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AI07Ypn006026;
	Wed, 17 Nov 2021 18:07:34 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 17 Nov 2021 18:07:29 -0600
Message-Id: <1637194052-5985-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1637194052-5985-1-git-send-email-bmarzins@redhat.com>
References: <1637194052-5985-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v3 1/4] multipathd: move delayed_reconfig out of
	struct config
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

delayed_reconfig was inside the config struct, but it wasn't updated
during an RCU write section, so there's no synchronization on it.
Instead, pull it out of the config structure, and use the config_lock
to synchronize it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/libmpathpersist.version | 12 +++----
 libmultipath/config.h                   |  1 -
 libmultipath/libmultipath.version       | 22 +++++-------
 multipathd/main.c                       | 45 ++++++++++++++++---------
 4 files changed, 42 insertions(+), 38 deletions(-)

diff --git a/libmpathpersist/libmpathpersist.version b/libmpathpersist/libmpathpersist.version
index e0748138..b52b7500 100644
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
index 933fe0d1..c73389b5 100644
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
index b2feee2a..6473091d 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -31,7 +31,7 @@
  *   The new version inherits the previous ones.
  */
 
-LIBMULTIPATH_9.0.0 {
+LIBMULTIPATH_10.0.0 {
 global:
 	/* symbols referenced by multipath and multipathd */
 	add_foreign;
@@ -284,21 +284,15 @@ global:
 	/* added in 8.2.0 */
 	check_daemon;
 
-local:
-	*;
-};
-
-LIBMULTIPATH_9.1.0 {
-global:
+	/* added in 9.1.0 */
 	timespeccmp;
-} LIBMULTIPATH_9.0.0;
 
-LIBMULTIPATH_9.2.0 {
-global:
+	/* added in 9.2.0 */
 	set_wakeup_fn;
-} LIBMULTIPATH_9.1.0;
 
-LIBMULTIPATH_9.3.0 {
-global:
+	/* added in 9.3.0 */
 	__snprint_config;
-} LIBMULTIPATH_9.2.0;
+
+local:
+	*;
+};
diff --git a/multipathd/main.c b/multipathd/main.c
index 2b416af9..1ead0904 100644
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
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

