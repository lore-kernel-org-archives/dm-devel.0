Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11021139.outbound.protection.outlook.com [52.101.70.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C463BE146
	for <dm-devel@lists.linux.dev>; Fri, 28 Aug 2026 10:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.139
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787913067; cv=fail; b=u/P7kTVwt+Z22hOXXRFKCFV7uL7zXEDtyVxjctU//IEaMkOsfNHdo3qH5A+l/tSVJ/O7qMFNsofJTFtwOSGzztBthsrEQFUXW6a8Ulqdnu9XwD3bwTvhUbgZCBPV/IoxTNiOqk67bCbys9WXgCtsea4pek6zF5//RP8dBpUmTbo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787913067; c=relaxed/simple;
	bh=kLY+36w1vOytXPVRtnH76iJBr5sl2lLUu7gOcGF9+5g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cHegR2C6jLx2xeFCh4lvcAKiqTPU49fcNNGwBZ3+FvIULx2J+qUjOYPdb4kmPhmUx2GkO0HNHgp8UYR+jYAR/Y/dg5U7oHtonFS+9kg9PBn91NINDncDuo847JUUMVQevYcAqxN/8X2SPwc951kS91t8Fa54/jonh9PSI0nteO0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kuleuven.be; spf=pass smtp.mailfrom=kuleuven.be; dkim=pass (1024-bit key) header.d=kuleuven.be header.i=@kuleuven.be header.b=I7hnXsd/; arc=fail smtp.client-ip=52.101.70.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kuleuven.be
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kuleuven.be
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kuleuven.be header.i=@kuleuven.be header.b="I7hnXsd/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ENz6CPdUnGf0PBISpR8tdyzBXiiw8JJdkBWM1+AiHBSM3vJDW44O1ROpPg9qScVtaGcNEvhh0Fbwcq9fmMefrxv7kpPUqDnTaJEQ43i+/a5N3OLkeNyAEZt55Kt5uDgIEKD26qry2A0ii7EV61RLBs+vX4IbEUC6FeVookOreKsqYIlXrtshbeBkcFKYg/YRur7lNQyN4wVXeX0oZa7IpQAxMtYAI5Jq3jjnrq/S9Alrl7lNFBbXyh9x/UlVcpJLlrZQPmDzTC1riJEIHudSVbf2Qga9Q1gZAO/B/XNSsaAJ+cW9414YKcvuPKMwXg8bbnaseuUNqE52EYCxiGycDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kLY+36w1vOytXPVRtnH76iJBr5sl2lLUu7gOcGF9+5g=;
 b=bInAOb+1GkIHfwbr8hk2/2fxwpDkEeliVehGnpUmH0w3tCCXE1wx2HjhUHGqX3s06NIXiR54uyRlU70tgv+G2PbmJLIHFaUha8YAKVA+xl6d+bzhE5+cP+t0N2JzHwbwXXYBJVAqOTBOpszKzrLBkbSoKycz8IsYMROx/PA9bhk+YBuYsRodr/RSn2DQ66+BFWQamGw2/dc88ynT6q6NL5A0vqTVq7Arp8zz+8Io8f8nx5PyHpKfT1hrurqufBodELzeiidtgx7zpOocvQ18SYubInRr4F5psewJ1UQ61eKdNAo3mS/tGTjONqGQxZJFkbZmM9jnNraLg88QX+ubog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kuleuven.be; dmarc=pass action=none header.from=kuleuven.be;
 dkim=pass header.d=kuleuven.be; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kuleuven.be;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kLY+36w1vOytXPVRtnH76iJBr5sl2lLUu7gOcGF9+5g=;
 b=I7hnXsd/qy4VVZ7jGULa1NSFHGEh2vYZQnIU7twh8T2/HeiU95mJaao/Aw606LwJfAIzw5aaN+AKwX89+uA6A5+T+1cqoeFl41pQcNlGd1o9lBNOInHtiwSKSkOeRk+77DX+nnhHAgcf6QbUqYbDHlKZvb0yuH3fA2GV8UNf4Tw=
Received: from DB3PR08MB9011.eurprd08.prod.outlook.com (2603:10a6:10:431::12)
 by PR3PR08MB5596.eurprd08.prod.outlook.com (2603:10a6:102:88::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.5; Fri, 28 Aug
 2026 10:31:01 +0000
Received: from DB3PR08MB9011.eurprd08.prod.outlook.com
 ([fe80::f6d3:4f5f:88a2:e500]) by DB3PR08MB9011.eurprd08.prod.outlook.com
 ([fe80::f6d3:4f5f:88a2:e500%4]) with mapi id 15.21.0382.007; Fri, 28 Aug 2026
 10:30:59 +0000
From: Shukai Ni <shukai.ni@kuleuven.be>
To: Milan Broz <gmazyland@gmail.com>, "dm-devel@lists.linux.dev"
	<dm-devel@lists.linux.dev>
CC: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, Jo Van Bulck <jo.vanbulck@kuleuven.be>
Subject: Re: [RFC] `aes-gcm-random`: per-key invocation limit
Thread-Topic: [RFC] `aes-gcm-random`: per-key invocation limit
Thread-Index: AQHdNlh9dzLuE/sXj0GBMZeEr3u7IrazELWAgAAy1KE=
Date: Fri, 28 Aug 2026 10:30:59 +0000
Message-ID:
 <DB3PR08MB9011BDD60C25C12ED21164BFE8AC2@DB3PR08MB9011.eurprd08.prod.outlook.com>
References:
 <AS8PR08MB8996C8D4732C4AE5806F7890E8AD2@AS8PR08MB8996.eurprd08.prod.outlook.com>
 <9a9ff56c-b8c0-4025-9ed2-3627bb7b3cf5@gmail.com>
In-Reply-To: <9a9ff56c-b8c0-4025-9ed2-3627bb7b3cf5@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kuleuven.be;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB3PR08MB9011:EE_|PR3PR08MB5596:EE_
x-ms-office365-filtering-correlation-id: 0b665e9b-7e2f-45da-0e76-08df04ef73ee
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|786006|376014|366016|10070799003|38070700021|11063799006|4143699003|10067099003|56012099006|18002099003|22082099003;
x-microsoft-antispam-message-info:
 ht7Xof1/l52cT43BbMD+sXvUkvMJLmwk/IisgVStSJumFrT+62+t/niS/EJUdePGCL6vnzu+Q0UCKP9/1rEBCahhAj2OpIegTTbXiCdECRJUrt3grfdY6cZlGDLMtEiqLjvLu2AaO4tuNBJNFtyfhl1PWNi42jtYOlGD0RkDXStVa+XW20qOMPFWvyx4fA6O6gLMmEnRnAX9euMHiOgLfLD+LppOEcsZo1Oi/qmVw0wov0mS4Ui4Auamlsd9+IcI8K+1Lgs37r0bughAQsZPkFWoaXhmrb//8eVlesIJPAqArcTc3BlDhaVfeFvmOb91ogq278xa24t+KKyFrNovrsqqicZ/qQrm4//4yEvSGapGvRghQPXFQT5Guyo1Ukyb0SjBq+AkHRudKcYEl3uVKYdmbd/EUf7wC2Df8I7iXRztKepF6pqN7+k2y8fSkEOKOKlbQtWi8J5SKFIgyg2upBuU4Z9NLMB4ZUWLKgXheWzC3ZI/yhpbDXfqK9bzkfX9f+1a7tqR4kj2Ul1jj+fQzJD7m5lX/pEt0ZAkNjVg/8ToVotTQH+mnWD1BK5wDMRjiFLvF2u2nPYZLL8Yh9U9XUUuFMgOoEBDXkA0+14fvVPefn076fqz2+wN+VVBITlLjbzasfxYhT5NyAGNssNrWo/p6z5vciPhXt8NSI9zZ0iZXrX57bxlsl1GRlfeJczYJsROgzUylaSICUlGxJi5RQiGzLc7hfGdGcYk9SR2bl0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR08MB9011.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(786006)(376014)(366016)(10070799003)(38070700021)(11063799006)(4143699003)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?nn1trIaKHyfJ6HGGgQ5XD/oz/GenYW80iiOtq8CrPi4SeC0Pwjg3zJ/dP4?=
 =?iso-8859-1?Q?lC8vmeXuO6De/XPKQXuJrXmM0Lgb/SuhwC7eXvZlq7N4m9HRtpVxgId72y?=
 =?iso-8859-1?Q?rVy1hUFK2MnwZFHxdyIAlTCF8C53sXclF/1DTJ5+kFDdStwiW6abawDxoJ?=
 =?iso-8859-1?Q?B3ChcHUvneUntrBpaMjMBoDSieqXQF/8U7t7Iurag4FZjx8LS2yecwdJi6?=
 =?iso-8859-1?Q?o10mIYC9lrxhf71b8shVZf7BnfeNy+59KnSFOBeIDD9pxWOQ3vuJOb6fQO?=
 =?iso-8859-1?Q?Zqwlr2VR4/7MVr4b4bv6ZAKmtl3IxP1terfyr0wK6t/1/B8JnH6skDjXmH?=
 =?iso-8859-1?Q?/zqFfjfUcj0noG0cC4T3+78ftv4aG10pU0LPmiVLg3fj9Y2vkjywUETDy/?=
 =?iso-8859-1?Q?TB+uggkJLvQ95D/gmnnI7VL4rEE4jQZvW0P1ncjuypJAe7kdN1iJmamjg7?=
 =?iso-8859-1?Q?QEqR+GytEUbueqK7obBjZgN+Ovg8Hy3lSQD3llAk5ia0hqmgopccP1xkJb?=
 =?iso-8859-1?Q?N/EGVrRZyf7zTp4jffchy2znGg+Jkts0dsEZkJeUyrrj7CZmSCjuGx03QH?=
 =?iso-8859-1?Q?YNZ+Fxixf5Ed1tN19XNzgpiyFZ/NG5DCtDL7/80PP0kdtiAZq3iAr54r83?=
 =?iso-8859-1?Q?S0Imk9IIG5c+yzU+DH7AsMKHgpFjxU6O1A/CMCMS1qpzk0M9UEL9DtEp5S?=
 =?iso-8859-1?Q?luLZLU4NTXJyRUUy/BHoGAzvZz8d5APFIKX6VKd7wwuS/ynKYgtHDB07B4?=
 =?iso-8859-1?Q?GyEud1Q/ld2ffCen5TLXl4HoENL5fEKQSMvlC0SjXGqLyBl/Ye/pVqEB/8?=
 =?iso-8859-1?Q?iDLYawuqpU/xanI1oVsecIvbhUCDDRMqStMPcXPLDbHIxLhkNKbzncKAwo?=
 =?iso-8859-1?Q?tPeHW8P4xut8bSx/nEDo+sf5dQRWHH/V1ImCaJiiEbAU/wbNtQosc7DVc9?=
 =?iso-8859-1?Q?HdT/vOxoWITLEKGCCb7qvDBXu49TKrYxkpPi023hJxTnAqaLWBX3FtIOkB?=
 =?iso-8859-1?Q?5mMYWT1jT7EtcHUggQ3gEJdp8KI0Sx6rt32MmXuAM/ipyamOSiXP4IHFZj?=
 =?iso-8859-1?Q?bk+8SJuoTLRDtXGrT1myECzxWqPpgdn/pYPTW+cW9s3y0sP9KDw7agCk5J?=
 =?iso-8859-1?Q?CPB8rYNtelnTqJSDI3QaLRHu2raq/VSU/VWoNMWSZa/5I84XJodJorR+qm?=
 =?iso-8859-1?Q?eLZ1cooEoyHISqzYZez5ImOdsehm3UG47O/7iaNsy63TibNitesa8b0jOY?=
 =?iso-8859-1?Q?dIO+LLONusHvIwFMBrlkuviQ1d0WmMk5tcoa6sz1tpEB8kWE+xSZ2nhANW?=
 =?iso-8859-1?Q?8jMyAP+dY3rH+3c346ktiYXC0AcuqwLBQYOjc4MWVfB4cSAwwU3acSur+c?=
 =?iso-8859-1?Q?g0n7AWavMzwOvlt/tqieZ/7UR+vB7rrbbVkLAwt2fTx5IHg+kIzaLIqlCI?=
 =?iso-8859-1?Q?H7Sl+In3EW0zek0S4+aeG8syzx9ON1I1ybYW9kVo4harcdc0S0x1QGu1iZ?=
 =?iso-8859-1?Q?wdaKSMtykvqFBMD4Dt9JDXfSTQDPV831mc2HK2tNaajNUawrp05amwCEPe?=
 =?iso-8859-1?Q?kvUG27PR7N5WuTkwdqZ/qifAvp1/d/t5VGPtAdT4+MWrhr1B6Vg0nRu3E/?=
 =?iso-8859-1?Q?6xPcG1XBL7mGbkwAHBrGDf/yaPLVtGzVuRsbzKDP1Cc1FyXiQm4OKiNA2r?=
 =?iso-8859-1?Q?NX082p367YF4ERqZ2CsSvHiReR5UkNJG1pHSPd4lGL10oGDZOQVm9crbGn?=
 =?iso-8859-1?Q?sistJbaX1JO3cjZpd/IuyXKwvdQKakCHU23CGnUUuDD37ipMIU6O2fBLZj?=
 =?iso-8859-1?Q?Tg91qDcBY7A2ZjiEyiluBFeGKrKUmEs=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: kuleuven.be
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB3PR08MB9011.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b665e9b-7e2f-45da-0e76-08df04ef73ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2026 10:30:59.7438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3973589b-9e40-4eb5-800e-b0b6383d1621
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RiW9iEYb+fv+IMsmAmE8vrnnS9/XT2hvqFSDgXRN5m5fkoVGmDq0Q9yA8MgX5YNny3YCflrYv+fDFT6uQL0lmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5596

Hi Milan,=0A=
=0A=
Thank you for taking the time to provide these detailed clarifications.=0A=
=0A=
> An attacker model that can record all writes can easily replays individua=
l sectors,=0A=
> including auth tags. It is just not secure in this scenario.=0A=
=0A=
Understood. Our review also found that the current setup does not provide=
=0A=
sufficient protection against an attacker under this threat model.=0A=
=0A=
> If you want to help, then please focus on promoting better AEAD modes=0A=
> (we have AEGIS in kernel, for example).=0A=
=0A=
That is a fair point. We appreciate the suggestion and will look more=0A=
closely at AEGIS and its existing kernel support.=0A=
=0A=
Thank you again for your feedback and guidance.=0A=
=0A=
Kind regards,=0A=
Shukai Ni and Jo Van Bulck=0A=
DistriNet, KU Leuven=
