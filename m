Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9953164B4
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 00:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376017; cv=none; b=D8FucrE+NU9ki0UYFbYLALzQqABZdsp4iyEgu+jX+imhkMVoRlkRCPLCcOm5+8wW30vWCIOW3EtYbO7kLHbzGkwgNEZfG6i4puXRj9wrTv2TZKk8Z/koUMFa9ZpYx/wDFCsIO7hgFfhb+WZpAsxt2tT7JP0oqnbr2/Yx25HZIQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376017; c=relaxed/simple;
	bh=ZQBh7Dx4s2rJcX93vfJCC6FX29fJnw3cNnifBffD5Go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=QxifEor1/JITOCRTCWmAy5VzBpAhUxTSFO4IJNjrVTGF23R3lh+SL3lb++arynGd0yAP0EGQ/LdqiB+aO4IzRvcuhqSGvFfbvInLRWpgB7LauPugpYmWMIarRIISP0t4w/pNHlQdyo2GnYeGJF+4xWinU4IWe3m3Lpt8UqHkCrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZO7MUBOU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZO7MUBOU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757376013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qsqGZvut7Loevf6wYAXIdt2f9+J8hiD1nz+GfIMGvVc=;
	b=ZO7MUBOU56nBQqFeoOgqTYGQ10hCUyexHs36VYkFxsOM1NQEAXbeBRpuTYhqFt4BJTsTb5
	hoacGXf+3U4D0BAo5esWTE2n9tbJALIBExO5B9KgDuy6bZQPvsvLttPR3GeV8nz0h99ot5
	f3Li8wpbP/GFfVZ6+zGDVeExdUnpg4g=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-642-g1KVwihyMXCO4uVpU7NSfQ-1; Mon,
 08 Sep 2025 20:00:09 -0400
X-MC-Unique: g1KVwihyMXCO4uVpU7NSfQ-1
X-Mimecast-MFC-AGG-ID: g1KVwihyMXCO4uVpU7NSfQ_1757376009
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D66551800452;
	Tue,  9 Sep 2025 00:00:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9730A1800446;
	Tue,  9 Sep 2025 00:00:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 589007ZA751183
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 20:00:07 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 589007H1751182;
	Mon, 8 Sep 2025 20:00:07 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 25/32] libmpathpersist: only clear the key if we are using the prkeys file
Date: Mon,  8 Sep 2025 19:59:55 -0400
Message-ID: <20250909000002.751039-26-bmarzins@redhat.com>
In-Reply-To: <20250909000002.751039-1-bmarzins@redhat.com>
References: <20250909000002.751039-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BgCgjEQ8AASSNe4usTB3dPyUAGGgQKSOqv1kFYDvTlI_1757376009
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Otherwise this request will create a useless prkeys file.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist_int.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index df77ac98..3819c0d7 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -839,7 +839,8 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 		break;
 	case MPATH_PROUT_CLEAR_SA:
 		update_prflag(mpp->alias, 0);
-		update_prkey(mpp->alias, 0);
+		if (mpp->prkey_source == PRKEY_SOURCE_FILE)
+			update_prkey(mpp->alias, 0);
 		break;
 	case MPATH_PROUT_RES_SA:
 	case MPATH_PROUT_REL_SA:
-- 
2.50.1

