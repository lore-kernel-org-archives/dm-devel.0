Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACA630ACE3
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 00:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376013; cv=none; b=TyicpK+XYRNaBZhwijn3YZF/mKPjvE9vmeTo505XktykDdgkNLtmYXmQQ+WKZtA4LiGhnJtSH3sR2Q/cY46f1UJ1Q07iolQSVzPIOcqnuBIlju5jbRxuz/z3C1Vacdp+fIQwyNFjleFWFs0itQpyEdRik97okIey0159FJNJddc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376013; c=relaxed/simple;
	bh=sjullb1g1DYrm4qF0Plnw8wakehBQDTwlzznD+L+w8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=FXic3UHXCUNhLzMzWml+AnlC87FOs8Vvt+ySAZrOfHXeEGtzNOEc+QilN+ul6BN2CIJxZvJ8+hyJV6zyaFSYWcV+31TnGCcD05/jPOzwmHT/R7c2QtpD31+fxx7f0EkLQkKC/NK6XIqbczNJ3Ar5YSaz1TjLh2XTPAiEuXUhJUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=acxIhO56; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="acxIhO56"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757376010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yixG5Taw6x6PXeA1hGWvthNJIpHhGsSL/kI3bJ9mI+s=;
	b=acxIhO56mtpCrOswUpIf6RUIMfVsTr4bqfZtQNX39MXKhs0ui0LHp73m8tUfzSu4jQ4k0F
	cp/VjVkHDYpCtuNlJAeH7phwVHsl3Ja5g3XpYqjK3ao/ZT/VCkX/rHme4PIwzo8MuiphLx
	GxVshUgAkWZ9PdR3B16qyxgzpBdDdr8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-567-W4D_KVfVPueYuFKMyIkVqw-1; Mon,
 08 Sep 2025 20:00:06 -0400
X-MC-Unique: W4D_KVfVPueYuFKMyIkVqw-1
X-Mimecast-MFC-AGG-ID: W4D_KVfVPueYuFKMyIkVqw_1757376005
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A9871180034F;
	Tue,  9 Sep 2025 00:00:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 54DE01800446;
	Tue,  9 Sep 2025 00:00:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 589004bu751092
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 20:00:04 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5890049G751091;
	Mon, 8 Sep 2025 20:00:04 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 03/32] libmpathpersist: reduce log level for persistent reservation checking
Date: Mon,  8 Sep 2025 19:59:33 -0400
Message-ID: <20250909000002.751039-4-bmarzins@redhat.com>
In-Reply-To: <20250909000002.751039-1-bmarzins@redhat.com>
References: <20250909000002.751039-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5kIcv0tqL8BWxIX72BFsdmrxy_d-iOerJPwEL4_OE3g_1757376005
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Move logging of minor expected behavior to INFO level. Modify the log
level of some messages by whether or not mpp->prflag changed values.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist_int.c | 34 +++++++++++++++++++----------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 5ec896bd..95fa36db 100644
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
@@ -725,12 +725,14 @@ int update_map_pr(struct multipath *mpp)
 	struct prin_resp *resp;
 	unsigned int i;
 	int ret = MPATH_PR_OTHER, isFound;
+	bool was_set = (mpp->prflag == PRFLAG_SET);
 
 	if (!get_be64(mpp->reservation_key))
 	{
 		/* Nothing to do. Assuming pr mgmt feature is disabled*/
 		mpp->prflag = PRFLAG_UNSET;
-		condlog(4, "%s: reservation_key not set in multipath.conf",
+		condlog(was_set ? 2 : 4,
+			"%s: reservation_key not set in multipath.conf",
 			mpp->alias);
 		return MPATH_PR_SUCCESS;
 	}
@@ -743,8 +745,7 @@ int update_map_pr(struct multipath *mpp)
 	}
 	if (count_active_paths(mpp) == 0)
 	{
-		condlog(0,"%s: No available paths to check pr status",
-			mpp->alias);
+		condlog(2, "%s: No available paths to check pr status", mpp->alias);
 		goto out;
 	}
 	mpp->prflag = PRFLAG_UNSET;
@@ -760,22 +761,31 @@ int update_map_pr(struct multipath *mpp)
 
 	if (resp->prin_descriptor.prin_readkeys.additional_length == 0 )
 	{
-		condlog(3,"%s: No key found. Device may not be registered. ", mpp->alias);
+		condlog(was_set ? 1 : 3,
+			"%s: No key found. Device may not be registered. ",
+			mpp->alias);
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
+			dumpHex((char *)&resp->prin_descriptor.prin_readkeys
+					.key_list[i * 8],
+				8, 1);
+		}
 
-		if (!memcmp(&mpp->reservation_key, &resp->prin_descriptor.prin_readkeys.key_list[i*8], 8))
-		{
-			condlog(2, "%s: reservation key found in pr in readkeys response", mpp->alias);
+		if (!memcmp(&mpp->reservation_key,
+			    &resp->prin_descriptor.prin_readkeys.key_list[i * 8],
+			    8)) {
+			condlog(3, "%s: reservation key found in pr in readkeys response",
+				mpp->alias);
 			isFound =1;
 		}
 	}
@@ -783,7 +793,7 @@ int update_map_pr(struct multipath *mpp)
 	if (isFound)
 	{
 		mpp->prflag = PRFLAG_SET;
-		condlog(2, "%s: prflag flag set.", mpp->alias );
+		condlog(was_set ? 3 : 2, "%s: prflag flag set.", mpp->alias);
 	}
 
 out:
-- 
2.50.1

