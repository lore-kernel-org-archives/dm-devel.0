Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BA41CF82
	for <dm-devel@lists.linux.dev>; Wed,  3 Jan 2024 17:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CMrZ6z6W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704304610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RMdKCKGjPkyCzkE7JEj1b1nAr33Ea69zwS0wG2vkrAY=;
	b=CMrZ6z6WXetSeAbr/XZeBwi/qwH1FHY7AhzjRi+QlDSP556U2Lx1TAu5H9+k4A5Ds0rq3z
	TMk+SF7vPkR72DD7qFZJYSHA6K9ryLg3RyoUEFoVBrsfnQJlTO8Do4AvVadj/t382WAo3B
	pQlew3yvRaupOIz54sFZ0nkfcKliY08=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-159-rjXgLc8wNXasBpjgurvkaQ-1; Wed,
 03 Jan 2024 12:56:47 -0500
X-MC-Unique: rjXgLc8wNXasBpjgurvkaQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CFA523C0274A;
	Wed,  3 Jan 2024 17:56:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C99D251D5;
	Wed,  3 Jan 2024 17:56:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 403HukO9018539
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 3 Jan 2024 12:56:46 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 403Hukof018538;
	Wed, 3 Jan 2024 12:56:46 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 18/18] multipathd: sync features on flush_map failure corner case
Date: Wed,  3 Jan 2024 12:56:43 -0500
Message-ID: <20240103175643.18438-19-bmarzins@redhat.com>
In-Reply-To: <20240103175643.18438-1-bmarzins@redhat.com>
References: <20240103175643.18438-1-bmarzins@redhat.com>
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

If dm_suspend_and_flush_map() disables queueing on a device, and then
fails both to flush the device and restore queueing, the device will
still have queue_if_no_path set in mpp->features, but not in reality.
Fix this.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c          | 4 ++--
 libmultipath/devmapper.h          | 1 +
 libmultipath/libmultipath.version | 3 ++-
 multipathd/main.c                 | 2 ++
 4 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index e970e71b..373d2e6c 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1136,8 +1136,8 @@ int _dm_flush_map (const char * mapname, int need_sync, int deferred_remove,
 			sleep(1);
 	} while (retries-- > 0);
 
-	if (queue_if_no_path == 1)
-		_dm_queue_if_no_path(mapname, 1);
+	if (queue_if_no_path == 1 && _dm_queue_if_no_path(mapname, 1) != 0)
+		return DM_FLUSH_FAIL_CANT_RESTORE;
 
 	return DM_FLUSH_FAIL;
 }
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index fa9c6114..a7d66604 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -52,6 +52,7 @@ int dm_is_mpath(const char *);
 enum {
 	DM_FLUSH_OK = 0,
 	DM_FLUSH_FAIL,
+	DM_FLUSH_FAIL_CANT_RESTORE,
 	DM_FLUSH_DEFERRED,
 	DM_FLUSH_BUSY,
 };
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 8ab7c802..df2c0fff 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -43,7 +43,7 @@ LIBMPATHCOMMON_1.0.0 {
 	put_multipath_config;
 };
 
-LIBMULTIPATH_22.0.0 {
+LIBMULTIPATH_23.0.0 {
 global:
 	/* symbols referenced by multipath and multipathd */
 	add_foreign;
@@ -151,6 +151,7 @@ global:
 	_print_multipath_topology;
 	reinstate_paths;
 	remember_wwid;
+	remove_feature;
 	remove_map;
 	remove_map_by_alias;
 	remove_map_callback;
diff --git a/multipathd/main.c b/multipathd/main.c
index ed543caa..13cb404d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -790,6 +790,8 @@ flush_map(struct multipath * mpp, struct vectors * vecs)
 {
 	int r = dm_suspend_and_flush_map(mpp->alias, 0);
 	if (r != DM_FLUSH_OK) {
+		if (DM_FLUSH_FAIL_CANT_RESTORE)
+			remove_feature(&mpp->features, "queue_if_no_path");
 		condlog(0, "%s: can't flush", mpp->alias);
 		return r;
 	}
-- 
2.43.0

