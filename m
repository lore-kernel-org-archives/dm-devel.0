Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836B313775C
	for <dm-devel@lists.linux.dev>; Mon, 24 Jun 2024 11:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719228104; cv=fail; b=P8BanD/ViWqxddkfomfYuT2InL2ILV/sbs2V+6edpf0GZEzNxV+gZgQdGPJ+lnOorhBtq6420Qguu7nKwKYQGs1u5e5q4gMt6obnlqbDBmaNKU6o6JPD2zezyAhdFKoSf6Da9bzoVKURwxC89N6PdMd4yUKv+JEvDYdWBPphia8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719228104; c=relaxed/simple;
	bh=UgtKZfVt3wptMP+JsRA7WOztxU2OB6aRE8Uytz/PD/M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VhN/pXmQ54iqQramrUfPgAVFE5qkNAYkeacQNY3GLe7NOmne2l6SXn1o3mcJjDnUGUS4ohaa/+iEiGRjfbMCvknuRkFDyQbJopffVb4IHx5c0TgzW+PJFOV5wcuI8nKIW6cNK7QdItNzxmmWU2/WOb1SZDVB9Ir0aAwRkQXABBQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=AFTv/ez5; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=h93jftmr; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="AFTv/ez5";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="h93jftmr"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1719228102; x=1750764102;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UgtKZfVt3wptMP+JsRA7WOztxU2OB6aRE8Uytz/PD/M=;
  b=AFTv/ez5sDNggLue65/1B1tZgRyqmYy1VHl/zBZ9+H01cF1wtp9KijpZ
   cPQ/a45PWF4XauaPVFaCb5W6+YCEM/34dp+SjiWfDJCLhm80OTKlQHm9z
   Ra6DreESAHEwmvDXWvjL0KFdP8slNDqqNSQkFSTwuGw/lpnmXl/YAx250
   HurM5BCOK+6q/RYG7JCqbVp4jxK6NC4fOgK70qcU625aa9p0vB+3jIRDo
   yuFuv99Tq9oe1hcLPG6b9uORInfwXol2WMP+oII1Zd4+jdRhi69z0ImQh
   9pQlx4gIh4nkbP0rottUSeE271sUp6Lt4vzCpO1wFdae2DMaTJGNCreAw
   A==;
X-CSE-ConnectionGUID: IeG1AHy+SMu4HhTAuW3/kg==
X-CSE-MsgGUID: Ebi5oDnCQQaHxhQrQaK1KA==
X-IronPort-AV: E=Sophos;i="6.08,261,1712592000"; 
   d="scan'208";a="19566191"
Received: from mail-dm6nam04lp2040.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.40])
  by ob1.hgst.iphmx.com with ESMTP; 24 Jun 2024 19:21:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GkhDYyGWtdOGtbwG2kc4aTB60EFEmUWpW7K2DS3Pgtu43LCBp4qDDO95DN4srGoB0aiHIkROlxrNQfHbnM/3xWTX+Twm/UA1IQiWLtPXLpqtPy7mnW0FkLxWKj+YJKw3rWmvmOdIWKXPUDkh5CP4PtxTEqAWEXVd+2aT6c5dsNcJdYHsUFpQR0rnpHHrkCrQt5b/MruBzAYZPwOQARjlz6kUy/YFluIt/G10Rd6S21O583ut34T16KvVa3bdOFUcQfnT4KaE7gftGTCyZs+LhyyAxACuhQcCjBPm0ooqeQkxj8rI3/n2pj3UTJj7QBc3Ruf9zlY4iZbypzshcnxi/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PVk+whk53MYZqAtjfEYooKXd8R9p8Du45pMTfvwTens=;
 b=bUfch3s3VfHfxRJmf5/iMW/0dBXaguqzTgtsgQ+E6p9vRF/CKpFn6OAaPn98bZqSIYboUeMGiRkFf5KL3VMmmtAF8IbfyLqd/ah6dIle74K9sc3H9nynGN4fqmFMrOQKEPIKFsDB7xQn0yCCx6ku/RSwf3aN4sqYQ3lwVhs6ROxc1Tv3gMxi2w1fKgrhvfRq5Nn6VYffRDkICi72lRiTam5P7NYvNlUVyugpX4EE7p5YMhiObYyTD7+eZmUHtB3+ZYYDu+4UxQTLSkWwRmM7gM4Mv9IXf6Wcw09vqorvxO4VZaCdcxq5udjd5hCGQs0LddWmDHxe0yVZ08/ezJLMHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PVk+whk53MYZqAtjfEYooKXd8R9p8Du45pMTfvwTens=;
 b=h93jftmr6rI3oyQbE+2NovTboWPZtZg7PJm+o4S68/IoQUFcl7805ORyGopDOaRjQV6dMqpsdMLQUkUrDTCwnZnHtTIcOu9PKjUKOgdD2mNvwdKttFLjsjbgdN3vcOmly+ogciKTcXETMcZ8CaVQ6sYGsGioTFM7NHxi+wvq0/k=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 PH0PR04MB7883.namprd04.prod.outlook.com (2603:10b6:510:e1::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7698.29; Mon, 24 Jun 2024 11:21:33 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%3]) with mapi id 15.20.7698.025; Mon, 24 Jun 2024
 11:21:33 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "hch@infradead.org" <hch@infradead.org>
CC: Bryan Gurney <bgurney@redhat.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "dm-devel@lists.linux.dev"
	<dm-devel@lists.linux.dev>
Subject: Re: blktests dm/002 always fails for me
Thread-Topic: blktests dm/002 always fails for me
Thread-Index: AQHavWqPXCpPMpKn4ECcCs6HQBvzjLHGxlmAgAAB4wCAD6M9gIAAPsiAgAAsPgA=
Date: Mon, 24 Jun 2024 11:21:33 +0000
Message-ID: <i4skne2yegneuyuw7nqt2mziuywjwo2p54emgba3fjcg5rflhe@dvqy65je7boc>
References: <ZmqrzUyLcUORPdOe@infradead.org>
 <pysa5z7udtu2rotezahzhkxjif7kc4nutl3b2f74n3qi2sp7wr@nt5morq6exph>
 <ZmvezI1KcsyE3Unl@infradead.org>
 <42ecobcsduvlqh77iavjj2p3ewdh7u4opdz4xruauz4u5ddljz@yr7ye4fq72tr>
 <Znkxn7LymUjD3Wac@infradead.org>
In-Reply-To: <Znkxn7LymUjD3Wac@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|PH0PR04MB7883:EE_
x-ms-office365-filtering-correlation-id: e7c253d0-b56c-4e0e-9400-08dc943fcdae
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|366013|376011|1800799021|38070700015;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?LCM1xoavI7nhjHXNI94DTU0aVBAbYGKzaWHawg6OIWrStek4vJfC1izrANzd?=
 =?us-ascii?Q?L+QTO+fKehfrAVDxRUqc7jLFFy2P5UDaMP1wikS1vpg87FYbBzX1eSogknP4?=
 =?us-ascii?Q?fJMrBYIPBa8nWeM38jvFkzzZ6cyh8sOOX8WiKg+Ac6hqpGw+6wWKjV2b+kes?=
 =?us-ascii?Q?7ghjGwIq+EV748WXr3YaNTBAw3nCe9sQL/6xeRmtM3iMw22g588XVgGVOTCt?=
 =?us-ascii?Q?4ZLkV9lOYhLx82SslRIBqeby20x0arVdbrwQqx/YLL1qzrz5gnHht3fujUSP?=
 =?us-ascii?Q?FYS4bvFDF6qpgoOqS9pk45w1FaJzk2ZFQ5/waOmr4kc3Wnqlx7Y6uok7fr5n?=
 =?us-ascii?Q?tpVkQegZdE7ydBzGb3rDiBMH8sF03jQsNi070gGLqru1VXHhsIsBDLek3bMV?=
 =?us-ascii?Q?z5xKWoh65v0IZHMRBhS7hQsPdDQkZ7se/IO/PfUvsXJwN483Vtykuaczr8bq?=
 =?us-ascii?Q?Okv1sR7jYAFlLpHeTwBWwsDKUIvDl/tqa3uW5c0cH8aOoZ5822Q9eXSsd8Ds?=
 =?us-ascii?Q?ckVKylAOrU1yKw65GNXDaNi+mJjB0NHUCHHcQtnIp9NSMf9Sj2uvvcFyQ1DS?=
 =?us-ascii?Q?owAo+sb4umUkitVRh1UGscjzkeUPQ5+IhzNtgxaoD2lO7bhv6ACRSWw9LbEL?=
 =?us-ascii?Q?oTTFDlixtjuGdtW/7Oe1Ybn47lHOnPKd8aE84p34flhCsn1Gzx7Ah7bISHxl?=
 =?us-ascii?Q?siTiamn3nuF160s//z0cRp+uEy53TgW5+vA422QVUIAM5GTLCvQlLS9mBRbK?=
 =?us-ascii?Q?7Es8y+6dYjWRw6bQNbGwM71x39cgRjIoUdTnbYKam3a7p/tSDa8EZh+e8jGw?=
 =?us-ascii?Q?olsSywGJsHsQ3b2tmFrW5FSp44xdaSnOA+cw+qzcEBjdDinnWm+ZzKUfo2dI?=
 =?us-ascii?Q?LUU6+Xh8RLFcGWPxRuN235ZM5euwaSbW8WsnSy62tVz4k/3KBbcLpUvAT9S5?=
 =?us-ascii?Q?ExK4IHSAgrEnnva9ne7db/t1N1Mp2HN+U+dirVgsz2gxfv05+JmZU1GaovqB?=
 =?us-ascii?Q?ID0rWzYqdQh6j1fW3dTHdz/92boSXUBJ1e8GudkQIjO3zbEH0P6qy4aTJBjT?=
 =?us-ascii?Q?Ct89h0kxdGkk+uCa4Mu+lwY+m2t4q4vos3/vosKHYDGXoyz21009Yqxjv8eV?=
 =?us-ascii?Q?5v7+GnRl+10tu354fjP7NxEgdRQnEDWdS7Xq1qhtvxSqZvBCoNiAJ+M2Yj5p?=
 =?us-ascii?Q?bcRFUCaezSYZkYQw+Bi9j3VJbyS9TkksiZYz2wXrtceb4ZqpikYVmyzozkEE?=
 =?us-ascii?Q?H5RfpyGscrl4QfTo9QV8G0BZcvqJIxnfSNGN+mp/FQVFLSae3uxGuX28W9fv?=
 =?us-ascii?Q?99WDMcDdmdJ7WgYQXW4O3FkwZL2E5D/lX7Utr2nu9ZumJsg7wNSH19zXXZFm?=
 =?us-ascii?Q?bw3WxN0=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(1800799021)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?w1Gg3KcDE5Qy2AfYtUrADr/QwV33RGwhY7TBcoY7UaoLaFxNEKmSqwbS+KuA?=
 =?us-ascii?Q?N+PZOEatk4Gsct+ERKeG7KbQmhO7cBzMAVVkSz+z2lnl/fQi2SSEu5ESXM9Y?=
 =?us-ascii?Q?W3e2VkptICGCdqJBoEn3ylvAjAwz/JV20Gmp/STyxfyCD7FkwKh4Yty8OJMy?=
 =?us-ascii?Q?g4+izt+q/G8Kwp2m5uGHSI7axeB1fmD/Y1+J7Txlwe+5beGYesV38vrtzfhF?=
 =?us-ascii?Q?frqzJX8hCGe8mxDQpTv4FxPoPmuLB5KcM2bIkM29vkl1ej/Imj57NoEkGBGI?=
 =?us-ascii?Q?Bk9WiW0V653YIl03J58bon2t5O5Idpk6XF6IF7vkABuUnp/ElBk93KCTN2dV?=
 =?us-ascii?Q?d/11XRVn40V2qPhqf/e8SSc7IdL655VyRxXVzz6OvKQKtSPQ3E+HtHXghDZ4?=
 =?us-ascii?Q?BeRONrynw6nWSkIzalAzmP7XkTdfuB/28HwsUvefvY18snvAMBkfxm7SChcT?=
 =?us-ascii?Q?NEQg8D8y5wKUCAWXEQHe6lBUnjcvu0v+ts/fJ4evtO0X+1Dqw49/Dvn85ty3?=
 =?us-ascii?Q?dqEPPN0gr1XLRTMMJ4D1BEOOUOjV9WcFoJzeR+cNm++pKvPGFAiSXkguZWNe?=
 =?us-ascii?Q?ur1TvWFZOy2HKVEZbw0QyhVXxrFaK1JlSsPoS7pgYDDzzUFLbsdUUtTHmYt+?=
 =?us-ascii?Q?J81hsgQ9j58k3+SNENFKKk20XWLpoq/q29TP0aU3jOjWB++rcKbXSjhUu5Rl?=
 =?us-ascii?Q?08zV3G1fYe95G0COZd9Qkq7kFfUu0wrVarLtXObJYiDD9VuMj3weEJU3GPtV?=
 =?us-ascii?Q?Ly5DnkugYGKcP44gOS0QyN3GIlZ3QrRXe/WxO8ZJ+Mpbad5EPQ73ZtgEAiq/?=
 =?us-ascii?Q?2ADgMxDVqBHz/M3vKaySAOqH59dXZ7VwXm0+DwMNH2d/p+VkhcAQcxJMwNSr?=
 =?us-ascii?Q?noI44S2lHDZN7zxN+Y6cAKgpUjq4kpkm+GPEYsz4OAYRgf5Dr73GhyTvxaUN?=
 =?us-ascii?Q?O5NYCyBjGgikbjOE8VLGrQP/6qr4DHPwiV/TwnyykGz1Z8lkz5tjGlc9a1yu?=
 =?us-ascii?Q?3cls5tCUvc1YHTt5ohY4MGXvT2EhYWsTBi6yjTAPdaCui2N08zSfjrvWZS6D?=
 =?us-ascii?Q?xhxaGIvCPCo5x8pdLIx07TIQR6uKYewF1WuEjnFpsD6JWqveBPr8H8gkEKsO?=
 =?us-ascii?Q?4SDaZM2CTuMX8jqGeTgGALo0YbK4iFgiE84o70QrRpulA9YPJu7DcvGfIHvZ?=
 =?us-ascii?Q?sbIzGUQgPj8tPo1JFd2A4ruOwk/TqMcZM9yERRxAmxiRjPl1EUD7d5XmRLdh?=
 =?us-ascii?Q?22MmhPM2pUvnieMd2QqyfZIz0OM2jL/l1GKCoCNbxIHRUuiqdqfcJXS6IMxM?=
 =?us-ascii?Q?maWOIWLZIa7oMRsYvpajmaa3Pc+gl7hauBhfe5c2Uc0x6q2GW9vJa+SVudzv?=
 =?us-ascii?Q?tZucorTJUeMWZfdfBkit0oRLxIn3ObAo4wUFIFwGJlHi0SAvo96UeE1U9fq6?=
 =?us-ascii?Q?8f+aWh0FIWI6oiEMcy72+SHE/vXg4I57+28KRtQDbSPLYxD2tD5TP+mJ2ij2?=
 =?us-ascii?Q?TLCoKxSimAoEjNhYbTxSmzdj8yb0vMwwsKxGpxHQ2HAk11PxhOsD2o1eZTpc?=
 =?us-ascii?Q?O/BL4zHbvtk7JRjzep2KJygMA1QZnta7dMGD0XrVVKmNatJBO2xnQyp0KZP6?=
 =?us-ascii?Q?mwSAWQjX/2zRCKs58c/qPe4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <05E85BB52445644D976BFCBFA883319B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	++OzEKLeSZyEbcbbJe7/iT46ENs5zAkAcnCVryqdFoQED8Iy8ofYQ6d36Bf+E6QldGi7uJDh3/3oAAtUxiXDFeVSVvLQY6S0ZGENveqBAaZ2FA82AaWflOagFRzYhN9Es3glENIbtbrravYPNW91/BXaZoZ97Hl7FxONg5E3RVJi+5mzThkw6NHxur/LGLJsav0MogK290c5x7SFLryGnlYmir/bLPUPnhUj/Lr+GgEUjJcV4IjyD6VwIUu3XoUprSKj9BDGT0II22ow9H7NYSMdf+cU9TA4Ml8Gk2dlwCjflqXtxacZ9BZK1FKN51GP8UFMirQoYV7Kd2d0IF6q2LPA0R19jxsAZCISeLsXODc2TxsseqV9FqICy1JEBjRfC9EZp7w4nqko0JX7OnxOvrNtCINlZ/4Vf8sWLcPCmKAqHyRLlyI0ShagFcglTLSYF804xC4U0xmlmY9t5e/Y9tEGG6p+dLHJL3SW3J9PlKU6hBZebFNa7mFSWGkErcnA9GnzTSmuWW7AA9WuFO9ii6VYtAzxb/aMAg7AOluphYVN+e5IrtzzdOlHrFjiMoUAPsOF91a6nC9mzRk5rM3wYUlfyLqPRw2wyrK1xwBtfeTB+vE1rGQMD7p0rxMGYKnp
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7c253d0-b56c-4e0e-9400-08dc943fcdae
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2024 11:21:33.4077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V8bCdlUT8HEA8riL3HlglUBLh3xX4Qy0eyCGqN6Jdtt+6FJHX9lK5F3Mt6JQ20wamjTQ15uHzlTslpJ6Obnu6EyFwhRNSfQy9ggSeFEfNao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7883

On Jun 24, 2024 / 01:43, hch@infradead.org wrote:
> On Mon, Jun 24, 2024 at 04:58:29AM +0000, Shinichiro Kawasaki wrote:
> > Based on this guess, I guess a change below may avoid the failure.
> >=20
> > Christoph, may I ask you to see if this change avoids the failure you o=
bserve?
>=20
> Still fails in exactly the same way with that patch.

Hmm, sorry for wasting your time. My guess was wrong.

I took a look in the test script and dm-dust code again, and now I think th=
e dd
command is expected to success. The added bad blocks have default wr_fail_c=
nt
value 0, then write error should not happen for the dd command. (Bryan, if =
this
understanding is wrong, please let me know.)

So the error log that Christoph observes indicates that the dd command fail=
ed,
and this failure is unexpected. I can not think of any cause of the failure=
.

Christoph, may I ask you to share the kernel messages during the test run?
Also, I would like to check the dd command output. The one liner patch belo=
w
to the blktests will create resutls/vdb/dm/002.full with the dd output.

diff --git a/tests/dm/002 b/tests/dm/002
index 6635c43..ad3b6c0 100755
--- a/tests/dm/002
+++ b/tests/dm/002
@@ -30,7 +30,7 @@ test_device() {
 	dmsetup message dust1 0 addbadblock 72
 	dmsetup message dust1 0 countbadblocks
 	dmsetup message dust1 0 enable
-	dd if=3D/dev/zero of=3D/dev/mapper/dust1 bs=3D512 count=3D128 oflag=3Ddir=
ect >/dev/null 2>&1 || return $?
+	dd if=3D/dev/zero of=3D/dev/mapper/dust1 bs=3D512 count=3D128 oflag=3Ddir=
ect >"$FULL" 2>&1 || return $?
 	sync
 	dmsetup message dust1 0 countbadblocks
 	sync
