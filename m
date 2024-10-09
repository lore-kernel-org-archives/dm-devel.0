Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC011CD2C
	for <dm-devel@lists.linux.dev>; Wed,  9 Oct 2024 01:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728436541; cv=none; b=TzVlhXMIG3ewTTtftibwyAAuHY8gok+pw11swUh5o64DDxhMWHk+72B520zfZ/x54QZbIA2JPGf/8S+Y/1I52PztP3Nx7um84A0cnxRpDBW7NMHVfJwo3D2GpmY9emrnfWCK/J0Id9UOLTWLAJwfjXEScaIeVYBFgtd3t3gK7iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728436541; c=relaxed/simple;
	bh=ev9hbR9J8QxR3vyZrwK3UV9bUOZUj0BJOpliD5gDO5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VvWzxxpRiig3yKBol0qjrD4uOtfX5IxuDMq7Uv+rAl2wrzJN5cmARTWaLeH9fzbWBqhypvpkEJYcMuA/S5UxPj2WL6PLHp7Bm/tiZ8+10MdAZNfahQV41zJC9sDpbTFlO9iW1eSU4wTvSxq+XaJZEybcBw0XfHL3lJ5CAKYDjpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LVBzZIoI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LVBzZIoI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728436539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mWIDSC0L+QVlymRHw3Vd+wWnbhNrMXo3bWFIYFiW1CA=;
	b=LVBzZIoIE9PcFF7TvcN/es+oqMd5udLk0kQq0jOy68gPGqnNEulkzIl/NOMWcLOLiAsIb8
	vEYaC6LQwYjrpWPy7b/PiyvIdH8ACGSM5uGet1nDZJOQNJbDz/iXVAuDVmEL2i62t8TuMz
	mBdRU7eaW/aylykveh+XYKWN6wgzFm4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-512-sp-zqBpNPqSVaUNfgXZwVg-1; Tue,
 08 Oct 2024 21:15:28 -0400
X-MC-Unique: sp-zqBpNPqSVaUNfgXZwVg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E42761955EE8;
	Wed,  9 Oct 2024 01:15:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8A00C1956052;
	Wed,  9 Oct 2024 01:15:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4991FP7T2381636
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 8 Oct 2024 21:15:25 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4991FP2G2381635;
	Tue, 8 Oct 2024 21:15:25 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v4 07/22] libmultipath: change path_offline to path_sysfs_state
Date: Tue,  8 Oct 2024 21:15:08 -0400
Message-ID: <20241009011523.2381575-8-bmarzins@redhat.com>
In-Reply-To: <20241009011523.2381575-1-bmarzins@redhat.com>
References: <20241009011523.2381575-1-bmarzins@redhat.com>
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

Instead of pp->offline being a binary value, change it to show the
actual result of looking at the sysfs state, and rename it to
pp->sysfs_state. Also change the function name from path_offline() to
path_sysfs_state(). Adapt the tests for pp->offline. This should not
change how multipath currently works. pp->sysfs_state will be used in
future patches.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c          | 65 ++++++++++++++++---------------
 libmultipath/discovery.h          |  2 +-
 libmultipath/libmultipath.version |  2 +-
 libmultipath/print.c              |  2 +-
 libmultipath/structs.h            |  2 +-
 multipathd/main.c                 |  4 +-
 6 files changed, 40 insertions(+), 37 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index e0f46ff2..6ccdfa0b 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1076,18 +1076,16 @@ detect_alua(struct path * pp)
 		return;
 	}
 
-	if (pp->fd == -1 || pp->offline)
+	if (pp->fd == -1 || pp->sysfs_state == PATH_DOWN)
 		return;
 
 	ret = get_target_port_group(pp);
 	if (ret < 0 || get_asymmetric_access_state(pp, ret) < 0) {
-		int state;
-
 		if (ret == -RTPG_INQUIRY_FAILED)
 			return;
 
-		state = path_offline(pp);
-		if (state != PATH_UP)
+		path_sysfs_state(pp);
+		if (pp->sysfs_state != PATH_UP)
 			return;
 
 		pp->tpgs = TPGS_NONE;
@@ -1800,7 +1798,7 @@ common_sysfs_pathinfo (struct path * pp)
 }
 
 int
-path_offline (struct path * pp)
+path_sysfs_state(struct path * pp)
 {
 	struct udev_device * parent;
 	char buff[SCSI_STATE_SIZE];
@@ -1814,7 +1812,8 @@ path_offline (struct path * pp)
 		subsys_type = "nvme";
 	}
 	else {
-		return PATH_UP;
+		pp->sysfs_state = PATH_UP;
+		goto out;
 	}
 
 	parent = pp->udev;
@@ -1827,16 +1826,18 @@ path_offline (struct path * pp)
 
 	if (!parent) {
 		condlog(1, "%s: failed to get sysfs information", pp->dev);
-		return PATH_REMOVED;
+		pp->sysfs_state = PATH_REMOVED;
+		goto out;
 	}
 
 	memset(buff, 0x0, SCSI_STATE_SIZE);
 	err = sysfs_attr_get_value(parent, "state", buff, sizeof(buff));
 	if (!sysfs_attr_value_ok(err, sizeof(buff))) {
 		if (err == -ENXIO)
-			return PATH_REMOVED;
+			pp->sysfs_state = PATH_REMOVED;
 		else
-			return PATH_DOWN;
+			pp->sysfs_state = PATH_DOWN;
+		goto out;
 	}
 
 
@@ -1844,31 +1845,34 @@ path_offline (struct path * pp)
 
 	if (pp->bus == SYSFS_BUS_SCSI) {
 		if (!strncmp(buff, "offline", 7)) {
-			pp->offline = 1;
-			return PATH_DOWN;
+			pp->sysfs_state = PATH_DOWN;
+			goto out;
+		} else if (!strncmp(buff, "blocked", 7) ||
+			   !strncmp(buff, "quiesce", 7)) {
+			pp->sysfs_state = PATH_PENDING;
+			goto out;
+		} else if (!strncmp(buff, "running", 7)) {
+			pp->sysfs_state = PATH_UP;
+			goto out;
 		}
-		pp->offline = 0;
-		if (!strncmp(buff, "blocked", 7) ||
-		    !strncmp(buff, "quiesce", 7))
-			return PATH_PENDING;
-		else if (!strncmp(buff, "running", 7))
-			return PATH_UP;
 
 	}
 	else if (pp->bus == SYSFS_BUS_NVME) {
 		if (!strncmp(buff, "dead", 4)) {
-			pp->offline = 1;
-			return PATH_DOWN;
+			pp->sysfs_state = PATH_DOWN;
+			goto out;
+		} else if (!strncmp(buff, "new", 3) ||
+			   !strncmp(buff, "deleting", 8)) {
+			pp->sysfs_state = PATH_PENDING;
+			goto out;
+		} else if (!strncmp(buff, "live", 4)) {
+			pp->sysfs_state = PATH_UP;
+			goto out;
 		}
-		pp->offline = 0;
-		if (!strncmp(buff, "new", 3) ||
-		    !strncmp(buff, "deleting", 8))
-			return PATH_PENDING;
-		else if (!strncmp(buff, "live", 4))
-			return PATH_UP;
 	}
-
-	return PATH_DOWN;
+	pp->sysfs_state = PATH_DOWN;
+out:
+	return pp->sysfs_state;
 }
 
 static int
@@ -2052,8 +2056,7 @@ get_prio (struct path * pp)
 	old_prio = pp->priority;
 	pp->priority = prio_getprio(p, pp);
 	if (pp->priority < 0) {
-		/* this changes pp->offline, but why not */
-		int state = path_offline(pp);
+		int state = path_sysfs_state(pp);
 
 		if (state == PATH_DOWN || state == PATH_PENDING) {
 			pp->priority = old_prio;
@@ -2424,7 +2427,7 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 			return PATHINFO_SKIPPED;
 	}
 
-	path_state = path_offline(pp);
+	path_state = path_sysfs_state(pp);
 	if (path_state == PATH_REMOVED)
 		goto blank;
 	else if (mask & DI_NOIO) {
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index f3e0c618..7d42eae5 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -33,7 +33,7 @@ struct config;
 int path_discovery (vector pathvec, int flag);
 int path_get_tpgs(struct path *pp); /* This function never returns TPGS_UNDEF */
 int do_tur (char *);
-int path_offline (struct path *);
+int path_sysfs_state(struct path *);
 int start_checker(struct path * pp, struct config * conf, int daemon,
 		  int state);
 int get_state(struct path * pp);
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index bb34d9e8..6439d3a7 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -146,7 +146,7 @@ global:
 	path_discovery;
 	path_get_tpgs;
 	pathinfo;
-	path_offline;
+	path_sysfs_state;
 	print_all_paths;
 	print_foreign_topology;
 	print_multipath_topology__;
diff --git a/libmultipath/print.c b/libmultipath/print.c
index e536c5c0..00c03ace 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -514,7 +514,7 @@ snprint_offline (struct strbuf *buff, const struct path * pp)
 {
 	if (!pp || !pp->mpp)
 		return append_strbuf_str(buff, "unknown");
-	else if (pp->offline)
+	else if (pp->sysfs_state == PATH_DOWN)
 		return append_strbuf_str(buff, "offline");
 	else
 		return append_strbuf_str(buff, "running");
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 074faca6..d8231e95 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -362,7 +362,7 @@ struct path {
 	unsigned int tick;
 	unsigned int pending_ticks;
 	int bus;
-	int offline;
+	int sysfs_state;
 	int state;
 	int dmstate;
 	int chkrstate;
diff --git a/multipathd/main.c b/multipathd/main.c
index 4f752adb..33a57041 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -96,7 +96,7 @@ void * mpath_pr_event_handler_fn (void * );
 do {								\
 	if (pp->mpp && checker_selected(&pp->checker) &&	\
 	    lvl <= libmp_verbosity) {					\
-		if (pp->offline)				\
+		if (pp->sysfs_state == PATH_DOWN)		\
 			condlog(lvl, "%s: %s - path offline",	\
 				pp->mpp->alias, pp->dev);	\
 		else  {						\
@@ -2320,7 +2320,7 @@ check_path_state(struct path *pp)
 	int newstate;
 	struct config *conf;
 
-	newstate = path_offline(pp);
+	newstate = path_sysfs_state(pp);
 	if (newstate == PATH_UP) {
 		conf = get_multipath_config();
 		pthread_cleanup_push(put_multipath_config, conf);
-- 
2.45.0

