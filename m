Return-Path: <SRS0=TigA=PD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 997AFC4167B
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 23:30:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2D7C3611C2
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 23:30:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2D7C3611C2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-geQW6gO0OsqfDOB-SFuUog-1; Fri, 15 Oct 2021 19:30:53 -0400
X-MC-Unique: geQW6gO0OsqfDOB-SFuUog-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F29A1005E4D;
	Fri, 15 Oct 2021 23:30:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 463A51973B;
	Fri, 15 Oct 2021 23:30:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DEAA74E58F;
	Fri, 15 Oct 2021 23:30:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19FNUh9Y015316 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 15 Oct 2021 19:30:43 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A091A2026D5D; Fri, 15 Oct 2021 23:30:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C3752026D46
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 23:30:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 529F9100E659
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 23:30:42 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-559-e0Fn8vHLMVSlFVTF_Yh0Pg-1; Fri, 15 Oct 2021 19:30:38 -0400
X-MC-Unique: e0Fn8vHLMVSlFVTF_Yh0Pg-1
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2
	(Red Hat Linux)) id 1mbWej-0095ur-55; Fri, 15 Oct 2021 23:30:29 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
	agk@redhat.com, snitzer@redhat.com, colyli@suse.de,
	kent.overstreet@gmail.com, boris.ostrovsky@oracle.com, jgross@suse.com, 
	sstabellini@kernel.org, roger.pau@citrix.com, geert@linux-m68k.org,
	ulf.hansson@linaro.org, tj@kernel.org, hare@suse.de, jdike@addtoit.com, 
	richard@nod.at, anton.ivanov@cambridgegreys.com,
	johannes.berg@intel.com, krisman@collabora.com,
	chris.obbard@collabora.com, thehajime@gmail.com,
	zhuyifei1999@gmail.com, haris.iqbal@ionos.com, jinpu.wang@ionos.com,
	miquel.raynal@bootlin.com, vigneshr@ti.com, linux-mtd@lists.infradead.org
Date: Fri, 15 Oct 2021 16:30:19 -0700
Message-Id: <20211015233028.2167651-1-mcgrof@kernel.org>
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
Cc: linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-um@lists.infradead.org, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Luis Chamberlain <mcgrof@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: [dm-devel] [PATCH 0/9] block: reviewed add_disk() error handling set
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Jens,

I had last split up patches into 7 groups, but at this point now
most changes are merged except a few more drivers. Instead of creating
a new patch set for each of the 7 groups I'm creating 3 new groups of
patches now:

  * This set, for which we already have an Acked-by or Reviewed-by tag,
    it would be nice to get clarification of driver maintainers want
    these to go through you or if a the maintainers want to pick these
    changes up themselves.

  * A second set will deal with patches which have no reviews done for
    them yet 

  * The last set deals with the __register_blkdev() change and the
    __must_check change which ensures we don't let in new drivers
    which don't deal with error handling.

If you're a maintainer of any of the below patches and wish for them to
go through Jens' tree directly now would be a good time to say so or
you can just pick the patch up yourself.

Luis Chamberlain (9):
  scsi/sd: add error handling support for add_disk()
  scsi/sr: add error handling support for add_disk()
  dm: add add_disk() error handling
  bcache: add error handling support for add_disk()
  xen-blkfront: add error handling support for add_disk()
  m68k/emu/nfblock: add error handling support for add_disk()
  um/drivers/ubd_kern: add error handling support for add_disk()
  rnbd: add error handling support for add_disk()
  mtd: add add_disk() error handling

 arch/m68k/emu/nfblock.c       |  9 +++++++--
 arch/um/drivers/ubd_kern.c    | 13 +++++++++----
 drivers/block/rnbd/rnbd-clt.c | 13 +++++++++----
 drivers/block/xen-blkfront.c  |  8 +++++++-
 drivers/md/bcache/super.c     | 17 ++++++++++++-----
 drivers/md/dm.c               |  4 +++-
 drivers/mtd/mtd_blkdevs.c     |  6 +++++-
 drivers/scsi/sd.c             |  8 +++++++-
 drivers/scsi/sr.c             |  7 ++++++-
 9 files changed, 65 insertions(+), 20 deletions(-)

-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

