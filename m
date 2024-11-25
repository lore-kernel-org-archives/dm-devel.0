Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2071.outbound.protection.outlook.com [40.107.117.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B64C126C10
	for <dm-devel@lists.linux.dev>; Mon, 25 Nov 2024 05:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732514310; cv=fail; b=TYM7TwSrAdyx3XF33+UBewwmxF7BdZcG+HMTb1tZtWfhKHMZT6i51EowwIkFIiAuPTXN1BDLpm3dBv/7xzihEn7gM+OfWOgVeHObOXLjun/pTA7LBzdxpC3rnIvryDtQ39S4eaxGls+2xBE3NFvzGPeN+LGawSJAxwkqiIGYgKE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732514310; c=relaxed/simple;
	bh=mhM5AouTrRTUyNk9PINniBEohHyQGoRAmUiq5XneGsA=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=uElE+uQIy9bXp6jryMsjK5Gem0k3z6M4S2pDk9XxHxu6DOxa5bpeAL6PtKlIzOKd6XWj9RUg/4MNh0M0VZfFjePhjGh9HpHltDBitpOBCT6iRlQVrrfszpb87ynQaYkgasnZVEZxszXzp2jRVr9FT6ZMpOzVPXlVge+cA53z1RI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=kD8cAUeu; arc=fail smtp.client-ip=40.107.117.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="kD8cAUeu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NXyILvEK3/VVMWJ56rol8VZF0PMwViI7jUb6RUaK7hbBqF72cRscSmkWsaZ3jpKoxCvgf6oabPOh6UXvfm972NV7Wo/wYqgf0Vl/N/JavwvEYaz+mtF2hkuuhbqSidikiS0MHjCWgXLQShHWKHmon8WTw/em6wjdOVFHvVw1GmTZjt+UP8S5naAshNQDRXPVz7+hJC1IDxFX2AoWhh6h+7h6H4nLspmjj8jMfxFmcukxezM5m976N4MYHc2T2x0ZksFGOpwp/SYC7/3q6HH7TTipPcNjLZYT1DnJPJ9yTUcroiRTOfc0HSgozlnq2lLNMLgxwf3AfjyoZlHPg7KP6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mhM5AouTrRTUyNk9PINniBEohHyQGoRAmUiq5XneGsA=;
 b=JYof/4ElcfuxQwaRh3qjZ5gtvbtXdcfFqEc4kvwe+35Cyy6q3CavjG/5cAqdw8QS3wT9Fdx/WSRW4dsamneTL216JdaUd44iq2XQLFxnpWMwErHHIZpyALu2peIR43jh2hmFrPC5kMtBEH2A0i9GxdyRI8uoHki0WWb8iUms8WqYxHx+eqNxTkOhsyQazVbsS5L/+7H0fpV8ODwcwiybvJgZN4H6MvPeN6amNECfBizFUGX2u62niP7ph3HG8o25mby5gdCX1/6vNS88KqeEzzEDtB+88w8gQ42XejzBj5uVRRPrtWd9maBCjr4IWblwKp7SbRdc+XbUUXNEFOObyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mhM5AouTrRTUyNk9PINniBEohHyQGoRAmUiq5XneGsA=;
 b=kD8cAUeun23H8f3gO50i/gELAbWdESZXiVZLig9ccsCb7vFttduDuKk3roI+ovXwTHdfIafkUwL10Vmr/GdtBfARZ2fpOqU44OlO2CmJ43kbdNnRxEHV/EnCSliRGXB8oWw4qmJotRkASAfMgi0L2sO2o+A4bD5B8mI70IDoI8k=
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by TYZPR02MB6550.apcprd02.prod.outlook.com (2603:1096:400:45c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.20; Mon, 25 Nov
 2024 05:58:22 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%3]) with mapi id 15.20.8182.018; Mon, 25 Nov 2024
 05:58:22 +0000
From: =?gb2312?B?zqTB+sa9KEdyb290KQ==?= <weilongping@oppo.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	"snitzer@redhat.com" <snitzer@redhat.com>, "dlemoal@kernel.org"
	<dlemoal@kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"ebiggers@google.com" <ebiggers@google.com>
Subject: Re: [PATCH] dm-crypt: set max_io_len as chunk_sectors of zoned device
Thread-Topic: [PATCH] dm-crypt: set max_io_len as chunk_sectors of zoned
 device
Thread-Index: Ads+/e9JuZn42/qAQMCYojxAshkP+A==
Date: Mon, 25 Nov 2024 05:58:22 +0000
Message-ID:
 <SEZPR02MB7967C480572B3B15D5F57F92D42E2@SEZPR02MB7967.apcprd02.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SEZPR02MB7967:EE_|TYZPR02MB6550:EE_
x-ms-office365-filtering-correlation-id: d0919951-970d-45da-6aa4-08dd0d162b62
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?gb2312?B?ZnBlQ1FWYkQwWHh0ZnJ6Mmh0Sll0bW9ZbEtqSWZESDFxWGw2SEVVMzFnaFd1?=
 =?gb2312?B?UTJmbVQ2bXp3RnNzUnd0V3FWOHVzVEl0ckNjaFUycVNvZlRqckVzVkhmZ3A4?=
 =?gb2312?B?RVFralltc1JoMTRPR3FHRUN2RVJGTzBCMUhzRkZrSlpyWjlDczdvM25KVTE3?=
 =?gb2312?B?RVhPTXZCaE1SNXZIVmg4ZWlhSTgveStqOWZkbGE5NjhXNUNJUnI0MXNOdUVi?=
 =?gb2312?B?WFdPMGtnekF2bTByL0RFZ2l0MElnM1dNMTBxd2tvdm5TV0gxTEN5a0xFRWpP?=
 =?gb2312?B?OC9TUDNSTmpILzlTV0xQeEpVcWdMQ2Z5eGlKTVRvRWhLUVJHNExiUE1seTdn?=
 =?gb2312?B?VDEyclFWK0lvWmwvOWZ2V1orNGl2dDVyMFdFbmZISjhrYnBjZ1lpV202cnk1?=
 =?gb2312?B?Wk9FVHJabnBOdjNiMDBPRFp4U1NtcW0xVXFrRDFDcHg5b1dwN3J0NHpBK3Rm?=
 =?gb2312?B?bitUcVo1NWFxNkRkRExvbkJPWUh0alZTcml6MEc2MnRRQUlGNGZpMkJHMWp3?=
 =?gb2312?B?ZlprOWlzYWdQVkIxZlMyY2M0MklGNTBSNTM5eno4TlVqMm41V2xLQjRiMWZ2?=
 =?gb2312?B?QzNKbGxvTnV1ck81V3lzZURHYmFZNjhyK3JrUG1kT29sUVBxVkNUYVVMeXAy?=
 =?gb2312?B?cllETjVxSm1qOEtpQXBMU1BGSUFQY2h0WmdkejBPTWtqeWk2MnRRcTJReG1k?=
 =?gb2312?B?YzFlVk03R0ZKSjZvNDY4U0YxSDhibi9nb211dWhmR2pzTkhaTnNXMXArdFA0?=
 =?gb2312?B?dDdjeERRMTdrTlQzblVROGdSYzZEd0wrRGJmT1duS2IwVlY0NStEZTRXcEs5?=
 =?gb2312?B?QmJYMkhKL202cXp4OS9nc0ZTQ2xpQVNlN0lNd29OMjRlSDRjV2ZuSVl6bUxl?=
 =?gb2312?B?a1Q4YlVzUXlEZjRyb2hJU09hZ2NzTjd6NGxNK0hVa2svM1lNZzNQZVpYd3Bo?=
 =?gb2312?B?M0M3dVEyVkt6UFU0eUJDSWRSR1VVSUxXanhzYm4wUnYvaXJPOElIUW05UGs5?=
 =?gb2312?B?aEFpbkNDbDRzNERPYlBuT1Jxbk54Zk4yditNVDQwY3paUTBWZTdmZEVITEc3?=
 =?gb2312?B?WEhxTWRWNUhYT1NiSUx2WEpjdCtqcXFxMjR5NnI0ekJjTSsrMXUvQUJ1WW4x?=
 =?gb2312?B?WWlpb25ab2ZnSXBLQ1pWU2UwenhlRGx3Z1Z5cFhIT3poVkdscGtUNlNPZ21K?=
 =?gb2312?B?NHd4YlBMSEhpMThJWU9PZXVyZGNFeXpzalN0UDVVc1NveGFldTFiQnZBMkRD?=
 =?gb2312?B?b3Q1dmJ5NStqOG5XTCs2R1NyclVadHZ4NHdUdlBjSG9oVEVKcXJhU3NPTWVk?=
 =?gb2312?B?ZVN0YUNMSFQ5NG5JcVMyTURUWVlFMjQ1MGoydTBmRHozT2MvWDNiZFhJbE1t?=
 =?gb2312?B?SlhDclphbjJpemczWGJ3bmRMVWNHR3lRUUlxRHp2eTBmNDNNWlZMS3E4NkFE?=
 =?gb2312?B?WjFyK08vYy85SEZNbVR4Y3NDSEQwT1IvR3ZKMkRUaDNobHdyVHhCcVYvNk03?=
 =?gb2312?B?a0hpUUg2c1Zib3dKQkN3QnkrWnlWTFBLSktDR211SDgyZmE1MDFydnMxZHN2?=
 =?gb2312?B?c1RkUC94UG5PTlR0L2lWUEtpUmJ1bjJ4VUFNK2V5RlBlOHpVVDNyRHZoenZX?=
 =?gb2312?B?dnVaV2NXTUpvRmFZTktvR0VTa1ZCbHlyVnhxclVGcUQ5YWJGV0ljZi91bVRk?=
 =?gb2312?B?RUZyTE8zQ201SUREa09RUkcydmk4SXhwMld4WjRxR0NHRGVsb0hnd1pvLzBJ?=
 =?gb2312?B?YXB2bHIrV011MEZ1SUxON0ZHY0hidVBPY1JUbmFjcWM0bmVINUttMXplL2RU?=
 =?gb2312?B?eGFENUNMejVUVU14ZnhtekxzcU5ZL29JaTB5eUNhZFkvQW9hazZPN3dDcWFH?=
 =?gb2312?B?V2JMbHVDQjhKckxXbXNxME1pOEJTSlU4amJtWUlHLzNJTnc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?Q2V5bkk3bS9SSGtJdWZBSVBENEpUM3h1dHl2OTdrL0NuTmZYOVNFUDhKeXov?=
 =?gb2312?B?Qm1FaXVvUUVMMXFzbUlzclhiSlZLOEgvUlM0dXlsQWRZM212cDQzRVlKMGhJ?=
 =?gb2312?B?SFhoTmFValIyOERacnR2cktzNklyYVlBU1VveG1mYUJ5NHltV3RhR0tCUUt6?=
 =?gb2312?B?MmlSZFNPQ3FSTDJ2NmZwaFZQaGYvVkpYM1FPSm5TbHFpQ2lzM3RvSjVYUWRQ?=
 =?gb2312?B?VE92enpyWVIxaWtOQ2cwMmYyc2V2cnZYSVNieUVneFpIQzdXWUNqbFJyZytw?=
 =?gb2312?B?NXBNTWFFR1VoM3lnUHhpZ2ZmejQ3OWQ4cWFObzhaeWtHYU1xTlltWklBNWoz?=
 =?gb2312?B?SGZFVmNsUVBNVEZtOXlXL3U4ci9vdlRmYm5EN2F4TlFQSDdJeVNUYUt2emhR?=
 =?gb2312?B?ai9YUzBTTk5saVEvYnAvSklmeUFyRnFwSWRTaHhlamd6cWRqVDhjcTdMREhS?=
 =?gb2312?B?ZHZDbUthWkdzc0xGbkh6enJUaW10aVB1UWVWWHhNcXVqRWFYNUZ0dVYyMEVT?=
 =?gb2312?B?UTZZYlRxYm1vYytlMHNGaUlQMGwzT0dJWFV0VDdPelowdndnUStnWWdhak1H?=
 =?gb2312?B?LzNvcWJqOTNjSlpNRGExN3B2R1BSNDhTaVZxOUVZMWhmMHFDei9uWm1RbDBF?=
 =?gb2312?B?c05qOXUxUkZ6K0RmODJtOXcyYlpyMm9sVVVOY1h1bmJMa1B2SkE2YVlJUEJM?=
 =?gb2312?B?ZmZ5cmIyL292OERET1kxcVdEcW1LbStvNSszU3NnUVRmUkh4OXAxOXV0aDdi?=
 =?gb2312?B?K3doNnhpSStLYWNxQks5TGc5RFZVZmZ0NkpkZkZTUTBPUU5XOGZ1Q2VXM1k3?=
 =?gb2312?B?MHBIelJ3Sm56WDBFRVYzRCs0ajZtMlF1c29qKytwdDZTa0h6SkVjMzZMWEd0?=
 =?gb2312?B?KzlPTU9kbWY2TWd1RENaNmdmYVpldmo0Vkg5bHBXRnU5b29wd2JvZ1FZUmJw?=
 =?gb2312?B?U0wzd0RLbnpEUG5MRitMbmdvYmJqMDF3S2lhdWQ1QTBISGdwR0VRY3hlQ2xL?=
 =?gb2312?B?cG1QV2JqMG1vclhieEFLYkMvYS9RVGxiVGNDNk80cXNUK2ZPajBGa1YzdzFz?=
 =?gb2312?B?Wmd3RnB6L1oxSjdSSTN2YUlrUW1WcDROOXdmYTNlRHlNRHdsNFlKUVFLRjFB?=
 =?gb2312?B?WEFDL3RrSDZ4cDIzKzQvWU1SMVpBVnpCck5ZSW04MklNUlltcU1YUUx6V1Vk?=
 =?gb2312?B?TTlrV2Nrang1Z0pEdFAzbWlwbVRaSEp0WUN0YnAwa0tZMWRmU1l3enpFaThN?=
 =?gb2312?B?bGMweDNPanBjN2huY2hGMkt0UmU2dmwxNEZ1WEdRc2VTWVcvY05CbHlIdWds?=
 =?gb2312?B?WXB0U1lrRFdMYityNzJudXlmeTM5TG53bU80MGNMOFlqV3ZjK2daNE1iR3Yv?=
 =?gb2312?B?RlVRZFVmV0FKUFlXZTQzcmxpQXZJTzFBZVVTcmNjM2xseUtuOVVSbVVVaGFx?=
 =?gb2312?B?Smc5QldaeHh1ZG9BRVRuNkZKb2JPbHZiVG85ZWpJSktvSDdaQTE0QnZtU3Q3?=
 =?gb2312?B?b2pzK3Y1MTZ2aDVhRjRUeDhOZ3F3ZzkyWTVGaGJiTEV4N3NvNC9HQlZpSGpo?=
 =?gb2312?B?ajNkdGVzUDNESGlibUVWRlJGZ2xhNG5oMHdBOGRKaW0zQzBWUGgxVHdERk1W?=
 =?gb2312?B?azdPRHJXWU53cHJDVHJ2akRMRG1ESUZqQTNZOVpGUlpwbE9MUm56dWJPczhU?=
 =?gb2312?B?N1BsQzVSZHpYMXhIRW4ybW04ZWs3MHMxeWIraWJzTXZLLzBVUUF1b0FvNTE0?=
 =?gb2312?B?cGlxeW41OXZhMDJYK055MzVpemI1OGYxdW5UVU9DQTVWbXFoVk5hc2EwbTVN?=
 =?gb2312?B?WnM2ekozajNCUXNHZSs0UnB4ZWdQYnBneTFWNm5MYlBvYjM5SU1MOXJnUkVU?=
 =?gb2312?B?ZU1zb1dRVGEwVDliRk9yQUMrSS9JekI3WHMzS0YwYU41d0dBaXhtUThEdkpS?=
 =?gb2312?B?S2tFeFJaUzhNbGgyblpjWWVQLzI0WVg1cUdRUVRjaExHcjBNeHltTUVoaUFv?=
 =?gb2312?B?VWZISFA1K014MW9wM2JuRTluWUNXZVFaOTJaT3o0b1ZhQXpmYnY5bU9sa2hh?=
 =?gb2312?B?enNhbm91c2hmVFFoaEhmd0I3T1VJbTI2MC9kSHVZTGptU1YvL3REV0FJVmx1?=
 =?gb2312?Q?+fT2mrhuiZN28TJOrlnNvNLMw?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0919951-970d-45da-6aa4-08dd0d162b62
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2024 05:58:22.4427
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2oyhSKYPf5vKOSsaOkiipnIUoffAld/3tbQiaBNs1ahl5HAY2BpIf8eWkI+Wk5HGUy14fKg3wWfpiEdC8l8R0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR02MB6550

T24gU3VuLCAyNCBOb3YgMjAyNCAyMTowMDo1MiAtMDgwMCwgQ2hyaXN0b3BoIEhlbGx3aWcgd3Jv
dGU6DQo+IE9uIE1vbiwgTm92IDI1LCAyMDI0IGF0IDExOjIyOjUxQU0gKzA4MDAsIExvbmdQaW5n
IFdlaSB3cm90ZToNCj4gPiBXaGVuIGRtIGxldmVsIHN1Ym1pdCBhIGJpbyB3aXRoIGJpX3NpemUg
PiBtYXhfc2VjdG9yc19rYiBvZiBsb3dlciBkZXZpY2UsDQo+ID4gYmxrX21xX3N1Ym1pdF9iaW8g
d2lsbCBzcGxpdCBpdCBpbnRvIHNldmVyYWwgb25lcyB3aXRoIGxpbWl0ZWQgYmlfc2l6ZS4NCj4g
PiBJdCBtYXkgYmUgYSBwb3RlbnRpYWwgdW5vcmRlcmVkIGlzc3VlIGFzIGl0IGJyZWFrcyB0aGUg
WldMIGRlc2lnbiBpbiBkbQ0KPiA+IG9uIDYuNi4NCj4gDQo+IFdoYXQgaXMgWldMPyAgQW5kIHdo
eSBtZW50aW9uIDYuNj8gIEFuZCB3aHkgZG8geW91IGNhcmUgYWJvdXQgb3JkZXJpbmc/DQpaV0wg
aXMgWm9uZS1Xcml0ZS1Mb2NraW5nIGFuZCBpdCB3YXMgcmVwbGFjZWQgYnkgWm9uZS1Xcml0ZS1Q
bHVnZ2luZyBvbiA2LjEyLg0KDQo+IFRoZXJlIGlzIG5vIHJlYWwgb3JkZXJpbmcgcmVxdWlyZW1l
bnQgaW4gdGhlIGJsb2NrIGxheWVyLg0KQWNjb3JkaW5nIHRvIHRoZSBkZXNpZ24gY29uc3RyYWlu
dHMgb2Ygem9uZWQgZGV2aWNlLCB3cml0ZSByZXF1ZXN0cyBpbiB0aGUgc2FtZQ0Kem9uZSBtdXN0
IGJlIGRpc3BhdGNoZWQgaW4gb3JkZXIgb2YgYWRkcmVzcyBhbmQgdGhlcmUgY2FuIGJlIG5vIGhv
bGVzIGluIHRoZSBtaWRkbGUNCg==
