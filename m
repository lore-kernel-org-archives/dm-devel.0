Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B2D4C4332F
	for <dm-devel@archiver.kernel.org>; Mon,  7 Feb 2022 09:34:16 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-cgtVH1CPM7W_V0C1ThTnAw-1; Mon, 07 Feb 2022 04:34:12 -0500
X-MC-Unique: cgtVH1CPM7W_V0C1ThTnAw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA4B58143E5;
	Mon,  7 Feb 2022 09:34:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B41F66E10;
	Mon,  7 Feb 2022 09:34:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 73791180B654;
	Mon,  7 Feb 2022 09:34:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21796l5p019067 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 7 Feb 2022 04:06:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BA65553AC; Mon,  7 Feb 2022 09:06:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B622F53D6
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 09:06:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5CE0B106655B
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 09:06:44 +0000 (UTC)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
	[209.85.214.176]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-375-nGgijuyQOqeA9gT3ce39VA-1; Mon, 07 Feb 2022 04:06:40 -0500
X-MC-Unique: nGgijuyQOqeA9gT3ce39VA-1
Received: by mail-pl1-f176.google.com with SMTP id x4so3049082plb.4;
	Mon, 07 Feb 2022 01:06:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=z4u5w4bPw3yV/b+kwX1aHYBXd+5cdgt0I+HhlG81Y0w=;
	b=kUvWp3O/PcZ1c3mmTUZodTnKhO0uBrXpQt1fwjrw7JdL80akMGHSJOsgYJvyUVtzEX
	tkHKAmSRWSSzSgFBn1P5HbzjUJGkkIZ4+07Ihym55Ze9XP0VNNr/gEraSD5yu+oRCLS0
	ih0wtXmtu0Qok2wYksz/8cg0sUD76CyKZ/PPRBlaPrf+PpvmF0fan7GX/TxkLvhS8ac0
	b1fhscuMGE9ei3TLpilAnhfX7tizu3kVliSdnPZPDPl2cf12TgxLm8wRVFTkoF16aA6c
	LHD93Boo3icjduSF0MSGD5+6Tb9dNlIsmU+nABriwRpPcjjscj4S1MiaHtaLmtSyf+/M
	SDmw==
X-Gm-Message-State: AOAM530gL3Xwx6l1RaRZfoEo1FF46S3rdEPkuUhoXaRu2G9E++xQaGbN
	ZR99H1svaYwkrlJHbC1j8mNI8EvzrVk=
X-Google-Smtp-Source: ABdhPJx4GR2wsbDJLP7wI3RIxadSj0ipCMY9VI0P/l4mi9o0gHOe/FMyPrBofsFJ5cLht8dSGeBJGw==
X-Received: by 2002:a17:90b:4c06:: with SMTP id
	na6mr13168872pjb.37.1644224798980; 
	Mon, 07 Feb 2022 01:06:38 -0800 (PST)
Received: from baohua-VirtualBox.localdomain (47-72-151-34.dsl.dyn.ihug.co.nz.
	[47.72.151.34]) by smtp.gmail.com with ESMTPSA id
	s17sm10660126pfk.156.2022.02.07.01.06.35
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 07 Feb 2022 01:06:38 -0800 (PST)
From: Barry Song <21cnbao@gmail.com>
X-Google-Original-From: Barry Song <song.bao.hua@hisilicon.com>
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	linux-block@vger.kernel.org
Date: Mon,  7 Feb 2022 17:06:20 +0800
Message-Id: <20220207090620.21207-1-song.bao.hua@hisilicon.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 07 Feb 2022 04:33:18 -0500
Cc: Barry Song <song.bao.hua@hisilicon.com>, Jens Axboe <axboe@kernel.dk>,
	linux-kernel@vger.kernel.org, linuxarm@huawei.com
Subject: [dm-devel] [PATCH] dm io: Drop the obsolete and incorrect doc for
	dm_io()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Commit 7eaceaccab5f ("block: remove per-queue plugging") dropped
unplug_delay() and blk_unplug(). And the current code has no
fundamental difference between sync_io() and async_io() except
sync_io() uses sync_io_complete() as the notify.fn and explicitly
calls wait_for_completion_io() to sync. The comment isn't valid
any more.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
---
 drivers/md/dm-io.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 2d3cda0acacb..7dba193de28b 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -528,11 +528,6 @@ static int dp_init(struct dm_io_request *io_req, struct dpages *dp,
 
 /*
  * New collapsed (a)synchronous interface.
- *
- * If the IO is asynchronous (i.e. it has notify.fn), you must either unplug
- * the queue with blk_unplug() some time later or set REQ_SYNC in
- * io_req->bi_opf. If you fail to do one of these, the IO will be submitted to
- * the disk after q->unplug_delay, which defaults to 3ms in blk-settings.c.
  */
 int dm_io(struct dm_io_request *io_req, unsigned num_regions,
 	  struct dm_io_region *where, unsigned long *sync_error_bits)
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

