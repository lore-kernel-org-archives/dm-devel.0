Return-Path: <SRS0=0/yZ=PI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2959C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 20 Oct 2021 19:19:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 667216135F
	for <dm-devel@archiver.kernel.org>; Wed, 20 Oct 2021 19:19:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 667216135F
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1634757553;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1YHbpqUMdkrhSilOtH+JYjO3rQEOn9h59YFRUtQAAwc=;
	b=h8ntgtug0TrNl2nAfyMA0YvKZXhsduW3sqG7s4EtnZckv4vAdec2tInd8swniXeGgamgWd
	kKXZbT80P3b/QZXmACme9wD/inDEPP2TFBpo8cEVfFrT/IMQZaDXQHrkGgcJRI9eLLjXwD
	PgiQ/S3eBwmn0KDt0ASXmm8kBuKUFE0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-O1tlFhLwPz-XPQnVmYne3w-1; Wed, 20 Oct 2021 15:19:09 -0400
X-MC-Unique: O1tlFhLwPz-XPQnVmYne3w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1990D104ECFC;
	Wed, 20 Oct 2021 19:19:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C4C2660C0F;
	Wed, 20 Oct 2021 19:19:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8F6751800FE4;
	Wed, 20 Oct 2021 19:19:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19KJFVrR000606 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 20 Oct 2021 15:15:32 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E582A10016F5; Wed, 20 Oct 2021 19:15:31 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A7DB4100164A;
	Wed, 20 Oct 2021 19:15:31 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 19KJFTKM006073; 
	Wed, 20 Oct 2021 14:15:30 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 19KJFTAi006072;
	Wed, 20 Oct 2021 14:15:29 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 20 Oct 2021 14:15:20 -0500
Message-Id: <1634757322-6015-6-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1634757322-6015-1-git-send-email-bmarzins@redhat.com>
References: <1634757322-6015-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 5/7] multipathd: fully initialize paths added by
	update_pathvec_from_dm
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
---
 libmultipath/structs.h     |  6 +++++
 libmultipath/structs_vec.c |  5 ++--
 multipathd/cli_handlers.c  |  4 ++++
 multipathd/main.c          | 48 ++++++++++++++++++++++++++++++++++----
 multipathd/main.h          |  1 +
 5 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index d0b266b7..69409fd4 100644
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
index fb26437a..1de9175e 100644
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
index 58b9916c..8d37431e 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -526,6 +526,10 @@ cli_add_path (void *v, struct strbuf *reply, void *data)
 			return 1;
 		}
 
+		if (pp->initialized == INIT_PARTIAL &&
+		    finish_path_init(pp, vecs) < 0)
+			return 1;
+
 		if (pp->mpp)
 			return 0;
 	} else if (pp) {
diff --git a/multipathd/main.c b/multipathd/main.c
index cc4a4a5d..4b8e2cde 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -976,12 +976,19 @@ check_path_wwid_change(struct path *pp)
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
@@ -1000,7 +1007,10 @@ uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
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
@@ -1110,6 +1120,8 @@ uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 	}
 out:
 	lock_cleanup_pop(vecs->lock);
+	if (partial_init)
+		return uev_update_path(uev, vecs);
 	return ret;
 }
 
@@ -1405,6 +1417,25 @@ fail:
 	return REMOVE_PATH_MAP_ERROR;
 }
 
+int
+finish_path_init(struct path *pp, struct vectors * vecs)
+{
+	int r;
+	struct config *conf;
+
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
@@ -1443,7 +1474,7 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 		}
 		/* Don't deal with other types of failed initialization
 		 * now. check_path will handle it */
-		if (!strlen(pp->wwid))
+		if (!strlen(pp->wwid) && pp->initialized != INIT_PARTIAL)
 			goto out;
 
 		strcpy(wwid, pp->wwid);
@@ -1451,12 +1482,20 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 
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
@@ -1507,6 +1546,7 @@ out:
 
 		condlog(0, "%s: spurious uevent, path not found", uev->kernel);
 	}
+	/* pp->initalized must not be INIT_PARTIAL if needs_reinit is set */
 	if (needs_reinit)
 		retval = uev_add_path(uev, vecs, 1);
 	return retval;
@@ -2116,7 +2156,7 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 	int marginal_pathgroups, marginal_changed = 0;
 	int ret;
 
-	if (((pp->initialized == INIT_OK ||
+	if (((pp->initialized == INIT_OK || pp->initialized == INIT_PARTIAL ||
 	      pp->initialized == INIT_REQUESTED_UDEV) && !pp->mpp) ||
 	    pp->initialized == INIT_REMOVED)
 		return 0;
diff --git a/multipathd/main.h b/multipathd/main.h
index c8a1ce92..4acd1b8c 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -66,4 +66,5 @@ int reload_and_sync_map(struct multipath *mpp, struct vectors *vecs,
 
 void handle_path_wwid_change(struct path *pp, struct vectors *vecs);
 bool check_path_wwid_change(struct path *pp);
+int finish_path_init(struct path *pp, struct vectors * vecs);
 #endif /* MAIN_H */
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

