Return-Path: <SRS0=t70f=OG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E693C433FE
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 17:25:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D0F756120D
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 17:25:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D0F756120D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-qFl9Rg9WPqajJ7i9KUnoMA-1; Thu, 16 Sep 2021 13:25:04 -0400
X-MC-Unique: qFl9Rg9WPqajJ7i9KUnoMA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E70B3DF8A0;
	Thu, 16 Sep 2021 17:24:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BA23100164C;
	Thu, 16 Sep 2021 17:24:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 88B1F4EA2A;
	Thu, 16 Sep 2021 17:24:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18GHOs8f010061 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 16 Sep 2021 13:24:55 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AA85AB578C; Thu, 16 Sep 2021 17:24:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A34E411F4BC
	for <dm-devel@redhat.com>; Thu, 16 Sep 2021 17:24:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DBFA9180138A
	for <dm-devel@redhat.com>; Thu, 16 Sep 2021 17:24:48 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-560-pN14BievMZKozYIst3kWKw-1;
	Thu, 16 Sep 2021 13:24:47 -0400
X-MC-Unique: pN14BievMZKozYIst3kWKw-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id F077160F50;
	Thu, 16 Sep 2021 17:24:45 +0000 (UTC)
From: Eric Biggers <ebiggers@kernel.org>
To: linux-block@vger.kernel.org
Date: Thu, 16 Sep 2021 10:22:45 -0700
Message-Id: <20210916172249.45813-1-ebiggers@kernel.org>
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
Cc: Satya Tangirala <satyaprateek2357@gmail.com>, dm-devel@redhat.com,
	linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [dm-devel] [PATCH v2 0/4] blk-crypto cleanups
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

This series renames struct blk_keyslot_manager to struct
blk_crypto_profile, as it is misnamed; it doesn't always manage
keyslots.  It's much more logical to think of it as the
"blk-crypto profile" of a device, similar to blk_integrity_profile.

This series also improves the inline-encryption.rst documentation file,
and cleans up blk-crypto-fallback a bit.

This series applies to v5.15-rc1.

Changed v1 => v2:
  - Fixed a build error in blk-integrity.c.
  - Removed a mention of "ksm" from a comment.
  - Dropped the patch "blk-crypto-fallback: consolidate static variables".
  - Added Acked-by and Reviewed-by tags.

Eric Biggers (4):
  blk-crypto-fallback: properly prefix function and struct names
  blk-crypto: rename keyslot-manager files to blk-crypto-profile
  blk-crypto: rename blk_keyslot_manager to blk_crypto_profile
  blk-crypto: update inline encryption documentation

 Documentation/block/inline-encryption.rst | 439 ++++++++--------
 block/Makefile                            |   2 +-
 block/blk-crypto-fallback.c               | 118 ++---
 block/blk-crypto-profile.c                | 564 +++++++++++++++++++++
 block/blk-crypto.c                        |  29 +-
 block/blk-integrity.c                     |   4 +-
 block/keyslot-manager.c                   | 578 ----------------------
 drivers/md/dm-core.h                      |   4 +-
 drivers/md/dm-table.c                     | 168 +++----
 drivers/md/dm.c                           |  10 +-
 drivers/mmc/core/crypto.c                 |  11 +-
 drivers/mmc/host/cqhci-crypto.c           |  33 +-
 drivers/scsi/ufs/ufshcd-crypto.c          |  32 +-
 drivers/scsi/ufs/ufshcd-crypto.h          |   9 +-
 drivers/scsi/ufs/ufshcd.c                 |   2 +-
 drivers/scsi/ufs/ufshcd.h                 |   6 +-
 include/linux/blk-crypto-profile.h        | 166 +++++++
 include/linux/blkdev.h                    |  18 +-
 include/linux/device-mapper.h             |   4 +-
 include/linux/keyslot-manager.h           | 120 -----
 include/linux/mmc/host.h                  |   4 +-
 21 files changed, 1194 insertions(+), 1127 deletions(-)
 create mode 100644 block/blk-crypto-profile.c
 delete mode 100644 block/keyslot-manager.c
 create mode 100644 include/linux/blk-crypto-profile.h
 delete mode 100644 include/linux/keyslot-manager.h


base-commit: 6880fa6c56601bb8ed59df6c30fd390cc5f6dd8f
-- 
2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

