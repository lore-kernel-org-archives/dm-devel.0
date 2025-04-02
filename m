Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2082.outbound.protection.outlook.com [40.107.255.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9277A1DE2B4
	for <dm-devel@lists.linux.dev>; Wed,  2 Apr 2025 07:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.255.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743577821; cv=fail; b=LiviT4K3o9YmNUqDS74Ur8mGkBkERwz++bQG2MmPLspPNvo9TPolgMReLV9AKdmph31GCm3WA1k+2xr3M4JL0m74H7xraWfCeCPVdX3PCYvSqEBlcSUab7+cSbpCXq4B/tPn0SWH3PXq0k3Iy84QpjvZDpxym+bwPXzTKKszprM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743577821; c=relaxed/simple;
	bh=Qg0PJs7k7m36y4P8klETOEuw/exta9b8DW1f1OMtZd4=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=msWEw4D5OxD/OY2oRwUDni5u4MwryWpatHOW+A98qNLeg6RdxPxTNsn5KhbHjDMLppIqmxI4mUQAYR6kJclV58X8gma5LNzJJmfFLvPFjvbno+AnDcT9xGxzWn0FOIywnhyXfk6cqirPYNXomMXGMQSmlVtXxUDhrwArEiAVxrw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=m7SjGXf5; arc=fail smtp.client-ip=40.107.255.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="m7SjGXf5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CLemXyPtM8xEqoU09iOo+SMyPtxpKH8Yme/EGPaK/EJKnw/g0WeG5JuHas3AkWHpRCMFXNnhVFwRCNqMLBcRXp3NjA8sipmylDzgqhO965mhPEIZv4yBR6bej8+O70u0a/0J/G/qVbpf278S6sM7PMgrn/VzKRQwQGnBD1GPKiWmabX0cNYaAGZdMc8hZxFRwHDwM4oc9/nu5zx7dbkmvT+D7AUFFr2lRW93nJncvgJJxyeNpAL6Fo3sX/IVvwq1v76Sf38gSUVoTJ1xjlCtQl9wjMgIlHPU8O/q71FltBgIvpjKPV8TogSjY+rCeup/Im7EzoWVixYxBnitnDtYPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bbCcIvbE+4K6q+FZdSm8zSb3yj19WuI56XzbGpdEOzQ=;
 b=pVdKO9gz8vT2WsjJ8TWmP2WoP2yhIAZlSkfQUCfXg6LgBKhWgCi+u9leBTqa8lAbIHHcDDs59S6StvNNUSCbVpltczXTK1i70gxwh+B5U4Qvl5ASH0MoQGyGyKPcYGAt0mLUMHerJhC+UKdVuXqQYHUlOr0doMe9t1EsOb/fK1KacWUXv1CvkKNCMQfAo4eQlgLqmAyHzaOWWpxjKUrGOBMhNUzAJtmYpQ+cM4IUpbStZqAvWiPstVp12SyzNfcF3A9DkApeCLYHYUt7NGGQbYKOyDpbpoZe579cc1kc1HVam3u5GS1IPkcWjIA4EI1AfUhYKXnhtvJSUW60R87XDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bbCcIvbE+4K6q+FZdSm8zSb3yj19WuI56XzbGpdEOzQ=;
 b=m7SjGXf5ygMcsUxloQ9qu9hvflfWWEwQyTvhT2n7FUpOfHTdW2kNso3CSFNs/4JBL1VaG+0ju+RinTA76zQwkSQ9+mQJ6+taTNtn44bKsG5KJrCRL7a91/HwzFXL2Yo4Og4YAJ5v4Lyr0KFH1fKnNs75Z2FUCV5H2nZVpkKROCA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by TY0PR02MB6127.apcprd02.prod.outlook.com (2603:1096:400:265::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.20; Wed, 2 Apr
 2025 07:10:15 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%5]) with mapi id 15.20.8606.019; Wed, 2 Apr 2025
 07:10:15 +0000
From: LongPing Wei <weilongping@oppo.com>
To: snitzer@kernel.org,
	mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	guoweichao@oppo.com,
	ebiggers@kernel.org,
	bvanassche@acm.org,
	LongPing Wei <weilongping@oppo.com>
Subject: [PATCH 1/2] dm-bufio: improve the performance of __dm_bufio_prefetch
Date: Wed,  2 Apr 2025 15:09:34 +0800
Message-Id: <20250402070934.2387587-1-weilongping@oppo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0077.apcprd02.prod.outlook.com
 (2603:1096:4:90::17) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|TY0PR02MB6127:EE_
X-MS-Office365-Filtering-Correlation-Id: a099973f-afaf-4d30-0d60-08dd71b56a9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|366016|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EU3iclXih5oQ4WnnH26bofqP/p95d2M8hOb8O6xUyKMPRMkkJroHqJpWGv5Z?=
 =?us-ascii?Q?6ClvH5NjuQPlwqFnZkunIF/pr/9A5giuH9Png4jQFaRv2Qxd9uq+3EyNkIwJ?=
 =?us-ascii?Q?luGimboHin82kDbk5O2PBphS6Nob8EkezHHr3MALyeDrLRGQTdFfyz5xaJyl?=
 =?us-ascii?Q?BOd1Wwb6vrgbb9iTNl0PEksG8aZSdMCuJ9xbhS9QCrrAK1pIEOBMpbeWWvEJ?=
 =?us-ascii?Q?1VdcL49kHL3rF2i7pnUApfEvJVFnXGVbmaT6/7L3SH3uNBJB/SrhtZEe3bT7?=
 =?us-ascii?Q?mvb1uWV3So+QgQMQjUNnpnH36vfZbesmCpLWFW0kc6au/eNhGWqxJBMoQZzm?=
 =?us-ascii?Q?jrYAoobdH/2+uzrOBiU9DZofDaIFdyh9LUEN/tDw2PRwLxpUeKyDWoKGWvB7?=
 =?us-ascii?Q?+XAqUOUA+Dl8kGTmXJUEpsrFDsv2qhy8hOi9m4SyO54l0t0Z2vymxcjY6HmH?=
 =?us-ascii?Q?Y+HuUi2sFZ8Ml/NS0G0oWZgmZExk5vBJkjKX1yWSbAC7lcnT6oCUSfPzOBJr?=
 =?us-ascii?Q?anW7GLRTd1bGy00XDZ2zw/jLYTEHSV0b/cqsxIyaSP9rpSe6iqlFXpg5mb3q?=
 =?us-ascii?Q?h21IBsYQewSFt4rYezJoBUIopqborrrQySNVH3Y8EGDPBH013KH58U/tksQl?=
 =?us-ascii?Q?fYWrq0V3i1gjonkkmEZ1s3GzrcLEofz01Mhu2Tg7qBzitK//XYoEBwW0Jkgy?=
 =?us-ascii?Q?P499ifTqMEZKcuniFB+FPDXdXzAqHvMe9VdwO7mmGHKILYZzeYj89tNYxSmC?=
 =?us-ascii?Q?boUN8j3+Jc3qVB82GxNfW+HAEM+Coezxq/gIlrWEhmIXoLow2P2Y2zhrp/AU?=
 =?us-ascii?Q?7n8NhlAQlZX1CfFlDg09WfbpHVazVrrS43XyyU9pExqvwwJidd+nI6W45+8Z?=
 =?us-ascii?Q?lHVo+Y1vY1mmSblVFRaSfzmoyrEBBxlwkPek+r3hDOqb8/fB1E3zTqMjOu8y?=
 =?us-ascii?Q?TQ/vUKCc0AeOPkcB/icg7PEeZlHS7HfLG+a7w24DK1PNndiD/1w6J7IKAIMX?=
 =?us-ascii?Q?nIK/o6SWVnXbnXJU4X12zhW8Lui5Bf7EoekMSSroexq3bEZgJOjkmtywnW4r?=
 =?us-ascii?Q?+lGfcKJuD2BGH/oLWkUS3orAJWnawqXCzKQkLRHpMRUKgmTxXQST29V+g4uG?=
 =?us-ascii?Q?dnUPwhwZOYfMIMGYmPYOPI966mnpnjNV+/bPqq7dLcir787W9WMblJEIeKVc?=
 =?us-ascii?Q?SY01+gTud/YH7zTc2PSu6P6oNONF8zG5of5KUStRuoceXq2/tYEICJbP72+K?=
 =?us-ascii?Q?PXm6xVU6p0zU0hmK+h3oAoN1LK+pNpzVwFC89Nax699kCXH30vCMsLHCT3/8?=
 =?us-ascii?Q?tf01M/uitNuwzof6U7vH1A1KpbKPxTididcjskAwL/NGQ6ATvhe9yp/4BmoK?=
 =?us-ascii?Q?b3cygOk9peqUwRkyET43piz9gkHpFFmDTuGRAQ/4XwC/7VBeorn5Owa64exY?=
 =?us-ascii?Q?X2gj/vrcJx6CtuSHo17O5tJBe5uXywfT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(366016)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/PYimwPAJqMXQqMqs0uRWvFyv7mKmaVNZowyqt6687yGabBU162xGJG2FVzI?=
 =?us-ascii?Q?gVOCTOXm8k/uy8EXC07hANLUUgxcQ2wSnxn0l6H6C9PbGg8Wd+LmRMsz0dgF?=
 =?us-ascii?Q?9hB/UerlYz6CJqbBtpedPFi9Gh2+IUD8nomI7xU+C9cMTT5qLU0qKz9v1DPm?=
 =?us-ascii?Q?BUR5Zp4EE+3LG0PhLHJyBQz7YYRONT6uxQ7yJ+AyFYMTQF+AqDhC3ueDscLF?=
 =?us-ascii?Q?IMRGtqmEgOXigJn9gNt0FyHOJwxTardIV08Meai3m2rDETv2o09lnox81eoD?=
 =?us-ascii?Q?OVOvsdrx5LK6CkAWRGNbGnZEq5wUs0QefaBynFVRFnlxln2axLaSa0gVSDmO?=
 =?us-ascii?Q?3G7njUlMEcUsabKvK0AIGeT18WAHnj0YYYBDtNvg2xN2smcSwG9hHVSFbXc0?=
 =?us-ascii?Q?Od6sp7svQPk8O+wpIzrrnBaN5kXGAhLi6AKCfsPFZPwjPI8NXPstx/Qzpj5p?=
 =?us-ascii?Q?wKQG6JePuZ5DEor8wOpcLrs8LMbQY+7IQfqPrYx7Jt7SYRmE320vZ8V3gVDN?=
 =?us-ascii?Q?3m5XoVTHKTwPOeVeaMR1LBQr9nZuggxfEHOzWOYCA7QLIIus9jp3IBHVNnA1?=
 =?us-ascii?Q?sGoRe4WKfp46oyJ3S+c00fC5O80N8fcbGwPUiLZa8XxZ0UCAFQXjI1foEoYx?=
 =?us-ascii?Q?o7faAo2Hv8epkFceuzDVYR4etYAAmcp9w8W8uYJPVGHvA/F5vNPCoiElYCnB?=
 =?us-ascii?Q?wfVTck9XeGXlT8KzyOJ7mr+7iMr5ObXBCpjdbyjaO2CvHA6iqYCGst99wDYa?=
 =?us-ascii?Q?yONZEQRgcwPEs36+cYTm7ycu97zgrvN3cAR/DSUXSnR8TGg0wv5Rlc4HqP7u?=
 =?us-ascii?Q?TkbmZlsY6rn3Hhnewr8X7gWMCxMc/vef7UbD09dZXfhwBEivdt5DDdRRvT2D?=
 =?us-ascii?Q?gkRHmasSMp3OMH6wZgnQZ3nffUP3po+XRhJbEXEMjOf3zf+TmLPIl4FLfRI6?=
 =?us-ascii?Q?/0AZ/AfmRejtWHknozS2eE57jgJb4SDdNGvDPhg72oqZE35Y9fy4Od9tTz/c?=
 =?us-ascii?Q?l61XLC5Nlg9SrPWGBTXLv/GDdWkyvknsLphb8o41rGbpsbbJHvAwsqfAohzw?=
 =?us-ascii?Q?pXK00HXVX7JuQlx+PqfoxEAajjq5BxDwggpGFm/DuPA1CGkRvyasY6p8mYbC?=
 =?us-ascii?Q?RM91E+Xn5QM/4MuAE4NTrjppF2PlBjl2Coa3kgcDBwT4C6pFl1ThAKLZvMMn?=
 =?us-ascii?Q?YUStDb+7toJJ7Xm1k2Kt2aVTpL1WmxIYkfxSzZog+XQ97+5lrmH4uDcZr5//?=
 =?us-ascii?Q?n6tJXyqdOCSPbqYNbm9nuGmvgGgs0A9TWnvYj0ZSOc1f/PgLdFNK39vvQZlB?=
 =?us-ascii?Q?xw01SNogmAl6zgd41BKIGhJmrQwRVCpSuC6yGO4xk+iNYx5J4/ZIHHIDfnDi?=
 =?us-ascii?Q?ioxvLFCTHCq474FaVDLSQqri2vXm+c3gaqdjc8l7S38gpPJhFi9ms67qRYt5?=
 =?us-ascii?Q?Pbz7t4FL0RKbRXQpdbP7erYVorG7Ol7JI/B5pdoa52gU61bSDp0ioFn+b06m?=
 =?us-ascii?Q?eldbtxxNaWompH0EZKZ9cMlxqeFAYg72wKKO72+z4aumxi8ryiLVw/gTeVsh?=
 =?us-ascii?Q?7LwbuDFGPK2EubG5599WvGfyz3xlDb/QTGSKdorO?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a099973f-afaf-4d30-0d60-08dd71b56a9b
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2025 07:10:15.1580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pUAEJEshOFP26CVYEcgI4nI7fDWd43ugWCaFSA9TXJU6iA21j2XI1aJD6lQKa+dSahdkc5mmzm7vWpMWfF4c7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR02MB6127

1. call blk_flush_plug when cache hit as the address of the subsequent
 bio is no longer contiguous with the previous bio;
2. skip cond_resched when ioprio class is rt;

Signed-off-by: LongPing Wei <weilongping@oppo.com>
---
 drivers/md/dm-bufio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 9c8ed65cd87e..ec8392fbcf5d 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1981,6 +1981,7 @@ static void __dm_bufio_prefetch(struct dm_bufio_client *c,
 			unsigned short ioprio)
 {
 	struct blk_plug plug;
+	unsigned short ioprio_class = IOPRIO_PRIO_CLASS(ioprio);
 
 	LIST_HEAD(write_list);
 
@@ -1997,6 +1998,7 @@ static void __dm_bufio_prefetch(struct dm_bufio_client *c,
 		if (b) {
 			/* already in cache */
 			cache_put_and_wake(c, b);
+			blk_flush_plug(&plug, false);
 			continue;
 		}
 
@@ -2017,7 +2019,8 @@ static void __dm_bufio_prefetch(struct dm_bufio_client *c,
 				submit_io(b, REQ_OP_READ, ioprio, read_endio);
 			dm_bufio_release(b);
 
-			cond_resched();
+			if (ioprio_class != IOPRIO_CLASS_RT)
+				cond_resched();
 
 			if (!n_blocks)
 				goto flush_plug;
-- 
2.34.1

