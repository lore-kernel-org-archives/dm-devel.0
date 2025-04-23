Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013064.outbound.protection.outlook.com [52.101.127.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0716BA45
	for <dm-devel@lists.linux.dev>; Wed, 23 Apr 2025 13:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745413624; cv=fail; b=YnUOuzxkpeGAsXTFIHKLWQ2FzYg1pJV8AglNkkT6UYuWQosFRIuLwNkMvZIr6xClCjN5bGWXWQbH4cGRTAMu/zwz3MnK6nUj8q4btMx5mceOIB9Vlv3PxzlIgY2D+nlBLGFZE90DaOnCv1lnpETLhqw05TBOJoThRMFr0X/2Tgk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745413624; c=relaxed/simple;
	bh=xNtzoLW3F3/vEJmnJ/wHUTGVetYFvOA+nX/Imqn1ark=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=p0Wb7heSFP8Q1X/hvkteP76MgklLoUPAbowfbAKMsvejdjJUaq+yL3K2dMbM6mcvPu5I3o0D7pKGmwcOYnmU6P9RoaKwrfsV7AfjTEXlQhM2c0Co4H8LdXVekzBcqrQrOkZYSTm6Pl4aY1Y/qe2pPKKwUIk8DHmQBwAHLSslH+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=Kpnq4SCd; arc=fail smtp.client-ip=52.101.127.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="Kpnq4SCd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ntdwSDeP/qfjMcxv0OARfZlP+vfH7ZW2t09nguHsfDh2SNsECH9nrOd/qbLJ395tg/EjZwIH7SxPXrxuKwtz/tbjyRVKJmnEAIc2ZeOvwXVuWOgLrRxpe/I6YADsNmHkir9lWaTNeE/eMA9LEubQ+rDDVXFoNO3XzoJ17AXx9FfqBGVrAKld5zVrohRrIb6PgOkq4SXX5fFK40f/96xMwummfFi6PizKLfJlEzmkUp4xL2/lpGiALDER5/yph6JTp4Dx+0gomo8FvjNTHRmo8L/oGn1UfeHvoBqPJFRjwoj6ABO/qQJ28cd84HM7Yo3UO3wwnxB2eXfXCbHM6voYag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ARnTaTQKE4DbxrWYQD2WFyUO9KHIlmEZdmpQ5sB7nGs=;
 b=eFvY0y2G6sSjpSbY5AoRKUWVA/vsRIw6PJL262o7ozztbNoEBZXUabFw46deKdDszgh1dD3u87jLpo6Pj3Q38cqO39ysHug/O2tvtL/rnK0DkAzKsjp7iQV4XzJIXI0qNCnpyxKd8nXQeNfxF4ctvH3Z86x1+XtlUZipWHMF6JYILrDzQ4VAH0JOG07fZrkOAjX0WJFalmajNoVK9MwbFELZ1JTx+nQfsnAQtfbBcErCmQncz28X4BtU8HOdRzjuLQivu712vhpx+aW5+AtruZrAEGRH4mMmB0dlM9Ipl1DGiGCcKchWk3Gthr9H9wsaFxvR1w5G8tPxVMf2Vm3yTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ARnTaTQKE4DbxrWYQD2WFyUO9KHIlmEZdmpQ5sB7nGs=;
 b=Kpnq4SCd1hLNPlhV14Kle6hOLtyRHadIajZ9X5ldD2IL6x3USXE7Vh5mzISBdcEVaq9NO3UhPue29NxoLD2H5xk0HuRT9r/VqTSiYJ3smf0kRhL+l9XdSVcfjHTTXOyfzTAwxQEU73pES2EQThhkOybaVpTChNdf8kinW25+SQM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by TYZPR02MB6711.apcprd02.prod.outlook.com (2603:1096:405:2a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.27; Wed, 23 Apr
 2025 13:06:59 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%5]) with mapi id 15.20.8655.033; Wed, 23 Apr 2025
 13:06:59 +0000
From: LongPing Wei <weilongping@oppo.com>
To: snitzer@kernel.org,
	mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	guoweichao@oppo.com,
	ebiggers@kernel.org,
	LongPing Wei <weilongping@oppo.com>
Subject: [PATCH 1/2] dm-verity: all verity devices share the same dm_io_client and recheck_pool.
Date: Wed, 23 Apr 2025 21:06:16 +0800
Message-Id: <20250423130615.24793-2-weilongping@oppo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250423130615.24793-1-weilongping@oppo.com>
References: <20250423130615.24793-1-weilongping@oppo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0129.apcprd02.prod.outlook.com
 (2603:1096:4:188::19) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|TYZPR02MB6711:EE_
X-MS-Office365-Filtering-Correlation-Id: 81963aaa-4cd1-433f-24f2-08dd8267bb77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|376014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9i1WgR51YtGoMprZrfcHnYkAoBryhlLOfo9A7wUBq9ZKjdGn195ojEAQLmEq?=
 =?us-ascii?Q?zLWjfpe6lknvd6ygL/1CPo//6iqKDycNhX2TXSyeChHdcMJB/7+v0CqzFJs+?=
 =?us-ascii?Q?BWtg4FvgFifEgMy+cUQKEcbStC7X9STcBn06hZRA5EMsqP1JhjwKApu73BBr?=
 =?us-ascii?Q?l4Hrcl/qXGJrpcBxVSc+ovhI16v2QGLbPOvm+r2UbdnO/Gjw6/xfhzL7/nxu?=
 =?us-ascii?Q?rOYDIujoKh+vw64mCawc9gt1I7lKMqlkF9lFx7vu4Sh41utTHTwJW4gCE2Qo?=
 =?us-ascii?Q?Uj5Rr5JAc6suXoLxdNl7oXmdCHWXIpiHpHOVxMfpjE9VLt8dCJMwndZPKU4N?=
 =?us-ascii?Q?Ds/vK4oOd0niO2hM4nsmNaSQIkTAYpcc2r0B7yZFvaEabuKbTTLEWDpFs9Pt?=
 =?us-ascii?Q?v3LGnEpH6+GR6EDtKI0IkvFF8Vnmj2hcZLb/hTOvRmdhdl54/X6z/Ulx/GmO?=
 =?us-ascii?Q?DmZHT9Miq68HLWSO6fAPl5dtv4I0VEF8dTidw3eN52cKVS78aF+e3oG8SzAP?=
 =?us-ascii?Q?m1LgRNR7f9G09I1nayNYauFHOgmpC439d1Va+Atf+PzIZfga3ZDEoHkLHoe7?=
 =?us-ascii?Q?4dYARW9E5xmOSxsuclBspNp8MRtkf5tMkcny3SH1a8s027Toyc1rzeuMla5F?=
 =?us-ascii?Q?ml/UyiTwXVBFL/aFZHDj9ziX0j+Uj86jLN1wacDLCHDr5Mh3sHPoVq7KhAw/?=
 =?us-ascii?Q?iR3KjxxNe4vgkj2qZny/yQ6w1zILI9df/nBfACLtr65sF61A2Izvag3sRh1p?=
 =?us-ascii?Q?bG0wgnmoSr1NA/Cdmxh2LrCuywXInlkj5osJZ27DUaxElkFWVWzItszvIx9U?=
 =?us-ascii?Q?gT5cqvud8Ancm6rQcOtiCfwFOhGcp+cwh/JUqqbCbn7JiJ1Bnb6MuA6W6Nre?=
 =?us-ascii?Q?M9m/ryXK1rjJ+dGBtBxq8YoCm9DhD8X4A53PDs/u0DptiV4J21Srt9PWRKDI?=
 =?us-ascii?Q?6LAOIjtgNtAIfijMV/z0Quk6AskvLH3Jk8EmPU0VVVQbAY4tSV0laP0Ru6ZW?=
 =?us-ascii?Q?OfRBhU80OUWDuDYCeXCiS/u34hrsafTxpg1jFjfWVZVgDf+U/8XiqmWg40SH?=
 =?us-ascii?Q?lFmKuDgO34TWyYheTaFCU85gMNYANE4Us7yr5wk3GUzUPE71HBcJJ9xxCaxX?=
 =?us-ascii?Q?L/fqQQ9rvHkxuLztKTVeGI8THGPalUPOSHGS2DUCL3szaW6fe0qXbqjFSce3?=
 =?us-ascii?Q?6xLxVxcAIEmhEV4k49zunX3NTZudYx1UNmmE48JMIsi0izbHddYUcFz+BpG9?=
 =?us-ascii?Q?eHmlkp+qUAVC7ELLuUHOQzBp3xxptOBqEbtTD9QkIvUlI7795vTXffci2P+D?=
 =?us-ascii?Q?IZ+qhYQqUJafcsMl/8Kb1QGgAPSGIjZiTkZpadU7Jv4XMNfBRe8tZxvb45w3?=
 =?us-ascii?Q?TiScL5aW9D8QVDOHTSIIry7UzLGGOS79JRWgaw3Pekr9CnfHug6mfokuwdSb?=
 =?us-ascii?Q?Q/YWHT1GnE6mv12bYdLrEe8Ee+3dKCTaQn+kd0dhcjciiq6O26zTWg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(376014)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?o9r1f1W7HALzLk06C6GHTuUSzLFD/w+X0miEgWWoIsVyMoAFlzncuPeNETvY?=
 =?us-ascii?Q?tTmk7mVBvDY71nJIZFyIScu9CkQwijiLduMjsd6FpWShhFvw9BwvLo60pb3U?=
 =?us-ascii?Q?3vB4/WQMwoPSnKO4Y+/QgZJWeZRO2/PTxJ24ZX7VVW4FO9ScVOfih+pL+4Tn?=
 =?us-ascii?Q?kl94gmFtpZPT0xQFUmqVssWfj8c+58bd7UfBAspOi6WJ58b15/F7IrkytB8f?=
 =?us-ascii?Q?ILKrdic/IzsaAd/gCJY6ZX1IOrizm/adej6jdJUYghrgbnw3l9hwiR/CihpC?=
 =?us-ascii?Q?NLgD60eAye3Zb2Cas16vNfWYxnl4XjIvBc1RqGlfq1FFcCPx3uoBzhDQNlb0?=
 =?us-ascii?Q?//Vc4uNXNAjbmsda2IDwR5HGjXAzIi4dUqr1w+SVx1hXxsoOF0HuLt7DDk3N?=
 =?us-ascii?Q?sc0U90rH3ur1bzlJJdLtMzl5p6rw5HacwxAuJCtqYsWwMmymz+owia407mTm?=
 =?us-ascii?Q?CpXUeY8Xrc8VryNaI3/BRPRPj4y1eEYfFt6jpTAYZcPHJiWEjUllJB6KqCIS?=
 =?us-ascii?Q?4vISG2bVXG/1Zmn8JRqNypvU3+eoZpSFMBsr0HplT35nS9DBPpvHIWEgizaw?=
 =?us-ascii?Q?7jtuxVaNizn5nFtsO1s2wTVirRAmcbndUbcn9e38a3wpnQWSAjWXZfeEfNdO?=
 =?us-ascii?Q?PpoohAzC1QEO1+znyh9f9QP65fIhIjaLAS9TGDqiBD1J0YHSrpIMQt2fSB1q?=
 =?us-ascii?Q?GNDpIYZDNzD9ixy289uqD45MDRJuqfN5Bd53zfPS37V9CYxHtWaBixxU+7oC?=
 =?us-ascii?Q?nJSo1HRmPqO3cPZwrmwIfCKnG5NjjVILkW424uVPUH1y41SAY7ycMWM8wgJT?=
 =?us-ascii?Q?wWvu+1dlOEf28+DA4S91FkujPX7oHUAjpl/DX+su+GB2BrVJ9Fzx31VwQIXa?=
 =?us-ascii?Q?xwy0VG3CxrWwLDAQI80rW8K4YFpqjMHHQJqoffofrHn+kqQ0rvjvHFmz+Fbx?=
 =?us-ascii?Q?yQa9YdEen3OdpYiRa7O45GhHLlEzYEH71nDHxpzA2GEs1e7cSTI57CkNE+w7?=
 =?us-ascii?Q?d4U98si675n11BPJ+0mXKugONGIgqpuV5+L23K0nCy4Mp37270Ig8noGDZoQ?=
 =?us-ascii?Q?5sm63osxDzLW0+a46Qg6wTYKdyi3gXscDEvv6MbjKr941WoXwaZar9KV/zae?=
 =?us-ascii?Q?YG5Usnj9tAPpl5Lx4hgGUfVWOc0cL2ofJLdAm+sN+eIq7O7uZHO7QEXuX7SN?=
 =?us-ascii?Q?7zaBV1MYmZ/PtqULpLwycinDo51w+AUrLY40sZIoOGRoGlpYoSBGYvHuSRSF?=
 =?us-ascii?Q?VrfJDAuR/TywR6IC/62wqKa65SmA18zlukb990UPQdqFJr1JZDXByM1vO4Od?=
 =?us-ascii?Q?qA+nfz0s7+bWSPEyNVpYfI6x/6FK25hHz5V8rlyTEGII6zkV0cygEtpfOsL0?=
 =?us-ascii?Q?Aw3felRHOZCv+Pv1ISQMU8xcruxMxK9EHIFojsgSv4ozhDnmqmtiCI/Qrfd3?=
 =?us-ascii?Q?YH+g6HWBk6BT3wk4nvbClctZ7LToQK/FdcPVtVDIrMHu1Z/dxynU9fCefS7z?=
 =?us-ascii?Q?l6hXXu8XcoHecNsbMvQj7A4X0075Rl9bxcREcpCdCLJ5sCCkunOYRy3gY+UH?=
 =?us-ascii?Q?CFkPR+H5j1eOT3XS/Jk0PPxGSG+CeMzPJhlh5zwN?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81963aaa-4cd1-433f-24f2-08dd8267bb77
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2025 13:06:59.6824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PIegdGQXo+OM+Ah/czFv8RjkOgilGDVfxJKKjBdXwTuz5PZNooDQOysOLzHZIpRdKidyavjKnjB12uDIprn+DA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR02MB6711

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

