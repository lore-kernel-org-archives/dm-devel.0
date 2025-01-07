Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033311E2317
	for <dm-devel@lists.linux.dev>; Tue,  7 Jan 2025 09:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736243397; cv=fail; b=Wuyt2dgCSJIGaxHOgrD+s1YMzGRZDeNd/cXT9Z9awyQLIUOxKKBWxoDLvO4msJpqBZ9CIo1L/MmPotflyLBHT9jiNzblDkgS1kZGmrGrHuI7iCn7SK+ozdsf6eBRd6dvCH0z+iPkmn7V9ZHHchN7vjWnBWj1rY4G3ZnuGJ9VhQs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736243397; c=relaxed/simple;
	bh=tKmsVjJoOnbyvgKMLN+diX7Iw+lOgNj8W7qE7q7+Ei0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uF0HjXM/lMrneRV4D8pxxeNIrz0NpD0btFwF/tVYP7jlda/HU3QgSy04rvtPOk/CaqvyM3zH7/tfn5j/6PCHE/1yJ7vlmGg1IVssEQcPjcPtlDE3EJ3ruKSVfJP2rGmbYTO8v2qLOWw98uMsAyJnbYE52YavEs4TiS/aaOW/W3c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ngdQoCMk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zNUblBas; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ngdQoCMk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zNUblBas"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5072tnv9005999;
	Tue, 7 Jan 2025 09:49:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=7YgQocsSK3Diqt6jdPEyKFgVEjUn1cPD+2Jjl8V8CKI=; b=
	ngdQoCMk+apKXgQgZUupI8iSTM11o/TKGRPavR01mHPaNND4gbD3gfhrbq3HUzSP
	2uX1bilpcFhaPOumBkDESDx7fVBFN2PxMEkPqsoMyoTGJK2TfrwEr81ebTuzgy8u
	bW2j4XX9qm/7R8T7yk+nEBS0SC5Qg8Rsty3+kb4mxLAyso3w3mpN1kxlY1T6k5WY
	knsKwSHQrl4NDloF3dngj9Kq48O/qzz5dFUN3s2RD2LcMG5e05dqLIk1XjMud1oa
	qeX5iynsVXUHsiNbOnYgt+iIUAzBKe1qwqxSRPMawVEvOViysXmiBa7G03bPlDGT
	JfNa1J/H0tcUk0cYZkKUow==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xvksv0u4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Jan 2025 09:49:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5079Co1e027675;
	Tue, 7 Jan 2025 09:49:52 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xue8hxeh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Jan 2025 09:49:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m/KEf7UJyZhtFq0Y9E7GtTyhZLbcq1JmoPjdhRb4ieyz++HnEeQo7KTEsd/n19RWzxR9aLP+uLC4N6iSGceI3xExd3+YFezCwBkuOXcuSTfAP3FjYWeT6i+bYEuMRs6sHJHGJG9VHixMuhFEnNx7orU+mce5Cj1I/hqWwVAMTQ4z2ig4pZecjgf2M8ZNQoYZ8INSzGKF+ZvIxuODxa2wp5r1q3CrbRZpy7hkT74Wd2qNiFI4tQzegxSY3gyAX7+0T0vgWzsAOtEXb5y9aC02ViL3zLw13xGvaN4PV9domcPGax5txM0zskHyt6oXzn46HVz7FgKV4Sxx5W081AGzNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7YgQocsSK3Diqt6jdPEyKFgVEjUn1cPD+2Jjl8V8CKI=;
 b=T+AKbkdWkzDabg3vQshFjgVa5rYrpXYqkH/Q7SD2adM6jHUMLoqro187C8q0hxUx8NQ50z62ne+87fAlAU3zFJDPPJTHYpxwpjkY0bCcVbH3Tfz/X61vUZQSSV0E8zVu0a28qZmoOhURGhYywTrwKmisAuTMe5nM2FMYTx0Os4JnV0HWwdaXsYXZfif3UmDSITXmNGVEztPvSLtwIaIKdxPQZNkb/hs9jLV3QLSYE0iKKz7W3LFKX1mDUI9pTC7Xr4sO3FZuvMvHHrwpnbzImtUgK1qoQvRMU9qdX2fPYcHKHT/UP1tkWumopNfpDe42r7LCNHYyCCaUAOXyyfE6TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7YgQocsSK3Diqt6jdPEyKFgVEjUn1cPD+2Jjl8V8CKI=;
 b=zNUblBasDdT5b68jjsolko1inQLxYeoJhqcsg0DkW/OHIrs67wue3Tf9vX/D5Y9hIfnG69CE3uF5pTXw78xVIUU/CGZMGRrYYJpgpnCek18QCUOeyzjtDokMZcB00UP84R7ZPvHc9VChepzyjoZqi+AO3apeSjKGHSgQ34E1QSI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA1PR10MB6898.namprd10.prod.outlook.com (2603:10b6:208:422::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Tue, 7 Jan
 2025 09:49:45 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8314.018; Tue, 7 Jan 2025
 09:49:45 +0000
Message-ID: <a9b32c24-f380-4a0b-a59f-16e2e87a833b@oracle.com>
Date: Tue, 7 Jan 2025 09:49:42 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm vdo: Fix W=1 allmodconfig build error
To: Matthew Sakai <msakai@redhat.com>
Cc: dm-devel@lists.linux.dev
References: <20250106141731.1341034-1-john.g.garry@oracle.com>
 <1d3beb46-c244-4ecf-8bd6-1895954c8e4d@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <1d3beb46-c244-4ecf-8bd6-1895954c8e4d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0246.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA1PR10MB6898:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ada0f56-bfae-4433-a4c2-08dd2f009dbf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VFdGY3U1TzFWTlRZUWxQVzQ0eVNWdHJRbFdNVmcrQXNlR1BTVlFCRktmZEN6?=
 =?utf-8?B?dEtITkNpSWtyTjdQOHB5a1M5c0Z4aFdpdml4dkVjYlFRbElUV0IwYlpZbjVB?=
 =?utf-8?B?dGtYTVY5YWdhUUVaWjJ1UVl5UlFJaElqNEJtTUwvcW41aWF1bVdNamxDWmhn?=
 =?utf-8?B?M3Faa1FmeWRXQStOUHJWb3BYQ3BCZnMvbnJZYnJaa0JCL0UrdzhnNGdhZHdZ?=
 =?utf-8?B?elVRc0luWG9PQjdXYXN0NG9RaEhMN1pHc2Y2empBSkVwVXp2YXZnR1ZiMSto?=
 =?utf-8?B?TlJpMFdjR29jYzhNSHZDYmd6VDlTOGFrSHlJOHJmc0R0N0RoQTZRT0FDU0hQ?=
 =?utf-8?B?NmZzSnpTdEVKUUVBL2t5dXVOK3Z1Qi9hV3RzMWxXTE1SejlwOVY0ZFRJWDVY?=
 =?utf-8?B?L3ZqSHJCVEZvV1hGSFlZaTZSemU5QnY5MEhxMkJ0dUdFUmVrRWMxdDdwSDJQ?=
 =?utf-8?B?MWhKeDU3NkF4M2VHS2t6Y05XV2RQa3ZuZGdyWmtJQW55RGRDa056ZFFPTU04?=
 =?utf-8?B?RGhnU3g0a0M4TWd5YndyVzZLNStDeEFUQ09UaUprMndNYTdVSDJZSzVxSXps?=
 =?utf-8?B?dXB4R1hwQWd6REFmMHl3ZWNNQmcyQnZ4aHIrODQ0K25UZzZqOHlBaFo0SXpX?=
 =?utf-8?B?Tm1PU0J5eFVteGtpRm1JaHk1VDZlQ1g3enZTZi9TTlB3RjBEVFhRc2ZkdUVX?=
 =?utf-8?B?TXp3dUl6ekhJelBCcU03NFcwSTZ6bnBBUndTNnVrRzBPQkFKN0d3RmJOaFFs?=
 =?utf-8?B?Y3ArZk1DOFZ3VDlmL29KOUtnclNYTWpTV3JlSWZPbGpiME0vZE1LRmdTK3Yw?=
 =?utf-8?B?RmF0SFMwSWowTmFRTlo1eW9VTU5Yc1hIRElpSUJFaUVTWWFtaG1lTU9mWDlP?=
 =?utf-8?B?Z2tvZXh3bzRCZXBUUnNRL2FLclNJenArUHRyUkFFRlFEcXZ2RGRBYzZLK0pD?=
 =?utf-8?B?M1ZjVk1WM2tLSlpmd0pFTkh0ZHVtbmFSdEw4UDdFUWVHVjJteWNkdFpGUGQ1?=
 =?utf-8?B?bHRTRDVyRzBKNnRaclBtT0N3aFpJVndTUHBDRmxZdExUNTE1UXpSblBnRnlW?=
 =?utf-8?B?Y2xrQjRPakFBcGpxeEVrTHFVTUcweVNxc1AveXVVVnB5cWlvSjcydzkvWUk5?=
 =?utf-8?B?MDNoSi8zR1dWMnI4ZzU2N1hoRXZQb041cE81YU9CUlQ1cUNzZDc4d0ZaQlky?=
 =?utf-8?B?OUxpclBRRUR5STRNRzNDOU11RmZaZzAweFhqS29hcmJ6dCtoWG4rRHZlTTht?=
 =?utf-8?B?bWhwZlRLU2JGY1dIM2dMK1JLUGZZYWNRRFBVeUhtblhCVnZudDdJVyt0SHRS?=
 =?utf-8?B?d3RLRTNSME5QM2RzSjE2T3Zpc1YwZEFaMFdhditLZkNQNFF4MGpQQ0xiQkJP?=
 =?utf-8?B?VDNzNUk2Q0ZaMzZVVll4NmVXUEwxVUhKcStWdjhnb2g4bEovYnN4bCtES0tz?=
 =?utf-8?B?Y2JmdGZPckpYODNRT0tQeTQwbFhaRmtjYlE3bll3cXpTZ3RIWnhjTGx1dU1y?=
 =?utf-8?B?MFBkQWd0d1B2ekRkSks5L2M4d1hxM3pQMEJQUHhXbmVycHpwdU9rc3VyL1pk?=
 =?utf-8?B?eDM5KzM1eTB0VEZ0bnM1Z21TRG92TnVHcU1BYjBWeUpWQzRZK3ArelZrdjFR?=
 =?utf-8?B?dW4xRXhWQXJDNDlCRk00VlkzR1AwSnlJUVYva1RCZVk1MDJLa0hSdzUxL2ly?=
 =?utf-8?B?dDVXMnpyc2J1eUZPcG0zSlkxczFFcDVmV0lqMGdMcmowT3U0NS8wSjVnK3Qx?=
 =?utf-8?B?SDVWNjFVNWZEMTdkZ1YzbVUrTEdHL3Q5bktvY0s2ckhVZ0ZMM0c3VzBOYlRn?=
 =?utf-8?B?dWJGMC9UNGl5N29PZ1hoRndOWHZDam8vVTdGZkRxL2tHTFAvQVpOSUFHMU50?=
 =?utf-8?Q?R+5F1CFJcN5SG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RWxxaXFHMmJ3YVh3aC9HWVRZRlJZMnZGaXBXbW5MUFJydFBCWGcvOUtST0U5?=
 =?utf-8?B?ZUdtanl5b2lZOWwxeWd1eCtpRTNaTllxSnZOQUpZZXZ3aHZNT2lNTE9XcFpH?=
 =?utf-8?B?SWU2OHJKNEUrTzFaV2NwNHo5OVlkN0paMDNhT3M2THVHUEcvckcrK1BnRm4w?=
 =?utf-8?B?d0hmMDU0dnptMFBZWWxKNFY3L0ZQY1RrS2ZBV0k2UE5lcGxVVFNycDdCeEh0?=
 =?utf-8?B?ZlJ4ZjBjZzdOMysza0hkZWwzRUdtdlpHSkxBbUswZDdadFJqMkMyWHpmUkIv?=
 =?utf-8?B?cnc4eFV1Uk16ZnlRUVdYcm5DNENtTG5mdU10cktVVXROQUhDSDk0eCtVc0My?=
 =?utf-8?B?bWVyRi9jWTIyRGc2TDVYQU0wNVREUXNMSEo4dTMxQVhaUzRiWmpFMTQybG1q?=
 =?utf-8?B?VGpWRzVJZ3piVjBRaFAzcEdrR0wxVHRRZEVYbkoxRnp0c3B3ZG9tcUpMcXlF?=
 =?utf-8?B?TkF2NTlub0NDR21PZ2FXTDZDNjRzemswY1dYb0tIYStFWU9NLzd2UnhoWUEv?=
 =?utf-8?B?eVVVTFlOY1lTRThjb3k0b05WMXhEZzM0RjBxNXlNRDV6b21xVmxKbWtNNGJp?=
 =?utf-8?B?Rnd1SGVFc2E2dHU1VjAyMXVwQ3QxS3lUOHR0OVltL1hRS0JkUkhhRm9USW1W?=
 =?utf-8?B?U1NPNG5oTk5rcDlhYkpWWFhwRkEwMTBJMVVPMlgreHhoMmtzeXJUclQwNitR?=
 =?utf-8?B?b21qTDdNdm5helZNZ1Q3ZmNCcFFSWGxHNXlNTFJ6Nk9WWEpuTnZkSUpXTWxN?=
 =?utf-8?B?SWhlbWZWZHFRMGU3UktsRkJkUERGSG8wYkJqVm82ek0zUXdML082OWI3VStR?=
 =?utf-8?B?YnBkdlRQQUtUUkxnL2VtMVZQMDVjWjV3NE1veUo0M29mdHZvVFY1MnhFOGdy?=
 =?utf-8?B?cDF5V0JzSmx4aFdSUEhaT1h5QzRwMEpVbG81Vks1WjV4NU9jSDRUK3dsUUFq?=
 =?utf-8?B?TjQyNEZ2TTVVMysrRHV5TEg4TUlUdFhmeTNXVnpvRGlZNzhPa05GQUVWOHB1?=
 =?utf-8?B?MnRsZXZDNC82NG1rd1ZNamdOUGZwNmZIcXU2VVhwL3pXN1EwR01GWVJlaFla?=
 =?utf-8?B?UzJUVjZYQmxXUHZ1cjV6V0FHOHFkVTNmUWh1TUZnanVGcHRTc1VNeW15VFBi?=
 =?utf-8?B?bXdtNFFUTDZoYm5Ic3lRRWdtMG1ueU5iSUJsNnRHNjFOL1E0bnlMcVB0U0g2?=
 =?utf-8?B?SFlnLzlXSC91NVMrWGxLRVJHUVNDMC8zdGk4TVVXa21uNnY5ajZFREd5WndJ?=
 =?utf-8?B?V0I1TUh5R3RKcDhRMTk2bjkxQzgzNE5DZWJvUnpKRnE3WmZIbkRVd3B3V1NN?=
 =?utf-8?B?VWZBcTUzRkp5d090UC9WYkpOWkI0OVk4WGZyNnlOenZzSWl5c2F3VXVQUkI5?=
 =?utf-8?B?c2dDMFU4ZmxjOUszd29FdFI4ZUdlMXczeVo0QTllWnBSVGJEOUUzc2hiVjZ6?=
 =?utf-8?B?RXg5UVU3NWFNUVVEQmEyQkJTNkNFVXJwdXRhdlpyWGp1dkJwREtYR003ME9p?=
 =?utf-8?B?ekRMZFVrTmJjZWJ4QTlUc0lNeE9wMFcxK05ySmJKZGV4cGNibDFJRTgydzAv?=
 =?utf-8?B?Z3Nhc28yOVp4bmFSSDNONjJKcmd1YnZSeCt3WW11SFRCYjZEZ3Yxdnl3T1h0?=
 =?utf-8?B?cDM2R1ZXblpnK3cwem5iRk9WS1MvVGxZZ2l6OTVMdkNtakV6NzZJZmZFNmw3?=
 =?utf-8?B?eWE5dUhTR3UwRlVWY21HSXZXWFp4MkxBQTRGRzlIcElYbHNVbWxLNTk5SlhJ?=
 =?utf-8?B?K3dTcCtEVCtCZEE4eW9kWFBHZENEajM2Zitnc0t6V2lzVzV0WTlpWW9oSFo4?=
 =?utf-8?B?VUxFQ2w5cFBlLzFxYUVaT2dFcVNOYm53VU0xOWd4YWFWNldYdTM4dzNYWmZw?=
 =?utf-8?B?eURKU1RMV2JOeWE1S0Z4ZVp2aExUcTFSQjJDTzdoK2ExV1FVSXNpK0wyMXBu?=
 =?utf-8?B?K1g4TS9RVXZUbnFTd2VhSFMvYThFZytCd0ZsL080ZTJLQmF4bzlQdUM2VGtp?=
 =?utf-8?B?SVBSd2YxRFVFTURrSGhiSFRROEVyeVpsMzdoL0lDNy9hMElqOWluVW8xckM3?=
 =?utf-8?B?OENrcDBFS1lyWHVDdVRLZFVab0FyTGxJNjZEdXNHNlFHdVVZRWZEK2pQUE1o?=
 =?utf-8?B?RCtKK3JQVWRjREJQZ3dBQVQvYmxkZ1RhUEx0dEN2R3ZudVp6WW9LMUhDNHZH?=
 =?utf-8?B?L1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2mKfU4br1syPB2D/h7xDQ4tkkW9+zfh9wU025G/WYIDqZfqacdX9MI0C4nbyYdazs0akJ7Ps3GWXjHjzQfdxppkAtDhpFTe37znaF4Xv6s2O5pg+MK+9/jazneS9JNKJSjSwTpwmNmEGda2FbJYfhbjCsQds7r1uy1PHJgI+RaoxID/wMJhsNr4piZVOQYEQymU0qQBk4XL3iAiaGFdXASXZCLyNYvmXLlSHnhIk8G4LLKOYJcSkN4PKrDKSuEOrM1uB+ZSFi+UG468fFQuWWvBgAwrOj3W+xZBoN0PlSDLt55xkKWBtt7WdGiOLQe3TkQcpJ3l8eCUId7xPS/aXlPRGTwirVQWOiZrHUgEXG8lSAmsyjH1Yc/lRQBrZJVSfxEkslamy/j0xILVt071egT6u18SC1DvCkxAe15oNShQ8iSeNsmTx3+AtvjCdj2sx66FsBZtHHNwpSMc3ELpcVOLbCPGgTG5h4UINw8jeO9FYZXjr1hXTHwsDQYqUCRE7+U9XT2ChmAUV3rNsIgGpo7eqGuGNwJQbSsYFlI9x7sutJcRO3LpgxwLJ/dmLUxPJhgrfoTKK5AoeXoBc5CHumKezbSV6HMTXZoUUZLBJjIw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ada0f56-bfae-4433-a4c2-08dd2f009dbf
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 09:49:45.7745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ITjqtjIlQc3Hp9LpHNuud90fCX31hTLxlaS430lvWjXCQouYN1lMq42q1fXuOSswE9ppaB3g57+8MCCHygzstQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6898
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-06_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501070081
X-Proofpoint-GUID: zy8gz4tI6RW2Wgy-OyiSEBOvdjc1zW3i
X-Proofpoint-ORIG-GUID: zy8gz4tI6RW2Wgy-OyiSEBOvdjc1zW3i

On 07/01/2025 01:24, Matthew Sakai wrote:
> Hi John,

Hi Matt,

> 
> I'm all for getting rid of warnings where we can, but I'm not convinced 
> this is the right approach here.
> 
> First, we use snprintf here because we really do want to limit the
> string to 15 bytes.

Out of curiosity, why is that?

BTW, as I understand, for CONFIG_DM_VDO=m, the module name is "dm_vdo". 
So why different MODULE_NAME if MODULE is not defined ("dm-vdo")?

> Making this constant larger doesn't maintain that. 
> This change also increases the size of struct vdo (in vdo.h) by about 50 
> bytes. While that's not a lot, it does seem unnecessary.
> 
> In practice, we know that the our module name is only about 6 bytes, and 
> the instance number will never be more than 3, so snprintf will never 
> actually truncate anything here. Would checking for a non-zero return 
> value suppress the error?
> 
> I'm also confused because I don't understand the difference between this 
> line and the similar use of snprintf at drivers/md/dm-vdo/funnel- 
> workqueue.c:430, which I presume does not trigger a warning?

For that snprintf usage, the compiler just doesn't know the possible 
length of @name, as it is a pointer. That is why it is a good reason to 
use snprintf.

> 
> Anyway, I'd be happy with a version that suppresses the warning without 
> changing the size of any structures.
> 
> Matt Sakai
> 
Thanks,
John
