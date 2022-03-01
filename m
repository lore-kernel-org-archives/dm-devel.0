Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A53B4C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  1 Mar 2022 08:46:22 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-130-m8J3aEckPGKSNR3zciwUUQ-1; Tue, 01 Mar 2022 03:46:18 -0500
X-MC-Unique: m8J3aEckPGKSNR3zciwUUQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D208180A088;
	Tue,  1 Mar 2022 08:46:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 80AD962D56;
	Tue,  1 Mar 2022 08:46:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3B48F1809C98;
	Tue,  1 Mar 2022 08:46:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2218k6aR028953 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Mar 2022 03:46:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DD69976C2; Tue,  1 Mar 2022 08:46:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D78437773
	for <dm-devel@redhat.com>; Tue,  1 Mar 2022 08:46:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C277800883
	for <dm-devel@redhat.com>; Tue,  1 Mar 2022 08:46:03 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-127-LKBciGh5O-eftqCEL-0PdA-1; Tue, 01 Mar 2022 03:45:59 -0500
X-MC-Unique: LKBciGh5O-eftqCEL-0PdA-1
Received: from [2.53.44.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nOy8p-00FfOp-B9; Tue, 01 Mar 2022 08:45:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue,  1 Mar 2022 10:45:47 +0200
Message-Id: <20220301084552.880256-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
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
Cc: linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
	Mike Snitzer <snitzer@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	target-devel@vger.kernel.org, David Sterba <dsterba@suse.com>,
	Phillip Lougher <phillip@squashfs.org.uk>, linux-btrfs@vger.kernel.org
Subject: [dm-devel] cleanup bio_kmalloc
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

