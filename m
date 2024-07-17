Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA20E79D2
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 18:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721239875; cv=none; b=Pd+rrqaK+AGQT16F18nbDrZOlcxsJf2QdIzjHuksXX8NTVcDbgkF+xR4o0zsI66LtjyGHyFE4e9pBHP+kJbWVpJpwREPHemn7Y8yOJq72s8C0aj84ypmGkvdhg0z//39VOyPod/99nHVgIzAPjV6xC4CEGjumvKIeT8gLNYn+SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721239875; c=relaxed/simple;
	bh=bYLAVeLlrmFbhtSUm6wy9BdZ5PIMTucdwy8m1uLPoZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ims01lQ13lvgECj+4kyTujySKHyPJQYWAY0xhYh78HqR5QKqs7Nj8Ttx5fsqQE6ZsNONfxfI8QhqjbB9zOKM/8/JV2JYyuC6QXkcKFFxji+DA71a5bPEx6bwU+hHRbFtcidOCp/eCIVkH0Lg2JG8xMxmTavUq/u5k2H8wJfIn8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bziEUOI/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bziEUOI/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721239872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ImgkSAUuZQrXYePA8TxJoVzfu24R3InlnmY9DHsssoM=;
	b=bziEUOI/OUFs38fP0NEXtrgILQrMFqnOndnwI0iwvbIA7kRPKDCKxW93Uut2D68a1gSYfC
	vTdZcLtDVm+XQat2OrSonUp5/tL9zsLnKeNqWWXOQQtvZPYGXHrMwPU29cBIcAu3+FSxYJ
	Ns57BLFir+NPBdHM68kAu0PMSxWKM/o=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-167-fST2gO-NMSy71JoHVtperA-1; Wed,
 17 Jul 2024 14:11:11 -0400
X-MC-Unique: fST2gO-NMSy71JoHVtperA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3C6151955D50;
	Wed, 17 Jul 2024 18:11:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A6FFD1955D47;
	Wed, 17 Jul 2024 18:11:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46HIB8WQ2173584
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 17 Jul 2024 14:11:08 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46HIB8Tk2173583;
	Wed, 17 Jul 2024 14:11:08 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 07/20] multipathd: set pp->tick = max_checkint in handle_uninitialized_path
Date: Wed, 17 Jul 2024 14:10:53 -0400
Message-ID: <20240717181106.2173527-8-bmarzins@redhat.com>
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

When handle_uninitialized_path() checks a path, it will either:
1. trigger a new uevent to initalize the path, in which case it won't
   check the path again until that uevent is processed and updates
   pp->tick
2. blacklist the path, in which case the path gets removed
3. intialize the path correctly, in which case it sets pp->tick = 1
4. fail to initialize the path, in which case it was supposed to set
   pp->tick to max_checkint, but instead it set pp->checkint to
   max_checkint, which never worked correctly.

By setting pp->tick to max_checkint at the start,
handle_uninitialized_path() will continue to work as it previously did,
except in case 4, where in now works correctly. There's no point in
messing with pp->checkint for paths that haven't been initialized yet.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index f9451302..7c4d3bf6 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2625,7 +2625,6 @@ handle_uninitialized_path(struct vectors * vecs, struct path * pp,
 {
 	int newstate;
 	int retrigger_tries;
-	unsigned int checkint, max_checkint;
 	struct config *conf;
 	int ret;
 
@@ -2640,8 +2639,7 @@ handle_uninitialized_path(struct vectors * vecs, struct path * pp,
 
 	conf = get_multipath_config();
 	retrigger_tries = conf->retrigger_tries;
-	checkint = conf->checkint;
-	max_checkint = conf->max_checkint;
+	pp->tick = conf->max_checkint;
 	put_multipath_config(conf);
 
 	if (pp->initialized == INIT_MISSING_UDEV) {
@@ -2675,12 +2673,6 @@ handle_uninitialized_path(struct vectors * vecs, struct path * pp,
 		}
 	}
 
-	/*
-	 * provision a next check soonest,
-	 * in case we exit abnormally from here
-	 */
-	pp->tick = checkint;
-
 	newstate = check_path_state(pp);
 
 	if (!strlen(pp->wwid) &&
@@ -2695,14 +2687,8 @@ handle_uninitialized_path(struct vectors * vecs, struct path * pp,
 		if (pp->initialized == INIT_OK) {
 			ev_add_path(pp, vecs, 1);
 			pp->tick = 1;
-		} else {
-			if (ret == PATHINFO_SKIPPED)
-				return -1;
-			/*
-			 * We failed multiple times to initialize this
-			 * path properly. Don't re-check too often.
-			 */
-			pp->checkint = max_checkint;
+		} else if (ret == PATHINFO_SKIPPED) {
+			return -1;
 		}
 	}
 	return 0;
-- 
2.45.0

