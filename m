Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF20B635
	for <dm-devel@lists.linux.dev>; Sat, 26 Jul 2025 03:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753502344; cv=none; b=qF+0n3uhFnn5XoMATOWdEgcCVC1m1KEg15z1LTCB3zxBvEAPsQozjW313eKe1zhq4P1vh6alnemNwrvPmytk+LE6TWU2Gyj+F2nT6xSKsTlNBW/wP1YRW6JDSY2kDw1RKyvwLoFpW0bkocpUlMprOUFYo87zlX4jTwmq9vtIeoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753502344; c=relaxed/simple;
	bh=5NV49hcQsb0+7eGaWqSRTcE2BTWSje5BEjy+fQsI/1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=PYtFPEMfm1aEfsBY26C8VWkIGDXZejqjTPcn9TIsjGRdQZoqA16zfOWiQAuV/imfnduhAbTM25yHaU+FN8YZUNlh+H/DcJ3LF2Y3CCYWR0gPN8z/LuOGbt4tmJmNP62pNIKrodtaRaPdykmDpMPOO4u/o4WnvCapXiqaEdBNXwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hFue4KGT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hFue4KGT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753502341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YO0Dh6h3vJCWDZVj65nmDTmLbCIB5YX0b/QAl7zBb0A=;
	b=hFue4KGT9XDZEIB69Sn3Xc0TnhKjSE3DMg/+4+5axtkNTuZIFYmU3pbSJGEBGGLLhZ/sDl
	gMpC+Bbf6n6TW0vBnY6ncNqNMMg0HvbY90shdfPFWeEgCn0jNE4jxu5nIAAOei24MROiGU
	PxtmiDT4zmRRBvVo4hSvGFuhUZn9obI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-459--J3DOZUfNgae83SVBLwkUA-1; Fri,
 25 Jul 2025 23:58:59 -0400
X-MC-Unique: -J3DOZUfNgae83SVBLwkUA-1
X-Mimecast-MFC-AGG-ID: -J3DOZUfNgae83SVBLwkUA_1753502338
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9CB96180048E;
	Sat, 26 Jul 2025 03:58:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 318B13000199;
	Sat, 26 Jul 2025 03:58:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 56Q3wvJZ363317
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 25 Jul 2025 23:58:57 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 56Q3wueA363316;
	Fri, 25 Jul 2025 23:58:56 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 01/14] limpathpersist: remove update_map_pr code for NULL pp
Date: Fri, 25 Jul 2025 23:58:42 -0400
Message-ID: <20250726035855.363290-2-bmarzins@redhat.com>
In-Reply-To: <20250726035855.363290-1-bmarzins@redhat.com>
References: <20250726035855.363290-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jLgb3NBZz-mDmf2PnBJDM6wLYm1Sp7art7CvIIiUzdI_1753502338
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Since update_map_pr is always called with pp set now, remove the code
to handle being called with NULL pp.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 91f0d018..afd19bef 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -833,18 +833,8 @@ int update_map_pr(struct multipath *mpp, struct path *pp)
 		condlog(0,"%s : failed to alloc resp in update_map_pr", mpp->alias);
 		return MPATH_PR_OTHER;
 	}
-	if (!pp && count_active_paths(mpp) == 0) {
-		condlog(2, "%s: No available paths to check pr status",
-			mpp->alias);
-		goto out;
-	}
-	if (pp)
-		ret = prin_do_scsi_ioctl(pp->dev, MPATH_PRIN_RKEY_SA, resp,
-					 noisy);
-	else
-		ret = mpath_prin_activepath(mpp, MPATH_PRIN_RKEY_SA, resp,
-					    noisy);
 
+	ret = prin_do_scsi_ioctl(pp->dev, MPATH_PRIN_RKEY_SA, resp, noisy);
 	if (ret != MPATH_PR_SUCCESS )
 	{
 		if (ret == MPATH_PR_ILLEGAL_REQ)
-- 
2.48.1

