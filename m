Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EF322309
	for <dm-devel@lists.linux.dev>; Thu,  2 Nov 2023 22:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yvz1XcbP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698963312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NzvmRDlJ0zcD26J0/dx4kKp3gsLLhD59vghkJ7iFSiA=;
	b=Yvz1XcbPiZ9Y+JRkfXxyUMULwRvBWWxMsyWoVZZ+8NzsjkuJUVW1ae0TRsmYVo9dDToiYV
	G0wIyUTCFgJHP8c/WrIU3I4MSh6d+betJlvVTSajqmkZU9LjlKMBLAr3w7EKAvIugJSBBg
	m21nYrfSjIkUTdZq4nrAHEhYF6knJn0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-1gDORuSkMr2CEL314yLvwg-1; Thu, 02 Nov 2023 18:15:08 -0400
X-MC-Unique: 1gDORuSkMr2CEL314yLvwg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9238C85A58A;
	Thu,  2 Nov 2023 22:15:08 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C1DE10E65;
	Thu,  2 Nov 2023 22:15:08 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 3A2MF8QW105397
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 2 Nov 2023 18:15:08 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 3A2MF8US105396;
	Thu, 2 Nov 2023 18:15:08 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 5/7] multipathd: move resize_map() to multipathd/main.c
Date: Thu,  2 Nov 2023 18:15:05 -0400
Message-ID: <20231102221507.105371-6-bmarzins@redhat.com>
In-Reply-To: <20231102221507.105371-1-bmarzins@redhat.com>
References: <20231102221507.105371-1-bmarzins@redhat.com>
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

No functional changes.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli_handlers.c | 29 -----------------------------
 multipathd/main.c         | 29 +++++++++++++++++++++++++++++
 multipathd/main.h         |  2 ++
 3 files changed, 31 insertions(+), 29 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 8eb19fdf..a4ed2031 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -813,35 +813,6 @@ cli_reload(void *v, struct strbuf *reply, void *data)
 	return reload_and_sync_map(mpp, vecs);
 }
 
-static int resize_map(struct multipath *mpp, unsigned long long size,
-	       struct vectors * vecs)
-{
-	char *params __attribute__((cleanup(cleanup_charp))) = NULL;
-	unsigned long long orig_size = mpp->size;
-
-	mpp->size = size;
-	update_mpp_paths(mpp, vecs->pathvec);
-	if (setup_map(mpp, &params, vecs) != 0) {
-		condlog(0, "%s: failed to setup map for resize : %s",
-			mpp->alias, strerror(errno));
-		mpp->size = orig_size;
-		return 1;
-	}
-	mpp->action = ACT_RESIZE;
-	mpp->force_udev_reload = 1;
-	if (domap(mpp, params, 1) == DOMAP_FAIL) {
-		condlog(0, "%s: failed to resize map : %s", mpp->alias,
-			strerror(errno));
-		mpp->size = orig_size;
-		return 1;
-	}
-	if (setup_multipath(vecs, mpp) != 0)
-		return 2;
-	sync_map_state(mpp);
-
-	return 0;
-}
-
 static int
 cli_resize(void *v, struct strbuf *reply, void *data)
 {
diff --git a/multipathd/main.c b/multipathd/main.c
index 214ed4ae..3b4c5b09 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1530,6 +1530,35 @@ needs_ro_update(struct multipath *mpp, int ro)
 	return true;
 }
 
+int resize_map(struct multipath *mpp, unsigned long long size,
+	       struct vectors * vecs)
+{
+	char *params __attribute__((cleanup(cleanup_charp))) = NULL;
+	unsigned long long orig_size = mpp->size;
+
+	mpp->size = size;
+	update_mpp_paths(mpp, vecs->pathvec);
+	if (setup_map(mpp, &params, vecs) != 0) {
+		condlog(0, "%s: failed to setup map for resize : %s",
+			mpp->alias, strerror(errno));
+		mpp->size = orig_size;
+		return 1;
+	}
+	mpp->action = ACT_RESIZE;
+	mpp->force_udev_reload = 1;
+	if (domap(mpp, params, 1) == DOMAP_FAIL) {
+		condlog(0, "%s: failed to resize map : %s", mpp->alias,
+			strerror(errno));
+		mpp->size = orig_size;
+		return 1;
+	}
+	if (setup_multipath(vecs, mpp) != 0)
+		return 2;
+	sync_map_state(mpp);
+
+	return 0;
+}
+
 static int
 uev_update_path (struct uevent *uev, struct vectors * vecs)
 {
diff --git a/multipathd/main.h b/multipathd/main.h
index a253d186..8a178c0b 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -52,4 +52,6 @@ int reload_and_sync_map(struct multipath *mpp, struct vectors *vecs);
 void handle_path_wwid_change(struct path *pp, struct vectors *vecs);
 bool check_path_wwid_change(struct path *pp);
 int finish_path_init(struct path *pp, struct vectors * vecs);
+int resize_map(struct multipath *mpp, unsigned long long size,
+	       struct vectors *vecs);
 #endif /* MAIN_H */
-- 
2.41.0

