Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E8C1429A
	for <dm-devel@lists.linux.dev>; Mon, 24 Jun 2024 04:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719205121; cv=fail; b=V2bUDpUGem3F0AQqtHqTsW02lUSR59IchepuyKJul9IVawOpEMF8Mnupo6yzSTol/F4HHkHAcV+iijkfgvXbP2jeIiPkuHXEAW280WoSo7rjaIs5n5r7cwiyCHVy33ZTy9jEAgOJ8fKVyr5dBDPRsCc7N4OAgXhJ5IhYM2+DXPc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719205121; c=relaxed/simple;
	bh=V9errEnOuLoIkX46RzFqAkSROoV4DCw/NYN6VToYFiw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qCgEhhCWFw2lsEuE4zHUhksh2Qw2uiSK7hJsshxjbz/wh8HWIj6dnbdZQd1I4Kh93qd/NTeyI0OenUczZTJkTJtPgZdBA3NAW/h9fKJ1Q+OZqfuIBx1Xk6UHQt2OqAHyp3Hpr+dSgcY6G+L/oKGnBgRkVK3mCVAuB9o4xZIA9QY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=M7gve/3U; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=IGw70J9i; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="M7gve/3U";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="IGw70J9i"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1719205119; x=1750741119;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=V9errEnOuLoIkX46RzFqAkSROoV4DCw/NYN6VToYFiw=;
  b=M7gve/3UzZ8ys+o0jNWtAeFsg1kZNKdSYJ2f4G/N4ws0wJfyrs4B2Rik
   20A4nrEXC+NVcpvaurjSHkMbmGQJ1F8voG3Ic705VB0IE61bPBCfgwE40
   qO97yWkNLpMeZ0UVUKcvBR2K7IurCi0JhOBVxVFJMSo/VtKgdbBrDf8hf
   9VRZjj9lzUcTCCaoV5M+EPld01GFnZ4L9nb0tCj/ggX3H4uHIQdDst9jm
   oKHKC/wEFZZJyodAGWnPyRgcgP+cdaBwWEtDNFW3aaNlaGN9ZQ7WHOZMk
   I/mtB9N9Vj/skCk8BNzJ5clKeZi2eKMeZrp78muc6TA17vQTsqSW5qRyy
   Q==;
X-CSE-ConnectionGUID: HgWHAMIjTKGNKoqHovyHIg==
X-CSE-MsgGUID: 0qLaOQfYTaK59Y6F4Xhiew==
X-IronPort-AV: E=Sophos;i="6.08,261,1712592000"; 
   d="scan'208";a="19878331"
Received: from mail-dm6nam11lp2169.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.169])
  by ob1.hgst.iphmx.com with ESMTP; 24 Jun 2024 12:58:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ghVR5co8FLRD9czoDfy5BAWnXCNIaJTXOUH59q8WZqW+kcBD7RZjfpXCPrCIpDy9GUrl0HCzvH/kp8tR3FCVuP9peDPKkgXb3LyxVYUJgSCUQT88S6PlmnB35jR7+NW07JmVazjlH2k54j8avafvhqReibf9e1rAJij4k27t4aKbwRp6Hnxf49ftsDTnWgdktAga7Njrbsbf5ZGmGGbBryfUAk46TVA3gQCV/ocJONnZi6r9Jj6624B4K2taauvYS5AESCE2ttUc8iKPcK3PZXx0pJD8gcUahM6HwAFqDAkEx7m9WlePdujmTkUUB4VcDeD7hLmVEkrWpvcKShOrQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QbD/HjQEhyzYqx0G8E1qC9Xzv8KwPsZtEQBHJ3u+lIc=;
 b=ns6TrtBH0od8cRgczPfdPAqTfuHSn8ZP4pFukIBigTf6iLZ/xZpeJd/kIzrNyup8uxgK3cFETQ5qHekRyVmSx9rFc3/0V042zjoM/nzfkE1nSBsDynOJTROI3qHX/tYo/mSKQZ2FxgixRlxQTF/axY99Hn+7tjoGxVPsEUhnY6gIFmwBVa+r5MqLxW5xJGTvZ/br4lbJRPdY+sIcMiRXZqWzKBAMmrRHoE/KrEaMMKYJec7rUcXQFbGe9h1QF+kokt51HW57aBCJhSTKPQB5UWNaC50nZEj14JW6a1cQ3fd2Cf/vP64CDFoOS6SEaIu4D5VC6+GFX15PU0d3oWUj2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QbD/HjQEhyzYqx0G8E1qC9Xzv8KwPsZtEQBHJ3u+lIc=;
 b=IGw70J9iOULQ+SFS40dtF4cHxc0TMPxC7887Wa7a01GktAv2LxmpozunDPmVDdO+HGNEW0F8PrZHnOoyVwfbVsLze2l4PjiOvRvMi5mQVzAG/5bhZPeGnoKrI+1gcwxzPIBQ0eDZSgIwl6nYDaNsCX2rVnVkagXrUWojhVZgq2k=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 MN2PR04MB6991.namprd04.prod.outlook.com (2603:10b6:208:1e1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.29; Mon, 24 Jun
 2024 04:58:29 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%3]) with mapi id 15.20.7698.025; Mon, 24 Jun 2024
 04:58:29 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "hch@infradead.org" <hch@infradead.org>
CC: Bryan Gurney <bgurney@redhat.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "dm-devel@lists.linux.dev"
	<dm-devel@lists.linux.dev>
Subject: Re: blktests dm/002 always fails for me
Thread-Topic: blktests dm/002 always fails for me
Thread-Index: AQHavWqPXCpPMpKn4ECcCs6HQBvzjLHGxlmAgAAB4wCAD6M9gA==
Date: Mon, 24 Jun 2024 04:58:29 +0000
Message-ID: <42ecobcsduvlqh77iavjj2p3ewdh7u4opdz4xruauz4u5ddljz@yr7ye4fq72tr>
References: <ZmqrzUyLcUORPdOe@infradead.org>
 <pysa5z7udtu2rotezahzhkxjif7kc4nutl3b2f74n3qi2sp7wr@nt5morq6exph>
 <ZmvezI1KcsyE3Unl@infradead.org>
In-Reply-To: <ZmvezI1KcsyE3Unl@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|MN2PR04MB6991:EE_
x-ms-office365-filtering-correlation-id: 5a746954-3ec2-42bf-ba76-08dc940a4a58
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|376011|1800799021|366013|38070700015;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?Nt2eHSuEnnXr3RtZ4oxRMiD2l7m/SqnBV8VVbkdDHPsMBl1Oz1KiD2yjL9qT?=
 =?us-ascii?Q?2+mbbkU2WKf4w3is9HALPnUYS3nB3H87g5mVgm0jiXO+PHhIXzNB+v44drcr?=
 =?us-ascii?Q?L7X6LU6RRfMW1S9RZHGiPhk1uzNK7OmjHl/5J+OD0HM/97hq+TOPav/k4KQ7?=
 =?us-ascii?Q?oOowUGU3XgRPtHA5/qlH9XmRMD+YUHGiDiwx1yU2fh+1OhnHidkRiT7MHVKK?=
 =?us-ascii?Q?R6UJ2f8aBuC6r7q4SRGkyBsTZ2GiUMqv5myg1HyxJlQk6PxL1uDxFRZ8q/6/?=
 =?us-ascii?Q?oqS3lGs+7lpVnRvnOGBqlmHiz9tOqAfJ6V3ytlMz2alvKHscb4SKLJNjhs/o?=
 =?us-ascii?Q?MK3eeAojrifanf6X2iiyihNTZbydoH4jlaJodaDJtDoxwAMHGoyOkYQUyqRu?=
 =?us-ascii?Q?awbSf7N32Kc0ip6sM/cyrDK3PZHNsFEU8HXosh5KM9lxuA+I5kyHvbChwben?=
 =?us-ascii?Q?2KRn213RbrZwxJrimVXyKGNq7DoeoP9naVUQSa2966SgrwdlyTMs6AeG95W4?=
 =?us-ascii?Q?Y+dSGuBpoefJugMbD5VroZsy0SUf4h1jeovt6tQmLoQp571JPkw+otAvN5LC?=
 =?us-ascii?Q?Z/OriHf0+qn3SqT+EOLpvJGky4qRfv4iOolBzI4dMiE8VIl92Ia/Cvsvos+4?=
 =?us-ascii?Q?50vL265NReHIKaTY3z4U7iBX7UJGz0hcg+ECyy5z0jFmsW2chbDu877jrRyy?=
 =?us-ascii?Q?FhrTKGL2ED6RFFhqXCgR7mc+o4GxRsZQE/9zqpqYxAsAunSmp8XfAr0yVjMH?=
 =?us-ascii?Q?PMboDNljrXYAcZA/sy9BsvVV9NzCm2Y6tDwj6pF5tybhEWnQ2S49YeQSa9r9?=
 =?us-ascii?Q?bNmvQG3J6KJ59vZdhAaRNnv+6GvhXcmnBGv4rBl72lOyvohRatB/C1CPaZl8?=
 =?us-ascii?Q?Xm73LSeavMI+PTwfazf6p1ys6PKBeinm55o0Y1qdxlkt2XuIsT0GvnAyOMOm?=
 =?us-ascii?Q?hvJxsYob8MUtCZ50gmpK9Wiulls/jO8wHDOfNzL62kelw7POiqOaapk1llMV?=
 =?us-ascii?Q?akf1cj77Xyo15O4K7mvfYbpeGJsRMabV+A7SMa89p98eRJ8fJs3G5LZ8UvXa?=
 =?us-ascii?Q?iow7RXjZS3kDb8zeMSo7SKxII5ZhHtGK4WJiGihqJdyHdwHkaKSnFvvOlU8W?=
 =?us-ascii?Q?ta+u7v1Xg+0wAHxJLIM6REG6VboxhOohb9zdnepGGLl19HpaxWYY1guYy458?=
 =?us-ascii?Q?AGEY0VJW5DNmBSULi05owM5P9ObljnDsEfxso8uNAOI7WqeekARRx3tQ9vPI?=
 =?us-ascii?Q?nOmV7WqIH8xXmjHQUwfb8g+3rf3EkglzwG3weLGCOZbe61ERw9reOCROxJEN?=
 =?us-ascii?Q?q/plOoXzbiq+Q2GpPQ60sjIdp9sI4b6INg8vdjRWWpZRq+ubVri/9d/6L5vi?=
 =?us-ascii?Q?jl0B/8Y=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(1800799021)(366013)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Q8TLk7sGIrxRdYRAhvWcfBA0TzyUVVqKEBxtdlOTJszHNpPoGNXmsFa0r5cN?=
 =?us-ascii?Q?zGy2lAxyJgRjfvVVRhYU0R/TXHSXOXBGaB9wJykVcDfHJrlb/lXZLw59pBMy?=
 =?us-ascii?Q?Q/sLTmYhpXd0j/zQVNhkfx5R9Xu1S+8PsVRO/INh9bR2UMK43sekgIiXuPpw?=
 =?us-ascii?Q?oeZx/fm2kARpeIEnbWhEU6sVeD4LxZT+iYMP/KiHhFU7mMejnAF10LtKIKr9?=
 =?us-ascii?Q?/zx0j4XkLcrnSOdA7l7lKzob3lyUi9DGSxsdMoadv4E+njlkvq1EICXX4p60?=
 =?us-ascii?Q?eH69Vxs6DkxZo1DDlok24ihrutZmtgBdJopMXC12xK8jKWTH740kB5nx9uD7?=
 =?us-ascii?Q?i1XedJaUgDd1jq+VkBrQVWwAHC73gt8ouizXzucLLpirDDVKH3+ueX2rmIti?=
 =?us-ascii?Q?aTGGfTdd7ynBsWRp2hAQF2HosDEJTtyKU+0RrzMtcOHFlr02tYU9bXHX8wrM?=
 =?us-ascii?Q?GcRQw/BsFVRekfd0ZBHEd+LwRKb7IJJAP7/S5wAPDixDg6aPRdhAKBEV5caV?=
 =?us-ascii?Q?ilkj8viw4aXgiWAacjSMD5i2uRq/bEow1OU0quT3quBQmxT0U9ZUzsT6X4VD?=
 =?us-ascii?Q?5D5KkLI5NdaDQ+Af8x5n3XDzjEs2fQvjXi3usj0KZ1HylEqes4zSUK0GhZnZ?=
 =?us-ascii?Q?g27bkneqcwwMCSWvQdGnJ1LVhA/sS6Ih2zZgiW6OYBGb95BqlwV5LuIB+Aj8?=
 =?us-ascii?Q?NatpAqH8BX/PPJuLGmkFv8BoB99bwmT91XlbcEp9N9uj8RwHTPm2VWKJNxbi?=
 =?us-ascii?Q?zqdv729KhkA0lp36FjunPsBYQ110yzW1C8sxr8rH7pFejAkmDLUNKxSSr2dm?=
 =?us-ascii?Q?dOE9BksV0iIH8uRW+rXPzZ170OSc7bExb/fVcWEMZ0H/IajtFCuFLkw8ifle?=
 =?us-ascii?Q?+1x9TkYSON3aBcMcYHhBdKgo0S0KgCNwX7XubPMEMHExjV88Kr6/hTaLksT7?=
 =?us-ascii?Q?7r6fkfTGczdL8Tu/FWY79OyvrDHrRX5/kgBAHbJSM0dQLLaooLD8zR+x3eYz?=
 =?us-ascii?Q?O4PFcNxy4cEUuV/dqz//Gh3ghiudSjSK+o5QILOKVPuUp2bVuhd2GCZZdbSD?=
 =?us-ascii?Q?z4kGcKvSj+5mExgMJf0j58XUmYM/YA6OW4GVRJ0TI2es5EKToWG8rg24qncF?=
 =?us-ascii?Q?Rl7UlbMSBuuEX1H/pkA0XTEXXofI8nLujRq47hYMNMwcZX53d555CQ+Z2Db5?=
 =?us-ascii?Q?9kF4riFM28Ooep8liKzrZM4y8SQov8QDVeR9B1WQ45CWTuw3P/LgBgttVT9V?=
 =?us-ascii?Q?7Gxgd1G+k1eTT9ucqKjXOWzl6XylPZ+iwvi6AcJdppNndByOJ1XY8E+O3SeW?=
 =?us-ascii?Q?VS9xfJB7tI89ZUgu9ejALi5GHkdPDZq2Lt+/5H+PHffz3Cc9ITHBRRAEqypF?=
 =?us-ascii?Q?Nec8i4eUG3UiEHHNxq2eDYeBPZYq2teI/iUyL20+RP4+nhXUBfjzXBC2yiOq?=
 =?us-ascii?Q?4/vZFL0xGu0o4PHPUEsiGEI88I/ZjTeLvNc7gGGd5VgoKUPSUZgotVnOLN2L?=
 =?us-ascii?Q?2B5a+GgipSo+SI07D3Jw7EaZ2VK39jLoRffFk2WWVirmAYptNVPoTOe9w1JU?=
 =?us-ascii?Q?g//9qK6CRUHzxJC+iXQ5Hu1Ykm4B0AfoURCuNIx2tADb3956VDuFAu7WiwYw?=
 =?us-ascii?Q?P9S+R88GSdFxf9C6qdNad9Y=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1F019CD0B4218545B5D763BBB9C6C82B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2GkZNDf0kPU+iMxI+SUTkGwvdB+RIK6hv9ZCiCEUzsD+zo03l1AThToS8S9wlLdmaPjmXNTg1xwAG0eRMXPL0fGqPG3ZC5UifrqcfeudstCqmAx6KKk+jTZ7xHnKL69RA0j0iNDaDoTg1DWDajKPM/WQO1RKFTBdzQwwKBJY6297iuJJXRrQfoQrBCjZQDdvHyTaOJywt1QiDCoYCBAiT7qTjiZ03mTRJbqAv2A4/Oq9dndDtR4vVxze1X00oPby6zbckcCpefwcjMXqq3TXjAqIzJ1GaWnfLNM+LOEdRgM0oDO27W9p2PRkmnJTEk7N1LnjN3vDrn6I+2/CkQz4r9JEIlMjME74rkO2d/REqmUzMHNGhgy/zw7Dzn81NpIkNCf8d0KowqhYS0wqAWN91nCwgJZanwAw5HDg7Puus7xhW0e2ZiNmbGDV5KLXAb3dQikAU2AHK4snHLqXAqnNR6DF2XaEu8iOtDEKSttYy5Xf9X69ExF+IAOYK+iOCKfJ6OixoZa4hSczzEiof7wb3QVpTrLvh+oH0n/Huu19mLdz7Kqbiqep7/VESo5ec36juw9dCAVz3nAK3R0SIsmjFsAXGebPa4LA78us6qbbINwU6rDHqP7sy+jJSbs++Ml4
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a746954-3ec2-42bf-ba76-08dc940a4a58
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2024 04:58:29.7647
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2ObrexrRhl1HwrXFnpqglibHqWpx60srCKP18jQDrrAIo7UoZb4oEqvFOkwU3JJQ2IBRBnFQpCrK/m610QhIvuGItcF46lzVvD2HXCmg76o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6991

CC+: dm-devel

On Jun 13, 2024 / 23:10, hch@infradead.org wrote:
> On Fri, Jun 14, 2024 at 06:03:36AM +0000, Shinichiro Kawasaki wrote:
> > I would like to take a closer look in the failure, but I can not recrea=
te it on
> > my test systems. I wonder what is the difference between your test syst=
em and
> > mine. I guess kernel config difference could be the difference. Could y=
ou share
> > your kernel config?
>=20
> Attached.

Thank you for the kernel config. I tried dm/002 run using the kernel config=
 on
several machines. One of the machines made dm/002 fail, but unfortunately, =
its
failure symptom was different [1]. I will chase it as another failure.

As for the failure you observe, I have one guess about the cause. According=
 to
the error log out put, it looks like the dd command did not cause error, ev=
en
though the previous "dmsetup message dust1 0 enable" command enabled the I/=
O
error on the dm-dust device. I looked in the dm-dust code, and found that t=
he
fail_read_on_bb flag of the struct dust_device is not guarded by any lock. =
So,
I guess the fail_read_on_bb flag change by the "dmsetup .. enable" command =
on
CPU1 did not take effect the dd on CPU2. IOW, it looks like a memory barrie=
r
issue for me.

Based on this guess, I guess a change below may avoid the failure.

Christoph, may I ask you to see if this change avoids the failure you obser=
ve?

diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
index 1a33820c9f46..da3ebdde287a 100644
--- a/drivers/md/dm-dust.c
+++ b/drivers/md/dm-dust.c
@@ -229,6 +229,7 @@ static int dust_map(struct dm_target *ti, struct bio *b=
io)
 	bio_set_dev(bio, dd->dev->bdev);
 	bio->bi_iter.bi_sector =3D dd->start + dm_target_offset(ti, bio->bi_iter.=
bi_sector);
=20
+	smp_rmb();
 	if (bio_data_dir(bio) =3D=3D READ)
 		r =3D dust_map_read(dd, bio->bi_iter.bi_sector, dd->fail_read_on_bb);
 	else
@@ -433,10 +434,12 @@ static int dust_message(struct dm_target *ti, unsigne=
d int argc, char **argv,
 		} else if (!strcasecmp(argv[0], "disable")) {
 			DMINFO("disabling read failures on bad sectors");
 			dd->fail_read_on_bb =3D false;
+			smp_wmb();
 			r =3D 0;
 		} else if (!strcasecmp(argv[0], "enable")) {
 			DMINFO("enabling read failures on bad sectors");
 			dd->fail_read_on_bb =3D true;
+			smp_wmb();
 			r =3D 0;
 		} else if (!strcasecmp(argv[0], "countbadblocks")) {
 			spin_lock_irqsave(&dd->dust_lock, flags);




[1]

dm/002 =3D> nvme0n1 (dm-dust general functionality test)       [failed]
    runtime  0.204s  ...  0.174s
    --- tests/dm/002.out        2024-06-14 14:37:40.480794693 +0900
    +++ /home/shin/Blktests/blktests/results/nvme0n1/dm/002.out.bad     202=
4-06-14 21:38:18.588976499 +0900
    @@ -7,4 +7,6 @@
     countbadblocks: 0 badblock(s) found
     countbadblocks: 3 badblock(s) found
     countbadblocks: 0 badblock(s) found
    +device-mapper: remove ioctl on dust1  failed: Device or resource busy
    +Command failed.
     Test complete
modprobe: FATAL: Module dm_dust is in use.


