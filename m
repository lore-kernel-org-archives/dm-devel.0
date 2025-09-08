Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BFC305061
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 00:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376011; cv=none; b=Cr//wTaNFfw5XcQ67PS2+ce9K+t1bWv6xWyk1lQlUboxkswF6MfZN+RnaP+IsPfuXOgklRNk2zlaam+K0agThJOt+qL0ojSn6aQoTWUr88W+fRekmUyGPwfB9bh0991S3E/2qis35Qoh3SnsQC3xm+IxDuh/5dmdo1xLob5d/h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376011; c=relaxed/simple;
	bh=tCuekgJjS/5ItVmaxBaNdXk43XQYJpEWUVpAikorU7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=tFg4cFDFKeSLM2o/XMuxKElRGIpwndYWFdf13xV38j+RcK1fodG+xTZsq4uLuW8mSjeDVU3Af8GygLpZIg3z2WHJuxb7uHcL6i44s88pVdzYjDVrZT2oOTj5HWTGSQ0SJP/eOlluNjf8PF0+vn3NkCt5a1IVvh1jGAwscpj0FHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h5YvU3Tn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h5YvU3Tn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757376009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wVGMF7SVjfKI/A948HiIpHaT2ojuBkjxavp7Dcu533Q=;
	b=h5YvU3TnRBNXY7MZ5y3dCkq3V0BjUai6w+nSYTaumdCGztoTeSE5hovtrLKRZnsQHFqykC
	nx07DHUgl/vdJdOXsGJqFYxC0mK63nvGA0fPcwqY7SdumZEqFdCHiOqc+r/Nbe6QP1uNOm
	fw3Y3unjoZ8mWm7r9y2+mG00Dhw+nbw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-388-gHp7MXh2OyG_25s6qf3ylA-1; Mon,
 08 Sep 2025 20:00:07 -0400
X-MC-Unique: gHp7MXh2OyG_25s6qf3ylA-1
X-Mimecast-MFC-AGG-ID: gHp7MXh2OyG_25s6qf3ylA_1757376005
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B796D180057E;
	Tue,  9 Sep 2025 00:00:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6EE131800452;
	Tue,  9 Sep 2025 00:00:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 589004HC751096
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 20:00:04 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 589004Vx751095;
	Mon, 8 Sep 2025 20:00:04 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 04/32] libmpathpersist: remove pointless update_map_pr ret value code
Date: Mon,  8 Sep 2025 19:59:34 -0400
Message-ID: <20250909000002.751039-5-bmarzins@redhat.com>
In-Reply-To: <20250909000002.751039-1-bmarzins@redhat.com>
References: <20250909000002.751039-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: E88Qho_2r5dDiB_noqFUMuBw9EoLT24bwrA70zHNWqI_1757376005
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Don't set ret to MPATH_PR_SUCCESS, after the code just made sure that
it was already set to MPATH_PR_SUCCESS.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist_int.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 95fa36db..e9cdb690 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -757,8 +757,6 @@ int update_map_pr(struct multipath *mpp)
 		goto out;
 	}
 
-	ret = MPATH_PR_SUCCESS;
-
 	if (resp->prin_descriptor.prin_readkeys.additional_length == 0 )
 	{
 		condlog(was_set ? 1 : 3,
-- 
2.50.1

