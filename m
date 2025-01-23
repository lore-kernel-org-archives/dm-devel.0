Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA103A8D0
	for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 03:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737602212; cv=none; b=IV5IdCiPvj6sF4HnvO0YXzRuAzRuF7TYKk/IFsac7KosWBTrDJ3l+Ze8ydhS2VYyVqN/M19uVMa7PnLyZw8OwQ9DXY6MxXzjqOeHU+lj7Sq6cy/L+wCC21Qs3Bl2FafrpDruhsVYOkxEpH/aTjuhANpVNLEmAEsXSyAXY4NQfsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737602212; c=relaxed/simple;
	bh=wLuUUGweED3aQcu91LCZIUUed96Hqf73mdIBR5Cny4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=DdX6NapFsHvHhobxiutugsKR+a8eQadUrkG1E/9AS4t2p754i/u7fDUYRz0n7TXSke1sXZmxn1f9D3GbadGD68fRju5pAahtlHTd9XlYRYfnPuEjJPGJrEWUxgj6lIGQr1UnXKepDo/HFxPxS4e15t3qVVsxg9WAE2ipTprLjN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WjZaIecg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WjZaIecg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737602209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qya/ih2k4Vv1DdYOWb0Qb1ejGIkh9PAuRxY85f//hE0=;
	b=WjZaIecgl/mmlm5F3tOorzAaMMK4llOuAbrGLIX9wTOM+7buSAWrCm/Y4p3+lJI41XVWV5
	fwnjlAVTuMqBg6fNZUVbh8vu3bDlrZP6RSBKQLf3RnxIZsmh2Md6EFq6WZYaGuiVAq1ljU
	o4PBJ96iwlcZg4ANN3kDEZbaETHspeY=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-102-j5iujsIGMAOfod-CZUWa2w-1; Wed,
 22 Jan 2025 22:16:47 -0500
X-MC-Unique: j5iujsIGMAOfod-CZUWa2w-1
X-Mimecast-MFC-AGG-ID: j5iujsIGMAOfod-CZUWa2w
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 286C91956048;
	Thu, 23 Jan 2025 03:16:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DD8E93003E7F;
	Thu, 23 Jan 2025 03:16:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 50N3GiMF3017933
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 22:16:44 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 50N3GiOi3017932;
	Wed, 22 Jan 2025 22:16:44 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 05/13] libmultipath: drop return value from update_pathvec_from_dm
Date: Wed, 22 Jan 2025 22:16:35 -0500
Message-ID: <20250123031643.3017891-6-bmarzins@redhat.com>
In-Reply-To: <20250123031643.3017891-1-bmarzins@redhat.com>
References: <20250123031643.3017891-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3TcB_M0vFfIgXnyb1zDvejZM2Y_UN_-oMIjoaeVLO9k_1737602206
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

We finally came up with a solution for handling mpp->need_reload, and it
doesn't involve checking the return value of update_pathvec_from_dm(),
so drop it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs_vec.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 47fc7cf3..b2bb47c3 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -92,14 +92,12 @@ static bool guess_mpp_wwid(struct multipath *mpp)
  * multipath maps but haven't been discovered. Check whether they
  * need to be added to pathvec or discarded.
  *
- * Returns: true if immediate map reload is desirable
- *
  * Side effects:
  * - may delete non-existing paths and empty pathgroups from mpp
  * - may set pp->wwid and / or mpp->wwid
  * - calls pathinfo() on existing paths is pathinfo_flags is not 0
  */
-static bool update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
+static void update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
 	int pathinfo_flags)
 {
 	int i, j;
@@ -111,7 +109,7 @@ static bool update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
 	bool pg_deleted = false;
 
 	if (!mpp->pg)
-		return false;
+		return;
 
 	/*
 	 * This will initialize mpp->wwid with an educated guess,
@@ -253,7 +251,6 @@ static bool update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
 		pg_deleted = true;
 	}
 	mpp->need_reload = mpp->need_reload || must_reload;
-	return must_reload;
 }
 
 static bool set_path_max_sectors_kb(const struct path *pp, int max_sectors_kb)
@@ -505,7 +502,6 @@ update_multipath_table__ (struct multipath *mpp, vector pathvec, int flags,
 	if (disassemble_status(status, mpp))
 		condlog(2, "%s: cannot disassemble status", mpp->alias);
 
-	/* FIXME: we should deal with the return value here */
 	update_pathvec_from_dm(pathvec, mpp, flags);
 
 	return DMP_OK;
-- 
2.46.2

