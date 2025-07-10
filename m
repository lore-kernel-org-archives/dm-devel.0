Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F014A2741BC
	for <dm-devel@lists.linux.dev>; Thu, 10 Jul 2025 18:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752171071; cv=none; b=JpjP+PY7gJAN9xFaNpKCex2yozrHAGHmGw/qLtiHxKCDTUMC4Te3G0kz67kT15VLjqwOopXy/p2vleN71oiVr+KU4WKpoNP+NFxU1RYiOEacuO56V/smzCnzd11DQ/317n+RlJMlwNoJuw+yn2xUY48lO/igXkbBcOtVD5WZkG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752171071; c=relaxed/simple;
	bh=zVccvtoTjncYbAugPx5Fy8+fdPRXNj6zQyRSQv65cc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=MM6kduI/JsFkCbimlDggoyP15aGwKMnWMcWKEpGv/04uZrncivbH8apz15r/SIzB1jafLUd17FsFHsJcn8FF0hRNOWNs3DXJ7kKoB8VxSTnLLvTjaqIn7J8xb9QwHfE4B+txuSg4jN0RY5VtJQYgN1G3wDMGRspRHsqY1GgUhb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AOuITeyg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AOuITeyg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752171069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oWSGFWMYeTO3MrdJ/epEEtxn+bwaCekaaXRt/+2fcQE=;
	b=AOuITeygY+rdUxfYl4X7YPn30dn6LiLSChY7rpF5k2BveO2Nju5XJLn29pt6WfHOuAtUJN
	1zbAeiTyD062X7bgqD/8iDd71CEryNkBvQ5FhXsbdNV1EpaFH8tLPxZK+yskG7NhCEgNNE
	Hf7+kczbSF8tr3CU5fz/CC7qoV9UzVI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-231-ZnRzZxxZMQq9lRvOo3-a1w-1; Thu,
 10 Jul 2025 14:11:05 -0400
X-MC-Unique: ZnRzZxxZMQq9lRvOo3-a1w-1
X-Mimecast-MFC-AGG-ID: ZnRzZxxZMQq9lRvOo3-a1w_1752171065
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 63DDC1800268;
	Thu, 10 Jul 2025 18:11:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 22E6D19560AB;
	Thu, 10 Jul 2025 18:11:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 56AIB2Qh3997823
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Jul 2025 14:11:02 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 56AIB2ED3997822;
	Thu, 10 Jul 2025 14:11:02 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 10/15] libmpathpersist: fail the release if all threads fail
Date: Thu, 10 Jul 2025 14:10:55 -0400
Message-ID: <20250710181100.3997759-11-bmarzins@redhat.com>
In-Reply-To: <20250710181100.3997759-1-bmarzins@redhat.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NyvjybBKPQXvacAvK1jzWcEYTJJTaRVComidoZ5-PSI_1752171065
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If none of the threads succeeds in issuing the release, simply return
failure, instead of trying the workaround.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 7fb08b2e..ad5a4ee7 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -475,15 +475,21 @@ static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 		}
 	}
 
+	rc = MPATH_PR_DMMP_ERROR;
 	for (i = 0; i < count; i++){
 		/*  check thread status here and return the status */
 
-		if (thread[i].param.status == MPATH_PR_RESERV_CONFLICT)
+		if (thread[i].param.status == MPATH_PR_SUCCESS)
+			rc = MPATH_PR_SUCCESS;
+		else if (thread[i].param.status == MPATH_PR_RESERV_CONFLICT)
 			status = MPATH_PR_RESERV_CONFLICT;
-		else if (status == MPATH_PR_SUCCESS
-				&& thread[i].param.status != MPATH_PR_RESERV_CONFLICT)
+		else if (status == MPATH_PR_SUCCESS)
 			status = thread[i].param.status;
 	}
+	if (rc != MPATH_PR_SUCCESS) {
+		condlog(0, "%s: all threads failed to release reservation.", mpp->wwid);
+		return status;
+	}
 
 	status = mpath_prin_activepath (mpp, MPATH_PRIN_RRES_SA, &resp, noisy);
 	if (status != MPATH_PR_SUCCESS){
-- 
2.48.1

