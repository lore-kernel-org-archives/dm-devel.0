Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB5D762F7
	for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 03:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737602213; cv=none; b=T4vCDaHQaiCZqcvKS0WH2i5hLClMMJehKfPvydxS7e2kw82SSLXh1MQeZCPtHy73oigTHccB+Hf1EG0PSii+jJfyDXcdiVZseczWNeHrqvooZZYznvKLoowmuvX3Esapkki3Va3NFG8wxTVxsA5RjhVzDrlnqBDhcfhziwRv09A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737602213; c=relaxed/simple;
	bh=JieXzLm+BlpC+So8WzlXUmVw0gl6GT7xrdg3QaWvUjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=a1bs0JwMavy2wHmt/DLygT8GeiU+1HfEpKe2o2O9ymMCazB/9Yey+ff8083XziwvZY+C+uMIi26k8yzThqNnaOgE0wqSuS04g/l6CQ04aLfdBY21Qnt2y82eh35zmF2QTCMHGtSjuVWS0LMMAPFPnbDAbcXItq1SS6wFtktsnhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PR3QZxUO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PR3QZxUO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737602211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dMMcOYSrn5CyDZG+94dzd1AtPJZNI8EJBukFEn5YpDU=;
	b=PR3QZxUO4v64RBs7o1CWkwhfEWp2j2OjipZJpyd3ePmjBz2NlAZn/4RkySzBgBbwlttzt2
	YG++4VxXWM6D8xlsfh3qugw+31kqKRiDaGsd5uXnz46NhXfi3COfuOsQeNxM7m07pH34Jr
	7D6WUUzWWE2/MFy3T0gNXddBk9fBKs0=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-124-ttQC-N7pNi-Z6uMIZAJ_qA-1; Wed,
 22 Jan 2025 22:16:47 -0500
X-MC-Unique: ttQC-N7pNi-Z6uMIZAJ_qA-1
X-Mimecast-MFC-AGG-ID: ttQC-N7pNi-Z6uMIZAJ_qA
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7565619560A1;
	Thu, 23 Jan 2025 03:16:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 29A4519560A7;
	Thu, 23 Jan 2025 03:16:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 50N3GjbN3017941
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 22:16:45 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 50N3GjVi3017940;
	Wed, 22 Jan 2025 22:16:45 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 07/13] libmultipath: move sysfs checks out of scsi_ioctl_pathinfo
Date: Wed, 22 Jan 2025 22:16:37 -0500
Message-ID: <20250123031643.3017891-8-bmarzins@redhat.com>
In-Reply-To: <20250123031643.3017891-1-bmarzins@redhat.com>
References: <20250123031643.3017891-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LnJZ0P01EDAcbuWB8pMf-zfNbhX9QXX6DS2N1Z2w9CM_1737602206
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

There are multiple checks in scsi_ioctl_pathinfo() that only use sysfs.
pathinfo() is never called with DI_SERIAL and not DI_SYSFS, so it's safe
to move them to scsi_sysfs_pathinfo(). The HCTL checking code is already
there, so remove the duplicate, and split the sysfs serial checking from
the ioctl serial checking.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 36 ++++++++----------------------------
 tests/test-lib.c         |  6 ------
 2 files changed, 8 insertions(+), 34 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 3d4da127..ea10f086 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1581,6 +1581,9 @@ scsi_sysfs_pathinfo (struct path *pp, const struct vector_s *hwtable)
 	condlog(3, "%s: tgt_node_name = %s",
 		pp->dev, pp->tgt_node_name);
 
+	if (get_vpd_sysfs(parent, 0x80, pp->serial, SERIAL_SIZE) > 0)
+		condlog(3, "%s: serial = %s (sysfs)", pp->dev, pp->serial);
+
 	return PATHINFO_OK;
 }
 
@@ -1907,8 +1910,6 @@ sysfs_pathinfo(struct path *pp, const struct vector_s *hwtable)
 static void
 scsi_ioctl_pathinfo (struct path * pp, int mask)
 {
-	struct udev_device *parent;
-	const char *attr_path = NULL;
 	int vpd_id;
 
 	if (!(mask & DI_SERIAL))
@@ -1933,34 +1934,13 @@ scsi_ioctl_pathinfo (struct path * pp, int mask)
 		}
 	}
 
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
-		return;
-
-	if (get_vpd_sysfs(parent, 0x80, pp->serial, SERIAL_SIZE) <= 0) {
-		if (get_serial(pp->serial, SERIAL_SIZE, pp->fd)) {
+	if (pp->serial[0] == '\0') {
+		if (get_serial(pp->serial, SERIAL_SIZE, pp->fd))
 			condlog(3, "%s: fail to get serial", pp->dev);
-			return;
-		}
+		else
+			condlog(3, "%s: serial = %s (ioctl)", pp->dev,
+				pp->serial);
 	}
-
-	condlog(3, "%s: serial = %s", pp->dev, pp->serial);
-	return;
 }
 
 static void
diff --git a/tests/test-lib.c b/tests/test-lib.c
index bb1d8cdd..cb60f10e 100644
--- a/tests/test-lib.c
+++ b/tests/test-lib.c
@@ -339,12 +339,6 @@ void mock_pathinfo(int mask, const struct mocked_path *mp)
 	if (mp->flags & NEED_FD)
 		will_return(__wrap_udev_device_get_devnode, _mocked_filename);
 
-	/* scsi_ioctl_pathinfo() */
-	if (mask & DI_SERIAL) {
-		will_return(__wrap_udev_device_get_subsystem, "scsi");
-		will_return(__wrap_udev_device_get_sysname, hbtl);
-	}
-
 	if (mask & DI_WWID) {
 		/* get_udev_uid() */
 		will_return(__wrap_udev_device_get_property_value,
-- 
2.46.2

