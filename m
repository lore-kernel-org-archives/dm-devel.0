Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5DE3B2BB
	for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 03:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737602212; cv=none; b=hMCXQchvn1i5+Yo1fksGEDBB6g+jk9y0ZI4FxmBykTNC8tjasHn9elcptz8WUWy1uWykoKqFLaBGr/hA1EymAPo2+cHeD1gokI6/PpaVMh8uiF0feTHtKg+hqb4QZ5iTkwHR+YVBYOnSFT4ctjqOGP2hBFtpe960rRSH9qs5Tkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737602212; c=relaxed/simple;
	bh=JOi6QPAPDEqBg/hBDi5tf0dXfbQqDLIztg2IN4/cNG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=pulA2lkS6evTi1FjRHLV6oDhvHpgHMSPQ7f3k9+DLnLimpDWPanlSBXNIrIqeYTBfXn6oNA9SrllbyxPPdbGGBs4/c/q5zO3LrbyU4+PLTlnL3baV0DLagsqGKMV05OyzFZ6R8pfP9syKfJFncLBWJgEzetoJbilBnoLqKzPmII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wi1s6BiS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wi1s6BiS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737602209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9wJsjo89tlt4+Gm3wH/ufjzcnSjaH9eEz2xCHnKAJy0=;
	b=Wi1s6BiSMzl5owAL8GruAwD+yiI1bsJz6PYh/F3zBgP0TKmSecE3JYS31q6kJlJ+g4y4TG
	eKTJOy+7ZrWV6IO7QB6mLqjM4mApfynNkcpmgINc/e35dsz3HOOtnIRwwLPmsCe0obZeIq
	6pbMSXdMa598qN0ocPDH8QQgVWKTyQs=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-92-E9Y3JCXXOkKIYe6cARzLuw-1; Wed,
 22 Jan 2025 22:16:48 -0500
X-MC-Unique: E9Y3JCXXOkKIYe6cARzLuw-1
X-Mimecast-MFC-AGG-ID: E9Y3JCXXOkKIYe6cARzLuw
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D905C195608A;
	Thu, 23 Jan 2025 03:16:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 984F330001BE;
	Thu, 23 Jan 2025 03:16:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 50N3GjjO3017953
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 22:16:45 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 50N3GjJc3017952;
	Wed, 22 Jan 2025 22:16:45 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 10/13] libmultipath: set need_reload when pp->serial gets set
Date: Wed, 22 Jan 2025 22:16:40 -0500
Message-ID: <20250123031643.3017891-11-bmarzins@redhat.com>
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
X-Mimecast-MFC-PROC-ID: RHv9SUF-zg4s9lrkmcLylpn2G-2ew4uowiBzoQjocGE_1737602207
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If a multipath device has a path grouping policy of "group_by_serial"
and pp->serial wasn't previously set, set need_reload. If the multipath
device hasn't been created yet, need_reload will get cleared when the
device is created. If the multipath device already exists, the path
likely wasn't in the correct pathgroup, since it was unable to set
pp->serial before the paths were grouped.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 2015a32f..48e23d44 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -2317,6 +2317,7 @@ get_uid (struct path * pp, int path_state, struct udev_device *udev,
 int pathinfo(struct path *pp, struct config *conf, int mask)
 {
 	int path_state;
+	bool need_serial_recheck = false;
 
 	if (!pp || !conf)
 		return PATHINFO_FAILED;
@@ -2357,6 +2358,10 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 			   pp->dev) > 0)
 		return PATHINFO_SKIPPED;
 
+	if (pp->mpp && pp->mpp->pgpolicyfn == (pgpolicyfn *)group_by_serial &&
+	    pp->serial[0] == '\0')
+		need_serial_recheck = true;
+
 	condlog(4, "%s: mask = 0x%x", pp->dev, mask);
 
 	/*
@@ -2415,6 +2420,8 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 			    pp->state == PATH_UNCHECKED ||
 			    pp->state == PATH_WILD)
 				pp->chkrstate = pp->state = path_state;
+		if (need_serial_recheck && pp->serial[0] != '\0')
+			pp->mpp->need_reload = true;
 		return PATHINFO_OK;
 	}
 
@@ -2524,6 +2531,8 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 
 	if ((mask & DI_ALL) == DI_ALL)
 		pp->initialized = INIT_OK;
+	if (need_serial_recheck && pp->serial[0] != '\0')
+		pp->mpp->need_reload = true;
 	return PATHINFO_OK;
 
 blank:
-- 
2.46.2

