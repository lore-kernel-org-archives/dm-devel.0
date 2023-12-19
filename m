Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D55E3D0BD
	for <dm-devel@lists.linux.dev>; Tue, 19 Dec 2023 22:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AHYSiNai"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703026316;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qRWw+InDSVkWE8YK7EAPyhNRTXA6dsY/vmef9MEAhmc=;
	b=AHYSiNair7MK0BLXh/Rjj7s9G0o03+XCvcGCiemwy7hWIE1FCssAN5g9cbeA6bCQom0PnM
	0BqzjuExS0B+PqimYrdjYdaDIlqBUVQi6MIdeQmGD13OwwWKlsYgj4Q7Tt74d3mmIWUf8l
	6REhMF3h68yJC7D9To1UXDXEwelrDPw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-47-paNom028MVySkW7LVdzj2Q-1; Tue,
 19 Dec 2023 17:51:52 -0500
X-MC-Unique: paNom028MVySkW7LVdzj2Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 89F1429AA381;
	Tue, 19 Dec 2023 22:51:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 836C61121306;
	Tue, 19 Dec 2023 22:51:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 3BJMpqnh787551
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 19 Dec 2023 17:51:52 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 3BJMpqCF787550;
	Tue, 19 Dec 2023 17:51:52 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v3 4/5] libmultipath: keep track of queueing state in features
Date: Tue, 19 Dec 2023 17:51:50 -0500
Message-ID: <20231219225151.787521-5-bmarzins@redhat.com>
In-Reply-To: <20231219225151.787521-1-bmarzins@redhat.com>
References: <20231219225151.787521-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Make multipathd update mpp->features when in enables or disables
queuing. This patch handles all the cases except failed removes by
dm_suspend_and_flush_map(), which is never called by multipathd.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c   |  4 +---
 libmultipath/devmapper.c   | 23 +++++++++++++++++++----
 libmultipath/devmapper.h   |  2 +-
 libmultipath/structs_vec.c | 10 +++++-----
 multipathd/main.c          |  8 ++++----
 5 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index d8094903..f6813c00 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1240,9 +1240,7 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
 			    mpp->no_path_retry != NO_PATH_RETRY_FAIL)
 				condlog(3, "%s: multipathd not running, unset "
 					"queue_if_no_path feature", mpp->alias);
-			if (!dm_queue_if_no_path(mpp->alias, 0))
-				remove_feature(&mpp->features,
-					       "queue_if_no_path");
+			dm_queue_if_no_path(mpp, 0);
 		}
 
 		if (!is_daemon && mpp->action != ACT_NOTHING)
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 9be82f4e..36b9d274 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -56,6 +56,7 @@ static int dm_cancel_remove_partmaps(const char * mapname);
 static int do_foreach_partmaps(const char * mapname,
 			       int (*partmap_func)(const char *, void *),
 			       void *data);
+static int _dm_queue_if_no_path(const char *mapname, int enable);
 
 #ifndef LIBDM_API_COOKIE
 static inline int dm_task_set_cookie(struct dm_task *dmt, uint32_t *c, int a)
@@ -1085,7 +1086,7 @@ int _dm_flush_map (const char * mapname, int need_sync, int deferred_remove,
 	if (need_suspend &&
 	    dm_get_map(mapname, &mapsize, &params) == DMP_OK &&
 	    strstr(params, "queue_if_no_path")) {
-		if (!dm_queue_if_no_path(mapname, 0))
+		if (!_dm_queue_if_no_path(mapname, 0))
 			queue_if_no_path = 1;
 		else
 			/* Leave queue_if_no_path alone if unset failed */
@@ -1134,7 +1135,7 @@ int _dm_flush_map (const char * mapname, int need_sync, int deferred_remove,
 	} while (retries-- > 0);
 
 	if (queue_if_no_path == 1)
-		dm_queue_if_no_path(mapname, 1);
+		_dm_queue_if_no_path(mapname, 1);
 
 	return 1;
 }
@@ -1252,8 +1253,8 @@ dm_reinstate_path(const char * mapname, char * path)
 	return dm_message(mapname, message);
 }
 
-int
-dm_queue_if_no_path(const char *mapname, int enable)
+static int
+_dm_queue_if_no_path(const char *mapname, int enable)
 {
 	char *message;
 
@@ -1265,6 +1266,20 @@ dm_queue_if_no_path(const char *mapname, int enable)
 	return dm_message(mapname, message);
 }
 
+int dm_queue_if_no_path(struct multipath *mpp, int enable)
+{
+	int r;
+	static const char no_path_retry[] = "queue_if_no_path";
+
+	if ((r = _dm_queue_if_no_path(mpp->alias, enable)) == 0) {
+		if (enable)
+			add_feature(&mpp->features, no_path_retry);
+		else
+			remove_feature(&mpp->features, no_path_retry);
+	}
+	return r;
+}
+
 static int
 dm_groupmsg (const char * msg, const char * mapname, int index)
 {
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 42f8eccd..d1790df5 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -58,7 +58,7 @@ int dm_cancel_deferred_remove(struct multipath *mpp);
 int dm_flush_maps (int need_suspend, int retries);
 int dm_fail_path(const char * mapname, char * path);
 int dm_reinstate_path(const char * mapname, char * path);
-int dm_queue_if_no_path(const char *mapname, int enable);
+int dm_queue_if_no_path(struct multipath *mpp, int enable);
 int dm_switchgroup(const char * mapname, int index);
 int dm_enablegroup(const char * mapname, int index);
 int dm_disablegroup(const char * mapname, int index);
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 66bc264c..665286aa 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -593,7 +593,7 @@ static void leave_recovery_mode(struct multipath *mpp)
 	 */
 	if (recovery && (mpp->no_path_retry == NO_PATH_RETRY_QUEUE ||
 			 mpp->no_path_retry > 0)) {
-		dm_queue_if_no_path(mpp->alias, 1);
+		dm_queue_if_no_path(mpp, 1);
 		condlog(2, "%s: queue_if_no_path enabled", mpp->alias);
 		condlog(1, "%s: Recovered to normal mode", mpp->alias);
 	}
@@ -611,11 +611,11 @@ void set_no_path_retry(struct multipath *mpp)
 		break;
 	case NO_PATH_RETRY_FAIL:
 		if (!mpp->features || is_queueing)
-			dm_queue_if_no_path(mpp->alias, 0);
+			dm_queue_if_no_path(mpp, 0);
 		break;
 	case NO_PATH_RETRY_QUEUE:
 		if (!mpp->features || !is_queueing)
-			dm_queue_if_no_path(mpp->alias, 1);
+			dm_queue_if_no_path(mpp, 1);
 		break;
 	default:
 		if (count_active_paths(mpp) > 0) {
@@ -625,7 +625,7 @@ void set_no_path_retry(struct multipath *mpp)
 			 */
 			if ((!mpp->features || !is_queueing) &&
 			    !mpp->in_recovery)
-				dm_queue_if_no_path(mpp->alias, 1);
+				dm_queue_if_no_path(mpp, 1);
 			leave_recovery_mode(mpp);
 		} else {
 			/*
@@ -636,7 +636,7 @@ void set_no_path_retry(struct multipath *mpp)
 			 */
 			if ((!mpp->features || is_queueing) &&
 			    mpp->in_recovery && mpp->retry_tick == 0)
-				dm_queue_if_no_path(mpp->alias, 0);
+				dm_queue_if_no_path(mpp, 0);
 			if (pathcount(mpp, PATH_PENDING) == 0)
 				enter_recovery_mode(mpp);
 		}
diff --git a/multipathd/main.c b/multipathd/main.c
index c7476ff0..de1c9058 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -596,7 +596,7 @@ flush_map_nopaths(struct multipath *mpp, struct vectors *vecs) {
 		mpp->no_path_retry = NO_PATH_RETRY_FAIL;
 		mpp->disable_queueing = 1;
 		mpp->stat_map_failures++;
-		dm_queue_if_no_path(mpp->alias, 0);
+		dm_queue_if_no_path(mpp, 0);
 	}
 	if (!flush_map(mpp, vecs, 1)) {
 		condlog(2, "%s: removed map after removing all paths", alias);
@@ -930,7 +930,7 @@ uev_remove_map (struct uevent * uev, struct vectors * vecs)
 		goto out;
 	}
 
-	dm_queue_if_no_path(alias, 0);
+	dm_queue_if_no_path(mpp, 0);
 	remove_map_and_stop_waiter(mpp, vecs);
 out:
 	lock_cleanup_pop(vecs->lock);
@@ -2094,7 +2094,7 @@ retry_count_tick(vector mpvec)
 			condlog(4, "%s: Retrying.. No active path", mpp->alias);
 			if(--mpp->retry_tick == 0) {
 				mpp->stat_map_failures++;
-				dm_queue_if_no_path(mpp->alias, 0);
+				dm_queue_if_no_path(mpp, 0);
 				condlog(2, "%s: Disable queueing", mpp->alias);
 			}
 		}
@@ -3260,7 +3260,7 @@ static void cleanup_maps(struct vectors *vecs)
 	put_multipath_config(conf);
 	if (queue_without_daemon == QUE_NO_DAEMON_OFF)
 		vector_foreach_slot(vecs->mpvec, mpp, i)
-			dm_queue_if_no_path(mpp->alias, 0);
+			dm_queue_if_no_path(mpp, 0);
 	remove_maps_and_stop_waiters(vecs);
 	vecs->mpvec = NULL;
 }
-- 
2.41.0

