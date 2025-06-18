Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FAF191F66
	for <dm-devel@lists.linux.dev>; Wed, 18 Jun 2025 08:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750235889; cv=fail; b=GADcgodgzpGdOLngRMaGtQfJRGYw87dWULs8tMc+a5TKD2FeATBW0/2TIv6Z2QgZ4s7N6UFiS3NMGR/LMbn22tlYuwVqrHxj0qDwY4DXlg0iwjIHrP8z0MGG6FJpDuY8MSMORko7koe3FSzYORiPD6gi12lLjA+++37GAWNfSl4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750235889; c=relaxed/simple;
	bh=e6x4pPWxXZM5vnYFXBEKzzpbnd0+jlijr0mD0FYlKZ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=O6Sz4kUnHyo0j5NsXtxzwGmSiFK6NGGmOET9ChU6Zx8h2XHzRgT9oe3Pa0GUZwQ9zKXGPi59SXV3eE4zlEVV4Ih3XLu6NGlHDuNur+N4/uJdDus7Fms918OLMplPNXY+nAQoyeKW8L2uLS7OlX+SIQ4SoQ3Iv3a1oWB1tPuPrB4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mjZaiz14; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jNM3ZV+b; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mjZaiz14";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jNM3ZV+b"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55I7Godc006043;
	Wed, 18 Jun 2025 08:37:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gk5iKLAaga/QtTUm/zseTShADYTBgfgA5BKSj/NP9ls=; b=
	mjZaiz14cgnm68hhwLbAu9l6FU83Iu2gdVHTI+pBcfwqkT8+RosQFd+A0nNANbap
	J//8GdnbppYVDQxO07SG/JnG8Ui7Y5yYNhSfyYGcwYzmdCNMLTP9H3jAkCDoxGxl
	wqSucoBt3LeT0mhVq6/Ujkn+sVeUM6AodzUmTJJq/XZ4cLxhrHrE4K/T9ge1R8Ry
	cKYc9D2C3jG2xAa8V2kC1KlxIA+fTmPIZ/qYtZLl3ozwr+eC46WXEO98UvkzydzP
	6/UD2YdHEKPk1r+tRtU74nPn0M8bvcmvy9uHzfwvWFlH9jk7YoOMlaLhJK1uFtqw
	n0wZfPB4a839YttFlaCQ3w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47b23xtsx7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Jun 2025 08:37:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55I8bCND034444;
	Wed, 18 Jun 2025 08:37:58 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2063.outbound.protection.outlook.com [40.107.243.63])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 478yha4as7-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Jun 2025 08:37:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KK6P3MjdWH9LRzDSM93LKjoo0GEKfSZXZQBCWRaEq+O/WQD05fXsR9G/mbiNVqhW/8ixSB0P4ftSIUx+a9ZyXqnp6ybgdFlg+I9aqCyXXIJ+y+7lm0TQ9MuMD0+nvoU55ngarqExOsOHrrvS58XDAqsFE1//xXyt2vpjCMREWkWZaVN9I4tF+Wb/pLtMZOuuV7QRcP3lcSsetES5CF8vRCNl2yuU/peDaRKuD5AGkcN8R074P/PGlr0wbMMil7Ajy7zPukxx5/6vVrgUX2AOd7oP3k581NLfqiDOwtaBo6MFkIh3WxH607JA6860SUz5sL1lgjs022/qoLxHkVJSmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gk5iKLAaga/QtTUm/zseTShADYTBgfgA5BKSj/NP9ls=;
 b=vzmSHYrm3lGi9/iFs4gp2srt5GpbUpPbleSnh4YvmgWiSpYOzTrtBcdG5+E2ZaNwcYW3OCic0x4oBWrEUFQ+t39PuMQIE0eDhTjpXA3Vqww0NtULg2rr7PtDDJK/skM7MnY8iKSbPe5R9f5KUH2opdmqZZo8g/SUyH2NLYHWDmwwaQ5aqSelV8V8l0OEfMCpyNrzW45Z+rNbg1rdvZZmWXzV5rWZMpK1prQe187kVEYhkmL1jQCPSDd3pYGocs+guHi+NOWutUblObA2sg8TdmIUgy9Kq6zs6OE6nPQigv5t0dFQn69QZMNkdsYwsd5IAvxEC2awcoGkbT/Eoyc6JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gk5iKLAaga/QtTUm/zseTShADYTBgfgA5BKSj/NP9ls=;
 b=jNM3ZV+byMBFm/3kP9g9yvMXFmhX4Qq10OlOPbYViByNd5vMMx0jQposK2yTys/+V54yQzadpAOOCJaZRgGY0PUkXLfn1xxaIkzgr5KI6elleN5/x2pPNzgi+gbFXJsKwqyNKtmHityb6UtVfzVxKvWcmL9YbJePFtCnvOFf4/Q=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by LV3PR10MB7769.namprd10.prod.outlook.com (2603:10b6:408:1b7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Wed, 18 Jun
 2025 08:37:57 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8835.027; Wed, 18 Jun 2025
 08:37:57 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 1/5] block: sanitize chunk_sectors for atomic write limits
Date: Wed, 18 Jun 2025 08:37:33 +0000
Message-Id: <20250618083737.4084373-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250618083737.4084373-1-john.g.garry@oracle.com>
References: <20250618083737.4084373-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0141.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::26) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|LV3PR10MB7769:EE_
X-MS-Office365-Filtering-Correlation-Id: 87f9d9d4-b0ab-4bda-c80d-08ddae436ccb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/964nOelBHAEwadgoeJthrfCUuCYsrsXAwRAm12QGIfOEPp3KHRI4SZXP3HP?=
 =?us-ascii?Q?lN1ZNma1GB64q0jmzZG9gpyC6xJmfGivpIZJxDC+lkp0qsgK83nWlOl6I8bS?=
 =?us-ascii?Q?rilRA/Q4h4f2Vzw1S6QIp/HiwZ6ygl0gJ6O6Evdk0E7ryvHLZ2WqzcO+zafN?=
 =?us-ascii?Q?B0dMLBY4XHhYsx7BZYkHm1QmTD9h3MB8WhLj/abG7AOvttjRyqU3RgkTNB86?=
 =?us-ascii?Q?RRL/fWoqrRv3U4IUS3J0HozZGYmuI+yNWKKWzLNIv2MxqThNQgqSOiwlN9Pg?=
 =?us-ascii?Q?pP/20ETSqkerzk6M/IdI0f0moY5P1UagDuLE/6zCwQz2cXNAuEq5hztkY64H?=
 =?us-ascii?Q?PVos4XyLKl3togsqeWGX4EY4REWqdJmRjERxe3x2Q0PuFwW2Q2ebMwsD2jVC?=
 =?us-ascii?Q?Dczcc6DvdhoLDFgeUVpnyo7od3YGL/T9onWkfjwRirBwbF5Hh38iI70bpSbw?=
 =?us-ascii?Q?U7UbF58rfrMSkCpmwMaYYV9fQLUgcNVpJlUDoMg8AHq1lBhi9nh12XNtNZuk?=
 =?us-ascii?Q?PS0bqH6OPIN5Htp1pVkxqTKQuZSKYWWqARPqXbq++vod7l5EAOhJqFsrft+u?=
 =?us-ascii?Q?soKCh8Wok6U18C0cUK/b7q6buPMe55HJCaorknjcy4nZx7Y/Yh/nuaeNDree?=
 =?us-ascii?Q?S18o9NqUpzL2T8BHRtEGP94d8PJSiQPreZKXfVnT0k5SnxAdBjSmmyaSghqo?=
 =?us-ascii?Q?ptgCjqR90fr99yjgBUiWp6FiLj7NRX4kimTyBsMRjrZmhV0CCKFME1hHYjiv?=
 =?us-ascii?Q?3UnChKr20NZIs4Y+qLf5XWy59h8e3Yh+m2pMCBj/6Grkcnbqv2vVebyrZOSy?=
 =?us-ascii?Q?+4XfnOEOVG6SMPDvtQKVjm3pXXEF3I/MXe1U1Q7iymzixfiA9XToRiiMxqYs?=
 =?us-ascii?Q?f729/fZyG1qeu4OKY6s6gs9wBJBSzHD1OMWTfdf7acIihVEDBqBBm9fPGd64?=
 =?us-ascii?Q?2lkB9aVLJwRRhU53+1vmIGmmmQacV2oKhG3p340rU03h74Y0IU0ntB1ZFXnS?=
 =?us-ascii?Q?otCPMK97JyZeoMzvDqIVX4Xqi7lXKfXu/nVWGuXMjKxUX6Srndl6PRD3Kkax?=
 =?us-ascii?Q?jBEf62lzdIhXs3Ot+MAHnPjN6UFykSXL0mJYG6SVsixR2EUNDCWbSjZqd3hV?=
 =?us-ascii?Q?y/3FCshwWP86OOF53p7meP+42/uZLfb1dnOrlBYTyCcma0gbOJ1NfdnndaRG?=
 =?us-ascii?Q?RN7Bvy3ExfcnGbk5H07aKo0edHu9cJ1ovYBOJ+c2Tb3nvlpFC11tybFbyNHU?=
 =?us-ascii?Q?OK3p9y3X2KaUQiivq4zpJoSoUUDRq/wXrx49JaQ/zZBJzTV/tQMeVG9+sRmo?=
 =?us-ascii?Q?wnONMKafkImEbU/Zn4MRccpTAsdOt14um7+qpreFkUk7rarjPKpVwYrhKhJ5?=
 =?us-ascii?Q?NOIMQj3lLV+dMbEXmAs9UHThy/FS6QDXJtq/AG7RCJfw9ptDTGLnAC7lU8aY?=
 =?us-ascii?Q?7A/NXAd8Ank=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ssh6X+ICJSatdI9r7PBZ/SSsyqmRzYrs8wcGTjcJsejtD8edza4qfZFxRpWG?=
 =?us-ascii?Q?Pk1d1/ZpGPIyH1koOP40PVuQ8obFLpUauKNdC5bc0KlotDiDJnIauBdR8MiT?=
 =?us-ascii?Q?lZ32corjdqhX25tiD4WPP0R2/GjYoOyzSsjHNl/kISImm272GkMVwoPj1lmh?=
 =?us-ascii?Q?DX4Ln0Twp8tV0SLkEQLKsEL7Hmt5C+fweSBO+u2Nk81lR+8nkI5fYLSlNizS?=
 =?us-ascii?Q?5/pn67eWNzEF8Lbe02vVoVYiKBSyC+Io8CIhC+/H+16VzXQtcfpbf6HUKKbH?=
 =?us-ascii?Q?jGKdEaVhn5c3tvZIz/edoJbVgFwtEqskpZmFMWE3ZL7QkqpRjM65l7onKMPM?=
 =?us-ascii?Q?ngeFtWvnVLuOmaf88rpYB+2+DUeApjOcCby5ZnHBFGFUuERWkaxSb8hKZly4?=
 =?us-ascii?Q?lRw5Ck2F4tQaQlA8HXhzm4CXGbUv06sMyFjA9qBnoI8FcWd95ctzUg1cr8B0?=
 =?us-ascii?Q?dUA3/ahy8ZmoyLMdd2wOuRNp61uKNa7K9EDYG2fRx0pmM+CLMA0vJ61GFzEN?=
 =?us-ascii?Q?LrSVaV6UTDNt5HBia3ImR41RGQgr4Ard9TVxanE0fCsqm3bmJi/9pbgDC0yF?=
 =?us-ascii?Q?x0sBgZF3eMn04OjB/1m0WIhHdjBDTBo7KS+kPqWnQOMdD5R36NMhuLK6Iw4W?=
 =?us-ascii?Q?QDdX1b9zsRvPVRrmtvzLkRZdURnZZAqEGLz8TkYU78cxIJKCbLw00Wh/tCeP?=
 =?us-ascii?Q?P4a6OZ69WZzBsvTfh2xh4OTx4ovOfYAA67qf77Im3VAkjUbp35mmZMaGvtMr?=
 =?us-ascii?Q?+1k6zYE/+zDzLfAjUbpAMQagjS28/Ad29IIGDn5VvLgv0YmwUNCAmoUYptnm?=
 =?us-ascii?Q?J7HfcVUOyTlRVB1jlEoY0qKTo2o3+P6zatKqHn0qprisVQUiQ36Wgoo0ZPP2?=
 =?us-ascii?Q?87IflPLy5jlEHMfszgDdzWC86BXHVWPNJ4OPKqeiKx4VRReIIM+Thvt1EU07?=
 =?us-ascii?Q?bBZ2LipwiIW3n3efkOvVPQFoR26hil+KvzWutPStHy9mkS6f9jEnW+Ayr0yQ?=
 =?us-ascii?Q?zvEFZinE7eHh+B2Eg9QuUkMKO2nNmgoJccwHUAZUjqf19mibQE9Kl4QViuyc?=
 =?us-ascii?Q?mgaDztp5zTmKUXd98nMdZ//Auq08Os5IOUVFG8L1m0g3Z2EE4yed9EffJQBT?=
 =?us-ascii?Q?3K/iU54ckqx+jSvdS7DDLAG/cfoE8sIYAmuG0+1+rLyRknBGAytZi+Pdr3Be?=
 =?us-ascii?Q?9E/Od+/ZImBmRBBw8NLbViZZkrnUIMgDzIeUCsPAUdXUPat+folAwS62+8A9?=
 =?us-ascii?Q?BAdqDXGFAnS6Jg2hUmdkSRfs85OH2TOtB5Hqi37hSQM+psPDxlHImzndUmrP?=
 =?us-ascii?Q?Jpr8I5L+NoWLYMY8oTcuwn30nIl/ejGzjpyBzFnEG9VMFBs6JqR2APhZ1zcj?=
 =?us-ascii?Q?G9C3khn23LCTL3grjVhdHuJpQn2lEfedFkyCs9X1gVfJpZREeIbtnujgdUjQ?=
 =?us-ascii?Q?eCxyW5oEj7RGbUVjca4XWeaztD7Ursm3OBUxe/SoTMs1nzvTf/i3Dx2B+w2W?=
 =?us-ascii?Q?bHdO2+O9HHRG7BP3sdHrX684Bgj+1mf2BgpqR+CtQyLKLL0I+8CHhyhrZu+l?=
 =?us-ascii?Q?kn7grZBBh3qzwmgYUB45VASKs9utExBy/5bz3gIOSVXOIDsdQ9wi6h88aBRO?=
 =?us-ascii?Q?nQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uVvYqDvPp0GbouWqwJEE1voOEd/0nGZRempX1cju/AwzC+CtAuYvfsM+vAy3WWy1VbfvmVYuaGkex7UTmdonfCu2BW8kYST1h2a+91GZ/qPj3ljon1OArjaDs5bZrJCVYDqzetx9cLGnoz8Q4hdpgjSkXK0OEy4GaaEheSYwQgfXROCO8oO+iW1jFGi7Aa2gva94fCsTn98+AQ5QuEqWtH9sFjFN0n4AzihkWJ9nNBWW8o1w+XROl/i1tooQfLVsimaQpgrxGbE/BSXgC1pUQkJbrXZJQQLVRLKP9uHxXXhhR/BL5lggZJ3tNK6urVpMcgPw0oLy2dLDwCla+6pqI2BKsi4GzUuvFcywRmBtO+tuv34+ygAjyTQ5QnsOXBMhpVbtPC/RlA2/1bY6ZQn3n3XV64EUG5gs7Ja5/zxxB+MNs0onOIUpgJ5JnrcrOb/tOoVeKDJojHzQNzgfoPtkDM6rsGe7Brb/YvP0WJf3nUkkqr77CpdWprwy4ExCyVoITFNdaIjMDoUQdi1gaQcxp/JJoyRfSP1ozXgVZNROggSASg8STrvAdSxvqhbw4Jh5Xewpgj9OgdbIZ97JSzkOz6/m/ug+XobaF1yqjKBsiWM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87f9d9d4-b0ab-4bda-c80d-08ddae436ccb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 08:37:57.1096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Z0cjPxoKg8gyh8cmY499eHFjhMnnE68rcFRRSnerakoPC9NovNn6iCVWHr1/zUW6wkz+/xdfmym0dOlns4gWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7769
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-18_03,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506180073
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE4MDA3MyBTYWx0ZWRfX/9MFbkmQGh0D 4zUZ6pvl5uXAhsc7B4IdXNmG4QhIWrnFbQXTl7NDyoAn3sg3rox39ktVzgfkEJvkU/dKzK/1OcC TtrgYTOLyXkioqPZOUf88hHTCEo+N51UD3kxKgSDwPiebDn5AvHJ4TaqaCAEmUjiI4o5WTdqndd
 JeXxwedv0OqUwQ8A5IEKk/1PBXjvth1wC/K0ljBMbBv9SBvCHpNQtkqCRuKugJ0gwnnMHii6zvb QdBLLTooo00xWCQXvjotyjNFfHjDlsRxlGjS5zrqlhLN1LqNA2oaSYUTjk2xD4C2asuIvvJx5rE /2CgfzEyfn2o44y7DrXlgJRgqPIZgqj5sZM8QE6B6NHun7PDhiu9ZphAlyqGLgBtZLD0ZXl+BeM
 dufLD1L7HPnEvPQRiK0r4WoTVhILECGk1grZDOWKW9yI99c6uZ1Yv23YyQYlMXnEzwrAVLDP
X-Authority-Analysis: v=2.4 cv=DM2P4zNb c=1 sm=1 tr=0 ts=68527ae7 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=DqzVqx8i_IFAgmWpyL4A:9
X-Proofpoint-GUID: xi7thNPY0QS7HDXqA2XF8S9xDihOXR7s
X-Proofpoint-ORIG-GUID: xi7thNPY0QS7HDXqA2XF8S9xDihOXR7s

Currently we just ensure that a non-zero value in chunk_sectors aligns
with any atomic write boundary, as the blk boundary functionality uses
both these values.

However it is also improper to have atomic write unit max > chunk_sectors
(for non-zero chunk_sectors), as this would lead to splitting of atomic
write bios (which is disallowed).

Sanitize atomic write unit max against chunk_sectors to avoid any
potential problems.

Fixes: d00eea91deaf3 ("block: Add extra checks in blk_validate_atomic_write_limits()")
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-settings.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index a000daafbfb4..7ca21fb32598 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -180,7 +180,7 @@ static void blk_atomic_writes_update_limits(struct queue_limits *lim)
 
 static void blk_validate_atomic_write_limits(struct queue_limits *lim)
 {
-	unsigned int boundary_sectors;
+	unsigned int boundary_sectors, chunk_bytes;
 
 	if (!(lim->features & BLK_FEAT_ATOMIC_WRITES))
 		goto unsupported;
@@ -202,6 +202,13 @@ static void blk_validate_atomic_write_limits(struct queue_limits *lim)
 			 lim->atomic_write_hw_max))
 		goto unsupported;
 
+	chunk_bytes = lim->chunk_sectors << SECTOR_SHIFT;
+	if (chunk_bytes) {
+		if (WARN_ON_ONCE(lim->atomic_write_hw_unit_max >
+			chunk_bytes))
+			goto unsupported;
+	}
+
 	boundary_sectors = lim->atomic_write_hw_boundary >> SECTOR_SHIFT;
 
 	if (boundary_sectors) {
-- 
2.31.1

