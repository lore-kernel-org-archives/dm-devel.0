Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2070.outbound.protection.outlook.com [40.107.255.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610578C1E
	for <dm-devel@lists.linux.dev>; Thu, 16 May 2024 04:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.255.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715832188; cv=fail; b=AkMfAjjRm1P76nNHyeu1jRixG2RzcZIgqIWpf5HKVPMALpFIxmTqekHQJiqLwPlrbyEG1Z8FeyncvgYtcDhcE9pJsbBhTHyGEJx9drb6NM4iVBnPPNeOmk38IqagfdCNs5uoDSCuTok3vrKlSmPldDxFVfk5zLl9dHjdCnCSFM0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715832188; c=relaxed/simple;
	bh=Dd2Ne+wYYQlf67SHMr3G51DSNztSqYbRu48pXFAFIJc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=olk0BiMYsCvGLe/5NweMDT3MVXeJygvvzCkJkQucU09d75DOrs+RnbW93cFkDVBI0IRGi0gvmOy+tuiN2cAF32Ioh59pvbWL3FXFXwO4jZoGILZZQ+pi3yyWZaT9SFA7b0YNMpcsKKNBDOVZoheUIVxhuWd/oI9IRpzy0+gWYHQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=hR8dt4rq; arc=fail smtp.client-ip=40.107.255.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="hR8dt4rq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EY9Wac2DlK4bA/i30wmWrtcjkeSLXkLbt/c2rsE27CL4pQzhgo5fg2h6e/C9b7FU0Kx8dIWkCyemGLWmtzQWNX3eIva0QvftNhgavsVnXD8TAa4lRhfb2j96u8FsQF8e0Y6z5l3CEqh6+Q2WSxwth9hafDRdD1wrCHch2VnBgvZd6UocZ1fW6OFpXUtXbIAZ8y89qyXal3F5FktgWTg0oLmKnbbIrmy13LKu37CjO1D0t5q0maufSdXAhbE74zNcm5oH3i6Gj0/1sdoMgG6CEDtuV64pD/hugVc1giFX7zBz/64v13U4K9K+sEOuZkh50ufrJpFsFgA/Ivy1hCELtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GJNf9BhDEBQw+QBjmIK43ZXJQ02KyxkOt212RsPDMms=;
 b=acDqjHsscYdRgRS1+k6rxHL6NLOBClreSxfZ9sVnRiHr5qCJLLsG0+AjgQfUiVmeyzBHAHAYh3cpwWcrgPKDKsyR5sz7LMYteC1YEzpEmW7+JgNTB7rPQyprIwXbWjbvUIaRoP/BtSBdvNOgvhtqSfKdAv9EtIwAwpRGBBmmz1k4HGhN3GQXFe3sLiKSudpUvs4mFLjD3ZlHMktROAUmPCbAgo8tNgOQmkpBb+4rRN8CMcjc9xdh5tx35Fwsi5ky1Zr1oa4ZAJlncDykTq2nPRN3NnhkICBT+d0qLD9KhAkrstv0K/oYYvc7eFVHiA9JcSBx4Dy5CYPTi3hkKFdkfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GJNf9BhDEBQw+QBjmIK43ZXJQ02KyxkOt212RsPDMms=;
 b=hR8dt4rqFahSat3A5hztYWEOH5uCwShoDEzwaN1ZUKZD1kNjI0JjBX9yj93brWW+epwezD28adqKpJo5qamiIBwFr5evnihCl4A4gyHcGCjcdziXpnd2MKz5GpS9STjMHBp36uAxX09QGpZaQOnYrL77KVaaQeRLK4tKP5CV0Abqs5VQ/85jc5NhMtY3GDfg8W6oUJbCPQaKYIYf99NonJRytx8HQl9yVGNCqk4EeskqQqysOAsxa8oG0fbEdlE7UAUPNC94QKiRdswrn2128O39UXU5Fb3UmGmCmyx1D42iezBs2EGtawMwEmE3k3KQ8Rf5Jp1BrokCh6EtiVfsig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com (2603:1096:400:42a::11)
 by TYZPR06MB6807.apcprd06.prod.outlook.com (2603:1096:405:1c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Thu, 16 May
 2024 04:03:02 +0000
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee]) by TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee%3]) with mapi id 15.20.7587.025; Thu, 16 May 2024
 04:03:02 +0000
From: Yang Yang <yang.yang@vivo.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Yang Yang <yang.yang@vivo.com>
Subject: [PATCH v3 2/5] dm: add __send_empty_flush_bios() helper
Date: Thu, 16 May 2024 12:02:31 +0800
Message-Id: <20240516040235.115651-3-yang.yang@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240516040235.115651-1-yang.yang@vivo.com>
References: <20240516040235.115651-1-yang.yang@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0017.jpnprd01.prod.outlook.com
 (2603:1096:400:a9::22) To TYSPR06MB6411.apcprd06.prod.outlook.com
 (2603:1096:400:42a::11)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYSPR06MB6411:EE_|TYZPR06MB6807:EE_
X-MS-Office365-Filtering-Correlation-Id: 9af02178-02fe-423d-0bbe-08dc755d152b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|52116005|366007|376005|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HRy0chjtiArK8X0jhwlQ2a6K+uvXvVzlKMbG9GzI7BZWe74hEBJGZGbR8Bcn?=
 =?us-ascii?Q?HVIUxkFGRh8HgIyrHo38MGDXWQE3UmVmhg5t0IKMGtbq36r7/CZ121bLu/Cu?=
 =?us-ascii?Q?UOZIlgEt6SscB6oO7s070pH0LCdBnFu644UuPOEJ2BG13Rc7oY7ZE+I86Tf3?=
 =?us-ascii?Q?QfS5N4oOmIhrYfr7TUtQyphIge81dTbJ57RMSgYhkTQNBiRr6b1B7QvwSzeP?=
 =?us-ascii?Q?wHlXjp4yTQLlscy5oe9H0lVOT9XWsMcHlkcWKt/JdSbQE731Fc6YgteulBPs?=
 =?us-ascii?Q?DCm2/b8pMx6ISJXgAGLv95aVy9/mc6X2Q8+cpzyCQlgm3X8VksrW5xhrFOrY?=
 =?us-ascii?Q?qvqXr2omwhtOix+cUJU/edzrIZLJo1D9iul3LMpXfCezlLInPwNNT08PoUAb?=
 =?us-ascii?Q?XVaXV7l3ALEMPGFWhwg+D1huLzKtymJtdkjT/Q5xlWwdEKTKRNikbg0+d99R?=
 =?us-ascii?Q?1JRfUy5bQTeCDGAVafIrTZjhONPNWkiIdCQtrsrIylyMYaxdaoylbfrxdDRc?=
 =?us-ascii?Q?f7kFZr5rSk2iCzeznbs85uGO+fTGFOm4Bv9OpEQnx9S9If3DFugs1m4+Yez1?=
 =?us-ascii?Q?kd4x/gu4cRe6e3OH1caBOBFGM8jpsz/e4UZjXKjUjcyF6/z3NKubGveTnAFQ?=
 =?us-ascii?Q?JQufOe7Rg02prRVOEcmtyzte0VIFtoY7h+ReuYu1uF12rzATiefuOVS3efiB?=
 =?us-ascii?Q?9fAhNvcENpHIR1dslW8cDEwpKdNWXbZccCRrWxJfMvdttMLNl1sDF+PJCJqJ?=
 =?us-ascii?Q?hJHLu6bdiEFnVzjvG4xvuW6qsj1VYe7gyEPYxjYblWcCkl0bzKaeEo4792ol?=
 =?us-ascii?Q?7XyzfMZJd33r1mEIDLCMxoN7CL1ZbDHJ4crqhqNj0mSuu4hVpOJBb7t4h429?=
 =?us-ascii?Q?5IeSUwSKlWI06VaEQvwqWTzxduYt6pkD6YfsS7YdMoWy/tquNBeumCJgNtYp?=
 =?us-ascii?Q?om3fJfFkjxDs/QvLSD7A2BB/pgV2+mo8YRx+uXS/XG66WKoXosFSF7+W+gv0?=
 =?us-ascii?Q?aGZPl8J+GzebeEj+WIpI31BtTmmZrjxpee2pEV27/xfwqjKsglhM3ouePlGl?=
 =?us-ascii?Q?H3OwMRHU20nozHeAxAcgo16H18EYm9xCvB8jTuNccoPD/Zv7q61ns22zCQXD?=
 =?us-ascii?Q?fxFoAf5Ve44GVvz+fcpY2kksttH6/rpHkEgKQnY46HQ667I0rJStNiF1euji?=
 =?us-ascii?Q?kf8iuJ7aJRxssLob0jTDh8HsLApksOy2lTx+UO9kuIADtBem4hc4+5tL/MNq?=
 =?us-ascii?Q?eKr4h692yViMU9L9lH3o5cx+DPRypft1gIUiLBhET//NgJGk6YAQ+2oPk4zk?=
 =?us-ascii?Q?mSGg3/B1+rn5/1Gx1Q1brFtbMGGzqgoa/cuxv35qWH06YA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR06MB6411.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(52116005)(366007)(376005)(38350700005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tmoC+OPnjyknlQ+qsjgJVYsGjTAxdXJF52nwIm79Fu6P65cJ7Duwookp1LOX?=
 =?us-ascii?Q?bxDOvvsEylslLplxeTfd/ul0ChG+OAaUTkCiHilIMpby1ux5qwK7jLasPyA6?=
 =?us-ascii?Q?GMmexPqajZVk78Bp0b+wsVMIfkjaiksrQMq5sktjTsV6tOJI867wT6wrOf8e?=
 =?us-ascii?Q?CPKpTnGS0PCIt4PDFgDELTI+9s3u6f3wrdcgNAOUbexdeweQMzcWGz2cg7zI?=
 =?us-ascii?Q?rNyc21rpvmEAcCNZ/jzUAN8MhPaJAzn6WaA2VB8anp+G1gJhIIei8un25Qi5?=
 =?us-ascii?Q?I9IEOy3KCqt1TXGb/+PlT9VHHIll/4lE8X8pngY8swtmKNohk8H5qNhvd4zO?=
 =?us-ascii?Q?m8gVF9isGAs9WXqlwL9eFg5M/ftQBOGV2xw+JJ8PplIQy2Asu9uWuLOGr4or?=
 =?us-ascii?Q?A97j9COdnJ85lINcnRfDh/JtXggc3hE9jz/PPmSXypyhgkq+OSWSwEBOfFRv?=
 =?us-ascii?Q?2SPhM2bGTWlRsAixgi90E/S9bTlipVLBzrCzgtO3Epcp70IG3eqkndQzZUMY?=
 =?us-ascii?Q?h9SLLm7ScSuK5k9KP6CQyMP6Bp8UoBXYv8DCg5wmLccpaIAw6A5+L2e/WK/s?=
 =?us-ascii?Q?+d8Bms4+wMR8cius+sW/Pp6ITI6zRo5M21c4Oce/s8qJqm0usDzFaKFs1MxS?=
 =?us-ascii?Q?/MwXSmcC5EmBeZx9m40OPkuewXkkMrVIe+3xu8rg0+Nsb2z7BhnRqkILEcp3?=
 =?us-ascii?Q?tWymHAeRWKnJuspEJ7ZXdERzYxOGggSm6T9GFrwlIK3NaLRurK/lpvYWCfLf?=
 =?us-ascii?Q?UdbW3C4ExmLs28RKMOJA3nNXuXEPJHJmJ4p0xXFzHMihiakZyTQhFJNNwf+s?=
 =?us-ascii?Q?J6J3UxpRm7jyTOUsvbddbKFCykIjBSUR1BtBmExS1sKbPiIUEhouy5cdQWPs?=
 =?us-ascii?Q?i3EuT5xn2tqAhNcEk9v4cFL0D6bsGYBCez4u6+AkxqctdO9bmJAJCwVbWgQX?=
 =?us-ascii?Q?H3FlCETIaZC9H8rJovGqAxdwYQtdR4W69E7d8opdMLiulYeoZeKNA0tz+7MI?=
 =?us-ascii?Q?yW5rXq3pVSQTw2WfECMo1w+wPb2UJ8QJRd2TbYV5svLsj+ieug00juyZYZsh?=
 =?us-ascii?Q?XvBPTVpYl1G9GM6uNDCRObZCiaFE97GeGwqsjg6ciUHfUjo/c60IQSPnA+2Q?=
 =?us-ascii?Q?u8g0X5CGs5uTMtt6bCJ0lpu8hZ52hhNqpwePfFuqvFaBOHXfwnT9hM0bSMli?=
 =?us-ascii?Q?+96YX/YQMUxCa9U3RnydKJd86Qp9q16gf28Gy7ajZELQjtQkXzFb0TILf/P1?=
 =?us-ascii?Q?2I0n+igeUsNv9NIZEYQqNjxeJrE7PfMKNsMWbt7/0HtOQL2DvZ6g+y4q0+CQ?=
 =?us-ascii?Q?id3LrU0gR0cJ4ylxJDPfuo/mZmTjZu5eCNgPxlgpVp9sGgZ6T2DPS9GMjICD?=
 =?us-ascii?Q?Ymt6GzdqLW2Q2vi6bMpg+vVXglT4XSMi5R8Nq6cuDb45IaahVg7DQ1rtvzro?=
 =?us-ascii?Q?qRe05TIAT/Qtpes5Kvv3pYHlivQ3/gNg0ob4y4rc0HHEHPLKudOOON7rEdP7?=
 =?us-ascii?Q?H8e2KPsZX/PDfGSKq1UljDVDwPedi2ensYD3VbmzciDBNA9MMt1+OBL2PgcX?=
 =?us-ascii?Q?NKIdeiPpMVzDnDC3HtWx/P5Ll6ClhAGa6c1yGxx2?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9af02178-02fe-423d-0bbe-08dc755d152b
X-MS-Exchange-CrossTenant-AuthSource: TYSPR06MB6411.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 04:03:02.8870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OvFOv1Wg3dEJcN7P/JnRcB2C5VLfYXA6dUr/72BT7Dlkz7BLVdEml0mrny6fSflkwY01a5sMR09lVkvGR44Xqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6807

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

