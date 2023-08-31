Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52B52C88CB2
	for <dm-devel@archiver.kernel.org>; Thu, 31 Aug 2023 21:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693519053;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6I+H0vL28LqUPiq9wR57WNAEjnZyF50gQowqGH86V5Q=;
	b=gvOoNTQsRo4QuGdEiijUNmOEBD/p8d08lkW8/IBaY+MdrYsGOJ1beP6diwTQFNZVmPvGAY
	w4ozWp1IpMhjwHR0uUtxiN/hadpTU6Z3MWpgCsyHEQ5o0jswmEWhdB4i5rNp5RtgOQakUu
	rhavmIDE+ksJ3SniUp8xYWCCMQ07NUU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-32-6noLNDPmOSKoqKz1Vu8tTw-1; Thu, 31 Aug 2023 17:57:29 -0400
X-MC-Unique: 6noLNDPmOSKoqKz1Vu8tTw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A72EA1C05EDA;
	Thu, 31 Aug 2023 21:57:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 93605C15BAE;
	Thu, 31 Aug 2023 21:57:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 73EA1194658D;
	Thu, 31 Aug 2023 21:57:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E5A7119465B5
 for <dm-devel@listman.corp.redhat.com>; Thu, 31 Aug 2023 21:57:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D78A32166B27; Thu, 31 Aug 2023 21:57:26 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C15762166B26;
 Thu, 31 Aug 2023 21:57:26 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 37VLvIN2030167;
 Thu, 31 Aug 2023 16:57:19 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 37VLvI1W030166;
 Thu, 31 Aug 2023 16:57:18 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu, 31 Aug 2023 16:57:12 -0500
Message-Id: <1693519032-30111-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1693519032-30111-1-git-send-email-bmarzins@redhat.com>
References: <1693519032-30111-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH v2 4/4] libmultipath: standardize datacore
 prioritizer timeouts
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If users don't add a timeout to the datacore priorizier arguments, it
should use the checker_timeout. Also, don't limit possible timeout
values, to match the other prioritizers.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/prioritizers/datacore.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/libmultipath/prioritizers/datacore.c b/libmultipath/prioritizers/datacore.c
index 74e15f3e..f288306c 100644
--- a/libmultipath/prioritizers/datacore.c
+++ b/libmultipath/prioritizers/datacore.c
@@ -32,7 +32,8 @@
 
 #define dc_log(prio, msg) condlog(prio, "%s: datacore prio: " msg, dev)
 
-int datacore_prio (const char *dev, int sg_fd, char * args)
+int datacore_prio (const char *dev, int sg_fd, char * args,
+		   unsigned int timeout_ms)
 {
 	int k;
 	char sdsname[32];
@@ -42,7 +43,6 @@ int datacore_prio (const char *dev, int sg_fd, char * args)
 	unsigned char sense_buffer[32];
 	sg_io_hdr_t io_hdr;
 
-	int timeout = 2000;
 	char preferredsds_buff[255] = "";
 	char * preferredsds = &preferredsds_buff[0];
 
@@ -52,9 +52,9 @@ int datacore_prio (const char *dev, int sg_fd, char * args)
 	}
 
 	if (sscanf(args, "timeout=%i preferredsds=%s",
-		   &timeout, preferredsds) == 2) {}
+		   (int *)&timeout_ms, preferredsds) == 2) {}
 	else if (sscanf(args, "preferredsds=%s timeout=%i",
-			preferredsds, &timeout) == 2) {}
+			preferredsds, (int *)&timeout_ms) == 2) {}
 	else if (sscanf(args, "preferredsds=%s",
 			preferredsds) == 1) {}
 	else {
@@ -67,10 +67,6 @@ int datacore_prio (const char *dev, int sg_fd, char * args)
 		dc_log(0, "prio args: preferredsds too short (1 character min)");
 		return 0;
 	}
-	if ((timeout < 500) || (timeout > 20000)) {
-		dc_log(0, "prio args: timeout out of bounds [500:20000]");
-		return 0;
-	}
 	if ((ioctl(sg_fd, SG_GET_VERSION_NUM, &k) < 0) || (k < 30000))
 		return 0;
 
@@ -83,7 +79,7 @@ int datacore_prio (const char *dev, int sg_fd, char * args)
 	io_hdr.dxferp = inqBuff;
 	io_hdr.cmdp = inqCmdBlk;
 	io_hdr.sbp = sense_buffer;
-	io_hdr.timeout = timeout;
+	io_hdr.timeout = timeout_ms;
 
 	// on error just return prio 0
 	if (ioctl(sg_fd, SG_IO, &io_hdr) < 0)
@@ -100,5 +96,5 @@ int datacore_prio (const char *dev, int sg_fd, char * args)
 
 int getprio(struct path * pp, char * args)
 {
-	return datacore_prio(pp->dev, pp->fd, args);
+	return datacore_prio(pp->dev, pp->fd, args, get_prio_timeout_ms(pp));
 }
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

