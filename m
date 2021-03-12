Return-Path: <SRS0=XTDI=IK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E72C7C433E9
	for <dm-devel@archiver.kernel.org>; Fri, 12 Mar 2021 16:21:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 77BBF6500F
	for <dm-devel@archiver.kernel.org>; Fri, 12 Mar 2021 16:21:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 77BBF6500F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=veeam.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-A_DGZKUjMpGJwujIB9ciVg-1; Fri, 12 Mar 2021 11:21:11 -0500
X-MC-Unique: A_DGZKUjMpGJwujIB9ciVg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32776760C1;
	Fri, 12 Mar 2021 16:21:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E16C1B582;
	Fri, 12 Mar 2021 16:21:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C874357DC3;
	Fri, 12 Mar 2021 16:21:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12CFjXMR017738 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 12 Mar 2021 10:45:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 454662026D6A; Fri, 12 Mar 2021 15:45:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E82DE2026DE8
	for <dm-devel@redhat.com>; Fri, 12 Mar 2021 15:45:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C044800C5B
	for <dm-devel@redhat.com>; Fri, 12 Mar 2021 15:45:23 +0000 (UTC)
Received: from mx4.veeam.com (mx4.veeam.com [104.41.138.86]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-473-Ev4dMoLCPlqguKdbayj9zA-1;
	Fri, 12 Mar 2021 10:45:16 -0500
X-MC-Unique: Ev4dMoLCPlqguKdbayj9zA-1
Received: from mail.veeam.com (prgmbx01.amust.local [172.24.0.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx4.veeam.com (Postfix) with ESMTPS id BB4E1114A84;
	Fri, 12 Mar 2021 18:45:13 +0300 (MSK)
Received: from prgdevlinuxpatch01.amust.local (172.24.14.5) by
	prgmbx01.amust.local (172.24.0.171) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.2.721.2; Fri, 12 Mar 2021 16:45:12 +0100
From: Sergei Shtepa <sergei.shtepa@veeam.com>
To: Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, 
	Alasdair Kergon <agk@redhat.com>, Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>, <dm-devel@redhat.com>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-api@vger.kernel.org>
Date: Fri, 12 Mar 2021 18:44:52 +0300
Message-ID: <1615563895-28565-1-git-send-email-sergei.shtepa@veeam.com>
MIME-Version: 1.0
X-Originating-IP: [172.24.14.5]
X-ClientProxiedBy: prgmbx02.amust.local (172.24.0.172) To prgmbx01.amust.local
	(172.24.0.171)
X-EsetResult: clean, is OK
X-EsetId: 37303A29D2A50B58627366
X-Veeam-MMEX: True
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: pavel.tide@veeam.com, sergei.shtepa@veeam.com
Subject: [dm-devel] [PATCH v7 0/3] block device interposer
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi all.

I'm joyful to suggest the block device interposer (bdev_interposer) v7.
bdev_interposer allows to redirect bio requests to other block devices.

In this series of patches I suggest a different implementation of the bio
interception mechanism. Now the interposer is a different block device.
Instead of an additional hook, the function fops->submit_bio() of
the interposer device is used.
This implementation greatly simplifies the application of this
bdev_interposer in device-mapper. But there is one limitation - the size
of the interposer device must be greater than or equal to the size of
the original device.

The first patch adds the function blk_mq_is_queue_frozen(). It allows to
check a queue state.

The second patch is dedicated to bdev_interposer itself, which provides
the ability to redirect bio to the interposer device.

The third one adds the DM_INTERPOSED_FLAG flag. When this flag is
applied with the ioctl DM_TABLE_LOAD_CMD, the underlying devices are
opened without the FMODE_EXCL flag and connected via bdev_interposer.

Changes in this patchset v7:
  * the request interception mechanism. Now the interposer is
    a block device that receives requests instead of the original device;
  * code design fixes.

History:
v6 - https://patchwork.kernel.org/project/linux-block/cover/1614774618-22410-1-git-send-email-sergei.shtepa@veeam.com/
  * designed for 5.12;
  * thanks to the new design of the bio structure in v5.12, it is
    possible to perform interception not for the entire disk, but
    for each block device;
  * instead of the new ioctl DM_DEV_REMAP_CMD and the 'noexcl' option,
    the DM_INTERPOSED_FLAG flag for the ioctl DM_TABLE_LOAD_CMD is
    applied.

v5 - https://patchwork.kernel.org/project/linux-block/cover/1612881028-7878-1-git-send-email-sergei.shtepa@veeam.com/
 * rebase for v5.11-rc7;
 * patch set organization;
 * fix defects in documentation;
 * add some comments;
 * change mutex names for better code readability;
 * remove calling bd_unlink_disk_holder() for targets with non-exclusive
   flag;
 * change type for struct dm_remap_param from uint8_t to __u8.

v4 - https://patchwork.kernel.org/project/linux-block/cover/1612367638-3794-1-git-send-email-sergei.shtepa@veeam.com/
Mostly changes were made, due to Damien's comments:
 * on the design of the code;
 * by the patch set organization;
 * bug with passing a wrong parameter to dm_get_device();
 * description of the 'noexcl' parameter in the linear.rst.
Also added remap_and_filter.rst.

v3 - https://patchwork.kernel.org/project/linux-block/cover/1611853955-32167-1-git-send-email-sergei.shtepa@veeam.com/
In this version, I already suggested blk_interposer to apply to dm-linear.
Problems were solved:
 * Interception of bio requests from a specific device on the disk, not
   from the entire disk. To do this, we added the dm_interposed_dev
   structure and an interval tree to store these structures.
 * Implemented ioctl DM_DEV_REMAP_CMD. A patch with changes in the lvm2
   project was sent to the team lvm-devel@redhat.com.
 * Added the 'noexcl' option for dm-linear, which allows you to open
   the underlying block-device without FMODE_EXCL mode.

v2 - https://patchwork.kernel.org/project/linux-block/cover/1607518911-30692-1-git-send-email-sergei.shtepa@veeam.com/
I tried to suggest blk_interposer without using it in device mapper,
but with the addition of a sample of its use. It was then that I learned
about the maintainers' attitudes towards the samples directory :).

v1 - https://lwn.net/ml/linux-block/20201119164924.74401-1-hare@suse.de/
This Hannes's patch can be considered as a starting point, since this is
where the interception mechanism and the term blk_interposer itself
appeared. It became clear that blk_interposer can be useful for
device mapper.

before v1 - https://patchwork.kernel.org/project/linux-block/cover/1603271049-20681-1-git-send-email-sergei.shtepa@veeam.com/
I tried to offer a rather cumbersome blk-filter and a monster-like
blk-snap module for creating snapshots.

Thank you to everyone who was able to take the time to review
the previous versions.
I hope that this time I achieved the required quality.

Thanks,
Sergei.

Sergei Shtepa (3):
  block: add blk_mq_is_queue_frozen()
  block: add bdev_interposer
  dm: add DM_INTERPOSED_FLAG

 block/bio.c                   |  2 ++
 block/blk-core.c              | 57 ++++++++++++++++++++++++++++++++
 block/blk-mq.c                | 13 ++++++++
 block/genhd.c                 | 54 +++++++++++++++++++++++++++++++
 drivers/md/dm-core.h          |  3 ++
 drivers/md/dm-ioctl.c         | 13 ++++++++
 drivers/md/dm-table.c         | 61 +++++++++++++++++++++++++++++------
 drivers/md/dm.c               | 38 +++++++++++++++-------
 include/linux/blk-mq.h        |  1 +
 include/linux/blk_types.h     |  3 ++
 include/linux/blkdev.h        |  9 ++++++
 include/linux/device-mapper.h |  1 +
 include/uapi/linux/dm-ioctl.h |  6 ++++
 13 files changed, 240 insertions(+), 21 deletions(-)

-- 
2.20.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

