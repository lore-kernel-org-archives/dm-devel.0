Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B211CA9C
	for <dm-devel@lists.linux.dev>; Wed,  3 Jan 2024 17:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BdWGDlN/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704304607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3JQhRIgfNmm6bH8JEDh0rB/ptYoc8GXWm+PEyrni458=;
	b=BdWGDlN/ckhJ4F/BlkoxulscRmfbwEj9mAjFbWLisrzEDHotUklZchuWjfE3b+tfNLNw08
	vOeM0nOvlFbMWO8HS3/aZrLm0ekNG+ylCwSOjvI5vN5vZdoLnrYvuQvXy0i/SmteOqi+WV
	mriHLOExHJ/CjN5wh+Xq24uAFuvrF4g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-qrVBs3AvO8e74JhL36yRsw-1; Wed, 03 Jan 2024 12:56:44 -0500
X-MC-Unique: qrVBs3AvO8e74JhL36yRsw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8088D101A555;
	Wed,  3 Jan 2024 17:56:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B21B492BE6;
	Wed,  3 Jan 2024 17:56:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 403HuiQi018483
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 3 Jan 2024 12:56:44 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 403Huiqh018482;
	Wed, 3 Jan 2024 12:56:44 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 04/18] multipathd: simplify cli_del_map()
Date: Wed,  3 Jan 2024 12:56:29 -0500
Message-ID: <20240103175643.18438-5-bmarzins@redhat.com>
In-Reply-To: <20240103175643.18438-1-bmarzins@redhat.com>
References: <20240103175643.18438-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

cli_del_map() does a lot of unnecessary work to match the arguments of
ev_remove_map(), of which it is the only caller.  Then ev_remove_map()
does more unnecessary work to verify the arguments passed in. remove
ev_remove_map() and make cli_del_map() get the mpp like the rest of
the client handlers do.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli_handlers.c | 23 ++++++-----------------
 multipathd/main.c         | 21 ---------------------
 multipathd/main.h         |  1 -
 3 files changed, 6 insertions(+), 39 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index dc547be8..9a0cd065 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -742,28 +742,17 @@ cli_del_map (void * v, struct strbuf *reply, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, KEY_MAP);
-	int major, minor;
-	char *alias;
-	int rc;
+	struct multipath *mpp;
 
 	param = convert_dev(param, 0);
 	condlog(2, "%s: remove map (operator)", param);
-	if (dm_get_major_minor(param, &major, &minor) < 0) {
-		condlog(2, "%s: not a device mapper table", param);
-		return 1;
-	}
-	alias = dm_mapname(major, minor);
-	if (!alias) {
-		condlog(2, "%s: mapname not found for %d:%d",
-			param, major, minor);
+
+	mpp = find_mp_by_str(vecs->mpvec, param);
+
+	if (!mpp)
 		return 1;
-	}
-	rc = ev_remove_map(param, alias, minor, vecs);
-	if (rc == 2)
-		append_strbuf_str(reply, "delayed\n");
 
-	free(alias);
-	return rc;
+	return flush_map(mpp, vecs);
 }
 
 static int
diff --git a/multipathd/main.c b/multipathd/main.c
index 6b66a5ee..17468985 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -931,27 +931,6 @@ out:
 	return 0;
 }
 
-/* Called from CLI handler */
-int
-ev_remove_map (char * devname, char * alias, int minor, struct vectors * vecs)
-{
-	struct multipath * mpp;
-
-	mpp = find_mp_by_minor(vecs->mpvec, minor);
-
-	if (!mpp) {
-		condlog(2, "%s: devmap not registered, can't remove",
-			devname);
-		return 1;
-	}
-	if (strcmp(mpp->alias, alias)) {
-		condlog(2, "%s: minor number mismatch (map %d, event %d)",
-			mpp->alias, mpp->dmi.minor, minor);
-		return 1;
-	}
-	return flush_map(mpp, vecs);
-}
-
 static void
 rescan_path(struct udev_device *ud)
 {
diff --git a/multipathd/main.h b/multipathd/main.h
index e050b5c5..4fcd6402 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -39,7 +39,6 @@ int need_to_delay_reconfig (struct vectors *);
 int ev_add_path (struct path *, struct vectors *, int);
 int ev_remove_path (struct path *, struct vectors *, int);
 int ev_add_map (char *, const char *, struct vectors *);
-int ev_remove_map (char *, char *, int, struct vectors *);
 int flush_map(struct multipath *, struct vectors *);
 
 void handle_signals(bool);
-- 
2.43.0

