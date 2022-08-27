Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6604ECAAD2
	for <dm-devel@archiver.kernel.org>; Mon, 29 Aug 2022 05:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661752584;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zYgvHG6M48FzgkJagkikNuGxxD1bRhtAbu96L1D/NSA=;
	b=VE20HlKO+D1XY7xz6IoZhy5SNXaNH9sunCNSM+dlgiyrI9OJo+52PI3YuUFE4irvrsW97T
	IRz98VJgP7FztD6gl9vBy6qMByFkr5BBxY6C73dk1nQxfoEc44E0ZsL8+YAqba2Rk++MLS
	EhqAK2PLrD76mDBb6WVCcNLM4Zra2jA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599--VXNztluMd2_CQ_SIxvjmA-1; Mon, 29 Aug 2022 01:56:21 -0400
X-MC-Unique: -VXNztluMd2_CQ_SIxvjmA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CF40101E9B2;
	Mon, 29 Aug 2022 05:56:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 13CBB492C3B;
	Mon, 29 Aug 2022 05:56:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 072421946A48;
	Mon, 29 Aug 2022 05:56:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 817521946A44
 for <dm-devel@listman.corp.redhat.com>; Sat, 27 Aug 2022 16:40:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6FC322166B29; Sat, 27 Aug 2022 16:40:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C5312166B26
 for <dm-devel@redhat.com>; Sat, 27 Aug 2022 16:40:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5431D1C0512A
 for <dm-devel@redhat.com>; Sat, 27 Aug 2022 16:40:15 +0000 (UTC)
Received: from bg5.exmail.qq.com (bg4.exmail.qq.com [43.154.221.58]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-Y32ryey8OgafWEc2aiHndA-1; Sat, 27 Aug 2022 12:40:12 -0400
X-MC-Unique: Y32ryey8OgafWEc2aiHndA-1
X-QQ-mid: bizesmtp63t1661618334tqngeig9
Received: from localhost.localdomain ( [182.148.13.26])
 by bizesmtp.qq.com (ESMTP) with 
 id ; Sun, 28 Aug 2022 00:38:49 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000B00A0000000
X-QQ-FEAT: 6PjtIMncaiylZqezYaqQpiMOUK9GQBlyMKovMYCLnlaQp+x70+WttUwEw69f/
 vzLjZfJDUHY5w0q46YXwq2gGSyPA4WXv3F5fQgf5XTs2bicD3sQu43L3snbQ6ggqRZc5R4Y
 B53roUyaV8L9pgSqvOJkF9M7ej0A8HjbazW46aovidb+8WdirUqHOact+3T4UbBlcvoW7sA
 KbyhPksbjFn53y6H1xA3YdPjhCMIeKEnJK5rIR3W0JnkD0CWyJjs10tay9TSF4p90f4Evvs
 DgCpEyIkKL1AQSdFaMK1t/mVxe3QpZvgIikrpfre7Vow7KE0GyrefoawVfVhus/MuXZPQjE
 xK8GSpgstO/Y1oyWV9a9PAFS/PEcdtvEUCVHuo8OiUUxkS9sNk=
X-QQ-GoodBg: 0
From: Shaomin Deng <dengshaomin@cdjrlc.com>
To: agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com,
 linux-kernel@vger.kernel.org
Date: Sat, 27 Aug 2022 12:38:48 -0400
Message-Id: <20220827163848.24296-1-dengshaomin@cdjrlc.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mailman-Approved-At: Mon, 29 Aug 2022 05:56:16 +0000
Subject: [dm-devel] [PATCH] dm: Remove the unneeeded variable
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The variable "sz" is unneeded, return 0 will be okay.

Signed-off-by: Shaomin Deng <dengshaomin@cdjrlc.com>
---
 drivers/md/dm-log.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 0c6620e7b7bf..a4955eb96d6f 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -805,7 +805,6 @@ static int core_status(struct dm_dirty_log *log, status_type_t status,
 static int disk_status(struct dm_dirty_log *log, status_type_t status,
 		       char *result, unsigned int maxlen)
 {
-	int sz = 0;
 	struct log_c *lc = log->context;
 
 	switch(status) {
@@ -828,7 +827,7 @@ static int disk_status(struct dm_dirty_log *log, status_type_t status,
 		break;
 	}
 
-	return sz;
+	return 0;
 }
 
 static struct dm_dirty_log_type _core_type = {
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

