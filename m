Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC067ECAAA1
	for <dm-devel@archiver.kernel.org>; Fri,  2 Sep 2022 06:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662100795;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZjOEVRyDZITB1au1QqCQs2ZGEu0tx6thwualdS6J9vo=;
	b=FI8dSVDjhGCwz/DMlLcOcvSOl78K3aqfBuShe1AnaQahL8ZIAWP7JHfjAeRZ8c9pyAdj4J
	248pyxWfbDVGhBg2mdkK7fJChq/Rx7pxmng0R1IwmEk2ld0BDIV4356sggmxQfN3GPRgS+
	1aaWDbgxVfA5uQd/jlpVqc2kFAe2keA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-QK-KV2ZrN4WOXkYwfcxzGg-1; Fri, 02 Sep 2022 02:39:52 -0400
X-MC-Unique: QK-KV2ZrN4WOXkYwfcxzGg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A37233810797;
	Fri,  2 Sep 2022 06:39:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4525140C141D;
	Fri,  2 Sep 2022 06:39:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 237D819426AB;
	Fri,  2 Sep 2022 06:39:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D721D194B945
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Sep 2022 16:10:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A6D9E492C3B; Thu,  1 Sep 2022 16:10:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A2798403162
 for <dm-devel@redhat.com>; Thu,  1 Sep 2022 16:10:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8AB8885A58E
 for <dm-devel@redhat.com>; Thu,  1 Sep 2022 16:10:13 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-73-P43ATInjNgiUbtrNh6RNyw-1; Thu,
 01 Sep 2022 12:10:11 -0400
X-MC-Unique: P43ATInjNgiUbtrNh6RNyw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id EEEC422B3A;
 Thu,  1 Sep 2022 16:10:09 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C03C813A79;
 Thu,  1 Sep 2022 16:10:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id KKxnLWHZEGMPDQAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 01 Sep 2022 16:10:09 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu,  1 Sep 2022 18:09:51 +0200
Message-Id: <20220901160952.2167-16-mwilck@suse.com>
In-Reply-To: <20220901160952.2167-1-mwilck@suse.com>
References: <20220901160952.2167-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Fri, 02 Sep 2022 06:39:47 +0000
Subject: [dm-devel] [PATCH 15/16] multipathd: fix broken pthread cleanup in
 fpin_fabric_notification_receiver()
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

We were returning from a phtread-cancel block. That should be avoided.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/fpin_handlers.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/multipathd/fpin_handlers.c b/multipathd/fpin_handlers.c
index a7da2c9..03b2b9a 100644
--- a/multipathd/fpin_handlers.c
+++ b/multipathd/fpin_handlers.c
@@ -499,13 +499,14 @@ void *fpin_fabric_notification_receiver(__attribute__((unused))void *unused)
 	rcu_register_thread();
 
 	pthread_cleanup_push(receiver_cleanup_list, NULL);
+	pthread_cleanup_push(cleanup_fd_ptr, &fd);
+
 	fd = socket(PF_NETLINK, SOCK_DGRAM, NETLINK_SCSITRANSPORT);
 	if (fd < 0) {
 		condlog(0, "fc socket error %d", fd);
-		return NULL;
+		goto out;
 	}
 
-	pthread_cleanup_push(cleanup_fd_ptr, &fd);
 	memset(&fc_local, 0, sizeof(fc_local));
 	fc_local.nl_family = AF_NETLINK;
 	fc_local.nl_groups = ~0;
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

