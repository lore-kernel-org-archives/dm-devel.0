Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBAA1CA93
	for <dm-devel@lists.linux.dev>; Wed,  3 Jan 2024 17:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VsVf2eQR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704304606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yhxCBgSLZHPX3qlWPiq1/Uy2w4KV5yaLt7JUXumxbS8=;
	b=VsVf2eQRR3eRvufmdyYTxEK+25XnMJGlGIHES7xTr+52JuWjDYRNCWZJ67VQUPl5307Yrm
	jHo5aXKYwjQ6+g7vLmyAd3YEK6BHovVDp7dB9bwbd7c9oMJrj7jHnj8R+I5Y97Xt2dSNHf
	92wZa+sblKBIiTnGvbDYVtZvMY5K6Gw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-62-qWY9kGBLPe-KIdAdQkIOSw-1; Wed,
 03 Jan 2024 12:56:45 -0500
X-MC-Unique: qWY9kGBLPe-KIdAdQkIOSw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A85DD3806736;
	Wed,  3 Jan 2024 17:56:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A1A6CC15968;
	Wed,  3 Jan 2024 17:56:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 403Hui3J018487
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 3 Jan 2024 12:56:44 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 403Huigu018486;
	Wed, 3 Jan 2024 12:56:44 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 05/18] libmultipath: make _dm_flush_map() return an enum
Date: Wed,  3 Jan 2024 12:56:30 -0500
Message-ID: <20240103175643.18438-6-bmarzins@redhat.com>
In-Reply-To: <20240103175643.18438-1-bmarzins@redhat.com>
References: <20240103175643.18438-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

A future patch will add an additional return code, so make this an enum
instead of just using numbers.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 18 +++++++++---------
 libmultipath/devmapper.h |  7 +++++++
 multipath/main.c         |  2 +-
 multipathd/main.c        | 12 ++++++------
 4 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 1646110b..f5b4f4c0 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1071,7 +1071,7 @@ int _dm_flush_map (const char * mapname, int need_sync, int deferred_remove,
 	char *params = NULL;
 
 	if (dm_is_mpath(mapname) != 1)
-		return 0; /* nothing to do */
+		return DM_FLUSH_OK; /* nothing to do */
 
 	/* if the device currently has no partitions, do not
 	   run kpartx on it if you fail to delete it */
@@ -1081,7 +1081,7 @@ int _dm_flush_map (const char * mapname, int need_sync, int deferred_remove,
 	/* If you aren't doing a deferred remove, make sure that no
 	 * devices are in use */
 	if (!do_deferred(deferred_remove) && partmap_in_use(mapname, NULL))
-			return 1;
+			return DM_FLUSH_FAIL;
 
 	if (need_suspend &&
 	    dm_get_map(mapname, &mapsize, &params) == DMP_OK &&
@@ -1096,11 +1096,11 @@ int _dm_flush_map (const char * mapname, int need_sync, int deferred_remove,
 	params = NULL;
 
 	if (dm_remove_partmaps(mapname, need_sync, deferred_remove))
-		return 1;
+		return DM_FLUSH_FAIL;
 
 	if (!do_deferred(deferred_remove) && dm_get_opencount(mapname)) {
 		condlog(2, "%s: map in use", mapname);
-		return 1;
+		return DM_FLUSH_FAIL;
 	}
 
 	do {
@@ -1114,14 +1114,14 @@ int _dm_flush_map (const char * mapname, int need_sync, int deferred_remove,
 			    && dm_map_present(mapname)) {
 				condlog(4, "multipath map %s remove deferred",
 					mapname);
-				return 2;
+				return DM_FLUSH_DEFERRED;
 			}
 			condlog(4, "multipath map %s removed", mapname);
-			return 0;
+			return DM_FLUSH_OK;
 		} else if (dm_is_mpath(mapname) != 1) {
 			condlog(4, "multipath map %s removed externally",
 				mapname);
-			return 0; /*we raced with someone else removing it */
+			return DM_FLUSH_OK; /* raced. someone else removed it */
 		} else {
 			condlog(2, "failed to remove multipath map %s",
 				mapname);
@@ -1137,7 +1137,7 @@ int _dm_flush_map (const char * mapname, int need_sync, int deferred_remove,
 	if (queue_if_no_path == 1)
 		_dm_queue_if_no_path(mapname, 1);
 
-	return 1;
+	return DM_FLUSH_FAIL;
 }
 
 #ifdef LIBDM_API_DEFERRED
@@ -1184,7 +1184,7 @@ int dm_flush_maps (int retries)
 		goto out;
 
 	do {
-		r |= dm_suspend_and_flush_map(names->name, retries);
+		r |= dm_suspend_and_flush_map(names->name, retries) != DM_FLUSH_OK;
 		next = names->next;
 		names = (void *) names + next;
 	} while (next);
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 1eacd966..9d484dab 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -48,6 +48,13 @@ int dm_get_map(const char *, unsigned long long *, char **);
 int dm_get_status(const char *, char **);
 int dm_type(const char *, char *);
 int dm_is_mpath(const char *);
+
+enum {
+	DM_FLUSH_OK = 0,
+	DM_FLUSH_FAIL,
+	DM_FLUSH_DEFERRED,
+};
+
 int _dm_flush_map (const char *, int, int, int, int);
 int dm_flush_map_nopaths(const char * mapname, int deferred_remove);
 #define dm_flush_map(mapname) _dm_flush_map(mapname, 1, 0, 0, 0)
diff --git a/multipath/main.c b/multipath/main.c
index c51884f2..00302087 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -1070,7 +1070,7 @@ main (int argc, char *argv[])
 			r = RTVL_FAIL;
 			goto out;
 		}
-		r = dm_suspend_and_flush_map(dev, retries) ?
+		r = (dm_suspend_and_flush_map(dev, retries) != DM_FLUSH_OK) ?
 		    RTVL_FAIL : RTVL_OK;
 		goto out;
 	}
diff --git a/multipathd/main.c b/multipathd/main.c
index 17468985..ed543caa 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -598,13 +598,13 @@ flush_map_nopaths(struct multipath *mpp, struct vectors *vecs) {
 		dm_queue_if_no_path(mpp, 0);
 	}
 	r = dm_flush_map_nopaths(mpp->alias, mpp->deferred_remove);
-	if (r) {
-		if (r == 1)
-			condlog(0, "%s: can't flush", mpp->alias);
-		else {
+	if (r != DM_FLUSH_OK) {
+		if (r == DM_FLUSH_DEFERRED) {
 			condlog(2, "%s: devmap deferred remove", mpp->alias);
 			mpp->deferred_remove = DEFERRED_REMOVE_IN_PROGRESS;
 		}
+		else
+			condlog(0, "%s: can't flush", mpp->alias);
 		return false;
 	}
 
@@ -746,7 +746,7 @@ coalesce_maps(struct vectors *vecs, vector nmpv)
 			 * remove all current maps not allowed by the
 			 * current configuration
 			 */
-			if (dm_flush_map(ompp->alias)) {
+			if (dm_flush_map(ompp->alias) != DM_FLUSH_OK) {
 				condlog(0, "%s: unable to flush devmap",
 					ompp->alias);
 				/*
@@ -789,7 +789,7 @@ int
 flush_map(struct multipath * mpp, struct vectors * vecs)
 {
 	int r = dm_suspend_and_flush_map(mpp->alias, 0);
-	if (r) {
+	if (r != DM_FLUSH_OK) {
 		condlog(0, "%s: can't flush", mpp->alias);
 		return r;
 	}
-- 
2.43.0

