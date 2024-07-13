Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3931CD37
	for <dm-devel@lists.linux.dev>; Sat, 13 Jul 2024 06:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720850717; cv=none; b=OnB3+omeUtOIuxHU25/MMq5WjXd5XD6uDK+BA0UgncwJhri3SwB5vpnAcqdQz+RY2J/xE6U/8rPLchaO8TT/IY7jeDa5IilS7y1hy5MDje8Zgj1oq8YqF266+mUshQUeFziW6xFX31KDDHH88qHHoPEgOs71Cc6o7vQ2kZYDgv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720850717; c=relaxed/simple;
	bh=DdYLj+660JXH9mtO0tAMVe91VJrUvJWrdOeX7malbMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r9nAZ3UXb7aCqvY0koO6oJ0h8/LnrimheRkpViAdZ9iwTykzoK7rSQnThnfv2+6MD8Y321LCNp7X5yKTQXltrkDO3VpP3v8EyGxl9i05Z36jEgebSxrgHSjgPrWEd4i5LydVHtIkDFk4dIPHiECU+EfmWjj4NP5UPGh5GsnibTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B3iPZG4p; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B3iPZG4p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720850714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+21VEqFsIMxTSc2nz8lS0bPGLiqoR6Dnw/+Q6mrmFTQ=;
	b=B3iPZG4p1TIP+OTqCT7X7BmdUxJHnvWtq4A+kisHWYBl+u67l/Vt3b+rdLLRaDj9+yeFmX
	A1WnviBfk0s0V2/ECtNxR+XCD5RxrLNGczSwNC0GMDQEMMezqzVT8fdahT0uwJ/9KD48cU
	L/fqK4/9Y98a9XOJ44uqGrdPFq1FQTQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-452-chHrUItENRuUXWbysS6TuQ-1; Sat,
 13 Jul 2024 02:05:12 -0400
X-MC-Unique: chHrUItENRuUXWbysS6TuQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1917D195609F;
	Sat, 13 Jul 2024 06:05:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C2DD23000181;
	Sat, 13 Jul 2024 06:05:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46D659im2015546
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 13 Jul 2024 02:05:09 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46D659md2015545;
	Sat, 13 Jul 2024 02:05:09 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 13/22] multipathd: resync map after setup_map in ev_remove_path
Date: Sat, 13 Jul 2024 02:04:57 -0400
Message-ID: <20240713060506.2015463-14-bmarzins@redhat.com>
In-Reply-To: <20240713060506.2015463-1-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

In ev_remove_path() it was possible to exit after calling setup_map()
without resyncing the mpp state with the kernel. This meant that the
mpp state in multipathd might not match with the kernel state at all.

It's safe to exit before calling setup_map() if either wait_for_udev
or need_do_map is set. In both cases, setup_map() will later be called,
either by a uevent or by the calling function.

Once setup_map() has been called, setup_multipath() and sync_map_state()
are now always called, to make sure the mpp matches the kernel state.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 179fec24..3c84c2a0 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1395,6 +1395,8 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 	 * avoid referring to the map of an orphaned path
 	 */
 	if ((mpp = pp->mpp)) {
+		char devt[BLK_DEV_SIZE];
+
 		/*
 		 * Mark the path as removed. In case of success, we
 		 * will delete it for good. Otherwise, it will be deleted
@@ -1428,12 +1430,6 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 		    flush_map_nopaths(mpp, vecs))
 			goto out;
 
-		if (setup_map(mpp, &params, vecs)) {
-			condlog(0, "%s: failed to setup map for"
-				" removal of path %s", mpp->alias, pp->dev);
-			goto fail;
-		}
-
 		if (mpp->wait_for_udev) {
 			mpp->wait_for_udev = 2;
 			retval = REMOVE_PATH_DELAY;
@@ -1444,33 +1440,35 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 			retval = REMOVE_PATH_DELAY;
 			goto out;
 		}
+
+		if (setup_map(mpp, &params, vecs)) {
+			condlog(0, "%s: failed to setup map for"
+				" removal of path %s", mpp->alias, pp->dev);
+			goto fail;
+		}
 		/*
 		 * reload the map
 		 */
 		mpp->action = ACT_RELOAD;
+		strlcpy(devt, pp->dev_t, sizeof(devt));
 		if (domap(mpp, params, 1) == DOMAP_FAIL) {
 			condlog(0, "%s: failed in domap for "
 				"removal of path %s",
 				mpp->alias, pp->dev);
 			retval = REMOVE_PATH_FAILURE;
-		} else {
-			/*
-			 * update our state from kernel
-			 */
-			char devt[BLK_DEV_SIZE];
-
-			strlcpy(devt, pp->dev_t, sizeof(devt));
-
-			/* setup_multipath will free the path
-			 * regardless of whether it succeeds or
-			 * fails */
-			if (setup_multipath(vecs, mpp))
-				return REMOVE_PATH_MAP_ERROR;
-			sync_map_state(mpp);
+		}
+		/*
+		 * update mpp state from kernel even if domap failed.
+		 * If the path was removed from the mpp, setup_multipath will
+		 * free the path regardless of whether it succeeds or fails
+		 */
+		if (setup_multipath(vecs, mpp))
+			return REMOVE_PATH_MAP_ERROR;
+		sync_map_state(mpp);
 
+		if (retval == REMOVE_PATH_SUCCESS)
 			condlog(2, "%s: path removed from map %s",
 				devt, mpp->alias);
-		}
 	} else {
 		/* mpp == NULL */
 		if ((i = find_slot(vecs->pathvec, (void *)pp)) != -1)
-- 
2.45.0

