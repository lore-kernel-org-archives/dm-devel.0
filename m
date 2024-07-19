Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942C01487C1
	for <dm-devel@lists.linux.dev>; Fri, 19 Jul 2024 19:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721418069; cv=none; b=lfkTCUfe/w+CrE/fKag8qu3fPeskQAFV2MWvlzPdWTGAgBahzneo8lDNtmoSAinhJ94q+NUhTtK9lcJxZzPxVLpEJpr5g9LU1FzHv/IQ/06FMosR4v3/ZHzuPlWQNTcQaKO6k+nQxALmRBtjWKlm8x1Vo3eU1Ig8Q8znB13TIQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721418069; c=relaxed/simple;
	bh=aeDvbfde2ZPUNOH1kn1j9VQztae+d40uERKJ+glcY7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CUdj/Y/i7sCU82cORSRnA5lO1wr1uPBQFXSVYTRYmngeV5ocW7+Mb8msp17Zxg/lhF8ou0iatdHJBHOCa8EeoJZVYW+WizDU2UTK3mWRqWrGWrFHHk28fUczoq/7Ih7xhavPmpV4IoK89JtDetHNOe8WjJeHLRkZQRkB26UpCGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TwWf0+aw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TwWf0+aw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721418066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jEzdxweULTk8P9LMik93eT3iAlaKa4XpKFs+f2D9S6Y=;
	b=TwWf0+awGkluJFKLd6HCKuguRpLnGQEjBTo64wpzAyk0XJ1YZ727Og4w4ELQZw1DuzjjRe
	InRy3t6/mGc+YJM10hFxZk+Yg1ox6+dBR8S7c/MP1tBpB1PZ88AqNNIisxwiyATwvpTPFK
	OeWEbT8mD80X0/Vjk3Yqy84XhRvwgLs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-591-pVg7NqpBOi-6hXob7X5cHg-1; Fri,
 19 Jul 2024 15:41:00 -0400
X-MC-Unique: pVg7NqpBOi-6hXob7X5cHg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BEEC919560A1;
	Fri, 19 Jul 2024 19:40:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 563721955D4D;
	Fri, 19 Jul 2024 19:40:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46JJevwV2373083
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 19 Jul 2024 15:40:58 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46JJev0e2373082;
	Fri, 19 Jul 2024 15:40:57 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v3 11/20] multipathd: resync map after setup_map in ev_remove_path
Date: Fri, 19 Jul 2024 15:40:56 -0400
Message-ID: <20240719194057.2373063-3-bmarzins@redhat.com>
In-Reply-To: <20240719194057.2373063-1-bmarzins@redhat.com>
References: <20240719194057.2373063-1-bmarzins@redhat.com>
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

In ev_remove_path() it was possible to exit after calling setup_map()
without resyncing the mpp state with the kernel. This meant that the
mpp state in multipathd might not match with the kernel state at all.

It's safe to exit before calling setup_map() if either wait_for_udev is
set or need_do_map is not set. In both cases, setup_map() will later be
called, either by a uevent or by the calling function.

Once setup_map() has been called, setup_multipath() and sync_map_state()
are now always called, to make sure the mpp matches the kernel state.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index ae40f599..6a027213 100644
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

