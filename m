Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB0AA2D
	for <dm-devel@lists.linux.dev>; Thu,  9 Jan 2025 00:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736381222; cv=none; b=V+UaIxGPueM93x9Iev+tPEFG8tPK/rxGZCylYa/WtFBeFOK02TyJY/oGUb99LJhAY/g0qDMdKfqPuUO76G2MZeOflKvaEXprTerzZ82EKtgrEBA+uJDo+//FTvH6a7mqyQvFxTzLTR0QDnMc3cdHIXL/FYGsoDsvOdDcs41l6oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736381222; c=relaxed/simple;
	bh=YpQRq99fQv7uBzjI6QV/QB7l8tIRGuyMOxNNzv+nF7k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=ZgXa+hn6qPJQ6dOeVf+eDp1A9v3zSdgfeyXD9tXOFpTVRfWN7kL6kzBsN8Ksj1EJMqNe1NfRB8UukXvs7kkeKXwiwewGbvG3QCJ2D/yfkf8iQoHouH2r9IIsjVkv0UnjrKqCqakrQW5wGrpZgrSdfy573Bmw3ouh1J90uutuasQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UxdAMnZ/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UxdAMnZ/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736381219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=smld5dlUMhWy8aQbJHSWZhnKoAf7S20J2bhEWrM3n/A=;
	b=UxdAMnZ/8OK3oZlsqWEY3zeMb0FopBWxpvMAXMiMZpnaN99LOty3G+OBf2ANiFuwteOZAB
	tethiAuFeKKCjL5VZOrdVrWDtrvZcvrVA1MAJcai2w3swjY0NA6F4ZFA1qls80eMXCa0ff
	v1kpdw+L54xMgbeioKIYS7mTSSAX8nQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-481-PMtsww_6O4Cd3z3vsJ2sow-1; Wed,
 08 Jan 2025 19:06:56 -0500
X-MC-Unique: PMtsww_6O4Cd3z3vsJ2sow-1
X-Mimecast-MFC-AGG-ID: PMtsww_6O4Cd3z3vsJ2sow
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 42A56195609E;
	Thu,  9 Jan 2025 00:06:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E98E4195608D;
	Thu,  9 Jan 2025 00:06:54 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 50906rgX2469660
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 8 Jan 2025 19:06:53 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 50906rru2469659;
	Wed, 8 Jan 2025 19:06:53 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH] libmultipath/foreign: fix memory leak in nvme foreign handler
Date: Wed,  8 Jan 2025 19:06:53 -0500
Message-ID: <20250109000653.2469651-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: g3j6XxT1KpTEXEZaja28fDVtHi_wejUBc1s52fS8MFE_1736381215
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

_find_controllers() needs to free the udev device if it doesn't get
added to a path. Otherwise it can leak memory whenever check_foreign()
is called, causing multipathd's memory usage to continually grow.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/foreign/nvme.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
index 0b7f4eab..cde660ce 100644
--- a/libmultipath/foreign/nvme.c
+++ b/libmultipath/foreign/nvme.c
@@ -675,7 +675,8 @@ static void _find_controllers(struct context *ctx, struct nvme_map *map)
 	pthread_cleanup_push_cast(free_scandir_result, &sr);
 	for (i = 0; i < r; i++) {
 		char *fn = di[i]->d_name;
-		struct udev_device *ctrl, *udev;
+		struct udev_device *ctrl;
+		struct udev_device *udev __attribute__((cleanup(cleanup_udev_device))) = NULL;
 
 		if (safe_snprintf(pathbuf + n, sizeof(pathbuf) - n, "/%s", fn))
 			continue;
@@ -719,11 +720,11 @@ static void _find_controllers(struct context *ctx, struct nvme_map *map)
 			continue;
 
 		path->gen.ops = &nvme_path_ops;
-		path->udev = udev;
+		path->udev = steal_ptr(udev);
 		path->seen = true;
 		path->map = map;
 		path->ctl = udev_device_get_parent_with_subsystem_devtype
-			(udev, "nvme", NULL);
+			(path->udev, "nvme", NULL);
 		if (path->ctl == NULL) {
 			condlog(1, "%s: %s: failed to get controller for %s",
 				__func__, THIS, fn);
@@ -744,7 +745,7 @@ static void _find_controllers(struct context *ctx, struct nvme_map *map)
 		}
 		vector_set_slot(&map->pgvec, &path->pg);
 		condlog(3, "%s: %s: new path %s added to %s",
-			__func__, THIS, udev_device_get_sysname(udev),
+			__func__, THIS, udev_device_get_sysname(path->udev),
 			udev_device_get_sysname(map->udev));
 	}
 	pthread_cleanup_pop(1);
-- 
2.46.2

