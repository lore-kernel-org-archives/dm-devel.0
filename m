Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013051.outbound.protection.outlook.com [52.101.127.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8265C8BEA
	for <dm-devel@lists.linux.dev>; Wed, 23 Apr 2025 13:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745414086; cv=fail; b=pogNyrwNPZpeQQEPiMTTH1hc18ItGeEsr7LbIPpOf4Wk3o3+N24Pso3MjYS+KvZJKeFMGlKJUuzmnW9LbL0UJjWn2mom/XohSkZ4ao3TleB+SGtcphj8gSBE5XJ5kzVsOGmMuINuL8hMEB6lKyQzN/E1Wp86pRq1VpLWxIIHqgE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745414086; c=relaxed/simple;
	bh=xNtzoLW3F3/vEJmnJ/wHUTGVetYFvOA+nX/Imqn1ark=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IX1c5qrsRDpvatwq7RZcDDSxt+Vmvg1w5YUx0udp2DjKpzGmmacVrtQqvSuiwk7BEkQ1xDnTdTCj+Io1ldxUM6Q5vKodcUYwBx2P4Rm2/SWxpM4Kv0DnFXfrCzUNxNphVf7V1iNpNGgUcQk7Ly1Q5EJXaYltTNrmh9mVhMCGlbs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=f7qeMpLG; arc=fail smtp.client-ip=52.101.127.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="f7qeMpLG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pmYa/GFd8z277lhMPxcVshHjSvH68mBIFaODX5jKnVpi06dCURaU8noM/WnCRcBqMEW+ej5m/ZCiH/hmDRgDdDbaMVllsabmK7qJVsOqMu8zjgZHiWbJnaF49dNZ0GVW36WC/v+NJ9wyeTkOokzdYGhSkP1wSjSlj3TRFVX4i6HI2SWEJYsLu94+kUZL76XMBPVn966UX6xxQ5u9oJht6G71zvNW362Qf+UVyp1IuzVkI8OBuVuxYXOH8UTSs/C4UDy7Mm0xJ+WNqtXmcJ8uzySnK32YmV0el7lvaqSwnkSazb780kXgaSRYT5AxTS/gG/h+bVkWmI0icZCXjiDOXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ARnTaTQKE4DbxrWYQD2WFyUO9KHIlmEZdmpQ5sB7nGs=;
 b=AuVuMO/m1+tiWyYp9hkzvQmp+OA0EsDuzFxM6Fsx6fGm+ORvAgDqQmDrtUVGqB9LO3M6sBr60tpCwxbFb8bOvpdBz7c7eLxPuT1fhMNaP4PETGPV2IxgiiF8L+/+pib6PGT3SUdqGZDo8YuuSNtTjaX3dAP+vnYmnqvyNH6hIQmKbG4neFfTrYN3fkHe72Ks/vEJtvhEUo7BO7guH1YRck0cByzxG5Po0UdCfN2Q7Wxbe+esYouG/+fd+dl1ICecygPxX/0yflbcPVUNS0s3gWMbfMhsBqq6oW1Dkso6ggtDcYPheyTn5zJe+BTT44a4hFA+tkH5GL/zj4ok6eo1Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ARnTaTQKE4DbxrWYQD2WFyUO9KHIlmEZdmpQ5sB7nGs=;
 b=f7qeMpLGnFqF0kjzqK0BILWCDOtbV6HPIalUJ+0Rc3ZAGdljkytJlb0OIHuTqcdFffU9NBMOmiRjsOWbVgmy3S1N/kas+xRODDYbujBk4p5PYRNY/wWy1/J5dDvwAHCgBrHwkhQvdclBv5jyDIiLqMzJwBFwlTxL8k2O+4kFeq4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by TYZPR02MB7770.apcprd02.prod.outlook.com (2603:1096:405:6c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.32; Wed, 23 Apr
 2025 13:14:39 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%5]) with mapi id 15.20.8655.033; Wed, 23 Apr 2025
 13:14:38 +0000
From: LongPing Wei <weilongping@oppo.com>
To: snitzer@kernel.org,
	mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	guoweichao@oppo.com,
	ebiggers@kernel.org,
	LongPing Wei <weilongping@oppo.com>
Subject: [PATCH v2 1/2] dm-verity: all verity devices share the same dm_io_client and recheck_pool.
Date: Wed, 23 Apr 2025 21:14:09 +0800
Message-Id: <20250423131408.26608-2-weilongping@oppo.com>
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
X-MS-Office365-Filtering-Correlation-Id: a77cf1f5-815a-4c1a-863d-08dd8268cd0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|1800799024|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mHF43xxG4BuLcgZMJ0+J/jk7FBt9tM1MfwEawTGjlmXQQKsskkeLmZsqz2HK?=
 =?us-ascii?Q?FD7rkkIFg7f5GGW/LtdR5/kU9dFhjFy3aOBSGwY5AmsOBGNLTqkRdtIHnJmO?=
 =?us-ascii?Q?RAdrVmPlJH0AiYf/9kDzHQiFW8QFvWm++FZp9oSh6mWeRioOiVHOKRR3B00X?=
 =?us-ascii?Q?TlDV+F54EQMImpbrbL7wH1fxMq/J0HoM3xALrXJ724GWSJn420YZXExwzRAH?=
 =?us-ascii?Q?9lTlPttf825AQj2RUAzZ+ZuILcYCL6CLKbtH2ApvGuHq1ylZt040onx3WVkV?=
 =?us-ascii?Q?q/okh7r5OCK4mX4nmrTWWs2G8UpdMSBHwtKdbqRtw+HrooqFjtr76to82uf9?=
 =?us-ascii?Q?P7Phkgcw2Z27QtKjn1ZmDO/bcuyhZ/WP1c9e16Nl4PNQrtgbWDrRlq/kEe4W?=
 =?us-ascii?Q?ykPSmRJyCVq9Tb7L7e1uOgpPTRxLo1o+dHrqe8IojVDI8ld5PR2QZ2FigH/M?=
 =?us-ascii?Q?DZ9LYd9v3nhRc2bcdJP4iarf+Nuj34BxvktQa3/dY5Nr1aHXJKNzeeUOpLFl?=
 =?us-ascii?Q?RMOveKUmsmcZ+OtLFD3vqZPcR3oxF0jxirjxhFJeeo3sN985yncGEBGtBly8?=
 =?us-ascii?Q?nRAF8iotxAlwVg7iyW7afUFqGD9wxQg1andVKJemw0Zj1iKEWIXDV5ap4JJX?=
 =?us-ascii?Q?IIhDYl0l9trHI/VZdZ+o7QDDWf0k+/GjRXbe1mDq+vc8po+SDIS9ncgv91+T?=
 =?us-ascii?Q?uEiUYQmKW2zjr2H+x3D8pzAzJ/M5aOCMwB+2GRmCfCzkxJUk56SKYV045bXQ?=
 =?us-ascii?Q?JRacEVJzBItu4ASS3GZWbQoGIrMZ/6ru1fGJw03Uv2rqFyR9j9i4xJ+l7yq4?=
 =?us-ascii?Q?LMRvGib5qz0ezgsXcjF8WxUHmoSSrZh5Q7xznSfL1A2qZW55jUA4ii29YjRC?=
 =?us-ascii?Q?9jbJE5WmeoRzkrfBk0hG1KDxp1XiFZyz2FlE8I2zrGgFrbSrMgOHOYwLsxTx?=
 =?us-ascii?Q?sh1NnsZDEh18ianf0NoEcJo3XGcnA0gOgFOD2sjyO8PbvVuxDyT+i4SQjOTY?=
 =?us-ascii?Q?Ko6+n/20EL5Ov8MmSwsYcq8OvF9cVPdEK4yki9IG5uYK0YIaG1tf1/BJ3sQk?=
 =?us-ascii?Q?TeyIPhgroO9X+JpJ1IaXY9ShYDre9R/Yut4Qna4gksMQlJY6pKA5F8LNL+HJ?=
 =?us-ascii?Q?Qn/GJAuLYpRBj2pXUVwl4eDr2xp9M0gmUq3h8Mm2ErQk6Z7AcfPJ3MBm4onO?=
 =?us-ascii?Q?cCza9UZYptkp9Lq6soxAqUoO5lkqL9ccDTXx1tO2mVsgsYdggsn83vMh4zQT?=
 =?us-ascii?Q?hZlu34guFAwgtQkpqSW5Rc+9xkZLgVsEeofppPr97Vbo9eHki1kxIyzM6lD1?=
 =?us-ascii?Q?eRaAwttJXPBwtxOez5Ip5N47nnDyCYMNjCTBSGx8/Z9JSfsqD4FL4jv7umww?=
 =?us-ascii?Q?jNCAvtD/JI1A1nK/QdHOYotmXcambd+n05B3VDIDIPBMxOAPfcwUUx3uUIYe?=
 =?us-ascii?Q?8uoWfxEinCIOk9bGZ1Bau81ehwAziGVG6bHo6gVzAHzst2WbLMocew=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(1800799024)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7J5S4jhsqgBjhQsxNWpZ07mzeafhvqkeLKpUZLPt+mY+NcseyQ4kHJRTYZy+?=
 =?us-ascii?Q?sXYdfoBVjb3RcGf4rWl48DrjPRoJqr7kI870WI0S84Vj3hlFJpv+sNSO/KDZ?=
 =?us-ascii?Q?Dm8dcX9UqGweyOB7VbeNQO0TLJ2fRxS4ynJu0bMFrpcXGy/aNBqPgqDDIk+b?=
 =?us-ascii?Q?tYuEA1kNyqRkB5sRb/WGD1dfX8X01hhzh5pWiuXnPcTM8YLx2RZgGLwLDvNW?=
 =?us-ascii?Q?p7qYANgk3bT+XYQUJXdUSnRBz9EQld51IsIipLSX8Fmm31WyClXn/63VTUxI?=
 =?us-ascii?Q?0WaItHx+rohXOhbAqznCltF7FLDGP6ha0wCO0ga7B2CA9gHQKW/VZZwQkMk9?=
 =?us-ascii?Q?gFJC2kdmWRD3JHLutb/Dm9VOxZD8At2dsyvoU9KzDSLsUtOkfSG4CLXc3A1L?=
 =?us-ascii?Q?shxglfMomcOOcQFn6kFYDy4iNFrqnOV2+hEQbl61wJBY7vpV7Lqndmt1pPu9?=
 =?us-ascii?Q?npuxf3mMO/7UvtUtHSIhwz9AeyAdpv+RH/vsFTVOyZm/uCfJ5YlYLK79c9vX?=
 =?us-ascii?Q?rLDDZJFUA68Xnh3BGyELQ4ha4J5q2y0sVzhX16KdW9f8yW+XbGGwTMAwT21A?=
 =?us-ascii?Q?f/esZg4ErdBn0wD98T7nx1aaDwv23jqcN2Ub1rMrIqse10SD8auXS8UyXYR1?=
 =?us-ascii?Q?p2wNWJ+Ps3nF25iSf/SKb699BELIg56RTx8r09hDZzb7BimZVURGh5aMSelU?=
 =?us-ascii?Q?Wf8jE6mjAL7OIOa5T/GwIfVGbhy9xaaZwUiFz15mOUVVTnHlkpeIYOxuKxu/?=
 =?us-ascii?Q?b6Cg0kbgAMI267yiPtrbjxVWbjTt75GCDpnekG58jtADH0H1+N3AK+thL09q?=
 =?us-ascii?Q?6WeMrBRiKWaT+W7aa994PWzX0BtH3T+oBinoWmhDRDqGvilAIVbBNUP1ty9Z?=
 =?us-ascii?Q?A8ZsGyl44s4QGJeR9bcvIvlLr7jfkOcFAD+dDhh662em8rIAS5nY/Nto7NUQ?=
 =?us-ascii?Q?PdTitG0ImEiVrvmxfJFTrNKSgye6lU5EQLupENLp7y3hOen656CSK1v0udaJ?=
 =?us-ascii?Q?ZXQrYpwkZF+4z/fsBwpNf7kTNi3q47jx9Zj5NIa3JQunPq+4u1EQdWZiU7LZ?=
 =?us-ascii?Q?6B8wqdhY5NYAV8u3h4QwFyDMTPgnroGsJeISmqSffYNTctZ9JJD7gyZh+vIW?=
 =?us-ascii?Q?OvbHOo4tyF7rrfFejOpwZxvG0mGRxFibbpzHkL5UYAxZX2gf+mqJcyyztaLf?=
 =?us-ascii?Q?nCurns8OpjQB7h+FVSxY6o8utUc1qz/zlMe8OkKKj+aukGe1UprDJEQGzMGv?=
 =?us-ascii?Q?lmTOrb9bKLVCD5iaHRqtVLeaHmwyT3WFldgTXoSKNmPDkcPPWJE91lJiuTlD?=
 =?us-ascii?Q?A+Ug44UfkJmYN4SV/iEq48HsoHih88lp6tY4JLgIBT789e9zWi149Udl0PrS?=
 =?us-ascii?Q?0cPZyoXdPeSu4BySR3rxLFC9s05FBTOuNe5UwJEZHWHrDUiLQn3o5YmZ1he9?=
 =?us-ascii?Q?5BQTBroM4k7dTHwr1rBouj+Gn41kMYJXGqOi7eFqW7yIVBIKxtXAnvzvP6Tv?=
 =?us-ascii?Q?ybI6KB92v1LTeiDIyGVqzD3mnAivLiMLkMRjVYE3xWurgvbHfybU3t9UoQiF?=
 =?us-ascii?Q?SQ2Objqjattyw9HzlzebNhEXlU/nJNbolJOzBRga?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a77cf1f5-815a-4c1a-863d-08dd8268cd0b
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2025 13:14:38.6875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1vyZ2ZQjg/qVgg1KqoFCfYE/nb36BjOxeuftqXLgKWvu/pq7wFgqUxVw+wJbfaMNj3yaUj5TCBaNEMqKZ9BY8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR02MB7770

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

