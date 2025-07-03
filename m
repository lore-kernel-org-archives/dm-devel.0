Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270C72E3B0D
	for <dm-devel@lists.linux.dev>; Thu,  3 Jul 2025 11:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751543222; cv=fail; b=kBrzp/5DtpsoN+xNjyMXXyfl8CIEHvmyhQzgC1+M719qEJat/a8O1UotfZFnNnNfVjPCt3xG1S7NkzgAknesJBzfoRlsB/YqLUYi1vChWDXFWaQUvtqv78vOK90DzXafKIXp8E7orW+jgYCNeRW4c3KjrLZ2QZCce1qpVvBqaIg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751543222; c=relaxed/simple;
	bh=p9UCcmm+ANgfqAnOUuHcXHgeN0Y7H3jieS9w9sFJ8zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YdOFk7m7QO0Q9iESfgUsjiaD8epDtd786fp18SPZ0uVjjEID7p/+XTa5UlD8j6zp7Pulz5lnc6QJmak6YEiUpf/BqoLnK9FYX7QF4MLOVCXzZX+uTXO1NyLItiRgJiZPhtMTXNG0lOdGQOjXj/d3+4FkAayHzVY+jMNKsmWpIMM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Am4DjK3X; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JLqZV/eu; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Am4DjK3X";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JLqZV/eu"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5639YqbQ010167;
	Thu, 3 Jul 2025 11:46:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ERvNBNTEwfRTbqyz/YjGksu8/iU/KI+sD0DNrg3kzGI=; b=
	Am4DjK3XIugydFBnAXpRovtyd+X25F5IeIUn0PC8dJHCwrpx+AFwSMTv0eeeYif8
	qnj6IBsIefpRx4vDqrAqHPFAIZgIEZ5UDgEGZSgWb/V6sUraYiKvFH/0HngCKQ5a
	fhK55NZyG+DdtuFqNv19kBI8Rj/Y3H/TjKmkWjPhn4rZFWYtz+0YCK7aaOxdyCgW
	dtiGw2CK08Y4kzHH8VvE7t4QFigxktCtg6Ndoa9zxiZ0KIqF/HgZVDIhdsoBSZrO
	Wb5nSdLAW/HxSSRKRquyFEyf+k644z3wuJq6sXd249Z65w2Cy+SuDG2Whq4uArj1
	ogPebDF+T1DnRgdPvqlxvw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47j6tfgshb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Jul 2025 11:46:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 563ANXW2027469;
	Thu, 3 Jul 2025 11:46:45 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47j6ucgj2f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Jul 2025 11:46:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NFrxTLJdcWj5PyteMHzooUOHdWyrupYcXBO/WYwj+5uPSnAc7JcYJySwsdjs1TSHLttx35pfZDXICX1ZNvnbjEllr6rSosFBYrX8cSqUWElMdVaqrCYXNeJigTn9PLljcfivp3N7HaDLdPPueejr2JS/weM5spprEkFggtUUBqcKE18ivAsEV12JT2DEzzfFKCcumobJk/QXu1q21oqoWF0YFmwPSKeQf6ynOYMoghCz67GhTfOK3PZt/SF1QcnJROqMSS4hXj1maZLXYkBZTpXZAYhA026kh3nlKdxW9RSieyOY4qDFTjHRfPceZTepuoaeX68QdBsbChv0PtxiaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ERvNBNTEwfRTbqyz/YjGksu8/iU/KI+sD0DNrg3kzGI=;
 b=DbuyUqvaaM38Rw96BBZJ7laiFJ7mILkSKRJ7y3DJWmavYrUYRQ4EWhyE4yIHj4JFeR32b1TzwIs3EBN+9kgkJ9ZAx7vOM3PYXRDVpY1iND9paGbCu37mxi81atvxBJDkA9HMBbE9rUVyFUuXxm8qK088MP4Q6WeY36jVbRd3VC8Ngy4366IfffcLoNddmSTzkevLMtdUDNx139CaA1hq+SDXyfOozbUEjczx/NxWMZjTifmP2zvjyfN4gdd5PgeMo/GAyuhwv4AZ2uf15V4+jkpEfuhixpfkiYcLtkJE4gZnU4M1t2WCBb07ouFEjxwc7La3lWWgQjRyUGjIcIsUfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ERvNBNTEwfRTbqyz/YjGksu8/iU/KI+sD0DNrg3kzGI=;
 b=JLqZV/euyB9gMRRY8v9JEd8rDa81txmbmu30BlBoKEBZaslaCBVgq5Hb2DnY/TDVNflblJf8vSaqja+BYBZE5I9mkE7GyPff6i3Hg7AXSurPJAeCvPHtGZfwSwhTE9gCYvNt1mCU+uaPU66K7+ijMUQkW+7YU0XPmUh5jAG9sjk=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH3PPF262994532.namprd10.prod.outlook.com (2603:10b6:518:1::78f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.26; Thu, 3 Jul
 2025 11:46:36 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8880.027; Thu, 3 Jul 2025
 11:46:36 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
        song@kernel.org, yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 1/5] block: sanitize chunk_sectors for atomic write limits
Date: Thu,  3 Jul 2025 11:46:09 +0000
Message-ID: <20250703114613.9124-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250703114613.9124-1-john.g.garry@oracle.com>
References: <20250703114613.9124-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P195CA0052.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::12) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH3PPF262994532:EE_
X-MS-Office365-Filtering-Correlation-Id: b5e85bec-92e8-4d38-7d08-08ddba2743fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eH39S/ASRfQV3dk2AfCKS9Y5MnZgSsj2tXU1mGrCHovE1e+I2n8Gcp6VzNDv?=
 =?us-ascii?Q?M730CSsgcS+Y7662Zg6akfHCDMrJC6DObz9OqEi+udqVbvRQE+y7FNtqL3hF?=
 =?us-ascii?Q?xIMGNU3NbIJCR2GQPy13rCfLRj/xRXqVB1bv3EK8dU4oYPC7S1aoGHffn7pz?=
 =?us-ascii?Q?PgaFJngJXJlHLi4L2rFLIz2K1vyzaBRIQTrSrdpDtA9+lwLYZb0q3+oPE9Fm?=
 =?us-ascii?Q?AptPwPfKZQ4VZF9i6vCy2rLbSCzVqmCJm1Wgl6zFPDgooIkM0mWea2vq91ph?=
 =?us-ascii?Q?REdXWeVFgYWYxLNxbK6dLD/aWR1WPn6U2Sccy6xo0CIRRs1IOnRgijrEGfZ4?=
 =?us-ascii?Q?GDTe0VpFs7XlEQT3SWmHhNMSP4DsnXZ1uebAQquz7HoLO3vOiUNrGcptWKB+?=
 =?us-ascii?Q?qUKPBcRK4PI1GROtDn6TyBeRDS6BR4lsY5QxFMMV9S5vT6AC6O262jwR7cH1?=
 =?us-ascii?Q?CnhxDTqCSmo6Gq9ivG2zleCm/bN79V3xBRdod3X7EB+eXiHoo5iIp8tt0ldX?=
 =?us-ascii?Q?jv0RBKlL6F98cuugsDAsCwFYQpfTLdopde+Tga5EleHwb6D5vK0aRVxdG/8F?=
 =?us-ascii?Q?o9bHBTO9YwLN02CiaqxRc7XABiXExDhNT5hyrVDJ3qHI3cVau4w0HKcSw2+1?=
 =?us-ascii?Q?zvO3zwyT8bmHqoWcCfgZ8Jmm5tdZ+CUGmrmeh4NRnkrtx8Ht2mhbwGQ/Zai+?=
 =?us-ascii?Q?wVuUTK79tGMkG7RRsPIfRVR97dWK7jzk9ADa3MWSqRtBHeN4UZQ21rFa2uyj?=
 =?us-ascii?Q?hDn79SrIc3G3Q5a4O+z6QScVZq28XuM8afo+N/wSXw+TvwhaY0TibHpfzkur?=
 =?us-ascii?Q?H3WFuWkTH+73I0kAYZJIHxtycI6bCn3XbAfikrldiCBKKuhZf47MZXWXKiBs?=
 =?us-ascii?Q?1iw1TkcwYzl8Dto5tGQHjLXU78y8nilodmqFrLH5rnnF3j5Am7Zjbxsrmpki?=
 =?us-ascii?Q?Kww6XlJPaMSGJMTiW/VhDggvhCgeoKKihBwl7u0ERTG/WvKNpUr6UHa0AYt1?=
 =?us-ascii?Q?TKqIq1Cc3SOfAL5mF1NJorQAczfEIMpeQ+YupTvwIC8O7jDfl19E27MnIuJF?=
 =?us-ascii?Q?mc7p5ZD4AnMyn6EStnln2PsBaFWgfs5amcdEamGqJAoLbXJl31WXJl7n2hAp?=
 =?us-ascii?Q?gGgTeYKZmsfj6//WEuw1LudegP22KwpwdAZXto+HRlApPtoI2clP2S6FGmXl?=
 =?us-ascii?Q?xf1Rxipmnq5nngOEuNxioF7nFYdkdSEkMQnvVyBl2MiOTvS2Un71gwDY9ieV?=
 =?us-ascii?Q?vTDljdbsgu/33e9cRgJ+hUkblvMb+LefThOHmcNeGi+OQYtxR2aM9m73itEk?=
 =?us-ascii?Q?H89Fg5BHxeKX0cMQNip7W7RxAxHCoS27LoVD8K1yyv6R9aJSHvnsNjogIYTt?=
 =?us-ascii?Q?GVpiP3bRaslSCwkXJQwe7FdmGJsfJ+QjgJDhFt1VFoeYao6gZBVEKCkXOKNx?=
 =?us-ascii?Q?EICSmhodH8w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?muZ6ZCCTJYUpCpObgRcFiWArJ318qe5cfTCdXOGrBbZcr+7h36GLGKUtZP0b?=
 =?us-ascii?Q?VwCmPBhyfd0Q2YYiz8ZqaLlhkyJRpdmu7vF71JFVr3UUNc5j/M8hOXMjERul?=
 =?us-ascii?Q?jXfGiM/13gfI2J2vIJ+fbFZEb0CVzgAWdkV7RRLEL4H1ixRiSw8NfOvb/Mvb?=
 =?us-ascii?Q?zAZBQsoj6155wq2CpKs3HnMQ3y7uT1/YcD6YlZVzDVAjXYMs0+u6RxNJNmHL?=
 =?us-ascii?Q?mFAkvJEMkMEf5P+hizzcMd3gYs7VjOMrhWNu/t8md8xUgnwMLnC4gvbPHsfr?=
 =?us-ascii?Q?dRpDAs6QMSDnXxN6D4dH4uUIC9VOJbhQFVWmcRo1HMmH+rZyLPRLuqYCNzek?=
 =?us-ascii?Q?j9QqASVMOU1tDJP3LdKR57D/BQtnvMl36DY6A1cnWBz7HQxrr/vj6fveFIIf?=
 =?us-ascii?Q?l85o96BIs484TnY2ZTbENQnnncUf3tfpt0y/HlvGT7SRbTZhqv6ws8lSNxDh?=
 =?us-ascii?Q?vqBDovnV57V9YPbJQDTx0ezjnwnfXEyo4w1HFz6ghf0jQyAjYu1ufO0nzpQa?=
 =?us-ascii?Q?G1/p7OJR7J274L5+A11bsbgVGvh9UFA2mvZfRZY+WMxW8EuBl0hOCqA9RSMW?=
 =?us-ascii?Q?zkfNLsXfsj4bXUfRrYH7s7t//4+LtYYkkCMPNYM2sWp08b2chM+8Xiiz3rQH?=
 =?us-ascii?Q?A6QWPLQ1txVMnWFkhbZRTIgLjn9s7w3+sxh1Qe2lgtN5nDXgq/CIcGf7gvsf?=
 =?us-ascii?Q?Ilc/Z2hf8WQ4oMjEKzee119gERPsw1xxTbObILPyLIxylT4LgQaugx6pmKmE?=
 =?us-ascii?Q?KpnviTaH6I/HVjA8Zmyw6eXdoXpoYuwia0qPC1o6ASJEAJED+qH6k6K7DZkw?=
 =?us-ascii?Q?Gzba9F7HBqvbdKbCclpc2xO8T1iJrq7flPclzQDUF13IZ+Inj6fXgduwXCz/?=
 =?us-ascii?Q?rgAZB7fJrLJs+i1XzTtMjYoxwkzZbdHuC9SSfPGl3NPMgiA+1D6PFKh/stbh?=
 =?us-ascii?Q?Ox6cci6fFpYFj09coeGE5GMUW6o8hCv3mjpvHndSTEdTxclyPbDTew8xQYP0?=
 =?us-ascii?Q?UZ1uVBMTZp7aJJkHuBs5SAhxuBz+feKnioM913y96Bdv6LQwKCJgzOVh4TKz?=
 =?us-ascii?Q?LMhdOH0FMC2wP4nJ+aQykN2efrtOHZyPOR925gpDy3pwY/+4YTUBcW4ncmYK?=
 =?us-ascii?Q?6RhqIUEjfTEYF8HDJuAYtZU0GHzPuHrsJ1MYxVV3ZK/JU/LILqBDOuebzVKn?=
 =?us-ascii?Q?kTD+rDcZMIgl+c2vM3Ed9D/4ERKN2BadZkbCPeqyVn7PD4ba0XZVKqqxG5aw?=
 =?us-ascii?Q?7+OW8ogklP4EQGhlx2RdDChtkttl6CkXJnt9BcyMLXxiU1mTh+qKsAlK9TAL?=
 =?us-ascii?Q?L6XeDXiAx+MGUnQ1VsueIUN4zarzOoEYUjt7Kug+lQbAPWK0oETp6RpgZfBG?=
 =?us-ascii?Q?KWaHIpTzdMsleuqBLkyj0OTqDa09XP4J8X45Bh05H6G7B0jDnLSduGvnRwAW?=
 =?us-ascii?Q?oniy0uQw67Wmh95zemAnMvQHOVH+i0HbjgIATTfzejMMmQ0DS5oyMuYH6tUt?=
 =?us-ascii?Q?luxDNqBkx+lJnCZW0STc3tyjowP05JI3ZX9nkdtNlwyRIKcqDqg2mP2jNlJf?=
 =?us-ascii?Q?0KkkVjneM3s13VaqJ+sNLtgKuAcYN7lDhnwKaru7NZUCsggQH5mLcusH6xKw?=
 =?us-ascii?Q?tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nI7w9mcbbjC66BCz/zIFAF0pT6rZiopvf+Ruti4LMX/4yDKErU04hKbpEqe3T/REHbYBa7xiEOYhU8Uvaqfk6vfeKxdG5OTlLdgdo2jtEOa0k3mhN32fWbl+UldUmFpHgDJaKWjwkUEjTJ/onNJpxf6AY+UnVULurANziOxWaLnwpclMbddFHfn8h8KnqHkxF9eKG8vzGIHaQYZGIYds13UxTPBiDu/VCctDBJGJVMgIbHncWWvMSJArJ8F/BkV0MDcbzjjr8ZttFsQ/XKtnUQZz+0Q4TRa2ZVFfOqs96VNeZjGhAIkhQCCV6YLNedzKshuKqej/bLfiu7P35Bwo8RsZk57UkAWM/Zht+FZWWz/ukKrgDzh3IymRNAtHzSCiat/t/q/kFHr/EDVbQ/jtZtNY9yK7v2ZYZv7QlYPNXIh/JaOoAiEcBCu9JO/VrXDZuJmVe128TqoDuKVjk7gQ5YK2yNaZbVJTot3u2uwGJsDeZ/EJTUjkRukNzYAp2/4F+Umup3OPh8kDBNQQi8UcCYzcDmPGJgqVgNYZHSL+CxVBR6MkeGvuBu8KmC6ndaaE4NmT5G9bu16s3fXBEg54VOAma12dayvZEExsim3H8Xk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5e85bec-92e8-4d38-7d08-08ddba2743fd
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2025 11:46:36.5389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fUS/S0pe4IeIw8im9+NtnQ4dSMnhx3tD8JYKXQj1FvybMVhMJkF3OPp/mMxD8v+e+Q4BBEgIXejwxlcvJSvIPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF262994532
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-03_03,2025-07-02_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507030097
X-Authority-Analysis: v=2.4 cv=CMMqXQrD c=1 sm=1 tr=0 ts=68666da6 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VnNF1IyMAAAA:8 a=yPCof4ZbAAAA:8 a=DqzVqx8i_IFAgmWpyL4A:9
X-Proofpoint-GUID: kuTuYte57gbRjHDf9Vhyw1NJHd-xGcFA
X-Proofpoint-ORIG-GUID: kuTuYte57gbRjHDf9Vhyw1NJHd-xGcFA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAzMDA5OCBTYWx0ZWRfX0WrPIWJFkAFY tfLaiNz0aL8H4hUv11ltdPuKt5BAmjFeA4Lqu0/4x9V3Tdqhz0jR6W8qCIjwOYXVKv0x/sx5ni5 vIzBictPFR2ls1fD/qZwLv4wjvX4leYHfwnzyIg5+3MWAmuTEnm7oKvJxt7ux/RzgtLzjszvrgM
 W3yxKb2LY99YtYtvoJ521yENYJiZeJoisMU/18Qnh2CL5s9bdRdy9qffHC/3/ow/LThUD3HN6AE +iq+SQb/A9Q1fOE4r7tUr18xx99T7Va1eJLmgx7Y8KjMsp4M8n/k2T/zy37khW+mqRqFMbLPw6l 6E90rEEha1mXCSvecE3VppnU03blQ3m9TnjWvT39IYcj+DIXI2gRixJyffW9TMjUMDbeSaOWW5Z
 Q8nGi86VIKp/cjOMb6zO8g+WicYrWZsDl6okFgdOAq0+BExAkHFnRBYaZAeZXXFhuv+u6hXw

Currently we just ensure that a non-zero value in chunk_sectors aligns
with any atomic write boundary, as the blk boundary functionality uses
both these values.

However it is also improper to have atomic write unit max > chunk_sectors
(for non-zero chunk_sectors), as this would lead to splitting of atomic
write bios (which is disallowed).

Sanitize atomic write unit max against chunk_sectors to avoid any
potential problems.

Fixes: d00eea91deaf3 ("block: Add extra checks in blk_validate_atomic_write_limits()")
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
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
2.43.5

