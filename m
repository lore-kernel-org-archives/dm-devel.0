Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3811684BE
	for <dm-devel@lists.linux.dev>; Tue,  7 Jul 2026 00:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783385306; cv=none; b=dTUE6yZE3LiYzJMYYRl/psieKEyx+OHcnUGlK33qCdf05YOgvEZYgwQ4RkCZvrp5dZsH3HIo9VS63/4RtDZLGuiN9eBNQRb9b8iSvfTfCtAdNeAyYH0XsUf/yUEOawH+8waEBRXofHzxifbHWoWXMLedKPata07K7DWv0+FP3nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783385306; c=relaxed/simple;
	bh=vUfWm7+sx9mVug3FPxUvcp3hxfzYxiiuKuokB1w2YGY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=AebaPQOiGKRDCZE64hwaCMqUhuyv7dvQph8gwczvNtHxS8RSRvyJ7rqXxV6ymw5JSsXmmorRm3CYbcRnE8wKeUBKinrtggAigqOsGFLhXgEbtBolA8vWdDj0qVwJOo22SQJ0qkOHQQDwEWQDrDgBXmjVZXn6h/hqSP+M4VEE/uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XrZUciEE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XrZUciEE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783385304;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=V9qsZ1aVZJr3j4kPHBPZbDDKnEa1okLq8Hki2rhyQ4c=;
	b=XrZUciEEK4gLuTzkgKlJJc+RFxb1OUXIJDzZPdTjrsSyOToIWkFwsYSSB9cvX4+Vhp2jez
	6CBq0PsCWig9947y+CWx4uk9QWUJelEZt2UB0+Bp92fSzrh+qbnbuYPq0uH914yDEibpkC
	KeXQq7lDme2NRE9sC+zgN008iMoiF24=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-447-yzPoSCu1O6e9HW32fcXFWg-1; Mon,
 06 Jul 2026 20:48:20 -0400
X-MC-Unique: yzPoSCu1O6e9HW32fcXFWg-1
X-Mimecast-MFC-AGG-ID: yzPoSCu1O6e9HW32fcXFWg_1783385299
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 45A681955DB3;
	Tue,  7 Jul 2026 00:48:19 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EA7BD1800674;
	Tue,  7 Jul 2026 00:48:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6670mHjJ1958274
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 6 Jul 2026 20:48:17 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6670mH3f1958273;
	Mon, 6 Jul 2026 20:48:17 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/2] libmultipath: make sure sscanf sets a max field width for strings
Date: Mon,  6 Jul 2026 20:48:16 -0400
Message-ID: <20260707004817.1958264-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8OEfaIbXVrVBqBJlfegx0rlP17vwOxW6ForOMejLRVs_1783385299
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

In the iet and datacore prioritizers, multipath was using sscanf to get
a string for a 255 byte buffer, without limiting the size of the string.
This could result in a buffer overflow, if there was a bad value in
multipath.conf.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---

Note:
This patch applies on top of Martin's ("libmultipath: iet prioritizer:
obtain PATH_ID from udev") commit, from the "tip" branch.

 libmultipath/prioritizers/datacore.c | 6 +++---
 libmultipath/prioritizers/iet.c      | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libmultipath/prioritizers/datacore.c b/libmultipath/prioritizers/datacore.c
index ab813a0e..a7c2ae3e 100644
--- a/libmultipath/prioritizers/datacore.c
+++ b/libmultipath/prioritizers/datacore.c
@@ -49,11 +49,11 @@ int datacore_prio (const char *dev, int sg_fd, char * args,
 		return 0;
 	}
 
-	if (sscanf(args, "timeout=%i preferredsds=%s",
+	if (sscanf(args, "timeout=%i preferredsds=%254s",
 		   (int *)&timeout_ms, preferredsds) == 2) {}
-	else if (sscanf(args, "preferredsds=%s timeout=%i",
+	else if (sscanf(args, "preferredsds=%254s timeout=%i",
 			preferredsds, (int *)&timeout_ms) == 2) {}
-	else if (sscanf(args, "preferredsds=%s",
+	else if (sscanf(args, "preferredsds=%254s",
 			preferredsds) == 1) {}
 	else {
 		dc_log(0, "unexpected prio_args format");
diff --git a/libmultipath/prioritizers/iet.c b/libmultipath/prioritizers/iet.c
index 97d35192..cddf29c6 100644
--- a/libmultipath/prioritizers/iet.c
+++ b/libmultipath/prioritizers/iet.c
@@ -101,7 +101,7 @@ int iet_prio(struct udev_device *udev, char *args)
 		return 0;
 	}
 	// check if args format is OK
-	if (sscanf(args, "preferredip=%s", preferredip) != 1) {
+	if (sscanf(args, "preferredip=%254s", preferredip) != 1) {
 		if (!arg_logged) {
 			dc_log(2, "unexpected prio_args format");
 			arg_logged = true;
-- 
2.53.0

