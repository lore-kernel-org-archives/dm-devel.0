Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010031.outbound.protection.outlook.com [52.101.201.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D298396572;
	Mon, 12 Oct 2026 17:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791825291; cv=fail; b=KwCi8qpIXE6b5sU0grcz1I+5fBX8fHHIhPgFhVy5SmpzkRBaOoz02XstclcExVAksshoiey6E7vRS1ehKrNmFzG5zIjzIpS2ItNS6Vc8st/ols72aKnu5EXme5fiKI5P5rFCJh0vF0nWk/Hsj8efRuDIEMWKXRMD9jQUsjNvuT8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791825291; c=relaxed/simple;
	bh=CFHpttI/PX8OUnSYgxQhqLzLI1xcnbBFtZDkv47bTCM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jFmtVbwmxT7g+Qizphvp/izOamOnNDVmdGCpa1pToYi8y34UQjZWa9kjKB0qzheChwrMofftWM0k76CNq3UBcihUK2n71137eINpLH5EYdmKk4xgz1e3h71mq64jDBLnBElf6hbmWMsHG96BFHp7DS6zbq46/3E0hQtzYMG/meY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nOTc78of; arc=fail smtp.client-ip=52.101.201.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nOTc78of"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FPv8obcONyvmx+CjJrY2MuxpB4B7GRGrHHE7pHpJJjz1rQJp5Hlb8Ew2FFyJhXtjFh06OztXxumgMQmqAqi5MXCEetvlHSu5V6Fsx60ralJ/4YH2+5wQGA5vjHorotmKQaGC+vC4e8gfv0cDkFci9Yu+7VVwSfzICElULLXVQwHe3cLPx7Gd1YJJxvJmULBZ0hbkWswVWtXEqVnzDwtO3u4KMyS36D/czl8yZMo+fVxrDDfB4anIp3AAWv/b2TeLgH2vb0WvxujTRY8/Fb9FU1S9fRipwU9k7sTxr6Uq+GjGAvCl7URBLA1ksTIqqDjNc64IE6S6fy39K2vk08FNDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CFHpttI/PX8OUnSYgxQhqLzLI1xcnbBFtZDkv47bTCM=;
 b=IkeD1FCXpALccrHv8mBy27Lu1rPDY3or6FFXPF3bk0YbFGS7bHLP7jRZ8iJ7dngY4HjL+t2KieV9/ztsJ1+42nskNsjAGJeurGhFASkNDO9/iDHvaMB3q1WYORE6QGfwjCGWqld/7XbPExr1JMPhiIsJyMVUcwxkcthtg8TyvhSN2mzJpgPP4TKtMHy0OcjtewMar7k+TTz2ri6brrdkGeo63Cbqa1UXc9v2XSNxp7IDiV0mnAQbvczo3fSWbYTW7sT6VuUBuVOoW4obpRMz6Rs+3sqpqt76ikCXYujR40xWd9IQe+vKUl03ZsODX3uQtPaDLuXVd/lQcNJpxyb5tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFHpttI/PX8OUnSYgxQhqLzLI1xcnbBFtZDkv47bTCM=;
 b=nOTc78ofVYmktmbXK7tsVyedzZ8zNEBOVTohGkHmW73tODadNAAOFhajwi6WMyZCeuKAmEL5gcQg69KwpFu2CX4cAIBvwcBn4jSloXWke6vu7dTZmXvW4a3UnH1PI7Pm4fqe4BcAlSYiLqF+hYNaB10IXALZsiMYNFdvQYLP10I83zyj0Vl2Mlf46OQgABsPbSvpI9pu+pNl19oa9p+zrq+kO05ryPm2K/jK/Kxwjcy8/mMkWmwvKzvCCl5JBJvLy89W8Fsm/BoQBFXR5C0hXGAHfRbJKFa01a5TBkgAA8/1yaSz1rMuQC2JtBFWGSAVYuY/rS2WFRrNG1J40J2McA==
Received: from SJ1PR12MB6124.namprd12.prod.outlook.com (2603:10b6:a03:459::15)
 by SAAPR12MB042067.namprd12.prod.outlook.com (2603:10b6:802:300::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.21; Mon, 12 Oct
 2026 17:14:46 +0000
Received: from SJ1PR12MB6124.namprd12.prod.outlook.com
 ([fe80::18d1:68c9:ae0d:7d82]) by SJ1PR12MB6124.namprd12.prod.outlook.com
 ([fe80::18d1:68c9:ae0d:7d82%6]) with mapi id 15.21.0496.015; Mon, 12 Oct 2026
 17:14:45 +0000
From: Manuel Huber <manuelh@nvidia.com>
To: Christian Brauner <brauner@kernel.org>
CC: Andrew Halaney <andrew@amutable.com>, "bot+bpf-ci@kernel.org"
	<bot+bpf-ci@kernel.org>, "ast@kernel.org" <ast@kernel.org>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>, "andrii@kernel.org"
	<andrii@kernel.org>, "agk@redhat.com" <agk@redhat.com>, "snitzer@kernel.org"
	<snitzer@kernel.org>, "mpatocka@redhat.com" <mpatocka@redhat.com>,
	"bmarzins@redhat.com" <bmarzins@redhat.com>, "dhowells@redhat.com"
	<dhowells@redhat.com>, "jarkko@kernel.org" <jarkko@kernel.org>,
	"paul@paul-moore.com" <paul@paul-moore.com>, "jmorris@namei.org"
	<jmorris@namei.org>, "serge@hallyn.com" <serge@hallyn.com>,
	"ebiggers@kernel.org" <ebiggers@kernel.org>, "tytso@mit.edu" <tytso@mit.edu>,
	"corbet@lwn.net" <corbet@lwn.net>, "skhan@linuxfoundation.org"
	<skhan@linuxfoundation.org>, "rdunlap@infradead.org" <rdunlap@infradead.org>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>, "bpf@vger.kernel.org"
	<bpf@vger.kernel.org>, "fsverity@lists.linux.dev" <fsverity@lists.linux.dev>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"martin.lau@kernel.org" <martin.lau@kernel.org>, "eddyz87@gmail.com"
	<eddyz87@gmail.com>, "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
	"mason@kernel.org" <mason@kernel.org>, "ihor.solodrai@linux.dev"
	<ihor.solodrai@linux.dev>, Fan Wu <wufan@kernel.org>
Subject: Re: [PATCH bpf-next v2 1/3] keys: add KEY_SPEC_DM_VERITY_KEYRING
Thread-Topic: [PATCH bpf-next v2 1/3] keys: add KEY_SPEC_DM_VERITY_KEYRING
Thread-Index: AQFA8w+2C5zyX59jlDtLuO4vqcUrcQHtTXNaAg0PIQi4EQlHsIAB1HyAgAAzOnA=
Date: Mon, 12 Oct 2026 17:14:45 +0000
Message-ID:
 <SJ1PR12MB61246B0BF58BC2B6F0A79D30DE9F2@SJ1PR12MB6124.namprd12.prod.outlook.com>
References:
 <20261008-ajhalaney-dmverity-key-identifier-v2-1-008456d189cb@amutable.com>
 <910460850fd4163dadb804fbdf6c17f6a9dfec060f4d865a17df87336ea3e165@mail.kernel.org>
 <asgQxTE-6YtEgvYZ@toolbx>
 <DM4PR12MB61364B4F81AE7A8D1FB71E1BDE902@DM4PR12MB6136.namprd12.prod.outlook.com>
 <20261012-wusste-werfen-loben-94aac9fd9cbe@brauner>
In-Reply-To: <20261012-wusste-werfen-loben-94aac9fd9cbe@brauner>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR12MB6124:EE_|SAAPR12MB042067:EE_
x-ms-office365-filtering-correlation-id: 66488c8b-5d8a-4a8e-fc50-08df28845004
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|7416014|6133799003|18002099003|22082099003|10067099003|3023799007|11063799006|4143699003|38070700021|56012099006;
x-microsoft-antispam-message-info:
 xaGY0MYE7EQWvwPOtKQTRv/8GD7xa6d43jXM2u90VKjhDbfaV1sUgzHDephM3IRuE3m3hT3Uyhkst17spZ/BZLcP/IsZP+KmSAO+Jo6uJ/AiATU8n9cIdqciu7JkWhMAmu82PieFrrVLVV5IgVridnbupV6t5OJKpK4+pPgC3jEgqLRJ9LmT9ra1crd0O+s7ZOri/di+Ir03nULv8KkqX1bbiKe2UFPMXdii913kGn2QtzGBbdALE9Xt3wq+viXkXzt8lwddgUsGgevw02gBO9JB03oGQThzGKv3rgalmqSPAH+LZXSyBDXMG1b8gJe/JkFTWc4rgAOjJt/2LxMCJMEwem2MAUdhKuMnR/4+iNOra2ccmnmAjRc+PdCXVeqsbnDiDMdKsaXBJugxBCc8hLlG7w7Drv72ZflxFc5uZADDP5pvnSaJFpFWhZEYYzYGqo5kQ2SHQCyLpjneT6c2NtWmdmhZU7JGjMuyeCt/HFXthupxz6EWlLArMVXDDUuh5eAmkCk3a8brmL+Pllf+q+xfGXXegCWJbZ3bedeRu75Wj1zYd7sAow2bDDCTnPVcurGu3BDECSkBarsqOSSgEZchLrS1D8zkXQEPAcTD2t7zLov0PIWLTIP/Oxa835ENuNqcRDHN1hJPN0jfvqtyAOAXr4mb/PJStSTHevUO5Xbut55oqM3XnlB8evNVsU2PxlKpl/dI42jBK+0Usz4lcQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6124.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(7416014)(6133799003)(18002099003)(22082099003)(10067099003)(3023799007)(11063799006)(4143699003)(38070700021)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?akZGc2MvQ0wwTlJnMVFRUk1vZDdYZ0NKS0ZuaWJxQzZ1TWhXZ2RnSVd0Q2JV?=
 =?utf-8?B?bGJYM2xXNnV3T0ZWQlpUbmdRSmR4clZFMkllNStNTHJHbmZZaWF3eHYxNmgv?=
 =?utf-8?B?VlkyNGR0ZWhkcW9NRjd5MEpCRXExVUFQc3Vud2daV2pMNWJ4Uk1sb1F3dnBu?=
 =?utf-8?B?ZUkvMXlScWdaTEZnRXd0OG9Ec3NURG1FR3UwdmtMZGZCSTE3VUZTNGx5aCto?=
 =?utf-8?B?OUdXRThKV3Z6eDQ0NTRjOWYvVHRoS3haSjJONWhoM25sd3hCMVBYbEt3Q2Ri?=
 =?utf-8?B?YTYyUnpMOExFZGR4Q0VMR1hoRk1tK0RVd1UxbFBrTlBtc3lxdThLQ2JodWhz?=
 =?utf-8?B?UGlNWjdPVHVOZ1JCNEdycFVwMytHbDR6ZkxFa29pY2dzRFU1SUY2Tmk2WkNZ?=
 =?utf-8?B?SUJuVVBYbjZsREZUTktORDQ1cEViODlkaDJuVW9TOUovN3Z0NkxNcUZyQUo4?=
 =?utf-8?B?bDR0L2k0eVFGZXFCdWNFaVZJUHhWLzBYZkdYLytCZVVlYmFSVGNTTm5FL0Z6?=
 =?utf-8?B?Vm1DRkwxODJONDN2SnVBUHlQRlp0M2d0Q3VWS0xrRFNFeDBPenFFcTk3SGo5?=
 =?utf-8?B?WnA0Z0V5MWZJdkdDSGdQNjhCUUNXTHpVajZVZEpVRXExdno0TDltL0JYNkpQ?=
 =?utf-8?B?Q0RBaHRlaDR4QnY4NWJBSE5xTnl6blhBY01yWXZWN3lxd3ViZzFCYXlDYkJn?=
 =?utf-8?B?c1RFN0s2aE84eTFaVUZqOVhqSHRjSXNLcWpUeENwT1VUY05FYXNrYmtUV0NN?=
 =?utf-8?B?SWNncDF2T1RkYmsybThBbG11R01mNGVQYmw4ZmFqMmdwbnh6VWpTRU5BQkk1?=
 =?utf-8?B?T2NRMmRFdWdPckVuN29RRDJ3Y2NtYnNzd3VJVXFUS0Y2UHBWTU4zNkk3aVIv?=
 =?utf-8?B?R01VbWo3R1E5MDQ1bUlmcGdISm43ZDlzdndFUnVqa1BweE51S0JHQnBFenl6?=
 =?utf-8?B?ZW5laEZuem05MUxSc2tUMC9TdWIxdGRkd1FNVzdoWEExQUpUMndJS2VyQWJH?=
 =?utf-8?B?RTRERGRiTnQ0dGVER3BoRFBEN08zd0hHeUVGK2xCTHZBTU9yeTQ3R3MwY085?=
 =?utf-8?B?dEtwVE1YS1VkQlBkTEQ2TmpQYisvNmNSeDUxRVhuMS9nTlJYMFU2TWdYcHVL?=
 =?utf-8?B?MGZYNjZhYkNHQlZxMXlYUTR4dG5uOEFwdFVnZnRSayt6bm80cFRyVVUxOGpn?=
 =?utf-8?B?eU5SNkNIK3h6Mm5JOHlCRE5BUnhjdmxRYW9Qa2ZEeG9SMnk1VVlUVkdyYXor?=
 =?utf-8?B?WnJIdWtmRndrK1ZwOWpmRy9vR3VyYjk4aXFsY3FBNFlXdU5maDVUK2F4aFlI?=
 =?utf-8?B?TWd6VGs5c0JiN285NUpQWmd3Q3BuWHZyNFpoc1kyMkluRnppWDRhMFZXRVlk?=
 =?utf-8?B?djFOUi9rbyt4Y0luRmMyM0xnYlQvZ3NRU1h5K3hubllFS3g5UFk2QTRUK1Er?=
 =?utf-8?B?UnF0VHhFMEpvUk5ES2xRdnFCL0g0N1RWcG1pN3p1eW9SdndMRERwMk5OL0k0?=
 =?utf-8?B?cEo3eUNHVmwxamZ5dVRGVGF4Zi9wckJaWjA1VXAwbFJRcGpHRTR4QkZNRWk3?=
 =?utf-8?B?ZDQ3UkxESFZ0cUp4VFljUnhKbVlDMGlxbmZQY1hWckdMTjdnL0NBbkpXSFZq?=
 =?utf-8?B?eTQ5bTlYK05MY0cwcSs2YUZ1K1ZpU29vb0JUaC8wOFVnT0RyZXVmWUlUeWti?=
 =?utf-8?B?RHFDallsSldpQU1xcWE2T3RJM3Vud1BoVE95d1ZwU3Q0SDlOSStQT3NUTUR6?=
 =?utf-8?B?RzlVWVlPaUxrdUJaSHp3ZWY0RHlhWFEvQ3R1bW91OWVIQ1djUm4wK0RrSW00?=
 =?utf-8?B?Vk5OS1NUQ2NWOWdZczFpNVlLMEpxNnZzL3RGSmhVZmU2M3JnRGRXWjEybEZj?=
 =?utf-8?B?SktnZlFQbVZNaCsxNTdJOUNQSlNBMkRqNFhTTE5XSHFBTVZvYURBQ0xRNnMv?=
 =?utf-8?B?b0ZjVm9lTGFwSDErdlVTS2R1c1NTSE1Vb1RSem80QWMrYkJqSC94Um5WNGUr?=
 =?utf-8?B?NGMvQkoydVl4aXo2WjBqR3JJNlcvMy9mUmRlYkxmTHAyODJ5bk02dm5uWjBj?=
 =?utf-8?B?aXlnTVJ6UG9Oa0lvZ0JvR3RVQlcxWVBEVnJXdktsaTdqbnRiVVRmQXgxekRj?=
 =?utf-8?B?U0gzK2U5MmErUXlSNmNKVWx2RnBxUUNYTkdkenY3anVZTG9FeHFhV2N5ZWR3?=
 =?utf-8?B?bTV3djNVa2c0YjUxVkljVHQybVErc0Y0K1I4L1BLcVZTWEZPZU44WVpYR1Ns?=
 =?utf-8?B?a3Ewb2pXd1FHOEhmMmhCSTdQczQ4RDM5WnNkNm1VU2FldGpnSzlqRzYzd3dF?=
 =?utf-8?Q?46sum7DtoJFCRJPOuD?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6124.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66488c8b-5d8a-4a8e-fc50-08df28845004
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2026 17:14:45.3012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TNOzEyP/Coryy2oILURy3cBLhleHawnlBGC+t5VTJLusxomXdajhwiB3Qeh+VtXA6O77DAvY1ladX9i0wEET3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAAPR12MB042067

T24gTW9uLCBPY3QgMTIsIDIwMjYgYXQgMDM6MTI6NTNQTSArMDIwMCwgQ2hyaXN0aWFuIEJyYXVu
ZXIgd3JvdGU6DQo+IEkgdGhpbmsgYW5vdGhlciBrZXlyaW5nIGZvciBqdXN0IC5pcGUgaXMgZmlu
ZSBpZiB0aGV5IHdhbnQgdGhhdC4gSQ0KPiB3b25kZXIgd2hhdCB5b3UgdXNlIGlwZSBmb3IuIEkn
dmUgaW1wbGVtZW50ZWQgaXBlIHZpYSBhIHNpbXBsZSBicGYgbHNtDQo+IGluIHVzZXJzcGFjZSAo
d2VsbCwgZm9yIGRtLXZlcml0eS4gV2UgZG9uJ3QgdXNlIElNQSBvciBmc3Zlcml0eS4pLiBJdCdz
DQo+IGF2YWlsYWJsZSBpbiBzeXN0ZW1kIGl0c2VsZi4NCg0KVGhhbmtzLCBDaHJpc3RpYW4sIGZv
ciBicmluZ2luZyB0aGlzIG9udG8gbXkgcmFkYXIuIEluaXRpYWxseSwgSSB3YXMNCm9ubHkgc2Vl
a2luZyBpbnB1dCBvbiBob3cgdG8gYWRkcmVzcyBEYXZpZCBIb3dlbGxzJyBwb2ludCBhYm91dCB0
aGUNCm9uZS1vZmYgc2VxdWVuY2UgZm9yIGFzc2lnbmluZyBrZXkgSURzIGZvciB0aGUgY2FzZSBJ
IHdvdWxkIGludHJvZHVjZQ0KYSBuZXcgSVBFIGtleXJpbmcgKGkuZS4gd2hldGhlciB0byB1c2Ug
LTEyIGFuZCBjb250aW51ZSB3aXRoIHRoZQ0KZXhpc3RpbmcgcGF0dGVybiB1bmRlciBxdWVzdGlv
biBvciB0byBzaGlmdCB0byBpbnRyb2R1Y2luZyBhIGRlZGljYXRlZA0Ka2V5IHJhbmdlIHN1Y2gg
YXMgLTI1Ny4uLTUxMikuIEhvd2V2ZXIsIHRoZSBleGNlbGxlbnQgcG9pbnQgeW91J3JlDQpyYWlz
aW5nIG1heSBpbmRlZWQgcG9zc2libHkgYWxsb3cgbWUgdG8gYWNoaWV2ZSBteSBnb2FscyB3aXRo
b3V0DQpsZXZlcmFnaW5nIElQRSBhdCBhbGwsIGJ1aWxkaW5nIGEgQlBGIGJhc2VkIG1lY2hhbmlz
bSBpbnN0ZWFkLg0KDQpNeSBzY2VuYXJpbzogS2F0YSBDb250YWluZXJzIHJ1bnMgS3ViZXJuZXRl
cyBwb2RzIGluIGVwaGVtZXJhbCwNCmhlYWRsZXNzIFZNcy4gV2hlbiBwb2RzIGFyZSBzY2hlZHVs
ZWQgdmlhIGt1YmVsZXQsIGNvbnRhaW5lcmQsIGFuZCB0aGUNCkthdGEgc2hpbSBvbiB0aGUgaG9z
dCBjYXVzZSBhIHBvZCBWTSB0byBiZSBsYXVuY2hlZCBpbnNpZGUgd2hpY2ggdGhlDQpLYXRhIGFn
ZW50IGNyZWF0ZXMgYW5kIHJ1bnMgdGhlIHdvcmtsb2FkIGNvbnRhaW5lcnMuIFRoZSBLYXRhIHN0
YWNrIGhhcw0KdmFyaW91cyBmbGF2b3IgdmFyaWFudHMuIFRoZSB2YXJpYW50IEkgYW0gdHJ5aW5n
IHRvIGhhcmRlbiBpcyBkaXNhYmxpbmcNCmZpbGVzeXN0ZW0gc2hhcmluZyBiZXR3ZWVuIGhvc3Qg
YW5kIGd1ZXN0IFZNIGFuZCBjb2xkLXBsdWdnaW5nIHJvb3Rmcw0KZGlzayhzKSBmb3IgdGhlIGd1
ZXN0IFZNIGF0IGxhdW5jaCB0aW1lIChLYXRhIGFnZW50IHNpdHMgaW4gdGhlIHJvb3RmcykuDQpU
aGVzZSBkaXNrcyBhcmUgZG0tdmVyaXR5IHByb3RlY3RlZDsgdGhlIGtlcm5lbCBkaXJlY3RseSBi
b290cyBpbnRvIHRoZQ0Kcm9vdGZzIHdpdGhvdXQgYW4gaW5pdHJhbWZzIHVzaW5nIHZlcml0eSBr
ZXJuZWwgY29tbWFuZCBsaW5lIHBhcmFtZXRlcnMuDQpJbiBzeXN0ZW1kLWxlc3MgS2F0YSBmbGF2
b3JzLCBLYXRhIGFnZW50IHJ1bnMgYXMgdGhlIGluaXRpYWwgcHJvY2VzcywNCmFuZCB3YWl0cyBm
b3IgQ3JlYXRlQ29udGFpbmVyIHJlcXVlc3RzLiBDcmVhdGluZyBhbmQgc3RhcnRpbmcgY29udGFp
bmVycw0KcmVxdWlyZXMgYSB0cmFuc3BvcnQgZm9yIGNvbnRhaW5lciBpbWFnZSBsYXllcnMgZnJv
bSBob3N0IHRvIGd1ZXN0LiBUaGlzDQp2YXJpYW50IHVzZXMgY29udGFpbmVyZCdzIGVyb2ZzIHNu
YXBzaG90dGVyIHdoaWNoIHByb3ZpZGVzIGRtLXZlcml0eQ0KcHJvdGVjdGVkIGltYWdlIGxheWVy
cy4gVGhlIEthdGEgc2hpbSBob3QtcGx1Z3MgdGhlc2UgaW1hZ2UgbGF5ZXJzIGFzIGENCnNpbmds
ZSBibG9jayBkZXZpY2UgKFZNREsrR1BUKS4gVG9kYXksIHRoZSBrYXRhLWFnZW50IG1vdW50cyBl
YWNoIGxheWVyDQpmb3VuZCBpbiB0aGF0IGRpc2sgdXNpbmcgZG0tdmVyaXR5Lg0KTXkgZ29hbCBp
cyB0byBlbmZvcmNlIHN0cmljdCBjb2RlIGludGVncml0eSBmb3IgdGhlc2UgZ3Vlc3RzLCBhbmQg
dGhhdA0KY2FuIGJlIGFjaGlldmVkIGJlY2F1c2UgYWxsIGNvZGUgd2UgZXhwZWN0IHRvIGJlIGV4
ZWN1dGVkIHJlc2lkZXMgb24NCmRtLXZlcml0eSBwcm90ZWN0ZWQgci9vIG1vdW50cy4gT2J2aW91
c2x5LCB0aGlzIHJlcXVpcmVzIHVzZXJzIHRvIGJlDQphd2FyZSB0aGF0IHRoZXkgY2FuIG5vIGxv
bmdlciBkeW5hbWljYWxseSBhY3F1aXJlIGNvZGUgYW5kIHJ1biBpdCBmcm9tDQphIHRtcGZzLg0K
DQpNeSBpZGVhIHNvIGZhciB3YXMgdG8gbGV2ZXJhZ2UgSVBFIHRvIGVuZm9yY2UgY29kZSBpbnRl
Z3JpdHkuIEhvd2V2ZXIsDQp0aGUgY3VycmVudCBJUEUgbW9kZWwgZG9lcyBub3QgeWV0IGFwcGx5
IHdlbGwgZm9yIG15IHNjZW5hcmlvLCBtYWlubHkNCmJlY2F1c2UgdGhlIGNvbnRhaW5lciBpbWFn
ZSBsYXllciByb290IGhhc2hlcyAoYW5kIHRoZWlyIHNpZ25hdHVyZXMpIHRvDQpiZSB1c2VkIGFy
ZSBub3Qga25vd24gYWhlYWQgb2YgdGltZSwgc28gSSBjYW5ub3QgYmFrZSBpbiBhIHN0YXRpYw0K
SVBFIHBvbGljeS4gVGhlIGlkZWEgd2FzIHRodXMgdG8gYWxsb3cgdHJ1c3RlZCB1c2Vyc3BhY2Ug
dG8gcHJvdmlzaW9uDQphbiBJUEUgcG9saWN5LiBGb3IgdGhpcywga2F0YS1hZ2VudCB3b3VsZCBk
eW5hbWljYWxseSBjcmVhdGUgYSBrZXkNCnBhaXIuIEJlZm9yZSBzdGFydGluZyB3b3JrbG9hZHMg
KGFuZCB0aHVzIHRyYW5zaXRpb25pbmcgdG8gYW4gdW50cnVzdGVkDQpzdGF0ZSksIGthdGEtYWdl
bnQgd291bGQgcG9wdWxhdGUgYW5kIHJlc3RyaWN0IHRoZSBJUEUga2V5cmluZywgYXV0aG9yLA0K
c2lnbiwgbG9hZCBhbmQgZW5mb3JjZSB0aGUgSVBFIHBvbGljeS4gQXQgdGhpcyBwb2ludCBpbiB0
aW1lLCBhbGwNCmRtLXZlcml0eSBkZXZpY2VzIGFyZSBtb3VudGVkLg0KRm9yIHRoaXMsIHRoZSBm
aXJzdCBzdGVwIHdvdWxkIGJlIHRvIGVzdGFibGlzaCB0aGUgSVBFIGtleXJpbmcuDQpJIHdhcyBh
ZGRpdGlvbmFsbHkgZ29pbmcgdG8gaW50cm9kdWNlIGEgJ3NlYWxpbmcnIG1lY2hhbmlzbSBmb3Ig
SVBFIGFzDQphIHNlcGFyYXRlIGNvbnRyaWJ1dGlvbjogcmlnaHQgYmVmb3JlIGthdGEtYWdlbnQg
c3RhcnRzIHRoZSB3b3JrbG9hZA0KY29udGFpbmVycywgdGhlIGFnZW50IHNlYWxzIHRoZSBJUEUg
cG9saWN5LiBJIHdhcyBnb2luZyB0byBleHByZXNzIHRoaXMNCndpdGhpbiBJUEUgaXRzZWxmLCBi
bG9ja2luZyBhbHRlcmF0aW9ucyB0byB0aGUgSVBFIHBvbGljeSB2aWENCnNlY3VyaXR5ZnMuIFRo
ZSBzZWFsaW5nIHdvdWxkIGJlIGV4cHJlc3NlZCB2aWEgSVBFIHBvbGljeSBkZWZpbml0aW9ucywN
CmUuZy4sICJvcD1JUEVfRU5GT1JDRU1FTlRfT0ZGIGFjdGlvbj1ERU5ZIiwgb3INCiJvcD1JUEVf
UE9MSUNZX1VQREFURSBhY3Rpb249REVOWSIsIHNvIHRoaXMgd2F5IG5vdCBldmVuIGEgcHJpdmls
ZWdlZA0Kd29ya2xvYWQgd2l0aCBDQVBfTUFDX0FETUlOIHdvdWxkIGJlIGFibGUgdG8gdGFtcGVy
IHdpdGggdGhlIHBvbGljeS4NClRoaXMgd2FzIGEgYnJpZWYgYXMgcG9zc2libGUgZXhwbGFuYXRp
b24sIG1heSBsYWNrIGNvbnRleHQgYW5kIGRldGFpbHMsDQpidXQgSSBob3BlIHRoZSBnZW5lcmFs
IGlkZWEgbWFkZSBzZW5zZS4NCg==
