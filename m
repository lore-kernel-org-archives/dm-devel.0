Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F29CC64EC5
	for <dm-devel@archiver.kernel.org>; Mon,  6 Feb 2023 07:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675669124;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=j9bpmsjKTaEQVnaCjMwUkveQKm+6+/ExWEWQAExbD3Q=;
	b=eIS2/ck1Aq/Q2qYhLCJcBz4waztrJSNS/fkk3dHRsyTGKoo43fy+cGhFogfcruLQhXCiBh
	HmUCZEyrujDFLt7irn6WZFIuV0vAvUJY3Nu2IPANpJMfTKRWNo1t0xjB/4dRI6BhLcMv7y
	ftYa0HmKJEeH2pbhuebkmTDGvOIoER4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-YTUTl4oSNFaIy1Y5AdaY0w-1; Mon, 06 Feb 2023 02:38:37 -0500
X-MC-Unique: YTUTl4oSNFaIy1Y5AdaY0w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D007381459A;
	Mon,  6 Feb 2023 07:38:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E5E9C1121319;
	Mon,  6 Feb 2023 07:38:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 102701946A68;
	Mon,  6 Feb 2023 07:38:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7E9D01946586
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Feb 2023 03:34:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5D8611121315; Mon,  6 Feb 2023 03:34:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 552FE1121314
 for <dm-devel@redhat.com>; Mon,  6 Feb 2023 03:34:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 342AD1C29D44
 for <dm-devel@redhat.com>; Mon,  6 Feb 2023 03:34:08 +0000 (UTC)
Received: from mail.nfschina.com (42.101.60.237 [42.101.60.237]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-327-w9GjhjcIPU2QgNy5COxuxw-1; Sun,
 05 Feb 2023 22:34:05 -0500
X-MC-Unique: w9GjhjcIPU2QgNy5COxuxw-1
Received: from localhost (unknown [127.0.0.1])
 by mail.nfschina.com (Postfix) with ESMTP id E95B91A00A5E;
 Mon,  6 Feb 2023 11:28:57 +0800 (CST)
X-Virus-Scanned: amavisd-new at nfschina.com
Received: from mail.nfschina.com ([127.0.0.1])
 by localhost (localhost.localdomain [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yQRbuDbOX5Gf; Mon,  6 Feb 2023 11:28:57 +0800 (CST)
Received: from localhost.localdomain (unknown [180.167.10.98])
 (Authenticated sender: yuzhe@nfschina.com)
 by mail.nfschina.com (Postfix) with ESMTPA id A41601A00A58;
 Mon,  6 Feb 2023 11:28:56 +0800 (CST)
From: Yu Zhe <yuzhe@nfschina.com>
To: agk@redhat.com,
	snitzer@kernel.org
Date: Mon,  6 Feb 2023 11:27:39 +0800
Message-Id: <20230206032739.19567-1-yuzhe@nfschina.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Mon, 06 Feb 2023 07:38:31 +0000
Subject: [dm-devel] [PATCH] dm raid: fix some spelling mistakes in comment
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
Cc: liqiong@nfschina.com, Yu Zhe <yuzhe@nfschina.com>, dm-devel@redhat.com,
 kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Fix typos in comment.

Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
---
 drivers/md/dm-raid.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 54263679a7b1..8c66a986d647 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1988,7 +1988,7 @@ struct dm_raid_superblock {
 	__le64 sectors; /* Used device size in sectors */
 
 	/*
-	 * Additonal Bit field of devices indicating failures to support
+	 * Additional Bit field of devices indicating failures to support
 	 * up to 256 devices with the 1.9.0 on-disk metadata format
 	 */
 	__le64 extended_failed_devices[DISKS_ARRAY_ELEMS - 1];
@@ -2855,7 +2855,7 @@ static int rs_setup_reshape(struct raid_set *rs)
 	 *
 	 * - in case of adding disk(s), array size has
 	 *   to grow after the disk adding reshape,
-	 *   which'll hapen in the event handler;
+	 *   which'll happen in the event handler;
 	 *   reshape will happen forward, so space has to
 	 *   be available at the beginning of each disk
 	 *
@@ -3148,7 +3148,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		 * If a takeover is needed, userspace sets any additional
 		 * devices to rebuild and we can check for a valid request here.
 		 *
-		 * If acceptible, set the level to the new requested
+		 * If acceptable, set the level to the new requested
 		 * one, prohibit requesting recovery, allow the raid
 		 * set to run and store superblocks during resume.
 		 */
-- 
2.11.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

