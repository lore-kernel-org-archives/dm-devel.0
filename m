Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1058EC678DB
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319338;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/Q/77Y5/An8Lvbe0rMaW4A2pCWka6gS8/aFCZdVkrCE=;
	b=bORyWlNlgYPlsZGNuYkR2jh8b0qW+VQEH6ru/hCmffzA0dHa97cAsxxjF1RsU5W2+tfme6
	IhYLznAOx7n2uMuBa+To5CkyxT+pmsYp5S0LRGc3SKue7Ge0MztwzexsJGDwcJPo9HsAdj
	rmJpRzpqQ2nH04A6gglytYe6iyNzNf0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-572-jtsKPM85Ny-1wlrSEymaww-1; Mon, 13 Feb 2023 15:15:35 -0500
X-MC-Unique: jtsKPM85Ny-1wlrSEymaww-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57B0B857A89;
	Mon, 13 Feb 2023 20:15:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 45ECF2166B29;
	Mon, 13 Feb 2023 20:15:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 39D87194658C;
	Mon, 13 Feb 2023 20:15:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A94981946588
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:15:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A063640B40C9; Mon, 13 Feb 2023 20:15:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 98FC640CF8ED
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A444D802C18
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:17 +0000 (UTC)
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com
 [209.85.160.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-102-dSinGTIpMSW2vkfDcSnsIg-2; Mon, 13 Feb 2023 15:15:16 -0500
X-MC-Unique: dSinGTIpMSW2vkfDcSnsIg-2
Received: by mail-qt1-f178.google.com with SMTP id h24so15158063qta.12
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:15:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=nOj4HUNAHlthKqTDP+xgaBXM0hmowK8iLMe4XmygrcE=;
 b=7P7PnmNgFsZ6A74LyX0jLoPnxLPyGdsQTthDf0upE4kHDQy9tHLcBQtwyXY7M/LVgY
 JYj3hdx5SuVK1n3zuq8ZgZaiVq+CHIw222Vm2NER7Jg+q8cnl+Tkz3HsdsHOaRJieGW7
 KOwtmIXFe7cdRh57N5ofL6MGIUVgo42CjdKLRcxDjfFxtrD3XjhenK/HfOPLxOwG058M
 5fwVpL0RJnq2NL09vIWW5fuQS/9zGq+t2PYaL+6Y9sV8gzj9erLVNm0qXcanlvF+ovaN
 Y5pO52r8Gk0+LKxIy6NEm9FGXK7cTf3MMW8B5wxE8QOXtN5LvCmnuxQ1t13kNKf4Hci6
 dfKQ==
X-Gm-Message-State: AO0yUKX7qO/nt4ohHfX3yYxUNTkW7HL4/5ggqe5e9LoXKPGu85OEq93V
 ogR3YeBSJKNhpLRyg7z+YWBXRqc4EnxWwf1bB0xV+OvT3nJy93sxFhAtBZIVbUoucvFoNpoTlsO
 kMm9gwPGa8hADKyZteliwd5Mkl6QVcQ5Oy6yLOW8S9Lx2u64Ux0ttTQLJ8p7mrNZLHQlXkA==
X-Google-Smtp-Source: AK7set+0X4dW2WrmCK8/N4DLhl/3vMImmwDeh6r11fBRuxPIqf0YCpEp/o7oi8UYy6aEQw/HMO6QzQ==
X-Received: by 2002:ac8:58c5:0:b0:3b8:6bc1:1570 with SMTP id
 u5-20020ac858c5000000b003b86bc11570mr33709007qta.23.1676319315255; 
 Mon, 13 Feb 2023 12:15:15 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 l12-20020ac8724c000000b003b8238114d9sm9756191qtp.12.2023.02.13.12.15.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:15:14 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:51 -0500
Message-Id: <20230213201401.45973-30-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH 29/39] dm ioctl: have constant on the right side
 of the test
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
Cc: ebiggers@kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index ec278675a8ca..e1eddb91cc2b 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1828,8 +1828,8 @@ static int check_version(unsigned int cmd, struct dm_ioctl __user *user)
 	if (copy_from_user(version, user->version, sizeof(version)))
 		return -EFAULT;
 
-	if ((DM_VERSION_MAJOR != version[0]) ||
-	    (DM_VERSION_MINOR < version[1])) {
+	if ((version[0] != DM_VERSION_MAJOR) ||
+	    (version[1] > DM_VERSION_MINOR)) {
 		DMERR("ioctl interface mismatch: kernel(%u.%u.%u), user(%u.%u.%u), cmd(%d)",
 		      DM_VERSION_MAJOR, DM_VERSION_MINOR,
 		      DM_VERSION_PATCHLEVEL,
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

