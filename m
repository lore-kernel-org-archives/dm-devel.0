Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398581CA94
	for <dm-devel@lists.linux.dev>; Wed,  3 Jan 2024 17:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ixm5k4vR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704304608;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X9ONvcfJyLN5our8dTlejS4UNNUUzsB23ZlmBnM/EMg=;
	b=Ixm5k4vRhRQosPOVmx5nD9tewwbSfALbd7UU0IE56aKj2mefrkw2h5+Fl0bRoFVm6dAR7W
	QFatxpmWfZim1xKyITwLBxOpbYwy+caiz0MgX0jol/OhxsYvEqIDMpUBIwUWcuNg1ZcgRm
	N9GphuHZNYugPinqVTrTPvP8SCbm1C4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-50-scSdU737NZikkV24iTWwMQ-1; Wed, 03 Jan 2024 12:56:44 -0500
X-MC-Unique: scSdU737NZikkV24iTWwMQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B3CD88CDCB;
	Wed,  3 Jan 2024 17:56:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F365E2166B31;
	Wed,  3 Jan 2024 17:56:43 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 403HuhvW018469
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 3 Jan 2024 12:56:43 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 403HuhVw018468;
	Wed, 3 Jan 2024 12:56:43 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 01/18] multipathd: remove nopath flushing code from flush_map()
Date: Wed,  3 Jan 2024 12:56:26 -0500
Message-ID: <20240103175643.18438-2-bmarzins@redhat.com>
In-Reply-To: <20240103175643.18438-1-bmarzins@redhat.com>
References: <20240103175643.18438-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Instead of flush_map() handling both user requested flushes and
automatic flushes when the last path has been deleted, make
flush_map_nopaths() handle the automatic flushes itself, since a later
patch will change the behavior of flush_map().

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli_handlers.c |  2 +-
 multipathd/main.c         | 45 +++++++++++++++++----------------------
 multipathd/main.h         |  2 +-
 3 files changed, 21 insertions(+), 28 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index cf448b67..2d90f0fe 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -775,7 +775,7 @@ cli_del_maps (void *v, struct strbuf *reply, void *data)
 
 	condlog(2, "remove maps (operator)");
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
-		if (flush_map(mpp, vecs, 0))
+		if (flush_map(mpp, vecs))
 			ret++;
 		else
 			i--;
diff --git a/multipathd/main.c b/multipathd/main.c
index de1c9058..4a7e0ba1 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -583,12 +583,11 @@ int update_multipath (struct vectors *vecs, char *mapname)
 
 static bool
 flush_map_nopaths(struct multipath *mpp, struct vectors *vecs) {
-	char alias[WWID_SIZE];
+	int r;
 
 	/*
 	 * flush_map will fail if the device is open
 	 */
-	strlcpy(alias, mpp->alias, WWID_SIZE);
 	if (mpp->flush_on_last_del == FLUSH_ENABLED) {
 		condlog(2, "%s Last path deleted, disabling queueing",
 			mpp->alias);
@@ -598,11 +597,20 @@ flush_map_nopaths(struct multipath *mpp, struct vectors *vecs) {
 		mpp->stat_map_failures++;
 		dm_queue_if_no_path(mpp, 0);
 	}
-	if (!flush_map(mpp, vecs, 1)) {
-		condlog(2, "%s: removed map after removing all paths", alias);
-		return true;
+	r = dm_flush_map_nopaths(mpp->alias, mpp->deferred_remove);
+	if (r) {
+		if (r == 1)
+			condlog(0, "%s: can't flush", mpp->alias);
+		else {
+			condlog(2, "%s: devmap deferred remove", mpp->alias);
+			mpp->deferred_remove = DEFERRED_REMOVE_IN_PROGRESS;
+		}
+		return false;
 	}
-	return false;
+
+	condlog(2, "%s: map flushed after removing all paths", mpp->alias);
+	remove_map_and_stop_waiter(mpp, vecs);
+	return true;
 }
 
 static void
@@ -778,30 +786,15 @@ sync_maps_state(vector mpvec)
 }
 
 int
-flush_map(struct multipath * mpp, struct vectors * vecs, int nopaths)
+flush_map(struct multipath * mpp, struct vectors * vecs)
 {
-	int r;
-
-	if (nopaths)
-		r = dm_flush_map_nopaths(mpp->alias, mpp->deferred_remove);
-	else
-		r = dm_flush_map(mpp->alias);
-	/*
-	 * clear references to this map before flushing so we can ignore
-	 * the spurious uevent we may generate with the dm_flush_map call below
-	 */
+	int r = dm_flush_map(mpp->alias);
 	if (r) {
-		if (r == 1)
-			condlog(0, "%s: can't flush", mpp->alias);
-		else {
-			condlog(2, "%s: devmap deferred remove", mpp->alias);
-			mpp->deferred_remove = DEFERRED_REMOVE_IN_PROGRESS;
-		}
+		condlog(0, "%s: can't flush", mpp->alias);
 		return r;
 	}
-	else
-		condlog(2, "%s: map flushed", mpp->alias);
 
+	condlog(2, "%s: map flushed", mpp->alias);
 	remove_map_and_stop_waiter(mpp, vecs);
 
 	return 0;
@@ -956,7 +949,7 @@ ev_remove_map (char * devname, char * alias, int minor, struct vectors * vecs)
 			mpp->alias, mpp->dmi.minor, minor);
 		return 1;
 	}
-	return flush_map(mpp, vecs, 0);
+	return flush_map(mpp, vecs);
 }
 
 static void
diff --git a/multipathd/main.h b/multipathd/main.h
index 194f8776..e050b5c5 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -40,7 +40,7 @@ int ev_add_path (struct path *, struct vectors *, int);
 int ev_remove_path (struct path *, struct vectors *, int);
 int ev_add_map (char *, const char *, struct vectors *);
 int ev_remove_map (char *, char *, int, struct vectors *);
-int flush_map(struct multipath *, struct vectors *, int);
+int flush_map(struct multipath *, struct vectors *);
 
 void handle_signals(bool);
 int refresh_multipath(struct vectors * vecs, struct multipath * mpp);
-- 
2.43.0

