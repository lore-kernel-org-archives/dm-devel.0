Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDE29C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 30 Mar 2022 03:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1648610539;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IbGuOzBN2SFn/0yMiK9hYtVsbxDFX/DKqBVavUgeuOY=;
	b=cC0wdxDkIOLOgbPV1U6/65LkI8CgP7vx++RK6V0T/4CF9n/41DrV3NEX1bfkPFbQvQf4a6
	zy9Y71mOi3VBltOtd3uyO29kz8FBzhFdEEsRdJ/p8AIrzx8B2VfTqAX/OcWCqh3hgFv36q
	Clu7JQoRfvBq9Zt3ewi53shco/HSTc0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-45-vVBlYoWtNzGEOHADEY5qWQ-1; Tue, 29 Mar 2022 23:22:16 -0400
X-MC-Unique: vVBlYoWtNzGEOHADEY5qWQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D63421C068E2;
	Wed, 30 Mar 2022 03:22:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8C5D0C202C8;
	Wed, 30 Mar 2022 03:22:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7228019451EF;
	Wed, 30 Mar 2022 03:22:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F11EB19451ED
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Mar 2022 03:22:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CFFF840D0161; Wed, 30 Mar 2022 03:22:12 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BEDE040D0160;
 Wed, 30 Mar 2022 03:22:12 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 22U3MBro028564;
 Tue, 29 Mar 2022 22:22:11 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 22U3MBx6028563;
 Tue, 29 Mar 2022 22:22:11 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 29 Mar 2022 22:22:10 -0500
Message-Id: <1648610530-28526-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [RFC PATCH] multipathd: Don't keep starting TUR threads,
 if they always hang.
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If tur thead hangs, multipathd was simply creating a new thread, and
assuming that the old thread would get cleaned up eventually. I have
seen a case recently where there were 26000 multipathd threads on a
system, all stuck trying to send TUR commands to path devices. The root
cause of the issue was a scsi kernel issue, but it shows that the way
multipathd currently deals with stuck threads could use some refinement.

Now, when one tur thread hangs, multipathd will act as it did before.
If a second one in a row hangs, multipathd will instead wait for it to
complete before starting another thread. Once the thread completes, the
count is reset.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers/tur.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index c93e4625..1bcb7576 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -26,6 +26,7 @@
 
 #define TUR_CMD_LEN 6
 #define HEAVY_CHECK_COUNT       10
+#define MAX_NR_TIMEOUTS 1
 
 enum {
 	MSG_TUR_RUNNING = CHECKER_FIRST_MSGID,
@@ -54,6 +55,7 @@ struct tur_checker_context {
 	int holders; /* uatomic access only */
 	int msgid;
 	struct checker_context ctx;
+	unsigned int nr_timeouts;
 };
 
 int libcheck_init (struct checker * c)
@@ -358,8 +360,23 @@ int libcheck_check(struct checker * c)
 		}
 	} else {
 		if (uatomic_read(&ct->holders) > 1) {
+			/* The thread has been cancelled but hasn't quit. */
+			if (ct->nr_timeouts == MAX_NR_TIMEOUTS) {
+				condlog(2, "%d:%d : waiting for stalled tur thread to finish",
+					major(ct->devt), minor(ct->devt));
+				ct->nr_timeouts++;
+			}
 			/*
-			 * The thread has been cancelled but hasn't quit.
+			 * Don't start new threads until the last once has
+			 * finished.
+			 */
+			if (ct->nr_timeouts > MAX_NR_TIMEOUTS) {
+				c->msgid = MSG_TUR_TIMEOUT;
+				return PATH_TIMEOUT;
+			}
+			ct->nr_timeouts++;
+			/*
+			 * Start a new thread while the old one is stalled.
 			 * We have to prevent it from interfering with the new
 			 * thread. We create a new context and leave the old
 			 * one with the stale thread, hoping it will clean up
@@ -375,13 +392,15 @@ int libcheck_check(struct checker * c)
 			 */
 			if (libcheck_init(c) != 0)
 				return PATH_UNCHECKED;
+			((struct tur_checker_context *)c->context)->nr_timeouts = ct->nr_timeouts;
 
 			if (!uatomic_sub_return(&ct->holders, 1))
 				/* It did terminate, eventually */
 				cleanup_context(ct);
 
 			ct = c->context;
-		}
+		} else
+			ct->nr_timeouts = 0;
 		/* Start new TUR checker */
 		pthread_mutex_lock(&ct->lock);
 		tur_status = ct->state = PATH_PENDING;
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

