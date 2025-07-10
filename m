Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5118F2FCE15
	for <dm-devel@lists.linux.dev>; Thu, 10 Jul 2025 18:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752171070; cv=none; b=uUXVruyYhWVeZmBsQxLDTAP2uA52pjGGeDIG980ef54GlxRAlvpwiOhrGNp3BHpgOvqUzX44Uyzg9vFbMNLAwXVwbkv/yePSUeQcI8tmI4zvehtJk7vuVIOS60e31s29+mKB/t/I7ZlfCB7zLYBd3NkiCDmv6e8DMf1CJ2qg54s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752171070; c=relaxed/simple;
	bh=67Xwhs5Fvui1+Er0NfKjWf9/XQ7W7UpMlAmsqygdZEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Tsw6ebvPMsV1CoZChiR3iWD0bRxWsOmA4JTBnDybaTIqEIKCVDkWSibQj+gq3uif7WA9OQxUyquZnhlNf8i16s08sss9+868EPmPSMOk3ogbqdsIcadLjWNYom7YBnQUZ8ZBDI+0Q5+U2r1F7m+Wfk72YgdQubV2Wef/T0xgycI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h5zMHet2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h5zMHet2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752171067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fHCBtQfZzJl2biev9q3QCoAWTIS8asLZLwNDFlw99XQ=;
	b=h5zMHet2p3lKn/RJ7EXiVdR23AKncsnjMUArPrCYnsX6YcP0ux3weUtOKQyjjMzxWqA7e4
	k6pLbOEAFu2Ccn2pOEIit6HlMO6ux9YJ9sVzr2fMxY4zQ0Qup6Lf+sDTAwCQ81WEsiu27E
	oPY//kcAtN53dE/m62pRTfK3ZUg+42g=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-227-VDZrTvkhOBG2dr2us_qGkw-1; Thu,
 10 Jul 2025 14:11:05 -0400
X-MC-Unique: VDZrTvkhOBG2dr2us_qGkw-1
X-Mimecast-MFC-AGG-ID: VDZrTvkhOBG2dr2us_qGkw_1752171065
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CB9371808984;
	Thu, 10 Jul 2025 18:11:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8B85A19560A3;
	Thu, 10 Jul 2025 18:11:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 56AIB3dl3997835
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Jul 2025 14:11:03 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 56AIB3Px3997834;
	Thu, 10 Jul 2025 14:11:03 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 13/15] libmultipath: rename prflag_value enums
Date: Thu, 10 Jul 2025 14:10:58 -0400
Message-ID: <20250710181100.3997759-14-bmarzins@redhat.com>
In-Reply-To: <20250710181100.3997759-1-bmarzins@redhat.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: U4l7rextJf2cVwlzsCjC7ZCTq6EUkH9dmHhoJf-l3vs_1752171065
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

These will also be used by another variable, so make their name more
generic.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 16 ++++++++--------
 libmpathpersist/mpath_updatepr.c    |  8 ++++----
 libmultipath/structs.h              |  9 ++++-----
 multipathd/cli_handlers.c           | 22 +++++++++++-----------
 multipathd/main.c                   | 16 +++++++---------
 5 files changed, 34 insertions(+), 37 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index ee9706c6..1bb62531 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -649,10 +649,10 @@ static void set_ignored_key(struct multipath *mpp, uint8_t *key)
 	memset(key, 0, 8);
 	if (!get_be64(mpp->reservation_key))
 		return;
-	if (get_prflag(mpp->alias) == PRFLAG_UNSET)
+	if (get_prflag(mpp->alias) == PR_UNSET)
 		return;
 	update_map_pr(mpp, NULL);
-	if (mpp->prflag != PRFLAG_SET)
+	if (mpp->prflag != PR_SET)
 		return;
 	memcpy(key, &mpp->reservation_key, 8);
 }
@@ -750,16 +750,16 @@ int update_map_pr(struct multipath *mpp, struct path *pp)
 	struct prin_resp *resp;
 	unsigned int i;
 	int ret = MPATH_PR_OTHER, isFound;
-	bool was_set = (mpp->prflag == PRFLAG_SET);
+	bool was_set = (mpp->prflag == PR_SET);
 
 	/* If pr is explicitly unset, it must be manually set */
-	if (mpp->prflag == PRFLAG_UNSET)
+	if (mpp->prflag == PR_UNSET)
 		return MPATH_PR_SKIP;
 
 	if (!get_be64(mpp->reservation_key))
 	{
 		/* Nothing to do. Assuming pr mgmt feature is disabled*/
-		mpp->prflag = PRFLAG_UNSET;
+		mpp->prflag = PR_UNSET;
 		condlog(was_set ? 2 : 4, "%s: reservation_key not set in multipath.conf", mpp->alias);
 		return MPATH_PR_SKIP;
 	}
@@ -785,11 +785,11 @@ int update_map_pr(struct multipath *mpp, struct path *pp)
 	if (ret != MPATH_PR_SUCCESS )
 	{
 		if (ret == MPATH_PR_ILLEGAL_REQ)
-			mpp->prflag = PRFLAG_UNSET;
+			mpp->prflag = PR_UNSET;
 		condlog(0,"%s : pr in read keys service action failed Error=%d", mpp->alias, ret);
 		goto out;
 	}
-	mpp->prflag = PRFLAG_UNSET;
+	mpp->prflag = PR_UNSET;
 
 	if (resp->prin_descriptor.prin_readkeys.additional_length == 0 )
 	{
@@ -817,7 +817,7 @@ int update_map_pr(struct multipath *mpp, struct path *pp)
 
 	if (isFound)
 	{
-		mpp->prflag = PRFLAG_SET;
+		mpp->prflag = PR_SET;
 		condlog(was_set ? 3 : 2, "%s: key found. prflag set.",
 			mpp->alias);
 	} else
diff --git a/libmpathpersist/mpath_updatepr.c b/libmpathpersist/mpath_updatepr.c
index 7cf82f50..c8fbe4a2 100644
--- a/libmpathpersist/mpath_updatepr.c
+++ b/libmpathpersist/mpath_updatepr.c
@@ -84,13 +84,13 @@ int get_prflag(char *mapname)
 	snprintf(str, sizeof(str), "getprstatus map %s", mapname);
 	reply = do_pr(mapname, str);
 	if (!reply)
-		prflag = PRFLAG_UNKNOWN;
+		prflag = PR_UNKNOWN;
 	else if (strncmp(reply, "unset", 5) == 0)
-		prflag = PRFLAG_UNSET;
+		prflag = PR_UNSET;
 	else if (strncmp(reply, "set", 3) == 0)
-		prflag = PRFLAG_SET;
+		prflag = PR_SET;
 	else
-		prflag = PRFLAG_UNKNOWN;
+		prflag = PR_UNKNOWN;
 
 	free(reply);
 	return prflag;
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 39d1c71c..6c427d6f 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -424,11 +424,10 @@ struct path {
 
 typedef int (pgpolicyfn) (struct multipath *, vector);
 
-
-enum prflag_value {
-	PRFLAG_UNKNOWN,
-	PRFLAG_UNSET,
-	PRFLAG_SET,
+enum pr_value {
+	PR_UNKNOWN,
+	PR_UNSET,
+	PR_SET,
 };
 
 enum prio_update_type {
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index fcb87757..a92b07ce 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -1250,14 +1250,15 @@ cli_shutdown (void * v, struct strbuf *reply, void * data)
 	return 0;
 }
 
+static const char *const pr_str[] = {
+	[PR_UNKNOWN] = "unknown\n",
+	[PR_UNSET] = "unset\n",
+	[PR_SET] = "set\n",
+};
+
 static int
 cli_getprstatus (void * v, struct strbuf *reply, void * data)
 {
-	static const char * const prflag_str[] = {
-		[PRFLAG_UNKNOWN] = "unknown\n",
-		[PRFLAG_UNSET] = "unset\n",
-		[PRFLAG_SET] = "set\n",
-	};
 	struct multipath * mpp;
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, KEY_MAP);
@@ -1268,7 +1269,7 @@ cli_getprstatus (void * v, struct strbuf *reply, void * data)
 	if (!mpp)
 		return -ENODEV;
 
-	append_strbuf_str(reply, prflag_str[mpp->prflag]);
+	append_strbuf_str(reply, pr_str[mpp->prflag]);
 
 	condlog(3, "%s: reply = %s", param, get_strbuf_str(reply));
 
@@ -1288,12 +1289,11 @@ cli_setprstatus(void * v, struct strbuf *reply, void * data)
 	if (!mpp)
 		return -ENODEV;
 
-	if (mpp->prflag != PRFLAG_SET) {
-		mpp->prflag = PRFLAG_SET;
+	if (mpp->prflag != PR_SET) {
+		mpp->prflag = PR_SET;
 		condlog(2, "%s: prflag set", param);
 	}
 
-
 	return 0;
 }
 
@@ -1310,8 +1310,8 @@ cli_unsetprstatus(void * v, struct strbuf *reply, void * data)
 	if (!mpp)
 		return -ENODEV;
 
-	if (mpp->prflag != PRFLAG_UNSET) {
-		mpp->prflag = PRFLAG_UNSET;
+	if (mpp->prflag != PR_UNSET) {
+		mpp->prflag = PR_UNSET;
 		condlog(2, "%s: prflag unset", param);
 	}
 
diff --git a/multipathd/main.c b/multipathd/main.c
index 02cfe8d1..582af880 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -637,7 +637,7 @@ pr_register_active_paths(struct multipath *mpp)
 
 	vector_foreach_slot (mpp->pg, pgp, i) {
 		vector_foreach_slot (pgp->paths, pp, j) {
-			if (mpp->prflag == PRFLAG_UNSET)
+			if (mpp->prflag == PR_UNSET)
 				return;
 			if ((pp->state == PATH_UP) || (pp->state == PATH_GHOST))
 				mpath_pr_event_handle(pp);
@@ -1273,7 +1273,7 @@ ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
 	int start_waiter = 0;
 	int ret;
 	int ro;
-	unsigned char prflag = PRFLAG_UNSET;
+	unsigned char prflag = PR_UNSET;
 
 	/*
 	 * need path UID to go any further
@@ -1401,8 +1401,7 @@ rescan:
 	sync_map_state(mpp, false);
 
 	if (retries >= 0) {
-		if ((mpp->prflag == PRFLAG_SET && prflag != PRFLAG_SET) ||
-		    start_waiter)
+		if ((mpp->prflag == PR_SET && prflag != PR_SET) || start_waiter)
 			pr_register_active_paths(mpp);
 		condlog(2, "%s [%s]: path added to devmap %s",
 			pp->dev, pp->dev_t, mpp->alias);
@@ -2639,7 +2638,7 @@ update_path_state (struct vectors * vecs, struct path * pp)
 
 		/* newstate == PATH_UP || newstate == PATH_GHOST */
 
-		if (pp->mpp->prflag != PRFLAG_UNSET) {
+		if (pp->mpp->prflag != PR_UNSET) {
 			int prflag = pp->mpp->prflag;
 			/*
 			 * Check Persistent Reservation.
@@ -2647,8 +2646,7 @@ update_path_state (struct vectors * vecs, struct path * pp)
 			condlog(2, "%s: checking persistent "
 				"reservation registration", pp->dev);
 			mpath_pr_event_handle(pp);
-			if (pp->mpp->prflag == PRFLAG_SET &&
-			    prflag != PRFLAG_SET)
+			if (pp->mpp->prflag == PR_SET && prflag != PR_SET)
 				pr_register_active_paths(pp->mpp);
 		}
 
@@ -4231,14 +4229,14 @@ static void mpath_pr_event_handle(struct path *pp)
 	struct prout_param_descriptor *param;
 
 	if (pp->bus != SYSFS_BUS_SCSI) {
-		mpp->prflag = PRFLAG_UNSET;
+		mpp->prflag = PR_UNSET;
 		return;
 	}
 
 	if (update_map_pr(mpp, pp) != MPATH_PR_SUCCESS)
 		return;
 
-	if (mpp->prflag != PRFLAG_SET)
+	if (mpp->prflag != PR_SET)
 		return;
 
 	param = (struct prout_param_descriptor *)calloc(1, sizeof(struct prout_param_descriptor));
-- 
2.48.1

