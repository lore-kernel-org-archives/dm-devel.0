Return-Path: <SRS0=s8Rv=LW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B794C49EA3
	for <dm-devel@archiver.kernel.org>; Mon, 28 Jun 2021 15:17:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8B36A61982
	for <dm-devel@archiver.kernel.org>; Mon, 28 Jun 2021 15:17:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B36A61982
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-8KbghXBXP96XLodLZS_8rA-1; Mon, 28 Jun 2021 11:17:40 -0400
X-MC-Unique: 8KbghXBXP96XLodLZS_8rA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 418C511279E2;
	Mon, 28 Jun 2021 15:17:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E2CFA5C230;
	Mon, 28 Jun 2021 15:17:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E53921809C9A;
	Mon, 28 Jun 2021 15:17:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15SFHVFE006256 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 28 Jun 2021 11:17:31 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 14A421007BA7; Mon, 28 Jun 2021 15:17:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F18E1134CD1
	for <dm-devel@redhat.com>; Mon, 28 Jun 2021 15:17:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 036151801386
	for <dm-devel@redhat.com>; Mon, 28 Jun 2021 15:17:26 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-14-YjCEY3lONXWfznpjzSnyHA-1; Mon, 28 Jun 2021 11:17:21 -0400
X-MC-Unique: YjCEY3lONXWfznpjzSnyHA-1
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128
	bits)) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4F93F22469;
	Mon, 28 Jun 2021 15:17:19 +0000 (UTC)
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
	by imap.suse.de (Postfix) with ESMTP id D421D11906;
	Mon, 28 Jun 2021 15:17:18 +0000 (UTC)
Received: from director2.suse.de ([192.168.254.72]) by imap3-int with ESMTPSA
	id wRhVMv7n2WDaJwAALh3uQQ
	(envelope-from <mwilck@suse.com>); Mon, 28 Jun 2021 15:17:18 +0000
From: mwilck@suse.com
To: Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
	Bart Van Assche <Bart.VanAssche@sandisk.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, dm-devel@redhat.com,
	Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Date: Mon, 28 Jun 2021 17:15:55 +0200
Message-Id: <20210628151558.2289-1-mwilck@suse.com>
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
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 15SFHVFE006256
X-loop: dm-devel@redhat.com
Cc: Daniel Wagner <dwagner@suse.de>, emilne@redhat.com,
	linux-block@vger.kernel.org, nkoenig@redhat.com,
	Paolo Bonzini <pbonzini@redhat.com>, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v5 0/3] scsi/dm: dm_blk_ioctl(): implement
	failover for SG_IO on dm-multipath
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

From: Martin Wilck <mwilck@suse.com>

Hello Mike, hello Martin,

here is v5 of my attempt to add retry logic to SG_IO on dm-multipath
devices.

Christoph's comment on v4 has been received, but as I'm still confused
how to handle the SCSI result / blk_status_t conversion properly, and
waiting for more guidance, I want to fix the nasty bug in v4 first.

Regards
Martin

Changes v4->v5:

 - (2/3) Fixed bug in logical / bitwise and expression
   Reported-by: kernel test robot <lkp@intel.com>

Changes v3->v4 (thanks to Mike Snitzer):

 - Added an additional helper function sg_io_to_blk_status() to
   scsi_ioctl.c, in order to avoid open-coding handling of the SCSI result
   code in device-mapper.

 - Added a new method dm_sg_io_ioctl_fn() in struct target_type, define
   only by the multipath target. This allows moving the bulk of the new
   code to dm-mpath.c, and avoids the wrong limitation of the code to
   request-based multipath.

Changes v2->v3:

 - un-inlined scsi_result_to_blk_status again, and move the helper
   __scsi_result_to_blk_status to block/scsi_ioctl.c instead
   (Bart v. Assche)
 - open-coded the status/msg/host/driver-byte -> result conversion
   where the standard SCSI helpers aren't usable (Bart v. Assche)
    
Changes v1->v2:

 - applied modifications from Mike Snitzer
 - moved SG_IO dependent code to a separate file, no scsi includes in
   dm.c any more
 - made the new code depend on a configuration option 
 - separated out scsi changes, made scsi_result_to_blk_status()
   inline to avoid dependency of dm_mod from scsi_mod (Paolo Bonzini)

Martin Wilck (3):
  scsi: scsi_ioctl: export __scsi_result_to_blk_status()
  scsi: scsi_ioctl: add sg_io_to_blk_status()
  dm mpath: add CONFIG_DM_MULTIPATH_SG_IO - failover for SG_IO

Martin Wilck (3):
  scsi: scsi_ioctl: export __scsi_result_to_blk_status()
  scsi: scsi_ioctl: add sg_io_to_blk_status()
  dm mpath: add CONFIG_DM_MULTIPATH_SG_IO - failover for SG_IO

 block/scsi_ioctl.c            |  72 ++++++++++++++++++++++-
 drivers/md/Kconfig            |  11 ++++
 drivers/md/dm-core.h          |   5 ++
 drivers/md/dm-mpath.c         | 105 ++++++++++++++++++++++++++++++++++
 drivers/md/dm.c               |  26 ++++++++-
 drivers/scsi/scsi_lib.c       |  24 +-------
 include/linux/blkdev.h        |   4 ++
 include/linux/device-mapper.h |   8 ++-
 8 files changed, 226 insertions(+), 29 deletions(-)

-- 
2.32.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

