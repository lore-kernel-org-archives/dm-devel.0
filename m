Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 244E4C433FE
	for <dm-devel@archiver.kernel.org>; Wed, 20 Apr 2022 07:22:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-75K4xwLFM52XrKhEq1Auvw-1; Wed, 20 Apr 2022 03:22:00 -0400
X-MC-Unique: 75K4xwLFM52XrKhEq1Auvw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D10443804511;
	Wed, 20 Apr 2022 07:21:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B324A401E1D;
	Wed, 20 Apr 2022 07:21:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6F4B81940340;
	Wed, 20 Apr 2022 07:21:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C792019452D2
 for <dm-devel@listman.corp.redhat.com>; Wed, 20 Apr 2022 07:21:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CAD22572345; Wed, 20 Apr 2022 07:21:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C71A1572322
 for <dm-devel@redhat.com>; Wed, 20 Apr 2022 07:21:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 589D6296A60F
 for <dm-devel@redhat.com>; Wed, 20 Apr 2022 07:21:55 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-424-N-xGKTQeOiGIs9voBHoaeQ-1; Wed, 20 Apr 2022 03:21:50 -0400
X-MC-Unique: N-xGKTQeOiGIs9voBHoaeQ-1
Received: from [2001:4bb8:191:364b:4299:55c7:4b14:f042] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1nh47x-007cXh-3O; Wed, 20 Apr 2022 06:47:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Eric Biggers <ebiggers@google.com>
Date: Wed, 20 Apr 2022 08:47:43 +0200
Message-Id: <20220420064745.1119823-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] fix blk_crypto_profile liftetime
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, linux-scsi@vger.kernel.org,
 linux-mmc@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Ritesh Harjani <riteshh@codeaurora.org>, linux-block@vger.kernel.org,
 Avri Altman <avri.altman@wdc.com>, dm-devel@redhat.com,
 Alim Akhtar <alim.akhtar@samsung.com>, Asutosh Das <asutoshd@codeaurora.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi all,

the newly added blk-crypto sysfs support does not seem to keep the
blk_crypto_profile lifetimes aligned to what sysfs expects.

This was found by code inspection only and is completely untested.

Diffstat:
 b/Documentation/block/inline-encryption.rst |   10 -
 b/block/Makefile                            |    3 
 b/block/blk-crypto-fallback.c               |   20 +-
 b/block/blk-crypto-profile.c                |  263 ++++++++++++++++++++++------
 b/drivers/md/dm-table.c                     |   28 --
 b/drivers/mmc/core/crypto.c                 |    4 
 b/drivers/mmc/host/cqhci-crypto.c           |   16 -
 b/drivers/scsi/ufs/ufshcd-crypto.c          |   31 +--
 b/drivers/scsi/ufs/ufshcd.h                 |    2 
 b/include/linux/blk-crypto-profile.h        |   19 +-
 b/include/linux/blkdev.h                    |    1 
 b/include/linux/mmc/host.h                  |    2 
 block/blk-crypto-sysfs.c                    |  172 ------------------
 13 files changed, 265 insertions(+), 306 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

