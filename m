Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65E02ECAAD3
	for <dm-devel@archiver.kernel.org>; Thu,  1 Sep 2022 16:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662048636;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=uz51utgLJnr75yY4jlj53XXo/dWSJ1vENNr+YmLnxTQ=;
	b=ddcxHAIbBm8TTnp43H1itQsiqmzTk3ODa6OdJmPc8rMxnzbAS0cevfnA/CzJ/5co1bR4Fs
	BvlHlsVV+l3MFTN2+0TLuJuM30XPDTLMNGawcY9OE09Si4zDwJTxS8Klpo6i27V0ttG9P1
	Y4D7WRpiV4miEBshfrfKzLTt0P1p994=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-i_t6MTL2MNi6b23Mj9A1mA-1; Thu, 01 Sep 2022 12:10:33 -0400
X-MC-Unique: i_t6MTL2MNi6b23Mj9A1mA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE4883C1068F;
	Thu,  1 Sep 2022 16:10:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DCADAC15BB3;
	Thu,  1 Sep 2022 16:10:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C4AE21943214;
	Thu,  1 Sep 2022 16:10:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1B7E31940357
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Sep 2022 16:10:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0CEA9492CA4; Thu,  1 Sep 2022 16:10:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 091CE492C3B
 for <dm-devel@redhat.com>; Thu,  1 Sep 2022 16:10:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E60CB101E9BE
 for <dm-devel@redhat.com>; Thu,  1 Sep 2022 16:10:14 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-513-ReQNths8NOKWuD5WeRn9xQ-1; Thu,
 01 Sep 2022 12:10:13 -0400
X-MC-Unique: ReQNths8NOKWuD5WeRn9xQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 360022021A;
 Thu,  1 Sep 2022 16:10:10 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 075D713A79;
 Thu,  1 Sep 2022 16:10:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id kGFUAGLZEGMPDQAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 01 Sep 2022 16:10:10 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu,  1 Sep 2022 18:09:52 +0200
Message-Id: <20220901160952.2167-17-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH 16/16] multipathd: Fix command completion in
 interactive mode
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

The command completion never worked, because the handlers
array wasn't initialized in client mode.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/cli.c  | 2 ++
 multipathd/main.c | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/multipathd/cli.c b/multipathd/cli.c
index d1bfeee..5d25ddb 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -14,6 +14,7 @@
 
 #include "mpath_cmd.h"
 #include "cli.h"
+#include "cli_handlers.h"
 #include "debug.h"
 #include "strbuf.h"
 
@@ -451,6 +452,7 @@ cli_init (void) {
 	if (alloc_handlers())
 		return 1;
 
+	init_handler_callbacks();
 	return 0;
 }
 
diff --git a/multipathd/main.c b/multipathd/main.c
index 4a65359..ba52d39 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1797,7 +1797,6 @@ uxlsnrloop (void * ap)
 	/* Tell main thread that thread has started */
 	post_config_state(DAEMON_CONFIGURE);
 
-	init_handler_callbacks();
 	umask(077);
 
 	/*
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

