Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC98CC433EF
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 07:23:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4ADAA61157
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 07:23:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4ADAA61157
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-V1v9iklmMUKKc43Ijbe-AA-1; Thu, 04 Nov 2021 03:23:06 -0400
X-MC-Unique: V1v9iklmMUKKc43Ijbe-AA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D9975074C;
	Thu,  4 Nov 2021 07:22:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 462F15E272;
	Thu,  4 Nov 2021 07:22:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 23AF9181A1D0;
	Thu,  4 Nov 2021 07:22:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A46loYl005661 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 02:47:50 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 07F112166B41; Thu,  4 Nov 2021 06:47:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F33012166B26
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 06:47:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 167F1899EC0
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 06:47:47 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com
	(mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-441-03hLJXoRM2WbulYh7ZcDQg-1; Thu, 04 Nov 2021 02:47:31 -0400
X-MC-Unique: 03hLJXoRM2WbulYh7ZcDQg-1
Received: from MW4PR04CA0341.namprd04.prod.outlook.com (2603:10b6:303:8a::16)
	by DM4PR12MB5341.namprd12.prod.outlook.com (2603:10b6:5:39e::18) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11;
	Thu, 4 Nov 2021 06:47:26 +0000
Received: from CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
	(2603:10b6:303:8a:cafe::2b) by MW4PR04CA0341.outlook.office365.com
	(2603:10b6:303:8a::16) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via
	Frontend Transport; Thu, 4 Nov 2021 06:47:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
	smtp.mailfrom=nvidia.com; infradead.org; dkim=none (message not signed)
	header.d=none; infradead.org;
	dmarc=pass action=none header.from=nvidia.com
Received: from mail.nvidia.com (216.228.112.34) by
	CO1NAM11FT044.mail.protection.outlook.com (10.13.175.188) with
	Microsoft SMTP
	Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
	15.20.4669.10 via Frontend Transport; Thu, 4 Nov 2021 06:47:24 +0000
Received: from dev.nvidia.com (172.20.187.6) by HQMAIL107.nvidia.com
	(172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18;
	Thu, 4 Nov 2021 06:47:23 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: <linux-block@vger.kernel.org>, <linux-raid@vger.kernel.org>,
	<linux-nvme@lists.infradead.org>, <linux-scsi@vger.kernel.org>,
	<target-devel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-xfs@vger.kernel.org>, <dm-devel@redhat.com>
Date: Wed, 3 Nov 2021 23:46:28 -0700
Message-ID: <20211104064634.4481-3-chaitanyak@nvidia.com>
In-Reply-To: <20211104064634.4481-1-chaitanyak@nvidia.com>
References: <20211104064634.4481-1-chaitanyak@nvidia.com>
MIME-Version: 1.0
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
	HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26ac02d0-1700-42ae-15c3-08d99f5ef585
X-MS-TrafficTypeDiagnostic: DM4PR12MB5341:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5341ABF93E80986C0583AC37A38D9@DM4PR12MB5341.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 6+53OUy59cS/uSmDZSCGJU2KvFqthHmmZMneEYFyfYl7c38hrX35h6sTKLip6j9weUmd8D2Nol9W8LIfrh2LcxFvam4OApQi2z93Od9yYy83UIjTz/oAW3AvHHUIGUYd+RLqy1+SVKSesfvSZSsG3Fw18AymIAm7gIV+sMQYwNlKp3fkqW68+R7gR9/FLebse/u73XSc0pbu3cdseLaH3c67Wj53S5zZDtLCzbrZa1DPArGMaHGL88J5UqEqmD5G+c4dhyzSset20lFtQ51B7KLEfYHy0xFQoaHgxd3QFJZD2f8y9wBayrufiVvaMdnqJiMDEItRn44F8BIQC/N0CYPLRVmYRIO1uPzU0f8/+aEK7N+NPCojipbmdb1b8COe6zfQ3qMudVHlms7yB2oD52+eumgFSbNcbzsZB5Q2zOBPdvUgZoCxCBMqomS78j//T9b53L1Rs39EDClTYojzLfDhW88jA57xJ8tKurIZI1+m4k0j+oRvBZWto6ovigc2OwHRSz5Vinat0V/Dxa1jFx9scBPMoneOJoElnckO9Xeyd02FW1mGr4x2hXTS87ijzjcwKEsuZ/uVO2hxiN1C1QvC0jTCDnpPLLRSulxz1aTtz2h78MozaVySnRpAqifyiWax7WQV2dJHou+YctEwNMr0l0BxPIuQ9cWyaXCs7wyjJPNImkzldJ3XN5Z9w0Dj9hlHyJleKV2q1gjrLa0mDT5H4bBjcH6qQXeSk2WiRhcbuvPAwHEPi1r7SMBidFsO
X-Forefront-Antispam-Report: CIP:216.228.112.34; CTRY:US; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:mail.nvidia.com; PTR:schybrid03.nvidia.com;
	CAT:NONE;
	SFS:(4636009)(36840700001)(46966006)(110136005)(8936002)(16526019)(86362001)(508600001)(54906003)(47076005)(2616005)(83380400001)(1076003)(4326008)(336012)(426003)(186003)(7696005)(82310400003)(7416002)(36860700001)(356005)(5660300002)(2906002)(107886003)(36756003)(316002)(70586007)(26005)(36906005)(70206006)(7406005)(8676002)(7636003)(21314003)(2101003);
	DIR:OUT; SFP:1101
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 06:47:24.3298 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26ac02d0-1700-42ae-15c3-08d99f5ef585
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;
	Ip=[216.228.112.34]; Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5341
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A46loYl005661
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 04 Nov 2021 03:22:43 -0400
Cc: snitzer@redhat.com, ebiggers@google.com, djwong@kernel.org, clm@fb.com,
	adilger.kernel@dilger.ca, osandov@fb.com, agk@redhat.com,
	javier@javigon.com, sagi@grimberg.me, dongli.zhang@oracle.com,
	willy@infradead.org, hch@lst.de, danil.kipnis@cloud.ionos.com,
	idryomov@gmail.com, jinpu.wang@cloud.ionos.com,
	Chaitanya Kulkarni <kch@nvidia.com>, jejb@linux.ibm.com,
	josef@toxicpanda.com, ming.lei@redhat.com, dsterba@suse.com,
	viro@zeniv.linux.org.uk, jefflexu@linux.alibaba.com,
	bvanassche@acm.org, axboe@kernel.dk, tytso@mit.edu,
	martin.petersen@oracle.com, song@kernel.org,
	johannes.thumshirn@wdc.com, jlayton@kernel.org,
	kbusch@kernel.org, jack@suse.com
Subject: [dm-devel] [RFC PATCH 2/8] scsi: add REQ_OP_VERIFY support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Chaitanya Kulkarni <kch@nvidia.com>

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/scsi/sd.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.h |  1 +
 2 files changed, 53 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a3d2d4bc4a3d..7f2c4eb98cf8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -106,6 +106,7 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_ZBC);
 
 static void sd_config_discard(struct scsi_disk *, unsigned int);
 static void sd_config_write_same(struct scsi_disk *);
+static void sd_config_verify(struct scsi_disk *sdkp);
 static int  sd_revalidate_disk(struct gendisk *);
 static void sd_unlock_native_capacity(struct gendisk *disk);
 static int  sd_probe(struct device *);
@@ -995,6 +996,41 @@ static blk_status_t sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
 	return sd_setup_write_same10_cmnd(cmd, false);
 }
 
+static void sd_config_verify(struct scsi_disk *sdkp)
+{
+	struct request_queue *q = sdkp->disk->queue;
+
+	/* XXX: use same pattern as sd_config_write_same(). */
+	blk_queue_max_verify_sectors(q, UINT_MAX >> 9);
+}
+
+static blk_status_t sd_setup_verify_cmnd(struct scsi_cmnd *cmd)
+{
+       struct request *rq = cmd->request;
+       struct scsi_device *sdp = cmd->device;
+       struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
+       u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
+       u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
+
+       if (!sdkp->verify_16)
+	       return BLK_STS_NOTSUPP;
+
+       cmd->cmd_len = 16;
+       cmd->cmnd[0] = VERIFY_16;
+       /* skip veprotect / dpo / bytchk */
+       cmd->cmnd[1] = 0;
+       put_unaligned_be64(lba, &cmd->cmnd[2]);
+       put_unaligned_be32(nr_blocks, &cmd->cmnd[10]);
+       cmd->cmnd[14] = 0;
+       cmd->cmnd[15] = 0;
+
+       cmd->allowed = SD_MAX_RETRIES;
+       cmd->sc_data_direction = DMA_NONE;
+       cmd->transfersize = 0;
+
+       return BLK_STS_OK;
+}
+
 static void sd_config_write_same(struct scsi_disk *sdkp)
 {
 	struct request_queue *q = sdkp->disk->queue;
@@ -1345,6 +1381,8 @@ static blk_status_t sd_init_command(struct scsi_cmnd *cmd)
 		}
 	case REQ_OP_WRITE_ZEROES:
 		return sd_setup_write_zeroes_cmnd(cmd);
+	case REQ_OP_VERIFY:
+		return sd_setup_verify_cmnd(cmd);
 	case REQ_OP_WRITE_SAME:
 		return sd_setup_write_same_cmnd(cmd);
 	case REQ_OP_FLUSH:
@@ -2029,6 +2067,7 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	switch (req_op(req)) {
 	case REQ_OP_DISCARD:
 	case REQ_OP_WRITE_ZEROES:
+	case REQ_OP_VERIFY:
 	case REQ_OP_WRITE_SAME:
 	case REQ_OP_ZONE_RESET:
 	case REQ_OP_ZONE_RESET_ALL:
@@ -3096,6 +3135,17 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 		sdkp->ws10 = 1;
 }
 
+static void sd_read_verify(struct scsi_disk *sdkp, unsigned char *buffer)
+{
+       struct scsi_device *sdev = sdkp->device;
+
+       sd_printk(KERN_INFO, sdkp, "VERIFY16 check.\n");
+       if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, VERIFY_16) == 1) {
+	       sd_printk(KERN_INFO, sdkp, " VERIFY16 in ON .\n");
+               sdkp->verify_16 = 1;
+       }
+}
+
 static void sd_read_security(struct scsi_disk *sdkp, unsigned char *buffer)
 {
 	struct scsi_device *sdev = sdkp->device;
@@ -3224,6 +3274,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		sd_read_cache_type(sdkp, buffer);
 		sd_read_app_tag_own(sdkp, buffer);
 		sd_read_write_same(sdkp, buffer);
+		sd_read_verify(sdkp, buffer);
 		sd_read_security(sdkp, buffer);
 	}
 
@@ -3265,6 +3316,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 
 	set_capacity_and_notify(disk, logical_to_sectors(sdp, sdkp->capacity));
 	sd_config_write_same(sdkp);
+	sd_config_verify(sdkp);
 	kfree(buffer);
 
 	/*
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index b59136c4125b..94a86bf6dac4 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -120,6 +120,7 @@ struct scsi_disk {
 	unsigned	lbpvpd : 1;
 	unsigned	ws10 : 1;
 	unsigned	ws16 : 1;
+	unsigned        verify_16 : 1;
 	unsigned	rc_basis: 2;
 	unsigned	zoned: 2;
 	unsigned	urswrz : 1;
-- 
2.22.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

