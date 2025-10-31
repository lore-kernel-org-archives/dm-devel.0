Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010009.outbound.protection.outlook.com [52.101.46.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5362E0418
	for <dm-devel@lists.linux.dev>; Fri, 31 Oct 2025 15:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761924917; cv=fail; b=IAGrWuehh8+oWUUk3FAnUI7NMb/IT1V2C2AzPBl0KxrVdhj4SCG8WYmwAP3MicGtReUVY7o6UeTdcbBYOgurAjPOI6dQu4BHuLUtvFjoRzmjut1lDh9H10anWiRhlPhNTkehBSc0q4Q63jSSPV6cwhS1/GHxXvhtJCG2ZGoQUbQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761924917; c=relaxed/simple;
	bh=x0zKsmASGy6tXUCay4u6Z+tbtbxIsE7nRNBpiZi8R40=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MPOpCHQy3LFdc17DyPo/jLeLGwqnjYBX0DIv5TJyWU7BJQw5DocNAVMzL0DUjkxMU52UOVMclVZ3vKTy32o16J4F8FXohTh/trqL/75KRTLh+AvocBSixGww99TnZTBs4dFXvtvVOhkO201I/J2ngug9FH5U1/KGRafDpn7FSL0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fWnmZ6Mb; arc=fail smtp.client-ip=52.101.46.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fWnmZ6Mb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bbHXhsZf7S89Vya6JmrqQd7Z1MRqCcCzK9zwbJq6yGdGrHhz6bOu0yvo8KoLJHlSlg9n+ehIqx8rRo/3r+0TK7JIMKL0axQi0XwlRQdO/65Dos2DtjGF30Rxh3dyQNCRqiKA34GwxgXDcpSu7Ydkbpx5r1RLGSj1wK+OMTvLZslMj6QpyDXcKiyf0yRQ7z4I+gmJKONv4XVy3KzNQxrBAROM9zUyk87RCeY0+tpt/wSRsB5a4LQc8sBwRlbgpQAOMoQ26sm/1OXQbhfE7xnSt6ipUwf9T/+2TCVV2K7fgL/8NirgIxE4Y9LU6YdR1B5xW6N/oyNbrXIfQDoOCde8og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PmyUAkpDbty3yCjnTmlAqSTj3AY4JalwYAIDeF8Y8UQ=;
 b=fmpnv9y+1yVf+06gCavZrNgFNrpSrKXBOb8nbwCJhVNxJR8yBwx1Dxs8t7FY0y5pb5dDDEE+Rc/q7xbF6LL9bkKKCqgeKWq5B5+9SBPotWdWq9pxor1sTPkh93a2rskinQI9u95BnuoCSms4R2tyxxGgltnnxK5EgO+2uv4dY3EjgQDmiUEK9EdblZ1rQ2/772t8NhYGKoUV/sz42QIqnk6D0edXDx2U0+lNumE3ib51ZpTx27kfmj/lNm2K3ZB1rG0KCaT83ti6+Yv5kU9XZoDaRdbC5QP7+/Pa6ZvXtX9k9IMOzsL4cTT0fMhgMxdP1QfzySyJZiybRPaMURPByw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PmyUAkpDbty3yCjnTmlAqSTj3AY4JalwYAIDeF8Y8UQ=;
 b=fWnmZ6Mbds1St5h5aqM7SMyxPpwq7IDh/anSgKz1rzeIgXwUyaEjuByteQebg9fT6MFtXrT2/peEahSK8FiwnVx6U+GMrnUGNNATppe0Klgdwcqb1aiU7HyHjxIIrwlEAlC+oVAUdhbTrd5ni6Of6iplfC2C6lKxG448ova8lTSwnlpqqILus2MY+XlXmDbW6i32Poy1O/ptolVF5i9artEyH/TSkXUVMyJb3/ozykrcHww9GmyXtpTdOqGSbWI9yUovpwBrS7G+2X5RdvH6psvCnTTmW9sMZqsRlnombWHfXsyawQO5+rGPKOBoSSM0hrAmHU1T2rD+TssiSrvNPw==
Received: from PH0PR07CA0024.namprd07.prod.outlook.com (2603:10b6:510:5::29)
 by LV2PR12MB5822.namprd12.prod.outlook.com (2603:10b6:408:179::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Fri, 31 Oct
 2025 15:35:13 +0000
Received: from SN1PEPF000397B0.namprd05.prod.outlook.com
 (2603:10b6:510:5:cafe::20) by PH0PR07CA0024.outlook.office365.com
 (2603:10b6:510:5::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.15 via Frontend Transport; Fri,
 31 Oct 2025 15:34:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF000397B0.mail.protection.outlook.com (10.167.248.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Fri, 31 Oct 2025 15:35:12 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 31 Oct
 2025 08:35:01 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 31 Oct
 2025 08:35:01 -0700
Received: from moonraker.home (10.127.8.14) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Fri, 31
 Oct 2025 08:34:59 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Tushar Sugandhi
	<tusharsu@linux.microsoft.com>
CC: <dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Jon Hunter
	<jonathanh@nvidia.com>
Subject: [PATCH] dm: Don't warn if IMA_DISABLE_HTABLE is not enabled
Date: Fri, 31 Oct 2025 15:34:55 +0000
Message-ID: <20251031153455.1057431-1-jonathanh@nvidia.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B0:EE_|LV2PR12MB5822:EE_
X-MS-Office365-Filtering-Correlation-Id: 781c2e64-1561-4985-cd86-08de18931526
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CjtURGItLBH4NmxtkRpekKF18o5B9sDmoQ8O58+Gf07ByBVSni4tsO2RRZRZ?=
 =?us-ascii?Q?ANBS0UvdYOTDqZFlYYPrnbHt8j0piZYG7MAMF1Gg0IS7m0k8W3E2FyWKsWG7?=
 =?us-ascii?Q?NQtioOGcNk5MBJbzWj/nvB8p56q2ufwzA+iWnmK4i6+C2Ueoz4vDzkqgrWew?=
 =?us-ascii?Q?nlK/T0p7Eslb+CcHPHUsMaDbSM90BwHKp9/nKNXL3HN5mCjiKCFNUUIAlIuj?=
 =?us-ascii?Q?+01ZC4Xmsz+uwBuI7njRoBKkExGKQtE5hjJnQ+ecD8uxsxM2eebdDw6NXCRi?=
 =?us-ascii?Q?FHYi3BQUVi3OfxaQTEbrxFz2vpcqhAo1yy1brfel266J8iDYa/nO+AoCbRq0?=
 =?us-ascii?Q?A95NSi759EXoYXA5XFK9LsJC0h7y+vWrtg6nFlCUhHa60GcKyHtkmnUf23bv?=
 =?us-ascii?Q?0PgGYj9ZAELx8OHmkKTiPcrBw/qyeXOh7g25c8BJbnhRA56+ZcoUyELnd+fR?=
 =?us-ascii?Q?v/6wIXJk898sZUG29KqCNAl3kRC89BGdM8StwTDZ1DFFsSVxdVWwKYiq1mvt?=
 =?us-ascii?Q?fR0Jb5Jnu7aVkqqX2tPSHxnQcPbMxiBZUQJ94q8MuR2swYK4jDqY5Mhx8HBi?=
 =?us-ascii?Q?CYmDBM7qzAxHwuxhhJcxJFCMFa/mKC/L/MpJxAIDf99bNBNgEsyGKtySkRr2?=
 =?us-ascii?Q?F/9ZoO3WxS7tWl+frTRzJmPzgZBF8wUY7+ejPDpC6w96U/FkW2/7dg1hSvqL?=
 =?us-ascii?Q?Xn9aiQqpkEaLyOHdP3TPM+UCvsbvLfkOfbI7fC8migeHeS1GpwPx6k2NJEis?=
 =?us-ascii?Q?MSevOjWnx2LNcPUB6IypbJzVRNa+iQMmgJw/0z4dKYz6KjxayqoFSg5AWraa?=
 =?us-ascii?Q?xM1M9OF13A55HfSDJpi9P3uYZq1u5HBk1lezOw9y++OcvveQSvE4TE1YxfOF?=
 =?us-ascii?Q?uqNUBPTJzJAoba/Z0c3xmgRdxPefOsf7PnkEi5FwRUqrKAbZG8oxFKA87P9M?=
 =?us-ascii?Q?p/dcr6jjsBKw+Ea/39G9O2yEvL2kqBEH5kDqN/gEYW1gTYIJujTqS+nUHPW9?=
 =?us-ascii?Q?3qJVvM6VPpREwXK9/Gdv7Pw/etAIVlyw2UP+/b9L2VdSs0LTkgDwZz4pL/9w?=
 =?us-ascii?Q?61k1/+RpxrbpgdMUF7sQE6IkNtgenBXv+4gGfBudegZAacMz5krp1HAO4CwE?=
 =?us-ascii?Q?i6duTeWNM1V+XDFskK/g6CahBaoF45cgkiFncH4DQKObLMLmQhJAldwIG/DN?=
 =?us-ascii?Q?nQRBtwtN8h6MlsFRcx9gRq3BVbPTxM2yYapAKySSWPtomABJhSy79q9YWZdW?=
 =?us-ascii?Q?mfwhffinZa2hWabKZb83tbHrVrfUsQ1U+/2M2RyiW0fWguqhA7LEVls4KABR?=
 =?us-ascii?Q?m9X0DSOCY4UaAqLHVFCsaeoh+bwyIeycFQGvdwinXwV59OmUHDXAbya8RpiM?=
 =?us-ascii?Q?YnNdt6x2fmE2WACMdJM5c54AEeZkdqZZ20G4eCUWtS7sdpUwk+ICAG4R46xC?=
 =?us-ascii?Q?Fl5j//L+2k2fixgbfKdFPTi1xtOcnvJEWHDP/xiW9z20JigG+KJnRvmurGi6?=
 =?us-ascii?Q?uWoH+0wM7tZWWJMOUGSbMv/xZrwo/FrEatuJr/vvzU7lwAi0LlSmwm3CeGIf?=
 =?us-ascii?Q?xWpr732DVPl2qd4tvl0=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2025 15:35:12.5891
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 781c2e64-1561-4985-cd86-08de18931526
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5822

Commit f1cd6cb24b6b ("dm ima: add a warning in dm_init if duplicate ima
events are not measured") added a warning message if CONFIG_IMA is
enabled but CONFIG_IMA_DISABLE_HTABLE is not to inform users. When
enabling CONFIG_IMA, CONFIG_IMA_DISABLE_HTABLE is disabled by default
and so warning is seen. Therefore, it seems more appropriate to make
this an INFO level message than warning. If this truly is a warning,
then maybe CONFIG_IMA_DISABLE_HTABLE should default to y if CONFIG_IMA
is enabled.

Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
---
We have some tests that check for kernel warnings and whenever we
stumbled across a new warning we see if there is a way to fix it.
For this one it seems a bit odd to always warn for something that
defaults to disabled. If necessary we can ignore it, but I wanted
to see if this would be acceptable first.

 drivers/md/dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index bff3ab4a3bd8..557f3f52edf4 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -272,7 +272,7 @@ static int __init dm_init(void)
 	int r, i;
 
 #if (IS_ENABLED(CONFIG_IMA) && !IS_ENABLED(CONFIG_IMA_DISABLE_HTABLE))
-	DMWARN("CONFIG_IMA_DISABLE_HTABLE is disabled."
+	DMINFO("CONFIG_IMA_DISABLE_HTABLE is disabled."
 	       " Duplicate IMA measurements will not be recorded in the IMA log.");
 #endif
 
-- 
2.43.0

