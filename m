Return-Path: <SRS0=cPWn=JN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1E14C433B4
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 03:06:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2171B61184
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 03:06:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2171B61184
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-itjicAIIMUC9rc4ChQ3lhw-1; Thu, 15 Apr 2021 23:06:16 -0400
X-MC-Unique: itjicAIIMUC9rc4ChQ3lhw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC2C2107ACCA;
	Fri, 16 Apr 2021 03:06:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4730D6E403;
	Fri, 16 Apr 2021 03:06:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 69C9C44A5E;
	Fri, 16 Apr 2021 03:06:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13G364O0030560 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 15 Apr 2021 23:06:05 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B854421111CB; Fri, 16 Apr 2021 03:06:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B277B21111C6
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 03:06:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2DE2185A7A7
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 03:06:01 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-557-JETZeSCzPb6wm89CgCp7fg-1; Thu, 15 Apr 2021 23:05:59 -0400
X-MC-Unique: JETZeSCzPb6wm89CgCp7fg-1
IronPort-SDR: 8ENQWT7rJq5z3pdl36rsERrN/Tz+rU/fsmEbo3LzHZJPBUVN3sFWlzf/+8q+bLQnfc0xnlab4T
	eQ9ccaUTajx+joRZMeJOKHq49TjLcelslCXtFQtWaZi/aGyMPVIJehEgsnSOan1RR9irmv2wV3
	T0OHZj6VhjL7K0NOZ5Vcf+aJnMylJJfO00uBOHkME7rjazurr84rtlrwTIoIDV40rTEo5BXgEi
	42IsBdY/2g6Km7Mg/dRTc2+l51HgtrWjaQz3MHb3//w+MBm7An0pVxiY3U2cn3xDkAm/hFfbYG
	RoA=
X-IronPort-AV: E=Sophos;i="5.82,226,1613404800"; d="scan'208";a="165604456"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 16 Apr 2021 11:05:41 +0800
IronPort-SDR: OEdsf1L/PPT5j629DHyohVCOSEQeeQC66EKcN9LDPmDQTRnielOoWqkgnl0fGTWyOtG4BZrGFH
	Uevw1W+L6JMFkk8Cd6jRypK8uM2yHspQw3guJra0ZWvaw5W7102zrhZsYFNwRY8gEwbLA/INf6
	zuah8QzLcVpzXaOJh8yg7e1AeAFNYMGOl1AV4D7sM/BV0utX+838fPd6aCbyhDS1oXujmH18JM
	sMpc85tR06NEMGxOxCDYbweafEZJEuEiF99KqLdhgLOFWWvQECQZ81CGgH/ew7nAiNxNgCcC5P
	ewcyiOypkkS4dVI6wD0V66iz
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	15 Apr 2021 19:46:24 -0700
IronPort-SDR: 5uaHx0ME4yfxIf/TiutCrTMnLjb2kBOpJtRTKSLg4tH5AbhRWHekMEEGKLa3AXqEYy3a31snCo
	ElUXAQxKJQa6aOhWFDCPzlc/IpBsAx5KR6EDXe2ZmlnAA88cCbpAMSRLACPaVf/fHSYLQd8IgO
	DxavW3RSuugPmrGUFvYDSFHbIBbCHilMvHw4PQpzJEgqusd0uGMzfwXRxK2a2urB4I+6r1cg8f
	s/TX9LXikk5YOZaAYTcUE+pTyB5gwDGLNtSP+JbbsKm5Z1xjY+x4TV2Bu/ZpK3jUK5XA0aSsC7
	IoM=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip02.wdc.com with ESMTP; 15 Apr 2021 20:05:29 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>
Date: Fri, 16 Apr 2021 12:05:24 +0900
Message-Id: <20210416030528.757513-1-damien.lemoal@wdc.com>
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
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>
Subject: [dm-devel] [PATCH 0/4] Fix dm-crypt zoned block device support
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
max_zone_append_sectors to 0. This change is done in patch 1 and 2.

Patch 3 addresses btrfs-zoned case. Zone append write are used for all
file data blocks write. The change introduced fails mounting a zoned
btrfs volume if the underlying device max_zone_append_sectors limit is
0.

Patch 4 fixes zonefs to fall back to using regular write when
max_zone_append_sectors is 0.

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

Damien Le Moal (3):
  dm: Introduce zone append support control
  dm crypt: Fix zoned block device support
  zonefs: fix synchronous write to sequential zone files

Johannes Thumshirn (1):
  btrfs: zoned: fail mount if the device does not support zone append

 drivers/md/dm-crypt.c         | 48 ++++++++++++++++++++++++++++-------
 drivers/md/dm-table.c         | 41 ++++++++++++++++++++++++++++++
 fs/btrfs/zoned.c              |  7 +++++
 fs/zonefs/super.c             | 16 +++++++++---
 fs/zonefs/zonefs.h            |  2 ++
 include/linux/device-mapper.h |  6 +++++
 6 files changed, 107 insertions(+), 13 deletions(-)

-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

