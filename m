Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEF135977
	for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 03:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737602211; cv=none; b=N+/1BoLN24sKL7wWVM+6/4HI8fUDyFyuPBRSQXlJQDTQ8H24jst/acEZ+IxK8zXX06Oos7nmpM3sN00lO9hMGHaPt0sUajc9Er7J0r55XUWcnoL4rjGdmTgGJD46pIHBq+AQbXoCv3gXEB1nFVb70sRjPxfpzqfZAumjh2n8xcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737602211; c=relaxed/simple;
	bh=QYFo63OVB/3gfzJh1eIsYBX5BfgjYlbU7uxiAsJBmUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=EISapCX1KHQ6FCURBfQ+1h7heKCyx3NTj04d0yeCA/Qs19Tkm8YJEBMNCsdHWG8JMBFZloFfJoyXYisMBE7CbRn/MFNh5IxE2UfblEPrDkirMMLMujpBH463HAQei04nQxkZR+NvRvbaXSuO8BGWdJ+LwJME6EiAL7DANiQk6kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KjnLrSk4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KjnLrSk4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737602209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9DTy1f6JjPieboeFoC984ZJq0d/OdRtVT+y4Hj8ATaw=;
	b=KjnLrSk41QKjN7Tec3xLlhjF8ax/wm1xMczmiXNjXU6uxWYBpNr2Nyx3liB7sOFeFXr3+j
	qg6M2cSM243UIHXK6TdxH0ABP64jXyl1P68hOncx2rwb6rEtMg3erNn2N0nt+WPsJEER8n
	rbjD+fntA2Qt7GiEz8OdNPc5p/fL7H4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-265-xqg-n_ytOCyw6NYvs4ASfA-1; Wed,
 22 Jan 2025 22:16:47 -0500
X-MC-Unique: xqg-n_ytOCyw6NYvs4ASfA-1
X-Mimecast-MFC-AGG-ID: xqg-n_ytOCyw6NYvs4ASfA
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E4B0195608D;
	Thu, 23 Jan 2025 03:16:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 67E3A195E3D9;
	Thu, 23 Jan 2025 03:16:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 50N3GjWn3017945
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 22:16:45 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 50N3GjM63017944;
	Wed, 22 Jan 2025 22:16:45 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 08/13] libmultipath: rename DI_SERIAL to DI_IOCTL
Date: Wed, 22 Jan 2025 22:16:38 -0500
Message-ID: <20250123031643.3017891-9-bmarzins@redhat.com>
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
X-Mimecast-MFC-PROC-ID: 1cy889KjrEVv7RplBaXLdY5EldH4HgQRTf-tzSkxLmE_1737602206
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

DI_IOCTL is a much more sensible name for what this flag controls.  All
the pathinfo functions that run for DI_SERIAL use ioctls. They don't
just get the serial info, and the serial info can also be gotten by
functions run for DI_SYSFS.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 6 +++---
 libmultipath/discovery.h | 7 +++----
 multipath/main.c         | 2 +-
 tests/test-lib.c         | 2 +-
 4 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index ea10f086..8a780d69 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1912,7 +1912,7 @@ scsi_ioctl_pathinfo (struct path * pp, int mask)
 {
 	int vpd_id;
 
-	if (!(mask & DI_SERIAL))
+	if (!(mask & DI_IOCTL))
 		return;
 
 	select_vpd_vendor_id(pp);
@@ -2433,13 +2433,13 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 		goto blank;
 	}
 
-	if (mask & DI_SERIAL)
+	if (mask & DI_IOCTL)
 		get_geometry(pp);
 
 	if (path_state == PATH_UP && pp->bus == SYSFS_BUS_SCSI)
 		scsi_ioctl_pathinfo(pp, mask);
 
-	if (pp->bus == SYSFS_BUS_CCISS && mask & DI_SERIAL)
+	if (pp->bus == SYSFS_BUS_CCISS && mask & DI_IOCTL)
 		cciss_ioctl_pathinfo(pp);
 
 	if (mask & DI_CHECKER) {
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 1f7a6e20..c4a8dd96 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -67,7 +67,7 @@ void cleanup_udev_device_ptr(void *arg);
  */
 enum discovery_mode {
 	DI_SYSFS__,
-	DI_SERIAL__,
+	DI_IOCTL__,
 	DI_CHECKER__,
 	DI_PRIO__,
 	DI_WWID__,
@@ -77,7 +77,7 @@ enum discovery_mode {
 };
 
 #define DI_SYSFS	(1 << DI_SYSFS__)
-#define DI_SERIAL	(1 << DI_SERIAL__)
+#define DI_IOCTL	(1 << DI_IOCTL__)
 #define DI_CHECKER	(1 << DI_CHECKER__)
 #define DI_PRIO		(1 << DI_PRIO__)
 #define DI_WWID		(1 << DI_WWID__)
@@ -85,7 +85,6 @@ enum discovery_mode {
 #define DI_NOIO		(1 << DI_NOIO__) /* Avoid IO on the device */
 #define DI_NOFALLBACK	(1 << DI_NOFALLBACK__) /* do not allow wwid fallback */
 
-#define DI_ALL		(DI_SYSFS  | DI_SERIAL | DI_CHECKER | DI_PRIO | \
-			 DI_WWID)
+#define DI_ALL		(DI_SYSFS  | DI_IOCTL | DI_CHECKER | DI_PRIO | DI_WWID)
 
 #endif /* DISCOVERY_H_INCLUDED */
diff --git a/multipath/main.c b/multipath/main.c
index 54d635da..46399350 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -533,7 +533,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 
 	if (cmd == CMD_LIST_LONG)
 		/* extended path info '-ll' */
-		di_flag |= DI_SYSFS | DI_CHECKER | DI_SERIAL;
+		di_flag |= DI_SYSFS | DI_CHECKER | DI_IOCTL;
 	else if (cmd == CMD_LIST_SHORT)
 		/* minimum path info '-l' */
 		di_flag |= DI_SYSFS;
diff --git a/tests/test-lib.c b/tests/test-lib.c
index cb60f10e..e529711d 100644
--- a/tests/test-lib.c
+++ b/tests/test-lib.c
@@ -18,7 +18,7 @@
 #include "test-lib.h"
 #include "wrap64.h"
 
-const int default_mask = (DI_SYSFS|DI_BLACKLIST|DI_WWID|DI_CHECKER|DI_PRIO|DI_SERIAL);
+const int default_mask = (DI_SYSFS|DI_BLACKLIST|DI_WWID|DI_CHECKER|DI_PRIO|DI_IOCTL);
 const char default_devnode[] = "sdxTEST";
 const char default_wwid[] = "TEST-WWID";
 /* default_wwid should be a substring of default_wwid_1! */
-- 
2.46.2

