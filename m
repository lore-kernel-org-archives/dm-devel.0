Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2065.outbound.protection.outlook.com [40.107.21.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC1732C63
	for <dm-devel@lists.linux.dev>; Wed,  8 Nov 2023 17:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cIHbxiFl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=afmi4Mg8wdzqRWMc4d9ISskLh5+Gj92pPfs65hYhvseIMq/I+bz/AMuKUNsTgd2DYd3zBTozDn3nh2ghSAKpzobZlf75gYaJ6DWsQdn6mJj9lOLAcLwRp/Vt3VWJqaAgZJfdlsvlXvYHQMm+9RSbAEPK1aJf/GzsIVw5DtjS2RBwb4MovBYodGeP2mqk/qssLEnRd03yAyqI4UFdmxnrnsOZRIA0FNI4veyQ0B9Tq+uwELjmLuic1v6CJ0q+N8ja6H5DYhVR+Z0ppgr4VTJDVhiucTPf0R0ecHXvi00LX9kPwSbBQMAJ5Ic7PKhKLQgjayodBf1AfqqWKTw2Mk2rAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oCAF3TcWJHeCEXFN8PunkMXQq80nKTLZGRdo11Q2SS0=;
 b=d3/oa8UUcbDKnnx9mq7/0MuVr1tBHFFx38y1J0ipmJ4VdXmMLMFyfHdjlqCK5HogGz8i4mM5s3gP+SQsWZzqdy5RjNh7dyAYp3ENwWDBluPbZ1G+ROtye2RIDnITQ3WlWl8RzW38GCuVa3b4bdKV0N8Lw1mCduPO9lN0PU8qudobb7CZOG5NLkcxo5hHEkQbggmdHIGHc8glCE7bf+VY3MzvLayw0flc1B7T/CYHrTl5Mpk6xDezTQ248I8h7seg7S4+kyiLIvR4sfAZuzKFR7YNo+qEiq7mm4anwzCOHIhfDL3qaEGuNsWvJEIlWPfMW0A/vxe/4a8RLltAP/gRbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oCAF3TcWJHeCEXFN8PunkMXQq80nKTLZGRdo11Q2SS0=;
 b=cIHbxiFl2qpt1b7mTYrnOiOCJQ6AC/H/lyXTDz/94NRBNUZxEootTTmJUxG3583jaaJX34WomtDMzFWhIw+8XdQcZhtDcB7O7BgG+MsLcjv1XfmYWwm8cYQX4kLoJY33fZQjY03I4BLNsG8lSONkOh8QTlm6Eywipq8Ez4HkHd5owlESyoA2hj3LZHaWW+tr/SB/mdPlMrdGaLSY1LqZoFGZnKJJtjvdXAuYFgy/upJSkZTW99yjfSV+0a3TUG+xM1ZNPHDBIPK11emRteSKm+zLb3ZDh3aNGhuAZSbV/O7huNhSBGa/6zPQSyJ39AvYGfcbJaI2T0bpwpKO+7xm+A==
Received: from AM0PR04MB6324.eurprd04.prod.outlook.com (2603:10a6:208:13f::12)
 by AM9PR04MB8180.eurprd04.prod.outlook.com (2603:10a6:20b:3e2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.18; Wed, 8 Nov
 2023 17:59:21 +0000
Received: from AM0PR04MB6324.eurprd04.prod.outlook.com
 ([fe80::a371:c087:fe5a:1e77]) by AM0PR04MB6324.eurprd04.prod.outlook.com
 ([fe80::a371:c087:fe5a:1e77%4]) with mapi id 15.20.6977.017; Wed, 8 Nov 2023
 17:59:21 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
CC: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 5/7] multipathd: move resize_map() to multipathd/main.c
Thread-Topic: [PATCH 5/7] multipathd: move resize_map() to multipathd/main.c
Thread-Index: AQHaDdoMNKkxWiisrki58GJHNJoVFLBwvuQA
Date: Wed, 8 Nov 2023 17:59:21 +0000
Message-ID: <59b7b03e0a316fb2c340ded0018c9e8e655ded7b.camel@suse.com>
References: <20231102221507.105371-1-bmarzins@redhat.com>
	 <20231102221507.105371-6-bmarzins@redhat.com>
In-Reply-To: <20231102221507.105371-6-bmarzins@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6324:EE_|AM9PR04MB8180:EE_
x-ms-office365-filtering-correlation-id: 8b2f5a9e-a3a1-4e48-1c75-08dbe0846f6c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 7wTJRYrfmak4NEyg3VmS7ru3H76K+AZr6at4Yi62VuG81DupLHZONaHtkE4bEUkLUbhuGEGKzhwnfW/pHkgFQM3gbE3toO2wYOZQStJ+ef/G9xmwxkG5LfmbYtBw20vaxYlkHG+4H+/DcaBdqeJNPYjSpvZTBsMX35YR2HkKpdZFxODJJtuMdJShPbsq3Qe9ms/lGNVhLbAN/H+mRk/WsVbCIB225t8HhVIgoBYjNVBzdnzhR8Sqez/tMzruzkv4iWq3Ee4wRx5+dtrpI4AP3VZK5fa6263bIFOZF2KdjlJNCEXkjrP9mBJBRpWryxT58uFDMJ0xnOx62SyxI7xlgFPIaqJIyKe0ysc7/loBWPLI0IaNCEjcrsHx0+E7GkR8toivft7odsicI613MErIUUSr0yv+kzmSwOTCNrDngoo/jsVaq4ONlp3U2irdCb/t+HrtkL1mMyxPQUJUF1ieOFlKthlWL6AulbC5R3slTNnNWjvnEVuVGlD1alhqgIgz1lahXQu12NWW43fpkllMnNBJtmmszUtNMzPaqGmYSTnbm7zoAAJxpx3BN/zUlLHjVnNXNNf0G+yUma3v6bsmjksRP2jYQhYNMTug0bbej5VXvX1h2FSOmDPNixE4HADM
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6324.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(39860400002)(136003)(366004)(396003)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(2616005)(6512007)(478600001)(6486002)(71200400001)(26005)(2906002)(110136005)(44832011)(316002)(41300700001)(66556008)(5660300002)(66946007)(76116006)(66476007)(66446008)(4326008)(8936002)(64756008)(8676002)(38070700009)(38100700002)(36756003)(558084003)(86362001)(122000001)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-15?Q?cTaKLsm3ZYNdcdsEDXc74PWTFiqgMg9uIU0Jy7OfZtVVa9CBzgBIY81cw?=
 =?iso-8859-15?Q?GHgMzB7dpgY/m041JuOnmo4zyO7v0ZXc33CRLhfa8hQGWKDuHj4uLnp9u?=
 =?iso-8859-15?Q?Tg0eUPvjcoWj8g4Hw2MhvRf4Vay07wc3CgBHLPmbARTVpsTtD3W2kKZye?=
 =?iso-8859-15?Q?YgQyZAD8K0JvJ8dJLoIPkDBkJcjWozZz/zdn5wbR3+mxC+i+PhNjAA3Xy?=
 =?iso-8859-15?Q?4ok6CMUqD2xeqUh5hlvjLrH3qde0kaX1bZofy1aR8FJX8nBDZaXVWYrlv?=
 =?iso-8859-15?Q?auJuYAmePRQVcG0HvaBFOuI2GB9vnX4QqtgTzQ+ZwETDm1D8NYl5ymI+M?=
 =?iso-8859-15?Q?F32vs779PZvIa7/QLDBazqn3ob5pfKHGWJ48SLReUyVjREioyi4vCWGoS?=
 =?iso-8859-15?Q?0HxyGj1CtmAHVkmJRyDZ4YsC8Qa5FnUovnQTuCzjDlNJLJPK2G4vWM09i?=
 =?iso-8859-15?Q?BrTyMiSmqj07zjbB3RiwUBib1d7Dtx9RnrrqWyiHSFNoAMkAKzMG/HQAz?=
 =?iso-8859-15?Q?m4bEQGdslWqoPGSPiIIGwHoWsQ/+BUCa7qXsNMo8GscXWg+i5VCZXkmvl?=
 =?iso-8859-15?Q?VxTjG05h0wTcojtpnzGO3p+ymxFi0QLP94fBPearB7zj54KC4Prmc5Pr7?=
 =?iso-8859-15?Q?uj4Moj92aiR2ZyYnHQpM5Gs15Y7BnsuvTL6sfnSCZ8H3ngktY93SnwzlJ?=
 =?iso-8859-15?Q?BFfoOQUgP6CKywEanJrOrCwHERHgJ5HPqbMtM4+B2OZYozCtBcrbivaHJ?=
 =?iso-8859-15?Q?j6J29n3E2XayaexFslqD7K6U5lpARhtPnW6E2wWRhoBWSBEipES2ufT3p?=
 =?iso-8859-15?Q?HJK8EqAk+1VixfQ7qoCqBeBxlXz7dDigG0qqAgNIdh6Kpnv+yimmloMid?=
 =?iso-8859-15?Q?fFeZcyoFAReeHSAHj7caY6ivl5qUY4l49a83K6Io16YASt5hvtUlQQPEp?=
 =?iso-8859-15?Q?pA1vzuegOgk1vKPLFktxyWRB1jDKAylbwlNpxVGll7bpxMJh61mBRRHj1?=
 =?iso-8859-15?Q?r0/rKlL5phE1d+m4E3dW09G+SoSSzAMHOrZaPUscz1W7DiXxD9w7TOYbl?=
 =?iso-8859-15?Q?GlPZix9CEteUtRNWaTfO4DLYTwRiWoCGdBLnMXlVo1ViYAyUjSlE8OMVV?=
 =?iso-8859-15?Q?JuhylLCYntd9aF88eOLlVNm/R63tTLdhBYQmWgWINafq776mQPlcHRXd8?=
 =?iso-8859-15?Q?iEjU6p8JZS2A8tit6LxVUmKLu45lRyAMcLN4vz18/n4pB19ZyABKo8Ang?=
 =?iso-8859-15?Q?+KjrTHR4HU93yjiJdAYoO8V3vBE93bhmlOkfBxpE3zd6SOjMlj/ye5gfI?=
 =?iso-8859-15?Q?KJ8ZjW9vWOAFs+YbI1rMiPQs7yO9FF90glRP39/Y25qfbOVXJBqe1RmXn?=
 =?iso-8859-15?Q?azmfxLv3/0e7Z/ROeOY3atQXi5zbETRRuQ51glvLtVnP7qWMFcr2WTJMm?=
 =?iso-8859-15?Q?IIzsQRd5PsLM7zw4/lhqxnxac2Exd9r7QIZvxbR9TMYIP2+WZN1Sa3tT2?=
 =?iso-8859-15?Q?vzyf7qHC5Q68VTgUISuw7JrbaW0L2JF5AgeAUaclQN2j1aoPNJUC8hfZD?=
 =?iso-8859-15?Q?xVwNiAnlnVgJJLzynIIBiVpitxNFct/wiV2UeFPiWLvv8pgUQpw0agVKZ?=
 =?iso-8859-15?Q?qN2pKdxAl+wc+h4zjhMlHg2nHL7WX7YiVKH9Heue977hLLXCeZEDSSu8d?=
 =?iso-8859-15?Q?hYUhYvdq6Uv9fQ53n1f21wkdpw=3D=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <8F332952F1C32842A3F34A983A0F3E4C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6324.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b2f5a9e-a3a1-4e48-1c75-08dbe0846f6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2023 17:59:21.2681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BiYDiLwBdX/ATM//aZI+wknhLxgHZp/4FQz+0ZhU1VRsD6gQgCDREOaB28IdV1aCsVPXIyHTT3q1uxd7s5UbWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8180

On Thu, 2023-11-02 at 18:15 -0400, Benjamin Marzinski wrote:
> No functional changes.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

