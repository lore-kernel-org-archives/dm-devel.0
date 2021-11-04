Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 998AEC433F5
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 07:23:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 39FB361108
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 07:23:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 39FB361108
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-J6dIt5UvMrSSqLHlAvD_HQ-1; Thu, 04 Nov 2021 03:23:12 -0400
X-MC-Unique: J6dIt5UvMrSSqLHlAvD_HQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C63780668B;
	Thu,  4 Nov 2021 07:23:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 52F8F60854;
	Thu,  4 Nov 2021 07:23:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 26D0B4EA29;
	Thu,  4 Nov 2021 07:23:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A46na62006374 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 02:49:36 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3BD4C400F3C6; Thu,  4 Nov 2021 06:49:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 36A77401A993
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 06:49:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A1BD802A5E
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 06:49:36 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com
	(mail-dm6nam11on2081.outbound.protection.outlook.com [40.107.223.81])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-474-OZhwdaEhMxeli7kA7p608g-1; Thu, 04 Nov 2021 02:49:32 -0400
X-MC-Unique: OZhwdaEhMxeli7kA7p608g-1
Received: from MWHPR15CA0041.namprd15.prod.outlook.com (2603:10b6:300:ad::27)
	by BL0PR12MB4929.namprd12.prod.outlook.com (2603:10b6:208:1c4::7)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11;
	Thu, 4 Nov 2021 06:49:28 +0000
Received: from CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
	(2603:10b6:300:ad:cafe::18) by MWHPR15CA0041.outlook.office365.com
	(2603:10b6:300:ad::27) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via
	Frontend Transport; Thu, 4 Nov 2021 06:49:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
	smtp.mailfrom=nvidia.com; infradead.org; dkim=none (message not signed)
	header.d=none; infradead.org;
	dmarc=pass action=none header.from=nvidia.com
Received: from mail.nvidia.com (216.228.112.34) by
	CO1NAM11FT054.mail.protection.outlook.com (10.13.174.70) with Microsoft
	SMTP
	Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
	15.20.4669.10 via Frontend Transport; Thu, 4 Nov 2021 06:49:27 +0000
Received: from dev.nvidia.com (172.20.187.6) by HQMAIL107.nvidia.com
	(172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18;
	Thu, 4 Nov 2021 06:49:25 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: <linux-block@vger.kernel.org>, <linux-raid@vger.kernel.org>,
	<linux-nvme@lists.infradead.org>, <linux-scsi@vger.kernel.org>,
	<target-devel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-xfs@vger.kernel.org>, <dm-devel@redhat.com>
Date: Wed, 3 Nov 2021 23:46:33 -0700
Message-ID: <20211104064634.4481-8-chaitanyak@nvidia.com>
In-Reply-To: <20211104064634.4481-1-chaitanyak@nvidia.com>
References: <20211104064634.4481-1-chaitanyak@nvidia.com>
MIME-Version: 1.0
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
	HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c88335d-44df-4ab6-fdb0-08d99f5f3ed1
X-MS-TrafficTypeDiagnostic: BL0PR12MB4929:
X-Microsoft-Antispam-PRVS: <BL0PR12MB49292A540009AE62BFCBC1D6A38D9@BL0PR12MB4929.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: cNcSmwHUNvU0MLrJY51f1jFTCFVJ/bInnujjBlLYf7Af8VWppB8y+0OxE3uGiPlteGRiS7INsnRvgmV3gr9EWJvNS1+5QUiZgHJqiP9YRUvg06GBcORfdopDWCIJwBoxEMff4Y1B6f10QE/2c5uo7sA5mmD59sDu1mB52sQlGoE49jbyrtfjFIx7ZC+wFQUrb0ElSbnd3swuqJysWxnbxQDEa0uvW0CO9CFrDABZ3mY+Ps6/+RA8ZFBNb+W/0tikWtCh+QOz9vxugVq0htgjcsybd8GfTcYn8GKt1A0aEz+r0u67l4kjeXN4aa/vUaeduBJQGWpH8nRaINa9LINagFgKLEdUqyZwJrMEn1AmcCvYfqYPOt6nkwp28Zqw4dj07/wT33nPSLmmWS53vrRm2wrjcANJ/Xf5G7q5xRASI0SLtW+Ovwm7BFvRwW3/p/qLAliRnyS6F29FI/vcMwGbdrTzncE/snlVLgHyDE3tmixpESGnpu5/9tyTMsCdodsRsIrKjDXZqL+mhgj14fynEjULEb8Ls8RgOUU7ggDwvMKsruE+vaPqYGfd+Yp9sSj5ErL/bm6iIgcr+uvi3fxvlmasnKNfPDR/QjMYn3eHcgoJoZKJXHL1pvtQg8ZpE1OpuqSSCLWERbybURW1rm+6XaqhJmUukqzw1s/W1fvQP5nhSX133syiHTEmTNvWOtDJx3+sKZLdjbNxRWPaiwiVjmeIvZJ17hmTngZwCVHj7a8=
X-Forefront-Antispam-Report: CIP:216.228.112.34; CTRY:US; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:mail.nvidia.com; PTR:schybrid03.nvidia.com;
	CAT:NONE;
	SFS:(4636009)(46966006)(36840700001)(336012)(8676002)(86362001)(426003)(26005)(16526019)(186003)(36860700001)(47076005)(7406005)(7416002)(2616005)(54906003)(8936002)(316002)(110136005)(7696005)(36756003)(508600001)(356005)(107886003)(70586007)(7636003)(6666004)(83380400001)(5660300002)(4326008)(70206006)(2906002)(1076003)(82310400003)(2101003);
	DIR:OUT; SFP:1101
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 06:49:27.3205 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c88335d-44df-4ab6-fdb0-08d99f5f3ed1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;
	Ip=[216.228.112.34]; Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4929
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A46na62006374
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
Subject: [dm-devel] [RFC PATCH 7/8] null_blk: add REQ_OP_VERIFY support
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

Add a new module parameter, configfs attribute to configure handling of
the REQ_OP_VERIFY. This is needed for testing newly added REQ_OP_VERIFY
block layer operation.

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/block/null_blk/main.c     | 25 ++++++++++++++++++++++++-
 drivers/block/null_blk/null_blk.h |  1 +
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index d6c821d48090..36a5f5343cee 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -216,6 +216,10 @@ static unsigned int g_zone_nr_conv;
 module_param_named(zone_nr_conv, g_zone_nr_conv, uint, 0444);
 MODULE_PARM_DESC(zone_nr_conv, "Number of conventional zones when block device is zoned. Default: 0");
 
+static bool g_verify;
+module_param_named(verify, g_verify, bool, 0444);
+MODULE_PARM_DESC(verify, "Allow REQ_OP_VERIFY processing. Default: false");
+
 static unsigned int g_zone_max_open;
 module_param_named(zone_max_open, g_zone_max_open, uint, 0444);
 MODULE_PARM_DESC(zone_max_open, "Maximum number of open zones when block device is zoned. Default: 0 (no limit)");
@@ -358,6 +362,7 @@ NULLB_DEVICE_ATTR(blocking, bool, NULL);
 NULLB_DEVICE_ATTR(use_per_node_hctx, bool, NULL);
 NULLB_DEVICE_ATTR(memory_backed, bool, NULL);
 NULLB_DEVICE_ATTR(discard, bool, NULL);
+NULLB_DEVICE_ATTR(verify, bool, NULL);
 NULLB_DEVICE_ATTR(mbps, uint, NULL);
 NULLB_DEVICE_ATTR(cache_size, ulong, NULL);
 NULLB_DEVICE_ATTR(zoned, bool, NULL);
@@ -477,6 +482,7 @@ static struct configfs_attribute *nullb_device_attrs[] = {
 	&nullb_device_attr_power,
 	&nullb_device_attr_memory_backed,
 	&nullb_device_attr_discard,
+	&nullb_device_attr_verify,
 	&nullb_device_attr_mbps,
 	&nullb_device_attr_cache_size,
 	&nullb_device_attr_badblocks,
@@ -539,7 +545,7 @@ nullb_group_drop_item(struct config_group *group, struct config_item *item)
 static ssize_t memb_group_features_show(struct config_item *item, char *page)
 {
 	return snprintf(page, PAGE_SIZE,
-			"memory_backed,discard,bandwidth,cache,badblocks,zoned,zone_size,zone_capacity,zone_nr_conv,zone_max_open,zone_max_active,blocksize,max_sectors\n");
+			"memory_backed,discard,verify,bandwidth,cache,badblocks,zoned,zone_size,zone_capacity,zone_nr_conv,zone_max_open,zone_max_active,blocksize,max_sectors\n");
 }
 
 CONFIGFS_ATTR_RO(memb_group_, features);
@@ -601,6 +607,7 @@ static struct nullb_device *null_alloc_dev(void)
 	dev->use_per_node_hctx = g_use_per_node_hctx;
 	dev->zoned = g_zoned;
 	dev->zone_size = g_zone_size;
+	dev->verify = g_verify;
 	dev->zone_capacity = g_zone_capacity;
 	dev->zone_nr_conv = g_zone_nr_conv;
 	dev->zone_max_open = g_zone_max_open;
@@ -1165,6 +1172,9 @@ static int null_handle_rq(struct nullb_cmd *cmd)
 	struct req_iterator iter;
 	struct bio_vec bvec;
 
+	if (req_op(rq) == REQ_OP_VERIFY)
+		return 0;
+
 	spin_lock_irq(&nullb->lock);
 	rq_for_each_segment(bvec, rq, iter) {
 		len = bvec.bv_len;
@@ -1192,6 +1202,9 @@ static int null_handle_bio(struct nullb_cmd *cmd)
 	struct bio_vec bvec;
 	struct bvec_iter iter;
 
+	if (bio_op(bio) == REQ_OP_VERIFY)
+		return 0;
+
 	spin_lock_irq(&nullb->lock);
 	bio_for_each_segment(bvec, bio, iter) {
 		len = bvec.bv_len;
@@ -1609,6 +1622,15 @@ static void null_config_discard(struct nullb *nullb)
 	blk_queue_flag_set(QUEUE_FLAG_DISCARD, nullb->q);
 }
 
+static void null_config_verify(struct nullb *nullb)
+{
+	if (nullb->dev->verify == false)
+		return;
+
+	blk_queue_max_verify_sectors(nullb->q, UINT_MAX >> 9);
+	blk_queue_flag_set(QUEUE_FLAG_VERIFY, nullb->q);
+}
+
 static const struct block_device_operations null_bio_ops = {
 	.owner		= THIS_MODULE,
 	.submit_bio	= null_submit_bio,
@@ -1881,6 +1903,7 @@ static int null_add_dev(struct nullb_device *dev)
 	blk_queue_max_hw_sectors(nullb->q, dev->max_sectors);
 
 	null_config_discard(nullb);
+	null_config_verify(nullb);
 
 	sprintf(nullb->disk_name, "nullb%d", nullb->index);
 
diff --git a/drivers/block/null_blk/null_blk.h b/drivers/block/null_blk/null_blk.h
index 83504f3cc9d6..e6913c099e71 100644
--- a/drivers/block/null_blk/null_blk.h
+++ b/drivers/block/null_blk/null_blk.h
@@ -95,6 +95,7 @@ struct nullb_device {
 	bool power; /* power on/off the device */
 	bool memory_backed; /* if data is stored in memory */
 	bool discard; /* if support discard */
+	bool verify; /* if support verify */
 	bool zoned; /* if device is zoned */
 };
 
-- 
2.22.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

