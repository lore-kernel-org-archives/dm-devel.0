Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012034.outbound.protection.outlook.com [40.107.75.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C143D19DFAB
	for <dm-devel@lists.linux.dev>; Fri, 29 Aug 2025 13:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756474692; cv=fail; b=VwGCOoUcLVSJqsmiZaosEI2K6soI0EIFOCyn2jKUvXBAONzfbi6Axjlw3YgnP/OVe7bRYdl4isxKthWqOZa/F2ro43LArdNY4LrqnAH5saqHoEjj9Mkn7L7lpePG0SUOkpfW58nAMTSPvwVIXHz6Z28pxSYS7CPj5E2Z2tJ8cJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756474692; c=relaxed/simple;
	bh=NlvJj4pKVI2fSt/+gpa8V+ZW3tz9oLVpM29332Le4og=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=tKvsRQK70ea2oSDWL+Quity9nskYRompkiPzkZJGnwUDnZZkr7Cwv4M5EZTuQdNSY0wl3sy3IgTZRCpiwTwEDnsCkjdmYMUmB1wU3Tjuph+0+9cpMLGlJqRgAZqf3Lsva/CO+fVS5HIwfDccA1JCL13cqM+I7dztPJOx4VXIUbc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=Krwe6a4S; arc=fail smtp.client-ip=40.107.75.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="Krwe6a4S"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jEibUSKlSFHWLVkQT4eZna9Jk7jj7vPIRd+ITyM98MUq2A5Hh+3xqw8kiU+uK17dnwPYYm+yOtYnx0X4SGk07oD+YyH5c63vOqPJf3C1+F1EMUCO8Bn0B7mNKqTILxy/pRJ4pkYpYl5pzzp0KpkyQjx31ZLwjaClGV+dob+tjHkk58EuxL+OPZfVCYp9ChqLLmXq2iRgusd+NkCRajx468paBYNGRZm5RSuLl01cGyicBoD9gP7v4faRjGQdHjvRCuflNsm8jlZnSG1h4VECocOGRCHs8m6qu6TTI4tzKxftEw9F2u2N5Cf8na94v2WrSQEeE7a54i25qadiwLjjTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b9p03aZ/Phs4BeEdMyOY36GXPw47GfIHnX/ddHf2Jr0=;
 b=ftOaVlAQLRjr28bjJ5UE0h1gF9YeIFU8XEacHTI/PWiIngJzyD8GW54/og/72QU+EODh8+1Mm8SiPY/OWleDEag69hv6cHVRkODa10CPGln3C2RtgbAiOD1v4i6lyLxwxTrCQiTCtLT5DUMz44Jt6DHnTOh8iXmjjptMejHy1W1hqN20+Yd5ZoBNwB4CdiHgDz/N0ls5beRTMCSWtuRYzc/12cnvsiDi9+P/iZ2HjjiXxybrniwyZqm9/f3Q9VK1/uIK/7bfyku4A+nMyhD21AtOitB/PvcghCGs7xI1/lxwWSjZNYCQTowThcCwh3ine/MsChQzpw1WLrslIf4Gtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b9p03aZ/Phs4BeEdMyOY36GXPw47GfIHnX/ddHf2Jr0=;
 b=Krwe6a4SO3z71FBAreOuoLqzRDeGw4vmgMgJVLqNEwmZV+DLpQ5Z8VR5JCqvfUbDdlJSZqk5RsE3jLGkkcbXkgCGYYAj6C7GmzHWaoqR3cuSV7belTfHr2U0XdmOxlCSc8oaOGB6lZRyK7pAhAtNxEcXXljP0eOLVMFjhgYZEAlSGHWPoJJm/4p4X29u2BJZobnoJZebB49310MV7KVx0RBzZmOoxdPTkacnQKvL6SiqbQlCZGmZ1ZorqQeuTghRNxIimp+xHXMEqEcWMKKmo2Ic0lcxyC84dfn3UmDRKygJPhZxCfGN2UTdYrDASgolc0AdPN0Tse/dVCec4PF3fg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 SEZPR06MB6781.apcprd06.prod.outlook.com (2603:1096:101:17a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.15; Fri, 29 Aug
 2025 13:38:05 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%5]) with mapi id 15.20.9073.010; Fri, 29 Aug 2025
 13:38:04 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH] dm-pcache: use int type to store negative error codes
Date: Fri, 29 Aug 2025 21:37:48 +0800
Message-Id: <20250829133748.104119-1-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0144.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::24) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|SEZPR06MB6781:EE_
X-MS-Office365-Filtering-Correlation-Id: d0324e64-a243-421b-39e6-08dde7014796
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fYAxdn0Pxjhi8LfuYuYa0a7K+66mYnkmam71LJCC/ZyvZyJkOOFOsLDwyI50?=
 =?us-ascii?Q?Vz7rU8LPKZQVBWhB1sNnnvnngTXA282JuJfS4KyzJFEOwRAJS9n1downpQZo?=
 =?us-ascii?Q?azjA/YK/LW+4pET9cHcSZapso2YEWn6yeQicXXTaNMwMHG0Gv/au+df4l3Y7?=
 =?us-ascii?Q?0CwMDljflpR8cwkE4pX2FAB4L30Pzv7gUqF1zaUX2hZW7noj8jURhR61f6LI?=
 =?us-ascii?Q?FJ+6O9imouppBvN6NEZkk9dpdy05j8MTuFy2ujrNwNtD/H8tN0SuKADzordR?=
 =?us-ascii?Q?cDYB+oXy93ctbDCuopI5dXda+D2b7z70O5wUuaxF8mI29A6NSdChVGZ1dGmB?=
 =?us-ascii?Q?QUZ+HmV56QwJx+6HNjKPyx2gbrR5MsF1nacNSVIsz2ywwiUZ8MEHuiJkcgB2?=
 =?us-ascii?Q?lQrVrPMqa09pkNc7/eMZXc/4ruwUAK2Se48ClEa0XLxyZEFw8fwm2wx/BD+9?=
 =?us-ascii?Q?CpxScGx3mGypDn1k2cGSv3q7N8INFiixhA02vqHsKKhCe1TAgdu1uug7BZPh?=
 =?us-ascii?Q?jnvJSxnmnQJaNfTPTA01G7C3mRyV5+4CkN4Ua5Y0vsSOiRQk649XxGnBskt4?=
 =?us-ascii?Q?Ad0yBe/D7knIlWkmHIZN49YeiIcbqzaj325avROKWxOmuitcLtvOE19ZrBPB?=
 =?us-ascii?Q?Gw7A1QSaZgYriLl5ac5DU17Q7oqwDghARuHQqqB6VIsyBoSYtGeDLTmcfJt4?=
 =?us-ascii?Q?YAlg1ZgsmHL2AZbyCmoiDyNnqSaJYzLsAWgpLU1XRk6BUeqa4pfTw2394zea?=
 =?us-ascii?Q?kVo07ownKwpeD261Pd1ZVoCvltdD2b5A8DUPYhTHXtJLvMR6qmrUimpzBDf7?=
 =?us-ascii?Q?Ft211DwH1X7jB4Qc2JKHQp3rMYit+4J4ofuGzmKoTmRhDK43SjjtslcGLW/o?=
 =?us-ascii?Q?p9/eDP0MMOvO8HNeyJMviWCKxIB3TBJCJIZ1XH6My8TUeS9aeXyVvRvls/1D?=
 =?us-ascii?Q?vB9g+JhLvkaS3rJW5Y9r3jHV5igb2hsEh+AbVMj38CI6pPSzcCbafvHp/RpE?=
 =?us-ascii?Q?3TnZSf9d1Cw6rNOXW1LCLLroRLvajrIhNXc+Lv6KkKJ8iVFy5t9PAbrvA/Ou?=
 =?us-ascii?Q?1feaENif/MKcWmY8uKKpHaOP7hprEGDEu+2b3/bQP0EbiFlS5YTIyDF6hA5i?=
 =?us-ascii?Q?es0S7WXT0M+SbMj/zh4ylgRX/8ujD/wNMwbjEh6kfKcxUF+uTNTa4+pyR7Q1?=
 =?us-ascii?Q?QrJUSrm0E/PnG4cwBbCa42nCpGhDx9IvCMISiguTW81Nb+I0UHVXj1HqwcgJ?=
 =?us-ascii?Q?ZiF4Jkjp+6avrgoUP76SH/erCiZcw/BZvFdFney94/oBoiT6ieieAJFSoFjP?=
 =?us-ascii?Q?lYuT8hkVxAHKJvkacdnImjnHr9wNm25b2jH8SvC6QLl09WaS1Apa3QXCGC00?=
 =?us-ascii?Q?qHw/dZs3CImAmXPN++qhS1o3yV++2ZMwJU9TV4OOafBkwPZNV/qpDbdqukWa?=
 =?us-ascii?Q?VXAGFo1doYJrYSk7cLbhcYbnC6vwGgle3fa7DmgJrxuUq1SQsmTB6w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?n1ipPxbTx/iu6yxk2lZx74x5TavWEcqo6puIXTbUDC16qP6HGlYweoe9gKzr?=
 =?us-ascii?Q?vjhIprhLEM15KG4YEnwE+bOtGiTS4pFSZpWHXykWrz+vj4DkNkS8HIBfhZlj?=
 =?us-ascii?Q?87ULNW6jB17aVT9gDzugrBjMmN/XhyaYy3NvuiT7i0K/DNzY33u1ePjX9Bpa?=
 =?us-ascii?Q?HswPhZyTIlKUCVbvjCRK/kdaytrXer0wFXnF9UXQAkWwHXN6ONzAQxFGxl8m?=
 =?us-ascii?Q?Mh4S9SS+nZE8sJ41wivKg02/BKpHqklGn5jZECuQGPojyipgS2qio6rWBoXx?=
 =?us-ascii?Q?xi2rU+0EX72ofOPEKbGCWkh5vJa6x4u4ftsKQMygWeRN7jqJ2d+0FuO6SUMr?=
 =?us-ascii?Q?dNmXfV/HnuGTb79CxRPBqGnBeDNttHL8+3GRCunl4DOL5JuSUGWRK78b2zqr?=
 =?us-ascii?Q?IivfAmNpoFEpzJTUu4cPB3h7BrPqte0oUhKeVNTJeEmDOhpvLODsCKEES7Iu?=
 =?us-ascii?Q?X6Fsr2Hr15obuw6r0dOAZ2zK4TMtdNPqX1PcyxuVsZe3SXfWvoA240y8zJiU?=
 =?us-ascii?Q?WP8t8TIeDXuzx98ko/r0mm6ztJHqywe0hWlKpGl28dRKp4q4TkJNAklbax8s?=
 =?us-ascii?Q?BrwUJvUc3OsoHX6YWsFFTmbTujV6PWP8FtxeAwEihs7nftSe8FoszhOubWgv?=
 =?us-ascii?Q?TAgHIgp88w8Cj79ioNdB2oUz7MOWjxlMCfiw3ufNR8s9JqzuyfPzxQ1ydSi4?=
 =?us-ascii?Q?YuURdTmL5DAPlmT1VQSYm3PFxpuhW/DRG8Alg6yH81FnDav/XOQaS5QeoNAU?=
 =?us-ascii?Q?sNQWCZk6rrfpWZpbYuXbD9n+jf5uPYVU9rj/C9ztYGA33fj3/UQYhtzt3Ctg?=
 =?us-ascii?Q?qBYYi/RigEtiY/9+NZhkTdvhl1KMgno+nHkgB+L797Poia8UcxMvXtWsD1BL?=
 =?us-ascii?Q?nCn8pMP+nXXa4XRtWg1b17S20YMpMzbmtK1+8trFKZ5Dq1kkl9K8mU5RGFrX?=
 =?us-ascii?Q?dnnZg3kLLeOOE77HB7UGf9Tj843yop1nDW0LD8LXdHJt0cjognGehBgvnptl?=
 =?us-ascii?Q?Y9h4Fub/bS4N23h/uc9zO3G4KFzFhC32hgt4W/so+5feumLhuJzmcO+xKSzE?=
 =?us-ascii?Q?yLMU/jub5YOSwmN/+rd/ARe9uJ+eq699/surdzvMi/ftXUG8zt5OQgZ24XlJ?=
 =?us-ascii?Q?LPj8pd2zRuvTQk5nYErGGqlixYTzFtK3sh81R1IlX3Zdvs8fEb58fiiF79jJ?=
 =?us-ascii?Q?QISFcNo/aGt41v7NcIpUM0Y+IGGm1Ru64g4fXXKYH8Q/igIMutX9i9p0CxIM?=
 =?us-ascii?Q?q18j5aNo4RF0wNkL+SD/0UDn8gVnpMiOxB0eiWvg5l274Kbp52p1FaXQAdsl?=
 =?us-ascii?Q?sDP3L/ofbg5dKf5gMhi9RBRJMKjdmzePBp2xwma94NxZIekgxJB1oIuGfDct?=
 =?us-ascii?Q?iwlXbP8lKXqQ/AUjsibwPW/Sv/kjrhwU+BsyEhKxiVWhvEK+QskBzXlXIFaL?=
 =?us-ascii?Q?IewLBLKuRCtsIzVwBwomYg4EJKUfEQDRhbCdM1VR7ojZNl6q6u2+a3nns2Pe?=
 =?us-ascii?Q?kY2CWjAKsme/2/D+Kx2wWqXUyAHata3S1w0W6hCvIJZYzudDZTREeUrQvDcv?=
 =?us-ascii?Q?6y8iN2VUsQcovwedXIc0q02mXuVTuJTNwx+4/ck4?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0324e64-a243-421b-39e6-08dde7014796
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 13:38:04.0112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +aL9v45+ZN7hByzClZEacxsY5CXlzDLn1UECzmtdXSp5/QTFGAwCbIvrexSblJUn+XMoBW9BOXqfvCL65MEzxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB6781

Change the 'ret' variable from u32 to int to store negative error codes or
zero returned by cache_kset_close().

Storing the negative error codes in unsigned type, doesn't cause an issue
at runtime but it's ugly. Additionally, assigning negative error codes to
unsigned type may trigger a GCC warning when the -Wsign-conversion flag
is enabled.

No effect on runtime.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 drivers/md/dm-pcache/cache_req.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-pcache/cache_req.c b/drivers/md/dm-pcache/cache_req.c
index bd5cace7de71..27f94c1fa968 100644
--- a/drivers/md/dm-pcache/cache_req.c
+++ b/drivers/md/dm-pcache/cache_req.c
@@ -805,7 +805,8 @@ static int cache_write(struct pcache_cache *cache, struct pcache_request *pcache
 int cache_flush(struct pcache_cache *cache)
 {
 	struct pcache_cache_kset *kset;
-	u32 i, ret;
+	int ret;
+	u32 i;
 
 	for (i = 0; i < cache->n_ksets; i++) {
 		kset = get_kset(cache, i);
-- 
2.34.1

