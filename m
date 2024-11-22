Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6717B17DFFC
	for <dm-devel@lists.linux.dev>; Fri, 22 Nov 2024 21:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732309902; cv=none; b=AzdEJLDDyv4VA6OQnkqIeTBM2DEgnHp2mWEDpAfFqbTNbsVaekj8o2LX8kdZ3uWSImCiGnmQSlud17NN3mBKSDCu11xYvjduIasIUgB0mh72p6UiEEr4Q+TcWjABeMZyXXm5i2yoGdSIePeAhZQFMy2zDRviDuSPi4swqZ0F5DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732309902; c=relaxed/simple;
	bh=aEnNGcu2YdXcKRGpLp4D8SLXxgHyuR9topp8iWcrtBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=mxO5T+Gkd9Uox6cW5kuqcFUrDm8VCk+VBqer3KrVoY408382Rx+qzJejxOK/wQHuJF4NaAQ9UxwVr+mz0yihc/dIhEv22Cl67B22Xor3l9aNVtN/HGDT/3MocL7deIMFIeizY3onM34GsIdlBf1n7Bd1/5gjzA98IO1P3PtHkpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZhOAlV6a; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZhOAlV6a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732309899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=esAFpuP4FfauggHP7CiJ3Npwrh2FqmsCsbcPKj3efw0=;
	b=ZhOAlV6alcv6XM1oDMQMqVuMx2x49X0hJAKoBubuCkAyBUi15xN6eqHMAV9tjyGBFowaIZ
	SoRzskFEngCIAhTPImZMV/hz5JAtQTwWvjjUOl66CzhC8NFZThc7KLd0qAAkfZyHwtPd8z
	hCtJiR/Ms4ftPRmDz0mtvIA8z3MFvEs=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-99-TSQ-VfInMRCt4tBtGRLA9g-1; Fri,
 22 Nov 2024 16:11:38 -0500
X-MC-Unique: TSQ-VfInMRCt4tBtGRLA9g-1
X-Mimecast-MFC-AGG-ID: TSQ-VfInMRCt4tBtGRLA9g
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 23A291955EEA;
	Fri, 22 Nov 2024 21:11:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D6F911955F3E;
	Fri, 22 Nov 2024 21:11:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AMLBZll718923
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 22 Nov 2024 16:11:35 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AMLBZgf718922;
	Fri, 22 Nov 2024 16:11:35 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 10/13] libmultipath: move dm_rename__ before rename_partmap
Date: Fri, 22 Nov 2024 16:11:30 -0500
Message-ID: <20241122211133.718861-11-bmarzins@redhat.com>
In-Reply-To: <20241122211133.718861-1-bmarzins@redhat.com>
References: <20241122211133.718861-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 90KYTuhQ8coBFltfNfhtzZTCJdUTMsBXvm1F9tNUiGk_1732309897
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

No functional changes.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 55 +++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 29 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index daaeebb4..751b45d8 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1480,7 +1480,32 @@ struct rename_data {
 };
 
 static int
-dm_rename__(const char *old, char *new, int skip_kpartx);
+dm_rename__(const char *old, char *new, int skip_kpartx)
+{
+	int r = 0;
+	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
+	uint32_t cookie = 0;
+	uint16_t udev_flags = DM_UDEV_DISABLE_LIBRARY_FALLBACK | ((skip_kpartx == SKIP_KPARTX_ON)? MPATH_UDEV_NO_KPARTX_FLAG : 0);
+
+	if (!(dmt = libmp_dm_task_create(DM_DEVICE_RENAME)))
+		return r;
+
+	if (!dm_task_set_name(dmt, old))
+		return r;
+
+	if (!dm_task_set_newname(dmt, new))
+		return r;
+
+	if (!dm_task_set_cookie(dmt, &cookie, udev_flags))
+		return r;
+
+	r = libmp_dm_task_run(dmt);
+	if (!r)
+		dm_log_error(2, DM_DEVICE_RENAME, dmt);
+
+	libmp_udev_wait(cookie);
+	return r;
+}
 
 static int
 rename_partmap (const char *name, void *data)
@@ -1520,34 +1545,6 @@ dm_rename_partmaps (const char * old, char * new, char *delim)
 	return do_foreach_partmaps(old, rename_partmap, &rd);
 }
 
-static int
-dm_rename__(const char *old, char *new, int skip_kpartx)
-{
-	int r = 0;
-	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
-	uint32_t cookie = 0;
-	uint16_t udev_flags = DM_UDEV_DISABLE_LIBRARY_FALLBACK | ((skip_kpartx == SKIP_KPARTX_ON)? MPATH_UDEV_NO_KPARTX_FLAG : 0);
-
-	if (!(dmt = libmp_dm_task_create(DM_DEVICE_RENAME)))
-		return r;
-
-	if (!dm_task_set_name(dmt, old))
-		return r;
-
-	if (!dm_task_set_newname(dmt, new))
-		return r;
-
-	if (!dm_task_set_cookie(dmt, &cookie, udev_flags))
-		return r;
-
-	r = libmp_dm_task_run(dmt);
-	if (!r)
-		dm_log_error(2, DM_DEVICE_RENAME, dmt);
-
-	libmp_udev_wait(cookie);
-	return r;
-}
-
 int
 dm_rename (const char * old, char * new, char *delim, int skip_kpartx)
 {
-- 
2.46.2

