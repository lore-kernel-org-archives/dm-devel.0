Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.20.1
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793893770;
	b=jbEJ241exn0otO4ZlHkhJ5W6S9UW68jxTOA8NzRUX+afjUKbtWX4xGRvApNZO1NzFCS+
	 dOo6C2tWXiqcC24ezMrxrWzrp4Uk1X96sN8QzNr0aCicMdWNGi4Yj1fq8QmjSrDL3L0Qz
	 /UMpfb4TTqHveJHY3fHkuwKMN4sPJx2imNh3beDMXPS9qbvA5ucAdtBWXAOB24+M/vacq
	 nYF79lB81XDibbqziSLY0oUtwufm/Okxvj/xvjshUUq7BABM7GukhelOQDKiYGj+qkd8v
	 sJg7hxCFqDZ7bPkxdFZ0Iu7tQhUhpKJ1JKdKlHSxlO8bcyhBfNu/ImOjsbTDbz6bpEQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793893770;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:
	 X-MS-Exchange-CrossTenant-rms-persistedconsumerorg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=Q9lnNsv6xOEA4ZSa6xVwAVyhG08ogb+nZ5Y7cLwxts8=;
	b=KyEC6Ort1Blkb7fe80GWcwCC73t9fbWaEipJf+NvWUAZxhOwvMloZFhuKmrGnn3tKEOV
	 Khk7eNa7EhHiftot6crT5tN0PBQvDpAG2bcEDTtlEU2/CM8j7PooBOkK5XmIWytf/6ZYe
	 W/pmHGjN27799AcirJVo9KrVfuARnS0hQAW9NMcAXMo/Lfp1TjWEs87asPWOM34nBjc1O
	 niMMPkfikOOLaxgyhtDTbdAqi8jC+qEvZDzZ1jOLsZk13AbATBa8rX4kkDhvAZJwbmMyr
	 Lhvbp1WvLQaM25ZdJAehERPOc1TFWLZT88ZtKydwjV+VRfS4B5AS2NnZuYg/Xqt+AXA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=vFDxKvnK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.20.1
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazolkn19010001.outbound.protection.outlook.com [52.103.20.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7513360A3824
	for <dm-devel@lists.linux.dev>; Thu,  5 Nov 2026 15:49:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7513360A3824
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=vFDxKvnK
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BFAvA5JtSHpsJeZxJuPz4e9Bcm9kGkFtytHIYJTDtiA+1/nkm9WPGjnoG/5HvNqQ4S06L86mxkjV4FHRfiZu9UqfW9iHPT8w8BQ8IuEBdB8t4B84m0Zsps7JzALcalcyHyKcpXsj/EpTUZ5MwqKgqs7by2/pd5+IuYxeo0mCAOHxa7HKYPWBYh0ERkOrT1AaH3LuzzkaIrkhhPh1Tu4UZzJf+ZURfFvWRSkzsJ6BnXaT8JvjR0aFFSVhZydbOc4f/uHXesVZKF0DoF+nU4PZut7zqKHKdOTsNbogkL2QCZDta5kAH85SuMty6cKs15gY+8IZtinkZ1N16GKos5MKoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=Q9lnNsv6xOEA4ZSa6xVwAVyhG08ogb+nZ5Y7cLwxts8=;
 b=rHRa3o52nQbnqXUU7/QY+iRLBH68AN1ySJqcH1CsEqzhVq4H1K+AOBAyUxda1Zee7Ul9VMLFmVA0zZWTjeXL6X6MPzjjyMnRaACRBaluHw3WCmZuU+Re/fZPrNHtqYQwUqn549zC/5ehEmB/HGZAlU3g3nH8rNDczkl09YYQqAe8BMhpiK2WstNgInXWfu17YkiqIbr/LIKTWnrOyFXcN2ZIdrXgA3+1QdtXJlFPyoR4jZmdwSd1N1wPs2oN5GEdxxUI1joQVupzLrAhep/bPusNQJTlXknUkqCjeJny75WfWte0cauddSpVEln2PUMbhkbyq5NcEJfPuQ/sxGz9Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q9lnNsv6xOEA4ZSa6xVwAVyhG08ogb+nZ5Y7cLwxts8=;
 b=vFDxKvnKsrfIk+Lxe+CuewK3Yp4hHxx7IlBe32cVSGt3nz6Pf7yvL16CDuLLcptWCVM7LZcKjHpkuhxe3VfrL3on+uifSl5QVp4pjHRP+wV+FWWE+jDriq1APS84b3KzskapHTfyZex/+eQ1ciaMZNVWdc3YLnv2Ab4Io15dGpFl9+WKVqhFtR5jfDW3S5YYkPaUhd6QRWgPZEmDVfplXI/NYxotz0iqdCERwTGX0oj6oR2fAV6QplSOPCaRjoB+a43KrDLA30lQu9e7S3sXopDuHlpCLE+LLcbKvmaubHTqjahRrMwNoMHb1dk9m3uJJUNzNOla6yerN+OI1y+W0g==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by MWHPR05MB10694.namprd05.prod.outlook.com
 (2603:10b6:303:282::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 15:49:27 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 15:49:27 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
CC: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, Anatol Pomazau <anatol@google.com>, Gabriel Krisman
 Bertazi <krisman@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] dm mpath: cap queue_if_no_path_timeout_secs
Thread-Topic: [PATCH] dm mpath: cap queue_if_no_path_timeout_secs
Thread-Index: AQHdbT08jF+hDXVJM0aMD1WvlEs9kA==
Date: Thu, 5 Nov 2026 15:49:27 +0000
Message-ID:
 <5699943a339b0a0b94ab0016a91c0926f4a4b075.1793893757.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|MWHPR05MB10694:EE_
x-ms-office365-filtering-correlation-id: 85f19778-9e2d-41a9-8b50-08df3b545f3a
x-microsoft-antispam:
 BCL:0;ARA:14566002|5062599005|31061999003|38102599003|15080799012|39105399006|22091999003|24071999003|24121999003|19110799012|8062599012|8060799015|24021099003|20031999006|25010399006|4140399003|102099032|440099028|3412199025|40105399003|26121999007;
x-microsoft-antispam-message-info:
 =?utf-8?B?cjliUzgvVTY4RXpGT2VaZWNKbzY1RWRxaE1YODVISVlsQ1gxcXBZNVpqY1B4?=
 =?utf-8?B?bDZNdWlOMkZFNm1IVTFYd0RraUZFNmEwNVEvZXg5YUkwNnRyYjZQQTJBNGpN?=
 =?utf-8?B?MjNKOS9wb2xZcmcwQ0VLWUhQZ0dWM3Y4OVRmRGwvR0RNaXpnRkdncnhSMGps?=
 =?utf-8?B?U1MyR0h2TzFuTzY5a0c0T2YvejNyRFVXb1B6OXhsc1A5K2dzZkNjZGlPOVdL?=
 =?utf-8?B?NFpKTzFLbWhhT01YTkZkTEpuNjExQUU5WnQxbjZUbmp3RkJTUW1ldG8rSGFT?=
 =?utf-8?B?TmJ5ZmFUYjlocHY0clFMbk9PaDFra0tiVXM0M1kvOE1XMENiSloxeWVEUm5o?=
 =?utf-8?B?UmRBTElGb0JTYlEvbkJnakVaT01oYisyNjFyYVNBMWJoRVJhYUZadmVISFQ1?=
 =?utf-8?B?VVV0SmgramhwU010aGN1N2FZU1pjQTNNb05RWGw5d2xYNFZuL2VkYmkycFF4?=
 =?utf-8?B?bEtLSjJZRjFCL3RRWVFHVTJCMFEzV0IvL0hTeFZGeVNSUFloN1plazhNdXVn?=
 =?utf-8?B?Mmt1R3BrMTJZdHFXQlQ1dVZUUFgrc3FjVER2OG0wMlJHUWJsTFc3VlY1cTNj?=
 =?utf-8?B?RldUL1R0Sk5FZythbHcvaXJFaStSZHV5cjlJMTJ1STRyUEtVcFF3MERSOE9R?=
 =?utf-8?B?TXI2VWpxNmJGeHdiaW9DV2dpcll5L00zSkpRUFAyY2xTb1hHWGZYSWVMcUwz?=
 =?utf-8?B?QzU5TmNyeVJRaytFT1hTazJRNDNlVmxwZkJISERNakxvRHRQc011SFhTZ1RV?=
 =?utf-8?B?L1VUeTg0NUQ2Wm84REErc1lLMXozZ0d5RG1YNjhSTkNVdURjaFZBbXpQdU92?=
 =?utf-8?B?eTdUaEFRUzN4NzJ0Zjg2ZytKM0NVbzdaRkI1ZzJhRWVvR2J0dmZ3d0JTVUI2?=
 =?utf-8?B?MFJPRlNkOC9sd1Q3aFVIa0xvODl5bzk2dFQvSmo5VWZPNUVDYTZhTk1HVmVX?=
 =?utf-8?B?dGZ0VGsxNHNNTWFqR0hoVmIvVjNHaVFLcGZ2Zy9UTFBCenZ5QU5tclNkMEFn?=
 =?utf-8?B?WW1KRVg2R1o3dUl3MWpiejk1SnJDWTFyMnU1ZVBtSmlnYjRFdGZ3RWpndHVG?=
 =?utf-8?B?clphOW9NNkQrb1ZveDVnSHJIRVBhOWlTSm1GMCs5RlVacjgvUDI1Sk5hQXRw?=
 =?utf-8?B?Z0tzaXpHeEJXc1pBV2lIa1c5QWd6bytRdGM2UzBheGU1VERGQmNXc1diUjd5?=
 =?utf-8?B?dWN5L2pCZnVHQWdWNTBBS2VleGM2azhWZzJVVThpNFpMRXpVbE5RV1hTb1pF?=
 =?utf-8?B?U0pnSmpsUkk1bG1Wa05RK2llY1g0b2VYa0FUeWhXdTlUdGxNVlBjT2RLdk9j?=
 =?utf-8?B?ODFHcHVsdGJRb1BBRmNoenFNcW93MkEraHFwWTdxL21EVnNGM1ZwYnd0cXk4?=
 =?utf-8?B?M2J5NE1JRnBlYlB0bEVaMFgwS1RXSGR3d1BndjlBem1naWRjTDFwd1lFWE02?=
 =?utf-8?B?OEpIUHB5MndZZy9qT2wrTjZnQ2FzSEJiS0ErbWpoVStHbGlaeEhCdms3OVJn?=
 =?utf-8?B?WlNoeWpJQ3BxYVo0ZXZkQ0gzK0x4bVZVbWNHNzU4ZjQzbTA3cDRBbjc5Ymxi?=
 =?utf-8?B?cWRiUT09?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TGk3Q2NnS2kveUlrYnNqQWE1WWdyWnN5SUZRQit5WDBMWFlrRDhkVTRsTHpn?=
 =?utf-8?B?aXNwMlJEYm90R2NEMnJTUVQ2aEFQTkJTa1RGa3JvVHdyT3FaR01VbXlZYXVN?=
 =?utf-8?B?YWFoMCt5bE5SWHpwWDRpNnlsQURzTit4V2JKZjk4UjI4d29GSVNXSWw0K0ZB?=
 =?utf-8?B?M28xVTNpcDFZR2FlSkZWVDlDZzRHTXAyRlFuWXpCMzNHQXB5Q241NjdPdzN5?=
 =?utf-8?B?K1h0YzdBem1SNXBaL3FHV0k0NURxOEtYTU9oYld1SzZhd1pHem84eG94Vnda?=
 =?utf-8?B?eG96cGN3djhmMTJybVlEUVJDZVllRjZEZHF6djdGRkM1MjM0N1F0MHhveWVx?=
 =?utf-8?B?MWNLZjBnVVRSdkc2cmlQZVdQd051TFFxS0MrUUdaTjhFcDQ4UFlyWks2TGpq?=
 =?utf-8?B?NTBzVkZKbVVieGFEZVlqT1ZZS1JPSWgvRU54aGlPNkVWYUtrWFZiYmtNNHZG?=
 =?utf-8?B?TTRXc1dZSStObGFJblk5NDMwN2lZbDZHd2l6M2J4cnNaenZHcnhlZkxjVTJz?=
 =?utf-8?B?M0JzY0hkb1ZEcUdNeDVZVjBtWU5HTklaS281ODNZL0tnSk5BUU81Vmkyc3VS?=
 =?utf-8?B?RXlOdzU4cnBCNU9PWTBIRVMzUmtML0dQQlllTVJ1L3dCTDlvclBzaUgxWmtS?=
 =?utf-8?B?NXJKWHVHT0h3ZnpQUndyY0hOa1pZTVM1OUZoeGhhT0RHZ2N0UHZuRmZkblpZ?=
 =?utf-8?B?UW1FemZBUDZLTk5mb0V0TEhDdFpHSUw3R1RWWTU5L1g5dXF2YkxuMzMyRTF5?=
 =?utf-8?B?SDJCWWs1QUpYaVlVTDhMZXJvM2t3dWxKN0xXRVFYdmhKQ0dvZWE4aUhic0hV?=
 =?utf-8?B?WWZEcERYRTdxUzNESlRQK3pYdDNqYUdOYUhKNW9oc3pVaFZnNWxzQi82Z2N3?=
 =?utf-8?B?Zjd6VUxIcTlGcFN5bStueXhRZW5wVmdXYmVucWRaSTV5SDlvc1h0NWNIWS94?=
 =?utf-8?B?dU1nOC9SUzVxc2VMQVhVZ0ZuZGZqbTVLQkt5SWh3K2pEYVp4SFg0Y3h6eUpp?=
 =?utf-8?B?c2htbVFrNXJSSjRSRW94dEFBSzZOYU9iZ3NyNmFOK3EvM29hMjFmbzFQSGl5?=
 =?utf-8?B?T0xsd1FhRXk1OTRHQTQzYURYdElrb0Q0Q0pMaU9uM05uS2FsQ2YzRVpEUElx?=
 =?utf-8?B?ZU1HZVNZOEpJb2IyVnhoU1VIQVJ2ZnUwZ0IvMGVDRXZzZ2FwTy9BaGJka0NP?=
 =?utf-8?B?eGJjbDFSNWl3cUhMTEJMbUIwTW5DSEVPOHZySTFIZ0szcHU1Tkg0WHFnMnJN?=
 =?utf-8?B?dmw0THNYQTdBQ1ZMdGpoN1FBTGJYS3crQTcvMzFsSDNKUmJrNzZXVkp3ZFdx?=
 =?utf-8?B?alRyMlo1YUhHWHNRUVR3SFB3NnV0THgvSzR0YWpLM29uaEZ2OVJ3MmVrTXJJ?=
 =?utf-8?B?VnhRR2VKcmRIUU84QTgvNTRxdVdRTXRQSHBzdjNzYnY5ZDBYRTh1dFlFR3Vy?=
 =?utf-8?B?YWVOdkZIYVRQeHIrNmYyVUZYU2lObVcwZjVXMCtaWVBVamZuZUhnY0orV1JC?=
 =?utf-8?B?aHlQa01vZ3ZBSXkrQ0Zya2ZOcGVVRnVMWWVRbGhaWUtDZ3Bjb2FudnRxaE11?=
 =?utf-8?B?ZWcycjZBNC9UTDZ4WncwWVBNbkRZZ3FyV2dvZFpPSHJWcy9iQk03aUhyb3hy?=
 =?utf-8?B?WStZQlFRWFBwaTFLVzYrQ1ppRERiNjU0V3R2Z0o3OVNQYWhzTk1PbkVRaEhY?=
 =?utf-8?B?Qm1PNWhZRlZISkFnOS9BYkQ5K1krM0Q5SjNOOG1uSVVldWxmNk0zTUhDbmZQ?=
 =?utf-8?B?OFlTbWo5QXA1NDYvVGpjenFYdFd5QS9Tc2c3aHlDYjJUVzFYOGY4cUZPVG5Q?=
 =?utf-8?B?YVZYWm1GTVd5TDNSWkVJU2Nrb1hRd0hPSUp1VCtRTk5XY0ltSjVTUzZrQ0tx?=
 =?utf-8?Q?6VYB8qkrO9DCU?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR05MB10385.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 85f19778-9e2d-41a9-8b50-08df3b545f3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2026 15:49:27.0607
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB10694

ZW5hYmxlX25vcGF0aF90aW1lb3V0KCkgYXJtcyB0aGUgbm8tcGF0aCB0aW1lciB3aXRoCmppZmZp
ZXMgKyBxdWV1ZV9pZl9ub19wYXRoX3RpbWVvdXRfc2VjcyAqIEhaLiBUaGUgbW9kdWxlIHBhcmFt
ZXRlciBpcyBhbgp1bmJvdW5kZWQgdW5zaWduZWQgbG9uZywgc28gdGhlIGRlbGF5IGNhbiBleGNl
ZWQgd2hhdCBtb2RfdGltZXIoKQpoYW5kbGVzOiBhIGRlbGF5IGFib3ZlIExPTkdfTUFYIGlzIHRy
ZWF0ZWQgYXMgYWxyZWFkeSBleHBpcmVkLCBhbmQKdmFsdWVzIGFib3ZlIFVMT05HX01BWCAvIEha
IGFsc28gd3JhcCBpbiB0aGUgbXVsdGlwbGljYXRpb24uIFRoZSB0aW1lcgp0aGVuIGNsZWFycyBx
dWV1ZV9pZl9ub19wYXRoIHJpZ2h0IGF3YXksIGFuZCBJL08gcXVldWVkIGFmdGVyIHRoZSBsYXN0
CnBhdGggZmFpbHMgZ2V0cyAtRUlPIGluc3RlYWQgb2Ygd2FpdGluZyBmb3IgdGhlIGNvbmZpZ3Vy
ZWQgdGltZS4KCk9uIHg4Ni02NCB3aXRoIEhaPTEwMDAsIDkyMjMzNzIwMzY4NTQ3NzYgc2Vjb25k
cyBmYWlsZWQgYSB3cml0ZSBhZnRlcgoxMjQgbXMgd2hpbGUgb25lIHNlY29uZCBsZXNzIHJlbWFp
bmVkIHF1ZXVlZCB0aHJvdWdob3V0IGEgNC4yLXNlY29uZApvYnNlcnZhdGlvbiB3aW5kb3cuIEEg
dmFsdWUgb2YgMTg0NDY3NDQwNzM3MDk1NTIgc2Vjb25kcyB3cmFwcGVkIHRvIDM4NApqaWZmaWVz
IGFuZCBmYWlsZWQgdGhlIHdyaXRlIGFmdGVyIDQ1NSBtcy4gT24gMzItYml0IGtlcm5lbHMgd2l0
aApIWj0xMDAwIHRoZSBkZWxheSBwYXNzZXMgTE9OR19NQVggYWJvdmUgMjE0NzQ4MyBzZWNvbmRz
LCBhIGxpdHRsZSB1bmRlcgoyNSBkYXlzLgoKQ2FwIHRoZSBzZWNvbmRzIHZhbHVlIGF0IHRoZSBs
YXJnZXN0IHdob2xlLXNlY29uZCBkZWxheSBub3QgZXhjZWVkaW5nCk1BWF9KSUZGWV9PRkZTRVQg
YmVmb3JlIG11bHRpcGx5aW5nIGJ5IEhaLiBUaGlzIHByZXZlbnRzIHNpZ25lZC1kZWx0YQpvdmVy
ZmxvdyBhbmQgbXVsdGlwbGljYXRpb24gd3JhcC4gVGhlIHRpbWVyIHdoZWVsJ3MgZXhpc3Rpbmcg
aGFuZGxpbmcKb2YgdmVyeSBsb25nIGRlbGF5cyBpcyB1bmNoYW5nZWQuCgpGaXhlczogYmUyNDBm
ZjVlNDAyICgiZG0gbXBhdGg6IEFkZCB0aW1lb3V0IG1lY2hhbmlzbSBmb3IgcXVldWVfaWZfbm9f
cGF0aCIpCkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnClNpZ25lZC1vZmYtYnk6IFlpbmdqaWUg
V2FuZyA8eC1wcm9mZXNzb3JAb3V0bG9vay5jb20+Ci0tLQoKTm90ZXM6CiAgICBUZXN0ZWQgb24g
eDg2LTY0IChIWj0xMDAwKSBpbiBRRU1VIHdpdGggYSBzaW5nbGUtcGF0aCBtdWx0aXBhdGggdGFi
bGUKICAgIG92ZXIgYSBsb29wIGRldmljZSwgZmFpbGluZyB0aGUgcGF0aCB3aXRoICJmYWlsX3Bh
dGgiIGFuZCB3cml0aW5nIHdpdGgKICAgIE9fRElSRUNULiBXaXRoIHRoZSBwYXRjaCBib3RoIHZh
bHVlcyBhYm92ZSBzdGF5ZWQgcXVldWVkIGZvciB0aGUgNC4yIHMKICAgIG9ic2VydmF0aW9uIHdp
bmRvdyAodGhyZWUgYm9vdHMgZm9yIDkyMjMzNzIwMzY4NTQ3NzYpLCBhbmQgYSAxLXNlY29uZAog
ICAgY29udHJvbCBzdGlsbCBmYWlsZWQgYWZ0ZXIgYWJvdXQgMS4xIHMgYXMgb24gdGhlIGJhc2Ug
a2VybmVsLiBBbHNvIGJ1aWx0CiAgICBmb3IgaTM4NiB3aXRoIFc9MS4KCiBkcml2ZXJzL21kL2Rt
LW1wYXRoLmMgfCAzICsrLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxl
dGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvZG0tbXBhdGguYyBiL2RyaXZlcnMvbWQv
ZG0tbXBhdGguYwppbmRleCAyZjg3MWEyM2EuLmQyZTk0Yjk2ZCAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9tZC9kbS1tcGF0aC5jCisrKyBiL2RyaXZlcnMvbWQvZG0tbXBhdGguYwpAQCAtNzk3LDcgKzc5
Nyw4IEBAIHN0YXRpYyB2b2lkIHF1ZXVlX2lmX25vX3BhdGhfdGltZW91dF93b3JrKHN0cnVjdCB0
aW1lcl9saXN0ICp0KQogc3RhdGljIHZvaWQgZW5hYmxlX25vcGF0aF90aW1lb3V0KHN0cnVjdCBt
dWx0aXBhdGggKm0pCiB7CiAJdW5zaWduZWQgbG9uZyBxdWV1ZV9pZl9ub19wYXRoX3RpbWVvdXQg
PQotCQlSRUFEX09OQ0UocXVldWVfaWZfbm9fcGF0aF90aW1lb3V0X3NlY3MpICogSFo7CisJCW1p
bl90KHVuc2lnbmVkIGxvbmcsIFJFQURfT05DRShxdWV1ZV9pZl9ub19wYXRoX3RpbWVvdXRfc2Vj
cyksCisJCSAgICAgIE1BWF9KSUZGWV9PRkZTRVQgLyBIWikgKiBIWjsKIAogCWxvY2tkZXBfYXNz
ZXJ0X2hlbGQoJm0tPmxvY2spOwogCgpiYXNlLWNvbW1pdDogODc1YTcxNjFmZTE1NzQyMDUyOTNj
MzZmN2JiZDA4MTUwMjNlNDhhMQotLSAKMi40My4wCgo=
