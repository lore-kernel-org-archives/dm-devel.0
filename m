Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636CA178CF6
	for <dm-devel@lists.linux.dev>; Fri, 22 Nov 2024 21:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732309902; cv=none; b=ZVh9hCykz7367cZ53iBswI3N+E2Mr5a/x7G1TYgB96Rx4oBxCxbWed6yK7P6fB8etmJHlfSL8mm9+NHhtTgaAIbh4K901UQFeQXM/Q50AObHKFkbs6IOSRD06I9Z6IBqFXmjP/3CUlvI8iF6D7s/d8V5UpgcGR36qAi4sHXRT2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732309902; c=relaxed/simple;
	bh=VwvzbyvScF8jnJVrihY0aPnabhJ3Efna+oVUzp5PJhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=rtK0AtQjSPodruvPnOZ0NWqMKaZYq8xjlIRsgR7C5qx3muFfb6JD3u7WncZzwHeMyIUa3luonGgs/8INwKg9JWwHxygbr7FSOMU8bNUYfkTzd3YgoiTyYLaUeYp+gCR2N+zTqUkYmTgh0eLp7cgS+l7H8AMbT1EDmJb+MXRBuQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nkqv2cNt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nkqv2cNt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732309899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b/EWs7G4+cTXuh+UJnvci/afZKJkUq82+iUPugW2+MM=;
	b=Nkqv2cNtbX+An3kkgqec3wf+hgisooKQFpE+E+rlBnCPQwGHlFJcIDx/P/Fu08RdmUh1de
	BUBF9m534Vx7HBdxopsEUWc7J9REHkBQEcs62Kk5VxV8PgGy8rwPpD4Wtnl5KwsDl1Xlko
	rsrYhQnH1lNlDDMsqsIQre6XLRAiJKA=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-584-7ISZT1ntOjSZpSP6-l5Xhw-1; Fri,
 22 Nov 2024 16:11:37 -0500
X-MC-Unique: 7ISZT1ntOjSZpSP6-l5Xhw-1
X-Mimecast-MFC-AGG-ID: 7ISZT1ntOjSZpSP6-l5Xhw
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 887681955EE7;
	Fri, 22 Nov 2024 21:11:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3723E1955F3E;
	Fri, 22 Nov 2024 21:11:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AMLBYKF718903
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 22 Nov 2024 16:11:34 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AMLBYJt718902;
	Fri, 22 Nov 2024 16:11:34 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 05/13] libmultipath: check table type in dm_find_map_by_wwid
Date: Fri, 22 Nov 2024 16:11:25 -0500
Message-ID: <20241122211133.718861-6-bmarzins@redhat.com>
In-Reply-To: <20241122211133.718861-1-bmarzins@redhat.com>
References: <20241122211133.718861-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CIKsyxC5JUgSk3BGn0Pkl0-u1tM9t800XtCw844A-B4_1732309896
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This function is only supposed to work on multipath devices (it adds the
multipath uuid prefix to the passed in wwid). Check this, and adapt
cli_add_map() to handle the corner case where there is a non-multipath
device with a multipath uuid.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c  | 2 +-
 multipathd/cli_handlers.c | 8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 38c49bd5..e5f49a5b 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -892,7 +892,7 @@ int dm_find_map_by_wwid(const char *wwid, char *name, struct dm_info *dmi)
 	if (safe_sprintf(tmp, UUID_PREFIX "%s", wwid))
 		return DMP_ERR;
 
-	return libmp_mapinfo(DM_MAP_BY_UUID,
+	return libmp_mapinfo(DM_MAP_BY_UUID | MAPINFO_MPATH_ONLY,
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

