Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBD44C4332F
	for <dm-devel@archiver.kernel.org>; Tue, 20 Dec 2022 23:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671579730;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=UWaECTxWgyngqa9oQp7RgnHaqocsVtRWkhTEnM8WRco=;
	b=B/RQoxURJNQ4Cv2EUVqDSFy+PRotXKiAwIbIh9yPSbE3OK4sbwNnhVqTKjKObNO+aBDIeC
	nUh4MDJC8rUFAbEE/ZqAnVylfUEICxzz3MJVoUbcbkddkKqxw/9582lbMe/SUkjVlHQ5vi
	T19lQuco93g96DnTsemtVvehBMGEz6U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-221-qfYeo1HZMduh10hnu5UW2A-1; Tue, 20 Dec 2022 18:41:34 -0500
X-MC-Unique: qfYeo1HZMduh10hnu5UW2A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5AF31183B3CB;
	Tue, 20 Dec 2022 23:41:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A10DD2166B2B;
	Tue, 20 Dec 2022 23:41:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 796931946A78;
	Tue, 20 Dec 2022 23:41:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BA42B19465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 20 Dec 2022 23:41:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 91649492C1B; Tue, 20 Dec 2022 23:41:21 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 72389492C18;
 Tue, 20 Dec 2022 23:41:21 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 2BKNfKkq023708;
 Tue, 20 Dec 2022 17:41:20 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 2BKNfJwU023707;
 Tue, 20 Dec 2022 17:41:19 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 20 Dec 2022 17:41:12 -0600
Message-Id: <1671579675-23658-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1671579675-23658-1-git-send-email-bmarzins@redhat.com>
References: <1671579675-23658-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH 3/6] multipathd: handle no active paths in
 update_map_pr
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When a multipath device is first created, if it has a reservation key
configured, update_map_pr() will check for a matching key on the active
paths. If there were no active paths to check with, multipathd was
leaving mpp->prflag in PRFLAG_UNSET, as if there were no matching keys.
It's possible that when update_map_pr() is called, all the paths will be
in the PATH_PENDING state because the checkers haven't completed yet. In
this case, multipathd was treating the device as having no registered
keys without ever checking.

To solve this, multipath devices now start with prflag = PRFLAG_UNKNOWN.
It will remain in this state until multipathd actually tries to get the
registered keys down a path. If the map is in this state, it will check
newly active paths, and if it finds a matching key, it will register
the key down all active paths.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c |  8 ++++++++
 libmultipath/structs.h              |  1 +
 multipathd/cli_handlers.c           |  1 +
 multipathd/main.c                   | 19 ++++++++++++++-----
 4 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index a84d9474..8b52b746 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -738,6 +738,7 @@ int update_map_pr(struct multipath *mpp)
 	if (!get_be64(mpp->reservation_key))
 	{
 		/* Nothing to do. Assuming pr mgmt feature is disabled*/
+		mpp->prflag = PRFLAG_UNSET;
 		condlog(4, "%s: reservation_key not set in multipath.conf",
 			mpp->alias);
 		return MPATH_PR_SUCCESS;
@@ -749,6 +750,13 @@ int update_map_pr(struct multipath *mpp)
 		condlog(0,"%s : failed to alloc resp in update_map_pr", mpp->alias);
 		return MPATH_PR_OTHER;
 	}
+	if (count_active_paths(mpp) == 0)
+	{
+		condlog(0,"%s: No available paths to check pr status",
+			mpp->alias);
+		return MPATH_PR_OTHER;
+	}
+	mpp->prflag = PRFLAG_UNSET;
 	ret = mpath_prin_activepath(mpp, MPATH_PRIN_RKEY_SA, resp, noisy);
 
 	if (ret != MPATH_PR_SUCCESS )
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index f2265300..e2294323 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -377,6 +377,7 @@ typedef int (pgpolicyfn) (struct multipath *, vector);
 
 
 enum prflag_value {
+	PRFLAG_UNKNOWN,
 	PRFLAG_UNSET,
 	PRFLAG_SET,
 };
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 7ee2729f..ec5db1b8 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -1278,6 +1278,7 @@ static int
 cli_getprstatus (void * v, struct strbuf *reply, void * data)
 {
 	static const char * const prflag_str[] = {
+		[PRFLAG_UNKNOWN] = "unknown\n",
 		[PRFLAG_UNSET] = "unset\n",
 		[PRFLAG_SET] = "set\n",
 	};
diff --git a/multipathd/main.c b/multipathd/main.c
index 722235c7..bdeffe76 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -647,7 +647,7 @@ fail:
 
 	sync_map_state(mpp);
 
-	if (mpp->prflag == PRFLAG_UNSET)
+	if (mpp->prflag != PRFLAG_SET)
 		update_map_pr(mpp);
 	if (mpp->prflag == PRFLAG_SET)
 		pr_register_active_paths(mpp);
@@ -1330,7 +1330,7 @@ rescan:
 	if (retries >= 0) {
 		if (start_waiter)
 			update_map_pr(mpp);
-		if (mpp->prflag == PRFLAG_SET && prflag == PRFLAG_UNSET)
+		if (mpp->prflag == PRFLAG_SET && prflag != PRFLAG_SET)
 				pr_register_active_paths(mpp);
 		condlog(2, "%s [%s]: path added to devmap %s",
 			pp->dev, pp->dev_t, mpp->alias);
@@ -2492,13 +2492,17 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 		}
 
 		if (newstate == PATH_UP || newstate == PATH_GHOST) {
-			if (pp->mpp->prflag == PRFLAG_SET) {
+			if (pp->mpp->prflag != PRFLAG_UNSET) {
+				int prflag = pp->mpp->prflag;
 				/*
 				 * Check Persistent Reservation.
 				 */
 				condlog(2, "%s: checking persistent "
 					"reservation registration", pp->dev);
 				mpath_pr_event_handle(pp);
+				if (pp->mpp->prflag == PRFLAG_SET &&
+				    prflag != PRFLAG_SET)
+					pr_register_active_paths(pp->mpp);
 			}
 		}
 
@@ -3788,6 +3792,7 @@ void *  mpath_pr_event_handler_fn (void * pathp )
 		goto out;
 	}
 
+	mpp->prflag = PRFLAG_UNSET;
 	ret = prin_do_scsi_ioctl(pp->dev, MPATH_PRIN_RKEY_SA, resp, 0);
 	if (ret != MPATH_PR_SUCCESS )
 	{
@@ -3858,12 +3863,12 @@ int mpath_pr_event_handle(struct path *pp)
 	struct multipath * mpp;
 
 	if (pp->bus != SYSFS_BUS_SCSI)
-		return 0;
+		goto no_pr;
 
 	mpp = pp->mpp;
 
 	if (!get_be64(mpp->reservation_key))
-		return -1;
+		goto no_pr;
 
 	pthread_attr_init(&attr);
 	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
@@ -3876,4 +3881,8 @@ int mpath_pr_event_handle(struct path *pp)
 	pthread_attr_destroy(&attr);
 	rc = pthread_join(thread, NULL);
 	return 0;
+
+no_pr:
+	pp->mpp->prflag = PRFLAG_UNSET;
+	return 0;
 }
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

