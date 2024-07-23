Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4DC43ADE
	for <dm-devel@lists.linux.dev>; Tue, 23 Jul 2024 03:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721706676; cv=fail; b=XqTFrbHryh/lzPfEQtvAvORlp62Jkzcr/sVp/nEDF0QBAUdu1ojqsJq33v/56U6U9r1TEqZMBny5ACGhmVZ4E3dN8d/08U6SgJAQQm1rAKn6rdyV9JTzdF+wX9wToPk5grdi5EPhiV/TAohGHLdF+vLhfoXDjxd6/cbJ04uKfek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721706676; c=relaxed/simple;
	bh=bKtBa11NeYmmr380UN5Ay7ITh6FihljXByUc6ry7G+U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oqEIIKGqNb/ryIi6pwpBGjn0W2wiHo5tu+rLeBf8qQMoQXzsHOn7SfBz6Lb99yWBD6K4+1xRY6ZSeftguFDCz866NjPYX3E8wjGQjTWMabpFvP0xRdSAkqVSRbwsMORr83I/WgfbvrJK/Ie6UMOPAEIP0MIRyoJMMUmllx3/IWk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=oVK1Pczn; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=G43s2qmK; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="oVK1Pczn";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="G43s2qmK"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1721706674; x=1753242674;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bKtBa11NeYmmr380UN5Ay7ITh6FihljXByUc6ry7G+U=;
  b=oVK1PcznCyvbdJd4uua21Xypj12dnukwI7ZWpmopdOAICTDvG+RdU9P1
   MvfEPX2KhqwNPoCTsdbrtN1Bg1q95jO+OfuOw7Lg6oSD8EIxHClOMH7IM
   beZ4kmXVwFVAg+aEEbONdwrUZVPAkEZfJzWeON7EMyNxAKCebemb9i+gn
   KkTsiYxBqDnDTmG/Hjnxs/Q7lkFaCZAnzapJYcqHa5TRxSPVOp+66MCsV
   qXuV2l9416e04riGwlahyJUSbSrxHajzm4uyZHlPcfbWxpqZ9tzbj6sOS
   GR5N9OOKSsro/w2jvGpPHhpGaSQbG+19xtMpgvCoswe6k1zRloDDh9SM2
   A==;
X-CSE-ConnectionGUID: EyUg9CD+SJyp9Nd+Sd9CMA==
X-CSE-MsgGUID: uVNW8zM5S/O6yc7uV3NuRw==
X-IronPort-AV: E=Sophos;i="6.09,229,1716220800"; 
   d="scan'208";a="22721581"
Received: from mail-westcentralusazlp17010004.outbound.protection.outlook.com (HELO CY4PR05CU001.outbound.protection.outlook.com) ([40.93.6.4])
  by ob1.hgst.iphmx.com with ESMTP; 23 Jul 2024 11:51:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M3oiWZqapR7br+y07/mQurhf82FTn0BrSPVlTHeiw6biE9ip+k4h557TyO3XXR8TgDZDq+yi/V3Qu2ef6U/PMTtk2NStsDIDC/7Gf19o4YNvlVCYZUP4PBZHs9HZ3A8kMpzdJyOrY+7OvMk9vik9Tdt8lUkhyERUX7JLNHjXEPcA8dpp69lJm2zhzGvLqv5RCWvdrTg5uJaargLwXmqVfRD8UBFD+S0Tp1r6lAbiq9fTit6v4nD94lWOdIOS37vfW3MKPnRcZV9UCmgdmoAW5OkDNuGCdl8eigkoNm5G1wlIRtvQl609SD4Fniu8SIpZjA6gdVZxNvMDNABdAeHtjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VG8FV03cFYX65IlrkFowRkt5n2Ysq39z7SAYD7h5UZM=;
 b=aPLdmv65O19QPxnnOXgexIcM7nHZb4FYEXHz5ih8t9rsPGCVoh5OE9HcUiOYcTNIq/JoWZBQ81Ruo+snfkXSOqmhQZJismZmpnkm1QnYIOMbGC9YE3uWF4birRrjBOWb3Pv/IxJUW8Lu8zN/gdRxGXXn9zphRjU2pw4g/mWOXidsHXlwnC5oSlE/8FpiR5w/dYU1pnTB3tPk5SNESAwGvOixRslg4sBkNgZ6IL+sNF56UR2V7ixNmB/43h56uBjW+zYhErr0GtBDPl32txYBRdIvmCUx73GehqZ99iapfCsD7Bm4gGi5erMIyv9oiPCO9IaGfbYCxxJmGmLBc8MdEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VG8FV03cFYX65IlrkFowRkt5n2Ysq39z7SAYD7h5UZM=;
 b=G43s2qmKZHIVjzSZFRtyG7fryIp0L3QU0lKdA9yWeb2jCLsBJW7VAgbJLeiKieBzm2gejTOar6zs0BlPz19OiaVYQuXV6h7VVEeUXuB75hP3k1nG8Uvc9qmgNr3LI5rBYMmMawvBg+iIS/qnnJnA9lo86meyNxuQJz2a/VStDhk=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 IA3PR04MB9403.namprd04.prod.outlook.com (2603:10b6:208:50c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.19; Tue, 23 Jul
 2024 03:51:05 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%3]) with mapi id 15.20.7784.017; Tue, 23 Jul 2024
 03:51:05 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Milan Broz <gmazyland@gmail.com>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, Bart Van Assche
	<bvanassche@acm.org>, Mikulas Patocka <mpatocka@redhat.com>, Bryan Gurney
	<bgurney@redhat.com>
Subject: Re: [PATCH blktests v2] dm/002: avoid device access by udev at
 dmsetup remove
Thread-Topic: [PATCH blktests v2] dm/002: avoid device access by udev at
 dmsetup remove
Thread-Index: AQHa2ZNlldtWYewTdEqTlH0AgYoE0bH9o1QAgAYQmIA=
Date: Tue, 23 Jul 2024 03:51:05 +0000
Message-ID: <jzqlbsnwukr55s6gl2ajneo4fzj44il7d6235sguhjgsopa7zt@xld57gkaf5us>
References: <20240719042318.265227-1-shinichiro.kawasaki@wdc.com>
 <b53ffb90-096f-41f6-b7be-ecbe8e8ac786@gmail.com>
In-Reply-To: <b53ffb90-096f-41f6-b7be-ecbe8e8ac786@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|IA3PR04MB9403:EE_
x-ms-office365-filtering-correlation-id: e3be59d6-73f1-4ec5-444f-08dcaacaadd2
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?fxdnoylHNr7bpgk3xoNX5HC9TrW58YpUvVaxscPekd7O2YQgKpMTKHkegl0Y?=
 =?us-ascii?Q?6gL3CJFAfcWtqajHlU1jCEw4IyjvQ1kprgudULNBdifMJG6uO84TWFlcEkqM?=
 =?us-ascii?Q?bv8I+QuOn+V/UEQOMbIMTK+uMqDV6vixZ89t0DXVuVcKzyBXQLEcRJy1vGQB?=
 =?us-ascii?Q?fl9984gKCxcll6Z31E0P5EDYBdiYJ1ra+GB/5LPAUZ0LqrGleCS7XYBJrCoP?=
 =?us-ascii?Q?DY0JJMDJq/InbrMZwbCuoIFG7/AfdmXZSJUsHeT+3KEySdz/g+UXvxYDWxYE?=
 =?us-ascii?Q?35G1DJNje4diFjJ0HfD1cSQ6YoBCR/wloz5nAbVRoXuxXtmKD7Pq7m4nw708?=
 =?us-ascii?Q?poOb8YvzBRJNgplRQWLtM1MT+XXcWA77tlpqe+A1Qqcvqet7D51FcHgHemJw?=
 =?us-ascii?Q?oJjG4uUqN9qz0JXKUGE6WPEGmCdPz570iNK5PpP/20FqKbJDG1T98g69K7jj?=
 =?us-ascii?Q?eElREh2n7ybaSZS/2UgyGqCH4CmkPzPZaZuDcSpq102I55Z/JqFBgT4p+NUt?=
 =?us-ascii?Q?7BlXIefwMlNwF9R1UNnC77PzG7a49+9U1Q0wJWNRqKodDJL4uoy41rg9UnNx?=
 =?us-ascii?Q?5wW/U8IVj6x4kaqjMiwnBLaPadFyi2DvUBLC+okBfLdQSUoVuNBJOgUhhve0?=
 =?us-ascii?Q?MuLE+7k0MAAPoB3CRo0e/Aj13qTUk5t3I+FoAi4mq3PWrVxy4iS468z3s/do?=
 =?us-ascii?Q?27P1BmGMsFJ2NMLjY4QZxtFPtk42BAZ25eo7T7a7kEYQqB66nkXWvOlPdnVL?=
 =?us-ascii?Q?5E+lxhGkesaAIz07a438bXQ9efMn0vLie+iIQ78BTIinSV9VcsMPFFFCXSYB?=
 =?us-ascii?Q?fgXTbOcAofKk/cEsAKo1VSjklGR6hI4shvduOhzEzv+sOwPeq35iAeEZwqy5?=
 =?us-ascii?Q?2vb+50V/B8Faj+VYKmyZQAcJmIUJYYB35msXXyWLvxbHyXzRPFzao8JexsfW?=
 =?us-ascii?Q?DAGMxnZhQvjM9H0AKcP4xViHRmhKftMnfNTktwDyXIxr+BTKTf/acsn0EX1X?=
 =?us-ascii?Q?7H/XP/uCiqJQaTil4W2EbnAaBOZdTmYJcn7rqSlrdL5hm79NKyaVaoX67p9w?=
 =?us-ascii?Q?ce89HYW4mk0ynLoCHx/sCP9V9LSnaQRzSzJJMdnC4f+ykwPydmezZgOcRhke?=
 =?us-ascii?Q?iYO4SVWBwZip2UTvrnJQRLE3kMwVMl6Pjp0OQ+RgflfoR3BvgoSD2QN5UNK8?=
 =?us-ascii?Q?FehreJFwnICssLlwmXkY01Zo7eMFAZdthjwv+4QIBEH5lYfh3M9P+lMNzbxU?=
 =?us-ascii?Q?YGgNgAoQhrnJ4BU1uL/Nkcy1kwXVGqMeOvYLFA+RN4Y4vewIppC2IoXiAtOt?=
 =?us-ascii?Q?0OwhnVUWgr2vPeJ2wcRkNk7dx7qhLrlsFtXUqj0E6Mz/XHdsvE7T/8xVu1Bo?=
 =?us-ascii?Q?rzHVDfBJqziK5sKPXQ0ZbsFrIhfa5uXn0k3s7XAs6Jd1COq0UA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Set/cmq6F+wNfy1x0e8gk/1Y0S1lM2FdGVAvlfApJ8+dfE134JY/O8v88OW0?=
 =?us-ascii?Q?fLkEsPGG28dXCA+mU/wJiwXuOKV74lujk59MRZCFcJOGhwvdYwLzv4/z1rbz?=
 =?us-ascii?Q?1z7p6IsqSx10jsetNj9WzK4b7l4vfrtOWTkHxjboeSQziXVeB6yLHA1lCi5N?=
 =?us-ascii?Q?K1mrsWeXBYN21dL+ORo0XsbJPu3RYtO7KyO5pvAbf3OpdHv4kxUsBKv2LWCo?=
 =?us-ascii?Q?EXxWWC213qHijRuAnpBeVAs92292q3p4VrPWminpN2aimi4/bKCKE0wvjGg6?=
 =?us-ascii?Q?cqcXPOHPMpwHri1PBOnWr4+MZDDCAA1mhSBCKB4ADlHRhneKSGU3Vy9m3JLT?=
 =?us-ascii?Q?XIr5yfrqMOQcdEXyGZJUieYhGP4LezpW0tIxAEn3Ku6tVzXv7GHEugW81N/K?=
 =?us-ascii?Q?idT4CfvRzYps5ZnyeJCjEKbbBECN213pkFIidWwKje0yVxVYZ7t7JxYv5H3J?=
 =?us-ascii?Q?SbGX6t9oSii53JLAgox3dKXcc1e+0Kb1+8M9+BQQHxV4TEaewDouhRxR3pVt?=
 =?us-ascii?Q?lXyfQqmJhWNv7Na4sa2vIM433sHPDliavO00jF51etEyfKyhkSuOVkznKw9W?=
 =?us-ascii?Q?9qPSy92RTr/WUA9bwUe4ITc/9Pky8cJf2DgDG6uBXWqSFZ+7woUQ+caI3umV?=
 =?us-ascii?Q?JUczzmzd5efrHX82LaWJBgYTrURXI5/PmDS9MzwB5EI2RreAaUWCUdNwHEOw?=
 =?us-ascii?Q?tHFMyUGF4n0CjXLIkd/MxLeh79reCRuBD57yXQ9w82SkJ6WG0srthdaYr1XU?=
 =?us-ascii?Q?YF5/0pLlWK2W4zUliBLR3lcSQzgSwxvIg3ZIhHt6KdhCa1PzX8srtPUOxtkJ?=
 =?us-ascii?Q?okToQp09PZ3Km1QnOw0cIUJ07XzBSqk5OR/x7EGDl3GnwQWOGrxTnpv1w9VS?=
 =?us-ascii?Q?o98X7XYus63osLxitIiQ/ZHLvKOVu1ImjjWSLjSUhHYhrjJHG1lNZ8BQgXs1?=
 =?us-ascii?Q?A0bx4QGwxNivgpR8t/3xBFfVYIVmHj6wyZ2NcJZ8m9IMLX3XNjxoNI2jTDS3?=
 =?us-ascii?Q?9Os5A8y77P2PooQ8XY0h9Q+P37+yxWnrqtch2XaagVRkQENFITa3RqOzLwv3?=
 =?us-ascii?Q?pwZpsu4kefTtodk6KObyfKbQsL8g0HFid+RPXT5AtqvoHhCNhIJh7MwcZDd6?=
 =?us-ascii?Q?csPraldoouTnl+lBNeVrYRSBfGuLFRUX3mxhb6icyevbGgRLl4NOLgSRpuI2?=
 =?us-ascii?Q?HY/eO7lhoQhet6N1d72junF3hu5ob+UKQTNAGTaME2WF/5BGxixrc479XW6G?=
 =?us-ascii?Q?ZkxqFz7yVdgZJg8S2CFe7OpH9T6Mopgq6ySuK2Zu6J9EEgGG5Y/zRkGObcXJ?=
 =?us-ascii?Q?WjdnaMrCFxYjFtVvlGT21P4DP0cRcLOPljaegdxyywvtS7RW8t526goP/jMf?=
 =?us-ascii?Q?FQtVa60UeCPXBwfCF/5RKkBZVxRbJlPGlHgfXWGZvcNpyHxfufXdUF/xiEmy?=
 =?us-ascii?Q?pSysOLz6weG3bCiCRP/eK9NsR2TZdy2oypQpue+OYUZdgGH4M9GlKXFyXgcY?=
 =?us-ascii?Q?3WrQbmNIDm/IKayyowZxqQJvkB0B+fzlPGZKbKL7lNsBNC2TeFo8KxBQDoNH?=
 =?us-ascii?Q?ihUD6ktWkQdxAWVzSt4WCuUpE+Z3PGkf4JiUTqZRzTHbrZv/u6B7WMCJ/ogt?=
 =?us-ascii?Q?wYGywM/O6bnuFgiJniMNpcE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <978630DB471D8040B54905DE77BC56FD@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZUW5EO1UXTqFy1fo0rpDuMhJubEGz6/W5gXRR5SUdOHPxYBkTQ+AyAl+4qQhEHnjx5w9KsIm5NJkTLUoOjKO7y1xr/TdqbQzI1rATQj4bQe0MfOFwLfLrgXTKHCJAzDB72g8qArFCfMZbWSx61TF1HrPZfyDV5z+2gnFND0WodGn8eNeRutVyUniXpH85WfKDpJjfHUZe9QQpt5kRnLN/lmVkNb8bZx/OlwNqcpngcH0dQV5mZxItfZGxgmaIKWdvSA7B8l4X8OsV2MkB435ZL1ZMDDD1FaSglKYqE4nOXHGh9xNHP0YYWnzPoiQBvllVevk5WEeIYOkF+NIlZAKGB1wQ3gttn9mF7YuZhOZuAzjlw7UiyvEP/46unDI4Fe7gZ9511YxJo8BlnqY7FIQUtQkAGm6HZZ7asYyODfSlihMaHw7pxwIB1RJYVIOVni/FzhpIT9xej/mTLOgrlzlwbL1mtfJUd/3HHEqLGF58cwLpSVzNf04HPJbaoNRJjniRgATMrNldH8+ZF/iX6SHAzeOFCyEKlUKuD9OmXy4QgX24KjKT4+C50iRMT2LyINIG4NM+QLyXSVG17X+sipY9qF6TfQlsG3bZewwNGeGVAZnoY5tjnQCfOcCfiuiNXY/
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3be59d6-73f1-4ec5-444f-08dcaacaadd2
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2024 03:51:05.5926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l8yhu4+j8HIHHJai5HWuWY+K0g9VWy71wyFMAymiLPYuWo7zUgH6itOD1LQ3JAAMn3vLadka5dvSMNKwTmdQ8byKhA2lGKPKHFDsqQRBpGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR04MB9403

On Jul 19, 2024 / 09:14, Milan Broz wrote:
> On 7/19/24 6:23 AM, Shin'ichiro Kawasaki wrote:
> > The test case dm/002 rarely fails with the message below:
> >=20
> > dm/002 =3D> nvme0n1 (dm-dust general functionality test)       [failed]
> >      runtime  0.204s  ...  0.174s
> >      --- tests/dm/002.out        2024-06-14 14:37:40.480794693 +0900
> >      +++ /home/shin/Blktests/blktests/results/nvme0n1/dm/002.out.bad   =
  2024-06-14 21:38:18.588976499 +0900
> >      @@ -7,4 +7,6 @@
> >       countbadblocks: 0 badblock(s) found
> >       countbadblocks: 3 badblock(s) found
> >       countbadblocks: 0 badblock(s) found
> >      +device-mapper: remove ioctl on dust1  failed: Device or resource =
busy
> >      +Command failed.
> >       Test complete
> > modprobe: FATAL: Module dm_dust is in use.
> >=20
> > This failure happens when udev opens the dm device at "dmsetup remove"
> > command. To avoid the failure, call "udevadm settle" before the "dmsetu=
p
> > remove" command.
>=20
> I think udevadm settle is overkill as it waits for everything, not only t=
hat device.
>=20
> Did you consider to use "dmsetup remove --retry <dev>"? This is one
> liner and you do not need to implement the retry yourself.
>=20
> We have many such situations in cryptsetup tests and --retry was enough
> to fix it (as the busy comes usually from blkid scan that is fast enough)=
.
> It will print a few benign messages while retrying, though.
>=20
> (Just a hint, I am not nacking the patch :)

Thanks Milan, I was not aware of the --retry option. I confirmed it avoids =
the
failure. I think it's the better than "udevadm settle". Will post v3.=
