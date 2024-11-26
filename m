Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF941DE3D9
	for <dm-devel@lists.linux.dev>; Tue, 26 Nov 2024 18:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732646556; cv=none; b=Cc80dLRTg4qUhwQa4fijXNYRRyoLU2lakSTrbUGTpL4e5KjTbtst8EHCpvhpgQmFqcYi5Nu4urX22Xiky1l9mTxi+gzEiNYj9quhU14BHSE9fp9T0+OnSg3vZFRUvhtgv9OpQhgZmAJMeF5shjoYIrd9ady/3dbLkiBcXx4pfSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732646556; c=relaxed/simple;
	bh=J3d+yAjAuj16m2elbdgl2lCvpc2kUpSKE3kvY9iKO14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=RPwDj48BvVQ3L7OQn2Q50QERxo0bkBsevOr+FNPjxIQ36S8s3PPKbJdR4KGYh22GYmxTVfpXABtMtqRO8PvOzHDefVjWcXosfzl1dJ6ZLxUNkRTKc4kxgdGORydkADlH89rtRm/NKmauYgotziBS0ye8bMRS3h0Kmzu0eHqHz5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b+m6LXFg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b+m6LXFg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732646554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B/ZrZErwHwYycc+sEKMeX8EMSHMxC5Zz6MQhc2qdMMo=;
	b=b+m6LXFgCh3qM58/4eNyPRzAO5GnNxrigcY7ELxmgU4hmw9JE5TMnxUfQFg+g+r1DNJ7Z0
	rRFVVoChbsYG3liq5fKvcxKV1XCULiPpaDgk6m3X2U3VixUEl/7Xt+NcGgOYN3RR4qKvXK
	/u/3AokZLt1gFNwJmL6jQBxUyOfTOWg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-554-Iw_2UteAOv646lLSDAxYdw-1; Tue,
 26 Nov 2024 13:42:28 -0500
X-MC-Unique: Iw_2UteAOv646lLSDAxYdw-1
X-Mimecast-MFC-AGG-ID: Iw_2UteAOv646lLSDAxYdw
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6E43B1954B1A;
	Tue, 26 Nov 2024 18:42:27 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2C32A195E483;
	Tue, 26 Nov 2024 18:42:27 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AQIgPkA855508
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 Nov 2024 13:42:26 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AQIgPLp855507;
	Tue, 26 Nov 2024 13:42:25 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 07/12] libmultipath: handle empty maps in dm_flush_map__
Date: Tue, 26 Nov 2024 13:42:19 -0500
Message-ID: <20241126184224.855459-8-bmarzins@redhat.com>
In-Reply-To: <20241126184224.855459-1-bmarzins@redhat.com>
References: <20241126184224.855459-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Nl72__JL7MZcbWqSTM6GCXHlXdbINfwnir9vATMJk4M_1732646547
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Make dm_flush_map__() remove empty devices, as long as they have
valid multipath uuids.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index e5f49a5b..b0bd0d4f 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -982,11 +982,16 @@ int dm_flush_map__ (const char *mapname, int flags, int retries)
 	int udev_flags = 0;
 	char *params __attribute__((cleanup(cleanup_charp))) = NULL;
 
-	if (libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY | MAPINFO_CHECK_UUID,
+	r = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY | MAPINFO_CHECK_UUID,
 			  (mapid_t) { .str = mapname },
-			  (mapinfo_t) { .target = &params }) != DMP_OK)
+			  (mapinfo_t) { .target = &params });
+	if (r != DMP_OK && r != DMP_EMPTY)
 		return DM_FLUSH_OK; /* nothing to do */
 
+	/* device mapper will not let you resume an empty device */
+	if (r == DMP_EMPTY)
+		flags &= ~DMFL_SUSPEND;
+
 	/* if the device currently has no partitions, do not
 	   run kpartx on it if you fail to delete it */
 	if (do_foreach_partmaps(mapname, has_partmap, NULL) == 0)
-- 
2.46.2

