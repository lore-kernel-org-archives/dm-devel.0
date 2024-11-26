Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CBE1DEFE1
	for <dm-devel@lists.linux.dev>; Tue, 26 Nov 2024 18:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732646554; cv=none; b=tJIEvJKqEpzoQ9l86d7a72yJLk0zuuFeYtE4wpBzR/csdg8ybHDGEi7EpjRezw9RTMhm/Fsr5CaATmgLm2gXkLgrjiRgXobd18B56dmqgZs5zeaQEIykCcSoBbYIO3Nnfu1HmoWPMBs+fen4GhXClbcODAgmxHrblX3qwoc6RRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732646554; c=relaxed/simple;
	bh=jj/WwDiwe6CUwOI0g+ZYwSFn/EryoxEKc2+45/SDFoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=heit5KBuqy4WrAB1DcolAqMzHTWhE/KQ2tq6+pAOR8pWJU2sDJRCelmnYHjD0rIhsCVhmVKW1yWztKQrQjZXIEMXV5i4+WIphh+j66VQpnwHgytCaWRKNsevTRrxWPM6wRgKM0gRevzlHEx60qUnsS4iVMOKximTEyAyHr/Ll/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PYkHJA1D; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PYkHJA1D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732646552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1XxIvS/iz7G5x9/inp7Fy0zDkBgoAJThyhE3IsCkkc4=;
	b=PYkHJA1DK6M9YIdz/JSa1yOBNy7v3hVCdPBVSGLMklboa9C3Ta9tlinu0QNV82QoPl/XuI
	/GFOg1R3TUPmUzfdvXeGGM4go0Q0DS8XgzGph+biWnDlDsqPg0DbRXVAkoIdXlk3++Xrl1
	ulB1eL6nw2sWhosmKuTjPGg2rRlRVAs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-493-ryfwwF7oOoyBy7ZBKetJ3Q-1; Tue,
 26 Nov 2024 13:42:28 -0500
X-MC-Unique: ryfwwF7oOoyBy7ZBKetJ3Q-1
X-Mimecast-MFC-AGG-ID: ryfwwF7oOoyBy7ZBKetJ3Q
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BDD171955EAD;
	Tue, 26 Nov 2024 18:42:27 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 74726300019E;
	Tue, 26 Nov 2024 18:42:27 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AQIgQBd855512
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 Nov 2024 13:42:26 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AQIgQFP855511;
	Tue, 26 Nov 2024 13:42:26 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v3 08/12] libmultipath: factor out code to check if a device is a partition
Date: Tue, 26 Nov 2024 13:42:20 -0500
Message-ID: <20241126184224.855459-9-bmarzins@redhat.com>
In-Reply-To: <20241126184224.855459-1-bmarzins@redhat.com>
References: <20241126184224.855459-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 28tMllRSHqRsEO5SJuBB4R2xOXtG6rMNMyL4nAtoCo4_1732646547
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Move the code to check if a device is a valid partition of a multipath
device out into its own function. A future patch will make this code
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

