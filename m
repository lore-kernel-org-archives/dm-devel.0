Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397A02DAFD7
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 00:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376012; cv=none; b=aqAKvVwRzzxOBs5F1x6AxcAMEd9DyBBU66HFtqKIqNsLT3SL+atLka7sEM1se1I8XWxWlnyHyru3PdHuqUmK84VEQDZsqwouShcDYA6G/6rshsfjqsaA36H9Dm+QwXcQ6GLetJ6qJZJOKZBskXw3ciW34cAQ1YgNXlfBYsWnFr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376012; c=relaxed/simple;
	bh=bm4xa+kDiY4DBsaJD7dOS+d5fCNcyNozAq6mO1YIaMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=H6Q4TfzkVv3L27ZFi8DcdxfenI7IrwNGdV/lJXsNQ2C9+EmnM7kVdRkaLRTlyImroqVveD2Cb9jjdYZEQDbEMgVfGeo95QFxNVfDjXK2ueHFzygzkhbsqtVQP1UmoJIEkJSQP/E8YDnu2uWz9ADF6MWH06MRCQUfG4qutaSyql8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=adrraSM5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="adrraSM5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757376010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hcuGDkCfztqtU/uxdl5lWKIbpIfEoQebrUvAOHiRqVg=;
	b=adrraSM5TmnYpOEJA8lF8WUc59HaFBQi4L/yymVTVWYd/Yy2yVGI6X7QROWcMnL30hmQox
	jdlrNjNF05bx45CD0413IJDHMqdT0OOvi8eeRYIbjDToiJEZ+92gCofLa9TOdxeKfoWuBB
	VJyfaVWYffh1KKhzW2OBhxoX4n5648s=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-496-Nr4t__zSNTuCYbSQ6JDV2w-1; Mon,
 08 Sep 2025 20:00:08 -0400
X-MC-Unique: Nr4t__zSNTuCYbSQ6JDV2w-1
X-Mimecast-MFC-AGG-ID: Nr4t__zSNTuCYbSQ6JDV2w_1757376007
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 77D3A19560AF;
	Tue,  9 Sep 2025 00:00:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3867B3000198;
	Tue,  9 Sep 2025 00:00:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 589006Ma751147
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 20:00:06 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 589005ST751146;
	Mon, 8 Sep 2025 20:00:05 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 16/32] libmpathpersist: remove update_map_pr code for NULL pp
Date: Mon,  8 Sep 2025 19:59:46 -0400
Message-ID: <20250909000002.751039-17-bmarzins@redhat.com>
In-Reply-To: <20250909000002.751039-1-bmarzins@redhat.com>
References: <20250909000002.751039-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SMk4NzBR9uKeFRDx7TznYkekoIPGtxlMnApI5hVWDTU_1757376007
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Since update_map_pr is always called with pp set now, remove the code
to handle being called with NULL pp.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist_int.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 63682ee9..9eb9c228 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -842,15 +842,8 @@ int update_map_pr(struct multipath *mpp, struct path *pp)
 		condlog(0,"%s : failed to alloc resp in update_map_pr", mpp->alias);
 		return MPATH_PR_OTHER;
 	}
-	if (!pp && count_active_paths(mpp) == 0) {
-		condlog(2, "%s: No available paths to check pr status", mpp->alias);
-		goto out;
-	}
-	if (pp)
-		ret = prin_do_scsi_ioctl(pp->dev, MPATH_PRIN_RKEY_SA, resp, noisy);
-	else
-		ret = mpath_prin_activepath(mpp, MPATH_PRIN_RKEY_SA, resp, noisy);
 
+	ret = prin_do_scsi_ioctl(pp->dev, MPATH_PRIN_RKEY_SA, resp, noisy);
 	if (ret != MPATH_PR_SUCCESS )
 	{
 		if (ret == MPATH_PR_ILLEGAL_REQ)
-- 
2.50.1

