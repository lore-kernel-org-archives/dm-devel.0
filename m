Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F142E49BD
	for <dm-devel@lists.linux.dev>; Thu,  3 Jul 2025 11:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751543224; cv=fail; b=awl7zHopyCnxliyoDqJW0UgnPSxTfkIFvWCdVfet3jd25OUakiC1voe6TW1KyKTpeeeBT+1fed0WUxrlaFNrusev1J5giSPJZ1cr+eZpnFDjNziojysDtvJDfZKwNDQenrPERIasvjYKsJjd52YqtiT1mAOoU1+6lKeS5hiBWKY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751543224; c=relaxed/simple;
	bh=7J/GoWqcB8TqZvIOQE+957r+CgM9SgAtc6HDwHHiiX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BTp4y+mdI/fZB/sKuN52GNT1f2/Rq64bghPUaxsNnzybQv1xrrRl+oSa8UYGj8kq4oqcIMrci5y2CKcwDIzuiMQmDwbz12KP9M/v4NL0ROR62exEmUPOwqz12FFzBLaOsCtc9H10OF5H8u0i3YaqzUR5Zuvk/WIg/ZaMse5w6r8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CDVGGd1E; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=a/B4v/zb; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CDVGGd1E";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="a/B4v/zb"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5639Z8x5007128;
	Thu, 3 Jul 2025 11:46:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Wg6Wmg1XTAk+HcRE1yWIyDmWORwOgQZYLZm04nEWdBI=; b=
	CDVGGd1EWUF7dkQtPOrVX07SD3jvXs9/1z1/s2vL4Dp4yJPktF9BHPsHVc57bQar
	4WFnCWixt/JNCQ4oXSL6wvCZEUBBBTfc2fu39Ih9uH+Dg6tyBYaFbOEwhcj8Svp1
	UsTB8/YukUeTbXlzi3JazqSR7N1dxoVX9AdHfzHHPB4g6OIeaUK+hSIEMScZHzhW
	MFQ39kP31oS3MMXL+bWeDUzIdQ39pNWdNXDO/BG9psHifqX6Y4fbGKy9CISYoX64
	1vUBRaU6FlZaCpxjXD34XCZ1gkDLVdr3aN2RY/DP2J3db5m6jYbKbNnWcr5fCyWT
	0C0EZEld4MzNzLBkLnV7Qw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47j8ef8wp3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Jul 2025 11:46:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 563ANXW3027469;
	Thu, 3 Jul 2025 11:46:45 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47j6ucgj2f-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Jul 2025 11:46:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rR9jrzN3o4BxrYQuy20D33k1nV8Yrh1kKSyZpKUNB4XAOuyqI4uaeZJNa7aocZa5asghmcFuosMP2yTTlHrODrENCamTwXxzb2cgTnMF+/5HM8KhncR+k+FcqpJ4r9UWInY5sSpe67o0Aj3rlbS4mEym2n97+Pma3Gl0Z2aCCBHdNU6CM8QJY33DMpR0dFxF/A+2uYCi4UWqE5P6LY6znlCvAsjczQHV1wRQlYv5TPyjLZP4uZo1KIJQTHFjwbHn7j3yLSUepITAeyixgCiCd4IgOlt4sNxfkFC/O4fWutlCIwakYI022zmAkZ/Sq/KhiiCmUEzK7D4nuXSsDNlraw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wg6Wmg1XTAk+HcRE1yWIyDmWORwOgQZYLZm04nEWdBI=;
 b=jhFbmCL9cqvjIemsZ3ooMs+nG8ua3pRxexcFI2y6Mq821W149ZGWOHHtfU+1JiKkp2fZ3OkoF88+QB28llPfBcNBLpAg5kyGqLZgZPFJ5IkK7aiIoUpRVUjF7zBmsoNp1UnyIY9/fqi8f+XVIOfBWGAIdodi8Nd8RVW6YYOVVri1OZTaOZvYOJhMaBlORRxGFwNiyi9IIyLEVa2KpliGKgp7Xnb0rav9fVT5NP9unp5D9oLbUjHeBZPfgkO+9MSpCsDKLS8NumA0kobN0pzHw8d1BmD+6RNo9IZ/XDw6iUVbV+gl2RPix8NKkynO0d4qBL5fcfG6QIiYD1PPkExuDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wg6Wmg1XTAk+HcRE1yWIyDmWORwOgQZYLZm04nEWdBI=;
 b=a/B4v/zbHps9dDcvR8SHsEl7sSMPGGbXjqooUyrUoWDEj193nTn8cPJd5Pz2rKdKrXjsnY8nzTYM44W9VoYMpMR9k05tfdWhSwNhHTMaCeiV7D6qeTH860HDrMyefjgJaFnXe1I039fudvDEHkxdGwSuPsd4pwh5OXJ2E7lkvnA=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH3PPF262994532.namprd10.prod.outlook.com (2603:10b6:518:1::78f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.26; Thu, 3 Jul
 2025 11:46:39 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8880.027; Thu, 3 Jul 2025
 11:46:38 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
        song@kernel.org, yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 2/5] md/raid0: set chunk_sectors limit
Date: Thu,  3 Jul 2025 11:46:10 +0000
Message-ID: <20250703114613.9124-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250703114613.9124-1-john.g.garry@oracle.com>
References: <20250703114613.9124-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:510:339::20) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH3PPF262994532:EE_
X-MS-Office365-Filtering-Correlation-Id: 842655b4-1741-4c1b-4f5b-08ddba274556
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mf9k//SqM/kuWMf6jThza+Dgh7TwxAv1ffwGufoUqgPfwonlatWl1s6Z785T?=
 =?us-ascii?Q?RwKyWs5S3qhTzWmvVsSYWSr/mOd9j+Jnw7gaUhVXf+NbQhd2l0Vprwwgjc5E?=
 =?us-ascii?Q?BzkcD6Ml8HymbQMxKudZHTqf6IMGJk6twWPTQ5ImL85rBfufwWfgRJDk6fOZ?=
 =?us-ascii?Q?JUCOFBOlowPL2e/wmol8gVvUmASgj48e94iEuEbERJXK0EX98M278yApJG1e?=
 =?us-ascii?Q?owrh/rKO5NwbpglEenRzUU08+5W4XzQDfaFAPiqTwSdTC+qv3ftGFCzNwk37?=
 =?us-ascii?Q?mVu1Q0glYMQQZWH8vPghauTUh8jCGh/n5W+BBbW4Smt5Isk1yrg2JhtLg8k5?=
 =?us-ascii?Q?A85KYp4ljee6RZIE51UBtNURMe3qG4cGth3NZhXWusD8GRMQ1zox1Fw7BRQ1?=
 =?us-ascii?Q?3MiO3CBins5gooZLzSagMiTXHvrqZVq07t9cmf3NlEz31HNXen8b9ebjzJOG?=
 =?us-ascii?Q?xoISX5028GJCj1TpLV1fGIaAVksq7syefGmDmC/vpAAnV5KfUQ1nOru0uHeE?=
 =?us-ascii?Q?nXSueI5maQNiMjJTUYpMTqG7ddBp3r3MQK+DfV4h/A5+JyUUIsOkWcISQLMs?=
 =?us-ascii?Q?ieKwU3rL8ffrFozkTDmuINoJ0Wt6fWa9vrxvVZbY94Jvi/WVijJ6OdUMXXeG?=
 =?us-ascii?Q?Zansv5WwKP0+eKk3/DdtdbcmQbNMnfD5TuokWmAPHPJl5wUlz5jDKl6eiaYp?=
 =?us-ascii?Q?FdRwUceEzjSWNWZlbNFRhYlgz3czj0tAHJqFrEas1NwjTzDq/MOTuqjY/S/5?=
 =?us-ascii?Q?AFpYz77EacfAkpvhMsEvXExWLKAnyGFdVvsie67uJC+yodspqiW+QKBhumLk?=
 =?us-ascii?Q?c3uWOTuSi1GDuJr4Bhqld7S0b3Bo/bdcZmcrvmeoh4F4rrIXmPXNjEvZMnFq?=
 =?us-ascii?Q?ZrTABvinhgT1/L3NQu5iHMqoJ3VtoTGOo+xtQ1FE6T9KJo4V16KpJ16w3b4r?=
 =?us-ascii?Q?fyXApTx5hRxzIR8s8+VuInxkOsYEGUk+y0fTB+WR8+EhvMZjIaWMdV3BHuI1?=
 =?us-ascii?Q?4vGX6Odr5xrXLqpeHlCYaNXgC86u8FGjBr8VJ5epucd+SXZL/5nnHV/Sh1Ce?=
 =?us-ascii?Q?xETt22mhEGkR4OGSWEFYv1aT+SpX9iPU0kkarsRlETmVRANlDMH2MnSgy5ey?=
 =?us-ascii?Q?IG2dXd7UxHFKfBMY+2Io9KBGBKVmS4lDtzVZpu+t/O7uLz89STILjgrt/3R+?=
 =?us-ascii?Q?4UaA5mZlQYo92YiM2afj/lDrMLVB7zSeYcOK4zmuNvcRD+yIT7c1ytvviVUD?=
 =?us-ascii?Q?eqcs6+0erWTvU0OLoigJ2mQ8TZ7LnP3zOWZwsAI8No2eem9DsZV6+Sc8vryD?=
 =?us-ascii?Q?jTB4eTCb7eWLVnxlHybonLL07eCgwNpLX/gSv+uAZV/w/yeEaqPiql9wHztb?=
 =?us-ascii?Q?xhSv3FUHQIMHGCWX0xGa8Fwwn8d1CW/2pC6xdVO09axIzfeMR2MM4ASCbzNg?=
 =?us-ascii?Q?rN+tsSk0QU8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pT45Kj3nPhXvYEuPsSZeQQ9Fqs+XlSGFLgG/ayPLm71QPr8/y6ilIDyMo+Fi?=
 =?us-ascii?Q?1ztRLe0hu+ijIyJ0b8MMHfu0OIHuGt3dt2Kr2RC4W9Zu3ih0U8nSudQPnh4p?=
 =?us-ascii?Q?DdKwJ+UzfQEMKu8AcAELLjwiPYs4B4kYqsvyr3COft86mGbeit8lsc0gainG?=
 =?us-ascii?Q?zOf351RXxLs8nGFSYZau72oaIPAmKd/qFY4+BX1a06Xl+M/ENjE02ZQvB9QH?=
 =?us-ascii?Q?MNjypZv6BH1h3SB3uFvpBqOUX0P4umybTov/1n673h/tNLSGnM+J8ezybJkM?=
 =?us-ascii?Q?Z9AxURZay1O2UyFW1301xtq9m679UA+3TyU3CyydGvNYC6gtSd8BAA8FQwuC?=
 =?us-ascii?Q?zC8c7rfaY4TLar+kIw1lR/DAbWIuTA+/aJZLKNT1YmGvbPe8MFNgglYxtPvs?=
 =?us-ascii?Q?ClOB195NvFjHmPAg0FcVpbctM7b0ydO82harjZySI/QUfVycqpOgoRTkrg3Q?=
 =?us-ascii?Q?GAc+KXJjmjtC+FvEr2JN0hU3bONL+faxs6TaYGzAnDRuDrYUKvc1g3NuGpmx?=
 =?us-ascii?Q?Kfd7y1WkgEjq7xfXypa716znUX9uILOMa82ZJuA0xFqzZoTi+0o4uV18/eE0?=
 =?us-ascii?Q?XS6uCtePSQ7Tr/yGAqgOpehdUQss+nEBNE3dGc+yJlM+pgp9zmzuKB5hBgHd?=
 =?us-ascii?Q?8vV8+Nm0Z3oVWhVlZcEl/MylvEsmRsyT330KQkozoXzsGR5mrWjs/srlQptR?=
 =?us-ascii?Q?ItY0Da4Dkt9BGf6Cp6QEnhji9IZ7pP2hJlTC2j7oWADfRJrV9P+vihBaVaw3?=
 =?us-ascii?Q?N+Ocbrc6sd4uk2iWse1vRiEdt3yRqdXQAKUltGTUVIkwqADRU+GYA4dCrpv/?=
 =?us-ascii?Q?E9JIScSxrDoSiPfQpBWQsTU7YI16YSwOqOKJiaRYDRQrsUg8yP8wqBZx9pe4?=
 =?us-ascii?Q?1qdPubMOFQYjyEkmtTKT0qoljUhmnI0Dp9Dm5XP2OOJ5v/P3FRgYJh1uMrGJ?=
 =?us-ascii?Q?FBZNY/4T84fLVsa/255UIFhWvajb31fZjsy++XydxdZREBNbIQ7s29tqApeN?=
 =?us-ascii?Q?ENtb9i8xWWXgXOk3SgVCWat5H/S7BklptBTy2zM+zDnPU8a886swyL7pVMUa?=
 =?us-ascii?Q?CJX979/P1G1U4E0amd4jasioOJtheFdHhWbOFgi+bLjLrnnylG8OIL9lBhLj?=
 =?us-ascii?Q?ky0cx10iFt+aKwrhlVqfiC3vtEzUICuJUB1f243sVBccBbFLmk3rRmBEnZUl?=
 =?us-ascii?Q?JMZe8lt6wpeLfPKO3CcrZ8TMQxtG7xluomu3e/q43rj8cTZedZ1sDGqtYlcM?=
 =?us-ascii?Q?7F5Bwk3KcFhQ9BuMRV4Eld94OXeqkwnucIEbSebOg6M9YeInF4eUC/WiNtAy?=
 =?us-ascii?Q?pigK+IDeQZsxok0XRwm7ejfKX6kitxt238Ca4qm9f5iAEflS84CTKD2TPomg?=
 =?us-ascii?Q?owu0pwpRXu9UuO922sXpFuBJvlxRSUE87DUJtoX07qurPT/uF8DrKCpQ26ED?=
 =?us-ascii?Q?R3fhlN6KKNiKefkBF5fC19xe0Vkd51wPxdRC2MGE1JTJsx69cMoWcbIDJ03+?=
 =?us-ascii?Q?cDwU0y9/o3W7lJ/3OXWk68KaDdF0cab1yrS7tDGVCWqdblqSSpCMMng/FUh9?=
 =?us-ascii?Q?8pSmHHicGM+tl7kyJOfWSlFC2cIk1ssBUI+lgn/sP3sN5amxkBSXW+kpssZl?=
 =?us-ascii?Q?gg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IMfziDwwTpKYtzpn4Xo+xSFWop6ta0zURR6W+KoLRUGJi3Rufxw8n2MpPnGszohqhy/9nYloVNe4scJVXuC6ynFWTiL0sViZq3CIOFz8PQIORxuJP8jJnLlWLzk7PDWLYqHMAurI/0qNE2qbzb2MYRZE5wllLuATT6IYelDn13pZnOt+ArYHEDf9RC3EE9Vp1ZlW3JC9qPDfCm6KNcxraHpISgxvEWoZmK29f7NYvWGqK3iEPZwuk5jI2AKL5LQUh4kB1nYZmJ/hVr5eAZMB9MUe0puhJl9iI7JPfQb5FI0LrfOJm79S/EopvYJn7DyNQRi11YTE8mIsm8cMFjhumcPjxXamE3HiA5Lzh2Ba9fKdmWlXF25fLKoY0RkiECurlxIXRhKF2I/Fi8TYcuxBprsLIK3b8Y5jfQq0trFPFwroWvjoyZrPxRfZ9Nhp9s2nKs86R7zSBZrYetnFfOv8FxEws6OHpWjeqtaMW4nLjxngoa1dtxvHZMYpF21CvvzJj6gdojwPkWYcBSd7Pf8dw/9CW4nL1MskN+7CKsAnu55QHn+lHxX/Z6PITBxosKXNy/kB2tE/7ip6NwqQVXlVS3HhPfr7d0F9E6ZQ+vn7pGA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 842655b4-1741-4c1b-4f5b-08ddba274556
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2025 11:46:38.9199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vaz5QA1ls52AqL2FkqyDKl8D1T8AFTUOfxxTImbPukhUvjOxXO+1EzkioPY7y4ydqjsHwaC4uY5Q6r63l+ESeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF262994532
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-03_03,2025-07-02_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507030097
X-Proofpoint-GUID: KkYS8XkhrHCsqbkRWZ6P9Yzbyv5yDP5u
X-Proofpoint-ORIG-GUID: KkYS8XkhrHCsqbkRWZ6P9Yzbyv5yDP5u
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAzMDA5OCBTYWx0ZWRfX/VsEWYDJHZgv SiIk2cyf4s7HzPWCFzL9MWMUTCePLT3HZR76TQ+cUU8aOLhQsCSzV8Bk9GVGixzmW2M5ZAr4hab zUqhzlmi44ZYftgnRrfBmdPdPbHg6mXkvqbR3jR2DZo3bq88MEGoD748XT9S2zsyYyBIDaVUfbI
 arg0zmGKQWZgLcSQcXwIb5joYT4rdLWr+K25v+VybHW1zmEjfsZaR/NWZ7aKk5CqAabuwSrU272 e4z/wu/RzzXp+pSTHbtMeXGYE8H0APFpVtYG+0IbZfj77G/iNVHlSOg6N5J8V3QnbuwMKxVAHLf PDsHBetmpvrUKKWl+ZZ5cczBwVSa2VfQBn4dsWG2wb6qrZR605qh5dk+hYYXT4jCKTgQ04uJ7Oa
 /9iTHelOk1RyvYulJfFelqHNHzSzvj5oCopD53R8pN4FdeAbv6NhRIAPfHfDhZpFjdGlGdIw
X-Authority-Analysis: v=2.4 cv=ONgn3TaB c=1 sm=1 tr=0 ts=68666da6 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VnNF1IyMAAAA:8 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8 a=oeePQw0IGsqOEWDZT9MA:9

Currently we use min io size as the chunk size when deciding on the
atomic write size limits - see blk_stack_atomic_writes_head().

The limit min_io size is not a reliable value to store the chunk size, as
this may be mutated by the block stacking code. Such an example would be
for the min io size less than the physical block size, and the min io size
is raised to the physical block size - see blk_stack_limits().

The block stacking limits will rely on chunk_sectors in future,
so set this value (to the chunk size).

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index d8f639f4ae12..cbe2a9054cb9 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -384,6 +384,7 @@ static int raid0_set_limits(struct mddev *mddev)
 	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * mddev->raid_disks;
+	lim.chunk_sectors = mddev->chunk_sectors;
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
-- 
2.43.5

