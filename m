Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B081635280
	for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 03:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737602211; cv=none; b=dvnQvkvmp+h3V3beD6b2d1C7ebgG1cIhT2q4Ff4Po335NfswTIDAtiTg5fbfapsz1PhOIOrSRcCDHYBx5oVqS5635lNISqXWmLU17aNkEmKYeZfYsiqM62pNadptmbOr0hTrikR7HKOqjdUtWQ3VP1ELZgkvA1qbXfflBgeUgNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737602211; c=relaxed/simple;
	bh=rkZ/BYHISR+HGDNhMmwj9q+g+lTE2MrWV5BG8D6qPiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=JGpYroOLXOlJl9L3nBhbwyFiZ1uddML4zgKL+KbjJT2rY6PBPmycxMwFUc1epV7dgYv8E5QQXbZaxRwKjITSwosQuC+S1vkOg8yrzDctqwL5gu+M8NJ92hN7fjhzF1+JJtvb8oO9Cg/+dMF/YfVC1LrXrLZ21i/gdhKWSTZW+eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fbPVJwdP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fbPVJwdP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737602208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p0+yrX459dKjJmcMrvXtaJHzn0Ztk3DGYZxYhdyfub8=;
	b=fbPVJwdP9UpsqpVamTCMlfik0BNbJRkkvgATWvoORNxIfHiCzqbVuLTZj5mafkrawpHoXN
	2VDHqihRmKCW8z9knTK3OnXzAdoMORrZbUnyI10/VUe7lR4jcXomsjlitiigZhdEDIouoR
	LjWbZxs7XNINO8Fgj33A3hFnYP+HL4Y=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-191-X1El_7TPNO20k_CfbGYI8w-1; Wed,
 22 Jan 2025 22:16:46 -0500
X-MC-Unique: X1El_7TPNO20k_CfbGYI8w-1
X-Mimecast-MFC-AGG-ID: X1El_7TPNO20k_CfbGYI8w
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E95B319560B0;
	Thu, 23 Jan 2025 03:16:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8183230001BE;
	Thu, 23 Jan 2025 03:16:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 50N3GiqM3017925
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 22:16:44 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 50N3GiEE3017924;
	Wed, 22 Jan 2025 22:16:44 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 03/13] libmultipath: don't set need_reload in adopt_paths
Date: Wed, 22 Jan 2025 22:16:33 -0500
Message-ID: <20250123031643.3017891-4-bmarzins@redhat.com>
In-Reply-To: <20250123031643.3017891-1-bmarzins@redhat.com>
References: <20250123031643.3017891-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TRcMJRlgwLN_obwnO66LKnVlzVZMZzh8r7Guoxc98rQ_1737602206
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

adopt_paths() is generally called when you are planning on creating or
reloading a multipath device. The only time when adopt_paths() is called
and mpp->action isn't explicitly set to ACT_CREATE or ACT_RELOAD
afterwards is when it is called by coalesce_paths() ->
add_map_with_path(). But in this case, you will only set need_reload if
the path that is being adopted isn't already part of the device. Because
of that, the new device that's being assembled in coalesce_paths() must
be different from the existing device (it has a path that isn't in the
existing device), so select_action() will select ACT_RELOAD, regardless
of the need_reload state. This makes intuitive sense. When multipath
adopts a new path, it should reload the device to actually add that path
to the device.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs_vec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index f5860499..47fc7cf3 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -349,7 +349,7 @@ int adopt_paths(vector pathvec, struct multipath *mpp,
 				 */
 				if (!current_mpp ||
 				    !mp_find_path_by_devt(current_mpp, pp->dev_t))
-					mpp->need_reload = set_path_max_sectors_kb(pp, mpp->max_sectors_kb) || mpp->need_reload;
+					set_path_max_sectors_kb(pp, mpp->max_sectors_kb);
 			}
 
 			pp->mpp = mpp;
-- 
2.46.2

