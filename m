Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09DF29DB79
	for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 08:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745916865; cv=fail; b=Gm1byQX0qof2VnZnUJiPkFTnn2/UFKzAAvJ8S91ScvkBfr/T+byJ2EQaBXZAj5ewKJpFrlbDC1qIZd7eARD0ap1RsoOtwseB6I8bG3UKus79nOA2LRSHh5uSbn9PBECOqzAGJSlHuWEKwrtR5m1XLQQ4eNeFCrDXDo/+G/p5pSE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745916865; c=relaxed/simple;
	bh=HJuITaxPeWpiLfnH56StDKWBXzeGGHCtyl+1DqlMQds=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UJ8z32mAjFlarrO8R+J6CuxH/PQYWbgNxohDFe97V2pesS7jLOtsGrCKwJQVQaYpx4TBdS5j/Qt8a3AO2vzYh39OTicEV9aDlSVe8xE3S50W2V/GrUiRfG/Zwsb/DnZq8zR+LJsrQBtQCTodFlZRpD650D1yjc1UNgFCkDhPUhk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lc+rTvP3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=l/1gDge0; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lc+rTvP3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="l/1gDge0"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53T8W9Al017970;
	Tue, 29 Apr 2025 08:54:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=3IbVbK0aXKpn1ELEb3BN3+L9FEefoiBE4cqPmedmxfY=; b=
	lc+rTvP3+PTvnVtNLkXxOaukS7VB9IEXr4i50NeAoKi4J112DrSqMOk9qJVsBuoO
	zVEWNj/6t0hNX5obkNA/oZwPQg+eUhfjI2etLGMb42xjXWifnlY/gwwTn7laEThr
	Kvsp8kzWKbTB6OVuqbwH3HxRiWKzb2fPm+mywXJALTXkC1TChcyqc+4WAkqjpU42
	jptP/Epx2J2tBL+UaRCPbnufKh7Uffrh/lc1iQRT5MRUduvOAxpEKHNDfrZm8fQQ
	wz98isI+sfRN198AWbl5jsewxTgu3ua06XPh1udX0okER0PmtKSZYk8uIGEkKZOc
	SHXelDgBzBBbjlEBLrhcTw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46aubcg30h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 08:54:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53T7kAT9001267;
	Tue, 29 Apr 2025 08:54:01 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazlp17012051.outbound.protection.outlook.com [40.93.20.51])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 468nx9hpc4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 08:54:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZeAN4algV6l8mT/Fdzkv2sbeOd5W8HKB38k2Nt3JFiiNPgGJHFTx10NdXuwRLhvpU7WOO8r6G2Wez3jZULkVNpxixFyPK7J8aXAIU+AcVevKFf8jttfw6570Il3W8a6Ygn96TjNZlh4pkd1ehXJCHygoDyO0kmjrgmwXt5Cz4gsqfBVZzIssdmo6KyPOpVuMHFHDVBdL9p9jKdhU0QWjo3tbSOBDrLKjZv+OQxkNQJgtT+ICUZF+NzdIz5O7++V2V/0GFyvslgMRH60yjTsIrNo6BI6qsKCq0Y0ueTgPop030Ax+dbmf0T6A7iNEGc/8n5ErRsLOHo27me2sJHjCBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3IbVbK0aXKpn1ELEb3BN3+L9FEefoiBE4cqPmedmxfY=;
 b=Yf4qLzKJd7pMqS3FP92XM3S1TIF53A5a0v0dhE0TrSAOHxmEKKDsWdqu34eRCdFqYWHI/xaEzv+tP6b5BCMn2j9F5s36lNzBhXxa4nM4JLQ2K9ipjg4ud3WT/wft/oFz3wqH3Zh2HnS2lLjh4qePdUh5uPa34j05ueg0WeINRJpDI7DJlJBgOvlDBzMUHfaCjRWR3T93GkDFCWMUhAgwMKubuzWffcBBHgJ75Kce0IZAAtppoue3spA+cR8HF77Q7g5uW/C8WmPHTySVx0Eltxv/IUcZ/IG+aDH0HEMmQ3plw78UE+3tRs6kV0d/gW1vsMvbBXRiQFNz+x4uonG74g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3IbVbK0aXKpn1ELEb3BN3+L9FEefoiBE4cqPmedmxfY=;
 b=l/1gDge0FN3w7ndGoZyL+DVL0nxci4oPo6vtkyVzPXnL4x6Mkjdb7tPBMlBMq5CmLZY4hxvCeX4JqJPQCqCyW87sZa/ADaz1anuXH3XZHs6TyVwjUFBVERxGNb2QaLsZY/U6YynhPCOzEjhohb0/kbhhbFiJsXB/mCwnV7lgks0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BN0PR10MB5142.namprd10.prod.outlook.com (2603:10b6:408:114::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Tue, 29 Apr
 2025 08:53:58 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 08:53:58 +0000
Message-ID: <c2c95790-32ad-4de2-bfd6-344b189f1ca1@oracle.com>
Date: Tue, 29 Apr 2025 09:53:53 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/9] block: WARN if bdev inflight counter is negative
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@infradead.org, axboe@kernel.dk,
        xni@redhat.com, agk@redhat.com, snitzer@kernel.org,
        mpatocka@redhat.com, song@kernel.org, cl@linux.com,
        nadav.amit@gmail.com, ubizjak@gmail.com, akpm@linux-foundation.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
        yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20250427082928.131295-1-yukuai1@huaweicloud.com>
 <20250427082928.131295-4-yukuai1@huaweicloud.com>
 <4c6ac59f-0589-4cb9-b909-354d02ee1a44@oracle.com>
 <6bb64a49-a8db-3431-537f-913982886ba9@huaweicloud.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <6bb64a49-a8db-3431-537f-913982886ba9@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0017.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:150::22) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BN0PR10MB5142:EE_
X-MS-Office365-Filtering-Correlation-Id: c808e54c-69ad-4f96-f4d0-08dd86fb616e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZU41YkU3eGV4TDVTYkZuandzRkEzSElVZGFQbThjeTE1d0JGOGQ2Ym1PbjNX?=
 =?utf-8?B?emh2WlhxaVlQRTBGTUdYUTAyVThMNHR3WkFVRkc5YUNUdHNRYkZCcUlGT2w0?=
 =?utf-8?B?bEdUZmhlSVp6MlBHNy9FZDFFMTQwRXppRXoxeEVaNWVMWUQrSXBKVVlHeUIr?=
 =?utf-8?B?a3N5SnRhdTZkU2NXdkcvbnp4VVhQSGtmbFBvTENYYlhqd1lvTFlpYUVBbGYv?=
 =?utf-8?B?aVdjajlmdmk4QVNoMThyWnBOa1JrUnlPTUs1cDUrOTJQZUxxYit3d0Yxak5Y?=
 =?utf-8?B?WnF6ZHdxUkZoTk80VStMTGh0Y01CK3ZzcllNaG0wcWJ0cCtrMjVVTTNVTFdv?=
 =?utf-8?B?K1p1dVp1WWxveEtyNEtvdCtEQnBZWTE0WVZtQ3g1Zk9vM1NjZUtKb2hiU2Ry?=
 =?utf-8?B?RFEwRkJEUkJHNUh1M2RBTlRhOTFIQnZxcHVWdHhFSG16TS9vZWQ1bzdTQ29K?=
 =?utf-8?B?T2drMUM3NHpLY3JMLzhKWStId0dqNVc4a2RHT25DZkZUQWZPZmtGQUpEbGNG?=
 =?utf-8?B?MzBvV3RDUnhDQnV4Wk5GTUdNakQ0VExMSG1waDl2WVd1YTFNVjkxNTNuRko4?=
 =?utf-8?B?aVhYQ050dU1iNndEaGdMU1crWGtIZXQ1WHh4cDZIT0FjVFlydXljSkw2cEVX?=
 =?utf-8?B?NWxSb0RMU0M4azR0SDY5cGJMZ1dOR1FISDUrRllCQmpuTTd4aGE2SWxlczhH?=
 =?utf-8?B?S2pyQTRqWEtpc2c5UWpHMU9ZWXg0TnlMZ054WUtnaFMvY0Uwbyt5SXpxbWlK?=
 =?utf-8?B?WUdnNlo2THloNTR6MENrMHo2ZUNuS3U4eUZzM1BBVUpZaEo2VzNFRUxKa1RY?=
 =?utf-8?B?a29lWDVVWFRiWVJvSTFxVi9zNmhGMUtFcUtXNGVmL3JjMU0vM0Z3UXl4YjNm?=
 =?utf-8?B?Z2swUUR2dE9XMnVKbW1jREx0VjNobUZreTFVeGY4Y0JVREhoTXdYTWp5Ujhw?=
 =?utf-8?B?SFQ2QXdVL2p2bldFQS9JbFRDTnRLK2czN3BaTWk0OFhpamVwUWNLbG5qaG1C?=
 =?utf-8?B?Q0RkcVRLT21zQjBQUi9NS2FOM2p5TGp0cDFaWStYL3FQL0hveWErOVVrc0l5?=
 =?utf-8?B?NzMyNXFYK2RGWFYyNm5KNmNYVnVLdDdUdlFVSmZSV0g4bUxMWGExYkM2TVQw?=
 =?utf-8?B?V1ZIWGlYejJDalBBcmVkd0NVRG9TUjg3SXVqQ2x5eXlGL1VnaCs1SWJPc0ts?=
 =?utf-8?B?MVVYS1lsOFdmMTdKd212SHYySE1DMFVtYmNzd2o0a2l1R2ZSQ2preUtHMWph?=
 =?utf-8?B?L05hY2VtbEEwdGlGY0g2WWtaOE9VZldYLzltNHkxdVQvWDR2RmNFN2kyRDJj?=
 =?utf-8?B?dk9vbUdJTGRUbGpyNit0WG5pWkVoT2RLUVJEb2hORGlQVTg4bW4zWHR1Z0hH?=
 =?utf-8?B?K2VmK1k0L3pTTzFPS2t3NWRldUVqcFhCMUxJa2d6MGlSaWZDMjdiUFBCVzV2?=
 =?utf-8?B?aDlQalYxamQwZHh3SVNNUkQ3ZVFDMS9ycmEwWXVZd2l5VjFmL1ZWbGxwUHBm?=
 =?utf-8?B?bkZSYTlBR3RkKzNIeG1rcDVGaTZuME9WK294RDNNY3ZieUgzMzJzdHBSOXFK?=
 =?utf-8?B?MndtQVE4QkJuOWxDV21lRkZCZTVRdit3WkxEWHRhVllsWW5BSnNSNlordzVa?=
 =?utf-8?B?L0c5UGszSkkwWndkNllGWGhPK2cxZi9PbkZqaFJaclZiUkJ3VW1NTW52ckM3?=
 =?utf-8?B?aEtkT1ZhNURkb0ZBVUVTRlNXekF5VnJsbVROMTdRWmplVmNsTjlHTkZpRGhF?=
 =?utf-8?B?aXQwS3NPUmFjeXc5UHljTWtPejR5OWJJVGhqZDJtbysxNjQ2UlBJTnMrQ2do?=
 =?utf-8?B?ZW9JdEZYSndwTUU1ZzdBRVlUb1d6ZmN6YTJaMFQrd0ZCSW50eVM0TjRQcHJ3?=
 =?utf-8?B?L0pQaHNtQk1MOVlZRDVNUjUzRk55US9VZFRXQlY5M3FqcnpreitqRWZJUjZJ?=
 =?utf-8?Q?RHrQ/FSCgNI37NcGfJxgjQoxs6e16lrz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NTVjSE83bkQxWGUwUm9iK0hJMjkrQkFBVTRlUUlPS2ZVdUZjMkRlSGM2aGQ4?=
 =?utf-8?B?c1I3MTRQaDluMHVFdkZIRjZSTmVUUisxMjVMbHB2NmUvaU5oUVJLdWlscGdH?=
 =?utf-8?B?d2dCWGxmd3BucURVT3J4WCtjS0kzRzViQUhBYjNnc0ZOU1RpV29YRXdoT1Vz?=
 =?utf-8?B?U0psRHEvWFFGUFVTRXFrRU8zQlpjamxzcnlpdS9KQXBKbC85RXJiVFNxNFk3?=
 =?utf-8?B?NWIvWnRLRVlpWWZ5cnV0cWtXZFV5N3d4K05IYmVVaUxGaTJsM1BDOVdoa3FW?=
 =?utf-8?B?dEdYd0drL3hkaElsTFNkR3FSTTk1UmFKRDMycFBqOE1NM3BwcnVCREI1N05k?=
 =?utf-8?B?aGs5UkllUXIvdzQ1RFRQMHhmT2RFWFZ3NlpwWEFYdVMvWFNxTk5xSnRqV01L?=
 =?utf-8?B?RjdFaVFDSUpweklUWm5ORkdnNTlXMjYwenVyQlJnMkIwK05ISjhhN1FZOVN6?=
 =?utf-8?B?aG5Hb05ycnBoVDZEbExGQmZ3SnpvcnBpdkFXS3ZNVUZnSk42cnZNczBuQ0VW?=
 =?utf-8?B?Mkh0VTZWemhLWGVJTGczVkpFTDJYT3lCMWJiRE1wTmxTNERhTHEwVkVXM2xW?=
 =?utf-8?B?UUlXMlg3TDVxNklvY2tNZXMxZ3d1V1ZGL3VoRlhJVEJEbTVIMkFKZlZuZGIr?=
 =?utf-8?B?TEpwMHl3UEVoRmxnaDYyaC9weVpSUGljSWtRV2d5Q3FKWGxhNUVjSUFINUE1?=
 =?utf-8?B?aGVEWHJnTlcyaThIcmtGK3M3K293S2lWRE5LalltL1pOcXBlQ0JWNDVqWllx?=
 =?utf-8?B?djdVZXVhOUFVbjBqQlhqVUF5RlAydFRORDl0MEtacTZWZ3pwaWp4NVJvN1Z4?=
 =?utf-8?B?WXZLOENKclJWMEVLUVJGZUFPTTVMemx1ODd5QVNQcldZQmhSVkkyRFQwenp6?=
 =?utf-8?B?c1ZmUDg3cnV5ZTI2YlY0azE4bDhCNHJkTmRLMUQ0K0ZmcjFGWXpMOGdZMmlV?=
 =?utf-8?B?YWh5aGtnQXphOFFFVVozcWc0cVhtVHhsb056ZDAwbTltN1RuNHg2U3hVanRH?=
 =?utf-8?B?ZWluYVJMK0JiMUM0WWlXdllrbVZ2dC9Ob2VNRnMzVVc0QXQ5dS9lTVZPRkM3?=
 =?utf-8?B?VkFUbWlHWDJ4U0VVK2JYRklPV1oyTW1XVlB1aE9HQ0pKc2JPUDNYM0lkWW1E?=
 =?utf-8?B?SlVKTFFxL2V2bzZudHFWTXV1cFBST082V3ZmRUFGajFleXY4OElCM1J6Mk5E?=
 =?utf-8?B?YzFSY250WVhqQSt0UDlKKzZ5cG1sYllhaUdIYUxLZVVZRmwzR0hZWjhiSEV5?=
 =?utf-8?B?YWZtNkVPQmVmZFRpK2FWbFBleXhFcGJ2Z3gyeGpUYUpTSTkzckVMK1hSeExN?=
 =?utf-8?B?cU5Ec21aeVFSMEExSGlhWTN2Y0FQWWEvNzg4VTJmVk5BYTlvcWtGaUJiSlFJ?=
 =?utf-8?B?UEhjZWJtaVJOUjBKK2FQeDhKNjRodmozQ3dHaTBWa0JhdEx2VEYvRWZHYWE4?=
 =?utf-8?B?V3ZVaW9SeWdHVmI4WVlZMXhEZkFHVVlGQXA4RmxjNmJRcnlZcmtwdjdUekxY?=
 =?utf-8?B?enJGVElWZGVqQlo3aThBbzhlTllMdFF6VEhYMDRTaVUrd05hTnNQeTFQTndH?=
 =?utf-8?B?S1Q1NVZLMTJSU3JvYTZEeFV1WkNKS2tkektGdEV1djlsekRDRTd2SlQ1d28y?=
 =?utf-8?B?dVBpRHNhQTdaZFlMNGJYeDM5WGhnQi9QZ0xYUW1HMFlLeG1obUh4WjlJekVv?=
 =?utf-8?B?U2hPaWpXb08vNTFuNmtpeW80UWl1dFk2NksxRVIzSUZMS3pIakFHeEt0ajlu?=
 =?utf-8?B?NzhkVm9FQnFCaWc5dTJ5Yk41ZHlJeHdyRkhsNXhWYnl4NlY2Ym9xTW1IUUox?=
 =?utf-8?B?N3BlNU92V3ZOdEhHOW1TWlFCbVdHandEVmFuSGJXYnc5eEZoenN2QUNNZk5J?=
 =?utf-8?B?UHZ1eitGYzVaK0xITmo0NVBTOE8zeWl6VDBYMU5xb2xna3pWWVF4YUZuOVor?=
 =?utf-8?B?blRIMkpwWFpMeEtLcDZrUHgwYU14MjZxOTZoc3A2T2cxQjE3WUNEemYrR1g1?=
 =?utf-8?B?Umh0N3JQSGVRcGs4Q0NSQXBrcHcyc2NKOU56ZFdrdW94cXVrWTJmUnZtUnUv?=
 =?utf-8?B?Tm9qMDVXbmpveG1jRmtaT1Y4VkM1V0kzNmI5MkMwSWt2MkNKVk93L3B6V3Y0?=
 =?utf-8?B?WEhxQUdEN0RJVlBJSGFOYVFYWldwVlcvYzZLT0s1bEJrbDA4Z2tBbGpqWmF6?=
 =?utf-8?B?d0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TBuG4Q358Sa9Zejt5pgVr/qFXPRwazE3lgGp9oEH3wa7zYzHzuAcTOocJ2tElhtv8wcqNiVQ590RMNPM9nE2htqvONGSCZPCBcAMx5Xd3wYZ04IW91fD6cNXfr/7iE5XTghEnkQE2GZ5NS+MDJnyKOH5vRk2CB84UsD+bBU1LKFdP/033PmBko09qEuSNvwqYYV7Ah0rN7nI0Igh833Wx3d5qvYYx0UhwgPqrtgqL33L1BhHKdSFq2l+GT8sUMDkux5xyHWFqlxerMht74jRfmEQYa14HGGA2MHE19T2Sjm8eCOEMY5zMZC7TgcJeKPFRxFB8Ivm/3Y0XJv2R5Ru0gVNkBkFAww5hwkN6Hoqj2qU1kWq7Ck1PU3obPk9Z1Cf6lkho+7UBHQs7iTgbkXS3I3+GrT5oLAn6wWhxoyYRsvRjcmE4F0hKTmV0qB0ptXnj4vCZHAXVBFahEddKfshwm5avQAT2wJOUzvsFSia+ylS9qInfKuwAO88Y83sCU/zVBpYa5QS5HaLdj744ZDEOyM79SV2bytuVgVcmyZlFke0K79k0WxG6gkFldzL7YtGt2xYqjWkbFZYhY0k4oC1yNUbhkb8748204XBV1vOEZI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c808e54c-69ad-4f96-f4d0-08dd86fb616e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 08:53:58.8361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s5IlEerNPnHRgWsfbI8hAdCGtiwO/5fWy32LlxX9G8lB/I4dN8Vam0iBznf3OQl+n7+FdpSkVAj2amcUTNL7ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5142
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-29_03,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2504290066
X-Proofpoint-GUID: KTm1UflZge2t33J3ET69vv8hfSM412wz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI5MDA2NiBTYWx0ZWRfXx9iLYIvCFT7G wQU4bIEpLG361G+Fja1yoWl5gMUiMn8yNb7U1WqSiOqpBF8CRbWSQx6VSF0Oc5IactHfB5bm9aL 9r9QxsO4GajaJmxAvempVvP4Qtg8rQpbmh2HHzjhpbyEW0RNqBK+Ng0/EPQ/r8+69JgwVYpRwE1
 bu+z8TkIglNHzO57eh5ZdR4GUzKCu7rOBvztCv6H2XidJRntU71hysXFffwn8hOmdnofQz7+SUt m9MQf7k89Hef7iDWL/QYGRTvT4gv28DY6bxwrXmRZzuXKn9bX/8ICNC2YCJ7P+MKKvle/j2iuPZ 0ahN05vvs4mAMqXoN0UwuqMflGV14kT2WXQ5BbRedC37zAyZvyAY3x0aVQXUlVgif111kv9pEiJ 3Wun9EoW
X-Authority-Analysis: v=2.4 cv=dbSA3WXe c=1 sm=1 tr=0 ts=681093a9 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=GoEa3M9JfhUA:10 a=f8UM15U17NqVCSsVUncA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13129
X-Proofpoint-ORIG-GUID: KTm1UflZge2t33J3ET69vv8hfSM412wz

On 29/04/2025 02:43, Yu Kuai wrote:
> accounting, IO done is more than IO start, and this is a bug.
>>
>>> for related bio-based disk driver, or blk-mq
>>> for rq-based disk, it's better not to hide the BUG.
>>
>> AFICS, this check was not present for mq, so is it really required 
>> now? I suppose that the code is simpler to always have the check. I 
>> find it an odd check to begin with...
> 
> This check do present for mq, for example, diskstats_show() and
> update_io_ticks().

ok, I just noticed this in part_inflight_show() -> 
blk_mq_in_flight_rw(), which didn't have such a check. I think that is 
because we expect the tagset iter to provide a sane count value.

Thanks,
John
