Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07E5AC433FE
	for <dm-devel@archiver.kernel.org>; Tue, 18 Jan 2022 03:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1642476478;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=t8+ggFj3zxmKjzBMNVqOha59cVHJoHld3+kcFtwKs6I=;
	b=DPzOixvOuF50qQNzHjb9MSwGcPeDldm2Vi9UjvW47/s1b91nBCNklSlfq954sieKSv01WH
	oluG6rYzrR+bHgDuI1FtQtvbrEmi+Ptlo8Ato6Tj9ab6zWDFFR0SRQRQwFmRw3p2SZKCZ9
	zTOUIJ1qaq3kub88MywhEyvRnIjNnd4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-66-MoCiORn0Myy-7VUybZC5ow-1; Mon, 17 Jan 2022 22:27:53 -0500
X-MC-Unique: MoCiORn0Myy-7VUybZC5ow-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 287A32F2C;
	Tue, 18 Jan 2022 03:27:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0BFC84697F;
	Tue, 18 Jan 2022 03:27:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7FC964BB7C;
	Tue, 18 Jan 2022 03:27:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20I3Rl86028845 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 17 Jan 2022 22:27:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F41DB1B5B7; Tue, 18 Jan 2022 03:27:47 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C4004D739;
	Tue, 18 Jan 2022 03:27:39 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 20I3RbGJ006020; 
	Mon, 17 Jan 2022 21:27:37 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 20I3RaIo006019;
	Mon, 17 Jan 2022 21:27:36 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon, 17 Jan 2022 21:27:32 -0600
Message-Id: <1642476453-5974-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1642476453-5974-1-git-send-email-bmarzins@redhat.com>
References: <1642476453-5974-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 2/3] libmultipath: make helper function to
	trigger path uevents
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

Pull the code that checks if a path needs to trigger a uevent, and
triggers, out of trigger_paths_udev_change() and into a new function,
trigger_path_udev_change(). This function will be used separately by
a future patch. No functional changes.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c | 79 +++++++++++++++++++++-------------------
 libmultipath/configure.h |  1 +
 2 files changed, 43 insertions(+), 37 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index ec38f325..eca11ba0 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -503,11 +503,8 @@ unref:
 }
 
 void
-trigger_paths_udev_change(struct multipath *mpp, bool is_mpath)
+trigger_path_udev_change(struct path *pp, bool is_mpath)
 {
-	struct pathgroup *pgp;
-	struct path *pp;
-	int i, j;
 	/*
 	 * If a path changes from multipath to non-multipath, we must
 	 * synthesize an artificial "add" event, otherwise the LVM2 rules
@@ -515,6 +512,45 @@ trigger_paths_udev_change(struct multipath *mpp, bool is_mpath)
 	 * irritate ourselves with an "add", so use "change".
 	 */
 	const char *action = is_mpath ? "change" : "add";
+	const char *env;
+
+	if (!pp->udev)
+		return;
+	/*
+	 * Paths that are already classified as multipath
+	 * members don't need another uevent.
+	 */
+	env = udev_device_get_property_value(
+		pp->udev, "DM_MULTIPATH_DEVICE_PATH");
+
+	if (is_mpath && env != NULL && !strcmp(env, "1")) {
+		/*
+		 * If FIND_MULTIPATHS_WAIT_UNTIL is not "0",
+		 * path is in "maybe" state and timer is running
+		 * Send uevent now (see multipath.rules).
+		 */
+		env = udev_device_get_property_value(
+			pp->udev, "FIND_MULTIPATHS_WAIT_UNTIL");
+		if (env == NULL || !strcmp(env, "0"))
+			return;
+	} else if (!is_mpath &&
+		   (env == NULL || !strcmp(env, "0")))
+		return;
+
+	condlog(3, "triggering %s uevent for %s (is %smultipath member)",
+		action, pp->dev, is_mpath ? "" : "no ");
+	sysfs_attr_set_value(pp->udev, "uevent",
+			     action, strlen(action));
+	trigger_partitions_udev_change(pp->udev, action,
+				       strlen(action));
+}
+
+void
+trigger_paths_udev_change(struct multipath *mpp, bool is_mpath)
+{
+	struct pathgroup *pgp;
+	struct path *pp;
+	int i, j;
 
 	if (!mpp || !mpp->pg)
 		return;
@@ -522,39 +558,8 @@ trigger_paths_udev_change(struct multipath *mpp, bool is_mpath)
 	vector_foreach_slot (mpp->pg, pgp, i) {
 		if (!pgp->paths)
 			continue;
-		vector_foreach_slot(pgp->paths, pp, j) {
-			const char *env;
-
-			if (!pp->udev)
-				continue;
-			/*
-			 * Paths that are already classified as multipath
-			 * members don't need another uevent.
-			 */
-			env = udev_device_get_property_value(
-				pp->udev, "DM_MULTIPATH_DEVICE_PATH");
-
-			if (is_mpath && env != NULL && !strcmp(env, "1")) {
-				/*
-				 * If FIND_MULTIPATHS_WAIT_UNTIL is not "0",
-				 * path is in "maybe" state and timer is running
-				 * Send uevent now (see multipath.rules).
-				 */
-				env = udev_device_get_property_value(
-					pp->udev, "FIND_MULTIPATHS_WAIT_UNTIL");
-				if (env == NULL || !strcmp(env, "0"))
-					continue;
-			} else if (!is_mpath &&
-				   (env == NULL || !strcmp(env, "0")))
-				continue;
-
-			condlog(3, "triggering %s uevent for %s (is %smultipath member)",
-				action, pp->dev, is_mpath ? "" : "no ");
-			sysfs_attr_set_value(pp->udev, "uevent",
-					     action, strlen(action));
-			trigger_partitions_udev_change(pp->udev, action,
-						       strlen(action));
-		}
+		vector_foreach_slot(pgp->paths, pp, j)
+			trigger_path_udev_change(pp, is_mpath);
 	}
 
 	mpp->needs_paths_uevent = 0;
diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index efe18b7d..2bf73e65 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -56,6 +56,7 @@ int coalesce_paths (struct vectors *vecs, vector curmp, char * refwwid, int forc
 int get_refwwid (enum mpath_cmds cmd, const char *dev, enum devtypes dev_type,
 		 vector pathvec, char **wwid);
 struct udev_device *get_udev_device(const char *dev, enum devtypes dev_type);
+void trigger_path_udev_change(struct path *pp, bool is_mpath);
 void trigger_paths_udev_change(struct multipath *mpp, bool is_mpath);
 void trigger_partitions_udev_change(struct udev_device *dev, const char *action,
 				    int len);
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

