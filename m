Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4656114AD3F
	for <dm-devel@lists.linux.dev>; Wed, 22 Jan 2025 15:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737559159; cv=fail; b=uIyuUwJ7SiIbbUUpDtsNRiK7ZmGjqhoT5gPvTCk/3khOnMiTz2y4Jgr1nSBr8FNqI5L0NRsBQTXsCZWjMWK9wa0Dhfb3yv2RIE+vJk69700w6m3FaWbS6CsKSbMvCkqNYxD3MmTqLEtAWSUP+YQxKKL631pDvWsvaxR48Te26Cw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737559159; c=relaxed/simple;
	bh=yrnntL9R7gub6Tp7xwqCJsMTlXe3wjYNDDNbig2Poss=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=spsAnn3L5U/WYizet4tWNzGsGwceXhZybAjOR1d3BcVsppNrEy6u5I8PsAvzkcE9aokGsowy00y6tZkfwieXl0uf60uAPRJ6Mjm2uD1iwm9JUtk49wTXQHSHSifMMGXAxCLNGzScpejCER+RA2UaSz1b3l+k2VjRaaLvrA3iYuo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ntCGBF4W; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qB0+se9k; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ntCGBF4W";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qB0+se9k"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50MEXmic028958;
	Wed, 22 Jan 2025 15:19:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=mL6Zj29laty2JHex68NwDs0roTd3/seMICxWSgfu2zQ=; b=
	ntCGBF4WN8LMRDpnBTXImLEZ74tIv3uOFgV9ktWPQHILfF98ULHyhoNkATYbYpRL
	FZI7dlzzMeJiZWKwg+MJYYUTeebHaOjo7yvM35y25NHqVvF6w1JV4Ak+ehFO9CV6
	BhK661LDRQuF3bsW2MT/Avm07XbprfPnDpHaujB2oeiQnmp4pZRFlfIgJ29lqsSR
	LBHJp8G73km3Y4XXHP9+d5h9jpXykRku3URvvXELrOQLWqXjV0dP4y9KUp8vy/Tv
	3MyW4d8JLXR0D/cBrrxgLns3Np6KzX0NNDXLGYGYL1LuoRvzg9F9XtrqoMLWup/n
	dD7S5cBDJNrgz7EOPsC9Yg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44awpx0nwc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Jan 2025 15:19:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50MDnBEK030432;
	Wed, 22 Jan 2025 15:19:16 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 449193xv7p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Jan 2025 15:19:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=At5GS2y+h3rOSASAn7IUIVKpc1VHg98AtVsZ/BAHcflRkr8tMpj9GND7PVItmNkpDZCY/fJPZTHpi8TANwkJ9gGfSQDtA/cdp1rXMpxSutOOkkwy6caHWNjjAqc1+H3/S3K0gySrxobFpdRTqpDKkA01ZpK9GEoTTWP/SQZeH2pw22vTzDWFo+FTVo+lfkthu7tD1B8NHdAz64UziEaaXtue0TlW4s1iSaYGZ1vtpKkl3H3DcE69oXwD05IMk47OVvWqYgOxGaMn+lgWbxNCvH27aZmnvWYkMCZVao+01H0lsKPjUrtMMMdAgH1YIIOM8J7z0ubHMJWjTuX+MKs0SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mL6Zj29laty2JHex68NwDs0roTd3/seMICxWSgfu2zQ=;
 b=TD8kShdK+Rgic1BI6MlJkhFva/MO+9bRo+yGE7M2fx5+v58fchpxfwRN+yCy2CpHs0UKzPmNSajHg7LrJhoRrcQw9JZYFGz10y83ceVMUzKjVv/2ZwoH22jfXOLCWqvDvlJvyP3kujwTJGNoL5kS1KxHOi0jdKlDHp5DJzyNGIbfp/vzpeEqjeRx2zwBlthaZNTw4ZtZkQEEcTd9rvXMSlwiygbPG34OhuRvFRwM7MBbkAMWE4VwjJCrp/lKCrAyTFGq4M7WTyK123XhtI1nECeEOuF0Jc6F0/+gBziiDX7BQhFcpo+w4vKn4j0DazcVtE7pv7zsKAxW0g7p2DPyQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mL6Zj29laty2JHex68NwDs0roTd3/seMICxWSgfu2zQ=;
 b=qB0+se9kAzc0M0IqFIOc4doIpcqp2gVpUBzurNctGAvHA/TIHlvaPyouJt9vr/ObyzndBUUkBNjbk1Thr6NeNauOQHK/w1TGpsuvU2wF9Gleb+6qfMWmylQPwe8C/TXsuLLk5ZWyjpG1tUwKSdp+C5rk5ppl1aq2Wf3vyk07/yk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA0PR10MB7232.namprd10.prod.outlook.com (2603:10b6:208:406::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Wed, 22 Jan
 2025 15:19:14 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8377.009; Wed, 22 Jan 2025
 15:19:14 +0000
Message-ID: <9c6e2bec-55d0-4e76-87c5-1b660de548f5@oracle.com>
Date: Wed, 22 Jan 2025 15:19:11 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm vdo: use a short static string for thread name prefix
To: Matthew Sakai <msakai@redhat.com>, dm-devel@lists.linux.dev
References: <9146ca1541ef988061c22eddd03ae5f5905fc78e.1737513476.git.msakai@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <9146ca1541ef988061c22eddd03ae5f5905fc78e.1737513476.git.msakai@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4PR09CA0004.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA0PR10MB7232:EE_
X-MS-Office365-Filtering-Correlation-Id: 911c332a-52a2-4390-8f22-08dd3af82154
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NjNhS0VJeXkzMkZSUUhZN0h2Tk0wN0p3dm91OUJ4MXRMMEVTc2dGZnEwRlZl?=
 =?utf-8?B?UTNRZm5GVWpETnNZQW1Xbm03aHd6enpuWDJpcjhBcHluVWRRMG81bE1OTk5Y?=
 =?utf-8?B?NXhReFZwaWdDa1FrSkNEbHFjL3ZhWnJ5K3lPMWU3WTFuQnBGeEtOSVJhZDJu?=
 =?utf-8?B?a1hXc0FvbzBITitGL2JJNmdHNjY4Nk42VmEvNThvSDA5ZTJobE1hSEtLYzha?=
 =?utf-8?B?OTNnWHhiMlRQL3NxWjRlRmh6YkxOUmJhN0U4T2ZkNG1qN1gvWXFsN3Rkd2pN?=
 =?utf-8?B?TllJaVZpQ2NGVzFVQTZjaGNuaXBNS2dSUktSN0JNeXZTaEtzVGk4d0QzTVNC?=
 =?utf-8?B?KzRtcVlvcGVadmkyY0t0NjVwa1NaTWhGZXpKQWdDd1RxVHFqK3J2ZzAxSmVt?=
 =?utf-8?B?cE5iMlBRUGQ3N2RJT2s3NHpEUWgwRmNhQi9CeUszKzRrbmx1Q3dnTkR0TUpC?=
 =?utf-8?B?K3crTi9rbUVYOGsxOFZpU1JaaENld0tMNjJlMG8xOTBIVHJSdFFxa0dZYjFn?=
 =?utf-8?B?Z0ZOeWdCS1ovdWFuREQrRTNIaG8vUlhxRUQwZW9HYUxiU2V6UzhTdllzUHlH?=
 =?utf-8?B?T0lwQXJnUDlJTTVsb1RLMFQ5cUxWckovL05HK0hRMjVaN2hvRjc2TGwzREt1?=
 =?utf-8?B?SnZveVZwcERlcHJ6eWNuZXhSK0Z1OEw3MWQwYnZrOFRqWHhoTmpHWkU5aHhm?=
 =?utf-8?B?OXlMck5iQ1o5aWwyMGRiU0t1NTdzWi9YbFdVcHRXMkNsTjVOOFdUOGtKVUs2?=
 =?utf-8?B?Z2cwdTlpODg0TTlaNmsvNmZtZElFc2Vvb3V6U2R4T3I1U281aU51WC9RSUxq?=
 =?utf-8?B?YkRxYUk5enpDSlUxS3BKOXl3c2x3eTlhd2pCQUZsZFZBdzZDUEYrdzZGTE1Q?=
 =?utf-8?B?akliSGpwVHl3WFl4K0hDQkZnQ3NkbzBEZlZkS0ltWHhXd080YXFMTmQvV2Q5?=
 =?utf-8?B?R2xVRWhnbHhxbGxDREVObWwvMkp0eEt5STgxckx4R1E1QTN5SG1IRGxWeG0z?=
 =?utf-8?B?Z0I1K3gwU09YWlB3bGJ6ajVNU3VLVHBUUWxjdnE3NXhUaXFNVS9DblNQbEJ4?=
 =?utf-8?B?cE9WV0U1am11b1FiUmJVOHdLZzArZEhZdk1hTy9WcEFWekU2VWhpdjZtM0dr?=
 =?utf-8?B?Q29EekJPZUc0UGxpNHJ3UW9YR3N0WmZIb3l6THBObzV4b2twb1k3ZjlqOERF?=
 =?utf-8?B?SjBzQWtCMGh4WjRuMmcyYnNzUCtCRGFSbXROeDF2NFdtUkVBcE95V3pXVVcz?=
 =?utf-8?B?RkdyVzkzcmRIZ3k2T1o2SjJzQkMvT0JsR2E5RGFBSjlZa3h3UTNoUlRkMVJ4?=
 =?utf-8?B?ZkxlTTN2Smh0R0ZsNE40Tnc0ckNMSmRTZmFqcUVCWFZuZ200OXpXL1dlY1BB?=
 =?utf-8?B?azZMbzY2TTNTUHhISVIyRitjam90QUpQTDc5Y3ZRN2cxbURleHpvS3RkMkVW?=
 =?utf-8?B?ZThoMzRMeTBsMTVhdWZ6SU5weGRUSUpPZFJ4VGwyY2k0TklPT3ZlN0ErRFNF?=
 =?utf-8?B?S2doNTZuWGIyT3YvQm1kWDYwQWZrM2tpOW5lYXFDRW9FbzlCQlRobktIZ2tH?=
 =?utf-8?B?V2QrcGxkeDVxQkFETDE5ZHd5ZlpXUzkwR3FZM1hod2c1Wi83QkdDK29SVUxJ?=
 =?utf-8?B?TTBMRDhKc2R6Q0VxbGo0dE1GUlQraVRsY05mT1B1TlZOWXNVR1VrenFVellL?=
 =?utf-8?B?MlBTaUtsWE5ESDNwRkovajNUczFlU2hoM0xFOGpFcUhEWkxBV2hEQlRVazVa?=
 =?utf-8?B?MEpzSVErMU0rQ3BEYWFwQlN2SFJmbzY0cGUyenUzbnFGK1hXUDNEcStiU1BO?=
 =?utf-8?B?Rm4zTlRrbE9hV2plR2puRk8xU1hvaTVndUVXWEhxUUpxemU2UUJtSVp3SXd5?=
 =?utf-8?Q?mA+ql4Gq7kYvI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?andhTXd5ZTlCWlFMSzBOdkh3VmQydDV6YW12b0ZvMWZUUGl6RE5tUk8xb1JY?=
 =?utf-8?B?QWhBMVJQVmhGMzBFRWsvQTdHOHBabHByV2hXQktvM0dJVjh6blhtUWU3N0RU?=
 =?utf-8?B?blg0WEFPTFVWYUNvS3JMS0NsVGVqbnFSWG5WYkZ2VU9OWVJEcTBmWUJVMFhw?=
 =?utf-8?B?cmdhZDdZdE4vZ0tReE51MG8xSnNMMER2Y2lFOXk5a2pIcnlJRXRuL3VBdDhD?=
 =?utf-8?B?SDhCY0FQbjFTRmlUVWhmUDMzRXNKdm9na3puR29hNERmQW1mNjdLYncyWnp4?=
 =?utf-8?B?ZmdRcW8rdEZCRU94WTFXMno5eExVbThRZFNTYVB6K1hhSFovWVNpeFFVQ1NS?=
 =?utf-8?B?VU5qWWRnR3dpbzlObm9jR2RBa2tyNW5sMVQ0KzRJY2owbzFzQ2xobXZzNDdy?=
 =?utf-8?B?R1Ayd3lqcVZUTjJTNzFKdEhlajduOFhJYi95NjNjM0lPOVNlbWFSUFFyd3JR?=
 =?utf-8?B?NWxycmJWeXFlUDNYWXVwMUN6MHV5RTBETFc1QXg3SEVlTHl0WFpzTklLV2hQ?=
 =?utf-8?B?TEVNQ2pobTgyV3AvMFVlNlluNWU0RFl2Zkh6RVU1ZXozSmRqd2RJOERtTFZ3?=
 =?utf-8?B?eVZadi9OVk1uU0JZL2xGUzF2NnI5VHBlVy9oYlM1dzBTVjNNMGhXUmdkS3pI?=
 =?utf-8?B?KzdrZEJqNUQ4dkEwNWdsdDlJWWIxUWZJbzI2L3U5NUpCWGVXUnFvUmVCYitr?=
 =?utf-8?B?VUtSMXlIQ2FmbldOenVGa0IxSFFzRS95K0ZtbVl6YWZNY3ViMUZWRmdWWVE4?=
 =?utf-8?B?VlJObEN3WWZjVCtSRU9xS2MybzNZYlN3Slp0NmNkMzFUTW1YcFpGVGErKzRB?=
 =?utf-8?B?ellucnUzN0dXU1dydkNuR1ZQT0FPbEc0WkRpQTJEeGZLRzlJc0VGNlBUeE91?=
 =?utf-8?B?ZWJMMkNLOWtac2pKWXNjb0Y3YnpIcUtCQ3pVY1FqelNkK3IwbUE3Z3NIZm1K?=
 =?utf-8?B?b3hQYUUzSVlQd3pScWFIbjFISjd5YUJ0Q1NXMzAwNWFPVm9DREtvTkk0V3ZX?=
 =?utf-8?B?ZzNkY1BZNGgyLzhseGw3RUJ4d2xnNXVMQmpUZmhVU3ZEZUQzWUxHVjFVN29K?=
 =?utf-8?B?QkFKcy91TjVBOHh2WnNxUy9nMjgzcmFQUk81WldIY2RxR3VEbHd2UWwxWWRX?=
 =?utf-8?B?dFU2azBWanR5MTZ0cnlEYlhNU0FwTGtIRzFEdU9xeHBlRjVqektrZHhxVlcx?=
 =?utf-8?B?SGNybzJxYlk2T3FYMFFHRDNVL2pmSGN4SXppZmtDLzVobDhQSGJrbkMveGhR?=
 =?utf-8?B?QS9oRHUwdUc0eTVHM1FiekZ5SHVQWUxsbVhTNEpscVRvcldCR094eHFYZlE5?=
 =?utf-8?B?bkc5TEpxRnMzcTNVai9YeWRBRlkydkszcURYM1krOEU0Zkt0UzJyb2FRclNO?=
 =?utf-8?B?TEg0cWJZcFpyUk1qWmJoMFRkYlpLSjVNSzNBK1k0TTMvVE9WbE9QWDdHazN2?=
 =?utf-8?B?ZWJRYXpDQTZGbkltaGxtaWpTYmppcytwcDNmUFd1Uk1TN1BjVzRXVTZNQTNJ?=
 =?utf-8?B?MCt3dCtVVm1haXM4T01wVllFZ0JrZGIzV1k4dzJIMnlRcDNxaDdsNkk1K29J?=
 =?utf-8?B?YU44UGFuMzBlT0NHNmhwd3poNStkMm5VWEptR0NGUlo0N3BwdkJ2cGVhRitO?=
 =?utf-8?B?ZXoxM1oybWVnVHF2RFkyb2dZLzZwVTVYZEZaODRtM0I3NkNsNVd3clNWM1Uw?=
 =?utf-8?B?WVpvd1pMS2xXajV1L0N0dUVmbTg4c1ZuMUFuU3l2Q1RDckZ4bDRrUVdUcWVl?=
 =?utf-8?B?S1V5M0RkVS9hYjFINVJhMDJSemdjWnNXNFRoejRTdy90UDczR2lhbUQ3ZmZV?=
 =?utf-8?B?NGRBcjZnalRmT3FheVNtdnVxcG1DWUF5ZGdkeURVRm5MZWxIRXFRcGdrUEtI?=
 =?utf-8?B?QUdxY09RRWpxa2VDWlBSdzF3SVpwR3JuR2htSTI3L0VHS05aWlJpdnM4YkVE?=
 =?utf-8?B?S0tPczB3ZXJiZW50a0RWemlZRHkrWXF3WGhxU3J5UVFqbURBQThHbEo0dmFw?=
 =?utf-8?B?K1d5UTdVYlVLZDdWY3VQNmVlN295UXp6bW5TSW1VTXg4R2NxWnJ3MGZWQ1p2?=
 =?utf-8?B?dEpuLzF4eitLZW01d0NCV0daNFFOOFRaVEJnSTEydzlWQzBhQWVNcDBZb0tX?=
 =?utf-8?B?cldmd0xZMlRrL2o0TVdiYVJHOUJoQlc3UEFYS3BzS3dERUlFMU9iQmJkRUUz?=
 =?utf-8?B?cnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zolLVUZeRxVbx4TqFxosp3UX38tw5KmDgNlIjiIV+SARimELn+dNfyHtH3mtweRaSWj6rlX3T/lJJ206/id6jZqa7NY21vt4FsK0yvB8isLDU4zSNXvSDHhfp1zwwrsh+HwHgQdtUV1IzZL2VLqj/gxTOanm66toddhA3B998P2G0YBQ1mrkc8lTn5/1UAMgncSmu94vxKOwbmwWiRqaKPKz507+dCv0p+mvmLLBzz5YY0ppFufqYaDpt7rYcZgBuqccWdiun6eQwYg/02lfqlbTM3QuIGNdCmM2mNXdw3gfJavtc5JaFNu44hbH3GmhY91FRxL8OK5oFnVu36or3r522n68gJhPxFuAabS0gbGgGKio+PGQR/h8gxHyjSFqQYl84WG3gpxOZZugr56VIdr1aZ1KQ7Zf7MkGfpS3k6sdAE3MTtVHHSDe/NSZ3hmVr852aZ0ZAHhEgYMYm4t7GXAOK8qtkx12BkQQg6+hSHU4WloHQXhuzATVY7KbLNJX+HXyPO0Avu5YOHDeE2Y4wDkblCQAtiPICO4uqJOi0kVQS1JMjagQ+fErXoAJhjUlaf22tiRhVbVbD+ryK4gUvBqeBwG1KIrsn/S0KBy70k0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 911c332a-52a2-4390-8f22-08dd3af82154
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2025 15:19:14.4785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O17Rzgtw/ji/lmrQP7KvhiVWmQq0QAkIXJZYBptPoAcVSy5Nui6fL7K3XxkOSw51Zkq6bZscwlB3ubAj44EvEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7232
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-22_06,2025-01-22_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2501220113
X-Proofpoint-ORIG-GUID: 4wxrM7mtAhjz2c7XZodNqfoLdO2WRsbO
X-Proofpoint-GUID: 4wxrM7mtAhjz2c7XZodNqfoLdO2WRsbO

On 22/01/2025 02:42, Matthew Sakai wrote:
> Also remove MODULE_NAME, which is now unused.
> 
> This fixes a warning about string truncation in snprintf that
> will never happen in practice:
> 
> drivers/md/dm-vdo/vdo.c: In function ‘vdo_make’:
> drivers/md/dm-vdo/vdo.c:564:5: error: ‘%s’ directive output may be truncated writing up to 55 bytes into a region of size 16 [-Werror=format-truncation=]
>      "%s%u", MODULE_NAME, instance);
>       ^~
> drivers/md/dm-vdo/vdo.c:563:2: note: ‘snprintf’ output between 2 and 66 bytes into a destination of size 16
>    snprintf(vdo->thread_name_prefix, sizeof(vdo->thread_name_prefix),
>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>      "%s%u", MODULE_NAME, instance);
>      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Suggested-by: John Garry <john.g.garry@oracle.com>

I am not sure that I did suggest this fix, but I did report this issue.

> Signed-off-by: Matthew Sakai <msakai@redhat.com>
> ---
>   drivers/md/dm-vdo/vdo.c | 8 +-------
>   1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
> index a7e32baab4af..40b3ff8c49cc 100644
> --- a/drivers/md/dm-vdo/vdo.c
> +++ b/drivers/md/dm-vdo/vdo.c
> @@ -142,12 +142,6 @@ static void finish_vdo_request_queue(void *ptr)
>   	vdo_unregister_allocating_thread();
>   }
>   
> -#ifdef MODULE
> -#define MODULE_NAME THIS_MODULE->name
> -#else
> -#define MODULE_NAME "dm-vdo"
> -#endif  /* MODULE */
> -
>   static const struct vdo_work_queue_type default_queue_type = {
>   	.start = start_vdo_request_queue,
>   	.finish = finish_vdo_request_queue,
> @@ -559,7 +553,7 @@ int vdo_make(unsigned int instance, struct device_config *config, char **reason,
>   	*vdo_ptr = vdo;
>   
>   	snprintf(vdo->thread_name_prefix, sizeof(vdo->thread_name_prefix),
> -		 "%s%u", MODULE_NAME, instance);
> +		 "%s%u", "vdo", instance);

if you think that this is the right thing to do, then ok..

>   	BUG_ON(vdo->thread_name_prefix[0] == '\0');

is there still some value in this check?

>   	result = vdo_allocate(vdo->thread_config.thread_count,
>   			      struct vdo_thread, __func__, &vdo->threads);

