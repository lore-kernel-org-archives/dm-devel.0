Return-Path: <SRS0=xPb5=LF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A3BBC48BE5
	for <dm-devel@archiver.kernel.org>; Fri, 11 Jun 2021 20:39:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0A7B1613CD
	for <dm-devel@archiver.kernel.org>; Fri, 11 Jun 2021 20:39:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A7B1613CD
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-k8ASUvndOralU-aDqWDQ1w-1; Fri, 11 Jun 2021 16:39:44 -0400
X-MC-Unique: k8ASUvndOralU-aDqWDQ1w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87F9B802B4F;
	Fri, 11 Jun 2021 20:39:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6CB61136F5;
	Fri, 11 Jun 2021 20:39:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2637C1809CAF;
	Fri, 11 Jun 2021 20:39:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15BKdJoI007825 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Jun 2021 16:39:19 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8571516C8F2; Fri, 11 Jun 2021 20:39:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8037816C8F0
	for <dm-devel@redhat.com>; Fri, 11 Jun 2021 20:39:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C9CA80122D
	for <dm-devel@redhat.com>; Fri, 11 Jun 2021 20:39:16 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-450-KclwLcIANG6WZNYJnsz-0A-1; Fri, 11 Jun 2021 16:39:11 -0400
X-MC-Unique: KclwLcIANG6WZNYJnsz-0A-1
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128
	bits)) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9DB921FD6D;
	Fri, 11 Jun 2021 20:39:09 +0000 (UTC)
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
	by imap.suse.de (Postfix) with ESMTP id 494C1118DD;
	Fri, 11 Jun 2021 20:39:09 +0000 (UTC)
Received: from director2.suse.de ([192.168.254.72]) by imap3-int with ESMTPSA
	id 7BwmEO3Jw2BGEgAALh3uQQ
	(envelope-from <mwilck@suse.com>); Fri, 11 Jun 2021 20:39:09 +0000
From: mwilck@suse.com
To: Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
	Bart Van Assche <Bart.VanAssche@sandisk.com>, dm-devel@redhat.com,
	Hannes Reinecke <hare@suse.de>
Date: Fri, 11 Jun 2021 22:25:07 +0200
Message-Id: <20210611202509.5426-1-mwilck@suse.com>
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
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 15BKdJoI007825
X-loop: dm-devel@redhat.com
Cc: Daniel Wagner <dwagner@suse.de>, Martin Wilck <mwilck@suse.com>,
	linux-block@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [dm-devel] [PATCH v3 0/2] dm: dm_blk_ioctl(): implement failover
	for SG_IO on dm-multipath
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

From: Martin Wilck <mwilck@suse.com>

Hello Mike,

here is v3 of my attempt to add retry logic to SG_IO on dm-multipath devices.
Sorry that it took such a long time.

Regards
Martin

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

Martin Wilck (2):
  scsi: export __scsi_result_to_blk_status() in scsi_ioctl.c
  dm: add CONFIG_DM_MULTIPATH_SG_IO - failover for SG_IO on dm-multipath

 block/scsi_ioctl.c         |  52 ++++++++++++++-
 drivers/md/Kconfig         |  11 ++++
 drivers/md/Makefile        |   4 ++
 drivers/md/dm-core.h       |   5 ++
 drivers/md/dm-rq.h         |  11 ++++
 drivers/md/dm-scsi_ioctl.c | 127 +++++++++++++++++++++++++++++++++++++
 drivers/md/dm.c            |  20 +++++-
 drivers/scsi/scsi_lib.c    |  29 +--------
 include/linux/blkdev.h     |   3 +
 9 files changed, 229 insertions(+), 33 deletions(-)
 create mode 100644 drivers/md/dm-scsi_ioctl.c

-- 
2.31.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

