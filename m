Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EEE295DAA
	for <dm-devel@lists.linux.dev>; Thu, 26 Jun 2025 09:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750930624; cv=fail; b=Na6Db3C7s7ciDoEZ4bzyTCFfjMBLdDAQhGf9wXV5FNkD9PskFu/RGN/7tLrxp2jEDHN0zVW8g8piclMgOiVgI1ezQ2TNW+NH4jNtyVxhshcXeeqvPjcvsfKkf9LYIZtiF0jdsv+bH/GarUntXrc92Y94IIGdQK5XK1GDMq1EXgs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750930624; c=relaxed/simple;
	bh=tnl4sNHzqaLbtQMMQzY3QdpuxTbyP7kucSuDBEt9uXQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CGraKMEqxfcaKKM0Yghm9mCDlfdl21XZZkqnvPhNxHsjbb4zhBY6gF/586d+GlEPGHxNSwp76cd75Kq0RHs/N3QKDcJAZbnHhlbTjLbwwF6wdkRxXKlt4tSaLJDl+SvGVfqduohpiCcavVCItu80tVutgnRTbAYNvSdJKX5iUWE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Pk4H0qE9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cqqSf5XW; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Pk4H0qE9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cqqSf5XW"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55Q9BcQt009745;
	Thu, 26 Jun 2025 09:36:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=v3/iifnYXEI/kJm1XZoNVykvN5S4KhGmt2NI99LPuXo=; b=
	Pk4H0qE9jzOFIudpn3Q9gr2uiVk+eoI5fyO8+6Vu7us2cr0QrHCQC4jm4aXd5l4l
	X7TqMj53GDB/+Lo+maTajPjwys7XYI80zXZr3fx3UYbwwGxB3FeL2BE4InA0abA8
	dUJgvIrnDG0WCaleYeZ1IdDYQH1vueHCBTagCmL9YMU/SQL6IgGxaGPPmSv0ibdO
	ijZe/e69Tf1bLrrYkDm5WqqcHOZNAxDYUHaK99TKiduJG3U2SvTq4UdAO9Kq/hUy
	WMUQdGtjz1eqpRZUYLd3zB7+cX0BmC0Ih5XsrV9cd4lzXStfkM8hP2i7PqIVQIPs
	/3gH+2pSuDkJxpLzznHobQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47egt7g91a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Jun 2025 09:36:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55Q90uaN034573;
	Thu, 26 Jun 2025 09:36:53 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2063.outbound.protection.outlook.com [40.107.212.63])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ehkt95rj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Jun 2025 09:36:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HyMQVAN2yQlHI8r1hlMfrOs1R2iNRSubG0DRaZD4eUO+RIpT5Y+K9wsTo5wGIrQWuATPvp1RUFWvNYtLW3kHq+sVlrS+mvuKc0erOIjDcI6XQ42m9Ch7hkcU9JnKlPuPEPW3hl3P2EETRaVFLshLFf1/+PxrGLwGCH9VEuT8T+kj5L70rlsL8kDRwYqxSQbo1/veghra/K8jAnYQ67A2O0kN4gqYaTlRFl6j+SNSsQ6uzfGqPCPJ/d+PqVhOIwQu3vrNMOF9H9bgHD29x6zFGWo63w/VO/ggrt9IkDYnwNTdiQlYyCTLQ9ZKxV2A09/UitQf/FzVtRlNvp+fidjfbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v3/iifnYXEI/kJm1XZoNVykvN5S4KhGmt2NI99LPuXo=;
 b=yGlWu7W5o28H7PRrV8cL8QR2YZpyWdB0DGlsIeMujff547llhGhOL+BxsKZ3em09V9cqrDnSCMQ17vOfpQ/X3Mi8OKHJ6vjTGxcoZzoXji5gB6QNiB0cnn7XirjQnxAm7vuDnG31fF4r+RI2C9eA0qNSlazXpx8quwQXMOq7phKSh66Vqq+ArLsJHFmPegwWDve+y1lpW7lTzsszG+AvPQZTz/ibmgEAfzI7iHilpda5Wf6aSyG56LssYz3NBKwdRrLrWoCB0jeBBOYcD++ejiNGKp3uFrmBDdawK4pL6QuIMOCe8iKKx6eiMTA1Rbe/l9VNDu++YXh8bsgTYs0G2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v3/iifnYXEI/kJm1XZoNVykvN5S4KhGmt2NI99LPuXo=;
 b=cqqSf5XWBMq+K5S2qqVuDFmMDQQNHWbFwtZX755j36FKhdK+LxaE0p+lhjbHdY7xRX3Yr75MZUlIJwBKmNF4U8/PEftJGKeTvg0dehOiUcauF7q58usB2zCzTOWRLuuedGi0m+l35TtTJRScqqzYLtnPT9zKe336T0JkpPwnTJE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA1PR10MB6342.namprd10.prod.outlook.com (2603:10b6:806:255::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.22; Thu, 26 Jun
 2025 09:36:51 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8880.015; Thu, 26 Jun 2025
 09:36:51 +0000
Message-ID: <32a644b7-4f27-47b4-80ad-04026b2bfc7d@oracle.com>
Date: Thu, 26 Jun 2025 10:36:45 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] block/md/dm: set chunk_sectors from stacked dev
 stripe size
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com
References: <20250618083737.4084373-1-john.g.garry@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250618083737.4084373-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0139.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::44) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA1PR10MB6342:EE_
X-MS-Office365-Filtering-Correlation-Id: efa997fc-f85a-4af6-877d-08ddb494fa7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R0h0VEE4UXlEM214dWhLRmtZQlgrVzB0Wml6VlNJYTJQSGtmd2U4YkxkUWpZ?=
 =?utf-8?B?M2RzcWJmdUN2Z3R1bERYcFZ0YldERUxFaGZtWGpOZ3VVdkFIV09zbjFGMytB?=
 =?utf-8?B?TWVyc1pwMjB2NHh5b3RaUzl3SUZ5Vi9NWjh2YzM4enRDTFVFYXN1N1VXUEdJ?=
 =?utf-8?B?aTZFVFF5aEtMa0dLMFpEMnI5bWIrdG9KNGFMYnFEMldoUGhYQnBvaGMwV2Jz?=
 =?utf-8?B?ZWEzaEFFUk00eWtaTlg4SVRzOXB3L0J0M0VKaithK09Kc0dnTkNoYmpJZEVu?=
 =?utf-8?B?Y0RvYmFSYjByQjlKZlJXcFlxQTJwbU5hRWROUnZOYnpxOXoxcDU0cjkvbUNC?=
 =?utf-8?B?ZDFzYnVXeldyRmc2Z01ENjZUYk1CMWw5THNWVmw1V3diZEp4aEdXWEd3K3Ri?=
 =?utf-8?B?SjRGTExwNFo0ZS9WM3lpSlFvc3c5R3hoQ3BKRHN6bVMwc291WHB2ZTFhZVZB?=
 =?utf-8?B?OGEvY21BYy9iUXFsV0NVNnhaZTdEcGpSRHZyLzcyV3hxZmpEdmRncWpBVDc1?=
 =?utf-8?B?SXQyeHA1WklaS3IzSEo0N2VyTGVRRHp2cURXRHVuNHVXOTZWM09kbFlZTkpH?=
 =?utf-8?B?b2pWbVZEYXd6WHNyNXhQTExHUG5DQVdidk9hMWdSd0FObDVNZ2RMS2tNZ3R5?=
 =?utf-8?B?K1RrT3RONnhqQXNVUmVlQUcyQ01MOTJ6L3Y3WDlHanJXMWcrYkNEYXZwYUQ5?=
 =?utf-8?B?TlZBUG01ZUJEbzhZUHdXN01xMFZScmdrcW01SzE4bVV0RWNvZzhOUkx4RkM1?=
 =?utf-8?B?LzJQVGsxL0pKbnRYZUw3dXFTRVRIWHZkb01PaThZUTZHQ1lOL3dMTjFRZzNF?=
 =?utf-8?B?NXFtUjFwM0Z1MmpkMUkxV010dEt4VWR4UnNSdUk0NVBzNUJBTGtZd2Y0UnFm?=
 =?utf-8?B?TE5nRzBTc1NBQWovUDB3R2xnVTdkcjcrdDFIWlI2Mm1YcW5zRG9SZmEyNFp3?=
 =?utf-8?B?SkhKWVZhbHF6U1Biams5Yy9JbWlGalROdzMxd0x6Sm8vbFFsYWxtZkhtWUJB?=
 =?utf-8?B?RjVROWIzd0RtQ2hwd2hmQkZCSS9XRitUKzBZbDlSaEE0cnFWcnc2VEpTZHE2?=
 =?utf-8?B?MHRlemREaDZwVCs0WFVpcEEzdHFmODRscUdDY0pyY09pN0FWcHpsYjN4OWYy?=
 =?utf-8?B?TmFWWUozSCtOV0VzdjJNSWViZHlNbnhtR0pXb2k1QlBtK1cwRzY5cFd6Q1FZ?=
 =?utf-8?B?WmhRcWllTld4b0ZCYllyMmU2S1JHSEI4WVI1YkRaRENXSnQ5QTBYcVkwYTlm?=
 =?utf-8?B?TDFhV0lYenVpMENMK2xNRjhXY3M0VEhlY2lHYzVoNHZUSW52cVBKcTJESkxK?=
 =?utf-8?B?cTNodXBaZ1oxZG95dnJDMUF0dWcydlREOHdyazgvUTlEK1IySCtCSnd2Q2hU?=
 =?utf-8?B?RktoeURFcEw1NnRVbkNQdHZNM2pEalZlcm5RcDdLOWNoaHF4S0FyOHR4bWRs?=
 =?utf-8?B?SEdNWWtZSWlKYXo5M2wySExUYnVMZ2F6M3dNbkNzVjh2Qjk1VmVCcVhvakNY?=
 =?utf-8?B?VlU0UjZ3cDVBSUZ6bnpreXlVN0ZEZ1J1OFpYMUNkazFWTEdJQktJL1RkTm54?=
 =?utf-8?B?OVFub1c1c2kvQlJ3aUduc0VWRitCblFNaVNLMmVoVXhNcVZzWVIvSUx6RzFX?=
 =?utf-8?B?Sml2RGxYQmFmdHhWQ2htSlpTNG55ZFpuMElzaG1Fdmo5YUpIbFF5Zm9oK1hq?=
 =?utf-8?B?RWd3NHJ2Q1NTbWpzVHhXdXdkQUtIazkxaDh1NVFBQVRuMDlDb3Q0eWUvWUR1?=
 =?utf-8?B?MHJ0QmVBSUN1WEdSNjUveVUyeklUTnhNWDBleXowOE9GZHRLU2J2Zi9Ha2xS?=
 =?utf-8?B?TVdGVklFam1nbDRBRVQxNzQ0VE5YN0JIajYzb3FETmpoY3BTUDRaY3pHeDdB?=
 =?utf-8?B?YnZnMW5RcktnOWxybUh2dUZiM0hBVWRjenpleEVGaHBpY3NOTzE4bG83akpO?=
 =?utf-8?Q?YO6P94r+sjI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TmZGc1YzSmxyalN4c045UnNZZlJuazZ4RmRDNU0vc3BUZWFzOFZJZmEzRHpK?=
 =?utf-8?B?TDdLYWZLNDZzUlF2UTY4NkxGMmlSc3RPNHJDcitnMUcvcEt4b3lHRWR0TE83?=
 =?utf-8?B?Z3ZWN2t1ZmJpci9sMWZSdDBDZ1N2VHYyT1FWTFc2aFNaVjd6SUxOa0NQeStl?=
 =?utf-8?B?T2s1VTVmbkIveUlURXNlZFVtWlpDemJYUURCT0VKOVJvcm5HRTU1blZUaDhQ?=
 =?utf-8?B?UVdhTmt4UFQ1em9oTzlkYnlNOWhOZnR0VUE2R3F4Z0FITlFZb2k5Y284OXJC?=
 =?utf-8?B?ZE83YnRyZWliSHlPaE1YM0RDd2FiUWpuZ05Ha3ZQOFBDYlRtaS9sbHllS0cx?=
 =?utf-8?B?N2E5Zmh3ZEE0RG9wd3FuRkVzNjhPUEZ3QXlxRkNseXRiYzFHd21LTkFwYURm?=
 =?utf-8?B?TExNWEhhcE9IYnVYcUE2RVZNNlVkblB3U2pJaXBBU3BkaWJlTmxtd1QvVSt1?=
 =?utf-8?B?dUVicTJqdFFnaWpjejNJaEZsU0k5dWR5Y3pyVUlkM01aS1oyLzBNK3RKV3Iw?=
 =?utf-8?B?YVZ6TEtlMkI2bERqbXUzZ0twWjVpaE5GMFZuZ0U5U1RXOWdIUWRWN1JKRzJj?=
 =?utf-8?B?QjQzdTk1U2o1Z1JrbU9ZUzZNTklieHZNbkR6b3UxVndROERpblhwZ2F3Z3ZY?=
 =?utf-8?B?a3F6QTdUNzIyd2lkVFZkN1ZIaFhRblVRemlsVUEwOGJ6SjNObE5iWXhqaitn?=
 =?utf-8?B?M0lxdEs1VHNBNGZ3b1daWjM4My9NbjdaNk15NzQrR2tZN01QZlZEY1VxWjJS?=
 =?utf-8?B?MEpEd09VYnR1QUZEQUFjYzJ1WVBEMTZTaVpLZGN6RTBYTU1uTy95ZmFDZFUz?=
 =?utf-8?B?czJUcmVxaFZrbmhKYURJOHlObkVyWG5Ha2lxNWlxelo3Wm5qRkFtNFVzVy9F?=
 =?utf-8?B?NW1MTzdJTVorRExidkNVZ0YrRlhIRTlqeWk5RFJPbkU4L1JPcWllc3NvSi9S?=
 =?utf-8?B?SSs2WVcvNFFzVkJoeFp3dEl0TEN6aGJIM1ZOM2dQcXAvWUtzUGRBT3lUcGZJ?=
 =?utf-8?B?NUwrTXFqM2dBd29yV0NiVytwMjNyMEpVaTlpeG54VC9DNElucHRHNmdhcXpO?=
 =?utf-8?B?eHlpQjRHT1NyZkllK0hocjFCTlFEbDhVUEdsbVhNS0tlbHBXTjA5U3JHZkFM?=
 =?utf-8?B?c2ZrRWZIeHZVZDVBL1d1dzQ1b1B5V1pvUlBBYmhpMjV3dlRWV0hKVmRBTWNQ?=
 =?utf-8?B?QlhHT0IwdThPWi9QWWtMYWRyRWFIRGpVNmRmUHZ4N0pxWnZZckIzZU9BVmUz?=
 =?utf-8?B?M2xmMVo1WWFwOS9yN0FWQXBYb0dwN3B2V21Lbkl2SVJuaU1XckNOakNGVU9p?=
 =?utf-8?B?eExiNEd2bGMwZEtQWXB6L1ZuL2dVSGJhL0cwQ0dDU0RiV0VpMDFhcmptRWRm?=
 =?utf-8?B?TjdaMzhoM01LNUJycWxLaTA1djRNVE5xT0ZBbm5xU2xLdEl6NVA2ODJJSG04?=
 =?utf-8?B?L1RsZ25Id0tsOTFZRXRUNE9PZHRmZ1pPNnN4K2trR2tERS85YS9nSDc4dzdl?=
 =?utf-8?B?c2ZJaGxaSGdzbnc3cW1yNHRYaVRSNE1FR081TW9GR3BrZlQrUWxmTXAxZytp?=
 =?utf-8?B?NUdLYTJ0VjhZTjBuSmRrQTAzK1AvbFdzMVlBd1J1MEN3QjdXcUdMckNjL1lx?=
 =?utf-8?B?dUx0bTZDd09vSVpaYzZRZkNQek1Xb3RNeDJkajYyd2xnVnVoSHgwdlNDcVpZ?=
 =?utf-8?B?c1pHb2ZURzFLeTRUQ3hNT3cwT1VwNlJ6YXc3aFlCT25pbUwwRDNXR0RPN2I0?=
 =?utf-8?B?bXNUdVFVZzF4Wm9EemNHVVVVMVNYUlAyRHBrbEFFSlVvVS9paVpBQ2UzQWpj?=
 =?utf-8?B?SlZQMVlVUWhnZlE2ZEU2d1BUOCtLSzZqM3pCWnVxbGgzWG9ta1czaFQ3V2xi?=
 =?utf-8?B?TWxoay8vM29oNm9OQUtSaFYxSTFaM0drb0V5UmVYc1JVZFFSTDloSVpmalkw?=
 =?utf-8?B?ZzY3MmlyVGJPTjUrc3piUXcwelJ4dFhqVjkzWmlVOHEwZTlpV2FwbE5kSGx1?=
 =?utf-8?B?dXpPVEhXWjRrMFJhdWJKQURDTDdpS2dSNHVtSTJVOEY3Mm1PSDhHV0tzdWJL?=
 =?utf-8?B?R3YvaEcxaEYyMHZIMkFOTDlvMHIxdkg5cVMxaTA3YlJoQzNVMWhBVlFuVVNX?=
 =?utf-8?B?RjVHallZM0dPbnJBREkvcmliazBuTXlkRFlsL01WZERLUDZWT3FhYVRmYXBD?=
 =?utf-8?B?Y2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aNmUkmXJsGhAsTQQXk927za9DUthqbs96GefesrydhrxqGlR3+wghOs0uqY5jEHn2nuZkxAIaoh19CVBI5/DD+i6MtyPhdBtsL1E0sHoiP2DSeTEz7iPUYFSphVliVDrgbeJEqssGo8kFzwCSxqTPz60OgqOBD3MxxwLbKuEP1dzxr7RYqLqcP5vCTCHktrCiwEYGvGl8iPSfQmPpThJJhE8pG39OzJkyZCoMFgqhMt3zgTbXnWHI+8C0kCwDdyw0R2noRd3LCTmPO/W+DDa7wmeAcsiQfYHGaVPBdEVRixWU7ipIgtCNMjHqIwpoLET1ewbIyXT4nSH6Uh0xn2DtK7eGRTe5iYrir/+AC6veX2M4DnKH5wdE4Ot/GofKZKnHMipF2FBci+rLc7fKyfzOBtNzhj3HVTRgK7taelecVeDJJOExYTV4jl+fzsDF1DhttjyaJdLkyuEyJhJC8gtXDNvoQlyHvhfT4hsVJ5Vv3UA7hUHONf8TBBrg9YA46w5FSu16Qh5aIW/yTH/472gaPLR1jNByU09TRj+2T1hwTWxfRa8uHHZe2OACE1jZeDp6Ihek0XRNlw5399y1Doo7B41ystWczpxsKc6XyawHXA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efa997fc-f85a-4af6-877d-08ddb494fa7c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2025 09:36:50.9264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KPIl8zGu/ulCCoHfiU5niQSCVPCRGKZGb6ca+4uhkJEse+2ot7e5xeOBO1K1j30nrH2P/qRCTWAydT+zhJTZXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6342
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-26_04,2025-06-25_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 adultscore=0 malwarescore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506260079
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI2MDA3OSBTYWx0ZWRfX7hHCcQAG42jw l1sdYEWyj9tpZwgADgt2uARJbp7cswPlYP5AQSFzVATu8Gdi/otIKJl93DLuNnHuevHHk0TIeDO 7cEC1ltSDasb4oJ6M9hKSTuWmhKlwwifBRrvZHPjwXHIf5RUoVK0oK0JR+3ghxgOYTLxsGlu2Ck
 JF2xvSh1cGtRVcbwkLa4eYdbp+d7JI/A2X9RRxMQdmjIenMFd/hMdmw6LTW7NGcdk7FC0nW/98u /7V29BKroecpoTtBVfrLEY7HeBFeGOMGO0iWlGL0bh086SQSMHTwhXz7ZWeLbn8rLaspGYdiyx7 ZgauKTOV9jL65g9MP5m8zS9Ffh/9ihdA4NLYbhK/Ch+NtuLPfsANNIrBKJUg3GQJRWPvI+C4EID
 ZRRQqC/bEWmYb4DHzve8ub4qLfYkQuNi3yG39lqdK4RuR/QsRcQAiibgmQ+grSEfup7qyCt5
X-Proofpoint-GUID: K-NzL8Cx4HpRH13HQPdDhuCesk_jpdNa
X-Authority-Analysis: v=2.4 cv=QNpoRhLL c=1 sm=1 tr=0 ts=685d14b6 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=GA5c7RnSAOpnPb49pOgA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13216
X-Proofpoint-ORIG-GUID: K-NzL8Cx4HpRH13HQPdDhuCesk_jpdNa

On 18/06/2025 09:37, John Garry wrote:
> This value in io_min is used to configure any atomic write limit for the
> stacked device. The idea is that the atomic write unit max is a
> power-of-2 factor of the stripe size, and the stripe size is available
> in io_min.
> 
> Using io_min causes issues, as:
> a. it may be mutated
> b. the check for io_min being set for determining if we are dealing with
> a striped device is hard to get right, as reported in [0].
> 
> This series now sets chunk_sectors limit to share stripe size.

Any more comments here? It would be good to have the md/raid0 and 
md/raid10 changes checked by the md maintainers.

Thanks

> 
> [0] https://lore.kernel.org/linux-block/888f3b1d-7817-4007-b3b3-1a2ea04df771@linux.ibm.com/T/#mecca17129f72811137d3c2f1e477634e77f06781
> 
> Based on v6.16-rc2
> 
> Differences to RFC:
> - sanitize chunk_sectors for atomic write limits
> - set chunk_sectors in stripe_io_hints()
> 
> John Garry (5):
>    block: sanitize chunk_sectors for atomic write limits
>    md/raid0: set chunk_sectors limit
>    md/raid10: set chunk_sectors limit
>    dm-stripe: limit chunk_sectors to the stripe size
>    block: use chunk_sectors when evaluating stacked atomic write limits
> 
>   block/blk-settings.c   | 60 ++++++++++++++++++++++++++----------------
>   drivers/md/dm-stripe.c |  1 +
>   drivers/md/raid0.c     |  1 +
>   drivers/md/raid10.c    |  1 +
>   4 files changed, 40 insertions(+), 23 deletions(-)
> 

