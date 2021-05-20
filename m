Return-Path: <SRS0=4wsM=KP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A482C433B4
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 04:22:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0FDB16108C
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 04:22:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0FDB16108C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-L0lsICKXNvOZT8Damm_IuA-1; Thu, 20 May 2021 00:22:49 -0400
X-MC-Unique: L0lsICKXNvOZT8Damm_IuA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0444C802B4F;
	Thu, 20 May 2021 04:22:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BB584687FA;
	Thu, 20 May 2021 04:22:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 229B755355;
	Thu, 20 May 2021 04:22:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14K4Mcls005764 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 May 2021 00:22:39 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C644E105481E; Thu, 20 May 2021 04:22:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BFCA6103F291
	for <dm-devel@redhat.com>; Thu, 20 May 2021 04:22:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4680E80D0E0
	for <dm-devel@redhat.com>; Thu, 20 May 2021 04:22:38 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-452-ha0SDqdTMM-DGMT5_GmE2w-1; Thu, 20 May 2021 00:22:31 -0400
X-MC-Unique: ha0SDqdTMM-DGMT5_GmE2w-1
IronPort-SDR: gDTFAxoYU5Mon+RP6Kb2aBbxhl0QbJ2Yca6nk34QJEWEAndQg4aD0bbykURYIyA0l6B2FbFySr
	tZLvlHQTWnOTixQw+GOfotBrnth2HFwhsj2DgaFWmaHacm6dbsgaS4tApRAwdsDqc7CkAdEoIf
	kJQp8mjLbgO7N9c07b7d3NFlBtbsBokGV10l7/y7WtAoQkWieNYRI3oVoMxuBC9LmP7Uw+On52
	4sdXwd63KbDbQcj39l2ai8C4Zgz1VggjqKvbvcwI6XOg3ONd8bhX89fHA9v0UdLi+1/QrbXR1I
	tPk=
X-IronPort-AV: E=Sophos;i="5.82,313,1613404800"; d="scan'208";a="169343182"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 20 May 2021 12:22:30 +0800
IronPort-SDR: gxhZv9dJj9MhYD3bCN61McHXJCafwYelwPsmJy+6OdBaoxZIbYQ3Rk7KXqyKjDHe6+Ynkh3aAS
	rkl/YgoqopW8W7AVjMcrYdppwDKccv5/BfGqGUtK8YiaStp9CHG3dxJjCK+thEbYVxUgV2FAEB
	7CSWguzU68y+pchgrAtb6FZbpUBsW0Pz4mfGuXR0lL67EzYtQBbGgaEd6IewEZ35t6bs6zM+YC
	auYRCq69mbZfeSUe7JxIW3JLZGya8GLSkXysablmbKS2uJNsUbk6LRY1slV1SBbDhM74JEztpb
	zaZnO4Q0b3uq/QSfURJDWxOb
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	19 May 2021 21:00:53 -0700
IronPort-SDR: kqkx6Wgss/J1P0XbNojevRZX6KCllmhPyNFdKU7WOHMBrlhfHpIfJW142FtWDL8KffHOxpgJuw
	AB4cOEMViGbThbO0F68lgS/H3lobe5cow8FMHOpjnM+OEo2BZSviEHcx3qtOmmar427AEESGxY
	zbYuKYqz9wxHxcgbpi/dq8WmFKefB5fYDOfWaTHJ9FxkTKyMyO/cWN6Vfgxis17pDZykmUXZ5g
	6BwEPysC09/VvoiHQP1fYX332HqZYJ5Sc9Tm7DU8NCN950O4SPRaeK4jvyfINuzbvEJFLKYx79
	NTI=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip02.wdc.com with ESMTP; 19 May 2021 21:22:28 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Thu, 20 May 2021 13:22:17 +0900
Message-Id: <20210520042228.974083-1-damien.lemoal@wdc.com>
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
Subject: [dm-devel] [PATCH v2 00/11] dm: Improve zoned block device support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This series improve device mapper support for zoned block devices and
of targets exposing a zoned device.

The first patch improve support for user requests to reset all zones of
the target device. With the fix, such operation behave similarly to
physical block devices implementation based on the single zone reset
command with the ALL bit set.

The following 2 patches are preparatory block layer patches.

Patch 4 and 5 are 2 small fixes to DM core zoned block device support.

Patch 6 reorganizes DM core code, moving conditionally defined zoned
block device code into the new dm-zone.c file. This avoids sprinkly DM
with zone related code defined under an #ifdef CONFIG_BLK_DEV_ZONED.

Patch 7 improves DM zone report helper functions for target drivers.

Patch 8 fixes a potential problem with BIO requeue on zoned target.

Finally, patch 9 to 11 implement zone append emulation using regular
writes for target drivers that cannot natively support this BIO type.
The only target currently needing this emulation is dm-crypt. With this
change, a zoned dm-crypt device behaves exactly like a regular zoned
block device, correctly executing user zone append BIOs.

This series passes the following tests:
1) zonefs tests on top of dm-crypt with a zoned nullblk device
2) zonefs tests on top of dm-crypt+dm-linear with an SMR HDD
3) btrfs fstests on top of dm-crypt with zoned nullblk devices.

Comments are as always welcome.

Changes from v1:
* Use Christoph proposed approach for patch 1 (split reset all
  processing into different functions)
* Changed helpers introduced in patch 2 to remove the request_queue
  argument
* Improve patch 3 commit message as suggested by Christoph (explaining
  that the flag is a special case that cannot use a REQ_XXX flag)
* Changed DMWARN() into DMDEBUG in patch 11 as suggested by Milan
* Added reviewed-by tags

Damien Le Moal (11):
  block: improve handling of all zones reset operation
  block: introduce bio zone helpers
  block: introduce BIO_ZONE_WRITE_LOCKED bio flag
  dm: Fix dm_accept_partial_bio()
  dm: cleanup device_area_is_invalid()
  dm: move zone related code to dm-zone.c
  dm: Introduce dm_report_zones()
  dm: Forbid requeue of writes to zones
  dm: rearrange core declarations
  dm: introduce zone append emulation
  dm crypt: Fix zoned block device support

 block/blk-zoned.c             | 117 ++++--
 drivers/md/Makefile           |   4 +
 drivers/md/dm-core.h          |  66 ++++
 drivers/md/dm-crypt.c         |  31 +-
 drivers/md/dm-flakey.c        |   7 +-
 drivers/md/dm-linear.c        |   7 +-
 drivers/md/dm-table.c         |  21 +-
 drivers/md/dm-zone.c          | 689 ++++++++++++++++++++++++++++++++++
 drivers/md/dm.c               | 203 +++-------
 drivers/md/dm.h               |  32 +-
 include/linux/blk_types.h     |   1 +
 include/linux/blkdev.h        |  12 +
 include/linux/device-mapper.h |   9 +-
 13 files changed, 992 insertions(+), 207 deletions(-)
 create mode 100644 drivers/md/dm-zone.c

-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

