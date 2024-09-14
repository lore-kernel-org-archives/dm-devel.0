Received: from HK2PR02CU002.outbound.protection.outlook.com (mail-eastasiaazon11010027.outbound.protection.outlook.com [52.101.128.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BAB748D
	for <dm-devel@lists.linux.dev>; Sat, 14 Sep 2024 06:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.128.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726295914; cv=fail; b=TBs4eM3X92B6jbOF7cRTY6y6CrzmkSw8FqPvOUc+hfFuz/W2uL2euEOLOw4eDa0yVLIdQ5fPGEA8OthLGk5AMZ9Xik3olNmiYuVf0gFsQckNFLwmWbeeBZz0Yd2IHvvwKAzw4E/OW0u0iHtafecDWRnWQA7hu8UUyynl5p9KW98=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726295914; c=relaxed/simple;
	bh=fJ+tyGB8i1BiVrdB3EGjGln8fCuGsFSY5CgwgYbbqRg=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=qENaYCb3vvBsBUhYpaWWH76l789Xq04yuF8wDhJDIxcqWyZg78DxoiASayJL7S6qsgE3/S+fqyFZQcVkpW6aMZm0qUpHeGrPly1cX1/5Yhipp1vohc43V2lEKUHmM8ET4AHMQiceYqgrHdfbTbB2SJPovpnqrXca5sjBoyog1I0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=jjqTyhJd; arc=fail smtp.client-ip=52.101.128.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="jjqTyhJd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tkFodL+/wJMvgPhTOBDoSw5cPe4DdK1BtVrwOqnCLI/r8uva9itw9bDCyWW0rMjB/56eL1STLQDdWA1GG98VDRFxEnCwthlD1iWdfH+MsrwXm48HXYogbwY/+QseUwcKPX18BoKhDYK9STMti4NovW5r797KduSvBjkCjyjkoqTgTbJDSDc1NlvuxFK7AW7AClQ+T1/J8t9fvohfDTxwmHmZi8k49IEdKfBA/e5vED99K5GLGkA+/MY/d4RDegXMyZk8me0av3148ov0bVWh6BuiAFt0xmaLDZpmUa2TSZE2XxYGzWLfZUcdkhqrwAXNnNY071D8IQJPX0wxAY1nOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q/qfS9GNPnFZg6LSoys3wr4HTtl/VwgvOGK5noHbitE=;
 b=TeDjCMWxgwi0VQRdnCiMyxTDO8i6o7joWfJJCUveeOpadS7CKaTgD/+kLcfrRNc+X7azyFYGbHg7BRBVJnkiM1kMV0ykLJ0xh/yIy0d9i9aC0UrasqTehCqSezUOpSYtG1vkPUxZ4wQVGet23POUhE0B+e5BeJp8iZV93C5z8fVqVmoz2UpwjepUnejeqopVAiJ9K5wPUC+zQfkLv8PUaD73S0UMMhBdXOcNk5TsJw30epLepx+EGY0AKRFBrSi+DCp3jQVKOMPH8PhVSwHVimu2Sua0nb+FZWQ3jTvAu/3QfQ4XN/PnHZzswF1VPi4qEZZM8vNoVQxB/jQrsIAdOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q/qfS9GNPnFZg6LSoys3wr4HTtl/VwgvOGK5noHbitE=;
 b=jjqTyhJdv5TZ42orsU+HmzSdRHXLmR8rPysqnqlBheEwopUYEhrUPa+yXpINlacFIiELlrTZv7MnnSLYNIpg/x6xrRd3QfeOxaSnYv9fANt2IvhenVMZtI/9LBE2lsvQUO4ZZ8TgKSxlOREcWDfrzIReaoBzdamzYYgX4LhoP/k2HpJJWo2Mdko1qu82tkmfya4y5t3tS+X6GKYTvY0VPvNfxqS4QNKyIS9epcd1Kt1lKDO9qqsoKmxVOqS8pLHxs+sFI+iKDFtRnrjm/O3w8LPkrN9smwc4m573nyUXBSgWSSTlM9IJermEkUeSu61JJZcUcZzs50JfhurYlVFGtw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5899.apcprd06.prod.outlook.com (2603:1096:101:e3::16)
 by OS8PR06MB7322.apcprd06.prod.outlook.com (2603:1096:604:28c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24; Sat, 14 Sep
 2024 06:38:29 +0000
Received: from SEZPR06MB5899.apcprd06.prod.outlook.com
 ([fe80::8bfc:f1ee:8923:77ce]) by SEZPR06MB5899.apcprd06.prod.outlook.com
 ([fe80::8bfc:f1ee:8923:77ce%3]) with mapi id 15.20.7962.021; Sat, 14 Sep 2024
 06:38:29 +0000
From: Shen Lichuan <shenlichuan@vivo.com>
To: msakai@redhat.com
Cc: snitzer@kernel.org,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	opensource.kernel@vivo.com,
	Shen Lichuan <shenlichuan@vivo.com>
Subject: [PATCH v1] dm vdo indexer: Convert comma to semicolon
Date: Sat, 14 Sep 2024 14:38:08 +0800
Message-Id: <20240914063808.3471-1-shenlichuan@vivo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SI2PR06CA0001.apcprd06.prod.outlook.com
 (2603:1096:4:186::21) To SEZPR06MB5899.apcprd06.prod.outlook.com
 (2603:1096:101:e3::16)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5899:EE_|OS8PR06MB7322:EE_
X-MS-Office365-Filtering-Correlation-Id: 5627f207-6c48-4788-429a-08dcd487d823
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|366016|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Bnx5tHmBIu21aBTh6KZuG+G6l2L/779rMGu5Pl/poA9p9yNMXXqyuZbc2YhI?=
 =?us-ascii?Q?EiiN+n2/L4W8ovWlZLP1HBNqaoCT1DcjYK8m2FAf/QI1gy369yjsQPU0eIQ1?=
 =?us-ascii?Q?pnRYv9xIXN0YmCOOyqAihsxZsm3Gofg0wf/gwjz4+mX5zps0LMR866B9qoDO?=
 =?us-ascii?Q?WgUl3qm7RfYEYCT2vJfvRTWZs818D3Yd/4Vt6F9/vrdif9F5aJbIVBXH9QEx?=
 =?us-ascii?Q?AWswAwpTFp2hvWQaCXNP6P7urBzEuHwGCeT+HhbrhGF+uJ9lb4/7b89Kf9dG?=
 =?us-ascii?Q?zowlP/5YQSfJ8PxJgqc5B0XsUyyfzxlD3aGLD5fZpVXtDuweTJ1xCSm/2r+h?=
 =?us-ascii?Q?CZcouDn00IuvHtLxrZgC0ARd80w89VPFpt/CP2Yt5xxc7cV8opQKu1pr/74K?=
 =?us-ascii?Q?nTPWteLESJyZoSFJcrRfHaXiz3SuaJRkRWHtSB6lvhdR2bdOWa9x45iaIPmr?=
 =?us-ascii?Q?jVM9aExcJPRyXc+VW1SWGu+Ylsi9uiZU50ZYVOlTDv2k2rgwFKlwBwYc+kNb?=
 =?us-ascii?Q?w89ZzoqC5kb2w70cggg9RFEi7O6P/0dT33kCOFij1y+wQBuEpChy0VzphDU+?=
 =?us-ascii?Q?qvmj+LgBkFWjV9rDGztf0BZSs/lAxPe9qK3dYYdwhT2haRhBK+dw9SsoYxzh?=
 =?us-ascii?Q?v9d04Yj75EXBgO0go8/yv0fKGwR/m4pVl8VrRfWaJrlDyxet7+ciDKnSSU4Y?=
 =?us-ascii?Q?q90env9lOywRlMrGRvyBl69r8giM0OuL8lV5Z3Gh8Xeihcx623yHSeEp7+Ox?=
 =?us-ascii?Q?u0J6VBAjT7zloxbyC+bWPtOsN1qfpxPUEFkC+JoJ/pxYLELjAVQm0wM7YxSi?=
 =?us-ascii?Q?b24u9e15LBQojleMl0qqBJv7gIwuRFBLRaE8LxNz5Cqbc4uGB6pVcvqvB/7L?=
 =?us-ascii?Q?RDXfNIYWO8X6AOdt5IG1NNFD1/YJOwd2j8L9V2TesO1PQgZiaXvA9nVSGvnj?=
 =?us-ascii?Q?6XB5H7PCe6FJtDPfLIaPnEoShpp7WHIKqfF0U9MlfcZbprgmRtuJuZO3roqJ?=
 =?us-ascii?Q?62Fbe+JD0Etsy/CfHGqNk+/yCB+XUl7GOkqnINlavttvBzqHdKKJX1pxfxZ4?=
 =?us-ascii?Q?FsDgLYdOpeGGnTjGG3KyVJrh58CuCQl54GNBMz+gimxRiSIBbiCbOFaFxlpp?=
 =?us-ascii?Q?Nh40smVxrhfIua9rKsd0UwBofIofZOgdrHLXep2WZEHptdQoA4TDM1Bi2enT?=
 =?us-ascii?Q?oDNGk0rG5jLwEdn4I1MTdTqXW2tCPzddDUGg/fR8s1fLT57mR36FQSAw2ll6?=
 =?us-ascii?Q?NCRW+28drQUuMpVM8J9QtKt8aahdYc2JHTi+AkkdmqP+8TYLaPExq08pJkPf?=
 =?us-ascii?Q?EdkMXJXMeFsxjSuCRwVeIs6B4deccOlyjx5POTmNF/bFTPyDz+ZVeIyRQdCC?=
 =?us-ascii?Q?chm47gHeLxiO1UMdlKpIce2J/555y7K7tPT85wTUrmmj0ZMqYw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5899.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(366016)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ihsAet+QEPZ2GUwjD85KuMgxnfebThPedAOXSn9YP8LPO9dDOFlZWeNPwhKP?=
 =?us-ascii?Q?hLFxIdzwKmUPMcccz3XrP1TP/kO7ZrqGzg53tGZO0RmKm9F+Fc/ALUznzr2G?=
 =?us-ascii?Q?smV0NmoFvoj2o56tXOpSIb50TzvC3cASzWwj5pcC2qWF634gIpiV0HjFYgOC?=
 =?us-ascii?Q?e3DwBwqYBqL0GecL0xUgpNoxej6lTiNKy4QKiVyJK7Apd7bu0Ri0sVKOWtWD?=
 =?us-ascii?Q?6oRtkMSxs/VZCqqIld1lHbUrcfhav/NhOyw3MPm8Q0h064GBFkWVlLuMV0t1?=
 =?us-ascii?Q?qdIOUSP9LHfaXyXb9zmEwg2xJ7xlO06zjzlCP6X16hfFeEjkWZUIxh68aVlA?=
 =?us-ascii?Q?wTeCKGMAjbg4ZbOeamh1VZ3UHs7NC1YinSpCCAH8x+9qAUIbaLPI5GnqtM05?=
 =?us-ascii?Q?++wKDkX3BZzQEE2AHmTXrO6a6CB0dEnljOw8saasD+0qBYzQsC6NbPCb00/Q?=
 =?us-ascii?Q?izUY7T5HGZfa1CA3bM6yXvZ72rlgMX1L77IWdyxDPynoCiKJABMnilQqeJIt?=
 =?us-ascii?Q?9yD2WTRgfIye9yWqwZV1YiJKJSWzqzv7Qgn0BZBe5ze3GNHUnJP7SSb+80mf?=
 =?us-ascii?Q?5h4qS0YUeZXinTJEImW8ViDsnemtdSdesqUnAoUbmigV193hIPWY3NTs3UoP?=
 =?us-ascii?Q?vnPKQu94mpipyVLv/zyf9x6h2/8eoIlzKin/wAA7XmsK4OIdhmGJ5haYguNe?=
 =?us-ascii?Q?LPxh5yfbyD1U6vAtngx+iD5DSQ+q1eVkB3qWBBapRl6ZQ44FMRpw/vT7Wa5T?=
 =?us-ascii?Q?GVJC25knHWnhYG8QxbCsFqwk2tGejjLSKWBFpR0fnFHo1NAuZh5uy2GfCGLM?=
 =?us-ascii?Q?PYdB0u19NhXElAxTSoojkZC5LGC23lViQn3eUw6TZp5Pxmlbp33Fh1zOluxp?=
 =?us-ascii?Q?1vepTiN6hWHZwJSH0vmkAhehQ8PDWx5EkFbI44IovIaS3J0TU27T+24QcnDb?=
 =?us-ascii?Q?DhEouxBDc6Srsf19fvtnCHF2BuRcCcYbvaeruxn4WTv98bDDp+m969sKI6tj?=
 =?us-ascii?Q?e0tQCgCcUZwJWopPEwOF7qgaIXOFvQyUjOlHAH9zxo7OSRtSVx61TmW1DvX/?=
 =?us-ascii?Q?TscWxcj6pXpDxDLcp0NKxOzpdlfXNG4cNV8j6/dtieOgxg4+DkRedagyk+g/?=
 =?us-ascii?Q?YV4/zFFyU7+2DJG2by+4XXekc0k+sQ7qJGsFdsdEezQBI86wk3/aTtZT3KSY?=
 =?us-ascii?Q?QaAwq5GkenIcsoS7pS34RgrIzAVGqD0fbgRngj5xXXjizDC7PwLVDAXJG6d9?=
 =?us-ascii?Q?23Q08j0uToJCWNy8M34hr4wyykJf1f3si4CxfqgwxL6vpdl+Q3H0qmp1QD7T?=
 =?us-ascii?Q?9WCKgdp82PXeXUc3Nsdl8xdrrqkGZvB0EY1MyyHYzyWfMNlRaCQIiEXj1ndg?=
 =?us-ascii?Q?Cc68E/y958+4284THBgbO7I70HUTmbsWUG0Lp49xlUKhJGTiOXDsvZ9JyhEY?=
 =?us-ascii?Q?9zJYDkHxCjmIFdNfPEl00mZchgO8gfNgAKwOWQR0A8YEN+EEccJ5u7JcIYEW?=
 =?us-ascii?Q?4+0EhuxNsrWUvIArv1AN/AWntNDFVkrYFqfjbZq9/0SeKUUMOq/OBK1qrVhi?=
 =?us-ascii?Q?Qq6P8iKOhxMZxgRTwfn0j1DBnCFFi1X7RXKogVBV?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5627f207-6c48-4788-429a-08dcd487d823
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5899.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2024 06:38:29.3516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FhvCsMnsCSv8Vgav9HpuGsF07oKXbsZ6jrk1k9E5A1EPF5ArleAxE17Z4yoop0nk/UYq5HPfRglh3+PBIf8Yew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS8PR06MB7322

To ensure code clarity and prevent potential errors, it's advisable
to employ the ';' as a statement separator, except when ',' are
intentionally used for specific purposes.

Signed-off-by: Shen Lichuan <shenlichuan@vivo.com>
---
 drivers/md/dm-vdo/indexer/chapter-index.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-vdo/indexer/chapter-index.c b/drivers/md/dm-vdo/indexer/chapter-index.c
index 7e32a25d3f2f..fb1db41c794b 100644
--- a/drivers/md/dm-vdo/indexer/chapter-index.c
+++ b/drivers/md/dm-vdo/indexer/chapter-index.c
@@ -177,7 +177,7 @@ int uds_pack_open_chapter_index_page(struct open_chapter_index *chapter_index,
 			if (list_number < 0)
 				return UDS_OVERFLOW;
 
-			next_list = first_list + list_number--,
+			next_list = first_list + list_number--;
 			result = uds_start_delta_index_search(delta_index, next_list, 0,
 							      &entry);
 			if (result != UDS_SUCCESS)
-- 
2.17.1

