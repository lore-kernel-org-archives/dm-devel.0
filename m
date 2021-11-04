Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7C99C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 07:23:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 47FA46112D
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 07:23:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 47FA46112D
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-5J3iUg7cPpSSLRJ-OdqVHQ-1; Thu, 04 Nov 2021 03:23:06 -0400
X-MC-Unique: 5J3iUg7cPpSSLRJ-OdqVHQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52884806696;
	Thu,  4 Nov 2021 07:23:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2CF2419D9F;
	Thu,  4 Nov 2021 07:23:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CEDE64E9F4;
	Thu,  4 Nov 2021 07:23:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A46m3DZ005668 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 02:48:03 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B7D6B2166B26; Thu,  4 Nov 2021 06:48:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B14B72166B25
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 06:48:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 918BC899EC2
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 06:48:03 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
	(mail-bn8nam12on2084.outbound.protection.outlook.com [40.107.237.84])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-233-xldSiKD4Pcu0scAkmdoeYA-1; Thu, 04 Nov 2021 02:47:59 -0400
X-MC-Unique: xldSiKD4Pcu0scAkmdoeYA-1
Received: from MWHPR15CA0043.namprd15.prod.outlook.com (2603:10b6:300:ad::29)
	by MN2PR12MB4064.namprd12.prod.outlook.com (2603:10b6:208:1d3::17)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17;
	Thu, 4 Nov 2021 06:47:56 +0000
Received: from CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
	(2603:10b6:300:ad:cafe::e4) by MWHPR15CA0043.outlook.office365.com
	(2603:10b6:300:ad::29) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via
	Frontend Transport; Thu, 4 Nov 2021 06:47:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
	smtp.mailfrom=nvidia.com; infradead.org; dkim=none (message not signed)
	header.d=none; infradead.org;
	dmarc=pass action=none header.from=nvidia.com
Received: from mail.nvidia.com (216.228.112.34) by
	CO1NAM11FT004.mail.protection.outlook.com (10.13.175.89) with Microsoft
	SMTP
	Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
	15.20.4669.10 via Frontend Transport; Thu, 4 Nov 2021 06:47:56 +0000
Received: from dev.nvidia.com (172.20.187.5) by HQMAIL107.nvidia.com
	(172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18;
	Thu, 4 Nov 2021 06:47:55 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: <linux-block@vger.kernel.org>, <linux-raid@vger.kernel.org>,
	<linux-nvme@lists.infradead.org>, <linux-scsi@vger.kernel.org>,
	<target-devel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-xfs@vger.kernel.org>, <dm-devel@redhat.com>
Date: Wed, 3 Nov 2021 23:46:29 -0700
Message-ID: <20211104064634.4481-4-chaitanyak@nvidia.com>
In-Reply-To: <20211104064634.4481-1-chaitanyak@nvidia.com>
References: <20211104064634.4481-1-chaitanyak@nvidia.com>
MIME-Version: 1.0
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
	HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18df7c6d-8220-41b9-b5ed-08d99f5f089b
X-MS-TrafficTypeDiagnostic: MN2PR12MB4064:
X-Microsoft-Antispam-PRVS: <MN2PR12MB40647BD0F774AFD8567ED79DA38D9@MN2PR12MB4064.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: e9XznhoJ3x00fkMXDPRfHAw9zkQ9lx+xLczVn+ZNWr+lNcO1+Le0SJCuY4dNNJjrzrzorj4pbUejn2D3DmU+7mJ9RiVQzQGO/V1dSArmOt4OnlDngaNILcKgCVqmK/JQmKDZ5PXSHAxsyaZdzKSrbR7Pkr77pwPKJxf84utKmsGAoPR8/Mk2+dd0s2rFJweTUgYcpO2ywQzUCS9tKOCV35c33k7tGzWHfCb3k7tDlG9r7R5F4toRfVqgkJ0yF+toksFJu8f+9WjhDVCCfTNbQCejMC/WlH5JlJw3A8HoKZGAWjGPI2hRm8JABHbv1FMcX7xMK0DlpRaXJ/FDKropT4k3MCWPnsv5hCiegU9+kEHVUeF7lOu0lYj1ekTSj9YF73DnjHJoZeQQks646XSLKRInzvqsyhxuCH8RDwUC98VxlFqL1KtRZb5wzHd85rYNc6PhIqtRYWkdRztIXcbn5xYZu6bwBXidfM86HrMjvGvZWPr8Pt6mVAthd5SFb/QwXIjFZp1sz541WKYQP1di2St97ShPYDRvowLK8d8Ap4Z0V/fX07Mk/92aG94uFr6z8tw/+oxGo1sYYuEq6r+Wy20w0thFQrPIF+obTqKL/2GVIObIuMmyZvf1uNrNKj9GKjcu/d8hFx7EJlb0PcGmSh/IE1IWJS80ym4GaV+A9AC9BFY2xmwHGI1wryRysXP0Rn/gQJg8oBsPYkl4R82RNztj42SglmXFoD99SHBCGjI=
X-Forefront-Antispam-Report: CIP:216.228.112.34; CTRY:US; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:mail.nvidia.com; PTR:schybrid03.nvidia.com;
	CAT:NONE;
	SFS:(4636009)(46966006)(36840700001)(7406005)(110136005)(426003)(508600001)(7416002)(36906005)(70586007)(316002)(16526019)(54906003)(82310400003)(70206006)(2906002)(7696005)(6666004)(1076003)(107886003)(186003)(26005)(8936002)(36860700001)(336012)(47076005)(8676002)(356005)(86362001)(36756003)(83380400001)(5660300002)(7636003)(15650500001)(4326008)(2616005)(2101003);
	DIR:OUT; SFP:1101
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 06:47:56.3628 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18df7c6d-8220-41b9-b5ed-08d99f5f089b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;
	Ip=[216.228.112.34]; Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4064
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A46m3DZ005668
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
Subject: [dm-devel] [RFC PATCH 3/8] nvme: add support for the Verify command
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

From: Chaitanya Kulkarni <kch@nvidia.com>

Allow verify operations (REQ_OP_VERIFY) on the block device, if the
device supports optional command bit set for verify. Add support
to setup verify command. Set maximum possible verify sectors in one
verify command according to maximum hardware sectors supported by the
controller.

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/nvme/host/core.c | 39 +++++++++++++++++++++++++++++++++++++++
 include/linux/nvme.h     | 19 +++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 546a10407385..250647c3bb7b 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -801,6 +801,19 @@ static inline blk_status_t nvme_setup_write_zeroes(struct nvme_ns *ns,
 	return BLK_STS_OK;
 }
 
+static inline blk_status_t nvme_setup_verify(struct nvme_ns *ns,
+		struct request *req, struct nvme_command *cmnd)
+{
+	cmnd->verify.opcode = nvme_cmd_verify;
+	cmnd->verify.nsid = cpu_to_le32(ns->head->ns_id);
+	cmnd->verify.slba =
+		cpu_to_le64(nvme_sect_to_lba(ns, blk_rq_pos(req)));
+	cmnd->verify.length =
+		cpu_to_le16((blk_rq_bytes(req) >> ns->lba_shift) - 1);
+	cmnd->verify.control = 0;
+	return BLK_STS_OK;
+}
+
 static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
 		struct request *req, struct nvme_command *cmnd,
 		enum nvme_opcode op)
@@ -904,6 +917,9 @@ blk_status_t nvme_setup_cmd(struct nvme_ns *ns, struct request *req,
 	case REQ_OP_WRITE_ZEROES:
 		ret = nvme_setup_write_zeroes(ns, req, cmd);
 		break;
+	case REQ_OP_VERIFY:
+		ret = nvme_setup_verify(ns, req, cmd);
+		break;
 	case REQ_OP_DISCARD:
 		ret = nvme_setup_discard(ns, req, cmd);
 		break;
@@ -1974,6 +1990,28 @@ static void nvme_config_write_zeroes(struct gendisk *disk, struct nvme_ns *ns)
 					   nvme_lba_to_sect(ns, max_blocks));
 }
 
+static void nvme_config_verify(struct gendisk *disk, struct nvme_ns *ns)
+{
+	u64 max_blocks;
+
+	if (!(ns->ctrl->oncs & NVME_CTRL_ONCS_VERIFY))
+		return;
+
+	if (ns->ctrl->max_hw_sectors == UINT_MAX)
+		max_blocks = (u64)USHRT_MAX + 1;
+	else
+		max_blocks = ns->ctrl->max_hw_sectors + 1;
+
+	/* keep same as discard */
+	if (blk_queue_flag_test_and_set(QUEUE_FLAG_VERIFY, disk->queue))
+		return;
+
+	blk_queue_max_verify_sectors(disk->queue,
+				     nvme_lba_to_sect(ns, max_blocks));
+
+}
+
+
 static bool nvme_ns_ids_valid(struct nvme_ns_ids *ids)
 {
 	return !uuid_is_null(&ids->uuid) ||
@@ -2144,6 +2182,7 @@ static void nvme_update_disk_info(struct gendisk *disk,
 
 	nvme_config_discard(disk, ns);
 	nvme_config_write_zeroes(disk, ns);
+	nvme_config_verify(disk, ns);
 
 	set_disk_ro(disk, (id->nsattr & NVME_NS_ATTR_RO) ||
 		test_bit(NVME_NS_FORCE_RO, &ns->flags));
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index b08787cd0881..14925602726a 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -318,6 +318,7 @@ enum {
 	NVME_CTRL_ONCS_WRITE_UNCORRECTABLE	= 1 << 1,
 	NVME_CTRL_ONCS_DSM			= 1 << 2,
 	NVME_CTRL_ONCS_WRITE_ZEROES		= 1 << 3,
+	NVME_CTRL_ONCS_VERIFY			= 1 << 7,
 	NVME_CTRL_ONCS_RESERVATIONS		= 1 << 5,
 	NVME_CTRL_ONCS_TIMESTAMP		= 1 << 6,
 	NVME_CTRL_VWC_PRESENT			= 1 << 0,
@@ -890,6 +891,23 @@ struct nvme_write_zeroes_cmd {
 	__le16			appmask;
 };
 
+struct nvme_verify_cmd {
+	__u8			opcode;
+	__u8			flags;
+	__u16			command_id;
+	__le32			nsid;
+	__u64			rsvd2;
+	__le64			metadata;
+	union nvme_data_ptr	dptr;
+	__le64			slba;
+	__le16			length;
+	__le16			control;
+	__le32			rsvd3;
+	__le32			reftag;
+	__le16			eapptag;
+	__le16			eappmask;
+};
+
 enum nvme_zone_mgmt_action {
 	NVME_ZONE_CLOSE		= 0x1,
 	NVME_ZONE_FINISH	= 0x2,
@@ -1411,6 +1429,7 @@ struct nvme_command {
 		struct nvme_format_cmd format;
 		struct nvme_dsm_cmd dsm;
 		struct nvme_write_zeroes_cmd write_zeroes;
+		struct nvme_verify_cmd verify;
 		struct nvme_zone_mgmt_send_cmd zms;
 		struct nvme_zone_mgmt_recv_cmd zmr;
 		struct nvme_abort_cmd abort;
-- 
2.22.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

