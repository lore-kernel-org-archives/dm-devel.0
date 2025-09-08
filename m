Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936E731197B
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 00:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376014; cv=none; b=AjlnqgxwczC2zLiJMG15MgghhjDWlXEt5eKtwVX8d2iDyWvvLVTCPpWGV4fl6HSDcd4ympTOfkyab3XyzBngSBrB2vUDE9qDSPUj0N0efD3OGkYTQcv6E+7nUCa4BlOSnKhZoQVXCRjQkll6Xfc7tQkhGErAlHKMztSJDiIlmbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376014; c=relaxed/simple;
	bh=51X27alxVu1vQDRsxdNilDkd2k8nIVr+Ww7Ae0G5CG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=hRt+p2DBTG2ZSWzVQHVmh+lY6pLPWV/H74etRsi+UTnrvDDDbpK58fOgYJWiAR9JQe3Dj6LgiahWbC17xKnvQSKmNXLpDUltW6i/bMwZkKznOli9KFIweCBo4TncPkQRynTsAfWnkYxXMMV5AkV3jnMBfLU1MX/IAgjacHfdjMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PGzy8ZCE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PGzy8ZCE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757376011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1JMUM2dshR9+jdOycA2zfIOjz8fMiB7Z59awOckjdqg=;
	b=PGzy8ZCEsfwxT8Eu14ElaXn0WavJ5V20C6B2iAtkIhjm2S8i8OoRvgvIk73MiehXtU7vOB
	djT723weFldSMuMosSJSUwx778qRboZEMQNtepahFs9V6RhwUQX6IL4AS1AQG2dzOuyZZ9
	9iX/UAXz4y2ipPgQdTMulioEbv+2VCM=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-91-Xrk6XQouPMS5-ZYR8r7yRw-1; Mon,
 08 Sep 2025 20:00:07 -0400
X-MC-Unique: Xrk6XQouPMS5-ZYR8r7yRw-1
X-Mimecast-MFC-AGG-ID: Xrk6XQouPMS5-ZYR8r7yRw_1757376006
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 95BD019560B3;
	Tue,  9 Sep 2025 00:00:06 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4D0B01956095;
	Tue,  9 Sep 2025 00:00:06 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 589005wN751120
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 20:00:05 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 589005dT751119;
	Mon, 8 Sep 2025 20:00:05 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 10/32] libmpathpersist: fail the release if all threads fail
Date: Mon,  8 Sep 2025 19:59:40 -0400
Message-ID: <20250909000002.751039-11-bmarzins@redhat.com>
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
X-Mimecast-MFC-PROC-ID: KvnjKuWlOACKUG_5u5PbtGYV5V-Z6K6pTZnnGrt_tNw_1757376006
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If none of the threads succeeds in issuing the release, simply return
failure, instead of trying the workaround.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 8ade2e13..d78d4fd8 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -413,6 +413,7 @@ static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 	struct prin_resp resp = {{{.prgeneration = 0}}};
 	uint16_t udev_flags = (mpp->skip_kpartx) ? MPATH_UDEV_NO_KPARTX_FLAG : 0;
 	bool did_resume = false;
+	bool all_threads_failed;
 
 	if (!mpp)
 		return MPATH_PR_DMMP_ERROR;
@@ -474,15 +475,22 @@ static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 		}
 	}
 
+	all_threads_failed = true;
 	for (i = 0; i < count; i++){
 		/*  check thread status here and return the status */
 
-		if (thread[i].param.status == MPATH_PR_RESERV_CONFLICT)
+		if (thread[i].param.status == MPATH_PR_SUCCESS)
+			all_threads_failed = false;
+		else if (thread[i].param.status == MPATH_PR_RESERV_CONFLICT)
 			status = MPATH_PR_RESERV_CONFLICT;
-		else if (status == MPATH_PR_SUCCESS
-				&& thread[i].param.status != MPATH_PR_RESERV_CONFLICT)
+		else if (status == MPATH_PR_SUCCESS)
 			status = thread[i].param.status;
 	}
+	if (all_threads_failed) {
+		condlog(0, "%s: all threads failed to release reservation.",
+			mpp->wwid);
+		return status;
+	}
 
 	status = mpath_prin_activepath (mpp, MPATH_PRIN_RRES_SA, &resp, noisy);
 	if (status != MPATH_PR_SUCCESS){
-- 
2.50.1

