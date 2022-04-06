Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1373DC433F5
	for <dm-devel@archiver.kernel.org>; Wed,  6 Apr 2022 06:12:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-424-PFvVMc-qOoScNSzpO9lwiA-1; Wed, 06 Apr 2022 02:12:51 -0400
X-MC-Unique: PFvVMc-qOoScNSzpO9lwiA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 575223803506;
	Wed,  6 Apr 2022 06:12:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 467CB1415112;
	Wed,  6 Apr 2022 06:12:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CF7841947BBB;
	Wed,  6 Apr 2022 06:12:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A1B6E19451F3
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Apr 2022 06:12:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7EFBA1121319; Wed,  6 Apr 2022 06:12:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A4091121314
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 06:12:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5AE17811E78
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 06:12:44 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-8-opdjenBeOYaAn-IY2UhdRw-1; Wed, 06 Apr 2022 02:12:42 -0400
X-MC-Unique: opdjenBeOYaAn-IY2UhdRw-1
Received: from 213-225-3-188.nat.highway.a1.net ([213.225.3.188]
 helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1nbyu6-003zG4-UT; Wed, 06 Apr 2022 06:12:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  6 Apr 2022 08:12:23 +0200
Message-Id: <20220406061228.410163-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] cleanup bio_kmalloc v3
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
Cc: linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
 Mike Snitzer <snitzer@redhat.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
 Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com, target-devel@vger.kernel.org,
 David Sterba <dsterba@suse.com>, Phillip Lougher <phillip@squashfs.org.uk>,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Jens,

this series finishes off the bio allocation interface cleanups by dealing
with the weirdest member of the famility.  bio_kmalloc combines a kmalloc
for the bio and bio_vecs with a hidden bio_init call and magic cleanup
semantics.

This series moves a few callers away from bio_kmalloc and then turns
bio_kmalloc into a simple wrapper for a slab allocation of a bio and the
inline biovecs.  The callers need to manually call bio_init instead with
all that entails and the magic that turns bio_put into a kfree goes away
as well, allowing for a proper debug check in bio_put that catches
accidental use on a bio_init()ed bio.

Changes since v2:
 - rebased to 5.18-rc1
 - fix bio freeing in squashfs

Changes since v1:
 - update a pre-existing comment per maintainer suggestion

Diffstat:
 block/bio.c                        |   47 ++++++++++++++-----------------------
 block/blk-crypto-fallback.c        |   14 ++++++-----
 block/blk-map.c                    |   42 +++++++++++++++++++++------------
 drivers/block/pktcdvd.c            |   34 +++++++++++---------------
 drivers/md/bcache/debug.c          |   10 ++++---
 drivers/md/dm-bufio.c              |    9 +++----
 drivers/md/raid1.c                 |   12 ++++++---
 drivers/md/raid10.c                |   21 +++++++++++-----
 drivers/target/target_core_pscsi.c |   36 ++++------------------------
 fs/btrfs/disk-io.c                 |    8 +++---
 fs/btrfs/volumes.c                 |   11 --------
 fs/btrfs/volumes.h                 |    2 -
 fs/squashfs/block.c                |   14 +++--------
 include/linux/bio.h                |    2 -
 14 files changed, 116 insertions(+), 146 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

