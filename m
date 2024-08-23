Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2088.outbound.protection.outlook.com [40.107.215.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAB813B5A1
	for <dm-devel@lists.linux.dev>; Fri, 23 Aug 2024 09:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.215.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724404714; cv=fail; b=Eyjjyamt9/6DPzJTRm5nD0x1bCeLMZBztzHXfoow4tpmsa0tcxyEHpcOWNH+WifpB249QlZGznLd+DtVkykDqGnHNZjK47ttMk+RPWUc8gkVyUlo4fB8tjG8GBazk7Z3z5zOMC9K9DpoQFpeEpzwXMBxLuAZHyMh6+iUBtOt7J0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724404714; c=relaxed/simple;
	bh=aiaQawtZARk47TpW1hXOX8xyXl4cuAvgkitMSrJ1zCE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rddFx+0wKBPGYahlREIxGGwTzRZqFgYZFh2qDwB9ViHVGIloHZFvIlO0QutMjIc8Lhk3ROHgbOhNsiwwMfQXxbyfhaQyaLQgxzLHPUGLxbf+ffIX6FnYjOb5XgCkJmAaBbsJjOQuwqHJvWbUodBMvnrAlI8QDanPPG+kAtqWmas=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=UY3aiGk3; arc=fail smtp.client-ip=40.107.215.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="UY3aiGk3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F9HG0Bj6e/1yqHP+w/47YJFa0tMkkiKEyltk8u+kwCx2zeDJ501UzodS23p4MacfUeF8RRS2tCJqBiQV3zXtolOFeiv4pjLN+J4aJQObR2MlNCDUBJfaW6RkNXZz2KMFk11d9Way+uqDGB1wiAm5rpDF5M6tau++7F2TOzbQI8A39QGz8oHDejMf+O5OuW0jbAo+PSYkXwaG4gFfQHG8k35Ut2wydoznpSQJyk+c2CDJ9WxSJWSCM9Z4dO17zID6w8qqHP0F+Jag+4XS6rM7ocHO906/SxyRTU8jlOKR9+o0rogTwdeJjFhXFiIHN8yigEseuf99TR0Mis1yqQqazw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aiaQawtZARk47TpW1hXOX8xyXl4cuAvgkitMSrJ1zCE=;
 b=dWJFkERg6i+QhnC9yWVHESeqvs92hfhuqBXOl1izDnZjU6H1V2tEDOETkxDnNGH+JzKNjQbmMPcTPe+I53L46X7wuRY1/f1WLewD7KNDLhNRnDWwgGULsqwJuCGM1v68VMUGpZ8I7jcelXDDPp4o8ub4E0xkuRdbP/qbg/7KrD2KpfCtublmGS2ny7ZjX4XwQ8RIIzt5bFZPwQxdja0HkI2Enra1TpAcAFOSrAY5EYPb2tepvnS1ittJW4Q1lO7zm8jdHV2IGMRkWXwD/h5EQCi7Bso+f6s3adbVSztzv4plmOMNlXP3JDtw7+ehVRd1SbA9/9Nd6JplNxNvE57A7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aiaQawtZARk47TpW1hXOX8xyXl4cuAvgkitMSrJ1zCE=;
 b=UY3aiGk3ZUGsvbuMURuyu1iDf44lQAF4bxdO9+dx1CiFXdbmbi8tNNhescHBwIHpxC9Jmr4i9n7xOml5qZJr4FuC7spm6XBV5R5jCngvt/k/HkfRIo//y+2U17P3IBnr+8/COHyB9TfSlQwDfUyoTrLCfaSyT/IkFPkjEMJ9wbKWcTmSevXs2d01HBha7K4XqasVua4jo7lreqU7epahinl/3XuW09z9PNTMKTrgugNNyWv5mOkd/B5s7fYNsp5+Fnd+LzGeobdPj4ynzIfRaNLXDsH3tw75CoZJCSj0nZmiGWsC/cePVO58pspEIBQtK0QH2MP2xr+9kvsXCT0uJA==
Received: from KL1PR0601MB5487.apcprd06.prod.outlook.com
 (2603:1096:820:bf::14) by OSQPR06MB7183.apcprd06.prod.outlook.com
 (2603:1096:604:295::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25; Fri, 23 Aug
 2024 09:18:25 +0000
Received: from KL1PR0601MB5487.apcprd06.prod.outlook.com
 ([fe80::2129:59e5:6c67:311f]) by KL1PR0601MB5487.apcprd06.prod.outlook.com
 ([fe80::2129:59e5:6c67:311f%7]) with mapi id 15.20.7897.014; Fri, 23 Aug 2024
 09:18:25 +0000
From: =?utf-8?B?6ZmI546J5Yeh?= <chenyufan@vivo.com>
To: Mikulas Patocka <mpatocka@redhat.com>, =?utf-8?B?6ZmI546J5Yeh?=
	<chenyufan@vivo.com>
CC: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	opensource.kernel <opensource.kernel@vivo.com>
Subject: Re: [PATCH v1] Device-mapper(LVM): Convert to use time_after_eq macro
Thread-Topic: [PATCH v1] Device-mapper(LVM): Convert to use time_after_eq
 macro
Thread-Index: AQHa9DZXzFQTUSW+HE6rB9nMJbVcb7Izg2oAgAEO+YA=
Date: Fri, 23 Aug 2024 09:18:25 +0000
Message-ID: <bc1025c5-fa3c-4a49-9d91-d2d90e7423b4@vivo.com>
References: <20240822015416.3627-1-chenyufan@vivo.com>
 <1abae895-7fb4-0342-21b9-1fd8e085dc9a@redhat.com>
In-Reply-To: <1abae895-7fb4-0342-21b9-1fd8e085dc9a@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: KL1PR0601MB5487:EE_|OSQPR06MB7183:EE_
x-ms-office365-filtering-correlation-id: 7d9c6e19-c4d2-4d6d-717b-08dcc3548b0e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?YUwrdHNobzg5eGp1U0NISnFWY2dOdE1uWWhIUmtYSHc3NjVQRmVtOWxDVFBU?=
 =?utf-8?B?ZDFSRm90WHdYVmpxN1lZQURHdVgzR0dzQ2FjZ1ZxazMvUFJKRW5XenkvdXlC?=
 =?utf-8?B?RlloTGtNTEN1emZBOUxuVGhsbUFYSWdnVXNDOVJKanFsMEVvcGxPQlM2NmZY?=
 =?utf-8?B?QWticlhFeFBoLzBBMXhjWTZ5SjkyYmpJRk5mQlFwdFJsYmZ5cWJ6QkwrdUZL?=
 =?utf-8?B?RkorTitQVzBMTzd6RS9uNXA2WjJBV1lZTjVVNUQ2QVM5NUZ5RXZSRmQ4RkN3?=
 =?utf-8?B?QUtEQ1FSQ3FBbXk1UWRlN2VBdXVDaU1nMCtRRUU4Zm90bHRDbkxQdU8zYXNI?=
 =?utf-8?B?Y0UyRnhXWFl3emZpclRUN2ZkaTVVVjR4UmFaTFR6ZmMvWGJmMEVCTWN2dG1Y?=
 =?utf-8?B?bllIZGF1WGc3UlpxK2JjQ1VQTll1cFlBVkpEdWQwU1AzU1NyOU5vZkFkNFVE?=
 =?utf-8?B?alMvQ0c4Q1JQWVhJY0RJdStPMFV5R05QNHVaVHZuWFIxQUc3eDRnNk9lNFlP?=
 =?utf-8?B?alpDOWlSb2ExbnEzdFpwQU1kcmMzdU9mbE15UmNHLzk4Q2c0TFhJcG9FQ05x?=
 =?utf-8?B?NmU2Q2NOTkFQejVjQXNiRDNwSVJWc3o5K0E4ODJkamZ4cHpCOG4xbWgrMGRl?=
 =?utf-8?B?eU1CeUk2UWNJZHlWcFFSUy91Z3lQVUNtaENRT016WHcyT3lSRTlNRTlYVklC?=
 =?utf-8?B?ZStkZzB3MHJmRU1WOU9ZYzhyVXBYQkh4dGZxYURNM2ZqOGR1REtOMHFDR1Vy?=
 =?utf-8?B?NFV5RzhNbkpsdDhVOHFRRHR3dkpLMFVVbUYrVEFtWGpKNUQzeXlFcGliRFFM?=
 =?utf-8?B?cjRpblUyVW9vdUUwM000d2xIdjVSR3Nrd3N0VmQxdEdCV01NOFliSUk5c1k2?=
 =?utf-8?B?MEFFeVVleEtDYU1kU0hmY1NwaWJtdnhscDhKRUxnUm4ySHI0S3pMbWw0REtK?=
 =?utf-8?B?bnRVblFJalJIbFFvQWRJbnZQT3NPN3FyaGR3V1NEeTltbEpHZzFva3NXbEJT?=
 =?utf-8?B?UWdSdVl1R0dSalRDNGdzbW5jNlFvTmpzUTNubUR2WGJJaU5GQkNDY3dLVmkw?=
 =?utf-8?B?Ynd5ODJBTjB0bnNDSTlyWDAydVZOZWo2dGRmRE05amFQK1YzT2pmQUl6RTBY?=
 =?utf-8?B?RUtyWW04aXRwQlh0cW53TFdoM3pBU29CNEIvRjNjNStGb25MNjk3akFqVVRH?=
 =?utf-8?B?NWhxSllTUzYwc3YybFlzNkZhR1hJU1lqRkJHREtBdGkxVEc0ZDBKZ1BONDhl?=
 =?utf-8?B?RUlwRm1WQTgyMGdNN0xHL280UFErNkU0bHpybjF4ZmVja3RHd1JNSVVlbG1F?=
 =?utf-8?B?MmRaZVkvUGh5dzdkL2lCSmcwTmJhVjNlNU1tRGZ2K25TZ3QwRzJkUkkvYlA0?=
 =?utf-8?B?RVA4cEV2WGpCZElSYzhSUnhrekdWOTNYMFcrM1pGajRWRnZSaFlQalB3cWJs?=
 =?utf-8?B?eTBhNW1KNWFlbmFHQitGOVNuQVBiMEpiUUx4WmE2Wnk5YWlwTG5Dc1c3L3p3?=
 =?utf-8?B?b3gxREViY1UyM0VxSkhOVEhkdnBPdkxsdVlIQVJ0cEdBeHlUWjJtSVdwUEQw?=
 =?utf-8?B?aHhkaVZ5WVBTM1lOT09WTm5SUVpJOTR3cmNvV1kwWWhBSEd5ekZJbUVIZlVT?=
 =?utf-8?B?c1dxc3NqcVFLZHRXeUFwUGVLb0p6MkJYOXNRbE5GeFNCRDhpcU1EUTVXTERa?=
 =?utf-8?B?RXY2SjNWVG5sR1VyWktrMFg3UGlLc0FDUmp1VWlhdE0ybUlUb29rY3BPZUpm?=
 =?utf-8?B?bVF5ZXg3Qm13czJBUnJQZnROQTFlWmZhMkVDaHBrWmd4VkxSRkpZRHphZWUx?=
 =?utf-8?B?cVFSc3RXQVh2ZUkrQitINENCT2Q3aUQ0cGpsUzVsQmlyMTU5blg2SmlPMk5r?=
 =?utf-8?B?aE5RQ2ZTR2lXZVpaM3k4WE9rcEo5NUN3ZEh5VmttOTFpZFE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR0601MB5487.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cmo1djM3TnVKZHFQNjJaNkFoRUdDeVd4QnpQSmdwaTFtSXM4UDRGc0lJeHlL?=
 =?utf-8?B?WktmTjNEZDRUZ1JPMTkza2pXZ0wxTnhHM0ZBaEVmSW5iOE92VllBa2o4MXlu?=
 =?utf-8?B?TFFSbkJpWG1sTFRsSmpGOFhySjFyM3NVUWg4OVFkaUR1QzE1NFMrc21uNTNs?=
 =?utf-8?B?ZWdvSW85aHZ0aTk4NEU3Uyt2RytvU1pzdVZsWS90TTVrRElBZHFmSElEMUpO?=
 =?utf-8?B?TzhNZGFCRDcrSFNhMFFzdTJoVmpNU2Qydmg1UWZLamYyZmdtbGFQVm5IVVRO?=
 =?utf-8?B?d3dlTytWSmt5cS9udkJDSVdxcXNWNEpocU5KZTJSdUE4UUV2dlFBeE55TFRo?=
 =?utf-8?B?YThlSm9Tc3FxVFprZkgvZk44U242bG1YeE5iMVR0NnFkbDdTNXhnM1BEZE1H?=
 =?utf-8?B?STd3Q2VNYWNTdk12VWlnWDB0QlN0cEtxdkM2WmROUDhjN25ONlFXRmZtT3hH?=
 =?utf-8?B?TkdIVWZuanMycjZmVFY2cytPNVVEY3JiQXVHMmdSRWZQbXpLUHhGcHdUQ1hE?=
 =?utf-8?B?SWxISm5VV28xZjhlLzFrVDVBb3FOS2JwZDU3WTZ2ZmszalRvUUVoNHV0RVcv?=
 =?utf-8?B?WmQzcnUrUkxLek8yOWpHbkFEeGtOck4rdm1UZGkyYXJOMjNHOWNoUS9mL0cw?=
 =?utf-8?B?eE1FWGRrYnBld1lQZWJyOHhGNWoxZHdZMGRrYzdOZ0pEUjZOdi9vazUvTXc3?=
 =?utf-8?B?V05DY29DdFIwY0JDU2U4SGIrWXF1ZkY2RnI1WjQ0RHU4Ny9QbkJZYW5DbHNT?=
 =?utf-8?B?dythbnhFTEo1Z2Z5cmRjNlVXR0lGNHgxKzNmLytqYzlOQTVuem5qa21mSURn?=
 =?utf-8?B?SC9MbmhnZWFtRGRUbkZYbCtPZ2JMNmJHU25FU2RVbFk3b2lWdzhDQlNRYkZv?=
 =?utf-8?B?cnJ6bnB6WTBNQm1qY3NmcWxkdm1lYWVMUzZERGx3c1g5VjIwazZPNFR5b054?=
 =?utf-8?B?eHpQeTlKSVBXeDhZNFljT211KzdFcjBmV2p4K3U4blVBaU1yZGl2Y0FtNkNm?=
 =?utf-8?B?djBGYnJQcUoyOHZnRUZWc2lGWkFGZ3h1clhDSFMwYThXa1gwQktxZFR4eDQ5?=
 =?utf-8?B?TDU0UHlubUpzTmswS2luNjRhd21QR1BpT25ONTN5SVdjNWZla2pna3ZFTDIw?=
 =?utf-8?B?ZE00bmN1RnFiWVMzL01yOERWdXhocUVQNktIRzBjYklkMndJNTNNZEdubnFu?=
 =?utf-8?B?VS9xOVA2MDJ3ZE1RTEJWNllUMkU4WmN4NVg0NzV2cU5pUy9aVWNlSW1UQTQx?=
 =?utf-8?B?ZTNuaHI1YlpjTDFiZHBOMWhOVURuNXlXMWkzR0syQmNodWEzRXBqMzU0ZnBE?=
 =?utf-8?B?WTVaOGZsblVJTVlmNDBjeEpyV25uT1ZBVUFnSmZyUmxsajJKcFloWHFKZjk4?=
 =?utf-8?B?c09JM29WQnRDeDNxN3pOb0hxYWxraXdsbFNhMy93QmJ6bUxmVmNRbDhQT3lY?=
 =?utf-8?B?cFMwRkRNeklGdHN1UU5FU01aMnFLaUdpdllLYm5ZM3daNDJveWhqV3pKbnV1?=
 =?utf-8?B?d2hNdDJZTGFPWENOUWF1ZEJNNENENFkwT2pFSUpRU1dYdFFNcWcwSlQxS1Iv?=
 =?utf-8?B?RllOOWlwNW1GSWdqQmtuT0RLUU1GUlR5Mi9KV1dHeFd4eVA2TEs3M2lEOWYv?=
 =?utf-8?B?S2JsWnNPM1JOVXdsMmlBcGFTc1BDMTB2Wk9KTXFjMHErUmhLV1ZsenMrSmtD?=
 =?utf-8?B?SVdocjRORGRETWFtRTZUOENxejhFL3U4UEFZQ3BGRk1oYjhzNHN1N3p5QnF3?=
 =?utf-8?B?cXN2OVh3SGR2V0o5T2E0d0dnSW1HSDdqL3p5blAxaHdQQVB1WVIyRVBLSDBK?=
 =?utf-8?B?RWtZbWFKM1N6MDVpS3U0YUVubWh3aXNwQU51SEo1dWJ5UU94a3hsbkFubkVR?=
 =?utf-8?B?czZnVUE5Y09Hd0p5VWJzRVpIak9MZXl6ajUxM0tsUm9BejRoV2xTWDFPUkFO?=
 =?utf-8?B?R1JETlJhYk05aXBpaW1sdU5ZMHlIbGczQ2Z2clpsZ1QxUDZ3NHhGdzlxcU5t?=
 =?utf-8?B?UDJRNE5rY2tVWGJnaGdJNmU1SWhQS2hKMmJOM0hXa3dFTGozOTNsSFh5UjJZ?=
 =?utf-8?B?RCtvM2RWaHAzdkZWZkNCODJTUmQ2WFZ6eEU2OGswZmwzMnV1UDN0cGYva1Jm?=
 =?utf-8?Q?mQlU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <26985A7DC237D748BA5BD76E8E03B9AF@apcprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1PR0601MB5487.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d9c6e19-c4d2-4d6d-717b-08dcc3548b0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2024 09:18:25.6894
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oZNvnlJsHUaSjR2InQjusKlpHnBVuwtl3j6QQF5piJNOxxr5RcMod6XfFKvrpDE78DO1sHEtoeUhiqBiQRldHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR06MB7183

5ZyoIDIwMjQvOC8yMyAxOjA4LCBNaWt1bGFzIFBhdG9ja2Eg5YaZ6YGTOg0KPg0KPiBPbiBUaHUs
IDIyIEF1ZyAyMDI0LCBDaGVuIFl1ZmFuIHdyb3RlOg0KPg0KPj4gVXNlIHRpbWVfYWZ0ZXJfZXEg
bWFjcm8gaW5zdGVhZCBvZiBvcGVuaW5nIGl0IGZvciByZWFkYWJpbGl0eS4NCj4+DQo+PiBTaWdu
ZWQtb2ZmLWJ5OiBDaGVuIFl1ZmFuIDxjaGVueXVmYW5Adml2by5jb20+DQo+PiAtLS0NCj4+ICAg
ZHJpdmVycy9tZC9kbS13cml0ZWNhY2hlLmMgfCA1ICsrKy0tDQo+PiAgIDEgZmlsZSBjaGFuZ2Vk
LCAzIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbWQvZG0td3JpdGVjYWNoZS5jIGIvZHJpdmVycy9tZC9kbS13cml0ZWNhY2hlLmMNCj4+
IGluZGV4IDdjZTg4NDdiMy4uNTQ4ZDRkMzdlIDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy9tZC9k
bS13cml0ZWNhY2hlLmMNCj4+ICsrKyBiL2RyaXZlcnMvbWQvZG0td3JpdGVjYWNoZS5jDQo+PiBA
QCAtMTYsNiArMTYsNyBAQA0KPj4gICAjaW5jbHVkZSA8bGludXgvcGZuX3QuaD4NCj4+ICAgI2lu
Y2x1ZGUgPGxpbnV4L2xpYm52ZGltbS5oPg0KPj4gICAjaW5jbHVkZSA8bGludXgvZGVsYXkuaD4N
Cj4+ICsjaW5jbHVkZSA8bGludXgvamlmZmllcy5oPg0KPj4gICAjaW5jbHVkZSAiZG0taW8tdHJh
Y2tlci5oIg0KPj4gICANCj4+ICAgI2RlZmluZSBETV9NU0dfUFJFRklYICJ3cml0ZWNhY2hlIg0K
Pj4gQEAgLTE5OTQsOCArMTk5NSw4IEBAIHN0YXRpYyB2b2lkIHdyaXRlY2FjaGVfd3JpdGViYWNr
KHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykNCj4+ICAgCXdoaWxlICghbGlzdF9lbXB0eSgmd2Mt
PmxydSkgJiYNCj4+ICAgCSAgICAgICAod2MtPndyaXRlYmFja19hbGwgfHwNCj4+ICAgCQl3Yy0+
ZnJlZWxpc3Rfc2l6ZSArIHdjLT53cml0ZWJhY2tfc2l6ZSA8PSB3Yy0+ZnJlZWxpc3RfbG93X3dh
dGVybWFyayB8fA0KPj4gLQkJKGppZmZpZXMgLSBjb250YWluZXJfb2Yod2MtPmxydS5wcmV2LCBz
dHJ1Y3Qgd2NfZW50cnksIGxydSktPmFnZSA+PQ0KPj4gLQkJIHdjLT5tYXhfYWdlIC0gd2MtPm1h
eF9hZ2UgLyBNQVhfQUdFX0RJVikpKSB7DQo+PiArCQkodGltZV9hZnRlcl9lcShqaWZmaWVzLCBj
b250YWluZXJfb2Yod2MtPmxydS5wcmV2LCBzdHJ1Y3Qgd2NfZW50cnksIGxydSktPmFnZSArDQo+
PiArCQkgKHdjLT5tYXhfYWdlIC0gd2MtPm1heF9hZ2UgLyBNQVhfQUdFX0RJVikpKSkpIHsNCj4+
ICAgDQo+PiAgIAkJbl93YWxrZWQrKzsNCj4+ICAgCQlpZiAodW5saWtlbHkobl93YWxrZWQgPiBX
UklURUJBQ0tfTEFURU5DWSkgJiYNCj4+IC0tIA0KPj4gMi4zOS4wDQo+IEknbSBub3Qgc3VyZSBh
Ym91dCB0aGlzLiBUaGUgb2xkIGFuZCBuZXcgY29kZSBpcyBub3QgcmVhbGx5IGVxdWl2YWxlbnQu
DQo+DQo+IE1pa3VsYXMNCg0KVGhlIGNvZGUgaGVyZSBpcyBzdXNjZXB0aWJsZSB0byBvdmVyZmxv
dyBpc3N1ZXMsIGFuZCB0aGUgdGltZV8qKCkgbWFjcm9zIA0KY2FuIGhhbmRsZSB0aGlzLg0KDQpD
aGVuDQo+DQoNCg==
