Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2058EC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 18 Feb 2022 22:27:59 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-387-GJmUiWYdM7aEbbnBJCzaxg-1; Fri, 18 Feb 2022 17:27:55 -0500
X-MC-Unique: GJmUiWYdM7aEbbnBJCzaxg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F9171091DA1;
	Fri, 18 Feb 2022 22:27:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 43C724F84B;
	Fri, 18 Feb 2022 22:27:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 29D301809CAB;
	Fri, 18 Feb 2022 22:27:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21IMRi71013409 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 18 Feb 2022 17:27:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 64206401E4C; Fri, 18 Feb 2022 22:27:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6088C5361FE
	for <dm-devel@redhat.com>; Fri, 18 Feb 2022 22:27:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45FDA85A5A8
	for <dm-devel@redhat.com>; Fri, 18 Feb 2022 22:27:44 +0000 (UTC)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
	[209.85.216.54]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-435-9yWs2P3MNY66cCxN2Foo5Q-1; Fri, 18 Feb 2022 17:27:40 -0500
X-MC-Unique: 9yWs2P3MNY66cCxN2Foo5Q-1
Received: by mail-pj1-f54.google.com with SMTP id
	t4-20020a17090a510400b001b8c4a6cd5dso9776714pjh.5; 
	Fri, 18 Feb 2022 14:27:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=RCW/+7BeMgwUktuYHiRiifRgvAyXvxvZWS62/OY0Kjw=;
	b=4NhHnQlAZzKa+NTtjLyvkK2Uk0vmPUL/mTfalZqyfei0E6Z+sziJ1dCbUUJ4/JIJQ3
	JY5jbD54M23pPGbEHINgIHY4GbV8cxsl0iijM5yjoFyTz/IXWSht4MJVR0H26mgb0Ui9
	2UYvqXvCwqFS6DipAkPD09FFLv2yI+GbNvhCcqrnrysNNCbJYpTtRsSt8j5Zp1A3ZyTq
	0Z4cmHdj6G3/Gs3C9rGzIoHWfwudUEFwp8Pmz355lL01l8p9lRcM3EzE7tXth28FxS5s
	54UDTeMIKKOfATwjbuT8CEPeIw4ou8Qn/DdOtc2MTlYVX7nOUyx6npbK0x0PwlLsqNkj
	2q5Q==
X-Gm-Message-State: AOAM5302j24Dgq0icbjxKXBmQDkQzi5t3FpvWqvLFAVuDh1rUiVChXOF
	o27O3gJhrMw9737qc7bP9nx52iR8fcA=
X-Google-Smtp-Source: ABdhPJyujmIMn0tC8gKa5kqHWj0U/Dyhv+iqweU3gzcsS5ysg+BGgCRISeBYEYj30vNfuaxZOdSMjA==
X-Received: by 2002:a17:90a:c913:b0:1b8:d641:cc1e with SMTP id
	v19-20020a17090ac91300b001b8d641cc1emr10406292pjt.76.1645223259048;
	Fri, 18 Feb 2022 14:27:39 -0800 (PST)
Received: from baohua-VirtualBox.localdomain (47-72-151-34.dsl.dyn.ihug.co.nz.
	[47.72.151.34])
	by smtp.gmail.com with ESMTPSA id v2sm321403pjt.55.2022.02.18.14.27.35
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 18 Feb 2022 14:27:38 -0800 (PST)
From: Barry Song <21cnbao@gmail.com>
X-Google-Original-From: Barry Song <song.bao.hua@hisilicon.com>
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Date: Sat, 19 Feb 2022 06:27:24 +0800
Message-Id: <20220218222724.4802-1-song.bao.hua@hisilicon.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
Cc: Barry Song <song.bao.hua@hisilicon.com>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
	linuxarm@huawei.com
Subject: [dm-devel] [PATCH v2] dm io: Drop the obsolete and incorrect doc
	for dm_io()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Commit 7eaceaccab5f ("block: remove per-queue plugging") dropped
unplug_delay and blk_unplug(). Plus, the current kernel has no
fundamental difference between sync_io() and async_io() except
sync_io() uses sync_io_complete() as the notify.fn and explicitly
calls wait_for_completion_io() to sync. The comment isn't valid
any more.

Cc: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
---
 -v2: refine commit log;
      add revewed-by of Christoph, thanks!

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

