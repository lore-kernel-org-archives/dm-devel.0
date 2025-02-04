Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEA72101B5
	for <dm-devel@lists.linux.dev>; Tue,  4 Feb 2025 13:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738674161; cv=fail; b=akj+L8q4gQTCDQoriOgnOOfg1DHXzoKJzWyfMbirtLHzSsKQiHs3fsTB6VtC4iOlTdqzdo56x9+Wt51TanyKkZbSYXHjhfX3u9oCwrcP1NUCfv/Jx3M93jf4Uxa/Pbk9uxirG6oCgJvQdDGOGpweQqCf4GgndYeVVI5wfG4ULZk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738674161; c=relaxed/simple;
	bh=/y8aLxqa8bDbkk7ow3LtASdfC9VsqU6xD7PmOOs8R90=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Q1xFg04WjU+R6P8FyZE/ac9N6zz/ogIwNTvSBC4Y6B7o7CiHG3cpdLKmrOq/gHKf5SGw0oNIpI29nM+p7cjRw+IlL74LZMt+M6RELn24X/FfsWjNe3H8QTipZNunY2S6UqsNToOERHpjgZDnsQGURQ5gZh/gL2Cjt6V+skOlJ8U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iu8NEeKZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IDF476OK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iu8NEeKZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IDF476OK"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514BfVpg000553;
	Tue, 4 Feb 2025 13:02:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=qsgEg+iBOWpzq+HCOA
	PS2OpTz562luG1B9n6tenDGUg=; b=iu8NEeKZaIaGta1jVWEaYXVO0jKpz3oHR5
	l6PKd3b3uYdbH15BT2gkvS1gqtqjW8XucKi/xu4lmgFVr15zPPOw76G853UgGIJe
	As3OAvmJ6/JiGHdhP/x9Gp32zPYeg1sTC2GGhZm/Og+dbCUpaFNEX24InW54sV7y
	GUNkSTOEcd4WbrG8/UTRrIsleCNKuNWwt7aVcMT7PNudDfEaiq1vhHb+7LGXlqwK
	pUH943M2jSvgM5kPk2Gu58PGaa2ZHP/spO5aSxvP2+KoIKnWiCg+hdf9VcFQjUg0
	HudYHD5cqnt9IAeawS0gTTmnN7qkn0Xk24RueLCEWeiaVmLGcYhw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hhbtcrve-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Feb 2025 13:02:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 514BOJS1036296;
	Tue, 4 Feb 2025 13:02:24 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8fm5utv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Feb 2025 13:02:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SDfp7jt61XIeYrTB+/bOPCLhnYVLIson8QSMKprnhXMjEMFnF5AVMa0P111AKb/rXWNaOf9I2Wq9VIwANANkUMY/Tc1mpnz3Qtm/kxfnORAP1hMC5jyeL9ZXUTnsbtMGvntqofGASRD6FdWVirZnKjQg6hZPHwEMq5x59JN+UPtg2jIisvdYyBMeSxE9MxGppqaT5B14vAnEWm2z+KjIHpLEldoaHFyp4nrXOTiu5CE25FKWFllHXquyPdSob+Qjb5syiCrbYlvbB95b40usIFXJsCu1mo9N9yoWImQ9TsICavMKWeyN1LRjEkZGI7xPuVzzxdcE1YbA7hnkO/hwJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qsgEg+iBOWpzq+HCOAPS2OpTz562luG1B9n6tenDGUg=;
 b=jclWqHY3u2+Nq4doC9vdS7HNdWvlf9vNTBE8so0IWfxljw8KpCbwofDB0rH6oFLiz/ozItebse3AEK9M4OXhIsxZkmpMoBxFSvFSw5fSzXwT+H8KcrEdm6pnFGu5YojvGYN53WeHcvAN246Fm1Os7S8Vrb2A8u/zClhCNia/WF+gNEx7zwYH/BsCcfZKgceGUwHjnyWU/SxbU3UEYXTOJX7W7RF2lcsLDmAFMwcSQQbbUOjlqUHZ/q3ZyVjTOIu6LdWiwr3cdrbZOByqyqYLPEsExi1YcOQXihPNmxzlaw0I9gloKey7fxf42zHh4oJajmY00y/+MEtZAWNwdKrPjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qsgEg+iBOWpzq+HCOAPS2OpTz562luG1B9n6tenDGUg=;
 b=IDF476OKMZDSmkwBb/sJO7JrPpNDzbPeZ/F+ExFvs9nuJK4cjArzA5E9QfbxPBW9df2T/NRApgSfc1kIqc6RkMtMme8KcwTPhOVZnG26pqKnJ9GRQ9mf80E7YTyUu9KGjI6iAo5ltQEL6Ttb9JT7KraAl2HmVFApk6wmjbQqQYM=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CY8PR10MB6492.namprd10.prod.outlook.com (2603:10b6:930:5c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Tue, 4 Feb
 2025 13:02:21 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8398.025; Tue, 4 Feb 2025
 13:02:20 +0000
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mikulas Patocka
 <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Alasdair Kergon
 <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Zdenek Kabelac
 <zkabelac@redhat.com>,
        Milan Broz <gmazyland@gmail.com>, linux-block@vger.kernel.org,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH] blk-settings: round down io_opt to at least 4K
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <Z6GsWU9tt6dYfqBL@infradead.org> (Christoph Hellwig's message of
	"Mon, 3 Feb 2025 21:57:45 -0800")
Organization: Oracle Corporation
Message-ID: <yq1zfj1eusl.fsf@ca-mkp.ca.oracle.com>
References: <81b399f6-55f5-4aa2-0f31-8b4f8a44e6a4@redhat.com>
	<Z5CMPdUFNj0SvzpE@infradead.org>
	<e53588c8-77f0-5751-ad27-d6a3c4f88634@redhat.com>
	<yq1cyfykgng.fsf@ca-mkp.ca.oracle.com>
	<28dcf41a-db7d-f8e7-d6b7-acef325c758c@redhat.com>
	<yq1bjviflwb.fsf@ca-mkp.ca.oracle.com>
	<Z6GsWU9tt6dYfqBL@infradead.org>
Date: Tue, 04 Feb 2025 08:02:17 -0500
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0053.namprd08.prod.outlook.com
 (2603:10b6:a03:117::30) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CY8PR10MB6492:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c24eb49-a03b-4ab9-e040-08dd451c28b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?05tV9mz4NJ+wCORYIzIlc//nUUw7XoSYhxCYSc8hvHKw2Vknq3uX00pqlO3B?=
 =?us-ascii?Q?04puxkqFoHB7Oi4M6XGEzaxXdUdqkl5WmiR13Oa/JMl4At5ogrOiisqhoUR6?=
 =?us-ascii?Q?N9gVSu8xdzP9fLKbOFlypuVcc/JbmwU4xxWwWccyfFpMX9rTFlyhB+DvMs15?=
 =?us-ascii?Q?watKV5vfbaStyg4eXThTr+F04DmKq5o57SK/OGGI4eesh89hSbE22zolRmEe?=
 =?us-ascii?Q?jg748D1Mstz589Q/FJy3EiXnncgit0lMKzE6A4Ip42Am95aGxMNxYaJES5b7?=
 =?us-ascii?Q?ADBcV997eBHqFsKIQ0wknaXs3ngjlR7lfq2tEbO7PlOupiRZmD/mreZk3VdS?=
 =?us-ascii?Q?tUWcGr1EOhpsRX2e9izhio9Zv1UzzIjT1m9rTqRVVATspg5ANiNS690CY7B6?=
 =?us-ascii?Q?dT8M63R6XUjxTBjbvFbQ3+dyfPPjMMAdl/o7oiuEO9qfR/s/41yI7Hwm9ST3?=
 =?us-ascii?Q?yhH8Uf1vYzY5ZJJ1oGgQM0+kaV2+jSpVVzqmcUOFw7xzoHPBbNPIfIENjdwG?=
 =?us-ascii?Q?D9XMZDBcg0QXBo+LysWyXJ2uJQKF59aSzllUUg1AFPH4Ni8Sbf0cWIU8wXD2?=
 =?us-ascii?Q?X0rnMPlefqla7imo5gqCk9EiSfqlDCI6wQzhidYJ7r2+FRRnIuZo/zXDAaHu?=
 =?us-ascii?Q?sIrMYUa9YH0CN/83lyK4xG7SMAWOEfE/cY+F7uxIYb3XGV98OrMIexwuZaLO?=
 =?us-ascii?Q?2LczgyvLet/e8Dzc9+UlH2B6Kg1cFCXTqkhd9Cp/RI9KdN3qumlSSPvw4alh?=
 =?us-ascii?Q?xhgcOoGm003okRJYjr6ziW49mmJSXuF1/XlreFHBzZFabRZLphn0ju0WUv9C?=
 =?us-ascii?Q?g7kwL6n2PmNinw/ccefsq8JHO5g0rlcumk0g0W+NdHJ24k8OZgQ3qsWiyM4q?=
 =?us-ascii?Q?fa/oZurXiESZ8px0hcOwhcyuVu0rgXyT53ehdaYSqSIKbMG2+W2MpVafvAY1?=
 =?us-ascii?Q?/U4Yytl0dyCCh1LV/G1I1AZpmK9DehERQV2SnDPAnBQW1acf/3Hik4feCxZP?=
 =?us-ascii?Q?h/jjarlCLw5yDarGQA5m/9/3IRwGER2puq1hiskO3ll1hXp9sh4W59AZNywd?=
 =?us-ascii?Q?WpagXQQ+T9PBB/NvnQ0AX9/Vmr/foU17BG+HFNAR+YcQ6bCMpnr52//lbZvZ?=
 =?us-ascii?Q?Z85tc2J94bJghMyzNTO6fXH7royPS5AnMkTmRfrG8Unm67MtAsT8B0tyfdnp?=
 =?us-ascii?Q?F6Dfg4K8dAwyWvc0bfpi3HHGztz1WsBKJDZB8MR5+L730ilEwbPe5gap09U/?=
 =?us-ascii?Q?1qeW6GDurH14C1z87arJ5OqDaxtM+bJCFhxmo6wAASo9HMHtwmUx0QcqyFVG?=
 =?us-ascii?Q?8pcMDRbduS5g4Pv9Z7G6R4R3H88t3G0fHbdRww2pZaTqHe1xy8aWRK7HFhb8?=
 =?us-ascii?Q?WNRkjxpIJ8V3gwQm5Zvm0uMmbxps?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?N3eaU3x+sVBp18jpIqRyGljTG62YR6FvTVTKSWwgxQq6LlJHrl8eLSBEO04J?=
 =?us-ascii?Q?J2wGMf1X6xuAuvEALQLPqPzY0yY376BiILn2WcelYOqOcBUWQ5eb29PBGKa2?=
 =?us-ascii?Q?ShOWXD8LQIN9TbP6DisQr5sFLwzz5m4U3zeKhdfUS2RmiEM/uiOK/MTHjV1B?=
 =?us-ascii?Q?86g4kQiMlX0FiZlGjQn7B+eTzn1agQXxXQ7SetcJ0i3fiYo1pGyJzmHNoODd?=
 =?us-ascii?Q?fPwShPKJHqLNpJdwlMhlXxsEgBRkMuc4iJ8VIBWOOF1h69bKZIzMR/mzW/mv?=
 =?us-ascii?Q?zVlyACUZ9nIZiX3ZRtqmtBeEjvmYTwyZiMy/8A48p1wrLV5ArqRDUquc6RJk?=
 =?us-ascii?Q?JpCjphV6VvWJLNIfhkl7069YMAq+AoZ4fXsI+oc0B1KmcJ9UCOReKXtdANxj?=
 =?us-ascii?Q?0FMLVwKiVv9S9F/6ag8j/cPAV1Ww2+RqHZdItzrJKc4+sSQ8gBvyBR8pdBVh?=
 =?us-ascii?Q?L/s1oTHsOtKhWmJf87wuK4k0mg9fXHMIUZTTT54n49dXqXDKmaz3gqnRi0lA?=
 =?us-ascii?Q?lbbFL22lco5k1S7SmMqDyUBEo9IdGdQcAQFLfB8bc/IZDCY0CZElrz+XnLJe?=
 =?us-ascii?Q?9U8oHcNJ4JVVsqaMWvOk8IZfISf11H8aLx/9fSIDYNRQVZdvYgQs/P+4T4te?=
 =?us-ascii?Q?40+7xQPVySbd//8UWjjDIB9T+pElS0SivImbOjwpX5LweSpO3NEiniXYdx2m?=
 =?us-ascii?Q?oGOPty5t5nn5eS/uCrw7a+rMPwCSeq5A/v1s/tVBs9b5pQxqZRF7ji+qV9Pk?=
 =?us-ascii?Q?nOPMmqdEeIyCQ5ZpfX+WuKwDuwKfUrzsKazUUmtXtpHEaXWCfnFNTN0uAnP3?=
 =?us-ascii?Q?ly7oe3jFtXZLnms/J/Hul6qdkMwQoCJWElDtgIYa1FhQ4FSZs6+8mFyhRFmj?=
 =?us-ascii?Q?YXLuApJp5W3gvvaMRgS3YgXIBmpX/LRrao5rGIdNHZBa10Iqu1wWtAPrCVX4?=
 =?us-ascii?Q?/elKXBiZMQB6dR0tspH1dHLBTBz/G8a2T3w1WW10l0swEdV0ew4wO44QI2MX?=
 =?us-ascii?Q?+mOameyRcXcBq0neyfu6K3v6Pp0crElJElYTQawRvjbtTopUVRsIrbAM8WQM?=
 =?us-ascii?Q?w9crWx5ehzrT9jP2w3i/1TgJ84FmCdpqndcH1CW16o8iYZU8ExkZ/xGgBr7k?=
 =?us-ascii?Q?AUu0oqQCTvLKfe7y3pARyRLezK9emO2mglSdWug40T561m+cXjcUwo1OMsnZ?=
 =?us-ascii?Q?O98LgjiM0NKq4FSuH5KBbna7x2Fg+Wnhsol9oWIwVp/4OFOyAbbdNzxLS+5x?=
 =?us-ascii?Q?ktTvS6ELU2lqLXgXk8JZXgIzSHm+MdSbUfqphTVWpEVaaAzPBUQhXymXHC/W?=
 =?us-ascii?Q?mvTp2ldqML+QsdiupgIVPIyzGPnoUTS6meAxa0GALvNK3lA6ADrK0UmUeb58?=
 =?us-ascii?Q?aggHxLSTMSPxPIQK+krCJE8CLc5sznGzhu+34wmMQP+xb1jrEvTRXVGxBzxG?=
 =?us-ascii?Q?p7iwQUz/X5b4UcOstW0EWIjUzxCwf+U565pG4FT2ooS5i+0tur5oUoainwT+?=
 =?us-ascii?Q?3aNwD2BaJjZa87nVs6vRoGIoEzJW+dTn8/qSR9pLlgA5lPToW7i5GsqGz4IT?=
 =?us-ascii?Q?YD/grmyVqcKc9hx7kh7j81p7dca4+t2y5AUAERY75oknijz5P74Cp/sRY1X4?=
 =?us-ascii?Q?eQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tm3WLkOOx6IXAIgEs8SeGK7jRNj8GDRLCkOjEqiM7e7+zb46yzbA5l7UVV1mOJv4dArwyDC/KSVF/zUDQGa9Mh18iYQa/4Z9lwPZeL37jMZEpevCEwMwy/DW7YdUmTblWBP1P4TayRHHZrxKD6dtf8fgN/Wlur037+zYWjLm4vVTAJCZifCmJfbmf1Ulygt/TcctrRHLA3Ua/O1UqVt38KdrAjTwu2g3WvNpiOW1ePXCkvONLM9Hkg4t2J1adcbX4QIhT+NuoU2OgGblNvDarPpOWBRmwkqnb5MizC3e7IXirIc4fl5s6oofFXCZhHUFjE5nn8xJGLvR+LjK2D5wPByH6G4LJYKNUOGFAPbDXblPmjmbWWhxXQXcXv80Lvv/5puZQDuwETT3dv1Sfu6AxarlMPDDJSpESdF1gLZnORuz1u/ofdakIguAgbykZLTWOsuYNQfFPDDX7a0P/2fo55QJxDpc107y4nM8wP7Df0igZsQ0AzP8GBb41Nwpw2T0pzrGurXK9qvUitjLzr8QYm4NSV3H4WL3WYjYEinhfwONmGEI75RE8IrEkS87fK4WMvgXtqj2lJZbfoET16a1lJGeu60+nrc5bp6MkstTK9g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c24eb49-a03b-4ab9-e040-08dd451c28b8
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2025 13:02:20.3099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WYmDW7mzJYcSfRaguSd2/LEXnJj/iM/GoXaX1dnOFJuMQcufyToJ8a71xeZfu2sSfCoaNKOf/uixCKNfXaI3uTmJoQi6G1gVUoboiytuNHM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6492
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-04_06,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=966 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502040103
X-Proofpoint-GUID: R1qs4cMmY50kiZMdIK8fo5Wy2uajKrWT
X-Proofpoint-ORIG-GUID: R1qs4cMmY50kiZMdIK8fo5Wy2uajKrWT


Christoph,

> 0xffff as the max and a weirdly uneven number even for partity RAID
> seems like a good value to ignore by default.

Quite a few SCSI devices report 0xffff to indicate that the optimal
transfer length is the same as the maximum transfer length which for
low-byte commands is capped at 0xffff. That's where the odd value comes
from in some cases.

> But then again just dealing with USB will probably catch the majority
> of cases.

Yep.

-- 
Martin K. Petersen	Oracle Linux Engineering
