Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 876BDC05027
	for <dm-devel@archiver.kernel.org>; Wed,  1 Feb 2023 15:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675267025;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qzz4WkAzRcnZDxHVbqnzFoW+Jcx9o/zbTL7J77JK3nM=;
	b=EFhMzK2OVAMrfL+g2qm1+KsBRibgJ5FERKSJ9MQfEM4InRiH0qmi8m88kFnc+GeJI8mhC5
	AVMMql9hDDjB3xcEu9szokIik41nQmzGTeIGsBF24WW0hGQliP8I8/BTuNvklTc58nuGt9
	lMOCN7L0hgsGPgKNy82r1DJQCPNoPOI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-LzEy59-ANtuRoQ9TGMv-EQ-1; Wed, 01 Feb 2023 10:56:58 -0500
X-MC-Unique: LzEy59-ANtuRoQ9TGMv-EQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83C8185651F;
	Wed,  1 Feb 2023 15:56:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8A9BF2166B36;
	Wed,  1 Feb 2023 15:56:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 57B1A19465A3;
	Wed,  1 Feb 2023 15:56:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2F8FB19465A4
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Feb 2023 15:56:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 19D8B492B00; Wed,  1 Feb 2023 15:56:37 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EF0A3492C3E;
 Wed,  1 Feb 2023 15:56:36 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 311FuZVW008335;
 Wed, 1 Feb 2023 09:56:35 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 311FuZO3008334;
 Wed, 1 Feb 2023 09:56:35 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed,  1 Feb 2023 09:56:29 -0600
Message-Id: <1675266989-8281-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1675266989-8281-1-git-send-email-bmarzins@redhat.com>
References: <1675266989-8281-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH v2 4/4] libmultipath: keep renames from stopping
 other multipath actions
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

If select_action() is called and a multipath device needs to be renamed,
the code currently checks if force_reload is set, and if so, does the
reload after the rename.  But if force_reload isn't set, only the rename
happens, regardless of what other actions are needed. This can happen if
multipathd starts up and a device needs both a reload and a rename.

Make multipath check for resize, reload, and switch pathgroup along with
rename, and do both if necessary.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c | 62 +++++++++++++++++-----------------------
 libmultipath/configure.h |  4 ++-
 2 files changed, 30 insertions(+), 36 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index e870e0f6..4a1c28bb 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -670,7 +670,8 @@ static bool is_udev_ready(struct multipath *cmpp)
 static void
 select_reload_action(struct multipath *mpp, const char *reason)
 {
-	mpp->action = ACT_RELOAD;
+	mpp->action = mpp->action == ACT_RENAME ? ACT_RELOAD_RENAME :
+		      ACT_RELOAD;
 	condlog(3, "%s: set ACT_RELOAD (%s)", mpp->alias, reason);
 }
 
@@ -681,6 +682,7 @@ void select_action (struct multipath *mpp, const struct _vector *curmp,
 	struct multipath * cmpp_by_name;
 	char * mpp_feat, * cmpp_feat;
 
+	mpp->action = ACT_NOTHING;
 	cmpp = find_mp_by_wwid(curmp, mpp->wwid);
 	cmpp_by_name = find_mp_by_alias(curmp, mpp->alias);
 	if (mpp->need_reload || (cmpp && cmpp->need_reload))
@@ -705,14 +707,8 @@ void select_action (struct multipath *mpp, const struct _vector *curmp,
 			mpp->alias);
 		strlcpy(mpp->alias_old, cmpp->alias, WWID_SIZE);
 		mpp->action = ACT_RENAME;
-		if (force_reload) {
-			mpp->force_udev_reload = 1;
-			mpp->action = ACT_FORCERENAME;
-		}
-		return;
-	}
-
-	if (cmpp != cmpp_by_name) {
+		/* don't return here. Check for other needed actions */
+	} else if (cmpp != cmpp_by_name) {
 		condlog(2, "%s: unable to rename %s to %s (%s is used by %s)",
 			mpp->wwid, cmpp->alias, mpp->alias,
 			mpp->alias, cmpp_by_name->wwid);
@@ -720,12 +716,13 @@ void select_action (struct multipath *mpp, const struct _vector *curmp,
 		free(mpp->alias);
 		mpp->alias = strdup(cmpp->alias);
 		mpp->action = ACT_IMPOSSIBLE;
-		return;
+		/* don't return here. Check for other needed actions */
 	}
 
 	if (cmpp->size != mpp->size) {
 		mpp->force_udev_reload = 1;
-		mpp->action = ACT_RESIZE;
+		mpp->action = mpp->action == ACT_RENAME ? ACT_RESIZE_RENAME :
+			      ACT_RESIZE;
 		condlog(3, "%s: set ACT_RESIZE (size change)",
 			mpp->alias);
 		return;
@@ -801,14 +798,14 @@ void select_action (struct multipath *mpp, const struct _vector *curmp,
 		return;
 	}
 	if (cmpp->nextpg != mpp->bestpg) {
-		mpp->action = ACT_SWITCHPG;
+		mpp->action = mpp->action == ACT_RENAME ? ACT_SWITCHPG_RENAME :
+			      ACT_SWITCHPG;
 		condlog(3, "%s: set ACT_SWITCHPG (next path group change)",
 			mpp->alias);
 		return;
 	}
-	mpp->action = ACT_NOTHING;
-	condlog(3, "%s: set ACT_NOTHING (map unchanged)",
-		mpp->alias);
+	if (mpp->action == ACT_NOTHING)
+		condlog(3, "%s: set ACT_NOTHING (map unchanged)", mpp->alias);
 	return;
 }
 
@@ -909,6 +906,17 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 		}
 	}
 
+	if (mpp->action == ACT_RENAME || mpp->action == ACT_SWITCHPG_RENAME ||
+	    mpp->action == ACT_RELOAD_RENAME ||
+	    mpp->action == ACT_RESIZE_RENAME) {
+		conf = get_multipath_config();
+		pthread_cleanup_push(put_multipath_config, conf);
+		r = dm_rename(mpp->alias_old, mpp->alias,
+			      conf->partition_delim, mpp->skip_kpartx);
+		pthread_cleanup_pop(1);
+		if (r == DOMAP_FAIL)
+			return r;
+	}
 	switch (mpp->action) {
 	case ACT_REJECT:
 	case ACT_NOTHING:
@@ -916,6 +924,7 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 		return DOMAP_EXIST;
 
 	case ACT_SWITCHPG:
+	case ACT_SWITCHPG_RENAME:
 		dm_switchgroup(mpp->alias, mpp->bestpg);
 		/*
 		 * we may have avoided reinstating paths because there where in
@@ -942,6 +951,7 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 		break;
 
 	case ACT_RELOAD:
+	case ACT_RELOAD_RENAME:
 		sysfs_set_max_sectors_kb(mpp, 1);
 		if (mpp->ghost_delay_tick > 0 && pathcount(mpp, PATH_UP))
 			mpp->ghost_delay_tick = 0;
@@ -949,6 +959,7 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 		break;
 
 	case ACT_RESIZE:
+	case ACT_RESIZE_RENAME:
 		sysfs_set_max_sectors_kb(mpp, 1);
 		if (mpp->ghost_delay_tick > 0 && pathcount(mpp, PATH_UP))
 			mpp->ghost_delay_tick = 0;
@@ -956,29 +967,10 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 		break;
 
 	case ACT_RENAME:
-		conf = get_multipath_config();
-		pthread_cleanup_push(put_multipath_config, conf);
-		r = dm_rename(mpp->alias_old, mpp->alias,
-			      conf->partition_delim, mpp->skip_kpartx);
-		pthread_cleanup_pop(1);
-		break;
-
-	case ACT_FORCERENAME:
-		conf = get_multipath_config();
-		pthread_cleanup_push(put_multipath_config, conf);
-		r = dm_rename(mpp->alias_old, mpp->alias,
-			      conf->partition_delim, mpp->skip_kpartx);
-		pthread_cleanup_pop(1);
-		if (r) {
-			sysfs_set_max_sectors_kb(mpp, 1);
-			if (mpp->ghost_delay_tick > 0 &&
-			    pathcount(mpp, PATH_UP))
-				mpp->ghost_delay_tick = 0;
-			r = dm_addmap_reload(mpp, params, 0);
-		}
 		break;
 
 	default:
+		r = DOMAP_FAIL;
 		break;
 	}
 
diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index 2bf73e65..9d935db3 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -18,9 +18,11 @@ enum actions {
 	ACT_RENAME,
 	ACT_CREATE,
 	ACT_RESIZE,
-	ACT_FORCERENAME,
+	ACT_RELOAD_RENAME,
 	ACT_DRY_RUN,
 	ACT_IMPOSSIBLE,
+	ACT_RESIZE_RENAME,
+	ACT_SWITCHPG_RENAME,
 };
 
 /*
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

