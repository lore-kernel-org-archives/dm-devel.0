Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE932391A6
	for <dm-devel@lists.linux.dev>; Thu,  5 Dec 2024 03:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733371007; cv=none; b=oUk1rZjqXbvQCC/8xy3B+IFk5xFy+1/LZMik8OIlm2Yfpuyjg+vBI9vXlHuIR12lJ+TGYx4I03pp7L44+tLjbsn7yocFf44ev88/GDeM62Xh1bBZNVBT5mbGFHkUYYfEumA/2qbLz6Zl4cMPlAcQEJiZKpS6QyOFqUsNigC5iAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733371007; c=relaxed/simple;
	bh=WkWsfvJbLTU2lpShM7JuzIh4DuqBw1F1ZDTM0kwkeiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=ik2UGQkHoS1PqPMsCAVc7AjNUDYZNJOBaSaQoFvB88OedhcSW8WBIiTB3YBLSUGmzcZI2vQqCT16QndOsf5lMDi+FWZ8F5QfgG5rMctTHnvTsIxXCxA0LGbPJT80Gp8yAOhEApey9BtNEuX1d2CN98ZOXV4pqFpbab4X+CRGT3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OIDBA2ot; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OIDBA2ot"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733371003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5oi4qJo9HOffjsNYF0vIl0a8cVua4KEfiMIT0RCz9pE=;
	b=OIDBA2ot8mHs+N2qh8QTl1Z55VEWFFPnw7madpHTl/UB31lzqGZIurl/B9c6bhAktSAqHx
	iAP3npWImD8qzUwamo3FFbbjeX5jrPgyOfR7xv3uuG6u62gIxyVNGnHfTbD0Nw2oW/VQwQ
	4WU41j3A4Ep/jYzj2RUkIZ9DJ/qbN/Q=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-9-CMXtJ_4NPe6zwioYSdpE8g-1; Wed,
 04 Dec 2024 22:56:41 -0500
X-MC-Unique: CMXtJ_4NPe6zwioYSdpE8g-1
X-Mimecast-MFC-AGG-ID: CMXtJ_4NPe6zwioYSdpE8g
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 076A4195608F;
	Thu,  5 Dec 2024 03:56:41 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E6761956052;
	Thu,  5 Dec 2024 03:56:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4B53udGK1218977
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 4 Dec 2024 22:56:39 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4B53udXF1218976;
	Wed, 4 Dec 2024 22:56:39 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 3/3] multipathd: Don't call select_action in reload_map
Date: Wed,  4 Dec 2024 22:56:38 -0500
Message-ID: <20241205035638.1218953-4-bmarzins@redhat.com>
In-Reply-To: <20241205035638.1218953-1-bmarzins@redhat.com>
References: <20241205035638.1218953-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UJxqMZ0a9I1YPxPU7kZvQAG2URkB3aheuUw8TGFZMaM_1733371001
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

reload_map() was calling select_action() with force_reload set. Since
mpp will always be a member of vecs->mpvec when reload_map() is called,
when cmpp and cmpp_by_name are looked up in select_action(), they will
just point to mpp. This means that none of the early checks related to
cmpp in select_action() will do anything, and the action will always
end up being ACT_RELOAD. So we can just set ACT_RELOAD in reload_map()
and skip the work.

Additionally, calling select_action() with force_reload set will set
force_udev_reload. This isn't necessary for any of the reload_map()
callers, and will just cause udev to do extra work. I did set
force_udev_reload in cli_reload(), so that it works like calling
"multipath -r", which does force udev to rescan the device.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli_handlers.c | 1 +
 multipathd/main.c         | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index ec330d81..0849fe51 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -818,6 +818,7 @@ cli_reload(void *v, struct strbuf *reply, void *data)
 		return 1;
 	}
 
+	mpp->force_udev_reload = 1;
 	return reload_and_sync_map(mpp, vecs);
 }
 
diff --git a/multipathd/main.c b/multipathd/main.c
index c1ae44f2..c0cf0d06 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2273,7 +2273,7 @@ static int reload_map(struct vectors *vecs, struct multipath *mpp,
 		condlog(0, "%s: failed to setup map", mpp->alias);
 		return 1;
 	}
-	select_action(mpp, vecs->mpvec, 1);
+	mpp->action = ACT_RELOAD;
 
 	r = domap(mpp, params, is_daemon);
 	if (r == DOMAP_FAIL || r == DOMAP_RETRY) {
-- 
2.46.2

