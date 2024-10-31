Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99F21BC9F3
	for <dm-devel@lists.linux.dev>; Thu, 31 Oct 2024 18:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730399591; cv=none; b=oHmoEExEByR05gXk4cNoTYzMysxm4SnnAkO4JmJq2Xq6KVWoWaTMha6vEjYI6bguyIs90h9lAlj1LbFGuzZ7gaYL6PfZ5PwGTprk3JVjEIlCsrvfze6bb3veHWOYv/r8swxoK0MbAhGCJV2TeSmC42NopqxSNrcI9ZM88uCDLqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730399591; c=relaxed/simple;
	bh=XmPCXOUufXoUPP7xiA7xmF7aC1VJfC817kV4WzcvO6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FgPPd/LaLE8acHQGV9j8vTV2kvKjwOdnE9ielg6BRqUd6G1hr/u8ZnTBCFnrhzb0eSLzEN/fPlBTwQFjFry5YpuyUtD9KW+dZhf7Jt6dcILpgg/rWlU73rV1xvmfTUGlhALdyaJm0t90pZIlIBKUivganCf713eouuszyagZHzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y5i//XNn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y5i//XNn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730399588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=656JWP42m/h/xAb32eTHiGPELrL9SBuET0EYHWgbL7c=;
	b=Y5i//XNnyOTABOrJyKYK3o6sdrgyb1jf0QBQrR2aA4K3pEFVjQcsVJtqPYNrPFh8ZaLFaf
	QEgkHN1bqwtbyo+3/mSPxnr2K6bE10KJhQIWc9Yo6jjzkFHSKFkF5y56H0HafsRfzBRJKf
	NRlS7uCLdlQbo4T3SPRgDJxj2bGgod4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-629-UORKY0ipPrC4lItjSRT2Uw-1; Thu,
 31 Oct 2024 14:33:05 -0400
X-MC-Unique: UORKY0ipPrC4lItjSRT2Uw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BBD4619560A7;
	Thu, 31 Oct 2024 18:33:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7A7851956046;
	Thu, 31 Oct 2024 18:33:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 49VIX3iY391453
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 14:33:03 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 49VIX3PE391452;
	Thu, 31 Oct 2024 14:33:03 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 5/8] libmultipath: use MAPINFO_CHECK_UUID in dm_get_multipath
Date: Thu, 31 Oct 2024 14:32:58 -0400
Message-ID: <20241031183301.391416-6-bmarzins@redhat.com>
In-Reply-To: <20241031183301.391416-1-bmarzins@redhat.com>
References: <20241031183301.391416-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Instead of seperately calling is_mpath_uuid(), just use
MAPINFO_CHECK_UUID when calling libmp_mapinfo.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 33eadb12..13d8c1e5 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1211,7 +1211,8 @@ static int dm_get_multipath(const char *name, struct multipath **pmpp)
 	if (!mpp->alias)
 		return DMP_ERR;
 
-	if ((rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
+	if ((rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID |
+				MAPINFO_MPATH_ONLY,
 			  (mapid_t) { .str = name },
 			  (mapinfo_t) {
 				  .size = &mpp->size,
@@ -1220,9 +1221,6 @@ static int dm_get_multipath(const char *name, struct multipath **pmpp)
 			  })) != DMP_OK)
 		return rc;
 
-	if (!is_mpath_uuid(uuid))
-		return DMP_NO_MATCH;
-
 	strlcpy(mpp->wwid, uuid + UUID_PREFIX_LEN, sizeof(mpp->wwid));
 	*pmpp = steal_ptr(mpp);
 
-- 
2.46.2

