Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDB9CC433DF
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:43:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 209D9207F7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:43:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 209D9207F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-S6gNxJqWOqyzeKKitRYUlA-1; Fri, 16 Oct 2020 06:43:19 -0400
X-MC-Unique: S6gNxJqWOqyzeKKitRYUlA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C16FF18A0761;
	Fri, 16 Oct 2020 10:43:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A5D726EF4A;
	Fri, 16 Oct 2020 10:43:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7F1A344A47;
	Fri, 16 Oct 2020 10:43:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GAhCjI019933 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 06:43:12 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C6D1016C2DF; Fri, 16 Oct 2020 10:43:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C00A6124579
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B302D811E76
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:10 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-301-sA5iDwvCMCiXmZ1VAk8D1A-1;
	Fri, 16 Oct 2020 06:43:05 -0400
X-MC-Unique: sA5iDwvCMCiXmZ1VAk8D1A-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 4F83EB2AE;
	Fri, 16 Oct 2020 10:43:04 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 16 Oct 2020 12:42:29 +0200
Message-Id: <20201016104239.8217-3-mwilck@suse.com>
In-Reply-To: <20201016104239.8217-1-mwilck@suse.com>
References: <20201016104239.8217-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09GAhCjI019933
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 02/12] libmultipath: copy mpp->hwe from pp->hwe
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Since f0462f0 ("libmultipath: use vector for for pp->hwe and mp->hwe"),
we've been trying to fix issues caused by paths getting freed and mpp->hwe
dangling. This approach couldn't work because we need mpp->hwe to persist,
even if all paths are removed from the map. Before f0462f0, a simple
assignment worked, because the lifetime of the hwe wasn't bound to the
path. But now, we need to copy the vector. It turns out that we need to set
mpp->hwe only in two places, add_map_with_path() and setup_map(), and
that the code is simplified overall.

Even now, it can happen that a map is added with add_map_without_paths(),
and has no paths. In that case, calling do_set_from_hwe() with a NULL
pointer is not a bug, so remove the message.

Fixes: f0462f0 ("libmultipath: use vector for for pp->hwe and mp->hwe")
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c   |  7 +++++
 libmultipath/propsel.c     |  4 +--
 libmultipath/structs.c     | 15 +++++++++++
 libmultipath/structs.h     |  1 +
 libmultipath/structs_vec.c | 54 ++++++++++++++++----------------------
 multipathd/main.c          | 10 -------
 6 files changed, 46 insertions(+), 45 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 6fb477f..d7afc91 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -311,6 +311,13 @@ int setup_map(struct multipath *mpp, char *params, int params_size,
 	if (mpp->disable_queueing && VECTOR_SIZE(mpp->paths) != 0)
 		mpp->disable_queueing = 0;
 
+	/*
+	 * If this map was created with add_map_without_path(),
+	 * mpp->hwe might not be set yet.
+	 */
+	if (!mpp->hwe)
+		extract_hwe_from_path(mpp);
+
 	/*
 	 * properties selectors
 	 *
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 7e6e0d6..4020134 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -65,9 +65,7 @@ do {									\
 	__do_set_from_vec(struct hwentry, var, (src)->hwe, dest)
 
 #define do_set_from_hwe(var, src, dest, msg)				\
-	if (!src->hwe) {						\
-		condlog(0, "BUG: do_set_from_hwe called with hwe == NULL"); \
-	} else if (__do_set_from_hwe(var, src, dest)) {			\
+	if (src->hwe && __do_set_from_hwe(var, src, dest)) {		\
 		origin = msg;						\
 		goto out;						\
 	}
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 464596f..2efad6f 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -234,6 +234,17 @@ alloc_multipath (void)
 	return mpp;
 }
 
+void *set_mpp_hwe(struct multipath *mpp, const struct path *pp)
+{
+	if (!mpp || !pp || !pp->hwe)
+		return NULL;
+	if (mpp->hwe)
+		return mpp->hwe;
+	mpp->hwe = vector_convert(NULL, pp->hwe,
+				  struct hwentry, identity);
+	return mpp->hwe;
+}
+
 void free_multipath_attributes(struct multipath *mpp)
 {
 	if (!mpp)
@@ -290,6 +301,10 @@ free_multipath (struct multipath * mpp, enum free_path_mode free_paths)
 
 	free_pathvec(mpp->paths, free_paths);
 	free_pgvec(mpp->pg, free_paths);
+	if (mpp->hwe) {
+		vector_free(mpp->hwe);
+		mpp->hwe = NULL;
+	}
 	FREE_PTR(mpp->mpcontext);
 	FREE(mpp);
 }
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 7de93d6..4ce3055 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -422,6 +422,7 @@ struct host_group {
 struct path * alloc_path (void);
 struct pathgroup * alloc_pathgroup (void);
 struct multipath * alloc_multipath (void);
+void *set_mpp_hwe(struct multipath *mpp, const struct path *pp);
 void uninitialize_path(struct path *pp);
 void free_path (struct path *);
 void free_pathvec (vector vec, enum free_path_mode free_paths);
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 8895fa7..f7f45f1 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -294,11 +294,6 @@ err:
 void orphan_path(struct path *pp, const char *reason)
 {
 	condlog(3, "%s: orphan path, %s", pp->dev, reason);
-	if (pp->mpp && pp->hwe && pp->mpp->hwe == pp->hwe) {
-		condlog(0, "BUG: orphaning path %s that holds hwe of %s",
-			pp->dev, pp->mpp->alias);
-		pp->mpp->hwe = NULL;
-	}
 	pp->mpp = NULL;
 	uninitialize_path(pp);
 }
@@ -308,8 +303,6 @@ void orphan_paths(vector pathvec, struct multipath *mpp, const char *reason)
 	int i;
 	struct path * pp;
 
-	/* Avoid BUG message from orphan_path() */
-	mpp->hwe = NULL;
 	vector_foreach_slot (pathvec, pp, i) {
 		if (pp->mpp == mpp) {
 			if (pp->initialized == INIT_REMOVED) {
@@ -397,24 +390,26 @@ extract_hwe_from_path(struct multipath * mpp)
 	if (mpp->hwe || !mpp->paths)
 		return;
 
-	condlog(3, "%s: searching paths for valid hwe", mpp->alias);
+	condlog(4, "%s: searching paths for valid hwe", mpp->alias);
 	/* doing this in two passes seems like paranoia to me */
 	vector_foreach_slot(mpp->paths, pp, i) {
-		if (pp->state != PATH_UP)
-			continue;
-		if (pp->hwe) {
-			mpp->hwe = pp->hwe;
-			return;
-		}
+		if (pp->state == PATH_UP &&
+		    pp->initialized != INIT_REMOVED && pp->hwe)
+			goto done;
 	}
 	vector_foreach_slot(mpp->paths, pp, i) {
-		if (pp->state == PATH_UP)
-			continue;
-		if (pp->hwe) {
-			mpp->hwe = pp->hwe;
-			return;
-		}
+		if (pp->state != PATH_UP &&
+		    pp->initialized != INIT_REMOVED && pp->hwe)
+			goto done;
 	}
+done:
+	if (i < VECTOR_SIZE(mpp->paths))
+		(void)set_mpp_hwe(mpp, pp);
+
+	if (mpp->hwe)
+		condlog(3, "%s: got hwe from path %s", mpp->alias, pp->dev);
+	else
+		condlog(2, "%s: no hwe found", mpp->alias);
 }
 
 int
@@ -514,8 +509,6 @@ void sync_paths(struct multipath *mpp, vector pathvec)
 		}
 		if (!found) {
 			condlog(3, "%s dropped path %s", mpp->alias, pp->dev);
-			if (mpp->hwe == pp->hwe)
-				mpp->hwe = NULL;
 			vector_del_slot(mpp->paths, i--);
 			orphan_path(pp, "path removed externally");
 		}
@@ -524,8 +517,6 @@ void sync_paths(struct multipath *mpp, vector pathvec)
 	update_mpp_paths(mpp, pathvec);
 	vector_foreach_slot (mpp->paths, pp, i)
 		pp->mpp = mpp;
-	if (mpp->hwe == NULL)
-		extract_hwe_from_path(mpp);
 }
 
 int
@@ -701,9 +692,15 @@ struct multipath *add_map_with_path(struct vectors *vecs, struct path *pp,
 
 	conf = get_multipath_config();
 	mpp->mpe = find_mpe(conf->mptable, pp->wwid);
-	mpp->hwe = pp->hwe;
 	put_multipath_config(conf);
 
+	/*
+	 * We need to call this before select_alias(),
+	 * because that accesses hwe properties.
+	 */
+	if (pp->hwe && !set_mpp_hwe(mpp, pp))
+		goto out;
+
 	strcpy(mpp->wwid, pp->wwid);
 	find_existing_alias(mpp, vecs);
 	if (select_alias(conf, mpp))
@@ -754,12 +751,6 @@ int verify_paths(struct multipath *mpp)
 			vector_del_slot(mpp->paths, i);
 			i--;
 
-			/* Make sure mpp->hwe doesn't point to freed memory.
-			 * We call extract_hwe_from_path() below to restore
-			 * mpp->hwe
-			 */
-			if (mpp->hwe == pp->hwe)
-				mpp->hwe = NULL;
 			/*
 			 * Don't delete path from pathvec yet. We'll do this
 			 * after the path has been removed from the map, in
@@ -771,7 +762,6 @@ int verify_paths(struct multipath *mpp)
 				mpp->alias, pp->dev, pp->dev_t);
 		}
 	}
-	extract_hwe_from_path(mpp);
 	return count;
 }
 
diff --git a/multipathd/main.c b/multipathd/main.c
index a4abbb2..eedc6c1 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1153,13 +1153,6 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 		if (i != -1)
 			vector_del_slot(mpp->paths, i);
 
-		/*
-		 * Make sure mpp->hwe doesn't point to freed memory
-		 * We call extract_hwe_from_path() below to restore mpp->hwe
-		 */
-		if (mpp->hwe == pp->hwe)
-			mpp->hwe = NULL;
-
 		/*
 		 * remove the map IF removing the last path
 		 */
@@ -1191,9 +1184,6 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 			 */
 		}
 
-		if (mpp->hwe == NULL)
-			extract_hwe_from_path(mpp);
-
 		if (setup_map(mpp, params, PARAMS_SIZE, vecs)) {
 			condlog(0, "%s: failed to setup map for"
 				" removal of path %s", mpp->alias, pp->dev);
-- 
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

