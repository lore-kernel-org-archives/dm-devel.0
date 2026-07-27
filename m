Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11021097.outbound.protection.outlook.com [52.101.65.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21FE3E3D98
	for <dm-devel@lists.linux.dev>; Mon, 27 Jul 2026 13:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.97
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785160141; cv=fail; b=ghuMC22L4lVSriiCO30Ee1hWq02Y5vzZQY7hmAC4KWqUACjGgNUqQg7ow8yZAs8P0FSKbtzLTNMmJ29maXZMZ34uoqf44kpwWGBIYfKhQbIIT/n4MVWpwi93tXf3MEVu1A0CPOPvUYrFxz+CqXJSozViw3vPZuhUv9rdGUfOaXI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785160141; c=relaxed/simple;
	bh=ZoomJK6WfzhgKU0PFe4r7U4RT4nWauqu6zjJGIsCVHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M5iaDtmlBDfpwLoR3brZB1ds5bp/qP09gNqWAEp/WYrF6B852bAVeUefeWI8XRflQvnq1n73+Kki0agd7DT3eOkkdSE8NvPGt83/wujNup0pZ6bmVxyPDKOEO9uZl58TSqoulWIfdkowe+qNoI8Pq6gINwfCH7xj1nkMrsv5B1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kuleuven.be; spf=pass smtp.mailfrom=kuleuven.be; dkim=pass (1024-bit key) header.d=kuleuven.be header.i=@kuleuven.be header.b=KnOLSZYU; arc=fail smtp.client-ip=52.101.65.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kuleuven.be
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kuleuven.be
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kuleuven.be header.i=@kuleuven.be header.b="KnOLSZYU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a0Fj1bss4lU3zJ0ZxY2opUdHlstHjScLO+G++CioQOQiTnWhoYxNP6e3STOsWo9ja/7D2/f4X7EIzaE/hQeowMyhiRTvQ3rPToQ0VQpfLvNKhhWR3Qy8xw1Ub22/JsDFuEzHAUcJ204+xN3MgCOEP7HhvO1MI9l8061BtpDY/vjdferx+ezPr5mpFpZpvDfyncMPVEurbz6HG+UnVDk3zHHzsgqqBVd1A9unvRZ38cL4O73U5IAPBARW6dnqbTuvNVtLSiCe4yFKioqB3XpAt21qOJB0Kv0wQm8qVG3rdR2pLqT7ujxYY2i4zXS/RRP9MkBSyen+nF4UpDxBMaSVGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2InWmbVsEOAHFiYcZtajQDeOsdoYMj3tMya3XGnsFS4=;
 b=kNNbiI5sWfrcs734cH/xIlHAVEl4qnj796kTEPotyOZ3OwtWi29cRmVMuuIRsuQ4NUTBNRoE41snSKHaYqF5WDXAoEKD4kD6W9aqvmtEoPdCPWyf7jKNhGWkaqOpSRn9O/b6/+gGvI2zEsW8GrZqjLoTrN3M0jTw/09gmWSgtjJadhYtJVEAbu6KyOHHOLvK4sNlSUgp/j3JlFzCj5ocJiMhsP/fxK47nhe/EeXLlnV/wdObuXX5DLeaguamaIqoFgVvIO+CMQFI1j2ozH6DmAAN/9Cywn+Un60EykVYRrG4fQwcFUAPCnKJqyL2I/VOzYaLIyeMFZ+ST/zmSwkPNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kuleuven.be; dmarc=pass action=none header.from=kuleuven.be;
 dkim=pass header.d=kuleuven.be; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kuleuven.be;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2InWmbVsEOAHFiYcZtajQDeOsdoYMj3tMya3XGnsFS4=;
 b=KnOLSZYUoMGCBtHIGU/7Q8+fyr0FzKBHr3Rw1G+/HBpQ39G58QjWY95oljrEpYSF0cU32GxqVLxinDjxLyYb+gJcD6JxOIyCAQpb8Gp36gtgeBrFrz/gX+nbmLAKxzzNDXUFqcTmwg2YxMIUVeOI5M7VwZn8FBsKr4g0wHF35PA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kuleuven.be;
Received: from AS8PR08MB8996.eurprd08.prod.outlook.com (2603:10a6:20b:5b1::13)
 by DU0PR08MB9298.eurprd08.prod.outlook.com (2603:10a6:10:41d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.12; Mon, 27 Jul
 2026 13:48:55 +0000
Received: from AS8PR08MB8996.eurprd08.prod.outlook.com
 ([fe80::ee9d:8228:404b:262c]) by AS8PR08MB8996.eurprd08.prod.outlook.com
 ([fe80::ee9d:8228:404b:262c%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 13:48:55 +0000
From: Shukai Ni <shukai.ni@kuleuven.be>
To: agk@redhat.com,
	snitzer@kernel.org
Cc: mpatocka@redhat.com,
	bmarzins@redhat.com,
	gmazyland@gmail.com,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Shukai Ni <shukai.ni@kuleuven.be>,
	Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
Subject: [PATCH 1/1] dm-integrity: replace forgeable discard filler with a keyed sector marker
Date: Mon, 27 Jul 2026 15:48:41 +0200
Message-ID: <20260727134841.1109615-2-shukai.ni@kuleuven.be>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260727134841.1109615-1-shukai.ni@kuleuven.be>
References: <20260727134841.1109615-1-shukai.ni@kuleuven.be>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0525.eurprd06.prod.outlook.com
 (2603:10a6:20b:49d::16) To AS8PR08MB8996.eurprd08.prod.outlook.com
 (2603:10a6:20b:5b1::13)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR08MB8996:EE_|DU0PR08MB9298:EE_
X-MS-Office365-Filtering-Correlation-Id: 738fda76-767e-4175-7cd9-08deebe5ccdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|786006|10070799003|22082099003|18002099003|56012099006|11063799006|3023799007|10067099003;
X-Microsoft-Antispam-Message-Info:
	dfww/2pDefugYz2buG+fxggPJ93YL24FtUBlh6zIs3nJYZZZiiOOHivgInMjnGsj5X6r9GORfJ4K7y3/sM4WTBQfuHN0wE4ggQx7VojS71OsSLCjR1yCglvgahfBC5vAFTuueNmL2qqPUbeO8c1TaZcRJiLQnaXBbc0oEveFEd/aOBFsIpwu2Z/nilFV76ORR/Rh6J1yoAHaojaUDiriuFxmD6egS02DQYMFtPnjADOSILFmyG5MCn5LovyOyRy/0fbzWtwOuGeVozygEAnry6gDIA4A6XhdOyrchh6vHovlsZxUMWuop5cjBWUzauFtf1f66btXixCaTMezy96Q85o1XGCj6UntJ/TYlE4jh0SIzJa3avCynhnwvpHXS0bezoVFytCJUyHxq4GMY0HEaCll8RkpuormQxKJE+BBJBcjkOXUClHwMMyT8Crqy7zweMQ9KNEvqNd3+VkWW65/I/EytyYUXxYrfoP1/VwrvSw0j0ne6Y89Wf/1fMDN+yVx2UoIDwuQxigC9d4U3Dg9qasqLrI6VzZztabUbRRRhaeRhx+O8pvculf1wGoTaCq+9/zSvrLoEZLeKtrFzCxwEm+v6942SWHYPMC4TT+VecYFMo15f8ruhfwbEZQQNjKrJyqi0ad4tEXVEs+R6Cln8WDZNw0oHLcTqhCTNQy0nhU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB8996.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(786006)(10070799003)(22082099003)(18002099003)(56012099006)(11063799006)(3023799007)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?23vOoCkJP+Ozqxg0bfghPKnhU++u4hAyuRQPsuyEZ2ZDfMmceIpnNFcQ5JST?=
 =?us-ascii?Q?6e1f0LO+uYvjIq37iz+mpbFNVNRtKNB4kfvQmJyGoiXuFFFjbYLeD/mbIzXt?=
 =?us-ascii?Q?n57b24bJ3UaJpd3G/VHqWtADTC0VS52Y2fwLEVr2tFjgRWQffDrHtBi22C+W?=
 =?us-ascii?Q?KUlNIS4gWnOPqta0nFZOXtIXTa34Jfc2HMkCOXXEsdpGlaQqyUCidU5MRplA?=
 =?us-ascii?Q?8UtdS3W+rI8VV+8OgK4Gt9O8+yi8Br0HBVDdZ3o4JE9OC5Q1Lh8RkshawzpJ?=
 =?us-ascii?Q?Aw+7kLpHjPNqthPKmRFd91FpvVWx3U++ynTRproQ5k7mohpVNNY11YvsvIHR?=
 =?us-ascii?Q?Gxd4O9qlngKE/Cq9j5UKDIAI4snbYijGqPdUWnsE23mzFtC4dBdMTTA1hhnL?=
 =?us-ascii?Q?1qQNxroxgKMZzpoBnCfbrIAYZUxCF8bGz/ztMmdhWnZHQNYTizqTj5PWBdMd?=
 =?us-ascii?Q?8QLZB9+Dgg7yEiCzyhtIEXo9GvEnkNDItM8aaXDVqsnW2102xZnkOYM56T1s?=
 =?us-ascii?Q?WEIm98KmKn+ltm/foFLasuLnh2fNtKcakUsxMQ0fAm0vBtjEdPWFuEqUqI8r?=
 =?us-ascii?Q?D3xENIZpFFJ2euotTJL0DbiqZcsyCAaLH+epUpvt8oA3P8ubAzGYecAN00NC?=
 =?us-ascii?Q?QKc49EFZrx9SZg9+TNdX0Dr0sv5cJdO4YzUrTKUG9NJS8kvoJeksdfPymcd5?=
 =?us-ascii?Q?0SZsqzmvpAI7VYzwctGjLGCsNZ4Jer8QuRjbf+zKOsrXZrq4210oJwHpMJa6?=
 =?us-ascii?Q?OFsjNLzrDvpE4lyi988gHbFTHLbvePU8GqyZH7Gsl3DdstlGARwcCnZPRfRT?=
 =?us-ascii?Q?6xF1Z6eSpJLbi1GXQ8qu+kY+b5vF0AusQrTJRJZIrzIHgroqOTIRPqKmBw5s?=
 =?us-ascii?Q?KXSXHuEOFMycmJLA0l2mE6KDGxCh6LtF5swu5l/xRVVv+SfEZ6efV1+3GM76?=
 =?us-ascii?Q?NmcCXTqJmCUsf/56pBRWrtcN9lpdWYISrydaWAr73Ak/WF/dCV/YFHS1vblw?=
 =?us-ascii?Q?MDo/4tAoxeN13LwMbRz8j13Te8zkAAYoj4XJvE12YQS8kN4T60Ix6rCVZfwL?=
 =?us-ascii?Q?sJpZwYRjw+va7yEFr/IXGTUzKcwcrZ/HN0KKFfUjLGGCvKUkDKsosNP2e4qx?=
 =?us-ascii?Q?kroYBwY9jjr+MVaPFQ+9AUAa+IZ/+ZDjd7r/1uQe/BdTBgWrp/pdQRWsziG4?=
 =?us-ascii?Q?3G4j7of+be7Zh7V9A2Fq+75kQ2qI8c2ERPaRXplShrdVZNlwPXfqX+Xa/GHc?=
 =?us-ascii?Q?N3UR87qHSu/WxerweEFzrLcJd6sn9bI5zOmeBf1RjCDGeY+DfIUYaqurB6tR?=
 =?us-ascii?Q?SUGHmH9IQNm4hN6w/LkGwjEraYakfZUj+RfQ/nvgiIhfgef9EjektPtYg2qz?=
 =?us-ascii?Q?xFu8t95KWl/F8NDLyuThaI1rVFMErceKFomXcX8SA5QwpL7XEUFExgjlmaT4?=
 =?us-ascii?Q?bEt3J8XJYsdCQdnJKYnUgPypPwInhtnKwZAN0yO3E9GvvPyhDnnZCuduRL5l?=
 =?us-ascii?Q?8nKXcYosCIKdOCQC23huSM2KEkEwbEao+YtUoqvf5x81gPUw2nKw9A6meQZy?=
 =?us-ascii?Q?Zf9f2h+M4T8vSi8F9D60z0RFv2+hbMhfZf3htfvjY9YfvXl7+reCNUJfKF/9?=
 =?us-ascii?Q?Zi+A65pWRdoLn3Deh+896Ue5OLH1l42ZCWSmqFsmXO3GElKGiK6pwIA2fTzu?=
 =?us-ascii?Q?FEWsIfBTLNjWyR5CPbL3TJt3K3On5e9kttg7sicrWYxoEdcvK3v45IZ6tmBS?=
 =?us-ascii?Q?vd11q7M1PFq+HVii/MyUj8Wg5jMI23mbxaBIstl/avdNoS5ZYo6I?=
X-OriginatorOrg: kuleuven.be
X-MS-Exchange-CrossTenant-Network-Message-Id: 738fda76-767e-4175-7cd9-08deebe5ccdd
X-MS-Exchange-CrossTenant-AuthSource: AS8PR08MB8996.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 13:48:55.4658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3973589b-9e40-4eb5-800e-b0b6383d1621
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oTLXKdRGc4hyqnw0k2RaoluiTiYXpkDkd+FjbhIJYwWRGXgx1x5W6HI/ZN7sc7ueSEs9IvWX3KgeetKpf4dAOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9298

The discard-block check in dm_integrity_rw_tag() treats a stored tag
of all 0xf6 bytes (DISCARD_FILLER) as proof a block was discarded and
skips HMAC verification. allow_discards is only accepted in
dm-integrity's standalone mode. An attacker with raw write access to
the backing device, but without the integrity key, can stamp any block
with an all-0xf6 tag and have it served as authentic.

Replace the constant filler with a keyed checksum of (salt || sector)
and no block payload, computed by integrity_discard_checksum().

Fixes: 84597a44a9d8 ("dm integrity: add optional discard support")
Co-developed-by: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
Signed-off-by: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
Signed-off-by: Shukai Ni <shukai.ni@kuleuven.be>
---
 drivers/md/dm-integrity.c | 77 ++++++++++++++++++++++++++++-----------
 1 file changed, 56 insertions(+), 21 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 06e805902..7a58086a7 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -44,7 +44,6 @@
 #define RECALC_WRITE_SUPER		16
 #define BITMAP_BLOCK_SIZE		4096	/* don't change it */
 #define BITMAP_FLUSH_INTERVAL		(10 * HZ)
-#define DISCARD_FILLER			0xf6
 #define SALT_SIZE			16
 #define RECHECK_POOL_SIZE		256
 
@@ -1414,7 +1413,6 @@ static int dm_integrity_rw_tag(struct dm_integrity_c *ic, unsigned char *tag, se
 {
 	unsigned int hash_offset = 0;
 	unsigned char mismatch_hash = 0;
-	unsigned char mismatch_filler = !ic->discard;
 
 	do {
 		unsigned char *data, *dp;
@@ -1457,16 +1455,14 @@ static int dm_integrity_rw_tag(struct dm_integrity_c *ic, unsigned char *tag, se
 					 * individual bytes.
 					 */
 					mismatch_hash |= dp[i] ^ tag[i];
-					mismatch_filler |= dp[i] ^ DISCARD_FILLER;
 					hash_offset++;
 					if (unlikely(hash_offset == ic->tag_size)) {
-						if (unlikely(mismatch_hash) && unlikely(mismatch_filler)) {
+						if (unlikely(mismatch_hash)) {
 							dm_bufio_release(b);
 							return ts;
 						}
 						hash_offset = 0;
 						mismatch_hash = 0;
-						mismatch_filler = !ic->discard;
 					}
 				}
 			}
@@ -1645,7 +1641,8 @@ static void integrity_end_io(struct bio *bio)
 }
 
 static void integrity_sector_checksum_shash(struct dm_integrity_c *ic, sector_t sector,
-					    const char *data, unsigned offset, char *result)
+					    const char *data, unsigned offset,
+					    unsigned int len, char *result)
 {
 	__le64 sector_le = cpu_to_le64(sector);
 	SHASH_DESC_ON_STACK(req, ic->internal_shash);
@@ -1674,10 +1671,12 @@ static void integrity_sector_checksum_shash(struct dm_integrity_c *ic, sector_t
 		goto failed;
 	}
 
-	r = crypto_shash_update(req, data + offset, ic->sectors_per_block << SECTOR_SHIFT);
-	if (unlikely(r < 0)) {
-		dm_integrity_io_error(ic, "crypto_shash_update", r);
-		goto failed;
+	if (likely(len)) {
+		r = crypto_shash_update(req, data + offset, len);
+		if (unlikely(r < 0)) {
+			dm_integrity_io_error(ic, "crypto_shash_update", r);
+			goto failed;
+		}
 	}
 
 	r = crypto_shash_final(req, result);
@@ -1698,7 +1697,8 @@ static void integrity_sector_checksum_shash(struct dm_integrity_c *ic, sector_t
 }
 
 static void integrity_sector_checksum_ahash(struct dm_integrity_c *ic, struct ahash_request **ahash_req,
-					    sector_t sector, struct page *page, unsigned offset, char *result)
+					    sector_t sector, struct page *page, unsigned offset,
+					    unsigned int len, char *result)
 {
 	__le64 sector_le = cpu_to_le64(sector);
 	struct ahash_request *req;
@@ -1707,6 +1707,7 @@ static void integrity_sector_checksum_ahash(struct dm_integrity_c *ic, struct ah
 	int r;
 	unsigned int digest_size;
 	unsigned int nbytes = 0;
+	unsigned int nents = 1 + (len ? 1 : 0);
 
 	might_sleep();
 
@@ -1720,12 +1721,12 @@ static void integrity_sector_checksum_ahash(struct dm_integrity_c *ic, struct ah
 	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP, crypto_req_done, &wait);
 
 	if (ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC)) {
-		sg_init_table(sg, 3);
+		sg_init_table(sg, nents + 1);
 		sg_set_buf(s, (const __u8 *)&ic->sb->salt, SALT_SIZE);
 		nbytes += SALT_SIZE;
 		s++;
 	} else {
-		sg_init_table(sg, 2);
+		sg_init_table(sg, nents);
 	}
 
 	if (likely(!is_vmalloc_addr(&sector_le))) {
@@ -1738,8 +1739,10 @@ static void integrity_sector_checksum_ahash(struct dm_integrity_c *ic, struct ah
 	nbytes += sizeof(sector_le);
 	s++;
 
-	sg_set_page(s, page, ic->sectors_per_block << SECTOR_SHIFT, offset);
-	nbytes += ic->sectors_per_block << SECTOR_SHIFT;
+	if (likely(len)) {
+		sg_set_page(s, page, len, offset);
+		nbytes += len;
+	}
 
 	ahash_request_set_crypt(req, sg, result, nbytes);
 
@@ -1763,10 +1766,28 @@ static void integrity_sector_checksum_ahash(struct dm_integrity_c *ic, struct ah
 static void integrity_sector_checksum(struct dm_integrity_c *ic, struct ahash_request **ahash_req,
 				      sector_t sector, const char *data, unsigned offset, char *result)
 {
+	unsigned int len = ic->sectors_per_block << SECTOR_SHIFT;
+
 	if (likely(ic->internal_shash != NULL))
-		integrity_sector_checksum_shash(ic, sector, data, offset, result);
+		integrity_sector_checksum_shash(ic, sector, data, offset, len, result);
 	else
-		integrity_sector_checksum_ahash(ic, ahash_req, sector, (struct page *)data, offset, result);
+		integrity_sector_checksum_ahash(ic, ahash_req, sector, (struct page *)data,
+						 offset, len, result);
+}
+
+/*
+ * Authenticated marker for a discarded block: HMAC_key(salt || sector), with
+ * no data payload. Because a real data tag's input always covers a full
+ * block, its length differs from this marker's, so the two can never
+ * collide structurally, regardless of block content.
+ */
+static void integrity_discard_checksum(struct dm_integrity_c *ic, struct ahash_request **ahash_req,
+				       sector_t sector, char *result)
+{
+	if (likely(ic->internal_shash != NULL))
+		integrity_sector_checksum_shash(ic, sector, NULL, 0, 0, result);
+	else
+		integrity_sector_checksum_ahash(ic, ahash_req, sector, NULL, 0, 0, result);
 }
 
 static void *integrity_kmap(struct dm_integrity_c *ic, struct page *p)
@@ -1820,6 +1841,7 @@ static noinline void integrity_recheck(struct dm_integrity_io *dio, char *checks
 			char *mem;
 			char *buffer = page_to_virt(page);
 			unsigned int buffer_offset;
+			char on_disk_tag[MAX_T(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 			int r;
 			struct dm_io_request io_req;
 			struct dm_io_region io_loc;
@@ -1847,8 +1869,16 @@ static noinline void integrity_recheck(struct dm_integrity_io *dio, char *checks
 			}
 
 			integrity_sector_checksum(ic, &dio->ahash_req, logical_sector, integrity_identity(ic, buffer), buffer_offset, checksum);
-			r = dm_integrity_rw_tag(ic, checksum, &dio->metadata_block,
-						&dio->metadata_offset, ic->tag_size, TAG_CMP);
+			r = dm_integrity_rw_tag(ic, on_disk_tag, &dio->metadata_block,
+						&dio->metadata_offset, ic->tag_size, TAG_READ);
+			if (likely(!r)) {
+				r = crypto_memneq(on_disk_tag, checksum, ic->tag_size);
+				if (unlikely(r) && ic->discard) {
+					integrity_discard_checksum(ic, &dio->ahash_req,
+								   logical_sector, checksum);
+					r = crypto_memneq(on_disk_tag, checksum, ic->tag_size);
+				}
+			}
 			if (r) {
 				if (r > 0) {
 					DMERR_LIMIT("%pg: Checksum failed at sector 0x%llx",
@@ -1914,13 +1944,18 @@ static void integrity_metadata(struct work_struct *w)
 			unsigned int bi_size = dio->bio_details.bi_iter.bi_size;
 			unsigned int max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : HASH_MAX_DIGESTSIZE;
 			unsigned int max_blocks = max_size / ic->tag_size;
-
-			memset(checksums, DISCARD_FILLER, max_size);
+			sector_t sector = dio->range.logical_sector;
 
 			while (bi_size) {
+				unsigned int i;
 				unsigned int this_step_blocks = bi_size >> (SECTOR_SHIFT + ic->sb->log2_sectors_per_block);
 
 				this_step_blocks = min(this_step_blocks, max_blocks);
+				for (i = 0; i < this_step_blocks; i++) {
+					integrity_discard_checksum(ic, &dio->ahash_req, sector,
+								   checksums + i * ic->tag_size);
+					sector += ic->sectors_per_block;
+				}
 				r = dm_integrity_rw_tag(ic, checksums, &dio->metadata_block, &dio->metadata_offset,
 							this_step_blocks * ic->tag_size, TAG_WRITE);
 				if (unlikely(r)) {
-- 
2.53.0

