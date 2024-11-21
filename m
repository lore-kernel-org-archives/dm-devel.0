Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BAC2309A1
	for <dm-devel@lists.linux.dev>; Thu, 21 Nov 2024 00:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732148272; cv=none; b=PLBt2WcfO7I3wDh/dYt9Rzm3fX2P3sBUeFbBUI+JSP0hUXDawhNcv/J6UKs+Mcg+RJuGGLjBYAm7UB7iH7EVUXDlzrGvRe8XYDla2JSVE2LaZC+pvlgVhCO2yd0f3mFtPZgiwXNVxy7wF3j4h9JP5g2mRN/dJBViqMJTIyI+F6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732148272; c=relaxed/simple;
	bh=EWTRhgJsAkFrycXmjA70/glINYNQW80mg7WS9YNeQaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=lgqj9V928bj/FAEWDw9XzTt/Ko4lfFWkHy5lAueHPRBt2VY+cegYEF1zgrQao2mqM5EmpazzZjQ6LnRC/SkOhk640kxlc1xt3+SW4E68f3v+oH/goCBaUEpizlzSnh/lQ2KBPcsMHHDiHET6Wny+JlzjISF4sxFO+dEp0xHkQP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AsBvdQbX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AsBvdQbX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732148269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ex7WtBgO+O+zEKp6c2xOOXLMoe4rt3pA+Jg7BeuwndI=;
	b=AsBvdQbXs2vgxc7SPIh3sk3IolhQuKHMxVf8RbZ8jGLV0Z8rhhymoup5NIocjuix/5M/Tq
	SIISzpuGyDc6haqNmyjG22dJiKLvq23SCCMrIQ5wdVirVKfKn8lzDXOQXp1Q+u02WPHKkx
	U5u/mcIMJuHOlz9ifv52IzDRZ7CeVJc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-118-McoDaqyHPn-z0hRAZX-Xpg-1; Wed,
 20 Nov 2024 19:17:47 -0500
X-MC-Unique: McoDaqyHPn-z0hRAZX-Xpg-1
X-Mimecast-MFC-AGG-ID: McoDaqyHPn-z0hRAZX-Xpg
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8507819560AA;
	Thu, 21 Nov 2024 00:17:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0E6481956056;
	Thu, 21 Nov 2024 00:17:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AL0HiLw699371
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 20 Nov 2024 19:17:44 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AL0Hihr699370;
	Wed, 20 Nov 2024 19:17:44 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH] libmultipath: Fix MAPINFO_CHECK_UUID with partitions
Date: Wed, 20 Nov 2024 19:17:44 -0500
Message-ID: <20241121001744.699362-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: a9BjHahrz0G7aWoJmT_3UB95lkfBv_oncdTyUasoTC4_1732148266
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

In libmp_mapinfo__(), if is_mpath_part_uuid() succeeded, instead of
ending the 'if' statement, is_mpath_uuid() would be called because of
the OR operator.  This would always fail if is_mpath_part_uuid() passed.
This meant that libmp_mapinfo__() could never match partitions with
MAPINFO_CHECK_UUID.

Fix that by not calling is_mpath_uuid() if MAPINFO_PART_ONLY is set.

Fixes: c1aa0285 ("libmultipath: make MAPINFO_CHECK_UUID work with partitions")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 9714270d..224be512 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -734,7 +734,7 @@ static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info, const char *ma
 
 	if (flags & MAPINFO_CHECK_UUID &&
 	    ((flags & MAPINFO_PART_ONLY && !is_mpath_part_uuid(uuid, NULL)) ||
-	     !is_mpath_uuid(uuid))) {
+	     (!(flags & MAPINFO_PART_ONLY) && !is_mpath_uuid(uuid)))) {
 		condlog(4, "%s: UUID mismatch: %s", fname__, uuid);
 		return DMP_NO_MATCH;
 	}
-- 
2.46.2

