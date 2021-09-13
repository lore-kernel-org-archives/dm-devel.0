Return-Path: <SRS0=4gQq=OD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98C4AC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 13 Sep 2021 01:41:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D26CC6108E
	for <dm-devel@archiver.kernel.org>; Mon, 13 Sep 2021 01:41:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D26CC6108E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-Pq10Y8CmNnWjG2ae0BRJBQ-1; Sun, 12 Sep 2021 21:41:50 -0400
X-MC-Unique: Pq10Y8CmNnWjG2ae0BRJBQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9EA8835DE0;
	Mon, 13 Sep 2021 01:41:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CD775D9D5;
	Mon, 13 Sep 2021 01:41:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C7272180142F;
	Mon, 13 Sep 2021 01:41:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18D1fd02003361 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 12 Sep 2021 21:41:39 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3B6082167D6D; Mon, 13 Sep 2021 01:41:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 351F42167D6F
	for <dm-devel@redhat.com>; Mon, 13 Sep 2021 01:41:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3171B8934E0
	for <dm-devel@redhat.com>; Mon, 13 Sep 2021 01:41:36 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-46-9viMAC0VMnufBS28HP0UcQ-1; 
	Sun, 12 Sep 2021 21:41:34 -0400
X-MC-Unique: 9viMAC0VMnufBS28HP0UcQ-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0EB660FDA;
	Mon, 13 Sep 2021 01:35:26 +0000 (UTC)
From: Eric Biggers <ebiggers@kernel.org>
To: linux-block@vger.kernel.org
Date: Sun, 12 Sep 2021 18:31:30 -0700
Message-Id: <20210913013135.102404-1-ebiggers@kernel.org>
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
Cc: Satya Tangirala <satyaprateek2357@gmail.com>, dm-devel@redhat.com,
	linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [dm-devel] [PATCH 0/5] blk-crypto cleanups
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

This series renames struct blk_keyslot_manager to struct
blk_crypto_profile, as it is misnamed; it doesn't always manage
keyslots.  It's much more logical to think of it as the
"blk-crypto profile" of a device, similar to blk_integrity_profile.

This series also improves the inline-encryption.rst documentation file,
and cleans up blk-crypto-fallback a bit.

This series applies to v5.15-rc1.

Eric Biggers (5):
  blk-crypto-fallback: properly prefix function and struct names
  blk-crypto-fallback: consolidate static variables
  blk-crypto: rename keyslot-manager files to blk-crypto-profile
  blk-crypto: rename blk_keyslot_manager to blk_crypto_profile
  blk-crypto: update inline encryption documentation

 Documentation/block/inline-encryption.rst | 439 ++++++++--------
 block/Makefile                            |   2 +-
 block/blk-crypto-fallback.c               | 330 ++++++------
 block/blk-crypto-profile.c                | 564 +++++++++++++++++++++
 block/blk-crypto.c                        |  27 +-
 block/blk-integrity.c                     |   2 +-
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
 21 files changed, 1310 insertions(+), 1219 deletions(-)
 create mode 100644 block/blk-crypto-profile.c
 delete mode 100644 block/keyslot-manager.c
 create mode 100644 include/linux/blk-crypto-profile.h
 delete mode 100644 include/linux/keyslot-manager.h

-- 
2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

