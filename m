Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 740A5C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jan 2022 07:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1641801326;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ow8IOCarsCDfu3QEUf4cSGpLtVFckeW9fftoym13QUo=;
	b=abZH3vBz0XLRj6XqPhY09FLvfj7497/CukpTID8GsCLdWzYvSXE7TGLibtYAXbfHAM/Fop
	v/cLu5Qp5phY8EAy3sda4bdS6IR5b9Mn5c32h6zoGr0n4QwOfurEtAhbVPIkmu5DTwX3fJ
	+fjsxlE6JAm9lcgMmbfz++zznPOvH5I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-513-zNrPmyBxOY6t9vAcPZSkmA-1; Mon, 10 Jan 2022 02:55:22 -0500
X-MC-Unique: zNrPmyBxOY6t9vAcPZSkmA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1542A1006AA8;
	Mon, 10 Jan 2022 07:55:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F7D91F2FB;
	Mon, 10 Jan 2022 07:55:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 469FA4BB7C;
	Mon, 10 Jan 2022 07:55:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20A7r0jG015350 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 10 Jan 2022 02:53:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B1351694DE; Mon, 10 Jan 2022 07:53:00 +0000 (UTC)
Received: from localhost (ovpn-8-24.pek2.redhat.com [10.72.8.24])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 72BCB694D9;
	Mon, 10 Jan 2022 07:52:28 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
Date: Mon, 10 Jan 2022 15:51:41 +0800
Message-Id: <20220110075141.389532-3-ming.lei@redhat.com>
In-Reply-To: <20220110075141.389532-1-ming.lei@redhat.com>
References: <20220110075141.389532-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, lining <lining2020x@163.com>,
	Tejun Heo <tj@kernel.org>, Chunguang Xu <brookxu@tencent.com>
Subject: [dm-devel] [PATCH 2/2] dm: use resubmit_bio_noacct to submit split
	bio
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

lining reported that blk-throttle iops limit doesn't work correctly
for dm-thin. Turns out it is same issue with the one addressed by commit
4f1e9630afe6 ("blk-throtl: optimize IOPS throttle for large IO scenarios").

So use the new added block layer API for addressing the same issue.

Reported-by: lining <lining2020x@163.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Chunguang Xu <brookxu@tencent.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 280918cdcabd..8a58379e737c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1562,7 +1562,7 @@ static void __split_and_process_bio(struct mapped_device *md,
 
 			bio_chain(b, bio);
 			trace_block_split(b, bio->bi_iter.bi_sector);
-			submit_bio_noacct(bio);
+			resubmit_bio_noacct(bio);
 		}
 	}
 
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

