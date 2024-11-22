Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1C24A0C
	for <dm-devel@lists.linux.dev>; Fri, 22 Nov 2024 21:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732309901; cv=none; b=eJbzN3DS2Xl5QIXyNEt4OS/ECsU2ErVK3fGW0lBLBOQbkzj4gmjodg5njBcB0OdOCTuCGws4qBJ76JE7yjDN3Q9uBuQx1dBlZyy1pvPqrIZG+lqZQt0LxS28tAJz05dvblld1glrV3yJQ/jisAtxjh2fkYfZx2lYXpEqOJI7/Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732309901; c=relaxed/simple;
	bh=BIbleTl1rALtb1vpdiNnnt4ohbS+0rCK+99XAsi+Zyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=CQlPsHA9J9Emi5jvnBUDonwkv5G7ZkQvq4MehGAdpV5QWv+1AjtzWdRUXJziN2NbAYW2xc6961BQKxeiCDXaJyDQ5AG6VlbLtlP0dfsQY+aKZ2jMqrz6rWLALkWpbKvGNRmIITZCjH2Af+muAUeEvQz5lM4WZzQFXh1J+nXoSaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FEGkOGMv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FEGkOGMv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732309898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QggajM37qtosVAK+KZun23dB0z86nzctjqfIzCivRmg=;
	b=FEGkOGMv6HWmA5Zmj8kAbiiuiPkHU3+h2QYYsPjkrIU4YXLkJ9kTK7Ka3/bwaC6xIEgLHf
	gY92zxxFTtQMSwwiKzU/ogH5lEz/+/cPrQe/sLmaseD5mefRM3DuNPP5+75HYsPeEAb1Lk
	7QzsVFtzSGBaPSgcltM0KXVfMNYHkZA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-568-vi-pRilMNPKphfjsuZB7jA-1; Fri,
 22 Nov 2024 16:11:37 -0500
X-MC-Unique: vi-pRilMNPKphfjsuZB7jA-1
X-Mimecast-MFC-AGG-ID: vi-pRilMNPKphfjsuZB7jA
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F39CF19560BD;
	Fri, 22 Nov 2024 21:11:35 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 771511955F3E;
	Fri, 22 Nov 2024 21:11:35 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AMLBYWT718887
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 22 Nov 2024 16:11:34 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AMLBY5S718886;
	Fri, 22 Nov 2024 16:11:34 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 01/13] libmultipath: signal device with no table in libmp_mapinfo
Date: Fri, 22 Nov 2024 16:11:21 -0500
Message-ID: <20241122211133.718861-2-bmarzins@redhat.com>
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
X-Mimecast-MFC-PROC-ID: 1C1WeDFpc8DD7d5UKEa5be42FDlixSndkCAtCHH7n1k_1732309896
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

if libmp_mapinfo() is run on a device that has no active table,
it will now return with a new exit code, DMP_EMPTY, to signal this.
Currently all code paths treat this identically to DMP_NOT_FOUND.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 6 ++++--
 libmultipath/devmapper.h | 7 ++++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 224be512..33425d02 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -86,6 +86,7 @@ const char *dmp_errstr(int rc)
 		[DMP_OK] = "success",
 		[DMP_NOT_FOUND] = "not found",
 		[DMP_NO_MATCH] = "target type mismatch",
+		[DMP_EMPTY] = "no target",
 		[DMP_LAST__] = "**invalid**",
 	};
 	if (rc < 0 || rc > DMP_LAST__)
@@ -747,9 +748,9 @@ static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info, const char *ma
 			condlog(lvl, "%s: map %s has multiple targets", fname__, map_id);
 			return DMP_NO_MATCH;
 		}
-		if (!params) {
+		if (!params || !target_type) {
 			condlog(lvl, "%s: map %s has no targets", fname__, map_id);
-			return DMP_NOT_FOUND;
+			return DMP_EMPTY;
 		}
 		if (flags & MAPINFO_TGT_TYPE__) {
 			const char *tgt_type = flags & MAPINFO_MPATH_ONLY ? TGT_MPATH : TGT_PART;
@@ -873,6 +874,7 @@ int dm_is_mpath(const char *name)
 		return DM_IS_MPATH_YES;
 	case DMP_NOT_FOUND:
 	case DMP_NO_MATCH:
+	case DMP_EMPTY:
 		return DM_IS_MPATH_NO;
 	case DMP_ERR:
 	default:
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 6b3bbad9..23926e3f 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -35,6 +35,7 @@ enum {
 	DMP_OK,
 	DMP_NOT_FOUND,
 	DMP_NO_MATCH,
+	DMP_EMPTY,
 	DMP_LAST__,
 };
 
@@ -105,7 +106,11 @@ typedef struct libmp_map_info {
  * @returns:
  *     DMP_OK if successful.
  *     DMP_NOT_FOUND if the map wasn't found, or has no or multiple targets.
- *     DMP_NO_MATCH if the map didn't match @tgt_type (see above).
+ *     DMP_NO_MATCH if the map didn't match @tgt_type (see above) or didn't
+ *                  have a multipath uuid prefix.
+ *     DMP_EMPTY if the map has no table. Note. The check for matching uuid
+ *               prefix will happen first, but the check for matching
+ *               tgt_type will happen afterwards.
  *     DMP_ERR if some other error occurred.
  *
  * This function obtains the requested information for the device-mapper map
-- 
2.46.2

