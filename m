Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90DD18DF8D
	for <dm-devel@lists.linux.dev>; Fri, 15 Nov 2024 23:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731712986; cv=none; b=gRyppuLcr43vhwE6Qd3jHYrsAtXxdxHZs9jyEO9fvTYTznQ6koPz6dNTJc1LItCVB3py4gMjvAE4gmiMlqxb3iKdBFY29LAns4hDo1Ph/P45P7YU65LBaFtBzpK0NtVUf41PzGUvDs2gPVucfznCBHkUu5+d1tl4ufkGR+7XVu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731712986; c=relaxed/simple;
	bh=X7XXXCnX3Q42918UGNB5knHK4IblelN/UKYflPCOTIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I1LG58RPh7ZsDHryvKU9P6rfvrAQN+1RSTh9DwfR4LWbWaGh2o5K6QLGSY7wCnJqS3AdrIKGHLupuJ/RyID6Q9MWMlDFFp3VW4MGRNTXNtUEGBEpehkUvAAy3ZW7aDIJTnjAUHHL9zD1yUdgTNNcFWPNJeqS7b26iTOFpTrKLrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RB3K2fUj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RB3K2fUj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731712983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/nf3mHlDWAKCg9R17oBCeJyqjRQ32l+A9wojRwR414Y=;
	b=RB3K2fUjLkCBUqiU8CGSAwaouD0hAqnDIn1jy9Wd+gH6poq/tC4CY9XrE8ICNNC4Di1qAJ
	MuuwxlF4WBW36VcLv6z0ReOuI8aAauSthTY/6WNMX31SdcOX2NVoVvV7LDNKlG3EQIiE4o
	BRMuIs7uqFA5ZjAyaxe3YT3l9SpG7dY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-182-7fSoIBntOKG3KrLEk3d66A-1; Fri,
 15 Nov 2024 18:23:00 -0500
X-MC-Unique: 7fSoIBntOKG3KrLEk3d66A-1
X-Mimecast-MFC-AGG-ID: 7fSoIBntOKG3KrLEk3d66A
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E42119560A6;
	Fri, 15 Nov 2024 23:22:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BEEBC3003B71;
	Fri, 15 Nov 2024 23:22:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AFNMvJp627952
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 18:22:57 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AFNMvNV627951;
	Fri, 15 Nov 2024 18:22:57 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 1/6] libmultipath: signal device with no table in libmp_mapinfo
Date: Fri, 15 Nov 2024 18:22:51 -0500
Message-ID: <20241115232256.627933-2-bmarzins@redhat.com>
In-Reply-To: <20241115232256.627933-1-bmarzins@redhat.com>
References: <20241115232256.627933-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Ck-2XEHS2ejRp2Kc5e24zueK8IBWsZAwKJsiuwV54Po_1731712979
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

if libmp_mapinfo() is run on a device that has no active table,
it will now return with a new exit code, DMP_EMPTY, to signal this.
Currently all code paths treat this identically to DMP_NOT_FOUND.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 6 ++++--
 libmultipath/devmapper.h | 7 ++++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 9714270d..b718dccf 100644
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

