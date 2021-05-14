Return-Path: <SRS0=HAWy=KJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ACFEC433ED
	for <dm-devel@archiver.kernel.org>; Fri, 14 May 2021 20:11:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9F6206144A
	for <dm-devel@archiver.kernel.org>; Fri, 14 May 2021 20:11:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F6206144A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1621023090;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OHdnf+/A2Ha8KIlwnPwCQLw4aatiC1JDvJ7+foBvGzQ=;
	b=RntgwG/2FKialzBkb1Yyho48Y6SH0j7s8Wp217yI4HIoGbQX2tce77NZYyo0QF4onrrF4T
	et0YD50qCqXPFVVyMbC78qG1W3StibdvmBWOcZAt0U7PL6wLWHNq9Rgj2h68k6cOyxSr3T
	0TFZJtXXvtmhuL3dl0+JUczx66rH7Us=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-iMaorkVLOLOUTnVSexCQiA-1; Fri, 14 May 2021 16:11:28 -0400
X-MC-Unique: iMaorkVLOLOUTnVSexCQiA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DA811007476;
	Fri, 14 May 2021 20:11:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D9F71037F21;
	Fri, 14 May 2021 20:11:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4752C180B7A2;
	Fri, 14 May 2021 20:11:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14EKB9EE010846 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 14 May 2021 16:11:09 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id F41B55D9E3; Fri, 14 May 2021 20:11:09 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 431E85D9D0;
	Fri, 14 May 2021 20:11:05 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 14EKB3Tf020061; 
	Fri, 14 May 2021 15:11:04 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 14EKB3LS020060;
	Fri, 14 May 2021 15:11:03 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Fri, 14 May 2021 15:10:57 -0500
Message-Id: <1621023060-20011-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1621023060-20011-1-git-send-email-bmarzins@redhat.com>
References: <1621023060-20011-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v3 3/6] multipathd: fix ev_remove_path return
	code handling
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When ev_remove_path() returned success, callers assumed that the path
(and possibly the map) had been removed.  When ev_remove_path() returned
failure, callers assumed that the path had not been removed. However,
the path could be removed on both success or failure. This could cause
callers to dereference the path after it was removed.

To deal with this, make ev_remove_path() return a different symbolic
value for each outcome, and make the callers react appropriately for
the different values. Found by coverity.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli_handlers.c | 14 +++++++++++--
 multipathd/main.c         | 41 ++++++++++++++++++++-------------------
 multipathd/main.h         | 14 +++++++++++++
 3 files changed, 47 insertions(+), 22 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 1de6ad8e..1462ea84 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -752,7 +752,8 @@ cli_add_path (void * v, char ** reply, int * len, void * data)
 				/* Have the checker reinstate this path asap */
 				pp->tick = 1;
 				return 0;
-			} else if (!ev_remove_path(pp, vecs, true))
+			} else if (ev_remove_path(pp, vecs, true) &
+				   REMOVE_PATH_SUCCESS)
 				/* Path removed in ev_remove_path() */
 				pp = NULL;
 			else {
@@ -813,6 +814,7 @@ cli_del_path (void * v, char ** reply, int * len, void * data)
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, PATH);
 	struct path *pp;
+	int ret;
 
 	param = convert_dev(param, 1);
 	condlog(2, "%s: remove path (operator)", param);
@@ -821,7 +823,15 @@ cli_del_path (void * v, char ** reply, int * len, void * data)
 		condlog(0, "%s: path already removed", param);
 		return 1;
 	}
-	return ev_remove_path(pp, vecs, 1);
+	ret = ev_remove_path(pp, vecs, 1);
+	if (ret == REMOVE_PATH_DELAY) {
+		*reply = strdup("delayed\n");
+		*len = strlen(*reply) + 1;
+	} else if (ret == REMOVE_PATH_MAP_ERROR) {
+		*reply = strdup("map reload error. removed\n");
+		*len = strlen(*reply) + 1;
+	}
+	return (ret == REMOVE_PATH_FAILURE);
 }
 
 int
diff --git a/multipathd/main.c b/multipathd/main.c
index 6090434c..8e2beddd 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -838,7 +838,7 @@ handle_path_wwid_change(struct path *pp, struct vectors *vecs)
 		return;
 
 	udd = udev_device_ref(pp->udev);
-	if (ev_remove_path(pp, vecs, 1) != 0 && pp->mpp) {
+	if (!(ev_remove_path(pp, vecs, 1) & REMOVE_PATH_SUCCESS) && pp->mpp) {
 		pp->dmstate = PSTATE_FAILED;
 		dm_fail_path(pp->mpp->alias, pp->dev_t);
 	}
@@ -948,8 +948,8 @@ uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 				 * Make another attempt to remove the path
 				 */
 				pp->mpp = prev_mpp;
-				ret = ev_remove_path(pp, vecs, true);
-				if (ret != 0) {
+				if (!(ev_remove_path(pp, vecs, true) &
+				      REMOVE_PATH_SUCCESS)) {
 					/*
 					 * Failure in ev_remove_path will keep
 					 * path in pathvec in INIT_REMOVED state
@@ -960,6 +960,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 					dm_fail_path(pp->mpp->alias, pp->dev_t);
 					condlog(1, "%s: failed to re-add path still mapped in %s",
 						pp->dev, pp->mpp->alias);
+					ret = 1;
 				} else if (r == PATHINFO_OK)
 					/*
 					 * Path successfully freed, move on to
@@ -1167,7 +1168,6 @@ static int
 uev_remove_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 {
 	struct path *pp;
-	int ret;
 
 	condlog(3, "%s: remove path (uevent)", uev->kernel);
 	delete_foreign(uev->udev);
@@ -1177,21 +1177,18 @@ uev_remove_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 	pthread_testcancel();
 	pp = find_path_by_dev(vecs->pathvec, uev->kernel);
 	if (pp)
-		ret = ev_remove_path(pp, vecs, need_do_map);
+		ev_remove_path(pp, vecs, need_do_map);
 	lock_cleanup_pop(vecs->lock);
-	if (!pp) {
-		/* Not an error; path might have been purged earlier */
+	if (!pp) /* Not an error; path might have been purged earlier */
 		condlog(0, "%s: path already removed", uev->kernel);
-		return 0;
-	}
-	return ret;
+	return 0;
 }
 
 int
 ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 {
 	struct multipath * mpp;
-	int i, retval = 0;
+	int i, retval = REMOVE_PATH_SUCCESS;
 	char params[PARAMS_SIZE] = {0};
 
 	/*
@@ -1245,7 +1242,6 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 				condlog(2, "%s: removed map after"
 					" removing all paths",
 					alias);
-				retval = 0;
 				/* flush_map() has freed the path */
 				goto out;
 			}
@@ -1262,11 +1258,14 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 
 		if (mpp->wait_for_udev) {
 			mpp->wait_for_udev = 2;
+			retval = REMOVE_PATH_DELAY;
 			goto out;
 		}
 
-		if (!need_do_map)
+		if (!need_do_map) {
+			retval = REMOVE_PATH_DELAY;
 			goto out;
+		}
 		/*
 		 * reload the map
 		 */
@@ -1275,7 +1274,7 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 			condlog(0, "%s: failed in domap for "
 				"removal of path %s",
 				mpp->alias, pp->dev);
-			retval = 1;
+			retval = REMOVE_PATH_FAILURE;
 		} else {
 			/*
 			 * update our state from kernel
@@ -1283,12 +1282,12 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 			char devt[BLK_DEV_SIZE];
 
 			strlcpy(devt, pp->dev_t, sizeof(devt));
+
+			/* setup_multipath will free the path
+			 * regardless of whether it succeeds or
+			 * fails */
 			if (setup_multipath(vecs, mpp))
-				return 1;
-			/*
-			 * Successful map reload without this path:
-			 * sync_map_state() will free it.
-			 */
+				return REMOVE_PATH_MAP_ERROR;
 			sync_map_state(mpp);
 
 			condlog(2, "%s: path removed from map %s",
@@ -1304,8 +1303,10 @@ out:
 	return retval;
 
 fail:
+	condlog(0, "%s: error removing path. removing map %s", pp->dev,
+		mpp->alias);
 	remove_map_and_stop_waiter(mpp, vecs);
-	return 1;
+	return REMOVE_PATH_MAP_ERROR;
 }
 
 static int
diff --git a/multipathd/main.h b/multipathd/main.h
index ddd953f9..bc1f938f 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -13,6 +13,20 @@ enum daemon_status {
 	DAEMON_STATUS_SIZE,
 };
 
+enum remove_path_result {
+	REMOVE_PATH_FAILURE = 0x0, /* path could not be removed. It is still
+				    * part of the kernel map, but its state
+				    * is set to INIT_REMOVED, and it will be
+				    * removed at the next possible occassion */
+	REMOVE_PATH_SUCCESS = 0x1, /* path was removed */
+	REMOVE_PATH_DELAY = 0x2, /* path is set to be removed later. it
+			          * currently still exists and is part of the
+			          * kernel map */
+	REMOVE_PATH_MAP_ERROR = 0x5, /* map was removed because of error. value
+				      * includes REMOVE_PATH_SUCCESS bit
+				      * because the path was also removed */
+};
+
 struct prout_param_descriptor;
 struct prin_resp;
 
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

