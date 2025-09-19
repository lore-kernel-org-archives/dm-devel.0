Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150AC2264AD
	for <dm-devel@lists.linux.dev>; Fri, 19 Sep 2025 02:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758250035; cv=fail; b=cKnQ8gxVVo8xDRzzbxCQWhv+kjrdbXB9tuYsjIsOqYksGpjCFfxfmd7FSVjA8uTtwsAEhl3f4IxAOwVcnnYOZuKI4gczKR0LlM56sYMHsHDU7F6E+S9dGq+eMnvI2zx8qixxXx5Hq0K1KGM83R+hgTy3mKQpMZvce93TqQ68Lqs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758250035; c=relaxed/simple;
	bh=h2/pDAonld5NmxB4ZU03Fa61MC16Ut7iRxNMNAODOfI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XO3YRdp5A3nVerB3elFGEJ8odnfpWo954psxTUxN+zQltYEkitiw/bmJpDqLdKDja5eQ5NXepf1L3MDowHX2dpjrC3WHYiAbX+MVEtBCQSOG0ynAgJH8yvFnitwh6E7nnsjcsZ2AElFNBYrl9Cb0Ewt9cgMeM69Bm0tPPsC7F/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=GCqaTtUs; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=nLP455or; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="GCqaTtUs";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="nLP455or"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1758250034; x=1789786034;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=h2/pDAonld5NmxB4ZU03Fa61MC16Ut7iRxNMNAODOfI=;
  b=GCqaTtUsLLAUxnIjHL5bGAMSbc5FA7WZowhdnsJHOT4OzbxN+/RYeWSw
   W6UzSOgaeQp0HVZK8lDM39GXj5r/uRGarphraV6sCBgKcRoPfBz4HJ4Zl
   627UKTizWo49Tm/HJOFzsj7co4ohPXulDsJdNtOZl7HZOE9t8GSVcyVuf
   s0MIEQs6G8S1c4NiiDb/OOInRCDo9SPcvMxFw5gSzLHLswntKrMrBmMgn
   rVzrqvbNztAE5bgzMl22tLCQn9+Uw+g4lCbHsJpR3vz+CYZSRGbV5lH/I
   nxbtBTCOz8p1TP5P1uYjZOY8nmJgyDb9OSgu/9b6j3YM3KsjQyqG4YmGu
   w==;
X-CSE-ConnectionGUID: WBdQ4UpNQlif5QT2hvZEeQ==
X-CSE-MsgGUID: +tXu19FkRN6jVMKrMWOaaQ==
X-IronPort-AV: E=Sophos;i="6.18,276,1751212800"; 
   d="scan'208";a="121191775"
Received: from mail-northcentralusazon11010045.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([52.101.193.45])
  by ob1.hgst.iphmx.com with ESMTP; 19 Sep 2025 10:47:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tpMK+ljb9OSRkIexbB0WBo1Ypy82FwphdWFqlLUNdJtwbSOEE52gZDcWurdcmfDdUOON5NhUalSNGdRdSzVu/PTCUAIHjfJShB+X4Rq3qUvYTRhLpIZzRcv/LYSPyBT6RuHPukQtRsFm7weWyx9tbz96h4AAcyjBcn5OKDaeSzUJJ6id3BIY0CgcYIbR5G4Bpr79lMD11+kKJCCh6k3wGH//ps8BXJ4i5PYmDqCVcIFbuN5VkiIlQm3PrYb/AcnW9kg0Lqpy2CGOSV6D+b5uurJGFMc1NLfYSCwS6wIM32qWErU7DdGrIeFftjFOdgyvo4z1ZstrmKST4WrkdVACKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h2/pDAonld5NmxB4ZU03Fa61MC16Ut7iRxNMNAODOfI=;
 b=N56fkqAvw3/mVVVg2WVlOTtk4SVMBQ6NNsDvexnI9f//kR7Vde2zsulRKZFs58rlyeEdGMKbDnDNGTnFM1ix4NVBcfiMSaNvcKzuzGB3kqeHHtIXRCYwHGuUxDU655ZJafVtZNvN+WqcE+oSvG5aOSvEvMu4/MDrEZyX0lum0CLQQ0I5mC8tEaNXT0ZlNTVi1nwYzjqhAoU5IUhK7BjVwY4UIEENzFbdAUhKZpi4+lLktAvzzAoB+2xmsB8pJcSuv7n9SY6IYIAuOQ4bip2Jj6Ij68yo2yEGbrsX6y4baRoPuZ5r2YNEt2V2WPO5Z0HdPCCe5sy1DIEQf/u4acwIZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h2/pDAonld5NmxB4ZU03Fa61MC16Ut7iRxNMNAODOfI=;
 b=nLP455orFY8v3aFJ/DLHkwIK+H4tcY2OINiHN+G9Y2eBYfnRrB2isv5HGAOaKup0Q7aGvq4nITfQXovVs0Y+PVg0ANcs0DgB6wwg4JS0+7kqYkcL6jPR2J0/Yy8KeMWPYFvcONV77QuXrdRh24+kRO5qU1YwpyZYUZ2hgXioSC0=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by CO6PR04MB7476.namprd04.prod.outlook.com (2603:10b6:303:ac::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Fri, 19 Sep
 2025 02:47:10 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%7]) with mapi id 15.20.9115.022; Fri, 19 Sep 2025
 02:47:10 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Mikulas Patocka <mpatocka@redhat.com>
CC: Bart Van Assche <bvanassche@acm.org>, "dm-devel@lists.linux.dev"
	<dm-devel@lists.linux.dev>, Mike Snitzer <snitzer@kernel.org>, Damien Le Moal
	<dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [PATCH v4] dm: optimize REQ_PREFLUSH with data when using the
 linear target
Thread-Topic: [PATCH v4] dm: optimize REQ_PREFLUSH with data when using the
 linear target
Thread-Index: AQHcKD8r2U1k6WeCp0+vmpTt9bP2nrSYypGAgAEEU4A=
Date: Fri, 19 Sep 2025 02:47:09 +0000
Message-ID: <dtyybrzcofyqzxdcnilxtglak3zk3h5ynjb23bdwf2vbg6ebzz@wapaafu2covv>
References: <20250910172742.187645-1-bvanassche@acm.org>
 <55e3a5e7-8e4e-3e78-1f36-4bd4300974ae@redhat.com>
 <bbd7cb48-a13c-0077-af7b-39c849c9f6c0@redhat.com>
 <c29b0abc-2443-4cc4-9c2a-a41e6770bb96@acm.org>
 <274476e9-357b-5346-2316-6a6dc2971dfc@redhat.com>
 <qxeldko7kx763qu7aj7bei5gikwczyzlihaqpdxq3affkmcbz3@v32xuyu3ls5a>
 <8e0be106-fcae-e566-8891-4272f6f0c738@redhat.com>
In-Reply-To: <8e0be106-fcae-e566-8891-4272f6f0c738@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|CO6PR04MB7476:EE_
x-ms-office365-filtering-correlation-id: 5864c788-9d18-4171-cac6-08ddf726d47c
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|19092799006|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?2fqPC2UNzEHie/mU/J3I4VSdSJl6OSyfIuW//c1xh8vGKX+L7Re+c4zlRPFh?=
 =?us-ascii?Q?oSxVE58+zeingFvhPVISv3wgOplmPRFINhmzfahKgCweDe3gQ8XG7jgmvZQL?=
 =?us-ascii?Q?sxWTaAse0NJU2t45PbU371fUR7fu0oUhXmWrqEflb9pqyqI3kHMRqfX9abr3?=
 =?us-ascii?Q?TvaFIQV0SYZSrEsZ+P9y+jxE8czt7FrOe4G9vPHIFVSPv7AkvngjfjOuya9s?=
 =?us-ascii?Q?K/gPTdgU48sYOsrt+i2IIesrOj4ZY68tR3P4VfJ8AkLRN47Ll0K1XU0Ov1UD?=
 =?us-ascii?Q?XFhoijvG09mWQq5ldh+RBOsvSuxxDd+TTDP2y1UOZ7wBkqvGqmKLZxvvKFdz?=
 =?us-ascii?Q?Sx1RXpZbNdhXhUmIZhicZo1NWEX+vF3bGzt0biTDJ+cX9sbfrzALa5d9cJW4?=
 =?us-ascii?Q?082iAq7MKnPuHuLHYOTX7bYU6RNgEv+eRj1cKZS5z0FPe+krXWf4EwYYON+E?=
 =?us-ascii?Q?z8l1RIalQhIsAcUAXi748cGpYO1m72QmVzsl3DzX45pi3zul6+N/odmfQsyo?=
 =?us-ascii?Q?ntx1cgmQFQIjkT1dQhW8a/YyDUsU4TncmhzB0LmIq0MV/nY551oTuMH7TA0k?=
 =?us-ascii?Q?QKx4u7taVzp2Q4MHG7uYnF8L0V9Ar0crqOM4xfZ/KhW9Lz0pGQCtdQNhX/Vx?=
 =?us-ascii?Q?2oWhb1lqszDnyUAwInxqaCRFE0ev+LLJZIJng0y1xVCFATRNOwhcxCmP2ekm?=
 =?us-ascii?Q?/6a1u8gkDuWHCTItFTKctmVhKSeT/ADA+O+0+IV3COftq+0CrjwkdFH9DCju?=
 =?us-ascii?Q?JUQs3CukcwERjuqMhX94ukS93R6GOEEMXCQFGeredsgUPLjID6OYVqg07iFf?=
 =?us-ascii?Q?qkpL1vlCbrbWTLVgFArx5v5XmVztTILeoJVX6gY86KuytacNH7c/alew3nQp?=
 =?us-ascii?Q?cPEjwBZjTdPZSdq/SBVrQfOFbMzbx2z3YsrR0zUjhUxkh0fc28CfGlfH2jo0?=
 =?us-ascii?Q?Mq6/imZv528JNI3F7tOlINOWXyQz52ZuRKFA45JTK6S6/aX8oySDF1m5owbH?=
 =?us-ascii?Q?Iaze4whviXLDQtcdfXTcSUsSJvygrawTZ/gifLaJaCGPqJKVD6OP2maMOEXN?=
 =?us-ascii?Q?fgcg8atO1hhH0bFjhW03hYPEWB4P2jkjy3uDnbAxg7ZgeR9jBFp2WOEzmZh0?=
 =?us-ascii?Q?bHbEcz672cd2CShvS6ssTSmkuNkuSvib3L13of5aBAczyiIoOGj745N5Y5eQ?=
 =?us-ascii?Q?XO/cMBGWTKIP73MU45JATsbQnMfdT0yxfhKt3qku88lOKrrVZRKlhWfZTc9B?=
 =?us-ascii?Q?hrkcfG+9vJnc6do0JOZTPMSew7DZzgCZU5BPRFXyaIFXySWKr1SuBpb42tRi?=
 =?us-ascii?Q?HAmkpkToUubCF6GGZ6/Oj5ek8kygq8HABG7dw4V2wnGCgPXs/UxvbzRP79c8?=
 =?us-ascii?Q?jW24/RMctzKf7dXKO8NC1VyWvXLIdSraXUAyBSKbPr11Ww/3ELL0mA+XVZ85?=
 =?us-ascii?Q?I/QvjwOHg7bDtkH7xnwSymSu7sBfCdYUlAcIPmhXQJSomJwBDfAB7iUrcTI8?=
 =?us-ascii?Q?Iz7EQp5wqmHFrvM=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(19092799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Lon5zqUmtG6md1iG6tRTdoc1ca8Syiv/kpmepZT3/VxuvMp6NwsRn60YWMLS?=
 =?us-ascii?Q?A5Zj/06ay82OMyrA9oXIcUwCZG4KKhQColPbeopl++YUYNhn0d9S7DlC6Yn+?=
 =?us-ascii?Q?mbt6Wh0oHbfzS9gpXCEiYnBMkRWleQANS93yoTEs/qHaoeAGQN/pKwpXo8wv?=
 =?us-ascii?Q?J8/44LtJ3AOiheF75qrQEhH4fIXNs6FKoRUIC/1Uq09lPSeAhGYxUsA36p0Z?=
 =?us-ascii?Q?Ys+c+348YacYm5RikQTJfiCVYMMdgPxMgqOdki58kffedbwFmppOsNWzF4li?=
 =?us-ascii?Q?u+28EMvFM8J+y7yPllrBs1pNrvyNXjsS5e+pEyZKlEnidGI2TaWCywcTkrVO?=
 =?us-ascii?Q?pu/8jfO6ItLdR+zbiOE3Of8PYBoe2qXHWibQp8MPVRhAQi8E6Z5g6NJKlmCy?=
 =?us-ascii?Q?seX2VRCt+2e2E4lON+eP2ZIBVDa//2pO+kuZTECODfIPQ8Gl6ablEqRqewLg?=
 =?us-ascii?Q?9DWuQ/JIxJQ6zp7QQiDURgx79lTkdJCzzcFyoFi3n5zHS+kbK3kKmkO8TD/0?=
 =?us-ascii?Q?NFvCy+Ikud3hvarYJBujskJy/yqcVE5UrGU76jrKxNWbfgVtlAKTAVgMXQH2?=
 =?us-ascii?Q?K8mB21GAoeYEWTIuPgSerx4LsvyBid+K6te/10GW3WtEBk8u0vD3X2x1OCXN?=
 =?us-ascii?Q?QXHgqVuLE+LvI/AJlmpW8leKgysA/TASky3AbOt/Wyh3TQc0bpxHUtWqc5m6?=
 =?us-ascii?Q?f03kDIBkBciiocr5hQ78rCTC1szdjgXtNVDy8pn1uxU3QlmJFzhq8yMRhZbS?=
 =?us-ascii?Q?ozPU8fYpibnpxIhsUR+iVp+TriMUmO5qYNZd/IjSs4WB8yn0GAyFY6Ocv5to?=
 =?us-ascii?Q?zMR90WfFjZZVK+ek/JzEo54B0zYcRJs5jAhnTOlavRL6w4jjV+Q4r18CPH2l?=
 =?us-ascii?Q?6G0hr5EUz8sllVG1PNJP4scNYjBuGF5IO7PjPdTBBiXPjOM2SSYFulBzbOpZ?=
 =?us-ascii?Q?dSySjE/wsM37tZwJXniwQD3j6LwU+uM8tvZDxUcVSOvZpUeflowMMUXJcmYD?=
 =?us-ascii?Q?l+8YmUXsnHW9DK3hQVjw6VrV/jUqIThC1ojT+6tYwvZy1L8mOnQ0fnbzTreH?=
 =?us-ascii?Q?oVIMi/Uk72yKe3K404IxrNMWh6Tt9iOpgEmWhhlEBja/T/rPkzqjUgJdEZa8?=
 =?us-ascii?Q?3D7z+HpEiwilMgHqcmyW50C2TnhqSaDlfblBv/ZMEZH7u39WeoFIm+XMhh3Z?=
 =?us-ascii?Q?bKCnSNb2cqGAPzSdwu05aJmitP5JGn+101nsyU56hfAOL82uA0M+ek0414nE?=
 =?us-ascii?Q?nQpFyFKMOUGoqi0AMLTUuCmm4AnXfJ3eDs7yeshViJcEIfYLToT6vkifFpgw?=
 =?us-ascii?Q?cdwfnkhnZn4cLkzr4JNVe7fCOd7BvteMIIeF594ZgDxFna++ZGPSx4BqBNc3?=
 =?us-ascii?Q?Nr7XdJhtZN6RbxSrKBQSKs+5K8/hnpt1ERmaFLanCj7fFiFUpikOXhNGG6gi?=
 =?us-ascii?Q?hjbX75iEhdLIhkAeeiePpZ1okBcrwuZU5MU0mCzh9Q0OrpJbjn5ncxOuAcXo?=
 =?us-ascii?Q?kK547E0b8CI7vk5/pBYEMEIdGJwqE05E06OcEjyJgyW+blXboMmJxr6NJsyy?=
 =?us-ascii?Q?qSxxbklov5lTqVkskF+10ZpIBqzFIkHcfEkpL5K5RoD444LiWvlhDdrI7eGp?=
 =?us-ascii?Q?bQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <ECB190779BEEA94A88782AD80DADB36C@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ryNPgnDelX/If42wWvBXfGbw2mDfkhzVHo2PTFDZshPL4nkmglQKuJ5EJsZ1lv5Kbhho6X26IAGX4wACaz/fD0+lVxj83RnkBPKfOb833yTYeq7hrlBJMX1YH0wmA+uX7hwBUP+Ejv+o1U9TDJwbTXIpNQxJsTMcjQR3MdIqfsFeQpiE9zgpU8YOHyDABQi53xd5e5+ZgFrcq8RCgl0J4oIO7C5xj2g+9zTr3+9aCU336wfp3xoQVhKlsoOG3E0c0nCZxLFBJGrs9PHW90ePfilJa+mDVyLkKgJ3wqpkBxWXPKfZ9QlQT0IUug3QB3BsMLStDbq+eul3vyiGKiLTVAUv15NlW0SBFtsaa4owXfTtHVnVujuUwJdtclYkFeffRly/wqGZWd8Q7bIUlpETdxQRcCsQe5SOQNLXWdDKFuRLHBpkiOUg+OJ/v5QJO76tSvrhbR/TaY1sYnTmrZPZV8ERzUHZ761IsrT2rfc6OqfShpwZ2l/A592+1GuWPSazUw2avDIMzfSwz7w19fCizrFuyIQmVHfCGfKdqPRJpVBIbbrOZStut1Svc3lCq2x9u0E54h6J+7acfSrGnK+tKuCPOExj+S8yP9/rz9CsHWtCzbjelrCjSlBmMl+zjEvi
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5864c788-9d18-4171-cac6-08ddf726d47c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2025 02:47:10.2133
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b7NK7sz0FctgnGkBQ/Tk8SjeSKalO24788cU1fWGoQKfBXVelVucF7hVmSLQEYix+VZlIcjbZwhGuoX+wPT5JpEnf5zPzXgRMYc7dy9/Guw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7476

On Sep 18, 2025 / 13:15, Mikulas Patocka wrote:
[...]
> Thanks for testing it. I fixed it, I folded the fix into the existing=20
> patch. You can get it here:
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.gi=
t/log/?h=3Dfor-next

Mikulas, thank you for fixing it. I found that the blktests block/008 can
reproduce the KASAN suaf in stable manner using dm-linear on null_blk. Usin=
g
this reproducer, I confirmed that the fix avoids the KASAN suaf :)=
