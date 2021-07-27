Return-Path: <SRS0=tlLk=MT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D0DAC4320A
	for <dm-devel@archiver.kernel.org>; Tue, 27 Jul 2021 06:08:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 13C1561102
	for <dm-devel@archiver.kernel.org>; Tue, 27 Jul 2021 06:08:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 13C1561102
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-FFzmQzakO42wTbdu_1lgyw-1; Tue, 27 Jul 2021 02:08:13 -0400
X-MC-Unique: FFzmQzakO42wTbdu_1lgyw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20D3218C89E0;
	Tue, 27 Jul 2021 06:08:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 05D339C8CB;
	Tue, 27 Jul 2021 06:08:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CD0BF1804489;
	Tue, 27 Jul 2021 06:08:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16R6759l010371 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 27 Jul 2021 02:07:05 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 401EECF607; Tue, 27 Jul 2021 06:07:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3600ECF626
	for <dm-devel@redhat.com>; Tue, 27 Jul 2021 06:07:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6DCF2805A30
	for <dm-devel@redhat.com>; Tue, 27 Jul 2021 06:07:02 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-376-qsK_UltYO8ya1Paklp0Puw-1; Tue, 27 Jul 2021 02:07:00 -0400
X-MC-Unique: qsK_UltYO8ya1Paklp0Puw-1
Received: from [2001:4bb8:184:87c5:b7fb:1299:a9e5:ff56] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1m8G59-00EiCP-1F; Tue, 27 Jul 2021 05:57:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 27 Jul 2021 07:56:31 +0200
Message-Id: <20210727055646.118787-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
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
Cc: linux-arch@vger.kernel.org, linux-block@vger.kernel.org,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Mike Snitzer <snitzer@redhat.com>, Geoff Levand <geoff@infradead.org>,
	linuxppc-dev@lists.ozlabs.org, ceph-devel@vger.kernel.org,
	linux-mips@vger.kernel.org, Dongsheng Yang <dongsheng.yang@easystack.cn>,
	linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
	Ira Weiny <ira.weiny@intel.com>, Ilya Dryomov <idryomov@gmail.com>
Subject: [dm-devel] switch the block layer to use kmap_local_page v3
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

Hi all,

this series switches the core block layer code and all users of the
existing bvec kmap helpers to use kmap_local_page.  Drivers that
currently use open coded kmap_atomic calls will converted in a follow
on series.

To do so a new kunmap variant is added that calls
flush_kernel_dcache_page.  I'm not entirely sure where to call
flush_dcache_page vs flush_kernel_dcache_page, so I've tried to follow
the documentation here, but additional feedback would be welcome.

Note that the ps3disk has a minir conflict with the
flush_kernel_dcache_page removal in linux-next through the -mm tree.
I had hoped that change would go into 5.14, but it seems like it is
being held for 5.15.

Changes since v2:
 - rely on the flush_dcache_helpers in memcpy_to_page and memzero_page
   that now hit mainline

Changes since v1:
 - add more/better comments
 - add a new kunmap_local_dirty helper to feal with
   flush(_kernel)_dcache_page

Diffstat:
 arch/mips/include/asm/mach-rc32434/rb.h |    2 -
 block/bio-integrity.c                   |   14 +++-----
 block/bio.c                             |   37 ++++++----------------
 block/blk-map.c                         |    2 -
 block/bounce.c                          |   39 +++++-------------------
 block/t10-pi.c                          |   16 +++------
 drivers/block/ps3disk.c                 |   19 +----------
 drivers/block/rbd.c                     |   15 +--------
 drivers/md/dm-writecache.c              |    5 +--
 include/linux/bio.h                     |   42 -------------------------
 include/linux/bvec.h                    |   52 ++++++++++++++++++++++++++++++--
 include/linux/highmem-internal.h        |    7 ++++
 include/linux/highmem.h                 |   10 ++++--
 13 files changed, 102 insertions(+), 158 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

