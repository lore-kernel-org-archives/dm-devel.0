Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012015.outbound.protection.outlook.com [40.107.75.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A2B23AD
	for <dm-devel@lists.linux.dev>; Fri,  1 Aug 2025 01:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754011881; cv=fail; b=srSVqQnlKzASss0iY/Dzd1ZZQ5I9CM9hUgs/zUGoy0Wq3MF1ZvqxSq+CB4X1K6p6oIZ0c2oqcvrpL9YhW3l8SvjkQZbgPFeMLOnGB16RU80UUBqbyDDyZXtdD/p7uReU1EG/LlcWc6NFkRaLfgLwjPP0LagTwBjmY7OCXwBjAK0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754011881; c=relaxed/simple;
	bh=rGL7CDuNGUUd1zqNrfNX7q5ICIxwLKk30j493uTNo10=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UjxfsOx+F2WNfyLlV6jVu4BxPraY/U24OgjSAY7ZkiM+pgU0PmCuJloWtKRZKVugd/32or6DNB94F0ieOGdzVpgc/7wc8OAzIE5g2GDWQlJuuJ6YnzaJZLbuDq0xtvA8fOxtk6FrUluF6fcAz1VmLbtIwWmVg68hZx/mmeL/sQw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=K08cI6qJ; arc=fail smtp.client-ip=40.107.75.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="K08cI6qJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K45WDfzX+yTcm3VSdLZnBBLHuRm/3bxPB4JUHchf8a1C+WjIAli762GjkwUaPLhdnLEwAfVBBBZNm8kdI6e7BJvQN6fQRXMyaujTIoQM+qFXW9GEigY3VoIm0eBrToOGULRjppkFjM0iu+tXqG3ab1pxIMI/PfE6ZM5Dy3djaadzAA29iN1jG6451ltG208WB3/xz/zggzwkFItKxNjVH1/vdFL5sjMgeZ8jAXPw0R5G8q4e1OywOlQd+OYFqwA9pjBfKjgA9Zw+/oOdv0pwffZh35RBfCnoUdl+SIjaLCONUy/KZUDM41tL6g0YBMwgS5mSYZupY8qkZMZU+ORQcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Ygdj1e1Gh+XkX51+O7mQrIsl62Jp+Le9JYjFRVZkMc=;
 b=vKqY4lM5Crrbmsyr/k+Vptcq4kJgcW+TxOP6nVOPmYQw5sqes6pPSJ9g1Ktq7pbclftAABZUpf80QcoN63nYqIlgwF9SCNARAveRTzQ83du6IzCSTDbul58+8X6peSp1yJwxAOkFDkh+GikQ6HQ89AnZcYDMQnmNA1EH/WaDoajTigjRtIJlfRrg3cAzo2wp7rlEAN2xhT/zmoHaQ00X873GXeBak0R3XIqCl/opQPBtvHaUmX/GLrZV6NfkuDJLI4TWHqzqj9pd+6BgUCNJi6npE4oqai8rb0l4GDpN6wfyMkgEjdya08+dAUEzYzvuRH5ptmdb+l6Hx3CJvQz6/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Ygdj1e1Gh+XkX51+O7mQrIsl62Jp+Le9JYjFRVZkMc=;
 b=K08cI6qJ49CnoYIKslYkqHJElcxAiS+r41bIkiFviNeH3LHrTsApV/kwtewh44TahQjQvEwd2StHdIdHtU9pNy7540REA0zSU4hUk40YOd+FXirFAKU4QNhlZ6i+63W7hcwWQhtqvYF3hBb3ySQ2YgIuDmriovd9TXi9BMEo22o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from PS1PPFE5C9D9891.apcprd02.prod.outlook.com (2603:1096:308::2ae)
 by KL1PR02MB7664.apcprd02.prod.outlook.com (2603:1096:820:122::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.16; Fri, 1 Aug
 2025 01:31:16 +0000
Received: from PS1PPFE5C9D9891.apcprd02.prod.outlook.com
 ([fe80::e3d8:6cd4:4818:db76]) by PS1PPFE5C9D9891.apcprd02.prod.outlook.com
 ([fe80::e3d8:6cd4:4818:db76%5]) with mapi id 15.20.8964.024; Fri, 1 Aug 2025
 01:31:16 +0000
Message-ID: <66308a97-f2c3-4f6d-83fa-2fa202b0e473@oppo.com>
Date: Fri, 1 Aug 2025 09:31:12 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: set DM_TARGET_PASSES_CRYPTO feature for dm-thin
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, guoweichao@oppo.com, snitzer@kernel.org,
 Eric Biggers <ebiggers@kernel.org>
References: <20250730061718.1966686-1-weilongping@oppo.com>
 <0d84258e-daa5-2f96-78e3-ac52b8d35452@redhat.com>
 <6db292e9-dea9-42a6-ab96-298481cc70c2@oppo.com>
 <f66ace1c-3112-a3c9-5c43-efdbbf82d765@redhat.com>
 <72f54b80-2e66-4692-a635-0882e9d11631@oppo.com>
 <99a2ab74-55f3-5609-c887-e6c2d5df6228@redhat.com>
 <20250731183020.GA1312@quark>
From: LongPing Wei <weilongping@oppo.com>
In-Reply-To: <20250731183020.GA1312@quark>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0022.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::8)
 To PS1PPFE5C9D9891.apcprd02.prod.outlook.com (2603:1096:308::2ae)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PS1PPFE5C9D9891:EE_|KL1PR02MB7664:EE_
X-MS-Office365-Filtering-Correlation-Id: 11763d0f-ccab-456e-8b03-08ddd09b1b5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eStlVlMrdGRtdmp0OFI4bXkzS2Znekd6Vkxnd214cHp0M200WnhxdHgwL1ZC?=
 =?utf-8?B?MDkyVkgzNlJ2Y2lCQXhEZXhpL0owckFOVGNJakZ6eW85WERGSmk2dzVrOW1G?=
 =?utf-8?B?eGowVGdCZ3FPNUVPTE5zdGYyelF3RFlSTXUxY2kwUDFnZmZDYU5OQkRzZDBa?=
 =?utf-8?B?d01IK21XRm5VTUFCbGNxamNabTBuZkxsOGhxUlgzMURYTzI1TlptckhWTC9Z?=
 =?utf-8?B?bUY2VktzVHhwZlk1VzBJTi9CQVpGalk2L2ZpM1ZmMHFJaHk1L1kyYisvTEIz?=
 =?utf-8?B?b1pBbFhWaHdldGlndmwyVWhtNjM0T0FZRWF2cWhtdndrVW5OTkorbmFNYXdX?=
 =?utf-8?B?QlN0OUVKbUIreC80bGNjN2NWRzZGMWRPU0lnNW01eDVBenZoSm1mN1kvQU10?=
 =?utf-8?B?KzQvYnZMQTFBN2s1bWhod0pMZmF0cDkrYW9oVVBvZnBubUhqUEovc0hqdE1m?=
 =?utf-8?B?VlZaZ0s5bGZ6a1VwTlRkekFkbTI5RGxBZS9SSDdNUTZXWWtGR2JwS2hkclp2?=
 =?utf-8?B?OGlsSmtxM1IyN2RITkFsMldIR3pwbmZhcE9MblZreCtCdWYxL0FaVWxqaG91?=
 =?utf-8?B?YVdqSENBZC8ybEFWNzBtSUlMVjU3c2crUldYbE9XK2RyZFU0c09pNHA3QlZI?=
 =?utf-8?B?TlB1M1labWV0Q1lxOGRlTzJDWnhpYUtQNTBqR3VkRjZBK2NrY0lZQmVCZ01K?=
 =?utf-8?B?VDNncDk0VzNPblZhV0dITWFiWGpNd0Jzd1NDYzZMa2cwaE1COEYxcm5teWdw?=
 =?utf-8?B?bTV4Sjh6RWdpby9qTFBwL3VIL3FZRnY1THVxM2RWc1NYbWQrUkFPeHlwSU15?=
 =?utf-8?B?bDlzSHpMWFkxNWNPdys3eDZwTXdpSS9odE9MRFJySzcrVytRcU5GNmRlU3lG?=
 =?utf-8?B?SFFER0VlOUJuTnJYVCtwWkhRdVB3T3JMVHNweG4rWU84RkxtdTAzaGdIL1Jk?=
 =?utf-8?B?VDcwRlRBSUJGdHJDTW5Qd0I4ZTg1aTM3MVdLVmdYWWNYTE1pOXRwVjB6ZWZ2?=
 =?utf-8?B?VDJrVnRPWFV6VWhtRDRwUkNnRWxOSzBSTFo1elpPYVRMd09BQXlIUm5CM04v?=
 =?utf-8?B?VEN2V01rRlFPMXBudzBXeUVvZk41dU9tcDg3eHBZaHVYL0hHRGtsM3ZGRmd5?=
 =?utf-8?B?VHE1aVp3ODNOTGFHd3JOZ3VJNDhsWGZPak5CekpEbTNHcU53ajZJeDZCYXF6?=
 =?utf-8?B?SXp4V1ZvTDBtQ3Y5Y1dvUHh2YS9rcHFRT0l3eUg5ckF5M3RDQjg5UGdSMlpI?=
 =?utf-8?B?UDNOYmt0TFoxRngzREQxTEVlN3pWVS94UWdyV3BXajIxZmlKeFNVUEFTVVYr?=
 =?utf-8?B?eUVjR0J4KzNCOHgvSXpqdUhuYWNtbXNNUktHMnBGQndRK2RvMnB4VGRacnF5?=
 =?utf-8?B?WG1SaXREV1lTRVVwZjZUSjR4U0VjZkVBTXNUbkNNa09rSHlzcTlqaVhXODRW?=
 =?utf-8?B?V3F2dTlMdlppUDNHMHZ4RlQ0MXROQUU4RW5tcThmdUo1SmVaa1RtOWQ3ZVl6?=
 =?utf-8?B?c3lvemZ5UjAvMTdvMnAraEI2Z2pMakg1eWlORjlCNTVQOW5KSnJQOHdORWRZ?=
 =?utf-8?B?SkpuVkt5a3VzWVVNRUN6NmV3Zmp3Tmt1SUJST2lVaTlCVzUzVEx5MTd6V0Y1?=
 =?utf-8?B?L1J6ZURvVDhqc3dPdFBDbFlNbkZQZ1Y2dy9UUHNLQVMzbU01K2VnQXZzRGpx?=
 =?utf-8?B?bEJpWldOMC9oenhHQ1gxejVyVS82S2QrY00yRUFQNXNOVkhCK2xQcHZUUGxp?=
 =?utf-8?B?Vmk4RWNyL2dtd0dOWVpLWkVoZWRjTkk5dHdwMGZ4b2xENzZlZ0FlNmhmMlZZ?=
 =?utf-8?B?Vy82ck9kSlVUUEZ6YnBGOU1HRHpUS0Jna2tsbldRdUk1c3dtUXRhbGQyQ21S?=
 =?utf-8?B?aVBnRmNaMlB2em45VzArQWJJVjBadVJva0dlZnRlS2hURlp5Kzl3N0JaSjBZ?=
 =?utf-8?Q?4HApPZWeEpg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PS1PPFE5C9D9891.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N3pGR0twQWlZMzc0VzhZTURiZEMvUnBBL3MyR0xkLzZEMzBVUkRyMDBJQ1dt?=
 =?utf-8?B?b0IrWWVlcmEzY054VlNkZm5pZUp5UGdUdG5pbGp2Nks0Sjl6d2kzMEJmTThG?=
 =?utf-8?B?WWZEQTdCR1ZuL0x0SVFVMm8wWVVJTWxqMW5GWWpweXd0c0lLSFp0WlczTzU3?=
 =?utf-8?B?OWJWNm5IdUtzRzJBVmQrclRnb1lHWklFZHZ6YUd3M0VzM3RDcVFwYWtibkNW?=
 =?utf-8?B?L21EYmJ3ZWZvZHZmdjFzVHdiWDJuRTJtOEZGbmpUMjViUW5zTGRJZ1E1c212?=
 =?utf-8?B?UG51YU93K3E4VzczU2ZYVW9SUUpqRXBnbHZDTmJ0cG5HS3FzVFRBUml1NzN2?=
 =?utf-8?B?UmFLTk56UzZFTlZPY0dNYXdLQTdYUjZxM0pNa1owUlVkRjdHL0VpYU1ubG03?=
 =?utf-8?B?L3h6Z2xLeVllei9wbExxNnBKem5JUEV0NzlHWFNTWjZwR3pBaUx6ZTFaaFQ4?=
 =?utf-8?B?dVdrTmFGcmNpQ2x6SnF1cE5mdE0rajJCaCt1UTZ4ajhzTzR2dmhWbnBWR0NZ?=
 =?utf-8?B?cmpWVnR0d0JFcVN0REtBakFqbXhVcnVLdHlSK3MwMXVDOEg0dGZ0M2dqdCtM?=
 =?utf-8?B?Zk5pZG4xVzZldnpsRnR3Mkc4TlN5RDh1b0lSeC9Qc1k2a3JHcmF3RUFhbGRF?=
 =?utf-8?B?SFo5dENFcHRGK0pnS3p2am1oL1Qya1I4dUtDN1hESkZ3ejlOeGVpTEZ2ZkJs?=
 =?utf-8?B?dUo3eitMeU5VWFlNY2tkYVBhczJGYkNWZmRmSjlrNjI3WXUyQXRsRkRnWlpS?=
 =?utf-8?B?QUoyM3l0QkJGb05EZTR4ZGJ0THFNUHEvL3lSbnlEUGYrVi9HNG9raTBpMjVi?=
 =?utf-8?B?Vktod0V2Q1VMV2w1VUxFYWxlT0ZSOGFpOWhwZkVvaTBDZStwaHRKY21sUEJp?=
 =?utf-8?B?ejlnVi9XU0RaQTlIVmYrU0VPaVg2T0hERERFZ2FPaHF0QzV1d3YxT0dmcjNl?=
 =?utf-8?B?MGFnSzVZWjhqeFIyNjVicmpYWi9wTHUyVUtUcjdxVHpRTVZlTmREYUI0VzN0?=
 =?utf-8?B?RlFTVGRDTUdnUGNpQU9SU2VFSWUyOEVwakRFRlplclBOQmMzTnNhTnNQcmgw?=
 =?utf-8?B?TC9BTnFNVCtvdEYyNVJodzFrSmtHSUNZR2RORE41NS95cDZuMHUrNUQzUVc3?=
 =?utf-8?B?d3lFaitFTGZNTnFqNEFXRjZIUXBMSkdHcHpvcUwrTEFWaGlEcHBjcVpYenlx?=
 =?utf-8?B?TEpuTnFaWkYwUUxLVmZlREJKblNJYUtjcUxhK1RaWEtyaVBZbENnbEtjdzR2?=
 =?utf-8?B?TlRhUlZYYWYzaXJCYUN2NitjVVRvY3ljd0VzYUVaMStRd1Y0c2lMU0pJRVhs?=
 =?utf-8?B?U3RjRWFUMVg3OURTeXFTWWdBN2NlSVlpa0ROM3JsV2hOZzRXSjkyY0tWQnhQ?=
 =?utf-8?B?S1MvUUMvZ0FROWtqRks0MUY2UVRzRVcvRis5S1dlVEpnRzgyLzNFUUVBMXhE?=
 =?utf-8?B?Qzd5QjhPVlFEK1ptb3YvVi83UEkyWHAxRjRLZkduVHdyaHQ2RDNsMjNTS3FO?=
 =?utf-8?B?bGtBZm1ldmRocTN2Z2c4dE1kb3VFMWZFcTVOcU9jaGpBbEhjUDhyU29wd0lH?=
 =?utf-8?B?Rzg5Q21Kcy9CTGwwb0dZQXBCWEN0aUdZTHVFRUNYcUN1MFIrSkJ3Z0pxVTRk?=
 =?utf-8?B?ZzZJV2ZaREd4Nlo1YTcvNjRVd2ZPeTJtZjdLMVViWXlOSEJhV1pnRWx5YjBl?=
 =?utf-8?B?OTQzSHJQS0F0MDg4bm1uOHhDMEErVWtFdXIxb2hHSkRJNk9xN3l5TkdMWWly?=
 =?utf-8?B?bFJSS0R5ZnFXRkNkY2tuSjdjNitHaGc0NkdlU1Z0eHJtbUZtVW5vNWQxRWlP?=
 =?utf-8?B?VXVTeG9JTWpMU1p5QWVwU3hZNEw2Zk13MEF2c1ZzajZZY3RRcHpjRFgxWlZt?=
 =?utf-8?B?Q2tDdmdVdjMvV0RGWkljZUdPdnFDaWIyK0xJWHJUZE5pd0RUK3BGU1RjbExr?=
 =?utf-8?B?V09wV0hCNU1keEw3VENLU0YySHNWV2NBY3NKY253eExxRy9VdmdiZkM2V28z?=
 =?utf-8?B?TVRVRWZZcFJ5SVAzLzdnZkUxVnRHMWRrTEx5c0NLQXJaellxK2tDQ2hOS2U1?=
 =?utf-8?B?UE1pNGJQbTZNVm9xVVlKOHdNNEFGYWtMYTlUNUt0UGMzVHdvNHdyM1Nkc09O?=
 =?utf-8?Q?n5KXTRCP8fuoEl0M96wEJKBHp?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11763d0f-ccab-456e-8b03-08ddd09b1b5f
X-MS-Exchange-CrossTenant-AuthSource: PS1PPFE5C9D9891.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2025 01:31:15.7689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qul+v1VykKCulKSkrA+uwttARoiv+J8S4fMAupqozfmCf/wkaNjSUYKxVkJhb8VrUW5CuG0gWO+TV6iZ8L2m9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR02MB7664

On 8/1/2025 2:30 AM, Eric Biggers wrote:
> On Thu, Jul 31, 2025 at 06:04:52PM +0200, Mikulas Patocka wrote:
>>
>>
>> On Wed, 30 Jul 2025, LongPing Wei wrote:
>>
>>> Hi, Mikulas
>>>
>>> For example:
>>>
>>> F2FS/EXT4
>>> ----
>>> dm-thin
>>> ----
>>> dm-thin-pool
>>> ----
>>> pool data
>>>
>>> 1. There is a block of testfile in F2FS/EXT4.
>>> 2. The offset of this block is n.
>>> 3. The position in the dm-thin device is m.
>>> 4. The position in the pool data is x.
>>>
>>> The IV is only be affectted by offset in file and the ino of this file.
>>>
>>> Even if we change m by defrag or change x by COW, IV won't changed.
>>>
>>> The upper layer will only read the decrypted blocks with the same key and
>>> continous IV in one bio.
>>>
>>> If the upper layer read the full chunk with mixed blocks for GC purpose, key
>>> and IV won't be passed in. Then the upper layer just get the encrypted blocks.
>>>
>>> LongPing Wei
>>
>> Yes - so if the IV is calculated from inode and offset, it seems safe to
>> support it on dm-thin. So, I accepted the patch (and increased the target
>> version).
>>
>> BTW. what happens if someone uses FALLOC_FL_COLLAPSE_RANGE or
>> FALLOC_FL_INSERT_RANGE on a file with inline encryption? That changes file
>> offsets of existing data, so it should be disallowed when using inline
>> encryption - but I don't see a test for this in the functions
>> ext4_collapse_range and ext4_insert_range.
> 
> This seems to be a question about fscrypt, not about inline encryption
> per se.  FALLOC_FL_COLLAPSE_RANGE and FALLOC_FL_INSERT_RANGE fail with
> EOPNOTSUPP on encrypted files, as is documented in
> Documentation/filesystems/fscrypt.rst.  For ext4, the check happens at
> the beginning of ext4_fallocate().
> 
> - Eric
Hi, Mikulas

For f2fs, the check happens at the beginning of f2fs_allocate() just 
like ext4.

LongPing Wei
