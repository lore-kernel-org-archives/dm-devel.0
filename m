Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4927530C637
	for <dm-devel@lists.linux.dev>; Thu,  5 Mar 2026 22:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772750196; cv=fail; b=bryjkc31er7Z3qCxyepJ0BbgY2FH06bE/K9FM3Thcnzof+EnvWCNnA1IW2Sp3/ptkLiWIUhJHvHIDHd1X0kACNnGDnTUn1vJZoSH6VB8wLLQZbo6j8sMP+iLVqFG1eCkft37/c9CYvj6MSUjxdATMKT6IX/Ox3TfCivv/+u4rF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772750196; c=relaxed/simple;
	bh=wVFnyVr9Py91wgAQLKPMGZ/i7N2X5//jjlLoXFNsOsA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rP4FmbK4Nf8WWvv40xjrno5kd3jd2SNNLAGguIEUJd1RHJolm8rKv1a4jxYjIOj+ORdNJ8nSjd4j2qo2Nwf+lfFq9JCQf1gaDptANCGp26dcENNQN70A2GjXl26fEW7KTK268O6fKU7AVzTXxALvKkKYXuyfQQm9AuzjJTmGD7Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GhFta4WW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=heNbyjNB; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GhFta4WW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="heNbyjNB"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 625LgTHW1632969;
	Thu, 5 Mar 2026 22:36:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=sK4hWfTfQi9uKMjCn2prGg63LIXWP5LivyqQBiu02gg=; b=
	GhFta4WW/V7ye4T2Y8dQ7wAkqAYyNFBxBgCQFlIHyZdaTmJFZZ1SZwhOO4b3VKiE
	dVJe8+vCKCBVEUW3A9sFJ2YlqSdPDzdDrrm+sOOXDtiVxS3FZZ6hFl4kR9l+xR5C
	Bad08Wpl0xQJCHBL4WFxtbNJjZwnBOGuHBuaJlMZqawwoP05KzFZk8xJFzfQ/td/
	6fu2Ph20FES3xNZleMXZ+Ma+9O5XkLCP79BXp3Yg24TykxPjUxVB/v3QsaYM8RUd
	vF66+ne3eKw+rR2qcIuVWUjwYnjQJxvgMhZhedIEYLKwcXXoOLQe7knbyhYwpSPh
	Bt3viDGXMd4wBSqDY7r6RQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cqhysg3dr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Mar 2026 22:36:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 625LmxOS029694;
	Thu, 5 Mar 2026 22:36:30 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011063.outbound.protection.outlook.com [52.101.62.63])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptdujsb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Mar 2026 22:36:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=txh7ghCRODp1yT9u95GeaA1UlS1XTWB1MZuxopg4zbPngNWC9VvTVcnquIibSunxIs0wipiW/u7dfmbwhZtLh4GWicZcciq560ddo8sZJ6P86Rbyy+poG5HuvODSMRKCckVTtLKAvvbZo4McRo7z341gb7KwxBmm1FfM20iQ9pnqYrWBcuhvrJvNUxwVq4CgoAxpM6qTGVssH6aqTM7sVYULIPExHXDD8MlyiJJWSrhF0kNRBdk3FN8h31wV91iKbYqxaioq++CaeTVxiUBd3FIZdHSuVXnuEldy34hnqB0UoN6Dhh+mvp7F8U5VP8ogbkPDB5IgPDrduy1J5ltNyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sK4hWfTfQi9uKMjCn2prGg63LIXWP5LivyqQBiu02gg=;
 b=q/GGce/CwBIWWWsRe7K74RUFQ9Xd9nOf5x7M3SF0VdV24rMYxVCsmMyMRBEzjUzLGlX2XarviKwvSrbuGwP2xG4sazoUhfCFnnipa62SnV8ndmpnw9E65v8cLFvNzUx3CRnLdaADP7m+5gnk7gzZNggRUKbDAI8aUJ2lEhm3RlOoxavCDHaeq8PvrAnzn9fPqJiQNH5swRFSSWBSwv/HVTlZXaI96IM1Y/WT2RQVyY1IG+cCfa2Ldd6dJpXYZKvDShTVb2+oIQ8RW/nYeli8qYoyE3jpYL/aI+XLeJeG9xitY38fsTNCPqK5pd7oE0Gzk+tnEaKkjBYO9kxx7XxkKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sK4hWfTfQi9uKMjCn2prGg63LIXWP5LivyqQBiu02gg=;
 b=heNbyjNBs3jUD+rN7WWceohVY3javXncEObRHs0nI5u9Dgyr/Ynw7ymL0Z4SfGecEh68UnDBJw+v3uuabffKojFQJCb520mygq90Rmi6/XwUF4JAuXQ8Y9cE12lUYEqZKnGcgr1JwTkcouJBhuCvFImieK8WovMGocTrXcqdb9k=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH0PR10MB4647.namprd10.prod.outlook.com
 (2603:10b6:510:43::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Thu, 5 Mar
 2026 22:36:27 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Thu, 5 Mar 2026
 22:36:27 +0000
Message-ID: <6670e402-8758-4c64-b441-fa7aca40ad8c@oracle.com>
Date: Thu, 5 Mar 2026 22:36:25 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] block: consecutive blk_status_t error codes
To: Andreas Gruenbacher <agruenba@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, drbd-dev@lists.linbit.com,
        linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20260304190424.291743-1-agruenba@redhat.com>
 <20260304190424.291743-2-agruenba@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260304190424.291743-2-agruenba@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DB7PR05CA0010.eurprd05.prod.outlook.com
 (2603:10a6:10:36::23) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH0PR10MB4647:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e3ae435-ace2-44b0-2701-08de7b07a39a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	ZSsEAFvkKbDg41tpRfpg3ABEr7rB0pdBal0etxFGkEMlqlj6nAWD8Ny+loDJYzWrjydWSFjh9lPD7qd0kqqdHf4r6g2j4BPtOcL6Bp4KI/IY8ge/QQiKOHeOmwToRKtBEARQ1Kpy7j1czxCnDln/UXnZCUdfqhgi8WvhJXL6v7JdUEBYaCpMU0WOsixEHpVj6y3i2+wV/abmjgOQnsWeaXwHMdvYJG6DPrtgdg137zOn+fPBr2zBit7NoGfNzeuhEcq7mjSgsa1SP1RS5Md3HbeCtV2JwO4yZU4ZSpSlVi2NT5MA1h4mAB4CQcy9WvY6R3e2vyRK1+OpeTLWHHeBFmD6aHR8ijUGWuDe0Ni1nN4HRFCjMeMMlLD6B7KBR3MfMweD1W3RV6JrkyQvUxKZYz1ewx+VAnjylhehx292r9Z+dY/v71jxBB6VZ+WOndhuV2mYyhVXTH0ts7zyjIJsVy1aFdqb0yy+p/b7tB9rtJKen76m3jjAXzXXQ0Jp1BpYHlEDharbaYc6+BW6jpQp1169B89IyMwoxyNy1gJEBSbOY9JKtR3q5lBLC15BIJWkOzyYfZmWRfTjKsEY52NLJYL8SAc6DkW79QJs6co3i4kHQHLXlpRqrIxqG+15pePW3NmMPVGuscx23hfomFYjaEoYjCcnZohSLFAM58j/SE2KUNFSfzDmOnUBucRbc79cI32sLhnx2uQ6SxSU0XbadULjOstQl1goARaf/dQZVzw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UUFMampONWMrYk55L0dlK0JVeUhEaXZoQ205aG4xaWo5dmVMR05OLzZWM1Jh?=
 =?utf-8?B?VmsrUk9MdWp6MTVIaXBGTEYwTXJZQ0YwVVNRQ1hld3BIWXQxMHM2TG50SUhG?=
 =?utf-8?B?K0ltNlFTbmhHREJTdWFNeUJCWkM5aElmU3BvSCtXTXIyT0VRcG9DOThNVkNr?=
 =?utf-8?B?c3BndXA3SlNXL0NFUTVCamptMEN3Q1dpeGphcFpqVFhraDBTOVZyT09PV1Vo?=
 =?utf-8?B?SjNWSElQSENXakNvM290eEQxNmYwUUJQOElYdW9DV0tyUmxKandjRCtnZEpK?=
 =?utf-8?B?eDZTb0tkcjFQR29yTnIySWlQaFBzaHllWnVvb001NlRqSHVrQ2Rzckh2SHVE?=
 =?utf-8?B?L1JBajNxWEJyV2hhTW1Ram4wU3RZTXFQa0JDUFNSMG1CV2FBUTNyVi9BZ05Q?=
 =?utf-8?B?N243aXVrWDRQV2wrZlhZTHJBblZIZVRuQ0xUdVZydlg5RURwS3RTU09VTUxS?=
 =?utf-8?B?cjRzTDQrbm1WUEY5ZktiM2ZTTFdCamhGeUJDU2NhLytHdFVHcWRXQmhQQjRY?=
 =?utf-8?B?MHNWRDRrT0ZESThRNTY3NDBVZWF5OHdFbmFkMys2YnFXRmFRTmp4b3g3KzUr?=
 =?utf-8?B?K1phMDN4UmVBNndoL1ZTUTdoT0lnTmdsNW5jdkhoNFNjTDEyQ3VpUWxEenJ3?=
 =?utf-8?B?Q2lZaWNlMlZHVWg3R3d1RkhhMmlnRCtjQytLQmJ3VU1UVUdteEtmWlJoYXRn?=
 =?utf-8?B?TTBJSDM4RjFNRGZMNzdPM3hyM2IrTnZtaEJyNkZ0NXZBN09wUEdyanV3dVZh?=
 =?utf-8?B?dzFEZCt3cjM2aFEwQWlaM2JzZHkvVHoxQ1NRYkt3aVc0dTRMVTczWFJXb1VQ?=
 =?utf-8?B?VnhIM2VmRFZaRGZQY1pBYUdMWWlaOFY1dFhrTFZzaytRWGJwM1d1SWpHZ2c4?=
 =?utf-8?B?UzNla2NUeEJGQ2U5blphSnZlQkJIeFYvVWNWYnV0a2dsK3kzUUJHNTJ4NWR5?=
 =?utf-8?B?L25qRWFackZTdElDaWZlOFFDTzVzS2FWczF3L0xhcE42VC9QaUZtYnZ1azRh?=
 =?utf-8?B?Y040a0NLMS95M3FFMXZ2bzNuSnJMU2ZJT0NyUFcvMzFFZUpocHZnbEpmNlRY?=
 =?utf-8?B?OHNPeEppYVN5YllLSVdob3VYWW9LWC8rRnRiaXROL1dNdVo4OU9kZlpmNjU4?=
 =?utf-8?B?cTZ4OVh3NXMvQ2doQ2ZWb2hBMWZ1Mk50QVNwaWlFRDQ2ZGJxMHZ0Sy9ROGdt?=
 =?utf-8?B?SnF0a1NtNGpOb3JMczNXYmVPSWI3SGFGRzFOS08zOWpEQzRoVTJ4L1pJWUUv?=
 =?utf-8?B?T08xNjJXZXhtZWVSSmozZDhHOUNoMkIwNFFhU3UxclF5Y3lGdjkzUFpyWmpU?=
 =?utf-8?B?YVA1Q2ZnMStJSEVXN3Z6eDZnVkZXQkI2YTFFd3JEQnRkcEdxUDI3Z1hHMmJ6?=
 =?utf-8?B?Mzdmb1pObm1kUjVWaWlaRzV1d1A4UW9sR3pGdDNYUXRaRjRoTHVlWGNQMkdk?=
 =?utf-8?B?ZlQwMnBxVFowSy95cTRVelBTV3RBRkR2UllNQ1ZTdHNRWkJiUUxEQ2RRTVZw?=
 =?utf-8?B?UFZnZERjbGNuQWp4dXNYTTBZRmZoQlJkV01NdHhRNk1DWVdabUg5dEd3VzlW?=
 =?utf-8?B?bDVJQ3B5cndnU0UxZUVqakxmb1hwQ0c2V3JNNVV3TTBMYTZ3UGw4bzA0UW5n?=
 =?utf-8?B?LzNHSDFRaGk2R283TGV0M2J2YmNEb3djSG9jaGNKMW5POXR4ditwNGNEWWVY?=
 =?utf-8?B?ck9rY0ZkRGx3QWxhL1ZXWUR3Umc3cHl5cDAzdjNWWHFkU3cyQmpXcUdCQzVh?=
 =?utf-8?B?OUdwTnFYWUozRHkzLzNPTDFqUjBpK1JjUXRQbThmdnRPV0RXeGRWMGhpVnBX?=
 =?utf-8?B?ZHEwNElWWnBrOWxwU0xIcStFK25naTBYVGZPY1lJTVEza3RWQy9UK3pJNFN3?=
 =?utf-8?B?bEtOZnp0YStBajVuKzI0ZEIydFQ1Njd5WnhLRkJxY3d2UWxDUGYweTZXWlpI?=
 =?utf-8?B?VWp5NnUzOEE2dCtwZzhJanlaZnI1NUVyUHVHR2hwdXExajV6U21hUGEzMTdv?=
 =?utf-8?B?dG54cmZiL2RlMWZMSTRVT2EvbjVNWUt0ZTl6MWNsL28rTTZndnVCVjlpcGNj?=
 =?utf-8?B?ZVJhbSs2UFdzdDBOZ3JULzhzSmhISXlzSzF2MFNRSmh5eUVEd2ppQkZsUDJR?=
 =?utf-8?B?K3hvWGkxQlRabldORU1EL1lLTzhSTDhaYk01VVdER051NGZDRXI2bVdIWXM3?=
 =?utf-8?B?MVVBRDBnQWc2SGRpbTQ1ZzNsU0lMUVh2NHlIYnJrWjhVVngxMVlkeGtIcjc2?=
 =?utf-8?B?bVpXYUlGT1dFU00vQjBRQ0YxMFYzcXo3d2s2N1JaU1dXVXFPTGVlQi9yZXVa?=
 =?utf-8?B?SVd2VXlLY2RXYVk2QldxWW1xYlUzb2EzSVFrUk1yWTdIU2RBc0dSZz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FpBth3xlpX0D9i5vxsNMARHUpkVVHK61KP6l3rr28Dw0XnklXEE1DMs2CxHjSJDUR8FgyeeyAAc55uAX9E+1IZ5oukDK94e4eFdtYGKoQ+l+HCVetDlqEZgy6dNqWQcx0TJ0nbv+nzJMllql65/jqEGsOjwfJiTqEUq8mq9cZ6grsvgw0sKjd+oS35rrSmNih5rZNKiVETAprl2a62BKhUlFKEaR6sKhOPuTR9nTFsKMeAciHJKaV4AafF0y59jj9ZCWJI9oHGgExYPFcEvnmx4CdtcdgpvY8LmnNobMrIoZ5mAGb9gfrgtJGrrW2Z9PUlVyTRP3Dy9kgU7lYQT3eEPNHQK9AmAKUCHNs6juQFFDcC7MtYlH/Ew3ZGXLMwJYEJpdC129K6Z2Kl2MZSnZ6MzbCafeZSORrxkJYMbQF/fcAG2sMfYWgxXLj6LM4I1CnzpiYQaAcDA2YapH8vM+gVxl1FFeJMDlKACcLgu+8adATrugMvahNfzZP7HhiR8s634dv9n19xJzP8OunHME2wT5vrQFzP/2NqVamLjnv/YKwE3fWZJ2MEnDD1RJyH91WpG3XMCpda8hdNNZasoPXf+xvXUx6+4nrW3GRdzPXAo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e3ae435-ace2-44b0-2701-08de7b07a39a
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2026 22:36:27.7226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GvLqyAAG/xX1TkYflVmhYvvGxewFTwgZVcfYf3EbekkdelIPcJf7YQdHbM44bcNFeG6D7uFFz3uSrE3vk3avrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4647
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-05_06,2026-03-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603050194
X-Proofpoint-ORIG-GUID: k1h76jQjD1uoCu0h0DguIAoZO7y2tQML
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA1MDE5NCBTYWx0ZWRfX8Aj8Oet/9mcj
 sbTuRnpVB/3Pk5aNtWzGuWTuEl/J7UMG69psyplsVPPKfXP2LzrLvg3QFuJFIfkty96PeozarN8
 tFo66RgyuT/OXGkrlrNU7WKUTNRqgdS/OaaPSY98rooo5PMdbwkFAFWEdt15GjL1F/WDl7/19b2
 1hGtJwhokHxoW7HsuXCyBVZi0QBdpLPa9lTbDdRfOA+qiaJYt/EUr2oFWYi6t/bv4EAROkMlFiY
 kvafLlDmPPOd9QkfRSQtRCxXaSRUbPJY3lJ9+0AdupH5hKq9KOE/vGWEPMkLs5NTZlwTeEAh3K9
 NuHOo7fNw6+rZLDvSJ2o8JgSUUYmM8qqPdK+1ZXVToIpuEFbhQvhDLvtPnbfrEhDBmjyfgjrdjk
 9DaNXBKhkneXuotxMAegE380iUhnIEDY3t6EBTkqG+p/3wvfJxz0iAauULifnC1Z54j1wnCxm6+
 DUaJHJp6/h8MJOLDyew==
X-Authority-Analysis: v=2.4 cv=Jsj8bc4C c=1 sm=1 tr=0 ts=69aa056f b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=20KFwNOVAAAA:8
 a=yPCof4ZbAAAA:8 a=BxcFmBYk3axAdTEt_0wA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: k1h76jQjD1uoCu0h0DguIAoZO7y2tQML

On 04/03/2026 19:04, Andreas Gruenbacher wrote:
> Since commit 9da3d1e912f3 ("block: Add core atomic write support"),
> there is a gap in the blk_status_t codes and block status code 18 is
> unused.  This causes blk_status_to_errno() and blk_status_to_str() to
> return incorrect values for that code. 

Sure, we get the wrong value (for 18), but 18 does not match a valid 
blk_status_t

> Make the blk_status_t codes
> consecutive again to avoid that.
> 
> Fixes: 9da3d1e912f3 ("block: Add core atomic write support")
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   include/linux/blk_types.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 8808ee76e73c..89a722d76c28 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -168,7 +168,7 @@ typedef u16 blk_short_t;
>   /*
>    * Invalid size or alignment.
>    */
> -#define BLK_STS_INVAL	((__force blk_status_t)19)
> +#define BLK_STS_INVAL	((__force blk_status_t)18)
>   
>   /**
>    * blk_path_error - returns true if error may be path related

