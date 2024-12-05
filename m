Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FC219048D
	for <dm-devel@lists.linux.dev>; Thu,  5 Dec 2024 23:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.143.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733441342; cv=fail; b=s6v1KacQoUi7fybrIJy/KhrHC54iOjE/1lUkxf69JTxj0yU3VbfRhrbzlv4pi6rZ/1tN1zoNRtjR9mB1E9ZZ/vbqr8GK0C/JAMPeC7yeugpX58rSKF5Gpnpu8JRYirTcZUDsuS+2td2sOPIiq7Lvj4+aNuMmA/qw0vC8v5RrIVQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733441342; c=relaxed/simple;
	bh=vIVNjrSoypfLIKeW7DWlrCXEi/dhT+UrQYoZdwlWSrs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GceZIbqOHwExhRD3nXXfqb6fVkQiac2RbV31OKyn5oPwzz+T7afX6nk3jPpkmshEt6wXyZACoG730DpX5fDBBjg+ZymXe1d3jz2rrYI6UNcfDxlahDlDgg1xlmKmzfkDF91KtF9PrnYbFn+T0StwiEbYP7Fuq+8UJploH6rthd0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com; spf=pass smtp.mailfrom=hpe.com; dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b=CoJ53Bg1; arc=fail smtp.client-ip=148.163.143.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b="CoJ53Bg1"
Received: from pps.filterd (m0150244.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5NIIZ7031607;
	Thu, 5 Dec 2024 23:28:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps0720; bh=NW
	TrN0U7fU/VvvAkouERQbnm4EgK+0tAkbAXtBaJzsw=; b=CoJ53Bg1kh0oMDcd40
	kMMuwAqBW7qfD8mo5MN5CShVX2dXyBplZJEOhOk/0kXD9iTivWwpvtW5jsSCABHP
	diZ+LY9+G/6MyjfpZXQQ0xCCgghIxhkFPistaawtgwB0elBhV/Owos+2SxVi6Idg
	lTymucQyQLsApq4pru1Dy/rxEJvpevMB/R12vLN3Yfp7t/IkcmzhAt5ewaj1iWdU
	gTOsMGsVp0S0FEvv1sxlN627fwwPbC1C0J8bTBDB37fycx7bt5VZ8WsrASjydvOR
	aPgNvFHrfA4VQ3SXhpFjHGfS6ijN9605hd6QmYZ82epLwd3wPcbwCzxAuIgP9Brq
	993Q==
Received: from p1lg14881.it.hpe.com ([16.230.97.202])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 43bnqpg2ph-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Dec 2024 23:28:56 +0000 (GMT)
Received: from p1wg14923.americas.hpqcorp.net (unknown [10.119.18.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14881.it.hpe.com (Postfix) with ESMTPS id 27DF9806B74;
	Thu,  5 Dec 2024 23:28:55 +0000 (UTC)
Received: from p1wg14923.americas.hpqcorp.net (10.119.18.111) by
 p1wg14923.americas.hpqcorp.net (10.119.18.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 5 Dec 2024 11:27:07 -1200
Received: from p1wg14920.americas.hpqcorp.net (16.230.19.123) by
 p1wg14923.americas.hpqcorp.net (10.119.18.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11 via Frontend Transport; Thu, 5 Dec 2024 11:27:07 -1200
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Thu, 5 Dec 2024 11:27:08 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IRlewTBvKiTdz90ciEyV1Ga14RMcesLw8toia0gnleIWPo4a1eXY6dGs9WpGCgP2EAZM/Cew8gl2lRPtCfb2WYQ8cGjS7OxSq3tZ3R1B0rVPRqYY1wUW0n4KFcc01FeekTJUcQVCqFSMxzW12tPluS+hD+U7B6FUiOHvvuzqlu3W7jnNdBCSZMAIRdUrnNbxbIXiigMyNu4cW8XplzY4FI6RR78Gts3YQVb9Bne8masKrLK3SGFz5N1E3MITQU8mXtWpnKQQG9dmCySb+HcdLP5+gWQXZBGz2/ctIjN8HAe/0HCObHjhitJx414VR9EpjA0+KTPGfpKz6aDoDrEsVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NWTrN0U7fU/VvvAkouERQbnm4EgK+0tAkbAXtBaJzsw=;
 b=C1DJvsUdXZWLAdv4cDgqNJa0XEDw7/MIKuBePIDf08curWsT+EvUVhEgcUTdRVLUbmPkiPWwyX2qcU4DwCpI8eVOtl6wxTzvJF1WfmtPgHwZ3jz6LKX3KmpkYffTlP27feh9JHGhTFc1BCs2VWlUueHhBYOFIRy0MhPZQzfEJfaZCuLckcLB9e+4vkA2skOx7ELxUUk+GdH/u951eUdEcRSdUVZr9AW6DxdRXhMcMcqTWtpffqqb430e8wqDJdos1GIBAqU3QBHL0v7b9Zy10ro+gDjLzdFRGkAmHkp29b1Z5/TNo4j5tkdbohvc0F6nbcVP0VUdOeSezilBJ11mkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from PH0PR84MB1954.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:16e::17)
 by SJ0PR84MB1989.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:a03:433::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Thu, 5 Dec
 2024 23:27:00 +0000
Received: from PH0PR84MB1954.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::8a14:4ed8:c5dc:42d7]) by PH0PR84MB1954.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::8a14:4ed8:c5dc:42d7%6]) with mapi id 15.20.8207.017; Thu, 5 Dec 2024
 23:27:00 +0000
From: "Paul, Jon (HPE Storage-Fort Collins)" <jon.paul@hpe.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        DM-DEVEL ML
	<dm-devel@lists.linux.dev>
Subject: RE: [PATCH RFC] multipath-tools: add HPE MSA Gen7 (2070/2072) to
 hwtable
Thread-Topic: [PATCH RFC] multipath-tools: add HPE MSA Gen7 (2070/2072) to
 hwtable
Thread-Index: AQHbR2f6TquCQMJ+7Ea5m1AGvx/7obLYSx0A
Date: Thu, 5 Dec 2024 23:27:00 +0000
Message-ID: <PH0PR84MB1954F13D770F7F74E7CFEA4285302@PH0PR84MB1954.NAMPRD84.PROD.OUTLOOK.COM>
References: <20241205224917.7104-1-xose.vazquez@gmail.com>
In-Reply-To: <20241205224917.7104-1-xose.vazquez@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-bromium-msgid: b35f0abe-d803-4654-be30-d7f378ad86d7
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR84MB1954:EE_|SJ0PR84MB1989:EE_
x-ms-office365-filtering-correlation-id: 041538b2-e199-4442-64c4-08dd15845192
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?KmLOC9OTZpmd5I1QyysuQ6mHFtEHIItg1lFdKzAhi/Yrg2Zlon33GoFtqYe+?=
 =?us-ascii?Q?Ow3w30l09nS6+1eJdF2UrB9syi2J1bZSOJU+c01fFpD3BOMI2Q5wjAwrhCVr?=
 =?us-ascii?Q?P0efRSm6Q+qvOy3hO6gKEieuvE4Vjw+siGZJrHYAZD9/6DRjpYr/a93SNEhH?=
 =?us-ascii?Q?2WOfpi5XlxqmeocWbnyb879uRuflZ0PqvEr5UB2z8qBoigeLM9q1zyRWeb7H?=
 =?us-ascii?Q?MDsBInJGlDcZn8v0wG//045KYiC7aNiLtdP5ECEeKnZTo6H93NnjaBAr8Va2?=
 =?us-ascii?Q?eFfH1afKXUaPgw0IqWSeBl8BhyxXzVWrLjQwN1MerI99VIdL9FJlHn9fN1Iq?=
 =?us-ascii?Q?5DUPstlDvjNkRCCHuPWvnAuCO3lIF8cE7+B/7Y9r388DLZ16CVrGY6BK6iBM?=
 =?us-ascii?Q?jNXJT4maTq0h8vvXLdgRRu6e28EHx0AF09CQL3pHqaA7PWdhE6KAWRcdQ4/K?=
 =?us-ascii?Q?EAH90pFZofa6SS+91WQCoEAhOg/SS7Nqf8OHYZMKT5ghrK3reM274Grr4xWs?=
 =?us-ascii?Q?pw0f3DUhg6SUJzOUQENoa7CC/y3quAB3N49XEFnAwRZkmT5OPieMbuVOTiAW?=
 =?us-ascii?Q?0cUjxVWbXgbyWxc3FSbyMJpN0uWi8kFI+S/9JUiaeO+GJdEhuqzMTZTYPB0O?=
 =?us-ascii?Q?L6d6DNdalf4LtwCq7bCFL1Hu14fvDPO6lVBNu7LoiGIjqzB4rRnSmwpgfon1?=
 =?us-ascii?Q?N4yWlxkNxVbF7mvr1Ean15uhVemCBpDWDUvArGl02BJbJS2VXavGhA9yUUkh?=
 =?us-ascii?Q?al058AOCZSkvUUrqgfrOjFQlG0XilX/zc4zflO/NEKpHUcanCR+9Ce/9hkit?=
 =?us-ascii?Q?HpLc/tQ9tuJnXstc09528hngbmkvR/P4mAypslNelfmCCYwCrkVGUBf7vzBr?=
 =?us-ascii?Q?vPKZz7MAUALZbNeNw42UsfHe62rVWBOAqdr6oyleplV3ObH0/ZuDMt9Rv73C?=
 =?us-ascii?Q?G4fXq7aG6CA/POuP6za+nDSP9X8fidfN8LDaCEEprRTSqKgGiVjBC9IFfpNE?=
 =?us-ascii?Q?TGUQsm/pSLj1c8ag7FpQz0cK6iCT6eypoERkRcPjXHa1RlImR+clX4NalgSD?=
 =?us-ascii?Q?fxixyrH6rJ9XmGHFnkFkKpMxUFDvIQ6w8T5GaiDgclYQ5NhXRNC5Q56JnxQt?=
 =?us-ascii?Q?P3fFsaB+8voVXjLpO1GgeDz6w+v4x+sH1vngFdsceU4r23JisuN+NsbtYzW5?=
 =?us-ascii?Q?z64vUK9d+3/QpIJz9d3yp+8Te2spWwLaL/By1Du73agW7TCSIsFswC+ek+5p?=
 =?us-ascii?Q?F9rwE6pCf7TvjZm52rUUPKvHCupuAdUnFsp4tUelDjHO2mVPHGD96IIBp/y0?=
 =?us-ascii?Q?lGJJ5EHlIbXy1i9mRf49tlVQQ2yWUo69TZFtTBnoRT33sv3QHemVHNznGiMb?=
 =?us-ascii?Q?ulfC48RBWnMLpdhXjqnhAiUaMquszUKPZaQBVcUyQo//9qabqw=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR84MB1954.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vCt+Slj8nRJKK0uc642VatQQGkRM1hbPvlZmBK1mwMWpq/8XmrZ1AXysjUoE?=
 =?us-ascii?Q?syFCPp3wTmIwB3jgBK5c56ttNaoIUp29SAxZKreVAfw2YdUEuJ6JPzn5R3Hq?=
 =?us-ascii?Q?TLcg4l98MbvMUHVOWnLXRH54hm8verzcd0rV4bugCTKmNqoijWkzb5MucS6b?=
 =?us-ascii?Q?+iCbETUx9LptQz1TUNrbghseB2bXutfPUjkE5GtTy9UO8sY4W3+YKS5aP4E7?=
 =?us-ascii?Q?yDg1s1XkNUr5PcWkFYcHNCS/SI/w+WE3bCg3NNDxAmBqMC5+c2bDd9SCVxd8?=
 =?us-ascii?Q?EQ36yEqH6FsGAUYSNK4M00ZEa/5IFY0BWByvNOaOFPMImwtFvn9q95383jE8?=
 =?us-ascii?Q?oqRZ3jTo1BpKauglWI+sPNxF9DCEdzm1eLvxVtcqqXX4aPGfceR4NDTORWI6?=
 =?us-ascii?Q?3BOYk5X+0wk7KLoeREIde7z6Uz7miptx5K7JooDg4Ek6YTju+JkLoHYQnA3v?=
 =?us-ascii?Q?yAxoNBZRBo8TFIm+jPo10yLeTh6wBwBNq9l8WDKVfJ+kxTEwXZYjy3xxwK8X?=
 =?us-ascii?Q?7RldEhhmIAYEBhuGdOiiMD3SNOivWXI9nQmMJA37OPTgny2wc6yi7I61gZYq?=
 =?us-ascii?Q?L24Q1DfXUpj2XHsuPT/OmfFKKt3Ufeb9kVG63l0n/oyj45cm3bjN1EYyNvKs?=
 =?us-ascii?Q?EEkloJN3KHzl6nZFV4SqNTNNyGjxBhqdHb1y/7H3IERYQuLCVduHhzGninwY?=
 =?us-ascii?Q?MjwbHQje5Iwvs1AWq/dNtZHZIWW00SxElXKcdrmphTOvXWH1zDEpNpgrGQUU?=
 =?us-ascii?Q?Xf1pfwI58u3b/S6gz889ne2LViIkK/5Y9xo4SwpOftmiA00gWkS3Zs8hysnI?=
 =?us-ascii?Q?zAxuCio3senr183jLdpmj15TRkHE7oNwtMrvbJUBEPRNDYb5OQ5u9OQcz3Xo?=
 =?us-ascii?Q?tuOTrtJc53Xwe0KaBvwe1oyqfWbEfxmOQ//2078rMW8UUfmxjjEdqidQ4SwU?=
 =?us-ascii?Q?mq8iKZ4ODeUpjO8Tx5D38njqrie9pkQkGkAVdGxt7RSvpXUQFU+jYNXQCDTO?=
 =?us-ascii?Q?uQ+9OUyOySSrvxcJ6HsJ1l/T2uBGWclcXWkAcZR+b3E2/WE8TXJgwzGeZQHG?=
 =?us-ascii?Q?/4HsZWqYdkOcQf9mThPD585ylK2CzPIXyWaHaK6cJGz5vcdeVIPPnr9AtsyL?=
 =?us-ascii?Q?a6VOpowi89wffkSqzJh19C3siJTob6rY98U9/10LSIw/QjCiamCnd+C0PX+R?=
 =?us-ascii?Q?Rw6JCz68sNOnnwVVK4DeK8j/IEQXLHvS7jh4hj5/dJwCqbOnej2+aphn+Vly?=
 =?us-ascii?Q?j6wfuqdy4l3/WiH+L6wOcVIAfPOkYS8pDXwaYZ2rRIOMBpC8GLA4AHDfakMj?=
 =?us-ascii?Q?xwTBP4tgDDIC0qSMVutKYOiHcYldwwSw3l1K2HVk2rREE2XTV7QZ2q/4DrVw?=
 =?us-ascii?Q?11ihmY4kNwREALSLhVOvj+XfTQcI2n1ss+Vu1c+WmQ5U+vzYUu3F7OCSaSwf?=
 =?us-ascii?Q?NwSMooEg9KOVlAc9N3yaH9npyRBCDtG8bOStv+e+iNjn0cEfqbVJmxib9IG7?=
 =?us-ascii?Q?yM1ZczgxX/SaRtESlK7ggw4WgDDIGIBeL9waZzVGNrcWQW6p+2UFmjaMy9yG?=
 =?us-ascii?Q?lTklLirxd860wx2Rh9c=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR84MB1954.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 041538b2-e199-4442-64c4-08dd15845192
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2024 23:27:00.4323
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hwOhKH9LftHcQJXYyiAWo329zcK1OrODgqkTUSYzNnep7H1E8b4WYhyuvsDFZ5cBkzi6DpEVcGv/LOjQ+E5Jtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR84MB1989
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: Kos46uAfFFA3_PAvZp3EmjrNl1PR-H6O
X-Proofpoint-GUID: Kos46uAfFFA3_PAvZp3EmjrNl1PR-H6O
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_02,2024-10-04_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2412050176

Thanks Xose,

I had a lot of help finding the right contacts a few years ago to add MSA G=
en6 you have solved that problem for me.

The updates you show below are correct and approved from the HPE MSA R&D te=
am.

JP
Jon Paul
(970) 898-4375
Jon.Paul@hpe.com

-----Original Message-----
From: Xose Vazquez Perez <xose.vazquez@gmail.com>=20
Sent: Thursday, December 5, 2024 3:49 PM
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>; Paul, Jon (HPE Storage-For=
t Collins) <jon.paul@hpe.com>; Martin Wilck <mwilck@suse.com>; Benjamin Mar=
zinski <bmarzins@redhat.com>; Christophe Varoqui <christophe.varoqui@opensv=
c.com>; DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH RFC] multipath-tools: add HPE MSA Gen7 (2070/2072) to hwtab=
le

https://support.hpe.com/connect/s/product?kmpmoid=3D1014856412

Just guessing, confirmation from manufacturer is needed.

Cc: Jon Paul <Jon.Paul@hpe.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c index 32118339=
..543f0bc1 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -188,9 +188,9 @@ static struct hwentry default_hw[] =3D {
 		.prio_name     =3D PRIO_ALUA,
 	},
 	{
-		/* MSA 1040, 1050, 1060, 2040, 2050 and 2060 families */
+		/* MSA 1040, 1050, 1060, 2040, 2050, 2060 and 2070 families */
 		.vendor        =3D "(HP|HPE)",
-		.product       =3D "MSA [12]0[456]0 (SAN|SAS|FC|iSCSI)",
+		.product       =3D "MSA [12]0[4567]0 (SAN|SAS|FC|iSCSI)",
 		.pgpolicy      =3D GROUP_BY_PRIO,
 		.pgfailback    =3D -FAILBACK_IMMEDIATE,
 		.no_path_retry =3D 18,
--
2.47.1

