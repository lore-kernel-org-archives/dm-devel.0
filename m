Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A267C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 22:49:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2CD1161260
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 22:49:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2CD1161260
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637275771;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=F0t3WuHLdqmt7ieVMbFir4UARxjdLA58OO+zKNb3MIc=;
	b=hAiiKtfX3BiUcrV1OM34eruGKNAxcOsOgGz86yVrylI6Hgio48prnj2K456j3WabdpLqlr
	hcLR8NZkgEuQZtWzGxHkS2D/I5GzF9GEwc33zi2AZnVEY+7rtTgNNr4/EmrVwYyF5c1nR8
	vkrjYLvncf8AxMaECmVY334MSNrXihY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-r-1upq5NN1ugJXpCxlqrYA-1; Thu, 18 Nov 2021 17:49:27 -0500
X-MC-Unique: r-1upq5NN1ugJXpCxlqrYA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CCBF87D542;
	Thu, 18 Nov 2021 22:49:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2DE5E5DAA5;
	Thu, 18 Nov 2021 22:49:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F3586181A1D1;
	Thu, 18 Nov 2021 22:49:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIMlquN001442 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 17:47:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BD94D5C1D5; Thu, 18 Nov 2021 22:47:52 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B26E5C1D0;
	Thu, 18 Nov 2021 22:47:50 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AIMlmck013474; 
	Thu, 18 Nov 2021 16:47:48 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AIMllL3013473;
	Thu, 18 Nov 2021 16:47:47 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu, 18 Nov 2021 16:47:47 -0600
Message-Id: <1637275667-13436-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH] multipathd: avoid unnecessary path read-only
	reloads
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

A mulitpath device can only be reloaded read/write when all paths are
read/write. Also, whenever a read-only device is rescanned, the scsi
subsystem will first unconditionally issue a uevent with DISK_RO=0
before checking the read-only status, and if it the device is still
read-only, issuing another uevent with DISK_RO=1. These uevents cause
pointless reloads when read-only paths are rescanned. To avoid this,
check to see if all paths are read/write before changing a multipath
device from read-only to read/write.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/libmultipath.version |  5 +++++
 libmultipath/sysfs.c              | 22 ++++++++++++++++++++++
 libmultipath/sysfs.h              |  1 +
 multipathd/main.c                 | 31 ++++++++++++++++++++++++++++++-
 4 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 58a7d1be..ab4c7e30 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -296,3 +296,8 @@ global:
 local:
 	*;
 };
+
+LIBMULTIPATH_11.1.0 {
+global:
+	sysfs_get_ro;
+} LIBMULTIPATH_11.0.0;
diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 9ff145f2..24c12b6a 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -236,6 +236,28 @@ sysfs_get_size (struct path *pp, unsigned long long * size)
 	return 0;
 }
 
+int
+sysfs_get_ro (struct path *pp)
+{
+	int ro;
+	char buff[3]; /* Either "0\n\0" or "1\n\0" */
+
+	if (!pp->udev)
+		return -1;
+
+	if (sysfs_attr_get_value(pp->udev, "ro", buff, sizeof(buff)) <= 0) {
+		condlog(3, "%s: Cannot read ro attribute in sysfs", pp->dev);
+		return -1;
+	}
+
+	if (sscanf(buff, "%d\n", &ro) != 1 || ro < 0 || ro > 1) {
+		condlog(3, "%s: Cannot parse ro attribute", pp->dev);
+		return -1;
+	}
+
+	return ro;
+}
+
 int sysfs_check_holders(char * check_devt, char * new_devt)
 {
 	unsigned int major, new_minor, table_minor;
diff --git a/libmultipath/sysfs.h b/libmultipath/sysfs.h
index 72b39ab2..c948c467 100644
--- a/libmultipath/sysfs.h
+++ b/libmultipath/sysfs.h
@@ -13,6 +13,7 @@ ssize_t sysfs_attr_get_value(struct udev_device *dev, const char *attr_name,
 ssize_t sysfs_bin_attr_get_value(struct udev_device *dev, const char *attr_name,
 				 unsigned char * value, size_t value_len);
 int sysfs_get_size (struct path *pp, unsigned long long * size);
+int sysfs_get_ro(struct path *pp);
 int sysfs_check_holders(char * check_devt, char * new_devt);
 bool sysfs_is_multipathed(struct path *pp, bool set_wwid);
 #endif
diff --git a/multipathd/main.c b/multipathd/main.c
index 08a8a592..a1665494 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1440,6 +1440,35 @@ finish_path_init(struct path *pp, struct vectors * vecs)
 	return -1;
 }
 
+static bool
+needs_ro_update(struct multipath *mpp, int ro)
+{
+	struct pathgroup * pgp;
+	struct path * pp;
+	unsigned int i, j;
+	struct dm_info *dmi = NULL;
+
+	if (!mpp || ro < 0)
+		return false;
+	dm_get_info(mpp->alias, &dmi);
+	if (!dmi) /* assume we do need to reload the device */
+		return true;
+	if (dmi->read_only == ro) {
+		free(dmi);
+		return false;
+	}
+	free(dmi);
+	if (ro == 1)
+		return true;
+	vector_foreach_slot (mpp->pg, pgp, i) {
+		vector_foreach_slot (pgp->paths, pp, j) {
+			if (sysfs_get_ro(pp) == 1)
+				return false;
+		}
+	}
+	return true;
+}
+
 static int
 uev_update_path (struct uevent *uev, struct vectors * vecs)
 {
@@ -1512,7 +1541,7 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 		}
 
 		ro = uevent_get_disk_ro(uev);
-		if (mpp && ro >= 0) {
+		if (needs_ro_update(mpp, ro)) {
 			condlog(2, "%s: update path write_protect to '%d' (uevent)", uev->kernel, ro);
 
 			if (mpp->wait_for_udev)
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

