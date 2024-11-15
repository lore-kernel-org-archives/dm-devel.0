Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507961991DD
	for <dm-devel@lists.linux.dev>; Fri, 15 Nov 2024 23:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731712987; cv=none; b=mEgaGHx18x7kJciOTl+J5ww6e+1T7uFFMRAnA7BXviWboNqIgwX5rRaE+YuXIatjZKT2t4W5/bc1po3u5IrGQ8Uf3JZ3W7nJ6vfy/qkdyB7EYSmxIcBCxy4w/BAH7jHiQ0wcVltarWrtUxuFkCcDL7oL5tTBrAxX5faVvojv88k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731712987; c=relaxed/simple;
	bh=2wZ5mjxv3kRL+QvMvIoRvxY0+LfEaXpNmbawtQrDKbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D7ApsC6t3FKSzUIUuSjVkq5OGNd2Jg9TKXLZOoGGnAc+RwKVzAS8Kko0EdechL2EJv/Bvj9nbaSuIKBfyWMLYiMLNbmFuntoh/quqeL+oiooVmekdcWNDGAJs5EyXAKhCuOynkNw+3I0DTyt+KYxRXMhJIIa7ixRGWzp3pzsvJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bpnWI2wP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bpnWI2wP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731712984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QO3/xpnSX52xP7nQ607VKTNlDEaSqeLqe30Wuj37Zvs=;
	b=bpnWI2wPW25Q/kIE5SmM+Px342GSZkNvIQ9OgrLgzXTIMALzk08SKiGY7jm41vW5W8vfYr
	TPwjUcj41V8LYmCi8dCVuUdVci2zXaPNEx26Sfp2Sqi7kA3cEKXcct+tPbGrl+ad7ziMSN
	FKz9fHeo7cGZYrptLK0q/jeZVcKvoYc=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-439-Ku2gwpIYPEa0eaHcZLRepg-1; Fri,
 15 Nov 2024 18:23:00 -0500
X-MC-Unique: Ku2gwpIYPEa0eaHcZLRepg-1
X-Mimecast-MFC-AGG-ID: Ku2gwpIYPEa0eaHcZLRepg
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B286619541AE;
	Fri, 15 Nov 2024 23:22:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 663B23003B71;
	Fri, 15 Nov 2024 23:22:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AFNMwMs627968
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 18:22:58 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AFNMwHe627967;
	Fri, 15 Nov 2024 18:22:58 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 5/6] libmultipath: check table type in dm_find_map_by_wwid
Date: Fri, 15 Nov 2024 18:22:55 -0500
Message-ID: <20241115232256.627933-6-bmarzins@redhat.com>
In-Reply-To: <20241115232256.627933-1-bmarzins@redhat.com>
References: <20241115232256.627933-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: p_GbZNG31TEdEMo512MhCgEjOuq_4bWRTi1U9kDCay4_1731712979
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

This function is only supposed to work on multipath devices (it adds the
multipath uuid prefix to the passed in wwid). Check this, and adapt
cli_add_map() to handle the corner case where there is a non-multipath
device with a multipath uuid.

Also, make dm_find_map_by_wwid() returned the alias of any found device,
even if it's not a valid multipath device.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c  | 2 +-
 multipathd/cli_handlers.c | 8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 42dcbc77..fa637c75 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -910,7 +910,7 @@ int dm_find_map_by_wwid(const char *wwid, char *name, struct dm_info *dmi)
 	if (safe_sprintf(tmp, UUID_PREFIX "%s", wwid))
 		return DMP_ERR;
 
-	return libmp_mapinfo(DM_MAP_BY_UUID,
+	return libmp_mapinfo(DM_MAP_BY_UUID | MAPINFO_MPATH_ONLY | MAPINFO_ID_IF_FOUND,
 			     (mapid_t) { .str = tmp },
 			     (mapinfo_t) { .name = name, .dmi = dmi });
 }
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 184c3f91..ec330d81 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -725,7 +725,13 @@ cli_add_map (void * v, struct strbuf *reply, void * data)
 		condlog(2, "%s: unknown map.", param);
 		return -ENODEV;
 	}
-	if (dm_find_map_by_wwid(refwwid, alias, &dmi) != DMP_OK) {
+	rc = dm_find_map_by_wwid(refwwid, alias, &dmi);
+	if (rc == DMP_NO_MATCH) {
+		condlog(2, "%s: wwid %s already in use by non-multipath device %s",
+			param, refwwid, alias);
+		return 1;
+	}
+	if (rc != DMP_OK) {
 		condlog(3, "%s: map not present. creating", param);
 		if (coalesce_paths(vecs, NULL, refwwid, FORCE_RELOAD_NONE,
 				   CMD_NONE) != CP_OK) {
-- 
2.46.2

