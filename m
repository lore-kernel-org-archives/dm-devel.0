Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF6C299AAF
	for <dm-devel@lists.linux.dev>; Wed, 15 Oct 2025 07:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760513444; cv=fail; b=X2g/SUiH1RtSq1t8zOHTQL2MdGp6QHpoYr1g2NxmWIzaQHdbecX+SedP64cvHBLZX0wHQe5Q8a5uUY0xVvdZybOPTQ0onV7xqHqOarzz8s0HawJLJTNao0JnaFZ/E/0gMRZAHSrOY2PlCqvGlz6oaQ07aBfkvMgl4/07rKA6t1A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760513444; c=relaxed/simple;
	bh=wJaDserIxrnDXpKritRj1r2qiFPvC/ZWTrLnJwXstp4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uJFUHVCnGKDcUQDxoS0doHObGQRoXAlUP+kWZuzsmvSwZZYTbiyjy1g+YJLegkFHrdi1RFTNsFYWcSqdxUTnlAUeieOHYIdSc40yJSnCEdn0fuV9u5Yt3x9lZol64zgLkn3IcN5KHlsgpasMGSU0yDAPViOTAlHShJuZUhOYmKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=DCLBd6ZH; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="DCLBd6ZH"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59F6SVEx1243548;
	Wed, 15 Oct 2025 07:30:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=kijOrV8XHRCKUKm09APP1OJMTpLr8KnSV9TBTVFrMD8=; b=
	DCLBd6ZHQnD2bfMm9H+FUqCNzZC9fYoIC+bWcWU46J7eQiZrMKSIsEMdbtusXXnD
	4FZTSgFDb27qfXRP2NKDbISZBycHoTdnqA2NDnxUbepTsbuLsF51V/4s8/fTCWgt
	bYrwpHGqp3rLsfIs+jluOE09MJF9G9FHn4/RSKyZUDFLyIMO5n+gh0TcqabJTskX
	TmuRKXi9UmwsQRmc/fCaKcTDosfDBOMCLSXwhUd+xhOyKW2jV9RXA8xsElDisali
	01d1k9tvHK1xgPf5NwNLOh7Mm7E5wzUo8xJ1V9b+KAnE1hR/AndIbztMIYqmoT4L
	bysHxoJIPC2Vb+JBsm2kew==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012006.outbound.protection.outlook.com [40.107.209.6])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 49sthh90fc-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 15 Oct 2025 07:30:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p4BtimuYhkn6h31h7Ll8EOZu8cCYvMqoAZ4e4AZM3PrZ6p1AQuuEmBQNwmAmgZMHz10tYHs9mw1ZZj3GbP/dRGnjISljFGueFQn4CtvrekF4G1vomWJx0skddxa1zoS0tVPCyK9sTVGlmCBZ/VTAwPhqro2i2WVoC6cIMHd4nWyDr+DYQpOXQESAirbqzDZKkJwN1N3J0WVJTsttFkXzXxeMEV2qY4fmhmqpqzBpfBs4wsdGutYr6xdp3qWhh9tjve+5O5P+ePjSNwWCfPGIl1EmvQNTPsOMtrMkiNs1yGByu5b9nqXizOoNllyTNQ6M//nWt4aIDToSgIAMTmQnrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kijOrV8XHRCKUKm09APP1OJMTpLr8KnSV9TBTVFrMD8=;
 b=J5MgHDfKkmnW6JivDCjHxfAz2RBYWztnrefF49CYb/URuUGYpp3cr0LT3dMaoxy5fN9C8mxliIA6epNBn7Qa6Z/g2IHFwXTaU5EfR16aVLpXNTbfQcjwqRXQaKZbBSxUaSfFjItvDbW/fPRZbWz5VICp5pK4WiUl6pfStN4jF2HPn480XyhQiWEFDv0tC2QIWkq6a/rat2LLYGdOb2YYfV6CspPXpZWZv2NtI5cSUcN/hxSZ+NndkrNZo/5zmktKJF/ZPwpigNqk52qyLZL7jUzvfyXvR2uSLCgjOa9AIUGyA6cx7lDqhhCOgabFrQXNPGQGsHiegJiYqLVmnDcqIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ5PPF2F7FC4EE6.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::81d) by IA0PR11MB7912.namprd11.prod.outlook.com
 (2603:10b6:208:3dd::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Wed, 15 Oct
 2025 07:30:03 +0000
Received: from SJ5PPF2F7FC4EE6.namprd11.prod.outlook.com
 ([fe80::5cd3:aaa1:1564:3e48]) by SJ5PPF2F7FC4EE6.namprd11.prod.outlook.com
 ([fe80::5cd3:aaa1:1564:3e48%5]) with mapi id 15.20.9228.005; Wed, 15 Oct 2025
 07:30:03 +0000
Message-ID: <040131e6-08f7-4f64-a317-deaa21e1a5e1@windriver.com>
Date: Wed, 15 Oct 2025 15:31:47 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md: fix rcu protection in md_wakeup_thread
To: Yu Kuai <yukuai1@huaweicloud.com>, Paul Menzel <pmenzel@molgen.mpg.de>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20251015055924.899423-1-yun.zhou@windriver.com>
 <86705912-07a3-4a24-bacd-ad5ac2038201@molgen.mpg.de>
 <d2574af5-9410-d296-ef74-97f3e43dc1cc@huaweicloud.com>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <d2574af5-9410-d296-ef74-97f3e43dc1cc@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1P15301CA0038.APCP153.PROD.OUTLOOK.COM
 (2603:1096:820:6::26) To SJ5PPF2F7FC4EE6.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::81d)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPF2F7FC4EE6:EE_|IA0PR11MB7912:EE_
X-MS-Office365-Filtering-Correlation-Id: 99b17f4a-6b0a-413a-3f29-08de0bbca7ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MUFrQmxHcWMrRHZROEUvNytyVmhUd0ZmcHRRZFNGc2JOcGxHdWV4S2NCUHZl?=
 =?utf-8?B?R05xTzc5c2s2bTArc3ZLNWdZbkFNMWczZlorU1E5YUloVEdVSVVMaGY2NXB2?=
 =?utf-8?B?T3hsY1JGTUx5YStNTEFnTzlFR2wycDlmV2kvNHpZZzBwT21hMXQrUmN2UTJ2?=
 =?utf-8?B?djV4MVlhV1VtbEp4YURHV2NubnpRNWpQL1JoYnkwTEpUaHhoLzFpcTFZNWJO?=
 =?utf-8?B?MjY2TUd4V3NxOG9DOXV6QnFYZ3Z2R3VweXZGWlNxSnVseGN0Qkg2SHBNdWVk?=
 =?utf-8?B?dGxxTlZQMDE5MGNrZzR1WHZLaGtjR0FtZ1FXWTB6ajBUTk5xSHRoUitmU2pF?=
 =?utf-8?B?MXFGUk41OXVuN1IvY0k3RThzaGZnUXMyeFNweGhOYWx4ZkFaek5DUGJSYzBL?=
 =?utf-8?B?Snh4NkxyQzU0ck44bkJGb2FCc2NEaVM4eXFBeHY3eW1RVVplSlBmVWNVWm51?=
 =?utf-8?B?d3ByWldvbGdNd25DWnNnVnlNM2JQeTA4dnlMT0l6RldtbFdKZ1l2WG1SbG9u?=
 =?utf-8?B?U0RQK2xUT0xjNno3MGxBS04zblF1SCt1b05Sc2QzOUNNN3JmQkI3N2xpMGdo?=
 =?utf-8?B?VmwxMTdBZHdNZE1BdzBOcVU1d2d3K2F3WS9RU2dlSGdYNjhzMkNGU3REZHJq?=
 =?utf-8?B?RmdONnBKTFl6dlh0RXVPK2NnVksyZERNbkp0OVVEQXNDTXhHRHQ0Z0liMnFt?=
 =?utf-8?B?eWxmUmVUUnBYRytHQjVWemFWQU1WQ0NPZmlaTmRTNGpxdGQ2bzhwNlNJek5k?=
 =?utf-8?B?T3I3Qi9zMUJXc2t4NjFXR2ZWNmEwQkVnYzVQNnlsd2lJNG1YWmJwcng3TnN0?=
 =?utf-8?B?bnNGZ2FwaklXYXRKWlE2cXZWQklJakk5TktudTNhb3FkbzFuVFh3OHcrMEVD?=
 =?utf-8?B?cmFWMkFOa2lhUWx5NTVqa0xmcFhram9wTVRPeURVdmwydkJ4SUt3MnVoQTF3?=
 =?utf-8?B?ZDRiUTAwUk9TZklGUXFrVmNiNkVGbEhUUFpJL0lBN1VVV2ZGTDZGdDJXdldn?=
 =?utf-8?B?T1ZtWW1BUU0vajBRbXkyMVlWRUtaOXZpR0tQMk1CeHVoUGFhRUtQcUtmM0xk?=
 =?utf-8?B?QU4zQjZpOVNGZ2N2b2tzZVJwNHhRbWpFQ3F3bUFPdmxmMThtUkZIOTNSd3Jr?=
 =?utf-8?B?eG9MNnhrZmRUazJhclR6bWlpMTRkRmU5ZEMvUlM5K0RJcDQ4clFIVnpsaXJT?=
 =?utf-8?B?M2M0ZnlJd25HQjl4OGNycW9VaXBOcjV0elhHdm96OTBPa1Q5eDFsQ0Y2MVFa?=
 =?utf-8?B?Qmh4dWNzTlpLNXA2aFFFL2dkZTFrbzJqWUgvL3J5U1Y0U3BFU0UwRXJsWVJY?=
 =?utf-8?B?UTNFb3RFVlpweVpRSDc2QU5XZXN5UGJydVZPQmJqUHc0TVRyV3NpaE5DcEE3?=
 =?utf-8?B?VXAvRkJHY1liVHAwclZOU2N5SWpscFZtY0t5dWhQSUdzSkZVWkdXdXVZRUgw?=
 =?utf-8?B?alNRMmkxL2xYbk5Pb1NoeW8xWmEyU3RwdGJ3aGZsV2xoMkFsM1ROcklxNjZQ?=
 =?utf-8?B?Q0JWWUZnWVRjd0twZ0ZtN1QxRDhGeTR0MVJUTXNKM3VCU3dHeFF5cFF0UmMy?=
 =?utf-8?B?Q0tNOXJjZ1BlcW9Rd0tOZ2x1aWI1bUw1YWtMNC9XR0I3VlZSUkpDU1JjY29W?=
 =?utf-8?B?bmQ0VnlHOTRpL0l6ajFLUDhDNkpJY01PYWQzT3RDR3JGdElVNnRpc1c3ajFP?=
 =?utf-8?B?SGZ6ZjJuRTcrWktMb3BFYUFWeUMvWHZuSzREOEhiSlh0RzhnOHlobWhKa2V4?=
 =?utf-8?B?Wit5QlZOM1hkbE8xOUZwRTkwYzlXMHpWWllianlUdU1pZGhuYTJOK0krNzRU?=
 =?utf-8?B?V3pFci92UVpMajdBRW9jNEFwNWNtTGJlVFlnUnBGdnZxQ0dxMGFPQVg0ZVo2?=
 =?utf-8?B?L0lqcFFSbFYwR3RFc1ZOL3RoeklxakVhMmczcXljd01UOEgvckxPdElZRmFU?=
 =?utf-8?Q?nwpmXCv4KOKJQgDE1f9e4u6DroW7tWi1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPF2F7FC4EE6.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Um40YTNscTEreFFOdlJZcDFhYndSYzZqd09EMTE5MGtsTlB3a0dYN3lleVdJ?=
 =?utf-8?B?UElwOFFhZ0hNQk5JV2Q3cm4xdC9HL2c3SS9rS1M5V3dDMHcrZXd5MHhVWFZT?=
 =?utf-8?B?Tk8yTmpVYStVUzI3M1ZVUTcvQVQ0Y0JBTDhNZGhNTCtRNmNTd09LL3hMMmJS?=
 =?utf-8?B?am4rRHZ6dVFnMUZyL1IvZHZkYzhrdGZjV3lhcU1xQnFJeTRlNEdlQ1Q2ZWVV?=
 =?utf-8?B?OVJZMTNPNFJJYWU2cTZjM1haOGtkcHVWZEtoU0xTZUdOQTNFZDNYUFd2eC9q?=
 =?utf-8?B?VlhieDNQd2pLaDVkMzg2aGFrZURteVVFTjJzVEJHVUxjWjduQ3YwTnMxYlBB?=
 =?utf-8?B?djVLWm1iRE9sQjhRdWI1Nmt2N0I1VHhJTk5PcUcraTIyNmhBdlNuVmtXTVdv?=
 =?utf-8?B?b25nMkZCRk54U3kySi9PZmpRZ096dHhxL1QxS3lib05ZZXp1eDY1S25nN0hI?=
 =?utf-8?B?RzVPSUY0WWlBUnZMdlJmU0szNFBCb3duUEJnOEUwbERUWFpLSE9nMmlzYStP?=
 =?utf-8?B?MWU5L0lEWmg0UUxNUS8ybVBMVnNJVmxFby90LzJRZCtoVnhLbzJWZFRhUG9w?=
 =?utf-8?B?QnpUNHdJOWpkaXpuSWhxdXlQYzFTM2dFS3ZIVzBqNmhpLzFPaWpDSXBaWllC?=
 =?utf-8?B?dE55N0tKVWFYYVZwdTkrTTFvbDZaQllSZHplQmE3eHJDLytQbEV6TXRsM1Jm?=
 =?utf-8?B?SDhGVlVaVm1JYjBuNEhOU09MN0ZVLyszcHJEa1BGTTNxRmxGNW9WSklSYTN3?=
 =?utf-8?B?SVdPWi9FdDRicW0zMjhjaEszRVFKRHJKTDFJZi9LNlk2SlRvOW1adVM0OHJZ?=
 =?utf-8?B?MGRiaWo0T08wdFdZMVFGdm4yUmk0QXZDaWJZck1YNXFmdjNRZEllcUdOOUdO?=
 =?utf-8?B?Qyt5bVF5cE1hZlpOVU1ZdzBiL2JuRlRSSk9obXpoUXJ4Tk4zYTBZOWJkTUk4?=
 =?utf-8?B?ZDNLT0xWQk42UW8yZjZzcm5QR2RDSTBTU3o5eWJHVjA1Q3FGQzVlczVZeWFZ?=
 =?utf-8?B?eGtibU5KTkMzTXRwYVorM2YvMkFwbm5JSUdkSnRKbm5uQkQveWY3QzlvbWtj?=
 =?utf-8?B?cmkwODdWd1VrK1NnRncrYUMycVQ3UnVkVUFic1E2YXdEaC91T2RzVExIUGZE?=
 =?utf-8?B?OUFqS3ZxYjFWVWgvNEZMUlBwUUk4dFV3QnNQUGR6ck5lZGRxZytCNmkzQ0NX?=
 =?utf-8?B?ZFAvZEVjcjU4VEE5RTFYQmlCWFpTZVVaSnZkTWtOY0s0dUkvbDQ0QStUNkVa?=
 =?utf-8?B?RTNla284Q1RxblVWNld2Um5FdUJiM2RqTWlxOTYzY0ZmSmVRTjc3SW0rY1NE?=
 =?utf-8?B?MUIyTmk3SHYyZFNFRnhvTkthTW9XdDJvcjQyL0tXUmxOcHRqY0d6aXF5dDdB?=
 =?utf-8?B?L1BORGw4cWtHam1Gc0FBK2k4SVV2bkZzVzdkYlJibkx6dnZtTVFqOEZJc0tO?=
 =?utf-8?B?VW51MWJPL3JDOVpiWURrT2Zoc1N6U25memN3Qm1NMW9wQlc5ZU85cHhmZmtW?=
 =?utf-8?B?elJEaEx2Y3Y2VzNORlNIR2lxd0dVckNjVktMMTBVNysrcmltT1pWZUtCTHIv?=
 =?utf-8?B?dHNXdnJiL3FDR002ZHArVHM5MjhkWHdKYUZkOXRZTGZUNlFlVVVQTWRtY2hz?=
 =?utf-8?B?Uk9xZU1KRER1cm1xMXpJRStYOWxQZ3pyNlBiS0tZaDQ2WTd4NFN1MmVKWlJq?=
 =?utf-8?B?TEhFMnZXeHZxWTlodUl5Wi9Td2JFbkJocXpMSXpYTXl2ckExYVh5VFgrZWIw?=
 =?utf-8?B?bVRtR2NiQVpKTHl2Z1VqeXdxYnJXd3NFSktRalB1d3h5MTI5ODd0NjZZMEk4?=
 =?utf-8?B?Nm9BODlMYXcyNnprUzFTSXNWRzIwWUdONmsvRDdYYWU2Y3Rva2RiZHJjbFFM?=
 =?utf-8?B?clhPU3R4VjhsdXNhRzlwUVNvVVc3Vm1qbGNlM0x1Vmh5SW52d2djclFyNTRj?=
 =?utf-8?B?ZnBNMmYxdGRvaWlyQWlXOGhIaTMxd1FnK21lUWVFSUVzUTVaU2g5UEorRUcv?=
 =?utf-8?B?R1dkQ1paQ3JsOUpUUk42bGhIMzRDRi9OK1VSaTlaOEpFRGxoeGZ3bUY2Vi9y?=
 =?utf-8?B?aTF4NHE3Z0JMZXRBeGg4TzNickpaS2tJUFJsSnlwYWxrY1JQdFZGRlBsVlVN?=
 =?utf-8?Q?2Dr2l+pvEu2EnHCBMzISiG3nb?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99b17f4a-6b0a-413a-3f29-08de0bbca7ec
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPF2F7FC4EE6.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2025 07:30:03.5316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NdwvEJNTeB3pCX8CSlsCD7WDa7Y+7p4OHGxyj3kOcgw0kWXl4rBHNuOlx3nKwyOOzuHu8UfeKzmPHx4pvF+GJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7912
X-Proofpoint-GUID: c7KOJCaiOAbt-RgdYt4Na364hOpk12c9
X-Proofpoint-ORIG-GUID: c7KOJCaiOAbt-RgdYt4Na364hOpk12c9
X-Authority-Analysis: v=2.4 cv=QLBlhwLL c=1 sm=1 tr=0 ts=68ef4d7e cx=c_pps
 a=fq9WP/vNXoxpaIAZvvUcmQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=tMxWpUngqp4TuERcfTUA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22 a=HhbK4dLum7pmb74im6QT:22
 a=pHzHmUro8NiASowvMSCR:22 a=Ew2E2A-JSTLzCXPT_086:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE1MDA1NiBTYWx0ZWRfX/x+KRdf8wAi6
 UJwk10iGDETeQKZkiG5Q1/xxfQoh8XwgQO4Vypz+q/ArHHHq90qwSZpdJBLU8N5VpHQyCo0GIPl
 QAEuGOI7SjlAhIjuoCZRXNRDHLmZjNaSpG720E0r52/KTYATZy5tV/FndjHfqUjLstyIqfkOqOr
 hZ4l0MZjVuwAQ6BuKm0u1xBXA0AjnqnBNGlfdBiKZ1nJi9w7ukspDaRpmrHz+ls2nfHMRICNukC
 ChBfAppoMLo8EGkIbNEOlxDVDkQmSRZ+tCBjBGnUdFnWiC6oCfOHlQSvC7FgBK7U86f15LODLxE
 RnKv3tZvM679/CI0Npv8Gb6CX4y07YIAFwSSBPrmAAyLleK8Ipgc6cyQy5IIaGz1Sh0f6MNE96L
 Qf/5PRzQziOYRNzona1fA22ZrZkjsw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-15_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 phishscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 suspectscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510020000 definitions=main-2510150056

Hi Kuai,

On 10/15/25 14:58, Yu Kuai wrote:
> CAUTION: This email comes from a non Wind River email account!
> Do not click links or open attachments unless you recognize the sender 
> and know the content is safe.
>
> Hi,
>
> 在 2025/10/15 14:35, Paul Menzel 写道:
>> Dear Yun,
>>
>>
>> Thank you for your patch.
>>
>> Am 15.10.25 um 07:59 schrieb Yun Zhou:
>>> We attempted to use RCU to protect the pointer 'thread', but directly
>>> passed the value when calling md_wakeup_thread(). This means that the
>>> RCU pointer has been acquired before rcu_read_lock(), which renders
>>> rcu_read_lock() ineffective and could lead to a use-after-free.
>>
>> Could you elaborate a little more – especially as nobody has noticed
>> this so far since v6.5-rc1?
>>
>
> This looks correct, memory dereference should be protected by rcu, while
> in fact this is done before function parameter passing.
>
> However, in most places, a null check should be enough because the md
> thread can't be unregistered concurrently, that's probably no one ever
> meet the problem.
>
> However, for the modification, I'll prefer a new marcon like following,
> so that you don't need to update all the callers:
>
This method only changes a little code. But it holds the lock before the 
function jumps, which seems to violate the principle of minimizing the 
critical area.
> Thanks,
> Kuai
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 1de550108756..d48ee1b50d27 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8384,11 +8384,10 @@ static void md_wakeup_thread_directly(struct
> md_thread __rcu *thread)
>         rcu_read_unlock();
>  }
>
> -void md_wakeup_thread(struct md_thread __rcu *thread)
> +void __md_wakeup_thread(struct md_thread __rcu *thread)
>  {
>         struct md_thread *t;
>
> -       rcu_read_lock();
>         t = rcu_dereference(thread);
>         if (t) {
>                 pr_debug("md: waking up MD thread %s.\n", t->tsk->comm);
> @@ -8396,9 +8395,8 @@ void md_wakeup_thread(struct md_thread __rcu 
> *thread)
>                 if (wq_has_sleeper(&t->wqueue))
>                         wake_up(&t->wqueue);
>         }
> -       rcu_read_unlock();
>  }
> -EXPORT_SYMBOL(md_wakeup_thread);
> +EXPORT_SYMBOL(__md_wakeup_thread);
>
>  struct md_thread *md_register_thread(void (*run) (struct md_thread *),
>                 struct mddev *mddev, const char *name)
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 1979c2d4fe89..9ec62afc2a7d 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -882,6 +882,12 @@ struct md_io_clone {
>
>  #define THREAD_WAKEUP  0
>
> +#define md_wakeup_thread(thread) do {                          \
> +       rcu_read_lock();                                        \
> +       __md_wakeup_thread(thread);                             \
> +       rcu_read_unlock();                                      \
> +} while (0)
> +
>  static inline void safe_put_page(struct page *p)
>  {
>         if (p) put_page(p);
> @@ -895,7 +901,7 @@ extern struct md_thread *md_register_thread(
>         struct mddev *mddev,
>         const char *name);
>  extern void md_unregister_thread(struct mddev *mddev, struct md_thread
> __rcu **threadp);
> -extern void md_wakeup_thread(struct md_thread __rcu *thread);
> +extern void __md_wakeup_thread(struct md_thread __rcu *thread);
>  extern void md_check_recovery(struct mddev *mddev);
>  extern void md_reap_sync_thread(struct mddev *mddev);
>  extern enum sync_action md_sync_action(struct mddev *mddev);
>
Regards,
Yun
