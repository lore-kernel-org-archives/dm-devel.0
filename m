Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.162.83
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794001017;
	b=lLn1hjXRY3XaujZabCKQe/davVRTQHo2OAO5nzxHP+UDvUeeQRaEuVwaGDrkh7sNjKye
	 lbdadXGpMVWWlQwfeBzU80Vl+DCfB/+nh5dXV8qiPYpHz2VyMcevlxbx4xpC5RsX2Ukc5
	 w1+1WPWdiL7h0W0PWF73O0kzzEkVigfz1i03e/zgHhLqYpbSkT2vZoBl0CodRrMiuTErA
	 HE4sKEEuy7t4y6MQVdtBpXxQORJdz5zbVkJWvFlEDAL7QLQWi8H3Q++z4JD0dOT6YCKLQ
	 +fadyCaumJW2pmCoj1hXpVObVej2mgEKnpyXyxyL88lsWHAZnZEYlIKofQITDHS2FJg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794001017;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:Content-Transfer-Encoding:Content-Type:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=SmUgZv3A/aq/RXLVveIFfH/s0ZCrKBTwAaW773QmsEE=;
	b=ncdUz0YswMKcm9FZBnSueA7yTDFp48uiUoLCEZxI+7wg1oZ6bgqJUAPYCMGKQY7S8eco
	 evPl+t39OtbefPqmXtweH3RxYACsDK7efEAAmIvtsgvy9zscft+NQk5QIIkhxM5MjSS59
	 +SSy3W9hhHawutFXXqfpAOZHLNapj5RY9+VfnxcCJ7+JbI8nXp/QN9kEOv2cmsJAfg2lX
	 ZjlGDGxI5i9x+VebrDTHQtqpp0sL+7Dbq1q5+FhqTcOQMU1365neA7mHzsKF2qcAlcg5l
	 Zxgalmy/qi3GHE8zphbj1dwvvQ7NBmbpW+ettYgJWMymBjtpmzFg0Jb/cNBjLXcSG/Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=kuleuven.be;
	spf=pass smtp.mailfrom=kuleuven.be;
	dkim=pass header.d=kuleuven.be header.i=@kuleuven.be header.a=rsa-sha256 header.s=selector1 header.b=kSCt1nXu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.162.83
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11023083.outbound.protection.outlook.com [40.107.162.83])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7355606A329
	for <dm-devel@lists.linux.dev>; Fri,  6 Nov 2026 21:36:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7355606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kuleuven.be
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kuleuven.be
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=kuleuven.be header.i=@kuleuven.be header.a=rsa-sha256 header.s=selector1 header.b=kSCt1nXu
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k6TnseDOTUnVkxaYbMfJbm0o3bcr41pNchjWXBs6o0HGq4GiunOz/zaewMMcLJqPBM/KL1bDqgoUitIbnPos/oB05irgotmYa4LRQmNJDpxAKPYbNHvkREebEIAx4DjArNJN89gTez19M0DJOb1G0IdThFBi2QP9sYCnG7l/dlEYPanCTSzraZ3a8VsVAUCTsBoRLjbe5bGq4u3Ji3Rjfh4cczPMph19wi8/vd/KkNTfOO7yP+kZ3lIp9V1u/Yl+FjOdGe5ZHLS+3rmBf+Nv3MDdH+RTnUcp9gkQj6P2+EjKAByctbqHJnWWypiP2g2RhDmEmHW1vDYUx2QwB9Ku+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SmUgZv3A/aq/RXLVveIFfH/s0ZCrKBTwAaW773QmsEE=;
 b=kdQg+uLXq2XdQz3o0JsF/QHFSGTEWyd6P9nt0hccBjuilhooloy+fgShwI4n2SuGvLqfT7upfXNVG15hYVTvXISQbY7HwGyVk8ErJCOdq6+5yyvJhoyOvErt5iDypzLcP3HCLHRNHVsddkWdxNd81PJlUiDgQpCkjea+C3cOPAfJuDghJvbM0vE3Mdm2T21qB2IMA249ItmSWHOzHo2j+UdraCOAD/kQ4jQls1xkxpebwX3ZT4RFeJQ6oVRKsGtv5EsaiyB+K4bAKKn9BEU/rNAf17SpdzTU+76sMH2W5x20RGCTECkGVp1Z8VsCoSjNSo+RlDcUx3hTsHX5M1/efA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kuleuven.be; dmarc=pass action=none header.from=kuleuven.be;
 dkim=pass header.d=kuleuven.be; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kuleuven.be;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SmUgZv3A/aq/RXLVveIFfH/s0ZCrKBTwAaW773QmsEE=;
 b=kSCt1nXu0Lf0+2aVdIITpZtRWvQTGsQyqONGsvmOcSybE96AsaFaryqEzlYNnsfgtmoBNLlqVOp8z1yrdatOMhiRzDBYy6CvZSYvV/ZfelLSr3JZMa0JE40GVbXrfQgHRxgn5ZHprnnEGr83L+BMSOvIpoDNVNXFA3byRqU7iKs=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kuleuven.be;
Received: from AMDPR08MB999846.eurprd08.prod.outlook.com
 (2603:10a6:20b:70a::22) by AS2PR08MB10111.eurprd08.prod.outlook.com
 (2603:10a6:20b:62d::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Fri, 6 Nov 2026
 21:36:52 +0000
Received: from AMDPR08MB999846.eurprd08.prod.outlook.com
 ([fe80::a2f1:726a:58fb:8320]) by AMDPR08MB999846.eurprd08.prod.outlook.com
 ([fe80::a2f1:726a:58fb:8320%5]) with mapi id 15.21.0592.010; Fri, 6 Nov 2026
 21:36:52 +0000
From: Shukai Ni <shukai.ni@kuleuven.be>
To: mpatocka@redhat.com
Cc: bmarzins@redhat.com,
	gmazyland@gmail.com,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Shukai Ni <shukai.ni@kuleuven.be>,
	Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
Subject: [PATCH] dm-integrity: return zeros for blocks with a keyed discard marker
Date: Fri,  6 Nov 2026 22:35:15 +0100
Message-ID: <20261106213515.3948508-1-shukai.ni@kuleuven.be>
X-Mailer: git-send-email 2.53.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P192CA0051.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:658::10) To AMDPR08MB999846.eurprd08.prod.outlook.com
 (2603:10a6:20b:70a::22)
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AMDPR08MB999846:EE_|AS2PR08MB10111:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c9d9442-8293-4603-f244-08df3c4e1237
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|10070799003|786006|366016|1800799024|23010399003|18002099003|3023799007|10067099003|56012099006|261028144727099003|11063799006|261021123027099003|261026140227099003|261021121427099003|261102123227099003|261022105027099003|261026121527099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	I6rY03xxYbdUuF0y1Hwf2Vjk4rg3XKGWu0HszPoVjKe6R+S0m/l/q+6o7Byeu2MV7A01iABwVAHu70U822dIKGAHWNhrovupyzuyG8cd6HJazh0J7IXczRwi4/IkdW700zTVPdouW+aTU7VdIJSD/i6fIgNWLMUKlXGwtD05b8SODqJCmUIctu+9rwp7M1Plie2juOY8jGhYGmKoLjcNGRevYTIFL3Q5KONeGXlNq+5ySZSt13Ghw9doy+lawbUJ92rovBox3TDF75V3i7NcJb/TFY/uqKHRXZRCJ63n9y3iBj+4QKJkDP0arVCTozUd8ia1cmGBQYxPGB2dJt7GsJZW7aVyrGHeyGyt/rv07nFj5qKmopslO5JeZT7JJBMdLeUGHwkRnj4YJFJaaKDoJQaC922C298vZnlkFnRzbnEhk8pV+o57rPO+vl49VobUngE9Y/GntPPrl7I3FJ6cwMQwTVFGyphnJ0BJAUGslArtX4sw2fXDWlu8HXbzwM9PigTK+eecQDxBFjQwbL6Ed24KjjonpXqFhCpwhCVPmfpEMBrm8IzGqr8kx0IwsYQ2KePQU9o1W/8QPj3NWIm5v33CtrXAt08FOQ2YFPCc02WK4s4YPuqy45dSe2HBjvll9FmggE1TbWczTvtdKpKhRpT7p3eNNzyElvQZIErjE7g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AMDPR08MB999846.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(786006)(366016)(1800799024)(23010399003)(18002099003)(3023799007)(10067099003)(56012099006)(261028144727099003)(11063799006)(261021123027099003)(261026140227099003)(261021121427099003)(261102123227099003)(261022105027099003)(261026121527099003)(261009223027099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TF7L+jt5iyMDpFgAOTzdpV+ZJ10pabOeP6E1+iyqlXzAMACEVMf4PyLOd1wf?=
 =?us-ascii?Q?XBkDloVe8whfuw50iejdasxla1pVlYHqTpWQAJCeDSCtC3O73llOWNARlG/z?=
 =?us-ascii?Q?QUnu+TTr0PhMlx03121gZl+WQxIZanPYJ8QO1htA5BJCdGnpK7bYZ3Bf7Mv4?=
 =?us-ascii?Q?fHZmI8gaq6m7V7pyGdteRgeBoV9wn0KdUJFmlOCubq1L7vwm4ZmKlKke7W17?=
 =?us-ascii?Q?8gTZ8FQHWmLEIc4OPXvw7vI12BOI3BoX8k1D4shClVWYgjkv7fgf0JEitMVp?=
 =?us-ascii?Q?7mV3avedtpIUlKT0dNXsRcCmeXEUF8Nd/J7SoUYGcAT+I5SHHXgZsc70A9V5?=
 =?us-ascii?Q?twbbPAqb4Oer+sQXg3J+hvS5D5X+oHBCSfgbzP+MCFu2NIVYKJdcbD4pil+3?=
 =?us-ascii?Q?N6K79hnFodOM6VGoYma/J0Y8XxVHRwUQg1RZ/LQ5y8G7Zeq9cfD/p+sV6qvD?=
 =?us-ascii?Q?kftK7kiHAFugbXL/Gka4iqhwDDD4nZynGyF63qOBgcBW7himn9UrASyGIHAG?=
 =?us-ascii?Q?RxEanExHSpHrEHeas5iu1dxlwT63AODLD1/k0dcbjX0mD3URCB5MmmxZ08HA?=
 =?us-ascii?Q?xGnwaanKhB4vmYJ2wCYY8rcf7U3Scw6fI/ZD5gmCOGsD5/rZwiyQIuTcAbcW?=
 =?us-ascii?Q?bOVH9VoF8P02VjLWd3j20vh1ZdV+gd6yA8GJTJzKg3hoFOXUD1arnKOVw3Ll?=
 =?us-ascii?Q?bNd0WuiJ41wgmx4iDZ9D1SU7dti3mVOF1rU8Y5gpxS8b12TkAbUz2OCNN8nb?=
 =?us-ascii?Q?1g8UJI3u2Vs7b8ivpCSqKTX76L4RPSO1wFT1bOJYDgyDa8XREITIkc1SV2I4?=
 =?us-ascii?Q?b2p5J/jgeurRe4G2emqt2ckB9Tlb89OxY8OTA9+NF4G0el6Bx9sDop6XFN6L?=
 =?us-ascii?Q?n35/azQGrHcl9r1HlMWLUrLjlHRBDGFR5rZDeMcZQpXGv0OZ1vm9dnj24AyL?=
 =?us-ascii?Q?nCHKYJzVM34JmyiYJEYvEe4H+9+7HxV15OkGU+KbHIEgpV+RKcMti74W2pF6?=
 =?us-ascii?Q?T7NGq5sWTEz194pbwtkhPMAjL3A5TIdi0KAqXtmDmdYL2rI5RRV4217qstBz?=
 =?us-ascii?Q?ICyimiz5Gl+nj3B/QnHuoSk5yZ90kdjx+wWy2hKehbw8yYQQrkXQw2vygO/5?=
 =?us-ascii?Q?f+dF0YHdHPUvDm8/L2FelpLlgA8BQKYa/ccGKwblobRwyRNiyLibSnXJJhOn?=
 =?us-ascii?Q?PnfCd0RZQYNQd9ICjN21Jj9mtPrv5aj3m5vNDHZQybjDMaamfOOLZidVE/U1?=
 =?us-ascii?Q?/WPfClEx7gJ4t9LP9TeS3Ibu/HS0EvRNs+2zwHRtKjoTdxsYHehEhpHJiDxh?=
 =?us-ascii?Q?M2cnnts5EacMwKKPnPO8pcvo+Et5/zW2QoN489U5C3vESOTVE6xHXxDwIuZD?=
 =?us-ascii?Q?4cu7nne546PA5O6gWblrqM0qfC7nPFDYTRSilqz0uoTTPZA8HT+c90/OdiLq?=
 =?us-ascii?Q?fHrkrLFeSskIxPAEUXJJCcPbPu6Z8i1oiJ6d5a/UlJFI/Iot8JYvhFnjZ3eI?=
 =?us-ascii?Q?v7efkHy2pz25aZ0nrwrsP2vz0Sib8sQqR05cN+QSd4K2zm2jLZX5u73pOymZ?=
 =?us-ascii?Q?wNOg/AaQGf0LKvwNzZYTPstROuQhswNpxZ/5G0uxF70hUSLMylM1VSqKNE4p?=
 =?us-ascii?Q?Vun9spQmjABdnMBrhUqHw0JTIwYufh8EaQQUcOHDPpfqunJWeTP3pKt3odaK?=
 =?us-ascii?Q?K5Q5GECMG5hv4oFqF225knjkSK6WoYCNktB7J3q9leEjtbjL6sREeOH/WEq4?=
 =?us-ascii?Q?bRFt3NG+h8xgPQEBZNYD5zCeQOqDfg/xuGFPF07hAB3Ins1H/7Jq?=
X-OriginatorOrg: kuleuven.be
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c9d9442-8293-4603-f244-08df3c4e1237
X-MS-Exchange-CrossTenant-AuthSource: AMDPR08MB999846.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 21:36:52.1844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3973589b-9e40-4eb5-800e-b0b6383d1621
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9eoFjbD62haHx5C+H2nrb5otOEIsszfKf0eLHl50ljsdSpluV0z5HIINborKPzjUNAKYxTLKj70W3vgJ0QmXfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10111

While freshness is outside dm-integrity's threat model, this hardens
allow_discards_keyed further against rollback of the backing device.
The keyed marker covers only the sector number, so when a block's tag
matches its marker, a read returns whatever data the backing device
holds for that block. Return zeros for such a block instead, so that a
marker restored by a rollback can at most make the block read as
discarded again.

This only adds slight overhead on the recheck path, which a read takes
only after a tag mismatch, so reads of written blocks do not reach it.

Co-developed-by: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
Signed-off-by: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
Signed-off-by: Shukai Ni <shukai.ni@kuleuven.be>
---
 Documentation/admin-guide/device-mapper/dm-integrity.rst | 2 +-
 drivers/md/dm-integrity.c                                | 6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-integrity.rst b/Documentation/admin-guide/device-mapper/dm-integrity.rst
index 9c21301423..b60b83b22a 100644
--- a/Documentation/admin-guide/device-mapper/dm-integrity.rst
+++ b/Documentation/admin-guide/device-mapper/dm-integrity.rst
@@ -198,7 +198,7 @@ allow_discards_keyed
 	Like allow_discards, but marks a discarded block with a keyed
 	checksum of the sector number, HMAC_key(salt || sector), instead of
 	the constant filler tag, so it can't be forged without the
-	integrity key.
+	integrity key. Reads of a discarded block return zeros.
 
 	Not compatible with volumes that already have discarded blocks
 	marked the old way; only use on a freshly formatted volume.
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 92970e1226..7ba8edc5aa 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1839,7 +1839,7 @@ static void *integrity_identity(struct dm_integrity_c *ic, void *data)
 }
 
 static int integrity_recheck_verify_tag(struct dm_integrity_io *dio, char *checksum,
-					char *on_disk_tag, sector_t logical_sector)
+					char *on_disk_tag, sector_t logical_sector, char *data)
 {
 	struct dm_integrity_c *ic = dio->ic;
 	int r;
@@ -1857,6 +1857,8 @@ static int integrity_recheck_verify_tag(struct dm_integrity_io *dio, char *check
 	if (unlikely(r)) {
 		integrity_discard_checksum(ic, &dio->ahash_req, logical_sector, checksum);
 		r = crypto_memneq(on_disk_tag, checksum, ic->tag_size);
+		if (!r)
+			memset(data, 0, ic->sectors_per_block << SECTOR_SHIFT);
 	}
 	return r;
 }
@@ -1915,7 +1917,7 @@ static noinline void integrity_recheck(struct dm_integrity_io *dio, char *checks
 
 			integrity_sector_checksum(ic, &dio->ahash_req, logical_sector, integrity_identity(ic, buffer), buffer_offset, checksum);
 			r = integrity_recheck_verify_tag(dio, checksum, on_disk_tag,
-							 logical_sector);
+							 logical_sector, buffer + buffer_offset);
 			if (r) {
 				if (r > 0) {
 					DMERR_LIMIT("%pg: Checksum failed at sector 0x%llx",
-- 
2.53.0

