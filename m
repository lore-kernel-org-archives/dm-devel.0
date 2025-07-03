Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48C7292B25
	for <dm-devel@lists.linux.dev>; Thu,  3 Jul 2025 11:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751543223; cv=fail; b=Zyx6bBEDuJ/v1OaEHfuKVTswrNHxMa3S3Emuf+12DSiARRF01dtDH7NTrnP8odJxYwfND+9QhCQ4OHrb6KlIlo12y7QKOW/hcTKT7hkXvkyrXazwuILruB14ewoSo0PwkGSeAmrRS+Iw77wXoZrZmA/9/vlIj9sTGxVT30G671s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751543223; c=relaxed/simple;
	bh=7wq0nYUs2HA/8J7JcXXVkLjQXj3zotC53GBWIVF5nVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=se6ByEYq/cEXx1T11Dyfdq0fNPEVoeNhZ7GmDUPxecbLG4A2BCAzi/gPWH1F+pNIvEYgolccRzjlMjTCkIefk/E7n5auCJVAkrYJE8vTm1q4RCH/sgXj17HEG0LPaA6rdAXgRoFzvae3+vIT6s25UI7pCRlL38zp6lutAnLeWSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qjc6ubb6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dAvJDoFT; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qjc6ubb6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dAvJDoFT"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5639YpEl015448;
	Thu, 3 Jul 2025 11:46:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HjIVGx8Po9e6eGAErRb7NU5kH1F0p9rD05qmpFPfgTA=; b=
	qjc6ubb6SZFqIft9dNAtpzpUSHFsgA0zX4CKowwSoQayjQlS4X/uxeYbpYyYhRIz
	jfhWoPjDwTlh3Qta6JI/h2aOhEILFjGF3YNZB8Wj4P86p41R0JBkblGiIWugim3X
	yxoyvBKpsRxw99KNNCCEdQJIx3xXgxMfA05F60vYWR/0oql/BYKQleeei04FLYiP
	Gj5phgFP2VbSHPWNzy0E9fS0yC7eA4PcfxGEFyGu83gvPcSBL9RQf/DlHTVnYxLo
	kRMr8H2DbC/UYCH2uR+eQjL064ke/W+PM1qlqirw+m+jS8Mu2g6yRNjxPQExdw6P
	2N3H1G5Nv4icawP1haOoTw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47j766gw6b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Jul 2025 11:46:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 563ANXW5027469;
	Thu, 3 Jul 2025 11:46:47 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47j6ucgj2f-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Jul 2025 11:46:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bZbRIvGn3J1rmUaLCnHScLxPXdNC7QSDLe9JGUDtAK/YFReeSqg6CfaVJp8SCDufTmBSD4u0XDzilURWYH49NfUKxxJFciiCGhbiU3LgZdopjff2bkAHoDTRn5S6bIyW7xq57XGX/OyWmuDwmRhusdQbjrwGBd1FgIHKlGtJPlxq8yXVqNE9Q0O3AoFAIuV81CVUDNbjoo5hG4UISMcVlHQwOkJ2gcfLmcnbAHkjXBFF7xd3a/K9UodY+mHjPGfRkXoU9StqwnRjHN/mLVVEDHV5oMitU0NzpPsR+zUpgupakVqLq7Eo0saAvUoRJGt7z1nMqSGZpM670j8QQPOa+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HjIVGx8Po9e6eGAErRb7NU5kH1F0p9rD05qmpFPfgTA=;
 b=qh/d3asVBBgdqi6p/rYzgI3B3ERI7xbClECwMRM433fKXGj7Mvm2oJIREJyq/qs2e1vkXIXIw9A8F3l8MXyKBY6T4jBzomZ1yHbYJ4mEOlOuQrbUdDdiuw57g7sDOE5VSy4QY7JN0upxtsthb0/0PrxKX6W1R4tvoGBU5vxEj1gnHoyxhB/SLd6hbXmti6/NOLlyHeL6KBVJ2ny7ajr8DpYUXnz/HwZ4b2Y7pMGupQxICVx8KZ0QXAYV599psj1Vufk8ZgzxC3+RDIDiS2npqgSnHLSbsAgCWCQpou93tN77rqBObHl7pQrh4Mfqgwul7r+WYjfjnAYMlbAauErssw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HjIVGx8Po9e6eGAErRb7NU5kH1F0p9rD05qmpFPfgTA=;
 b=dAvJDoFTWc12CcmTBbf9B+2y/qwZDgtTHpSpxURRRUJ2VAc8Wn87VFYMWV814nOc/XXYEWUR1bZ2xuROS3LuPqAhyAWD8tgEPgaBBb/2SO0Y8z/ycuCvlHYdM2JdfXtWmd8bUtTsKb3ghboI7ShV0SkRvrm1gevtbv8ZVVaUYWc=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH3PPF262994532.namprd10.prod.outlook.com (2603:10b6:518:1::78f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.26; Thu, 3 Jul
 2025 11:46:44 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8880.027; Thu, 3 Jul 2025
 11:46:44 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
        song@kernel.org, yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 4/5] dm-stripe: limit chunk_sectors to the stripe size
Date: Thu,  3 Jul 2025 11:46:12 +0000
Message-ID: <20250703114613.9124-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250703114613.9124-1-john.g.garry@oracle.com>
References: <20250703114613.9124-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ2PR07CA0007.namprd07.prod.outlook.com
 (2603:10b6:a03:505::12) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH3PPF262994532:EE_
X-MS-Office365-Filtering-Correlation-Id: 47e146da-fe7d-48a5-9362-08ddba274897
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PxcM99IGtv/C2b5k1JxfIEV5UalylzmWC20o7CyAc4Vv9O1pno3KCerr2sQU?=
 =?us-ascii?Q?hl5iRN5VlLv4wBEpq9nyP+Nv4pQLbvo8oFBLS79EehoGMUpFr/3czZKHr+oy?=
 =?us-ascii?Q?QK/sOfdi0FRNgmm2Swigd+BSZWybBZOyo8h9NmxA7m+CKrL9YJ288XGLH/jV?=
 =?us-ascii?Q?c4iAZ3IDJd9VbUsrx9CDDSqxOgjpjiVH4GowczSDZJhJyJdPNWNMhH2ctSWs?=
 =?us-ascii?Q?92YA/DhRL/gUK3qeSVk1bjGDsCXTC7D9iR1BtpBQElMFE4gYipP1EJKoCL0o?=
 =?us-ascii?Q?7oma4o67K69xLFy+RcH4Fia/3l8ux24gSfOpzaUbOVMY8Hjzx8Ayc4WDW++O?=
 =?us-ascii?Q?XbOljLpLR1VgC4zemEAbBGb2rd3NsrsUkCyrVgr8BbJGvoP2MjKJkK4O3xww?=
 =?us-ascii?Q?7cY/7CyD02U8Eh4avspfsSHkS+vo3OSEuGQLPFmeaDJa7sqI035onaxf/0wR?=
 =?us-ascii?Q?F+wwC1tQatxZMgIFdohRm5HLExnmV9dlFIR0CeHmMvShV+aY4PYdeKcL7e2+?=
 =?us-ascii?Q?c6USda9z9urjH1tnq+q4WacsKj8++0VCtwYCiYtSxn/+evBDA73XKQIbuBFf?=
 =?us-ascii?Q?yBNRlNADupr2cCoRLFjfSe8qU/lhZjk8eR/k5L9eIlxqGNuCcW3Jo56cQ8lM?=
 =?us-ascii?Q?kied7tBYmfs43xwlpLcyszSU9UIMTBvC24firyHYyoKl/RVsRj2QLPuIaqqU?=
 =?us-ascii?Q?ULSXynKSr2Vt6uQh/iaoh0bcG7VNN/5Ri6nWrwXVknUikJLOd5my5UwpjNPA?=
 =?us-ascii?Q?F12IC3YaTTc3MGXaMxSgM5OoWerFglMi964Btyk68tNl3kwHkHgG1pe83JaG?=
 =?us-ascii?Q?mVKabsag/R5ElEtV4OFWh0bwdZm6YEHQP+CROsGvwrg9EZmJoYySyx633Psl?=
 =?us-ascii?Q?KTJurEmyNY0guMD/ovnCGooWNFgpjc7mKwrb+MDbXsa9B+Yl6LamvntCA/Sz?=
 =?us-ascii?Q?rFiwR48JHEfS8RfLeo0cI4mvazQzhtbp/ISy7350FYsjuUHGMwPqXHMXmYXp?=
 =?us-ascii?Q?9aXk30j2uguC0qWfiichIcm+F+Sapm0T01BSpzKIjQJWROx5pgJwG+tqmyXs?=
 =?us-ascii?Q?cMFMPYPvA3JHYfzHo9cXuVsWDNw61cz1f9bpVgQVmsu445unnhYk5z7u8HEe?=
 =?us-ascii?Q?krk5TD/fzJilTTC2B1FreQVTk97codkRaSFqG0nbyFb2XsutFpg/wBvjfbSc?=
 =?us-ascii?Q?HjBw+OTP18HajUvRV7gqHyFvpYsWXtgHMFypilpdqeuijM5TRKXpW8jxwAM2?=
 =?us-ascii?Q?NSgIzjmioN3HIN4Bk0MU1w8f/RQq7ewuqDfCWZJ9S/9cTtAv4n2j0HPh0XTK?=
 =?us-ascii?Q?KQ2sWVjt2Xg7a8LAg3x32s+Ab1IK7C0LdBhhBcouOXYELL3x08G5WWpl1B53?=
 =?us-ascii?Q?0g5aOWOlxazmW4783Iun8lSVJD5qYCI2af4pq8TdGVutm7HRPQXjm7bu1OOd?=
 =?us-ascii?Q?Fv4I8nGKXuA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6cjFmA8lveFGgzVP060vCjXuh2hQO2G8d/DRQBXPgiMFxbvc4CAE9fJV2K2O?=
 =?us-ascii?Q?DGAolRzI57mSHuoYu1Q82G649i9X64FbMReN0rZEXI3hn0j5SlKRDtQYuIbV?=
 =?us-ascii?Q?N2FD6YNvtyibzDxs/rGoZeE8C75aR4NlK3xCwRkB8KUCRC3m35CAhFCojnh7?=
 =?us-ascii?Q?agZM1xZsLbyS5D5mT+xq8JKSlHKN6jZAACho8P5rsQ+c7spz9ewWZT+9ASy4?=
 =?us-ascii?Q?65QSXMhW1EQTmkhhRhdlIoYURKZo3ThPKvBi7bb9fc3IgU+iYvqkKgSV8EiC?=
 =?us-ascii?Q?WtYz8f7cMJ9+tRSdcZwIzLYfCz773DmkWC8dzLQ/Sl5UvMfamDqKpgVeUQ3/?=
 =?us-ascii?Q?ySqgiLplzT1min4bw0KIsU0MeQsCdFfNsJUyDKTlw904jcSMXG4FEMOujqCd?=
 =?us-ascii?Q?zvZ2FVTKHTksXa411grHGf7MOO3DJ7zz7CEAP4PhwzWmvTz90p7llj0qQvDS?=
 =?us-ascii?Q?SKlT239BDvnBWE3u7fRcjSKluaskX6wffXbBOWelS88eGMTb0z2ANaYDK/5v?=
 =?us-ascii?Q?QRL+CQnS/8tQ5FhHfeRnV8kE/+vvI8obeURzbSrlvd8YnmAsZNhoBR9Dh/tK?=
 =?us-ascii?Q?rcoTduWi4yToh5vjXirCngfw318snsW4OpqvZpjOvenPiyjJiPD5dlhDcbL7?=
 =?us-ascii?Q?Npgsd/YQ8Oywr4n4Z4r34q8nDxDDTzB6OVZ0B1vVvNFqw+2+nrO6ZXoY6ewg?=
 =?us-ascii?Q?3/tQpDXf4CtUOAim9+Xhy95aOW+j8H2LUcUT3JkxkYBHlgGiU/qVV1NhHJE6?=
 =?us-ascii?Q?Oc44YPtg9x+TBfgfKABJzH7gBGKEk+d19Dt1KEcmqaEVDv/Hc4qgeSmMeo8W?=
 =?us-ascii?Q?GBh1Wc6/cpdKI4ilJ02GjCHmnYnVzkgJolY+n6CTdg6obLdmpafLbVZHGM2A?=
 =?us-ascii?Q?no+B0fdzKIuJ8ABj7J2QSS30qMlVVNdZq0bEml2k2PGQm47NHiCaYdaIrGhz?=
 =?us-ascii?Q?eabV6mtCpC++ow4F0TkDx0QQN1vDsZCJI817Jdf3Cts+mqw785FrS2vGUPT4?=
 =?us-ascii?Q?KA4LdIJFi5mbjZqf8UOIhbxPfJYbGroc1LhOkO10ktcIF3KWDQ/jrAdTl7mP?=
 =?us-ascii?Q?kL/oxzUGbQhWRmbjmrDguffi6Up5R01vURGsonUn/kKDgNDa+YEzs9Yz33Hw?=
 =?us-ascii?Q?TnDSNP74xKEuE40O+MsQ3+TSjaFlECui8LpKY+HgmOW3zQUqhNY4zI2xJHNu?=
 =?us-ascii?Q?LYPnJ8khvQVCOiM+N/jaVCnUytwL21z9kI2nNGKT8rj/g9jBIZlgxIb+qQvP?=
 =?us-ascii?Q?epVL+wn1SnRUnw+ntpfRHvsdzVIJXOjpv48ko7n4nxaTaUGtjo7259n1NiV6?=
 =?us-ascii?Q?KkprOT1HYIknzBNf8AZVaXKvoNORF4amuSbLR2ljg3SE+nIUmUBF445rAt9/?=
 =?us-ascii?Q?kyHxv2qKM42xMxvGFhVWxKiFZNtWPc/ulbSg6QI9HFz5DNp2s2ntZ2ji6hxN?=
 =?us-ascii?Q?6u8A5eXtEjI+2WziAr5EjjGCsXV0jW2BrH9tYW5tUtBi9YFbUM9W/kl9HuV4?=
 =?us-ascii?Q?8dgM+MhMnxOYzNT9aPh/Q7VSxgzmIpclm0ZIeZCErYVuyRa0ruhSRs0yBwn7?=
 =?us-ascii?Q?dgg8q+gxUCX/OEdtghsCXiiThnTrkhw1Suc21wyBw9JdLz8XP7MYUGz67rDJ?=
 =?us-ascii?Q?dg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	c9GBm0pYR3U2QfZZ2aJH9K+RUi/fUmzYmRZV+d64v+zItZ05MQJV0ARM+QlaqMS3N1dD4a6DbOJ00lJgCaPj8HRjT67KC1EjF7ez34/mxxiX1xXkv2xqwjRXSlE0zWSiB32l+caxeUhapxjMQDuJ9Q6qI52N32Dktd5LHoegngqkZ/Usfjb6loQdR2pp1Uhj+opQguwB3nSixOT7ibUEHBqBNrkbbT+lFTUMLlDW+L14h4gEMuS1kpgl69k5Px4Bhsq6WwlgLyFEXDBmmE2ipSJOIPmP/YDoeIaEflxUx0GdjHrDz01qLCYs5SpY9RyURBT6wwM9em7xs5UssFyzwD5YRju0uz2vpmki/9gzA1MSeT+Ba8qfxhpOFhZvAhwyXwERWwZ5xuishgoVeiYNL5AX5u2CXqcnaNbGtMnTQAO+ZViAjs9QvGERJceW0TGAz34W9tXrNY58Y+rnP37EnsK9OJ08vlSPzgsKGv04Kn2TozPoZazPAAg5hDA9j+rO0mcsIFWJn9nBEmDxNF5GbVD+QV8pTRDY33EWCBGFeCce9eYRXuVPWbTvWH9HG0434uvDRGVZRwQP2LmeEMU/CObmxqePzwpk7M+yo3JvLHU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47e146da-fe7d-48a5-9362-08ddba274897
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2025 11:46:44.2681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jva+HiOR4vcm+8HoDcPK0SgW7fffaHamIGImxwTmHNLl3hK0mYcuuJVGD4VYREAArAzc08VSx2vk7OFo193ksw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF262994532
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-03_03,2025-07-02_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507030097
X-Proofpoint-GUID: gUkgKhtygiEDPsBlXOs5gWfHO_Xy8kPp
X-Proofpoint-ORIG-GUID: gUkgKhtygiEDPsBlXOs5gWfHO_Xy8kPp
X-Authority-Analysis: v=2.4 cv=b82y4sGx c=1 sm=1 tr=0 ts=68666da8 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=RkmrOqiwSQOQut1nclgA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAzMDA5OCBTYWx0ZWRfX+OKziEn23wCP 8WwypLrAwgzpd4YRsVgQhlTzrV6WcmasNePc5kIK6TjbKSd/WkJEQUQi52bgG6+c7l5hL+NGc1f oPdYPaMsbPtR86VjkkQrTANJZnpYfwo+eFg9KC33wkcEAnqJrOcWTMMuyU62L1qqVk1efOKB5gl
 4E9xGWDJ5ghMgsOMMepOvQsieMP6syZXZOpqtYoaZJa8LN+0a8WdWdVXhvwF80umgrxqn6f6IXX 6lUOwoh7nQBIwwgKqZq3AQD8wQdQZv+ShS+KnoBjpp98jIzKxRl7n679XCoNwfZxsr1DE+Ff2Fx OYpxkAIc6H0pXr5YP3mBJ1GI4fHdhPQ0FEA4mHDLV6mzf6PzO3/erjZKr/RYvMJL5U85EwVWQ61
 /RwksBK7TydYWkfbSbKU5uJVhx4oq2SKfXBv7Kgo9JbQNNMkc4bycRT/xoKi+KB4OU8XvEXw

Same as done for raid0, set chunk_sectors limit to appropriately set the
atomic write size limit.

Setting chunk_sectors limit in this way overrides the stacked limit
already calculated based on the bottom device limits. This is ok, as
when any bios are sent to the bottom devices, the block layer will still
respect the bottom device chunk_sectors.

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/dm-stripe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index a1b7535c508a..8f61030d3b2d 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -459,6 +459,7 @@ static void stripe_io_hints(struct dm_target *ti,
 	struct stripe_c *sc = ti->private;
 	unsigned int chunk_size = sc->chunk_size << SECTOR_SHIFT;
 
+	limits->chunk_sectors = sc->chunk_size;
 	limits->io_min = chunk_size;
 	limits->io_opt = chunk_size * sc->stripes;
 }
-- 
2.43.5

