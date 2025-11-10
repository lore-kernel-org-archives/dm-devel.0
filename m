Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BD425A340
	for <dm-devel@lists.linux.dev>; Mon, 10 Nov 2025 16:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762790598; cv=fail; b=lME2oSv6koIIUAcjF+AYlOWV6m7VwEk7lz8OI38jqIr87t7qsCwslXvZxJNi2ht+OD+nDionF9hLs9MoIo/yV/HB/w73jgZ946IOEJmwrg4q2wJFsDMHHdMbwXLOVve7ytUUN/RuJYuriRPuFjvs0Zv4VY6TLyT+gdGTbkkHQmg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762790598; c=relaxed/simple;
	bh=jVgI3NQgsrdUBCTukafj4FhV83iCeUs5clHTtIRodx0=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BFUkujgIYfk7QvqmU6FVxHAllrL83214H6n3XRMFTfzEPG8NNTvMbk60fWK4IsZgZ9X10UYHsiL06LKSECfXUIbBSge/yurAEI9E8WC+meNKFS6ytzZ1m00tuHXp8U2tU7O2iqqpAWC0d4EO8im28HCflDfFS9/iJvAeHG6Tgqg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Xw3l83dD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zoocPA46; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xw3l83dD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zoocPA46"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAF1wrl001543;
	Mon, 10 Nov 2025 16:03:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6quooeHhStTOzhzX1aYPD36Qm3yZCwhk3AUV/KdHIp8=; b=
	Xw3l83dDNG5J5uKPrKlEJVimlXjq2Nj+0FY2G6qCMJQhDqckBDToN/80oFAuGpe1
	KsuzFS6aMOa0/LQ1oVdgE1Wm21UhYcUMbvkgiVbikaKRH3AxTY5wv0V9ieLbh1lu
	jYk4jNKV6SN0JgZYcF9l5ORjuhYwDWMGsUbYOi0kSno2YX0KAN1Ze9ohHjlLEWvv
	j8pleiTSRTkENH0h7+wecbpd/TX1CB+5tekyZZa0RYn2C3/wGWCpBswAPkmM701e
	3jFlF4VgPlm8bmAlm9JPuBcHDpA1aKWQN8ew4LzltfrTu/+h5LQAdoDfrUaXCrHu
	/I0ZDG7JzA4henimhade9A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abh4v8cnd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 16:03:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAEbxgp007388;
	Mon, 10 Nov 2025 16:03:09 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011030.outbound.protection.outlook.com [40.93.194.30])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va8uqbv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 16:03:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LcUglWa8o97pj6YtXQWFK+Dwar2N4jWXIIeynbbobLgGkmzJVg6myWRONLPAXSI5rYhCsGWvGL7tJ+4/plAao6L1ErZZjpEKIpHPyBkwBAEHK3CdjQdbrURG42HMdDhSXXZQIcdTra5XHsZSqu9qhbhuY/LrvBlVRsCurNyRJGJMQ/2AFlgNFic9Jerko8nzwjimRr94PsAC+564kzieXqRTvq1gCJZ3yWeBRniWPwM2m8CRNS+Zx+ACXwq0wDHVqrKpzEZtG/v4NXVmApyndoKj4z2BMLZ4ih8hVNAAsWeIGA5gBJ2//zwHOWge/+HA6D+f8Z/6jmmG05v10qdimA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6quooeHhStTOzhzX1aYPD36Qm3yZCwhk3AUV/KdHIp8=;
 b=VCD6Q3lzJhwDsr14JeELkRGxUzVid2HEPn0ngKjmJ89I5qS3biLxMkF3IsG6HF2GJwoGUMOSeZP6TOkIrEzQNpM6lndOsvJ+z4QEGO2C6HH25TT0OVqxdg5jZ5MncMfXWyBb4aXhbCdbSgk60jVJXrNcJikCl3SpvV2KRqPPzps9mr5ei/T1SZ2yWZW44xkwdpYZ/Tpi+/6T6NfP2WCYd5bqy4Lo86FlvGFryxGlo3BG7YWviFW5KKZqn4tZTZDNdAqtc/Azb/9UE0x+c510h1BRUouzwoDtRVKz3sb+Zvp6XssEWszA828UeAaE97qaZIZQ38kcaY3BHZBE8o19eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6quooeHhStTOzhzX1aYPD36Qm3yZCwhk3AUV/KdHIp8=;
 b=zoocPA46nJCR2Dh7TYb63dSzIThhU1LcyHlwIp0LRnHtYBBW0GvyqUnpUMZavrPvf6MHFzbgaRjoZDENushPSSvbFJb3TgDoWBHY7EPs/3eNKKg9EybegSEjMjn/zSUZ8QuJlzggTP8SwnXB6REvw3O/TQMZ8p5s8K4EslPnKak=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by MN2PR10MB4368.namprd10.prod.outlook.com (2603:10b6:208:1d6::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 16:03:07 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.015; Mon, 10 Nov 2025
 16:03:07 +0000
Message-ID: <30f2009d-5bba-435a-bbc0-1fa107acde5d@oracle.com>
Date: Mon, 10 Nov 2025 16:03:04 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] dm: BUG on REQ_ATOMIC in dm_accept_partial_bio()
To: Mikulas Patocka <mpatocka@redhat.com>, agk@redhat.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, michael.christie@oracle.com,
        martin.petersen@oracle.com
References: <6428d43a-ded8-c368-2057-39620bdf8546@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <6428d43a-ded8-c368-2057-39620bdf8546@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0496.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::21) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|MN2PR10MB4368:EE_
X-MS-Office365-Filtering-Correlation-Id: 70658f6e-2694-491a-359a-08de2072a30c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eXdlYzlnT3NuaXdqNHNjYko0S0Jkcno2MWJnb1VITlFJa21QdVhSQTNBSmtC?=
 =?utf-8?B?VUVBaHdJNGhTWDhmcDNUTVdYSmZMczM4ZnVDTG5GTFliOUhqdldUTFNiUlo0?=
 =?utf-8?B?bHhsWVZCZnppblF1QzB3Z0VUS0QxaHN3Tm0yazdJRFZhckp2VEFwSzc0b21H?=
 =?utf-8?B?MUJCMDFEWUxtcExUUi9CNUNWT3RiNVZXYk9ncjRHaEZwcGRHQmZhZlpPSmtn?=
 =?utf-8?B?OTJuY1lkZUJmcVMrRFA3Mkp2MnRXak83R3pkVFNSUlZNaXFGUUthanlWY3hm?=
 =?utf-8?B?MzNEZWJVd0d6NHVHWmtuV0JvMWh4VUJncU5jNTdQYlY3c0JNZXF0YnErMllk?=
 =?utf-8?B?SEgwZ3ZJa01kQU5oZUtDa3M5UFlubkxpY3JLcWYybDliT0FPdWZjQ3J5QzRV?=
 =?utf-8?B?T0V6K1h2UUdDclpyeVJjazZNald2WXNCWVJWRWNlbDdTckpIK0xvaFJRZ3lD?=
 =?utf-8?B?MEhYZm81YkNqS21oT2RxT3pPSG5DaWljeTVnVVBuNjR3L3VraCt3RGlDTUc3?=
 =?utf-8?B?ZGFpRzlxaTZvTk5NYzZNOURaTWcrNGlneForQk5FUEF1MEUrRXp1SnF6cGJT?=
 =?utf-8?B?WTAxQzRMd1JOb2JIajRuZFRPNEpzSHZDV24vZmdFVEt6aFdCMVlvVDA3M0Q0?=
 =?utf-8?B?WXVwUkoyMzlTNDZuenQ3c1lRRkgxa2xVZE9nZ2drS05Ba3VxL290R2JzazdJ?=
 =?utf-8?B?Yk9EQ2x3RXE4Wk9wMjBzNlFCWldSeExmZDlaSnd6TmN0bkwzLzN3Q0tIa2p3?=
 =?utf-8?B?Ym4xWjZPUzdjaEw3V2VuODhIbjZ2NStHYXpEWjA0bGI2MFc0K0Vzb0RwSUhE?=
 =?utf-8?B?WWxZSDUyb25iY3BUVVdJdmwzYVkrS0FLNlRGcUc3RmszUHFick1PYjJnd0xR?=
 =?utf-8?B?L2JzeldtcmJZWEdRMzNqdExIcDJwTXVRd3ZjckZCU1YzL0x3bXkrYldaMzJE?=
 =?utf-8?B?RUFsRnlIVnFLRUVWUERnK1puRUV5RE13eTVEbWV1K0F2VFV1TVNGa0w5UlA3?=
 =?utf-8?B?czI5U0srMk10VzNlMEtoRGlQaU4zMmtWa0VONm1ZSDJDcm9kRm8yT2UrcjdO?=
 =?utf-8?B?cTA4bHh3RG1JK0Y3bTVXSHJESDZYQmM1YTY0T2t0Ty9LT1plZXcrY25kSloy?=
 =?utf-8?B?ZG5HOXJzWEI1RnhMT0loTmFxbTJtUnFyeVZIOW53Uldtb0xJaXlrSzlkQm9w?=
 =?utf-8?B?S25ZbGVqaVYrMHRGdlZGRmVZZU5scTZXRGNrK01MWEQ4QmxCTHRINWRRSmh6?=
 =?utf-8?B?bHIwOG5NT3ltNTlGN0tSRW0wRFU1bjIwT2NaZjhqSTEyUldvQmx2V3RWQTc0?=
 =?utf-8?B?ZXd0V2gyUWdERVJUdm1qQnJZOFpFVGd6Z0hJTDAwT0lXdzlQTHhqaVdJY1RX?=
 =?utf-8?B?ZXJBT05MenlWR2dDbmNzZGZDKzFodkRXUE1lbWpSZEtFOE9yQmxqM3FGOGZS?=
 =?utf-8?B?RU8wKzVoS3ZFVW9RMCsrTDVlQWJFdTdZMlk3c3FLNkdNOXNkdHl0ajFPa2V1?=
 =?utf-8?B?Sm9zRWFpU2l5VmN1aSs0eFVTZE85VC96Wm9acmZLYjJhMldsUmxPU3gyUHFm?=
 =?utf-8?B?TDJ3Q24zWXV3L2s5UVU2SlpJUzluZUFTbFZqMDhQM1FwejhnT2Jrc21WMGVZ?=
 =?utf-8?B?M1RrRGIwRzFkT2RMWm1sR2pHeUNEYXI0SUkrSkdYRkM0ZTdNZlArZ3FGR0Yz?=
 =?utf-8?B?OFlzcDNtbTZMbUdONnVNYUZkU0FEaWZ2MzB5a3dUQ3RaQXRzMkgrVkV1OUVR?=
 =?utf-8?B?aDByRHc0SVU2WGh4TEdYQjRBclhpeVk0cW0yRWtpNzVlN0RFby90K3kreWky?=
 =?utf-8?B?dTIvVkxoK2tia2x5cnp4Nk9RNmlzT00rSU9ESGhxVStFTklkbDFNUnlBbXlo?=
 =?utf-8?B?N3g2ZXJGOUNyOUp5TURuVkRyTDFxbWh6RGM4dlpUV05pbS9nMUdhNVl6WEs3?=
 =?utf-8?Q?LkTe3CIWEEMtCRM0u2Bz6QFK5XWO50ux?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ckZXY3BnSXdSbFJFaG0xWi9kbDBiNkZzYW5URGJ3aGh3eURLdXkzOGtZbVgv?=
 =?utf-8?B?aGNiMVJHNXJjLzNDendETVlRdlRLa0g4ZkcyTWVQWTdwYnIyUjZpR1ZzNDFp?=
 =?utf-8?B?M1RyM0s2eWlDbGdWR2RJSmpmTkR6QmNMSitTSnNRMEIxK3VHRXR2WnJsSDYy?=
 =?utf-8?B?THhQdnltQUhFdVBlSEoyWGpqajhlK0VWdEJCR2p6Y1ZkVHJFSW55V2t5WFI5?=
 =?utf-8?B?ZVZUdEtReWI3Tm83QkhodTVuSzE3TnVCZXVmQld0QWc4MDFENnl4SitJdjJi?=
 =?utf-8?B?anNBQldmWUNJM2oySGFsaDNHWWp1bDRUL1IxTHJuU00rTDZHWDBGbWhPVU5C?=
 =?utf-8?B?NlBzVExpc0tkUHFmVTg2R2g4K1VZa3h5YVJtWG81S3M3dlJJSmFVZEYvMlVB?=
 =?utf-8?B?WmorVG9ZdHQyaTRSSVJVSldEL3Rnclc0N1BMb042SVl5VXFFcmtnRTd0UlZp?=
 =?utf-8?B?YjdPUXhuenFPV095VHdrbHF0M0ozMHk2ODFLSlZtZTE0Z1lPUEUrSTd5Y3ZZ?=
 =?utf-8?B?UTlOYU92TGJqU1czQVFyTmo1dGEzRHJ3L1Z0Z0VGSm1GUmdpUFZndm1TOXhi?=
 =?utf-8?B?eFU2OFBZVHVobU11eGwzQ1E5MkxlV0xJUE9RRE1DQ2pTeS9jK2FBYlAvTHR4?=
 =?utf-8?B?M3pvR1UzbENUT3FGNXpPN1ZSYXZUalVWenBVa3ZtRG50aUxQK3h4ZmtGenJB?=
 =?utf-8?B?b0syb2NGRzhIUEVzZFl3cGxRRUdObEplazhOZVArZkE4OHU2SW1MdTkwM0FE?=
 =?utf-8?B?aUx4MWUvRk1ydm9vZm9ub0t1ZjdPdkhWcjZoYVdQRy9HSVVqdHE5d2piamZK?=
 =?utf-8?B?SHZLQW5hYWNxejlNMU44cTBIYjF6WFloYzljL0RKSldSVnpnZXpGdFgzNEll?=
 =?utf-8?B?VEtkWmh2N2xESGFFMFJsY0tCblBIcE8zL3JVMVNGTGdNcmg0Mkh2QWJ4akhG?=
 =?utf-8?B?eFF1OW1QMDNnK3J0WjYzb3JQVHVIcDBueUFwVnRXTVp3WnN2Q3ZhMVRHU2w5?=
 =?utf-8?B?UHYvZXhaRzZNNjZIQ3A0U0RvcGUvMFBxVkZMMmFZdWhKUW1pZC8zdlZKZlp0?=
 =?utf-8?B?U083R0x4OWtJNWNDVC9NS0p1ZENqNVp3V0dZcVBHcElQN2dZcHJmallkQ1JO?=
 =?utf-8?B?MW9WK1l6dE5sdjJ3eFRwSUdIcFh4U1lVQm1wWjdZK1FCZDgvMDY1STZzWlZo?=
 =?utf-8?B?TFV6ai9zQjJPanNQMzN4a2VvenlHdFU1b1NZVzY4aE94bTYvQ1VYd3MrN0Nr?=
 =?utf-8?B?OE54ZklyOEIwWGwrckdMNXZiRWk1NmkvQnZ4eTJTTHhBdzRQbTAzMldwU2Ji?=
 =?utf-8?B?MEcyU3BrQXV5RStzQUZMS0ZseStxZWVmdVdQK2t5TkV0cU5vL2dzS2FqTFBl?=
 =?utf-8?B?bndHaE13OHdDZi9FTXZuU0gxYWpkVnJZSENFYi8ySzc0RU96VWUwelQ2ZmRu?=
 =?utf-8?B?OWdhT2MxaFVWdWxhQU9wd29CbGV6V3VXbFRlTUl6aS9adjZPUlFOMDA1Mk5K?=
 =?utf-8?B?QlB3cUE0bit0VUJiQUp4VzcwdEs2NWg2U2NUVFIzSHFYcHhOc0JMV05iTFkx?=
 =?utf-8?B?VmNQdDZFZEFWN1VIa0hVMFhCTlhDMnBtSFk5MnQrVVdiMUZ0KzNNWk9PWnN5?=
 =?utf-8?B?LzVwOTBjejk5aHFPclhXcm1FbTFuako1K3VlWWdMY0svN1NncGFQRTNUOElp?=
 =?utf-8?B?RWtmU0I2TmVwREkzekg5OW5kSlF0Yk1ZaWdhckhodldLaGcxbExqdi8wci9r?=
 =?utf-8?B?S05xWXJJT0o1UnhVdmpWdDFDcWQ3ak9qaTZFdGtOKzFHWVFQUTV0czZSMGNO?=
 =?utf-8?B?WFU4YWh1dGtYa1NOQUpZcUl4SlE1UkhXZzZYSGdJTkg3b3UxN0YvV0dOWVRi?=
 =?utf-8?B?NFVxUmtvRjR4TktUY1UwYVJjR3pvRXVZVEMzMERmYUNQR3FFUjVDWExOTlUr?=
 =?utf-8?B?N2pnVHBqODN3OXBUZ3hHUUNuc1N0a1JrRC9DVTV0NnJwMnkvaXZxOW5CelVB?=
 =?utf-8?B?U29Hb1d2SXFwUDlSVmxrODZHSWxka2MrSGNMQUhGUVNXcVVtYnNtV2FBMG1V?=
 =?utf-8?B?V2FzY2dNaG9OV0FOUW5mYUd3R1l5em1BQ3pucmhMbE5YMTlnRm53U1JzQmZ5?=
 =?utf-8?B?UTVpU3l5U1I3UURUUnI2QllzSUJmY05OS0dmeXE1Slowdk94SGU2NXZ3RlFL?=
 =?utf-8?B?Y1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uhvfrtrNqfuAvUjFLjVk3Him1a68PjQLeScxYNMQ9IlfgJNG8MdMu7A9gfvPLiCcouwn+PGvcrMArx3/qBMBOH7IG8GSn4B9637b6Yf51O8l5i5IVJgmplR6Yfov05Mbd+y9JWPLoOSYpLqNOXM9fyDGmZD4v1nCtQGFatEHWCHJU2KF/osC1WhwZ7190eBuJEQnMoUCLeNUtlFuCXjxBq0eUgWM76EtQyPHg02CmDCmSmXYMfTOTdL8ZBJtIxKp/fQCU8xW6u5U8o5mYfNLBVLiJNK5FG47tEwyyLslYy9FOzNQlwMG1gHC2hQswRB96J4imQRy0hUp8D3rjmyp1gPs9nB7shmJteYZ7NKf2NGDaEz5tKfUCBGsVeIcapvpa4Ls7ZtafVV8pK6Bxb7zjnMhnfHpKtAUPhHXpzUN/zepGrfWp3rlEdWxChU6WuJzfPyEfUL11E7Yn+BBT1wlD4CLHyqNc3gJLTlorTkg8ksN2E1mhMT4vtPCumj66FXwyabx+Jm9WtcmJ5q2A7++EZSuxWowKauvidNDw4017NhFLb9bMdSUST8ooPdGBduBRNLmRCCbRv3HnFZV2TYS8Kq+biTyF3ZGFBfbcjh3okg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70658f6e-2694-491a-359a-08de2072a30c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 16:03:07.0037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4svyHD9+JaRbNzLpzfuzNMToQvDeCwDmm9qxP5vGu3intgGc1sk9Xvifl/m2HpDggfqa4bSOXDJXlPyL7cWa2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4368
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_05,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511100135
X-Proofpoint-GUID: rlICQKWPLRJmFjqXPdOxGU5nPvF2vD3e
X-Authority-Analysis: v=2.4 cv=J4GnLQnS c=1 sm=1 tr=0 ts=69120cbe cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=yj9OWSHv3zJKDy8vTwUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: rlICQKWPLRJmFjqXPdOxGU5nPvF2vD3e
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDExOSBTYWx0ZWRfX0cRLtOUPlDPo
 zj/GauCpHyGu/lydAkmvOjgOAroBjyO37mprF1aBSFbYOaH0xCzxWfZzUx/Bj4XIzazD8Et3pmR
 7Y6+lwsdsr2pI+BjiQyVuNLCOSb6UEnSloJc/8jXef3ETlIHsZTu7zdxlEs84AbzJUD7sFqRkNg
 q1yrHH9jNYpWB9eYbIirmf7bPU654xX20NdCdYIFG7HqOlSjBg/IIzQATJL7YLE+cpoBNe2RVJo
 oLdKPAtJAblfEDB6k0FzLI7NES+nADBWD589xBie4RNZ9SlOWYcmgZR7JnRzXeHR5XdP5+WlcuD
 dv7E+6G9CImjsmEyEJ1UOYw/L8sbttUR4ViNA/kFSyqVzavTrapD+mPJPhQLNdvcRBFA298VBlq
 YD+xn4iN/7Cn59GpvjmZZXRJoZXKQA==

On 05/11/2025 15:01, Mikulas Patocka wrote:
> Any bio with REQ_ATOMIC flag set should never be split or partially
> completed, so BUG_ON() on this scenario in dm_accept_partial_bio() (whose
> intent is to allow partial completions).
> 
> Also, we must reject atomic bio to targets that don't support them,
> otherwise this BUG could could be triggered by stray bios that have the
> REQ_ATOMIC set.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>


Tested-by: John Garry <john.g.garry@oracle.com>

Thanks!


