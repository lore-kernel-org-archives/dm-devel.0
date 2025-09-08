Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7503164A1
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 00:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376018; cv=none; b=rdue33mXwzRlS1OxMk25WE4TsifF2dJR9eVpA9IBUg6zjDvwxd4qkz1ArJ2sJIRBE89u/oloPXZDZ5MuQKwqpnbOP4fktztj5dFDQhCN5NZ2qkDxfbgx0uAOkJBOZC6GsYUlwVl96V/s5aVG6dosqOM6fX2fa5MRjyPmg4RCiE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376018; c=relaxed/simple;
	bh=ZbQJ6x767gqvj97jqdmXyWcE6F4ahi808AhllCOEJrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=op7vCuwYSrJbqcQsgJ8NDOo9ZJ45AC1++X023RGP1vDkbgZtq9Y3uA1jFdpb1ZGNJyGBtlpLpodGIW8NEnpOpbTf3YhaYn4/SG8dUTdeztXRnc5AyHpwxDH9HAcFgfL7qVv5N49GaD3aWl++3mJJXzN6piDcJIPfUaKe6/7XWOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GDc7huGn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GDc7huGn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757376013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8PKmvb6KAzQhjgwbAR1O1fP1xd7A+udrNZm5F0VacZ4=;
	b=GDc7huGnuXSMBDEjhoWXEdZXEyE5iQwZkZfBC8XiI8BVfjCO4jfh08zQKf2KSZqd3HiEs3
	HFelH6J6Mame2JRJEkevWAh4GKPk0nh59sYXeISBGr0tDjcFokhctVctXWzgbkca9LnMSC
	nXX8xeA5owLNRqGqKbu5QAcxUaB5W2s=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-92-Z97FL0N0PXaD3lCvJYX3zw-1; Mon,
 08 Sep 2025 20:00:10 -0400
X-MC-Unique: Z97FL0N0PXaD3lCvJYX3zw-1
X-Mimecast-MFC-AGG-ID: Z97FL0N0PXaD3lCvJYX3zw_1757376009
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 431AD1800451;
	Tue,  9 Sep 2025 00:00:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D5C501956095;
	Tue,  9 Sep 2025 00:00:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 589007G9751191
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 20:00:07 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 589007iZ751190;
	Mon, 8 Sep 2025 20:00:07 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 27/32] libmpathpersist: update reservation key before checking paths
Date: Mon,  8 Sep 2025 19:59:57 -0400
Message-ID: <20250909000002.751039-28-bmarzins@redhat.com>
In-Reply-To: <20250909000002.751039-1-bmarzins@redhat.com>
References: <20250909000002.751039-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GizHGxRHv72VYGAqf3suCJyhCc9eicfVjTS7NE0qdY0_1757376009
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

There is a race condition when changing reservation keys where a failed
path could come back online after libmpathpersist checks the paths, but
before it updates the reservation key. In this case, the path would come
up and get reregistered with the old key by multipathd, and
libmpathpersist would not update its key, because the path was down
when it checked.

To fix this, check the paths after updating the key, so any path that
comes up after getting checked will use the updated key.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 80 ++++++++++++-----------------
 1 file changed, 34 insertions(+), 46 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index c575e3b5..3419fde3 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -110,39 +110,18 @@ void *mpath_alloc_prin_response(int prin_sa)
 	return ptr;
 }
 
-static int get_mpvec(vector curmp, vector pathvec, char *refwwid)
+static int get_path_info(struct multipath *mpp, vector pathvec)
 {
-	int i;
-	struct multipath *mpp;
-
-	vector_foreach_slot (curmp, mpp, i){
-		/*
-		 * discard out of scope maps
-		 */
-		if (!mpp->alias) {
-			condlog(0, "%s: map with empty alias!", __func__);
-			continue;
-		}
-
-		if (mpp->pg != NULL)
-			/* Already seen this one */
-			continue;
-
-		if (refwwid && strncmp (mpp->alias, refwwid, WWID_SIZE - 1))
-			continue;
-
-		if (update_multipath_table(mpp, pathvec, DI_CHECKER) != DMP_OK ||
-		    update_mpp_paths(mpp, pathvec)) {
-			condlog(1, "error parsing map %s", mpp->wwid);
-			remove_map(mpp, pathvec, curmp);
-			i--;
-		} else
-			extract_hwe_from_path(mpp);
+	if (update_multipath_table(mpp, pathvec, DI_CHECKER) != DMP_OK ||
+	    update_mpp_paths(mpp, pathvec)) {
+		condlog(0, "error parsing map %s", mpp->wwid);
+		return MPATH_PR_DMMP_ERROR;
 	}
+	extract_hwe_from_path(mpp);
 	return MPATH_PR_SUCCESS ;
 }
 
-static int mpath_get_map(vector curmp, vector pathvec, int fd, struct multipath **pmpp)
+static int mpath_get_map(vector curmp, int fd, struct multipath **pmpp)
 {
 	int rc;
 	struct stat info;
@@ -174,12 +153,6 @@ static int mpath_get_map(vector curmp, vector pathvec, int fd, struct multipath
 
 	condlog(4, "alias = %s", alias);
 
-	/* get info of all paths from the dm device     */
-	if (get_mpvec(curmp, pathvec, alias)) {
-		condlog(0, "%s: failed to get device info.", alias);
-		return MPATH_PR_DMMP_ERROR;
-	}
-
 	mpp = find_mp_by_alias(curmp, alias);
 
 	if (!mpp) {
@@ -200,7 +173,11 @@ int do_mpath_persistent_reserve_in(vector curmp, vector pathvec,
 	struct multipath *mpp;
 	int ret;
 
-	ret = mpath_get_map(curmp, pathvec, fd, &mpp);
+	ret = mpath_get_map(curmp, fd, &mpp);
+	if (ret != MPATH_PR_SUCCESS)
+		return ret;
+
+	ret = get_path_info(mpp, pathvec);
 	if (ret != MPATH_PR_SUCCESS)
 		return ret;
 
@@ -736,25 +713,15 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	bool unregistering, preempting_reservation = false;
 	bool updated_prkey = false;
 
-	ret = mpath_get_map(curmp, pathvec, fd, &mpp);
+	ret = mpath_get_map(curmp, fd, &mpp);
 	if (ret != MPATH_PR_SUCCESS)
 		return ret;
 
 	conf = get_multipath_config();
 	mpp->mpe = find_mpe(conf->mptable, mpp->wwid);
 	select_reservation_key(conf, mpp);
-	select_all_tg_pt(conf, mpp);
-	/*
-	 * If a device preempts itself, it will need to suspend and resume.
-	 * Set mpp->skip_kpartx to make sure we set the flags to skip kpartx
-	 * if necessary, when doing this.
-	 */
-	select_skip_kpartx(conf, mpp);
 	put_multipath_config(conf);
 
-	if (rq_servact == MPATH_PROUT_REG_IGN_SA)
-		set_ignored_key(mpp, paramp->key);
-
 	unregistering = (memcmp(&zerokey, paramp->sa_key, 8) == 0);
 	if (mpp->prkey_source == PRKEY_SOURCE_FILE &&
 	    (rq_servact == MPATH_PROUT_REG_IGN_SA ||
@@ -807,6 +774,27 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 		}
 	}
 
+	ret = get_path_info(mpp, pathvec);
+	if (ret != MPATH_PR_SUCCESS) {
+		if (updated_prkey)
+			update_prkey_flags(mpp->alias, get_be64(oldkey),
+					   mpp->sa_flags);
+		return ret;
+	}
+
+	conf = get_multipath_config();
+	select_all_tg_pt(conf, mpp);
+	/*
+	 * If a device preempts itself, it will need to suspend and resume.
+	 * Set mpp->skip_kpartx to make sure we set the flags to skip kpartx
+	 * if necessary, when doing this.
+	 */
+	select_skip_kpartx(conf, mpp);
+	put_multipath_config(conf);
+
+	if (rq_servact == MPATH_PROUT_REG_IGN_SA)
+		set_ignored_key(mpp, paramp->key);
+
 	switch(rq_servact)
 	{
 	case MPATH_PROUT_REG_SA:
-- 
2.50.1

