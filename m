Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998DB22079
	for <dm-devel@lists.linux.dev>; Mon, 27 May 2024 07:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716796134; cv=fail; b=e6jCY86qk9xIpiHTNFwpgPif4c2pcTuFd1QtP1MT4cAFutxl8MGVAjrT0ETw1pIclYW0fDow07ry/qJvEyII/abs1RG9fHaSu/Ud6HnZcC5nHxS4vaIWmp+yWGbyRTN9tLPhyH1ay0O0adoCp+tcLy/XPa9pi7GpS4YVr0CXTPY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716796134; c=relaxed/simple;
	bh=ceCemzZCXZsy6Uwz1SSmJjFTrRXDb1Hcnhy+mlGpKlE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=R5CdhpQ6hidiXXSyC9ANuE49VzB/3sBMsEHaSoXSNQFoM1NZRNPD3qb3bbkdhxbMEibz52i9RqyaDwbwHFFfgrVVGUKmC0aHHzp7DFqAtGg8jpVPrrrTsoVJJdz6jdNkGD8jcq3/OhIuV26eqQmCgVhXP46IhKr/Uki7yGPXSHo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=iv3O9qzB; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=HExAzpki; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="iv3O9qzB";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="HExAzpki"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1716796132; x=1748332132;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ceCemzZCXZsy6Uwz1SSmJjFTrRXDb1Hcnhy+mlGpKlE=;
  b=iv3O9qzB+cxqWFaHWM4fd44BgOVa2KhUWTYz/df0jFzvHzNn9QhERaW4
   X9abvV//rj2CTDDUZ2bM7FLSsnQgYjbXY3isaWx6RT+I6ktDszngewrCm
   6UzevUoPTP6ZMDd/QjEyvyr/PkYEgkQWGu8NzGXQ+hXPT7XCUfYmnBzVG
   1zgQu/3mHEyqyQXOVfR8k6u2ePpZr00em2Xnmqxzw8y9IjfFNPGcQyhgA
   nhG4/WM/8E7avbfoweLoZvmjqD2qpE937foZ2zuxnBfAyzA48gdn0GA/7
   1XiexuhFS0oI+RLB2iOEO4B9LL6WSpHWL8rW2Kg8GS04v92I53D9rkf6U
   A==;
X-CSE-ConnectionGUID: ChPkX9rqT3uWpsAT4dQA1Q==
X-CSE-MsgGUID: +H+GD81WTESemk3qyIcgiA==
X-IronPort-AV: E=Sophos;i="6.08,192,1712592000"; 
   d="scan'208";a="18169500"
Received: from mail-bn7nam10lp2101.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.101])
  by ob1.hgst.iphmx.com with ESMTP; 27 May 2024 15:48:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DlUhkJa/ixyrhPwRnmbp70HJJLzPi5QL+E3MgA9rtuxvyBomXiJR4JmHObgBV64vvbcN2VSyViYdnH8FslDqk/4vr7VoXS/fDZ33MbYWaokuhD1jEOxbToh8fEJofbi67MqWc8Ao3A0pQoLHJZihwA1P62CMzpN4OOqv5x5sjyuTvZE5/2rqAbNmhf19lzXCHwFKyTbmnLSa0dd4PXst8VEhvFNWql2NsDwP7Gd29bI3VC5g34388+ZjJb2ChVz5zPH3OsM6acXKEL8+JrPzrOyxUbuMdYlh56m0L09BEfxo3M6Kr4WOqolNcDz76HTpK1uuxKvFv8yHXaIMHo5YLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S0tb+oY0295OTlfi0bEjSTib2vvTLreK/LxFMcMjnoE=;
 b=YQmqoDKBD5GAme1S2euDur5WS7lQv7lzSk1onVIxrOaR1bx1x/Tv+2Iw10s2rV1k0kDtaZ+/YyZWaKW5MpPC8OCyLsYCPQxoey0NR6BYFU8t1P4j5FauYoYOJG/GRqLemtajO/Zi+mKzEled3XftS8wt4uAnwuKAETGq5QgwHsTf8iTQQr466KLL8Sq/dnIUjw/0gsjLPTVDdI3yypW4FH/pnmDmVU8HaDFY/6MBC67diuF9RGYmPl6HmDyNVzf7dEPXu6oK48xBQRxXXC5dbUizteConmRgnynks7wPl05vAgJ9WnRY964Nobb4351LtTbrhmk1ptvNmLZlm0ft+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S0tb+oY0295OTlfi0bEjSTib2vvTLreK/LxFMcMjnoE=;
 b=HExAzpkicmjPORvOb/PZffktM50MBD/Muv5Gt6zsgQSWz6M+I/UaZ5fej0edYw+KXblU9JfHJf4BgAmi+x4aaJoJGhTJkBk5PTVaESExo6xZ8jwdtWRCrEhSrcvJoLlkuG1Cm53IMPuUtexQo4EU4qTHEhtDNLfWoGVmyx/Beug=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 DM8PR04MB7799.namprd04.prod.outlook.com (2603:10b6:8:3b::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.29; Mon, 27 May 2024 07:48:43 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%3]) with mapi id 15.20.7611.025; Mon, 27 May 2024
 07:48:43 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Bryan Gurney <bgurney@redhat.com>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, "snitzer@kernel.org"
	<snitzer@kernel.org>
Subject: Re: [PATCH] tests/dm: add dm-dust general functionality test
Thread-Topic: [PATCH] tests/dm: add dm-dust general functionality test
Thread-Index: AQHaqs6ZWevFxwsTIUei2Iy08nz1PLGhJmaAgAmYkwA=
Date: Mon, 27 May 2024 07:48:43 +0000
Message-ID: <civjjqrnv4l3xwwtzcv67xj2e4vbf5e6dzmtbkyfd27jvruopl@jrlogbnvgulx>
References: <20240520155826.23446-1-bgurney@redhat.com>
 <2yvdxcpid6rvi2us3z3hxxgeyvp3zfv4cgqxkd2rubp3rohmoj@6gvleke7iae2>
In-Reply-To: <2yvdxcpid6rvi2us3z3hxxgeyvp3zfv4cgqxkd2rubp3rohmoj@6gvleke7iae2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|DM8PR04MB7799:EE_
x-ms-office365-filtering-correlation-id: d3cd17b9-21e9-4b89-27e1-08dc7e216eb2
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230031|366007|376005|1800799015|38070700009|27256008;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?j8cIv61VHiFuhD6gdj2QWcZgxUuGOg7/8vE2Gf+0XFyK+omTjF1JT4hFheY/?=
 =?us-ascii?Q?VXAYbhtOAiBX+umvlieypUBsZlUTUk0vXzcT1VMzWBLxF4xZabEmHaqTm9GF?=
 =?us-ascii?Q?bEAEgyh16D3wAs8gZpHWzD4LHms57OxQyN5RHw3Njb1B/djzM7InArWKl8eO?=
 =?us-ascii?Q?aKzGepBla+PrQ4oZofaWv0lhnkXfDLwkViJxPFHe6qgM6Tw3IpzcEHQMIxa3?=
 =?us-ascii?Q?f6P3dcu6/Av2XKOD/vlWBP6knWku+PyLStRipTavLyasDPrbGFQWaZZfiMRv?=
 =?us-ascii?Q?tvbG9Mem4rBFCWb9t+61i1xqCshIhno2x+zYX9OT+p7BAJbYzG4sD5NPHRbU?=
 =?us-ascii?Q?kWqKfa4ZVULvWus6DL+Od+FaXMOp29cRWzU2bglNirOYcdpvIp7JYnROZY8d?=
 =?us-ascii?Q?9lSR30x0twMPvQ4dEUesYAQBxNUJeCj4Qstxf/5r5TRoTEnv2xXEp/BQ666b?=
 =?us-ascii?Q?rOeMIjWwH48dCkC0OEd/JXRVcObotpdf7HzvlIV3DMIJzebRiYEsKgGeFocl?=
 =?us-ascii?Q?hr3Ug5eLvqSm8ELZuMfxqhN8zuj7CAtNAvTABp29T0p+wiiHgU57io2bDI43?=
 =?us-ascii?Q?uqtu2hxJSwImChTSZp18k1NiphHoxjBTinORw4+3sFCAU2eFGwbGCJdO8gVk?=
 =?us-ascii?Q?GdRB52+M3aMINeigqBAGdjwBv8dUO1ZxzKZ6bvdV5FkV6iXLiSBEU5QzJaID?=
 =?us-ascii?Q?bUoPApXqYrwNqME0iEpDRixYmukgQ4eddGFcwQX9hUhsOrPd1RvbTN0JbTZC?=
 =?us-ascii?Q?cu/5j6qH78FcukSarD+6YPdVS6Wim8afnn4g4DNiVlBn/8RyW4AN8loM9NWh?=
 =?us-ascii?Q?DGIb3HZJoXjThRluVfqIjtnF1ka0JDBSbfvuxblbmlY+gy2Gxy0rYOo6ehH/?=
 =?us-ascii?Q?1XF45bYbdvpta7lbPJAlt3C1FbTlysUthi8wdMlxz19qQAcaMD0iqbfv6nqa?=
 =?us-ascii?Q?ZcNlYubBuboVpW3Q06oKNEec5cAc1HYSRtvQkJSIsTjTudpVsF40NbkLBKZ6?=
 =?us-ascii?Q?imvcA1rEDadg7CU8zYfzDpXpmKoZRdLnhrVndZyGNzwePQ3rUesfoziSwQN0?=
 =?us-ascii?Q?/yVwEIbJtEPhn2amrLtjXlEpl3PhmyECL35GAC1/lH528/kOHJ8nJqI02MIm?=
 =?us-ascii?Q?GnoZ+89BhLyxulsuqMBk16FZs4e1JJWd+WrAa4iur+Fbam0u8HZqBHjdmDqF?=
 =?us-ascii?Q?kb5K83TAzTHku/UwQds9iIQ9NwXSQnq4cPU+iTRSk0X/tp29mkizxHnYdTmj?=
 =?us-ascii?Q?XF7dWWhcOt73aZpUz8zLA1K7ZMQx0vTCQ739OQlVW4JbUITDZCBEiTOxpydp?=
 =?us-ascii?Q?qPSQ5A9rG4mw6x/JW4+/hywJTolI0MA0YQUD1A8jpaubiGXe+Oq5iHXC/6LQ?=
 =?us-ascii?Q?MsG+pSY=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009)(27256008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?uxPE+fH/QqVmRLWioKVtcV5OYNtNwK6o13p0khXNjIfxkl5mcc9ZKJiVjIlw?=
 =?us-ascii?Q?bVC8zes6dm9p2lJS5Xmj5QAIK0Z6cizo5CdtOFz9QYlO7YbLKLI/SFlElNXC?=
 =?us-ascii?Q?jhDyBW0IC2tWhrqUBIsLZxAwjLhDsZHItJnIE3qvdtxuXJAQuOKmzm0KL3kO?=
 =?us-ascii?Q?AyrFwEe0+7plJcNFSOT9IbLSAtz0jNbAXcw1vQXoKVrX50LSomKzp5lT08N3?=
 =?us-ascii?Q?teuAS8IJ0vJiqGulrawW8+JP6YOkJk6IlT27BKrMpGzU0bwGYm50iu7/Sf80?=
 =?us-ascii?Q?L8nQo3n/FJ3DQpylgJsfwThB+O/LFUzMVuX5f9DZ/efUp1anIGmkil/KxYNX?=
 =?us-ascii?Q?TfTcVFcXtVV9mivG+D9n5N+5lIugLtB+XXEmRa1oANhcJ2eg2/4Gk3r/TfZp?=
 =?us-ascii?Q?pXAYSNLeVFSrPEwClcrkquVStv9hsCJWXBT3s0RjKMVpAa3jzjpdK4lo305l?=
 =?us-ascii?Q?1sLbpAWgM4xHwazBP+Hl1nFke05rVODjl8qivrKq8rVENfO3ATMcgqXdb2ai?=
 =?us-ascii?Q?y1evsagXhapiIv03RaHztKt92kIFgvV3VX64bLA6GwyTNLmCgkuS9nPOd2O9?=
 =?us-ascii?Q?Lj6ORoLHzEQF2x/T3PdqvKbIp2wZAkI0gV0IyLKrTYAlyAYhH9OUpn2DGApb?=
 =?us-ascii?Q?LHRw0Vo9hpkkv1IUSrH9J1uXDmbXsQd3ae6V2pLVP9QmotFNi+tZMknfJRL3?=
 =?us-ascii?Q?I0BFQDY2iY+KGuTi+RVlWYmv9FEnBDanO8Y5HA0ur5r1sY1/ifNKNoiZlQRq?=
 =?us-ascii?Q?GqmC8iN5Kt0+mt9rScY0Jj6aKZvYlUcyZC0mgVfu06oWAOADQQAEwDMASsir?=
 =?us-ascii?Q?qKDCYZv/pUB1dmNQHd06Jq1Hm7Zv8yE8xXZ+H91vDB30x69qrgwEydEdVXRv?=
 =?us-ascii?Q?2eM6QTRaYO8bTWNKszwTJUHa1BrSaSHnrIE+6DqcCwAtDE4SsJvMmM1VUmCO?=
 =?us-ascii?Q?ESk6YzJYl5V1aEgaTQGR2Y+ZuOt8WpuXq8DUYh4Y1csxEoZFD0GzRHlvqqBY?=
 =?us-ascii?Q?JP+b9Lh2SO6fU0XlKx5fU5C58eTDvLGTKy7LhVF0ubJvJEKskIAVZ6b4DSj7?=
 =?us-ascii?Q?yS84GA95dEwaeckTOzsgl9x8A5+/ISMM9OYZlF1HKHZJyxRClkASZsuoYD9A?=
 =?us-ascii?Q?1MwfSUoF61PaYB4tUmPIHaCi64Nsj3PxpH3Oc3fixw7yZdv66/fe8oq3/IBZ?=
 =?us-ascii?Q?mvwhcKY5fEZuTmZAl4tGGAdYPtOS3Xq20kMxTP2ZhGPh+Os+jWJhCI4LxTKd?=
 =?us-ascii?Q?7Qkrmd1nY5PvzQ0fbvwqF5dyq5HXOQyoK9xtBknQjghV/gxZ6VsIp3ojZser?=
 =?us-ascii?Q?WgE+RdK6lRYfRdu02+TTbZIX84cmQ1jllPSfoL8ywoqKxQ9ujh8/oKb6h16Z?=
 =?us-ascii?Q?8zBeuG/qSKZ94mYxTIPtpsdkUvj9UBz5cex+Bt2UUMLtz3eWgAlqVPL2HDEl?=
 =?us-ascii?Q?bPL134atMxHAiErUc9Wcdybd+sXFyBKz1DBkcbrHSTzsutEez6Cdl9+s6oNE?=
 =?us-ascii?Q?TzqSL1RJvXDZJdMdvkoGY0X9x9YbWhc1+SEZTKA6sp8QoxKDjujJynOXTI0+?=
 =?us-ascii?Q?Zd3XrOTr/2tOawPulmnp7R7eLJ69LzQPirjyincscUG2xNXHxdAY0TPgrNFQ?=
 =?us-ascii?Q?04Kpe3VnIwqlKPhOyqm8Ato=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <886AEB74F665C24795AECC9A921D238A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FtlcHsEmWdN3ibOFKouaWBL01QTSVoOpunUq99HGbJLrnv5SOGAbFklLsJizdtjVcWnk6IizdNLRERGQjredX+D5B5gt3SYXX1zFWbZLS1TvGUOyrkADlahHU1fM7lw7jFEKrvuIPqm+EkEy7B5gqiRkEh4f5Krr603o+5uWZ4RpZq7/pH2TH/ulx5epr6sRvungJLCA4v8a92obraIkCqzvjawpq+24SXqr3A7n29t3vKRhK3nhEDRL9xM2KkVIJcms/zcSSvm6z1ANJOENyBlqeJ/l+/xLSopFJt7E0SuMYxELc4gZbnnYvzwiiimTdTulDXRZmHQr75evmxOOZ3uq/HXzVYG1E7APmsMvbsGklh5sfAIr2f9AtVwGqvEbsSiWQOO73eemeLJS9S0sf9WYyFBq7p5GgnkqO/7eCbgYYsEti3MLd/GUtN9GJjGX3WQIzbN8NAKkW6dE7KfHzdzfR3dmWJu/Co/7lHQCkPBYfoJLLP4uCf+LXgLDI9uOblMUxACXEuHOY4MKwoMECQgpW1HhjT6wLGR5lbgrgcqMeB1QZ2XAQZmADSVfkds9yjTo2WRKf0N9eK2tl8GIzvW8SSf46Y0WSlw/0b+ZmpB+/ZUkLq7c7nIH/sX3CNJ5
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3cd17b9-21e9-4b89-27e1-08dc7e216eb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2024 07:48:43.5400
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TO9+9UHeKsss8SLsaiXmW6hbcpw6hFjrCJziA407rL0A0oWzaYItrmPIAcYwZtOj++Y5Rechc0Qf0Gv5R/nIaZKza14fofDJsCmrlDEJGXI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7799

On May 21, 2024 / 05:16, Shinichiro Kawasaki wrote:
> On May 20, 2024 / 11:58, Bryan Gurney wrote:
> > Add a general functionality test for the dm-dust device-mapper test
> > target.  Test the addition of bad blocks, and the clearing of bad
> > blocks after a write is performed to the test device.
> >=20
> > Signed-off-by: Bryan Gurney <bgurney@redhat.com>
>=20
> Hi Bryan, thank you for this blktests patch. It looks good to me. I ran t=
he
> the new test case on my test node and result looks good too :)
>=20
> Before applying it, I will leave it for several days in case anyone have =
some
> more comments.

I've applied it. Thanks!=
