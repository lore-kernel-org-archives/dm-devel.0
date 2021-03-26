Return-Path: <SRS0=sRxI=IY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24A2BC433DB
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 00:56:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9E6E561A26
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 00:56:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E6E561A26
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1616720167;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tjNqjEVK1QA+Ma5mTBJK2XURinJdT0WcitQlqP17So0=;
	b=aP7Ps29JBWNnPHmB2QanLld3/y0uhE9wRAX4jswDM+4VXJot23G641JY4Sjaqzjz2EUDPk
	XHzcgS0UFgkgvrFBrSbbN0KACfMOklO3CMRQVrdN+MSWsLE5KgfazoZctIMRq1BcfYL7As
	uCpaM9OwRhmuaoDuC8TctD9BmJv0/pg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-EHZTqY5MP4ae46VqV3a2aw-1; Thu, 25 Mar 2021 20:56:05 -0400
X-MC-Unique: EHZTqY5MP4ae46VqV3a2aw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7F49190A7A2;
	Fri, 26 Mar 2021 00:56:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B94F95D9D0;
	Fri, 26 Mar 2021 00:56:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 574091809C84;
	Fri, 26 Mar 2021 00:56:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12Q0qteM019170 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 25 Mar 2021 20:52:55 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 68CED5D741; Fri, 26 Mar 2021 00:52:55 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F72361F49;
	Fri, 26 Mar 2021 00:52:51 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 12Q0qnhl010271; 
	Thu, 25 Mar 2021 19:52:50 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 12Q0qn91010270;
	Thu, 25 Mar 2021 19:52:49 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu, 25 Mar 2021 19:52:45 -0500
Message-Id: <1616719966-10221-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1616719966-10221-1-git-send-email-bmarzins@redhat.com>
References: <1616719966-10221-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 3/4] multipathd: improve getting parent udevice
	in rescan_path
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

Instead of looping through parents and checking, just call
udev_device_get_parent_with_subsystem_devtype() to get the
right one.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 1df69096..bc747d0e 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -822,16 +822,12 @@ ev_remove_map (char * devname, char * alias, int minor, struct vectors * vecs)
 }
 
 static void
-rescan_path(struct udev_device *parent)
+rescan_path(struct udev_device *ud)
 {
-	while(parent) {
-		const char *subsys = udev_device_get_subsystem(parent);
-		if (subsys && !strncmp(subsys, "scsi", 4))
-			break;
-		parent = udev_device_get_parent(parent);
-	}
-	if (parent)
-		sysfs_attr_set_value(parent, "rescan", "1", strlen("1"));
+	ud = udev_device_get_parent_with_subsystem_devtype(ud, "scsi",
+							   "scsi_device");
+	if (ud)
+		sysfs_attr_set_value(ud, "rescan", "1", strlen("1"));
 }
 
 void
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

