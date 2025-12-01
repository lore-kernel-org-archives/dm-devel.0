Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011028.outbound.protection.outlook.com [52.101.52.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9BA277CBF
	for <dm-devel@lists.linux.dev>; Mon,  1 Dec 2025 06:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764570245; cv=fail; b=tcPOX2VCP2RaoKpgZmIltX0VuGGxDEYk4sB4lDd9gacRYnrFVUdOwnv1manC3fRlJyJJSclKTiYyPKhkNobPj7f1Gy8BxJJKVFe/hqJ2VJC8gDY9biMzzOIIOGb+EYNUEJ8e8eL93W4EauZKhbaQBy5NsKEPpWPmY+Irk1NMW6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764570245; c=relaxed/simple;
	bh=wyEOFsB4RoD2ZnSHNrQ5wBE4bM9MCsNwTdLXFMwGdZw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Iey+QJYwE+HSMPR3Jugy4IAfUB7tZyz1vry7fMZAqTin/u+880xSIvadHesniGeOWeJZ5nOBd7TvidRSnxVJfApuEpuuU9pgmad5SpGkakFXtRZ4/4U+wYdi6rgsQTXQAzmb4YVeusgyqAC/JwCODt8rcnr4f/1JccgeEQJ+rJ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=F8E3zB+4; arc=fail smtp.client-ip=52.101.52.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="F8E3zB+4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VjO3qi6g/t5diAUr58cwrEC0Ag/K00MAzXG0DDq3ljfqWy9bHgEYmu9WrS9WfcgRzq6wJnEzgi2Ecnzkayv36kd5ErEnABlqSM37mnDgHxfjj5DyZosJPKH7dYWoPfFwtQNENI6YXJC/H36gPM/qYoEaW0jq1g7qQwnpDxuqcth0TNMyB07450S6Si0QwackMNv9MDjsJfGYliO88cfT3Opv6bmkkoatN/9rlZf654ZMOu/JWCEqRV4RKYbY7gOOXBQ8CjCdYUwGF2SzZzrdfURKEsX3nDwbZGiFH9KNKVrBaxi28yGkpDSPwpztBC++eDE2ztWUJ6OgNniFpvULDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wyEOFsB4RoD2ZnSHNrQ5wBE4bM9MCsNwTdLXFMwGdZw=;
 b=xdKcEvDgZPiv08BkH6S5KzhGX2dhUA9Kdn0eBsJiGTKFPs83KUwLDVjb6XB1CPY52URERvC+7C6X3RV9N3mCaglN+1wLRIfHT0Xdy6iqXm/6N/ERdvM4sFbOEd81uIZXWhNWtCpMOAIZvPePPYrzKPXk9LZmrcEWCf6rmVOe2EYsHoqJxypDpQzuRWzf8UnoT4dMFkXEX//83iN34zbTHliHYxv0ajPkyPCiPWfFPDHNUWfAeQE6I8/Lblw8caw4wLmh3fYLwwWhM8+sC1kiUEZ+PolP3a7dwXpk6XOXEzfYs8Lk0VkMdbLlIHTSXDmBqYiBFoe4pPG9HpG8qu+lUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wyEOFsB4RoD2ZnSHNrQ5wBE4bM9MCsNwTdLXFMwGdZw=;
 b=F8E3zB+4PV48qtuR4dQ4JbzqD3l5fiCk3urRpIApJ/UXBC+JknpwrQvKaqtpAtdOzbB5iLMTfgwIm/NxzCXe8a2RDNXa+6Dxe+0wvw9fgFtp502jhD2D1y0FDJy34wNaZy8NTQmRidYgQ3q8nOVTAPiSGW65ucxgjaW0svQnhdnCupQDNPIxP+/ycnmmjjWSHzX4dxikL7CiRtx7LyWOlrbUvXN2IwA7ZRAP0IW/aonudAfJs6CrSq4kq1PsVn4S5rrOE6ySvrUDP3+e4aFTYSLNGxi/UJAnrtb9o8VSPxBiKiLLXKX4yqhhx048l8hdhlP4q1P5ekunDx0fupOq6A==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by CY8PR12MB7169.namprd12.prod.outlook.com (2603:10b6:930:5e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Mon, 1 Dec
 2025 06:23:59 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 06:23:59 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: "snitzer@kernel.org" <snitzer@kernel.org>, "mpatocka@redhat.com"
	<mpatocka@redhat.com>
CC: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, "hch@lst.de"
	<hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Johannes
 Thumshirn <johannes.thumshirn@wdc.com>, Chaitanya Kulkarni
	<ckulkarnilinux@gmail.com>, Chaitanya Kulkarni <chaitanyak@nvidia.com>
Subject: Re: [PATCH V3 3/6] dm: ignore discard return value
Thread-Topic: [PATCH V3 3/6] dm: ignore discard return value
Thread-Index: AQHcXZzVbHZRzBtRU0yhQgvJhF2vc7UMWu6A
Date: Mon, 1 Dec 2025 06:23:59 +0000
Message-ID: <5214ed1a-280a-4886-b679-db7bc99dcf94@nvidia.com>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
 <20251124234806.75216-4-ckulkarnilinux@gmail.com>
In-Reply-To: <20251124234806.75216-4-ckulkarnilinux@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|CY8PR12MB7169:EE_
x-ms-office365-filtering-correlation-id: e6f7c016-73da-4082-0f65-08de30a236c7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?aEhXUENOWW9zYk1NUzZBQ243MU9wOS82WVNYU1BwNnlEZHFnbGdyZ0N3dW9m?=
 =?utf-8?B?UVlZTG5KWUlLVTJtV0hQNFl0ZEJ6VUJDOU52R3QwRnFRNm5NODVGaWNtYVQw?=
 =?utf-8?B?SzlvbzRGNFVYVjcwamE3NFo5NmF3UFY0Sy82RFdIM0lNdFlJVVJadzBaZ2Rt?=
 =?utf-8?B?dnpKL3hzWFZsTlJEQjF1WUY4ZDNrQUlvMURERVk2QzhCUGtLL1JVelBBb1lP?=
 =?utf-8?B?bVpRVmxCSUgxTVFwaEdxTjhxNis0VFZkTkZTY00xZldvdGhXWUVuSklBZ0h6?=
 =?utf-8?B?b1AvWVA1WXB6RmlFcHNYbzR0c0NrZkZQejFzSGpVRG5YVEpKK1Z2VEplTkIr?=
 =?utf-8?B?VmpTZld4WVZGT2N2QU81MXNVSHlvZlJGZ3FRSk1yb281dGY2Y1FpdXZ4MTUv?=
 =?utf-8?B?NGxTaEh0ZU9Ra2RkVkJTOVYzTHdkdlVNeHNZTmFHY1Q1NDF5K3VnRTJmekRO?=
 =?utf-8?B?UFcyRVRZaXYxREUzQ3ZyKzd1d2Zoa0pJaFp6eFY1dG1QK05qU2doREFIbzhG?=
 =?utf-8?B?NTRZRk9RRDFkOGNjQ1F6NHp5RVRKaC9jeHpuZWRsb0lwTzEwdzEyVG4rSWNk?=
 =?utf-8?B?NXc0RmIvQ1puL2ttdXdDa3hMTWdiUWRMdnZFRFNieDlEb0RJSGdBMzFvRzF1?=
 =?utf-8?B?L3VOUGwzRFBNcTk2UlhldkNrVGxuYTVZOThvVEk0M0UzSit2bEJPMmxKMGRv?=
 =?utf-8?B?VGJyZmdrTVROWnZ6WTU5NFlOWDJxK0VtckE0QkZBN25hSUJ1bUlTcUQ3Y2NF?=
 =?utf-8?B?YitUWlNVUUx6L2hNbk9kekxpZk1oK2JCajNuemw3T1I5dUk0NkNvL3JBYmVU?=
 =?utf-8?B?S0Y2dFBQUjhSazltbHlUcHdob1M1NGV5U2VyYk9UL2pTSnI1cGo1alR2VEFq?=
 =?utf-8?B?VmFGK2xob3lhcUFYc3UxQ3JUSkNKd0hkaTFLVE8xenNkWkdpYmtWeWxGb1Rt?=
 =?utf-8?B?VDM4eW1Zdi9nTkdBSWNKRGdNeTdwck1uZ1JyM2t6TkNQdnNrcVoyQjFabWdy?=
 =?utf-8?B?bHRvdHhTUFBycVpKZkpQcHA2K1BXczVaZllqbTNyN056b2hiRUFScmNzU0dC?=
 =?utf-8?B?TkpLbnFuTTY3N2lZeEczc2srQW5leTR5QTBrbEVXS2JQS0N1UXFIeU04SW1R?=
 =?utf-8?B?MzBiWUhwRVp4RFEvVGtDYjZlSXZrd2o4ak5yaTVpU0V3VlYzd2FubnRDMjZ2?=
 =?utf-8?B?eGt6Wmg4bnp5K2owdjF5T3RJeVVHNjN6NFIzaXJsL0dtNUFVSmo2K0dXR1VY?=
 =?utf-8?B?dkxvdG5Kb2tTMzhoMGRrTVZ0TEwzNjZZenNkbVFhTk40aGJzVDByYnBsNGtk?=
 =?utf-8?B?YkZUTWw5RDRjNlcySGl5UWlJVXJ1K1p4RGhFMFhaS0VONXBNc1dxZitIREZV?=
 =?utf-8?B?b1pzZ2FBODBaaEUyL3hERUV2LzB4Rm1YQk4wbUQwODVJUGREQ3JscUdFNzRv?=
 =?utf-8?B?V0FjbDY4UzhxY3o1Rm1rWHB6TE9SQzlicGRDZmovL09Cam9Ba0ZlZWpNYm5H?=
 =?utf-8?B?bFkyQ2UvazZVT1FIQzlOcFJJRFVBZmY4dnFadXpYeXVYNk9mcDZ6VmRwNERS?=
 =?utf-8?B?NjVBSEowSkFZczR5SXZzMU85elFxR1gyVk1GVU81YmJJNWdHQ3gvZWFnS2U2?=
 =?utf-8?B?TDh4QytKTE1UT0xIRk1oWDZSbUNVZFhLekhRRE9TMHAvYytoT3VmZkh1ZlVt?=
 =?utf-8?B?SWsyR1ovWk50blZUOUJqb3kxdWNuWjhaak5ZTTJXeG1CcExwcWFSY3dsbTVz?=
 =?utf-8?B?ZkhpSzdkMit2bXdFT2wxSzhDM3NwOE1Kc01WMDQyZC94S0FyNjlldU96M3Ji?=
 =?utf-8?B?WVVmSXRlUFNjUzBrVGFGZ1g1V1hUai9TRVVHRXZaZFR4aWtRbmdmWjUzaDlM?=
 =?utf-8?B?Rk5NK1N1d2xyZzJuUlpWSjlRSHlUcGJtcHVHcWtjRVdHZm5RZ3I2Skw0eElS?=
 =?utf-8?B?Qk9QTzBJYlc5VVI2cy95blQxOEE5L3IyR0lFczZUVVNMNFNRakNFWExIaWxP?=
 =?utf-8?B?UWY4SER2MEdDRERkVDd4aXNTMWdEd0p6Unl0Sk9WdlN4aFlPYmVYRXY1QzZ5?=
 =?utf-8?Q?xNvhRi?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OW5jdGxpbjExbHplcHhyMDYySWJKSGdmV1AzT1ZPeUV4MWN0Qnk4aHdZSG5o?=
 =?utf-8?B?U3JFTDF6SmZKUmtYQVIyZStodjNORys0dzdYQmtQZlh1MXJpLzNuZXVMcUF2?=
 =?utf-8?B?ekZ3aHNpSHpyMVdvZSt1MWZublJIWWFUaUpHbmZIM0YzWWhvRzFna2pJSlJK?=
 =?utf-8?B?NE5mNm9wVHpyMnRGRDF4LzZ4dDBwSEtLZUtPVU9jK2VadGVTczErem9ZZzY4?=
 =?utf-8?B?T1NIeUhlWmxYUWtLb3kyYmRuSWtJRCtJOTk5THlYZlJtNEJub0JNY2lIZmRa?=
 =?utf-8?B?N3ZraXRmaURqOHEvdG5tWjVQWHV5VEFKUjBjN25vaEdNVU1hVnVldnRqaWJN?=
 =?utf-8?B?Tkt0VUpheHUyV1FDOWJYc2FiN2h6OWgyUlhKNHlQOEV2cmpPOHZjTjRNUCsx?=
 =?utf-8?B?aUQ5bmErbFRkZ0RiSUo1aThDdmpvY1kyVHlXbm81dld0Rm1EOWpuM3hYdzI2?=
 =?utf-8?B?YmZFNHdLZ1ZhM2hhaXdSM2JaRSttR1ZKYmZ4dDlIWFd4b1o2VDNTRkdrYUNK?=
 =?utf-8?B?OGNtZzhjcFlkSEZrWkoybTU5QlgvOUpWcGNySm9zdzc3U1BVWVg5RlRlZGRX?=
 =?utf-8?B?WFVkKzFZQ3d6dkQ0MkVTdU1IOEU4ay9JZzJuUW1wYWsxMnAwZkJ2VENybmdq?=
 =?utf-8?B?dWZZbnNSTmExNElDRVRaeVFsK3E3Y2Z0aGxiU1dkNGRVYWlVY21lM08xU2VN?=
 =?utf-8?B?REEwWUVQQmUrdXI3Q01kTWRJczNmNUhVcGx6RmNPaFNIVndpNHU0V3IwK0o5?=
 =?utf-8?B?eHNnVlUvMkZOQ2tzelpRcWhsTVdXYzBxVDgzM0RiZmRPVGhITXRYWmVCMC9o?=
 =?utf-8?B?MTF1Zy9Dak8zUXhIYmNsRjk4bTVrb0lEQXRDYjBCVUV2cjVMOXMyZ2lzQ2FP?=
 =?utf-8?B?cmFqb2RXcm44Z0RTQ3FzL1diejhCSjdYSEVZL0ZVcS9xNXZZZDl6M2FGWnRF?=
 =?utf-8?B?MW4xNlRJQmt6YXlob24xb2UzUVhCcjAxTmFzUWVXUTRFSVQwM0VyMkRMaHA4?=
 =?utf-8?B?R1FVK2hoMWRBZHRlZ1ZOUElWQjdHeWtaRUQ3Nmo5T3dqU0g2U252Z0N2SCtl?=
 =?utf-8?B?TWFRcHhkbzVmSHU4RG9ocm9EMWplVDVMbmg1MW1lWHlrSWEvdG5VT0dXazFs?=
 =?utf-8?B?UThIUWpUcWUvVGV1YlN3eHVnZlhzcEprOTU4aXB3TjFKakFUZWZFT2oyYVc1?=
 =?utf-8?B?aUxIL0tOZmxyMkF3bFc3UmJwZUh1NDBSZjROWXBoVis4byt3OUNvc25oWWl4?=
 =?utf-8?B?aFBWZm1UTTFIdzk0UTJjRWFrTVg2aEtmT0s4WXAwOGVkRFZzQy9wZnRlMWtZ?=
 =?utf-8?B?V254SXZGelJvOWtrUEs4RzFxT3RlMkhqbXdEVWdScjJxT3UvRkk4aWVmM3V0?=
 =?utf-8?B?R2xocURQSU9keVJhcDUxMDkrdUUzSTBqMyttSFVSdUpwRjI3WlgyTU8wUmE5?=
 =?utf-8?B?N25QN25FUjBqR21HZ2FXRU1xdkthYnVLdnlHalFBSVJOZHRHWktSV3ExNDlN?=
 =?utf-8?B?K05hcCs2MXBoN1JXc2dRdFdmdHI1TjB6dGdXdmlybGRabXRQY1FyNzdkVDFy?=
 =?utf-8?B?S2Nhamk3anZOanA4cC92cDN1Y2xsd1lJbFRBaUxDTXlCZlVKZWlJRUlNWGdF?=
 =?utf-8?B?QlVIUitDS0FJTWorVU1KNU9NS1hlL3Bjc0orbGg5WlFDNko1OGl4NWRLd0xJ?=
 =?utf-8?B?Lzk5MStGV1hScmIyL2ttRmlWQkxrUnliRlo2QUdXcjNMK3dRMzRHOFAya0VU?=
 =?utf-8?B?ZitOVHdDS2h3RHUwK3V6Miszd1BqS294amI2YkNBQVZmTWgyeHRDRDJLSndq?=
 =?utf-8?B?Mm5xdFI4d0gzU3Z6V2FsbDZ3ak9JQVdLSWwybTEyM25tQlpNYXQxVm5DWHBT?=
 =?utf-8?B?Yyt3b1NJeWVkTzJEcWpRTHVBMS9DQndXY094Y0lvY2I1aUpycEJUTk9oT1pB?=
 =?utf-8?B?azB5QWJaUld2S21uTytybWhFK2wzSjc1anJEdnFVTUZRZnVoWnZBWVA3VUE1?=
 =?utf-8?B?UkJLaTMwOFFnVmVHdnBYZURwT2lOU0hIUk12V0V2elhLSXRjdjhWWHY5NUNz?=
 =?utf-8?B?a2NES0tNV25LeWo5emNkSUMvd0ZLaEl0ZWVTQkRqN3FRV0phMStnckY3UUdv?=
 =?utf-8?B?cDhEenZFNCtva3lYZEgyN1BTTEcxd29xVFBIM2YyNmNmdXlyeFBUV3ZOck9Z?=
 =?utf-8?Q?WqPqdJHQztAM+GNn4PgbXMycCqjWXDi013e18S3IzKcx?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D967B07CFAF5974182D199D19780B11F@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6f7c016-73da-4082-0f65-08de30a236c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2025 06:23:59.4830
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eATsV8tA15qyHik3DLjjVEbRtHhxTbjed8nIk2c+xeA2USP2TyEoeJf8BZRYtRdJ6x8/B9QI52YwaMZ3kFaV3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7169

SGkgTWlrZSBhbmQgTWlrdWxhcywNCg0KT24gMTEvMjQvMjUgMTU6NDgsIENoYWl0YW55YSBLdWxr
YXJuaSB3cm90ZToNCj4gX19ibGtkZXZfaXNzdWVfZGlzY2FyZCgpIGFsd2F5cyByZXR1cm5zIDAs
IG1ha2luZyBhbGwgZXJyb3IgY2hlY2tpbmcNCj4gYXQgY2FsbCBzaXRlcyBkZWFkIGNvZGUuDQo+
DQo+IEZvciBkbS10aGluIGNoYW5nZSBpc3N1ZV9kaXNjYXJkKCkgcmV0dXJuIHR5cGUgdG8gdm9p
ZCwgaW4NCj4gcGFzc2Rvd25fZG91YmxlX2NoZWNraW5nX3NoYXJlZF9zdGF0dXMoKSByZW1vdmUg
dGhlIHIgYXNzaWdubWVudCBmcm9tDQo+IHJldHVybiB2YWx1ZSBvZiB0aGUgaXNzdWVfZGlzY2Fy
ZCgpLCBmb3IgZW5kX2Rpc2NhcmQoKSBoYXJkY29kZSB2YWx1ZSBvZg0KPiByIHRvIDAgdGhhdCBt
YXRjaGVzIG9ubHkgdmFsdWUgcmV0dXJuZWQgZnJvbSBfX2Jsa2Rldl9pc3N1ZV9kaXNjYXJkKCku
DQo+DQo+IFJldmlld2VkLWJ5OiBNYXJ0aW4gSy4gUGV0ZXJzZW48bWFydGluLnBldGVyc2VuQG9y
YWNsZS5jb20+DQo+IFJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm48am9oYW5uZXMudGh1
bXNoaXJuQHdkYy5jb20+DQo+IFJldmlld2VkLWJ5OiBDaHJpc3RvcGggSGVsbHdpZzxoY2hAbHN0
LmRlPg0KPiBTaWduZWQtb2ZmLWJ5OiBDaGFpdGFueWEgS3Vsa2Fybmk8Y2t1bGthcm5pbGludXhA
Z21haWwuY29tPg0KPiAtLS0NCg0KDQpHZW50bGUgcGluZyBvbiB0aGlzLg0KDQotY2sNCg0KDQo=
