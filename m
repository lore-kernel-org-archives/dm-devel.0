Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37BD2D4B40
	for <dm-devel@lists.linux.dev>; Thu,  5 Feb 2026 03:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770262903; cv=none; b=VOySvz8fpjHoz1JlOtMXgQ8nPz7JOsYFWeO66W56PzCfUSFenFBe3i7p9SItrY6ae46xxUiziTM6o9ItmXevq5XJ1xzZ/xFTlrcVoq1PxbfqAhF0YFUfcOHHRepe9aE3BwYdvFPbGMRYC7ZK242+PAbDMIrXH1voLz65804/pk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770262903; c=relaxed/simple;
	bh=toRVWAI/SWXSaWDZvhIUQCHNaURbfwxfMyR+3jiaRuY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=O38TX6Od7BOuyEyIFpsYKOeyFCTzdHFFqYbCbC+fGoSc+CrTnPSxUI2VGjiRSbtv2lLhsoiquq1qN+i7M8JrXIP7dKaxUEoQYHwS4f/tjcjYiKN/JTDP40ZHDp22oENa5le5IizoIBCvPrc3XJxXlS+sm6aTboEK6Iqa7oiNCOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PasesChz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PasesChz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770262901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1ejc3eUK0V/Wd990hX3ZZVmY9baQn4MBi7zNP/Rt3+8=;
	b=PasesChzIHytsx5YqQmF2S52W3FP73GZaYcd8r/24ZelXmjmZBCc7OiDE9hKyTR1i7A9Qa
	CFZqU/jE2oNdB0eUuLt04qI5yeBCWx68+GgXFQOiZYOX1BHKrASsnMszdXyVefLMqVyxny
	oloHnoRPXJkJQUU7tPBmSfsH+W7sqBw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-104-5Id9MCQMM2iTUZO3KWjOfw-1; Wed,
 04 Feb 2026 22:41:38 -0500
X-MC-Unique: 5Id9MCQMM2iTUZO3KWjOfw-1
X-Mimecast-MFC-AGG-ID: 5Id9MCQMM2iTUZO3KWjOfw_1770262897
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3DC8518003F6;
	Thu,  5 Feb 2026 03:41:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E40EF18003F6;
	Thu,  5 Feb 2026 03:41:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6153fZ52789208
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 4 Feb 2026 22:41:35 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6153fZIr789207;
	Wed, 4 Feb 2026 22:41:35 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH] multipathd: fix failures on booting from a multipath device
Date: Wed,  4 Feb 2026 22:41:35 -0500
Message-ID: <20260205034135.789199-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: T7M422GPHvsIFO7Y6dD7TvBmxApKAAYuG3IEZAG0CqA_1770262897
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Commit a04be557 ("multipathd: don't add removed/partial paths to new
maps") stopped including INIT_PARTIAL paths in the updated multipath
devices built during reconfigure(). During normal multipath operation
this does make sense, but isn't necessary (the uevent should still come
shortly) and the situation is very unlikely to occur. On the other hand,
when multipathd starts up after the pivot root during boot, it's very
possible that paths will not be fully initialized. Multipathd should not
drops paths in this case. The patch mostly reverts a04be557.

Paths that are marked as INIT_REMOVED shouldn't be added in
coalesce_paths(). adopt_paths() was already making sure that they
weren't before a04be557. But it does make sense to catch those paths
earlier in coalesce_paths(), so this patch retains that behavior.

Fixes: a04be557 ("multipathd: don't add removed/partial paths to new maps")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c   | 14 ++------------
 libmultipath/structs_vec.c |  3 +--
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index a713ddc4..a954ca31 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1108,22 +1108,12 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
 			continue;
 
 		/* 3. if path has disappeared */
-		if (pp1->state == PATH_REMOVED) {
+		if (pp1->state == PATH_REMOVED || pp1->initialized == INIT_REMOVED) {
 			orphan_path(pp1, "path removed");
 			continue;
 		}
 
-		/*
-		 * 4. The path wasn't found in path_discovery. It only exists
-		 *    in an old map.
-		 */
-		if (pp1->initialized == INIT_PARTIAL ||
-		    pp1->initialized == INIT_REMOVED) {
-			orphan_path(pp1, "path not found");
-			continue;
-		}
-
-		/* 5. path is out of scope */
+		/* 4. path is out of scope */
 		if (refwwid && strncmp(pp1->wwid, refwwid, WWID_SIZE - 1))
 			continue;
 
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 3e63e9c3..9384de01 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -315,8 +315,7 @@ int adopt_paths(vector pathvec, struct multipath *mpp,
 					pp->dev, mpp->alias);
 				continue;
 			}
-			if (pp->initialized == INIT_REMOVED ||
-			    pp->initialized == INIT_PARTIAL)
+			if (pp->initialized == INIT_REMOVED)
 				continue;
 			if (mpp->queue_mode == QUEUE_MODE_RQ &&
 			    pp->bus == SYSFS_BUS_NVME &&
-- 
2.50.1

