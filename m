Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85E82147F3
	for <dm-devel@lists.linux.dev>; Mon,  3 Mar 2025 19:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741031795; cv=none; b=loK4qv99C5oeDjOyTHKZw4Pftgesoio3ymNJgD5cI1UlGv6YZDASdOCgPL2dEAlG+xb6GifWOhVf1aFL8fDeguvsWpskQDcKG3g+IV2pgBv+gOJQduJeKTne1VjL/2+JRdrWypkOt5LOSJiDi6wXb/aeZNJsG3J/OZyc0XLiEWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741031795; c=relaxed/simple;
	bh=2WrRMOjVQoguZD3kiYUjYaTBT9ePM3+slaK2vcFZp4c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=T8oZELhJsjBfCKCgliVUNhZ0FHREvq9g+7S1jOMsReZk9mDdXE6Pi030AxEms8cNfUcR1BGPtjQ0yctcwNOViU6E+jWOkMOjtl8sfHKh5mBGrzVVCq2tSYNQrONZ/9uHhZgnhyZJu7tjk3cQE8KgPny1/+UJyC6PKkSqIF08omA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gbMVVE4F; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gbMVVE4F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741031792;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ai+gxawKF3VHRvKtFOs4waxawSe455tj7H/BPD42k0I=;
	b=gbMVVE4F80JcMOa3k2XpjtHHxx0YQX2MhnYohvw/aIH2C0XejbKSuPjTBs/9TvCZ/KVf/+
	eyBg97JcihRjL8mdyb07KNZjeJXwbItNvME0uPmcQpHIrZ2IAo3vLtQ/d+dr4RFL9UYrW2
	hTccMwEjaj9NyPKhmHcd+yxeKGWAJLg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-584-m-kyCYVcMeGqKTGO4Jsfnw-1; Mon,
 03 Mar 2025 14:56:31 -0500
X-MC-Unique: m-kyCYVcMeGqKTGO4Jsfnw-1
X-Mimecast-MFC-AGG-ID: m-kyCYVcMeGqKTGO4Jsfnw_1741031790
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 46FEB180087A;
	Mon,  3 Mar 2025 19:56:30 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D73BF1956048;
	Mon,  3 Mar 2025 19:56:29 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 523JuSK52998604
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 3 Mar 2025 14:56:28 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 523JuShJ2998603;
	Mon, 3 Mar 2025 14:56:28 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH] libmultipath: remove buggy reinstate_paths function
Date: Mon,  3 Mar 2025 14:56:28 -0500
Message-ID: <20250303195628.2998595-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dI4SDLW9D-ySIpebPVyNanuvgwCjoE1OM59P6Q3n5k0_1741031790
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

The purpose of reinstate_paths() is to reinstate all the paths on a
multipath device that multipathd thinks are usable, similar to
sync_map_state(). However, reinstate_paths() doesn't work correctly.
For instance, it will always reinstate every path in enabled (as opposed
to active or disabled) pathgroups. This is clearly wrong. It might be
badly written code to avoid enabling paths in PATH_GHOST in active
pathgroups, but that's just a guess and isn't necessary at any rate.

It's called in two places. The first is when multipath is run with
CMD_CREATE. The second is when domap() is run with a mpp->action of
ACT_SWITCHPG or ACT_SWITCHPG_RENAME. This case just exists to run extra
reinstates for paths that are not in PATH_UP, on pathgroups that are now
in the enabled state, instead of the active state. This is old code. I'm
not sure if it ever made sense to do this, but it certainly doesn't now.

Multipathd already will make sure that its path states are synced with
the kernel states whenever either the paths get checked or a dm event
occurs. It makes sense to additionally sync with the kernel state when a
multipath device is reloaded, like sync_map_state() currently does,
since the path's kernel state will start out of sync with multipathd's
state.

However, if multipathd isn't running, I can see the benefit of being
able to reinstate paths by running "multipath". So if multipath is
run to create or reload multipath devices (CMD_CREATE), it will now call
sync_map_state() with a flag to make it behave like reinstate_paths()
did (it will only reinstate paths, but never preemptively fail them). I
thought about only doing this if check_daemon() said that multipathd
wasn't running, but perhaps people are relying on running multipath
to reinstate paths before the next scheduled checker run.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c          | 35 -------------------------------
 libmultipath/configure.h          |  1 -
 libmultipath/libmultipath.version |  1 -
 libmultipath/structs_vec.c        |  5 +++--
 libmultipath/structs_vec.h        |  2 +-
 multipath/main.c                  |  2 +-
 multipathd/main.c                 | 12 +++++------
 7 files changed, 11 insertions(+), 47 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 939271fa..baa13573 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -804,35 +804,6 @@ void select_action (struct multipath *mpp, const struct vector_s *curmp,
 	return;
 }
 
-int reinstate_paths(struct multipath *mpp)
-{
-	int i, j;
-	struct pathgroup * pgp;
-	struct path * pp;
-
-	if (!mpp->pg)
-		return 0;
-
-	vector_foreach_slot (mpp->pg, pgp, i) {
-		if (!pgp->paths)
-			continue;
-
-		vector_foreach_slot (pgp->paths, pp, j) {
-			if (pp->state != PATH_UP &&
-			    (pgp->status == PGSTATE_DISABLED ||
-			     pgp->status == PGSTATE_ACTIVE))
-				continue;
-
-			if (pp->dmstate == PSTATE_FAILED) {
-				if (dm_reinstate_path(mpp->alias, pp->dev_t))
-					condlog(0, "%s: error reinstating",
-						pp->dev);
-			}
-		}
-	}
-	return 0;
-}
-
 static int
 lock_multipath (struct multipath * mpp, int lock)
 {
@@ -943,12 +914,6 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 	case ACT_SWITCHPG:
 	case ACT_SWITCHPG_RENAME:
 		dm_switchgroup(mpp->alias, mpp->bestpg);
-		/*
-		 * we may have avoided reinstating paths because there where in
-		 * active or disabled PG. Now that the topology has changed,
-		 * retry.
-		 */
-		reinstate_paths(mpp);
 		return DOMAP_EXIST;
 
 	case ACT_CREATE:
diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index f98a3b21..45ac54fd 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -56,7 +56,6 @@ int setup_map (struct multipath * mpp, char **params, struct vectors *vecs);
 void select_action (struct multipath *mpp, const struct vector_s *curmp,
 		    int force_reload);
 int domap (struct multipath * mpp, char * params, int is_daemon);
-int reinstate_paths (struct multipath *mpp);
 int coalesce_paths (struct vectors *vecs, vector curmp, char * refwwid, int force_reload, enum mpath_cmds cmd);
 int get_refwwid (enum mpath_cmds cmd, const char *dev, enum devtypes dev_type,
 		 vector pathvec, char **wwid);
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index b14ce6be..9fda717c 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -153,7 +153,6 @@ global:
 	print_all_paths;
 	print_foreign_topology;
 	print_multipath_topology__;
-	reinstate_paths;
 	remember_wwid;
 	remove_feature;
 	remove_map;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index a7a07b04..f6407e12 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -730,7 +730,7 @@ void set_no_path_retry(struct multipath *mpp)
 }
 
 void
-sync_map_state(struct multipath *mpp)
+sync_map_state(struct multipath *mpp, bool reinstate_only)
 {
 	struct pathgroup *pgp;
 	struct path *pp;
@@ -752,7 +752,8 @@ sync_map_state(struct multipath *mpp)
 			     pp->dmstate == PSTATE_UNDEF) &&
 			    (pp->state == PATH_UP || pp->state == PATH_GHOST))
 				dm_reinstate_path(mpp->alias, pp->dev_t);
-			else if ((pp->dmstate == PSTATE_ACTIVE ||
+			else if (!reinstate_only &&
+				 (pp->dmstate == PSTATE_ACTIVE ||
 				  pp->dmstate == PSTATE_UNDEF) &&
 				 (pp->state == PATH_DOWN ||
 				  pp->state == PATH_SHAKY)) {
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index 03bf8ee1..1188adac 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -27,7 +27,7 @@ void remove_map (struct multipath *mpp, vector pathvec, vector mpvec);
 void remove_map_by_alias(const char *alias, struct vectors * vecs);
 void remove_maps (struct vectors * vecs);
 
-void sync_map_state (struct multipath *);
+void sync_map_state (struct multipath *mpp, bool reinstate_only);
 struct multipath * add_map_with_path (struct vectors * vecs,
 				      struct path * pp, int add_vec,
 				      const struct multipath *current_mpp);
diff --git a/multipath/main.c b/multipath/main.c
index de9c33e4..9967dc6d 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -210,7 +210,7 @@ get_dm_mpvec (enum mpath_cmds cmd, vector curmp, vector pathvec, char * refwwid)
 			print_multipath_topology(mpp, libmp_verbosity);
 
 		if (cmd == CMD_CREATE)
-			reinstate_paths(mpp);
+			sync_map_state(mpp, true);
 	}
 
 	if (cmd == CMD_LIST_SHORT || cmd == CMD_LIST_LONG)
diff --git a/multipathd/main.c b/multipathd/main.c
index 3468b21f..e63b6aa7 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -688,7 +688,7 @@ fail:
 	if (setup_multipath(vecs, mpp))
 		return 1;
 
-	sync_map_state(mpp);
+	sync_map_state(mpp, false);
 
 	if (mpp->prflag != PRFLAG_SET)
 		update_map_pr(mpp);
@@ -806,7 +806,7 @@ sync_maps_state(vector mpvec)
 	struct multipath *mpp;
 
 	vector_foreach_slot (mpvec, mpp, i)
-		sync_map_state(mpp);
+		sync_map_state(mpp, false);
 }
 
 int
@@ -1344,7 +1344,7 @@ rescan:
 	if (setup_multipath(vecs, mpp))
 		goto fail; /* if setup_multipath fails, it removes the map */
 
-	sync_map_state(mpp);
+	sync_map_state(mpp, false);
 
 	if (retries >= 0) {
 		if (start_waiter)
@@ -1464,7 +1464,7 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 		strlcpy(devt, pp->dev_t, sizeof(devt));
 		if (setup_multipath(vecs, mpp))
 			return REMOVE_PATH_MAP_ERROR;
-		sync_map_state(mpp);
+		sync_map_state(mpp, false);
 
 		if (retval == REMOVE_PATH_SUCCESS)
 			condlog(2, "%s: path removed from map %s",
@@ -1558,7 +1558,7 @@ int resize_map(struct multipath *mpp, unsigned long long size,
 out:
 	if (setup_multipath(vecs, mpp) != 0)
 		return 2;
-	sync_map_state(mpp);
+	sync_map_state(mpp, false);
 
 	return ret;
 }
@@ -2274,7 +2274,7 @@ int reload_and_sync_map(struct multipath *mpp, struct vectors *vecs)
 		ret = 1;
 	if (setup_multipath(vecs, mpp) != 0)
 		return 2;
-	sync_map_state(mpp);
+	sync_map_state(mpp, false);
 
 	return ret;
 }
-- 
2.48.1

