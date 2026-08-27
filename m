Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11023105.outbound.protection.outlook.com [40.107.162.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EF049551D
	for <dm-devel@lists.linux.dev>; Thu, 27 Aug 2026 19:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.105
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787858319; cv=fail; b=bobsp4pySky5rn1QJAZMrvFroWglcm9TyziEupktcqOehGVOfeD/SGVM4tJ9p0I9pw2pxWdFE8pp8Y07kdZKzTKiYLHwwoWl8b1n3OBy62s5ouCbR+mOmQMckzyTnwQfUikBA+eo1NcqTZE1lY4GfKdTBWW9ySpyaX+3CeKsMvo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787858319; c=relaxed/simple;
	bh=/GLIGR7tHtKE3zd/06xIbjf+cRTleWu1jqKwsXDLhNw=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=SPdLBNr7T2+HZR2pG3Qln6jzxPuzR48ES2J4GqTVd93TRRAuine4Vsbc/8qUPEPRD26uUiwAanyAbH4hO9H9L7qOHFlhuMrk9QYZEWr+71hqAZ7iQI9xvm1eJ8xFYgVjjc5dKdkNxQscww+2S5b6PmbIpgf/yI+i9lCbfFw6IAU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kuleuven.be; spf=pass smtp.mailfrom=kuleuven.be; dkim=pass (1024-bit key) header.d=kuleuven.be header.i=@kuleuven.be header.b=Np4vaEOo; arc=fail smtp.client-ip=40.107.162.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kuleuven.be
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kuleuven.be
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kuleuven.be header.i=@kuleuven.be header.b="Np4vaEOo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wmf/gHvtzlLlcW4fqjWW78C9WgCQIg22Y3Zz+3ZmyG4wrfOO3n13sF3xPFPwD2ws5SZlf1AyJnm1qrIK42b/V/5RUagvX5NTpQ+d6WLR2jqcsC8LxKerufhqboGRnsdC++uJiKJXJMKCyit4R3r4xOFx/ObnamJIuRBGYLDeVndsalpQzBL5wlFrD050qZF/y1s9aUCoEI8KhtXzVHCKtBx06u7hfZqQIEk0HuorvCjz6Xky4d8/lq1fFcFaP9Ap2Yf6AVuhrvEU97Z4WcAeg2F13BWHmYzsYwToItUFc6m2ztmR7FJVCKg4L3YfcjLmL/7xO/y5B2LmzA6M2YGBTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/GLIGR7tHtKE3zd/06xIbjf+cRTleWu1jqKwsXDLhNw=;
 b=OotXNQycPUdlHpk3sGNhnLj7dCAy+nFHXQGonj9MCx8SwmSGEuie4+M0PLLXglY4G1amI1h814ZnI25RWf+xj6mxlvQmMBENvaHta6d6DYEVAIyFmd1PAvC4GyAZCtXDBLHgzTF8RqW0YK2b0Xo/0AU6DKX9V5os7DLDZnlnCXaB0xc8NlbblNT9VTsftK6UitG5w5CE38i0m/+QpJwwHR/TQ11QUcmUBdQFU0QeLeaGm35NyZAGSyyXPRkn40eiTc3GxhFyevotINDV8s3G1QVOTEYfsOGyRH5IEuIR5U4Z+6euspE2SqiUqMOKWXeIUl27lXBNT8zL0nSJU1oYdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kuleuven.be; dmarc=pass action=none header.from=kuleuven.be;
 dkim=pass header.d=kuleuven.be; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kuleuven.be;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/GLIGR7tHtKE3zd/06xIbjf+cRTleWu1jqKwsXDLhNw=;
 b=Np4vaEOosdsqhUemKhWuJuoXUZWSLQHcnEf1yfpUU8ZMjYGWBfM4D9JC+DYlnp84GE8+xgfXZQWdv4nA1A17ubKDI8RW6tieTplVHCgWq1TJzMPGvILJg2FtL6LtWtEbJHWRsQsgG9xniRFhBmGpHUT/itTFskk9bHj3FDcd2Ok=
Received: from AS8PR08MB8996.eurprd08.prod.outlook.com (2603:10a6:20b:5b1::13)
 by GV1PR08MB10479.eurprd08.prod.outlook.com (2603:10a6:150:16b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.7; Thu, 27 Aug
 2026 19:18:31 +0000
Received: from AS8PR08MB8996.eurprd08.prod.outlook.com
 ([fe80::ee9d:8228:404b:262c]) by AS8PR08MB8996.eurprd08.prod.outlook.com
 ([fe80::ee9d:8228:404b:262c%6]) with mapi id 15.21.0382.007; Thu, 27 Aug 2026
 19:18:30 +0000
From: Shukai Ni <shukai.ni@kuleuven.be>
To: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
CC: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, Jo Van Bulck <jo.vanbulck@kuleuven.be>
Subject: [RFC] `aes-gcm-random`: per-key invocation limit
Thread-Topic: [RFC] `aes-gcm-random`: per-key invocation limit
Thread-Index: AQHdNlh9dzLuE/sXj0GBMZeEr3u7Ig==
Date: Thu, 27 Aug 2026 19:18:30 +0000
Message-ID:
 <AS8PR08MB8996C8D4732C4AE5806F7890E8AD2@AS8PR08MB8996.eurprd08.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kuleuven.be;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR08MB8996:EE_|GV1PR08MB10479:EE_
x-ms-office365-filtering-correlation-id: 416e8049-1a38-47a7-ca9f-08df046ffadb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|786006|23010399003|366016|10067099003|18002099003|11063799006|56012099006|38070700021;
x-microsoft-antispam-message-info:
 1ZYEGsA7Hn4GhcQAHgUqYeLbJg6TAflDBfrQsdlfo54r8KtvDq8BH+qBsmm/Z5mpwEUgLOaw26xFuyaAkGpx0EBcxQxHCt+DNshaw/IHMyYn2tPUBb+mbiWwJLGrc2LIrGRbwcACtjVcmY1pZmm3ASMCVeghvyH6y+eCyX+yiKNydwdHjWZEsBM7jOyYAOCz/uLOXdB5Kn912s7XvM7V6OB2w73BhIOMyunhaNTI1XZSlxmszanPqtMNlP2yqKptA0zUSUlaBDsxAwGDxduN71RcqB4obURQBce2KP3NoCJyKsoEm9deVr65tLkTqSmtnfqcasKESDQcKGW/Pl5n5bQD8UyE1XJYMTrfc2BnwIej4g4oJXJ8e2iRARiCwzmhKE/HdXlzBFQrcDtx5/rqARo7JXHmivpnSBX2whfCGLZPon8Lih5m6MK0EsZXnesfbSJfU5M6XpyCZATrdTuMuynlNNdw1qOFPn+PL7ZrPb7nD19/VUksn4ooF4EV+o7iAzY6MZdJu5LKRlCzSW6HXKARc/6XKd0qNsS5be7CDLMI5fMAQ10r5bX0gjJa1KFs3bwpRJCYf4TiKttJDCo6V/Os7NaKPV0osbovtKazuwrza88/gIjgA47pDyyeyOemWRNK3/XCzXxEgsQg4VD2Vqkxf8Xaovholo3XSBoVsUgqsSnrkqZaeKr3CGOqvOK2WrbCRFl4GbzFyitATZIb8GXhufrnzDk8WvLCiKo87W4=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB8996.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(786006)(23010399003)(366016)(10067099003)(18002099003)(11063799006)(56012099006)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WUs2TXc0QkFIUnpBRXYvUC9YV1h2RWpXSkhMaUdhUnE0Nzk0QlZTRkNWR1ho?=
 =?utf-8?B?NlMzL2dKTGJIMTBxQytrUVBaQjdDMEVUS2lxSkNIbmw1K3BMUXFiVEovWlla?=
 =?utf-8?B?STNkTlh4Z1hIOHR2WENJcnQ2d0FzbzNCR1pDbjRZN3ZSZ1pmWG1CT0RVNEVz?=
 =?utf-8?B?a1FPYlk0cUtSME9QSHpzREhDZzJ0aUxXTisvYnVPbWxNVzR1OGF6S2thL1hN?=
 =?utf-8?B?bVdiOUo3TVA0SXkvMXlVUWlKNmpkVHVLbTV0N09BUjZtUThCRk95aEw2R0lO?=
 =?utf-8?B?UkNwUVBDMGgrd2dvT3dhaUNSUHBuV3pOcXV1NWFpSys4bVArVXlGenF4dHRY?=
 =?utf-8?B?OVlaMVRWMHJaWFhVV0R6THd6NGhpS0NUNEFRVWxTalVYcUlpd1Y1ckVqN1pD?=
 =?utf-8?B?a2IyUmhHQlBJTXI4a0tycjdBWkVjSjdVaG1kOEU5T3pyTUY3MnVpQ0FudUVI?=
 =?utf-8?B?dGZ2bHRZbjBaTzVERGIvSXVOOFpEcjB5UzVGYWJUM081WFJSY1o5WmtuTGlO?=
 =?utf-8?B?b1lrd2NHcldOMEovOGFmUGxCZEszczNNY1RnNFk3ZjdCd2RzS05zbXloMnIr?=
 =?utf-8?B?bDNva290dHR3ZE9tNjhpSUhLUDE4NTFIMHRzT1F3TnVzZUlHbDJwTlZQZnhG?=
 =?utf-8?B?TGpweEIvVTNrc0pyb1ArWVFQQmp5MHRTL3owQkJrRjE1aGNTZXdPQ1EyM09s?=
 =?utf-8?B?L1oyRDJKdHllbHI4ek9CNjVuNXhkOXVVMGJxcHJiNTRnTnhwN1VmYmh0TUNn?=
 =?utf-8?B?UDhGcXZFV0VDZm5TZXV1MmtrWXRmTVpjZnhrbnpEVFVja0hPVlRGUTEyQVFp?=
 =?utf-8?B?RTdyM084eTVuZjZLZ3JOQW1YdEtBeklMdjRkTU40WnVjNWhwcUs0MnVvUHdq?=
 =?utf-8?B?VW42eHh3WHNpQmtma1NzWkV6NGw5TlByU0FqTWk2VU9CemtHV1NudEdTbHJH?=
 =?utf-8?B?UCtzK2VGV3BQcG1oenA1TjJoZjNqZjRJTnhUL0dWY3VCcjhZZnhEVmZaQXRW?=
 =?utf-8?B?SjRwd256emJwT1drRUpmS25UTVVxYTM2WTZxYzNDUjFuejUrZEhNbktGVENZ?=
 =?utf-8?B?NDk2SmlvUUsvNlBqUHV5Z2RrUmlxVHUxMnd3M1czTUJqSHM1dnR5UnB2OEJY?=
 =?utf-8?B?U3B5dDBLNkpHNE9qcXB0Q2grcjNEZkMreXdiZ203YUlkS1ZVeTY1UzBTZk5G?=
 =?utf-8?B?c1FzZHhtUnBBdnZ3c2RXMlQ2L0ZTbHJ1a2FKNFZVUEZsTVRRcFpDY0VtaXls?=
 =?utf-8?B?VXlKOTdIeTgwRXdIbWN4VDMwZTFxclZXTnNBTkNkc3QxNnNJMVBJaXdSS2lD?=
 =?utf-8?B?UmNFZkNxdjNnUWkyRmc1NGpkaGFYOXN0QzVQaGt1cmtJYjJwMG1tNFVYWkRD?=
 =?utf-8?B?WVk0Y2l5blhTT1NJd0lSOCtsRVp1MExxNXVFM3NlZ3kwb054R0tjekwxR1VK?=
 =?utf-8?B?eEdrNWFPc2paMk1Tc3FoOGpzd0NBT2wxVHRDZXdmcDlDM1JGWmtnMzZ5UWRH?=
 =?utf-8?B?MmlORjJSQ3lCN2dMTUtPQXRvQkE2Rkl1UnNBZUpodU5Ld2JkMC9QeDFQOU1v?=
 =?utf-8?B?cHFETENhZHpYRUJTSUpjQzhGSlVzY1UzbzBTeUh6M3g3dDRCLzc2a0pDL1V2?=
 =?utf-8?B?Z0J5bkJpM3JkRXB1MWt4eTNnMTZxaFI2L2t4WkdCWHhlSDd1WDFxN1VHdGJu?=
 =?utf-8?B?M0Q5SlViYzNrM21ZaEUzR3cwMVpJWEpFRFlxbVhCeHk0VXlJZzFNZjh3Zitr?=
 =?utf-8?B?OFl3bUtWbkRaVTYxYTYvT2gxTVIybTRodmVLTFdnUkQzT24yaERpVjNuRlZh?=
 =?utf-8?B?SzBLY3VrVFhkTHJOU056ZWZEbUNxcUt0ZkJsNy9DRE14TmovUDVYcXRGVnY0?=
 =?utf-8?B?NDBqNTVxcStOc1J0VUFtQVIwcVR6TzZWK0E3aGdKSG5xclhNYzNudXNua1lo?=
 =?utf-8?B?cmdtOUlISGw4T0hNeGlnSm9taGZCK1lGMmNaU1JoN3V4RkNEN3ZIY2NJZ0tK?=
 =?utf-8?B?WWpXWnZQU1FzUG9hME5ReFlwTGFPMWtTWGVpaVh4SDJTemYycHNJNGoyODVT?=
 =?utf-8?B?YjExMHlwcWgzUFVFdzJ2T3JCM3IrTlRiUFJtTk5Hb2lIeWJCcmtVeG04eEVV?=
 =?utf-8?B?K2ZLQXJ5OU1vR2Rya3hBVGY0bnRsamo0RlptUW1pU2k3bnhtUFR6emhTcE01?=
 =?utf-8?B?S01tVm5KY1RUQThBT2E3TlVuOS8weEk2S01wL1lUaTBRYXYxSVdlOVl6YlpW?=
 =?utf-8?B?LzBJRzFVa1lqbW9QNFdPWWFhakZGK1pvdTRsKzRPam9BOERTYTFsZXhJMHdi?=
 =?utf-8?Q?ktg8kmzJe3NUHlX7FR?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: kuleuven.be
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR08MB8996.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 416e8049-1a38-47a7-ca9f-08df046ffadb
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2026 19:18:30.5910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3973589b-9e40-4eb5-800e-b0b6383d1621
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +f3bPyTar7SiGYKa8kt6cSDuy1bmM+350e1UhgpfBfCcGCThFOvoeX0Jj+/SNIpJ9gTwx/QZ30gJXc6m7vO8Mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10479

RGVhciBkZXZpY2UtbWFwcGVyIG1haW50YWluZXJzLAoKVGhhbmsgeW91IGZvciBtYWludGFpbmlu
ZyBgZG0tY3J5cHRgIGFuZCBgZG0taW50ZWdyaXR5YC4gQXMgcGFydCBvZiBhCmJyb2FkZXIgYW5h
bHlzaXMgb2YgZnVsbC1kaXNrIGVuY3J5cHRpb24gaW4gTGludXgsIHdlIGlkZW50aWZpZWQgYQps
b3ctc2V2ZXJpdHksIGRlZmVuc2UtaW4tZGVwdGggY29uY2VybiBpbnZvbHZpbmcgYGFlcy1nY20t
cmFuZG9tYCB0aGF0CndlIHdvdWxkIGxpa2UgdG8gdW5kZXJzdGFuZCBiZXR0ZXIuCgpUaGUgYGFl
cy1nY20tcmFuZG9tYCBpbXBsZW1lbnRhdGlvbiBnZW5lcmF0ZXMgYSByYW5kb20gOTYtYml0IElW
IGZvcgplYWNoIHNlY3RvciBlbmNyeXB0aW9uLCBidXQgdGhlIGRldmljZS1tYXBwZXIgcGF0aCBk
b2VzIG5vdCBjb3VudAppbnZvY2F0aW9ucyBvciByZWtleSBhdXRvbWF0aWNhbGx5LiBUaGUgb3Jp
Z2luYWwgcGFwZXIgWzJdIHJlY29tbWVuZHMKSVZzIGxvbmdlciB0aGFuIDEyOCBiaXRzIGZvciB0
aGlzIGNvbnN0cnVjdGlvbi4gV2FzIDk2IGJpdHMgY2hvc2VuIGZvcgphIHBhcnRpY3VsYXIgY29t
cGF0aWJpbGl0eSwgcGVyZm9ybWFuY2UsIG9yIGltcGxlbWVudGF0aW9uIHJlYXNvbj8KClNlY3Rp
b24gOC4zIG9mIE5JU1QgU1AgODAwLTM4RCBsaW1pdHMgdGhlIFJCRy1iYXNlZCBJViBjb25zdHJ1
Y3Rpb24gdG8KMl4zMiBpbnZvY2F0aW9ucyBhY3Jvc3MgYWxsIGluc3RhbmNlcyB1c2luZyBhIGdp
dmVuIGtleS4gVGhpcyBib3VuZCBpcwpjb25zZXJ2YXRpdmU6IGFzIHNob3duIGJlbG93LCB0aGUg
ZXhwZWN0ZWQgZmlyc3QgY29sbGlzaW9uIGZvciB1bmlmb3JtbHkKcmFuZG9tIDk2LWJpdCBJVnMg
b2NjdXJzIGFmdGVyIGFwcHJveGltYXRlbHkgMl40OC4zIGludm9jYXRpb25zLgpOZXZlcnRoZWxl
c3MsIElWIHJldXNlIHZpb2xhdGVzIEdDTSdzIHNlY3VyaXR5IGFzc3VtcHRpb25zIGFuZCBjYW4K
ZW5hYmxlIHRhZyBmb3JnZXJ5LCB1bmRlcm1pbmluZyBib3RoIGl0cyBjb25maWRlbnRpYWxpdHkg
YW5kIGludGVncml0eQpndWFyYW50ZWVzLgoKSW4gb3VyIDE2LWNvcmUgdGVzdCBlbnZpcm9ubWVu
dCwgd2UgbWVhc3VyZWQgdGhlIHJhdGUgb2YgcHVyZSBJVgpnZW5lcmF0aW9uIGFuZCBwcm9qZWN0
ZWQgYW4gZXhwZWN0ZWQgZmlyc3QgY29sbGlzaW9uIGFmdGVyIGFwcHJveGltYXRlbHkKMzAgZGF5
cy4gV2Ugd291bGQgYmUgaGFwcHkgdG8gc2hhcmUgZnVydGhlciBkZXRhaWxzIGFib3V0IG91ciBz
ZXR1cCBhbmQKbWV0aG9kb2xvZ3kuIFdlIGFsc28gcmVjb2duaXplIHRoYXQgdGhpcyBpcyBhbiBp
ZGVhbGl6ZWQgcHJvamVjdGlvbiBhbmQKYXNzdW1lcyBhIHN0cm9uZyBhdHRhY2tlciB3aG8gY2Fu
IGNvbnRpbnVvdXNseSBtb25pdG9yIHRoZSBkaXNrLCBhcyBtYXkKYmUgcG9zc2libGUgaW4gYSBD
Vk0gZGVwbG95bWVudC4gTmV2ZXJ0aGVsZXNzLCB0aGlzIGlzIG9uZSBvZiB0aGUKZGVwbG95bWVu
dCBzY2VuYXJpb3MgaW4gd2hpY2ggYGRtLWNyeXB0YCBpcyB1c2VkLgoKSWRlYWxseSwgdGhlIHJh
bmRvbSBJViB3b3VsZCBiZSBtYWRlIGxvbmdlciwgZm9sbG93aW5nIHRoZSByZWNvbW1lbmRhdGlv
bgppbiBbMl0uIElmIHRoYXQgaXMgbm90IGZlYXNpYmxlLCBjb3VsZCB0aGUgYGRtLWNyeXB0YCBk
b2N1bWVudGF0aW9uIHN0YXRlCnRoZSAyXjMyIHBlci1rZXkgbGltaXQgYW5kIHJlcXVpcmUgdXNl
cnNwYWNlIHRvIHJla2V5IGJlZm9yZSByZWFjaGluZyBpdD8KVGhlIGtlcm5lbCBjb3VsZCBhbHNv
IHdhcm4gb3IgcmVmdXNlIGZ1cnRoZXIgd3JpdGVzIHdoZW4gYW4gaW4tbWVtb3J5CnBlci1tYXBw
aW5nIGNvdW50ZXIgcmVhY2hlcyB0aGUgbGltaXQsIHdoaWxlIHVzZXJzcGFjZSByZW1haW5zIHJl
c3BvbnNpYmxlCmZvciBhY2NvdW50aW5nIGZvciBrZXkgcmV1c2UgYWNyb3NzIG1hcHBpbmcgcmVs
b2Fkcy4KCktpbmQgcmVnYXJkcywKU2h1a2FpIE5pIGFuZCBKbyBWYW4gQnVsY2sKRGlzdHJpTmV0
LCBLVSBMZXV2ZW4KCiMjIENvbGxpc2lvbiBlc3RpbWF0ZQoKRm9yIGluZGVwZW5kZW50IHVuaWZv
cm0gYGJgLWJpdCBJVnMsIHRoZSBleHBlY3RlZCBudW1iZXIgb2YgaW52b2NhdGlvbnMKYmVmb3Jl
IHRoZSBmaXJzdCBjb2xsaXNpb24gaXMgYXBwcm94aW1hdGVseToKCmBgYHRleHQKRVtOXSDiiYgg
c3FydChwaSAvIDIpICogMl4oYiAvIDIpCmBgYAoKRm9yIGBiID0gOTZgLCB0aGlzIGlzIGFwcHJv
eGltYXRlbHkgYDJeNDguMzI2YCwgb3IgYDMuNTMgw5cgMTBeMTRgCmludm9jYXRpb25zLgoKIyMg
UmVmZXJlbmNlcwoKMS4gTklTVCwgKlJlY29tbWVuZGF0aW9uIGZvciBCbG9jayBDaXBoZXIgTW9k
ZXMgb2YgT3BlcmF0aW9uOgogICBHYWxvaXMvQ291bnRlciBNb2RlIChHQ00pIGFuZCBHTUFDKiwg
U1AgODAwLTM4RCwKICAgaHR0cHM6Ly9kb2kub3JnLzEwLjYwMjgvTklTVC5TUC44MDAtMzhECjIu
IE1pbGFuIEJyb8W+LCBNaWt1bMOhxaEgUGF0b8SNa2EsIGFuZCBWYXNoZWsgTWF0ecOhxaEsICpQ
cmFjdGljYWwKICAgQ3J5cHRvZ3JhcGhpYyBEYXRhIEludGVncml0eSBQcm90ZWN0aW9uIHdpdGgg
RnVsbCBEaXNrIEVuY3J5cHRpb24qLAogICBJRklQIFNFQyAyMDE4LAogICBodHRwczovL2RvaS5v
cmcvMTAuMTAwNy85NzgtMy0zMTktOTk4MjgtMl82Cg==
