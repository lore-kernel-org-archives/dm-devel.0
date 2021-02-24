Return-Path: <SRS0=mVW8=H2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61AE1C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 24 Feb 2021 06:05:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A7AB864EBB
	for <dm-devel@archiver.kernel.org>; Wed, 24 Feb 2021 06:05:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A7AB864EBB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1614146734;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1F7inUD7aCJu1UKs7+qggW33t1bpcdev7abpFg/ljAw=;
	b=M1+KLUKselFyXNPrUOXnWkyj25M+PkJVgwzXL1Jt10d1HviNangBRhOU6ZAvf6bZFBIiQJ
	QKGJQOTRR12v8BEwjrz/zbJ756S0K5W1RInvVMy1+udHzHfcPBo/riJDl8MuI/j3EzizEB
	ehgnckYAuw8V2czwna/0ydZ5rK8xREU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-3Lmf74IZOKSirf2kuTB0VA-1; Wed, 24 Feb 2021 01:05:31 -0500
X-MC-Unique: 3Lmf74IZOKSirf2kuTB0VA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70137107ACE3;
	Wed, 24 Feb 2021 06:05:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C962E60C4D;
	Wed, 24 Feb 2021 06:05:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8350218095CB;
	Wed, 24 Feb 2021 06:05:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11O65JmQ025849 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Feb 2021 01:05:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8822E7095C; Wed, 24 Feb 2021 06:05:19 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B8426061F;
	Wed, 24 Feb 2021 06:05:16 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 11O65Ed4019733; 
	Wed, 24 Feb 2021 00:05:14 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 11O65D5K019732;
	Wed, 24 Feb 2021 00:05:13 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 24 Feb 2021 00:05:13 -0600
Message-Id: <1614146713-19694-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH] kpartx: free loop device after listing partitions
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If "kpartx -l" is run on a file that doesn't already have a loop device
associated with it, it will create a loop device to run the command.
Starting with da59d15c6 ("Fix loopback file with kpartx -av"), it will
not free the loop device when exitting. This is because it checks if the
the file it stat()ed is a regular file, before freeing the loop device.
However, after da59d15c6, stat() is rerun on the loop device itself, so
the check fails.  There is no need to check this, if loopcreated is
true, then the file will be a kpartx created loop device, and should be
freed.

Also, keep kpartx from printing that the loop device has been removed
at normal verbosity.

Fixes: da59d15c6 ("Fix loopback file with kpartx -av")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/kpartx.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 6a7933fa..8ff116b8 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -424,7 +424,7 @@ main(int argc, char **argv){
 					fprintf(stderr, "can't del loop : %s\n",
 					       loopdev);
 				r = 1;
-			} else
+			} else if (verbose)
 				fprintf(stderr, "loop deleted : %s\n", loopdev);
 		}
 		goto end;
@@ -668,16 +668,17 @@ main(int argc, char **argv){
 		if (n > 0)
 			break;
 	}
-	if (what == LIST && loopcreated && S_ISREG (buf.st_mode)) {
+	if (what == LIST && loopcreated) {
 		if (fd != -1)
 			close(fd);
 		if (del_loop(device)) {
 			if (verbose)
-				printf("can't del loop : %s\n",
+				fprintf(stderr, "can't del loop : %s\n",
 					device);
 			exit(1);
 		}
-		printf("loop deleted : %s\n", device);
+		if (verbose)
+			fprintf(stderr, "loop deleted : %s\n", device);
 	}
 
 end:
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

