Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3293D17FAAE
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 18:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721239875; cv=none; b=tH4LFdAfbNpRa+7pNhBWGNb7kQs8WAFG6ibLKPxU8su4Jb3ecsc3ELzFNzM5IUGWcBJL6Gw+LFY5AM5I2BNKSnq6JFR3bg6hOgmX0BsuFPrkL3QYWP8Hk3W9bX8qezeCAIkU9i6UzmP5jdfvfoLsjmEk61N32a6iJtkjI8oKGTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721239875; c=relaxed/simple;
	bh=k/MbXYdm9FqwQ+L6aVv0ZJ6SZI7lGvviOGjzDW2Ghjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bpAsBr4ksLbyxZcsHzzr3WoSIkSzbs0V0xNaJrmfTr3bybzdMP2LmiH6auBjjP6718SMWT5MlEqdHaoY9O/ZfFjwlSMU31XZeRuSrxrUc8xSa5VMyMid5Qo+mBU3l0DDF6574Ho1ICrSleicPCZGYaDOJwSt9MIZywl/YiiikbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G53LEBhG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G53LEBhG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721239873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YyifouYLDe74T7Vq8RIILmsU11BFW1JelfD8jG79xpg=;
	b=G53LEBhGzyPyHPwvVpyLJ0ONjmAH3ksv9kTXLCron55lnwiUTLmyzFI7nwrzwpKM2wcA8R
	ls6HqfFronmMk9rL95mNux3NQNVPwBOPrxHCj57uff1OK6c47JO7/A7+fr5n3XFD9GRZlF
	DjzM47lOdbMh09M6dA5P4IfcItJOYZM=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-678-l3clpyzkNXSKjDomCcwHBA-1; Wed,
 17 Jul 2024 14:11:11 -0400
X-MC-Unique: l3clpyzkNXSKjDomCcwHBA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A061519560B3;
	Wed, 17 Jul 2024 18:11:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5BC741955F40;
	Wed, 17 Jul 2024 18:11:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46HIB8mv2173600
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 17 Jul 2024 14:11:09 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46HIB8812173599;
	Wed, 17 Jul 2024 14:11:08 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 11/20] multipathd: resync map after setup_map in ev_remove_path
Date: Wed, 17 Jul 2024 14:10:57 -0400
Message-ID: <20240717181106.2173527-12-bmarzins@redhat.com>
In-Reply-To: <20240717181106.2173527-1-bmarzins@redhat.com>
References: <20240717181106.2173527-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
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
index d7c87039..aa3c7eb6 100644
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
@@ -1444,6 +1440,12 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
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
@@ -1453,24 +1455,20 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
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
+		strlcpy(devt, pp->dev_t, sizeof(devt));
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

