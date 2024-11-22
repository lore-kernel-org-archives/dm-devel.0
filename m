Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7047188736
	for <dm-devel@lists.linux.dev>; Fri, 22 Nov 2024 21:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732309903; cv=none; b=Wu+Yx83KQVA2HPSloigumww1StniDhUimabD3xv2QrAu6LHPKSRx9xs5/HZvuahpqzhF31ugl2TVbo9gZd1qCzUaSIGa5VPMRNfivQfRg9TpYdNHpM+buX0unpQnEBgDBKAfUlrRK5OTYKtFxN/XrmHsFnXOfvwfYxLpHr6BwwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732309903; c=relaxed/simple;
	bh=vWz+OlsAsdn/pwUjYWntePA7f0Imk6skyYDtZAHOwJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=RDM+XSYhC/5klARywTKH2bye5wEU50Qd5XPwhmCkzBUa877d8lqNU3SYPO4MsDglsnNqjIVGjwOVe0CMSin371dwsL3SVM4P0vvwMJFe7O3F9S8r4PzvL5rSNX309WQdxRw5jQyZzYDwLB/WNa+d925mGe6K3iwafNiLUcZqKGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZzBXphXZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZzBXphXZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732309900;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2VKNqjVaxF3u8YRRwe6C5a46Ejz0trjeequzLepicg4=;
	b=ZzBXphXZYx2/InGrEiiDkQh+tXSoBDwS+0fNCOiGCt/SM4It+6bkVfqLkTapG9Zr+b/uR+
	ice/N+3dhX+frI01M/kfaONkJhJgzFLMq/3YKFcdSsyuB4rF7IYaNYoP383UZCwnEfnnTy
	evZdBrt9aowCES8mQwfF+Yj2Risa3WU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-590-rcPNOKCIPxeoZ9x061Hi9Q-1; Fri,
 22 Nov 2024 16:11:37 -0500
X-MC-Unique: rcPNOKCIPxeoZ9x061Hi9Q-1
X-Mimecast-MFC-AGG-ID: rcPNOKCIPxeoZ9x061Hi9Q
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 947E41956064;
	Fri, 22 Nov 2024 21:11:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5391B1955EA9;
	Fri, 22 Nov 2024 21:11:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AMLBZAa718911
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 22 Nov 2024 16:11:35 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AMLBZQu718910;
	Fri, 22 Nov 2024 16:11:35 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 07/13] libmultipath: handle empty maps in dm_flush_map__
Date: Fri, 22 Nov 2024 16:11:27 -0500
Message-ID: <20241122211133.718861-8-bmarzins@redhat.com>
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
X-Mimecast-MFC-PROC-ID: zH1DAQ-PgnyGwupBKRX18gF6thfkqErpf_PV4akdkr0_1732309896
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Make dm_flush_map__() remove empty devices, as long as they have
valid multipath uuids.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
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

