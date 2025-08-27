Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013010.outbound.protection.outlook.com [40.107.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1659A2D6E48
	for <dm-devel@lists.linux.dev>; Wed, 27 Aug 2025 09:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756287887; cv=fail; b=Qvp5p8+jWCJ1WuhZAZEgEeD3We8wJ6MytDIS8GIdA7xp9TjrhUDS0G1a82Qr1AdUC6Yloicu9kzfF0nHZ2c7Ey+oTLeA/aD3kBvklxvQCclcoszrIXK8MDS9A510T9S8+Lcss/b1ethf9vWFuLDlqbV/t5nLdDLlKCsDBId6FT8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756287887; c=relaxed/simple;
	bh=FM+6Sj7F51iGhvyduRfR2puvkt5CZ/WJAAMfb0sU7BU=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=myGRABV4e1j2jighJBYSX8LWllgH5vLlH6GZ+8IlGpx99rshCgG6apkE9mX5imyV0Lf0Qzv9Uf8qONNwHB5SvKImoP8ZVFSDiffmgduRRSAO2w3SPna6HWgTQJCoFDEx8xwA1aD2nDCavXEag+IC9hfBk6+JtFEVG+aoA94VtFM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=Uc9QU3+L; arc=fail smtp.client-ip=40.107.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="Uc9QU3+L"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iVaPdnmCLwduxkSbyjVj94O5RKq5r+61RaOitWiITz6mJ+Dl1Kq0PxqZs4Pz8w2cCA1tPq/9fZDnK+yF2TA/141C5iKujW/0VW9FUoEfXHAIu7ZT8Ija4ChZadFACGWUBTM23aZSLkjarUONPPa69G8pUjklyQjJqgSec7VXdT9RK02ZKkahqHYz0KOmy656DsFx1OWvRH7ZhSVNwCfRJr/bHfHy8NsYpeZKW7TVhbsbpBJGUEUew9qaugjrEJaQ3ndh/pqqJY5An2bBZyRE46yumS1wyAqC/Sp6Gz7RcjmpVWvJh7Fz29leGRGnVX13utRmY9baFoIhUYqdRUyu8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xDqFaGFmIkUYN1NeJBwrEOFCjmRU7Par3tuwKugVdrk=;
 b=R5oQ5IT2cI2kzPz7L6bUoryW6oyUUyo0yTYm/Z7858Xsl51T4tvzNzPNFWm1FguUEy623EyMG/VaqhLsdrpeI5AT5W5QPVfPB1F7MYilWS59GYXdzvRCB/n7KFiOPPqChKgpRpJDZvHWLZ2V7lqrb1V0DgWsAw6RUqp+lZV+g3bga4rr/fd7GXI+D2T0uENlBAMNbT2u+d/exmkx3sHP0qb1+jlxm5qnIjfz/XgL65LroNTrs8DGA+4cDC4HFzic62dIUC+LSkjASqHGnJJOOzY5DWOfgStURGm7OuDO7U6KYrcorVs93SpUX6Via0kMSQzUj/QaXjCHBR+9vQ4U7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xDqFaGFmIkUYN1NeJBwrEOFCjmRU7Par3tuwKugVdrk=;
 b=Uc9QU3+LAbudq2T2V/RJTojBImnLDN2/FD6rf2mfBkpHEBlFKhnGJkECU0NTsBK9ew3N4ZyV4tuxf7HWvN0RSI+/JXFPoWCAeYHXTxFZZ8KWNOklBGyKMEk5hPVi1kHxkdCtxdBSX7xOzui/jsdyNsq7x04yqiB0UFKyFn2pkBmYbbinZFEheFXmRHW4q6LO+cJQ6fDH50EW2dn6UqSvuJzGuuBdUfOOr7q8mRT92Cxws0ElyEhDTIjqE+yc1wqrWqAHZCPlD1vMlN+FYVgfgKr+dcA38LtU309xJaEOdm2HS1JLYWh3HqR4lpv/szclasIbvo30CuH7heY18V1mZA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com (2603:1096:820:d8::5)
 by SI2PR06MB5163.apcprd06.prod.outlook.com (2603:1096:4:1ae::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Wed, 27 Aug
 2025 09:44:42 +0000
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb]) by KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb%5]) with mapi id 15.20.9073.010; Wed, 27 Aug 2025
 09:44:42 +0000
From: Xichao Zhao <zhao.xichao@vivo.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Xichao Zhao <zhao.xichao@vivo.com>
Subject: [PATCH] dm: fix "writen"->"written"
Date: Wed, 27 Aug 2025 17:44:33 +0800
Message-Id: <20250827094433.425157-1-zhao.xichao@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0233.apcprd06.prod.outlook.com
 (2603:1096:4:ac::17) To KL1PR06MB6020.apcprd06.prod.outlook.com
 (2603:1096:820:d8::5)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6020:EE_|SI2PR06MB5163:EE_
X-MS-Office365-Filtering-Correlation-Id: 7175ddbd-5201-4742-a312-08dde54e58c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|376014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?z88QZqS7OgPtdB3/hstTM0poXx8eGAylau6nEI3b/bwoScZ8P6s3F95aecV7?=
 =?us-ascii?Q?dU5mTeH+wY4myktbquMn1yaXDD8XAC7vVhlaS381T7I7oxPfvU5VvhrOxHja?=
 =?us-ascii?Q?64+Eq4nymYXQZiKpb1snOJUtbIESGKd1xCzg1yN1RjmYTHmfMdMTZUeSkftK?=
 =?us-ascii?Q?U1n+xdOFUkIhsvwh26noyyc37cKu+rbc00xlY0dORzo0n5P4fkrSjlrNdt1m?=
 =?us-ascii?Q?187kktKdq7jv9/47WhKShsM+glFkGetz3wnOIYg/ldp8mKdLBGEV/jzdRD8R?=
 =?us-ascii?Q?NE57ajuYXYUBqSg9wLgnD3dj98c+ACwn/qzQRnfDNGHHRC4nG3nhvZ8a2/1/?=
 =?us-ascii?Q?aRH6SCugIHO/KorNao1L+/zJbqlHAIQ5DlFFvoH6fZhx5A2a9mBqZDNoCNwk?=
 =?us-ascii?Q?ZNJXSatso/CMC3VDeZGwT2VmNTCarQrRu9lUicw1bJqr0oBT1mEM5ohsJzBm?=
 =?us-ascii?Q?FopYo3bNx0IfL/vAXvyNIX1vXVKIH8Ytlgyr7p96xcozDYlp7Yh68psvWDn/?=
 =?us-ascii?Q?4DhfoWQCovcwPH1lSUvZbzywqRlCJlm+uFWW7ozxpIuo1oDSVhRXEp2D5yuZ?=
 =?us-ascii?Q?JSt21ub78tlv7o5a3bWMVXp2LLXVNCZwZCQJrxVHPAx0nwTSYsHR6TfSmc7R?=
 =?us-ascii?Q?kyciGl30SGXI+SnXCxLCl34C4yJexqbHsKkXvUI138W8hxqw8f71gzN74UjX?=
 =?us-ascii?Q?oJqbsiFS42RSq6ZdFWT9WBQW97uSCea57XVfsj8Q2fKg3I0MbmfEpOjqi/3O?=
 =?us-ascii?Q?VDEiMPxw9thkk0xgqxUgLJ1uFccJ9UteEsgcs3LfKrsNloaKm1iKiBlKy9To?=
 =?us-ascii?Q?qBp1UQbhsOPGBfb8EDW2kaaGUxktLYv5IDCXytUiBUlYBpZOf4drE6ED6MUK?=
 =?us-ascii?Q?y9P2f7rR+S82ZLha1QgX0Y4ZxqEtO7NrMXZm+v81IOE5kAFOiZgX1HECTnwX?=
 =?us-ascii?Q?pyv72b3+fyssKFWk7rrEv2bQTyGaUhqiiRE/52nugNEvSRN4RSQg5QhrVFhJ?=
 =?us-ascii?Q?xZ5ThcsMqZbk9qI2hlCDm81u8gKvAVVBNDMpqCPh5GNrroOuGxtGAmUQUqMU?=
 =?us-ascii?Q?wXYF6EMlJRgCup1tTsFaQleSxlrmJHKlO2vwg3S892OUt0RvaZu+wNvJH9Vc?=
 =?us-ascii?Q?L72J6giaGiIkJC2SFiN99lbHgd4GjKybS+LpPO88YcVBrUF+4vEIplEBzuTw?=
 =?us-ascii?Q?6MKbYm5IAUPr2tklp8bU9lloAZc8P8lxS2VgFJj1G0A/PEzDW1uRMB31VoVe?=
 =?us-ascii?Q?3t9ebg28sQ/6wxS62+ifD48qDkeOa9WoXWkzZeVfDpSKsgO4Y/Z8T84vk4q2?=
 =?us-ascii?Q?RdAJV6Ig8rVI6l5aOxwakUQx9/2tlbjJ3i4Q1eq1RslmPdHAxlU+vbJh1OUp?=
 =?us-ascii?Q?5QTcLf3iE8xgPYNKi7Q21uYyZ2Yvx/QB+Lr/McPYS0BpIiiZxFd9o9zhOHwN?=
 =?us-ascii?Q?wvO/+Xxmqd/86Aw0dqtuvP+jDfIc7eezjbI9H5sgdUrD1Ye9wEEKLw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6020.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(376014)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yYa13h8o3MtMbVTU1aDnR258Xaro9s4UZSxitjiSLEsFfchmJnsPTGS+N+y3?=
 =?us-ascii?Q?6Yypm8VfyomoS6ZG7dbP5408VY9/FBo7iMh7dyGFh/N12gzK/DqINLYBBgr2?=
 =?us-ascii?Q?R7A9uGWKGieSRb1Hg34lHM3mgreJ9ze3aRg0zM7MxPaJ/XlUSeW23E9FcP9i?=
 =?us-ascii?Q?HPCoImsXzJKmI1jFA4XoShucA0ObbX18bvNkp0y9pfcmjGT6bOuOdn/DaH2I?=
 =?us-ascii?Q?xm0wo+rI/pS7JMfvfhhM2mLI+Fdy5ZYwxpw5/8BkuleYkzkqGWSm2h9uafLg?=
 =?us-ascii?Q?u//8Exm88dXeSqa8umRvBV4Kv/HaWYVNWIhMS4hGTCmioobej30t8173Acbu?=
 =?us-ascii?Q?XNqTs8dMkSpu1EhpQG3WvqaVDwuprECsJc+x/d6PbdjEZUO84H/gFl4npcdb?=
 =?us-ascii?Q?eAaWuXCgiZhfQ1PEmErZpFoq9IiqRehB57cku8UEJ36NvJHazc54C2Zrf+kr?=
 =?us-ascii?Q?uj7UJ0H57nyNZHWA0Z+VyObzksT5JwDQsDPKAEzx0cV0flMgfwYLBYiRrZaA?=
 =?us-ascii?Q?h9J0g5sRxU5MnMcnQ5WPUdHl5dob6l6O7voXg/qrLvifz4o7rbBeNwcFtRiD?=
 =?us-ascii?Q?FjLFp5x2OCgXjvQlSFpP7MsD0IzVQJP2DS1pTU7l2jlExYA2fEIgfCxuH9S6?=
 =?us-ascii?Q?F9izXz5a5zcjie6Sk0wEJSTQmznZ5RSRHlO5SQFunTd5Z9Un3La1+RctBIMS?=
 =?us-ascii?Q?s2+Y3wqQRpK/3sBro4jWvukto+GnfM6tCCZgEyB4DjFYfXS3KfYQ7sIhVeZs?=
 =?us-ascii?Q?M9gWvyijrH/PYm/GxzMp/IfiwlQYojkUnLfS2taLWZRF5a05aIas9jetaGeK?=
 =?us-ascii?Q?scLoYCJ9M2LqeljHIsOQ+JaMreJhQuHitV1fxX/87eBBQCgo66m6J8av9OUO?=
 =?us-ascii?Q?Sx5N8IucMD7GJrb9tsyrBeBFpsk6CMa84Ou3H/VqiKyczjrFm1UzGZrWf3Ly?=
 =?us-ascii?Q?sKmIslcg1N94ol6TSGLowGWShM9Xfn191iuDzY1i8bBUlQveS53NopwJ8ZRZ?=
 =?us-ascii?Q?ddgET8Ftd9bwIuCkIfJ4zFOIQyI4yWA5aiaAh5N747BPtzck84JorpubAiVB?=
 =?us-ascii?Q?5RSqXMtDePdL7NABLJ0IS6gXRx77MqQ+B9b6Yoay9qhm37h4PXQVZXiTdX8b?=
 =?us-ascii?Q?r1rysH8zwuKedTdinZzAkYH07Y8f7VPhpTaQTaIZyM+E0dGG8zyBHIQaSdif?=
 =?us-ascii?Q?O2RhTVVBz//f8z2Dn7QXqk7j7MMdtW1kqI3rkpt/f7urthPyOhXHfrpKH5iM?=
 =?us-ascii?Q?Qp21chtRgvKuokyG9e6Q4vSTa0D5uxTLM7FJ65TmbZnXAX7XvghwRH5RfNTn?=
 =?us-ascii?Q?PRCkGwndYlC6w3939yprauDo1DcvRY4WAIozyPuWfy4DugZoZn1MqzqFBlc5?=
 =?us-ascii?Q?w4bXJZBNx+o07M5+YZ2IdZ8LbvJtbRGjb1ZT+B/4G5tzbWZhwsgboUey0DMp?=
 =?us-ascii?Q?s7qqy+FGv84GFAx14gXzddVIwz8T1xtuGIte9JlodHQxaoQFIlxhnUMtEqON?=
 =?us-ascii?Q?D7ffr1PdQHf+smVpA55g/ExmhlvG9iUHhHiVDZJY/TNwtxosRynYyhAxjWHi?=
 =?us-ascii?Q?sP8RarWY9wiPDf4pCWBy7647ebJteuUm3lq/rP32?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7175ddbd-5201-4742-a312-08dde54e58c4
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6020.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 09:44:41.8473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g/QBXznFhrUjonVuoy3gOHHoLvZxKu9jryer1Czk207EX79gZ1Yc7P/Xn5Eu/CkEq+dDpu5v/Sc2fivEum9+XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB5163

Trivial fix to spelling mistake in comment text.

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
---
 drivers/md/dm-log-writes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 679b07dee229..7bb7174f8f4f 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -414,7 +414,7 @@ static int log_super(struct log_writes_c *lc)
 	}
 
 	/*
-	 * Super sector should be writen in-order, otherwise the
+	 * Super sector should be written in-order, otherwise the
 	 * nr_entries could be rewritten incorrectly by an old bio.
 	 */
 	wait_for_completion_io(&lc->super_done);
-- 
2.34.1

