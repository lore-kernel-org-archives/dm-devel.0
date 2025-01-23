Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC3F41C63
	for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 03:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737602212; cv=none; b=EMtQN8tFbg2T+e79zAcxkLvPFltxNvcL+HKQEmgRCKbROcolms1m9klY7euKlRNB5Rv1I93Bs90sTQ8DxUXHH+77PZ0AwrQfR3yrI//m9HH8oc5+IotDCZZen+KAybstqN+7zFIfmpEn7OpiKkVAMH11drAwY6gQMYosZg1BPBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737602212; c=relaxed/simple;
	bh=gplegxwAVdYcMvrGCt3FYj/655l5otjOXSjckBeyE3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Mlng2aVyjLtZcv0oTEcNF26HdGpUNu480UxBl43LL6tYMO4Y5Hi6VM1obsVds1xyh8Zv4vNnyFfYS08EN6BI40I7ZJcoXRZy+BYBXtffJ1mU12ZRFP4SqPBWKH9udL+vt2Z/HfaSvcYwLntToGN7BioFvI8BB/+xL+KKm4e3FjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TMDV/rPD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TMDV/rPD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737602209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ds6TvzHfQlQcmX8Z/5WevJKcuYjh6EQuaIbvI8Bi5u0=;
	b=TMDV/rPDXKa+BbPphBCf3AdYQtTSxe98Jt5lGvdTzgtMgrrBvq3QHNRkkYoD8MuMfR148H
	X2OBdNAcMMgz/ID83SbMIW/R9PLmwFVMnsEb+DtDbfpuMyrx8UJv3/oip89LIKJkkMUg2K
	i0eWsscIr05vZxvYcpLxa6OAzyQITBY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-570-F8Zmz4cCPcqC6T9_7mxS-A-1; Wed,
 22 Jan 2025 22:16:48 -0500
X-MC-Unique: F8Zmz4cCPcqC6T9_7mxS-A-1
X-Mimecast-MFC-AGG-ID: F8Zmz4cCPcqC6T9_7mxS-A
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 55C8219560BB;
	Thu, 23 Jan 2025 03:16:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0F579195608A;
	Thu, 23 Jan 2025 03:16:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 50N3GjbV3017967
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 22:16:45 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 50N3Gjit3017966;
	Wed, 22 Jan 2025 22:16:45 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 13/13] libmultipath: be lenient in allowing the alua-based pgpolicies
Date: Wed, 22 Jan 2025 22:16:43 -0500
Message-ID: <20250123031643.3017891-14-bmarzins@redhat.com>
In-Reply-To: <20250123031643.3017891-1-bmarzins@redhat.com>
References: <20250123031643.3017891-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3P7c_dAJWATOCvqFWBb8LpJX54z_DSpHb027GDMZb84_1737602207
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

multipath wouldn't autodetect the GROUP_BY_PRIO path grouping policy or
allow the GROUP_BY_TPG policy if there was a path that didn't have its
prioritizer selected (for instance because multipathd was reconfigured
while it was offline). To avoid this, make verify_alua_prio() assume an
alua multipath device if all the paths with a prioritizer selected
(there must be at least one) use an alua-based prioritizer.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/propsel.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index ad771d35..664e62fc 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -255,14 +255,18 @@ verify_alua_prio(struct multipath *mp)
 {
 	int i;
 	struct path *pp;
+	bool assume_alua = false;
 
 	vector_foreach_slot(mp->paths, pp, i) {
 		const char *name = prio_name(&pp->prio);
+		if (!prio_selected(&pp->prio))
+			continue;
 		if (strncmp(name, PRIO_ALUA, PRIO_NAME_LEN) &&
 		    strncmp(name, PRIO_SYSFS, PRIO_NAME_LEN))
 			 return false;
+		assume_alua = true;
 	}
-	return true;
+	return assume_alua;
 }
 
 int select_detect_pgpolicy(struct config *conf, struct multipath *mp)
-- 
2.46.2

