Return-Path: <SRS0=hs6z=KU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C563C2B9F7
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 02:26:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 08AC16141F
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 02:25:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08AC16141F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-tmMRbnCdO6akX0La-Y5Y5A-1; Mon, 24 May 2021 22:25:57 -0400
X-MC-Unique: tmMRbnCdO6akX0La-Y5Y5A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8107F1005D52;
	Tue, 25 May 2021 02:25:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3917E100238C;
	Tue, 25 May 2021 02:25:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0410D1801029;
	Tue, 25 May 2021 02:25:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14P2Pkl7027646 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 24 May 2021 22:25:47 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5D7A21009157; Tue, 25 May 2021 02:25:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5866D1111447
	for <dm-devel@redhat.com>; Tue, 25 May 2021 02:25:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D97C783395B
	for <dm-devel@redhat.com>; Tue, 25 May 2021 02:25:43 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-507-bSxydBgPM2OLNCJA6T4PBA-1; Mon, 24 May 2021 22:25:41 -0400
X-MC-Unique: bSxydBgPM2OLNCJA6T4PBA-1
IronPort-SDR: MLvbOMyQylQAn2zpjJM7jC5bg/XhexmUt7xf0Qfeb7drfy5pleOuJY2RCx+Prhtnl2lRjx8cbW
	m3+nviT1182aw0Y+9puo6cT/aAf9sxFiSrESB3s8DEB6Y1hoQObENO4s2E48TeGS6xwyghYLEB
	EjnWYxZkd5VjYkdWBkAr5bvWgaPeBygYuj3ol7GSBTjcTbBw/aUBJjkA53F0uR8WfgSUFj66Nj
	7wxbHySKvKc7Z9iw+vjBGP0Wv++s4oCEnQ0elA9iTERPI63SV1qGRWgyHtr9Az8KjWcCAdzT3e
	iFQ=
X-IronPort-AV: E=Sophos;i="5.82,327,1613404800"; d="scan'208";a="273213771"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 25 May 2021 10:26:36 +0800
IronPort-SDR: koK3ulI+7Qix/bgFH4RiFluzw+oEHukLRM7xMkCNThf8x7nBx0zFJ0ozSVDTiVLv456P3qti2M
	LVVCII0ABVXOxLHaEY6KkW+1BOFFXg2MVMcdwUxLihnsCI+emaSnWIir1M73GLjkbv6IMTVaNV
	TCybrgD8BLnIkNFOllaL+24JmEFhhUOKK+KjbpbR5xdGVQEWbVQifey7NWdRKxmYY+cQC+LzpC
	nuxD2lbfqrR21DUuDHddXJ+zhifFrp7L3NLi/5iHRi7VQa1MMm7lWGtUKQMyc7IBhwvIdrP1D4
	EiovWXl0GjzsPFF7q8Cg6v3o
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	24 May 2021 19:03:54 -0700
IronPort-SDR: WoCjn06vNnQAlnlv1p4iyV9s4DNGMjYjHUm1ASW0KfxEitteLFLdaj3FY5cBjAZa32G3McnkVK
	Oi9FzceS1Y/i4iTUuH6YlZGHeVbr5zZ0nuU9vaVkCa3KZgDTVVp5GYDAH9/7wiV5TGynddjy10
	u2Rm1QheboeiSrQc1lsFWNxLSzqUsD92scXDHdhUFbUiH79QBFEUY5Ov69CScLbtu/lWlusi81
	meq8+InorQl7rk6/efvkAdDNbV/Zeo3s3V/wTV+S34bNavhcYttxUgvEVkmBMaA1zDvzVd4zTE
	4X4=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip02.wdc.com with ESMTP; 24 May 2021 19:25:39 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Tue, 25 May 2021 11:25:28 +0900
Message-Id: <20210525022539.119661-1-damien.lemoal@wdc.com>
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
Subject: [dm-devel] [PATCH v4 00/11] dm: Improve zoned block device support
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

Changes from v3:
* Fixed missing variable initialization in
  blkdev_zone_reset_all_emulated() in patch 1.
* Rebased on rc3
* Added reviewed-by tags

Changes from v2:
* Replace use of spinlock to protect the zone write pointer offset
  array in patch 11 with READ_ONCE/WRITE_ONCE as suggested by Hannes.
* Added reviewed-by tags

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

 block/blk-zoned.c             | 119 +++++--
 drivers/md/Makefile           |   4 +
 drivers/md/dm-core.h          |  65 ++++
 drivers/md/dm-crypt.c         |  31 +-
 drivers/md/dm-flakey.c        |   7 +-
 drivers/md/dm-linear.c        |   7 +-
 drivers/md/dm-table.c         |  21 +-
 drivers/md/dm-zone.c          | 654 ++++++++++++++++++++++++++++++++++
 drivers/md/dm.c               | 202 +++--------
 drivers/md/dm.h               |  30 +-
 include/linux/blk_types.h     |   1 +
 include/linux/blkdev.h        |  12 +
 include/linux/device-mapper.h |   9 +-
 13 files changed, 955 insertions(+), 207 deletions(-)
 create mode 100644 drivers/md/dm-zone.c

-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

