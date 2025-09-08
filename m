Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC533054F0
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 00:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376013; cv=none; b=tE1RbufPagy2FEbsFzWpgxVfOwu3hAUnQeImCf9AHSjCBSW+Hq8xvuT5NNir4XoAB5Sv1wa/o2QDMVyIf+2w4gbdXUEHkZSFDIm3Xy2ElmVoF3sjD2TyCRimpJpczS9bL6ryEpEu8QnkJhr2EqrxQr9VBakcnWP4Xd5AxhPW5ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376013; c=relaxed/simple;
	bh=DxaXKTUlJ764zBl0u4py7/YaqoHng01PmHQJsCQUd4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Uew7NmFm+pq2ZL9BINTt1TYQAreRIiIvr4nBfHybVsZFtyDIlFUpjOJmwSjoZCWW9xewiNEIgPdIZxoq0QI/D2YDwC32rZxsSbBr/Fy4e8fyVBHnbcPzozU34QHh68u1cvY0X1siHs170QuFHsg/tBEUoCalmLBIbmaPkNX6pw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KrBP0J3T; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KrBP0J3T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757376010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fNscFFqOx5Y5U9dzI7SBTUFIuClwigHs0+o22eLibFY=;
	b=KrBP0J3T7ndWK7tu+D264+fDjlQ8ODiGgDNG+U1nNlZ7YqLTW1RK4LUEZJWNXEJi8myvAH
	uphX/mzU4yifcvFnR5FLNTPcJUoo1mUDZbU/lNmCzzaRhpfjYHVKkJZM+EgiUwlM3jzRsq
	1MOc3+NqSiatD3mqR6knQhysArUZMjo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-49-JriufCruNIaRaWIchuJkeg-1; Mon,
 08 Sep 2025 20:00:08 -0400
X-MC-Unique: JriufCruNIaRaWIchuJkeg-1
X-Mimecast-MFC-AGG-ID: JriufCruNIaRaWIchuJkeg_1757376007
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BAC4B19560B4;
	Tue,  9 Sep 2025 00:00:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 799611956095;
	Tue,  9 Sep 2025 00:00:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 589006f2751151
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 20:00:06 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 589006CW751150;
	Mon, 8 Sep 2025 20:00:06 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 17/32] libmpathpersist: move update_map_pr to multipathd
Date: Mon,  8 Sep 2025 19:59:47 -0400
Message-ID: <20250909000002.751039-18-bmarzins@redhat.com>
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
X-Mimecast-MFC-PROC-ID: xd3mqrhPZUXr_MFp1CnHAPYpBTyHBWdmiYJ3y10aJRw_1757376007
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

multipathd is now the only program that calls update_map_pr(), so move
it there, and make it static. There are no other code changes.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/libmpathpersist.version |  1 -
 libmpathpersist/mpath_persist_int.c     | 83 -------------------------
 libmpathpersist/mpath_persist_int.h     |  3 +-
 multipathd/main.c                       | 80 ++++++++++++++++++++++++
 4 files changed, 81 insertions(+), 86 deletions(-)

diff --git a/libmpathpersist/libmpathpersist.version b/libmpathpersist/libmpathpersist.version
index b31237db..7f47ea99 100644
--- a/libmpathpersist/libmpathpersist.version
+++ b/libmpathpersist/libmpathpersist.version
@@ -40,5 +40,4 @@ __LIBMPATHPERSIST_INT_2.0.0 {
 	mpath_alloc_prin_response;
 	prin_do_scsi_ioctl;
 	prout_do_scsi_ioctl;
-	update_map_pr;
 };
diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 9eb9c228..05cc416e 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -813,86 +813,3 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 	}
 	return ret;
 }
-
-int update_map_pr(struct multipath *mpp, struct path *pp)
-{
-	int noisy=0;
-	struct prin_resp *resp;
-	unsigned int i;
-	int ret = MPATH_PR_OTHER, isFound;
-	bool was_set = (mpp->prflag == PR_SET);
-
-	/* If pr is explicitly unset, it must be manually set */
-	if (mpp->prflag == PR_UNSET)
-		return MPATH_PR_SKIP;
-
-	if (!get_be64(mpp->reservation_key))
-	{
-		/* Nothing to do. Assuming pr mgmt feature is disabled*/
-		mpp->prflag = PR_UNSET;
-		condlog(was_set ? 2 : 4,
-			"%s: reservation_key not set in multipath.conf",
-			mpp->alias);
-		return MPATH_PR_SKIP;
-	}
-
-	resp = mpath_alloc_prin_response(MPATH_PRIN_RKEY_SA);
-	if (!resp)
-	{
-		condlog(0,"%s : failed to alloc resp in update_map_pr", mpp->alias);
-		return MPATH_PR_OTHER;
-	}
-
-	ret = prin_do_scsi_ioctl(pp->dev, MPATH_PRIN_RKEY_SA, resp, noisy);
-	if (ret != MPATH_PR_SUCCESS )
-	{
-		if (ret == MPATH_PR_ILLEGAL_REQ)
-			mpp->prflag = PR_UNSET;
-		condlog(0,"%s : pr in read keys service action failed Error=%d", mpp->alias, ret);
-		goto out;
-	}
-	mpp->prflag = PR_UNSET;
-
-	if (resp->prin_descriptor.prin_readkeys.additional_length == 0 )
-	{
-		condlog(was_set ? 1 : 3,
-			"%s: No key found. Device may not be registered. ",
-			mpp->alias);
-		goto out;
-	}
-
-	condlog(3, "%s: Multipath reservation_key: 0x%" PRIx64 " ", mpp->alias,
-		get_be64(mpp->reservation_key));
-
-	isFound =0;
-	for (i = 0; i < resp->prin_descriptor.prin_readkeys.additional_length/8; i++ )
-	{
-		if (libmp_verbosity >= 3) {
-			condlog(3, "%s: PR IN READKEYS[%d] reservation key:",
-				mpp->alias, i);
-			dumpHex((char *)&resp->prin_descriptor.prin_readkeys
-					.key_list[i * 8],
-				8, 1);
-		}
-
-		if (!memcmp(&mpp->reservation_key,
-			    &resp->prin_descriptor.prin_readkeys.key_list[i * 8],
-			    8)) {
-			condlog(3, "%s: reservation key found in pr in readkeys response",
-				mpp->alias);
-			isFound =1;
-		}
-	}
-
-	if (isFound)
-	{
-		mpp->prflag = PR_SET;
-		condlog(was_set ? 3 : 2, "%s: key found. prflag set.", mpp->alias);
-	} else
-		condlog(was_set ? 1 : 3, "%s: key not found. prflag unset.",
-			mpp->alias);
-
-out:
-	free(resp);
-	return ret;
-}
diff --git a/libmpathpersist/mpath_persist_int.h b/libmpathpersist/mpath_persist_int.h
index 7b32c1e2..4d23606b 100644
--- a/libmpathpersist/mpath_persist_int.h
+++ b/libmpathpersist/mpath_persist_int.h
@@ -19,7 +19,6 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 int prin_do_scsi_ioctl(char * dev, int rq_servact, struct prin_resp * resp, int noisy);
 int prout_do_scsi_ioctl( char * dev, int rq_servact, int rq_scope,
 			 unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy);
-void dumpHex(const char* , int len, int no_ascii);
-int update_map_pr(struct multipath *mpp, struct path *pp);
+void dumpHex(const char *, int len, int no_ascii);
 
 #endif /* MPATH_PERSIST_INT_H_INCLUDED */
diff --git a/multipathd/main.c b/multipathd/main.c
index 913d2b4d..99a2d5ca 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -4249,6 +4249,86 @@ static void check_prhold(struct multipath *mpp, struct path *pp)
 		mpp->prhold = PR_SET;
 }
 
+static int update_map_pr(struct multipath *mpp, struct path *pp)
+{
+	int noisy = 0;
+	struct prin_resp *resp;
+	unsigned int i;
+	int ret = MPATH_PR_OTHER, isFound;
+	bool was_set = (mpp->prflag == PR_SET);
+
+	/* If pr is explicitly unset, it must be manually set */
+	if (mpp->prflag == PR_UNSET)
+		return MPATH_PR_SKIP;
+
+	if (!get_be64(mpp->reservation_key)) {
+		/* Nothing to do. Assuming pr mgmt feature is disabled*/
+		mpp->prflag = PR_UNSET;
+		condlog(was_set ? 2 : 4,
+			"%s: reservation_key not set in multipath.conf",
+			mpp->alias);
+		return MPATH_PR_SKIP;
+	}
+
+	resp = mpath_alloc_prin_response(MPATH_PRIN_RKEY_SA);
+	if (!resp) {
+		condlog(0, "%s : failed to alloc resp in update_map_pr",
+			mpp->alias);
+		return MPATH_PR_OTHER;
+	}
+
+	ret = prin_do_scsi_ioctl(pp->dev, MPATH_PRIN_RKEY_SA, resp, noisy);
+	if (ret != MPATH_PR_SUCCESS) {
+		if (ret == MPATH_PR_ILLEGAL_REQ)
+			mpp->prflag = PR_UNSET;
+		condlog(0, "%s : pr in read keys service action failed Error=%d",
+			mpp->alias, ret);
+		goto out;
+	}
+	mpp->prflag = PR_UNSET;
+
+	if (resp->prin_descriptor.prin_readkeys.additional_length == 0) {
+		condlog(was_set ? 1 : 3,
+			"%s: No key found. Device may not be registered. ",
+			mpp->alias);
+		goto out;
+	}
+
+	condlog(3, "%s: Multipath reservation_key: 0x%" PRIx64 " ", mpp->alias,
+		get_be64(mpp->reservation_key));
+
+	isFound = 0;
+	for (i = 0;
+	     i < resp->prin_descriptor.prin_readkeys.additional_length / 8; i++) {
+		if (libmp_verbosity >= 3) {
+			condlog(3, "%s: PR IN READKEYS[%d] reservation key:",
+				mpp->alias, i);
+			dumpHex((char *)&resp->prin_descriptor.prin_readkeys
+					.key_list[i * 8],
+				8, 1);
+		}
+
+		if (!memcmp(&mpp->reservation_key,
+			    &resp->prin_descriptor.prin_readkeys.key_list[i * 8],
+			    8)) {
+			condlog(3, "%s: reservation key found in pr in readkeys response",
+				mpp->alias);
+			isFound = 1;
+		}
+	}
+
+	if (isFound) {
+		mpp->prflag = PR_SET;
+		condlog(was_set ? 3 : 2, "%s: key found. prflag set.", mpp->alias);
+	} else
+		condlog(was_set ? 1 : 3, "%s: key not found. prflag unset.",
+			mpp->alias);
+
+out:
+	free(resp);
+	return ret;
+}
+
 static void mpath_pr_event_handle(struct path *pp)
 {
 	struct multipath *mpp = pp->mpp;
-- 
2.50.1

