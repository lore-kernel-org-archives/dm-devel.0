Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB5A1A00FE
	for <dm-devel@lists.linux.dev>; Fri, 15 Nov 2024 23:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731712987; cv=none; b=VxlS0n+nVJ66fhzpOgZd9nEh0D0AqkbLyL3INFUS6FMDNWfrhIuycqYFJMyfNERfcgzlH/vFEjZIo5h+oXxfk8SPug4aIFE6FSaSxb4AXb1issIP18g2TnHHchAswzdCZuGBdD21iTWzIw2lmMheu1rsCM44YqH24RWu19FiuUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731712987; c=relaxed/simple;
	bh=UfE3wje387FLrxxxZScNuOZLGOpSD/o7iKAdXhnqpVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c3q+RWZunVX4oegW0xTpMVwfZZOuwPx9+II9fDVmb49qZDsncDgTfO+CXlDEYBrOOqAqPWJWKSgJWG5hUCeN7JVUO8l8jqaPhl1pQJDvIGqWkjmptwu1XwxLLPfn2qP5C43x73+Lo4sv922sSDMx5lITuEho6gwUxt2KVJpk80o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KDqk2sSS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KDqk2sSS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731712984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BCYWfZec574Tuw0r1eGkLNFpu1884L0vft1euEnA8Z8=;
	b=KDqk2sSST6YkqYQKpxs8TRvPXiN3GS4EmW/VQs3ZTdzKveALPZB7ZF77D+NcrCH2lZOLY2
	fbhsG2uWu2n3vZAW3GBTj0ObqP9wSUKAWisnMHmRq6OVhn8Iocx1HXwMfyRhSSxmNoz0EN
	//+myO/edbSF2j6Iehcapmbio7+fG0M=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-435-qCESoN2aPI-n2Z2w7RV7dg-1; Fri,
 15 Nov 2024 18:23:00 -0500
X-MC-Unique: qCESoN2aPI-n2Z2w7RV7dg-1
X-Mimecast-MFC-AGG-ID: qCESoN2aPI-n2Z2w7RV7dg
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 40D1F19560B8;
	Fri, 15 Nov 2024 23:22:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E940E1956054;
	Fri, 15 Nov 2024 23:22:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AFNMvw5627960
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 18:22:57 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AFNMv6u627959;
	Fri, 15 Nov 2024 18:22:57 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 3/6] libmultipath: fix removing device after failed creation
Date: Fri, 15 Nov 2024 18:22:53 -0500
Message-ID: <20241115232256.627933-4-bmarzins@redhat.com>
In-Reply-To: <20241115232256.627933-1-bmarzins@redhat.com>
References: <20241115232256.627933-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: asXoXD9RcYva-KqPsTJBn05t5JHVWDAZOt_9utrd-mI_1731712979
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

dm_flush_nap_nosync() only removes a device if it has a multipath table.
On failed removes, there is no table, so this function does nothing.
Instead, if libmp_mapinfo() returns DMP_EMPTY, then there is an empty map,
and it is removed using dm_device_remove().

Also, since there are no longer any callers of dm_flush_map_nosync(),
remove it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 7 +++++--
 libmultipath/devmapper.h | 1 -
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index b718dccf..842e7c80 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -557,9 +557,12 @@ int dm_addmap_create (struct multipath *mpp, char * params)
 		 * Failing the second part leaves an empty map. Clean it up.
 		 */
 		err = errno;
-		if (dm_map_present(mpp->alias)) {
+		if (libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY |
+				  MAPINFO_CHECK_UUID,
+				(mapid_t) { .str = mpp->alias },
+				(mapinfo_t) { .uuid = NULL }) == DMP_EMPTY) {
 			condlog(3, "%s: failed to load map (a path might be in use)", mpp->alias);
-			dm_flush_map_nosync(mpp->alias);
+			dm_device_remove(mpp->alias, 0);
 		}
 		if (err != EROFS) {
 			condlog(3, "%s: failed to load map, error %d",
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 23926e3f..0bd2b907 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -174,7 +174,6 @@ enum {
 
 int dm_flush_map__ (const char *mapname, int flags, int retries);
 #define dm_flush_map(mapname) dm_flush_map__(mapname, DMFL_NEED_SYNC, 0)
-#define dm_flush_map_nosync(mapname) dm_flush_map__(mapname, DMFL_NONE, 0)
 #define dm_suspend_and_flush_map(mapname, retries) \
 	dm_flush_map__(mapname, DMFL_NEED_SYNC|DMFL_SUSPEND, retries)
 int dm_flush_map_nopaths(const char * mapname, int deferred_remove);
-- 
2.46.2

