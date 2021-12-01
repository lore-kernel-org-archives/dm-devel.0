Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFE00C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 12:37:43 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-158-B3grte6_MbC6oFIf4KF2DA-1; Wed, 01 Dec 2021 07:37:41 -0500
X-MC-Unique: B3grte6_MbC6oFIf4KF2DA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E10910144E0;
	Wed,  1 Dec 2021 12:37:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 03929100EBAD;
	Wed,  1 Dec 2021 12:37:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D34154A706;
	Wed,  1 Dec 2021 12:37:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B1CbBFX008703 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 07:37:11 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 797D4404727A; Wed,  1 Dec 2021 12:37:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 74F8D4047272
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 12:37:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E9191066680
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 12:37:11 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-105-zzOYy8AhOSWqRyHLzVkGyQ-1; Wed, 01 Dec 2021 07:37:09 -0500
X-MC-Unique: zzOYy8AhOSWqRyHLzVkGyQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 61499212BA;
	Wed,  1 Dec 2021 12:37:08 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2CB5D13FF5;
	Wed,  1 Dec 2021 12:37:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id iJkHCXRsp2GGKAAAMHmgww
	(envelope-from <mwilck@suse.com>); Wed, 01 Dec 2021 12:37:08 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  1 Dec 2021 13:36:42 +0100
Message-Id: <20211201123650.16240-14-mwilck@suse.com>
In-Reply-To: <20211201123650.16240-1-mwilck@suse.com>
References: <20211201123650.16240-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B1CbBFX008703
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 13/21] multipathd (coverity): simplify
	set_oom_adj()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Coverity discourages stat-before-open. So simplify this function.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 53 ++++++++++++++---------------------------------
 1 file changed, 15 insertions(+), 38 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 1be42c5..36cc76f 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2952,51 +2952,28 @@ setscheduler (void)
 	return;
 }
 
-static void
-set_oom_adj (void)
+static void set_oom_adj(void)
 {
-#ifdef OOM_SCORE_ADJ_MIN
-	int retry = 1;
-	char *file = "/proc/self/oom_score_adj";
-	int score = OOM_SCORE_ADJ_MIN;
-#else
-	int retry = 0;
-	char *file = "/proc/self/oom_adj";
-	int score = OOM_ADJUST_MIN;
-#endif
 	FILE *fp;
-	struct stat st;
-	char *envp;
 
-	envp = getenv("OOMScoreAdjust");
-	if (envp) {
+	if (getenv("OOMScoreAdjust")) {
 		condlog(3, "Using systemd provided OOMScoreAdjust");
 		return;
 	}
-	do {
-		if (stat(file, &st) == 0){
-			fp = fopen(file, "w");
-			if (!fp) {
-				condlog(0, "couldn't fopen %s : %s", file,
-					strerror(errno));
-				return;
-			}
-			fprintf(fp, "%i", score);
-			fclose(fp);
-			return;
-		}
-		if (errno != ENOENT) {
-			condlog(0, "couldn't stat %s : %s", file,
-				strerror(errno));
-			return;
-		}
-#ifdef OOM_ADJUST_MIN
-		file = "/proc/self/oom_adj";
-		score = OOM_ADJUST_MIN;
-#else
-		retry = 0;
+#ifdef OOM_SCORE_ADJ_MIN
+	fp = fopen("/proc/self/oom_score_adj", "w");
+	if (fp) {
+		fprintf(fp, "%i", OOM_SCORE_ADJ_MIN);
+		fclose(fp);
+		return;
+	}
 #endif
-	} while (retry--);
+	fp = fopen("/proc/self/oom_adj", "w");
+	if (fp) {
+		fprintf(fp, "%i", OOM_ADJUST_MIN);
+		fclose(fp);
+		return;
+	}
 	condlog(0, "couldn't adjust oom score");
 }
 
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

