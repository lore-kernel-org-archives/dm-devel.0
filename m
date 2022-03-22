Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 653B6C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 24 Mar 2022 15:34:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-327-K8SuIyyHOru4328Qrv87Fw-1; Thu, 24 Mar 2022 11:34:51 -0400
X-MC-Unique: K8SuIyyHOru4328Qrv87Fw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F433802A97;
	Thu, 24 Mar 2022 15:34:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 29B1441136E0;
	Thu, 24 Mar 2022 15:34:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B9FAB194034F;
	Thu, 24 Mar 2022 15:34:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 86F0A1947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 11:01:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7500E400E54A; Tue, 22 Mar 2022 11:01:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7107A40CF8EF
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 11:01:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E2AC53C01C08
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 11:01:19 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
 [185.176.79.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-79-YgQ46PhANFaJeUSO5K5bIA-1; Tue, 22 Mar 2022 07:01:18 -0400
X-MC-Unique: YgQ46PhANFaJeUSO5K5bIA-1
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.201])
 by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KN7PY4fsNz67Q1X;
 Tue, 22 Mar 2022 18:43:29 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Tue, 22 Mar 2022 11:45:39 +0100
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 22 Mar 2022 10:45:36 +0000
From: John Garry <john.garry@huawei.com>
To: <axboe@kernel.dk>, <damien.lemoal@opensource.wdc.com>,
 <bvanassche@acm.org>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
 <hch@lst.de>, <ming.lei@redhat.com>, <hare@suse.de>
Date: Tue, 22 Mar 2022 18:39:34 +0800
Message-ID: <1647945585-197349-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Thu, 24 Mar 2022 15:34:41 +0000
Subject: [dm-devel] [PATCH RFC 00/11] blk-mq/libata/scsi: SCSI driver
 tagging improvements
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
Cc: linux-scsi@vger.kernel.org, chenxiang66@hisilicon.com,
 John Garry <john.garry@huawei.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com,
 beanhuo@micron.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Currently SCSI low-level drivers are required to manage tags for commands
which do not come via the block layer - libata internal commands would be
an example of one of these.

There was some work to provide "reserved commands" support in such series
as https://lore.kernel.org/linux-scsi/20211125151048.103910-1-hare@suse.de/

This was based on allocating a request for the lifetime of the "internal"
command.

This series tries to solve that problem by not just allocating the request
but also sending it through the block layer, that being the normal flow
for a request. We need to do this as we may only poll completion of
requests through the block layer, so would need to do this for poll queue
support.

There is still scope to allocate commands just to get a tag as token as
that may suit some other scenarios, but it's not what we do here.

This series extends blk-mq to support a request queue having a custom set
of ops. In addition SCSI core code adds support for these type of requests.

This series does not include SCSI core handling for enabling reserved
tags per tagset, but that would be easy to add.

Based on mkp-scsi 5.18/scsi-staging @ 66daf3e6b993 

Please consider as an RFC for now. I think that the libata change has the
largest scope for improvement...

John Garry (11):
  blk-mq: Add blk_mq_init_queue_ops()
  scsi: core: Add SUBMITTED_BY_SCSI_CUSTOM_OPS
  libata: Send internal commands through the block layer
  scsi: libsas: Send SMP commands through the block layer
  scsi: libsas: Send TMF commands through the block layer
  scsi: core: Add scsi_alloc_request_hwq()
  scsi: libsas: Send internal abort commands through the block layer
  scsi: libsas: Change ATA support to deal with each qc having a SCSI
    command
  scsi: libsas: Add sas_task_to_unique_tag()
  scsi: libsas: Add sas_task_to_hwq()
  scsi: hisi_sas: Remove private tag management

 block/blk-mq.c                         |  23 +++-
 drivers/ata/libata-core.c              | 121 +++++++++++++------
 drivers/md/dm-rq.c                     |   2 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  66 +----------
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |   3 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |   3 +-
 drivers/scsi/libsas/sas_ata.c          |  11 +-
 drivers/scsi/libsas/sas_expander.c     |  38 ++++--
 drivers/scsi/libsas/sas_internal.h     |   1 +
 drivers/scsi/libsas/sas_scsi_host.c    | 153 ++++++++++++++++++++-----
 drivers/scsi/scsi_lib.c                |  14 +++
 include/linux/blk-mq.h                 |   5 +-
 include/scsi/libsas.h                  |   4 +-
 include/scsi/scsi_cmnd.h               |   4 +
 14 files changed, 298 insertions(+), 150 deletions(-)

-- 
2.26.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

