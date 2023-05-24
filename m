Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 111E4C7EE23
	for <dm-devel@archiver.kernel.org>; Wed, 24 May 2023 23:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684970487;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Z1jzPH5w+cno/jyn/C0oHqefv8o5qwgSTqQ6zEdnkzA=;
	b=HC0mxC/hTYfglfdyTMePVPc2KMItzh2S3M3ffP6GyicO3s2Lw8IZg0HbFG6sMzWZOFq4om
	unDh5nc51pDQd9TuvbyBKvVlaawZtHhr1BCJFpxG6dmyfHoqhQM6hm+ZFASLagv8NznX7p
	vuAn2mij/5frNiWv6/HuBfxD87LvwEc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-EbUnANGBMZex6sk1I_gzrg-1; Wed, 24 May 2023 19:21:23 -0400
X-MC-Unique: EbUnANGBMZex6sk1I_gzrg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D658C802355;
	Wed, 24 May 2023 23:21:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C698820296C6;
	Wed, 24 May 2023 23:21:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 88D2B19465A8;
	Wed, 24 May 2023 23:21:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0E8EB19465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 May 2023 23:21:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F3D43492B0B; Wed, 24 May 2023 23:21:19 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 601E2492B0A;
 Wed, 24 May 2023 23:21:19 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 34ONLHBZ028721;
 Wed, 24 May 2023 18:21:17 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 34ONLGA0028720;
 Wed, 24 May 2023 18:21:16 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 24 May 2023 18:21:10 -0500
Message-Id: <1684970472-28669-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1684970472-28669-1-git-send-email-bmarzins@redhat.com>
References: <1684970472-28669-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH 3/5] multipathd: refresh all priorities if one
 has changed
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

For multipath devices with path group policies other than group_by_prio,
multipathd wasn't updating all the paths' priorities when calling
need_switch_pathgroup(), even in cases where it likely was necessary.
When a path just becomes usable again, all paths' priorities get updated
by update_prio().  But if the priority changes on a path that is already
up, the other paths' priorities only get updated if the multipath device
uses the group_by_prio path_grouping_policy, otherwise
need_switch_pathgroup() is called with refresh set to 0. But if the
priority of the checked path has changed, then likely so have the
priorities of other paths. Since the pathgroup's priority is the average
of its paths' priorities, changing the priority of just one path may not
change the average enough to reorder the pathgroups.

Instead, set refresh in need_switch_pathgroup() if the priorty has
changed to something other than PRIO_UNDEF (which usually means an error
has occured) and the priorities of the other paths haven't already been
updated by update_prio().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index bdeffe76..e7c272ad 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2575,20 +2575,27 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 
 	if (marginal_changed)
 		reload_and_sync_map(pp->mpp, vecs, 1);
-	else if (update_prio(pp, new_path_up) &&
-	    (pp->mpp->pgpolicyfn == (pgpolicyfn *)group_by_prio) &&
-	     pp->mpp->pgfailback == -FAILBACK_IMMEDIATE) {
-		condlog(2, "%s: path priorities changed. reloading",
-			pp->mpp->alias);
-		reload_and_sync_map(pp->mpp, vecs, !new_path_up);
-	} else if (need_switch_pathgroup(pp->mpp, 0)) {
-		if (pp->mpp->pgfailback > 0 &&
-		    (new_path_up || pp->mpp->failback_tick <= 0))
-			pp->mpp->failback_tick =
-				pp->mpp->pgfailback + 1;
-		else if (pp->mpp->pgfailback == -FAILBACK_IMMEDIATE ||
-			 (chkr_new_path_up && followover_should_failback(pp)))
-			switch_pathgroup(pp->mpp);
+	else {
+		int prio_changed = update_prio(pp, new_path_up);
+		bool need_refresh = (!new_path_up && prio_changed &&
+				     pp->priority != PRIO_UNDEF);
+
+		if (prio_changed &&
+		    pp->mpp->pgpolicyfn == (pgpolicyfn *)group_by_prio &&
+		    pp->mpp->pgfailback == -FAILBACK_IMMEDIATE) {
+			condlog(2, "%s: path priorities changed. reloading",
+				pp->mpp->alias);
+			reload_and_sync_map(pp->mpp, vecs, !new_path_up);
+		} else if (need_switch_pathgroup(pp->mpp, need_refresh)) {
+			if (pp->mpp->pgfailback > 0 &&
+			    (new_path_up || pp->mpp->failback_tick <= 0))
+				pp->mpp->failback_tick =
+					pp->mpp->pgfailback + 1;
+			else if (pp->mpp->pgfailback == -FAILBACK_IMMEDIATE ||
+				 (chkr_new_path_up &&
+				  followover_should_failback(pp)))
+				switch_pathgroup(pp->mpp);
+		}
 	}
 	return 1;
 }
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

