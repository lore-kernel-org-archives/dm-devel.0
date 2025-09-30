Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F35D2D2397
	for <dm-devel@lists.linux.dev>; Tue, 30 Sep 2025 23:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759276448; cv=none; b=QnvjRJUGaSKuKgY4AfgOQMJ/mElonUVvZa1u1tQh+Pja0IA24oB2rm05Wg9PrQFGOllBsNMRKS7ubvQ1J/G7QFSTVWFh84OB53kDm4afnAx3hGtmCB1AGZSjIq+i83l9ESOG8iBXU4VVXYyhHRCNd1zd2Ww/I/LHOTU6mXAtXsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759276448; c=relaxed/simple;
	bh=l/AnBBFcXFL9RmmcOPqgYC9898TWy8pe1kokTtBeAtc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=QWICcfJ4Z/U1XoQJKRkp8BAka9XlaIuPbw5uEurAOALAxHef0Iszlo62vBuK2B2iW1c99ZJsuNTEXSouytT8JL9VO+ODelY7WvNIuo5yLPVlmFgEzCB860k7gN6ckrrvEUeHWg+Qxj+U3EYJl07h68nHPAFvPRtQXxbmfwOxq9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=czx7swEf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="czx7swEf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759276445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=laNmT85x9yNCMXen5mXs5ibczHm3XfCwnu+0YvU/dGw=;
	b=czx7swEfTXQZTNdnuSnLaPM4W+N068TILzVI0piBZKXUTyy96d/98Uk+DtiAOwBeI7L6E9
	qBxxNqegIpHJkVYhMtYebgFpr+ZN7XbYoSt+YptqPz1Jla2tniE1ACzNWR1t4ZoJl5bZCu
	3aukLAJxpNQgLX/rAV3bKEjppxU1RCw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-283-pql8mvCRMm2CLhzfemQ5Sw-1; Tue,
 30 Sep 2025 19:54:00 -0400
X-MC-Unique: pql8mvCRMm2CLhzfemQ5Sw-1
X-Mimecast-MFC-AGG-ID: pql8mvCRMm2CLhzfemQ5Sw_1759276439
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1EB82180028E;
	Tue, 30 Sep 2025 23:53:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AF02719560B4;
	Tue, 30 Sep 2025 23:53:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 58UNrvCQ1752845
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 30 Sep 2025 19:53:57 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 58UNrui91752844;
	Tue, 30 Sep 2025 19:53:56 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH] libmpathpersist: Fix race between restoring a path and preemption
Date: Tue, 30 Sep 2025 19:53:56 -0400
Message-ID: <20250930235356.1752836-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: w2zEdsL7JOcSKpZApe-eu5WZoUimJxBIVOFzbtfKPYE_1759276439
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If a multipath device gets preempted while a path is being restored, the
path could end up getting the old key registered on it anyways.  This
happens by:
1. multipathd calling update_map_pr() in mpath_pr_event_handle() and
   seeing that there are matching keys.
2. Those matching keys get preempted.
3. multipathd registering the preempted key on the path.

Since there is no way to guarantee that the key won't get preempted
after multipathd checks for it, mpath_pr_event_handle() now calls
update_map_pr() to check the registered keys again after registering the
key. There must be at least as many keys registered after registering
the key on the restored path (which may already have a key registered on
it, so it's possible that the number of registered keys doesn't change).

pr_register_active_paths() calls mpath_pr_event_handle() for all working
paths on a device. In order to avoid calling update_map_pr() twice for
every path, mpath_pr_event_handle() now takes the number of keys to
expect, and skips the initial call to update_map_pr() if it already
knows how many keys are registered before trying to register the new
path.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 77 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 52 insertions(+), 25 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 39d4f8cd..d7642a0b 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -89,7 +89,8 @@
 #define CMDSIZE 160
 #define MSG_SIZE 32
 
-static void mpath_pr_event_handle(struct path *pp);
+static unsigned int
+mpath_pr_event_handle(struct path *pp, unsigned int nr_keys_needed);
 
 #define LOG_MSG(lvl, pp)					\
 do {								\
@@ -631,7 +632,7 @@ flush_map_nopaths(struct multipath *mpp, struct vectors *vecs) {
 static void
 pr_register_active_paths(struct multipath *mpp)
 {
-	unsigned int i, j;
+	unsigned int i, j, nr_keys = 0;
 	struct path *pp;
 	struct pathgroup *pgp;
 
@@ -640,7 +641,7 @@ pr_register_active_paths(struct multipath *mpp)
 			if (mpp->prflag == PR_UNSET)
 				return;
 			if ((pp->state == PATH_UP) || (pp->state == PATH_GHOST))
-				mpath_pr_event_handle(pp);
+				nr_keys = mpath_pr_event_handle(pp, nr_keys);
 		}
 	}
 }
@@ -1318,7 +1319,7 @@ rescan:
 		verify_paths(mpp);
 		mpp->action = ACT_RELOAD;
 		prflag = mpp->prflag;
-		mpath_pr_event_handle(pp);
+		mpath_pr_event_handle(pp, 0);
 	} else {
 		if (!should_multipath(pp, vecs->pathvec, vecs->mpvec)) {
 			orphan_path(pp, "only one path");
@@ -2645,7 +2646,7 @@ update_path_state (struct vectors * vecs, struct path * pp)
 			 */
 			condlog(2, "%s: checking persistent "
 				"reservation registration", pp->dev);
-			mpath_pr_event_handle(pp);
+			mpath_pr_event_handle(pp, 0);
 			if (pp->mpp->prflag == PR_SET && prflag != PR_SET)
 				pr_register_active_paths(pp->mpp);
 		}
@@ -4264,12 +4265,16 @@ void unset_pr(struct multipath *mpp)
  * Returns MPATH_PR_SUCCESS unless if fails to read the PR keys. If
  * MPATH_PR_SUCCESS is returned, mpp->prflag will be either PR_SET or
  * PR_UNSET.
+ *
+ * The number of found keys must be at least as large as *nr_keys,
+ * and if MPATH_PR_SUCCESS is returned and mpp->prflag is PR_SET after
+ * the call, *nr_keys will be set to the number of found keys.
  */
-static int update_map_pr(struct multipath *mpp, struct path *pp)
+static int update_map_pr(struct multipath *mpp, struct path *pp, unsigned int *nr_keys)
 {
 	struct prin_resp resp;
-	unsigned int i;
-	int ret, isFound;
+	unsigned int i, nr_found = 0;
+	int ret;
 	bool was_set = (mpp->prflag == PR_SET);
 
 	/* If pr is explicitly unset, it must be manually set */
@@ -4299,7 +4304,6 @@ static int update_map_pr(struct multipath *mpp, struct path *pp)
 	condlog(4, "%s: Multipath reservation_key: 0x%" PRIx64 " ", mpp->alias,
 		get_be64(mpp->reservation_key));
 
-	isFound = 0;
 	for (i = 0;
 	     i < resp.prin_descriptor.prin_readkeys.additional_length / 8; i++) {
 		uint8_t *keyp = &resp.prin_descriptor.prin_readkeys.key_list[i * 8];
@@ -4319,41 +4323,57 @@ static int update_map_pr(struct multipath *mpp, struct path *pp)
 		if (!memcmp(&mpp->reservation_key, keyp, 8) ||
 		    (get_be64(mpp->old_pr_key) &&
 		     !memcmp(&mpp->old_pr_key, keyp, 8)))
-			isFound = 1;
+			nr_found++;
 	}
 
-	if (isFound) {
+	if (nr_found >= *nr_keys) {
 		set_pr(mpp);
-		condlog(was_set ? 3 : 2, "%s: key found. prflag set.", mpp->alias);
+		condlog(was_set ? 3 : 2, "%s: %u keys found. prflag set.",
+			mpp->alias, nr_found);
+		*nr_keys = nr_found;
 	} else {
 		unset_pr(mpp);
-		condlog(was_set ? 1 : 3, "%s: key not found. prflag unset.",
-			mpp->alias);
+		condlog(was_set ? 1 : 3,
+			"%s: %u keys found. needed %u. prflag unset.",
+			mpp->alias, nr_found, *nr_keys);
 	}
 
 	return MPATH_PR_SUCCESS;
 }
 
-static void mpath_pr_event_handle(struct path *pp)
+/*
+ * This function is called with the number of registered keys that should be
+ * seen for this device to know that the key has not been preempted while the
+ * path was getting registered. If 0 is passed in, update_mpath_pr is called
+ * before registering the key to figure out the number, assuming that at
+ * least one key must exist.
+ *
+ * The function returns the number of keys that are registered or 0 if
+ * it's unknown.
+ */
+static unsigned int mpath_pr_event_handle(struct path *pp, unsigned int nr_keys_needed)
 {
 	struct multipath *mpp = pp->mpp;
 	int ret;
-	struct prout_param_descriptor param;
+	struct prout_param_descriptor param = {.sa_flags = 0};
 	bool clear_reg = false;
 
 	if (pp->bus != SYSFS_BUS_SCSI) {
 		unset_pr(mpp);
-		return;
+		return 0;
 	}
 
-	if (update_map_pr(mpp, pp) != MPATH_PR_SUCCESS)
-		return;
+	if (nr_keys_needed == 0) {
+		nr_keys_needed = 1;
+		if (update_map_pr(mpp, pp, &nr_keys_needed) != MPATH_PR_SUCCESS)
+			return 0;
+	}
 
 	check_prhold(mpp, pp);
 
 	if (mpp->prflag != PR_SET) {
 		if (!mpp->ever_registered_pr)
-			return;
+			return 0;
 		/*
 		 * This path may have been unusable and either the
 		 * registration was cleared or the registered
@@ -4366,21 +4386,28 @@ static void mpath_pr_event_handle(struct path *pp)
 		clear_reg = true;
 	}
 
-	memset(&param, 0, sizeof(param));
-
 	if (!clear_reg) {
 		param.sa_flags = mpp->sa_flags;
 		memcpy(param.sa_key, &mpp->reservation_key, 8);
 		param.num_transportid = 0;
 	}
-
+retry:
 	condlog(3, "%s registration for device %s:%s",
 		clear_reg ? "Clearing" : "Setting", pp->dev, pp->mpp->wwid);
 
 	ret = prout_do_scsi_ioctl(pp->dev, MPATH_PROUT_REG_IGN_SA, 0, 0, &param, 0);
-	if (ret != MPATH_PR_SUCCESS )
-	{
+	if (ret != MPATH_PR_SUCCESS) {
 		condlog(0, "%s: %s reservation registration failed. Error: %d",
 			clear_reg ? "Clearing" : "Setting", pp->dev, ret);
+	} else if (!clear_reg) {
+		if (update_map_pr(mpp, pp, &nr_keys_needed) != MPATH_PR_SUCCESS)
+			return 0;
+		if (mpp->prflag != PR_SET) {
+			memset(&param, 0, sizeof(param));
+			clear_reg = true;
+			goto retry;
+		}
+		return nr_keys_needed;
 	}
+	return 0;
 }
-- 
2.50.1

