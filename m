Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8427033CD2
	for <dm-devel@lists.linux.dev>; Thu, 11 Apr 2024 04:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712810323; cv=fail; b=mcWtDLQPSMD4wwvWvT/bTfXjLg304owlYbxfJlCLlZ87zJNjl6PCoDD9HQ2MIvacxQ+aYJkvE7r9XFv9AJodDo+p4yWZAJt4YnfeIBGAcL8QscrDilvecXJYZXma7xagCXWGUbnNHmVWYkl4pQXIMiQFVS7a6S73uBuON8pdgDY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712810323; c=relaxed/simple;
	bh=Tv0+OREBJXfvlZAY9Cn3YlFDjS3UuAGzHzIxqdL8fmA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=L5289JHYwTVmWznMdfKSuJOOyGlM2JrvAw+GmzRWPjePwHaXVgYg4lsn+gnPm4iIeEZMeWhCVq/LyKiAMyxhrQwU+PFpAqzwxqRr6W9Z9if43Rv80zaZGls29aBsHQoFZcTz9TUB4wTIYbA2NL1enKWxjM0mC2j2jSmxnZuhVHQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=qBhu9a5R; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=m+12EQER; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="qBhu9a5R";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="m+12EQER"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1712810321; x=1744346321;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Tv0+OREBJXfvlZAY9Cn3YlFDjS3UuAGzHzIxqdL8fmA=;
  b=qBhu9a5RDTdJKvE3N6vxIgnI8+Z6srRrRWjv9tUcsYYoI9oXsWK5jVgi
   w7m8fYNZiPrX4GX2QnlIXmOQmMPNBEY5Rujshk5zKfHpY5fcsY36ETKon
   cjlrqJL97JVqU3tddXCdE/shspURPAGlWPzFFb0DWF6AgYNKCTfh56Srg
   N9GnUdZ0bd/PiZgzWN0xiLsAkghS/6JBrrUqLCJVU/ZpQQ2KTm4nLm3Nc
   cx4oTSljZG/7Ek587WFdbj1BZgkRg2+BzuPk3/SBK/30B6w51cfz5MrLY
   qzuA20tCiKslNlUxKUaXBhwi8uLIZWhw9ok5VtNrhlVyAMlCoQwb8gXo0
   w==;
X-CSE-ConnectionGUID: SzDVzhLzQgiSg7mNBDN1qg==
X-CSE-MsgGUID: +FSbsdIlTeiaIB/u8oBedw==
X-IronPort-AV: E=Sophos;i="6.07,192,1708358400"; 
   d="scan'208";a="13985223"
Received: from mail-mw2nam10lp2100.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.100])
  by ob1.hgst.iphmx.com with ESMTP; 11 Apr 2024 12:38:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oRz2LKgEP9nZX7azafjzL90VlrFfatd1EN1KRtG7KF824+kRTWOy8f7kkaS22V6AYF92U8/utSCkulu19Khj06GLha64kgexJPsC846XeiNkvrec4Fh29H58MekCch/dt306uMODgL+AH5e4WgdJnPr9xDPfB4vbGJHDTnhsTt7fK1Ih9Yg6lOgL0i6fpGHYz740PG78HbhpsUfPVXBxlx0XteDp5zlHal9eVvHfHDULIYOMnhkLfV25CewsSIaQT3hlfRrjJ+PeZHcezgeqElPg6FJw6GRvdbUqwVJUwGCdd7XZpwqdHo9qN6ylmrXFbN/e6iuVT9w8t85f8Nbgqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1OUsiQ8DtlqSqSDBroFdAj7R7i/rOUKc9EjkeDmLisI=;
 b=jsqmFVtS6ttDA/nojL47b4eNY3hE04PcapwE1Ub32cE46YTvu6FPXd9blWneSzmgkjnedL+xRjGOI7gFbIWHNGQyNkf/qs+42EoktcnDPkFFoksTimpYJdmBRW5NslWo5oOVIE/UGm9NRTi7o8MCxUZryzQ1GukPsbLQdjQ6k8M8WQ0Jew9HR5HvkWnOJ7APc94M+5hsGsA7ARRCWMPEeEzCGqAptB/i2X90asTLYZf3KxDnF21YjdKfaN5jwRdyeUnXSXIkxIWhNvhfQ4R4AzXHWCHreBSGzTetsTO4WXtijMJr/my/tUs3ljqYxMVOBCwMdkPODAa402nYbnlk0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1OUsiQ8DtlqSqSDBroFdAj7R7i/rOUKc9EjkeDmLisI=;
 b=m+12EQEROdukRXUY7lmp9zQ0VFfzo5pjjY0sDy+qPRi5oFc46Rr84rY3qJ/VeJw3G/2Qu2jzhwdveVKd4rjhJ4+ydAW/anJrOrgnSXjxm3YnpFdSb4vN/c25b3gMsAgXY8Au0re3Ps5Ydq1t9QsLLlC7RWir7iYCiPuXQqLlWE0=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 DM8PR04MB8023.namprd04.prod.outlook.com (2603:10b6:5:314::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7409.55; Thu, 11 Apr 2024 04:38:35 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::c75d:c682:da15:14f]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::c75d:c682:da15:14f%3]) with mapi id 15.20.7409.042; Thu, 11 Apr 2024
 04:38:35 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Tejun Heo <tj@kernel.org>
CC: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, Mike Snitzer
	<snitzer@kernel.org>, Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH] dm zoned: Drop the WQ_UNBOUND flag for the chunk
 workqueue
Thread-Topic: [PATCH] dm zoned: Drop the WQ_UNBOUND flag for the chunk
 workqueue
Thread-Index: AQHaiyN3MAt3ravZkEmOdAHOryyyUbFhySCAgAC00gA=
Date: Thu, 11 Apr 2024 04:38:34 +0000
Message-ID: <kmi647h6yrkpc2d5zfbxzvv6yi37yh3aonbbjkohvbf44s7s3n@frptyb2kp5vl>
References: <20240410084531.2134621-1-shinichiro.kawasaki@wdc.com>
 <ZhbRm2i3OeBVwE44@slm.duckdns.org>
In-Reply-To: <ZhbRm2i3OeBVwE44@slm.duckdns.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|DM8PR04MB8023:EE_
x-ms-office365-filtering-correlation-id: 34e583b6-80cb-41a0-9e38-08dc59e13fb3
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 tAxnse06dWgJwH2Wl4NIqMASdbKzw97/A4NJE+Tx1n2L9mmAtyJ7TJI2uUle5Dp+DVovXQ1jUaaRfrq7F6h1sDADhAKATJzGiGfopDNG8tDKCafbGPySjLijausdkEaRBt5+9T5TjpVlBNvI9bjIDT0Egxw4G6y4tV/l6esWViNR+hrFlBdjP3lX9FKoetMeAmQKqyWOGURQ+JRCTXO21PVlJrYuFDgoI60171uu9T40zfJOTVzLDGAhiA8c8U4INMMONSvM+PIsfhInOQUqckIoTeHPnDSe05KEAPz5Bs1WWIAbhLAGZ+S2XXBc0P1iRDu0ajX5CR2USgTo3Es5Hnb243m0WRWkpQBF6ncMafxZYEokCQvcg9bT116vxkv2feQCyDv6KSzqUpYCUCt8CBvcDqn1dXn0owpjuHEiBproSKvawA2ZKaA5TrIylRUs3hSoqSqHADy11M7LcKsBaeXEuhaUyFfYQk1Bv5ras0koUFyPEOHeu84cOyZ/CP5GA5eUvg/PvCaa1I9E69OjUyeBjWsOaGrkaCiSj9cz62cbtCeUp4UQbmBm6MTAJTSsLYQyzlCl2jFskcWGg4gMGImey6rxgxrgQ2wQ4hxCtipXX4JJ2Gx9RvVOahoOLNzEl0LB1WvSAIK5t7JKE5GG5oMQYUeb+EVUoibv5YTycs7ugxr/Ha95z7Ss2fLXEHmNX2X8FCt7D1w2fMi83JL6NLTlIMP7MazC5QCPUKX59UY=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?A3wDxEBTxM2euiYSK6/cbdmgLxpShDEDDeCfGTSV+WExqqtxoHSkmLk9XdS8?=
 =?us-ascii?Q?zWPCPr/Orx5GGfzCJViBaQO6deEJGirHNX1GErUKogl//YygTNMbiuvzh98m?=
 =?us-ascii?Q?B4Rd9mK96swsbQfCZkuZ50CJxRXf7eumTACxcD1b2RBXr+8DPFyit1Psi/Qn?=
 =?us-ascii?Q?zbnpDLEUxqRwC3ZPEglaC19yznxqcK72PHeQm0LaZwoZ/MLRBf0BnNFYsQCA?=
 =?us-ascii?Q?rrvsvFYoe4VTffnKaQHzNdlHPExt+jUCWk/91N7aoEuQ9W1hH3dNIzMu3b1E?=
 =?us-ascii?Q?n5bWJtxKSsp3UmRAvZJMG1xMiBcLKgNCRyyttIFTdB+q2i4ycqwIKS9Rr71N?=
 =?us-ascii?Q?DXaLD5HHtB5N2Zo2WIKX7EghUeaoFfDP99MNAVA/zehT1TnJKEM8ugzAohNU?=
 =?us-ascii?Q?AGyrlhLPRGnfu2X4jgA7XqL/TGoBS2C7HSCl5L6kv0GZIoqb3GL8kT5d3SPp?=
 =?us-ascii?Q?bdDugDw0sJO0++G7frRkVC1KfQktwOXMiJQzTrMFsDXHsVl1QXIRaNUJv6Cg?=
 =?us-ascii?Q?PBikziAOMqolS/J/WYfOgLHi4p1f/acAIAWs3AJpKOHzqYe1F/5PGA7lYqrf?=
 =?us-ascii?Q?fBbyVOeN4pMdMdS+V+d+/PBO0kBPC/P+qpf/C2ZRsNtgfeR2DMwuc8INGsW8?=
 =?us-ascii?Q?0ao1ecXqdXlv+HNzkxTVcP3DJ1Z2+GqlXtDcqy6ub2dewTSmp6k795WQFNse?=
 =?us-ascii?Q?DWJ7nm5LYThGr+ndNX250mt8WoUT4xxkw1sY6YUz6vs+vAJidF3/1kROebSe?=
 =?us-ascii?Q?Rdl3qNudPDEUYZQWoDXsQ32ke/QXEBS5KNlPG7KpMTGgk6JBPFg80xInMa5N?=
 =?us-ascii?Q?S7vQtGjcGa70L73hqeoEM0VtXedwjCjh+nEdMAo13ircFJv4eA+eN5wZE8cp?=
 =?us-ascii?Q?M7mRacyOvvBE1r5NHfOuxcCmBY7C/VY1GQLXrbdlefk+dGPvxE54KyKoAIBR?=
 =?us-ascii?Q?JDFrSHMGl+52z1kMkTz1xfeOPz60Ub4Q5iRUBADakDmPjsCOti4a5KA9xzZz?=
 =?us-ascii?Q?5jnWVx4rRD+ZyfOlCRG7RJyf+FF57vOU4KdGxVlJbWFjcRu6nQMtKWCOPERX?=
 =?us-ascii?Q?tQ44wVpsvJRmpAD7+24IJxb4NbBjEwVGSKzyEt+I1vng6vaPPJoCxVplmn12?=
 =?us-ascii?Q?/D8SmZujfZP2ChyAaFfeCA815Ze3XC4a/UX00IAK0mygoMzBrtoZJEs+6wC3?=
 =?us-ascii?Q?bRouCU6H0WGPGgDdrAt+iekubS6MxstujFLtqu0ojW7LwiTQSaDn4R6RN6ln?=
 =?us-ascii?Q?eXyy3e9YS8vbVn9HyjXNuPAmuMeFZqo0jcoLxWxROB0bEzSdTa/idRtFQlzi?=
 =?us-ascii?Q?/dbmRNL4gpFHXihHZ+8uB6Vxok94QT4Xl9k1qhiZ6Ujxh4qeNoRP1QCmWS4w?=
 =?us-ascii?Q?0TutjUFAFDtnYpzMvubAR0kDn6mWNblN5ubt7OTFaOn4S0zbzDD4KUId5yQr?=
 =?us-ascii?Q?glvv03GnXtTnej+CTohpYY6XXG7zJSlrEZ2mjDD+qf7IgZM7y6nGsC+WV9N+?=
 =?us-ascii?Q?oW+3UCNeJgFO9yL29yh6QYBPR7yTQDKijPYEHmCp1iuXL80wnMK9dJA0+CyL?=
 =?us-ascii?Q?LVRkUfDD7VsDtKTq/nQ1ChU+Ki1bX0LXKewQhAr1za750NT20ApPKnNM8YLH?=
 =?us-ascii?Q?azzXyZZVO8F9WmPnxHptJOg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E3D10ED10920C84CA9B082A20A3F7356@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9cvF1pp+8XEwQDYWsCF5DQh/XozJB5sRYTgzVgyY49a8yIh0QzkdXABApQPJcuEhXbdu8TDEdNrOrZ+Iuw6ebHNx19DF08Ppy+FymFZbRJ9fn/y6B325qjPW3FFXrVJtfD9VSP1nPSKvsxp060XuiP+YH5ySC7uss0lkR/6gErJJwrPJJoK5S/1qWhNsGM+H9yGEAIReoK+Dzc2OqztzphCiwge0ZgbWndOW0PB4JHf77yIVowunEXPtJHmpPIritpL9B4HYnuV2kVeOHQx8RjyYnfCjHkj7KeeaMPJH27rY50U4dAF7XSlQ1spxAm4Q2iUhoT4wneyvmfyl/Ooe7wW2pL2tJsM2nLmQg8l1CBqc5CjytwehFbQD9jkgHi30J8hD/Xt6O5AC+NBz0XcHntLbQ6WyTevd+iBRz+odzQdxeRxDb+KynDPGZVXe7jrVelS8x54hRsDburP4dGrViBsVgvq1FKfimoNXpls8gZg9/VDVq+0vKEJQ2KCFHVv38uZQRI4FLoieI6LqSbfyNoSpz/1wVE+NBkInhMleix0W+t/24VHABTMRooKBdpZyk78trqBFHnw3d6nK+oKEgWIJS6JwsY1lKQqIz2RhaRg6Fzf9mI/pzxNes0CgwhJt
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34e583b6-80cb-41a0-9e38-08dc59e13fb3
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2024 04:38:35.0445
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hDu6T6TOZt++O4fMlRD6rdVvYLFR1gyjBxPzEa2+g7a7iWYZEsWQZfRByZajThLZfZ1ZCPbIL6zaqhcG6vF9+COvaixkcEYCPZjpJekj6ps=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB8023

On Apr 10, 2024 / 07:51, Tejun Heo wrote:
> Hello,
>=20
> On Wed, Apr 10, 2024 at 05:45:31PM +0900, Shin'ichiro Kawasaki wrote:
> > Commit 5797b1c18919 ("workqueue: Implement system-wide nr_active
> > enforcement for unbound workqueues") modified the maximum number of
> > active works that an unbound workqueue can handle to at most
> > WQ_DFL_MIN_ACTIVE (8 by default). This commit thus limits the number of
>=20
> This shouldn't be the case. The default max_active remains the same at 25=
6.
> MIN_ACTIVE is used only to guarantee minimum forward progress guarantee w=
hen
> @max_active too low in multi NUMA setups. It's unexpected that the commit
> caused significant behavior difference on a single NUMA machines. The lim=
its
> and enforcement for single NUMA machien shouldn't have changed.
>=20
> > active dm-zoned chunk works that execute concurrently on a single NUMA
> > node machine. This reduction results in garbage collection performance
> > degradation which manifests itself with longer unmount time with the xf=
s
> > file system on dm-zoned devices.
> >=20
> > To restore unmount duration with dm-zoned devices, drop the WQ_UNBOUND
> > flag for the chunk workqueue, thus allowing more than WQ_DFL_MIN_ACTIVE
> > chunk works. Though this change bounds all chunk works to the same CPU,
> > it provides more parallelism and improved performance. The table below
> > shows the average xfs unmount time of 10 times measurements, using a
> > single NUMA node machine with 32 CPUs. The xfs volume was prepared on
> > dm-zoned devices on top of an SMR HDD with 26GB dm-linear clip, then
> > filled with data files before executing unmount.
> >=20
> >  Kernel              | Unmount time
> > ---------------------+--------------
> >  v6.8                |   29m  3s
> >  v6.9-rc2            |   34m 17s
> >  v6.9-rc2 + this fix |   27m 12s
>=20
> Can you please run `drgn tools/workqueue/wq_monitor.py 'dmz_cwq.*'` while
> testing? It should show how many work items are in flight and how much CP=
U
> time the workqueues are consuming.

Sure. I manually ran the command below during the unmount operation.

 $ sudo drgn ./tools/workqueue/wq_monitor.py -i 10 'dmz_cwq.*'

Please find the command outputs below. I captured the outputs with three ke=
rnel
variations. Each of them shows the output for a minute.

Kernel: v6.8
---------------------------------------------------------------------------=
-----
...
                            total  infl  CPUtime CPUitsv CMW/RPR  mayday re=
scued
dmz_cwq_dmz_dml_072           825    76     17.1       -       0       0   =
    0

                            total  infl  CPUtime CPUitsv CMW/RPR  mayday re=
scued
dmz_cwq_dmz_dml_072           825    75     17.6       -       0       0   =
    0

                            total  infl  CPUtime CPUitsv CMW/RPR  mayday re=
scued
dmz_cwq_dmz_dml_072           826    74     18.2       -       0       0   =
    0

                            total  infl  CPUtime CPUitsv CMW/RPR  mayday re=
scued
dmz_cwq_dmz_dml_072           826    73     18.6       -       0       0   =
    0

                            total  infl  CPUtime CPUitsv CMW/RPR  mayday re=
scued
dmz_cwq_dmz_dml_072           828    73     19.1       -       0       0   =
    0

                            total  infl  CPUtime CPUitsv CMW/RPR  mayday re=
scued
dmz_cwq_dmz_dml_072           829    71     19.6       -       0       0   =
    0
...
---------------------------------------------------------------------------=
-----

Kernel: v6.9-rc2
---------------------------------------------------------------------------=
-----
...
                            total  infl  CPUtime CPUitsv CMW/RPR  mayday re=
scued
dmz_cwq_dmz_dml_072           580     7      3.9       -       0       0   =
    0

                            total  infl  CPUtime CPUitsv CMW/RPR  mayday re=
scued
dmz_cwq_dmz_dml_072           581     7      3.9       -       0       0   =
    0

                            total  infl  CPUtime CPUitsv CMW/RPR  mayday re=
scued
dmz_cwq_dmz_dml_072           584     8      3.9       -       0       0   =
    0

                            total  infl  CPUtime CPUitsv CMW/RPR  mayday re=
scued
dmz_cwq_dmz_dml_072           585     8      3.9       -       0       0   =
    0

                            total  infl  CPUtime CPUitsv CMW/RPR  mayday re=
scued
dmz_cwq_dmz_dml_072           586     8      3.9       -       0       0   =
    0

                            total  infl  CPUtime CPUitsv CMW/RPR  mayday re=
scued
dmz_cwq_dmz_dml_072           587     8      4.0       -       0       0   =
    0
...
---------------------------------------------------------------------------=
-----

Kernel: v6.9-rc2 + the patch
---------------------------------------------------------------------------=
-----
...
                            total  infl  CPUtime CPUitsv CMW/RPR  mayday re=
scued
dmz_cwq_dmz_dml_072          1439    46      8.2       0    2812       0   =
    0

                            total  infl  CPUtime CPUitsv CMW/RPR  mayday re=
scued
dmz_cwq_dmz_dml_072          1441    44      8.3       0    2813       0   =
    0

                            total  infl  CPUtime CPUitsv CMW/RPR  mayday re=
scued
dmz_cwq_dmz_dml_072          1442    43      8.3       0    2817       0   =
    0

                            total  infl  CPUtime CPUitsv CMW/RPR  mayday re=
scued
dmz_cwq_dmz_dml_072          1443    42      8.3       0    2821       0   =
    0

                            total  infl  CPUtime CPUitsv CMW/RPR  mayday re=
scued
dmz_cwq_dmz_dml_072          1446    42      8.3       0    2824       0   =
    0

                            total  infl  CPUtime CPUitsv CMW/RPR  mayday re=
scued
dmz_cwq_dmz_dml_072          1447    41      8.4       0    2828       0   =
    0
...
---------------------------------------------------------------------------=
-----=
