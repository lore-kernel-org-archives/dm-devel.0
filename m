Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2048.outbound.protection.outlook.com [40.107.21.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB765644F
	for <dm-devel@lists.linux.dev>; Mon, 22 Apr 2024 09:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.48
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713778440; cv=fail; b=nJ5XGcxICMuGLwssTqKKHm/cJfETezqeih8tGkm/hzLJbLTZZ2qcwRYGbOvGmoadXJ0Nmg6ltm202vLryAUY788B2ojdVBj22N2z5APY/8ikoXCLO+FLUdZcAAT3qivAIV4GgYUiF9QTIIWMft0fOigX/6ZAVhsT9VHy+tWInjM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713778440; c=relaxed/simple;
	bh=vs1OQrL/hOrOL909MZpH1Bmng6128yOKcnHMaqqYWsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dAGnONg/oZHHw9Lyp/Dp6zaow7SjaJd5foe2/c6JCRqqg+exI7qA0sQt3nOmRalUBnuqjkixtSjafqBYrCJ+IztV8Ou+CTI0x91iR+Nbz0soQRlcZNmiEwH5CBEgf/Lrk6lIh7Ft7b3CEs7Wnjd4nVr+SvbqaJSCTbtz0LFLVa4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b=8a7/cHdn; dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b=8a7/cHdn; arc=fail smtp.client-ip=40.107.21.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="8a7/cHdn";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="8a7/cHdn"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=pass;
 b=AJMXxocpSn6x1866Aqv3ZxED+lOry61lx+1+682XO/CI4/W5eb50iZLkSjSN0x6LvBosGbh0nWXHzaD34I4AEo9eGZ24eakO/3dazin37xpDd+1mNxTipjKweIbVlUGU6RIGJ/cdc3wJyDwy/Ly4wBqOv3RsFuz8hGzjBXOs2PhipJTe2V25T88zggUDn4zgQIK9fiIjUaX0kqsUUR1Z72ZvYRMdbRGM/83PwybxO1je8pa7mSn9MXQIYT+E0tXbem3yMqHoOMr9ZMun/KmwATsX6xHiDgKkhqCv05H5794mYpaE1RPKcNEHZ+faBLatvvVV0dwFdL6a6BxmnLiywg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=etE7acvZx6HYqe2Jq30jD7X3z6QlcL2aoalD7eHzZOY=;
 b=KKJAHzel84k4U5eOiF0a4Opw8KJhSXrG0IcEebYEIR8mcBib1dOoIqE4Lct/lrw3Lo3WfBwsCenZq60H8mo6w4eT7jFu+q8Wu5l2IVvvmTh5znk0mwkm50mWhmROn5FchePKDPOteA3m/Q+IFEJjEVxbZkrIO5SyIkZ4fG42JJEltqb4wgZFZLk4GJvHokOqyZpvGS868Fq/xaysM4REh52k0H6Io6sS0S4xYwotZCa4dWrt4XoHtfqgsGOYXnH8gEQBFeZLbiCwZAnIGN/4GvufgaqSsznOSjH8wjfz2a9G3kTphtcYkghuWYVY63fovsQUpXDe2DrNi8gTcAI5AA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=armh.onmicrosoft.com; arc=pass (0
 oda=1 ltdi=1 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=etE7acvZx6HYqe2Jq30jD7X3z6QlcL2aoalD7eHzZOY=;
 b=8a7/cHdngYvjJHbQtAWETopNtPrYFF1Os+VrAS7h6jjirKj9wN4zgyv67/wqunJ5w/gzghtd7cy5Lj5qLqwkFTe4UwbdnapfYD/kRpKdVOa4HyhHsIRmz63BH13B7skpggzCWDOPHw0RMMM/fMI7Rmaph6mSj94UojYGwu7kHfM=
Received: from AS8P251CA0003.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:2f2::23)
 by AS8PR08MB6728.eurprd08.prod.outlook.com (2603:10a6:20b:396::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Mon, 22 Apr
 2024 09:33:54 +0000
Received: from AMS0EPF000001A6.eurprd05.prod.outlook.com
 (2603:10a6:20b:2f2:cafe::1d) by AS8P251CA0003.outlook.office365.com
 (2603:10a6:20b:2f2::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.33 via Frontend
 Transport; Mon, 22 Apr 2024 09:33:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AMS0EPF000001A6.mail.protection.outlook.com (10.167.16.233) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7519.19
 via Frontend Transport; Mon, 22 Apr 2024 09:33:54 +0000
Received: ("Tessian outbound 88c46f8f09a7:v313"); Mon, 22 Apr 2024 09:33:54 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 4a30949d174ad816
X-CR-MTA-TID: 64aa7808
Received: from fb65f69311db.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 5408B32E-F173-4017-9A6C-3D907CE3F879.1;
	Mon, 22 Apr 2024 09:33:47 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id fb65f69311db.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 22 Apr 2024 09:33:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KLllv7BCaB1DfMm6p5Qlplgq5DFHJvxobvzOmUmypUk7gMQhpyf6T8x9lmKcix7brpGJ21krkE+qzu1FtCflvxs+W7in94Q7xz7NUyTyOZthSFlBamry/hkZbiCexWHkgHotWxgQ59IoWz/KRHG/dZu0HYzSdDpQLN7DCZdbqAufFeGzywe4pwtFd+KYmp7CkkWW8M8iAElXD8s61l+8SOgkIIIGR79Pj/ySvH3LcRX+vVcCdFftX93TGw+cJ7hsDrniT3tRbLBe1aeT3tf0rS9ZQ8yGEtEHe/tmQ1NhiChFzYS7Yv5Yfskaa3vBJM2+SBdHgCaMB8Zp/4XTIWhpOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=etE7acvZx6HYqe2Jq30jD7X3z6QlcL2aoalD7eHzZOY=;
 b=ob89I+0IOgza/CzMZo9Eit+5fPLBjofQ0onecaRgE6y1LdMOBDu7sDuWqwvd8KytDonfDFh0Rp9UOe8lM/vAwiC2hNi3CSfk+6lHXfh0JeRm/C4u38PqWR/Yle4gJo0j9p12/qWbr8+6hJ59GJceps/8PHKdl4vKhrQnDsWrG1NGAzF8cYU7nVIJOwuwfeobnzpKLGBYXxzRhoLkxRYrdwe6H5D2Uqoz5pyUw8Vmj9iSO7DlvqZJdDcc4vNDd+IQ0Hkh1FBtnuu0wX+Hu2yZVmBBkTqQgR7gnbu4dD6JFv/lfGY6Y8UQeic/t1oUf1f15uZi6CwRARV1flGsppyT0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=etE7acvZx6HYqe2Jq30jD7X3z6QlcL2aoalD7eHzZOY=;
 b=8a7/cHdngYvjJHbQtAWETopNtPrYFF1Os+VrAS7h6jjirKj9wN4zgyv67/wqunJ5w/gzghtd7cy5Lj5qLqwkFTe4UwbdnapfYD/kRpKdVOa4HyhHsIRmz63BH13B7skpggzCWDOPHw0RMMM/fMI7Rmaph6mSj94UojYGwu7kHfM=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com (2603:10a6:10:2cc::19)
 by DB3PR08MB10335.eurprd08.prod.outlook.com (2603:10a6:10:435::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Mon, 22 Apr
 2024 09:33:43 +0000
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::8c23:46ef:c2c9:ea91]) by DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::8c23:46ef:c2c9:ea91%4]) with mapi id 15.20.7472.044; Mon, 22 Apr 2024
 09:33:43 +0000
Date: Mon, 22 Apr 2024 10:33:30 +0100
From: Szabolcs Nagy <szabolcs.nagy@arm.com>
To: Mikulas Patocka <mpatocka@redhat.com>, libc-alpha@sourceware.org
Cc: Zdenek Kabelac <zkabelac@redhat.com>,
	Ondrej Kozina <okozina@redhat.com>,
	Milan Broz <gmazyland@gmail.com>, dm-devel@lists.linux.dev
Subject: Re: memcpy is leaking secret data through ZMM vector registers
Message-ID: <ZiYu6laGnTGbkRCS@arm.com>
References: <a139443-d6de-7be1-c59b-c099b0b32884@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a139443-d6de-7be1-c59b-c099b0b32884@redhat.com>
X-ClientProxiedBy: LO4P123CA0163.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::6) To DB9PR08MB7179.eurprd08.prod.outlook.com
 (2603:10a6:10:2cc::19)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DB9PR08MB7179:EE_|DB3PR08MB10335:EE_|AMS0EPF000001A6:EE_|AS8PR08MB6728:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e69e9ec-21b3-4fc9-6208-08dc62af53cc
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?Q1J1R2pac2FmU3h5L1I3SWR0a0s3TC9Ma09xSmpYNXA2cENmdlhNVEhCOTdv?=
 =?utf-8?B?L0JhcWlyNkJ1TUpCc1B0STFyOGlJQkRocEprdlEvMkhOcHpyeGZYSld5ZFBN?=
 =?utf-8?B?NkdrMWVCTFVSY1JSYWRTN2J6VFJNYndicEphUHpPSVJyZkxTWmJCN2xBS0Z4?=
 =?utf-8?B?SkZVRnNWU2w5bW5uVHUxY3ZDekJlWXdvWDViSm04NklEWkZJQWJsK1RpQ1JW?=
 =?utf-8?B?VXU1dWpFelZWcXg2dW4zemdrQ3pjcDViOXhUUU9tVkdhaTZIeWJSQjRsTWFy?=
 =?utf-8?B?Nko4bG1rRm1Vd2NoNXExZzVXUnI2elFOK1d3eXpEOUFVTGxXeFJhUHFuY2Ur?=
 =?utf-8?B?emVtZXVId3lSVmFvTFNrSkVzcUdCNEJKeUJZUnN0K3NqSVlUM0o5SklrS2Vt?=
 =?utf-8?B?Q0RGaFIwSUJCNnY5QncwMElIY3kwbmxQZTBxbWVXZ3hBOUhEd0JlOHRFUzY4?=
 =?utf-8?B?aTdieUNYbWhxa01qaWlRRFJwak93QVc2VTRvc2dyU1VYb09JRzZvMGVHN0dm?=
 =?utf-8?B?enAxU0V5SUpGMWF3VjVBQ1FMOGJRZ2ZWdndJdTk1SDdYQnJoK2MyLzA4V2F0?=
 =?utf-8?B?c3BiMWwrTmQrSnNZTjdrdFdKRW93YzNTYW5VTXVGWi8wU3lmUStucnJKYTdu?=
 =?utf-8?B?WE9lSWtOQlZxN0lTZXdRdjBFT0xNS3hmVENzRXNtL2VDRUNnL1QwTGhKOHh6?=
 =?utf-8?B?b1d2RmhNQU1FVGdqQTZSSHVZTmdmRW0yNXV1bU1MT00ydGE2bXhZQWRVTXlC?=
 =?utf-8?B?eXBjaHBKOG9yRjNwUjlCOWkzYWJrbW94SlJ4MldIbkYyZGlDTUJBQUNvd2dW?=
 =?utf-8?B?R3YwNEJFRzZIVEtmRGF3Vkx2RjBuOExQVWtkMGJyWFhPd2ducXNRWlIycDFk?=
 =?utf-8?B?cG92SVdmMFlYR2FJdjE4Q3Yrd1VLd0RoQTFZS1ZRZGp1My9CUm1IV3ZJVk5T?=
 =?utf-8?B?QWR0VkhQdXpQRG9McFptdGNIY0JQZUdFZFR0YXhnaFZEeVZvZlVPc1dkQXVn?=
 =?utf-8?B?WDA2SFlpbTVSRzlqOEd5UWtYazdtcWEyMmg4aFFlU2VRVXFBRUQ3dUJwL2pV?=
 =?utf-8?B?aHR4RjRBOVFXMVgxRkcxdVBGdy9LbkJrSTdNNVhNaUFUK091aGpxTWhnT2E0?=
 =?utf-8?B?a09RamFDaEs1aHJZMmd1L1hSVW0yQWVTWmdLNlBtSmdHUE01bkh0Um85eFNh?=
 =?utf-8?B?SlROYXkzLzUvSkRkUnhyeXFDYlJNR2x2WGZxZExrT295NGhIZlRTN1RvaWhl?=
 =?utf-8?B?aWNTa3FXMEFudUI2RHZuV2FWTTFNdHQ0RUZ5MmQvTmg0M0wxcHBxVGU4Vnoy?=
 =?utf-8?B?RmQ5aStkSTR5bXVZU2xkb0IwVWVJWjhHaGM4U2VvNTY0THNMUXd1b3ZMWDFV?=
 =?utf-8?B?a2FiYlA4SEN1dWNYWHpsNU1JbklVWitaTGFmeEFOOUp3Z2p0MXNaUkthOVE5?=
 =?utf-8?B?dW5sVGJHUS9uUmJIM2FzOW16SDRldngxRlhING1ienVlSXphVzdIOGhTWXRv?=
 =?utf-8?B?NHlFc1JXS1BjWWNHS0Eya2tpWXhsYkZldkVHUTJ2NDR2SXZUYjBFRDBhNGRK?=
 =?utf-8?B?VGVJMnBHdVZrTHVGQklZaTFDY2R5K3BnWnJ5MDZqUElaMC8zWFMxSk4rWXdB?=
 =?utf-8?B?YWNoSHJPaTZqUFdTSU9ZckxvQUl1NGxkS1o1bCtzOUVMUmZKK2FrcXNZaEZh?=
 =?utf-8?B?cjlmTDh2WnoxZHdBSVlmcUhTWTNHRmFTS09GWGErQTZZTGJHY1JYaERnPT0=?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR08MB7179.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB10335
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A6.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a751d886-943f-4d4f-13fb-08dc62af4d49
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MlNOMGZyV2JKK25Mc0x5NWpVbEpIVjlrc20vRDNTSHdKTUZoTDN5cEJIcWFW?=
 =?utf-8?B?dVgwMk91WGNwb3RvZXFDeXZUZFQvbVpTMlJWaTJnOGJscUJ4RStoKytta2Np?=
 =?utf-8?B?T1hSVVRLN1RZam05NDMrQUlKR00zZVc3a1FFRitFYjZ0K0V5UG43S2dwMDBi?=
 =?utf-8?B?MVZxSzdPZjZrNDlaMGkvZ3ArRmYzOHFCVlI4YTlDelVXSXRNVkdFek1KMG9u?=
 =?utf-8?B?THJma3ZQWElsR1Bhbko3TndMbHQ5ZlNQRGVMd0U1V3JtSkRoa1NGR3B0YXJ6?=
 =?utf-8?B?MHNNN25XUkNVUVhjSCs0YmxYTWlTeXdSeEY1WmZKZkFTbFZsQTVNTUlTSUhM?=
 =?utf-8?B?RGFodG5PbUh6RDVrSEtpNHY1MS9rNmFnNFJsbEk2WWtHS0JYSkNQVzgvNFNi?=
 =?utf-8?B?RFBLT09RMy9FVVJ2d1J1dE1IMHZnYTNsWnJ0c3BWbUtkdzZqWHhRWXRDd2R2?=
 =?utf-8?B?blFsUWVndlhFV1hYZ1lpN1lpLzBFY2pVdlZmME5TM0lQbEFzMjFlcFgzbk0x?=
 =?utf-8?B?S1FMV05YcUl2QUFjcExveFp5UTRGUDRvdThJMDI5dFhiZW9xWnk3eVVqWnhX?=
 =?utf-8?B?ZFdrQm10WGpCdGMwSmo2Vk9zMzVhZ1VwdXhibGhVNk5GYjd6M29EaEt6bFJJ?=
 =?utf-8?B?NXZPRk5uT2pJREdTbXJic0JQczVaejArb1l5ZnVDMmdGakVTMDlkMUZaVytj?=
 =?utf-8?B?SGVGWjRSY3FxWngwTE9oU1VPSUxraTdydlFOTWhSWnhxNGdEOFdQZjhnbENz?=
 =?utf-8?B?ekdncVV5L1pISUR6eXZBQXRNQWJlbGdGcEN4c2ZjZnFqbk50eWZyVzlXK2Rs?=
 =?utf-8?B?eDU3bVRIT2pZbHZBR2pEaHVueFZPR0J1Vis0aHpJanVzSmRYWk1rcjBmUVRB?=
 =?utf-8?B?VnAzYTdDYWtkdStFTlNIZUhYcFRuTm11SzNVeDY4Tk1xTzVpSElNSHR0TndZ?=
 =?utf-8?B?YXZ5UjZGNThmeVRVQmdGSzVCaEZOcWl1NmlOaTVOWTVmcTcrblBJV3VPTk5I?=
 =?utf-8?B?dEFCK2FWbE9RM3g4SGtpZGdpcDNHT1ptOVdQUk5uTEFXaitFMmpsemFjU3hR?=
 =?utf-8?B?ZEJidWR3U1FlQmNDU29YT29zNWI1NXhQcDZTd0p1eE1Bd1FPVHdzc2tCWWM4?=
 =?utf-8?B?MUdpSHVLZkl3Z01uQ1BGSkJMRWRwQzBXOTNMYjdxZ3lab0Q5M3JwV2VPeWpw?=
 =?utf-8?B?ejVmeEcydGw5RGZzVUNEZmI0UjRQMlIzOXkzYUVQRk5rbEhSMmpQK1FRV3BK?=
 =?utf-8?B?VkRYbEJjZXRjNG1OQWJwK2QwRW9MN2FReVRlcHNuSURTQms2M2F4RTZNU25o?=
 =?utf-8?B?VFpza2h6cGpXWTBOdXcxcjJCd05sSzhQc1pqbHB2alUyell6TWpIaU1MQzJE?=
 =?utf-8?B?MVZFbWx5TUE5bjdWNnAxeFA0UDUvSXhqeVNaRURjMU56VGtMV1UyMWowNU9p?=
 =?utf-8?B?NWIxeEF3anhMODdHazdNdlVJZFNNOFd6WFZna29qazJzNFlubW53cGVJeVJk?=
 =?utf-8?B?ZG55YXU1eG9vNy94c0hBcWloNUVObGEyQXZxanVJR0VtdXdOS0tTREFHSWdP?=
 =?utf-8?B?SnlYWWFHSTBSbW1rYlR5eVBsK1ZpTHFoTG9kZit6UnowdGZyMUF1K2IxQUlX?=
 =?utf-8?B?bTliMnRyWmszUCtxYXFMQkdlTU5TOEhZdVQ0am1NZy9GVGgzNGpLZ3IxOS9h?=
 =?utf-8?B?VmdQaFBSSDJIdXZsOU0wY3NtSE4xZTRESklXbDdEY3A4RTlzR1F4QlZhUVhx?=
 =?utf-8?B?NE5oN0h2VWFvWWNxdmNYczNFL200TU1wUWp5c2l4NFpiTGZscnJFVXJ5WGF3?=
 =?utf-8?B?d2xSZWRCdUxHUDVGdmcwbkxseEFyNkQrSHJuRG1IT0VNS3JyWXJ0VkUwUE1E?=
 =?utf-8?Q?LcwPI39kO8Df/?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230031)(36860700004)(1800799015)(82310400014)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2024 09:33:54.3845
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e69e9ec-21b3-4fc9-6208-08dc62af53cc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A6.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6728

The 04/19/2024 16:07, Mikulas Patocka wrote:
> Hi
> 
> As a part of LVM2, we are developing the libdevmapper library. The library 
> may be used to load cryptographic keys to the kernel, so it avoids leaking 
> the data to kernel memory and to the swap partition.
> 
> After the use of cryptographic data, the libdevmapper library clears them 
> with memset and frees them afterwards. It executes __asm__ volatile("" ::: 
> "memory") to thwart some compiler optimization regarding writing to 
> to-be-freed memory.

instead of

 crypto_foo(key);
 dont_optimize_me_memset(key, 0, sizeof key);

can you do

 crypto_foo(key);
 memcpy(key, dummykey, sizeof key);
 crypto_foo(key);
 memcpy(key, dummykey, sizeof key);

if there is no sensitive data based conditional in
the code (which there should not be in crypto logic
nor in memcpy) the exact same registers and
instructions should be exercised twice. i.e. you
clobber all state in a portable way, no arch
specific magic hack is needed nor new compiler flag.

technically this can still leak information in all
sorts of ways (c is a high level language, internally
the implementation can do whatever with the secrets),
but this is pretty much how far you can go within c
(pretending otherwise with random weird compiler or
libc extensions is a mistake imho).


> 
> We have a test "dmsecuretest.sh" that loads cryptographic keys into the 
> kernel, dumps a core, the core file is analyzed and if it contains the 
> key, the test fails.
> 
> This test fails on AMD Zen 4 - the reason for the failure is that the 
> "memcpy" function uses ZMM registers for data copying. When memcpy exits, 
> the encryption key is present in the ZMM registers and the key remains 
> there even after both source and destination buffers of memcpy were 
> cleared.
> 
> When we perform dynamic symbol lookup, the ZMM registers are spilled on 
> the stack and they remain there forever - this is the reason why the core 
> file contains the encryption key and the test fails.
> 
> I'd like to ask what to do with it? We could use LD_BIND_NOW=1 (or 
> -Wl,-z,now) - it mostly works, but not entirely - the key may still be 
> present on the stack even if we use LD_BIND_NOW=1.
> 
> When I hack the file glibc/sysdeps/x86_64/multiarch/ifunc-memmove.h so 
> that it always selects the ERMS variant of memcpy, the problem goes away.
> 
> Could it be possible to add some switch to glibc, that could be turned on 
> by security-sensitive programs and that would prevent glibc from using the 
> vector registers? Or, do you suggest another solution?
> 
> Mikulas
> 
