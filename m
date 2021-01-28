Return-Path: <SRS0=XDEt=G7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D5A7C433DB
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 21:09:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AFF8964D9E
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 21:09:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AFF8964D9E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-izT6-HubPheCyOOMEpL1mQ-1; Thu, 28 Jan 2021 16:09:21 -0500
X-MC-Unique: izT6-HubPheCyOOMEpL1mQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69EC5802B67;
	Thu, 28 Jan 2021 21:09:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D048C60875;
	Thu, 28 Jan 2021 21:09:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4878B5002C;
	Thu, 28 Jan 2021 21:09:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10SL9D0C017477 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 16:09:13 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AC8762026D11; Thu, 28 Jan 2021 21:09:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A7E482026D76
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 21:09:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60FA2800B3B
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 21:09:11 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-56-rzwNowB5OIGkarQQ6Ie-OA-1;
	Thu, 28 Jan 2021 16:09:06 -0500
X-MC-Unique: rzwNowB5OIGkarQQ6Ie-OA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id E2276AAC6;
	Thu, 28 Jan 2021 21:09:04 +0000 (UTC)
From: mwilck@suse.com
To: lixiaokeng@huawei.com, Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu, 28 Jan 2021 22:08:52 +0100
Message-Id: <20210128210852.23207-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10SL9D0C017477
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH] multipathd: avoid crash in uevent_cleanup()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Crashes have been observed in the unwinder stack of uevent_listen().
This can only be explained by "udev" not being a valid object at that
time. Be sure to pass a valid pointer, and don't call udev_unref() if
it has been set to NULL already.

I'm not quite sure how this would come to pass, as we join the threads
before setting udev to NULL, but this is unwinder code, so I guess it
might actually be executed after the thread has terminated.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/uevent.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index d3061bf..4e662ff 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -397,10 +397,11 @@ service_uevq(struct list_head *tmpq)
 
 static void uevent_cleanup(void *arg)
 {
-	struct udev *udev = arg;
+	struct udev **pudev = arg;
 
+	if (*pudev)
+		udev_unref(*pudev);
 	condlog(3, "Releasing uevent_listen() resources");
-	udev_unref(udev);
 }
 
 static void monitor_cleanup(void *arg)
@@ -560,7 +561,7 @@ int uevent_listen(struct udev *udev)
 		return 1;
 	}
 	udev_ref(udev);
-	pthread_cleanup_push(uevent_cleanup, udev);
+	pthread_cleanup_push(uevent_cleanup, &udev);
 
 	monitor = udev_monitor_new_from_netlink(udev, "udev");
 	if (!monitor) {
-- 
2.29.2


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

