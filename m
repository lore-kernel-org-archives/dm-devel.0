Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2070.outbound.protection.outlook.com [40.107.13.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CE020B0D
	for <dm-devel@lists.linux.dev>; Mon, 13 Nov 2023 14:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="x5KJvm/a"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jsm1U9NJqCVPdoNi3pkYx3AJAStHEFQc2Wvu3YNOoOW63BE8CstC8OjDwKGfoxfeh8NtGunfijBB7FrMrHLQIgvwB9Mtn4x5OD2OlLZ8y6HHAqOgIix1t483WM1AhH/wms+V6/lpQtCTg1FBBarSSeOS0T/LUpLMsWRDZ2/sfILw9JKOUOauqNmDb3AmDwi0mSVsDRh2j7lSHoxCMJDKlSiUOXvqMganL1JBR2ROp2ifm6TxmEFZtAmcYplqZsJc+WbbIhyGuK1XtCDOLctJlpTGD3FxVQ7C8hDPXc2gFf++2MLa1biMxH9CICwqMQplOyGQmpoRREN88H2l3mzGSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zL3kjUVPXYpP6yTtiwgQIsnmGaUHslTyQn1aNhiN6OU=;
 b=F2L7kT7oFwebrQi9jJjD1/UMnu369xWl6oAP36Q+SR9JrINWDrsz3ehQjtG5s9yDTKpFc5ngYKeoCrredtDupaUhhnuNa8RNqhCIqTHOopiKuyv4+hnrrqwMSVe+ZeU5TsK+RVF1k689pNaqTAf4v6i0HHURAJjcMVom7SpPXCeNEFXXFQ1jjmpzCozVUUKr4SFAQVsaYse/6Ksexq+7jgePogdrEpBwr6uE2Uvu87nwHI8dvbjxVdCeHX/vKh6qrw8J4fAE50/DFIZ3LB2Bo/SRNhuy0YaObt2tJ1PKNIomXPMuu/9s8i4sAIRaYAVDBcgo3+HugsOAgq/P9XHyFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zL3kjUVPXYpP6yTtiwgQIsnmGaUHslTyQn1aNhiN6OU=;
 b=x5KJvm/ag2DZlLcz3A4EUE00MupiFK7kzX1eHmDrQqeseHqFZE3TeVgQgwi2MGwP7ozPvmVMMWMaYMaAimhAq6V97JbzyHt/PFeoPzI+F5F5BSi7OZZXxKwzNk2SwXhGMvVijK2Oph0gRIzjh+MpO6CtxdQTD0FsdgHxG47E89rlPvs4/LLoAVmkFqT5WzCQLR+YtA3LCtBL3hjNQ/ZjV4pderWMn7K4tTfSsoW1Uhh2Xph7sHWSbGAuJUSFpWKY/I1KCL1YusGW7n0NwG8eyNW7omtgsxd3ie1hUZlRO2JjHowH8x2v6MeWJGiEgYPfX6dZskcBIfSsNx9f2ymGow==
Received: from AM0PR04MB6324.eurprd04.prod.outlook.com (2603:10a6:208:13f::12)
 by AS5PR04MB9800.eurprd04.prod.outlook.com (2603:10a6:20b:677::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.15; Mon, 13 Nov
 2023 14:02:00 +0000
Received: from AM0PR04MB6324.eurprd04.prod.outlook.com
 ([fe80::5c82:3111:897d:74ab]) by AM0PR04MB6324.eurprd04.prod.outlook.com
 ([fe80::5c82:3111:897d:74ab%6]) with mapi id 15.20.7002.015; Mon, 13 Nov 2023
 14:02:00 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
CC: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 2/2] Makefile.inc: always use /usr/include for includedir
Thread-Topic: [PATCH 2/2] Makefile.inc: always use /usr/include for includedir
Thread-Index: AQHaFA+IFdMYKrHZwEmrHuoeHvondLB4S9CA
Date: Mon, 13 Nov 2023 14:01:59 +0000
Message-ID: <85eea355e56383e7d9cd82c5728eb9260d791c61.camel@suse.com>
References: <20231110195304.107907-1-bmarzins@redhat.com>
	 <20231110195304.107907-3-bmarzins@redhat.com>
In-Reply-To: <20231110195304.107907-3-bmarzins@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6324:EE_|AS5PR04MB9800:EE_
x-ms-office365-filtering-correlation-id: c7848ab5-813b-4c55-8bb0-08dbe4511b11
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 hhBR+8PKZkbFb/c+8t7sy00Kz+eM/+pW5CfrDLv+Ck526+ujwg2ef+XNvBRk9dQ22s+Tz6L7quZ6jNrtpXI4l7BUU8y/LutQ2UUbXqmxa/FfRN7fMfEa4UwpywWgnzPzOILz9rhbILuW/jDSn23rQgFNtqRg4iJ9wRaAHQQRst3TcmRzfHEz+tUfoocbCZIaH+wLdrEkqnwpRF5DPjJcPsxbx1k4vMJ9wpRXGPK0+zoWWBRTiWc60MU97LVGnBONhw+HGWPicT4Pb7lx0DLiNxZlshCytTe/Yme9oBu6hNayyJx22gAcbq9A+bHzZzb6QWdljO9KeiQ0rOh6UCfJv6AGT5EUwBLKOcOcw0Up6lSA6rWcLTqAG2bln/zGhAvBVhHVu7hVMGLBBTGOZe9DL4LJNpi7MHjGW/3Lr8o2+NpzYHjro/F9RQzEJOt9k0pR/rzZvp0zylopMEl6rIig0fqrEsVyxyclxtAzd9bjzSCzUHqWiw8gO2dhhThIJGhSVZB0ZEH9GFCNbsnTLW3JkTq3bbN0gK1jwFNQ9ecGIbUBUf8GDT8JtZF3B3Flez9Qt/uxfGXcvNuHnvGgHk4FKwikNUToEcCh+asXKGEf/PBRN/17vbeSYmQGet/aM6+L
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6324.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(39860400002)(346002)(136003)(366004)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(26005)(6506007)(71200400001)(2616005)(6512007)(44832011)(5660300002)(4326008)(8676002)(8936002)(41300700001)(4744005)(2906002)(4001150100001)(6486002)(478600001)(110136005)(66476007)(66446008)(64756008)(66556008)(66946007)(76116006)(122000001)(36756003)(86362001)(316002)(38100700002)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-15?Q?kxN61+bQgWTFp1NjA7EVVveu4RKQnZlLYOlBApzveqM2S+vn1eUi6OVOt?=
 =?iso-8859-15?Q?OTdn4gEekmCebswMGIxGXGe4WtUMLdnuwxOOoC5H1PA1IwFNlaMX4qMVZ?=
 =?iso-8859-15?Q?UB/VcnsnHShLonArXIw8O1frj0+4dZWkzc4w5qmSSUU2i7Nxib9pMG/xQ?=
 =?iso-8859-15?Q?2C6q+GdQ0z2VROZBsC+aae/r7Qo3HIZogF9KjxAgazkZc5Oy3zQvhDsPj?=
 =?iso-8859-15?Q?DodyW00cOof5hSaldFqu7pRmwGrymJfE+Y+NLJ6iDdm5VSRO0G1X1rZUQ?=
 =?iso-8859-15?Q?B6E5/Sygyg6NCQR8V9vYI2nCykcbz67L8fhULzCrpsOHcfpcZnaXlAP98?=
 =?iso-8859-15?Q?aDP8OZBsL2XnpsTkI1dUlpGMq3dw47mJCAJvl5OZrv1+KTxewv0MO7M4J?=
 =?iso-8859-15?Q?xc7Xzdd0tupWW38GF7bLT0bAkG/3lHGtnXgDhmk5x3D+IPLYKTwzWoTe9?=
 =?iso-8859-15?Q?kcYSQWhTH7c8J1DfN2gC+AUzQ2c/o5SpUbfqfh36CA8CBBckUTuEbZDJu?=
 =?iso-8859-15?Q?apglh8wJKOpn5Y2Xhr1X8UtqvBkiuj14uwmFIn6PUeTqpjTswKv8//nmr?=
 =?iso-8859-15?Q?PBVemmebqmItG1weYs9OBcpNczobMReZayANTqMK+HvRusU0ATRlamwTb?=
 =?iso-8859-15?Q?r98AF99YV3cUMlSK5viEcwDq3lVzeOsKb5quJDTFuvFAeM9jpxtvKysuX?=
 =?iso-8859-15?Q?3uRZe4ncUMtXvZ3KLZXrxmKZ2z9qdIvb1jw2zhct3VYNF0mcZ0x9ZgYeG?=
 =?iso-8859-15?Q?Gc3iWfbLp98FW84e8eo+NsNDba7JDfvcgbw58P+5ZtgrZ9U6vk9M/cERo?=
 =?iso-8859-15?Q?jKU2ZPIJFblh3tyyDmVTWYhAWyltCJ7EuTCb09loRIemN0rDC/Hm0LsOz?=
 =?iso-8859-15?Q?sNI+2vSuHqAI8+LiIps+u4ss9Whc0jvo+ZdZu4+VeCFFfnI/UvFNbUzG1?=
 =?iso-8859-15?Q?LPcnaZWq/jfET/b8FbZ9ecru7HgjJUxZDL8PKbRCBO+lQ9FcGXrSSjXim?=
 =?iso-8859-15?Q?O6pGJEio63bt9dsaM+dgQvckft1QJXZgR/PvRdtlJdhih+P9ZBGsFWzux?=
 =?iso-8859-15?Q?Om+o5X5tDLVOJKNUogYpGlrp47KXhRTCmXvVnDF+jb7OkDGAzhNCQ99pU?=
 =?iso-8859-15?Q?LvgZH1XBmQA4mKjuPkOhD+2ZvJ65VkbPIq+Nm+YyMz/2sqex1VFgRdt4x?=
 =?iso-8859-15?Q?f7nORahKzNCCD8jFIC9maB0Szf/YjQbmmhcmXb0M3A2GIgd5rWIsq/KcA?=
 =?iso-8859-15?Q?eRDQSpBkvC15RWScYK4qPZkd6V29HWOPMSy3bu+oeXfkObD8ZhQRcKVOi?=
 =?iso-8859-15?Q?TZRIIHnakVe0W09wCB6F4gZLctv6C1uuEPK/ZUNgKdiRWWchc2FRzLTKN?=
 =?iso-8859-15?Q?GCvCfyDzTZOll1fcg6DiiGu9BtAcRGQxZpROdgPWi392Ula+CbW3yDvvt?=
 =?iso-8859-15?Q?l2sh4N0DrfXaFHt1OYYTaGU2CT9ntTjeHLOPkoIAbRT0Tzg6P5cUSTSjO?=
 =?iso-8859-15?Q?8fprWJ0siI7RdE5cwABqmxfJLb13z6Nx8HWIh5Nefk7HUuv9skLpP9U1M?=
 =?iso-8859-15?Q?46Cxk7vdkJ8lqnnn7abD1GG4CygN3ASGY4Zot4zJ36YEVyw7SYMhvod3g?=
 =?iso-8859-15?Q?RdiIqo82/uBDrgOWa8vqiCHhP93oh1UbG+OJPIZCnkW08BAQYwGnH1d5O?=
 =?iso-8859-15?Q?UWS9a3TqEZjQbhNqN9XswjxqUg=3D=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <3EBDB00500C8E24EA9BD6FE629C49A52@eurprd04.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c7848ab5-813b-4c55-8bb0-08dbe4511b11
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2023 14:02:00.0120
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PQHAK5C8FH5zu23UmdbEDvaQWX8Drs0C2uQoo0LBPwphLY4VVhfDHPlu+ctCTmlih8H+cv6Xt9PtQmKUKi1PUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS5PR04MB9800

On Fri, 2023-11-10 at 14:53 -0500, Benjamin Marzinski wrote:
> The current build system, with nothing overridden, will install the
> header files to /include, which AFAIK isn't correct for any
> distribution.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

I have the same comment as for patch 1/2 - correct for the default
case, but the more obvious fix would be changing the default of
usr_prefix (our current default prefix=3D"" usr_prefix=3D"" is arguably
bad).

Also, I bet that there are cases out there where the assumption that=20
paths for multipath and kernel headers are equal would fail.

I'm going to submit my suggestion here; I'm of course open to further
discussion.

Thanks
Martin

