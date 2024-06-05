Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8A6175562
	for <dm-devel@lists.linux.dev>; Wed,  5 Jun 2024 23:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717629782; cv=none; b=OFjsLFB5x2T0G7lhOpnZAvyiDq2IvEh2RYeICoDALz0Facqsq9zP3aaDzRpThouFGe+3sVMo2E7a4/Ws/ryiSzmj9HhSuvtf7szgKYrWNObfzsqVy8vkpqqaqndVFqadQ64Fdz2o8n90ChfwFofCpc/urCT8A065KmRgfHgjYQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717629782; c=relaxed/simple;
	bh=aIiLz688TBy1j0iI27UEFPDEslJY71PnWegaEiOFDC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TPADkRMp/5cx9beSHls71BboIB5CZGJS6Tm2GBM7/PbVGpozpaXMlHqriHdF2kfzmt7vaFt1hMPjZqQtyhttJnAU9L7i2HhfW4DO9INuHVgFa84oXarzpJTMVOfY7726DIeP8uPEYPQTOhZyLVKPw27Gv+4gmVdS+O2CfhucwTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mh0EaQZI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mh0EaQZI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717629779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SrFPtng+Uc7p8AeKTVTdTn+DHwPnoDlhSj/zte/zVMQ=;
	b=Mh0EaQZIhxXWE/yjwQj2UT9AWwG5EZSoB3Mm7UXH6sPXth+9++1tDZOsMXtNNpRxvdrokT
	amjtRT02mwmi+9ZMO0ypWDsMbzc0s2tR8SSrWGBgFKAgeq+MCUlu+ZFHxi3x2uktEE3ipe
	wQgizYCtz3TKqgiaSgKsKNfKjx2dgVU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-35-FwwUCivpNEKSIJmB03KGhw-1; Wed,
 05 Jun 2024 19:22:56 -0400
X-MC-Unique: FwwUCivpNEKSIJmB03KGhw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 190C31C0512A;
	Wed,  5 Jun 2024 23:22:56 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1358BFF5A;
	Wed,  5 Jun 2024 23:22:56 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 455NMtpL623334
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 5 Jun 2024 19:22:55 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 455NMt2L623333;
	Wed, 5 Jun 2024 19:22:55 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 7/7] multipathd: make cli_add_map() handle adding maps by WWID correctly
Date: Wed,  5 Jun 2024 19:22:54 -0400
Message-ID: <20240605232254.623290-8-bmarzins@redhat.com>
In-Reply-To: <20240605232254.623290-1-bmarzins@redhat.com>
References: <20240605232254.623290-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

cli_add_map() runs filter_wwid() on the input param as if it were a
WWID, but dm_get_major_minor() will never find the multipath device if
the user actually passes in a WWID. To handle this case, call
get_refwwid() early in the function, and use dm_map_present_by_uuid() to
check if the map exists, and find its alias and minor number.

Also, the do/while loop is unnecessarily confusing and only avoids one
repeated function call. Remove it to simplify the cli_add_map().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/libmultipath.version |  5 +++
 multipathd/cli_handlers.c         | 57 +++++++++++--------------------
 2 files changed, 25 insertions(+), 37 deletions(-)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 600de394..fa78bf93 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -241,3 +241,8 @@ global:
 local:
 	*;
 };
+
+LIBMULTIPATH_25.1.0 {
+global:
+	dm_map_present_by_uuid;
+} LIBMULTIPATH_25.0.0;
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 34e0147e..6016c51b 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -697,57 +697,40 @@ cli_add_map (void * v, struct strbuf *reply, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, KEY_MAP);
-	int major = -1, minor = -1;
 	char dev_path[FILE_NAME_SIZE];
-	char *refwwid;
+	char *refwwid __attribute__((cleanup(cleanup_charp))) = NULL;
 	char *alias __attribute__((cleanup(cleanup_charp))) = NULL;
-	int rc, count = 0;
-	struct config *conf;
-	int invalid = 0;
+	int rc, minor = -1;
 
 	param = convert_dev(param, 0);
 	condlog(2, "%s: add map (operator)", param);
 
-	conf = get_multipath_config();
-	pthread_cleanup_push(put_multipath_config, conf);
-	if (filter_wwid(conf->blist_wwid, conf->elist_wwid, param, NULL) > 0)
-		invalid = 1;
-	pthread_cleanup_pop(1);
-	if (invalid) {
+	if (get_refwwid(CMD_NONE, param, DEV_DEVMAP, vecs->pathvec, &refwwid) ==
+	    PATHINFO_SKIPPED) {
 		append_strbuf_str(reply, "blacklisted\n");
 		condlog(2, "%s: map blacklisted", param);
 		return 1;
+	} else if (!refwwid) {
+		condlog(2, "%s: unknown map.", param);
+		return -ENODEV;
 	}
-	do {
-		if (dm_get_major_minor(param, &major, &minor) < 0)
-			condlog(count ? 2 : 3,
-				"%s: not a device mapper table", param);
-		else {
-			sprintf(dev_path, "dm-%d", minor);
-			alias = dm_mapname(major, minor);
+	if (dm_map_present_by_uuid(refwwid, &alias, &minor) <= 0) {
+		condlog(3, "%s: map not present. creating", param);
+		if (coalesce_paths(vecs, NULL, refwwid, FORCE_RELOAD_NONE,
+				   CMD_NONE) != CP_OK) {
+			condlog(2, "%s: coalesce_paths failed", param);
+			return 1;
 		}
-		/*if there is no mapname found, we first create the device*/
-		if (!alias && !count) {
-			condlog(3, "%s: mapname not found for %d:%d",
-				param, major, minor);
-			get_refwwid(CMD_NONE, param, DEV_DEVMAP,
-				    vecs->pathvec, &refwwid);
-			if (refwwid) {
-				if (coalesce_paths(vecs, NULL, refwwid,
-						   FORCE_RELOAD_NONE, CMD_NONE)
-				    != CP_OK)
-					condlog(2, "%s: coalesce_paths failed",
-									param);
-				free(refwwid);
-			}
-		} /*we attempt to create device only once*/
-		count++;
-	} while (!alias && (count < 2));
-
+		if (dm_map_present_by_uuid(refwwid, &alias, &minor) <= 0) {
+			condlog(2, "%s: failed getting map", param);
+			return 1;
+		}
+	}
 	if (!alias) {
-		condlog(2, "%s: add map failed", param);
+		condlog(2, "%s: failed getting alias", param);
 		return 1;
 	}
+	sprintf(dev_path, "dm-%d", minor);
 	rc = ev_add_map(dev_path, alias, vecs);
 	return rc;
 }
-- 
2.45.0

