Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288CD168BE
	for <dm-devel@lists.linux.dev>; Fri,  9 Aug 2024 02:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723169915; cv=fail; b=WfdfT9yKBZHiledT8xvIMBseIzbGA1rCS9fy4ww0ekVgmzXVgYhkp9jhCbXIM0eC5uxDTfZ6WsOiT4UWFe8sgy/8Sy04h9LkkjMB7S+7F7nZLI8L+myPkzBd8UL6HLFheVT3JDFR/QxkH9NVKS9Vp41eezcZCvme1La2KBQ/fp8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723169915; c=relaxed/simple;
	bh=uDTGByjWlhrvtfv2AdVzSVYQRl0xdOc+1qtCbakMN8M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YTsQWTmF5onDINs7tf3LR/Y0ub+g7ALHJnYKPOemBVsaBAZqubpY46fAmqq1bepqEUcXlEsVt48/tdQSPryDYjDjnwXMlnNzbqE8urubyf0V7z78+fzLCNMIJjkdmhFHrunJcw6ieUwOBw8rMJV0ENWursa0Itz0O6Vkic4yHbI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Th8ViT1F; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Tai2fhkA; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Th8ViT1F";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Tai2fhkA"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1723169913; x=1754705913;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=uDTGByjWlhrvtfv2AdVzSVYQRl0xdOc+1qtCbakMN8M=;
  b=Th8ViT1FTX2aZ6upuYx+0ySBVTTfI9Zm3MxijrLIzsfcP2vE1x+oHGZl
   a0FMQ2MkGIXMR+mWdAw9XWr0D9LvZDvWU3uaCJi6HdLh6lRFBEo6DPC35
   QL66n0F1Lw7HyfNmPBJBc5Waan4YXbU3LlRH9jl887vB5n1svK6M/pLPl
   C4QEBMc4Z88f6A1s8yZCp20Hwj2twnZl/sFacgjAPU38WrrNnCPCzOyXv
   36LfgqhAuG7A8SJ2O2ZRCHxhLAwVP3oUK8utdWLCanYU0teB04VNPt8nU
   1ic3WfK4BRwMkFy7j5DQZwpcMSoT/o66D8OFu83YFqPzcVpoWTkwfNb5Q
   A==;
X-CSE-ConnectionGUID: jpkl0RnaSo2XSCUUJYrBlw==
X-CSE-MsgGUID: aHKzmbavS3OoDxkTaUoZAA==
X-IronPort-AV: E=Sophos;i="6.09,274,1716220800"; 
   d="scan'208";a="23830014"
Received: from mail-westcentralusazlp17010007.outbound.protection.outlook.com (HELO CY4PR05CU001.outbound.protection.outlook.com) ([40.93.6.7])
  by ob1.hgst.iphmx.com with ESMTP; 09 Aug 2024 10:18:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kqlS5g2kdBIqJm34NdE1Z4owS/ymM4mCXEnPHz2YTbiYEO6xhk4TNNhmH8GobhTsq59kMcXPiYv6P5i010lmX6qYWUzkdPzywBEyA9dmH+GLPtWJJWLwydG4Fi6pbyn/P7XHkv93cs+o2wNRlXgNlUR8bxGme3csZkrOvuM6Rlrg9E2LWUxKe65J8ZkAqkfiK3mv5Uf+rIRDwJLhsE4w2Y+EORcOCAvIVHIyJNv4roDP7Ru6i8slfyZnubJb7BfLpR4jkzTdbeWLLIkwI00TbLwFrigFg6Ex2979XKQ3q2PV7aKELMHdHTsA60KqNrfkS9AJOH3dq8d4ElV8DuOc+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yxUBWRfWUnhdyTBJoQOzzJZZIckHOhyYZo4NamtOSTk=;
 b=VWosSpZKsGIp2euThIsVSw/tgmx692Kwh2OM9qb5kI9VYh/2EI6uSyA3awyByUVuy58nfU7korR06QQEW8gPrbk+1ixMbsoqN6fY8MlrDyXeBTpQ+n0ZOYegXZVyUpUXSemW+tM0SKZ0IRQYmnH0eyU8kR7I391cy9hOqxdmrSFmPcIYeTbpGjU+8GEq2O8aaTxiVUazOppSF3Ta1vfhlGQr1m8EQ/Qz0gVVwAN4Cq+3BiC3RBM+yMiau4mrwxb8+ukYPdU8AnIxYJeiI8snYRNfIrmwfebdHscTrEhmft0RrmKn+ssno5G37LMRrmIQs0wDK+1hOZHOLMtU2bAjZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yxUBWRfWUnhdyTBJoQOzzJZZIckHOhyYZo4NamtOSTk=;
 b=Tai2fhkA6FsHQUVpiLPVswzKQHvgWrplymhZe2DI/25QdNoXnx7fMBMeV5+FyfT8kOZVkVvaBKqjZCHBpVOyAwF69qSA8wNiC2aI4S1frZXCvbf0CzwMDrST1ZSEFRXhFh1cL9AtYEfzfZiAWd4wDVgDrZHLwxXQIGkeX9UUKIs=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 CH7PR04MB9641.namprd04.prod.outlook.com (2603:10b6:610:24d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Fri, 9 Aug
 2024 02:18:23 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%4]) with mapi id 15.20.7849.014; Fri, 9 Aug 2024
 02:18:23 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
CC: Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH blktests] zbd/011: add test for DM resource limits
 stacking
Thread-Topic: [PATCH blktests] zbd/011: add test for DM resource limits
 stacking
Thread-Index: AQHa4lVNuVs/UKf+sU+F5G3YXrbSPLIeQCUA
Date: Fri, 9 Aug 2024 02:18:23 +0000
Message-ID: <uhtlh3qrtcw4yrn7jwrjx3bi7eswmr5isjvxukl363ipdj7l33@4f23h27ivtxf>
References: <20240730075129.427245-1-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20240730075129.427245-1-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|CH7PR04MB9641:EE_
x-ms-office365-filtering-correlation-id: 645039d4-653d-4fb4-33c1-08dcb8198b95
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?GOVN1xmS5oAJJcF7UAKLlwpYnyR/WcdP3AF3q6IPJANkkQyEa0lxfV08UySF?=
 =?us-ascii?Q?w2yUhXnuxb6zc9R7XGCyOU9lUuWr+Ru46MYZ1788q9cHI+tHfOBCLqauqVyW?=
 =?us-ascii?Q?1TdoybwxXKMwJX4I0nqKddsY/VPqUceE9LiAl9jZ99iCyEBIgJNdUG0bIvwV?=
 =?us-ascii?Q?ER12KHdB4KH4Ma34d8/w8u/QpZitQvzcBxLdrbLvolLwov4sFppedZtNaMgr?=
 =?us-ascii?Q?Ems8dhSlXwwu+82a5utdBtyK6Hgu9jAdIohcxIMwZC45MP6hPCe6da2KkTUw?=
 =?us-ascii?Q?BQxBRGk3voPntEVUiNRnHVlg8IivLdtZm44gYSGrF34fc0byrpThsdud6uzd?=
 =?us-ascii?Q?SpwirGxuC6dJr2+49EWN5ESsTj3/ajcz8aP0SNBHGNRTnfTtvaw4tuOJHFYW?=
 =?us-ascii?Q?ymAVeb2lwfCgZ8b8nG0MzYwJWkD3ZB6vE3IzLbWV4UTSekOy5W//We1h0bLI?=
 =?us-ascii?Q?Dhyj/wo8M1KuZhGa94Gt2q8d3bt2Mf3Pvfq4aptVB6wtzHG42QB/UJDVC+QH?=
 =?us-ascii?Q?7Kfa79NbgKnXg3pK/lEJJonqfHJH1pq+Od9NWxtMTVpEGIhKvqT84+FQiumP?=
 =?us-ascii?Q?kkIA9/FIY8tsaOBh3UvAG7ytwpb79heZy634owGqKEF0F3V5jPKvwGHGcxkm?=
 =?us-ascii?Q?FuvjlaGSOCysE4PK6U/i3V37k+gkeWL3aE5wIQVN9cnr3W97gWxC6xxNweHp?=
 =?us-ascii?Q?Y4DmtDPYB2WpubEsxTUsMLvQfqmeUeMDTuyMRIxpzljtNso7U7ADPZaLK1Du?=
 =?us-ascii?Q?T6GSH2HVUjykB+l1p0EHuz7lnbKIVpYcrunldxC6Q2LsNucE5JB0znS5tk+W?=
 =?us-ascii?Q?OE+b1vP0QC6adFu3BlXOZpmxZOY4UY842oytA1ckQQzZBC5klMI771jzA+qE?=
 =?us-ascii?Q?iTQZLdnSL9WON40uIj/hWzDqEZ0fEdyKIArmKVYW3cp/3G/TrpXuPcEHSzIx?=
 =?us-ascii?Q?gpDR+Yc7GieeLu8bSw2nb22GDlJRczE8rDC9+on02ABNS4rAqyHJc/wMP7dq?=
 =?us-ascii?Q?XUo57kwHAQy1J5bfZFcYUowVbCiRUCN93lICR32ItFfeu+oOLIsjhUSK79vF?=
 =?us-ascii?Q?A0ahzs0oAQWVVtsk9ZC9rtIj9ZotV1NOwWM/l3Xv80TAQHhvaDgEnck2cvlO?=
 =?us-ascii?Q?RI5yDIAYn7DNF/mYo4qEOJUeB7SuriL8LQswsH4Xvju43AcKBkUUuxuu4T4r?=
 =?us-ascii?Q?mqIw1Gy8TK9M9GyvQg/UZly8hhuNKCC1/3BDukeH0lMZuBpCNRBBdWVUCWyt?=
 =?us-ascii?Q?93ra0oowc3WwWprB2J8afJoO6mxLtHuTz/pIsXYraUwbzYaJDYHacAtiyJSE?=
 =?us-ascii?Q?t9DfKmHl7bn8qviEIkvgBnCwCxexwyoDTb+Evemb7AYQ8R6HGWDHO+BfOVTZ?=
 =?us-ascii?Q?b05QIRu4YwL3HiJE77ixCbN0BCSboK+UAv4zTjKORBlV4jv7rw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?C+SYNy0ecnQPMMQKDQzMvd1gWwwLUZY8h1m3amcD1sIBZHBvqPtDwWJh5nsX?=
 =?us-ascii?Q?irbhlqfejv+VfdHyU4RQVPfEVaqmbjOrQbGxHggGTH000BqaSx8pqhmajATz?=
 =?us-ascii?Q?AFgu7r11DVNRtxvbYn7pG9krK3853xgwQkAekFNlSAypFWgEAczhJnad5djH?=
 =?us-ascii?Q?AtScUHPmBRZXMEjNBWgKT8pc79aG7jCEytFf4ZEPYE4qeUdJI/y8LcUsEkgs?=
 =?us-ascii?Q?Me4zRHTY1f7FUYKG+pUFv+3ZV9CCVM+wShuwkT0VYKEkyDSEa6gZfitTQGI7?=
 =?us-ascii?Q?IwqXpTFUqiM0DpxvNVyqLufIXlc9+KgN15elnxfubK6b9m2cvrAIKz6SRLSr?=
 =?us-ascii?Q?C9Cz3TKyj0N6Lau360XnKR12+tdrbN73AmlcYr3klClz3TXHTijRlayJqXfm?=
 =?us-ascii?Q?7kc9WLs0I++Bi/yzWqm6HiFdqYPZFNbN6HNapVD/P17pALj4VYHWWC5qM2rQ?=
 =?us-ascii?Q?W3qA/nrulEZdv7meX6nmt4G6W+2qrikz5bFQYj92JY4hkN3gCTKoxP9tlT2u?=
 =?us-ascii?Q?2sIPn/HE6Wd3+jeVSG8bFKvZWxkjVokWwBiAvvFUIF/sQa/+k3Zup5wo3g0d?=
 =?us-ascii?Q?jWm2vej35Eqi7PLcwTKaAO2f5EntbaUq0TuTrmVCnPcBLnVZxf8+LqKLjE2G?=
 =?us-ascii?Q?fKpGUWPJx2NdEEfJw1VaNhJBl0RqcZGeVJXxosKHYRWSuyHgDRNcSxIZklE8?=
 =?us-ascii?Q?4bP3qChPWbGFLojrW3PdJLIH6uyNRapX0rXF+9LNThS8tuXIpjMbrVJ2mp2i?=
 =?us-ascii?Q?GvbjsKOs1oN2afCnOQje81GyDdyZl0FFaNPFn6gI6U0X7QT65SrnjffcWaEB?=
 =?us-ascii?Q?4BEiPbDwzIeu9DsO3ylHZ8ryQSMH8Djj5Mn01J6dCHNv+WRaswwyk0tUnHM9?=
 =?us-ascii?Q?Gju+kTOjW6AduepZO1rBjrQaSpvj5AQC8HwKDUvH8ohV+M1bX0QU9wwJP3rk?=
 =?us-ascii?Q?kmbqeonPd5wx0F/XOlzpEc+xKxGNEYjJToOBQUSt0c7pV2qZkWSJCk4KF62I?=
 =?us-ascii?Q?3Ltsl3Xol3LFye91MTE5MKVKS8r5UIv57QYoDMb2AGf5GpFac7WLorBNV2Y2?=
 =?us-ascii?Q?NgbvX+BBQZw2sDzXRIAiKaQQcc6XYyaItqKQDNXKCD6fNL6tkJt/tsrabasD?=
 =?us-ascii?Q?Dij+eVW9/+v1+Alpo/CkltUsaNZDAvrE6cpEne7GAwFoRE6SutGQqaNZsyDh?=
 =?us-ascii?Q?h318lv9vPt02Bih9p5JSickM+DP40b7VRZ5pDWFlSstKiAho0cGGz163zpa8?=
 =?us-ascii?Q?+I6QC9XOfk6N5CZE12oWfA+rgkndREv4WVKgG+R5uhkdoVTHrbMJGHGRgcQG?=
 =?us-ascii?Q?Wy/yjrGfx3/Ubs/o8NYpsxme6XmrLXbq0fnB79lrFrPLwmYHde8WwxHcr45n?=
 =?us-ascii?Q?R/mOcMe86k/W/YxcUsr8kQlW5GMyF6nAgUNQm2FBiNpkGKvHXGJCtJrIE4/k?=
 =?us-ascii?Q?VwB7mH6BGm9UrPubbuOoY63zDwNIhL+s1tsiMadkU9BWgMg9V6e+iVGsqm0t?=
 =?us-ascii?Q?Xq2VU4ug0JM3cBtD3CAhmuHYK4JN9FLv73laFTDeGnIeAK/rvvOUsZ9B6t0T?=
 =?us-ascii?Q?vJS5q4h1zQoh/SI0FIUOI37G6YVzt1zvKa0leIeiQONQHKDBfxJzmhnzTvWR?=
 =?us-ascii?Q?L00EDsrUiFOFuvWHX4WZ9kE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7F612A00DC98094392573253B567DD74@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	52jXnf3HV3Ly/itFoazgsz6RDy5Txoma+luvxsE8y7dT5sLQRsiHw/oNG388mWp39XdRmU2DPInslsmcS/U3SQnxuTjFhXCLexRgJJq7GnyIxF9IxOFejPCG/6FXzgE3+o/OA/MUt8Y1DxPngl2NeaH5D2sKyvMNFB+nhjXaHdMfq9RRsmCD4MRXvgqC/eWykbefbR/ivyiMLZWxluSOZOXEWpeFlfeouEA9o21MmlVo/5E4L2aMYBnAsPOnqxY8I6+V4k+wSMsknonbLR4wEC7g+uoCpjRaP/2qbOgRrhYbFcRciWjKcqFAwfqe245spDLSrUBY1cmPsmYF1dFmgIpTBtQPVTrgIhQFFX//70gk+9x/2Km/PFSxmW13nRoiBFQPHSH3S0BrHW4i5PALO2faOrh4JWYfAH9JrnjzQesWEXBQI+0M44HnxRmIHqBY4aTodYdg+kzOX17JjEV9wx017AoqqsYYVUWLOHXyQ2kwrVjXi4rnkzBkMRA3K/A6P1khfyd8Pqt/317rjvyaQ3SdDugvpzASlH9RESDTnhb8nMt6aK2vAZY3wtZ7OaqtWki0RCmBmE0vIBqv1vj8r+J2YqrNDcT55QkJr5rG4fth4K/PiUvxVCfh3nZJ7txb
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 645039d4-653d-4fb4-33c1-08dcb8198b95
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2024 02:18:23.4715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bDbyOwKvkVGGSNn0ibAQcUpOTX4MqAI4SuATrjbbAmx6CUWwrn3jseMqlI66GvDco4+zsENij3RM6mzhWBfViuQlpngbuHkuXV2FHWylUyM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH7PR04MB9641

On Jul 30, 2024 / 16:51, Shin'ichiro Kawasaki wrote:
> Since the kernel commit 73a74af0c72b ("dm: Improve zone resource limits
> handling"), zone resource limits (max open zones and max active zones)
> are propagated from target zoned devices to mapped devices. As the
> kernel commit message describes, the resource limit propagation shall
> follow the two rules below based on the number of sequential zones
> mapped by the targets:
>=20
> 1) For a target mapping an entire zoned block device, the limits for the
>    target are set to the limits of the device.
> 2) For a target partially mapping a zoned block device, the number of
>    mapped sequential zones is used to determine the limits: if the
>    target maps more sequential write required zones than the device
>    limits, then the limits of the device are used as-is. If the number
>    of mapped sequential zones is lower than the limits, then we assume
>    that the target has no limits (limits set to 0).
>=20
> Add a new test case to confirm that the resource limit propagation
> follows the rules. Prepare two zoned null_blk devices with different
> set ups: number of conventional zones, different max open zones and max
> active zones limits. Create variations of DMs using the null_blk devices
> and check if the max open zones and the max active zones have expected
> values.
>=20
> Suggested-by: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

FYI, I have applied the patch.=
