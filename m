Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D0C5C4332F
	for <dm-devel@archiver.kernel.org>; Tue, 20 Dec 2022 23:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671579735;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2GpfyEn4SKaouFUqi0XTZSbgGoXpskct++5Fbi0IcAw=;
	b=eQH7wir9mlG3DjZ+R4KtNuDWcTv92JbdBM7btE9HvYEmcjNaTx0ozPhIAdZMy3hwyzYaYF
	VZkxuV/DniMRFwPmgggjNXMMkP4vh/qJADccLe5V+EjmxG1I1ZFhck24m9NkmODWLX919K
	RezegYX181xQBYbRVpxo2tROqohG7JI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-CxvMjkSUMGyl215sQdLBFQ-1; Tue, 20 Dec 2022 18:41:34 -0500
X-MC-Unique: CxvMjkSUMGyl215sQdLBFQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5AEC03C025CE;
	Tue, 20 Dec 2022 23:41:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BC7EF2026D4B;
	Tue, 20 Dec 2022 23:41:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F1F5F19465A3;
	Tue, 20 Dec 2022 23:41:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E4B9F19465A3
 for <dm-devel@listman.corp.redhat.com>; Tue, 20 Dec 2022 23:41:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6F022492B02; Tue, 20 Dec 2022 23:41:19 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C75FB492B00;
 Tue, 20 Dec 2022 23:41:18 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 2BKNfHMI023700;
 Tue, 20 Dec 2022 17:41:17 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 2BKNfHN9023699;
 Tue, 20 Dec 2022 17:41:17 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 20 Dec 2022 17:41:10 -0600
Message-Id: <1671579675-23658-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1671579675-23658-1-git-send-email-bmarzins@redhat.com>
References: <1671579675-23658-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH 1/6] multipathd: make pr registration consistent
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

multipathd was inconsistent on what it did with persistent reservations
when a multipath device was created. If a multipath device with a
configured reservation key was created during configure(), multipathd
would try to read the registered keys using an active path. If it saw a
matching key, it would set the prflag, but not attempt to register the
key on any of the other paths.  This means that if a new path had
appeared while multipathd was not running, it wouldn't register the key
on this path.

If the multipath device was created during ev_add_path(), multipathd
would used the added path to check if there was a matching key and if
there was, register the key only on the added path and then set the
prflag. This could be problematic if the device was created with
multiple paths, for instance because find_mutipaths was set to "yes" and
a second path just appeared. In this case, if the device happened to be
only registered on the second path, it would not get registered on the
first path.

If the multipath device was added to multipathd during a call to
ev_add_map(), multipathd wouldn't set the prflag or register the key on
any paths.

After a device was created with the prflag set, if a new path appeared
before the creation uevent, and multipathd was forced to delay adding
it, when it finally updated the multipath device, the key would be
registered on all paths, fixing any paths missed during creation.
However, if a new path appeared after the creation uevent, the key would
only be registered on that new path. Any paths that were missed on
creation would stay missed.

persistent key registration needs to be handled consistently.  This
patch does so by making sure that however a multipath device is added to
multipathd, it will check to see if the configured key is registered. If
it is, multipathd will set the prflag and register the key on all the
currently active paths.

When a new path is added, multipathd will use it to check for active
keys, as before. But if it finds a matching key and prflag isn't
currently set, it will register the key on all paths.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 1e1b254f..f7212d7b 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -586,13 +586,26 @@ flush_map_nopaths(struct multipath *mpp, struct vectors *vecs) {
 	return false;
 }
 
+static void
+pr_register_active_paths(struct multipath *mpp)
+{
+	unsigned int i, j;
+	struct path *pp;
+	struct pathgroup *pgp;
+
+	vector_foreach_slot (mpp->pg, pgp, i) {
+		vector_foreach_slot (pgp->paths, pp, j) {
+			if ((pp->state == PATH_UP) || (pp->state == PATH_GHOST))
+				mpath_pr_event_handle(pp);
+		}
+	}
+}
+
 static int
 update_map (struct multipath *mpp, struct vectors *vecs, int new_map)
 {
 	int retries = 3;
 	char *params __attribute__((cleanup(cleanup_charp))) = NULL;
-	struct path *pp;
-	int i;
 
 retry:
 	condlog(4, "%s: updating new map", mpp->alias);
@@ -609,15 +622,6 @@ retry:
 
 	mpp->action = ACT_RELOAD;
 
-	if (mpp->prflag) {
-		vector_foreach_slot(mpp->paths, pp, i) {
-			if ((pp->state == PATH_UP)  || (pp->state == PATH_GHOST)) {
-				/* persistent reservation check*/
-				mpath_pr_event_handle(pp);
-			}
-		}
-	}
-
 	if (setup_map(mpp, &params, vecs)) {
 		condlog(0, "%s: failed to setup new map in update", mpp->alias);
 		retries = -1;
@@ -643,6 +647,11 @@ fail:
 
 	sync_map_state(mpp);
 
+	if (!mpp->prflag)
+		update_map_pr(mpp);
+	if (mpp->prflag)
+		pr_register_active_paths(mpp);
+
 	if (retries < 0)
 		condlog(0, "%s: failed reload in new map update", mpp->alias);
 	return 0;
@@ -1191,6 +1200,7 @@ ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
 	int start_waiter = 0;
 	int ret;
 	int ro;
+	unsigned char prflag = 0;
 
 	/*
 	 * need path UID to go any further
@@ -1234,6 +1244,8 @@ rescan:
 
 		verify_paths(mpp);
 		mpp->action = ACT_RELOAD;
+		prflag = mpp->prflag;
+		mpath_pr_event_handle(pp);
 	} else {
 		if (!should_multipath(pp, vecs->pathvec, vecs->mpvec)) {
 			orphan_path(pp, "only one path");
@@ -1252,9 +1264,6 @@ rescan:
 			goto fail; /* leave path added to pathvec */
 	}
 
-	/* persistent reservation check*/
-	mpath_pr_event_handle(pp);
-
 	/* ro check - if new path is ro, force map to be ro as well */
 	ro = sysfs_get_ro(pp);
 	if (ro == 1)
@@ -1319,6 +1328,10 @@ rescan:
 	sync_map_state(mpp);
 
 	if (retries >= 0) {
+		if (start_waiter)
+			update_map_pr(mpp);
+		if (mpp->prflag && !prflag)
+				pr_register_active_paths(mpp);
 		condlog(2, "%s [%s]: path added to devmap %s",
 			pp->dev, pp->dev_t, mpp->alias);
 		return 0;
@@ -2852,6 +2865,8 @@ configure (struct vectors * vecs, enum force_reload_types reload_type)
 		if (remember_wwid(mpp->wwid) == 1)
 			trigger_paths_udev_change(mpp, true);
 		update_map_pr(mpp);
+		if (mpp->prflag)
+			pr_register_active_paths(mpp);
 	}
 
 	/*
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

