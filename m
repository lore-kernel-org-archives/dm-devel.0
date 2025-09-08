Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBF426D4FB
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 00:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376012; cv=none; b=FwirM/zrkB/9df50eFbvRpK1srQX5Hw2L/fCsBpto7R8PoCc5IbCAjmkewi5HqLOO2eP3jNKcrVsq0Tb4awB8CWVzkKDZ+dg/oagxWEhOvQC+iqMBVriPhhBJ5hOSQiOA+lZw+86ALGcCfB6EOqJl6XrPTjeNoUd3DWL7fU/sLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376012; c=relaxed/simple;
	bh=ZXtSNcW8rE2FuRjR1rgEK0lXvHiHyfnWtnCFzg3S0r8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=cRIs1Sw/MbW7AuLFWlqG1vwKGYIpx5qQqhce7s4BQAGZ7ygZJ2BWq1XUsBFi3UQfKf/y3UkT7QUalKhdu9cuzjgE4KED9Bm5Qa6jB780pJVSQefBoptzZDNddxImYVW4//U5zRIP/yLPXjFKC1X/b2ldykXbDIXgUFhodIaK38w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VUoVVOQ9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VUoVVOQ9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757376009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XOLsMHtu06Ej4EXB62YPGqeKVKTPOqXKJj2DLQ0R6Rc=;
	b=VUoVVOQ9BpFZXB0A4rIUWmoNVXrTgnBpZWlojlhAFv12hXvUdX5Z8AIbIezK/fBEpemGTT
	9fpYNWTvCK9QSChkhQoaan8jqrSLqGBZOExr0JPIAW4tTl9tuxwKXqoRTmw+RuHgXRmEj/
	2kNwlAprzrdA+Xv8qyf4bb+GGbExuRM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-111-wDZM8ytYMOecwEqJ2_w_HA-1; Mon,
 08 Sep 2025 20:00:07 -0400
X-MC-Unique: wDZM8ytYMOecwEqJ2_w_HA-1
X-Mimecast-MFC-AGG-ID: wDZM8ytYMOecwEqJ2_w_HA_1757376006
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 530E71800366;
	Tue,  9 Sep 2025 00:00:06 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E066D1800452;
	Tue,  9 Sep 2025 00:00:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 589004du751108
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 20:00:04 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 589004I6751107;
	Mon, 8 Sep 2025 20:00:04 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 07/32] multipathd: Don't call update_map_pr unnecessarily
Date: Mon,  8 Sep 2025 19:59:37 -0400
Message-ID: <20250909000002.751039-8-bmarzins@redhat.com>
In-Reply-To: <20250909000002.751039-1-bmarzins@redhat.com>
References: <20250909000002.751039-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BQGHOldD5xDWcB9SFmiiELPVTvrEJV0Y_HsrFFfm16s_1757376006
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

None of the calls to update_map_pr() outside of mpath_pr_event_handle()
add any benefit. When update_map_pr() is called without a path, it tries
to read the pr keys list on each usable path until it succeeds, and then
checks the keys to see if they include the configured key.

In all cases where update_map_pr() is called outside of
mpath_pr_event_handle(), after it is called, pr_register_active_paths()
is called if a matching key was found. pr_register_active_paths() calls
mpath_pr_event_handle() on each usable path, which calls update_map_pr()
with a path, so it only checks that path. If a matching key is found, it
registers a key on the current path. The result is that after
pr_register_active_paths() is called, update_map_pr() will be called for
each usable path, just like update_map_pr() did. So calling
update_map_pr() first doesn't change the results for multipathd, it just
adds duplicate work, so remove those calls.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index ace278f1..02cfe8d1 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -637,6 +637,8 @@ pr_register_active_paths(struct multipath *mpp)
 
 	vector_foreach_slot (mpp->pg, pgp, i) {
 		vector_foreach_slot (pgp->paths, pp, j) {
+			if (mpp->prflag == PRFLAG_UNSET)
+				return;
 			if ((pp->state == PATH_UP) || (pp->state == PATH_GHOST))
 				mpath_pr_event_handle(pp);
 		}
@@ -726,10 +728,7 @@ fail:
 
 	sync_map_state(mpp, false);
 
-	if (mpp->prflag != PRFLAG_SET)
-		update_map_pr(mpp, NULL);
-	if (mpp->prflag == PRFLAG_SET)
-		pr_register_active_paths(mpp);
+	pr_register_active_paths(mpp);
 
 	if (VECTOR_SIZE(offline_paths) != 0)
 		handle_orphaned_offline_paths(offline_paths);
@@ -1402,10 +1401,9 @@ rescan:
 	sync_map_state(mpp, false);
 
 	if (retries >= 0) {
-		if (start_waiter)
-			update_map_pr(mpp, NULL);
-		if (mpp->prflag == PRFLAG_SET && prflag != PRFLAG_SET)
-				pr_register_active_paths(mpp);
+		if ((mpp->prflag == PRFLAG_SET && prflag != PRFLAG_SET) ||
+		    start_waiter)
+			pr_register_active_paths(mpp);
 		condlog(2, "%s [%s]: path added to devmap %s",
 			pp->dev, pp->dev_t, mpp->alias);
 		return 0;
@@ -3312,9 +3310,7 @@ configure (struct vectors * vecs, enum force_reload_types reload_type)
 	vector_foreach_slot(mpvec, mpp, i){
 		if (remember_wwid(mpp->wwid) == 1)
 			trigger_paths_udev_change(mpp, true);
-		update_map_pr(mpp, NULL);
-		if (mpp->prflag == PRFLAG_SET)
-			pr_register_active_paths(mpp);
+		pr_register_active_paths(mpp);
 	}
 
 	/*
-- 
2.50.1

