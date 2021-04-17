Return-Path: <SRS0=ANAI=JO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A535BC433ED
	for <dm-devel@archiver.kernel.org>; Sat, 17 Apr 2021 02:34:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 299C661166
	for <dm-devel@archiver.kernel.org>; Sat, 17 Apr 2021 02:34:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 299C661166
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-q1OtxK2NPxuCDf_aGas5nQ-1; Fri, 16 Apr 2021 22:33:45 -0400
X-MC-Unique: q1OtxK2NPxuCDf_aGas5nQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A6B9501F0;
	Sat, 17 Apr 2021 02:33:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 92F555E1A4;
	Sat, 17 Apr 2021 02:33:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BF4011806D0F;
	Sat, 17 Apr 2021 02:33:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13H2XZWY031240 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Apr 2021 22:33:35 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id EFD9D2138CF5; Sat, 17 Apr 2021 02:33:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EA3AA2138CF3
	for <dm-devel@redhat.com>; Sat, 17 Apr 2021 02:33:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD2C41021E2A
	for <dm-devel@redhat.com>; Sat, 17 Apr 2021 02:33:29 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-160-PncEe6CTM0ejUryZhjUs3A-1; Fri, 16 Apr 2021 22:33:27 -0400
X-MC-Unique: PncEe6CTM0ejUryZhjUs3A-1
IronPort-SDR: rjOyBup0/2oxf+uCuEckBgCgs3a0e/chWbJ03OEwbT++J/9Irfv8/VvBqe3x672mRMIbY43hwU
	QyCObJMVdkOyQLQe5s6f7Y1nR2TNK5oyGC6QfifOH66axooTqBm4eYtDooZZrg0wF7Pr1Qz3F+
	US3uuUkKep6YPvk5MsVsXeQIUdqmadNSk5hbA8taIv/5UzyrOFx2d6hhf7Pi45SsBmOfGJAoMM
	2hNvwplzdg6C+cXUG22Q5PLrrD0kYwIWsw3BeZ5+/337eVd9j5NVAdV0Q0EI9OvRsihVXH91VT
	Nag=
X-IronPort-AV: E=Sophos;i="5.82,228,1613404800"; d="scan'208";a="164553494"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 17 Apr 2021 10:33:26 +0800
IronPort-SDR: ah3BW7R2ZC7HHfC0k7xNX3RKslxDNn6tP0TSQ73onME5rOB73KBORX77ugrqmGPFV/rhbrLbeg
	cLbu6Gq8av7+eTo3GL4zccToe3RKH0dOIDlY7qYSgiHxDJ9KjCQy3BU5icUgQLHlhuvFTd/Wtk
	XGxbT3WYresyjkHx/ZdpnL55vKCS87dbg0pOOWSWtxC9H1srD2w0JjSguBp7JQ+TzZ8EuDhFO9
	jki1AvT5RnE64hIzepaHRmgbvh563MHU9PJa5hpFbsKXrEs+ipEhO/A5qGxHfahtf1EGwMsKMv
	33QXD4PkXHOyY4Y1W6IJqSdW
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	16 Apr 2021 19:14:14 -0700
IronPort-SDR: 16C8yH8D/rdxr7PuzxuUa8rWesM6KtsM3HDeoMg5sHjMNQvboeWQIps+YwRvcomtoPwI1MlqpW
	jtUKTWfjkpWaBLNjN5xtPZuKGF4EOTxwjzXBqX1pWi0R8zPmCngifSjkXAeqAvXMy9NAI4LKZT
	f9KAxP0v20dDFF1Ae8+mSXucvh3MQe66TKjwZTiapM7cpv7MSLw49bM8YbT4PQ5+coB0yQiIBP
	Nf6yxq7YFcTDZpXsZ740QZx0uXdp4NshbQe/QyHeTBtItwgM4/uiFWqOvW+Hfb4m7ddW6kfsUA
	efs=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip01.wdc.com with ESMTP; 16 Apr 2021 19:33:24 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-fsdevel@vger.kernel.org
Date: Sat, 17 Apr 2021 11:33:20 +0900
Message-Id: <20210417023323.852530-1-damien.lemoal@wdc.com>
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
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [dm-devel] [PATCH v2 0/3] Fix dm-crypt zoned block device support
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

Mike,

Zone append BIOs (REQ_OP_ZONE_APPEND) always specify the start sector
of the zone to be written instead of the actual location sector to
write. The write location is determined by the device and returned to
the host upon completion of the operation.

This interface, while simple and efficient for writing into sequential
zones of a zoned block device, is incompatible with the use of sector
values to calculate a cypher block IV. All data written in a zone is
encrypted using an IV calculated from the first sectors of the zone,
but read operation will specify any sector within the zone, resulting
in an IV mismatch between encryption and decryption. Reads fail in that
case.

Using a single sector value (e.g. the zone start sector) for all read
and writes into a zone can solve this problem, but at the cost of
weakening the cypher chosen by the user. Emulating zone append using
regular writes would be another potential solution, but it is complex
and would add a lot of overhead.

Instead, to solve this problem, explicitly disable support for zone
append operations in dm-crypt if the target was setup using a cypher IV
mode using sector values. The null and random IV modes can still be used
with zone append operations. This lack of support for zone append is
exposed to the user by setting the dm-crypt target queue limit
max_zone_append_sectors to 0. This change is done in patches 1 and 2.

Patch 3 fixes zonefs to fall back to using regular write when
max_zone_append_sectors is 0 (Note: I can take this patch through the
zonefs tree. But since I have nothing else for an eventual rc8 and next
cycle, you can take it too. No chance of conflict).

Overall, these changes do not break user space:
1) There is no interface allowing a user to use zone append write
without a file system. So applications using directly a raw dm-crypt
device will continue working using regular write operations.
2) btrfs zoned support was added in 5.12. Anybody trying btrfs-zoned on
top of dm-crypt would have faced the read failures already. So there
are no existing deployments to preserve. Same for zonefs.

For file systems, using zone append with encryption will need to be
supported within the file system (e.g. fscrypt). In this case, cypher IV
calculation can rely for instance on file block offsets as these are
known before a zone append operation write these blocks to disk at
unknown locations.

Reviews and comments are very much welcome.

Changes from v1:
* Addressed Johannes comments by renaming the CRYPT_IV_NO_SECTORS flag
  to CRYPT_IV_ZONE_APPEND to avoid a double negation with !test_bit().
  This also clarifies that the flag is used solely to check zone append
  support.
* Removed btrfs patch (former patch 3) as David is taking that patch
  through the btrfs tree misc-next branch.
* Added reviewed-by, Fixes and Cc tags.

Damien Le Moal (3):
  dm: Introduce zone append support control
  dm crypt: Fix zoned block device support
  zonefs: fix synchronous write to sequential zone files

 drivers/md/dm-crypt.c         | 49 ++++++++++++++++++++++++++++-------
 drivers/md/dm-table.c         | 41 +++++++++++++++++++++++++++++
 fs/zonefs/super.c             | 16 +++++++++---
 fs/zonefs/zonefs.h            |  2 ++
 include/linux/device-mapper.h |  6 +++++
 5 files changed, 101 insertions(+), 13 deletions(-)

-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

