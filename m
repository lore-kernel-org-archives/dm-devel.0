Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DC1213237
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 00:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376012; cv=none; b=PrKGA6aCUQGR2EWZeR5Xuifw2PHDNFPPaU6MMXp+7HLA31X6F8Y+Kl4xCoIF4AePTTCNLmFs6M7983WiVP37a462GV/M9qidsDSbLg1uBNSfjEf+g8VnYqE97ISg6Sl3oWKU6+uH4/OSpb6Q6G7huABK4SH6XY5kQ4tpL3MvOzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376012; c=relaxed/simple;
	bh=+rvDhuXGyHjIoUMmguZhYJRXcFqqC8hr1UuwCvU3S6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=WSN3EOffhVXTaDxFTy5y0GXc2hvFF1P3lrMBownoVCU4nn02MmKpDnNvfDaiiWu8Sb22iROqmM94dSObamgkDD//4mwylYnzvmGVIJJFnbLoYIJ9IjTNyqRsjCyQ8SuK037LBAFJSwbWYmR9Bt2lMbhKPVgfLDvy7aGi5tYbvMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kdo/AEIo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kdo/AEIo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757376010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2+G84560TRxRKhPVE2cQCQM6asx76PQu7Vq82aVFmAk=;
	b=Kdo/AEIojpSTWUg4g70OlfRKtpeQJ8/SZfAhPcaL7dvQeUir64y8+oWq4ngbCnfc//MnDr
	vqZeOppmpjLiGgqxe3B30kTvehg3s10sbaApJasToqkvnUlgXYNS1r0AgOTPIhhs9RbQkT
	wwQDrMBRWSSniIRJZKulPYu7wEMDT0g=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-588-jm8Q0DImNT68JxYaQFapIQ-1; Mon,
 08 Sep 2025 20:00:08 -0400
X-MC-Unique: jm8Q0DImNT68JxYaQFapIQ-1
X-Mimecast-MFC-AGG-ID: jm8Q0DImNT68JxYaQFapIQ_1757376007
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 362141956089;
	Tue,  9 Sep 2025 00:00:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E809019560B8;
	Tue,  9 Sep 2025 00:00:06 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 589005dg751139
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 20:00:05 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 589005I4751138;
	Mon, 8 Sep 2025 20:00:05 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 14/32] libmpathpersist: use a switch statement for prout command finalizing
Date: Mon,  8 Sep 2025 19:59:44 -0400
Message-ID: <20250909000002.751039-15-bmarzins@redhat.com>
In-Reply-To: <20250909000002.751039-1-bmarzins@redhat.com>
References: <20250909000002.751039-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: X5Rz_RScKxiojN9YvIrwq2CrowadcmD5U1iYZoA4h1o_1757376007
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Change the code at the end of do_mpath_persistent_reserve_out() to
use a switch statement instead of multiple if statements. A future
patch will add more actions here, and a switch statement looks cleaner.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist_int.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index dd875792..cee7b28d 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -738,15 +738,19 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 		return MPATH_PR_OTHER;
 	}
 
-	if ((ret == MPATH_PR_SUCCESS) && ((rq_servact == MPATH_PROUT_REG_SA) ||
-				(rq_servact ==  MPATH_PROUT_REG_IGN_SA)))
-	{
+	if (ret != MPATH_PR_SUCCESS)
+		return ret;
+
+	switch (rq_servact) {
+	case MPATH_PROUT_REG_SA:
+	case MPATH_PROUT_REG_IGN_SA:
 		if (prkey == 0) {
 			update_prflag(mpp->alias, 0);
 			update_prkey(mpp->alias, 0);
 		} else
 			update_prflag(mpp->alias, 1);
-	} else if ((ret == MPATH_PR_SUCCESS) && (rq_servact == MPATH_PROUT_CLEAR_SA)) {
+		break;
+	case MPATH_PROUT_CLEAR_SA:
 		update_prflag(mpp->alias, 0);
 		update_prkey(mpp->alias, 0);
 	}
-- 
2.50.1

