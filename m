Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E63D3C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 30 Mar 2022 03:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1648610535;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hLVaobbNkbhbOnsMqmG1ZlX5xxu9w6gw+g6TJ9Mbosc=;
	b=bxQ23hZaO8FIzgRKtH4Z0zzzbUT/4r6dvM/EiWmIOlRhnfiKl+FlQaTdaKifymJAzXHdKr
	4It2Sk6sTuZ2pKLia/4NEWAdXmGuddwuESHC/EYtStbFo3y5iw6qSCY3W62hw/8h4ctnmo
	r22HWl9S+7W1iIGheTXGAdrGv5IpuOE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-sANAkMK7OO6gEfkMna60bw-1; Tue, 29 Mar 2022 23:22:12 -0400
X-MC-Unique: sANAkMK7OO6gEfkMna60bw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 668A4101AA45;
	Wed, 30 Mar 2022 03:21:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3C5A32026D6B;
	Wed, 30 Mar 2022 03:21:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7015319451EF;
	Wed, 30 Mar 2022 03:21:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AAD8019451ED
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Mar 2022 03:21:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 959C756D18B; Wed, 30 Mar 2022 03:21:40 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 81C6354B975;
 Wed, 30 Mar 2022 03:21:40 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 22U3LdEc028478;
 Tue, 29 Mar 2022 22:21:39 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 22U3Lcev028477;
 Tue, 29 Mar 2022 22:21:38 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 29 Mar 2022 22:21:38 -0500
Message-Id: <1648610498-28440-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH] multipath: return failure on an invalid remove
 command
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
Cc: device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When "multipath -f" is run on a device that doesn't exist or isn't a
multipath device, the command will not remove any device, but it will
still return success.  Multiple functions rely on _dm_flush_map()
returning success when called with name that doesn't match any
multipath device. So before calling _dm_flush_map(), call dm_is_mpath(),
to check if the device exists and is a multipath device, and return
failure if it's not.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/multipath/main.c b/multipath/main.c
index d09f62db..e865309d 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -1060,6 +1060,11 @@ main (int argc, char *argv[])
 	if (retries < 0)
 		retries = conf->remove_retries;
 	if (cmd == CMD_FLUSH_ONE) {
+		if (dm_is_mpath(dev) != 1) {
+			condlog(0, "failed removing \"%s\"", dev);
+			r = RTVL_FAIL;
+			goto out;
+		}
 		r = dm_suspend_and_flush_map(dev, retries) ?
 		    RTVL_FAIL : RTVL_OK;
 		goto out;
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

