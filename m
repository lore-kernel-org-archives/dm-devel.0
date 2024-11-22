Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A9018BC0D
	for <dm-devel@lists.linux.dev>; Fri, 22 Nov 2024 21:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732309903; cv=none; b=sggYnbbbNXDGyyvNPE/z6tgq6ehKnVf9+zK03/0Psb5TBlt7xrUiR//n7s1KfT96DSyAiHu83VJ6TJ8mZedp4NvCVvQSVIqT1Nzt3u/NejYNR+Sfk1V9v3V+vQxW1IXJidJCSacUf/GEWO0l2roj0EpOgH6v3BzVxVaY4nocyxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732309903; c=relaxed/simple;
	bh=RirEoRPr0csyNeaEP0BXGDHSR8LsqTu1sOBNQbON2oM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=n28zloa4NEhlPYOBryMtM2nPOoRSThWNjsaObJQBE3PdWaHyCbnZoFyjnzU46v2049xbhzGrEpWcn9/Ncb5GYhyDC+HeClggvy0cXuM+VbBbJDqLXqZo3iDOXKWl8bSTXmB9IvhOOHn2jx2XWjn0AAQH2WA9h+cadT3liTTA5SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KDX9MhDt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KDX9MhDt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732309901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Eu+bRsKkC7V9Qb4CjosKMZBobvgsdQGqyoqGWbQLXGM=;
	b=KDX9MhDtxx5w+kW90rpWH+y/rp30vi1x43QxfwB+9zCjILAgHAOCzJttCNs7g/aEoQJZl3
	SeJNRvAyzc2A5t1g+7nAYPZ7Mz1QmFgFIDHgEvnaX6ylv63Drbxdo/4DiOXml/E/JuPjzq
	vZV+tSdYgZay0+dCFecfGjlrYWt1who=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-99-49c5Jmo7P2iRCWzsGrvjYw-1; Fri,
 22 Nov 2024 16:11:37 -0500
X-MC-Unique: 49c5Jmo7P2iRCWzsGrvjYw-1
X-Mimecast-MFC-AGG-ID: 49c5Jmo7P2iRCWzsGrvjYw
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 038C4195608C;
	Fri, 22 Nov 2024 21:11:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ADCAE1955F43;
	Fri, 22 Nov 2024 21:11:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AMLBZFU718915
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 22 Nov 2024 16:11:35 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AMLBZqJ718914;
	Fri, 22 Nov 2024 16:11:35 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 08/13] libmultipath: factor out code to check if a device is a parition
Date: Fri, 22 Nov 2024 16:11:28 -0500
Message-ID: <20241122211133.718861-9-bmarzins@redhat.com>
In-Reply-To: <20241122211133.718861-1-bmarzins@redhat.com>
References: <20241122211133.718861-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PgXft8B-Hpn_x_Cnx3sKzLONgRHLClfGVTNpQcnV83c_1732309897
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Move the code to check if a device is a valid parition of a multipath
device out into it's own function. A future patch will make this code
more complicated. No functional changes.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 57 ++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 28 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index b0bd0d4f..0df9ee40 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1318,17 +1318,43 @@ char *dm_mapname(int major, int minor)
 	return strdup(name);
 }
 
+static bool
+is_valid_partmap(const char *name, const char *map_dev_t,
+		 const char *map_uuid) {
+	int r;
+	char __attribute__((cleanup(cleanup_charp))) *params = NULL;
+	char *p;
+	char part_uuid[DM_UUID_LEN];
+
+	r = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_PART_ONLY | MAPINFO_CHECK_UUID,
+			  (mapid_t) { .str = name },
+			  (mapinfo_t) { .uuid = part_uuid, .target = &params});
+
+	/* There must be a single linear target */
+	if (r != DMP_OK)
+		return false;
+
+	/*
+	 * and the uuid of the target must be a partition of the uuid of the
+	 * multipath device
+	 */
+	if (!is_mpath_part_uuid(part_uuid, map_uuid))
+		return false;
+
+	/* and the table must map over the multipath map */
+	return ((p = strstr(params, map_dev_t)) &&
+		!isdigit(*(p + strlen(map_dev_t))));
+}
+
 static int
 do_foreach_partmaps (const char *mapname,
 		     int (*partmap_func)(const char *, void *),
 		     void *data)
 {
 	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
-	char __attribute__((cleanup(cleanup_charp))) *params = NULL;
 	struct dm_names *names;
 	unsigned next = 0;
 	char dev_t[BLK_DEV_SIZE];
-	char *p;
 	char map_uuid[DM_UUID_LEN];
 	struct dm_info info;
 
@@ -1354,35 +1380,10 @@ do_foreach_partmaps (const char *mapname,
 		return 0;
 
 	do {
-		char part_uuid[DM_UUID_LEN];
-
-		if (
-		    /*
-		     * if there is only a single "linear" target
-		     */
-		    libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_PART_ONLY | MAPINFO_CHECK_UUID,
-				  (mapid_t) { .str = names->name },
-				  (mapinfo_t) {
-					  .uuid = part_uuid,
-					  .target = &params,
-				  }) == DMP_OK &&
-		    /*
-		     * and the uuid of the target is a partition of the
-		     * uuid of the multipath device
-		     */
-		    is_mpath_part_uuid(part_uuid, map_uuid) &&
-
-		    /*
-		     * and the table maps over the multipath map
-		     */
-		    (p = strstr(params, dev_t)) &&
-		    !isdigit(*(p + strlen(dev_t))) &&
-
+		if (is_valid_partmap(names->name, dev_t, map_uuid) &&
 		    (partmap_func(names->name, data) != 0))
 			return 1;
 
-		free(params);
-		params = NULL;
 		next = names->next;
 		names = (void*) names + next;
 	} while (next);
-- 
2.46.2

