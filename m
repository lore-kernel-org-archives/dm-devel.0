Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6B9FC64EC7
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319341;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eq3kmgdpYNeJDwb52ESWmy9r0koMiuYy830yHNzf+M0=;
	b=WnjFUMxDXNWHLDLml9JeBmaeh+tWCfHY2F6PYPWiReyVSZ0dGyl2ErhpvL0sG0K4+AYABn
	3Jp6z/FmBYSGvtJV0P6PehxLRWmcJa8Jn0hmfKE+R+X4BXhVkHBHqSqg9UYep6bZzh2aRj
	Adb8sHoU0vvJASjWbqu6vMdeIJyi0BQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-v0cOzICNPKmcHIuRj_SF6w-1; Mon, 13 Feb 2023 15:15:37 -0500
X-MC-Unique: v0cOzICNPKmcHIuRj_SF6w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87C133C18342;
	Mon, 13 Feb 2023 20:15:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7768D492B03;
	Mon, 13 Feb 2023 20:15:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 68B7B1946588;
	Mon, 13 Feb 2023 20:15:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A19491946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:15:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 981472166B29; Mon, 13 Feb 2023 20:15:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 91A4A2166B26
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 72C112823801
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:25 +0000 (UTC)
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com
 [209.85.160.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-675-ml3JFpvHPVSJcflQehfrqg-4; Mon, 13 Feb 2023 15:15:19 -0500
X-MC-Unique: ml3JFpvHPVSJcflQehfrqg-4
Received: by mail-qt1-f176.google.com with SMTP id g18so15181863qtb.6
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:15:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=M49WNCMeZK6pnvAnFXyg8qJ5Xi0dh91u61PaXAPB+qM=;
 b=kxehrpbh4Mm8HEr07FnTB9fPOHRA/EnNq+ds6F6SCcZqsEkYjf8iN1fNUIdZWikrkV
 aNWKyVOVYEHZ4xkh5jMVTXjmhBTxWXLg/7LAom5ZD5BVw1PVcI5tMoHQeAffRtFdWd+W
 E0oxH8wq8TdSc6aD52EwlYdx2Vnp0AA6oCHKhkV0T0lqzyX9rxOYKYVJIpcX86VSaGMl
 oUWCsx6nvh3jes+lMAM3Nf5jxyU3VNdHfyFm04itbVJ544Gf/8nF7IbHfvIjf5slW8b7
 CGoHfq3yw/Ww5SgyFRXB2RxcEy7smvitKWnvsSEgDwue+dHSA1ct35adsj0hAvcZ/KO/
 EFWw==
X-Gm-Message-State: AO0yUKXeryPxU2mXzs3uBow/KiRdolc3a3aTaBJ5Xt+jycGr4omjtph8
 aloidq1MZbZrisqgX9xj9huRdVGMoL0OsZrtZck6GTkIdJxlBNvx34BagomaQUk7v0ecWHvvNvc
 H3QVYzW/ag+3AJ9tsKyv4G5FnEJCstqUX2zxPsxVPbOcSZNYwTb21FKcaQqwQbyVUU9VuLg==
X-Google-Smtp-Source: AK7set/icWOKx+JCq5hqlbycN0cgwLHXihEse/w4SqBkGHQzOM9/+mescILt62/saAOSXe0qc6SUsQ==
X-Received: by 2002:a05:622a:1647:b0:3b8:5bc6:deab with SMTP id
 y7-20020a05622a164700b003b85bc6deabmr44895899qtj.8.1676319318607; 
 Mon, 13 Feb 2023 12:15:18 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 t66-20020a374645000000b007203bbbbb31sm10481437qka.47.2023.02.13.12.15.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:15:18 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:53 -0500
Message-Id: <20230213201401.45973-32-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH 31/39] dm log: avoid multiple line dereference
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-log.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 94c5d8a19231..5f8c9c246a7e 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -447,8 +447,7 @@ static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
 		 */
 		buf_size =
 		    dm_round_up((LOG_OFFSET << SECTOR_SHIFT) + bitset_size,
-				bdev_logical_block_size(lc->header_location.
-							    bdev));
+				bdev_logical_block_size(lc->header_location.bdev));
 
 		if (buf_size > bdev_nr_bytes(dev->bdev)) {
 			DMWARN("log device %s too small: need %llu bytes",
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

