Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF42285C5E
	for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 03:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737602214; cv=none; b=UTcoYQupIWKOxkCLTuCOm8dLJJ+Vy9jQPYXe4G+N0XGCrIcbLgZE9fYlyso2X+nHUv2nTXYAXCjwpu27+dOiNOAmoK1VxQ2Rqi3yo9Mfj3aXRMxHarEEHt6yIKH/GhFvcwuz+NI9WXyMwiANBmdUvZXK8B75eH7ZliafQthvsAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737602214; c=relaxed/simple;
	bh=JeI/yPJ1txW6FJ1GF2e8M48oDSf99leQViZXCXYjxZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Qz4cxUDM87A5EQ18yNN+lwv0a6CjbqeQt50B4urWrPPRGLYIxayi2GS6/Z9v2l+CWoJd5QrbcOS6y/HdcvJpub1avTHIS4gG/BT10xWA+79z+RZ4af01xESuhDNCYwA+Q2tJF0WXInJVSJYG4cwpzc72WTLW1IQNWtJeZHhOdw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VVZHYPRj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VVZHYPRj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737602211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=egoX42DkQVAaucvQA1al166ytXVpomBWuE281NkX3Rg=;
	b=VVZHYPRjuuOyaNEsoreXrH/qitLZdbXNrjNfaLPKgVIkRuqB8zqXV1QEAP+gcBgZDd8OUl
	UOoHOtcpVbe/PphuIfbjltPecHuIG5pz2C3Pv+eYYXK/9pCtB1mxuQDbj8R+eJnmrCn6MC
	O95SamxwYxMzCIo1z6a/cyBOW1syIzY=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-326-jvqaRBDuN4Wj4bjFIIC1bQ-1; Wed,
 22 Jan 2025 22:16:48 -0500
X-MC-Unique: jvqaRBDuN4Wj4bjFIIC1bQ-1
X-Mimecast-MFC-AGG-ID: jvqaRBDuN4Wj4bjFIIC1bQ
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 20D3319560AB;
	Thu, 23 Jan 2025 03:16:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C8E7019560AA;
	Thu, 23 Jan 2025 03:16:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 50N3GjXZ3017961
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 22:16:45 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 50N3GjIb3017960;
	Wed, 22 Jan 2025 22:16:45 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 12/13] libmultipath: stop static analyzer complaint in init_foreign
Date: Wed, 22 Jan 2025 22:16:42 -0500
Message-ID: <20250123031643.3017891-13-bmarzins@redhat.com>
In-Reply-To: <20250123031643.3017891-1-bmarzins@redhat.com>
References: <20250123031643.3017891-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aACkWY4EuWbkoDcP-pauXr3R8tMLsttdUS-bxe6ZCDI_1737602207
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This change doesn't actually fix anything. The code was already safe.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/foreign.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
index 28d1b115..af5b0ed3 100644
--- a/libmultipath/foreign.c
+++ b/libmultipath/foreign.c
@@ -129,7 +129,7 @@ static void free_pre(void *arg)
 static int _init_foreign(const char *enable)
 {
 	char pathbuf[PATH_MAX];
-	struct dirent **di;
+	struct dirent **di = NULL;
 	struct scandir_result sr;
 	int r, i;
 	regex_t *enable_re = NULL;
-- 
2.46.2

