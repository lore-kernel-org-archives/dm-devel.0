Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11020090.outbound.protection.outlook.com [40.93.198.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3276D4D8D8D
	for <dm-devel@lists.linux.dev>; Thu, 23 Jul 2026 16:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.90
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784823305; cv=fail; b=moReVdNvTlrdV7cch5VNksTgsQw/z9XwDP92RSIPjN2yElO01HlWriw9xIDY3sFBMaX+rTAWXoMmdZrSXwiAGRpsRpf7QA8dOgJGZoopvDaZ3ewucwrNYcm+QBxvvac0lA0PlkpfybaQ6wQU643nCk8hIHyR6wFaPwnkqF8t474=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784823305; c=relaxed/simple;
	bh=wvZX+uAAfnBF2yFLP6RY9mfxZk+UDQo2sqalBuCDRm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DuxEsedv0fdkTW6QgosXXmnqcI3NrX2LIWYGcp/wwmLc9BBRvLHY8wRBGn/vuPjK4HfUWjnSyvnwPIKNL6pUyhGKQoAhPDCwIEYpPlc6cneusQw8ANajsFh8g6Y6T1P6nG/4w6c48Xsur7M0hwKfdeh/YdWFv4ytGZhxqdOvqTo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pythonplayer123.dev; spf=pass smtp.mailfrom=is-likely.gay; dkim=pass (2048-bit key) header.d=pythonplayer123.dev header.i=@pythonplayer123.dev header.b=S1eO7Z8I; arc=fail smtp.client-ip=40.93.198.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pythonplayer123.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=is-likely.gay
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pythonplayer123.dev header.i=@pythonplayer123.dev header.b="S1eO7Z8I"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s6XCw5fduRAkTi6sgnHI+mzMUOsWA+/R4pqB4Ps300mgbKYiBli4ZzNJzBNNq4cgNYIA66pGOQ7U3hfhQOA1JR9spN/SsrJ63JMGOoRDh8peIw4SI00H7ATEhHQe5CwuZUctyIYn6v7T4lccvvK1WHtfzuTiEB0SB+QfQQSoi048K61j3QVCxGePCc0MRHK7UvD1xWjyYAqFOImWqVegneB4R4ZV/5fABWqROuLLptOqAkUDZto0jrZGteocvotmtbmzAF+V/5W+iAVhFg0itQUP0jZ5zyOG0XkBELaaT313juqCS2Q/uPSvxbwFol0Yqo4CWv2kvRBkO+pDNZqfHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WbLqdHbLioyB2kHEhDM7qlUIZL1sU1jWscHhvMbsuPk=;
 b=hNQ/7k0laY+2q8MFTQ1xD33xsO1dunbzKZVyFyDqiU7swpXuDWpqBgDdFLlQnPQH/JUO9HbMyjFZ0+GD22B7wTeakngBIcHbWH9UTvWI+Nyx8k/OTRg/aqrVifCeIcNmv3yqzN27aDCSxbuExqIuLDd2R/ST62SrJH+XzRk4ULIYBpKbLIlKv7LzgZJdw1iSUtVMU/W7iZqV9m3uJxuQ/Ww1dwL44JLRq4hHgk6XjyQjxuH/dRdkkZI04ldgF3PGIdc8mPCcQCPuYTf4W6LCTx8qZEbSCTdGivbItVsHSwtEUomsjwoSinH6NmuvfGWAL7ZnIxKksD80o/lLjWmFGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=is-likely.gay; dmarc=pass action=none
 header.from=pythonplayer123.dev; dkim=pass header.d=pythonplayer123.dev;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pythonplayer123.dev;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WbLqdHbLioyB2kHEhDM7qlUIZL1sU1jWscHhvMbsuPk=;
 b=S1eO7Z8IcceJudzU+jbTX74KmjKciWyMSSBbRJkFps/FYsqG8XKjR23UYaT7hJhFCj1ReMWa7o0GlefoKxar/CfUNRAXzUVB2aj8PyRtZLePKFksyARl90yPuylmLDtOMnrFIwFjVC3aS34b5rKV651pq54I+nhguW3l8Ivz7YHCQj0GS8vE7P8CE8CeVrJ3pwDeXL2QbBNv7ZZqK8+HwOHy+Zfg2y2W1RYPTbFax11q+JC1FR77ReJTXzGMf1cTg3zBk6xIK3QrVtKEr/KWoEoPRwItP6K51fUxrmkbKAbIFNUf59PAYr3+r1wuW4TPktgGdZyDKeWZJgk3JS5J3g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=pythonplayer123.dev;
Received: from SJ0PR20MB5160.namprd20.prod.outlook.com (2603:10b6:a03:47e::16)
 by DS0PR20MB6702.namprd20.prod.outlook.com (2603:10b6:8:167::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 16:14:23 +0000
Received: from SJ0PR20MB5160.namprd20.prod.outlook.com
 ([fe80::6a30:68dc:9faa:1ec2]) by SJ0PR20MB5160.namprd20.prod.outlook.com
 ([fe80::6a30:68dc:9faa:1ec2%3]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 16:14:23 +0000
From: Rhajune Park <june@pythonplayer123.dev>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>,
	Rhajune Park <june@pythonplayer123.dev>
Subject: [PATCH 2/2] Documentation: device-mapper: document VDO zstd
Date: Fri, 24 Jul 2026 01:13:50 +0900
Message-ID: <20260723161350.1080473-2-june@pythonplayer123.dev>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260723161350.1080473-1-june@pythonplayer123.dev>
References: <20260723161350.1080473-1-june@pythonplayer123.dev>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SE2P216CA0041.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:116::20) To SJ0PR20MB5160.namprd20.prod.outlook.com
 (2603:10b6:a03:47e::16)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR20MB5160:EE_|DS0PR20MB6702:EE_
X-MS-Office365-Filtering-Correlation-Id: aa44db63-8cb0-4526-f4d8-08dee8d57594
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|1800799024|366016|41320700013|23010399003|376014|34036016|20046099003|22082099003|18002099003|3023799007|10067099003|56012099006|11063799006|5023799004|6133799003;
X-Microsoft-Antispam-Message-Info:
	bI2bvprHvw/XO99YIN+ix3GvFKiVzMybULL4cwG633wyHmSEPSzcs/2n8lRNhcLLWKZy7Z2+f8Fa+rv1UH+0whZzbtBV5KFeH8AiqjOQMKVJhCWQCXGYyMihc03pAQVU/XJLW0Z5sfhL9sPdgdQHzlXcy8iHstWWwZm6ku6v4QEK92MydZEZ2RdDufkLYJcsV2QDCA6zWbAbXqtiVrXnkcqAf4vcH8fFOYaYo0eEAhbPblv+aFPWMNYFYT6XMdfbRluyqsgiNmdYXuYioWwm2O0QrQQ7oaxLu6Ix016OG6v8f0XMtBiStec9KhjQ1NEMhxAvCfBZTc932LSH/Ofh71cCwIhU0ECIpFT9LXKmJu9swVI+2z/uRwu+7391LojtZQ1QWW4bGp6OoiA8eD4UvEO2V7Xf6ZZqquFLajjXnO1NByNE/myqKZ97p6Z3kAZPfeIZH+XRp7CQ4SavfwCNil59/rkdabO+1r/Vpx+xPrCehhnkhYWfKIZKbq1ozK8yYIrdoKPK2fCypBbRBePBh1B9d0No6tiSVBxX/uddo6QqlL3F0I9H987F4d3nxFLVm7/oe4+OjX0ZXIeb3FQtgpnyRPRrglHg3YnxSBtMVmuYHoIEUNVxqJTBzrbff0pmkV4uJtkq3b5SF9F4J7S8FJpoxyAS08D6i4KyuWtK+4o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR20MB5160.namprd20.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(366016)(41320700013)(23010399003)(376014)(34036016)(20046099003)(22082099003)(18002099003)(3023799007)(10067099003)(56012099006)(11063799006)(5023799004)(6133799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?i30xtyPUZUx09xP48dPfPaMho9lLsfmM4G/CWyFf/FVi6qToK0t9FYiHu0gW?=
 =?us-ascii?Q?RLp5ljAq6Psl5jtFnt/0fk21Z/e2iuWnLCqOyFYbk2HY77tUIIBlGW+TSY4h?=
 =?us-ascii?Q?DRrsq7akJ2GnZ4x9kNZ8bObsIFHuRNjXFc1PZSnG84LPaDbAejBvA+fAMtfI?=
 =?us-ascii?Q?9fY7x6RY8ak7/1s28DvxBsuENlbBcCTPlbzZEBCjceXJzGzh2S7WNuedTvxA?=
 =?us-ascii?Q?gfz1KFQXKOS3NzLJtQgufEJlHQFCm13RYDCWJls/oxCkD2HHXAh+6Pefj6ZP?=
 =?us-ascii?Q?KXjYYBLrVINrw8w0Jnzr+fXZ4qXxKOzxTqv0IFqQF4YBz6QoCefcTQlhkHUv?=
 =?us-ascii?Q?Vofdsv1SG9PP8dgxCUAjIbGryxlMYd8FuqwyIM4MsgrfzZDVNzI0CEaEhRor?=
 =?us-ascii?Q?uvL9+RCtSd2N1NreaFFLZbG3+rkCZxlfhPwjXgXYGOev1f0ZNXssghH5qIil?=
 =?us-ascii?Q?OqaF9iv3Wj8wLUtcLzOPp+aHD70Qbwt1+yN8ygjUAonY73TnT0TRpBja1J41?=
 =?us-ascii?Q?9qiI0VWkqBaFPgE56Nco3xkh8RQs+Ytd4VH1qba1ebzexAOaF1L5potZXBoc?=
 =?us-ascii?Q?kTywd56w8rP3xfsassRXmvfXcdkEa2W7kp/MbfPAm9Rd4MFSAuWYrmnpQhQi?=
 =?us-ascii?Q?UemNCfaWNXCGL9ZX87Hizyc40zRbJ3IJy/BiKcZXQZvMp6uz2RzfO9Qf51Kv?=
 =?us-ascii?Q?X7dVpwxXeTkJ1CHn5TvtI0LYsPJZLbM97Z9lQDUHhFL2pdtIxIC/1KuTmcnr?=
 =?us-ascii?Q?LVucLbHOfX8z3B0rRKqHTs3SvNyjBEpXovc3vWYz+3RWtmS/2reoeZDZTz3S?=
 =?us-ascii?Q?6aah3KT3VxVa/43peJ9v3TidPi69mRIzEuQd32XoftpxJj/CBgA6lk2ZgsNM?=
 =?us-ascii?Q?6TmhezldKiPcjZNYEAskwvNwSjqAZwNg/YkM20uk2WCEtE/UM3BOhbcyf+t/?=
 =?us-ascii?Q?8miBybZjXiWbxn2PJxJdhif6PbeHpKsVajbFLUK16I9iLAZnsvnfI6oAGBMV?=
 =?us-ascii?Q?l2sXUiE2z4FJ3OQ+A6OGIuAUGYbq5yDqMZWsu++gn87xj77gJcNNhuOpenm9?=
 =?us-ascii?Q?g/pTpcbklKiIrn7jOAskUnGQoVC49joyKEpn8FKT8HIW9/lBVlK2pFN9z7sM?=
 =?us-ascii?Q?pgSV3hJnXgBhiMucCDPgGEL3JjywCxjHRw4Kr+glGPHnaNlN/Em/kHiSVQvV?=
 =?us-ascii?Q?kEGF4Arz+5DxmIMgM/Z+2OLiNtbQZDcUK9DDNvNGF5zUH6hQdNEFnCJ7Yec/?=
 =?us-ascii?Q?tDRlwPqUGBC5tQeioIrfyGB1CzGeJANMbcjuP7RncNR27ycL88e4U0hQrsXW?=
 =?us-ascii?Q?573/4xqvAcV/gMf7m1I9+twzBkpFPxd+qXoXYWMfcthmHzZP37FeOpEo1oJM?=
 =?us-ascii?Q?twdz9rlvsCbexTBBRSkCbDX9nsICZ2xlyC10N/Z8XesasWa8pW72rQLjmPYi?=
 =?us-ascii?Q?t2uA7spvotpSX5SbwaF6AF8EqPFfd+BoNf8oU09VRXumwdbexGslrEdyRkLa?=
 =?us-ascii?Q?K9mI76tdywtzZvxv9w2wcQ7kcjRQWWDfN0tGiAwbKyFtJ1Bo8gxzqsbFn2oN?=
 =?us-ascii?Q?lUNUK8KM1geasJVgOh9JB719mmnphKbRGH1gtpiE4apk40j/VuKkWaH6bY0I?=
 =?us-ascii?Q?RJqYB0KhbTID8qXsofB1p1LedqfSHTiHNa9WbFlabtpt5EJq83UkiatZ5rNG?=
 =?us-ascii?Q?nuEiHJnxcyNqQaNQLgRhklw9vHRt5iBOVYbMfKADc+nByn2z1TkhebI0xD3I?=
 =?us-ascii?Q?I7nEG2QtLA=3D=3D?=
X-OriginatorOrg: pythonplayer123.dev
X-MS-Exchange-CrossTenant-Network-Message-Id: aa44db63-8cb0-4526-f4d8-08dee8d57594
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR20MB5160.namprd20.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 16:14:23.2865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a3ce53b7-1063-4e66-9486-3ad7281a5cc5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dfdyUJMeNYleBCZhIkmxJnNeZVyCkpv66g4ZCIRQIMtZ835RqeqkYdwODEuDGx2TmY+lG1z2o+mSjj9HBZuBuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR20MB6702

document zstd compression with dm-vdo

Assisted-by: opencode:gpt-5.6-sol
Signed-off-by: Rhajune Park <june@pythonplayer123.dev>
---
 .../admin-guide/device-mapper/vdo.rst         | 21 ++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/device-mapper/vdo.rst b/Documentation/admin-guide/device-mapper/vdo.rst
index 8a67b320a97b..24a6b26bb990 100644
--- a/Documentation/admin-guide/device-mapper/vdo.rst
+++ b/Documentation/admin-guide/device-mapper/vdo.rst
@@ -171,6 +171,20 @@ Miscellaneous parameters:
 		Whether compression is enabled. The default is 'off'; the
 		acceptable values are 'on' and 'off'.
 
+	compressionAlgorithm:
+		The algorithm used to compress data. The acceptable values are
+		'lz4' and 'zstd'; the default for a new volume is 'lz4'. The
+		algorithm is recorded when the volume is formatted and cannot be
+		changed afterward. If specified when loading an existing volume,
+		it must match the recorded algorithm.
+
+	compressionLevel:
+		The Zstd compression level. The default is 1; negative levels are
+		accepted when supported by the kernel Zstd implementation. This
+		option is invalid with LZ4. The level may be changed after fully
+		deactivating the volume, but not by reloading an active VDO table.
+		It does not affect the readability of data written at another level.
+
 Device modification
 -------------------
 
@@ -178,6 +192,8 @@ A modified table may be loaded into a running, non-suspended vdo volume.
 The modifications will take effect when the device is next resumed. The
 modifiable parameters are <logical device size>, <physical device size>,
 <maxDiscard>, <compression>, and <deduplication>.
+The <compressionAlgorithm> parameter is a format-time property and is not
+modifiable.
 
 If the logical device size or physical device size are changed, upon
 successful resume vdo will store the new values and require them on future
@@ -255,7 +271,10 @@ The messages are:
 	config:
 		Outputs useful vdo configuration information. Mostly used
 		by users who want to recreate a similar VDO volume and
-		want to know the creation configuration used.
+		want to know the creation configuration used. Output version
+		3 contains physicalSize, logicalSize, slabSize,
+		compressionAlgorithm, the Zstd compressionLevel when applicable,
+		and index configuration fields.
 
 	dump:
 		Dumps many internal structures to the system log. This is
-- 
2.55.0

