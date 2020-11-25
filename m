Return-Path: <SRS0=cgFg=FA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46A4FC56202
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 08:36:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6F57820B80
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 08:36:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F57820B80
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-IrXfw1DJNo-fzgGdidQaDw-1; Thu, 26 Nov 2020 03:36:45 -0500
X-MC-Unique: IrXfw1DJNo-fzgGdidQaDw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F8A91842159;
	Thu, 26 Nov 2020 08:36:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 72AC15D6AD;
	Thu, 26 Nov 2020 08:36:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4B61950032;
	Thu, 26 Nov 2020 08:36:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0APLuirt009606 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 25 Nov 2020 16:56:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 674A31148B65; Wed, 25 Nov 2020 21:56:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 638C51148B63
	for <dm-devel@redhat.com>; Wed, 25 Nov 2020 21:56:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02A40800BFF
	for <dm-devel@redhat.com>; Wed, 25 Nov 2020 21:56:42 +0000 (UTC)
Received: from relay3.sw.ru (relay.sw.ru [185.231.240.75]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-425-uQIWp1ypNheaLh5-7AwNtQ-1;
	Wed, 25 Nov 2020 16:56:36 -0500
X-MC-Unique: uQIWp1ypNheaLh5-7AwNtQ-1
Received: from [192.168.15.51] (helo=localhost.localdomain)
	by relay3.sw.ru with esmtp (Exim 4.94)
	(envelope-from <ktkhai@virtuozzo.com>)
	id 1ki1iz-00ALc3-Qs; Wed, 25 Nov 2020 23:49:14 +0300
From: Kirill Tkhai <ktkhai@virtuozzo.com>
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ktkhai@virtuozzo.com
Date: Wed, 25 Nov 2020 23:49:25 +0300
Message-ID: <160633733483.339234.11951322983778059158.stgit@localhost.localdomain>
User-Agent: StGit/0.19
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 26 Nov 2020 03:35:50 -0500
Subject: [dm-devel] [PATCH] dm: Devices not having .iterate_devices may want
 to set max_io_len
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

After commit 5091cdec56fa "dm: change max_io_len() to use
blk_max_size_offset()" my out-of-tree driver stopped to work.
The reason is that now ti->max_io_len from such target is ignored:
max_io_len() ignores ti->max_io_len, while
dm_calculate_queue_limits() never stacks ti->chunk_sectors into
ti_limits.chunk_sectors.

Here I see two possible solutions, both are in dm_calculate_queue_limits():

1)Move ti_limits.chunk_sectors assignment down, so it will be made
right under combine_limits label. Thus, every time ti->max_io_len
will transform into chunk_sectors, even in case of device
has no .iterate_devices method;

2)Move io_hints call under the label (like it's made in this patch),
so one can set desired chunk_sectors there.

First solution looks less clear, since in two drivers chunk_sectors
are assigned in io_hints (see unstripe_io_hints() and dmz_io_hints()),
and this rewrites, and we should not rewrite it.

Second solution does not break anything since we change only
order with ->iterate_devices(device_area_is_invalid), while
device_area_is_invalid never touches chunk_sectors. So I choosed it.

Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
---
 drivers/md/dm-table.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 2073ee8d18f4..9994c767dc82 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1453,10 +1453,6 @@ int dm_calculate_queue_limits(struct dm_table *table,
 		if (ti->max_io_len)
 			ti_limits.chunk_sectors = lcm_not_zero(ti->max_io_len,
 							       ti_limits.chunk_sectors);
-		/* Set I/O hints portion of queue limits */
-		if (ti->type->io_hints)
-			ti->type->io_hints(ti, &ti_limits);
-
 		/*
 		 * Check each device area is consistent with the target's
 		 * overall queue limits.
@@ -1466,6 +1462,10 @@ int dm_calculate_queue_limits(struct dm_table *table,
 			return -EINVAL;
 
 combine_limits:
+		/* Set I/O hints portion of queue limits */
+		if (ti->type->io_hints)
+			ti->type->io_hints(ti, &ti_limits);
+
 		/*
 		 * Merge this target's queue limits into the overall limits
 		 * for the table.


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

