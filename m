Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 002C3C05027
	for <dm-devel@archiver.kernel.org>; Fri, 17 Feb 2023 07:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676618130;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XE7Bf/+QXLAiFKWMFNf8+l6FeXqlOwY9BTYvMqaQyKU=;
	b=KIrxeZ/zqxX3re9Enfaz3briOy7kteXwjRgzohdIEKmXYAMbuK16mFKvgHk1M8Lyz6Csem
	yoNdaxsXB0T4QXzrJmZYq52iyG6vasmHM1ZZ1n/nqBXKUDvSohbjPQDbYzMu3KxkFQUKko
	5bjIYh5Wj3y8LJratOMwu4BAYXXkvSE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-439-xHSZSOGyOR-yQq1il9uj8g-1; Fri, 17 Feb 2023 02:15:27 -0500
X-MC-Unique: xHSZSOGyOR-yQq1il9uj8g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A508B802D19;
	Fri, 17 Feb 2023 07:15:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4B5B4140EBF6;
	Fri, 17 Feb 2023 07:15:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 28729194658C;
	Fri, 17 Feb 2023 07:15:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BB7E81946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 17 Feb 2023 01:20:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A8D87141510F; Fri, 17 Feb 2023 01:20:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A0ED11415108
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 01:20:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8986029DD99C
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 01:20:24 +0000 (UTC)
Received: from mail.nfschina.com (42.101.60.237 [42.101.60.237]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-593-r8rBoYjYOQytiXHWHXjEGQ-1; Thu,
 16 Feb 2023 20:20:22 -0500
X-MC-Unique: r8rBoYjYOQytiXHWHXjEGQ-1
Received: from localhost (unknown [127.0.0.1])
 by mail.nfschina.com (Postfix) with ESMTP id 61E841A00A90;
 Fri, 17 Feb 2023 09:15:18 +0800 (CST)
X-Virus-Scanned: amavisd-new at nfschina.com
Received: from mail.nfschina.com ([127.0.0.1])
 by localhost (localhost.localdomain [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S9EpLlZOJPy2; Fri, 17 Feb 2023 09:15:17 +0800 (CST)
Received: from localhost.localdomain.localdomain (unknown [219.141.250.2])
 (Authenticated sender: xupengfei@nfschina.com)
 by mail.nfschina.com (Postfix) with ESMTPA id 8EBB11A00A8E;
 Fri, 17 Feb 2023 09:15:17 +0800 (CST)
From: XU pengfei <xupengfei@nfschina.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	dm-devel@redhat.com
Date: Fri, 17 Feb 2023 09:14:21 +0800
Message-Id: <20230217011420.6613-1-xupengfei@nfschina.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Fri, 17 Feb 2023 07:15:22 +0000
Subject: [dm-devel] [PATCH 1/1] dm: remove unnecessary (void*) conversions
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
Cc: XU pengfei <xupengfei@nfschina.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Pointer variables of void * type do not require type cast.

Signed-off-by: XU pengfei <xupengfei@nfschina.com>
---
 drivers/md/dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b424a6ee27ba..669f2821376a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2139,7 +2139,7 @@ static void event_callback(void *context)
 {
 	unsigned long flags;
 	LIST_HEAD(uevents);
-	struct mapped_device *md = (struct mapped_device *) context;
+	struct mapped_device *md = context;
 
 	spin_lock_irqsave(&md->uevent_lock, flags);
 	list_splice_init(&md->uevent_list, &uevents);
-- 
2.18.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

