Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2087.outbound.protection.outlook.com [40.107.215.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEECD22EF3
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 09:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.215.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715677566; cv=fail; b=RLh5No6iHvxK9veeylv7yKh5fP5jpSlz4qK93Tow7kKzZuP/e+zkMAdVsxGz7AHnwFG9JDzc52NWpRNNdHfFvh0ocpfrDTdUSpsFXftzRvHWbfpxBsl+5aGBBQ98gt4ZpPjJG1jPhEOE+XuTkLd70ZVKYqhjFag7S3U8hrUdGzY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715677566; c=relaxed/simple;
	bh=pPWvRKMPkRY+EnBmIi6erbgSwiPgbkjhyxIFZjHSVZs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eq9bYidrwlAZgerX1ooRkdokL4zv5LNmnv9ukPy6hKuCAPZ0M8qf8hdmRwVKAjzDu/3FTqCpocpdQe0LpQw2hGo1CXyoRRRFrRJO/1Wr+BkSYTvvldDqgQyNBzcN2/jFR6vOzch8rPKtBkKT2OIewpPEuo3STCbUoU6dAtblkow=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=AXvAd4ZG; arc=fail smtp.client-ip=40.107.215.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="AXvAd4ZG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CW2x4MxQMIs+PDg68vEwqw8Bg1fF0EnMyNsmCVPIlOEwKSywmcpFsFSl7KF+XxUOVfyu8LhaQolDCA+8xcGIeXVdq6ENqhSfCTil+nIIJBTMTsZf6ugxMmsYJGX1tcxcreGoyvZgkdVgkZPSIG8LOPlGHtQjgfIWf8/IYjlnNOfOakliahKvMOSfIJQvQ+BMHEtq2BgYN1ZJhdRNJ/mSFWDTY/+bjw7nBEh+vLNW87q3eAbqf+Fu2BqPikcyL8GMg5GSHLaMaIR/TX9bZQE+zkFTalpEK6DqN193p7Q1dWl8XbtJpIwRU5t4fLkO50RxIsekE6aaHH+WMBgn54KIvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BRt2mpHtqBUQEwpYTcZxeN7e22kn1HBl7EsDYJP5O38=;
 b=jvoAH+A8FMpA4W0P6A9TjL3sNrp5e4qDcMyEyQS8NFBSJwIDHItRpPr0TzuoOSOJk4z4kqfP1Han46RsIZ+m1dj4xFj/L27rNS+zOzZtqS65RNjoav+4dWZAK5QOCtTyfbpxk5DXGe6E84/pAu9vQmkmXjHXLhhf3rFvJCN/84+iwWko+rBzyiACjgkgEh0zLO+dKdl1y4LAbXYNeDJCkrKKwOtEfdJ3iaOUodKJSHOFphB1FAHn0lv+fXpYFLvQfRvGY96HILgky+zVKFC+1BmNOMO9sv/KUjmn10bjATvnMtJnt7qQ2x2du9UvWzgt3l8fzwzuijav2IYCy/yjDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BRt2mpHtqBUQEwpYTcZxeN7e22kn1HBl7EsDYJP5O38=;
 b=AXvAd4ZGpOtxUO+2MCyFDJLy+xn41teGis1Qq0j3PpAJcNOzojAqUIimcvJAd3JOwrC+WGszlun8BZGjiuO5X2DccuefpAgINT0ZFxFUx40Q3tPi4y5eolGtH/4QfonqoCZLf3v33lFDUI799KSahDtgmH2flU27PZIVEh8JVxwsRtoOinoaM/wh97OdvxL7aLN5JskQtOiyU6IwzjN2bkDCJY3u8f4r0rljnV03wjP0UbmA0SFDdFYcTYoAw4jzqollSp1P5W7pNL1hYUeshmsMglA1r0KWUNZaUYEzrswf7tm5C8sN/8O7KfC6V+trow8A6+8LNKR/uoQWUrnyUQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEYPR06MB6398.apcprd06.prod.outlook.com (2603:1096:101:145::9)
 by PUZPR06MB6102.apcprd06.prod.outlook.com (2603:1096:301:112::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Tue, 14 May
 2024 09:06:01 +0000
Received: from SEYPR06MB6398.apcprd06.prod.outlook.com
 ([fe80::9784:d8bc:5eb5:b60e]) by SEYPR06MB6398.apcprd06.prod.outlook.com
 ([fe80::9784:d8bc:5eb5:b60e%6]) with mapi id 15.20.7544.052; Tue, 14 May 2024
 09:06:01 +0000
From: Yang Yang <yang.yang@vivo.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Yang Yang <yang.yang@vivo.com>
Subject: [PATCH 5/5] dm linear: enable flush optimization function
Date: Tue, 14 May 2024 17:04:44 +0800
Message-Id: <20240514090445.2847-6-yang.yang@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1761c51f-8dcc-4918-ec50-08dc73f513cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|52116005|1800799015|366007|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?s5sUsPhALM/Pkp7ol0V/Q3ICt5QQBGJZBY7iON0WNEl7c4S73/XQNjohiOMd?=
 =?us-ascii?Q?9mI44PKH2z61GjlxU8M44nAa+5mk/594gw5/wqkGihuXctfQ6Mzcaul8Pk6x?=
 =?us-ascii?Q?AKRxj/ESjEwJWCKdsHDEw1znnqbx1ccVro2kMJX17Jq8+MBh7LVk83CXerpy?=
 =?us-ascii?Q?zWrKiOVxscrIeykkMOp1KmXrMqreFaJkoIwh40KBfMCDTakDzDic4LhrhZek?=
 =?us-ascii?Q?fyDrqGsGzr/i4VPXsDs/E69aY7qan/jzEDjiFDol9BYVY90zPmNVPS3DseZi?=
 =?us-ascii?Q?a9eP9ev5JMwyMxj9rP4Wv2siMbVU1TUSe1d4G5Tmk+/5sVhl0rDJdgMITvwb?=
 =?us-ascii?Q?XCN2CHZvJcXUYt4lMjcvYjYAKuhjNr5mjwgO+sMitQnL2mCqydvQR3eHxiQu?=
 =?us-ascii?Q?HXeHpXcNvDxOM4YibdGOuKPxVHGvtGxI1+KlVcbDR4DvUv9MmuJ3kMCQAKog?=
 =?us-ascii?Q?8mKqKaQv6nLJ6qRs1VfNMFqCL65xmhPJWm88QcRpVX5UZ4CCrlPeSvzlIfgw?=
 =?us-ascii?Q?0oOMJ/tzRyFYjQ9CICd5mcoMlvM2cWVDk0bB6NKBYE5D5Nazze4Dg8FC9ZUb?=
 =?us-ascii?Q?+dXkGIpshkYa/7Ag8KiSGD8otwPQ4gpoiJHU0NYlzdgic+Groxx0RsLlLUxA?=
 =?us-ascii?Q?S43PQUTH+41QH+/4WdGr09oFW8R2t73fRLLYVkaG57NUQWkYG6ImPsdABDwX?=
 =?us-ascii?Q?bFi1NF2b7l5XF2Xs/K55TmxBTsVQz1vsN/67X3dHFAEw6oOjCZVk7GADA5SU?=
 =?us-ascii?Q?ReCrhMAtf5NYm+sJRhkYKGV8PQBtHaeBKocLQ1RDf3DrwEpNCEHjK5mkRdnf?=
 =?us-ascii?Q?o6pFstEgoRoz1f3c94YGAkwj+p3mqGGKMnrc83AiXR40oxjEf030qa/CaDuk?=
 =?us-ascii?Q?dCPBBTTW2qME4MR80a5/JoNEmqLn3igXKgRWY56BMx7xtvoUFVgC8W9ZgBI9?=
 =?us-ascii?Q?b80mde0pqZtjzMmgca7r4tnhqC9qZz/aCp7BTs9oIdZkYQWrYmfT4DCSOp7V?=
 =?us-ascii?Q?sC2bBMPa1RApRlvJ8qvXGWPAnI7UMDaFrCLhdvXrkHwn16kx58mUHRLZBZ+i?=
 =?us-ascii?Q?rseB+T+BRw/MMnSWg/uGS7U4HuAWyBxjRN1ZESYXwJ3DZU6uKtm2YKtIW0QO?=
 =?us-ascii?Q?9h0kTlp82yCNv9oMgIl2X/wAmnHxAKz3B7VWA01oBrJSQrKw8uka5X8D9cp1?=
 =?us-ascii?Q?WaE/wGrRpBlg0IWZepibDCCrFWv8/SZgvDXtdL4gdGZZKCaHnT7+Bc2W8rjF?=
 =?us-ascii?Q?1gpwDpM7fiUXDgmhT8yyoIC5s0Gpj+9z+nHuzijOdDbfcZXK/RiLNBbchMEN?=
 =?us-ascii?Q?DTsXBmvzc9PIxs3aafnKkwnMpmd7uZEzvUZlTC42t9vvjg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEYPR06MB6398.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(52116005)(1800799015)(366007)(38350700005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Dn/AN0mKnR+6oun4WZDZUyNnTKuaPzMeqWM6FOMwWY1IBV/p9Dy1WGRLnkK4?=
 =?us-ascii?Q?gfmG35buEk6G14ZUFqyA42JYrIf+6E9BGJlJKjFiur/XWhckGc2TdQPCEOak?=
 =?us-ascii?Q?CgzIRd39drDYFOtG/htM+enn2tDYCZrJC1OASQ1zBPcaCBiBkLzN/0g1JUs5?=
 =?us-ascii?Q?9XbRuNXbGnw0cse5U4lDshZj1coSQHaC5ytZEJ3E2AJ70qFs+9uUTuHm/fp+?=
 =?us-ascii?Q?sgS2XItzEcH3CqPeqGDDmcVlQJEQfjWMjX+6HC/pLdJjasQzlFEi3GmejoQO?=
 =?us-ascii?Q?q5/gZLIYe9u/BsgmuYylN1jA9938SPGxL3WQUcxNJq5pvO5sjpd3yM8+l1nG?=
 =?us-ascii?Q?0J9WL1mNI+xJQrVLCWG9j+cJes4cnsLljB9GUYZ9yZJOfTKHmGOtUzPULEiF?=
 =?us-ascii?Q?ILvxuI7Z6DKVrVAgCI3HkHqhJSYw2UVnkPQQrG34KuUemyTSRAbDCKdJM5r0?=
 =?us-ascii?Q?yJhDgfUBNQtTrPHKKgKWEkV9MZGNZpv927nxgEEZCxZUkRT3drCopdpI32Gb?=
 =?us-ascii?Q?vXCQ+aFVLX89Mest9qymbHkDzSC5O8ScVD6snfqqaET8Hi+BE62tsGPwakkn?=
 =?us-ascii?Q?2JBttxu6dGno+oQ3hrGqw3baUYeNxe2NnAf7TGJmtpVSINKEQCjmsYLvYl3F?=
 =?us-ascii?Q?YU36F8UlBae6yuhQG3UdJMUqU9z0nGjxS5NE/EHAoOTwY8WtnBHCHcRcO5AL?=
 =?us-ascii?Q?dZsIqO1PBxfhamguVC+cG1V9kZerfIQZxRDxMkHsYPB8MkTTBztQRnAr0RaG?=
 =?us-ascii?Q?Q96zTo8qUuBz1vHCPl3dpYMVztqEETk64xHv1XfShDT5JsAoRSCfmRyjCm1C?=
 =?us-ascii?Q?3MzA+0gGgZaaoQyR75sUZ+0aJzwcPeBe4kiPGqj79rHivEQkd49D+M1UxYEq?=
 =?us-ascii?Q?oPLACWbf7hB6e6ZgVZxgx+zIybRNObdt2XIjd24xKdfqQJZax678ZMkqfMq8?=
 =?us-ascii?Q?yveAn9Yzm5wXjboLUu6xuGWuH+nEAJ+41uH1SIbog57Ifm34/pnD3da8Z98A?=
 =?us-ascii?Q?Wq3VhmUz9OMRXwCIuV3v6IC/V7i91qu/DrCe+6oCqJYVRxQU57ab6tgTZZkO?=
 =?us-ascii?Q?y/uc1j4LgXwPvXBzCHmhBOTe3uD7NWWRin3g4JFveXUZuKe9dTXe9g0JAEio?=
 =?us-ascii?Q?mG5ttEEmJrUExPn72I8MBfBs7ssWHNg8O8iit64YSlgBXUYj91SzlRd+rk/l?=
 =?us-ascii?Q?5mT7k0lF4vfyrGg469+dAfFK7oNlGpXG1qrp7eeaZALv0r9wFl7BQBsXT4uL?=
 =?us-ascii?Q?Z2S5yZelpleJoX1jKm9RDtDColIJIXhy2etCULxY/q3t3s+sRWDWSGnsO7vk?=
 =?us-ascii?Q?NTvprDHXoYgZazAo6MMISPsmywDtVfGa/ehbWxjjlo5bhQkYY07aeMk+4p9A?=
 =?us-ascii?Q?rWWF/9I447wIA93YWJntFa83e+QbkO63pAU3RXxU0jyaEwwJezb2OOGWBZzW?=
 =?us-ascii?Q?5Nn/jJ6jeMfcfWzGiKjW2M9zHY8/S5X4oLOsQUcaNCjuDgTGHPKtOgaYZkBW?=
 =?us-ascii?Q?DYtL4KbSpmyJbt8C06kkyf+Vs2LrOj1YVzTb5e/sqy7/ieRJbuE+CwyJ1qLQ?=
 =?us-ascii?Q?Ss6TjjzEaurZ1aFTxX/RiO+wPYR8ker6ajfqA+7I?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1761c51f-8dcc-4918-ec50-08dc73f513cc
X-MS-Exchange-CrossTenant-AuthSource: SEYPR06MB6398.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2024 09:06:01.7972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w94iYCHefNR2n59gjE7vrXXZNA1JuKTJAAul1A71gTW3pATB2OtPz2zjQEMYNmGLj1P01DNfXytuwOXNjonROg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR06MB6102

__send_empty_flush() sends empty flush bios to every target in the
dm_table. However, if the num_targets exceeds the number of block
devices in the dm_table's device list, it could lead to multiple
invocations of __send_duplicate_bios() for the same block device.
Typically, a single thread sending numerous empty flush bios to one
block device is redundant, as these bios are likely to be merged by the
flush state machine. In scenarios where num_targets significantly
outweighs the number of block devices, such behavior may result in a
noteworthy decrease in performance.

This issue can be reproduced using this command line:
  for i in {0..1023}; do
    echo $((8000*$i)) 8000 linear /dev/sda2 $((16384*$i))
  done | dmsetup create example

With this fix, a random write with fsync workload executed with the
following fio command:

  fio --group_reporting --name=benchmark --filename=/dev/mapper/example \
      --ioengine=sync --invalidate=1 --numjobs=16 --rw=randwrite \
      --blocksize=4k --size=2G --time_based --runtime=30 --fdatasync=1

results in an increase from 857 KB/s to 30.8 MB/s of the write
throughput (3580% increase).

Signed-off-by: Yang Yang <yang.yang@vivo.com>
---
 drivers/md/dm-linear.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 2d3e186ca87e..3e1a33b4d289 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -62,6 +62,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->num_discard_bios = 1;
 	ti->num_secure_erase_bios = 1;
 	ti->num_write_zeroes_bios = 1;
+	ti->flush_pass_around = 1;
 	ti->private = lc;
 	return 0;
 
-- 
2.34.1

