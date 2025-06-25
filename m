Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CE125C704
	for <dm-devel@lists.linux.dev>; Wed, 25 Jun 2025 11:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750852166; cv=fail; b=UGx3b/F1T88LVuSyr1b0yD3cXWNOSfCj7XfRNhjSmlkyllPF8ImkPLCZPtq72r3RBVO3xh2cZmN/w3/qXmyt81DvvJHsq8tlvYe2al3fhvMOKc7Be2NxDhZi4e39t0cIE2D0oZp8xo62q7okgbR65p4q9tuz9W2MRlM+kfWLGx0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750852166; c=relaxed/simple;
	bh=OULjwvA3neUG1sHmKwW7kKV848AllbzgwDzP8DFs31M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YxJd8E0p+3eYc5JrnffJVQU20WHRfMO7hRTqTZP172NY+xCPpEBEvE/Yo2AIHbjCB/YRX0mnRC9Iv77A8goSYqas5/frqKLxOq+K7hFMGowtVlvNxNBGc+sBTMCkl8eFZdmuoKALT/L9h2jhK50qWd9kAF8G3/TF3jvkiGnHAWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Wk6Lqnfu; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=j3ySlBhO; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Wk6Lqnfu";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="j3ySlBhO"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1750852165; x=1782388165;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OULjwvA3neUG1sHmKwW7kKV848AllbzgwDzP8DFs31M=;
  b=Wk6LqnfuQ4Pf2g0ZvBPL1SuWzMbTVusRtPJgqEgAizfZCvSbo2+ezRB/
   ntGXhNGJRsIKwvll7cBEke18XftRR9QRQ08V+tn7L0YXgzTQ5v9625BwK
   UqGHNWwpcvhE42AaKuDfOXQ29y1+XjjkB/Zr6czE+7FGA7TCx9ju4yCg0
   txDwUWpHNqUyFsFPCgVE12lhZV08Qn+tYVi/VY5oOKGJI2dv9DTfzdpjY
   Ttpa9NAju0QQA0IqRizodcfhLqLv4ZvEwUYfbCOi2fPcvdp33wIEgpTTs
   IO6mWDzcS821/UlYE0iRRquLy9ROcE1rCNK0Hntf0DqSDZy/3s2nDm8JO
   w==;
X-CSE-ConnectionGUID: 8J30TpUzR+2ublBLBu4XqQ==
X-CSE-MsgGUID: vOS4W+oWSomhvDF2eJmzgw==
X-IronPort-AV: E=Sophos;i="6.16,264,1744041600"; 
   d="scan'208";a="84695508"
Received: from mail-dm6nam04on2077.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([40.107.102.77])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jun 2025 19:49:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w7rSlrstA66K3FXoTm2b3bM8W6wWR352E5FV5/D9khtfwiWoxYIW77KriKhZ8YEl6Et+6+bNjnGMHmbxPhgw97kyFWhq2+Lvx3d52YVEkd7iQNWUKG28NXxO4YRCKpTa9kGcgvxLVnGzsB5aO02rYgbq109mV2EbyJuMtzXHxlDSKrceGGfdUy7DKezGdwwO+bc+0o2O639fFla5fYHAfllofsLkNsd8ztMiW1FiXGgiWixu+XYCaEee26Pb19gmn6ac1f/NeMzVysk+kA9dz9xFA6v2w/FTHWpZ0XzI6Z9fH7KmvB9onXj3oihyMbn8lb00d58Vcplf0vEYAXkf5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OULjwvA3neUG1sHmKwW7kKV848AllbzgwDzP8DFs31M=;
 b=T1QYPyhuG3dD3gDCRv32NCFd0N+J+wNJSWpg2VQfcHd2+phGBWgk/CKy195ezWn2x+NhSxANUbIw+6c9RCAujsk49cdMMHCfVUFU4+9z5y1RlxEP0GxOCsfChJssfUqu82I7GFZK0fwQXEZeAzUE5SD95LGCSZBFjA2ChUnqSKNMmkrK8Sp61xmDp8rzQyCbJ6Rj+90ah/E3Hk16GBGIYMu2LJnTdPx7OX/RyJIUGy6L2nlRWQqYPgR/MpydGpCmYln59mOfFljxkrz1q8+mI+8IA6OHtfsLkP64Rg6ByQo36D0gANIOxFy+UO9vv2jmAR7dfcKXDb7DJ7epoC8I9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OULjwvA3neUG1sHmKwW7kKV848AllbzgwDzP8DFs31M=;
 b=j3ySlBhOOSP54ifFtKBMnnn7b546EgTGJnHRcEFOGLIXNQ6LSzvOA0o/gTVjSfsM3fE7DY82Ged+EQ3kG2Odpoy7t/yLm2NklUYTwgV3dsk1SWCNmy6JirbFb9amgu/rLlmtKgXMDpgKzUW8zRn/+JYcMAsFEvmuql4K5VbqB1g=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SA3PR04MB8671.namprd04.prod.outlook.com (2603:10b6:806:2ff::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Wed, 25 Jun
 2025 11:49:22 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%7]) with mapi id 15.20.8857.026; Wed, 25 Jun 2025
 11:49:22 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, Mike Snitzer
	<snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
CC: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v3 3/5] dm: Always split write BIOs to zoned device limits
Thread-Topic: [PATCH v3 3/5] dm: Always split write BIOs to zoned device
 limits
Thread-Index: AQHb5bWfNCmSPmk85Eq0Xx9PpHGIPLQTwvYA
Date: Wed, 25 Jun 2025 11:49:22 +0000
Message-ID: <e93a9f59-989f-439b-a5d6-b44afa121081@wdc.com>
References: <20250625093327.548866-1-dlemoal@kernel.org>
 <20250625093327.548866-4-dlemoal@kernel.org>
In-Reply-To: <20250625093327.548866-4-dlemoal@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SA3PR04MB8671:EE_
x-ms-office365-filtering-correlation-id: ba72fe01-d8e9-419b-0c19-08ddb3de53f1
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?R1hkZE5ESmIvTmpuNGFhd2I1MnBtVHgzSmc4WllaTjhlayt4ODNkb3NNU1Bx?=
 =?utf-8?B?NnpVeGpLN08waUZFRXNsdnRucnBDR0s1UUJCSnp2VktPTFc4Ukg0YU15dGdv?=
 =?utf-8?B?NE14dnhadWRSbCtiTWZlMjJXSk5HdnBEb3FiM1RVOWwveEdhK2M4SU1XZGdi?=
 =?utf-8?B?QjJUb2M5N3JUMzNDYkgraExjUlFhVWtuQmxpRGZacTMyTW5LUHNhdFB0TDhR?=
 =?utf-8?B?Y0JTUHZVY1lvUVc4NTZZNXdTYVY3Yi9Fak5QOEd3VjU3S2RyZjVSUUo5ZXJv?=
 =?utf-8?B?QTFXNWptNFYwazFwVmcxUkw1Nlo3d0dzSXFSQitIS3lKRUw4ODVLSWpSSTEw?=
 =?utf-8?B?MzZwVTdxZk5NbDMrdjlBMmN2WXNhdVEzK2JpMG5Eak1DR0ZoaUR1VzVacGp2?=
 =?utf-8?B?VlNFOHJpd2NFWnNMOG9TR0FJSjRZeTA0c2VaSy9UWkhPck5kd1hZZi91YWJi?=
 =?utf-8?B?T1dpS1pCalg1dlhQRnRvUDZzTlFXS295Z2Q4cUkzaGF5VmkrNXVrcVA2VE5Q?=
 =?utf-8?B?emZYUEJVR0hOQm1QMTdiYzhHeWw3ZStxYUsweGg3Q09yWjdDbVF6dlJ3SFpz?=
 =?utf-8?B?bERWRy9pMGxMKzR3WHQzWllZTFZLOGRrcmRWQlY0SXB6WHRla0N0WnNTd3BM?=
 =?utf-8?B?Z090SlBFbjZKMFpobUVPcTFDd3NiV1lUdGlZUjB6cXNmVGwxT2tOZC9XQ0xB?=
 =?utf-8?B?dEZudG5nZFZ3VWg5N3M2ZVh3VlFkK01xVExOSWpiY0lEYU1oUGtsTzBkUkpC?=
 =?utf-8?B?RE9HK1BPc1BnZVc4SEhDMzNybzlyR1dOM1VZdHh3bkNqSnYwOUZMdHd0VXp2?=
 =?utf-8?B?R2h4UWh6QWVpaHNPbVBZUkZDdmhwclpoYjF5VkFRaE5jeDU1cnpQbHBoQ1FC?=
 =?utf-8?B?YS9nay9kalc1Mm5mdDlQcVEzRU5RdHYwOWVGL0xXTFZiWjRmc2FheFI3Y0JF?=
 =?utf-8?B?VWFCTmtLeTNVak5BVnUxSjhyWklxVXFCU203T1I5WXY3VmlvZ2F6b2lpbm1z?=
 =?utf-8?B?aDQxUlJxQUY1bnNvbnlvaFB5bGV3NCt3RC96Z2VkT0M2Q0FqYWRZOWlZa2Ja?=
 =?utf-8?B?b0tmVGcyY3NENFNnTnIzOXZWQ0VrRUREdWhLelRwYVlTVzJxcW1laVg3ZUFQ?=
 =?utf-8?B?bXlGRFRMTEZ2RmpmSmF4KzJQTHRNTWVYdzQzV3pTOUJyNnh6L1NEUDNQTFho?=
 =?utf-8?B?bW4wYVVjRWF2ZEFvdGU0ZHdYN0ZSK0thS3JQZCttVGlvNmF3VTB2V1FUajg4?=
 =?utf-8?B?NW52azlnbWRRUkhobjU1QjlPSmdHbnJ5cWVKSFN5dDVQUEVhT2htT1F3Q1Yz?=
 =?utf-8?B?dnZLUTVvYkpiMVNmWlZkeDh1Mk5Rc2txTlUxYlZiUjBFaVg4QnVSbVRsL1RO?=
 =?utf-8?B?aGFpS1J1TkxmZFFvdE52RW9ndXB1RzAzK2xodjFXVzhaRGhqT3ByOFdEWEZM?=
 =?utf-8?B?M1lXM0pGb1ljTHlkc0RSWGRLOXVZR2c1ZEZrNVJWN0JGc0d4dmxqenR4SklT?=
 =?utf-8?B?R3BIbWVYbkxjS2pINUtLVDYxZngxb0RLZDFVNWlaOGpxSEd4ZHpiZE5XTGtx?=
 =?utf-8?B?OW0yNVROT0x1VklMeW0yWTUzQmlJVWM5NWhZYmkvV2FETjdQTjJWM3RjU05B?=
 =?utf-8?B?cUNEa29TK01sem8vNjduV21RMXdnL1dJK0VCWW0yaXhmTWtFaHQ0Nmd2b2lT?=
 =?utf-8?B?UWZ2VDlHNUdQWVFjck04b2dnUVJqVGcwZ2lqRUhybHNuQmJEMGJ4ZUVUK2dF?=
 =?utf-8?B?TytFOW41VlRHT21IZmtKUy8zYmJUWDdLWHBtWGdGRVlXRG5tR0Nsb0lQRlh5?=
 =?utf-8?B?ZnlDMk1rUENRNGVWYW1KOTk2UFJuTUp5emxYTkhCUWlGeUFScUVxZ01vQzhB?=
 =?utf-8?B?cGp6UndOQlBrTjZtTnVSYUoxREZUUHI5aUl5cmxBZXBYMVBIS0NrLzdwcUxI?=
 =?utf-8?B?UnU0K1VXdHJGYXhwSmd5ZkpwNkxFWUpCSHV5aVVLRUd2Q3FaVlI0dVRFeU50?=
 =?utf-8?Q?yMgTnAi3igg20P4hY2uhzLRCeEZb8k=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZTdPUHQyM0ZkelRrMU5LZFpPd2k0L3V0endpRXloc3E2dWpxdnZncUx5OTlV?=
 =?utf-8?B?VFVhQWZFcTRwMUsrMFBkei9qUEN5ampLd3pCYmI5ek5oKzVYdUhEN3JEQ0d1?=
 =?utf-8?B?am5qU2Ixd0xpaGp5VWZ1dlBVRkxXSWVLS1llV3gyVDBGVVRJMEh1aFpLUjQ0?=
 =?utf-8?B?Zk1KZnFGTWlKUE8rSnlBOVowY0lBaXZpY2FMbUV4RUgrN0MwM05JbU80SHBJ?=
 =?utf-8?B?dmxLRGFHdzBCeE9HbjBhc25zNXA0R05PbndtNkIzaDdXM1Uxc2d3TXZOMEtK?=
 =?utf-8?B?WElCbzgxcEZRTHVsUmE0YkpacDloRnFRTHluczZVM2NuNlVjeG9iV3p0RHU5?=
 =?utf-8?B?MWZZb096bURVZDJDK0hTMWkyMXVZNkliNWhHWkNFQWhhL0x1aWd6Y01FOHoy?=
 =?utf-8?B?UnpsNkg2cDVCRisyRjVaWWVWZWJraHhNTDlBS0o0ZDIwalZqRXZVc1N2LzN6?=
 =?utf-8?B?MWhKbzQvWkJ0U2t1STJZbU4ybFNNYU4vRC9Xd1REeWI0RnJoZ0hpVVZHQnVC?=
 =?utf-8?B?YnBzR1FjSTBZczR1RXZpYnVvaXg4WVROMnQ4dnRMeldwa1RqL05rZEFRazNF?=
 =?utf-8?B?eGV4RUJKVFZDaHFNUVJWclVjRFk0dmN4ZmUzVHkrSU9ObERNMGZ6WXhwSXR4?=
 =?utf-8?B?bkZld2M1MDllTTA1bFc0blFBOEdkK0RxRzBBbUJKS0U4VGZzZjd6TUx3NXcx?=
 =?utf-8?B?SUdaZEFXQzBxZHNDb1dEZi95Y1pUOS9NTHRjSC9nZVIwNmNocndPQytuN0FY?=
 =?utf-8?B?SlpJRXpRMnlMSUlwUXQvMDBGelVYSHdnUlZTTWdrbzN2dWp3ZUZiaG1QaFFV?=
 =?utf-8?B?OG9FWUV6aVFEbXFOSXhuMklRcFA5emJkbXNwaStYK0ZyOUxFUE5yUlV3OGVU?=
 =?utf-8?B?N2g0cWsvNWtVVHJncWFzL21ReFR6L2xvUEN1R3NqcHplcGdSb0Z4eXNwQ0xn?=
 =?utf-8?B?Y3dqN1RMdlh2SjBBRkdOalhCK0RSSmVvUmpDZ1Y2TzVTUkpsUmFGVXBydFF6?=
 =?utf-8?B?ODBEOWpvbFJRbG45OUlzU2xaOHFrUk1WOUNFb2hPRk5jYjhESm14dVFRbUZO?=
 =?utf-8?B?NHRqT3R2L1RPS3hqaUh4K25PMURqVVE5bC92QlM5dXBCZ2ZETTRmQVpteVVy?=
 =?utf-8?B?RVovbXI1M2VpUkVCZ3JZVXFiaFBoU0d3emdzVDArZXZBWWtEMlZRcVpGY1lt?=
 =?utf-8?B?QmJOekcxa2xPcUxaSGdnQkhFbzArTmN3b0thQ1l0V3U2R3R2ZmRTRHpvU2Nh?=
 =?utf-8?B?RW9Qa2hsRXk5aWw4OFlWM1NhZHA3Z1RFdjl3QVppOER4L296aUJ5NHg1NGJB?=
 =?utf-8?B?cUw1cCt6SnkvYXgwU0MxSnAyZ04zSlVIdWR3c0pRcWx0NWZKT3BlbmJjblJw?=
 =?utf-8?B?MjdjWDl4Mmkza24wdFN5bC9KcnU2VTdDckxjL1F4UWppVUluZDJSai8yc2Fy?=
 =?utf-8?B?VzhKZ0lsZ1ZLM2xJc1pmVWpHWjEzNmJxK0J2MVBwQnlXZHFoYjNCVDYxMVY5?=
 =?utf-8?B?bXZIMkZQc1VydzlDb2dzcDdVcnpIL3pVdk43ZTdSa1J2VGxqZHhoZGt1Rkl2?=
 =?utf-8?B?ZDVhOUR5TG51OVU3OVBxWmJJcVVHYWh1cCtDbUtuMlhZbjFGUGFCTVVWc0pP?=
 =?utf-8?B?M2UyblMzOStFL1dkV3lOOFAyTzVvK2lSQW9ZN1ZHdS9BK00ycFZCMW9EaFJw?=
 =?utf-8?B?NWlGQ05vQTMxaWFUcUV3YjZEWUQxeTgwVmFDb2FmN2s4QmJVMlkzZjNoUjRh?=
 =?utf-8?B?QUlWcE1UYUdzbjN1WGp0SWthOG96R0ZlZTEzMnpvT1o5NXVxQUJwdDZqVlBY?=
 =?utf-8?B?Q2VtRHBwNmRNNGY2M3plWHhqemY1T2NUQkQyY1VIRjIyTGtJbSt4VzdxY0Vw?=
 =?utf-8?B?YkE2RkMycHdrS2dGYzFwdENDMkY5RnA3WUUwN3BNazZYUzJXaFpwNXMwS2Jm?=
 =?utf-8?B?K1lXN0ZpdzQ1ZDlFTlI5QVF6RWI0V1YxTHRNR2I4MGM4MWUxTDVrVzZsYnAr?=
 =?utf-8?B?Uk1TK01GT3BuZ0kyN1U0aHZtWjdZZElxazhqdFg0N3Qwb0dPNG9UaXVQL0Zq?=
 =?utf-8?B?STVUY2Y0NDFPdy9hTUk3cHo4UGdUUkR3d295M1JsQ1VPS21BOWNGVllybG5q?=
 =?utf-8?B?WDErNHpFRWpRYXNjN1ZSY1F6Q1hGb3RIVisvWUx1eFhTelVjazhUdittQ3JL?=
 =?utf-8?B?bHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B240D43E570A0D4DADA9462F4D33E12E@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pxGzYn4JYPmq7Xs1SEwlPDJ9WTaw1YNgCIz1y5dkBL9QiMgkezasJEYe5Mnn28an6nxvCzCbSYKjeUnNzSs/j+iIFtmsheQlIR8LM6nmKBE2w0q+3UQb389PjamtAZZ3jVYAng5j6WrRMM0J8YhwXktjfCMM1IbqQtqTuUyhLuiXrCXC++/xNNMaxL8i8Q0+HmHv2GX2cRao316RerhSIKrx34MAtEOmE0JJzUAKnEw5edBrSMHfgZeHNnti2Xe7o4gTzzO2p7CSKUXKYbB4s3tvYneQ8p2/yuF7MfvA/nOVq4UYjw8B+6t7rPugVIh5yL/ak/Y8Zn20+D32NmFh/cTT/CT4qKF4mL2Q/xz/aHWF+646I0VmbcPIbHB/j8G37uCgTKpLgUG7tHWbwRuVKgaN9vBX7c2UqcZmeLji6XrKc7Dc0NGLbeRCEp5Ni4GQznxsuIzV0qM6ieZ3W24tKACKdh6mTd+OLHum7DWx0fh8BrzRr1DytxJkv3FIJ/is7Vjjsvi+HpzY3wXqE4itsewnKeycMrC8Irmy4wAdLK2pby8O/PQ9hYoZBtGI1uT7n/ojpT8KGB34C9SwWGZjj2u9nHruddMUmNubgyGvrCbxm3l2NAQr0TfkZNAjOBNr
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba72fe01-d8e9-419b-0c19-08ddb3de53f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2025 11:49:22.8567
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vKeZ5nq3cXdaV7fO2rhfvawaFknKGlNO5RPbtutEM8QMYD8dmWIXbovvBkKHDmwrcvq+waF/71LVbPd1ZZPbGiNlpiFyW66UICVlf+HPvQc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR04MB8671

TG9va3MgZ29vZCB0byBtZSwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFu
bmVzLnRodW1zaGlybkB3ZGMuY29tPg0K
