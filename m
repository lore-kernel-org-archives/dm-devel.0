Return-Path: <SRS0=Tx5l=NY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 963F4C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  2 Sep 2021 22:04:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4BBFA60724
	for <dm-devel@archiver.kernel.org>; Thu,  2 Sep 2021 22:04:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4BBFA60724
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1630620267;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=EdaUOAZ3R6Z9UHEyeZ2EdweiOjhfHlmjsJCb8oy9dBE=;
	b=e9MlhfiErM1QfviZlSwW4alOdj+Kr7Ld8gviTcv0NYH1jYKnb4r9wnhjve0H68Qi5pDjNZ
	ys0uvQEcJfhIl5Q+6mgQRBvGyOjCvj+bfQ54sT4GkXRqJVeWZS+kykvTmhyn/FTREzl6CS
	WX8nsVUlX4P/LpjouPV0Zr+S7LvYwc8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-9WqlPL8MOteGA8MjippWRg-1; Thu, 02 Sep 2021 18:04:26 -0400
X-MC-Unique: 9WqlPL8MOteGA8MjippWRg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DADF5107ACE6;
	Thu,  2 Sep 2021 22:04:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C18DD60BF1;
	Thu,  2 Sep 2021 22:04:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 95CA744A5C;
	Thu,  2 Sep 2021 22:04:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 182Lw4tm013400 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 2 Sep 2021 17:58:04 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 882E95B826; Thu,  2 Sep 2021 21:58:04 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DBAA1369A;
	Thu,  2 Sep 2021 21:58:00 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 182LvxXn012315; 
	Thu, 2 Sep 2021 16:57:59 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 182LvwBC012314;
	Thu, 2 Sep 2021 16:57:58 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu,  2 Sep 2021 16:57:49 -0500
Message-Id: <1630619869-12251-7-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1630619869-12251-1-git-send-email-bmarzins@redhat.com>
References: <1630619869-12251-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 6/6] libmultipath: drop unnecessary parameter
	from remove_map()
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

When remove_map() is called, if the multipath device is in a mpvec, it
must be removed from it, because the device will be freed. Now that the
mpvec is passed as a separate parameter to remove_map(), the purge_vec
parameter is redundant.  It was only used by coalesce_paths(), since the
multipath device isn't on any vector when remove_map() is called there.
Instead, remove_map() can just be called with a NULL mpvec, when there
is no mpvec to remove the device from.

remove_map_by_alias() also has a redundant purge_vec parameter.  Since
it only removes a map if it finds in on vec->mpvec, calling it with
KEEP_VEC would be a bug, since it would leave a pointer to the freed
device in the vector.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist.c |  2 +-
 libmultipath/configure.c        | 13 ++++++-------
 libmultipath/structs_vec.c      | 12 ++++++------
 libmultipath/structs_vec.h      | 11 ++---------
 multipath/main.c                |  4 ++--
 multipathd/dmevents.c           |  2 +-
 multipathd/main.c               | 12 ++++++------
 7 files changed, 24 insertions(+), 32 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 26710e79..803a2a28 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -410,7 +410,7 @@ get_mpvec (vector curmp, vector pathvec, char * refwwid)
 		if (update_multipath_table(mpp, pathvec, DI_CHECKER) != DMP_OK ||
 		    update_mpp_paths(mpp, pathvec)) {
 			condlog(1, "error parsing map %s", mpp->wwid);
-			remove_map(mpp, pathvec, curmp, PURGE_VEC);
+			remove_map(mpp, pathvec, curmp);
 			i--;
 		} else
 			extract_hwe_from_path(mpp);
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 3f241c5c..7edb355b 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1198,7 +1198,7 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
 
 		if (!mpp->paths) {
 			condlog(0, "%s: skip coalesce (no paths)", mpp->alias);
-			remove_map(mpp, vecs->pathvec, vecs->mpvec, KEEP_VEC);
+			remove_map(mpp, vecs->pathvec, NULL);
 			continue;
 		}
 
@@ -1226,7 +1226,7 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
 		verify_paths(mpp);
 
 		if (setup_map(mpp, &params, vecs)) {
-			remove_map(mpp, vecs->pathvec, vecs->mpvec, KEEP_VEC);
+			remove_map(mpp, vecs->pathvec, NULL);
 			continue;
 		}
 
@@ -1248,7 +1248,7 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
 				condlog(2, "%s: %s map",
 					mpp->alias, (mpp->action == ACT_CREATE)?
 					"ignoring" : "removing");
-				remove_map(mpp, vecs->pathvec, vecs->mpvec, KEEP_VEC);
+				remove_map(mpp, vecs->pathvec, NULL);
 				continue;
 			} else /* if (r == DOMAP_RETRY && !is_daemon) */ {
 				ret = CP_RETRY;
@@ -1257,7 +1257,7 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
 		}
 		if (r == DOMAP_DRY) {
 			if (!vector_alloc_slot(newmp)) {
-				remove_map(mpp, vecs->pathvec, vecs->mpvec, KEEP_VEC);
+				remove_map(mpp, vecs->pathvec, NULL);
 				goto out;
 			}
 			vector_set_slot(newmp, mpp);
@@ -1282,14 +1282,13 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
 
 		if (mpp->action != ACT_REJECT) {
 			if (!vector_alloc_slot(newmp)) {
-				remove_map(mpp, vecs->pathvec, vecs->mpvec, KEEP_VEC);
+				remove_map(mpp, vecs->pathvec, NULL);
 				goto out;
 			}
 			vector_set_slot(newmp, mpp);
 		}
 		else
-			remove_map(mpp, vecs->pathvec, vecs->mpvec,
-				   KEEP_VEC);
+			remove_map(mpp, vecs->pathvec, NULL);
 	}
 	ret = CP_OK;
 out:
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 24d6fd24..85d97ac1 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -334,7 +334,7 @@ void set_path_removed(struct path *pp)
 }
 
 void
-remove_map(struct multipath *mpp, vector pathvec, vector mpvec, int purge_vec)
+remove_map(struct multipath *mpp, vector pathvec, vector mpvec)
 {
 	int i;
 
@@ -343,7 +343,7 @@ remove_map(struct multipath *mpp, vector pathvec, vector mpvec, int purge_vec)
 	 */
 	orphan_paths(pathvec, mpp, "map removed internally");
 
-	if (purge_vec &&
+	if (mpvec &&
 	    (i = find_slot(mpvec, (void *)mpp)) != -1)
 		vector_del_slot(mpvec, i);
 
@@ -354,12 +354,12 @@ remove_map(struct multipath *mpp, vector pathvec, vector mpvec, int purge_vec)
 }
 
 void
-remove_map_by_alias(const char *alias, struct vectors * vecs, int purge_vec)
+remove_map_by_alias(const char *alias, struct vectors * vecs)
 {
 	struct multipath * mpp = find_mp_by_alias(vecs->mpvec, alias);
 	if (mpp) {
 		condlog(2, "%s: removing map by alias", alias);
-		remove_map(mpp, vecs->pathvec, vecs->mpvec, purge_vec);
+		remove_map(mpp, vecs->pathvec, vecs->mpvec);
 	}
 }
 
@@ -373,7 +373,7 @@ remove_maps(struct vectors * vecs)
 		return;
 
 	vector_foreach_slot (vecs->mpvec, mpp, i) {
-		remove_map(mpp, vecs->pathvec, vecs->mpvec, PURGE_VEC);
+		remove_map(mpp, vecs->pathvec, vecs->mpvec);
 		i--;
 	}
 
@@ -704,7 +704,7 @@ struct multipath *add_map_with_path(struct vectors *vecs, struct path *pp,
 	return mpp;
 
 out:
-	remove_map(mpp, vecs->pathvec, vecs->mpvec, PURGE_VEC);
+	remove_map(mpp, vecs->pathvec, vecs->mpvec);
 	return NULL;
 }
 
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index ee2b723b..29ede454 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -27,15 +27,8 @@ int update_mpp_paths(struct multipath * mpp, vector pathvec);
 int update_multipath_strings (struct multipath *mpp, vector pathvec);
 void extract_hwe_from_path(struct multipath * mpp);
 
-enum {
-	KEEP_VEC,
-	PURGE_VEC,
-};
-
-void remove_map (struct multipath *mpp, vector pathvec, vector mpvec,
-		 int purge_vec);
-void remove_map_by_alias(const char *alias, struct vectors * vecs,
-			 int purge_vec);
+void remove_map (struct multipath *mpp, vector pathvec, vector mpvec);
+void remove_map_by_alias(const char *alias, struct vectors * vecs);
 void remove_maps (struct vectors * vecs);
 
 void sync_map_state (struct multipath *);
diff --git a/multipath/main.c b/multipath/main.c
index 6c70760f..65ece830 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -191,14 +191,14 @@ get_dm_mpvec (enum mpath_cmds cmd, vector curmp, vector pathvec, char * refwwid)
 		if (refwwid && strlen(refwwid) &&
 		    strncmp(mpp->wwid, refwwid, WWID_SIZE)) {
 			condlog(3, "skip map %s: out of scope", mpp->alias);
-			remove_map(mpp, pathvec, curmp, PURGE_VEC);
+			remove_map(mpp, pathvec, curmp);
 			i--;
 			continue;
 		}
 
 		if (update_multipath_table(mpp, pathvec, flags) != DMP_OK) {
 			condlog(1, "error parsing map %s", mpp->wwid);
-			remove_map(mpp, pathvec, curmp, PURGE_VEC);
+			remove_map(mpp, pathvec, curmp);
 			i--;
 			continue;
 		}
diff --git a/multipathd/dmevents.c b/multipathd/dmevents.c
index f52f5970..f035ee7f 100644
--- a/multipathd/dmevents.c
+++ b/multipathd/dmevents.c
@@ -359,7 +359,7 @@ static int dmevent_loop (void)
 		pthread_testcancel();
 		r = 0;
 		if (curr_dev.action == EVENT_REMOVE)
-			remove_map_by_alias(curr_dev.name, waiter->vecs, PURGE_VEC);
+			remove_map_by_alias(curr_dev.name, waiter->vecs);
 		else
 			r = update_multipath(waiter->vecs, curr_dev.name, 1);
 		pthread_cleanup_pop(1);
diff --git a/multipathd/main.c b/multipathd/main.c
index ae8272e3..3aff241d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -385,7 +385,7 @@ remove_map_and_stop_waiter(struct multipath *mpp, struct vectors *vecs)
 	condlog(3, "%s: removing map from internal tables", mpp->alias);
 	if (!poll_dmevents)
 		stop_waiter_thread(mpp);
-	remove_map(mpp, vecs->pathvec, vecs->mpvec, PURGE_VEC);
+	remove_map(mpp, vecs->pathvec, vecs->mpvec);
 }
 
 static void
@@ -518,7 +518,7 @@ retry:
 fail:
 	if (new_map && (retries < 0 || wait_for_events(mpp, vecs))) {
 		condlog(0, "%s: failed to create new map", mpp->alias);
-		remove_map(mpp, vecs->pathvec, vecs->mpvec, PURGE_VEC);
+		remove_map(mpp, vecs->pathvec, vecs->mpvec);
 		return 1;
 	}
 
@@ -572,7 +572,7 @@ add_map_without_path (struct vectors *vecs, const char *alias)
 
 	return mpp;
 out:
-	remove_map(mpp, vecs->pathvec, vecs->mpvec, PURGE_VEC);
+	remove_map(mpp, vecs->pathvec, vecs->mpvec);
 	return NULL;
 }
 
@@ -1162,7 +1162,7 @@ rescan:
 		goto fail;
 
 fail_map:
-	remove_map(mpp, vecs->pathvec, vecs->mpvec, PURGE_VEC);
+	remove_map(mpp, vecs->pathvec, vecs->mpvec);
 fail:
 	orphan_path(pp, "failed to add path");
 	return 1;
@@ -1469,7 +1469,7 @@ map_discovery (struct vectors * vecs)
 
 	vector_foreach_slot (vecs->mpvec, mpp, i)
 		if (update_multipath_table(mpp, vecs->pathvec, 0) != DMP_OK) {
-			remove_map(mpp, vecs->pathvec, vecs->mpvec, PURGE_VEC);
+			remove_map(mpp, vecs->pathvec, vecs->mpvec);
 			i--;
 		}
 
@@ -2706,7 +2706,7 @@ configure (struct vectors * vecs)
 	 */
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
 		if (wait_for_events(mpp, vecs)) {
-			remove_map(mpp, vecs->pathvec, vecs->mpvec, PURGE_VEC);
+			remove_map(mpp, vecs->pathvec, vecs->mpvec);
 			i--;
 			continue;
 		}
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

