Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C423EECAAD4
	for <dm-devel@archiver.kernel.org>; Wed, 31 Aug 2022 16:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661961804;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BYDdrr3+obJvYSC/vRNdFthgoCc4cMqkxzw1DvA1OfY=;
	b=fMpSh1LozwohhByw1PiliZ3j9Vj5pno80c7P5oU72uS/m6IKDuRNU6/iELjXt+pYUuvrbw
	xz32t8ME+xZET9iKcWi4/K8Oc53RnK0YsMylk1npM2wltJJnDcQ90Ep67F+srkxubw5bOL
	A0vjRmkKjsf4xWy8MZ8qzJyOLkHIRnU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-163-YbiyW1blOEi4RiDyAQsRcg-1; Wed, 31 Aug 2022 12:03:22 -0400
X-MC-Unique: YbiyW1blOEi4RiDyAQsRcg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 665EF294EDDC;
	Wed, 31 Aug 2022 16:03:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C998E1121314;
	Wed, 31 Aug 2022 16:03:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9DFF61946A45;
	Wed, 31 Aug 2022 16:03:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0636D1946A40
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 Aug 2022 18:45:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CB1862026D64; Tue, 30 Aug 2022 18:45:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C5DAA2026D4C
 for <dm-devel@redhat.com>; Tue, 30 Aug 2022 18:45:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4EC03C0E209
 for <dm-devel@redhat.com>; Tue, 30 Aug 2022 18:45:49 +0000 (UTC)
Received: from mail-vk1-f201.google.com (mail-vk1-f201.google.com
 [209.85.221.201]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-369-tZGTJxHCMF2p856jsL65Pw-1; Tue, 30 Aug 2022 14:45:42 -0400
X-MC-Unique: tZGTJxHCMF2p856jsL65Pw-1
Received: by mail-vk1-f201.google.com with SMTP id
 e1-20020a1f1e01000000b00378fe7fdde9so1903747vke.21
 for <dm-devel@redhat.com>; Tue, 30 Aug 2022 11:45:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
 :from:to:cc;
 bh=mR57utkbxRdTvq6YmQ+p8bb3XETj/4dqf7bp5NDk6kA=;
 b=6GsTI7t3ZL60jwyS5J0Sp7LABNbCjq1P4fBuO867kbGsrptn47hPsGVw+ktuE4w4ZM
 9lwjpKNqpxQ8DUiWJnoXhL0pbrBG3PRETfSzD+vUcLQg4c/4kCYX6P1GxHXPLCVq9f2U
 4bFB71msw9aooEGC3/XyJ01lVpDZXPtkvqM3Va8OZG/gwsX+LhP+RxN7yWPWFcJtWQ3L
 wjyByuXRsDYwTlywe82oRpz+KZmdcuU/5G75kCdyaS4JNwHW/u8u+8pZccmncf54uZQS
 Ko1f0FQhZldX3uA0gtJSrJ8xZSvJzwJEqCU3vB9wILjiaLmbqnQlUr5bdCAsLFBOumUa
 6Gig==
X-Gm-Message-State: ACgBeo0iDkwQ7TrJ3p87CMeOH+xeceWII3TfL/H4sRMEov0UBFsjjlXA
 qSuu9rKYPtw+ISjFqVQt2FmVC7IrbEzrixgjKvrSUnW2Cjq4K2C/gvw6vSOUG0WimieyZ8P7DLk
 vaFZxWPcNF+CbgUih5fhOXO2Eub70Ufh+G4b+OC7QjBODcd8UN06fzN8=
X-Google-Smtp-Source: AA6agR7cMqy8vMjnqCZSK+xuUkjcRUYdMDzBqh2y9WejC54EHo2tQvjjRPIMzBA4qSgPjGzYq1UHrJu6eA==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a05:6122:d86:b0:374:684c:7343
 with SMTP id
 bc6-20020a0561220d8600b00374684c7343mr5973822vkb.0.1661885141714; Tue, 30 Aug
 2022 11:45:41 -0700 (PDT)
Date: Tue, 30 Aug 2022 18:44:44 +0000
Mime-Version: 1.0
Message-ID: <20220830184444.2903582-1-nhuck@google.com>
From: Nathan Huckleberry <nhuck@google.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mailman-Approved-At: Wed, 31 Aug 2022 15:48:15 +0000
Subject: [dm-devel] [PATCH] dm-verity: Enable WQ_HIGHPRI
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
Cc: Eric Biggers <ebiggers@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 Nathan Huckleberry <nhuck@google.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

WQ_HIGHPRI increases throughput and decreases disk latency when using
dm-verity.  This is important in Android for camera startup speed.

The following tests were run by doing 60 seconds of random reads using a
dm-verity device backed by two ramdisks.

With WQ_HIGHPRI:
lat (usec): min=13, max=7854, avg=31.15, stdev=30.42
READ: bw=116MiB/s (121MB/s), 116MiB/s-116MiB/s (121MB/s-121MB/s)

Without WQ_HIGHPRI
lat (usec): min=13, max=3947, avg=69.53, stdev=50.55
READ: bw=51.1MiB/s (53.6MB/s), 51.1MiB/s-51.1MiB/s (53.6MB/s-53.6MB/s)

Further testing was done by measuring how long it takes to open a camera
on an Android device.

With WQ_HIGHPRI:
Total verity work queue wait times (ms):
528.824, 439.191, 433.300

Without WQ_HIGHPRI
Total verity work queue wait times (ms):
880.960, 789.517, 898.852

The time it takes to open the camera is reduced by 350ms on average.

Signed-off-by: Nathan Huckleberry <nhuck@google.com>
---
 drivers/md/dm-verity-target.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 981821f18a18..341fc58053ce 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1390,14 +1390,11 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 	/* WQ_UNBOUND greatly improves performance when running on ramdisk */
 	wq_flags = WQ_MEM_RECLAIM | WQ_UNBOUND;
-	if (v->use_tasklet) {
-		/*
-		 * Allow verify_wq to preempt softirq since verification in
-		 * tasklet will fall-back to using it for error handling
-		 * (or if the bufio cache doesn't have required hashes).
-		 */
-		wq_flags |= WQ_HIGHPRI;
-	}
+	/*
+	 * WQ_HIGHPRI reduces waiting times when reading from a dm-verity
+	 * device.  This improves throughput and completion latency.
+	 */
+	wq_flags |= WQ_HIGHPRI;
 	v->verify_wq = alloc_workqueue("kverityd", wq_flags, num_online_cpus());
 	if (!v->verify_wq) {
 		ti->error = "Cannot allocate workqueue";
-- 
2.37.2.672.g94769d06f0-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

