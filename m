Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E583421CC52
	for <dm-devel@lists.linux.dev>; Mon, 31 Mar 2025 23:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743463060; cv=none; b=j8P64DAr4X0wxKO9BhlDJ+jqMGtnXv2USGVZAcwo6Nq+N06UCBAvQwPG9hWKjEQeauF1PBzddzNIbE9T5bssfu5mkM07s0kmRgEXvBKWZ0bJl33h/ogTXChQW68lnMopkZ9io9LjoGLVuCwnRFJTA/83C/x9sR9qKGsgXgleTUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743463060; c=relaxed/simple;
	bh=xeGDg51Yf5vQbprLgdGGiHETJ9ZrcRWEwx7RQrpUJ0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=LAm7VLG0FMpkHNG6x3R6N33yB2FlyQCgt8gyK8EQ0MaX1v/vXYiynZAkBi2xpe8IPJ51iwzooD2e4l3/eCBcd+Ak96NmyNqosHxFWOIb69n5lJyHS5H1PgOrdsCBAUdgRmEvJRhuM0j2Oqm9FVx3mXlzXwYRYoY7lpHT2hSUQvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VMWEIizV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VMWEIizV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743463057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O1htVGb8uS4QJtDX8GWu9QzTtowuWcqMdcbkjNI8E3g=;
	b=VMWEIizVW21+gwVezeZ5yQycIq33izYevbpdlV2PF9u5L22B/eGsrhXMtoceak0ai+OEvE
	rzkQtLxpWMbxObn51GLnmTcVtdDuwVaaGjjdPSmcmzDlyePh+A+GWPu92XZzouNdQXeIme
	Ffjqb8p6aWYYdr4bvk6apFNTVGRvhM8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-358-7bsKraZaO1eJuRbzcq1ZxA-1; Mon,
 31 Mar 2025 19:17:34 -0400
X-MC-Unique: 7bsKraZaO1eJuRbzcq1ZxA-1
X-Mimecast-MFC-AGG-ID: 7bsKraZaO1eJuRbzcq1ZxA_1743463053
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5577C1954B3B;
	Mon, 31 Mar 2025 23:17:33 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1265C1808867;
	Mon, 31 Mar 2025 23:17:32 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 52VNHVt72857679
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 31 Mar 2025 19:17:31 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 52VNHVBN2857678;
	Mon, 31 Mar 2025 19:17:31 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 3/3] multipathd: don't update paths in INIT_MISSING_UDEV
Date: Mon, 31 Mar 2025 19:17:30 -0400
Message-ID: <20250331231730.2857655-4-bmarzins@redhat.com>
In-Reply-To: <20250331231730.2857655-1-bmarzins@redhat.com>
References: <20250331231730.2857655-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7pOqwhMxGGZvPKGq5bTLwejinlmciuKl50e6rRUUNnc_1743463053
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

There is nothing for update_uninitialized_path() to do for paths in the
INIT_MISSING_UDEV state. In fact, there shouldn't be any paths in this
state when update_uninitialized_path() is called, since they will have
switched to a different state in check_uninitialized_path().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck  <mwilck@suse.com>
---
 multipathd/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 9aa5a2fa..40ca83c7 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2890,7 +2890,6 @@ update_uninitialized_path(struct vectors * vecs, struct path * pp)
 	struct config *conf;
 
 	if (pp->initialized != INIT_NEW && pp->initialized != INIT_FAILED &&
-	    pp->initialized != INIT_MISSING_UDEV &&
 	    !(pp->initialized == INIT_OK && pp->add_when_online))
 		return CHECK_PATH_SKIPPED;
 
-- 
2.48.1

