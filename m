Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6D11DF25D
	for <dm-devel@lists.linux.dev>; Tue, 26 Nov 2024 18:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732646555; cv=none; b=is2Yd/9V3Oq0ONkzgGf5iYJ8hCqSvCALcOZ6Pd/yvGX+/ey7+OCpGMKTQz2E/jIrKkbm+m4s59W3pilAYV553twKOgpOm/Had1TN/X4zcfYWJkM+UXERgICmWm91EfqZKLmQzDjucEN7ipLVYgxq45/E0uPs1qFYMR5idMx44Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732646555; c=relaxed/simple;
	bh=5u1fJfaqTxp5ngofSBsrH3Ty4t5CaaV50Q/BQT6r3qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Ep5O8gpn5qO+GJuMOVvOW+jml6jfEgoXGV/89bPl+7YN0ZmL4+U0nB/cXov5u3DSC1SEkZ/eST6580lw1RKzorrKkm2DI/ST40oxxvfmVIH+kA8SLa7kVaw2JoOLj7WFNHtCcxXRSqozblGaZlIBoPC8H5XisFvs160mUkKk43Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J/PxC6Ze; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J/PxC6Ze"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732646552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HrIsM1M6Hi4v7xXB9cBnBk0Dvf5k+gzPhDBAiU2nhoY=;
	b=J/PxC6Zet/Fjda66gjsL5n2FTuX9lOthN5VfJ/CwdHpAn18wfFQXdIMdG+x4gSDv/aOA8+
	G8FHsMKlwX8TyRuVuq+YJXphtKN09/SsGNPCZHR8mq1QpWnumHSI49ykeFJ6eJHU1P3vNw
	Gk3+GBrMmZF+AGLvyWxKRvQLgXuD0dk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-344-jqSfxlWNOEqBIBoDBV-Y1A-1; Tue,
 26 Nov 2024 13:42:29 -0500
X-MC-Unique: jqSfxlWNOEqBIBoDBV-Y1A-1
X-Mimecast-MFC-AGG-ID: jqSfxlWNOEqBIBoDBV-Y1A
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4F5F51955F28;
	Tue, 26 Nov 2024 18:42:27 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0573D195E485;
	Tue, 26 Nov 2024 18:42:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AQIgPld855504
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 Nov 2024 13:42:25 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AQIgP8j855503;
	Tue, 26 Nov 2024 13:42:25 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v3 06/12] libmultipath: handle a create corner case for empty devices
Date: Tue, 26 Nov 2024 13:42:18 -0500
Message-ID: <20241126184224.855459-7-bmarzins@redhat.com>
In-Reply-To: <20241126184224.855459-1-bmarzins@redhat.com>
References: <20241126184224.855459-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MbeuL9sudySzwG-EGLjnucIBuue0tCupxotn8G2aYMA_1732646547
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Multipath already notices if there is any empty device with the same
alias and wwid as a device it is trying to create, and switches to a
reload. However, if the empty device has a different alias but the same
wwid, instead of reloading and renaming the device like it would for
a device with a table. multipath will attempt to create a new device
and fail.

Fix this by checking for these devices, and doing a reload and rename.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index a7257981..d0e9c958 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -835,7 +835,6 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 {
 	int r = DOMAP_FAIL;
 	struct config *conf;
-	char wwid[WWID_SIZE];
 
 	/*
 	 * last chance to quit before touching the devmaps
@@ -846,6 +845,7 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 	}
 
 	if (mpp->action == ACT_CREATE) {
+		char wwid[WWID_SIZE];
 		int rc = dm_get_wwid(mpp->alias, wwid, sizeof(wwid));
 
 		if (rc == DMP_OK && !strncmp(mpp->wwid, wwid, sizeof(wwid))) {
@@ -863,7 +863,26 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 			mpp->action = ACT_REJECT;
 		}
 	}
+	if (mpp->action == ACT_CREATE) {
+		char alias[WWID_SIZE];
+		int rc = dm_find_map_by_wwid(mpp->wwid, alias, NULL);
 
+		if (rc == DMP_NO_MATCH) {
+			condlog(1, "%s: wwid \"%s\" already in use by non-multipath map \"%s\"",
+				mpp->alias, mpp->wwid, alias);
+			mpp->action = ACT_REJECT;
+		} else if (rc == DMP_OK || rc == DMP_EMPTY) {
+			/*
+			 * we already handled the case were rc == DMO_OK and
+			 * the alias == mpp->alias above. So the alias must be
+			 * different here.
+			 */
+			condlog(3, "%s: map already present with a different name \"%s\". reloading",
+				mpp->alias, alias);
+			strlcpy(mpp->alias_old, alias, WWID_SIZE);
+			mpp->action = ACT_RELOAD_RENAME;
+		}
+	}
 	if (mpp->action == ACT_RENAME || mpp->action == ACT_SWITCHPG_RENAME ||
 	    mpp->action == ACT_RELOAD_RENAME ||
 	    mpp->action == ACT_RESIZE_RENAME) {
-- 
2.46.2

