Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C349B1FC7CF
	for <dm-devel@lists.linux.dev>; Wed,  2 Apr 2025 23:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743635610; cv=none; b=c+5z7ig3CjjTceEwewiD7Un+osG9sjCJhDTv8VtXBMgS4UhlpgElMWnnwjE8o9NbEWGmplkBhiCqFu4Yx0QuW6jYSXy4f+ECc5s8JTkBoM82W7YMiA5kwpryidPhfwDYdtCyLSBdf/isJKA9JmDYHfLS2Nfu9ZI4nfKcShuO1sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743635610; c=relaxed/simple;
	bh=i74hoPYcBppYYn0DPKu859Gsq5aH8jaLjQwuda9lWS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=EGeLBvwDJFBvfeYCzWDE5fyO2UfSmF+8W7aVfrJe8fGyoGIsiqp12O66sWkhXxna+t1MNyvbUYqKVlrUbIEFXSWFI/l92sstRVWoJcj99LdLRAn/VhzH1bxwec2Ipke94Xx7vkNHu7KGu0OBU/G1nwAsrBQS5p3xOjPXeDIotEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MYVuUsZZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MYVuUsZZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743635607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OCRjFYwMvpep2paRLnHKGpRcYXVdAvcNuotznJiNi+o=;
	b=MYVuUsZZF0WOAWFMbBq3Vulw4TelVV44hB97RGVHlhu9jNVc5PRps2P42RDiHfXXbRKH2g
	0bJGAJb/AKlieu/vJMbVjA+OIi/urUMFoqKHG4KkOibP0wTCsJ23b8m3OzUMzV5lRqohXD
	rIwZlwY5BNORBLEP2cfbCxRI7POn9t4=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-696-OtxEzTgTNliMqNK96ukeQg-1; Wed,
 02 Apr 2025 19:13:26 -0400
X-MC-Unique: OtxEzTgTNliMqNK96ukeQg-1
X-Mimecast-MFC-AGG-ID: OtxEzTgTNliMqNK96ukeQg_1743635605
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3BBBE1956048;
	Wed,  2 Apr 2025 23:13:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C686119560AD;
	Wed,  2 Apr 2025 23:13:24 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 532NDN7g3044089
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 2 Apr 2025 19:13:23 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 532NDNZW3044088;
	Wed, 2 Apr 2025 19:13:23 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v3 3/4] multipathd: re-add paths skipped because they were offline
Date: Wed,  2 Apr 2025 19:13:21 -0400
Message-ID: <20250402231322.3044064-4-bmarzins@redhat.com>
In-Reply-To: <20250402231322.3044064-1-bmarzins@redhat.com>
References: <20250402231322.3044064-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PH5BqXYObrIuACOEVeUFW-HlKDwOcGp1IEsBHiLmMZY_1743635605
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When a new device is added by the multipath command, multipathd may know
of other paths that cannot be added to the device because they are
currently offline. Instead of ignoring these paths, multipathd will now
re-add them when they come back online. To do this, it multipathd needs
a new path variable add_when_online, to track devices that could not be
added to an existing multipath device because they were offline. These
paths are handled along with the other uninitialized paths.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/libmultipath.version |  5 +++
 libmultipath/print.c              |  5 ++-
 libmultipath/structs.h            |  1 +
 libmultipath/structs_vec.c        |  5 +++
 multipathd/main.c                 | 58 +++++++++++++++++++++++++++++--
 multipathd/multipathd.8.in        |  5 +--
 6 files changed, 74 insertions(+), 5 deletions(-)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 9fda717c..a6718355 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -245,3 +245,8 @@ global:
 local:
 	*;
 };
+
+LIBMULTIPATH_29.1.0 {
+global:
+	can_recheck_wwid;
+} LIBMULTIPATH_29.0.0;
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 00c03ace..019ae56f 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -658,8 +658,11 @@ snprint_path_serial (struct strbuf *buff, const struct path * pp)
 static int
 snprint_path_mpp (struct strbuf *buff, const struct path * pp)
 {
-	if (!pp->mpp)
+	if (!pp->mpp) {
+		if (pp->add_when_online)
+			return append_strbuf_str(buff, "[offline]");
 		return append_strbuf_str(buff, "[orphan]");
+	}
 	if (!pp->mpp->alias)
 		return append_strbuf_str(buff, "[unknown]");
 	return snprint_str(buff, pp->mpp->alias);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 28de9a7f..39d1c71c 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -413,6 +413,7 @@ struct path {
 	int eh_deadline;
 	enum check_path_states is_checked;
 	bool can_use_env_uid;
+	bool add_when_online;
 	unsigned int checker_timeout;
 	/* configlet pointers */
 	vector hwe;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index f6407e12..663c9053 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -389,6 +389,9 @@ static void orphan_paths(vector pathvec, struct multipath *mpp, const char *reas
 				free_path(pp);
 			} else
 				orphan_path(pp, reason);
+		} else if (pp->add_when_online &&
+			   strncmp(mpp->wwid, pp->wwid, WWID_SIZE) == 0) {
+			pp->add_when_online = false;
 		}
 	}
 }
@@ -595,6 +598,8 @@ void sync_paths(struct multipath *mpp, vector pathvec)
 		found = 0;
 		vector_foreach_slot(mpp->pg, pgp, j) {
 			if (find_slot(pgp->paths, (void *)pp) != -1) {
+				if (pp->add_when_online)
+					pp->add_when_online = false;
 				found = 1;
 				break;
 			}
diff --git a/multipathd/main.c b/multipathd/main.c
index 7aaae773..61ebf316 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -644,11 +644,45 @@ pr_register_active_paths(struct multipath *mpp)
 	}
 }
 
+static void
+save_offline_paths(const struct multipath *mpp, vector offline_paths)
+{
+	unsigned int i, j;
+	struct path *pp;
+	struct pathgroup *pgp;
+
+	vector_foreach_slot (mpp->pg, pgp, i)
+		vector_foreach_slot (pgp->paths, pp, j)
+			if (pp->initialized == INIT_OK &&
+			    pp->sysfs_state == PATH_DOWN)
+				/* ignore failures storing the paths. */
+				store_path(offline_paths, pp);
+}
+
+static void
+handle_orphaned_offline_paths(vector offline_paths)
+{
+	unsigned int i;
+	struct path *pp;
+
+	vector_foreach_slot (offline_paths, pp, i)
+		if (pp->mpp == NULL)
+			pp->add_when_online = true;
+}
+
+static void
+cleanup_reset_vec(struct vector_s **v)
+{
+	vector_reset(*v);
+}
+
 static int
 update_map (struct multipath *mpp, struct vectors *vecs, int new_map)
 {
 	int retries = 3;
 	char *params __attribute__((cleanup(cleanup_charp))) = NULL;
+	struct vector_s offline_paths_vec = { .allocated = 0 };
+	vector offline_paths __attribute__((cleanup(cleanup_reset_vec))) = &offline_paths_vec;
 
 retry:
 	condlog(4, "%s: updating new map", mpp->alias);
@@ -685,6 +719,9 @@ fail:
 		return 1;
 	}
 
+	if (new_map && retries < 0)
+		save_offline_paths(mpp, offline_paths);
+
 	if (setup_multipath(vecs, mpp))
 		return 1;
 
@@ -695,6 +732,9 @@ fail:
 	if (mpp->prflag == PRFLAG_SET)
 		pr_register_active_paths(mpp);
 
+	if (VECTOR_SIZE(offline_paths) != 0)
+		handle_orphaned_offline_paths(offline_paths);
+
 	if (retries < 0)
 		condlog(0, "%s: failed reload in new map update", mpp->alias);
 	return 0;
@@ -2793,7 +2833,8 @@ check_uninitialized_path(struct path * pp, unsigned int ticks)
 	struct config *conf;
 
 	if (pp->initialized != INIT_NEW && pp->initialized != INIT_FAILED &&
-	    pp->initialized != INIT_MISSING_UDEV)
+	    pp->initialized != INIT_MISSING_UDEV &&
+	    !(pp->initialized == INIT_OK && pp->add_when_online))
 		return CHECK_PATH_SKIPPED;
 
 	if (pp->tick)
@@ -2849,7 +2890,8 @@ update_uninitialized_path(struct vectors * vecs, struct path * pp)
 	struct config *conf;
 
 	if (pp->initialized != INIT_NEW && pp->initialized != INIT_FAILED &&
-	    pp->initialized != INIT_MISSING_UDEV)
+	    pp->initialized != INIT_MISSING_UDEV &&
+	    !(pp->initialized == INIT_OK && pp->add_when_online))
 		return CHECK_PATH_SKIPPED;
 
 	newstate = get_new_state(pp);
@@ -2875,6 +2917,18 @@ update_uninitialized_path(struct vectors * vecs, struct path * pp)
 			free_path(pp);
 			return CHECK_PATH_REMOVED;
 		}
+	} else if (pp->initialized == INIT_OK && pp->add_when_online &&
+		   (newstate == PATH_UP || newstate == PATH_GHOST)) {
+		pp->add_when_online = false;
+		if (can_recheck_wwid(pp) && check_path_wwid_change(pp)) {
+			condlog(0, "%s: path wwid change detected. Removing",
+				pp->dev);
+			return handle_path_wwid_change(pp, vecs)?
+					CHECK_PATH_REMOVED :
+					CHECK_PATH_SKIPPED;
+		}
+		ev_add_path(pp, vecs, 1);
+		pp->tick = 1;
 	}
 	return CHECK_PATH_CHECKED;
 }
diff --git a/multipathd/multipathd.8.in b/multipathd/multipathd.8.in
index 43f87bf8..8815e099 100644
--- a/multipathd/multipathd.8.in
+++ b/multipathd/multipathd.8.in
@@ -595,8 +595,9 @@ The device serial number.
 The device marginal state, either \fImarginal\fR or \fInormal\fR.
 .TP
 .B %m
-The multipath device that this device is a path of, or \fI[orphan]\fR if
-it is not part of any multipath device.
+The multipath device that this device is a path of, or \fI[offline]\fR
+if this device could not be added to a device because it is offline or
+\fI[orphan]\fR if it is not part of any multipath device.
 .TP
 .B %N
 The host World Wide Node Name (WWNN) of the device, if any.
-- 
2.48.1

