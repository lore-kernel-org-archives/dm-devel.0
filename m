Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A756C6FA99
	for <dm-devel@archiver.kernel.org>; Tue,  7 Mar 2023 22:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678229385;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NBFkQhxLeTvOdtaaTRVLLiZrYw7UP+r27qFWg+cTb7w=;
	b=XHt5j/CqMdzv2hoL79byharyE+qH0/TGZ/KjKQBTCO5N7SAMsfbNV8Q3CeMy+BJTbRZHBM
	50BeB7gUdh0+lHsvdoivd6JNNvvEetOl7UJiCadZ2wX0C3xfVlKzPloFthhqI+sRzfpyjB
	jc57yEFP/LKDZsYfD9Tx6QT3LFU62Rw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-y1RSaNs1Oom0nCP-7EnSsQ-1; Tue, 07 Mar 2023 17:49:41 -0500
X-MC-Unique: y1RSaNs1Oom0nCP-7EnSsQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A94BC886464;
	Tue,  7 Mar 2023 22:49:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4E132C15BAD;
	Tue,  7 Mar 2023 22:49:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A786819465B2;
	Tue,  7 Mar 2023 22:49:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F278C19465B2
 for <dm-devel@listman.corp.redhat.com>; Tue,  7 Mar 2023 22:49:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D54DF492B00; Tue,  7 Mar 2023 22:49:37 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BF0DF492C3E;
 Tue,  7 Mar 2023 22:49:37 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 327Mnasn018830;
 Tue, 7 Mar 2023 16:49:36 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 327MnZV7018829;
 Tue, 7 Mar 2023 16:49:35 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue,  7 Mar 2023 16:49:32 -0600
Message-Id: <1678229374-18788-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1678229374-18788-1-git-send-email-bmarzins@redhat.com>
References: <1678229374-18788-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH 1/3] libmultipath: return 'pending' state when
 port is in transition
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
 Brian Bunker <brian@purestorage.com>, Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The tur checker should not return that a path is down when it is in the
transitioning state. Instead, it should return PATH_PENDING, so that
the path retains its current state, and multipathd can react quickly
when it moves out of the transitioning state.

The code needs to be careful to differentiate between when the checker
thread has finished and returned PATH_PENDING, and when it is still
running.

Reported-by: Brian Bunker <brian@purestorage.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers/tur.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 551dc4f0..a5045f10 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -32,6 +32,7 @@ enum {
 	MSG_TUR_RUNNING = CHECKER_FIRST_MSGID,
 	MSG_TUR_TIMEOUT,
 	MSG_TUR_FAILED,
+	MSG_TUR_TRANSITIONING,
 };
 
 #define _IDX(x) (MSG_ ## x - CHECKER_FIRST_MSGID)
@@ -39,6 +40,7 @@ const char *libcheck_msgtable[] = {
 	[_IDX(TUR_RUNNING)] = " still running",
 	[_IDX(TUR_TIMEOUT)] = " timed out",
 	[_IDX(TUR_FAILED)] = " failed to initialize",
+	[_IDX(TUR_TRANSITIONING)] = " reports path is transitioning",
 	NULL,
 };
 
@@ -186,6 +188,13 @@ retry:
 				 */
 				*msgid = CHECKER_MSGID_GHOST;
 				return PATH_GHOST;
+			} else if (asc == 0x04 && ascq == 0x0a) {
+				/*
+				 * LOGICAL UNIT NOT ACCESSIBLE,
+				 * ASYMMETRIC ACCESS STATE TRANSITION
+				 */
+				*msgid = MSG_TUR_TRANSITIONING;
+				return PATH_PENDING;
 			}
 		}
 		*msgid = CHECKER_MSGID_DOWN;
@@ -350,6 +359,7 @@ int libcheck_check(struct checker * c)
 			condlog(3, "%d:%d : tur checker not finished",
 				major(ct->devt), minor(ct->devt));
 			tur_status = PATH_PENDING;
+			c->msgid = MSG_TUR_RUNNING;
 		} else {
 			/* TUR checker done */
 			ct->thread = 0;
@@ -404,7 +414,7 @@ int libcheck_check(struct checker * c)
 		/* Start new TUR checker */
 		pthread_mutex_lock(&ct->lock);
 		tur_status = ct->state = PATH_PENDING;
-		ct->msgid = CHECKER_MSGID_NONE;
+		c->msgid = ct->msgid = MSG_TUR_RUNNING;
 		pthread_mutex_unlock(&ct->lock);
 		ct->fd = c->fd;
 		ct->timeout = c->timeout;
@@ -424,7 +434,7 @@ int libcheck_check(struct checker * c)
 		}
 		tur_timeout(&tsp);
 		pthread_mutex_lock(&ct->lock);
-		if (ct->state == PATH_PENDING)
+		if (ct->state == PATH_PENDING && ct->msgid == MSG_TUR_RUNNING)
 			r = pthread_cond_timedwait(&ct->active, &ct->lock,
 						   &tsp);
 		if (!r) {
@@ -432,7 +442,7 @@ int libcheck_check(struct checker * c)
 			c->msgid = ct->msgid;
 		}
 		pthread_mutex_unlock(&ct->lock);
-		if (tur_status == PATH_PENDING) {
+		if (tur_status == PATH_PENDING && c->msgid == MSG_TUR_RUNNING) {
 			condlog(4, "%d:%d : tur checker still running",
 				major(ct->devt), minor(ct->devt));
 		} else {
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

