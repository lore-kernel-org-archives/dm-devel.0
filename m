Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2662111AB
	for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 06:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="MZ/WLRoE";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="cT7FeZVc"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1698214975; x=1729750975;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VOG2F6MbglIdrcQn0RMQRAa7HmIqS5Ti3kwxBA/gPuY=;
  b=MZ/WLRoELa59SG22icBrA5ehueSYqUy/hjQNrwI8Hkg3PW6AFmxbzD+z
   swYDzknxZk8IJ5Kre8IOHCnY1btVhjAw0Dz+42J3Q/84tS0Mv7Y1Yf5BZ
   LByQl1o1AcMG3JSYRNaoR3lPVA5KgTopXDppx2R57NBBuJfXMDfMDt84O
   tu1EBKZwtnad1PWpX4Xzynnz5QZH4x518IMVY+zgyU1HJ7hYPstrgLbkg
   QZES1gmuEuOWUfjPIMxedADx05baOuOJVp5OPcQj4scq8zk+yx1yTroTq
   7rrefD1GvL/NkJs2VWIAFFOqxCe2ezKT3i1N30HQLF1u+dyqlaw1OrJut
   w==;
X-CSE-ConnectionGUID: UpqjDzBMT72uwBNPLtyHzA==
X-CSE-MsgGUID: 8Er21iB+QW6aYV4XCc0LiA==
X-IronPort-AV: E=Sophos;i="6.03,249,1694707200"; 
   d="scan'208";a="598344"
Received: from mail-dm6nam10lp2100.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.100])
  by ob1.hgst.iphmx.com with ESMTP; 25 Oct 2023 14:21:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y7vd+SugAw+R1LhUatTK6hQ6dR/UKvzLSByrZ8iBDTtHCV5Wr/XYLBxMto+Jiasz2ytfhDNWgCn6J9T0rGhIaYZs05hEZHiwuZUoHRTG2OELzqwZSa8lKa6iesfI0upPfv10arVUmqu8wO5y30oSLZ89mxy7uCKET9rtuuksj8GoibUQ32cPjh1mw6TcmZdF8G0lVSx17I0KxV0o2vpgFoBPR/mRRieOGDlfqweynr70tM4N/jd5Y3VjTHhMNC5z4DjA8K0H0skIYQ89HsV8bhZRK3IxYaz7BB9SXZdMzy5ZTk5+2cvPD1JmF79EmX2zQaqkuz3AsyRm1BiD9gLkag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=23Zsiza9ZqowtyRebttkUJ7sNlMg4V3daFLSi0z/fu0=;
 b=fc+UWh9jQhuj5IPI+2XXfbwxB+fzlGC70CBXifK/Y+ZxeS017yjLnTTJqjnnfxdDOMhi29iratvgNHga8Jhx6XG1deWcs1YrHDva6PoaQ2Hvj2Zr27oHYUoYjoztWvwoqgtTKxPRkm6QMCaWzQmr/wiJ3N10UAxtGzFMW8ext/NsHEtnCR0bOTMIJyYRoDfU+VktDq8PmaYHRtOnpR76gRXC9lfFjOlwoq8gyuKgJoEF7QKttVv2Fdxte5RBf+ttFPu7E7vp3ecLTLnJTw+GiBh+cc3bgNFVurp3Mx1wkozT7aaMV3V45yXO6rG0Q7FgNTIZELyGZ370bjOZPE7HtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=23Zsiza9ZqowtyRebttkUJ7sNlMg4V3daFLSi0z/fu0=;
 b=cT7FeZVcGSBe+9OOSk8d/caGFQdT3C7w8i3Yw/c27aOzZ3wZy20k4+pDX8nOUHAwe0vt2VmEznrpxrNP8pTazGU+1ld++D7DnlLrWARs+GP7JU6/NbMpCJFKM9rpvBvTCzgpVhl2zKUJp/2FnXmiHvwYBkZ1FQMH+Xs2QoTIZHc=
Received: from SJ0PR04MB7776.namprd04.prod.outlook.com (2603:10b6:a03:300::11)
 by CH0PR04MB7971.namprd04.prod.outlook.com (2603:10b6:610:f6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Wed, 25 Oct
 2023 06:21:45 +0000
Received: from SJ0PR04MB7776.namprd04.prod.outlook.com
 ([fe80::9511:64b5:654e:7a8a]) by SJ0PR04MB7776.namprd04.prod.outlook.com
 ([fe80::9511:64b5:654e:7a8a%4]) with mapi id 15.20.6933.019; Wed, 25 Oct 2023
 06:21:44 +0000
From: Naohiro Aota <Naohiro.Aota@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>
CC: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, Mike Snitzer
	<snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn
	<Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH] dm: error: Add support for zoned block devices
Thread-Topic: [PATCH] dm: error: Add support for zoned block devices
Thread-Index: AQHaBgKcGh2JZw05Xkaaw3gCOyIHMLBZ+paAgAAIfoCAAAfygA==
Date: Wed, 25 Oct 2023 06:21:44 +0000
Message-ID: <khah3n74c2rnfpz23thr2ue3qxiekuvklykuukaoyiblivh6gc@3xcwytv7ofkm>
References: <20231023224513.344380-1-dlemoal@kernel.org>
 <fuyglwmrwyvrx6w3vwi2zlkpxqc5mafnf5cehill5vovnwfhmh@ddzacow35ki5>
 <8410daaa-8f6e-46bd-ae4a-c9c362156b77@kernel.org>
In-Reply-To: <8410daaa-8f6e-46bd-ae4a-c9c362156b77@kernel.org>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR04MB7776:EE_|CH0PR04MB7971:EE_
x-ms-office365-filtering-correlation-id: c1cce747-0994-4e87-ba1b-08dbd522a8fa
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 pKqxgLF3z7uF55BrKdFIoNx89EHDdIUu36HDfoenJDyqeR5yBBl+5aM4yiAt4n4enyJuJiABUIcnR3NlDFdhVz9HSYGdq2BdL7od3xTyNdNNXVyUFO/BGm13JqcdHLOX6HYEnX6syi9bgSWkNsN8BsjVZ65XIZBoe4OIBgfLeQ6M1iTvcYFhGnirkDjK5SCUp1YugiRa5RbF2bdydTNFQP61otUfuVbBqYBfykU4Z9PFkMUrg7E18glZkUSDyQa5R3q+7IiNn1y1cEpYcT1T34BMIcP09ENEz2kIRhG+e93OCq12Fva518Ud9wRcF6ahC+HtwSIL6nYdOFb6igco/uVUO1N3DJQvCFKmLmystu/3GLYKEbKBP/cQfYzgQCbn+NhNLaLGYhdnQpAPDGN9XckM99RIpyq2crrfUzOO0tnJay/Ss0Zu6rYByd7jDDYUNjD3ZRokXctrjxpgLnvo1N5HMd+/VfWgrinxSQOUDblVyH47UllAcKV1vBNO1SI8dzYGbHyoeonMrsZrsUllBUJZGMUh1z6d0xKO5WTxIvmxv7FUHdrR58l9w7HfwSo+iTjODhjqH3Vu9+Kg2vNm6qg5wSYndJzoeF2Yj769CDBkPcQ0AtGmEMNWr5CfkpDk
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR04MB7776.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(136003)(376002)(39860400002)(366004)(396003)(346002)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(26005)(38070700009)(33716001)(6506007)(2906002)(41300700001)(86362001)(5660300002)(91956017)(8936002)(8676002)(4326008)(66476007)(316002)(71200400001)(82960400001)(478600001)(66556008)(66446008)(64756008)(76116006)(38100700002)(66946007)(54906003)(6916009)(83380400001)(53546011)(6486002)(6512007)(122000001)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?USUkRcUepIF/5Xe5b2g3lUluFA/drotACW4gkB1MfZuIfCbSshwZGeZSPk3m?=
 =?us-ascii?Q?fiJ+QX6rEV/aCKdL8prF04+u9hpYpVOEI5dupINcE/jHngOI21wkLLYUwP7p?=
 =?us-ascii?Q?tCdbe2RVccJtCHMOjs7yqwP61acP237CLW6LqY3W3/wUFLjKeNPV/jMbe7D8?=
 =?us-ascii?Q?nFRLXoE24AyNB85qEi6CDPTIbhacd72EIak8QOx6sV+V5jQNEt8P1fgUfBqD?=
 =?us-ascii?Q?G4hJBgOcr3tcU1PVpt6l6+6ALaLocfFPkS7pTjcWJHrgA7LlZlQoNP3TZeuv?=
 =?us-ascii?Q?37eEnVX2fird7aJEcl5wHnqFtEpINJYUrUHW4RF5jHOa96Y5k9sP0RTZDgWw?=
 =?us-ascii?Q?HF8cLXab/ixoIea10vdYxjt806RsOvod1lh/VqujVs7dBTW8GXGC4ScCdFOm?=
 =?us-ascii?Q?lH1zbZHEMopi6D8tpDu9LHtV14O4ARoO6d46yYHmV3QhDGpN0LPlH1Q64OE6?=
 =?us-ascii?Q?JIUvW5nXff0uyKAxKNIrZu5/hNueN2OvdrzVMXYszW3YauP1Pm9XUyLEhN5m?=
 =?us-ascii?Q?7lXq5l93x4OkIeyKiIulYRL7QfztIDkqOAQaSF/lzhQpLe11h5oReFuV0mF7?=
 =?us-ascii?Q?QwfcAP8mU1uSsHsWggRnSnqDLmdWM8rQmtsVGz9yWjuQZtsy2YUxPAaTTj+j?=
 =?us-ascii?Q?2yr2GDU2PwuSsqdy99ny7XbQ709JnuLlm8iTTnzjr6MYDUjo8N3zqHgvvT6U?=
 =?us-ascii?Q?F8lN9ck9jkYAEvz/8t2tooenJI1w7MZdMoYz2uV6+CBGw29x4Rgk7atfEotE?=
 =?us-ascii?Q?GDEXdsUnGuOawfTlci6jBVO0851FJYmLgi6Aux4MlXjj+aEMTXwCBzcsgguG?=
 =?us-ascii?Q?lecFLdWdAInh8breZ4gzM6tVgDPpFclm+b3wn75TtYqMXFs/QcMgr0ufkR32?=
 =?us-ascii?Q?1sG8e8k2OmW2uMzrLe1+1yNe6VsV2AX0jGsRXTPLfuIZtuUx7flNfymHh3ym?=
 =?us-ascii?Q?wBvYz76iOAjcQ9sVlt7Z68a0d36UDjhah96A7Dlftk2xs1AWI34FIR58lxs6?=
 =?us-ascii?Q?/QhBixINNY4Cmjt8wAfy8UObN4OU806Uj7Y7IOou80tnGhuM0GjUOq5/iUJG?=
 =?us-ascii?Q?FyoAFUiFUauWyn4UqPL1rqctGY13eghMyNeBz+Hn4e+F4YE2lUGeJqHv7qZK?=
 =?us-ascii?Q?lEiLE+R66X8HT10cMGhJvokSGZwBf53zaT9yU30dj5EXWWM5Kt3hxrS5nFxI?=
 =?us-ascii?Q?lkPHkxoOceKQhgwWAxGkV1fp6p8w6+zBXFwTi8DguhgxHmVa13nZcTpyHhmn?=
 =?us-ascii?Q?TaLW+3f7q8WtGJqj0LPlYz96Kvl108ofseQrcAOX5oqUfFxiWnnQ57FsQz7a?=
 =?us-ascii?Q?rn8DHrkX77V06LwMpNbNxpndtzmmrXolQeY4NTdhXKWVeppOdYuWPZF+xq0m?=
 =?us-ascii?Q?ZKxU7lUU+uvUnitKTwTH8d6QpjH6kKntgWpP9P8Tfm84raULDrFYQrbyPInp?=
 =?us-ascii?Q?tQcrRda97GOaT7hhoNaku6dQqi+SfNGTVX3MXdvMM/xJzvXol47qMi8jOjX7?=
 =?us-ascii?Q?VQMAIGEHJFwaL0nRNAeJR/QNU+2OkUnJedHeVaoLUzzwgo28WGxTz+U5mAjm?=
 =?us-ascii?Q?rxTtQBsr0ItLLwqTDE/+7dNXNGJgx/ATqhqzBgjVLbJREgmfxWYwK5fvIRS6?=
 =?us-ascii?Q?5Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0D8C33D98C3C46488C2E40B6BC833146@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UHai6qalK7nqF1CSHX6oqiVZfKhtGLA/u7D7o67ce541pXPHIcPuWl1rqD4aTYaLLj5g3GxOAc0+/lNQym5VqDoE0ZRcy4xfakOCPwsga/SBwzZAAdiTb3IJ+1Y9fV6hVUhO+DsQxQgLIVSeokAhVKR1m/sHiiOPI9uEEV/CtV6sCKpFJA72d2NFz2mExEpRaUnkLY/rT7eUeEMa3a7nW8I7wZt7elxVjnR/ylYfUf/+aTi8M/wdoEfJbVa5bEDPi6LHmxez2A5TPwSO116WQIC8EH2BrNhDDUjA1eG9wCaAcW627OVo/IIrp6PdxJbyFN3WtfhDCckdgi/gmnGux3V5QagqdqKKuLSIooSEhjGqUHZY1I7FSTKKCR1yJWkCGyyK6i0/v+dZtnO+tedxOTsFO57OjZACC/yqS+sOQ5GkYKgRwJEdLKDS1S4K12ARWTcTsLOBV2iYT20VmVxv6r3XNPZgjRTWE3l14qoQmVFE6z/JDunB8hwCvf4lX98oI0GDWBWFjic+szdcNGDev8Il6akyThpopaS9wfgP33AeveITMIiBFAZT6aO3A77XMaspjlvvL0N5IG5g7VpV3XpwG7mqaf83yvkAKQzGGiLx0BJzewquWm1Vndm+qJn+ALiI+YrHgiTAe1N4jyHQSlwpT6oR0ETQDsMNRsLEr2oA2rdHRod/nbzDwmXKBsK2dllnkjojv5UbKRLywwl8ymKISAIPYRb3zNnw3tly5Cbjv/I9MtH4kpiLPlw9gb73eJVJIDeKJGtnlRPiy3GH2ZrBduwNQtLFd7UfN/SXnezIWUvvtfsEQ9j7HQo+uC/NC2uAM3rUeuYPzl4wrQjCHaKQ8EvQ0APnGdiX4SUMoOY=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR04MB7776.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1cce747-0994-4e87-ba1b-08dbd522a8fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2023 06:21:44.3162
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mmu19j0glP3KO37tUlIm851Hrd2L585M6fgq31/SRyGE3gsZYOSTYNQwciaoC4QCqD4vyPoeWGy9TFc7Gj6ptA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB7971

(Updating dm-devel address...)

On Wed, Oct 25, 2023 at 02:53:17PM +0900, Damien Le Moal wrote:
> On 10/25/23 14:22, Naohiro Aota wrote:
> > On Tue, Oct 24, 2023 at 07:45:13AM +0900, Damien Le Moal wrote:
> >> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> >> index 37b48f63ae6a..5e4d887063d3 100644
> >> --- a/drivers/md/dm-table.c
> >> +++ b/drivers/md/dm-table.c
> >> @@ -1600,6 +1600,9 @@ static bool dm_table_supports_zoned_model(struct=
 dm_table *t,
> >>  	for (unsigned int i =3D 0; i < t->num_targets; i++) {
> >>  		struct dm_target *ti =3D dm_table_get_target(t, i);
> >> =20
> >> +		if (dm_target_is_wildcard(ti->type))
> >> +			continue;
> >> +
> >=20
> > This seems tricky to me. Currently, dm-error is the only dm target havi=
ng
> > DM_TARGET_WILDCARD. But, can we expect that will be so forever?
>=20
> Yes, I saw that. Not sure. Mike ?
>=20
> > Also, I considered what happens if the backing device is non-zoned
> > one. dm_table_supports_zoned_model() returns true in that case. But, it=
 is
> > still reported as non-zoned as we copy non-zoned queue limits. So, it i=
s
> > OK ... but it is a bit tricky.
>=20
> Returning true for dm_table_supports_zoned_model() is not an issue. As th=
e name
> of the function says, this checks that the device table is OK with zoned =
device
> but does not force the dm device to be zoned.

I see. I just think it's confusing as it also checks the backing devices
for other cases.

> > Instead, how about implementing the .iterate_devices just like
> > linear_iterate_devices?
>=20
> Because that would change how dm-error needs to be setup. Currently, ther=
e are
> no arguments needed for the table entry for dm-error. If we define the
> ->iterate_devices operation, we'll need a backing device and mapping star=
t
> sector. Changing the dmsetup command line for all users is probably not t=
he best
> approach... Unless I am missing something...

I thought we could just return 0 when there is no backing device. But, I se=
e,
we need a start sector to call the callback function, which is pain.

Then, how about continue the loop if (dm_target_supports_zoned_hm(ti->type)
&& !ti->type->iterate_devices) ? The target declares itself supporting
zoned_hm and having NULL iterate_devices implies there is no backing
device. Then, we can say that target supports the zoned model naturally.=
