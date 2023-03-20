Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03163C7618D
	for <dm-devel@archiver.kernel.org>; Mon, 20 Mar 2023 15:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679327772;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xBp2k63qae/3B2BDGF8YjzhOtsQ3Eag/afju+SrPyiQ=;
	b=eiii9qKdEPv5Ko0RbaAcUy9zRN+p6WTkwpme/ErgdrQSrLIqW+BsQjLCl8yAeEQZRa9mV9
	ABvjmVJ+MXFWYWLAE4u2TMaIAMbrQgx+gsS6EVAJfj4O26K6YaTe4V3142g9J2qpTr5mqp
	+7nieOwFUazxOn5ZOQfxswkwLaKmG5s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-322-a_T7D7UJPHSU9hMgQ45ulQ-1; Mon, 20 Mar 2023 11:56:08 -0400
X-MC-Unique: a_T7D7UJPHSU9hMgQ45ulQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 941108030D6;
	Mon, 20 Mar 2023 15:56:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 44BCDC15BA0;
	Mon, 20 Mar 2023 15:56:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 08A4219465A2;
	Mon, 20 Mar 2023 15:56:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2C3F51946594
 for <dm-devel@listman.corp.redhat.com>; Mon, 20 Mar 2023 15:55:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0EF6D2166B2A; Mon, 20 Mar 2023 15:55:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0823B2166B29
 for <dm-devel@redhat.com>; Mon, 20 Mar 2023 15:55:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC77888904B
 for <dm-devel@redhat.com>; Mon, 20 Mar 2023 15:55:57 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-241-ZUvC0I_5Mcanqpk1cYe6Vg-1; Mon,
 20 Mar 2023 11:55:53 -0400
X-MC-Unique: ZUvC0I_5Mcanqpk1cYe6Vg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 4E2281F8A4;
 Mon, 20 Mar 2023 15:55:52 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0E69313416;
 Mon, 20 Mar 2023 15:55:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id sWHOAAiCGGTVVwAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 20 Mar 2023 15:55:52 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Mon, 20 Mar 2023 16:55:50 +0100
Message-Id: <20230320155550.7326-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH] multipath-tools Makefiles: handle dependency
 files correctly
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Some generated .d files were not correctly included, and not
removed with "make dep_clean". Fix it.

Reported-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/Makefile | 4 ++--
 multipathd/Makefile   | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 61aa611..85767ab 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -71,7 +71,7 @@ uninstall:
 clean: dep_clean
 	$(Q)$(RM) core *.a *.o *.so *.so.* *.abi nvme-ioctl.c nvme-ioctl.h autoconfig.h $(NV_VERSION_SCRIPT)
 
-include $(wildcard $(OBJS:.o=.d))
+include $(wildcard $(OBJS:.o=.d) $(OBJS-T:.o=.d))
 
 dep_clean:
-	$(Q)$(RM) $(OBJS:.o=.d)
+	$(Q)$(RM) $(OBJS:.o=.d) $(OBJS-T:.o=.d)
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 9d53132..dca8e10 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -81,7 +81,7 @@ uninstall:
 clean: dep_clean
 	$(Q)$(RM) core *.o $(EXEC) $(CLI)
 
-include $(wildcard $(OBJS:.o=.d))
+include $(wildcard $(OBJS:.o=.d) $(CLI_OBJS:.o=.d))
 
 dep_clean:
-	$(Q)$(RM) $(OBJS:.o=.d)
+	$(Q)$(RM) $(OBJS:.o=.d) $(CLI_OBJS:.o=.d)
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

