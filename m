Received: from HK3PR03CU002.outbound.protection.outlook.com (mail-eastasiaazon11011067.outbound.protection.outlook.com [52.101.129.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2A8FC08
	for <dm-devel@lists.linux.dev>; Wed, 23 Apr 2025 11:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.129.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745409059; cv=fail; b=JlNJp+Y1PsjOnJONmtPlbvvLmjnWWUaHa5VBqLdRU2CWuTfN3a+wd5vXxmAnUr9NQTUck6VSeyJHiuT608XJn/G0nLVpUAjxFvLjh1dXWprR/UejSFq3Et2ahhYSPsfKycq71MHLIxGBeucOX9W78FxwSqNfDFmLgGYyYRH+b+A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745409059; c=relaxed/simple;
	bh=xNtzoLW3F3/vEJmnJ/wHUTGVetYFvOA+nX/Imqn1ark=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=Xw9Ck9sNl+aclwlIeGsvMTZLtR3zLb62E9IM0JJlmQz9UvQ4UV/8jJmj3Q8XUm/f+K0/HL5JguQfw3UisAFFSMS/awYUsRpToa6PAx+lPGS35xYvFqxjS/WZxyaOmSgnr+T23tytglE5n/ceonfytYb8OwLw4HSkNkuim0oMUEc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=TkAF5Fcz; arc=fail smtp.client-ip=52.101.129.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="TkAF5Fcz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XyAkH2NduAMb7nRbPspXtJkSJlQLIU/85cOcCIyKE94q7CZpL411llC5XAIagmPugXf3ahzL1blIBT5lm+u4JwICgSZwQvnRkNzqsZj5GyNCHFDeNEjsGzlFP9zbpMXRorXWaUDLiObB5T96SUcOSy0uPtQL3YnZ7UHokGj4OoYvTqnaI8RP67R7ams+Ai3cOmuY/NTe0GYS4/NUxgYb8u37rU7Z0CwdzmNEY494O9ThFFKHznTGglnuLDCgAd1dMqxaxEUEkSwVf5UhxgCOnikoPeYm5htow9WyxV7lyygreRgCzNfY03qqBOnV1o+jLxbc/HcQswS4mSboeQO8qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ARnTaTQKE4DbxrWYQD2WFyUO9KHIlmEZdmpQ5sB7nGs=;
 b=Ov13U18gDL6frc82AZ4CGdVN/WuvU6hWdcZ++h+ULvPGkSWmvSB566Mj9ru44gQnfS4IHR4dEwrzUySSi4OzNx6nX3nSgwX3RWWTcJfjbgMnTg9JF7k4zSgvVNo88eeSVeUWlN1WbxWST+wjpLFlxN3yZO8oyHTJgNtxTQHJ4JAQBjxaEjtuh27TmUMka/s/2r0NCM3lSawdUWf5W9POc7Ym2H7I0/pIyOvoVwL2voFdkuUcBpgYFHqcbL85VSDm0DkjYWeqtQZsYK+LXbdEwlIkXCIjY8wFWZ5u1AzD1b1nYnN2f0mWEpvtAMptT+9TnrNvFC/jn7mjjElIazea2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ARnTaTQKE4DbxrWYQD2WFyUO9KHIlmEZdmpQ5sB7nGs=;
 b=TkAF5FczreGqsX2YqH0vJu/N/UhMcKONAZt9+BypCqP66czB8dULpToBwEGWi4jdzYNwkIAxREYTr95JsosuVePXHH+/lZs9fvSlNjg5urjdeHs7qcBurZgatkhSNQvvWSelE1AhtH3yOVebsNDVdgNxoxWjpbGRH2ech9h8TTE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by TYSPR02MB7783.apcprd02.prod.outlook.com (2603:1096:405:5e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.33; Wed, 23 Apr
 2025 11:50:50 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%5]) with mapi id 15.20.8655.033; Wed, 23 Apr 2025
 11:50:49 +0000
From: LongPing Wei <weilongping@oppo.com>
To: snitzer@kernel.org,
	mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	guoweichao@oppo.com,
	ebiggers@kernel.org,
	LongPing Wei <weilongping@oppo.com>
Subject: [PATCH] dm-verity: all verity devices share the same dm_io_client and recheck_pool.
Date: Wed, 23 Apr 2025 19:50:14 +0800
Message-Id: <20250423115013.4004577-1-weilongping@oppo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0207.apcprd04.prod.outlook.com
 (2603:1096:4:187::9) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|TYSPR02MB7783:EE_
X-MS-Office365-Filtering-Correlation-Id: 58afe866-e467-4f68-94e0-08dd825d1783
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4vetMHD1n+eydh59BMVMAErqlyIvRZNBE+MLNx9kOQkTalXgoImuU+yb7MC3?=
 =?us-ascii?Q?I0vDwG5Gy3xLJbeqejIvC5d2vXOISpe6S5zjv3YKIMLfNUYv4fUBaDhXWlFg?=
 =?us-ascii?Q?efvhPr0gAad+FaN99r1b3YJLIiMnZdQ/N/hkqWRnCo2xMSQRYTYZxSs5DXkT?=
 =?us-ascii?Q?FDeEHSyUpx35hLjmSlul2X6QW/BE62TDDgi3zrvemVYdVnhjic03D3Jxwjon?=
 =?us-ascii?Q?mq/j/vVnQG8KCCFXR4MvSPOfh8PoBdLyNrnqkJ9uTRx5OJO39T/FXLUYcp8X?=
 =?us-ascii?Q?udwQ5TItw69BJ2soP7Iq2ywAI7T8Of/+l31nZN7+1+zwAPqnVWs0sh8OXldE?=
 =?us-ascii?Q?CBdFZ411BuCc+yKUt5LEB8vZ2v+F9VhouL42bU9e2Ke+7RCdS5i4anmOc3Yg?=
 =?us-ascii?Q?esyx9xxMgqa3Jta5HfS2JU1+yBLgRCaB7M2Z/HtueFFZXOPrGuQn+nw3zNFU?=
 =?us-ascii?Q?50294oJmjGpLJjB1tcnswYeOCe+g4HKF6nUHSOsC5NfpuUY1yLF8oYSYz28+?=
 =?us-ascii?Q?9mpqRAvIkoGd5gUpZy7TG0lF/2hVww78EkCuqvUkeunXnkwziL1heDsg6fV0?=
 =?us-ascii?Q?xOWWi4KxjGbe4x1yYvHtLYGIM8ciKIm2G2UmKz9Z51Ykcia/sd9ePUZ+vc2r?=
 =?us-ascii?Q?D8suRaLzJKl5UR33BuvQj/9j+4ITX9Nv0HU6SKbCqiqUyc7u0FxvnXKEKORY?=
 =?us-ascii?Q?w6HMsOOa+YnzfISefvS9ZVDMVS3xCCENwjfgciA1zNDU2LTkWYGRMPkaLvLM?=
 =?us-ascii?Q?YZao7z6/cC4WpOk/oDHr8H6AkTTUkmh3GimXQQXSFac03DAG0L3ImmUbO2Yw?=
 =?us-ascii?Q?hHh2qjkmdPYdTRDb0uxRbNnoPgS2Qwk6yaznAOUz+vmGJDD9jKMoTy4SYxZW?=
 =?us-ascii?Q?JV8WNqlzOpIh4PXM3tBIrF2EbrKh0sIOpI7sBmoK0GIkCTY16tqQ56IzgYbv?=
 =?us-ascii?Q?gztGr4YO/vA0ncS3VdQWOFt6FahkR57WhveRB8niLStgGqNgs1KpBKSqS8TB?=
 =?us-ascii?Q?ziXwg7cl+4mn/55oj5GrgyCHRLNhpxnewImIizjGozw87igeJL2BlvZU+rhq?=
 =?us-ascii?Q?wDI3cgsFRsaDohBEsjFhEvq04WtpczohsZc7GXxkj4GDrzCs5DoxwNr4Xz5l?=
 =?us-ascii?Q?Nyjq3d9aBf9KYF0RKkv5qj1pMLx23x+bax3HeVNLKdqATi8a7rodUPZ3Gxvg?=
 =?us-ascii?Q?EmkTsxrOjdMLGCzwI/IAy2W2rZcTenGF2c2qhCYwFY0LqXz/S69DyTiwqmMp?=
 =?us-ascii?Q?+A4fEuIg24WZRXbQgFqY/2eZwoBmR403+wWAAowXx8YWfmAgMkrPkwogbTtg?=
 =?us-ascii?Q?VMjRc2wlDoOPr5tDe70QHEMr7sTnBLs6aZWn4jeX44X0dFjRAl4jIzgCQfaR?=
 =?us-ascii?Q?Ihccojy/xuHvH3Y9KlpWHtsXcua6AltBYBJJD16S0X9qVAz6RzadRMjmENIm?=
 =?us-ascii?Q?XSmJj6mot0xEYMPRiGKb02I1p3L8XT/BQdXgFZD5mcGWxyRkA6KDXA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rDGhYQwOp729qiYkQ817cn0/w2jIlYY9K1K0rF91uc75uy3ZM3FBWEMldVLK?=
 =?us-ascii?Q?xpSpqOu4odXJ2IXvWerCOy6MqkDhEWjYVoh7NXSbjxgQy8Fd31epNhT/aRdo?=
 =?us-ascii?Q?ZWiNy7IRd1N/1zQCdE9dh8L/8XT8HNj3TFSASYYxAZCcI0lagR2WPPWYaUkJ?=
 =?us-ascii?Q?EDPderXE0vgOuoDbbPw7ToRknvVucdGXi7sUdptc/Kn3gstXZPu55SuFCvsc?=
 =?us-ascii?Q?ejRbILjFaZ97RI7T6WoNYM+F757qt/FOZ+2kaXUHlXrC3uaOHreebJXoEeHi?=
 =?us-ascii?Q?Affx8omPT2pi0gT2V1I2TlBOmBzKSd5URGRa+Th4srDjFIKrrGwRkFEVrhK4?=
 =?us-ascii?Q?FRlCA6Da7XBD15Q6weODAHnbK9zwS0X9MPQQHtWaBGByt+F3dNXTXkfreUR1?=
 =?us-ascii?Q?Hrnp1/tm8nML6p7OwLjoRNGmhKFdyqYumc+en8ZVbnfnW5k4MXKOvkWeX8oE?=
 =?us-ascii?Q?mtcGbuonAawtQOkp4/y6/I+zPDe9X82KMoqBo3XFGFram46uo6r+XEr+XYuc?=
 =?us-ascii?Q?AAYepZlACz/ISVt0g1FR9GVcvVK1CjKYfF28nmDhZP6Z5prDw2sn2WyDqouo?=
 =?us-ascii?Q?3qiA9lXXA5ERgGFFf5D0zPKv1SZdWDRCb5ocGaHweu5hFjFW4c6ASmzgDS15?=
 =?us-ascii?Q?hiHkUsw1QBm+RWsEAuB0QjaDzF4S2M179j+ABDLLiBLOnEtiQDt3aFK6ylpd?=
 =?us-ascii?Q?+0jRu56KQ2JDgA+KHAln4F3657vZnHZhJn54+UI5SQj6yHsr3Gf4RqVkX50I?=
 =?us-ascii?Q?nRqMZKX8jxehF43IktkT4kIJs9tAYjdaCpgPPB2hmLUdZe+VlulCFgTyLR7G?=
 =?us-ascii?Q?zWZrhcXuucc4vO2H03jrl2T5C1oGo6x850mRPFH8vp2l9UHmqD1tT/Ju5ev9?=
 =?us-ascii?Q?KArGE+LfAssCS3HI8zRw84BslYxvauEy8gOkEER/ZTEinVg1/UGlvtZHvkKy?=
 =?us-ascii?Q?Wt3DVOVNawftBo4Yiy5yAD8ke8ZHHWwwec+LCkuPaW8O8hlpfMOIZATvC9c2?=
 =?us-ascii?Q?IqeAcuUgJhx2U/J688hjo3dDGzSBdgpujclZO7LBAITsJ8sAGK106hEzfpEB?=
 =?us-ascii?Q?ubdn4jKIrAMtIXel6IWO7P5CK/tMijfg/rDUUIm17R4awvgkCb2Xk0ZoJ9rR?=
 =?us-ascii?Q?ICDpS70xnHMSY1jXvLxeoR+P59Z3jkBZuBiU0H25F7/vGgeRNnR3JbeUl1yj?=
 =?us-ascii?Q?TtWD1EpOx3uVKfsT3rXwzQPHwaF9cZzGEjR6YizBJ1fj5b16rdbSU/EHA2Bv?=
 =?us-ascii?Q?sb1G7r0p0cPVR3TuNjj6wveXnlkKa/KQyi3Wrkdt2t0mTaCDUWMpRxdwQvbE?=
 =?us-ascii?Q?tPqdIo9KRL+9h++KaS3RWn7F8yT792hM3K/OrEHc6oKQ0hkIySeCdEYvv9lh?=
 =?us-ascii?Q?eAH54+2FZI/zH8ab0W9SeYazOGlJQWKYR2L6BczNGmEezwzR49N7gnMg7i+F?=
 =?us-ascii?Q?c6rMPLEaEXITK8SUuMA0WIHFlD67IR6TOtSQJuxBMeE6cGqVJUuw7T9J19Hu?=
 =?us-ascii?Q?WGmAJLhkBZTn2MyfpouIFqeIdn2J15kjonhcLakVjtzVlZo/9QjVmXJu19ML?=
 =?us-ascii?Q?yG40jHzwx1tDa3z6Vg7ssloRKfmrjyNGv712ATKq?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58afe866-e467-4f68-94e0-08dd825d1783
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2025 11:50:49.6958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ebm9NVwhRB8P7hKPh3Af9Ey/EzFJfjmVy/ajsnyf8DGSEF0ULhXpWl8cCEbQpPk/d3Em7WfaEdwzpA9FsG9TBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR02MB7783

The size of biovec's memory of one dm_io_client will be
reserved_bio_based_ios(default value is 16) * 4KiB memory.
When the number of dm-verity devices is dozens,
the total memory size will be several MiBs.

The number of dm-verity devices is 59 on my test device,
and the size of biovec's memory here will be 3.87MiB.

This commit will reduce the memory usage of dm-verity
by making all verity devices share the same dm_io_client and recheck_pool.

Fixes: 9177f3c0dea61 ("dm-verity: recheck the hash after a failure")

Signed-off-by: LongPing Wei <weilongping@oppo.com>
---
 drivers/md/dm-verity-target.c | 71 ++++++++++++++++++++++++-----------
 drivers/md/dm-verity.h        |  3 --
 2 files changed, 49 insertions(+), 25 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 3c427f18a04b..986c3386aa59 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -72,6 +72,9 @@ struct dm_verity_prefetch_work {
 	unsigned int n_blocks;
 };
 
+static struct dm_io_client *verity_io_client;
+static mempool_t verity_recheck_pool;
+
 /*
  * Auxiliary structure appended to each dm-bufio buffer. If the value
  * hash_verified is nonzero, hash of the block has been verified.
@@ -449,14 +452,14 @@ static noinline int verity_recheck(struct dm_verity *v, struct dm_verity_io *io,
 	struct dm_io_request io_req;
 	struct dm_io_region io_loc;
 
-	page = mempool_alloc(&v->recheck_pool, GFP_NOIO);
+	page = mempool_alloc(&verity_recheck_pool, GFP_NOIO);
 	buffer = page_to_virt(page);
 
 	io_req.bi_opf = REQ_OP_READ;
 	io_req.mem.type = DM_IO_KMEM;
 	io_req.mem.ptr.addr = buffer;
 	io_req.notify.fn = NULL;
-	io_req.client = v->io;
+	io_req.client = verity_io_client;
 	io_loc.bdev = v->data_dev->bdev;
 	io_loc.sector = cur_block << (v->data_dev_block_bits - SECTOR_SHIFT);
 	io_loc.count = 1 << (v->data_dev_block_bits - SECTOR_SHIFT);
@@ -478,7 +481,7 @@ static noinline int verity_recheck(struct dm_verity *v, struct dm_verity_io *io,
 	memcpy(dest, buffer, 1 << v->data_dev_block_bits);
 	r = 0;
 free_ret:
-	mempool_free(page, &v->recheck_pool);
+	mempool_free(page, &verity_recheck_pool);
 
 	return r;
 }
@@ -1075,10 +1078,6 @@ static void verity_dtr(struct dm_target *ti)
 	if (v->verify_wq)
 		destroy_workqueue(v->verify_wq);
 
-	mempool_exit(&v->recheck_pool);
-	if (v->io)
-		dm_io_client_destroy(v->io);
-
 	if (v->bufio)
 		dm_bufio_client_destroy(v->bufio);
 
@@ -1625,20 +1624,6 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 	v->hash_blocks = hash_position;
 
-	r = mempool_init_page_pool(&v->recheck_pool, 1, 0);
-	if (unlikely(r)) {
-		ti->error = "Cannot allocate mempool";
-		goto bad;
-	}
-
-	v->io = dm_io_client_create();
-	if (IS_ERR(v->io)) {
-		r = PTR_ERR(v->io);
-		v->io = NULL;
-		ti->error = "Cannot allocate dm io";
-		goto bad;
-	}
-
 	v->bufio = dm_bufio_client_create(v->hash_dev->bdev,
 		1 << v->hash_dev_block_bits, 1, sizeof(struct buffer_aux),
 		dm_bufio_alloc_callback, NULL,
@@ -1822,7 +1807,49 @@ static struct target_type verity_target = {
 	.preresume	= verity_preresume,
 #endif /* CONFIG_SECURITY */
 };
-module_dm(verity);
+
+static int __init dm_verity_init(void)
+{
+	int r;
+
+	r = mempool_init_page_pool(&verity_recheck_pool, 1, 0);
+	if (unlikely(r)) {
+		DMERR("Cannot allocate mempool");
+		goto mempool_init_page_pool_failed;
+	}
+
+	verity_io_client = dm_io_client_create();
+	if (IS_ERR(verity_io_client)) {
+		r = PTR_ERR(verity_io_client);
+		verity_io_client = NULL;
+		DMERR("Cannot allocate dm io");
+		goto dm_io_client_create_failed;
+	}
+
+	r = dm_register_target(&(verity_target));
+	if (unlikely(r))
+		goto dm_register_target_failed;
+	return r;
+
+dm_register_target_failed:
+	dm_io_client_destroy(verity_io_client);
+	verity_io_client = NULL;
+dm_io_client_create_failed:
+	mempool_exit(&verity_recheck_pool);
+mempool_init_page_pool_failed:
+	return r;
+}
+module_init(dm_verity_init);
+
+static void __exit dm_verity_exit(void)
+{
+	dm_unregister_target(&(verity_target));
+	mempool_exit(&verity_recheck_pool);
+	if (verity_io_client)
+		dm_io_client_destroy(verity_io_client);
+	verity_io_client = NULL;
+}
+module_exit(dm_verity_exit)
 
 /*
  * Check whether a DM target is a verity target.
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index 8cbb57862ae1..f28454f81249 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -75,9 +75,6 @@ struct dm_verity {
 	unsigned long *validated_blocks; /* bitset blocks validated */
 
 	char *signature_key_desc; /* signature keyring reference */
-
-	struct dm_io_client *io;
-	mempool_t recheck_pool;
 };
 
 struct dm_verity_io {
-- 
2.34.1

