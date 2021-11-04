Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A402BC433EF
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 07:22:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2E6D161108
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 07:22:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2E6D161108
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-mOf2ZGixMv-eiZxGKy-Ubw-1; Thu, 04 Nov 2021 03:22:50 -0400
X-MC-Unique: mOf2ZGixMv-eiZxGKy-Ubw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 537B05074D;
	Thu,  4 Nov 2021 07:22:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 09DC513ABD;
	Thu,  4 Nov 2021 07:22:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DB3191806D03;
	Thu,  4 Nov 2021 07:22:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A46ma7v006040 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 02:48:36 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 802242026D46; Thu,  4 Nov 2021 06:48:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7AE0B2026D5D
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 06:48:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95C57899EC2
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 06:48:31 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com
	(mail-bn8nam08on2089.outbound.protection.outlook.com [40.107.100.89])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-485-T3NpyGOHONK3KVgfa53CFg-1; Thu, 04 Nov 2021 02:48:27 -0400
X-MC-Unique: T3NpyGOHONK3KVgfa53CFg-1
Received: from MWHPR1401CA0007.namprd14.prod.outlook.com
	(2603:10b6:301:4b::17) by BY5PR12MB4872.namprd12.prod.outlook.com
	(2603:10b6:a03:1c4::13) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10;
	Thu, 4 Nov 2021 06:48:24 +0000
Received: from CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
	(2603:10b6:301:4b:cafe::91) by MWHPR1401CA0007.outlook.office365.com
	(2603:10b6:301:4b::17) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via
	Frontend Transport; Thu, 4 Nov 2021 06:48:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
	smtp.mailfrom=nvidia.com; infradead.org; dkim=none (message not signed)
	header.d=none; infradead.org;
	dmarc=pass action=none header.from=nvidia.com
Received: from mail.nvidia.com (216.228.112.34) by
	CO1NAM11FT036.mail.protection.outlook.com (10.13.174.124) with
	Microsoft SMTP
	Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
	15.20.4669.10 via Frontend Transport; Thu, 4 Nov 2021 06:48:23 +0000
Received: from dev.nvidia.com (172.20.187.5) by HQMAIL107.nvidia.com
	(172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18;
	Thu, 4 Nov 2021 06:48:11 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: <linux-block@vger.kernel.org>, <linux-raid@vger.kernel.org>,
	<linux-nvme@lists.infradead.org>, <linux-scsi@vger.kernel.org>,
	<target-devel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-xfs@vger.kernel.org>, <dm-devel@redhat.com>
Date: Wed, 3 Nov 2021 23:46:30 -0700
Message-ID: <20211104064634.4481-5-chaitanyak@nvidia.com>
In-Reply-To: <20211104064634.4481-1-chaitanyak@nvidia.com>
References: <20211104064634.4481-1-chaitanyak@nvidia.com>
MIME-Version: 1.0
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
	HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9fe58b2-e2d4-4979-886e-08d99f5f189f
X-MS-TrafficTypeDiagnostic: BY5PR12MB4872:
X-Microsoft-Antispam-PRVS: <BY5PR12MB48723BB1E490C132E0F3B9FDA38D9@BY5PR12MB4872.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: EO8BTKCM6VtmG7mGQ+x4yQAEAJGfB8VQywv+7G9X9ZkOISMPLIreHV9sxZj/J7qC9VXdn5eG87MwXPRDFOp1phZFz+uaQEkRasnrqHO4IQnKVIz/zOJ0iQIe0sZYikdfOn54n7lR462qRv6lSb2ZMDNc5z1jBUVws60lMjHMjE/pLtSjCKcy7sMO4sqesU8e+eWSKz6st+0Cby0Kqmdbmzf3kX7thvfaLMOwY/F+E2gc2bHjHyr7MCfHs9sdeB+smbImQBSVdP3+NZyNt+1O4KHnh1ou5i86bD1pMUd8mJ1pUujouPDitowElGPiB8fqXB+FoXCDk7ZraC6Ifk8fgpXQ0orVtw913cGa0LkusGlDNi8IvrYsH45PRCWibyMUUKoXi9AhMWrbUTGOvoSa62CfRB/g5SfhgDoOaG/TvxetavE1QYdOQGn8qoYjk1qrJl47+HxT9HJTh6ke5biV/NZZ021CRNjxBQz9PTGw4H6Zzmt+BL9QIhziaqth9+Z/4udmXPFT+yI0kBYgn80jQYp98QXHL2XwOj0b7jfeEVJw6gl1jcmcgEqRWfCz1XodmvQqRR40Y0xBQol53+bIbhfXQn7Zv6taH9NDNSkcu9PBornhTjFTTrUidIPMhxiPK0DxFx7MfgxZQjKuVMM0GgUOKsS1w2WBKq0fNfW43ltip3G17OjfSxC6uU7xcKE2ZuylJTkL2jJ71n2by33c+q0ag/yFJOSqhtfBKzbQoZoAb0O930gU3hbNDRIFpslF
X-Forefront-Antispam-Report: CIP:216.228.112.34; CTRY:US; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:mail.nvidia.com; PTR:schybrid03.nvidia.com;
	CAT:NONE;
	SFS:(4636009)(46966006)(36840700001)(2906002)(83380400001)(110136005)(86362001)(82310400003)(186003)(16526019)(54906003)(2616005)(4326008)(6666004)(70206006)(47076005)(70586007)(426003)(336012)(8676002)(36756003)(36860700001)(15650500001)(1076003)(356005)(316002)(36906005)(508600001)(8936002)(7406005)(7416002)(5660300002)(7636003)(7696005)(26005)(107886003)(21314003)(2101003);
	DIR:OUT; SFP:1101
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 06:48:23.2284 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9fe58b2-e2d4-4979-886e-08d99f5f189f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;
	Ip=[216.228.112.34]; Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4872
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A46ma7v006040
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
Subject: [dm-devel] [PATCH 4/8] nvmet: add Verify command support for bdev-ns
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

From: Chaitanya Kulkarni <kch@nvidia.com>

Add support for handling verify command on target. Call into
__blkdev_issue_verify, which the block layer expands into the
REQ_OP_VERIFY LBAs.

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/nvme/target/admin-cmd.c   |  3 ++-
 drivers/nvme/target/io-cmd-bdev.c | 39 +++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index 613a4d8feac1..87cad64895e6 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -408,7 +408,8 @@ static void nvmet_execute_identify_ctrl(struct nvmet_req *req)
 	id->nn = cpu_to_le32(ctrl->subsys->max_nsid);
 	id->mnan = cpu_to_le32(NVMET_MAX_NAMESPACES);
 	id->oncs = cpu_to_le16(NVME_CTRL_ONCS_DSM |
-			NVME_CTRL_ONCS_WRITE_ZEROES);
+			NVME_CTRL_ONCS_WRITE_ZEROES |
+			NVME_CTRL_ONCS_VERIFY);
 
 	/* XXX: don't report vwc if the underlying device is write through */
 	id->vwc = NVME_CTRL_VWC_PRESENT;
diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index ec45e597084b..5a888cdadfea 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -128,6 +128,7 @@ static u16 blk_to_nvme_status(struct nvmet_req *req, blk_status_t blk_sts)
 		switch (req->cmd->common.opcode) {
 		case nvme_cmd_dsm:
 		case nvme_cmd_write_zeroes:
+		case nvme_cmd_verify:
 			status = NVME_SC_ONCS_NOT_SUPPORTED | NVME_SC_DNR;
 			break;
 		default:
@@ -153,6 +154,10 @@ static u16 blk_to_nvme_status(struct nvmet_req *req, blk_status_t blk_sts)
 		req->error_slba =
 			le64_to_cpu(req->cmd->write_zeroes.slba);
 		break;
+	case nvme_cmd_verify:
+		req->error_slba =
+			le64_to_cpu(req->cmd->verify.slba);
+		break;
 	default:
 		req->error_slba = 0;
 	}
@@ -428,6 +433,37 @@ static void nvmet_bdev_execute_write_zeroes(struct nvmet_req *req)
 	}
 }
 
+static void nvmet_bdev_execute_verify(struct nvmet_req *req)
+{
+	struct nvme_verify_cmd *verify = &req->cmd->verify;
+	struct bio *bio = NULL;
+	sector_t nr_sector;
+	sector_t sector;
+	int ret;
+
+	if (!nvmet_check_transfer_len(req, 0))
+		return;
+
+	if (!bdev_verify_sectors(req->ns->bdev)) {
+		nvmet_req_complete(req, NVME_SC_INTERNAL | NVME_SC_DNR);
+		return;
+	}
+
+	sector = le64_to_cpu(verify->slba) << (req->ns->blksize_shift - 9);
+	nr_sector = (((sector_t)le16_to_cpu(verify->length) + 1) <<
+			(req->ns->blksize_shift - 9));
+
+	ret = __blkdev_issue_verify(req->ns->bdev, sector, nr_sector,
+			GFP_KERNEL, &bio);
+	if (bio) {
+		bio->bi_private = req;
+		bio->bi_end_io = nvmet_bio_done;
+		submit_bio(bio);
+	} else {
+		nvmet_req_complete(req, errno_to_nvme_status(req, ret));
+	}
+}
+
 u16 nvmet_bdev_parse_io_cmd(struct nvmet_req *req)
 {
 	struct nvme_command *cmd = req->cmd;
@@ -448,6 +484,9 @@ u16 nvmet_bdev_parse_io_cmd(struct nvmet_req *req)
 	case nvme_cmd_write_zeroes:
 		req->execute = nvmet_bdev_execute_write_zeroes;
 		return 0;
+	case nvme_cmd_verify:
+		req->execute = nvmet_bdev_execute_verify;
+		return 0;
 	default:
 		pr_err("unhandled cmd %d on qid %d\n", cmd->common.opcode,
 		       req->sq->qid);
-- 
2.22.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

