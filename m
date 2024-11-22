Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCAC1DF97E
	for <dm-devel@lists.linux.dev>; Fri, 22 Nov 2024 21:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732309904; cv=none; b=YYB4Fy3fXJR0zRt/GMXeVr3y4B8/6WtCF2oJ+OP5ZnnIlj38FEFkBr1NciK4KkTJQgb8DnyAjtso7M+pGyDdrJ6qEdP8cmGSoJc4bhwIQN/i3vfvG4hDCu+LQGQEI0zU0ecKn0bnuztYNVyW04D6vu1viBjnZ6hB6vBWuzps3OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732309904; c=relaxed/simple;
	bh=LaRDZrheB9unV62VRnaA4qutHmmIfhK6iNsa1kwEDD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=qBSy8ICF8toHQxnSar3P0sEUJFoYh8dIdgbV99lKwDeWg2MtPSiwtZPRa+ElU8MxBrpV9SoP8lMZ8aALvJNm4IEqzJBcwwPlY+61E38nGtNAu4hZJCU3dN7s4TyJYwhcvImQC8nk47tY+YTRmBsScLIasush8VuBeggyNDnq7eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aLJMy50w; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aLJMy50w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732309901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yTVWr4XU3+SRWl5S3SmM/r7UolCqOGhaATMV3uGEO2s=;
	b=aLJMy50we1w4uPC201Im8HrZ7uMcyLIdL49axyzcdeq729nuW/JbETX447JeDiwvuRATpG
	sCKMVdfJGlQ30LIdn14M0kqbNvc7vaMimVvLJhjANZBqw0jA7Nh5cEWbyMreByVgZDiQWR
	HYZYg0zml6DsATj/g799Fu5z9NA7oQU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-141-66n_wCDKMbGUqUhKJJCJKA-1; Fri,
 22 Nov 2024 16:11:38 -0500
X-MC-Unique: 66n_wCDKMbGUqUhKJJCJKA-1
X-Mimecast-MFC-AGG-ID: 66n_wCDKMbGUqUhKJJCJKA
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 87F761955F34;
	Fri, 22 Nov 2024 21:11:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3D85919560A3;
	Fri, 22 Nov 2024 21:11:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AMLBZ7f718931
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 22 Nov 2024 16:11:35 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AMLBZM4718930;
	Fri, 22 Nov 2024 16:11:35 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 12/13] libmultipath: accept empty partitions as valid in do_foreach_partmaps
Date: Fri, 22 Nov 2024 16:11:32 -0500
Message-ID: <20241122211133.718861-13-bmarzins@redhat.com>
In-Reply-To: <20241122211133.718861-1-bmarzins@redhat.com>
References: <20241122211133.718861-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: I20JFRa2x6_JdIPRjZWNuBMrTZAEYD7vp8EQIgBtdPQ_1732309897
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If the partition is empty, is_valid_partmap() only checks that the uuid
matches the multipath device, since there is no table to check for
mapping over the multipath device.

The only partmap_func that needs changes to handle empty devices is
count_partitions(), which should only count a partition is it has a
table (since otherwise it will not have the multipath device open).

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 3667c51b..c96e4b22 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -944,16 +944,23 @@ has_partmap(const char *name __attribute__((unused)),
  * This will be called from mpath_in_use, for each partition.
  * If the partition itself in use, returns 1 immediately, causing
  * do_foreach_partmaps() to stop iterating and return 1.
- * Otherwise, increases the partition count.
+ * Otherwise, increases the partition count if the partition has a
+ * table (live or inactive). Devices with no table don't count
+ * towards the multipath device open count.
  */
 static int count_partitions(const char *name, void *data)
 {
+	struct dm_info info;
 	int *ret_count = (int *)data;
-	int open_count = dm_get_opencount(name);
 
-	if (open_count)
+	if (dm_get_info(name, &info) != DMP_OK)
+		return 1;
+
+	if (info.open_count)
 		return 1;
-	(*ret_count)++;
+
+	if (info.live_table || info.inactive_table)
+		(*ret_count)++;
 	return 0;
 }
 
@@ -1335,8 +1342,8 @@ is_valid_partmap(const char *name, const char *map_dev_t,
 			  (mapid_t) { .str = name },
 			  (mapinfo_t) { .uuid = part_uuid, .target = &params});
 
-	/* There must be a single linear target */
-	if (r != DMP_OK)
+	/* There must be a single linear target or an empty map. */
+	if (r != DMP_OK && r != DMP_EMPTY)
 		return false;
 
 	/*
@@ -1346,7 +1353,10 @@ is_valid_partmap(const char *name, const char *map_dev_t,
 	if (!is_mpath_part_uuid(part_uuid, map_uuid))
 		return false;
 
-	/* and the table must map over the multipath map */
+	if (r == DMP_EMPTY)
+		return true;
+
+	/* and if the table isn't empty it must map over the multipath map */
 	return ((p = strstr(params, map_dev_t)) &&
 		!isdigit(*(p + strlen(map_dev_t))));
 }
-- 
2.46.2

