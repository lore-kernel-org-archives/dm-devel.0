Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5813312819
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 00:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376017; cv=none; b=f+jjBNv1Hf/gh+Q6GNKfhZ1Sm14zjBSLbBPR2HaJly8pX6txNXlAiM1BQUU6I6ibLAtv0FLM5vRqy2N9vJ9JhBqnAARKtFvRjXycslA9aWn58CTDScGXpaiXhVap+QRg3d2gQ1wksQGB9HL/F0yAQlblJWlrWEluSWqJWz7n8io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376017; c=relaxed/simple;
	bh=Ulimt8kxWR/BR/OukIDaKGwddTWgyxjA/sFSK5zjKYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=F+iQdlQlC0x1bKSSxYqss77cIbyMjKaXA9qvTR69/AE4ei5QmfHymPcwusFitwSYTZCcp3JqGtIgcytHZjS9DHcVysHs7bT6YnIe8j/MuIoY5Tqkj45EIY0thYjHjyRb+8vZF9pUnJiGMJxSNdJ6vMVFh9AJnh0rygJpwhqt4gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MluAgKtn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MluAgKtn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757376013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4rcli9uG91YKMH2HYc/g9zzUqLL+3PNc2PQ367QA3dc=;
	b=MluAgKtn71pXWZ3oUTLS4DXD/qyJsjirJN8AbjlR4zgPQJqR+u1+1Mkx33P+C6CXsEzCyY
	tECp9Kw0NYHU9D0mN6IPwzKK+V7Re41hrcQ5P6fFrgvyK1t+ofzGfOXCnZ1EMVyC+ilfbF
	0DloVp7MC4Z95C3Xe8vtQHkL9W5V7P8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-311-5tP_toaINfa1PkuWD144VQ-1; Mon,
 08 Sep 2025 20:00:10 -0400
X-MC-Unique: 5tP_toaINfa1PkuWD144VQ-1
X-Mimecast-MFC-AGG-ID: 5tP_toaINfa1PkuWD144VQ_1757376009
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 94C32180057F;
	Tue,  9 Sep 2025 00:00:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 53CC41955F24;
	Tue,  9 Sep 2025 00:00:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 589008n1751203
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 20:00:08 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 589008G4751202;
	Mon, 8 Sep 2025 20:00:08 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 30/32] libmpathpersist: Don't try release workaround for invalid type
Date: Mon,  8 Sep 2025 20:00:00 -0400
Message-ID: <20250909000002.751039-31-bmarzins@redhat.com>
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
X-Mimecast-MFC-PROC-ID: c_vieeIplGNzVZ_e6LonS2ScTGgBTdt9xnzw5VGjprU_1757376009
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When trying to release a reservation, if the user specified the wrong
reservation type, libmpathpersist would try to preempt the reservation,
because the reservation key matched the device key, but it was not
removed.  In this case, the preemption would also fail because it also
requires a matching type.

Check if the reservation type matches, to avoid attempting the
workaround in this case.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 979b0d6c..a28e55b3 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -566,6 +566,7 @@ static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 	uint16_t udev_flags = (mpp->skip_kpartx) ? MPATH_UDEV_NO_KPARTX_FLAG : 0;
 	bool did_resume = false;
 	bool all_threads_failed;
+	unsigned int scope_type;
 
 	if (!mpp)
 		return MPATH_PR_DMMP_ERROR;
@@ -661,6 +662,13 @@ static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 		return MPATH_PR_SUCCESS;
 	}
 
+	scope_type = resp.prin_descriptor.prin_readresv.scope_type;
+	if ((scope_type & MPATH_PR_TYPE_MASK) != rq_type) {
+		condlog(2, "%s: --prout_type %u doesn't match reservation %u",
+			mpp->wwid, rq_type, scope_type & MPATH_PR_TYPE_MASK);
+		return MPATH_PR_RESERV_CONFLICT;
+	}
+
 	condlog (2, "%s: Path holding reservation is not available.", mpp->wwid);
 	/*
 	 * Cannot free the reservation because the path that is holding it
-- 
2.50.1

