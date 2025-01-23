Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FD45733A
	for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 03:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737602213; cv=none; b=KZYcyCXhhtlGs5umOkI5dWYlhvLcqYqKzpM7GPyskoajaSP/HfpW1FzhQWufz6DwMO2AVtuupKWiyiPK6iwwcDAehRaxidiJPJbDfBEM5Gcp+ivPMF6+uRxbvaIXLiNVCbttDzVk2nFu8u/oeDfAIcNe6dBASlSfOf5xQxaBYKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737602213; c=relaxed/simple;
	bh=DtOQp8lbHaiOs2aQgiJY3FaVzy8SzLNrug2kzA/DZzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=M9cT1wjYtBVHc+0+mhSIAq6Uui+Z5QzaiZz/pfsHE7NjUUkvmsTDAa8GbdYz6WuW4X6zo5+jMun0sX/SLNXc5OP83/GqUhNFn9lu1eu3iFbEhNn3B9zersKKpRN0HQwmJ9Y1Fa6ChGabpgg5XLlTzoJ10VCYCiW46kRHZJLqAdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MB6Yc0bm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MB6Yc0bm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737602210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uchQPncU+MOF7MC1n8kGv+sc3MFY8QJNUQ7ou2Us2Ww=;
	b=MB6Yc0bmdWDYjauE4zvazAb3voa6jWfrRpUqNoGNzncmutSA016LtgNhySMsRmjQw3+3DL
	yfRTernQiRaeHYiuFlqJxutVAjn19+D7WLqGuycIJGpKmlBUNdlaExRV6I8yQxFZvVpURF
	KqwA92Vnk+NpMgMUE6dNx3P0La/F5Ls=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-524-X_kHRWK7Os27J5DNuhXLOA-1; Wed,
 22 Jan 2025 22:16:47 -0500
X-MC-Unique: X_kHRWK7Os27J5DNuhXLOA-1
X-Mimecast-MFC-AGG-ID: X_kHRWK7Os27J5DNuhXLOA
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1D07F19560B4;
	Thu, 23 Jan 2025 03:16:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C6621195608E;
	Thu, 23 Jan 2025 03:16:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 50N3Gisx3017929
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 22:16:44 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 50N3Gilt3017928;
	Wed, 22 Jan 2025 22:16:44 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 04/13] libmultipath: remove need_reload check from select_action
Date: Wed, 22 Jan 2025 22:16:34 -0500
Message-ID: <20250123031643.3017891-5-bmarzins@redhat.com>
In-Reply-To: <20250123031643.3017891-1-bmarzins@redhat.com>
References: <20250123031643.3017891-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LHZJoCDfuEV8Qw8pulH73keCQjhzReUVhjKX6zv4uMU_1737602206
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

select_action() is only called by coalesce_paths() to determine what
action to take. The only function that sets mpp->need_reload is
update_pathvec_from_dm() and it only sets need_reload if there is a
problem with the current device layout. If coalesce_paths() generates
the same device layout for the new device, then forcing a reload will
not make any difference, since nothing will change. If it generates
a different device layout, then it will reload the device regardless
of the need_reload value.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 534ca7f4..ac5e6713 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -686,8 +686,6 @@ void select_action (struct multipath *mpp, const struct vector_s *curmp,
 	mpp->action = ACT_NOTHING;
 	cmpp = find_mp_by_wwid(curmp, mpp->wwid);
 	cmpp_by_name = find_mp_by_alias(curmp, mpp->alias);
-	if (mpp->need_reload || (cmpp && cmpp->need_reload))
-		force_reload = 1;
 
 	if (!cmpp) {
 		if (cmpp_by_name) {
-- 
2.46.2

