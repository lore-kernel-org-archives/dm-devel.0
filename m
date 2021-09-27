Return-Path: <SRS0=coXp=OR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6019CC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 27 Sep 2021 22:00:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C34BE611F2
	for <dm-devel@archiver.kernel.org>; Mon, 27 Sep 2021 22:00:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C34BE611F2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-9hZcY-duPYWqlIBled7VgA-1; Mon, 27 Sep 2021 18:00:52 -0400
X-MC-Unique: 9hZcY-duPYWqlIBled7VgA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3DAE71006AA3;
	Mon, 27 Sep 2021 22:00:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2123B5C1BB;
	Mon, 27 Sep 2021 22:00:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E4ABC4EA2A;
	Mon, 27 Sep 2021 22:00:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18RM0WVR025856 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 27 Sep 2021 18:00:32 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id F38561112868; Mon, 27 Sep 2021 22:00:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EF5A8100CA53
	for <dm-devel@redhat.com>; Mon, 27 Sep 2021 22:00:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8B9E180F6E1
	for <dm-devel@redhat.com>; Mon, 27 Sep 2021 22:00:31 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-149-XzZXQ5sKP8ikaGwTA2_-sQ-1; Mon, 27 Sep 2021 18:00:30 -0400
X-MC-Unique: XzZXQ5sKP8ikaGwTA2_-sQ-1
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2
	(Red Hat Linux)) id 1mUyfM-004SUt-Qa; Mon, 27 Sep 2021 22:00:04 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: axboe@kernel.dk, martin.petersen@oracle.com, jejb@linux.ibm.com,
	kbusch@kernel.org, sagi@grimberg.me, adrian.hunter@intel.com,
	beanhuo@micron.com, ulf.hansson@linaro.org, avri.altman@wdc.com,
	swboyd@chromium.org, agk@redhat.com, snitzer@redhat.com,
	josef@toxicpanda.com
Date: Mon, 27 Sep 2021 14:59:52 -0700
Message-Id: <20210927215958.1062466-1-mcgrof@kernel.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, bvanassche@acm.org, linux-scsi@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, ming.lei@redhat.com,
	hch@infradead.org, dm-devel@redhat.com, nbd@other.debian.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [dm-devel] [PATCH v4 0/6] block: first batch of add_disk() error
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is the first set of driver conversions to use the add_disk() error
handling. You can find these changes along with the entire 7th set of
driver conversions on my 20210927-for-axboe-add-disk-error-handling
branch [0].

Changes on this v4 since the last v3:

 - Rebased onto linux-next tag 20210927
 - I drop the patches already merged
 - Fix the scsi/sd, scsi/sr as noted by Ming Lei
 - md: rebased in light of "md: fix a lock order reversal in md_alloc"
 - Adds Reviewed / Acked by tags where appropriate. I didn't keep the
   review by Hannes on the scsi patches as those patches are now
   slightly fixed

[0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/log/?h=20210927-for-axboe-add-disk-error-handling

Luis Chamberlain (6):
  scsi/sd: add error handling support for add_disk()
  scsi/sr: add error handling support for add_disk()
  md: add error handling support for add_disk()
  dm: add add_disk() error handling
  loop: add error handling support for add_disk()
  nbd: add error handling support for add_disk()

 drivers/block/loop.c | 8 +++++++-
 drivers/block/nbd.c  | 6 +++++-
 drivers/md/dm.c      | 4 +++-
 drivers/md/md.c      | 6 +++++-
 drivers/scsi/sd.c    | 8 +++++++-
 drivers/scsi/sr.c    | 7 ++++++-
 6 files changed, 33 insertions(+), 6 deletions(-)

-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

