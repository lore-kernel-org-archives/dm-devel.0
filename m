Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50B9FC433F5
	for <dm-devel@archiver.kernel.org>; Sun, 20 Mar 2022 21:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647810776;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lq88HPUDkV3cWhpmFNAk3n49tbsjkCPB8xkLBLi6EfY=;
	b=FcuSwoYm29ZaZ2i5rhYCV5BfXd3s7KgHDV+uHZoBRYV1fQM+bYljQtPWgSLDGwPlDH2yog
	FkF383Sk6U6T5ULjEZIULWuYCdQR06hITtmlqn1gqrdvg2G3fL0KIqZUu8UawujzV2tXUe
	W8BOw16yf2HcPZt/W3HrG90ziHaULhA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-34-7RC04D7NMOuGdRuql9_gOQ-1; Sun, 20 Mar 2022 17:12:54 -0400
X-MC-Unique: 7RC04D7NMOuGdRuql9_gOQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A076B3C00102;
	Sun, 20 Mar 2022 21:12:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 749EC492C14;
	Sun, 20 Mar 2022 21:12:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 297AB1947BBB;
	Sun, 20 Mar 2022 21:12:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B8E5E19451F3
 for <dm-devel@listman.corp.redhat.com>; Sun, 20 Mar 2022 21:12:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 966C241D415; Sun, 20 Mar 2022 21:12:46 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8DCB341D40F;
 Sun, 20 Mar 2022 21:12:46 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 22KLCkY5018443; Sun, 20 Mar 2022 17:12:46 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 22KLCk9T018439; Sun, 20 Mar 2022 17:12:46 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Sun, 20 Mar 2022 17:12:46 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Message-ID: <alpine.LRH.2.02.2203201711500.18240@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH] dm-ioctl: log an error if the ioctl structure is
 corrupted
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Log an error if the ioctl structure is corrupted. This will help us triage
bugs when when userspace is passing invalid ioctl structure to the kernel.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-ioctl.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

Index: linux-dm/drivers/md/dm-ioctl.c
===================================================================
--- linux-dm.orig/drivers/md/dm-ioctl.c	2022-03-17 19:19:31.000000000 +0100
+++ linux-dm/drivers/md/dm-ioctl.c	2022-03-20 20:37:34.000000000 +0100
@@ -891,15 +891,21 @@ static struct hash_cell *__find_device_h
 	struct hash_cell *hc = NULL;
 
 	if (*param->uuid) {
-		if (*param->name || param->dev)
+		if (*param->name || param->dev) {
+			DMWARN("Invalid ioctl structure: uuid %s, name %s, dev %llx",
+				param->uuid, param->name, (unsigned long long)param->dev);
 			return NULL;
+		}
 
 		hc = __get_uuid_cell(param->uuid);
 		if (!hc)
 			return NULL;
 	} else if (*param->name) {
-		if (param->dev)
+		if (param->dev) {
+			DMWARN("Invalid ioctl structure: name %s, dev %llx",
+				param->name, (unsigned long long)param->dev);
 			return NULL;
+		}
 
 		hc = __get_name_cell(param->name);
 		if (!hc)
@@ -1851,8 +1857,10 @@ static int copy_params(struct dm_ioctl _
 	if (copy_from_user(param_kernel, user, minimum_data_size))
 		return -EFAULT;
 
-	if (param_kernel->data_size < minimum_data_size)
+	if (param_kernel->data_size < minimum_data_size) {
+		DMWARN("Invalid data size in the ioctl structure: %u", param_kernel->data_size);
 		return -EINVAL;
+	}
 
 	secure_data = param_kernel->flags & DM_SECURE_DATA_FLAG;
 
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

