Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A4C1BD008
	for <dm-devel@lists.linux.dev>; Thu, 31 Oct 2024 18:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730399592; cv=none; b=GUDYX8P4aUK7M9hxoHiOR3jrGcgw0Q95qjz7mHERzmwGRWrMJy5v8/ORNwYviXmQOFyr8if9yPIntuz4cuKjKVkAZO18X4eKFhDVfzi8Ym5rxIpfciUTrlx/Z/m9+mrl7TFWijULYsXtgyUc9bhKD8MRHrXwR4CcKIpHIasl884=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730399592; c=relaxed/simple;
	bh=UJKHLprM+8gQV5Ch6nmFQ78NGWazjzDcyOBOU9VkedE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YGlUC2wVvP4vnbYEXOjrX2heRQN6NrIlxWhsIVT2VG1A4WscT5owTDKLofCRsN5CVMtg+yVVd6AHLay9wK0FCL/6juLa4xKVRtvUoRZ3fXNapud/GvHRM6Cx8V55heLnixVxKgm3dRJkGI4QSrYyMxj0kBas6LZ/FYtgiYlsGoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dvu99SrI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dvu99SrI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730399589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3QjUQDZlr29UX4LD+Rlh5Bcy+6oIhQnoqKVkP/qwYgY=;
	b=dvu99SrIkQjYZkMPv4XqMlOPiG6XW0oLwav2QWDEXBYq2G+WdNRQ6MyYIe4l74EVourMkb
	34pKVVdl2AXUyOKuwqakwO1ZZKEGLiNl3V8lzz+pmbwEqu9K5MjNZi2zhkpUfYHZ/wN8Zn
	cgOBKZRJ1iNgay1tatRk0/r7T7gqpKA=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-531-Lm76npz4Mr6UHOJ0s7zENg-1; Thu,
 31 Oct 2024 14:33:05 -0400
X-MC-Unique: Lm76npz4Mr6UHOJ0s7zENg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6AE061955EE7;
	Thu, 31 Oct 2024 18:33:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DCBFB19560A2;
	Thu, 31 Oct 2024 18:33:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 49VIX2TY391441
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 14:33:02 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 49VIX2D7391440;
	Thu, 31 Oct 2024 14:33:02 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 2/8] libmultipath: check DM UUID earlier in libmp_mapinfo__
Date: Thu, 31 Oct 2024 14:32:55 -0400
Message-ID: <20241031183301.391416-3-bmarzins@redhat.com>
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

Before checking the target details, first check that the device has a
"mpath-" dm uuid prefix. If it doesn't then we can just ignore the
device. This keeps multipath from printing error messages for
non-multipath devices with multiple targets for instance.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index c497c225..41c6ae4d 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -715,6 +715,16 @@ static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info, const char *ma
 		return DMP_NOT_FOUND;
 	}
 
+	if ((info.name && !(name = dm_task_get_name(dmt)))
+	    || ((info.uuid || flags & MAPINFO_CHECK_UUID)
+		&& !(uuid = dm_task_get_uuid(dmt))))
+		return DMP_ERR;
+
+	if (flags & MAPINFO_CHECK_UUID && !is_mpath_uuid(uuid)) {
+		condlog(3, "%s: UUID mismatch: %s", fname__, uuid);
+		return DMP_NO_MATCH;
+	}
+
 	if (info.target || info.status || info.size || flags & MAPINFO_TGT_TYPE__) {
 		if (dm_get_next_target(dmt, NULL, &start, &length,
 				       &target_type, &params) != NULL) {
@@ -740,18 +750,10 @@ static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info, const char *ma
 	 * Check possible error conditions.
 	 * If error is returned, don't touch any output parameters.
 	 */
-	if ((info.name && !(name = dm_task_get_name(dmt)))
-	    || ((info.uuid || flags & MAPINFO_CHECK_UUID)
-		&& !(uuid = dm_task_get_uuid(dmt)))
-	    || (info.status && !(tmp_status = strdup(params)))
+	if ((info.status && !(tmp_status = strdup(params)))
 	    || (info.target && !tmp_target && !(tmp_target = strdup(params))))
 		return DMP_ERR;
 
-	if (flags & MAPINFO_CHECK_UUID && !is_mpath_uuid(uuid)) {
-		condlog(3, "%s: UUID mismatch: %s", fname__, uuid);
-		return DMP_NO_MATCH;
-	}
-
 	if (info.name) {
 		strlcpy(info.name, name, WWID_SIZE);
 		condlog(4, "%s: %s: name: \"%s\"", fname__, map_id, info.name);
-- 
2.46.2

