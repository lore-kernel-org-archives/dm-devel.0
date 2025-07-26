Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8568F1EA7C6
	for <dm-devel@lists.linux.dev>; Sat, 26 Jul 2025 03:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753502346; cv=none; b=gtR/yH5YNDza96j2svtRVCXBKwraIrTwkGXuNBmILknEJpeRzlXi1avokBorVovdnpnVl/V0F7LYXjkgw7QWtw4+nHDMU1R3tKEY3ZabLg8i7IJKx0jsk9OC++VA0V+yoshly7d5R39Nnr+lQblr/++ewLN13JRLXht/wuN2fa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753502346; c=relaxed/simple;
	bh=ekSywV7YlpwlCc/FU04wC3HTBN0lg/rSQAwsRkKHmxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=barLZPBkbr4SxWalIHeiBaFDIDPE7Wh7je5AmBTKCSgPG5QSG/2J8D1Rf0smXl+DGNYHDvc0o/F+vfnBJ66hIl9C4v+X5Gly5KzHuFnEl+sAd6O3l8H80iEcvrZnECv0XhnCc04EBNHRlzgq5EmFluqGltzB1FPB8rQicgM/HTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fALBBEbG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fALBBEbG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753502343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=faOQLo+PbG0RFSiqId4jvlTOlYxXR0zSVnfSivVWPuA=;
	b=fALBBEbG+/bWZjEEtUMMme1p1yx8YWnXJPFSu2I2sdrA+9pqijxLMuUb5RGIBZBP0fyrkY
	RJTuQhnT49fxR0Yt90UcLnLojnkxmtVgd+GJxL/sOeWYSf+8dLwmBmd7/W14YwhFxCaVOu
	2HI+Bl5xEBCXVx0TBISN1ocZZ9iIhRg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-695-ZCgW8vUlOJOy89yqqTnWFg-1; Fri,
 25 Jul 2025 23:58:59 -0400
X-MC-Unique: ZCgW8vUlOJOy89yqqTnWFg-1
X-Mimecast-MFC-AGG-ID: ZCgW8vUlOJOy89yqqTnWFg_1753502338
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BEF9219560A2;
	Sat, 26 Jul 2025 03:58:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6AA871966667;
	Sat, 26 Jul 2025 03:58:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 56Q3wvxK363325
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 25 Jul 2025 23:58:57 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 56Q3wv4J363324;
	Fri, 25 Jul 2025 23:58:57 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 03/14] multipathd: clean up update_map_pr and mpath_pr_event_handle
Date: Fri, 25 Jul 2025 23:58:44 -0400
Message-ID: <20250726035855.363290-4-bmarzins@redhat.com>
In-Reply-To: <20250726035855.363290-1-bmarzins@redhat.com>
References: <20250726035855.363290-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kGzhQu4rRQLszn6fVOTcPfFgOgz0veS-wdV7DjHb-g8_1753502338
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
 multipathd/main.c | 69 +++++++++++++++++------------------------------
 1 file changed, 24 insertions(+), 45 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index fd0c0dba..0e95ca3a 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -4251,7 +4251,7 @@ static void check_prhold(struct multipath *mpp, struct path *pp)
 static int update_map_pr(struct multipath *mpp, struct path *pp)
 {
 	int noisy=0;
-	struct prin_resp *resp;
+	struct prin_resp resp;
 	unsigned int i;
 	int ret = MPATH_PR_OTHER, isFound;
 	bool was_set = (mpp->prflag == PR_SET);
@@ -4260,57 +4260,42 @@ static int update_map_pr(struct multipath *mpp, struct path *pp)
 	if (mpp->prflag == PR_UNSET)
 		return MPATH_PR_SKIP;
 
-	if (!get_be64(mpp->reservation_key))
-	{
+	if (!get_be64(mpp->reservation_key)) {
 		/* Nothing to do. Assuming pr mgmt feature is disabled*/
 		mpp->prflag = PR_UNSET;
 		condlog(was_set ? 2 : 4, "%s: reservation_key not set in multipath.conf", mpp->alias);
 		return MPATH_PR_SKIP;
 	}
 
-	resp = mpath_alloc_prin_response(MPATH_PRIN_RKEY_SA);
-	if (!resp)
-	{
-		condlog(0,"%s : failed to alloc resp in update_map_pr", mpp->alias);
-		return MPATH_PR_OTHER;
-	}
+	memset(&resp, 0, sizeof(resp));
 
-	ret = prin_do_scsi_ioctl(pp->dev, MPATH_PRIN_RKEY_SA, resp, noisy);
-	if (ret != MPATH_PR_SUCCESS )
-	{
+	ret = prin_do_scsi_ioctl(pp->dev, MPATH_PRIN_RKEY_SA, &resp, noisy);
+	if (ret != MPATH_PR_SUCCESS) {
 		if (ret == MPATH_PR_ILLEGAL_REQ)
 			mpp->prflag = PR_UNSET;
 		condlog(0,"%s : pr in read keys service action failed Error=%d", mpp->alias, ret);
-		goto out;
+		return ret;
 	}
 	mpp->prflag = PR_UNSET;
 
-	if (resp->prin_descriptor.prin_readkeys.additional_length == 0 )
-	{
-		condlog(was_set ? 1 : 3, "%s: No key found. Device may not be registered. ", mpp->alias);
-		goto out;
-	}
-
-	condlog(3, "%s: Multipath reservation_key: 0x%" PRIx64 " ", mpp->alias,
+	condlog(4, "%s: Multipath reservation_key: 0x%" PRIx64 " ", mpp->alias,
 		get_be64(mpp->reservation_key));
 
-	isFound =0;
-	for (i = 0; i < resp->prin_descriptor.prin_readkeys.additional_length/8; i++ )
-	{
-		if (libmp_verbosity >= 3) {
-			condlog(3, "%s: PR IN READKEYS[%d] reservation key:",
+	isFound = 0;
+	for (i = 0; i < resp.prin_descriptor.prin_readkeys.additional_length / 8; i++) {
+		uint8_t *keyp = &resp.prin_descriptor.prin_readkeys.key_list[i * 8];
+
+		if (libmp_verbosity >= 4) {
+			condlog(4, "%s: PR IN READKEYS[%d] reservation key:",
 				mpp->alias, i);
-			dumpHex((char *)&resp->prin_descriptor.prin_readkeys.key_list[i * 8], 8, 1);
+			dumpHex((char *)keyp, 8, 1);
 		}
 
-		if (!memcmp(&mpp->reservation_key, &resp->prin_descriptor.prin_readkeys.key_list[i * 8], 8)) {
-			condlog(3, "%s: reservation key found in pr in readkeys response", mpp->alias);
-			isFound =1;
-		}
+		if (!memcmp(&mpp->reservation_key, keyp, 8))
+			isFound = 1;
 	}
 
-	if (isFound)
-	{
+	if (isFound) {
 		mpp->prflag = PR_SET;
 		condlog(was_set ? 3 : 2, "%s: key found. prflag set.",
 			mpp->alias);
@@ -4318,16 +4303,14 @@ static int update_map_pr(struct multipath *mpp, struct path *pp)
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
@@ -4345,21 +4328,17 @@ static void mpath_pr_event_handle(struct path *pp)
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
2.48.1

