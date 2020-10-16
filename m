Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE417C433DF
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:44:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 22C59207F7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:44:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 22C59207F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-y75pkC5XMPG_VlcVc0MGnA-1; Fri, 16 Oct 2020 06:43:59 -0400
X-MC-Unique: y75pkC5XMPG_VlcVc0MGnA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA445835BB9;
	Fri, 16 Oct 2020 10:43:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E9286198B;
	Fri, 16 Oct 2020 10:43:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 66F62181A720;
	Fri, 16 Oct 2020 10:43:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GAhpxX020127 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 06:43:51 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A51C12156A3B; Fri, 16 Oct 2020 10:43:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F0532166B28
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 59693805AB6
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:49 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-239-I4hZx4d2OU63aifo0MtX3A-1;
	Fri, 16 Oct 2020 06:43:46 -0400
X-MC-Unique: I4hZx4d2OU63aifo0MtX3A-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 26F7BAF2C;
	Fri, 16 Oct 2020 10:43:45 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 16 Oct 2020 12:43:10 +0200
Message-Id: <20201016104329.8337-3-mwilck@suse.com>
In-Reply-To: <20201016104329.8337-1-mwilck@suse.com>
References: <20201016104329.8337-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09GAhpxX020127
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 02/21] multipathd: avoid sending "READY=1" to
	systemd on early shutdown
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

If multipathd gets a shutdown request during initial reconfigure(),
it shouldn't send "READY=1" to systemd. Ensure this by sending
"READY=1" via post_config_state().

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index fa53e96..53a22a4 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -189,6 +189,8 @@ static void do_sd_notify(enum daemon_status old_state,
 {
 	char notify_msg[MSG_SIZE];
 	const char *msg;
+	static bool startup_done = false;
+
 	/*
 	 * Checkerloop switches back and forth between idle and running state.
 	 * No need to tell systemd each time.
@@ -205,6 +207,11 @@ static void do_sd_notify(enum daemon_status old_state,
 
 	if (msg && !safe_sprintf(notify_msg, "STATUS=%s", msg))
 		sd_notify(0, notify_msg);
+
+	if (new_state == DAEMON_IDLE && !startup_done) {
+		sd_notify(0, "READY=1");
+		startup_done = true;
+	}
 }
 #endif
 
@@ -2903,9 +2910,6 @@ child (__attribute__((unused)) void *param)
 	struct vectors * vecs;
 	struct multipath * mpp;
 	int i;
-#ifdef USE_SYSTEMD
-	int startup_done = 0;
-#endif
 	int rc;
 	int pid_fd = -1;
 	struct config *conf;
@@ -3065,12 +3069,6 @@ child (__attribute__((unused)) void *param)
 			}
 			lock_cleanup_pop(vecs->lock);
 			post_config_state(DAEMON_IDLE);
-#ifdef USE_SYSTEMD
-			if (!startup_done) {
-				sd_notify(0, "READY=1");
-				startup_done = 1;
-			}
-#endif
 		}
 	}
 
-- 
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

