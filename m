Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013029.outbound.protection.outlook.com [52.101.127.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782392D46A9
	for <dm-devel@lists.linux.dev>; Mon, 11 Aug 2025 12:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754915820; cv=fail; b=Fqb9DttpwLf+O5TUTMeOIdC8xqAho+Cnp6qniuK5Csdpc06vwfFua2hOiFNO0kNsBeIdiQOKRjoT6N+yf7u+U3K6w8ibxXkjQgFDTCryquz1hbZTMI5vFuv8sdNurZs21bsn+qKOGtxmD1qKZwHZ977gRj5nuw+ToBRM+0RFxCU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754915820; c=relaxed/simple;
	bh=GupdCB918/m7nWP5yKHODVECRggswT27JRV7C4Gp0a4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TC+2ZVhthAeNJSt8pavR0zRzhukqv3q5vrJRwR2lRaRVg6ByCj4fpAbOF1Ew5UfkFrdoLCJPXW7tDuUEN66vUqNTOBkcUHSs8T2/YrG0HLRjpAaNrYEPlQhohsccsQS/hLcfC++Dux04zP7cH6FhNxW8KgDta+7tFOcr0QbUpBY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=V3shOmem; arc=fail smtp.client-ip=52.101.127.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="V3shOmem"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zr1bZx1qMKoLlwfQrml2T8VcN0wJwXyelFw8lK2M0ooNEJ2tH62jHjW5+mHl99jawgbHnzkosxEXsKpdqYgYooBdM/eDwtLqS+HrCj1+giL5LSpomdImwwOymytVpzqEw+MkiAawT0Funx4vVusfRgdmtMzDgfimRdUkE2LAz9ax8rov+g83/i1nNrTFzdtr1IAP2k1StGOA07pOtjG1QSS+jtr0dIVXvwI87Mc4UN/hstR8OUZuciqi+sTzM6lJsE2g7yP+bk3jKQkdIKO0aS22oa+3o9kfOoEH6Nu/fR21SH/jNOvIJjiY0lOI1yMfwIvLWbXAO1pvOlNFunYPpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0IM3J4kAmuIkWcr0C2XJLLRgXhOQ+Nr7EUtfXPj79zs=;
 b=exw02sI8xYvwxr0f8gBLeF1jnjYud0cLQ5gUv5o/LhbWO+I997J7Y5I/xhYubnCwA6PAN0M4yfYYn3wH7oetjtfBZydvLrkIXZdSC4/661C2f1eUuVKTf+JlD7sIdKzE2nDmiBuEMF1LTxADjkeeQyqp897a/NG4ZrFWdyF4rWB6V060UVsecKCdx2b+qzNAe3/j8SuiMK2CsMAmV33epgLhhCO2eZ+OuSPU7+iagkRQkY4NwRj78RszEXQAll2H57o9Og9kXXXiurlcVSnKmmPyZNFjnMcrSNqzY+LFDCJ/EtujR9CQjkku9wtKXwoLljWGCt3XVw0w7jXOuwCDBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0IM3J4kAmuIkWcr0C2XJLLRgXhOQ+Nr7EUtfXPj79zs=;
 b=V3shOmem7PFpoADP8BoHDKs3KklH8Kytl5Wa/2M0VOyu4wVc5v5dkuFBBVThc2wIVHL6KaPMPRjsvKeTPtNSuroKIKeGPaBKq1xFgndjs9Z9ITPwHM7H9Otekb5rovZRCpaQItznf+Zt40c0GOzS6kfkrB1N8PbkYeGRCi3/ncCHrqYGmgJF927In5r4pmp9/XgK5cJUuqCyDDjVpVARDuiV9nYRXw6BllWBWx2rp1D0+YsYpUVyfsw+efc/HEI9V3nQLjwKLaOzmg6AovFak8rQwEZXn4zn1oAilSLFzfnR3kqHnC53heNFetP9Id5SUymK209aUR9MQrn/idXCnA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 PS1PPFA1B399C66.apcprd06.prod.outlook.com (2603:1096:308::25f) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8989.21; Mon, 11 Aug 2025 12:36:55 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%4]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 12:36:55 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev (open list:DEVICE-MAPPER  (LVM)),
	linux-kernel@vger.kernel.org (open list)
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH 2/3] dm bufio: remove redundant __GFP_NOWARN
Date: Mon, 11 Aug 2025 20:36:36 +0800
Message-Id: <20250811123638.550822-3-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250811123638.550822-1-rongqianfeng@vivo.com>
References: <20250811123638.550822-1-rongqianfeng@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0033.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::21) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|PS1PPFA1B399C66:EE_
X-MS-Office365-Filtering-Correlation-Id: bf31c711-c5b8-465c-e1df-08ddd8d3c168
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|366016|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TfoZSNUpCCgU+Co2AY/tZaia3mi7rm0KDH+jiJLiFauU2SuqDfdb++MsQAm3?=
 =?us-ascii?Q?VfYg1AaKHt2ugr4KfkcmaGWECprP/efLxUR99HfuyRhiMvGRgyLOxBW9KDI3?=
 =?us-ascii?Q?1s9pwV8tgSrQnY0KFQ/MatboZbjjgsm998rv7ZnD5GyqBpoqxR2cxBXlDlwf?=
 =?us-ascii?Q?6kIKRrUle35dVEXL/2aoHb1wntrGDEF92zVICu6HyQGCgJ+yCYJykBtGtTIG?=
 =?us-ascii?Q?WFrXCUKNgUTmqWXLfPsSZQ3HU/FXXT6RHfeGGbNJHwZdoJwW8TLsHsqXW2bk?=
 =?us-ascii?Q?zxqPIBuGhhuAnxnZgqpmkL72gLaUwkIb0WUx0qQX7JiWedb30dQixMnK1FB9?=
 =?us-ascii?Q?0aGHZhSZjNUbYayVKyjD9aQzacd7UR0nOooR6q4mvKzbDAt3WDB5lb4MU4uw?=
 =?us-ascii?Q?BHLa4AGcwjGl4BiANAwXtrwW3Rm+KqxJ9PA7EYqopEPV9QB5Sieg5Mo+NWvp?=
 =?us-ascii?Q?1cIG4jbWrhDOl5Faik69VGgaW1sM7oyW5jl1kv5gtHxMqveRAo2hifeuuu0y?=
 =?us-ascii?Q?hAVrKRxsqFIw8eWcttswP8hk66TIP9/6JA8DmOjCHJaHvV8qpKmUUN4OzN4h?=
 =?us-ascii?Q?pH6/oQBijAfsCJsmU4jZfhayhx8zSl/VYUlC9QUxG18xutOJV4LUCCrKyhDI?=
 =?us-ascii?Q?kuwJe8Bj6SUmH4t6iEvVn52j8lOgNvnnr9Gz3aqFHc2FXr0rlITGVu7T/05w?=
 =?us-ascii?Q?fabTPdXj2lB17yq4+fbQy5YSDh9Z3aGDq8WwQc1jiTD/pGXg7wPypGd2c4Ja?=
 =?us-ascii?Q?0/j7pe7/Ix6wYW+sCtbAun3OQUzNvHkNC4bTUb3flvAnKYtY25rwMhm5cvQp?=
 =?us-ascii?Q?muX6FPOvs+1VTEe8rNDBoc+GShNmdVO98Len/i1n6X7CWHvATNkUyfb/rFk0?=
 =?us-ascii?Q?uIfVrXfdXi6RJpZ7AU6VZqPhwZj+qblgHNLngNtDZM9g+azAZQbFsmv6wQCI?=
 =?us-ascii?Q?CUG7y8D57LqNnYzYxe+K3Sk4r/ib6T351z6mGz8Py9JIVmXsfMDZEHOExe5K?=
 =?us-ascii?Q?7C4LeuyaZYtj/4aFl5PLa4WRvDlS1Yew787QcSnczBYB1I6OBX8OB4ZgImnY?=
 =?us-ascii?Q?mjjRlc76j7nB+wV0Qe2bkVTGS1ZFK1NMrQCzPjkvi/5/sADjG/UeFMJWjcxD?=
 =?us-ascii?Q?7b2NVQ9iTMF5T97KOW4G3AznQ32Q9r/XZaggCNol9CQ6JDOliAJeeI0OgLL/?=
 =?us-ascii?Q?gtxZFkJ3QuylYmiOf2JoRIfFG5fPO63D0RU/NadmICiSmw2iEHVuGurKah0O?=
 =?us-ascii?Q?o4a50FgNQSeJsDJie/zd6F5E0Oy8T9Xk5dJ369shyApRkVtK62iOO8Nv03je?=
 =?us-ascii?Q?ZmrPhCoKt9wWUZY0EVarKRYOqZZUiWFtiVkV8eTFEdgURthS6CCkOdStkYL4?=
 =?us-ascii?Q?mGxy4dj6HSsDfuhE2PdZEaKtwwCJxuxo8xu2lAJE3JuGY0bLTgjDBaKCvQmb?=
 =?us-ascii?Q?e5ydLFzhgSbylEPxNj5BzIscGoIHBQSa0reowhE43hoA6B7qAoNtwQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(366016)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IOmd3MGzBGlibhInpbNLjhD7wOMCbVP05eDjYX2yX2wDrEWPcOlJaRnhDIyu?=
 =?us-ascii?Q?ODqajbkK4aWJB17m7TepNhhyzeop9QjAM7M7XdKiN1t53CSMQYT3NVmRPT8K?=
 =?us-ascii?Q?6ceBAucyQa5QHd247N1o+L1WwxFk9VE7yCpOmJGUGAmwV2jOfda68ZbUhPbI?=
 =?us-ascii?Q?k+ruD4kK/EUEX3VEqeHtzUcQ96F9a9ZLGR2vm/Ci/l+Q7yQj/B6nNzcjSSf8?=
 =?us-ascii?Q?UoZceiLQeUs1rAKwl+7uaM58HMXx8ANyQD6U4Bkqs+zgUmMD+lBCtNRhUoUT?=
 =?us-ascii?Q?6f0l66RDzyOx9pnch9dL6nYNb6qn81/pGwnvonttD7sYsQ8vgOJHB+o6Yugh?=
 =?us-ascii?Q?4GcuIltTEstRT+Z8RjZImic6nGgrgWkCahTQEgAPIwKv5mXZpVWXODH7eFdu?=
 =?us-ascii?Q?ax0C6gK5wkFkVu/dxw78Edbk3b4IEWe60M99FWyfuMwZMDzqfHjCznRi8TF5?=
 =?us-ascii?Q?Ft+wbSusDzGWeEPPbFFs6wv7Ua+wjymuhDFQVYwwqeUVKzmJzzGAD+Sq4MgJ?=
 =?us-ascii?Q?mPUXngS7WwMKshd8wZyr7rctiDWJH768QLzE6HVemkSAsHkx72PpolTjV8Pi?=
 =?us-ascii?Q?njoPIpm50Gc6egzPU0uTQURGrJ6RrJUnIuzcGDN9kuKnP2qFJTyBf5r2aUBB?=
 =?us-ascii?Q?MBmOQNzD6bUObrec9xP8qia3Bds0BJd7evfMfgqtUX/IeJEps0McY0cN/NG0?=
 =?us-ascii?Q?EtXNo90028QlJw+U4Bm25TjA2AWc3XxdwZW8weafj7cr1+K+M9brHHNrkVO2?=
 =?us-ascii?Q?zGMThyEnYN5+d6MyzipZ2Pay49TyhYc/FjAQlgTv0yRLULYyl2dj1qUeBNy9?=
 =?us-ascii?Q?pBvHSEsOD73K5KfwyshVEIf25nZTZugGDTiHOocD1MldqenBuai4S68pnH9I?=
 =?us-ascii?Q?tX8CUuMZoM3UA4ZJOQI32kJll652qbocPPGZHiH2h6nP6y3PbEucxsFcnKHs?=
 =?us-ascii?Q?/6oGPGy1jZhM0f8GOyt9FHt6U/viOnX9FtWRCNgTCIZREiLgDbUP9nDGxxGS?=
 =?us-ascii?Q?Vb7qiWlOgFkPuWLBj4oKVVE4abYg+ODsbyKeUwMcgWmZHDBi2yQy6nsSaaVF?=
 =?us-ascii?Q?3iDerRIUB4minuEhnIfD1LHWSC7z9NxWK4FCoX2NVmjFR3B14dQUElVwHnrH?=
 =?us-ascii?Q?biKDUqHUaVuMSjl7pH4gYsOVElhZ5cxWQbD20OY3Iwnd5SrpEoc7SGJD7XTB?=
 =?us-ascii?Q?ueFh1LvXXlUkreuL2VQhU5YYE7QkiVbdxYzBNUGOfvVi2zTBIrTfiOMNyXdE?=
 =?us-ascii?Q?eeuiBTJiKRnI/TJwxLuN7qOCBa5pcIv/YgjE98vIU7kNsN1jo/yHBmbT/3PN?=
 =?us-ascii?Q?ZytVwutwV4q3Uel0ERwowbpndk/b1AQPWaJDAcwtkr+bmcIUEed9gFQyc4KQ?=
 =?us-ascii?Q?QR3WYvorplkd5jtwRBrgdJhFVnq5z/St1H3Q4TrvT/c3KFsEVy6tb8bHygfJ?=
 =?us-ascii?Q?QsNq3W7EpU6gWh/czqCw6vNg8tLla8+ttwmwf87Dns6saDiJgpiusJLBD7Df?=
 =?us-ascii?Q?+2BPz6jh9Z3DGAMCPBYE/ZIWriq292WF1vj3mzMqcxjCiyU+FODTW49mIp1b?=
 =?us-ascii?Q?wPoXWQl2dq4FpdFX0pUelQ5zz/kaqxp5rDrgawEC?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf31c711-c5b8-465c-e1df-08ddd8d3c168
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 12:36:55.2914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lVBT9AtDXKIh6j6OtLjkV+Xv8eSxDQglsXTgtgJyUrverXOCtyobHEFBALHSWiTm9EFejy5x+BgJNu627CuzQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS1PPFA1B399C66

GFP_NOWAIT already includes __GFP_NOWARN, so let's remove the redundant
__GFP_NOWARN.  Also update comments to clarify the flag semantics.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 drivers/md/dm-bufio.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index ff7595caf440..4b20854e92f5 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1337,7 +1337,7 @@ static void use_bio(struct dm_buffer *b, enum req_op op, sector_t sector,
 	char *ptr;
 	unsigned int len;
 
-	bio = bio_kmalloc(1, GFP_NOWAIT | __GFP_NORETRY | __GFP_NOWARN);
+	bio = bio_kmalloc(1, GFP_NOWAIT | __GFP_NORETRY);
 	if (!bio) {
 		use_dmio(b, op, sector, n_sectors, offset, ioprio);
 		return;
@@ -1601,18 +1601,18 @@ static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client
 	 * dm-bufio is resistant to allocation failures (it just keeps
 	 * one buffer reserved in cases all the allocations fail).
 	 * So set flags to not try too hard:
-	 *	GFP_NOWAIT: don't wait; if we need to sleep we'll release our
-	 *		    mutex and wait ourselves.
+	 *	GFP_NOWAIT: don't wait and don't print a warning in case of
+	 *		    failure; if we need to sleep we'll release our mutex
+	 *		    and wait ourselves.
 	 *	__GFP_NORETRY: don't retry and rather return failure
 	 *	__GFP_NOMEMALLOC: don't use emergency reserves
-	 *	__GFP_NOWARN: don't print a warning in case of failure
 	 *
 	 * For debugging, if we set the cache size to 1, no new buffers will
 	 * be allocated.
 	 */
 	while (1) {
 		if (dm_bufio_cache_size_latch != 1) {
-			b = alloc_buffer(c, GFP_NOWAIT | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
+			b = alloc_buffer(c, GFP_NOWAIT | __GFP_NORETRY | __GFP_NOMEMALLOC);
 			if (b)
 				return b;
 		}
-- 
2.34.1

