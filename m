Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC163128AC
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 00:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376015; cv=none; b=pkcsNXPGhZ1slGvEDO+GAvGIaajn7jIlIv43AF9wSFnRqg7R7/PhEMRfnpdtLA8VajiXw3fSnhk5b39FbPRS67Ud5AkIe14MyZ0HEe0OC7cTtpnHW84Behlnnrpod5XZqnqwFp3Ad2Akzr2u4XpqsJ/WapLDvH897AvsK32XcY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376015; c=relaxed/simple;
	bh=IjuWxMjMiAvmQarUn+HpSf4QipCQ54+vTwlf4kT961s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=RmuDNTpY9lUly35OX65PsyPWcYiLBLYbo6DDXsGlA+UB7sZbGI3Dj50v4HUvbcLBgnviKIsRviEUAw4lH51x3M7wWu+Xc+0R8jPGtzpYku1wJbhSj1xUsxdWQGgALsBsLslT2NzZ4RtyKzP/Az8LayaDtEpUlYPnC1wXTt4BEwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PZf+so9o; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PZf+so9o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757376011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VdoV9sbABZ7ib4UhrmPN02k1SZGQTnbbL4L0xvvMba4=;
	b=PZf+so9ollHqJgKZgr2J9LQG0OBA7ndvw2nQeZlzR/uVb/H/DbqlENZo/upf6pVl6t/gb1
	x9/bLdJhxsKfXz+KiddZhIYslzOmHkWdDZIzF90uaTZH0MyYb5Zo1SIYqh5TmDz7UAPkp5
	EaVM60/fhnpBZDMri6BaxciFSElA/x0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-638-9nc9OmiHPY6h46xwFkLM5A-1; Mon,
 08 Sep 2025 20:00:09 -0400
X-MC-Unique: 9nc9OmiHPY6h46xwFkLM5A-1
X-Mimecast-MFC-AGG-ID: 9nc9OmiHPY6h46xwFkLM5A_1757376008
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CA270180057D;
	Tue,  9 Sep 2025 00:00:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 89D8A19560A2;
	Tue,  9 Sep 2025 00:00:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 589006Nq751155
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 20:00:06 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 589006ZU751154;
	Mon, 8 Sep 2025 20:00:06 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 18/32] multipathd: clean up update_map_pr and mpath_pr_event_handle
Date: Mon,  8 Sep 2025 19:59:48 -0400
Message-ID: <20250909000002.751039-19-bmarzins@redhat.com>
In-Reply-To: <20250909000002.751039-1-bmarzins@redhat.com>
References: <20250909000002.751039-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sTaDOeXzFB8GwSzbjJgoimAIvvJt8Urfaifaz4Y4d3Y_1757376008
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Store the READ KEYS response and the prout_param_descriptor on the stack
to avoid having to fail these functions for allocation reasons. Don't
explicitly check for additional_length == 0, since the for-loop already
handles that.  Also cleanup formatting issues,remove redundant messages,
and reduce the log level of others.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 62 +++++++++++++++--------------------------------
 1 file changed, 19 insertions(+), 43 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 99a2d5ca..394fd47a 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -4251,8 +4251,7 @@ static void check_prhold(struct multipath *mpp, struct path *pp)
 
 static int update_map_pr(struct multipath *mpp, struct path *pp)
 {
-	int noisy = 0;
-	struct prin_resp *resp;
+	struct prin_resp resp;
 	unsigned int i;
 	int ret = MPATH_PR_OTHER, isFound;
 	bool was_set = (mpp->prflag == PR_SET);
@@ -4270,51 +4269,34 @@ static int update_map_pr(struct multipath *mpp, struct path *pp)
 		return MPATH_PR_SKIP;
 	}
 
-	resp = mpath_alloc_prin_response(MPATH_PRIN_RKEY_SA);
-	if (!resp) {
-		condlog(0, "%s : failed to alloc resp in update_map_pr",
-			mpp->alias);
-		return MPATH_PR_OTHER;
-	}
+	memset(&resp, 0, sizeof(resp));
 
-	ret = prin_do_scsi_ioctl(pp->dev, MPATH_PRIN_RKEY_SA, resp, noisy);
+	ret = prin_do_scsi_ioctl(pp->dev, MPATH_PRIN_RKEY_SA, &resp, 0);
 	if (ret != MPATH_PR_SUCCESS) {
 		if (ret == MPATH_PR_ILLEGAL_REQ)
 			mpp->prflag = PR_UNSET;
 		condlog(0, "%s : pr in read keys service action failed Error=%d",
 			mpp->alias, ret);
-		goto out;
+		return ret;
 	}
 	mpp->prflag = PR_UNSET;
 
-	if (resp->prin_descriptor.prin_readkeys.additional_length == 0) {
-		condlog(was_set ? 1 : 3,
-			"%s: No key found. Device may not be registered. ",
-			mpp->alias);
-		goto out;
-	}
-
-	condlog(3, "%s: Multipath reservation_key: 0x%" PRIx64 " ", mpp->alias,
+	condlog(4, "%s: Multipath reservation_key: 0x%" PRIx64 " ", mpp->alias,
 		get_be64(mpp->reservation_key));
 
 	isFound = 0;
 	for (i = 0;
-	     i < resp->prin_descriptor.prin_readkeys.additional_length / 8; i++) {
-		if (libmp_verbosity >= 3) {
-			condlog(3, "%s: PR IN READKEYS[%d] reservation key:",
+	     i < resp.prin_descriptor.prin_readkeys.additional_length / 8; i++) {
+		uint8_t *keyp = &resp.prin_descriptor.prin_readkeys.key_list[i * 8];
+
+		if (libmp_verbosity >= 4) {
+			condlog(4, "%s: PR IN READKEYS[%d] reservation key:",
 				mpp->alias, i);
-			dumpHex((char *)&resp->prin_descriptor.prin_readkeys
-					.key_list[i * 8],
-				8, 1);
+			dumpHex((char *)keyp, 8, 1);
 		}
 
-		if (!memcmp(&mpp->reservation_key,
-			    &resp->prin_descriptor.prin_readkeys.key_list[i * 8],
-			    8)) {
-			condlog(3, "%s: reservation key found in pr in readkeys response",
-				mpp->alias);
+		if (!memcmp(&mpp->reservation_key, keyp, 8))
 			isFound = 1;
-		}
 	}
 
 	if (isFound) {
@@ -4324,16 +4306,14 @@ static int update_map_pr(struct multipath *mpp, struct path *pp)
 		condlog(was_set ? 1 : 3, "%s: key not found. prflag unset.",
 			mpp->alias);
 
-out:
-	free(resp);
-	return ret;
+	return MPATH_PR_SUCCESS;
 }
 
 static void mpath_pr_event_handle(struct path *pp)
 {
 	struct multipath *mpp = pp->mpp;
 	int ret;
-	struct prout_param_descriptor *param;
+	struct prout_param_descriptor param;
 
 	if (pp->bus != SYSFS_BUS_SCSI) {
 		mpp->prflag = PR_UNSET;
@@ -4351,21 +4331,17 @@ static void mpath_pr_event_handle(struct path *pp)
 	if (mpp->prflag != PR_SET)
 		return;
 
-	param = (struct prout_param_descriptor *)calloc(1, sizeof(struct prout_param_descriptor));
-	if (!param)
-		return;
+	memset(&param, 0, sizeof(param));
 
-	param->sa_flags = mpp->sa_flags;
-	memcpy(param->sa_key, &mpp->reservation_key, 8);
-	param->num_transportid = 0;
+	param.sa_flags = mpp->sa_flags;
+	memcpy(param.sa_key, &mpp->reservation_key, 8);
+	param.num_transportid = 0;
 
 	condlog(3, "device %s:%s", pp->dev, pp->mpp->wwid);
 
-	ret = prout_do_scsi_ioctl(pp->dev, MPATH_PROUT_REG_IGN_SA, 0, 0, param, 0);
+	ret = prout_do_scsi_ioctl(pp->dev, MPATH_PROUT_REG_IGN_SA, 0, 0, &param, 0);
 	if (ret != MPATH_PR_SUCCESS )
 	{
 		condlog(0,"%s: Reservation registration failed. Error: %d", pp->dev, ret);
 	}
-
-	free(param);
 }
-- 
2.50.1

