Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80AAF25D8E3
	for <dm-devel@lists.linux.dev>; Wed, 25 Jun 2025 11:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750851774; cv=fail; b=ClzBb9T9YP6J6tugh+9ObdZe9EsHhBpQTrWypCRtX4oM0Icjl4hOgof4yWII0oRO67zrTVT/dPzsHlo+JDYcIG5ofqV7nVpzQfBER27N3HxkCJELkk0XxldZb/7EZ0lcqd6AexKGVhE6jZXjQtAxsjeyIdiFK6nSc+WGzyGG130=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750851774; c=relaxed/simple;
	bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QOF/93NPpFmN/C/UfR+nysXIaG2b5yYRaTzBSzPVpE43Ittbq/51J7ONk8NzM/qMsZu6eAbESaLxKx6ld6+yZQ6mC8WOANgoTYFtmhQ7XlhkCT7/bgYz5vX2IJw218fJiBX+xPIiXDOzsdwmMJMQyMYRJWvyOHLSGrBeF/KQmdc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=OdMUD1w8; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=PLPFdtJO; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="OdMUD1w8";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="PLPFdtJO"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1750851772; x=1782387772;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=OdMUD1w8wfH4ZcOwpvk3+EGq+nRCSFmMDLbRUzjqLWfobg3E5hWEYQx9
   ehPoxq2dhRL0EMaTgwUd6OFXrQUeyQYEQXPQZHHbcR7U5FURrafB92HBY
   DZpx1mECLK+b7cQfOwCP7S7Mnpk2Ln0j087GgI0Trm3vmzl723E9Pwj2V
   JGJqnmtQnOFsTALwS6OL1Q8GbvUP2su69zXBrtQKlv447k4V2DS44nka7
   sWlB363rzM22QT0nLLeBPXBib7NbioC2qnKN+0smb6Q14osTRmjMzDOl9
   BldeuR1GWQr4vmK1Kv9ReNAlAmT488Llpbme21U3AtoKzCRXPaaP+Dd4V
   g==;
X-CSE-ConnectionGUID: m7pZ49r0QDegFKeoHup5MA==
X-CSE-MsgGUID: MI6q4ZnXT662MQKIykrPNw==
X-IronPort-AV: E=Sophos;i="6.16,264,1744041600"; 
   d="scan'208";a="85954317"
Received: from mail-bn7nam10on2044.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([40.107.92.44])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jun 2025 19:42:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kOvVzIwwYCZtIXwd+uwFNX3zKsN7LALTe9iu/2kIVH2oOPN29WgFl111ZHdEuPpx/qwXcrA6PLtBxc/+afS/XCJ9uicFYz1lSL+a9mH8acjcIYGa/rb2iMP6TOhrc/xF+TJwGzK1FKXGCxCFyWFcAos+gIFH2Ap90oMqVH4kJ8ttnHnU7R8qV7kiPgl9vB7kka7SMEwRpQcpY2pFMInz5Y8Mj15U6M/freMReEshqUaDykkuDywfK4TOgngp18WNpdEAlf19hdQ9B25qpofuhZ2dRd1NpQ+1Gcd9V8b9O+beO0ohyUZYIHm7UEtwaHR+/IWVXgiV0fAOQ4T+FdvxKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=T67qJjEq/PtT6i5GN4cykP7NnAljXmssaBQX1+EKqRhSgIWtvbxA5jBw7OpU+rkEMSt8dEtBagCbeisnS8n3F2fve+AJCrgRtri92mVT35c9KnfnvK4pGe9fuckNGprAF9ejs//Tq10f02rbO+MPhOVTANwnlsUO3gN/RkRBl4KckqKAEEd0Ly7/NF7mwbHT+T4tXtLdCmYokDioBA2fquxR0yFIJ9H1M5jL1UrcVah1AI0tXMyZTPZnq82iD+e588/THGh7lvS28FeDPC3gNwZ2/yt09dMPhY5wOp98R+fotf+tZdhqH/ZHdbka4i29xmM4EttPtZEqStSiYDHXHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=PLPFdtJO6Lh4JLsOAezFmY2zBB0dMzeopY68a+/4q0QtJFy1GRFwCOOnGRLZYck+RAu5Se9QgZlytpqZNtg2gzQY0cO4ex8RccU0KUtVMa8dHvWnfWlpMXRx+av0FCzrFANxmbq96XYVd7ei2iyVkHRSGLo226yxBww9DJthwdQ=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM6PR04MB6857.namprd04.prod.outlook.com (2603:10b6:5:249::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.30; Wed, 25 Jun
 2025 11:42:43 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%7]) with mapi id 15.20.8857.026; Wed, 25 Jun 2025
 11:42:43 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, Mike Snitzer
	<snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
CC: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v3 1/5] block: Make REQ_OP_ZONE_FINISH a write operation
Thread-Topic: [PATCH v3 1/5] block: Make REQ_OP_ZONE_FINISH a write operation
Thread-Index: AQHb5bXyEGE/+V9Pk0Cdo4zHNzGnX7QTwRkA
Date: Wed, 25 Jun 2025 11:42:43 +0000
Message-ID: <bccd25a3-bc8f-474f-8df2-1aa94536a24e@wdc.com>
References: <20250625093327.548866-1-dlemoal@kernel.org>
 <20250625093327.548866-2-dlemoal@kernel.org>
In-Reply-To: <20250625093327.548866-2-dlemoal@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|DM6PR04MB6857:EE_
x-ms-office365-filtering-correlation-id: 59f2952c-2010-4a1a-7f6a-08ddb3dd659d
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZVZwbkJJYlRTL3VvVzAySzlzZzBJb0hITWFBUWwycHdKMktvUzdueVhEWVJm?=
 =?utf-8?B?bWNzL0VHMVZMVU5yVUlEclY3UytCUm5WQmh6ZjBDMHh5am15cnRvNjRVNFUx?=
 =?utf-8?B?SnFoZkFXd1pLVnQrN1VhODMxVk9CT3BaYzdOZmdWTUFYL3d3RWN2RlJ1Rkk3?=
 =?utf-8?B?RFlTNmpyQ0RyenVTUDFKMkhUU2NHR1RSQnhpNmxNeG1GZXl1YWRnZlU1SFhR?=
 =?utf-8?B?RlFrZHNUc3dyVGdReWU3TGZkbFE1dDBOQnFZSFNZYnZoVk5adkJ5Q1YxR3JT?=
 =?utf-8?B?QjRrT1hjUHF3T09RQzBsSUQ2TGkwN3NkUmVZT0ZmUXY0ampxVUJjQkg3MHkr?=
 =?utf-8?B?ditYeTV5QWgzOTFPTC9CcUNSSndraDdRbnpVS0swMXBXVHRhRFRTcC92VmZK?=
 =?utf-8?B?bFJKZ1ZMUVJPQ3ZvZlA4NFFLcnMxTmFORGpOckFkZ0FYOXkxb3o4TXR4WUZx?=
 =?utf-8?B?U1VvSkIzTW12Y2JPajJwd1lVaElSUThtdjIxWmkwUUlLdlRHSTZ3T1RNWkVO?=
 =?utf-8?B?K3VGYXdjRUR3bUk3OUVZcXQ5TFhrUWt0bWdaYWRPdEpNTk5MYzVVbjA1a0FW?=
 =?utf-8?B?YTN2VlcwZlpwWjUzYzlzWjN5WkxXTGw1UWhuK3NSaDlHM3dCNnJzOWVnUHdq?=
 =?utf-8?B?YWJaZFRYdjZvaGUyNHpmQStWY0Jmc1Z2ZkhtNzh1V21wRnhmbDk2emU4dWNh?=
 =?utf-8?B?OHgxdjBLYXl4TVVhdEpObVBVTHF3bSt3bEFobmRRTExVcGpzc1p3bmJXU1I0?=
 =?utf-8?B?YUpNY29WVXV4N2NYSDNHWGdSL3ZOQTdVak9paGFOcC82Mmh5SHpGd3F4K1NE?=
 =?utf-8?B?MFNicUZzdXdlZ0NjclFyWUlDMWNFY3N4ODBLTjBhSHlRMS9qMVZCVTN6Q1h4?=
 =?utf-8?B?RmdNZHE0RUJGZVc4T0t6eXdjK3dzSDg3TWtMRUlpSHdWdmpPRDBkOWZJMllq?=
 =?utf-8?B?S3NwK0ZIVGRDZGxyUFloRmVHbDgvek1aT2FibmFWMlY5MUxTeS9HN2o2MjBY?=
 =?utf-8?B?b0NzN1VadXV2eTBCamM0UWtGQjJKTFJhS0hDUWp4MHB4VytSNWlWVmcxemor?=
 =?utf-8?B?M3E1VVJMYTlJdkY3Z1ZCOGtWSG9Zb1psWnhzRS9nc1NIaGFaaTJFOE1pcGFL?=
 =?utf-8?B?Y2hMU0p2V21VOWk4NG56TmNENkdLK201WjZ3bXc0aHZpU0ZYa25DVGd0c0c0?=
 =?utf-8?B?cG91dFhha20zRXo0RktvbDA4aUw1OHdzNjM4ZEFyd3R2S1pMK3RRT3V1czYr?=
 =?utf-8?B?M1RXTDl0em91a3lXa0ZhMllhTUVTU2pnUlRJVlAwYkcvWkJYU2RqTTdUNXh2?=
 =?utf-8?B?VHRqOGFvSHMrWGZmaWF2ZFJyVmlUTENoUmM3VGNHcWdHRFBOSFU4dk4rTmRN?=
 =?utf-8?B?YnZ4azltL1htMkhrZ0JrNmVRR20ycFd1TmowU0hQKzVqc21YQmhidW1wN0FM?=
 =?utf-8?B?T0ZOdHBIdjFTMHdKZEE5N1R4eTR2aU5XcTZzMCs5SHJTQnd2YzVqMnIxdDEr?=
 =?utf-8?B?Qy9DaHN1aUhrK0FReU11SVZPWDU1SmNxM2tMQmtZeHVKRU14SnE5djBlYm81?=
 =?utf-8?B?dGR3M1U4ZUJkTFFjVVZ5SUxNOXptWmhDeGFoTWFuRE5uOU1sRzNBRmVvOUFK?=
 =?utf-8?B?RG5hYWFxL2xIcklhSWJETlFGc09XYlFDdHJFL296QS95R2pNaDlLNGMrS1hh?=
 =?utf-8?B?L0dPWDQrVGM3VkFNdEpka0dDR1RJZnpyalQ4L2w3ZHNpbENrZ2IrY3huZEZ4?=
 =?utf-8?B?MnQ1S3E2UVowT1Jhem5SZ2ZwMWRoeldDbWtPaXdlb0k1bE5TWVdmNmFjMVVx?=
 =?utf-8?B?Q2JFRXNMN2FQR3N6dnkyWEZZdUYva0hMRHN1d1NxUGF6c3hwVnhadHhCcjRa?=
 =?utf-8?B?cUFFRHJkZktCZXg3QmhIT2NWNjZiVFdqTzZQMDlYMlE1d3RmUTJNMlQ5UlFY?=
 =?utf-8?B?UUxaak1NN3lsaEF4ZWRsMFhzTm9EOGg5L3lxQXNIczh5Q1pEeWtoV05CMWFz?=
 =?utf-8?Q?eJPOXFaDoRil6CT0b5yCpTTem9xOIE=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MzNZUVRINDVlTmQwMDFtdXNsaXY5NG1kaTVzTTFnRGJuZ2grYjdUWHFEZURi?=
 =?utf-8?B?cklDMVVKZkNTYzRMdWNsdUxQd0NzQ3VXTjZSeDNXYm9JOFVoWEhyenlVK0Nn?=
 =?utf-8?B?REpYRWhkNEx6MG9HMnFpWjdWY2RxTmEvK1phWURZUmIvZDZJN0YrSnlIYkRz?=
 =?utf-8?B?Y0NxalFCci9FaWZUSzNZNU9ybTBtOHlQSloyWWsxK1QvMWFhMTViRGRUenJu?=
 =?utf-8?B?bjRhd3d2cDNOZ1cwN1MzVVdIOUJBbUxSdnVOL3ljZEpvZkUwNU1vU2NNT0Zu?=
 =?utf-8?B?STN5bSt5RUFUVWoxUlhkRzRIYXlLSnA5bEV0a3J2bUtUdUhIK28zdFlWTFVJ?=
 =?utf-8?B?d0grQXpDZVBmMlhPWXRNOUlQMWFGbHF6VlVEeHZmTmZqaWxYR3V1NEpSM0Ru?=
 =?utf-8?B?OXVvWWVORVdraWI0N2VqcndlcDg2NnlwbG9yVWdxS3dVL1hYemMway9tME12?=
 =?utf-8?B?cVY4REdzVkZ1Q2szSGdKYnBHbTI3clE5ZGMxcHIvOW5hSlJ3d2ljL0cyR0FX?=
 =?utf-8?B?RWVJOXQzVUx1NURCTVFqUm4xNDNqMGVSQTlIUFYydWN6UmhHalpnTDFoYVRC?=
 =?utf-8?B?S3gyZkZDa1J0TnA1SS80RlpSMTljR21PZDZ3MTJTdjgxLzRxMUhyd1UxcGJn?=
 =?utf-8?B?UW1SVDkvUnhOWjMyN3FDcnRCc0FNMGZ1c2lrQVFJenpHMmlWMVhtVytCT3FQ?=
 =?utf-8?B?QlB3QUV4enZZWFJ6SER5V3UzZTA3dXVRY1JydkdIb1hLVmZnMXMvMWgwZXhV?=
 =?utf-8?B?WUpGSXhROGhlYkxXay9SUTREWGRlRWtMdEROdlp0UkFhYUtKQ0xpdmdzd0Vo?=
 =?utf-8?B?bDVjNnVvK2gxWmgwamhoMGVoa2JTT0pMNEhqRnlXUHJQSTUxZW1sN3BoTDNX?=
 =?utf-8?B?REZneHZGOVhOd1c0UlY2Tm5uTk9VTE80ZndwKy9GS1ozZzd0ZFZ4VHRyRjdu?=
 =?utf-8?B?ZHRFUFhnU0QrWWpvVGJETXRqMTJ5Z29Oa2RHNldQSG9wUm0zZXlzaTRQK2lY?=
 =?utf-8?B?cHR2RVR1cTdVNzF6ZTBxbktON3dqQ2Y0UkVTdjdiL1MrUlRGaEpFOEJ6bHk0?=
 =?utf-8?B?QjV3L1BNQXc1SUg2R3JXM0JwdzFhcGtxV2p4Y2NybWlhS3UwaHNwTjBOZVZS?=
 =?utf-8?B?U3FqeWkyVFdNNUl0VTZIVHlCbU9YZEZINkxsa3VTTWVCbW10cy96WmFOM0xX?=
 =?utf-8?B?emNsbWxpeEx6WS9CU05jRjJjUEgvdWRWNHpESWpPUk1TRXd1ZC9SMjZrUVRz?=
 =?utf-8?B?bDkydFZUVXd6UXdIaU0yTjZjaktxQ2hkYnk5QTZtbEY2eHQ5QTdrRHFjNjNP?=
 =?utf-8?B?VVEyaStZQXFJOExTNGJDWUlmSStGaXhJQVlnV1VCSGlGVWx1QmIyZ2lYK0Zj?=
 =?utf-8?B?c011VlN5dGtMLzFZYm4yRWdqQ2Z4V1prKzZoZEk1cnhWditObU5FWXBiM1JI?=
 =?utf-8?B?ZzFueC9zMkk4ZEFURmhqUnJBZXNEM3BJZUlhVEJ5ZmVIVU9yOWpmNzhPdVNJ?=
 =?utf-8?B?cWNzbWtrL2pITmpDRmlmQ1hSRU9FKzhPOWN5UGdxWS9uVC90WEVxVUZGNllN?=
 =?utf-8?B?aHNmUUpWUm9pMWM3RXdDbmsxaDQ2bUFVMERFWUU2VllqbVp3MFRySWRPTlRD?=
 =?utf-8?B?d1Q2UktKL08rNUNHaWpFN0tTK0dEMEovT0JrRzBRdk82TFA4RUxTYmZTU3pl?=
 =?utf-8?B?VENMMXQyak1UT2R5SkVQMlptQTY3dXFpM1FXSSsrRzd4VW5pSmxzZ2RtUlRm?=
 =?utf-8?B?MkNtc2s5cERzQ2Z1enRjZXo1MmhrQmRmTUFSZWFkYVFOK1VqZ3Vnek1GKzM1?=
 =?utf-8?B?RWNJUU9Mak1RU29RSkF1UVArVmYxQzlFK2Z5ZGl6Z1VKc0dWZTZWOGZJMWg1?=
 =?utf-8?B?WDNkWFRocEdCOGNjOGRTUXZzM2FXdk9SS0hDcU5JT2RUblNRc0pqQzdyb2dh?=
 =?utf-8?B?QVpNRnpaNy9hZUdqOXlhRzRhUkUzU0ZnV0RFYlR6Z24xd3VzaG5sTXBjblpY?=
 =?utf-8?B?WXI5Qm4yTGpQYlpTbEFnS1ZxUkVacFhNMnk0OWtoZ2luZGRqQnJucHpZd21X?=
 =?utf-8?B?Z1A5QzF4TDkrRWJwclpJT1BRMURpYnovN05ob0RibW1YclpUVXRIZE9QSDIr?=
 =?utf-8?B?TVNlM0k3UllJNmFDRktOTG1nYWg4WThyRXh2WlZBZDUwMkowT2xhaVhNQmFS?=
 =?utf-8?B?SFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4DD699ED691F1746B91FA884F64ADBA6@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JQkPBESvUWFw1sPNgi7fUTOb5gBhFIB2Uj7EbJU82MPL1z/bgTTFkSFql3MXppETv8tRv+ZpD9Pc1965FPCGhWPi8d4vo29Bhpk/BBsC425LQYfQa2ENSQUxWA95qGTgAXC/8FZNNxl2BowoUTWwP78xN8sheCqxToF+8+GbzBogjRV/zevTxBPA1GXj2Ypg0oKLrZmbozNXAdxY+bespkDotQqjiYJkZAB5sc51XfmDHxGQvk+Fhizd0ILZm9UiNp/Lf4SKenAtS0RBDpDwxZHmJrQMTYgDJL61j/YeEoML2O0pr7DQbj8OZ/Cy1jugOciOstEMJCi125I/x6HX0m7Lic1jWeMjNCPHwyL7pRqF1gcfHQYXUDQixparACsk3HAmT5F0O4gOpmzVIYG8ZzJ0W9RyXLPNTQ1RTxGK/GmxqCrB6MRqFbMKRctU33evlF9T1Dc2danP1ev+c8hG6Nxtp0i7tuJX0ypqv7UoBMfkBK3Osng9Dk/MCuH6FpM2Lh87mdMKEudxeUZLGL7oktfrYFclj/EfN2qyllDDfiFN7zSwUmYjZDkfnIa+Jr/TNoKjMfX9B26mRh1h0+Vii1enBWUrDsVIQ/64XoCKrXWm06BsgwUMCv54zRHrEYHP
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59f2952c-2010-4a1a-7f6a-08ddb3dd659d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2025 11:42:43.0278
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5p9qPcOfkwaKm0XTwW1w0xfQn99RkR8LnYzdAF6fpP7IuCzBkF6rYSlhmiZzcRrWyDhzu6XrFkP5RyYGbh8wBXR83jwrvffroXLisau5wKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6857

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
