Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A332FCE09
	for <dm-devel@lists.linux.dev>; Thu, 10 Jul 2025 18:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752171068; cv=none; b=hLz4/X3MhWtfJHFlsx3mESPAfnyg835/UBX8n+sJTUjqBNe+0dcq2fTTcqRGulEraOUqAoDbM2kFZV7llzig8oAe/DVmHKLOcCScEf70zTERI1OB3G62oS3bs9y7S+fmmoKdu6eGZ4jRB6/LfcrcBk+pViwiQ/GWyIT2jFqHlro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752171068; c=relaxed/simple;
	bh=NW4bbIS64+iksyEB/CxHrqrohIt6S6kuL9TDA4iBMB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=dguPuXmfpTfM6uNJRVAgV7PLzV+JP6mZAnoGVs7XQtR+TlhFrlXjpcSdheAW2WGLNlejEc9KbH+xkQRJGcHgX+Z2VgtMNodaY4lTXlVzvXfTVlR0c7k8pOwcl6QmPKCoZaEDjL1V4ARPxyvyDZ64SCFOmYI+Lp6sYIPnVLVMIF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Yb0BvePd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yb0BvePd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752171066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OhylItWmebKrlhYnkQfUVYWIYkxtLIiFVKQWeyXhkRo=;
	b=Yb0BvePdZ1gxPcumcZSjgCUL/FXD3AApJUhimsCWq3o2oCyNV+pOFeAlUx2WyfajDAlzc9
	c4aHr7h11vE6LhNoQF5FlbJxeomsLQwRY+AEAfjKJavc+mhc1A/eH810AoEumYBlkAJid9
	0u3hhQh+QDtTGUCzQv3gdpXFe7wDGiI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-395-1PE_UpMzNXyX3DdEI0PmPw-1; Thu,
 10 Jul 2025 14:11:04 -0400
X-MC-Unique: 1PE_UpMzNXyX3DdEI0PmPw-1
X-Mimecast-MFC-AGG-ID: 1PE_UpMzNXyX3DdEI0PmPw_1752171063
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7576E1800366;
	Thu, 10 Jul 2025 18:11:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 317291956094;
	Thu, 10 Jul 2025 18:11:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 56AIB1973997795
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Jul 2025 14:11:01 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 56AIB1aR3997794;
	Thu, 10 Jul 2025 14:11:01 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 03/15] libmpathpersist: reduce log level for persistent reservation checking
Date: Thu, 10 Jul 2025 14:10:48 -0400
Message-ID: <20250710181100.3997759-4-bmarzins@redhat.com>
In-Reply-To: <20250710181100.3997759-1-bmarzins@redhat.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YQjJYOmjoijYty7Ri8S4gs00h_fB7N_a476RphMgknc_1752171063
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Move logging of minor expected behavior to INFO level. Modify the log
level of some messages by whether or not mpp->prflag changed values.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 612bbed9..4172167a 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -60,7 +60,7 @@ static int mpath_prin_activepath (struct multipath *mpp, int rq_servact,
 		vector_foreach_slot (pgp->paths, pp, i){
 			if (!((pp->state == PATH_UP) ||
 			      (pp->state == PATH_GHOST))){
-				condlog(2, "%s: %s not available. Skip.",
+				condlog(3, "%s: %s not available. Skip.",
 					mpp->wwid, pp->dev);
 				condlog(3, "%s: status = %d.",
 					mpp->wwid, pp->state);
@@ -726,13 +726,13 @@ int update_map_pr(struct multipath *mpp)
 	struct prin_resp *resp;
 	unsigned int i;
 	int ret = MPATH_PR_OTHER, isFound;
+	bool was_set = (mpp->prflag == PRFLAG_SET);
 
 	if (!get_be64(mpp->reservation_key))
 	{
 		/* Nothing to do. Assuming pr mgmt feature is disabled*/
 		mpp->prflag = PRFLAG_UNSET;
-		condlog(4, "%s: reservation_key not set in multipath.conf",
-			mpp->alias);
+		condlog(was_set ? 2 : 4, "%s: reservation_key not set in multipath.conf", mpp->alias);
 		return MPATH_PR_SUCCESS;
 	}
 
@@ -744,7 +744,7 @@ int update_map_pr(struct multipath *mpp)
 	}
 	if (count_active_paths(mpp) == 0)
 	{
-		condlog(0,"%s: No available paths to check pr status",
+		condlog(2, "%s: No available paths to check pr status",
 			mpp->alias);
 		goto out;
 	}
@@ -761,22 +761,24 @@ int update_map_pr(struct multipath *mpp)
 
 	if (resp->prin_descriptor.prin_readkeys.additional_length == 0 )
 	{
-		condlog(3,"%s: No key found. Device may not be registered. ", mpp->alias);
+		condlog(was_set ? 1 : 3, "%s: No key found. Device may not be registered. ", mpp->alias);
 		goto out;
 	}
 
-	condlog(2, "%s: Multipath  reservation_key: 0x%" PRIx64 " ", mpp->alias,
+	condlog(3, "%s: Multipath reservation_key: 0x%" PRIx64 " ", mpp->alias,
 		get_be64(mpp->reservation_key));
 
 	isFound =0;
 	for (i = 0; i < resp->prin_descriptor.prin_readkeys.additional_length/8; i++ )
 	{
-		condlog(2, "%s: PR IN READKEYS[%d]  reservation key:", mpp->alias, i);
-		dumpHex((char *)&resp->prin_descriptor.prin_readkeys.key_list[i*8], 8 , 1);
+		if (libmp_verbosity >= 3) {
+			condlog(3, "%s: PR IN READKEYS[%d] reservation key:",
+				mpp->alias, i);
+			dumpHex((char *)&resp->prin_descriptor.prin_readkeys.key_list[i * 8], 8, 1);
+		}
 
-		if (!memcmp(&mpp->reservation_key, &resp->prin_descriptor.prin_readkeys.key_list[i*8], 8))
-		{
-			condlog(2, "%s: reservation key found in pr in readkeys response", mpp->alias);
+		if (!memcmp(&mpp->reservation_key, &resp->prin_descriptor.prin_readkeys.key_list[i * 8], 8)) {
+			condlog(3, "%s: reservation key found in pr in readkeys response", mpp->alias);
 			isFound =1;
 		}
 	}
@@ -784,7 +786,7 @@ int update_map_pr(struct multipath *mpp)
 	if (isFound)
 	{
 		mpp->prflag = PRFLAG_SET;
-		condlog(2, "%s: prflag flag set.", mpp->alias );
+		condlog(was_set ? 3 : 2, "%s: prflag flag set.", mpp->alias );
 	}
 
 out:
-- 
2.48.1

