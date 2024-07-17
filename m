Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D184F183093
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 18:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721239877; cv=none; b=P6bXpYhl5djjDXOR/2mfS6M1jMcdh+EY4/b3emXuAvj6TYrm4mbmFbob9m6SEQ9yuuirzZD4SB4ip5shv/CUZ9Vr3oi5eQ8YjF1Q7Y97TzVPXQuXcfdT+YsD8EeVwl8ZTBdDIwi44ee2DbRTqEDAAwtBUL+JsxLK/yUKyh1lJ3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721239877; c=relaxed/simple;
	bh=+J8pYTLo7B8o4eM3NHbJNJDswb999Nv2Y/2v1g5F02Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HBNfQaA7TzgjpXfiSl64YtC/aS5QTdnVbitw/Z0mQXwzTcCc5EjjTp7T5gMqqFpkarOvNEqK3HsvEdlxYHexCzwta/s0yCr1r5pGzQ55MygNFXzsLqWyllMje7S/gB7vkLNi0XuAES/QUoMn1Z4lJnhs53xr5bN+NWn2AI+3I0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iXRbN39L; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iXRbN39L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721239874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z/2qsTjbgfeocsPNYcYsq/i+8uELS4LREOQ6bhk4UV8=;
	b=iXRbN39LTqR52Usxa4JcaqWw8ALLHIKWOVVlMTaBJC9UTOd22KvXO54a6hcLVGdz1w2Ta1
	AkqX5UmDbzHydR3lcLApO0y5yljZhiH+XXsFHCX6DaRm3MScCg84zDHJAXwNziQFWcv5M7
	VknfKS0YBPvLgQghzQfTUO/kqrvGvrA=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-357-xzT9bAkHNvujX-a9asxS6Q-1; Wed,
 17 Jul 2024 14:11:12 -0400
X-MC-Unique: xzT9bAkHNvujX-a9asxS6Q-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D2B5B1955D4A;
	Wed, 17 Jul 2024 18:11:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8C5231955D47;
	Wed, 17 Jul 2024 18:11:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46HIBAHp2173628
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 17 Jul 2024 14:11:10 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46HIBABf2173627;
	Wed, 17 Jul 2024 14:11:10 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 18/20] multipathd: factor out actual path checking loop from checkerloop
Date: Wed, 17 Jul 2024 14:11:04 -0400
Message-ID: <20240717181106.2173527-19-bmarzins@redhat.com>
In-Reply-To: <20240717181106.2173527-1-bmarzins@redhat.com>
References: <20240717181106.2173527-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Move the code that actually loops through the paths and checks them into
a separate function, to stop it from being so heavily indented. This
will be more imporant when a future patch makes paths checked by mpp.

No functional changes.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 65 +++++++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 30 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 87ddb101..161c6962 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2783,6 +2783,38 @@ enum checker_state {
 	CHECKER_FINISHED,
 };
 
+static enum checker_state
+check_paths(struct vectors *vecs, unsigned int ticks, int *num_paths_p)
+{
+	unsigned int paths_checked = 0;
+	struct timespec diff_time, start_time, end_time;
+	struct path *pp;
+	int i, rc;
+
+	get_monotonic_time(&start_time);
+	vector_foreach_slot(vecs->pathvec, pp, i) {
+		if (pp->is_checked)
+			continue;
+		pp->is_checked = true;
+		if (pp->mpp)
+			rc = check_path(vecs, pp, ticks, start_time.tv_sec);
+		else
+			rc = handle_uninitialized_path(vecs, pp, ticks);
+		if (rc == CHECK_PATH_REMOVED)
+			i--;
+		else if (rc == CHECK_PATH_CHECKED)
+			(*num_paths_p)++;
+		if (++paths_checked % 128 == 0 &&
+		    (lock_has_waiters(&vecs->lock) || waiting_clients())) {
+			get_monotonic_time(&end_time);
+			timespecsub(&end_time, &start_time, &diff_time);
+			if (diff_time.tv_sec > 0)
+				return CHECKER_RUNNING;
+		}
+	}
+	return CHECKER_FINISHED;
+}
+
 static void *
 checkerloop (void *ap)
 {
@@ -2814,7 +2846,7 @@ checkerloop (void *ap)
 
 	while (1) {
 		struct timespec diff_time, start_time, end_time;
-		int num_paths = 0, strict_timing, rc = 0;
+		int num_paths = 0, strict_timing;
 		unsigned int ticks = 0;
 		enum checker_state checker_state = CHECKER_STARTING;
 
@@ -2833,16 +2865,14 @@ checkerloop (void *ap)
 			sd_notify(0, "WATCHDOG=1");
 #endif
 		while (checker_state != CHECKER_FINISHED) {
-			unsigned int paths_checked = 0, i;
-			struct timespec chk_start_time;
 			struct multipath *mpp;
+			int i;
 
 			pthread_cleanup_push(cleanup_lock, &vecs->lock);
 			lock(&vecs->lock);
 			pthread_testcancel();
 			vector_foreach_slot(vecs->mpvec, mpp, i)
 				mpp->is_checked = false;
-			get_monotonic_time(&chk_start_time);
 			if (checker_state == CHECKER_STARTING) {
 				vector_foreach_slot(vecs->mpvec, mpp, i)
 					sync_mpp(vecs, mpp, ticks);
@@ -2850,32 +2880,7 @@ checkerloop (void *ap)
 					pp->is_checked = false;
 				checker_state = CHECKER_RUNNING;
 			}
-			vector_foreach_slot(vecs->pathvec, pp, i) {
-				if (pp->is_checked)
-					continue;
-				pp->is_checked = true;
-				if (pp->mpp)
-					rc = check_path(vecs, pp, ticks,
-							chk_start_time.tv_sec);
-				else
-					rc = handle_uninitialized_path(vecs, pp,
-								       ticks);
-				if (rc == CHECK_PATH_REMOVED)
-					i--;
-				else if (rc == CHECK_PATH_CHECKED)
-					num_paths++;
-				if (++paths_checked % 128 == 0 &&
-				    (lock_has_waiters(&vecs->lock) ||
-				     waiting_clients())) {
-					get_monotonic_time(&end_time);
-					timespecsub(&end_time, &chk_start_time,
-						    &diff_time);
-					if (diff_time.tv_sec > 0)
-						goto unlock;
-				}
-			}
-			checker_state = CHECKER_FINISHED;
-unlock:
+			checker_state = check_paths(vecs, ticks, &num_paths);
 			lock_cleanup_pop(vecs->lock);
 			if (checker_state != CHECKER_FINISHED) {
 				/* Yield to waiters */
-- 
2.45.0

