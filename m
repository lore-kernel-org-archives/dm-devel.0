Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFFC1822FB
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 18:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721239876; cv=none; b=caf57HxQGAFb//yyReu8QH7cb+tPo9msofWDQs0W/DgwESIoAgBWOyaxjoa0IySd7XLkrRz0x2kSesc3nJgBag95Af+5CyBTUSF8bhphBmtLlbH0KlMu3b/tcSdtGzfxpPKXLqm/R0eIhO4zDHRJ3FvpvhPMuJPWTfa0tWTr1ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721239876; c=relaxed/simple;
	bh=fx7/wiQqFhNOWMu/KDzd2KbfocCTD66xj/vkXbmtAsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ep+4V/jxKHxOvgReceL5zp2K96xODXXM6DarmKtx0bTiCI7O+yJwIET8zKjkhBjM+CPtrem6ba4i9ZqYCIXoagX5Orv6LBxDiaFe3uWuPc+S8hIlIAVq7bwEnPcJuaK7Re3ERLVihJzdhJoi2khNi3Rob74go0nXeS0M01SeH84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I1VjcKU8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I1VjcKU8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721239873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R94oiu0lT9EzxNJSxBvPmT0GZScgl94iY0wBgdI0ZH0=;
	b=I1VjcKU8iv2Diju58YnfLUlacKu12PQnSf+yY64zacRV/H1hjF8aByOwPVxUBA4hLN/sIK
	LUXwAV+k3OJ+I24eUB0QqfohEd+t+cGO6mufx4iqL4Ei00xsBVF5vaq+2UnqzvyQ4KQOw1
	JsrIa+1eJgrvUaO7R0xexf2EVM1KxwI=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-155-19FY-2xEOfWzclM-xSI4pQ-1; Wed,
 17 Jul 2024 14:11:10 -0400
X-MC-Unique: 19FY-2xEOfWzclM-xSI4pQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7BBD21955D42;
	Wed, 17 Jul 2024 18:11:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D00FD1955F3B;
	Wed, 17 Jul 2024 18:11:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46HIB7qT2173564
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 17 Jul 2024 14:11:07 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46HIB78N2173563;
	Wed, 17 Jul 2024 14:11:07 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 02/20] multipathd: make cli_add_map() handle adding maps by WWID correctly
Date: Wed, 17 Jul 2024 14:10:48 -0400
Message-ID: <20240717181106.2173527-3-bmarzins@redhat.com>
In-Reply-To: <20240717181106.2173527-1-bmarzins@redhat.com>
References: <20240717181106.2173527-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

cli_add_map() runs filter_wwid() on the input param as if it were a
WWID, but dm_get_major_minor() will never find the multipath device if
the user actually passes in a WWID. To handle this case, call
get_refwwid() early in the function, and use dm_find_map_by_wwid() to
check if the map exists, and find its alias and minor number.

Also, the do/while loop is unnecessarily confusing and only avoids one
repeated function call. Remove it to simplify cli_add_map().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/libmultipath.version |  5 +++
 multipathd/cli_handlers.c         | 60 +++++++++++--------------------
 2 files changed, 25 insertions(+), 40 deletions(-)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 959f675e..d074032b 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -242,3 +242,8 @@ global:
 local:
 	*;
 };
+
+LIBMULTIPATH_25.1.0 {
+global:
+	dm_find_map_by_wwid;
+} LIBMULTIPATH_25.0.0;
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 0106213e..772a45d0 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -697,57 +697,37 @@ cli_add_map (void * v, struct strbuf *reply, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, KEY_MAP);
-	int major = -1, minor = -1;
 	char dev_path[FILE_NAME_SIZE];
-	char *refwwid;
-	char *alias __attribute__((cleanup(cleanup_charp))) = NULL;
-	int rc, count = 0;
-	struct config *conf;
-	int invalid = 0;
+	char *refwwid __attribute__((cleanup(cleanup_charp))) = NULL;
+	char alias[WWID_SIZE];
+	int rc;
+	struct dm_info dmi;
 
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
+	if (dm_find_map_by_wwid(refwwid, alias, &dmi) != DMP_OK) {
+		condlog(3, "%s: map not present. creating", param);
+		if (coalesce_paths(vecs, NULL, refwwid, FORCE_RELOAD_NONE,
+				   CMD_NONE) != CP_OK) {
+			condlog(2, "%s: coalesce_paths failed", param);
+			return 1;
+		}
+		if (dm_find_map_by_wwid(refwwid, alias, &dmi) != DMP_OK) {
+			condlog(2, "%s: failed getting map", param);
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
-	if (!alias) {
-		condlog(2, "%s: add map failed", param);
-		return 1;
 	}
+	sprintf(dev_path, "dm-%u", dmi.minor);
 	rc = ev_add_map(dev_path, alias, vecs);
 	return rc;
 }
-- 
2.45.0

