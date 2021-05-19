Return-Path: <SRS0=a9Kz=KO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 804B5C433B4
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 02:58:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 090AB6124C
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 02:58:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 090AB6124C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-6_kZahqNMUumjWefvpn2RA-1; Tue, 18 May 2021 22:58:18 -0400
X-MC-Unique: 6_kZahqNMUumjWefvpn2RA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1AA401007476;
	Wed, 19 May 2021 02:58:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BC1CB5D71D;
	Wed, 19 May 2021 02:58:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1FB0A1801028;
	Wed, 19 May 2021 02:58:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14J2tbJv029422 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 18 May 2021 22:55:38 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 48FEE2077FD9; Wed, 19 May 2021 02:55:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4452D2077FB8
	for <dm-devel@redhat.com>; Wed, 19 May 2021 02:55:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2BECB101A531
	for <dm-devel@redhat.com>; Wed, 19 May 2021 02:55:34 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-472-1MQf1fNRMYSTDZTLeuCmoA-1; Tue, 18 May 2021 22:55:31 -0400
X-MC-Unique: 1MQf1fNRMYSTDZTLeuCmoA-1
IronPort-SDR: Su6gmZ9cgbaDVyYGc+agb74mgAqGjxoXHJ2yfb1FP008SpnS2srGe33tKsnjVPj+820ZD6PHw6
	NGZXilyBj3zQaSCe/Ad/dRzW9tQTydxwDve5GnHP7L1RzPHdEJWmkwh5JDj1NlqX3sDB0bfexP
	6tGa4TWiuj3QSTBS18CPDxnNoOQgS1xBbOb44cyBXMwBY6NKU8jRZCcgB4axIPfhrkUn16F8fl
	t942PRKenqsKBmTxIhZ6OdyJ7bznEEYtkqgfjcVMPR6x5SXPV6LdEO+p87yi7+WmWY5cGeZQ0a
	Pmc=
X-IronPort-AV: E=Sophos;i="5.82,311,1613404800"; d="scan'208";a="169197389"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 10:55:31 +0800
IronPort-SDR: tVb1yUlZ3Ma5pDm9dk6+rRbfIS+bFWW2YG4G0/A8dm1VNkpmOQ2oL9Sys59mtK1rrdkHtrFVsV
	7HPt3XLphzEaQ3dlXeRz2OvaA3awj/Ea4iS3qbosTt+AhTNeJ3IBkiQYiyNSfYTOp9JnGDa1Jf
	oMwxiLrKh2DH8zvsWJawMDCT+M7hc00EqMvTACOKFft1uUqsEEVklxKbjefxcWy2TxMn15ejwd
	knJ+i+Jx/1Zziv4KaKkb9dc+G0u8wR4AxLiCybhQUu1o//pEeE1/VsYyA7jrNCsh/zazp+7BcT
	2AnTHAWM3vNGIJuDSTOP68t5
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 May 2021 19:33:55 -0700
IronPort-SDR: CuvPZHrPla/TVDDGGoSewdiLJMlRfKOvCYdPzeqA8RxHcPVR2dl0IOkV5qhlQo+JZZJjwj8sJB
	DPIxlEKaBfxGAA0vzHGDJ+O/T8v2MFdHDO/d/x5KRnfq1VEsQEY6IHN06gPMph399cgo8XPatK
	aJbQ6oqP2XxH8mX1HABAbpt9K29cK5gwDBhbrPUyRGrOfyZWMa/4DOLjDpEAUNUKtu8BDNqEK7
	Q7wG+15WcWgSvyIIXaCvXEuNievVKCcxMiB1HP0yY7fhnYh2EOMxB17wVLcjQ10A/OiUcjQQY/
	Ik8=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 May 2021 19:55:29 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Wed, 19 May 2021 11:55:18 +0900
Message-Id: <20210519025529.707897-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
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
Subject: [dm-devel] [PATCH 00/11] dm: Improve zoned block device support
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

 block/blk-zoned.c             |  87 +++--
 drivers/md/Makefile           |   4 +
 drivers/md/dm-core.h          |  66 ++++
 drivers/md/dm-crypt.c         |  31 +-
 drivers/md/dm-flakey.c        |   7 +-
 drivers/md/dm-linear.c        |   7 +-
 drivers/md/dm-table.c         |  21 +-
 drivers/md/dm-zone.c          | 691 ++++++++++++++++++++++++++++++++++
 drivers/md/dm.c               | 203 +++-------
 drivers/md/dm.h               |  32 +-
 include/linux/blk_types.h     |   1 +
 include/linux/blkdev.h        |  12 +
 include/linux/device-mapper.h |   9 +-
 13 files changed, 967 insertions(+), 204 deletions(-)
 create mode 100644 drivers/md/dm-zone.c

-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

