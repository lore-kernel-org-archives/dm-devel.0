Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17064FA3744
	for <dm-devel@archiver.kernel.org>; Mon, 31 Oct 2022 06:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667198345;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GEHScc91hjLKW4a1gOqz+6daXQHMeggEAUrIN3EcsS8=;
	b=P+IkJYE8qFJDTMKarkJ/Ho1c6BDe6g6ddTCEwdZ1ro0a1h5B21n3OPUH087HiRIhMuEolH
	/EFV2DM7g7zaIcfvRC267/9Xo7WTbgxy3ZieuhLMLezey4PKMeF2XQ1THGU/ntNB3TmHfl
	0UalzPjC6BSghorTwzcxnfRSFAgX9KY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-56-UDYHDmWPPoqpwuSYOXvVVw-1; Mon, 31 Oct 2022 02:39:01 -0400
X-MC-Unique: UDYHDmWPPoqpwuSYOXvVVw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5DBB1010379;
	Mon, 31 Oct 2022 06:38:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B50C9207B344;
	Mon, 31 Oct 2022 06:38:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9C0A1194658C;
	Mon, 31 Oct 2022 06:38:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 85D83194658C
 for <dm-devel@listman.corp.redhat.com>; Sat, 29 Oct 2022 16:20:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 03834492B0D; Sat, 29 Oct 2022 16:20:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F0AB1492B04
 for <dm-devel@redhat.com>; Sat, 29 Oct 2022 16:20:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D9D99101A52A
 for <dm-devel@redhat.com>; Sat, 29 Oct 2022 16:20:28 +0000 (UTC)
Received: from mail-m971.mail.163.com (mail-m971.mail.163.com
 [123.126.97.1]) by relay.mimecast.com with ESMTP id
 us-mta-604-FpTkfgCOPXqq4bg7xXU8UA-1; Sat, 29 Oct 2022 12:20:26 -0400
X-MC-Unique: FpTkfgCOPXqq4bg7xXU8UA-1
Received: from localhost.localdomain (unknown [153.37.166.1])
 by smtp1 (Coremail) with SMTP id GdxpCgDn8IYbT11jsfL5oQ--.17034S4;
 Sun, 30 Oct 2022 00:05:06 +0800 (CST)
From: lizhe <sensor1010@163.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	dm-devel@redhat.com
Date: Sat, 29 Oct 2022 09:04:41 -0700
Message-Id: <20221029160441.15310-1-sensor1010@163.com>
X-CM-TRANSID: GdxpCgDn8IYbT11jsfL5oQ--.17034S4
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
 VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTRQTmhUUUUU
X-Originating-IP: [153.37.166.1]
X-CM-SenderInfo: 5vhq20jurqiii6rwjhhfrp/xtbBdBKpq1gi4TLiagAAsF
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Mon, 31 Oct 2022 06:38:42 +0000
Subject: [dm-devel] [PATCH v1] drivers/dm-crypt.c : remove redundant state
 settings after waking up
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
Cc: lizhe <sensor1010@163.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

	The task status has been set to TASK_RUNNING in schedule(),
	 no need to set again here

Signed-off-by: lizhe <sensor1010@163.com>
---
 drivers/md/dm-crypt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 159c6806c19b..dd82e5aad729 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1913,7 +1913,6 @@ static int dmcrypt_write(void *data)
 
 		schedule();
 
-		set_current_state(TASK_RUNNING);
 		spin_lock_irq(&cc->write_thread_lock);
 		goto continue_locked;
 
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

