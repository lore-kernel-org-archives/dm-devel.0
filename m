Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1355F1D63F0
	for <dm-devel@lists.linux.dev>; Mon,  3 Feb 2025 19:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738609378; cv=fail; b=EuC61HGcyePrstjHPXCSXN8KzOmCW0YSDYyB/d0/JauP9tpJxcIzKgE/hqGGNHK/md6SYAF+8ZJE4pryLTbqNbWpTEu1qxgVHfgPyTB0ZaRnpofPIsfOQF9tjeIUEi3nY7g7QXK3b6B6vOVVnX8P5W7JCPfDcqNMueUJrQEA0J8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738609378; c=relaxed/simple;
	bh=GCxT7zdy6ddxCkgi9180U678blMlOHJcm5asCfeEAGU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=FdBhSnmi1RrMMuOzI1zs7wp+FuAZupa+ic6y0CfaPlJHw1pdO3xoq7IJADgAQv7yDlhd1/0YQhaykrSzzrvSi0mMNQLmz5puxpYYJPYk15oaeuhjPuFc/FjA62HrZmA2shNR868KcJRa+Q3b4k9ZEHBOI3zoi1ZoazAtpFl8L1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WGS6P8wr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mrVx/hbF; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WGS6P8wr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mrVx/hbF"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 513HMn9X010859;
	Mon, 3 Feb 2025 19:02:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=qIeVMAeFXQgom7cHs/
	31Zlayt4aRbPzLbyvwYkNTpRU=; b=WGS6P8wriVHx/62FGKjI+K4sSQmJTumVqu
	HrP/PAqcSzQ7wdGQsoMQqBHrNAER0KCg4p+wm/dUvX+dlSTWGIxsenD5TfXlH1kq
	WBv4HcSRU5ixvNGAMcb2waWChdjocpmYaKuNnpIgBBi8EYl1UdXwTLP/MxWp96wd
	nOfS29bP2cBvTETRVySO9f0fElpnUH3YfhlQx6QFoLU8Lgf3740KW92/MjDAQcdV
	MdIc4cnS5g9d7Cg45mkielrwoBeD2GTN/IbiiDHVzZiktUC+5b4ONllDpS1+qRYj
	BMwWf9ARkJQ3ANq2r9wgKU7G3ay3fI37xuHAyj53dZLcLeIx8u/Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hj7v38by-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Feb 2025 19:02:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 513HpMbu037814;
	Mon, 3 Feb 2025 19:02:47 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2046.outbound.protection.outlook.com [104.47.58.46])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8gg11ns-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Feb 2025 19:02:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g2zayKDR69l4SbtbqzQloEBt3019ZQrc/NJot/lZ6eu9ON5hc5pyHFjFLqpyUdw462KouaV2q1SEnAkbXkjVegYG22rQNj6OZufGM6RqFiRlbrVJl9ceEC5ERkedPPm5Jj346klRBMK9evdFip3rgsSFxCCAoy4qTGCzpNbBnDxhr2EFpTkWXVR2NsU6a+FmQBo1ipXkwSv88NOiVIpa5JoqLjuEg1riG2CrVchFHLUd+vkbD36ANtKcS+qCG5H811codgZr4QqmHZKrn5CrQaPPUR7qG27Jz3uVvC4yJQi82Ex7x6+aenNIC5x+PyCAHLk6iAF6IUNuFphA37RNOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qIeVMAeFXQgom7cHs/31Zlayt4aRbPzLbyvwYkNTpRU=;
 b=ibJelupgq4V5SoN8D/TAhGAndIyyGm4fYY/h2/y8ltWhSYNneFjTuwZt0O7QtJl4GDVBYRIVTDD6LSfkfAJmBWf0rMa3N7FrB89J40tkR4LUSoeHyOWtmXxv8GssCk/Tf4oPVPUqcupFGL0tSa2Z2vDeyjZs4iScwrGtLofX4UNDBBXjX1XPQPSNJWMCwEMkBcK8bZfrKL5/GbP8xoZWQEcPkoDHp2kS9JGNvBugQXgCChJ1v0Zu37g9JVJsL5IiXpDPVIdkIrZBck5HdbuBwbac0DO7pEq/Fxrl8tHmsy79jFFqCvf4BjWxsDMl0KVykk1dWDuqTFl9ct7jg00sbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qIeVMAeFXQgom7cHs/31Zlayt4aRbPzLbyvwYkNTpRU=;
 b=mrVx/hbFhdkD9ou664G9UmPYKL3bTNDuUSLci7RtvLYYEdw8SwDJQv7SfwQwunZJQhb+uS9fVOywcqnmsqgURc7PN5lIoyLWKt6jnB5jAaiwayb8sk35LtGj3gxFSqcTn13KPVAgel3aT0MdrHzW8eu7yvSfLDS5MpnaF6JMOCQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA1PR10MB6518.namprd10.prod.outlook.com (2603:10b6:806:2b4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Mon, 3 Feb
 2025 19:02:45 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8398.025; Mon, 3 Feb 2025
 19:02:45 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Zdenek Kabelac <zkabelac@redhat.com>, Milan Broz <gmazyland@gmail.com>,
        linux-block@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: [PATCH] blk-settings: round down io_opt to at least 4K
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <e53588c8-77f0-5751-ad27-d6a3c4f88634@redhat.com> (Mikulas
	Patocka's message of "Mon, 3 Feb 2025 14:38:25 +0100 (CET)")
Organization: Oracle Corporation
Message-ID: <yq1cyfykgng.fsf@ca-mkp.ca.oracle.com>
References: <81b399f6-55f5-4aa2-0f31-8b4f8a44e6a4@redhat.com>
	<Z5CMPdUFNj0SvzpE@infradead.org>
	<e53588c8-77f0-5751-ad27-d6a3c4f88634@redhat.com>
Date: Mon, 03 Feb 2025 14:02:41 -0500
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0852.namprd03.prod.outlook.com
 (2603:10b6:408:13d::17) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA1PR10MB6518:EE_
X-MS-Office365-Filtering-Correlation-Id: b64765ee-b51a-460c-a6d7-08dd44855799
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?p3zD0TgblKiRi4SGDZnnysPKReNLe0hRZFUX5+R2z+kmqgLm8C+qculpaCbo?=
 =?us-ascii?Q?lS2L24dvtQrBv0BQKbvZRxieBd/LWSgJTFQpDJZ8hpDk56fwPIEtjHkWHSqk?=
 =?us-ascii?Q?244xSN5TH1naS9/6zb4RbB/dbuEKO8wnSYa6JYhm0Bek/aaYUGKGpAyt0ZGD?=
 =?us-ascii?Q?IVrxTP/2hgYbqyOdk3p1syr83NFPaLI0zqW/U7/b40k4sPriXMh9R6FfgiV0?=
 =?us-ascii?Q?aUreuRGS6VnDGDSqqSjIShXwlM355/GyTNIVplypcZ/mIMfUnLZ/q6MmIqkx?=
 =?us-ascii?Q?OrxeAveIGofQECsjtjvaYnekXDZ4jh/uFeueZt44d7CzYzmgLnj/O4/S3C5V?=
 =?us-ascii?Q?4r+AFKyYHtQWmDH9ULSh04WUCBW9ajoWZvIBBe0jLcHLb9EMv4Cvo/eSe6Xd?=
 =?us-ascii?Q?9WACzANZgycHgJna/73LFSXFzHqxu/thUc3KOvjWWQvNszF+Yyt/7h2vaKJA?=
 =?us-ascii?Q?4vckm8OGzIAe/bTkk6h0kJ11vVjkD2sk0tvfY1oPHhfZ7ie6v4f2sTEfhAem?=
 =?us-ascii?Q?qt3PVgqcfDGp4N1313Ro8B85UCbsWJHB4tV9NEya11I2HPTzAtwtjWJIPhaH?=
 =?us-ascii?Q?sk6iIE3LjR9xkynh3M92siRUYG6K8rjgE8ZYBjUV4rchQDzL+5rBYXgfmHhO?=
 =?us-ascii?Q?Terwb7IcfoBYRGQ2RXzghNDm0vRZKsoyVZ1e+xrQWx8+u+hZ0oV3ytKPOvu5?=
 =?us-ascii?Q?hurZodJaPdMknJtMXTv4EyzIYzXBxC09ZTpbmSoOn0CZRMWgmKDzc2EJSw+6?=
 =?us-ascii?Q?2LVio9rf0fll4LMUY8gu+wkTLzzLOE94ErFUTtevqcq7v9ZF5OAMKQFsxZIF?=
 =?us-ascii?Q?YJ1qrYV4eQFsngAKdI902ktuyCYpGZRQz2idttvEvN3w7NVBAO+i+xDaCg07?=
 =?us-ascii?Q?1C+Z2GQ5FIelPffYdP/p7s7fhetew2r5XdGRY/ZhHZKvunPoXbsLEoZNj6DF?=
 =?us-ascii?Q?JbrR9gqhuWHbVE03oG6yUeMMWxk0TIKV4uPuMsb/ukQN4477PAN/Ishd272k?=
 =?us-ascii?Q?AS1I0vbAB0EnOdycARcL1hLuuqHQnZuQAw+UFWzrlrd3BvqnEDRWLK0b9eD0?=
 =?us-ascii?Q?j/L7u4jWUEaYv5rO4oFsLJ00VRHq9dp3A6wq73YkB5CoJXPsGfWKHWoFB1OL?=
 =?us-ascii?Q?UnyZDZ+UAQulaBXK1UEWaAuIxF2tJHKqFHPHBLl12wjsdyND+YWV3rZW4UE0?=
 =?us-ascii?Q?oj5JNYfln4wHxJnWewtP4OjM6PAg71Pnrd7+M4O4FgVGCTAHtN8RPr/nTaIx?=
 =?us-ascii?Q?lcmvoLpi/CYfsQ6AADT2dcsnlGLJC3ZV9BRztR2EnLesZpk8yBK3cCrTgM/B?=
 =?us-ascii?Q?R2Z5id1IWiWCbqCVH+SRXbEoB2oQ/VOkEnm+lpIm8MetUCDDDSEaufq5naj+?=
 =?us-ascii?Q?ZOryddsiPrK2cGyF7sO5CJo+lkSb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hqzg8pFuHgCsXU+zIxg5LoH2Y2L9LKQJRstJOqaPT2ilk2L0IkCmluI2XqJh?=
 =?us-ascii?Q?iNh/xm7UWR/HjeGi7jI2mBOMB7ABi2irT7NfBdvBYhTIuahQveNsI8xUKrkz?=
 =?us-ascii?Q?HDcDMe/dWpem1xqHZ9DPzWbefDnXaUYXqmYgA8HdTd0PkURnBwh3vq/PBXyg?=
 =?us-ascii?Q?/TfdkucV+8+//M/efsAWp7GFTNfW2+RLFuV6M2z353dOGkCnWakGETKAdpNm?=
 =?us-ascii?Q?l4dVFhl02NVxGLXQXJUaiG+BSv/0Erw+48pqxceAqI1YddQoA3/h++0BrVcY?=
 =?us-ascii?Q?Nd8op7Im7JqcNWRAltmtWQbCTpvl0zXn6JAKUVdJEyzfbOB24StaErYkpP5N?=
 =?us-ascii?Q?Lek5jIQxaxk1PNFN6IX+gLAfk7pnwoDk9TVXDQOqRbM/aD4/6Fv+Vva01g3H?=
 =?us-ascii?Q?s6dLZ8e4Q+guGNPJCEkVBaMxomjJ30HMrt+Ujq5YMmQdrHP7zHo2FkoYdI21?=
 =?us-ascii?Q?qqsERK04SIgO5prODs2xkp0lC/6pVT5iglnG29Ydhcy/hG0o1sX64UDg9EXf?=
 =?us-ascii?Q?gQO7x82Wiy428ubOfaIsa/MTeicid+K4ne7lvJ9IT8aJ5hjPBV6EeXBW0B8t?=
 =?us-ascii?Q?d+quSget1M3uqb1vqupORNYwUVVFjdtz+8EIl23rUWkO2vvnDgQtyDpfGLUS?=
 =?us-ascii?Q?XW+q9auIO+D/OHrsHSD9yrGcRcnzyclE8nhXmVJLiViDTlL54gf+z/IxpcG4?=
 =?us-ascii?Q?tqafp4dnb2rDDRFJ88nW6YkJ3glloYDuTeUJa9jLi3rz4H9Mzv3Qo5LFQXbq?=
 =?us-ascii?Q?lz5OVETj2ai7r+1k2E9OSJNQiUV1cVXDEc0e2ah5+Of/dqOkIH7dRDavQg96?=
 =?us-ascii?Q?UaUI6V4FgKLX7LAD2OuDmYOA5TiIkScWwrdV73ee8a2p6i9S7Bf5ZIQ80670?=
 =?us-ascii?Q?QUkoyCUf5DTGCgYa72CmJiEMcvWJ5HEHxKlF0T5uiXIkkJ8KDHVdW5vNs6Cz?=
 =?us-ascii?Q?1ghLbe6BWBVZeHbotvETgS5Vw/XefDqOMj3c1a8Th96XFmXkdJz5b8W9dnHN?=
 =?us-ascii?Q?yldaeffC3fzJm2q4zVQ5HAWGE1sGLKRX9U+0Z7Yn9OskPwovhKUX3fkjQhDv?=
 =?us-ascii?Q?jzjlvpKX7DNOgME6f2m75ljW4QMz69sQCBh3zjPoy3hDUTdwgga1wpDRUNuY?=
 =?us-ascii?Q?mqXOqN/JXwNT8EU6SQk72s90MUYhQlpH1n6Hcvqs00UFzahnLzj0W6N+u74t?=
 =?us-ascii?Q?XajU8MmwTTp08OQn8Vi1igwy1aRsU9KCrfGaPLYlXiEKNhKCxGe+kM1Slt0S?=
 =?us-ascii?Q?dkoDYqXMiJIm27+Gjbily1O5noc/fxMvMwja2Z91UwpdHmXkFu1nbIVD89TD?=
 =?us-ascii?Q?SY6D8YbMHlcIMxR4PePpnThP5YFs37T41MgjkFG7eQrYNqmbAzRd693T4hzl?=
 =?us-ascii?Q?blpn2fqEYYMPKlRHShs+mZuaMtGBLFu3P8pzcmZvDyBmWV3kq9rA6Q0Q9TiY?=
 =?us-ascii?Q?zW5iyK4d84ey2qFbN7lp12URYJRzV08uQHESoXcN1ZSmuKM/cqL31/RXsDpI?=
 =?us-ascii?Q?rtG7Hy8v7qb4GR2fOtE2lVQtGtXWpnZDi3kMIadjAQ+EQe9fSP/su1O7yF8W?=
 =?us-ascii?Q?JeaNhWtbk9R+u8wNQWNb0lrqGCY44tovewAMkMdECOHR8cSuUj/tKu/igHwa?=
 =?us-ascii?Q?zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2fhsPmpchBBtn4JSHv3XDT86wxLY/XHNHeXKmc+k5GQd6mT0Bb5xLxM04LMFvk68RLbHHviR0eIdItb/a5spfawLHTGZ11IpOD00eTc8J8Ta7oTiO0/TLx4xHeSJrVtQPTdIxhKwx6OgG3bKGds9Wuu6bBV2IRlRzUSegSRViz/+kzf8HD2/BWRiNVaYyTnLFHaNPiD/Qj+6KYQMQYppbDJA4f+37lJeZlP5oRoqB+Mtlvds+8h21H+LYR4BMP1RVX/kyAlRB3tZzE2XTqtgFZyGW4QEGMmKW14YXxx5Bom9ZMe430KTEOzgU7JRB1diE/nw7BBKHvQAJdfIGlFIdgiTYN38nI9zq+TrjUN0J3nvTBeXFG3vR41Bfl14RLx5PTAkjpRl7VUU7s81TYbXw4vA+i6jSw8v7zwGdmLnSh6S9wcdG8U8CaT6E1EiIgW7ezTlv46EDuoK945uFxqwRPIL2x1nLvG7YkYUuqIFSdJGoBJsBppxbC1gW3BOkODOrbew2q8tV0u5AAkErVcF2oqr4X43vv36uXtylmiJd/47IDW4qEbANDy/XgEo6MHcQRS/WZBX7KCmnfhLGJood98rI+w2s5IKdDj/PDzBUgs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b64765ee-b51a-460c-a6d7-08dd44855799
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2025 19:02:44.9327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sA8QlzaK9ohBY5ncfACU6Q5PnVwHu5r+Pvl2EAVVlMHgv4yLmcMsCozSxqpNE2LTEx9WJKNPaGRu77U5wcdxqOf67g6FTJsWn604x3wIF+0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6518
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_08,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=748 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502030138
X-Proofpoint-ORIG-GUID: BHzBAhN7iVOynUirUb0GGME_PqGjOd0u
X-Proofpoint-GUID: BHzBAhN7iVOynUirUb0GGME_PqGjOd0u


Hi Mikulas!

> The purpose of this patch is to avoid doing I/O not aligned on 4k 
> boundary.
>
> The 512-byte value that some SSDs report is just lie.

So is 4K, though.

> Some USB-SATA bridges report optimal I/O size 33553920 bytes (that is
> 512*65535). If you connect a SATA SSD that reports 512-bytes physical
> sector size to this kind of USB-SATA bridge, the kernel will believe
> that the value 33553920 is valid optimal I/O size and it will attempt
> to align I/O to this boundary - the result will be that most of the
> I/O will not be aligned on 4k, causing performance degradation.

SCSI tries to make sure the characteristics reported by the device make
sense and are consistent with each other. If we encounter a device which
reports something incorrect despite passing the sanity checks, we quirk
it.

But I wonder why we're even reading the block limits if this is a USB
device?

-- 
Martin K. Petersen	Oracle Linux Engineering
