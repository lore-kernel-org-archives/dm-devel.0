Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4742CC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:03:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DC5E861A86
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:03:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DC5E861A86
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-394-s-st5tpfMOWadoQT-jdpjw-1; Thu, 18 Nov 2021 18:03:34 -0500
X-MC-Unique: s-st5tpfMOWadoQT-jdpjw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6E331923766;
	Thu, 18 Nov 2021 23:03:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BD6B65C1D0;
	Thu, 18 Nov 2021 23:03:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9819D4EA37;
	Thu, 18 Nov 2021 23:03:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIMxQPC002487 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 17:59:26 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 27AFF400DFBC; Thu, 18 Nov 2021 22:59:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2242640CFD11
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 034D5185A79C
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:26 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-141-gGSBVLS0N4OIz0pW59X9kA-1; Thu, 18 Nov 2021 17:59:13 -0500
X-MC-Unique: gGSBVLS0N4OIz0pW59X9kA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5F99E217BA;
	Thu, 18 Nov 2021 22:59:12 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0908D13B11;
	Thu, 18 Nov 2021 22:59:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 0PJBAMDalmGHPAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 22:59:12 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 18 Nov 2021 23:58:36 +0100
Message-Id: <20211118225840.19810-45-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AIMxQPC002487
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 44/48] multipathd: fully initialize paths
	added by update_pathvec_from_dm
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Benjamin Marzinski <bmarzins@redhat.com>

When paths are added by update_pathvec_from_dm(), udev may not have
initialized them. This means that it's possible that they are supposed
to be blacklisted by udev properties, but weren't.  Also, in order to
avoid doing potentially stalling IO, update_pathvec_from_dm() doesn't
get all the path information in pathinfo(). These paths end up in the
unexpected state of INIT_MISSING_UDEV or INIT_NEW, but with their mpp
and wwid set.

If udev has already initialized the path, but multipathed wasn't
monitoring it, the blacklist checks and wwid determination in
update_pathvec_from_dm() will work correctly, so paths added by it are
safe, but not completely initialized. The most likely reason why this
would happen is if the path was manually removed from multipathd
monitoring with "multipathd del path". The most common time when
uninitialized paths would in be part of multipath devices is during
boot, after the pivot root, but before the udev coldplug happens. These
paths are not necessarily safe. It's possible that /etc/multipath.conf
in the initramfs and regular filesystem differ, and they should now be
either blacklisted by udev_property, or have a different wwid. However
an "add" event should appear for them shortly.

Multipath now has a new state to deal with these devices, INIT_PARTIAL.
Devices in this state are treated mostly like INIT_OK devices, but
when "multipathd add path" is called or an add/change uevent happens
on these devices, multipathd will finish initializing them, and remove
them if necessary.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs.h     |  6 +++++
 libmultipath/structs_vec.c |  5 ++--
 multipathd/cli_handlers.c  | 35 ++++++++++++++++++++++++--
 multipathd/main.c          | 51 +++++++++++++++++++++++++++++++++++---
 multipathd/main.h          |  1 +
 5 files changed, 90 insertions(+), 8 deletions(-)

diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index d0b266b..69409fd 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -200,6 +200,12 @@ enum initialized_states {
 	 * mapped by some multipath map because of map reload failure.
 	 */
 	INIT_REMOVED,
+	/*
+	 * INIT_PARTIAL: paths added by update_pathvec_from_dm() will not
+	 * be fully initialized. This will be handled when an add or
+	 * change uevent is received.
+	 */
+	INIT_PARTIAL,
 };
 
 enum prkey_sources {
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index fb26437..1de9175 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -194,6 +194,7 @@ bool update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
 					}
 					condlog(2, "%s: adding new path %s",
 						mpp->alias, pp->dev);
+					pp->initialized = INIT_PARTIAL;
 					store_path(pathvec, pp);
 					pp->tick = 1;
 				}
@@ -392,12 +393,12 @@ extract_hwe_from_path(struct multipath * mpp)
 	condlog(4, "%s: searching paths for valid hwe", mpp->alias);
 	/* doing this in two passes seems like paranoia to me */
 	vector_foreach_slot(mpp->paths, pp, i) {
-		if (pp->state == PATH_UP &&
+		if (pp->state == PATH_UP && pp->initialized != INIT_PARTIAL &&
 		    pp->initialized != INIT_REMOVED && pp->hwe)
 			goto done;
 	}
 	vector_foreach_slot(mpp->paths, pp, i) {
-		if (pp->state != PATH_UP &&
+		if ((pp->state != PATH_UP || pp->initialized == INIT_PARTIAL) &&
 		    pp->initialized != INIT_REMOVED && pp->hwe)
 			goto done;
 	}
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index f89f4e7..8bd407c 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -493,6 +493,33 @@ cli_reset_map_stats (void *v, struct strbuf *reply, void *data)
 	return 0;
 }
 
+static int
+add_partial_path(struct path *pp, struct vectors *vecs)
+{
+	char wwid[WWID_SIZE];
+	struct udev_device *udd;
+
+	udd = get_udev_device(pp->dev_t, DEV_DEVT);
+	if (!udd)
+		return 0;
+	strcpy(wwid, pp->wwid);
+	if (get_uid(pp, pp->state, udd, 0) != 0) {
+		strcpy(pp->wwid, wwid);
+		udev_device_unref(udd);
+		return 0;
+	}
+	if (strlen(wwid) && strncmp(wwid, pp->wwid, WWID_SIZE) != 0) {
+		condlog(0, "%s: path wwid changed from '%s' to '%s'. removing",
+			pp->dev, wwid, pp->wwid);
+		ev_remove_path(pp, vecs, 1);
+		udev_device_unref(udd);
+		return -1;
+	}
+	udev_device_unref(pp->udev);
+	pp->udev = udd;
+	return finish_path_init(pp, vecs);
+}
+
 static int
 cli_add_path (void *v, struct strbuf *reply, void *data)
 {
@@ -518,8 +545,12 @@ cli_add_path (void *v, struct strbuf *reply, void *data)
 	if (pp && pp->initialized != INIT_REMOVED) {
 		condlog(2, "%s: path already in pathvec", param);
 
-		if (pp->recheck_wwid == RECHECK_WWID_ON &&
-		    check_path_wwid_change(pp)) {
+		if (pp->initialized == INIT_PARTIAL) {
+			if (add_partial_path(pp, vecs) < 0)
+				return 1;
+		}
+		else if (pp->recheck_wwid == RECHECK_WWID_ON &&
+			 check_path_wwid_change(pp)) {
 			condlog(0, "%s: wwid changed. Removing device",
 				pp->dev);
 			handle_path_wwid_change(pp, vecs);
diff --git a/multipathd/main.c b/multipathd/main.c
index f8a422a..828d229 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -977,12 +977,19 @@ check_path_wwid_change(struct path *pp)
 	return false;
 }
 
+/*
+ * uev_add_path can call uev_update_path, and uev_update_path can call
+ * uev_add_path
+ */
+static int uev_update_path (struct uevent *uev, struct vectors * vecs);
+
 static int
 uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 {
 	struct path *pp;
 	int ret = 0, i;
 	struct config *conf;
+	bool partial_init = false;
 
 	condlog(3, "%s: add path (uevent)", uev->kernel);
 	if (strstr(uev->kernel, "..") != NULL) {
@@ -1001,7 +1008,10 @@ uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 		int r;
 		struct multipath *prev_mpp = NULL;
 
-		if (pp->initialized == INIT_REMOVED) {
+		if (pp->initialized == INIT_PARTIAL) {
+			partial_init = true;
+			goto out;
+		} else if (pp->initialized == INIT_REMOVED) {
 			condlog(3, "%s: re-adding removed path", pp->dev);
 			pp->initialized = INIT_NEW;
 			prev_mpp = pp->mpp;
@@ -1111,6 +1121,8 @@ uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 	}
 out:
 	lock_cleanup_pop(vecs->lock);
+	if (partial_init)
+		return uev_update_path(uev, vecs);
 	return ret;
 }
 
@@ -1406,6 +1418,28 @@ fail:
 	return REMOVE_PATH_MAP_ERROR;
 }
 
+int
+finish_path_init(struct path *pp, struct vectors * vecs)
+{
+	int r;
+	struct config *conf;
+
+	if (pp->udev && pp->uid_attribute && *pp->uid_attribute &&
+	    !udev_device_get_is_initialized(pp->udev))
+		return 0;
+	conf = get_multipath_config();
+	pthread_cleanup_push(put_multipath_config, conf);
+	r = pathinfo(pp, conf, DI_ALL|DI_BLACKLIST);
+	pthread_cleanup_pop(1);
+
+	if (r == PATHINFO_OK)
+		return 0;
+
+	condlog(0, "%s: error fully initializing path, removing", pp->dev);
+	ev_remove_path(pp, vecs, 1);
+	return -1;
+}
+
 static int
 uev_update_path (struct uevent *uev, struct vectors * vecs)
 {
@@ -1444,7 +1478,7 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 		}
 		/* Don't deal with other types of failed initialization
 		 * now. check_path will handle it */
-		if (!strlen(pp->wwid))
+		if (!strlen(pp->wwid) && pp->initialized != INIT_PARTIAL)
 			goto out;
 
 		strcpy(wwid, pp->wwid);
@@ -1452,12 +1486,20 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 
 		if (rc != 0)
 			strcpy(pp->wwid, wwid);
-		else if (strncmp(wwid, pp->wwid, WWID_SIZE) != 0) {
+		else if (strlen(wwid) &&
+			 strncmp(wwid, pp->wwid, WWID_SIZE) != 0) {
 			condlog(0, "%s: path wwid changed from '%s' to '%s'",
 				uev->kernel, wwid, pp->wwid);
 			ev_remove_path(pp, vecs, 1);
 			needs_reinit = 1;
 			goto out;
+		} else if (pp->initialized == INIT_PARTIAL) {
+			udev_device_unref(pp->udev);
+			pp->udev = udev_device_ref(uev->udev);
+			if (finish_path_init(pp, vecs) < 0) {
+				retval = 1;
+				goto out;
+			}
 		} else {
 			udev_device_unref(pp->udev);
 			pp->udev = udev_device_ref(uev->udev);
@@ -1508,6 +1550,7 @@ out:
 
 		condlog(0, "%s: spurious uevent, path not found", uev->kernel);
 	}
+	/* pp->initalized must not be INIT_PARTIAL if needs_reinit is set */
 	if (needs_reinit)
 		retval = uev_add_path(uev, vecs, 1);
 	return retval;
@@ -2117,7 +2160,7 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 	int marginal_pathgroups, marginal_changed = 0;
 	int ret;
 
-	if (((pp->initialized == INIT_OK ||
+	if (((pp->initialized == INIT_OK || pp->initialized == INIT_PARTIAL ||
 	      pp->initialized == INIT_REQUESTED_UDEV) && !pp->mpp) ||
 	    pp->initialized == INIT_REMOVED)
 		return 0;
diff --git a/multipathd/main.h b/multipathd/main.h
index c91f9f9..8356b25 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -65,4 +65,5 @@ int reload_and_sync_map(struct multipath *mpp, struct vectors *vecs,
 
 void handle_path_wwid_change(struct path *pp, struct vectors *vecs);
 bool check_path_wwid_change(struct path *pp);
+int finish_path_init(struct path *pp, struct vectors * vecs);
 #endif /* MAIN_H */
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

