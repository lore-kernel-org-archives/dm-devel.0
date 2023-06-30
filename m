Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C66C4EB64D7
	for <dm-devel@archiver.kernel.org>; Fri, 30 Jun 2023 16:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688143262;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hEn99J55bm1nGn4OUzTqcgSEFF8dcy9puqhRU2rvOEg=;
	b=gMGkzeeFfl7Py4U8Drgqhz6s1TXFsfX3jDjBil24o4Z7E7GLVPXyqgxAgdr9bYAHogn/Ue
	hdNZBFxhNfnvHBzpnb3+EJZcvC1x4Mb4L6pA5oINS8h1aq0kQbGtc5B4HL/welqU6+UXUq
	kz508OYSHMw7MNogEmb5v+pZkx0beQU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-378-NSJtPjELPo-CV8QbYvFsfg-1; Fri, 30 Jun 2023 12:41:01 -0400
X-MC-Unique: NSJtPjELPo-CV8QbYvFsfg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63B9F81D9EC;
	Fri, 30 Jun 2023 16:40:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EEB30F5CEF;
	Fri, 30 Jun 2023 16:40:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AEA1B1946A41;
	Fri, 30 Jun 2023 16:40:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9931519465B3
 for <dm-devel@listman.corp.redhat.com>; Fri, 30 Jun 2023 15:55:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 847FE48FB01; Fri, 30 Jun 2023 15:55:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C6B1492B02
 for <dm-devel@redhat.com>; Fri, 30 Jun 2023 15:55:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5AFF129A9D38
 for <dm-devel@redhat.com>; Fri, 30 Jun 2023 15:55:16 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-653-6PbGGL07OL6m4rmZlckr-A-1; Fri,
 30 Jun 2023 11:55:14 -0400
X-MC-Unique: 6PbGGL07OL6m4rmZlckr-A-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 1DA7321853;
 Fri, 30 Jun 2023 15:55:13 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E4978138F8;
 Fri, 30 Jun 2023 15:55:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id OIISNuD6nmQ+KgAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 30 Jun 2023 15:55:12 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 30 Jun 2023 17:55:10 +0200
Message-ID: <20230630155510.22843-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH] libmultipath: fix dev_loss_tmo even if not set
 in configuration
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

If pp->dev_loss_tmo == DEV_LOSS_TMO_UNSET, sysfs_set_scsi_tmo() would
not set it to min_dev_loss_tmo, causing the system dev_loss_tmo value
(by default, 30s) to remain unchanged. Fix it.

Fixes: 6ad77db ("libmultipath: Set the scsi timeout parameters by path")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 2dcafe5..285cbd6 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -895,9 +895,8 @@ sysfs_set_scsi_tmo (struct config *conf, struct multipath *mpp)
 			continue;
 		}
 
-		if (pp->dev_loss != DEV_LOSS_TMO_UNSET &&
-		    pp->dev_loss < min_dev_loss) {
-			warn_dev_loss = true;
+		if (pp->dev_loss < min_dev_loss) {
+			warn_dev_loss = (pp->dev_loss != DEV_LOSS_TMO_UNSET);
 			pp->dev_loss = min_dev_loss;
 		}
 		if (pp->dev_loss != DEV_LOSS_TMO_UNSET &&
-- 
2.41.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

