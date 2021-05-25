Return-Path: <SRS0=hs6z=KU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02D5BC47086
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 21:25:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8C9196141C
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 21:25:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C9196141C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-9DkJOeovOy2km1JZt5KwwQ-1; Tue, 25 May 2021 17:25:41 -0400
X-MC-Unique: 9DkJOeovOy2km1JZt5KwwQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94715801817;
	Tue, 25 May 2021 21:25:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A64660CEC;
	Tue, 25 May 2021 21:25:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 46A65180C69B;
	Tue, 25 May 2021 21:25:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14PLPEDR003304 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 May 2021 17:25:15 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D5990FA746; Tue, 25 May 2021 21:25:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D057063F84
	for <dm-devel@redhat.com>; Tue, 25 May 2021 21:25:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12D2F80D0E2
	for <dm-devel@redhat.com>; Tue, 25 May 2021 21:25:11 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-215-P03H6o0NNmOp20U06Q_BXQ-1; Tue, 25 May 2021 17:25:05 -0400
X-MC-Unique: P03H6o0NNmOp20U06Q_BXQ-1
IronPort-SDR: khG8wvF8pGrUAi8A4lmMX9pNTXToBhxrDIop225D7u1oxQjrvTTf2VpuYqBTOioOXJ4MchqwSw
	35aNxlLueITu5hbUqoqLpV/26ef6Z5vSao6rKPdMHX8IydvX0QQ/rBrw1TKMmo31j0ORubmFua
	n6VhGT4f6xID96JVSigcHgDv6T7pq7MsnXx57pPUMMctsoGxTZy4Lp16VxTAu+29Y116+Vs/pi
	lmDbgZmmYk5RaatrBiTWmRVL3/TXyHZz2RJUoWkiRK8yTdsHpkdPOv2L6es0yb5bPEhnusUhBC
	FTE=
X-IronPort-AV: E=Sophos;i="5.82,329,1613404800"; d="scan'208";a="168717507"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 26 May 2021 05:25:04 +0800
IronPort-SDR: JczIu6MoXvg52xzSUQtLJDcLw3yjF+rGqtL/nQAoVNqNh7rtGF9OLQy/7JTyYTm4BKhy9HP2UE
	yUmD8WLKkRlzZvMjWU1NtbRiBCZ0JaoAfx7hE1i0X3AssSNZ7y40nofEq6YGaMzNKA33UobMQK
	nAizsoc78HHdT/OcL28JAbFrBGRUkoN28k0LfwMb5+MvvllcQEcfGIeu5YYBXg8KaBvOe/UYaq
	rPOmV8Ws8v0WAc6aY3Ulyg03QSMRCQrkU1G21+kZJWo108rvUM6pKJvx56sPKZLXT8gUEam4eX
	gi6OYklsq2oOLdNQLuRU5Teb
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	25 May 2021 14:03:14 -0700
IronPort-SDR: xWy5TXbJxL/WICIduGJeqXsWqGXSHJsOL1aq+twxCdZeMwkruoxv0K7xlBbzMzn8pAfV52XMmz
	2PTC51bhtyyMP+rV9vnOL0QIR7lALawp9nTy6RIppSzxcMFLxFvJxoHbS0MertIL4DNEz/3/Gv
	HN4I3h9XxYK8irIZeDUVxHCPBQNg7u8y2uTY8H3n3otPgJ6L8sBEa4hYqOjyn8uh/iAv34Hs5V
	jr7IIejAa5l8iNt/pxgf1oLx/4hahgss/vWSKjI4Yd3HHRLgAiY6HfxLFgIy1ufpCL23P+NuEU
	zn0=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip01.wdc.com with ESMTP; 25 May 2021 14:25:03 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Wed, 26 May 2021 06:24:50 +0900
Message-Id: <20210525212501.226888-1-damien.lemoal@wdc.com>
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
Subject: [dm-devel] [PATCH v5 00/11] dm: Improve zoned block device support
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

Changes from v4:
* Remove useless extra space in variable initialization in patch 1
* Shorten dm_accept_partial_bio() documentation comment in patch 4
* Added reviewed-by tags

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
 drivers/md/dm.c               | 201 +++--------
 drivers/md/dm.h               |  30 +-
 include/linux/blk_types.h     |   1 +
 include/linux/blkdev.h        |  12 +
 include/linux/device-mapper.h |   9 +-
 13 files changed, 954 insertions(+), 207 deletions(-)
 create mode 100644 drivers/md/dm-zone.c

-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

