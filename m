Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3FEFC77B7A
	for <dm-devel@archiver.kernel.org>; Mon, 17 Apr 2023 16:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681748438;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Jw9LZq5nJh6TTygpUku1cDBhss1Bjic0eFXrXyDUHKA=;
	b=iRSu0thawNIZnR4sr2OLaFBjD0ZXTcfI8X/W6haxj/ROypPIde5WQtDMPfDGIbXZxX202S
	n616PGpNhl7/HU1iP4P2G25Q+fMYnRJCZLbqIOXSQ21irLePTiztCB0WaqVOSZV2BSfXEU
	bRDQ242pRanDKVAcfc6eF3Pbyn/Tjr8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-1mPOzlAYP6aaLiCf3bjnZw-1; Mon, 17 Apr 2023 12:20:37 -0400
X-MC-Unique: 1mPOzlAYP6aaLiCf3bjnZw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A871101A531;
	Mon, 17 Apr 2023 16:20:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3E13D492B03;
	Mon, 17 Apr 2023 16:20:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D22DE194658D;
	Mon, 17 Apr 2023 16:20:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0B101194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 17 Apr 2023 16:20:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A9BB4C15BA0; Mon, 17 Apr 2023 16:20:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A1C06C15E7F
 for <dm-devel@redhat.com>; Mon, 17 Apr 2023 16:20:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86CE93C0F19A
 for <dm-devel@redhat.com>; Mon, 17 Apr 2023 16:20:31 +0000 (UTC)
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com
 [209.85.219.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-54-u0c2MhhWPyartoxW_Q32ww-1; Mon, 17 Apr 2023 12:20:27 -0400
X-MC-Unique: u0c2MhhWPyartoxW_Q32ww-1
Received: by mail-qv1-f44.google.com with SMTP id m16so14354839qvx.9
 for <dm-devel@redhat.com>; Mon, 17 Apr 2023 09:20:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681748427; x=1684340427;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=Ub7tIRwtkL3uHAk4AECnTw80MqWTDLFc81n+6HzSTcQ=;
 b=GeppgNTy2CGgowpbzzTwJFVOG29TE/fPzSHJE8haw+b48iznoqx4dNVS+6DbUNa4Ky
 a6sFaQXrNvj51v4aVOdsvl4u2j3Evd0G30fUC1QpPyu40Ia3eA3EKAvSVtyX8UEbgpFw
 EtQYmR5s1TF7+B9A6eN8ERnAxNeOW7MnXPX9hcWIp8uaLFO+suefIp5P0wHWwzu3hPTc
 z3OvpYKPfOXAH0/svHLiC2pnu48cySbO6WfXHPWJnIeNWHqQdQFJEPRQrVEGX/YvAgWA
 QhFa3PYLjeswAKqfR/52E/Z1NZNzZZMtNaPoaJ8bC9w2ORK2vfkXtqLRttlH2TYSZbzv
 1NdA==
X-Gm-Message-State: AAQBX9fM18jujovyTbNwr3CZRYiP+F1qM15zSO9UZNMQsMvzLm+ByjQg
 Or/nWBAfhnrqrVBJejhAPGhdp3XqjMI6I0sFKo0k
X-Google-Smtp-Source: AKy350Zif85wmja9YUeBTmaCZVN0DyRBM/DP2PS9ZycOFsNEmNYPlKv/tw8AZBWEGdX0pkmFsSASJg==
X-Received: by 2002:a05:6214:c45:b0:5ef:6b9a:6948 with SMTP id
 r5-20020a0562140c4500b005ef6b9a6948mr6838354qvj.17.1681748427225; 
 Mon, 17 Apr 2023 09:20:27 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 b8-20020ac812c8000000b003e4dab0776esm3391128qtj.40.2023.04.17.09.20.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 17 Apr 2023 09:20:26 -0700 (PDT)
Date: Mon, 17 Apr 2023 12:20:25 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Zheng Zhang <zheng.zhang@email.ucr.edu>
Message-ID: <ZD1xyZxb3rHot8PV@redhat.com>
References: <CAC_GQSoYOYfO84RCwO86mgkNoyBZoLkS_5w0Btu3w9qVP7Q1vw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAC_GQSoYOYfO84RCwO86mgkNoyBZoLkS_5w0Btu3w9qVP7Q1vw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] Possible deadlock detected in Linux 6.2.0 in
 dm_get_inactive_table (dm-ioctl.c)
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
Cc: dm-devel@redhat.com, mpatocka@redhat.com, linux-kernel@vger.kernel.org,
 agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Apr 17 2023 at  1:08P -0400,
Zheng Zhang <zheng.zhang@email.ucr.edu> wrote:

> Alasdir, Mike, and to whom it may concern:
> 
> Hello! We have found a bug in the Linux kernel version 6.2.0 by syzkaller
> with our own templates. The bug causes a possible recursive locking
> scenario, resulting in a deadlock.
> The key trace is as follows (the complete trace is in the attached report
> file):
> 
>  down_read+0x9d/0x450 kernel/locking/rwsem.c:1509
> 
>  dm_get_inactive_table+0x2b/0xc0 drivers/md/dm-ioctl.c:773
> 
>  __dev_status+0x4fd/0x7c0 drivers/md/dm-ioctl.c:844
>  table_clear+0x197/0x280 drivers/md/dm-ioctl.c:1537
> 
> In table_clear, it acquires a *write lock*
> https://elixir.bootlin.com/linux/v6.2/source/drivers/md/dm-ioctl.c#L1520
> down_write(&_hash_lock);
> 
> Then before the lock is released at L1539, there is a path shown above:
> table_clear -> __dev_status -> dm_get_inactive_table ->  down_read
> https://elixir.bootlin.com/linux/v6.2/source/drivers/md/dm-ioctl.c#L773
> down_read(&_hash_lock);
> It tries to acquire* the same read lock* again, resulting in the deadlock
> problem
> 
> Attached is the report, log, and reproducers generated by syzkaller
> Please let me know if there is any additional information that I can
> provide to help debug this issue.
> Thanks!

Thanks for the report, I've staged this fix:

From: Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH] dm ioctl: fix nested locking in table_clear() to remove
 deadlock concern

syzkaller found the following problematic rwsem locking (with write
lock already held):

 down_read+0x9d/0x450 kernel/locking/rwsem.c:1509
 dm_get_inactive_table+0x2b/0xc0 drivers/md/dm-ioctl.c:773
 __dev_status+0x4fd/0x7c0 drivers/md/dm-ioctl.c:844
 table_clear+0x197/0x280 drivers/md/dm-ioctl.c:1537

In table_clear, it first acquires a write lock
https://elixir.bootlin.com/linux/v6.2/source/drivers/md/dm-ioctl.c#L1520
down_write(&_hash_lock);

Then before the lock is released at L1539, there is a path shown above:
table_clear -> __dev_status -> dm_get_inactive_table ->  down_read
https://elixir.bootlin.com/linux/v6.2/source/drivers/md/dm-ioctl.c#L773
down_read(&_hash_lock);

It tries to acquire the same read lock again, resulting in the deadlock
problem.

Fix this by moving table_clear()'s __dev_status() call to after its
up_write(&_hash_lock);

Cc: stable@vger.kernel.org
Reported-by: Zheng Zhang <zheng.zhang@email.ucr.edu>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-ioctl.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 50a1259294d1..7d5c9c582ed2 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1556,11 +1556,12 @@ static int table_clear(struct file *filp, struct dm_ioctl *param, size_t param_s
 		has_new_map = true;
 	}
 
-	param->flags &= ~DM_INACTIVE_PRESENT_FLAG;
-
-	__dev_status(hc->md, param);
 	md = hc->md;
 	up_write(&_hash_lock);
+
+	param->flags &= ~DM_INACTIVE_PRESENT_FLAG;
+	__dev_status(md, param);
+
 	if (old_map) {
 		dm_sync_table(md);
 		dm_table_destroy(old_map);
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

