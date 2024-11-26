Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B97D1DF257
	for <dm-devel@lists.linux.dev>; Tue, 26 Nov 2024 18:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732646555; cv=none; b=Kv76OcBFIJ0Xaty1h/ueOqJErHi526jTlfGbIWUJK5QpbiP2jbDWV7i2PRkqyrzTMG1paeuw5A8LCdq3kBEZfNFEIOhK03aX6D9QJiQMfJQu3DWmtZSL2OXUOeei+YcQ8XC2KYVKYhPxj/SzCNDJzlE0jUc4waqP0XW4rJqdpRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732646555; c=relaxed/simple;
	bh=6cQ8g5agngE9F1hYBInD+R8h3wq9eKkDVcEwJRGfZhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=JhEuieB3QoLNs/YpRfVDEofnsEy72RRnt9Ag4XzSttoCwFZ4IlRyWev49WIqqlzizisEVnZfA6ZiXBSdlneYl3tQV+ywvCMBf7eqd24PVt6yy6S4OCdiB/NpFKp7bJpEVKObkpAND9RiW9TiwidvWN3P8TIBb6R6qcMOPa1otCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q8SyS6lm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q8SyS6lm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732646552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=izF+JieZOO2/P8K937JI/F5JYcLI7jaLo6IhmBqjY8k=;
	b=Q8SyS6lm0MK5KOHLMR0OBk++YwuH6jWz3fXOzELKYSCPbRsFxg1cpd75wjCXBGSSEr7ns0
	+SmSUBG5wpGiQu8X3hN/zTcuOKkKYjb8lUYATy2dU894/8C9HAmQtgh83ID6d39g9NwL5x
	+JxaG1NEwyCzCUGHqEpxwX655HeLLlg=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-461-y_qjndASPiqNN70YkfGetQ-1; Tue,
 26 Nov 2024 13:42:28 -0500
X-MC-Unique: y_qjndASPiqNN70YkfGetQ-1
X-Mimecast-MFC-AGG-ID: y_qjndASPiqNN70YkfGetQ
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C9D591955DC3;
	Tue, 26 Nov 2024 18:42:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 667E71956086;
	Tue, 26 Nov 2024 18:42:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AQIgOdJ855484
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 Nov 2024 13:42:25 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AQIgOX8855483;
	Tue, 26 Nov 2024 13:42:24 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 01/12] libmultipath: signal device with no table in libmp_mapinfo
Date: Tue, 26 Nov 2024 13:42:13 -0500
Message-ID: <20241126184224.855459-2-bmarzins@redhat.com>
In-Reply-To: <20241126184224.855459-1-bmarzins@redhat.com>
References: <20241126184224.855459-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3uLoFo6xTek0A1n1P5fJ2ic9AuMob8D-i0llUuTbcdM_1732646546
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

if libmp_mapinfo() is run on a device that has no active table,
it will now return with a new exit code, DMP_EMPTY, to signal this.
Currently all code paths treat this identically to DMP_NOT_FOUND.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
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

