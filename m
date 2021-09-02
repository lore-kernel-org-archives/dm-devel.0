Return-Path: <SRS0=Tx5l=NY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D72DC433F5
	for <dm-devel@archiver.kernel.org>; Thu,  2 Sep 2021 22:04:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 41CEB60F12
	for <dm-devel@archiver.kernel.org>; Thu,  2 Sep 2021 22:04:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 41CEB60F12
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1630620265;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FwV47wkzHoi7sWw0vBGdXgpU7dQX/zl2JmXWThXd7QA=;
	b=X1h/H71xWo/dBUDanp3+dZ6bD/V5bOXDI7RnIo2jM7RXXGRlMAA5mrVQv+tkUcte6H/UPC
	qNZuxmNWHaR1P4k5cf2giSa6QH/4hxvXE49IORgMetaExLuTuahTNCU26O581F6cKBfCbS
	nqqjN5ddvx4hXrWtxFZ6ySOI/lsoVlE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-_DuwaoOnNKKdGxqXfpg10Q-1; Thu, 02 Sep 2021 18:04:23 -0400
X-MC-Unique: _DuwaoOnNKKdGxqXfpg10Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DFDE280292A;
	Thu,  2 Sep 2021 22:04:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C19495D9C6;
	Thu,  2 Sep 2021 22:04:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 75BEF44A5A;
	Thu,  2 Sep 2021 22:04:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 182Lw1Ot013380 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 2 Sep 2021 17:58:01 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7E610102AE41; Thu,  2 Sep 2021 21:58:01 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 183AA10074F1;
	Thu,  2 Sep 2021 21:57:58 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 182Lvu0T012307; 
	Thu, 2 Sep 2021 16:57:56 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 182Lvull012306;
	Thu, 2 Sep 2021 16:57:56 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu,  2 Sep 2021 16:57:47 -0500
Message-Id: <1630619869-12251-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1630619869-12251-1-git-send-email-bmarzins@redhat.com>
References: <1630619869-12251-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 4/6] libmultipath: remove unneeded code in
	coalesce_paths
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The code at the end of coalesce_paths() removes a multipath device that
was just created/reloaded, if none of its path devices have pp->dev set.
This code is very old, and no longer has any actual effect. Multipath
devices no longer get placed in pathvec without having pp->dev set. Even
if they could, there's no point in creating/reloading the device and
then immediately removing it.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c | 46 ----------------------------------------
 1 file changed, 46 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 2f417914..3f241c5c 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1060,28 +1060,6 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 	return DOMAP_FAIL;
 }
 
-static int
-deadmap (struct multipath * mpp)
-{
-	int i, j;
-	struct pathgroup * pgp;
-	struct path * pp;
-
-	if (!mpp->pg)
-		return 1;
-
-	vector_foreach_slot (mpp->pg, pgp, i) {
-		if (!pgp->paths)
-			continue;
-
-		vector_foreach_slot (pgp->paths, pp, j)
-			if (strlen(pp->dev))
-				return 0; /* alive */
-	}
-
-	return 1; /* dead */
-}
-
 extern int
 check_daemon(void)
 {
@@ -1313,30 +1291,6 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
 			remove_map(mpp, vecs->pathvec, vecs->mpvec,
 				   KEEP_VEC);
 	}
-	/*
-	 * Flush maps with only dead paths (ie not in sysfs)
-	 * Keep maps with only failed paths
-	 */
-	if (mpvec) {
-		vector_foreach_slot (newmp, mpp, i) {
-			char alias[WWID_SIZE];
-
-			if (!deadmap(mpp))
-				continue;
-
-			strlcpy(alias, mpp->alias, WWID_SIZE);
-
-			vector_del_slot(newmp, i);
-			i--;
-			remove_map(mpp, vecs->pathvec, vecs->mpvec, KEEP_VEC);
-
-			if (dm_flush_map(alias))
-				condlog(2, "%s: remove failed (dead)",
-					alias);
-			else
-				condlog(2, "%s: remove (dead)", alias);
-		}
-	}
 	ret = CP_OK;
 out:
 	free(size_mismatch_seen);
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

