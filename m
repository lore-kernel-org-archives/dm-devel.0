Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51B3FECAAA1
	for <dm-devel@archiver.kernel.org>; Mon,  5 Sep 2022 05:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662357091;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vGrHn3SipZGQEcz7G+7W1Fr9pAUHjrB92JK9H6g51PM=;
	b=LI00uRqsAfvHhnjKiZ7JBaNBNc+s/vn3DWtgyy+N+huLqWxgzKyCCP793d9t+aIvZSZaCy
	sdlHFv1wVRtb3wFdcoEhDY5qPcip4nObY0HGkZubihIG88LJsnw7I8uBHAx5B+6qtt3QTo
	S47xxLp684okPN7jZqMpCYZrI9DQmas=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-BynEmQn1MoSQPXI7gg-e4w-1; Mon, 05 Sep 2022 01:51:29 -0400
X-MC-Unique: BynEmQn1MoSQPXI7gg-e4w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 202031C0BC63;
	Mon,  5 Sep 2022 05:51:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0BB3D945DB;
	Mon,  5 Sep 2022 05:51:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CFCDF194B966;
	Mon,  5 Sep 2022 05:51:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4C9151946A47
 for <dm-devel@listman.corp.redhat.com>; Sun,  4 Sep 2022 16:05:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3FFA5400EAB2; Sun,  4 Sep 2022 16:05:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C00F4011A58
 for <dm-devel@redhat.com>; Sun,  4 Sep 2022 16:05:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27B9B804191
 for <dm-devel@redhat.com>; Sun,  4 Sep 2022 16:05:55 +0000 (UTC)
Received: from smtpbg.qq.com (bg4.exmail.qq.com [43.154.221.58]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-OIinbpWDNDWi9a5kl2madw-1; Sun, 04 Sep 2022 12:05:50 -0400
X-MC-Unique: OIinbpWDNDWi9a5kl2madw-1
X-QQ-mid: bizesmtp81t1662307473toihb2me
Received: from localhost.localdomain ( [182.148.14.80])
 by bizesmtp.qq.com (ESMTP) with 
 id ; Mon, 05 Sep 2022 00:04:28 +0800 (CST)
X-QQ-SSF: 01000000000000C0C000000A0000000
X-QQ-FEAT: M0bc4q6Ne4so6o+B5xJQ/1rpGWuLP3ZCm01G0A2ihLVssyft3q5GqQxlEpbRN
 HtQ8fF3CDo6lMDv/VX/6K9D+gw1T/d7dYWxVndDNBMHifgVUiPbzd5cjibapa6f71IeVcp6
 t8QgfIKLJTXydPWvNDlCylHEkyJZWxaencX2/MPBcNKAXL9LV0x+LFGv8WbiMJa73FRS7OU
 pAxY92Iy8zxESBUH+kuN4F8okOzlgyKyw+tymibMhCgf1AwFTYh0tM8jO5d346DrQV3l3UX
 Y9jR1ajSrykRznUClG5dic1xQOBaBbK0dEsoGay8RxtM8BmOaP5KzGB7DUuqLQ0DNK4ONeQ
 FD4s4ZfmuTKMjDpEnOTqdCVw2nXAg==
X-QQ-GoodBg: 0
From: Shaomin Deng <dengshaomin@cdjrlc.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	dm-devel@redhat.com
Date: Sun,  4 Sep 2022 12:04:27 -0400
Message-Id: <20220904160427.31232-1-dengshaomin@cdjrlc.com>
MIME-Version: 1.0
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Mon, 05 Sep 2022 05:51:23 +0000
Subject: [dm-devel] [PATCH] dm cache: Fix comments typo
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
Cc: Shaomin Deng <dengshaomin@cdjrlc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Fix double word in comments.

Signed-off-by: Shaomin Deng <dengshaomin@cdjrlc.com>
---
 drivers/md/dm-cache-policy.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-cache-policy.h b/drivers/md/dm-cache-policy.h
index c05fc3436cef..06eb31af626f 100644
--- a/drivers/md/dm-cache-policy.h
+++ b/drivers/md/dm-cache-policy.h
@@ -166,7 +166,7 @@ struct dm_cache_policy_type {
 	struct dm_cache_policy_type *real;
 
 	/*
-	 * Policies may store a hint for each each cache block.
+	 * Policies may store a hint for each cache block.
 	 * Currently the size of this hint must be 0 or 4 bytes but we
 	 * expect to relax this in future.
 	 */
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

