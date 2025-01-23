Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F035FEE6
	for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 03:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737602214; cv=none; b=rZyo9Q0QNIpl7yBwmhcS2Doj58XrSz+/Xzu37582OM274kQTZvhPUb7E/5dukMi/eTMOgK+Ki1J/O6uUFWwr72C7PJXJpve3lb6FvSp0f/Rb3xXc8V6SX1Mh6FHhDVqimNXAtMOKK2xaFDi1SkQfLJ8063dZ0IElwfVR7++kLQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737602214; c=relaxed/simple;
	bh=ECGJCFCb1HuhkHVze3We4qJr6VYwLep+Kx35J3kbg0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=ecq+T3FVDCmGOIxg7oOg6C1KYrDJogGKjD/OoNPtUVg7j3ih88bV5ww4bIDT0LoN7WZ+qFiXov1DEzV04icdWkxpB8CueW/icZ9ljGSlmhVKPiw1EcIIsjQYYSqzdCTV6ppIshcPTRid9LoH0TuaZufEMFszFE3HSza7vl0wzko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QMFFcUMd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QMFFcUMd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737602210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tlyr+kGHhIc4M8ohRcVGhYUHgpZ88VesAOdaHdUYbTA=;
	b=QMFFcUMdBWlGu/9MK89GcaqpQsdgxuqdo1p5+fsdEv7nhhYwhIEoedu1HS2VEe4TFYboyr
	bEaMVtQ3DB3O7MouWErtrc5i9jGb1mFSH4iTkzMCO87cuswgdDdN26EUiottMD7/MqGgkd
	QvkC4FE3zsv3LW8oQt8y73oiE8j9kLU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-479-C9EpCWymO_KDa-OCv6DGrg-1; Wed,
 22 Jan 2025 22:16:47 -0500
X-MC-Unique: C9EpCWymO_KDa-OCv6DGrg-1
X-Mimecast-MFC-AGG-ID: C9EpCWymO_KDa-OCv6DGrg
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7716319560B0;
	Thu, 23 Jan 2025 03:16:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 045B8195608A;
	Thu, 23 Jan 2025 03:16:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 50N3Gi5M3017937
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 22:16:44 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 50N3GiKr3017936;
	Wed, 22 Jan 2025 22:16:44 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 06/13] libmultipath: Dont scan pointless sysfs parents
Date: Wed, 22 Jan 2025 22:16:36 -0500
Message-ID: <20250123031643.3017891-7-bmarzins@redhat.com>
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
X-Mimecast-MFC-PROC-ID: xMRR7e6Vp_AkoIaA6XDCBxZOtQJq_E8dPG_A0JDxUyY_1737602206
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

In scsi_sysfs_pathinfo() we should just look for the parent that we want,
instead of checking all the parents.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 27 ++++++++++-----------------
 tests/test-lib.c         |  1 -
 2 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index cc4efbfc..3d4da127 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1527,23 +1527,16 @@ scsi_sysfs_pathinfo (struct path *pp, const struct vector_s *hwtable)
 	const char *attr_path = NULL;
 	static const char unknown[] = "UNKNOWN";
 
-	parent = pp->udev;
-	while (parent) {
-		const char *subsys = udev_device_get_subsystem(parent);
-		if (subsys && !strncmp(subsys, "scsi", 4)) {
-			attr_path = udev_device_get_sysname(parent);
-			if (!attr_path)
-				break;
-			if (sscanf(attr_path, "%i:%i:%i:%" SCNu64,
-				   &pp->sg_id.host_no,
-				   &pp->sg_id.channel,
-				   &pp->sg_id.scsi_id,
-				   &pp->sg_id.lun) == 4)
-				break;
-		}
-		parent = udev_device_get_parent(parent);
-	}
-	if (!attr_path || pp->sg_id.host_no == -1)
+	parent = udev_device_get_parent_with_subsystem_devtype(pp->udev, "scsi",
+							       "scsi_device");
+	if (!parent)
+		return PATHINFO_FAILED;
+	attr_path = udev_device_get_sysname(parent);
+	if (!attr_path)
+		return PATHINFO_FAILED;
+	if (sscanf(attr_path, "%i:%i:%i:%" SCNu64,
+		   &pp->sg_id.host_no,
+		   &pp->sg_id.channel, &pp->sg_id.scsi_id, &pp->sg_id.lun) != 4)
 		return PATHINFO_FAILED;
 
 	if (sysfs_get_vendor(parent, pp->vendor_id, SCSI_VENDOR_SIZE) <= 0) {
diff --git a/tests/test-lib.c b/tests/test-lib.c
index 99becccd..bb1d8cdd 100644
--- a/tests/test-lib.c
+++ b/tests/test-lib.c
@@ -282,7 +282,6 @@ struct mocked_path *mocked_path_from_path(struct mocked_path *mp,
 static const char hbtl[] = "4:0:3:1";
 static void mock_sysfs_pathinfo(const struct mocked_path *mp)
 {
-	will_return(__wrap_udev_device_get_subsystem, "scsi");
 	will_return(__wrap_udev_device_get_sysname, hbtl);
 	will_return(__wrap_udev_device_get_sysname, hbtl);
 	will_return(__wrap_udev_device_get_sysattr_value, mp->vendor);
-- 
2.46.2

