Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BAA1BC58
	for <dm-devel@lists.linux.dev>; Thu, 22 May 2025 00:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747873592; cv=none; b=SabDmH4R7pgjBqS02qHEwVIkr4ZGXGJoQ+ZwnKtAvy1SVJFE+5U+tv0BfR35RI1bqBscp4iNP2oNa4ax5AWG64VfCKXI7e3ReaWWJZHUbAlXOKvvIRPM754uotgoqm2aHR6BUU5TK4uMXYVHaRSs5FQ8bwZSedgJQeQklZItFi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747873592; c=relaxed/simple;
	bh=tuQoa+dGRRRa/15BXU0lEiwSVM5uDTXmn/IulnBbWWI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=NGmZVMdOZ13+P9JGrwJ61WNck6JT6Pnp8rHqfDFp7+BJHdsvqWRH/1+9l6wfDZcMvhLzS01G2C8eY/DNSuUyBC7bNy3DXhCBYNYjVPHl7UhodZPOgAtBtoF2cv+LtAv5vjNQXNOIH914ljqfo0n+TGbWRA20tJHAQTy+bx4oByQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hc0uyq/8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hc0uyq/8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747873589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SBxE5yB7p6Ec8duVaO+CM2aBA+hXhcPqXqk1MAE2M0Y=;
	b=hc0uyq/8ogwOKYFQyP6C+kv53dUbMCNoRckw4gWXr9AsQ4eeaPvggR+6FIjlg1r6rDlSqB
	+ByhPXHAUr2xo7ypE36nPCZLHHcsXF7dDSL3g/VCDkB15LvwXcAsOvOYXal8e+1CWnGDhT
	d6K2H2gUJsxk4gZVh439Pj3qszs5cB4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-313-wuug3PflPcabFX3QyYm63g-1; Wed,
 21 May 2025 20:26:27 -0400
X-MC-Unique: wuug3PflPcabFX3QyYm63g-1
X-Mimecast-MFC-AGG-ID: wuug3PflPcabFX3QyYm63g_1747873586
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F0F511956086;
	Thu, 22 May 2025 00:26:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5AA1D1800268;
	Thu, 22 May 2025 00:26:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 54M0QN58611839
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 21 May 2025 20:26:23 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 54M0QNke611838;
	Wed, 21 May 2025 20:26:23 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH] multipathd: always reset checker interval for failed paths
Date: Wed, 21 May 2025 20:26:23 -0400
Message-ID: <20250522002623.611830-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RgMHv7T9nKFYy2D5jpU1Z-xHsrkZGvzqLagpihLG5Eg_1747873586
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

The are multiple places in the code that can set pp->state to
PATH_DOWN without resetting pp->checkint, most obviously when
a path is failed by update_multipath(). When this happens the
path will continue to be checked at its previous interval,
instead of switching back to conf->checkint. Fix these cases
by always resetting the pp->checkint to conf->checkint when
updating the state of a failed path.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index d4928d80..2d5c146d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2711,6 +2711,7 @@ update_path_state (struct vectors * vecs, struct path * pp)
 			else
 				LOG_MSG(2, pp);
 		}
+		pp->checkint = checkint;
 	}
 	if (pp->mpp->prio_update == PRIO_UPDATE_NONE &&
 	    (newstate == PATH_UP || newstate == PATH_GHOST))
-- 
2.48.1

