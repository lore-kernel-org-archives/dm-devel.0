Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4902D3D0D0
	for <dm-devel@lists.linux.dev>; Tue, 19 Dec 2023 22:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ckTONMtm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703026318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CYXUQXny4xtBs5nAhKvLaGARd/oqIlrwjJ0js/H05Hg=;
	b=ckTONMtmKbA7Zirw0dah96FssqOmaAbZSID9l20UPcVBW0P8y3pW9DFriHWJ3/uqsMMnVY
	r0CUoc33Oo8GJGuKZSRz/7s2uC9DPZK6qK+qtQQwrjci6rARSieLRaKfYWp9hzagh/c+2C
	T9bQTKZ3gTSpEzL2tE7pCx50gQ1lUgA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-ywRhihb5PkmRar4ZfvY_6A-1; Tue, 19 Dec 2023 17:51:52 -0500
X-MC-Unique: ywRhihb5PkmRar4ZfvY_6A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6167D887E41;
	Tue, 19 Dec 2023 22:51:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5AE1640C6EB9;
	Tue, 19 Dec 2023 22:51:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 3BJMpqGx787547
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 19 Dec 2023 17:51:52 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 3BJMpqH4787546;
	Tue, 19 Dec 2023 17:51:52 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v3 3/5] multipathd: don't modify the multipath device on show commands
Date: Tue, 19 Dec 2023 17:51:49 -0500
Message-ID: <20231219225151.787521-4-bmarzins@redhat.com>
In-Reply-To: <20231219225151.787521-1-bmarzins@redhat.com>
References: <20231219225151.787521-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

The commands to show a multipath device are supposed to return its
current state without updating it. Even when reset is 0,
update_multipath() still can update the device.

To fix this, split __setup_multipath() into two functions:
refresh_multipath(), that updates the table and status, and
setup_multipath(), which works as before but now calls
refresh_multipath(). Make the multipathd show commands call
refresh_multipath() instead of update_multipath().

With the show commands calling refresh_multipath(), all callers of
update_multipath() set the reset argument, so remove it and always call
setup_multipath() from update_multipath().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli_handlers.c | 10 +++++-----
 multipathd/dmevents.c     |  2 +-
 multipathd/main.c         | 25 ++++++++++++++-----------
 multipathd/main.h         |  7 +++----
 multipathd/waiter.c       |  2 +-
 5 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 420d75df..b1dff202 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -76,7 +76,7 @@ static int
 show_map_topology (struct strbuf *reply, struct multipath *mpp,
 		   struct vectors *vecs, const fieldwidth_t *width)
 {
-	if (update_multipath(vecs, mpp->alias, 0))
+	if (refresh_multipath(vecs, mpp))
 		return 1;
 
 	if (snprint_multipath_topology(reply, mpp, 2, width) < 0)
@@ -98,7 +98,7 @@ show_maps_topology (struct strbuf *reply, struct vectors * vecs)
 	foreign_path_layout(p_width);
 
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
-		if (update_multipath(vecs, mpp->alias, 0)) {
+		if (refresh_multipath(vecs, mpp)) {
 			i--;
 			continue;
 		}
@@ -118,7 +118,7 @@ show_maps_json (struct strbuf *reply, struct vectors * vecs)
 	struct multipath * mpp;
 
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
-		if (update_multipath(vecs, mpp->alias, 0)) {
+		if (refresh_multipath(vecs, mpp)) {
 			return 1;
 		}
 	}
@@ -133,7 +133,7 @@ static int
 show_map_json (struct strbuf *reply, struct multipath * mpp,
 	       struct vectors * vecs)
 {
-	if (update_multipath(vecs, mpp->alias, 0))
+	if (refresh_multipath(vecs, mpp))
 		return 1;
 
 	if (snprint_multipath_map_json(reply, mpp) < 0)
@@ -365,7 +365,7 @@ show_maps (struct strbuf *reply, struct vectors *vecs, char *style,
 		return 1;
 
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
-		if (update_multipath(vecs, mpp->alias, 0)) {
+		if (refresh_multipath(vecs, mpp)) {
 			i--;
 			continue;
 		}
diff --git a/multipathd/dmevents.c b/multipathd/dmevents.c
index 3a859691..5657000c 100644
--- a/multipathd/dmevents.c
+++ b/multipathd/dmevents.c
@@ -361,7 +361,7 @@ static int dmevent_loop (void)
 		if (curr_dev.action == EVENT_REMOVE)
 			remove_map_by_alias(curr_dev.name, waiter->vecs);
 		else
-			r = update_multipath(waiter->vecs, curr_dev.name, 1);
+			r = update_multipath(waiter->vecs, curr_dev.name);
 		pthread_cleanup_pop(1);
 
 		if (r) {
diff --git a/multipathd/main.c b/multipathd/main.c
index 230c9d10..c7476ff0 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -500,8 +500,7 @@ remove_maps_and_stop_waiters(struct vectors *vecs)
 	remove_maps(vecs);
 }
 
-int __setup_multipath(struct vectors *vecs, struct multipath *mpp,
-		      int reset)
+int refresh_multipath(struct vectors *vecs, struct multipath *mpp)
 {
 	if (dm_get_info(mpp->alias, &mpp->dmi)) {
 		/* Error accessing table */
@@ -513,20 +512,24 @@ int __setup_multipath(struct vectors *vecs, struct multipath *mpp,
 		condlog(0, "%s: failed to setup multipath", mpp->alias);
 		goto out;
 	}
-
-	if (reset) {
-		set_no_path_retry(mpp);
-		if (VECTOR_SIZE(mpp->paths) != 0)
-			dm_cancel_deferred_remove(mpp);
-	}
-
 	return 0;
 out:
 	remove_map_and_stop_waiter(mpp, vecs);
 	return 1;
 }
 
-int update_multipath (struct vectors *vecs, char *mapname, int reset)
+int setup_multipath(struct vectors *vecs, struct multipath *mpp)
+{
+	if (refresh_multipath(vecs, mpp) != 0)
+		return 1;
+
+	set_no_path_retry(mpp);
+	if (VECTOR_SIZE(mpp->paths) != 0)
+		dm_cancel_deferred_remove(mpp);
+	return 0;
+}
+
+int update_multipath (struct vectors *vecs, char *mapname)
 {
 	struct multipath *mpp;
 	struct pathgroup  *pgp;
@@ -540,7 +543,7 @@ int update_multipath (struct vectors *vecs, char *mapname, int reset)
 		return 2;
 	}
 
-	if (__setup_multipath(vecs, mpp, reset))
+	if (setup_multipath(vecs, mpp))
 		return 1; /* mpp freed in setup_multipath */
 
 	/*
diff --git a/multipathd/main.h b/multipathd/main.h
index 8a178c0b..194f8776 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -43,10 +43,9 @@ int ev_remove_map (char *, char *, int, struct vectors *);
 int flush_map(struct multipath *, struct vectors *, int);
 
 void handle_signals(bool);
-int __setup_multipath (struct vectors * vecs, struct multipath * mpp,
-		       int reset);
-#define setup_multipath(vecs, mpp) __setup_multipath(vecs, mpp, 1)
-int update_multipath (struct vectors *vecs, char *mapname, int reset);
+int refresh_multipath(struct vectors * vecs, struct multipath * mpp);
+int setup_multipath(struct vectors * vecs, struct multipath * mpp);
+int update_multipath(struct vectors *vecs, char *mapname);
 int reload_and_sync_map(struct multipath *mpp, struct vectors *vecs);
 
 void handle_path_wwid_change(struct path *pp, struct vectors *vecs);
diff --git a/multipathd/waiter.c b/multipathd/waiter.c
index 52793698..d1f344b6 100644
--- a/multipathd/waiter.c
+++ b/multipathd/waiter.c
@@ -156,7 +156,7 @@ static int waiteventloop (struct event_thread *waiter)
 		pthread_cleanup_push(cleanup_lock, &waiter->vecs->lock);
 		lock(&waiter->vecs->lock);
 		pthread_testcancel();
-		r = update_multipath(waiter->vecs, waiter->mapname, 1);
+		r = update_multipath(waiter->vecs, waiter->mapname);
 		lock_cleanup_pop(waiter->vecs->lock);
 
 		if (r) {
-- 
2.41.0

