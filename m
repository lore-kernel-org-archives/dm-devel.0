Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81028C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 15 Dec 2021 17:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1639590265;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=A9x4T0IYnhyDedT+ipyV1yaUNz5+CRyNDeHUY01G5N0=;
	b=RGFOv7EtyzYBly0+B1ooZYechLaK6wX5unrQPc1F/4bnlT+VBt0kwRAHFc212V42xBS7oA
	ZTAIpz+KIwisI8N+Qws5z6TImH2NS+sKaMjKSTY3fBvS+CR09qy7LX/0Ua7zc/eWe4Z5wW
	Cr9aOQqw02wmSiFpQ57iikTfdmAy72g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-504-pid3No7nO-CHhXF_zcJfVA-1; Wed, 15 Dec 2021 12:44:24 -0500
X-MC-Unique: pid3No7nO-CHhXF_zcJfVA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C0F2802C8F;
	Wed, 15 Dec 2021 17:44:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 71FEC7A227;
	Wed, 15 Dec 2021 17:44:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 013CF4CA93;
	Wed, 15 Dec 2021 17:44:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BFHiIM8018391 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 15 Dec 2021 12:44:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 402747A229; Wed, 15 Dec 2021 17:44:18 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2881B7A225;
	Wed, 15 Dec 2021 17:44:18 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1BFHiGjZ011343; 
	Wed, 15 Dec 2021 11:44:16 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1BFHiFWE011342;
	Wed, 15 Dec 2021 11:44:15 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 15 Dec 2021 11:44:10 -0600
Message-Id: <1639590250-11293-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1639590250-11293-1-git-send-email-bmarzins@redhat.com>
References: <1639590250-11293-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 3/3] multipathd: avoid unnecessary path
	read-only reloads
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

A mulitpath device can only be reloaded read/write when all paths are
read/write. Also, whenever a read-only scsi device is rescanned, the
scsi subsystem will first unconditionally issue a uevent with DISK_RO=0
before checking the read-only status, and if it the device is still
read-only, issuing another uevent with DISK_RO=1. These uevents cause
pointless reloads when read-only paths are rescanned. To avoid this,
first check if the path is being changed to the existing multipath
read-only state. If the state is the same, do nothing. If it's
different, check to see if all paths are read/write before changing a
multipath device from read-only to read/write. If the multipath device
read-only state is unknown, assume that it needs to be reloaded.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 2e99a266..009a99d9 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1440,6 +1440,52 @@ finish_path_init(struct path *pp, struct vectors * vecs)
 	return -1;
 }
 
+static int
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
+static bool
+needs_ro_update(struct multipath *mpp, int ro)
+{
+	struct pathgroup * pgp;
+	struct path * pp;
+	unsigned int i, j;
+
+	if (!mpp || ro < 0)
+		return false;
+	if (!has_dm_info(mpp))
+		return true;
+	if (mpp->dmi.read_only == ro)
+		return false;
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
@@ -1512,7 +1558,7 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
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

