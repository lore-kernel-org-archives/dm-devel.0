Return-Path: <SRS0=sUON=EZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63532C64E69
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 16:49:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C2DFD22264
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 16:49:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2DFD22264
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-HTQgAnULOcWHYEiES9zDIQ-1; Thu, 19 Nov 2020 11:49:48 -0500
X-MC-Unique: HTQgAnULOcWHYEiES9zDIQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3A18107564B;
	Thu, 19 Nov 2020 16:49:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5DB4060843;
	Thu, 19 Nov 2020 16:49:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5961B4BB7B;
	Thu, 19 Nov 2020 16:49:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AJGndir004018 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Nov 2020 11:49:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1E585DA67B; Thu, 19 Nov 2020 16:49:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 18FFBDAF2E
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 16:49:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA0F6800BFF
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 16:49:36 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-39-qQ4OQiMFNsWx9Nbh47SHZQ-1;
	Thu, 19 Nov 2020 11:49:33 -0500
X-MC-Unique: qQ4OQiMFNsWx9Nbh47SHZQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 3FEC6AC59;
	Thu, 19 Nov 2020 16:49:31 +0000 (UTC)
From: Hannes Reinecke <hare@suse.de>
To: Mike Snitzer <snitzer@redhat.com>
Date: Thu, 19 Nov 2020 17:49:22 +0100
Message-Id: <20201119164924.74401-1-hare@suse.de>
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	Christoph Hellwig <hch@lst.de>
Subject: [dm-devel] [RFC PATCHv2 0/2] block-layer interposer
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi all,

here's a combined version of the earlier patchset from Sergei, fixing
some issues I've found during testing and including (some) feedback
from Mike. So with this patchset I could do a

echo "0 33554432 linear /dev/sda 0" | dmsetup create sda-cloned

on a system with root-fs on /dev/sda2, and things would continue to
run just like normal.

There are some things which might need to be improved:
- I've tried to remove the stub bio clone for the dm interposer as
suggested by Mike, but that resulted in an endless recursion in
submit_bio_noacct(). That needs more debugging,  but I'm also not
sure if we _can_ do it; the end_io callback might refer to
bi_disk->driver_private, and then will get confused as we've
reassigned the 'bi_disk' setting. Not sure if there are fixed rules
for it, so for now I'll probably leave it.
- The interposer is 'magically' hooked to the first block device
in the device-mapper table. What I really want is to have an explicit
listing of the interposer in the output of things like 'dmsetup table'
like

0 33554432 interposer /dev/dm-0
0 33554432 linear /dev/sda 0

and the first entry having the device number of /dev/sda.
Plan was to have that automatically registered once you set up
the original table, but then I'm not sure if that's the right
way to go. Mike?
- The removal of blkdev_get() as an exported API made things
awkward, as we now have to do a blkdev_get_by_dev(); if not we
end up with an uninitalized blkcg and a resulting crash.
We might be able to fix this up by moving bdget() into dm_blk_open(),
and have md->bdev uninitalized otherwise. But again I'm not
sure if that's the right way to go.

Anyway, comments and reviews are welcome.

Sergei Shtepa (2):
  blk_interposer - Block Layer Interposer
  dm_interposer - blk_interposer for device-mapper

 block/blk-core.c          |  34 +++++++++++
 block/genhd.c             |  55 ++++++++++++++++++
 drivers/md/dm-table.c     |  59 +++++++++++++++++++
 drivers/md/dm.c           | 140 ++++++++++++++++++++++++++++++++++++++++++----
 drivers/md/dm.h           |   4 +-
 include/linux/blk_types.h |   6 +-
 include/linux/genhd.h     |  19 +++++++
 7 files changed, 303 insertions(+), 14 deletions(-)

-- 
2.16.4

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

