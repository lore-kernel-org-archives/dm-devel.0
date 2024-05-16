Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2070.outbound.protection.outlook.com [40.107.255.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B821D2AF19
	for <dm-devel@lists.linux.dev>; Thu, 16 May 2024 04:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.255.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715832192; cv=fail; b=phdDUbbpHE/GigHN7QZgo599p8W21lUEcoxZ6RyE5tcJLrXCOrLtEmkT7Ln5/NtIeeXgiMyp66uHeiEJ2wJYYmakvoaRtSrivq7UDz1sytAN02QDs2Yqv2JCKScezKsW1qui1a8UYC0107FGKkA0mKLVUwOOlc+MpgIH3SRQUhs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715832192; c=relaxed/simple;
	bh=Ka0RlUPOcraRrZGtj2xqynrRqvKUIqfl5gHglLt+BvI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nRVT59XnprpI4j0IUa1JwM9HjpW26UZeaWnRs9fkeNJoNIA/ywLJMX0c0UX7eRO6dx89Md281qVrciEDI2wH8g7IDscj5JOZw/saRx7jm4i+TB35HWlUp56MihZaW/kmrfFAb8QvaWTr89ZDXlLZ1c//XPNAyCk9G0dlBQnJxSE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=V1fMd5TB; arc=fail smtp.client-ip=40.107.255.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="V1fMd5TB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IYHn73MYgEBPDnqEBrCrQVe4wIXYTxZoMDb0iIX55SL7SxtLp3XYlutLF/Ro/hw0GM3TOK9LGt9ByJuLXh3cdS5EcltQwAsiN1gIlWa8yR7q86xUQbopK0BLRcfKXSE0W22O5JjAouukSvOeg4zpKVUJCe1M1nKZ+0wcgsogaxGvgNfR8EC4r1RUzsxy1fXZi6YLMfwnNTGhOVIOkRdeQ7aMg4olHMZmP9v+2x7DHfg6k3Kv9aK3/vjy5MCbz7AKy5rJbiomXiSfeSvl8Hx4WDaj7gbN9gdmo8QU8cbiCrKO8lgcPch6rJLIdn5RrqeNGrxMrytxU46x/IGGynEKag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IGw8QMlOkK53XoUQo8KmpkoyGxRrVd+a4gf6PImb2ko=;
 b=nKs5WdZzwkomYPS0Mul/DmPZJII3hnGM5ZYTHyiG7XSKo2pvF/A7MhDXznMELys5IscoPka3Q7k16vCDdPALLCPgRL21FXTs96gHzm+P0oua/tgGWSPDpO50utATtJRlCRd1VQAaiOYcVy7a5YBhfjc2Vpn1hq761zpvIX9/aCFHO5GPN2/9QKcKTewAJ8ATXfrHAXxahnOwiZjNfbvrwpqzdy+xSTuaDQHP0wlURfOfOBHUk/DPQi7xAMeXZPDiNm7bsCYpyeLuJRRRMUPxsib5d5qxtn6kOI8h/MGFn6KIB6fMLvJfJw4q6y6oqrhPn5lK/ooCNYF/T6lvRbvBIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IGw8QMlOkK53XoUQo8KmpkoyGxRrVd+a4gf6PImb2ko=;
 b=V1fMd5TBeEERok9k7hFMGtZlL5Q5clxT2+WMQzHnpzxvM3viuUWvMZHjSAMmD5AxLR9PN0W7gBy8Jpv12enFR9xWU1SRT12inhA/hpxqYtxCnVe7yTEl3bAuzJcoX6/sUAECQlk/D8MEAYJ7lXcyu5N0NzaOL1u7RWxZzVjONiMbasEdOSsTJV3JVcADwmgs30XQgbU/pEcsgV+GIPT289uM+4DxPCWyNwy3oNpuMzqCN/yMZZTK1x0yngvAC20NspaDdKfX3WqsEJxpD68iIKTdHdagWrmCZHzTXyInxFDNv0SHuCouWMubdgoTnZ1wRhIgThkQnoazyLn+hI9lTA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com (2603:1096:400:42a::11)
 by TYZPR06MB6807.apcprd06.prod.outlook.com (2603:1096:405:1c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Thu, 16 May
 2024 04:03:08 +0000
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee]) by TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee%3]) with mapi id 15.20.7587.025; Thu, 16 May 2024
 04:03:08 +0000
From: Yang Yang <yang.yang@vivo.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Yang Yang <yang.yang@vivo.com>
Subject: [PATCH v3 4/5] dm: Avoid sending redundant empty flush bios to the same block device
Date: Thu, 16 May 2024 12:02:33 +0800
Message-Id: <20240516040235.115651-5-yang.yang@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: b89b3dc9-ed10-43ab-ca0b-08dc755d1832
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|52116005|366007|376005|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yhv6CWBVdzL/jByVitzlQRNMXcz1kNbzO0OyhF5osZzTGvZNAtSjKrwguXAn?=
 =?us-ascii?Q?c19s04j9FGNY2GZQ4t2kQU8Qii1y65EwPxwtmr7YZDzD38Elnyq2tXcTvrd+?=
 =?us-ascii?Q?9zDMMyYN5V5aj6kcFzrAnWQUwYX0skPrM/TUvZuceMLbxjsDI+peiBGXOAVa?=
 =?us-ascii?Q?6TGgQIoRimaqU1ZYWf3Zqs66b7wZhwtyLPWiRJmDbB1wpQ/4u/uWOFt7IpK0?=
 =?us-ascii?Q?WnDAHnhXH+R8m6+Oy3BJLfkoBo4fEO97qMab6r60TRzSmRvRvo+We3dq2J61?=
 =?us-ascii?Q?b8fFjVb3lz0cwitQphhIefPGfTXt44TD4B8RF/edM0eUJqlneB3ikWBFkfDc?=
 =?us-ascii?Q?cevMhNlHPujv0yrGbxZhbQY9ZqVjPN2XlvRDRM4KFoV4wVgfLjUobJROqIDx?=
 =?us-ascii?Q?mdWIcRdoRw5hg+dyWUhLwyfBCxn+YKpM3qLY9KV2OH05CXGLiLjod/65Ln9B?=
 =?us-ascii?Q?4Uj60mcuH+G0mxIC7qVI+kM7HRly4zu/cFNqxOSwbxNXjmCty0dw7kvi+RtC?=
 =?us-ascii?Q?fjdJNB2Bm2dHWGoVbumP6L/BkWPiqoUj1z3FNx62jDYRL7558g4PFFHiGPeo?=
 =?us-ascii?Q?tCPWOA5J7HFgj/qoIqIZB7sFmH7pIZVIUrZvRrmMrRq98hz0VsHbV6dFJ/Wc?=
 =?us-ascii?Q?QFSF5GdkzgLaDJuocSb1PedkC60SiO6vDTWa3N0Q+6zWFt0xDiTJVNE+sgbj?=
 =?us-ascii?Q?0usiTZzSkZDlbZnxQs63VAVzl+RGnEGO7o0+mAv6I5q5cSYWWdkQ1WRWaJDW?=
 =?us-ascii?Q?9GkFs4t1fqxDSWVLD0qj1pOJ+AibkS5tMrDlOGabMHeeaLuNbr9OwO1fjctN?=
 =?us-ascii?Q?+pPgVxJHa3zeuZwaebclJRKjcp/CQABmRt9DXkEsxFkjZPLZtdae2SP6K89d?=
 =?us-ascii?Q?sYNLltub5y1+/CXJRAJe9A+Zgpr384AVUk8aaJaOiqe5vLOqQeCXP48QiYhK?=
 =?us-ascii?Q?3fjSM1hr3H95PyqCVqWllfRwiYkExPEKEN1HwYbxrHlMQbVG9lNOhH6exEFn?=
 =?us-ascii?Q?NA9nmQfOillCOoJRYOtqy+IAHaFfe5ZUBEPXwKoP1iJqx9NGwUS7Ql6ChRAk?=
 =?us-ascii?Q?hyYqYZZxOCeC+7Xtfpo6JSX8cXmJFyqrMIK7eVQNAHgbJ2ZnR7ujW3509X8S?=
 =?us-ascii?Q?g6eiXVJP6DXpBrKw93r8JsJdqzuDMTOqYk+v8Ag8g1mckyKI1a+btb3qO1pw?=
 =?us-ascii?Q?O5jagv8E93wcvX2pggJyB1HyWnNyIAx2YIXRv98HvfsMVvf3T/9PE5oBtoq/?=
 =?us-ascii?Q?XxOAghY1fTfLPvW1Rp3aMA03Y+foziT8k4sEY84cyULe0MOBpDIEyd4ZBTTP?=
 =?us-ascii?Q?XfLE5R+C7IfxhYu6HzfIscGanMaQ14+REFm9tJ9nDD0Mfg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR06MB6411.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(52116005)(366007)(376005)(38350700005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C0+vmcGrBrcHUoHV90iGBt6PLFd/qXcECOu7NXB6j1EJEYu0qx6EOYuGBkV2?=
 =?us-ascii?Q?s0H4IyaSsjwtTlYjhwpu06mbxMcVBNkub7FP888fOCJxGGeuJyIOg8nTTB3w?=
 =?us-ascii?Q?h+5Wch8k9mz3yn4kGHRhlSeq1/gL5N/XwEMH6Qj3spJSE2CtrDtk18wHi8Nt?=
 =?us-ascii?Q?R/D1b/LsNFNB1w8iIBL7nfgP8mYdGfEkd2khO93tKgvWijVXxMAClyNwHqXK?=
 =?us-ascii?Q?D07LAr+mYAosLMyB9deRpD9vf3mH++uh/rErvNZgSLLCqJQzhqA65mnFk7XT?=
 =?us-ascii?Q?ChwwxxhLM7iKXr4gAp6HUZ7HNKZM++i6BLr9k2G1NS8mf8mpAtqC2LdgNbF9?=
 =?us-ascii?Q?kOkjTenlIV62zaSJw0sVkbYYtprCFqFvMM7uUAxoPY5bTCghWBhp02JzrTGq?=
 =?us-ascii?Q?bokDi8ak/4sn6kFgj5to+YeOTff7IZu1nJ7mNpvq4f04u4OZN+1lWI1yhKca?=
 =?us-ascii?Q?qDukUZchPLorsIwoaXUmFvnN6CCKzFHs795B3+ZhysE4htwLFQZgqxfilh7j?=
 =?us-ascii?Q?an43kDulxpZNnEJlfIwmpv0f9HLIAZvSC4fgkjLeJCPuF7Y50ovjtIKKu8Mz?=
 =?us-ascii?Q?02PuK9B03dAIOEVU2fAhHFuSgYRny/tUhkyS5qD/4agzAWKzfdq0FRw3WMQZ?=
 =?us-ascii?Q?V0Kw8fuqIMKCqUrShseQJRExEaSzVFpCbM8szHhoC+dO1qdK2r+8r5p7bJDX?=
 =?us-ascii?Q?d/4WV/k/tGcElBsyJWdf7dg5kKB709UbUe+wfYwcieb/N8ZTz5vTFqVpdqYI?=
 =?us-ascii?Q?ECIW7IT3e5RjVU9uo+cEv1Yc25qSwJdAtRMlQyjzDe1xWDKBdXZe4ocVPVzW?=
 =?us-ascii?Q?vL/eZmqFrqugMMjxtOovG6BlMXROiXSPo2opT7aS1bvxMD2vZhrOthfa5bj1?=
 =?us-ascii?Q?/Wepdl46Mnz0tOVSiNB3eVvWLG+k1t5z0LM4KLYX1jh9YZuQeJFB5OLUMHWy?=
 =?us-ascii?Q?pz2nBPQllQPXvvHt8qGAdectxX/Yvlmsa9yOO6vXRSvDSDvHIvNGSVKo5WA0?=
 =?us-ascii?Q?Ip39fQ4Uz1U+z/J5sBmKTPtQ10UWgRr3ncXG/57+HJePUjNZb3vckeuzm5pY?=
 =?us-ascii?Q?6D2WN+xycjT9vw38h/WbmSkyB5KazxeYGwnkzOe6YHfZxdRXBL3ZYjChxIwR?=
 =?us-ascii?Q?eSSB6gncYGnMJX0qw8Gw+BOGGL874WREH7owkK9IuWYOLVtvPt611Uhcvzqp?=
 =?us-ascii?Q?0EwL9HdQ5iaYOmQbzZNqiJybhZZn5mSWbeGW73pitIZp3esIpFzOlbZ3A/cL?=
 =?us-ascii?Q?x/vQ1YDxr7xsH3tqH9/dDUhbddrZwJjU8OcWUxK9J7hjTlI/QliTCpcITkyH?=
 =?us-ascii?Q?h4llBZZgPIAUGCFJFSjxqLU8C8xw+2UEbWwQj0Yf9tITqf3hYXehKgHKjPVo?=
 =?us-ascii?Q?1VJsbssgPnUAlHUrHtCjM2EG1aSDYTng/nim8Dqn2CoWcP2t2akk4sxzTa0b?=
 =?us-ascii?Q?mcEPnAGPMkOAdcFsYC9EfS6djb+zUpvw5/h+z4tk7uJyK92bnLuZEicajkIQ?=
 =?us-ascii?Q?StnEqxoXqtkwmqBNj1cjp+yGz/2J9k5LIRRImGhDvG5xkftDZTKLoq0Da47X?=
 =?us-ascii?Q?RD6r3ySHocoJoFRYh8Q/LcIF+j+ztEvJrBPm2Yky?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b89b3dc9-ed10-43ab-ca0b-08dc755d1832
X-MS-Exchange-CrossTenant-AuthSource: TYSPR06MB6411.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 04:03:07.9543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CXCPGhp6pFtCw+jrl1s5RCiGxcrIuvMBU+KnfJB3rg9bisfFXPE3lACIbhgpk799qQI+91zmPvclQc7g/Dk1cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6807

If the num_targets is greater than the number of dm_devs in the
dm_table's devices list, __send_empty_flush() might invoke
__send_duplicate_bios() multiple times for the same block device.
This could lead to a substantial decrease in performance when
num_targets significantly exceeds the number of dm_devs.
This patch ensure that __send_duplicate_bios() is only called once
for each dm_dev.

Signed-off-by: Yang Yang <yang.yang@vivo.com>
---
 drivers/md/dm.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 25215b93c3cf..9dd0f5c97028 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1561,6 +1561,7 @@ static void __send_empty_flush(struct clone_info *ci)
 {
 	struct dm_table *t = ci->map;
 	struct bio flush_bio;
+	struct dm_dev_internal *dd;
 
 	/*
 	 * Use an on-stack bio for this, it's safe since we don't
@@ -1574,10 +1575,18 @@ static void __send_empty_flush(struct clone_info *ci)
 	ci->sector_count = 0;
 	ci->io->tio.clone.bi_iter.bi_size = 0;
 
-	for (unsigned int i = 0; i < t->num_targets; i++) {
-		struct dm_target *ti = dm_table_get_target(t, i);
+	if (!t->flush_pass_around) {
+		for (unsigned int i = 0; i < t->num_targets; i++) {
+			struct dm_target *ti = dm_table_get_target(t, i);
+			__send_empty_flush_bios(t, ti, ci);
+		}
+	} else {
+		down_read(&t->devices_lock);
+
+		list_for_each_entry(dd, dm_table_get_devices(t), list)
+			__send_empty_flush_bios(t, dd->dm_dev->ti, ci);
 
-		__send_empty_flush_bios(t, ti, ci);
+		up_read(&t->devices_lock);
 	}
 
 	/*
-- 
2.34.1

