Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2084.outbound.protection.outlook.com [40.107.215.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27FA71742
	for <dm-devel@lists.linux.dev>; Fri, 30 Aug 2024 03:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.215.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724987827; cv=fail; b=tv76EgfAQFjaX5rUw7V08uNj9jw6niAQViX62px9BgDeII7Qd9lWKbJwm+HY4hLNkRnOdDtLLUe55gNWloB9MqFi9Iy6ALLNrgTU2EkZ2Tbzuw3XIyUDT9oUv9kaP0Tjz6afQwS3NAWvhGdBWG/iLNkggHlJ2x8g/rnQOPxYBG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724987827; c=relaxed/simple;
	bh=ffegIfHgyvojreatJ5S7Z2NYRr4zY+bT8nkQjiTgDEI=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=eJGA/rip2K/b6/OcSt99pzIQBcBTjYpHELa2kKakeICAoNvnb8ki2AtbYXF+l65BijDlXxMYh3R2LM2LCSxyxZhsXfpXkf4lyCksJJ0ZasZNDdS6DSWC06yGMCsEm5TY4mkHroyf2igzZUnNL+ivcTuo0ZQt/8j9ZO3YTBp9c/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=EFABotf9; arc=fail smtp.client-ip=40.107.215.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="EFABotf9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vgzg7Mo8r0WtwMUc65yAAHLkMgAUBt264IHaOtjPoJB4wtDaBDmTplGMRKI9PAVoNbGfmyifIdt7xt5pZS+nXBh2zYigzgTPD7Q2WCk3OLqIv5+mBCT+61kW9SMYTedCx6yok+81EeVFTLde6aY6XiJ/52fdGd0d4W9C/TjZlqbR6S5hrbVibDeuYqyus09e/LLJy49785gasyplYlh9E2GF8OlJmhrv2Xv815CoRD+8xTfuz+xqf9kbN5ZUtNZyJIWf4KBkeCodBwbrVNnQwJl3TXe1bE5O8YsIdm8Gtv37tktrddYWmIF+y6UpEFGxm/IwvlhMOfquLVnRdGTCwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b3VYGEh47JfK9G3Lgg8BenGxd4r+mrDpVEsp4XA2QDo=;
 b=s7PDCcodGmUzzV5tQKVXKo4dZUs+cB1xjbt6cMP6HcaCqkwbJtGL8rCbK9C30H8QRnnExRkbUSGMqBQsqe7xz2xOHBYWsMcxbDgc2HtVdIPYOy5sO6zyz2uiX3GSrG9V1smfY1n1N+xiVyMCC9mnwAJQa2KWZHC0au17GqkVlFLWiNzH8bbdhau1Jq5rxONYDnnkBvF2JmttN5IThqS841j8jJHwci+DqYudX55wLAxq8lTkPZnFfkzXzu389FN8YyE7fhOA80D4JIJoIqrBeLV2wzERfytD4SA19ymsuTIM4s0nh+fb3n2kzTe35CHMXHG33xpq+JjbPwAoz8TGYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b3VYGEh47JfK9G3Lgg8BenGxd4r+mrDpVEsp4XA2QDo=;
 b=EFABotf936fyE0nrXuRSYCqy9rl2I/eR4UQmBqKrRiNvNw0pIbiohIeB9FfDY91HNSkXS48WjjvbWfS5I3pTIgzSQqPBtwOBhyXIcr99KGpEIRHJ6G6DxDQf4CXkOqOFTWk12m6IICqJl1p/RSDQARzKYQBreyNpa3R3/x4gqPEffsS2ABld3jm+2RouFeMg9SWDJYjxx0RVYpjPbz0UGoufab8CIi8Xasd9d2dOgeTzqP2m4z77OgT+PomeALB6Q56PhqDMg+QBWNAcQqBttyvbAdnnOeyiVlPST50fuQVr+15o/og8cv6SqLa1501yp9BOT/7f6+vfFzMrYDZnog==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB5709.apcprd06.prod.outlook.com (2603:1096:400:283::14)
 by JH0PR06MB6811.apcprd06.prod.outlook.com (2603:1096:990:48::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 03:16:59 +0000
Received: from TYZPR06MB5709.apcprd06.prod.outlook.com
 ([fe80::bc46:cc92:c2b6:cd1a]) by TYZPR06MB5709.apcprd06.prod.outlook.com
 ([fe80::bc46:cc92:c2b6:cd1a%4]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 03:16:59 +0000
From: Yuesong Li <liyuesong@vivo.com>
To: agk@redhat.com,
	snitzer@kernel.org
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	opensource.kernel@vivo.com,
	Yuesong Li <liyuesong@vivo.com>
Subject: [PATCH v1] dm: Convert to use ERR_CAST()
Date: Fri, 30 Aug 2024 11:16:42 +0800
Message-Id: <20240830031642.78849-1-liyuesong@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR01CA0016.jpnprd01.prod.outlook.com
 (2603:1096:404:a::28) To TYZPR06MB5709.apcprd06.prod.outlook.com
 (2603:1096:400:283::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYZPR06MB5709:EE_|JH0PR06MB6811:EE_
X-MS-Office365-Filtering-Correlation-Id: b1a1243e-df8c-4ed4-9a9c-08dcc8a235ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|366016|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YVINZQoKsnzbfbO6lomp6Itr87PtV3I9gnzkbj4P/lEh2dKNnpRbEo9GaLFg?=
 =?us-ascii?Q?u6EYDHTJbpk47aXZF/HrBFxbWBTPfXz0aOntmsWdVPRffmu0Iyf5zeLHeAEM?=
 =?us-ascii?Q?yeCIG8i6laFXdGiP8kFbW1dLGqmRBma0ezHGHq3uaGt33kDlSe2AFyPrxjVW?=
 =?us-ascii?Q?JTq8wqxL+4JT6SNJpGgM5y0+aq5q0AWl0p/QN5DU0ntkdi5xTSbS7Bcf1B59?=
 =?us-ascii?Q?ygkw1N0zgYkK+C/ip7qhl9pssULimWeSCjXu7rlhhiJbWAMnkcWBTjZ3/w11?=
 =?us-ascii?Q?qVpYVh5T2JeWJmaOShnTkv7iChqCyvnncR8syfaR4y65wzA/rsUdkLIzVtQn?=
 =?us-ascii?Q?tV7IJW4yE0X2S7DzWPgY4caA2ukWCTA7N6ipVT77/ytPNyNzxjkzl77Q+7F3?=
 =?us-ascii?Q?Fz6z0xkp0bdCmM20QuG4lHlEx0sTpT5gWlQYNFnvOn/iCOvVi5dqzwoc0YL7?=
 =?us-ascii?Q?nFy9oTuobMETMiV5dKW1a0/j7x26k9mnvhs/7HCMO66Tkwy0bLNXrHeNKuB4?=
 =?us-ascii?Q?y0fA6KLm6whAeCmABGFAclqWZ34ubO0sBZkU7Jtd+5DXWfEAfvcz9k7pqSft?=
 =?us-ascii?Q?MjbFi0dUK/LXX+8mvkMaryP2jkJyxUeNcmwfTpSe2e3MSQP6DYqY38ePPqEs?=
 =?us-ascii?Q?Uhv8XS2+/ygXwgpIIJI0iVlEjPFcd1s8WotQUmmdnWkceIqt0hO0ngsjAcFp?=
 =?us-ascii?Q?bsaQfIwn9nPjSzo3xW9NbQKjjYtYy+CH8Id5ddpQXJ8iuhxl0PGkjcFFxIRC?=
 =?us-ascii?Q?PsdrHVccT8z/G2dVUJj3AiROTRPNjLyB4YYPr+IGEv6DZ1eXE1xQC65yj5zV?=
 =?us-ascii?Q?sUnJMkc3voIfuKgGCEV1+HL/wREyfNpOPlLai74wChlWLvqpyfe0W0ng4uWQ?=
 =?us-ascii?Q?FqVGBCBWDE85xS1yE+7mkMByOt0Y9r/EpE3YYhQZUqdaItuU2wsreU2TZ9y/?=
 =?us-ascii?Q?nEd21kUNf8RHJ22sCIqPahSlpPEHFfH86sPx3F1A+v2S/r+oZmCk73dRRaaL?=
 =?us-ascii?Q?325X9jPMcdplYfodBfGyg7Kg9ySXyebKXMr4Px9eXZKo7eKXvyxgNeEPz5Ky?=
 =?us-ascii?Q?PU9MAU+i2dVH+iF8yzoY2AGk2v5Lqr1nrGcRJTyDl3xn0ItNq6a3qc90ORrB?=
 =?us-ascii?Q?T0jymsTCWpL0v2pv7p+ZOwEK5XT8lGCH2ZIdtGDJjL7rTu4+BLpQrdOLugeL?=
 =?us-ascii?Q?LLQD3nRN9FM9xyHoHS+rNVGChUF5dgMRfyFSyPKNVVWSc1n+F3sjNhSdLdPn?=
 =?us-ascii?Q?hqSlV2b31acGpwSZb2eQbYYDDPLHsBnpdKu7olR339TuoF+ZK6wrtvpRUBJp?=
 =?us-ascii?Q?vevYYPnUcLtXeN5DdBYaN6WJWSUQURmki77QdoOYgFvpK6htg8fQtoWKT24n?=
 =?us-ascii?Q?4tUzz145Bb7h3VIHbgMZBQO3BH/L9LDGAInnVB6ImD5XvtQPBA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB5709.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(366016)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0S5WQt6uDUd/psxT7DUq7NNtKbloFRXK6L8LDcm7WixYU1zhdlXyBlpIrw/x?=
 =?us-ascii?Q?35rzHpytPTVQnL+sIZ3e1o8JVh0w1ESkBKnImAEyuZVZ7kCqGkZQxYGBKR/w?=
 =?us-ascii?Q?xlSGXX9JBtVmRqhHIYhsgasAuvsR8BvO9/dtSR41n/mhK7TLWLYrk/2XWUWr?=
 =?us-ascii?Q?QQuoQzz9ZHa/QWgedFX1kESteXuMsJZNrgNTZN7BQP28kpM2lE7Cow9fItip?=
 =?us-ascii?Q?A2IOw/bfAYXTkBpLXcqow0tKBZvCPH/ZNrdr3JepSHSY/iUNL6Nd0Af/rjd7?=
 =?us-ascii?Q?VyTELu9wo6rN67LFoPxEjqK1T41Qh4DI1bWpGWddRLIP7riFG/FjpJk+O8kr?=
 =?us-ascii?Q?nWs9ffPEG4woCdC31xmY0dDdVOZHvsUORwSE9HOfnaeUqfJKhi8LLIPw/f5c?=
 =?us-ascii?Q?+vMWdsh3PD5XVrfLFegzzr0MUuzriSMUIe5tlXBXAb+kLhRhNgoUEGG3sC5h?=
 =?us-ascii?Q?pppkvMjIXd8F3DHD30SDYGejdi3D1uLL/KBChBdJcVbwOlr1gptYjXTzQj5h?=
 =?us-ascii?Q?65tfgC/kkejDQBcP+EHFdJbxKcVNq3wtxF0hxhJkkuIGp0qR5JOVLcnroH+r?=
 =?us-ascii?Q?9BvCigNIs3SMUcmEQ5Qe8rZzPSU6iTyvxH9IOA9XtGN/4Nkc2tdg0+Juucf0?=
 =?us-ascii?Q?T/h2UTOL7FgIhUnD1ck4wmgfmoZTIzE8v20eXm7y0+AxfMmV0j6e7m/3myPD?=
 =?us-ascii?Q?FSk2u0TOv5+RQ/HJObOxBcD0Ys3qYc5v43ZtWrd3AtzMc+boiakP6nyHxSZf?=
 =?us-ascii?Q?v0nQfU+uWEvOF356jDvs2BGMvZhTFHCRRqFDfVaMNwRQX05XsY2yuz9leR2F?=
 =?us-ascii?Q?XYxncqkfavaPVEfYmCMmcpdU9tTlAMOyUuOtg/skHaKVDUHG5n2K8uDF+B+y?=
 =?us-ascii?Q?sP22ma+fB2/hqmz+bpOPwrav+Cq0Bvm+gVXY7GZG2yrWa3irAz0/9VeFF6oK?=
 =?us-ascii?Q?+jxPWDzwWWEoa1W8YHh9kONMwRiTOuZf6Dc5HYY2tyDIOuXlFTBFBOnTYTbu?=
 =?us-ascii?Q?j0/k25P1+tfbv+zZdpyVu7AT73Zz79ogF0O/tyYw+Ldf4kegBOGOE36PdyCu?=
 =?us-ascii?Q?xSwwcLESoT17hGnWv9TpRWT/XrJRrx5KC0ppaCIw+ohopj4hkSloeZ91BXS6?=
 =?us-ascii?Q?tnncMqCplV0RtiiXFOU9l6dCIIUW28QTq/ef/dvlc/PTXxiQNBhoRMlntaM3?=
 =?us-ascii?Q?BthywHJd7XLy1E+ujE+mN1RAvoGEQ4NJWfUJeeOzg9Al+ZTvzv3IQuc1WbPI?=
 =?us-ascii?Q?ej/QUtWFuE3OPpEU4X30afay1I3A1KLC6nJxyXPGrgvkFvSunq8iO64zQuDg?=
 =?us-ascii?Q?zm7vwtlLgL6P+oschMTC1WPrqm8Z9h8ySpjjP5QMLoxn7V4xcZQWlHc4JGyG?=
 =?us-ascii?Q?tUfKrM1eUJHuuAE/83ZRrkjs3duyEEIeb+M10d7eCbiHMDFz1mHDfC1ROnZg?=
 =?us-ascii?Q?c/JoNiAAYSW90iM9Jpurfx83fNI7xcsez0DeZ4x8xQcQYHAoNsLxhWTl494p?=
 =?us-ascii?Q?ChG2fnq53FHq2RU0Byt9DuTCsNrvM6NxrszC3XVCFxYYAOAwj1jaFw2Dix6l?=
 =?us-ascii?Q?8qNKlYXatL8eNlaGijMfTdAtHr+R/fw0JPaBKAuo?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1a1243e-df8c-4ed4-9a9c-08dcc8a235ff
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB5709.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 03:16:59.7724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Eziz/6Obm7MCq9Kdk6FaB2+XIJT/M62ppTKcPk8qEJlKtaNvSqg3UjC5ivMeFZyBVciwudylzjk+K56rla190A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR06MB6811

Use ERR_CAST() as it is designed for casting an error pointer to
another type.

This macro utilizes the __force and __must_check modifiers, which instruct
the compiler to verify for errors at the locations where it is employed.

Signed-off-by: Yuesong Li <liyuesong@vivo.com>
---
 drivers/md/dm-thin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index a0c1620e90c8..89632ce97760 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2948,7 +2948,7 @@ static struct pool *pool_create(struct mapped_device *pool_md,
 	pmd = dm_pool_metadata_open(metadata_dev, block_size, format_device);
 	if (IS_ERR(pmd)) {
 		*error = "Error creating metadata object";
-		return (struct pool *)pmd;
+		return ERR_CAST(pmd);
 	}
 
 	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
-- 
2.34.1

