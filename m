Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C0CAC7EE23
	for <dm-devel@archiver.kernel.org>; Mon, 27 Feb 2023 15:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677511422;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iYJGcZv418Hy3KaMJT7jQ5IGa7N+9iRmU7vzWmEV+Rk=;
	b=MSewbq1U+Z9ue0I7dT5tHGOKUL47OjzjWEaPEmm/IluBh/A9QCGI8rxjM0YF7RRvXGIkeA
	9HtlnZfR8gsMBu+J+gm+TwkJQb0GPURZLP08rHIpUBWVLb7D86uLeRXLCO5l7UsFbShVih
	lHJLQ4/g/RrpXHME8xU5z0lBgPShPVY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-282-z7akV4mCPSWmPBwHN06qOw-1; Mon, 27 Feb 2023 10:23:39 -0500
X-MC-Unique: z7akV4mCPSWmPBwHN06qOw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10EBF3C21C29;
	Mon, 27 Feb 2023 15:23:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7D5CDC16020;
	Mon, 27 Feb 2023 15:23:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6ABF01946589;
	Mon, 27 Feb 2023 15:23:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 086E21946589
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Feb 2023 15:23:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E5139C15BAE; Mon, 27 Feb 2023 15:23:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DD111C15BAD
 for <dm-devel@redhat.com>; Mon, 27 Feb 2023 15:23:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C23A7100F90B
 for <dm-devel@redhat.com>; Mon, 27 Feb 2023 15:23:29 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-64-PX3nyaYKMV-z-mvdPkI6ag-1; Mon,
 27 Feb 2023 10:23:26 -0500
X-MC-Unique: PX3nyaYKMV-z-mvdPkI6ag-1
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
 by smtp-out2.suse.de (Postfix) with ESMTP id 822D41FD65;
 Mon, 27 Feb 2023 15:23:24 +0000 (UTC)
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de
 [10.163.16.22]) by relay2.suse.de (Postfix) with ESMTP id A8B162C141;
 Mon, 27 Feb 2023 15:23:22 +0000 (UTC)
From: Coly Li <colyli@suse.de>
To: snitzer@kernel.org
Date: Mon, 27 Feb 2023 23:23:17 +0800
Message-Id: <20230227152317.32684-1-colyli@suse.de>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH v2] Avoid deadlock for recursive I/O on dm-thin
 when used as swap
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
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 stable@vger.kernel.org, Coly Li <colyli@suse.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is an alrady known issue that dm-thin volume cannot be used as
swap, otherwise a deadlock may happen when dm-thin internal memory
demond triggers swap I/O on the dm-thin volume itself.

Thanks to Mikulas Patocka for commit a666e5c05e7c ("dm: fix deadlock
when swapping to encrypted device"), this method can also be used for
dm-thin to avoid the recursive I/O when it is used as swap.

This patch just simply sets ti->limit_swap_bios by tree in pool_ctr()
and thin_ctr(), other important stuffs are already done by Patocka in
the above mentioned commit.

In my test, I create a dm-thin volume /dev/vg/swap and use it as swap
device. Then I run fio on another dm-thin volume /dev/vg/main and use
large --blocksize to trigger swap I/O onto /dev/vg/swap.

The following fio command line is used in my test,
  fio --name recursive-swap-io --lockmem 1 --iodepth 128 \
     --ioengine libaio --filename /dev/vg/main --rw randrw \
    --blocksize 1M --numjobs 32 --time_based --runtime=12h

Without the patch, the whole system can be locked up within 15 seconds.

With this patch, there is no any deadlock or hang task observed after
2 hours fio running.

Further more, I change --blocksize from 1M to 128M, around 30 seconds
after fio running, no I/O rate displayed by fio, and the out-of-memory
killer message shows up in kernel message. After around 20 minutes all
fio processes are killed and the whole system backs to be alive.

This is exactly what is expected when recursive I/O happens on dm-thin
volume when it is used as swap.

Note: this change depends on commit a666e5c05e7c ("dm: fix deadlock when
swapping to encrypted device")

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: stable@vger.kernel.org
---
Changelog,
v2: fix typo in commit log.
v1: initial version.

 drivers/md/dm-thin.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3355,6 +3355,7 @@ static int pool_ctr(struct dm_target *ti
 	pt->low_water_blocks = low_water_blocks;
 	pt->adjusted_pf = pt->requested_pf = pf;
 	ti->num_flush_bios = 1;
+	ti->limit_swap_bios = true;
 
 	/*
 	 * Only need to enable discards if the pool should pass
@@ -4233,6 +4234,7 @@ static int thin_ctr(struct dm_target *ti
 		goto bad;
 
 	ti->num_flush_bios = 1;
+	ti->limit_swap_bios = true;
 	ti->flush_supported = true;
 	ti->accounts_remapped_io = true;
 	ti->per_io_data_size = sizeof(struct dm_thin_endio_hook);

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

