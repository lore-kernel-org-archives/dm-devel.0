Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7248A81724
	for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 03:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737602214; cv=none; b=liGMPhSU8VDptsXIyQRnwFLqegVDRk/jcEcGd+GrXRUfW8+RvOJrmdkgmevQIAf/tDOF8yH2MD7ZJhjhqu71rAufTsH050ZFYm4LOYrEtbToCGFmlpCvTFjmW0/+3FKwTHXd2Cr8BMa7UmjjwWQrzTKTWoBu5jEc1hZR3R4tuus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737602214; c=relaxed/simple;
	bh=ceU1opEGtw494NaLnr7FeMRNBmu/ghzsvVjK4PZQjLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=nYsOPUxfumDKEsI+d2TGX85OWyVQh6DNst7OkCshPC4uu9GEOopYy87l/xHwKpgbvl7U7xvrF59fB6WWUpzOKSjCSNN4Kgd3YjFX472V0M1w8VWNeSb8FjJOqlmjC1qk0tKkQz7F+/gnBR9oNXHZJZcOMyh0tlbt80TNwniiejQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eJwWjxgM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eJwWjxgM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737602211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AzMEgoWKHWGmXBcEV6mCQm5i0kPQp2YmMuRYJx+FtaU=;
	b=eJwWjxgMPttHvn8ieZ4hObgFQUwFrHSJyCtC4ufW0U9TiHCRyq9lJD/jFO5atoztur3r85
	viM0OW6eLi90GbfM3sH/yi/kprdKznqIe12Z/fxsbQR8AMIHvUxcdtWKjZ3PwOO/t6FMeL
	X1Xd3ixuIILYU41WiWvx/6O9WxjlG04=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-479-KAtUFz1CO6qptkHFBeC2aw-1; Wed,
 22 Jan 2025 22:16:47 -0500
X-MC-Unique: KAtUFz1CO6qptkHFBeC2aw-1
X-Mimecast-MFC-AGG-ID: KAtUFz1CO6qptkHFBeC2aw
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F1E161955F2D;
	Thu, 23 Jan 2025 03:16:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BBEDE195608A;
	Thu, 23 Jan 2025 03:16:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 50N3Gj4V3017957
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 22:16:45 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 50N3GjFW3017956;
	Wed, 22 Jan 2025 22:16:45 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 11/13] libmultipath: set need_reload when the tpg_id gets set
Date: Wed, 22 Jan 2025 22:16:41 -0500
Message-ID: <20250123031643.3017891-12-bmarzins@redhat.com>
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
X-Mimecast-MFC-PROC-ID: e9QBFBDvTUW74Y_vs5yph-DjGXOdPaPFL8chiUQN9Ps_1737602207
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If a multipath device has a path grouping policy of "group_by_tpg" and
pp->tpg_id wasn't previously set, set need_reload. If the multipath
device hasn't been created yet, need_reload will get cleared when the
device is created. If the multipath device already exists, the path
likely wasn't in the correct pathgroup, since it was unable to set
pp->tpg_id before the paths were grouped.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 48e23d44..846101d0 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -34,6 +34,7 @@
 #include "configure.h"
 #include "print.h"
 #include "strbuf.h"
+#include "pgpolicies.h"
 
 #define VPD_BUFLEN 4096
 
@@ -1097,8 +1098,13 @@ detect_alua(struct path * pp)
 
 int path_get_tpgs(struct path *pp)
 {
-	if (pp->tpgs == TPGS_UNDEF)
+	if (pp->tpgs == TPGS_UNDEF) {
 		detect_alua(pp);
+		if (pp->tpgs != TPGS_UNDEF && pp->tpg_id != GROUP_ID_UNDEF &&
+		    pp->mpp &&
+		    pp->mpp->pgpolicyfn == (pgpolicyfn *)group_by_tpg)
+			pp->mpp->need_reload = true;
+	}
 	return pp->tpgs;
 }
 
-- 
2.46.2

