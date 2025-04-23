Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012033.outbound.protection.outlook.com [52.101.126.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885A18BEA
	for <dm-devel@lists.linux.dev>; Wed, 23 Apr 2025 13:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745414091; cv=fail; b=Och2LPPjKUTxUpbqEUMXrqV1C7K2h94YzYbQi/etw2UPda3kmv3SxvY3qlB3D3OV8I4ez3wUaZZeJh0LWn4xf2m5UbtsFui9xZOhFeMZnA/G+JzgKLAVcILTlL+C8cSSFr9PXBhPXtS5xotDybBuTThx4X9o1P4zkmiCW4Vd8lY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745414091; c=relaxed/simple;
	bh=roaNXNn5XFF3RsoMzaqp9v3kaRpYV/t0vmVkEidJ/KI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JtDaE5otcZZ/R5hS75Os4TWEy+aw6RoojgJfrppHvOUavEMa9NCyx+vp45sI7LOkNSbmL4bFGKkhTRrOpOyWsI0cPoL+Ez4tF3TPtrzJwqNN8iQFpX0ViwT/60J+/iQ5t6+Wn1sT8JaiDw4RC9pYlM3slvFPGyzhUP3OBAaM14A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=qyUvSowp; arc=fail smtp.client-ip=52.101.126.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="qyUvSowp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DtmT46pxsi3gaVzVZBcYIdSEqA3mn4DphNrTRJnX36Sb6507vQZXQwAKP9zw0CSwsdXtHM20cR87gF7QEN2onsPiowT1EpLr0LMm3dNU7hiYqtonuLNJ5ze62JZolJyiPr3g6aEjW/V8uL4/ojRkFiQXxTv+rnsamL8QyuIkdEhct1fyqSPvzuWbY55Rv9LNdzarNCHWR04dMNGi9IHe6SWUwv3Sc2767anT927ROJnLvLGBnmPgLbxb1AnfrKmftediWaaWiS+9PhglxDA9o1FFJ7ZfRJ/0LUh8b+J4+oe48H6Mv+8/Gesj6fanojBnhhiemdxfxtGnsnQHc3tYPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6zbVkZb7HrmDzdjQ6mwHrFYyQDes8KGcYjbaYoISKXA=;
 b=jaldYwbHk3xBa1EwekT6qCj0SuCO1TR8Op1OOQ+APgqLEa8eNBNZeN3DvgQRqIqo3gHYRfd1zQ2BL6cy743jgvdtTyKPrxSCFb8hPFtcNq15gVGf/deicfSr9csLz6EnqoXfMyog+2LO5qhRNefnjq18q6f7hQznt+tvY4CafczHlP03WcjeXPO+Eqz1QX8dfiisXJAUuLbFd1looiao+AwRkypwrSsBFxSkb6e8FKTAxzvbarilzTTfkVwRSg0HlYaSfOVjoynJasKa10NZxA1oMOVoPpmQQ0g+/jcNsW6loQWPknlQW54v5luHV5ligI0ivyklxxbR8l5tHJouOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zbVkZb7HrmDzdjQ6mwHrFYyQDes8KGcYjbaYoISKXA=;
 b=qyUvSowpfVNKQPRTpALuYnaIDHn2YF0fpBr25oYc0YJ8kxOitHz+W4bQ8U6hFJ3S8XGXevlkGmnswHRaTTDBnR/jGLSQfgmuy+QM2UF2ZljSfm+ktPVIa9yKgKQgREr63NyZkMaWzjZhbfYKt4C1JgD6Pz8tpD7onzbS0Lqfrx0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by TYZPR02MB7770.apcprd02.prod.outlook.com (2603:1096:405:6c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.32; Wed, 23 Apr
 2025 13:14:46 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%5]) with mapi id 15.20.8655.033; Wed, 23 Apr 2025
 13:14:46 +0000
From: LongPing Wei <weilongping@oppo.com>
To: snitzer@kernel.org,
	mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	guoweichao@oppo.com,
	ebiggers@kernel.org,
	LongPing Wei <weilongping@oppo.com>
Subject: [PATCH v2 2/2] dm-bufio: all dm_bufio_client share the same dm_io_client.
Date: Wed, 23 Apr 2025 21:14:11 +0800
Message-Id: <20250423131408.26608-3-weilongping@oppo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250423131408.26608-1-weilongping@oppo.com>
References: <20250423131408.26608-1-weilongping@oppo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0008.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::14) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|TYZPR02MB7770:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e837809-9544-494e-f97d-08dd8268d195
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|1800799024|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?A7yXoQA8u5ECXHUB4Tl0f0BpicyDrNe29YsFE+pqOtCytWTddHGbaz79XnvZ?=
 =?us-ascii?Q?a+EQ7xNcjXRUMHZSU9Qw1rsH8+6KSLMuu6dpZ7QBf8GoWMVSvmd1Ldch5nkR?=
 =?us-ascii?Q?TxMKkjGJ9ad3p5d2KhWFOqw/Al8dYivEHc6PEs/REjoYPzIdorqKH914zbGx?=
 =?us-ascii?Q?BHh0uayg+ACMwPBwqe1t0M4c0zmKv8wGDSxI6FHdFMJrtgxpjeYlT5KLzV0p?=
 =?us-ascii?Q?1hYU4rk9bBuCpj+6IaWce3uJOTXU0rq96XLyfBcbvjCIAKwx2zZMt+3cjjWr?=
 =?us-ascii?Q?qMpXGsCAN6LR2/RKV1AxfLxtzq5zp8Pdmw8eiBIaovzJahDsYmoV1cD6VRQ4?=
 =?us-ascii?Q?AjrxL+WqXV2ALA74VfVbNsOypvMz+/cUrB4AGu1gg4q+nKeB0ENa1ZOvJ/Cs?=
 =?us-ascii?Q?sSWc8QrLU2bWFRP0TTBHoSHnMkHtPxO0XsOnwdomvBtlG7YAhdU/KDm3y+BD?=
 =?us-ascii?Q?IaA6y8u1K3HfRfXZXvHe97hID41vtAZT9ojQS951GM8tGvTCzK3kQAHUiMb6?=
 =?us-ascii?Q?V1gHmpCPo0pj0bIOC3g2qNOw5UWA9dm7EbLQG5oJ7OoLBdo2NYhrGat+dex0?=
 =?us-ascii?Q?9z5Ddc1uGYJpR+VgYvV308RimahGgIdbcH1zWamuIUwvHsieT8uVDuegrXrU?=
 =?us-ascii?Q?CoWNIQaI08+ppx0t9lFVUv2zF9JJY7tFI38P8eVbjfee6ZViR4erZbfQgb74?=
 =?us-ascii?Q?86qY968xjrp9x1JELkg22TjBXujkClFpFpcBXo1NU/rShaZz+Y8vxePFv8N1?=
 =?us-ascii?Q?rtvKW2bs6wvRI4PXw1XQlSQyZYSa8h9zMpFkMauPCfK7ttzaYvHIZCSg06tQ?=
 =?us-ascii?Q?t13QyqBpiPnmYX2Il3XZKR60py34UFZpzdSLslhQzlSs8comcyGfRkxmpe4n?=
 =?us-ascii?Q?+24UKAgSUJpHqM7g1CiO6ct/6g8JtUV7T49RNBim47Avj8IwdX9Fu2t900Uk?=
 =?us-ascii?Q?i0Y1SfgRWiifskAxZhMuoTj/ARddjprqi76zshbxSSVdoxtWFY9ayiyLHdZp?=
 =?us-ascii?Q?hx9gTCEDbEM5udW6qZ5KaNd0eFuqj7tK6cD5VedQqi2vzKUoazdAI0FUXyTN?=
 =?us-ascii?Q?MrnfAnykJdwuSqoc1hq0L7Pi/JS0zQ7p6ifoc/iZAzQOy+Z7cf01XN1F2ke6?=
 =?us-ascii?Q?UPndbCAQ+eAjV6r2CfOoNX/4qk9N7JW8N7ckNIWGedU4RXn9Q2MFMz4SKF4+?=
 =?us-ascii?Q?+oHkdFruUqWVZA/mzyTw0qtuwUP/zjBU3e4pRRU+mD81EPoFTbTwEwYjCENY?=
 =?us-ascii?Q?FZr7DjOyOCxqsB6lnG3WfbQ44DKZjNY8s7rGATKWUb52yaZfoME1Qsrg9wfs?=
 =?us-ascii?Q?+9zn6pytVGBv95bti9ke6R+CAAdV/dFpxQqTfDtuex1/k8qqj7EOHw/MpWe0?=
 =?us-ascii?Q?0Q/IuPjdSKBocz7jmnIu8w1IbFxquO1jy2e6wF5LAU/DY/3TWCtd1V2/JnIs?=
 =?us-ascii?Q?tpSHoECEXwm4Ok1aAAdH40XJKUHfIAohaP9DxpUI0FEwwJe16K2Ugw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(1800799024)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7gEZxOcweuwCzkQi9Cr+DDMFLaeYozZBp02DDjsMRREr/8McblTM5ZUyApr9?=
 =?us-ascii?Q?0r4Mib74eUkTyt8brZkVMk+Rqu+TB9WnHnk/x2Tht8xBKPXO0sdeHr8hT4sS?=
 =?us-ascii?Q?XQU1Qr83va88EzNuJ1wbERiJKuG+98VK1B7bBS4KHxKRy2o6oLC97k5Hxf6/?=
 =?us-ascii?Q?ZJpwIWQov+m9hyz31hMMNMEIcR2XryohYaQ38evbUdrKOkADeEacz1REP6Oi?=
 =?us-ascii?Q?bQ0N/fBXPm28FWwetpJRLp51bRQ0a1JsyMRuKadjbFCsrJh2n7vaAK0s3Ljr?=
 =?us-ascii?Q?oqQWJ8wR3QMSx4W08iaaiLlFxKo+v5AkmDQnKetn12OCmM3NKycvQ4yeFaD3?=
 =?us-ascii?Q?ATr+ay071wDgOiRQfc73lHjjNi/Pv8LpQUqNeqQ8xQnHF0vWLL3gfLG0VtYB?=
 =?us-ascii?Q?WHsSykkdTK+ALA9lmV57Ih+TFlcj39wl9ARSsbvLKUY+zgChXl4/TaXZo2qg?=
 =?us-ascii?Q?yEFZS9rGbDUkxi1g+xfsET0gvO0tnEJoazaL3n9O8wdeMmCHZ7Ufa+UiCBuu?=
 =?us-ascii?Q?sDViNBCchLtIA2ZWPcZZDJmtG2QQjDFa75ijt5IHI+gR+8mirumBm9VnjSUO?=
 =?us-ascii?Q?gIZFIU+oObTsDP9q30kKnXWlGRw0ynl312Dyf5uKFveFWa8yDx/t9H7YzdZz?=
 =?us-ascii?Q?82STnL4jRWo2ePbYA3haowqsUZ9kXTLQHAzlMdHYMGzvGdA9gCuahA9L2ZBE?=
 =?us-ascii?Q?VJTlAKfKztgLndaPjJz6R2nhpU6yjg+KAQli2TDgeBbCehdPatBlza4nXOQA?=
 =?us-ascii?Q?E2v8w93n4js/BWfnHqP42AT5PMB+CzrL9Wcwt3buYANAO1cxE0LL1vj7n3zW?=
 =?us-ascii?Q?KqruJiqlbBLP7Xy8LLBmhVgqCps+FiJPlzDW04Y7eNNNTwwVoCxT+T4WYK8+?=
 =?us-ascii?Q?nN9+5uEP2c1IF5WSst8z61RVvrT1ma65wQnnXRhzX7hJH3uduiic9fW7acLO?=
 =?us-ascii?Q?Pb9s2dtSREOB4gKu510pbUFSXDIawSykNpTArnpBMRTvtszmRfvY9EL+xbvM?=
 =?us-ascii?Q?S3+vtwCkbrwLdT0WK8kjZdta0vglPToGWra0w1cjJzDLaycFArAfD8ZHsgfy?=
 =?us-ascii?Q?LbrrTBCIPs2o8BysLna435wsqWGlugjdgcWgDDl142UR+8nCliC3KXFdtgza?=
 =?us-ascii?Q?1BCxsiMFdO80tDVPFP5v2DqOlzu0nSgTFjvA9/Aqsb0di90lqs0dtjtgYYuZ?=
 =?us-ascii?Q?1PyyOduTiwfsBUQOe9nf6j8zUzlgW0Kl2saSG8XgzN2Hc7X9lDxfOovXxBvr?=
 =?us-ascii?Q?uJ6v8Lz+Mk6fPHJ+QJTMHwNCdxiRU7+/aBpSe+6A0BLrHcW8BkzYEtsvb3kp?=
 =?us-ascii?Q?k8dGscO8Lbi+FWIq3go2XfSMO15tHXmao8lFrrvZpNaabjDgbo2geR/isQSD?=
 =?us-ascii?Q?VLoqN25fxmsmhLxUlT2LkUpk2iBj6g9MLkqTCFgz61NxQq2D2tp1YF3DC+X2?=
 =?us-ascii?Q?dPzVALSaw0C2w6bJ/MA+sp8nH9ZFs8rrkeL6AF8XQSQbkCfsRQXkK6/LvAOf?=
 =?us-ascii?Q?txCwj/APkMxGDqNMwxkXgO4Z81f7Y4zTsmoVSiBoPEl1KxpfGXy6neAJhyIu?=
 =?us-ascii?Q?fYHPwQnp4S3E1eongb7Z8srE3CLZ/uGSoRHljAaz?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e837809-9544-494e-f97d-08dd8268d195
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2025 13:14:46.3353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZcqyY9fyQgiBEhvAGYtT5uPPlKtSTrM34DxvohhawN9eAq6R5DN8Bku6jicErI7P29/fqurfnUIJcwWAPS2QnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR02MB7770

The size of biovec's memory of one dm_io_client will be
reserved_bio_based_ios(default value is 16) * 4KiB memory.
When the number of dm-bufio(dm-verity) devices is dozens,
the total memory size will be several MiBs.

The number of dm-bufio(dm-verity) devices is 59 on my test device,
and the size of biovec's memory here will be 3.87MiB.

This commit will reduce the memory usage of dm-bufio
by making all dm_bufio_client share the same dm_io_client.

Fixes: 95d402f057f2e ("dm: add bufio")

Signed-off-by: LongPing Wei <weilongping@oppo.com>
---
v2: destroy bufio_io_client in dm_bufio_exit.
---
 drivers/md/dm-bufio.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index f0b5a6931161..bb9b82225744 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -70,6 +70,8 @@
 
 #define SCAN_RESCHED_CYCLE	16
 
+static struct dm_io_client *bufio_io_client;
+
 /*--------------------------------------------------------------*/
 
 /*
@@ -992,7 +994,6 @@ struct dm_bufio_client {
 	void (*write_callback)(struct dm_buffer *buf);
 	struct kmem_cache *slab_buffer;
 	struct kmem_cache *slab_cache;
-	struct dm_io_client *dm_io;
 
 	struct list_head reserved_buffers;
 	unsigned int need_reserved_buffers;
@@ -1311,7 +1312,7 @@ static void use_dmio(struct dm_buffer *b, enum req_op op, sector_t sector,
 		.bi_opf = op,
 		.notify.fn = dmio_complete,
 		.notify.context = b,
-		.client = b->c->dm_io,
+		.client = bufio_io_client,
 	};
 	struct dm_io_region region = {
 		.bdev = b->c->bdev,
@@ -2197,7 +2198,7 @@ int dm_bufio_issue_flush(struct dm_bufio_client *c)
 		.bi_opf = REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC,
 		.mem.type = DM_IO_KMEM,
 		.mem.ptr.addr = NULL,
-		.client = c->dm_io,
+		.client = bufio_io_client,
 	};
 	struct dm_io_region io_reg = {
 		.bdev = c->bdev,
@@ -2221,7 +2222,7 @@ int dm_bufio_issue_discard(struct dm_bufio_client *c, sector_t block, sector_t c
 		.bi_opf = REQ_OP_DISCARD | REQ_SYNC,
 		.mem.type = DM_IO_KMEM,
 		.mem.ptr.addr = NULL,
-		.client = c->dm_io,
+		.client = bufio_io_client,
 	};
 	struct dm_io_region io_reg = {
 		.bdev = c->bdev,
@@ -2310,7 +2311,7 @@ EXPORT_SYMBOL_GPL(dm_bufio_get_device_size);
 
 struct dm_io_client *dm_bufio_get_dm_io_client(struct dm_bufio_client *c)
 {
-	return c->dm_io;
+	return bufio_io_client;
 }
 EXPORT_SYMBOL_GPL(dm_bufio_get_dm_io_client);
 
@@ -2530,12 +2531,6 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 	init_waitqueue_head(&c->free_buffer_wait);
 	c->async_write_error = 0;
 
-	c->dm_io = dm_io_client_create();
-	if (IS_ERR(c->dm_io)) {
-		r = PTR_ERR(c->dm_io);
-		goto bad_dm_io;
-	}
-
 	if (block_size <= KMALLOC_MAX_SIZE && !is_power_of_2(block_size)) {
 		unsigned int align = min(1U << __ffs(block_size), (unsigned int)PAGE_SIZE);
 
@@ -2606,8 +2601,6 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 	}
 	kmem_cache_destroy(c->slab_cache);
 	kmem_cache_destroy(c->slab_buffer);
-	dm_io_client_destroy(c->dm_io);
-bad_dm_io:
 	mutex_destroy(&c->lock);
 	if (c->no_sleep)
 		static_branch_dec(&no_sleep_enabled);
@@ -2657,7 +2650,6 @@ void dm_bufio_client_destroy(struct dm_bufio_client *c)
 	cache_destroy(&c->cache);
 	kmem_cache_destroy(c->slab_cache);
 	kmem_cache_destroy(c->slab_buffer);
-	dm_io_client_destroy(c->dm_io);
 	mutex_destroy(&c->lock);
 	if (c->no_sleep)
 		static_branch_dec(&no_sleep_enabled);
@@ -2944,6 +2936,15 @@ static int __init dm_bufio_init(void)
 	if (!dm_bufio_wq)
 		return -ENOMEM;
 
+	bufio_io_client = dm_io_client_create();
+	if (IS_ERR(bufio_io_client)) {
+		int r = PTR_ERR(bufio_io_client);
+		bufio_io_client = NULL;
+		DMERR("Cannot allocate dm io");
+		destroy_workqueue(dm_bufio_wq);
+		return r;
+	}
+
 	INIT_DELAYED_WORK(&dm_bufio_cleanup_old_work, work_fn);
 	INIT_WORK(&dm_bufio_replacement_work, do_global_cleanup);
 	queue_delayed_work(dm_bufio_wq, &dm_bufio_cleanup_old_work,
@@ -2961,6 +2962,8 @@ static void __exit dm_bufio_exit(void)
 
 	cancel_delayed_work_sync(&dm_bufio_cleanup_old_work);
 	destroy_workqueue(dm_bufio_wq);
+	dm_io_client_destroy(bufio_io_client);
+	bufio_io_client = NULL;
 
 	if (dm_bufio_client_count) {
 		DMCRIT("%s: dm_bufio_client_count leaked: %d",
-- 
2.34.1

