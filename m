Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CD929406
	for <dm-devel@lists.linux.dev>; Sat, 13 Jul 2024 06:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720850719; cv=none; b=bEw40sxNq+HBsZMgQsofqmJ4d4L4cQdys1ZNcGFg+C3LgnA/RLDi/eWYdIZ6xXevIQwynV9IB/jXD+a/vNgtV5TBSGZD7AUMJToq5TSvmV3gGe4dfnx0ukL/0Jxv7Hk5W5jHtim+JYUI7/abqRFgcY91NKLYi1VdRr76qYgsVrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720850719; c=relaxed/simple;
	bh=42ev6G5X9EDDz17ZaVYZMZWDLHalnefha1KxgxyivQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=paqA0nKR7DHdmR9eshnDzPBL9jRVc5ScDcYCn9Xd7997PWXv+0ywlZHHQ4WJMkQSKWVOlgV0gp8ZMb3pfj5AtSxQfmULLdKajoWqZT6s40gTcXHscOE4u0cO488v2NY9zRxmmpKxjMpxwl9SIBfft+lv/5wu6kUdoiwrd3djffw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fzrx+gOM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fzrx+gOM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720850716;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AI8ZXgC0fqweJEmaQuLatbI2yhcnKql8selzn32kDCs=;
	b=Fzrx+gOMH8n93i7jjqnZ8SHOmfPjt0BKOC2CFxEaeeiJ5ABsVbicqTCIvzKtK/N8+pP+xi
	9KlbgAldZ5AlgJpo8jJhpXZjShdHabR4oM8qDuL2BVgP9kgx0XW0+tF8KSJMes6XE2WB8J
	M76QRrQBcU+Cc13sev6ai7Ufpt6uQ4k=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-500-EC_iDAeEP5unYGycop9AlQ-1; Sat,
 13 Jul 2024 02:05:12 -0400
X-MC-Unique: EC_iDAeEP5unYGycop9AlQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AA3F71955F42;
	Sat, 13 Jul 2024 06:05:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 420821956066;
	Sat, 13 Jul 2024 06:05:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46D659Si2015558
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 13 Jul 2024 02:05:10 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46D659Am2015557;
	Sat, 13 Jul 2024 02:05:09 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 16/22] multipathd: correctly handle paths removed for a wwid change
Date: Sat, 13 Jul 2024 02:05:00 -0400
Message-ID: <20240713060506.2015463-17-bmarzins@redhat.com>
In-Reply-To: <20240713060506.2015463-1-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

If check_path() exitted because the path's wwid changed and it was
removed, checkerloop() wasn't decrementing the pathvec loop count.
This caused the next path to be skipped by the checker loop.

To solve this, make check_path() return -1 when a path is removed,
make handle_uninitialized_path() also remove the path if it was
blacklisted, and make checkerloop() just decrement the loop count
when a path returns -1.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 33 ++++++++++++++++++++-------------
 multipathd/main.h |  2 +-
 2 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 0f763e29..e32af693 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -974,20 +974,24 @@ rescan_path(struct udev_device *ud)
 	}
 }
 
-void
+/* Returns true if the path was removed */
+bool
 handle_path_wwid_change(struct path *pp, struct vectors *vecs)
 {
 	struct udev_device *udd;
 	static const char add[] = "add";
 	ssize_t ret;
 	char dev[FILE_NAME_SIZE];
+	bool removed = false;
 
 	if (!pp || !pp->udev)
-		return;
+		return removed;
 
 	strlcpy(dev, pp->dev, sizeof(dev));
 	udd = udev_device_ref(pp->udev);
-	if (!(ev_remove_path(pp, vecs, 1) & REMOVE_PATH_SUCCESS) && pp->mpp) {
+	if (ev_remove_path(pp, vecs, 1) & REMOVE_PATH_SUCCESS) {
+		removed = true;
+	} else if (pp->mpp) {
 		pp->dmstate = PSTATE_FAILED;
 		dm_fail_path(pp->mpp->alias, pp->dev_t);
 	}
@@ -997,6 +1001,7 @@ handle_path_wwid_change(struct path *pp, struct vectors *vecs)
 	if (ret != sizeof(add) - 1)
 		log_sysfs_attr_set_value(1, ret,
 					 "%s: failed to trigger add event", dev);
+	return removed;
 }
 
 bool
@@ -2377,7 +2382,8 @@ check_mpp(struct vectors * vecs, struct multipath *mpp, unsigned int ticks)
 }
 
 /*
- * Returns '1' if the path has been checked and '0' otherwise
+ * Returns '1' if the path has been checked, -1 if the path was removed,
+ * and '0' otherwise
  */
 static int
 check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
@@ -2434,8 +2440,7 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 	     pp->dmstate == PSTATE_FAILED) &&
 	    check_path_wwid_change(pp)) {
 		condlog(0, "%s: path wwid change detected. Removing", pp->dev);
-		handle_path_wwid_change(pp, vecs);
-		return 0;
+		return handle_path_wwid_change(pp, vecs)? -1 : 0;
 	}
 	if (!pp->mpp->is_checked) {
 		do_check_mpp(vecs, pp->mpp);
@@ -2635,7 +2640,7 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 }
 
 /*
- * Returns -1 if the path was blacklisted, and 0 otherwise
+ * Returns -1 if the path was removed, and 0 otherwise
  */
 static int
 handle_uninitialized_path(struct vectors * vecs, struct path * pp,
@@ -2706,6 +2711,12 @@ handle_uninitialized_path(struct vectors * vecs, struct path * pp,
 			ev_add_path(pp, vecs, 1);
 			pp->tick = 1;
 		} else if (ret == PATHINFO_SKIPPED) {
+			int i;
+
+			condlog(1, "%s: path blacklisted. removing", pp->dev);
+			if ((i = find_slot(vecs->pathvec, (void *)pp)) != -1)
+				vector_del_slot(vecs->pathvec, i);
+			free_path(pp);
 			return -1;
 		}
 	}
@@ -2794,13 +2805,9 @@ checkerloop (void *ap)
 				else
 					rc = handle_uninitialized_path(vecs, pp,
 								       ticks);
-				if (rc < 0) {
-					condlog(1, "%s: check_path() failed, removing",
-						pp->dev);
-					vector_del_slot(vecs->pathvec, i);
-					free_path(pp);
+				if (rc < 0)
 					i--;
-				} else
+				else
 					num_paths += rc;
 				if (++paths_checked % 128 == 0 &&
 				    (lock_has_waiters(&vecs->lock) ||
diff --git a/multipathd/main.h b/multipathd/main.h
index 4fcd6402..7aa93ca3 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -47,7 +47,7 @@ int setup_multipath(struct vectors * vecs, struct multipath * mpp);
 int update_multipath(struct vectors *vecs, char *mapname);
 int reload_and_sync_map(struct multipath *mpp, struct vectors *vecs);
 
-void handle_path_wwid_change(struct path *pp, struct vectors *vecs);
+bool handle_path_wwid_change(struct path *pp, struct vectors *vecs);
 bool check_path_wwid_change(struct path *pp);
 int finish_path_init(struct path *pp, struct vectors * vecs);
 int resize_map(struct multipath *mpp, unsigned long long size,
-- 
2.45.0

