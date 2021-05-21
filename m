Return-Path: <SRS0=AQTU=KQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14FE3C433B4
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 03:01:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9040F6108D
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 03:01:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9040F6108D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-KrdT_h08Mfi1uu86SAouiQ-1; Thu, 20 May 2021 23:01:43 -0400
X-MC-Unique: KrdT_h08Mfi1uu86SAouiQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D2E0106BB2A;
	Fri, 21 May 2021 03:01:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C24985C261;
	Fri, 21 May 2021 03:01:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CF1391800BB8;
	Fri, 21 May 2021 03:01:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14L31R10013418 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 May 2021 23:01:27 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id F010520951A6; Fri, 21 May 2021 03:01:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EAFA820951A3
	for <dm-devel@redhat.com>; Fri, 21 May 2021 03:01:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6EF56185A79C
	for <dm-devel@redhat.com>; Fri, 21 May 2021 03:01:24 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-338-AMhPBSCtMWKVIlHBDD1ihg-1; Thu, 20 May 2021 23:01:22 -0400
X-MC-Unique: AMhPBSCtMWKVIlHBDD1ihg-1
IronPort-SDR: KQeHQ8mMHI9sf4HY+D+B7ZDsg3dlZGXkrFo/5eBblksd9p1ssvJnLFNCifvOZEEu58Vc9QLLFS
	Zeh17R9oYlAR0ua7Xv1wCxdv0gAfMzz9nkkmE/zDgFk2QVknEVreec4Tk8h2yykDl160+OWzZm
	rFKjA1YWMON/64kSwNRxbP2JBsZN8Bi5J/RIcXzVOMnfFveTi/p/o8qv7dRjp4+mqlGnkBd76l
	aRtI5TVPhRfvPEM3HvJ6Vdk6zCcLfViT9fqi4hTpY6dMt1+f2uyGFXyWWhdATq6GHz+pOXMH7b
	Nv0=
X-IronPort-AV: E=Sophos;i="5.82,313,1613404800"; d="scan'208";a="272871472"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 21 May 2021 11:01:23 +0800
IronPort-SDR: ZwDVSuzv2Y+ZwXHi/UyzsMP4DLzga1tIxkTEA6pvmBNFKyamYxl2OClFape1SrX0Q3TRv6BrVJ
	Nnol5CBVjfqQY2/S2fqlQ10pn780rOh+nd/XBrgLo2Ce9AdAYlq9tgH0aYDl8HPC/syRCBALt9
	03ZgYiuTPRR1HYEATGZfOPxA5ofS7OzufGzfOwvVhGI2VCSm2Dxrwjn65WGMFNAhAgvPZYXRF0
	+XDLqDkj2JNCBC/hckwJTM4tS48pX6ow3bZuXXklysdO/BUp0dZzcSt28oUtZezSGYwOsv2STr
	N2/cBNg6plJMEHeEfIcRGWck
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	20 May 2021 19:40:56 -0700
IronPort-SDR: G8GtJBclerJvhX1yly86IfVF6GTofO/iVFe1yIMjDh7WiizhIGHVjghuG6S6/jfl9MC6yo9/l0
	TXSKR144Tna19FuYAQLNIp0sK4pe7eeAyufFUdSp7gKtEn5iRSxz5tXfokgKns6hMib30CXOrq
	npEtXs68TM5d1p4+f5ntgiZOdYYwoIxaFE8vRgi4mxBA0Ow1zfJd3FSQMM3J4G0tFETN+rGyyB
	VDeSisecljL9OYeVOzIqwNfnR8UymPSZH0pkjrDcFvvcHn0oTT4Ab+T1DcLb5FgTgAYRWF/bJ8
	uBQ=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip02.wdc.com with ESMTP; 20 May 2021 20:01:20 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Fri, 21 May 2021 12:01:08 +0900
Message-Id: <20210521030119.1209035-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [PATCH v3 00/11] dm: Improve zoned block device support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

 block/blk-zoned.c             | 117 ++++--
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
 13 files changed, 953 insertions(+), 207 deletions(-)
 create mode 100644 drivers/md/dm-zone.c

-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

