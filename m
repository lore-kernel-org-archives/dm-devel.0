Return-Path: <SRS0=4ZGW=NV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A63CDC43216
	for <dm-devel@archiver.kernel.org>; Mon, 30 Aug 2021 21:30:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 49B3661039
	for <dm-devel@archiver.kernel.org>; Mon, 30 Aug 2021 21:30:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 49B3661039
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-wwJda_xjNuWZie-bUgYRzA-1; Mon, 30 Aug 2021 17:29:57 -0400
X-MC-Unique: wwJda_xjNuWZie-bUgYRzA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F9961051474;
	Mon, 30 Aug 2021 21:29:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 76BD36A8FF;
	Mon, 30 Aug 2021 21:29:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5143C181A0F7;
	Mon, 30 Aug 2021 21:29:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17ULQE0P008674 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Aug 2021 17:26:14 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BD8322031A5B; Mon, 30 Aug 2021 21:26:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B9565201C0DE
	for <dm-devel@redhat.com>; Mon, 30 Aug 2021 21:26:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2CEA800883
	for <dm-devel@redhat.com>; Mon, 30 Aug 2021 21:26:14 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-284-3kE9r-LsNYGRKB01nQ6ByA-1; Mon, 30 Aug 2021 17:26:10 -0400
X-MC-Unique: 3kE9r-LsNYGRKB01nQ6ByA-1
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2
	(Red Hat Linux)) id 1mKomk-000ci4-DU; Mon, 30 Aug 2021 21:25:42 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: axboe@kernel.dk, martin.petersen@oracle.com, jejb@linux.ibm.com,
	kbusch@kernel.org, sagi@grimberg.me, adrian.hunter@intel.com,
	beanhuo@micron.com, ulf.hansson@linaro.org, avri.altman@wdc.com,
	swboyd@chromium.org, agk@redhat.com, snitzer@redhat.com,
	josef@toxicpanda.com
Date: Mon, 30 Aug 2021 14:25:30 -0700
Message-Id: <20210830212538.148729-1-mcgrof@kernel.org>
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
Cc: linux-block@vger.kernel.org, bvanassche@acm.org, linux-scsi@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, ming.lei@redhat.com,
	hch@infradead.org, dm-devel@redhat.com, nbd@other.debian.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [dm-devel] [PATCH v3 0/8] block: first batch of add_disk() error
	handling conversions
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

Jens,

I think this first set is ready, but pending review of just two patches:

  * mmc/core/block
  * dm

All other patches have a respective Reviewed-by tag. The above two
patches were integrated back into the series once I understood
Christoph's concerns, and adjusted the patch as such.

This goes rebased onto your for-next as of today. If anyone wants to
explore the pending full set this is up on my linux-next branch
20210830-for-axboe-add-disk-error-handling-next [0].

[0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/log/?h=20210830-for-axboe-add-disk-error-handling-next

Luis Chamberlain (8):
  scsi/sd: add error handling support for add_disk()
  scsi/sr: add error handling support for add_disk()
  nvme: add error handling support for add_disk()
  mmc/core/block: add error handling support for add_disk()
  md: add error handling support for add_disk()
  dm: add add_disk() error handling
  loop: add error handling support for add_disk()
  nbd: add error handling support for add_disk()

 drivers/block/loop.c     | 9 ++++++++-
 drivers/block/nbd.c      | 6 +++++-
 drivers/md/dm.c          | 4 +++-
 drivers/md/md.c          | 7 ++++++-
 drivers/mmc/core/block.c | 7 ++++++-
 drivers/nvme/host/core.c | 9 ++++++++-
 drivers/scsi/sd.c        | 6 +++++-
 drivers/scsi/sr.c        | 5 ++++-
 8 files changed, 45 insertions(+), 8 deletions(-)

-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

