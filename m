Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2051.outbound.protection.outlook.com [40.107.215.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D382D054
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 09:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.215.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715677558; cv=fail; b=bZH2D3+jfAZbbMKJFsWV+4L60USgOVMbWEW5nHLlpIfTh9lF/GeM5Iq8cKC4ykCuW92PoKhtng/GANs5ixTPexlaqK5vsXkyUuvRZQkX7DuqkfYd2Gm/zwxmCBkkSUy4YrAFQ3O8/Xo0L8TqTgmpE1Gne4u3eRcLOJJXCIVBGK4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715677558; c=relaxed/simple;
	bh=Dd2Ne+wYYQlf67SHMr3G51DSNztSqYbRu48pXFAFIJc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Po594MCKm5jQEbLU95LRMMBC6a7UFFBruYopr8jqPO3uIfxXqfcFeq5ZOnsZsxvpnKn+hNBb3i9INkF9bsZ2Af4hrE8Mlq3aCu29OT0pQGnxWNWQ69HrmO44qzCig0Dqt+JNIFLBO5LbpbqqC9DkEgbVAZINOjf9z2SpgEBWPTU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=f6aUMyaF; arc=fail smtp.client-ip=40.107.215.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="f6aUMyaF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jUFzOSAvVX6aVOpLKyPyLofAsXU7JgaqUVqhK+nC90xcVAJ2Vcnlt7EhfNLh9FaCLFtcPnsa+kVeAoCHsChf3Hb1Ogp3oIaPc0anejvMQ+w/QRVJQUO5mBaaqrxme4gQTe76F+L49pJ/SUqfeeIBjRc+pevojhmrPPHQ05m8x7W20wOKJkoZsKJLpNrz6QQ1/RIuySIecWBGyj0l1KT6VosPVH5bhla22raHRCRNlVhh8hUh8HudlmzWvxxVz8VBPmkcmiPpaJPqzWReOrbDGt2ZDDAAGF11tHr9VMLe22mMStDisfxxvZT5ypq68jXQFSZuKYua/fuYxG+V4CaFvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GJNf9BhDEBQw+QBjmIK43ZXJQ02KyxkOt212RsPDMms=;
 b=dzwAxpkNC6AaKh9MSp/gwe0fT4oQIrDkGAdnwtSO10kEkX6AEV64Ng7q5xbrHsn+wZIkDRyWxd2GTCeW8zgy8E/tEBKYlQPOR93rWZsNnsuu6Ja4umAvkqPfn/wQ1vwV5J3yxNXb1WM1O94TJDCZkEg5sm0VD8n5gPhWivPlb8b93G4534vSgXV16dh5STtqOPMpksSkuPRntzWzbugHoxEXxuoX50wbo4Eu8OWnFimedsGv/EUbbxcQDC8MsXS7p1uG45uxUim1tGEZYtesay5yiP0W6ceZsAbo0MVnwCZffLE39hg8o4c/uzhqvtF4Jil0D7SQy7BHaq2ktzXFnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GJNf9BhDEBQw+QBjmIK43ZXJQ02KyxkOt212RsPDMms=;
 b=f6aUMyaFppsmccqZJbOELNbcsyv8pPTQ8W1dPmlR5Lac04n7szoBYIRzrGRujb2wgefBQErBKhsNBaxVQyPEjK//3SVz0CN1lCrAMRRxY1B/2Xp+x5CkDUesPn//KysZu8BV7utnzkxjgfosDN38hi3iiL4f6cQY5XpGkbyp42TdHD6AN+027cEzlcN67BJrY8Sn0rFLHj2h3YhwBFpH72tNBtf9UTP72qlhuvQpf8SQqJP5XvhbTxH5oYn9IJo7Oxjn+OoeRpnZmULLGEcFdDdT4bwgTAqjoxp3VBGp5QF0wevASSdkH6DRVGATNl/9TH6fWik34g1XAkZfT3FVKQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEYPR06MB6398.apcprd06.prod.outlook.com (2603:1096:101:145::9)
 by PUZPR06MB6102.apcprd06.prod.outlook.com (2603:1096:301:112::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Tue, 14 May
 2024 09:05:52 +0000
Received: from SEYPR06MB6398.apcprd06.prod.outlook.com
 ([fe80::9784:d8bc:5eb5:b60e]) by SEYPR06MB6398.apcprd06.prod.outlook.com
 ([fe80::9784:d8bc:5eb5:b60e%6]) with mapi id 15.20.7544.052; Tue, 14 May 2024
 09:05:52 +0000
From: Yang Yang <yang.yang@vivo.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Yang Yang <yang.yang@vivo.com>
Subject: [PATCH 2/5] dm: add __send_empty_flush_bios() helper
Date: Tue, 14 May 2024 17:04:41 +0800
Message-Id: <20240514090445.2847-3-yang.yang@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240514090445.2847-1-yang.yang@vivo.com>
References: <20240514090445.2847-1-yang.yang@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0046.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::14) To SEYPR06MB6398.apcprd06.prod.outlook.com
 (2603:1096:101:145::9)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEYPR06MB6398:EE_|PUZPR06MB6102:EE_
X-MS-Office365-Filtering-Correlation-Id: 8690b0bd-e8da-459b-2927-08dc73f50e53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|52116005|1800799015|366007|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mPXI4ddRs2oeaaFR+COxloOCSzRo4HV/32WMaNqgzyXGzKhnCXSEvEcI6RNb?=
 =?us-ascii?Q?DQ6ES1nclXxCre+hz4NMmNTtO6kURWoVfKpU+47WOnsxyEWfkMNb4SZ0PWxG?=
 =?us-ascii?Q?vP+TOYcfjzKABpFYAsuZvtgWT5jQcfPusBxGy9qz8r6OM2FS0UE7LZZTAt79?=
 =?us-ascii?Q?YsQ0sXEwDgmvbNBvY85hRGJAclhYCKtd8s1a/OlRKqOAUaMajSxnc/O8ebiX?=
 =?us-ascii?Q?TpeLFChGhAwlmYScMq7y//iaN82I81DYgKqvy70cZbkDcGpEigkpNmz1eQiq?=
 =?us-ascii?Q?4khGccBDV6ErkYwcV1a/iBEgB4o2jLJYtYWVOi/pZ7lXUhP3VFrrA8qq/gax?=
 =?us-ascii?Q?woGBOeG5ytn66VEYY6SnEBERcq5vSZ/yFnDbfz6cIrpxhEGyNs4oV30t0U2p?=
 =?us-ascii?Q?g5CMSKIECTskSl+5QxCAM8bTAKHZzYrLtLyqDKV1ERl8bSGIs+/0BJjna/Zm?=
 =?us-ascii?Q?wtkp4rln2ZnzqaxHp8Z+Hqq1rKP0GQWItm3eja8pR0NAP64ux5ZsEXaO48YH?=
 =?us-ascii?Q?iy60W+kYTXM70X6nPffmqZF7+jv53lSccTT8ThhqkiyNWmZLbcx5VF22UlpI?=
 =?us-ascii?Q?fm19jwJU7RfGfoT/ZR7HmlTl0iUI7n4/3CJnFcK9dtY9+BlE63QfNs8SysiW?=
 =?us-ascii?Q?PkKdGxaM3vtxHoaFJ+DpIFu2DsspWvddSBQ2S+vTkjExU5w147d5YWcHi8WG?=
 =?us-ascii?Q?OePB4901cI/+/PXBTC+dMCL372jkLpvmloY08nwPQHStJxqn31cBDFpFbUR9?=
 =?us-ascii?Q?55Qak8bInvs88wYJEazCmlYY+OvAb+By86mDRuDB45acmXtJXbIFFfLL7TuJ?=
 =?us-ascii?Q?2kVo9hMIhmr283ylIP8AoOwdfU8UIpRWVZ/kxdy+nVniiWm45CV90hzLuAON?=
 =?us-ascii?Q?nPHMdrhGHq4mwJNmBwNcQoLB14tUX0tZfkmaWXjcRItVObLJiA0wwYHpGu28?=
 =?us-ascii?Q?qeklxLeSBl9y5IcWl5rU6swPxL7Cmlfqz6Sk4t0UmshbHT9nbXjL3gjP14Ml?=
 =?us-ascii?Q?bv+VEg+EW8TYMFLsPgdy/+gUtcrV/RLHsQCP8boiJJhmWxKyygDDeQlz8XpA?=
 =?us-ascii?Q?m2Q+/tvpbo3jusFn+51iyDkXoOIQ2R9trE6oZNulol2hgHuK8XsnpXZqZgnl?=
 =?us-ascii?Q?Wvc1zHd1X1H2kbSMO3DZ9sESBHH2iq2vnL3NScCAzCx2istljlLPlyQzAtc2?=
 =?us-ascii?Q?Vr+5oy8Gm5plGb5kFfjSjfiScduaTWmav6ooG3JfisLK3G6YHpo0pelAZzEQ?=
 =?us-ascii?Q?pd0XBtLdW9PwLMGdyCmrRv6aqrqPYb7Wz768b3vRHF6XzGdeU37zvCrnUVsM?=
 =?us-ascii?Q?oBRZrBfJHKqk0jT5a02gGOJQwOi+oIAMhIZMsbFN73jD6w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEYPR06MB6398.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(52116005)(1800799015)(366007)(38350700005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tk7rSAqmPfWkIom1RMLyFhuZUjkXlIEaq7FF2+m7opIzHcy4+blM8lYoGZOi?=
 =?us-ascii?Q?ccxEf/k5AiFMw9vdPzV4l67Sf14Qi0wPwmlFAy37N523fnCCeXtG11BHtvUv?=
 =?us-ascii?Q?7eKR/YMGqhx9xqIWeE3S8jbj83rsVYQZiMqx266tXNC6ekFfqfvFXJXyeJd+?=
 =?us-ascii?Q?TVJRVtDBbj4ypnPnBIS38JrxTZSTz2NLGlVX99eODJ3Y7gsjr6CmIGHndZq2?=
 =?us-ascii?Q?KKrgtu+I08+Tv0KF+eKN86bxISWoI2TkcKq2d9uyVYIBKiDO8aXutOBjT0cN?=
 =?us-ascii?Q?GkcVWR7S/m8Yzr9VckOfEJYIPjjxya18qOQ6tpSVNEXBM+V2ewl/H8cVVLnz?=
 =?us-ascii?Q?q2GxBKCAMk81gr2YI/nSjKUU6M/QU0r/evJlpV3h3OICBvk3bHbVgLmb/FSJ?=
 =?us-ascii?Q?Awqlrhaan50gV81FoL95yGRgc2Sk93F+2GihbXXJsy123HHSQZsfYkb46lfZ?=
 =?us-ascii?Q?YZlNLv3OBNS+XJ+21+EQuabgE0eFLZ0EnYxsMvgqVCC1FYqrag2hxBVIN6SN?=
 =?us-ascii?Q?BAnQYWJVX+jXxuJZWPaKQz90RL0a0hd7RmjDO2fSkr/6OBstbQ0WkHaoO2KK?=
 =?us-ascii?Q?tLHTexqywTkUap+bC7UVXMTjF4uXIXu6pRCoM03gdgHp1lWYpAZNIpiUW8Rb?=
 =?us-ascii?Q?YuAlhc3eEo3lMOE8/DL5ATY5kt5ihVImLU+jrx2Eltxt9KJvdhz28gDdff1q?=
 =?us-ascii?Q?bOMCGtGU3FDo9/FH9cTRxMOjHtniKPRaRSs4xsEGBgGTDhTO6kTgSTI7njXL?=
 =?us-ascii?Q?RVQRRhnU/4NY3L9UhpERbceTbPAUtol01UwGQtusJx1PDiGZu1nwN2FW/3W3?=
 =?us-ascii?Q?dl0YXgnImSp8Q9T9EXwgiDz7oRzERwYtcH1Y2pD7HJmLc43izICOZxqmATcf?=
 =?us-ascii?Q?gK5+EjcVFsqNcSrNQuuyXB94JNvtb+IoHBIP7GKMwkkYmHjX0nhUMp4kvo9x?=
 =?us-ascii?Q?21a/FfVYu7dqrrpKcxc+bQZmhLtGw5kID5Tfg71nCOjlp89zxaNHWqjP61AC?=
 =?us-ascii?Q?ASTdElcJJ+CcjjZ/bMObNAHC9WkIcwgzgT0vpzlx3bp6Msrv1bZOExL8nTMD?=
 =?us-ascii?Q?rIB4w9hUmkfA2rEFp1ZkonBnim9a0JI+2E6MpXFG4FwqKvZjPuS927tXLaeU?=
 =?us-ascii?Q?s7Y4ndOW9xWU52GVJlxdu3xJ7ntJ18v8aVNoDzwKb17IX8AQmNQqFrcGxWk6?=
 =?us-ascii?Q?hCrwwWcjhkKrO+8um1chW/Bxu8DznIgkGRuRmzwJDRwLmaKI2LBhsrL6/uBN?=
 =?us-ascii?Q?WBJNunvGo0/EEEFcbNBXF6Hii9v7KaTP02Qe8GjsHIEAiqyr4BMmNtasyKnl?=
 =?us-ascii?Q?ENLTGAOvqUM+ZFrpJ9g21DYbAKM9AnFrf5uxeaZNXVmjuFP2GoU+YDsx71GW?=
 =?us-ascii?Q?6dQu1f9WM4qmdP53nf2tglxf4po5MZnk9l7eAYpOUI8rAEPBzO49dvm59N7J?=
 =?us-ascii?Q?1ipPG8K7nAHCqUWRMFYK+Gq1yLFlqno5U6Cu3EGn4/+S4OC7YrYEFUIlP4x4?=
 =?us-ascii?Q?cyDOiP37HOGZtHHD+QbQzwDV7Me3H/aC/8bKKMHVmJK0TdrputodY7SMqWZj?=
 =?us-ascii?Q?PwOxssRx2WfJbQX3xTptGHTHnWLh59SarzibVUe2?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8690b0bd-e8da-459b-2927-08dc73f50e53
X-MS-Exchange-CrossTenant-AuthSource: SEYPR06MB6398.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2024 09:05:52.6184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3GdhOrPvHV4qsNMP5YQxnd/40qFnqQsSWyFL0e43gH5BG5gS7CL0uRBr/b3rSa8gQBNE9FurT01Jx4zEMYfXng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR06MB6102

There are no functional changes, the helper will be used in later
patches.

Signed-off-by: Yang Yang <yang.yang@vivo.com>
---
 drivers/md/dm.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 56aa2a8b9d71..25215b93c3cf 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1543,6 +1543,20 @@ static unsigned int __send_duplicate_bios(struct clone_info *ci, struct dm_targe
 	return ret;
 }
 
+static void __send_empty_flush_bios(struct dm_table *t, struct dm_target *ti,
+		struct clone_info *ci)
+{
+	unsigned int bios;
+
+	if (unlikely(ti->num_flush_bios == 0))
+		return;
+
+	atomic_add(ti->num_flush_bios, &ci->io->io_count);
+	bios = __send_duplicate_bios(ci, ti, ti->num_flush_bios,
+			NULL, GFP_NOWAIT);
+	atomic_sub(ti->num_flush_bios - bios, &ci->io->io_count);
+}
+
 static void __send_empty_flush(struct clone_info *ci)
 {
 	struct dm_table *t = ci->map;
@@ -1561,16 +1575,9 @@ static void __send_empty_flush(struct clone_info *ci)
 	ci->io->tio.clone.bi_iter.bi_size = 0;
 
 	for (unsigned int i = 0; i < t->num_targets; i++) {
-		unsigned int bios;
 		struct dm_target *ti = dm_table_get_target(t, i);
 
-		if (unlikely(ti->num_flush_bios == 0))
-			continue;
-
-		atomic_add(ti->num_flush_bios, &ci->io->io_count);
-		bios = __send_duplicate_bios(ci, ti, ti->num_flush_bios,
-					     NULL, GFP_NOWAIT);
-		atomic_sub(ti->num_flush_bios - bios, &ci->io->io_count);
+		__send_empty_flush_bios(t, ti, ci);
 	}
 
 	/*
-- 
2.34.1

