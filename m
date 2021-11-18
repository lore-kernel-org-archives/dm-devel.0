Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F678C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:05:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 183C861A79
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:05:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 183C861A79
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-449-4fd6fv60Mo-nBGoxkl_NYQ-1; Thu, 18 Nov 2021 18:05:54 -0500
X-MC-Unique: 4fd6fv60Mo-nBGoxkl_NYQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7C5F1927802;
	Thu, 18 Nov 2021 23:05:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AF156179B3;
	Thu, 18 Nov 2021 23:05:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8ADC31832DD2;
	Thu, 18 Nov 2021 23:05:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIMx8bA002131 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 17:59:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6E23B404727A; Thu, 18 Nov 2021 22:59:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A41B4047279
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 524758011A5
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:08 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-597-LWce6BFTOt2hV4aaFIcfsQ-1; Thu, 18 Nov 2021 17:59:03 -0500
X-MC-Unique: LWce6BFTOt2hV4aaFIcfsQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C0E17212CC;
	Thu, 18 Nov 2021 22:59:01 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 78F3813B11;
	Thu, 18 Nov 2021 22:59:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id ALyMG7XalmGHPAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 22:59:01 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 18 Nov 2021 23:58:06 +0100
Message-Id: <20211118225840.19810-15-mwilck@suse.com>
In-Reply-To: <20211118225840.19810-1-mwilck@suse.com>
References: <20211118225840.19810-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AIMx8bA002131
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 14/48] multipathd: uxlsnr: avoid stalled
	clients during reconfigure
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Since 47cc1d3 ("multipathd: fix client response for socket
activation"), we hold back clients while reconfigure is running.
The idea of 47cc1d3 was to fix the behavior during initial
start up. When multipathd reconfigures itself during runtime,
and the reconfiguration takes a long time (a minute or more is
not unusual in big configurations), clients will time out with
no response ("timeout receiving packet"). Waiting for reconfigure
to finish breaks our timeout handling.

Therefore we should only apply the logic of 47cc1d3 during initial
configuration. In this case, the client that triggered socket
activation may still encounter a timeout, but there's not much we can
do about that.

Fixes: 47cc1d3 ("multipathd: fix client response for socket activation")
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c   |  9 +++++++++
 multipathd/uxlsnr.c | 12 ------------
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 268b940..0820a05 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1706,6 +1706,15 @@ uxlsnrloop (void * ap)
 
 	init_handler_callbacks();
 	umask(077);
+
+	/*
+	 * Wait for initial reconfiguration to finish, while
+	 * hadling signals
+	 */
+	while (wait_for_state_change_if(DAEMON_CONFIGURE, 50)
+	       == DAEMON_CONFIGURE)
+		handle_signals(false);
+
 	uxsock_listen(&uxsock_trigger, ux_sock, ap);
 
 out_sock:
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index dbee0d6..20efbd3 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -391,18 +391,6 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
 			continue;
 		}
 
-		/*
-		 * Client connection. We shouldn't answer while we're
-		 * configuring - nothing may be configured yet.
-		 * But we can't wait forever either, because this thread
-		 * must handle signals. So wait a short while only.
-		 */
-		if (wait_for_state_change_if(DAEMON_CONFIGURE, 10)
-		    == DAEMON_CONFIGURE) {
-			handle_signals(false);
-			continue;
-		}
-
 		/* see if a client wants to speak to us */
 		for (i = POLLFDS_BASE; i < n_pfds; i++) {
 			if (polls[i].revents & POLLIN) {
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

