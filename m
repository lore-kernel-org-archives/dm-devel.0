Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E27F8C433FE
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 07:23:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 834806112D
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 07:23:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 834806112D
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-UzGPTEYtNA-B6_-eeMpr1Q-1; Thu, 04 Nov 2021 03:23:04 -0400
X-MC-Unique: UzGPTEYtNA-B6_-eeMpr1Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97DE310A8E00;
	Thu,  4 Nov 2021 07:22:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 76BFC6788F;
	Thu,  4 Nov 2021 07:22:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 248F84E58E;
	Thu,  4 Nov 2021 07:22:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A46ntUw006389 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 02:49:55 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AAA1B400DEF8; Thu,  4 Nov 2021 06:49:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A43D540CFD0A
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 06:49:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87D50800B26
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 06:49:55 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com
	(mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-134-aBLicu2yNA6NTgVJugmnMQ-1; Thu, 04 Nov 2021 02:49:51 -0400
X-MC-Unique: aBLicu2yNA6NTgVJugmnMQ-1
Received: from MWHPR07CA0023.namprd07.prod.outlook.com (2603:10b6:300:116::33)
	by DM6PR12MB3803.namprd12.prod.outlook.com (2603:10b6:5:1ce::20) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17;
	Thu, 4 Nov 2021 06:49:47 +0000
Received: from CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
	(2603:10b6:300:116:cafe::1d) by MWHPR07CA0023.outlook.office365.com
	(2603:10b6:300:116::33) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via
	Frontend Transport; Thu, 4 Nov 2021 06:49:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
	smtp.mailfrom=nvidia.com; infradead.org; dkim=none (message not signed)
	header.d=none; infradead.org;
	dmarc=pass action=none header.from=nvidia.com
Received: from mail.nvidia.com (216.228.112.34) by
	CO1NAM11FT028.mail.protection.outlook.com (10.13.175.214) with
	Microsoft SMTP
	Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
	15.20.4669.10 via Frontend Transport; Thu, 4 Nov 2021 06:49:46 +0000
Received: from dev.nvidia.com (172.20.187.5) by HQMAIL107.nvidia.com
	(172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18;
	Thu, 4 Nov 2021 06:49:44 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: <linux-block@vger.kernel.org>, <linux-raid@vger.kernel.org>,
	<linux-nvme@lists.infradead.org>, <linux-scsi@vger.kernel.org>,
	<target-devel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-xfs@vger.kernel.org>, <dm-devel@redhat.com>
Date: Wed, 3 Nov 2021 23:46:34 -0700
Message-ID: <20211104064634.4481-9-chaitanyak@nvidia.com>
In-Reply-To: <20211104064634.4481-1-chaitanyak@nvidia.com>
References: <20211104064634.4481-1-chaitanyak@nvidia.com>
MIME-Version: 1.0
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
	HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee0b9fe1-2d93-4534-1f11-08d99f5f4a15
X-MS-TrafficTypeDiagnostic: DM6PR12MB3803:
X-Microsoft-Antispam-PRVS: <DM6PR12MB38038DB4938DBD5E5C75B8FFA38D9@DM6PR12MB3803.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: UY0SWpGBc1P4YkudM6UA+jyXXf244sHMqUERIe2IhT1uwMo/W79RqC6FOwoZTrBgcVvH5rN8m7cuHzRUA1tqhYCkKloU0TryGBGH55M0DGHV749FyxOnASykpJ470T0w0hr4ghyDk+5CuHKBMhjfX9B43mh4YYaQc9XonJA0p8ucmhd9c6XyDfx3kVw4sJN4mAFkZ65DZthVB7HZPziwCnTaxqXkhsChatibv+nTMUub80fqDgCqUht23Tb/lF6FAOgmnQ3WZq3r/uHuQRBIAQGW4PuhTSSa31eQJ+npp8FTjMBdfrs3EYzMigRYV6nK8EbzakU2oxlJ2RPwkRpAMCrpRONQA1lm2HcLSkSJVwybXeEvU7xkk2F0IYJJqIpHIXcjkp2JFPzKJmtsamsUkcDx+YUilSOuFGGFx4aOcGiZqF2nG6LtLzMtP25dD7LZXUsHmMGrQzGQTfcdJKfY5nCRWbmI4TpqBVCvJ2u069rfUTQ+uoZ7oVT/v/3vybdKt/K/ywdv8ujKi9ODUgXCGz3MVPfztKzIo3u71WAhzqJL1hExqTElAivOkuECDUOQ5fYAoJ2NtKKXThXroYPGV4oSFkkPEpHtu+QA0TKSkw61sddEbxaTzeul5hGjD1bodi81Eau6fKaT3VYPJY4Vm1UuscjWp6ufS9v2RAmTaeL3FytPCD/57dkLe3x4djbcW10MmOLaxlYuoBpoVFhjHxsVTWalIMoH9Yv4zUhcFyA=
X-Forefront-Antispam-Report: CIP:216.228.112.34; CTRY:US; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:mail.nvidia.com; PTR:schybrid03.nvidia.com;
	CAT:NONE;
	SFS:(4636009)(46966006)(36840700001)(70206006)(82310400003)(6666004)(70586007)(16526019)(86362001)(336012)(186003)(7406005)(36860700001)(36756003)(26005)(7416002)(47076005)(508600001)(83380400001)(1076003)(5660300002)(30864003)(7636003)(2906002)(426003)(107886003)(4326008)(7696005)(8676002)(316002)(110136005)(54906003)(36906005)(2616005)(356005)(8936002)(2101003);
	DIR:OUT; SFP:1101
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 06:49:46.2044 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee0b9fe1-2d93-4534-1f11-08d99f5f4a15
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;
	Ip=[216.228.112.34]; Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3803
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A46ntUw006389
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
Subject: [dm-devel] [RFC PATCH 8/8] md: add support for REQ_OP_VERIFY
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

From: Chaitanya Kulkarni <kch@nvidia.com>

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/md/dm-core.h          |  1 +
 drivers/md/dm-io.c            |  8 ++++++--
 drivers/md/dm-linear.c        | 11 ++++++++++-
 drivers/md/dm-mpath.c         |  1 +
 drivers/md/dm-rq.c            |  3 +++
 drivers/md/dm-stripe.c        |  1 +
 drivers/md/dm-table.c         | 36 +++++++++++++++++++++++++++++++++++
 drivers/md/dm.c               | 31 ++++++++++++++++++++++++++++++
 drivers/md/md-linear.c        | 10 ++++++++++
 drivers/md/md-multipath.c     |  1 +
 drivers/md/md.h               |  7 +++++++
 drivers/md/raid10.c           |  1 +
 drivers/md/raid5.c            |  1 +
 include/linux/device-mapper.h |  6 ++++++
 14 files changed, 115 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 086d293c2b03..8a07ac9165ec 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -114,6 +114,7 @@ struct mapped_device {
 void disable_discard(struct mapped_device *md);
 void disable_write_same(struct mapped_device *md);
 void disable_write_zeroes(struct mapped_device *md);
+void disable_verify(struct mapped_device *md);
 
 static inline sector_t dm_get_size(struct mapped_device *md)
 {
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 4312007d2d34..da09d092e2c1 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -317,8 +317,11 @@ static void do_region(int op, int op_flags, unsigned region,
 		special_cmd_max_sectors = q->limits.max_write_zeroes_sectors;
 	else if (op == REQ_OP_WRITE_SAME)
 		special_cmd_max_sectors = q->limits.max_write_same_sectors;
+	else if (op == REQ_OP_VERIFY)
+		special_cmd_max_sectors = q->limits.max_verify_sectors;
 	if ((op == REQ_OP_DISCARD || op == REQ_OP_WRITE_ZEROES ||
-	     op == REQ_OP_WRITE_SAME) && special_cmd_max_sectors == 0) {
+	     op == REQ_OP_VERIFY || op == REQ_OP_WRITE_SAME) &&
+	     special_cmd_max_sectors == 0) {
 		atomic_inc(&io->count);
 		dec_count(io, region, BLK_STS_NOTSUPP);
 		return;
@@ -335,6 +338,7 @@ static void do_region(int op, int op_flags, unsigned region,
 		switch (op) {
 		case REQ_OP_DISCARD:
 		case REQ_OP_WRITE_ZEROES:
+		case REQ_OP_VERIFY:
 			num_bvecs = 0;
 			break;
 		case REQ_OP_WRITE_SAME:
@@ -352,7 +356,7 @@ static void do_region(int op, int op_flags, unsigned region,
 		bio_set_op_attrs(bio, op, op_flags);
 		store_io_and_region_in_bio(bio, io, region);
 
-		if (op == REQ_OP_DISCARD || op == REQ_OP_WRITE_ZEROES) {
+		if (op == REQ_OP_DISCARD || op == REQ_OP_WRITE_ZEROES || op == REQ_OP_VERIFY) {
 			num_sectors = min_t(sector_t, special_cmd_max_sectors, remaining);
 			bio->bi_iter.bi_size = num_sectors << SECTOR_SHIFT;
 			remaining -= num_sectors;
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 00774b5d7668..802c9cb917ae 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -62,6 +62,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->num_secure_erase_bios = 1;
 	ti->num_write_same_bios = 1;
 	ti->num_write_zeroes_bios = 1;
+	ti->num_verify_bios = 1;
 	ti->private = lc;
 	return 0;
 
@@ -90,9 +91,17 @@ static void linear_map_bio(struct dm_target *ti, struct bio *bio)
 	struct linear_c *lc = ti->private;
 
 	bio_set_dev(bio, lc->dev->bdev);
-	if (bio_sectors(bio) || op_is_zone_mgmt(bio_op(bio)))
+	if (bio_sectors(bio) || op_is_zone_mgmt(bio_op(bio))) {
 		bio->bi_iter.bi_sector =
 			linear_map_sector(ti, bio->bi_iter.bi_sector);
+		if (bio_op(bio) == REQ_OP_VERIFY)
+			printk(KERN_INFO"dmrg:     REQ_OP_VERIFY sector %10llu nr_sectors "
+					"%10u %s %s\n",
+					bio->bi_iter.bi_sector, bio->bi_iter.bi_size >> 9,
+					bio->bi_bdev->bd_disk->disk_name,
+					current->comm);
+
+	}
 }
 
 static int linear_map(struct dm_target *ti, struct bio *bio)
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index bced42f082b0..d6eb0d287032 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1255,6 +1255,7 @@ static int multipath_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	ti->num_discard_bios = 1;
 	ti->num_write_same_bios = 1;
 	ti->num_write_zeroes_bios = 1;
+	ti->num_verify_bios = 1;
 	if (m->queue_mode == DM_TYPE_BIO_BASED)
 		ti->per_io_data_size = multipath_per_bio_data_size();
 	else
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 13b4385f4d5a..eaf19f8c9fca 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -224,6 +224,9 @@ static void dm_done(struct request *clone, blk_status_t error, bool mapped)
 		else if (req_op(clone) == REQ_OP_WRITE_ZEROES &&
 			 !clone->q->limits.max_write_zeroes_sectors)
 			disable_write_zeroes(tio->md);
+		else if (req_op(clone) == REQ_OP_VERIFY &&
+			 !clone->q->limits.max_verify_sectors)
+			disable_verify(tio->md);
 	}
 
 	switch (r) {
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index df359d33cda8..199ee57290a2 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -159,6 +159,7 @@ static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->num_secure_erase_bios = stripes;
 	ti->num_write_same_bios = stripes;
 	ti->num_write_zeroes_bios = stripes;
+	ti->num_verify_bios = stripes;
 
 	sc->chunk_size = chunk_size;
 	if (chunk_size & (chunk_size - 1))
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 4acf2342f7ad..6a55c4c3b77a 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1709,6 +1709,36 @@ static bool dm_table_supports_nowait(struct dm_table *t)
 	return true;
 }
 
+static int device_not_verify_capable(struct dm_target *ti, struct dm_dev *dev,
+					   sector_t start, sector_t len, void *data)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+
+	return q && !q->limits.max_verify_sectors;
+}
+
+static bool dm_table_supports_verify(struct dm_table *t)
+{
+	struct dm_target *ti;
+	unsigned i = 0;
+
+	while (i < dm_table_get_num_targets(t)) {
+		ti = dm_table_get_target(t, i++);
+
+		if (!ti->num_verify_bios)
+			return false;
+
+		if (!ti->type->iterate_devices ||
+		    ti->type->iterate_devices(ti, device_not_verify_capable, NULL))
+			return false;
+
+		printk(KERN_INFO"REQ_OP_VERIFY configured success for %s id %d\n",
+				ti->type->name, i);
+	}
+
+	return true;
+}
+
 static int device_not_discard_capable(struct dm_target *ti, struct dm_dev *dev,
 				      sector_t start, sector_t len, void *data)
 {
@@ -1830,6 +1860,12 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	if (dm_table_supports_secure_erase(t))
 		blk_queue_flag_set(QUEUE_FLAG_SECERASE, q);
 
+	if (!dm_table_supports_verify(t)) {
+		blk_queue_flag_clear(QUEUE_FLAG_VERIFY, q);
+		q->limits.max_verify_sectors = 0;
+	} else
+		blk_queue_flag_set(QUEUE_FLAG_VERIFY, q);
+
 	if (dm_table_supports_flush(t, (1UL << QUEUE_FLAG_WC))) {
 		wc = true;
 		if (dm_table_supports_flush(t, (1UL << QUEUE_FLAG_FUA)))
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 479ec5bea09e..f70e387ce020 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -969,6 +969,15 @@ void disable_write_zeroes(struct mapped_device *md)
 	limits->max_write_zeroes_sectors = 0;
 }
 
+void disable_verify(struct mapped_device *md)
+{
+	struct queue_limits *limits = dm_get_queue_limits(md);
+
+	/* device doesn't really support VERIFY, disable it */
+	limits->max_verify_sectors = 0;
+	blk_queue_flag_clear(QUEUE_FLAG_VERIFY, md->queue);
+}
+
 static void clone_endio(struct bio *bio)
 {
 	blk_status_t error = bio->bi_status;
@@ -989,6 +998,9 @@ static void clone_endio(struct bio *bio)
 		else if (bio_op(bio) == REQ_OP_WRITE_ZEROES &&
 			 !q->limits.max_write_zeroes_sectors)
 			disable_write_zeroes(md);
+		else if (bio_op(bio) == REQ_OP_VERIFY &&
+			 !q->limits.max_verify_sectors)
+			disable_verify(md);
 	}
 
 	/*
@@ -1455,6 +1467,12 @@ static int __clone_and_map_data_bio(struct clone_info *ci, struct dm_target *ti,
 	return 0;
 }
 
+static unsigned get_num_verify_bios(struct dm_target *ti)
+{
+	printk(KERN_INFO"%s %d\n", __func__, __LINE__);
+	return ti->num_verify_bios;
+}
+
 static int __send_changing_extent_only(struct clone_info *ci, struct dm_target *ti,
 				       unsigned num_bios)
 {
@@ -1480,15 +1498,25 @@ static int __send_changing_extent_only(struct clone_info *ci, struct dm_target *
 	return 0;
 }
 
+static int __send_verify(struct clone_info *ci, struct dm_target *ti)
+{
+	printk(KERN_INFO"%s %d\n", __func__, __LINE__);
+	return __send_changing_extent_only(ci, ti, get_num_verify_bios(ti));
+}
+
 static bool is_abnormal_io(struct bio *bio)
 {
 	bool r = false;
 
+	if (bio_op(bio) == REQ_OP_VERIFY)
+		printk(KERN_INFO"%s %d\n", __func__, __LINE__);
+
 	switch (bio_op(bio)) {
 	case REQ_OP_DISCARD:
 	case REQ_OP_SECURE_ERASE:
 	case REQ_OP_WRITE_SAME:
 	case REQ_OP_WRITE_ZEROES:
+	case REQ_OP_VERIFY:
 		r = true;
 		break;
 	}
@@ -1515,6 +1543,9 @@ static bool __process_abnormal_io(struct clone_info *ci, struct dm_target *ti,
 	case REQ_OP_WRITE_ZEROES:
 		num_bios = ti->num_write_zeroes_bios;
 		break;
+	case REQ_OP_VERIFY:
+		num_bios = ti->num_verify_bios;
+		break;
 	default:
 		return false;
 	}
diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index 63ed8329a98d..0d8355658f8f 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -65,6 +65,7 @@ static struct linear_conf *linear_conf(struct mddev *mddev, int raid_disks)
 	struct md_rdev *rdev;
 	int i, cnt;
 	bool discard_supported = false;
+	bool verify_supported = false;
 
 	conf = kzalloc(struct_size(conf, disks, raid_disks), GFP_KERNEL);
 	if (!conf)
@@ -99,6 +100,8 @@ static struct linear_conf *linear_conf(struct mddev *mddev, int raid_disks)
 
 		if (blk_queue_discard(bdev_get_queue(rdev->bdev)))
 			discard_supported = true;
+		if (blk_queue_verify(bdev_get_queue(rdev->bdev)))
+			verify_supported = true;
 	}
 	if (cnt != raid_disks) {
 		pr_warn("md/linear:%s: not enough drives present. Aborting!\n",
@@ -111,6 +114,12 @@ static struct linear_conf *linear_conf(struct mddev *mddev, int raid_disks)
 	else
 		blk_queue_flag_set(QUEUE_FLAG_DISCARD, mddev->queue);
 
+	if (!verify_supported)
+		blk_queue_flag_clear(QUEUE_FLAG_VERIFY, mddev->queue);
+	else
+		blk_queue_flag_set(QUEUE_FLAG_VERIFY, mddev->queue);
+
+
 	/*
 	 * Here we calculate the device offsets.
 	 */
@@ -261,6 +270,7 @@ static bool linear_make_request(struct mddev *mddev, struct bio *bio)
 					      bio_sector);
 		mddev_check_writesame(mddev, bio);
 		mddev_check_write_zeroes(mddev, bio);
+		mddev_check_verify(mddev, bio);
 		submit_bio_noacct(bio);
 	}
 	return true;
diff --git a/drivers/md/md-multipath.c b/drivers/md/md-multipath.c
index 776bbe542db5..2856fc80a8a1 100644
--- a/drivers/md/md-multipath.c
+++ b/drivers/md/md-multipath.c
@@ -131,6 +131,7 @@ static bool multipath_make_request(struct mddev *mddev, struct bio * bio)
 	mp_bh->bio.bi_private = mp_bh;
 	mddev_check_writesame(mddev, &mp_bh->bio);
 	mddev_check_write_zeroes(mddev, &mp_bh->bio);
+	mddev_check_verify(mddev, &mp_bh->bio);
 	submit_bio_noacct(&mp_bh->bio);
 	return true;
 }
diff --git a/drivers/md/md.h b/drivers/md/md.h
index bcbba1b5ec4a..f40b5a5bc862 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -802,6 +802,13 @@ static inline void mddev_check_write_zeroes(struct mddev *mddev, struct bio *bio
 		mddev->queue->limits.max_write_zeroes_sectors = 0;
 }
 
+static inline void mddev_check_verify(struct mddev *mddev, struct bio *bio)
+{
+	if (bio_op(bio) == REQ_OP_VERIFY &&
+	    !bio->bi_bdev->bd_disk->queue->limits.max_verify_sectors)
+		mddev->queue->limits.max_verify_sectors = 0;
+}
+
 struct mdu_array_info_s;
 struct mdu_disk_info_s;
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e1eefbec15d4..2ba1214bec2e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3756,6 +3756,7 @@ static int raid10_run(struct mddev *mddev)
 					      mddev->chunk_sectors);
 		blk_queue_max_write_same_sectors(mddev->queue, 0);
 		blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
+		blk_queue_max_verify_sectors(mddev->queue, 0);
 		blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
 		raid10_set_io_opt(conf);
 	}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a348b2adf2a9..d723dfa2a3cb 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7718,6 +7718,7 @@ static int raid5_run(struct mddev *mddev)
 
 		blk_queue_max_write_same_sectors(mddev->queue, 0);
 		blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
+		blk_queue_max_verify_sectors(mddev->queue, 0);
 
 		rdev_for_each(rdev, mddev) {
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 61a66fb8ebb3..761228e234d9 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -302,6 +302,12 @@ struct dm_target {
 	 */
 	unsigned num_write_zeroes_bios;
 
+	/*
+	 * The number of VERIFY bios that will be submitted to the target.
+	 * The bio number can be accessed with dm_bio_get_target_bio_nr.
+	 */
+	unsigned num_verify_bios;
+
 	/*
 	 * The minimum number of extra bytes allocated in each io for the
 	 * target to use.
-- 
2.22.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

