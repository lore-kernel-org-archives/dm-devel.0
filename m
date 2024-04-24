Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1894A1A
	for <dm-devel@lists.linux.dev>; Wed, 24 Apr 2024 00:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713919017; cv=fail; b=MIF8tVxwN82t0BMNzb7Sf20K6fOmsEIl8AsY/nVBqep/AmFL3fp6ClNELjvFaFJmCVRgZD+eUIiAKI4r5vXYe17JpIfhliyXVbzatA9NgCCd8/MlSqbzlbYi+GkgBNiF9YUCdn9dZIbmCXMam3BqDHoNXuOIPgwS1Gmhkcvwo9w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713919017; c=relaxed/simple;
	bh=WqAmueTubPDBWkQXj5r6YlmzCE4hCIZHESXzx4XbNbk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OCg1kyNv4TbRjXxJ18D56XUlrrLo0K45qgmt2J7UfHKJGYIgh6owss9E4zNMjmfO2iuYRW5wUfVMzti0ozsk/4qE8SD2GMQTaAcSfs8XatrxbQzXMooSbMc8k6D8vPWiKKMkKHY8Jkazt5iU/nwdHf1rzcx+qigwiMopDDctsag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=qeDF7cPO; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=cJfofSSv; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="qeDF7cPO";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="cJfofSSv"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1713919015; x=1745455015;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WqAmueTubPDBWkQXj5r6YlmzCE4hCIZHESXzx4XbNbk=;
  b=qeDF7cPOicbbt1LpRwMEAxxtokShOik+x5gmmD3aE0fkZrEDjvHizGfD
   2/GriGBI+Nrn6utJ8cUCqA/iuewvz/PvVdCPYcsj5xYM+TWVM/mpQ7V7s
   uzcPY3zXoO7rvaeEDXjzI/Z8PQe4w24pEx97urgjWth2c5M+ERRGz+5wu
   u3nMox6iHC9/IpBREPPQhjg5SeDLFPQSNVpfiZCK2sXJ25M5/Op4WpxgT
   JCnGyZsrCwz5xya9frksI3uI4ePA/F+X5IVh/dhugf/TbVz0S9CgsX/WI
   BuzrJ44ma5yBRfK38NeY1rQkIlVoKHsYL5GVH5nKHOnOyV1OPBmVx8e/q
   A==;
X-CSE-ConnectionGUID: Z5eqdXZWSSimspc94lAJ4g==
X-CSE-MsgGUID: LCz2uff/QOyCqQQFMyi5Ug==
X-IronPort-AV: E=Sophos;i="6.07,222,1708358400"; 
   d="scan'208";a="15433695"
Received: from mail-bn8nam11lp2171.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.171])
  by ob1.hgst.iphmx.com with ESMTP; 24 Apr 2024 08:36:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e2OXtyEFLnQktVBWabC9NT83b2GSy/Kd2rCaN6jY8wAeuFC+ckGI8KabQWkfQlm9j16fy+9SjiBczYtiSBOA26+gkVgkda1TVZfzn+GQ5YPeSdzhODD0ECiaIG+a0Qac3LDjwy6z94sjWo+2wPtt4t3lXo2VsANCMBRXty2CykcfRplKURjW6o9jsO/AOtHA2Kbtg7bi08O+BOWe/vO0x8a2FlPHQ4mGWgaYdRB8WSlFZXYyOkXIQsL+eaABznM4K5AtbTu/DxGQ2/aZuRi8ZOLzo7orb6GflbYZGee1oWhK88xEZZE7def4CX0Ky+I3UxBA7KKCt8i//hU6ITr5tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YI3U23f5wul4MS01gE/jxW/MOEpvDfJ5Vu0KSm2n+5A=;
 b=hzmQWFeQUlvZhpw8/NcIwCYmc1lnoAn6JxRVNCvBieciTtUYJxFLiC2j8STzbcxZd6I4A5SW7LHVwEVhA2vRI503QkNO8DfiaAsCpM4gw0BKPT+T5xpqb/eU+RsyMSr6U59lURvYYkQf1ZD49dRrYn5jmRBV+7q9NKW50qg6k+8eHm/AjbfDzm23ldGU5MAD8l/WEiQtsmg0Rq3U3BCRP5C1xdKSi0juga/yi36AMsJ2MLf2CRO6e9vu8f6dQphXTwG5NX6FPPnoD9Wyu3S5XZvoM7/LBUEa/Ydtc+rr//DarVMVmeiSwxXJrWy55GR9Ey638F76Q7UcNL+v5o3aMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YI3U23f5wul4MS01gE/jxW/MOEpvDfJ5Vu0KSm2n+5A=;
 b=cJfofSSvJORKEAr7hTgGycizh5D74G53FKvgz5U3GrkrPinyO/D85vt82mFB3778HR/wWOHHcHgoBNlWQC7GAvaOQlb/abrVX0VGed7MCGr3YHqnz584lVD0IdYGi1tR/AC/AyS3SpFwUz+huZB3jxy+S/Wc6QnwVBhnxhrYw+o=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 CO6PR04MB7666.namprd04.prod.outlook.com (2603:10b6:303:a1::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7472.44; Wed, 24 Apr 2024 00:36:45 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::c75d:c682:da15:14f]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::c75d:c682:da15:14f%3]) with mapi id 15.20.7472.044; Wed, 24 Apr 2024
 00:36:45 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Tejun Heo <tj@kernel.org>
CC: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, Mike Snitzer
	<snitzer@kernel.org>, Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH] dm zoned: Drop the WQ_UNBOUND flag for the chunk
 workqueue
Thread-Topic: [PATCH] dm zoned: Drop the WQ_UNBOUND flag for the chunk
 workqueue
Thread-Index:
 AQHaiyN3MAt3ravZkEmOdAHOryyyUbFhySCAgAC00gCAAmiQAIADu1wAgAx2dgCAAQiqAIAAh7EA
Date: Wed, 24 Apr 2024 00:36:45 +0000
Message-ID: <isfz6pnm2l6aizihmdrksktlcpkkbnkmxgc55ar4akkrmggecc@lxu4tko3ht5k>
References: <20240410084531.2134621-1-shinichiro.kawasaki@wdc.com>
 <ZhbRm2i3OeBVwE44@slm.duckdns.org>
 <kmi647h6yrkpc2d5zfbxzvv6yi37yh3aonbbjkohvbf44s7s3n@frptyb2kp5vl>
 <ZhlugLZbFk8xUbJ8@slm.duckdns.org>
 <nl3ys53xadoca2qht2r5ikjh2vrxyrlwvs7n5nbitzxuxx4maa@daejezc4mr6z>
 <ZicERHDW2w02sJQA@slm.duckdns.org> <ZifiSILH9MlSDjxw@slm.duckdns.org>
In-Reply-To: <ZifiSILH9MlSDjxw@slm.duckdns.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|CO6PR04MB7666:EE_
x-ms-office365-filtering-correlation-id: b951df41-e863-449d-84ef-08dc63f69eb0
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?IN+S5bizbkeh7l8TRiiqtZa81ZA23JdJTkGb/nVdKentaA/mk6KNvVXsh29k?=
 =?us-ascii?Q?Q3CUb0oyPg+y6zLI+G82uR7idHwqjaO0KtLBRFcKtUytUaE7W2cyy3WV9q8l?=
 =?us-ascii?Q?imjRjAEtNB4AdswZh1fKrUhatoRkjnEM0rva4CexIP0u2Ipy6LpysGLsUTm1?=
 =?us-ascii?Q?ImYXFmKskdLo5hEFD9drfIH8xULik5UrO4rIrTpP4veA2JAtA3ETMBjo+R38?=
 =?us-ascii?Q?uKz1iPtK9tSlyRpn5dY6A99qEdOsJ2QeXH0Hj4iFAQrxzXifpz7JlfH3iroo?=
 =?us-ascii?Q?9DD5fw+l4oEuwkDvZji1ZwVPjjyTTq3yoZLGckeIXlpLpN2RMBHy6bxT9+6J?=
 =?us-ascii?Q?Fc2Gt09iPEq4gkRNpi3hYWhW8u5wFlzj56zG+nZcXMcrvu/B1oO8Qo0uTObK?=
 =?us-ascii?Q?YyIWEli/FL0rpaKAWcoGVwuIAlhVnIjE9dfUW1FiRZ6nt+C7yAaEEtZE7Ufc?=
 =?us-ascii?Q?N/nhYj/YEWJPEACZrewDICSOfI4ftnjI43qVHQPUk8XEdmFLfFu+Lfls9KtH?=
 =?us-ascii?Q?cjWSdHXTRDkYNDPnRIlhH/SDaf/fGeG3IYe2k9JDBjl7Ph3+rSwvYhhFhQgF?=
 =?us-ascii?Q?VCbZbj+aTjXbELtkJ6XPSqG0fSY+ghVe73fgPgJvUT54Zgr3icaHqmgoWkQ7?=
 =?us-ascii?Q?MWVTdynAnOe6AT1EI8B4iEZAVu4iz45Z4s8PGzbNBjpkYABrg5sSqM8tHJSb?=
 =?us-ascii?Q?RkIjUZILuvQwyyq2WHgMA8O2ZfESMrgfAg3qpHTVrPZ1vvro01JieThlBlle?=
 =?us-ascii?Q?ieC5wuEpoMWn4enwcsP3cX9U+8C1rpJPtxEjgnfC1Pk3EQYZr7guHtNx45QM?=
 =?us-ascii?Q?SKbF8bYtprYJ07NuW/xqZcSk9ipEiYcaNcAB7zcae72QPz5pGqtIN9c3e8/x?=
 =?us-ascii?Q?kBfgPZX1LTGWLRFJbJzJLlbeNWThssuzpjoFxwyifgi4mvHAh3GmvGTu5XI9?=
 =?us-ascii?Q?qCeINN+eYdw/AYLEEpwezIHdEKnl4V+RupwryEQtI325osWKS6hEjdgTl2Lo?=
 =?us-ascii?Q?HaBt3l1rSE6ZGb7+kXPrJuM3Dih9t8dMH7CYcBV+WZXHBZAuujkoFrvHzh1a?=
 =?us-ascii?Q?H9D1KNojzgzAbUZNebeLgE6JOBgMjLlyPX6XyQcJOfYmquXauRcrsP+Qa5jI?=
 =?us-ascii?Q?hg+gghHq7C8PpbXx6vb26vlxIUdNhBhXueG+t4k3T+7G1IBREp0XkLEeVsWS?=
 =?us-ascii?Q?q6PF3jBGmbn4SIx9AzRRjMDOq44lyjsLIAkPsxnWTszewaLjeiyavstTLH71?=
 =?us-ascii?Q?5MyT32ZvDSlIxMqYz2Y0s+U9cszaLYBvJye9OHkecw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?E/PXyKpmvHURaKwtLH2whwDaJgp47fhrNJAZmr6A4uCPR4fCTTN92DHr26RU?=
 =?us-ascii?Q?rsAdGFPhIycVlxxWY8e6VKseG3Nal0qt+pdJwXtVdAni5sQdOv7mIQWOCi0P?=
 =?us-ascii?Q?W1Q5i8UR0SMGfmxtJ78+SYIu1EkaiaBR+yVCqAjI3O7ZGOUICByoErLJL1xE?=
 =?us-ascii?Q?BUIL+vSlxeRIajgLTVt404++pFT1aZz2+2g7hsE2l7Jwjl5v2L50qbz78tLU?=
 =?us-ascii?Q?EGO2RSbI02ytRwMadHcsq+tm3prepSg2xqb8r6qirjB/DgBJBeYyVPLyc3j4?=
 =?us-ascii?Q?zG+rWS7fwRNtppDITDNZaj6q/PDJ4Kl60MW8/BCHhWB99OQGpTaMOCHg4MUq?=
 =?us-ascii?Q?ZunoEBvsVkGJwfQG+58c4ePLHNUC4Iz4ANXraKaaiibVUyqevRwpo3lSQBgF?=
 =?us-ascii?Q?0zu4KYQmgEC5yO1KL+8a6JFvZoEnlRgsXjwzq1oWiS3zjbyAcdLQnunjIPpk?=
 =?us-ascii?Q?pC1wPDMr2oZgPb92y5paq0Yvko3KKV2Zkcy9gZawImYpSt9vUiBWWnaMPvF4?=
 =?us-ascii?Q?B63twdKGr13tu2RJBieEQ3yCXc1WTZFZs1TxtnHo6mkTuMdOuG8IFDo0oSqy?=
 =?us-ascii?Q?LHuG98new/CRF8lYX/Z4Ki5Kov3YdBGUu7DpR22TxYXj8qmH3WFSg2gBt9/S?=
 =?us-ascii?Q?aIoOlbNxCr/aILdq5kJ66Ow8FWgTNSfs7/cPdhaddZXdNz1ty7Yb2gK03+cO?=
 =?us-ascii?Q?UkPACAx+Z9SbD899w11JuL83YfTmEs4mZJbG8LRGWqSmlROfFcS74ma2Nwaw?=
 =?us-ascii?Q?rU0ROfT0OzY8BHr2PpgAv2ajcmFiVILEsHSKL9GBhXMZCfubLGVD4LHmadYX?=
 =?us-ascii?Q?0eoN3ZeR3KYpu0z5PHCoVLEGoB0QXtdOt6IPB6/q9/Tvj1xLepajNA9fUSDN?=
 =?us-ascii?Q?qgjAc5DEBL37zLju5goT1zurjJct19JlJsljOjOgFhLN+20C2UKXrcjY1ZpK?=
 =?us-ascii?Q?Hc2qTlqSE42rIja0QnVVUjYeyQZjD0PXvdkZcyMPNFT4Zr5wr2nZOL6QCZK0?=
 =?us-ascii?Q?NGgs61LV2wXu7mrghyylW5VZYkNbI4ekvF19WW3STtJMHIGWtTP0tzAcpRAd?=
 =?us-ascii?Q?jMQSSD6Zraao/RbI/Eq0bJawx1eR0KXGHwY7KSLPQGfS9alLG19Zyl8/lWnK?=
 =?us-ascii?Q?cyTtuKnY9Z/TQoGMQzJ3J+iwyfWlRjtODPyVnRJJhDDgt7WNVTCL09BiIXLq?=
 =?us-ascii?Q?trlr+MIdqRPQzh78N2jy0oCA9cmTyc4xnq/TRuumlpDrvt9pn2Ei+kSoM2rv?=
 =?us-ascii?Q?cbTWo/Q57fZPH/P5+u9doCFs339jWTzP6ApUc+57dP9s3LlUKrcqJl64PICr?=
 =?us-ascii?Q?FpizVUv9FUZBt2tBfUK4MyDfrH1oo4mmEm9KqmfTy84jwylUEdEXbWHsJAg8?=
 =?us-ascii?Q?4/SnLhtnyrV5cdfIyIbv0qu6Dw1bMd6oQllgYzxhvJEORBtJF2omIdzDdxde?=
 =?us-ascii?Q?VkBsQGFeO5AT3yxk+b5h204HYJfX2dv7VSf5tDU2ffsNszvdpVcRBvgHNzBG?=
 =?us-ascii?Q?3/AUeYptOMmX6aHla+ilGz8XH0J8FvQUz2UjBlM9M/StWv2WS/jC4JFwh0o/?=
 =?us-ascii?Q?XNxaHYsB4KtM7ihwyq/4ZQ4o8DgqCfzk4Mz2XyL26CJQjhYqsUTuQ76VNl/k?=
 =?us-ascii?Q?tVXZ2tVb3ioW3IO6yTY+ZZI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CA7B98F955E5044497F3C74ACE14BBEA@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Y1/xrvcR5L8DKNCXeMQVf59A/cSHmA3cQT/5UTqNTjAOee2TmwNSvtIFPME2hVXE1KX11vCRx+swVn4WbPpMzm/GeIAB/B0uZZ+v4YoZ0f2PB1yPJVw2aFrBSrFMVklcS6pEvVw7hR7LCMjOoFlOUHfjYJMOC9Bh6QuavhMMvBwNzAsdU6roaD7Efzfp0TN0GuVSj8IlsG/xgjv3RnQU1HYSgCocKdduEka5dOc6NY/trZhzDffAfRr3Ck3siSdsL2Otks1uq30m9XAXrgnCFtkBo5gNTfhWw1MyvtQam5REmI0a/RnXqLH6lCkL9aMSxSJKlUDGx5/VT4vfKNXJ3Z/DiO5UziyG392GthgGDAzJTF/lGT/hcYwdJh66OIPEvd84in/wr++/DuCFGrzCxl6Tor24KBhEzHdWbyxrFkWh73iNg3i5oSfvYAOWQ6VmxXofsmAlex6osiR4xGMSAYUPUJyIWiY7zu73zPz/ruCombvytman3nIfcK+xDl3lprMQhPKNyT26AryORUIWyepOKX/jjmvEqkY9KQRxVKaSZydwcVQ7txujQvLGbJ8MrN6+4YmalS6g0o5zJSJl5QI1CGS2P9g+5CTyxErV/sjtZIYRsugFadJFPqOy6vOP
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b951df41-e863-449d-84ef-08dc63f69eb0
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2024 00:36:45.5202
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FaVb/JrEGX+RnYL/3vIxlcDXRVU28gCBshGOanGdRQ80zif27I0dpjyo/K4k0taRCnpiSnDhPdMp1ePFwCrVV3RVhu13PsRqOhv7q4BKk3c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7666

On Apr 23, 2024 / 06:31, Tejun Heo wrote:
> On Mon, Apr 22, 2024 at 02:43:48PM -1000, Tejun Heo wrote:
> > workqueue: The default node_nr_active should have its max set to max_ac=
tive
> >=20
> > The default nna (node_nr_active) is used when the pool isn't tied to a
> > specific NUMA node. This can happen in the following cases:
> >=20
> >  1. On NUMA, if per-node pwq init failure and the fallback pwq is used.
> >  2. On NUMA, if a pool is configured to span multiple nodes.
> >  3. On single node setups.
> >=20
> > 5797b1c18919 ("workqueue: Implement system-wide nr_active enforcement f=
or
> > unbound workqueues") set the default nna->max to min_active because onl=
y #1
> > was being considered. For #2 and #3, using min_active means that the ma=
x
> > concurrency in normal operation is pushed down to min_active which is
> > currently 8, which can obviously lead to performance issues.
> >=20
> > #1 is very unlikely to happen to begin with and even when it does which
> > exact value nna->max is set to doesn't really matter. #2 can only happe=
n if
> > the workqueue is intentionally configured to ignore NUMA boundaries and
> > there's no good way to distribute max_active in this case. #3 is the de=
fault
> > behavior on single node machines.
> >=20
> > Let's set it the default nna->max to max_active. This fixes the artific=
ially
> > lowered concurrency problem on single node machines and shouldn't hurt
> > anything for other cases.
> >=20
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > Fixes: 5797b1c18919 ("workqueue: Implement system-wide nr_active enforc=
ement for unbound workqueues")
> > Link: http://lkml.kernel.org/r/20240410082822.2131994-1-shinichiro.kawa=
saki@wdc.com
>=20
> Apply to wq/for-6.9-fixes.

Hello Tejun, thanks for the fix. I confirmed that the number of in-flight w=
orks
become larger than 8 during the unmount operation.

                            total  infl  CPUtime CPUitsv CMW/RPR  mayday re=
scued
dmz_cwq_dmz_dml_072           613    33      4.6       -       0       0   =
    0

                            total  infl  CPUtime CPUitsv CMW/RPR  mayday re=
scued
dmz_cwq_dmz_dml_072           617    33      4.7       -       0       0   =
    0

                            total  infl  CPUtime CPUitsv CMW/RPR  mayday re=
scued
dmz_cwq_dmz_dml_072           619    33      4.8       -       0       0   =
    0


Also I measured xfs unmount time of 10 times. Its avarage is as follows.

 Kernel               | Unmount time
----------------------+--------------
 v6.8                 |   29m  3s
 v6.9-rc2             |   34m 17s
 v6.9-rc2 + Tejun fix |   30m 55s

We can see that the fix reduced the unmount time, which is great! Still the=
re is
a gap from v6.8 kernel. I think this gap can be a left work, and hope the f=
ix
patch to be upstreamed.

BTW, the URL of the Link tag is not working. Instead, I suggest this:

  https://lore.kernel.org/dm-devel/20240410084531.2134621-1-shinichiro.kawa=
saki@wdc.com/=
