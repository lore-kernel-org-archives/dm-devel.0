Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C6E19066E
	for <dm-devel@lists.linux.dev>; Thu,  5 Dec 2024 03:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733371013; cv=none; b=rGUiX+Z40NV07Hg/lkfE3EF8PwYxabxY/PDFA3hX0Xnruq/Y4sLn20Qo3vUNPNObjoO+JrdvLkf12bYkMEfq8ivqytKNFz25rZcgYCmGEZS1+z2BJbhgPANAOTn6TQpNjQ5jHvFpK0VL73FPyDBYUasZdRxyMHsca7yhUs5JTYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733371013; c=relaxed/simple;
	bh=8gMMo64Ex880FvGgkWpFESfJs1PIv5XzQTmJZC8X1vU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=E9thx3T94wlM0tgT5fvehOQmO+/VKebnA48bbGDYRrf9TzylrVUarQ73ulCNkqP/0sLsP4PwaaywmB07tWFTD0NNYB0+Ez4IEvkbajbuhiCN+FxtAwp1C/aY1L0TAnkVQ/XRhazsc2WBNmDVJXu22rWQIc8UpPnD5EcSQPzrW+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WVXUh5Qn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WVXUh5Qn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733371007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CYRk2qa7va3GuJDiVJlCAi8KtGixtlYG+1Otd7cliAE=;
	b=WVXUh5QnL2/roWOd/IwtKLeIXZkawCvuP3Cnv33KTxM7JIgZ+aRAyRNtdPETpQCR2UjxvO
	zys6JUd48npKP4nnrtcgBQB6JuKvxmE4MIsXtrunveJeCow7V9e/VYIk251QqVCc7/Peq/
	5YAPJjOTwPTm8u2l0RthZPJ0R+D6IQk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-26-Lb_S7UNZPXa0GNenhsqt3g-1; Wed,
 04 Dec 2024 22:56:42 -0500
X-MC-Unique: Lb_S7UNZPXa0GNenhsqt3g-1
X-Mimecast-MFC-AGG-ID: Lb_S7UNZPXa0GNenhsqt3g
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A3EF31956095;
	Thu,  5 Dec 2024 03:56:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3A23819560A2;
	Thu,  5 Dec 2024 03:56:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4B53ucJe1218969
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 4 Dec 2024 22:56:38 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4B53ucv91218968;
	Wed, 4 Dec 2024 22:56:38 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 1/3] libmultipath: Don't skip set_path_max_sectors_kb()
Date: Wed,  4 Dec 2024 22:56:36 -0500
Message-ID: <20241205035638.1218953-2-bmarzins@redhat.com>
In-Reply-To: <20241205035638.1218953-1-bmarzins@redhat.com>
References: <20241205035638.1218953-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UcSiAVKfoPnYhYU3IU-VXtl1IwpMIDu8ZDsPDi8YrTM_1733371000
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If a multipath device already has need_reload set when a path is
adopted, it won't call set_path_max_sectors_kb() because of
short-circuit evaluation. This isn't what's intended.

Fixes: e5e20c7b ("libmultipath: set max_sectors_kb in adopt_paths()")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs_vec.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index d22056ca..60051092 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -335,8 +335,7 @@ int adopt_paths(vector pathvec, struct multipath *mpp,
 				 */
 				if (!current_mpp ||
 				    !mp_find_path_by_devt(current_mpp, pp->dev_t))
-					mpp->need_reload = mpp->need_reload ||
-						set_path_max_sectors_kb(pp, mpp->max_sectors_kb);
+					mpp->need_reload = set_path_max_sectors_kb(pp, mpp->max_sectors_kb) || mpp->need_reload;
 			}
 
 			pp->mpp = mpp;
-- 
2.46.2

