Return-Path: <SRS0=4utB=KI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AD36C433ED
	for <dm-devel@archiver.kernel.org>; Thu, 13 May 2021 17:23:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CFA386143B
	for <dm-devel@archiver.kernel.org>; Thu, 13 May 2021 17:23:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CFA386143B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1620926636;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YzzYj1EskFqclu9hAXed3pMk71WrgkV8JlP4XXdll6I=;
	b=K9noMM1SakbjhsG44nl2kC6WRxm0Kaj8X5roR2CdCs33ryC7KdJtg+zsViTR21Z6kc1y2F
	IzwOg/YvDbAgLQHJH4XYt+CYKJ/rx1dMBJK0CDwjthBzC2JDOwJo1diyNSryviPeAhcqRN
	H+g+bl7ZGydzr6aZgxxvj5uJ1VG/IwI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-VnFpky6bOlGfFKB5-XQWGg-1; Thu, 13 May 2021 13:23:54 -0400
X-MC-Unique: VnFpky6bOlGfFKB5-XQWGg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1863F10AE5E8;
	Thu, 13 May 2021 17:23:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F32932B0B2;
	Thu, 13 May 2021 17:23:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CCF86180B464;
	Thu, 13 May 2021 17:23:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14DHNQjl005685 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 13 May 2021 13:23:26 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3AB6A5D736; Thu, 13 May 2021 17:23:26 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 13FE66249C;
	Thu, 13 May 2021 17:23:26 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 14DHNOJK012091; 
	Thu, 13 May 2021 12:23:24 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 14DHNNDB012090;
	Thu, 13 May 2021 12:23:23 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu, 13 May 2021 12:23:15 -0500
Message-Id: <1620926595-12029-7-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1620926595-12029-1-git-send-email-bmarzins@redhat.com>
References: <1620926595-12029-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 6/6] multipathd: use symbolic returns for
	ev_remove_path()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

There are many possible outcomes of calling ev_remove_path(), and not
all callers agree on which outcomes are a success and which are a
failure. So ev_remove_path() should simply return a different value for
each outcome, and the callers can decide how to deal with them.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli_handlers.c | 14 ++++++++++++--
 multipathd/main.c         | 35 +++++++++++++++++++----------------
 multipathd/main.h         |  9 +++++++++
 3 files changed, 40 insertions(+), 18 deletions(-)

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
index 4bdf14bd..72fb7e38 100644
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
@@ -1167,7 +1168,7 @@ static int
 uev_remove_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 {
 	struct path *pp;
-	int ret;
+	int ret = 0;
 
 	condlog(3, "%s: remove path (uevent)", uev->kernel);
 	delete_foreign(uev->udev);
@@ -1176,8 +1177,8 @@ uev_remove_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 	lock(&vecs->lock);
 	pthread_testcancel();
 	pp = find_path_by_dev(vecs->pathvec, uev->kernel);
-	if (pp)
-		ret = ev_remove_path(pp, vecs, need_do_map);
+	if (pp && ev_remove_path(pp, vecs, need_do_map) == REMOVE_PATH_FAILURE)
+		ret = 1;
 	lock_cleanup_pop(vecs->lock);
 	if (!pp) {
 		/* Not an error; path might have been purged earlier */
@@ -1191,7 +1192,7 @@ int
 ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 {
 	struct multipath * mpp;
-	int i, retval = 0;
+	int i, retval = REMOVE_PATH_SUCCESS;
 	char params[PARAMS_SIZE] = {0};
 
 	/*
@@ -1245,7 +1246,6 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 				condlog(2, "%s: removed map after"
 					" removing all paths",
 					alias);
-				retval = 0;
 				/* flush_map() has freed the path */
 				goto out;
 			}
@@ -1262,11 +1262,14 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 
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
@@ -1275,7 +1278,7 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 			condlog(0, "%s: failed in domap for "
 				"removal of path %s",
 				mpp->alias, pp->dev);
-			retval = 1;
+			retval = REMOVE_PATH_FAILURE;
 		} else {
 			/*
 			 * update our state from kernel
@@ -1283,12 +1286,12 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 			char devt[BLK_DEV_SIZE];
 
 			strlcpy(devt, pp->dev_t, sizeof(devt));
+
+			/* setup_multipath will free the path
+			 * regardless of whether it succeeds or
+			 * fails */
 			if (setup_multipath(vecs, mpp))
-				return 0;
-			/*
-			 * Successful map reload without this path:
-			 * sync_map_state() will free it.
-			 */
+				return REMOVE_PATH_MAP_ERROR;
 			sync_map_state(mpp);
 
 			condlog(2, "%s: path removed from map %s",
@@ -1307,7 +1310,7 @@ fail:
 	condlog(0, "%s: error removing path. removing map %s", pp->dev,
 		mpp->alias);
 	remove_map_and_stop_waiter(mpp, vecs);
-	return 0;
+	return REMOVE_PATH_MAP_ERROR;
 }
 
 static int
diff --git a/multipathd/main.h b/multipathd/main.h
index ddd953f9..24d050c8 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -13,6 +13,15 @@ enum daemon_status {
 	DAEMON_STATUS_SIZE,
 };
 
+#define REMOVE_PATH_FAILURE 0x0 /* path was not removed */
+#define REMOVE_PATH_SUCCESS 0x1 /* path was removed */
+#define REMOVE_PATH_DELAY 0x2 /* path is set to be removed later. it
+			       * currently still exists and is part of the
+			       * kernel map */
+#define REMOVE_PATH_MAP_ERROR 0x5 /* map was removed because of error. value
+				   * includes REMOVE_PATH_SUCCESS bit
+				   * because the path was also removed */
+
 struct prout_param_descriptor;
 struct prin_resp;
 
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

