Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2082.outbound.protection.outlook.com [40.107.117.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C7E450F2
	for <dm-devel@lists.linux.dev>; Thu, 27 Mar 2025 02:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743041923; cv=fail; b=o+EWC6YUigGpMAnvz5s8pvmgrCYiFBd/5wqSmFuQkFwALJN+mQ1Q3DdPRXcGrn9yjFzYT/VBw5c4nr41Ip2/km/EpECsm8Y0uPz+TyVvKU/s3lUPTMMfXfOlUaQoWh2p/TMJXgBLfaAasoinyaO8dW/p8rQV7o4orFXblJI1cPY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743041923; c=relaxed/simple;
	bh=w1eYmEuG9A4cjyPmjYObB2AIB9HjAYaDjY7X9CYE+GA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EJY55U60VJjs5U/mUPjm8VR4pg1IkqFiKRlHbhhcOvl1lZ1pEGIL49+YwWkEgbLiMQb5UiwwkVmDm/EWQxLWqIMNBDBe3JAKfWpXIwH3A1stgE7IPYN0XANB8DmD2R7+gUjiG1fUYSKQFmWJYZFRPYHpymgVxi0kegCsizTrQgc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=Ge7ZedUC; arc=fail smtp.client-ip=40.107.117.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="Ge7ZedUC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GnPF4O4buOSF3NyiXS8yMsd8q6hcgwAofyXDKWKKZZpmgmPNUUD44BDG37l5ACrX01TWyXREb4RFQYjvPBKlmlwF+jeH4Jb/DZyd8v8Ml/XfCMBbSkDYLz3Q8ETN39qKJcQG/3CUM6OE3jQIH27Sbj2Zm2lzNgcQx/nrf3y39SYSxgKGyqO6gwocA9NNP4TfgDfa1+5u5hndZQu9rxGhQSzJHc9l4LlVAzKLzNx+jq+kCB0V6R2RllT5nAA3GLSI3FerXH+q+3OkXKBwSRTNbJ8JO7db1G0GyFFLTu5U0WO8V3/07sG4H2GOKnAaBCFKs2j4WlKvzbf4Dt8PYzXg3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D8O//zd9J/7H18g8ppfnqOFS84HbkeRwERqqf8+BfK4=;
 b=hH1LY+p3kPSMft8am6yPyiWTYBT++USvM2g4ETyGRB1h2qvrPUEK8nanXFTk8FKUcsBbkmIcJGnAc0VGZn+JhN3A6Rh5uWdCRFwBP03A5rcWlVfNAY/C971hJtqcp/QnIpV89i7evk9j44gJvnF7j2oRTZRbehagh34K3iHImJK+P2fsdLAaImeH4SweJjcJgJP7tixSdvcPSCI2Baf+w7cdTd+TSHHps0Iv1gx+aPMobN7yHfSiAzboDVRBOU3VOl2jAVLTV4Pn3QoUKWJOVBUitR95LOpuzM/ZgbjCJZBMqj4oS8oObu/0IWrUpyAo3zmfVpLEhrAcPwojmCiw/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D8O//zd9J/7H18g8ppfnqOFS84HbkeRwERqqf8+BfK4=;
 b=Ge7ZedUCfy6PzC3vj/ZlcA9Tr3rIiI3KLMxC1ghOKEUkYmLO2CPNpc+Rn0UocJbTn4twTcyyKiByAE5KixhUhu9rJ1JjPT2aPWKQC+h5ZOxcUbAlZAmcakaUNmNO+5QAQeRmqMm+zW13dMrmnrzzZ8q5lPALFZTBlqX92qe5UDw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by KL1PR02MB7430.apcprd02.prod.outlook.com (2603:1096:820:117::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.25; Thu, 27 Mar
 2025 02:18:37 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%5]) with mapi id 15.20.8583.023; Thu, 27 Mar 2025
 02:18:37 +0000
From: LongPing Wei <weilongping@oppo.com>
To: snitzer@kernel.org,
	mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	guoweichao@oppo.com,
	ebiggers@kernel.org,
	bvanassche@acm.org,
	LongPing Wei <weilongping@oppo.com>
Subject: [PATCH v3] dm-verity: support block number limits for different ioprio classes
Date: Thu, 27 Mar 2025 10:18:19 +0800
Message-Id: <20250327021819.1623099-1-weilongping@oppo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <052d22b6-2d49-7faf-49f3-742c9b79fc8e@redhat.com>
References: <052d22b6-2d49-7faf-49f3-742c9b79fc8e@redhat.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0081.apcprd02.prod.outlook.com
 (2603:1096:4:90::21) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|KL1PR02MB7430:EE_
X-MS-Office365-Filtering-Correlation-Id: e26a5ab0-d88a-4f99-7f6a-08dd6cd5aebf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|376014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rUimaueFI4bxH/EyRlwvFnuLK01Zvysp/GQNo978kBd341uSo3UYBzgmaUOY?=
 =?us-ascii?Q?nXQd9dfIjZDSvmhVYdyoyItXOy15A7xF58kDjOyoWaSUHBvDY886AZcirHLX?=
 =?us-ascii?Q?IwewGujc0h3JPs6zxxwNvCLXjiaapdMKunW9Sqrgmi2EMwmmfSNMFBhumc8g?=
 =?us-ascii?Q?fXsibbDLisTlVRJsTo2vSOcjdTCyVHCTqQYNGwZCST/LCnWtvYD8xeQuGbAh?=
 =?us-ascii?Q?lJtRoTfv+ClYN0lyHC3QxAGXATgCch34OtENwV4jj+W2Wt8hsOFItmL0BRq9?=
 =?us-ascii?Q?5qobsLjMkbrtOa3zEILrbU2VyJoSQkouwCPB57xGBxjrKGYpeQsL33Dd9jix?=
 =?us-ascii?Q?TZQbWzOgl5qdlNBzpPv24O780K9itKJj/yqGOp54WEYh0GonZkP/sEZPmh4b?=
 =?us-ascii?Q?+SxRSe+C71EkrFFR/biSuDXqcyVc/lndvR1WTJus88P66zjn7/uiOjRGR2/V?=
 =?us-ascii?Q?497bwGErle2UPpM7Pkz5nJ/ly1JPvyyOv5SsyD/Yi9Ei7DTA8Wqz/gOx03oO?=
 =?us-ascii?Q?15s4iS4fHnTeeEufrOXxyterurIi8loWMKsSO2B/uueLdFtjVf4Eozhh7QlH?=
 =?us-ascii?Q?V5O/t6poIsxO0bT7b6brQXvYY4zdHFmXm0lmZeV+ejexUKzOchATUKMXMhMm?=
 =?us-ascii?Q?NYRdI9ZA5by6NFKbXOzv3H+rknfGDG1F6tYzXIXJLSBhQVOwrYF8YSZnfalx?=
 =?us-ascii?Q?ldDxmzBXBgP5uUSKOk8T5l6WXFlq10GWN+bPBgI2nK5k2/AJh0pN5C4poFZF?=
 =?us-ascii?Q?I8KyWV5UD5ohfSpfuTR/Sny4wgY+ToGdmGmqih1Fta9bOG1ClVmNNuiOSj1/?=
 =?us-ascii?Q?hj60U+v8DswodCZfLuweqKU3nkZmSXdhBu/uAaGFWIUK3WccOVcqWXFaPQS8?=
 =?us-ascii?Q?6JQkosCaVWUfiEdUCELTkLyLwnLrxsGTM9kZ7dJr+6TAvYGlwx1jXBjPHRxE?=
 =?us-ascii?Q?PMfAIJPazVSPONMKHoaxjPZEZW04s26ZDYOiWrXySly3TEEQ8smj0EzM3iz1?=
 =?us-ascii?Q?nFDecv/qUFIddkqh+65fXc4vtrj7ESNJRuRX51h2/Jio/tvxLPngxMcHf5CR?=
 =?us-ascii?Q?6yjw7L9KZCHAeIa/rKHRzpSf6TO2PuwhmSvacsr5YSccKgSzi/u+R0AYhbw2?=
 =?us-ascii?Q?aQwwkB/Dc+xEH3EFxUoThGdp/N99ZqEL2/Kq+T1YrvR6mmrHj4usIUeIChCx?=
 =?us-ascii?Q?AxXluV4vGmoGrVa/5Yo2b3+SlEwMlL2yj4mYg/ejAkvw6eq6x4btaKJsI+RO?=
 =?us-ascii?Q?igrDpLT0Ce0Rhch0vWgSrPSUCKiqlkpKgG4dM4sQxQHv9bIHasSAnDnuf2zc?=
 =?us-ascii?Q?2AQBeaeyMyaFnbsuIhyhPYV1Y7DIAV09kYBor95ubQYDRL07vypnqTf6eI9T?=
 =?us-ascii?Q?4jpsDlVItV/gTF0i7Z6pR0VkPikA3tFqqXnb/Ve337/DdsclGbx+sZ5Z61tj?=
 =?us-ascii?Q?k1FSdzAgtNh41un/drVIk7rFGo5ut67E?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(376014)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+0hCL5rgRuCPzqMzhH8lMlCiFeTmjdG0kRhh+l1xS/ocdeFZbe4mM7SPziTv?=
 =?us-ascii?Q?CDw15z/dv+Yt4HC8agNw/OAXjHXFNb9LIPYnf/f/52VWwf3AZqMVmdvmzevz?=
 =?us-ascii?Q?CzChRspo5M3qQWSkQ1i7NPkIxt386Br/9o8pjtnHz5cUx4xvyR0zkQCpP9ss?=
 =?us-ascii?Q?JuPr7RbXda8WBsDsdEP/mlMxWPM0xlNqtMDdneSnCZyhpLNPyuiDbB7ejDYc?=
 =?us-ascii?Q?opWSALY57pUPcbzYe3Pq0Q/vCgUIdq8jtlIq/vLzCeTNlsDghCxR1K8i/Gcx?=
 =?us-ascii?Q?+aBanDEaUYcHfiXdfp/bhhTLp+7oqQadCq/UcqiIuk1kKv4uVymV7TAcKZz2?=
 =?us-ascii?Q?vCgNNY8yAorzk+BH2wheXDT1OVVtsNfijvIr4F98TQmZqcTdui29VQjTwVYC?=
 =?us-ascii?Q?JyU5yM3afT2xvcI1s6admMeICIXpHrR3oHyC6eSeXwPvoVYJRM4OvwPAEKII?=
 =?us-ascii?Q?LvL7kc2iApaPdQAZbIWTvBti+10jEXQXePoPiEdccohLOwVA9J3o/W0Rv7Tt?=
 =?us-ascii?Q?dX04qKqxyNASZwcOy6sYCLfNxO8w5s/MP+f7kX2siu4J254Jag0Noh4yB9Q+?=
 =?us-ascii?Q?OTT3heiIYlHaARepq0ZSyzBJ4PZFKQNv8juruwBNgwgeltc+L/AbdieKom2R?=
 =?us-ascii?Q?BGar7xgQJXZ13Ez+7hww6ZQJQeGizv4H5qdK00HG9v9eBiVrawyvM+q6qsc6?=
 =?us-ascii?Q?/Qu8LBXhXd4t1VZcXInjbU35tq6CjxB0ja7KuyMcLPM3iEmlXLTLuckmCvPP?=
 =?us-ascii?Q?YEfeg+UYWvk7TMkbRnTxqa1zlDdtwl7B4mbkM/GLv1+cSPIVJ+crkFFmqLQ6?=
 =?us-ascii?Q?qeFSPRMwDHZp6zmQH2JGtpmS7JNUZfFZPocUzTCcQDFUE7bUW/pYyZrxQtAl?=
 =?us-ascii?Q?nax6TSY3OzXpXSETucrYVKsEd5QA9mW1AacJh9NLBWbTjOt3QonqKaWhBszA?=
 =?us-ascii?Q?Acx9jpuDe0BACelxwHdwA7Q35jl3hvPiL2RAnOad+fLmx3rzwG+JGuXQakYQ?=
 =?us-ascii?Q?jCd7vTDuuZls4aqACr/sfcAJlUxESHZr5D59t7/kjiAeKZZBNi9Mw/DRSNVg?=
 =?us-ascii?Q?DIrCN0/7CrYtuxLCgx/McmiE+y/JtQGH7OGCy4G2rVge+8wyTj/ePwCSa8S/?=
 =?us-ascii?Q?yvhabcRd20mPkKa+fhBLaibIsaCIL+ZmPz+HCqmzwTAFIGnj/2I3+k60gcma?=
 =?us-ascii?Q?Ah4mLWksieluF2+z5PHBjPShro/6pcFnqvPe5x54mMwARtIdn4XhMmiHFhPx?=
 =?us-ascii?Q?J9ZslxpGKo82Xy3+cQK9paMXbcvXIXnxIkPmvu5J++jPKia96icwrQCS8C5u?=
 =?us-ascii?Q?DkbbDmyyLdG9Cq6r7tiHBtL9ZYOSmFsWNef13SPTCcnWm3sBsAGIgaT1oSsv?=
 =?us-ascii?Q?7PMoh/JJVjxEO/DS8Rim35y2nIHvtn1FqHVJawUgk/rp3sD0zl6BAI55QCaE?=
 =?us-ascii?Q?blYegz7uUUxAtzuWPj9Y0ks3rsTZ1rLKlyOc2bITdOH6DnoO2t488PclSP1b?=
 =?us-ascii?Q?fxcbUg4GaqvZlRQ8/zkCpmrCV+2EhQJSRYO0pRC1STgRiky1TNHVat+ztinm?=
 =?us-ascii?Q?yZRQjCz/35a3SamNXoZDXFaCLiZXZNBnfhRYjdBV?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e26a5ab0-d88a-4f99-7f6a-08dd6cd5aebf
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2025 02:18:37.4639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O6w/ubRQJ08mELddk6n6QeNbx2SI4o81xBMYPR1GEgU4xsRW/Sk+V54IGnnOYNXgeDFtX/igpn8HM26Vn+uLOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR02MB7430

Calling verity_verify_io in bh for IO of all sizes is not suitable for
embedded devices. From our tests, it can improve the performance of 4K
synchronise random reads.
For example:
./fio --name=rand_read --ioengine=psync --rw=randread --bs=4K \
 --direct=1 --numjobs=8 --runtime=60 --time_based --group_reporting \
 --filename=/dev/block/mapper/xx-verity

But it will degrade the performance of 512K synchronise sequential reads
on our devices.
For example:
./fio --name=read --ioengine=psync --rw=read --bs=512K --direct=1 \
 --numjobs=8 --runtime=60 --time_based --group_reporting \
 --filename=/dev/block/mapper/xx-verity

A parameter array is introduced by this change. And users can modify the
default config by /sys/module/dm_verity/parameters/use_bh_bytes.

The default limits for NONE/RT/BE is set to 8192.
The default limits for IDLE is set to 0.

Call verity_verify_io directly when verity_end_io is not in hardirq.

Signed-off-by: LongPing Wei <weilongping@oppo.com>
---
v3:
1. set the default limit to 8192 bytes for none,rt,be;
2. set the default limit to 0 bytes for idle;
3. fix the mistake in v2 that verity_verify_io won't be called when
verity_use_bh return false;
v2:
1. change from use_bh_blocks to use_bh_bytes;
2. update documention;
3. set the default limit to 4096bytes;
4. call verity_verify_io directly when verity_end_io is in softirq;
5. bump version of dm-verity;
---
 .../admin-guide/device-mapper/verity.rst      |  8 ++++-
 drivers/md/dm-verity-target.c                 | 30 ++++++++++++++++---
 2 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/verity.rst b/Documentation/admin-guide/device-mapper/verity.rst
index a65c1602cb23..f7fb5ea3c0df 100644
--- a/Documentation/admin-guide/device-mapper/verity.rst
+++ b/Documentation/admin-guide/device-mapper/verity.rst
@@ -143,7 +143,13 @@ root_hash_sig_key_desc <key_description>
 
 try_verify_in_tasklet
     If verity hashes are in cache, verify data blocks in kernel tasklet instead
-    of workqueue. This option can reduce IO latency.
+    of workqueue. This option can reduce IO latency. The size limits could be
+    configured via /sys/module/dm_verity/parameters/use_bh_bytes. The four
+    parameters correspond to limits for IOPRIO_CLASS_NONE,IOPRIO_CLASS_RT,
+    IOPRIO_CLASS_BE and IOPRIO_CLASS_IDLE in turn.
+    For example:
+    <none>,<rt>,<be>,<idle>
+    4096,4096,4096,4096
 
 Theory of operation
 ===================
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index e86c1431b108..4d6148ed02e8 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -30,6 +30,7 @@
 #define DM_VERITY_ENV_VAR_NAME		"DM_VERITY_ERR_BLOCK_NR"
 
 #define DM_VERITY_DEFAULT_PREFETCH_SIZE	262144
+#define DM_VERITY_USE_BH_DEFAULT_BYTES	8192
 
 #define DM_VERITY_MAX_CORRUPTED_ERRS	100
 
@@ -49,6 +50,15 @@ static unsigned int dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE
 
 module_param_named(prefetch_cluster, dm_verity_prefetch_cluster, uint, 0644);
 
+static unsigned int dm_verity_use_bh_bytes[4] = {
+	DM_VERITY_USE_BH_DEFAULT_BYTES,	// IOPRIO_CLASS_NONE
+	DM_VERITY_USE_BH_DEFAULT_BYTES,	// IOPRIO_CLASS_RT
+	DM_VERITY_USE_BH_DEFAULT_BYTES,	// IOPRIO_CLASS_BE
+	0				// IOPRIO_CLASS_IDLE
+};
+
+module_param_array_named(use_bh_bytes, dm_verity_use_bh_bytes, uint, NULL, 0644);
+
 static DEFINE_STATIC_KEY_FALSE(use_bh_wq_enabled);
 
 /* Is at least one dm-verity instance using ahash_tfm instead of shash_tfm? */
@@ -652,9 +662,16 @@ static void verity_bh_work(struct work_struct *w)
 	verity_finish_io(io, errno_to_blk_status(err));
 }
 
+static inline bool verity_use_bh(unsigned int bytes, unsigned short ioprio)
+{
+	return ioprio <= IOPRIO_CLASS_IDLE &&
+		bytes <= READ_ONCE(dm_verity_use_bh_bytes[ioprio]);
+}
+
 static void verity_end_io(struct bio *bio)
 {
 	struct dm_verity_io *io = bio->bi_private;
+	unsigned short ioprio = IOPRIO_PRIO_CLASS(bio->bi_ioprio);
 
 	if (bio->bi_status &&
 	    (!verity_fec_is_enabled(io->v) ||
@@ -664,9 +681,14 @@ static void verity_end_io(struct bio *bio)
 		return;
 	}
 
-	if (static_branch_unlikely(&use_bh_wq_enabled) && io->v->use_bh_wq) {
-		INIT_WORK(&io->bh_work, verity_bh_work);
-		queue_work(system_bh_wq, &io->bh_work);
+	if (static_branch_unlikely(&use_bh_wq_enabled) && io->v->use_bh_wq &&
+		verity_use_bh(bio->bi_iter.bi_size, ioprio)) {
+		if (in_hardirq() || irqs_disabled()) {
+			INIT_WORK(&io->bh_work, verity_bh_work);
+			queue_work(system_bh_wq, &io->bh_work);
+		} else {
+			verity_bh_work(&io->bh_work);
+		}
 	} else {
 		INIT_WORK(&io->work, verity_work);
 		queue_work(io->v->verify_wq, &io->work);
@@ -1761,7 +1783,7 @@ static struct target_type verity_target = {
 	.name		= "verity",
 /* Note: the LSMs depend on the singleton and immutable features */
 	.features	= DM_TARGET_SINGLETON | DM_TARGET_IMMUTABLE,
-	.version	= {1, 10, 0},
+	.version	= {1, 11, 0},
 	.module		= THIS_MODULE,
 	.ctr		= verity_ctr,
 	.dtr		= verity_dtr,
-- 
2.34.1

