Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2054.outbound.protection.outlook.com [40.107.20.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AE51803B
	for <dm-devel@lists.linux.dev>; Fri, 10 Nov 2023 11:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Tpa0rqGL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fuTK7b77xukDbryVEJcxOIymxOg/5oQTwOCZ+LB2hNRi0CzQFObAhUHkXyicFSUjF3Naak4/5jar1bvsYS8Br7qiNPwylptmUlE3ovwtgLP9pBkFNhBdTt5dOhHUhPfWT5FnFcfpbxPzzch9oUNPtCZLvi9LVIvdt59pJat7NOiHl6Ip2x+RWv3CBYoIALcnq/U4x3vYoAMYF8IO7VA/STaS7KIQjEF/uh6qFb75RqkTLFk8SVQJCfE8u7P09Xs5O7gIX1bx6cLpXTv2aJsJTgdxGZIHk+XFt5CNR81UUtmuzo//41tC4ogvRNU9DH5LE7uVkJSrbuCIQpu2xhpY0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cDFsPtbsHLnPeO4STN1kfDGE+B4YbO5PrR9cQTPbAqk=;
 b=m67K6RUDzGx9eb6cqM6Fpm3ARLkULtRnd7D+4f4pEckhYuG6l7VSkv7vbhy9e6nzgFkhc8Q3hk8+JnAp4Pjzj4HDlrSAXCGzQx7tntidIyOxauZ+ZjkOcQ2jnXoCdeLjk7W4tym/OrDNtrNcjnLMIHglsCSUjZiN0hUZT8xVufhTiwpIbGzt3SzpxZ7IEiyoTtQiG0w0sZz7/jvYkE67vgf2XE+IMCtDNZl9PqYmgecVm+6DmZYUmo1TKIUwnygnwD8kM01Os7lS3rELALeGgDwo/IhS7kWZBNg5FvHML83S8vLgdSAq0iN1u3jwZa2DSs6rrp1SavJ+pJMyTAZMcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cDFsPtbsHLnPeO4STN1kfDGE+B4YbO5PrR9cQTPbAqk=;
 b=Tpa0rqGL0zNuCRNyUSrMQ+1RpldTAde8EAre3TbnUeACw+w73xVXxztSNv6synNIb0rf83LbmxXJKNI8tSUxtgh4fHpXliywHjrygTzJtOzTtxTcrJGDX8/iVsTachrox5FjRaguDNyCq4hL1eZgHVG8HFEiI8lUNdr6TD2HY5qAoSX4tXVDeTtw/6O8gHJbXcb8UjwrXC0511oLaBs4kWmi0WzAtvLcpHfdlLGbQQp8vDqqiaKZWJ2+QMw53BW5tB3jb8CTIT4czRJrXGaIrYGP+94Q27/7iVHfBttuiAhBrL62zOVrxz5lcIkuXphvAM/VNBHxs3q+VQZmK0Ez7g==
Received: from AM0PR04MB6324.eurprd04.prod.outlook.com (2603:10a6:208:13f::12)
 by PA4PR04MB9664.eurprd04.prod.outlook.com (2603:10a6:102:262::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.8; Fri, 10 Nov
 2023 11:56:54 +0000
Received: from AM0PR04MB6324.eurprd04.prod.outlook.com
 ([fe80::a371:c087:fe5a:1e77]) by AM0PR04MB6324.eurprd04.prod.outlook.com
 ([fe80::a371:c087:fe5a:1e77%5]) with mapi id 15.20.7002.010; Fri, 10 Nov 2023
 11:56:54 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
CC: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v2 1/6] libmultipath: Add max_retries config option
Thread-Topic: [PATCH v2 1/6] libmultipath: Add max_retries config option
Thread-Index: AQHaE2bz4t/VybM/TEKh+QO7bcAVcLBzcy+A
Date: Fri, 10 Nov 2023 11:56:54 +0000
Message-ID: <a41c47a7ba1bcd1c9b3306aab25b614978a18bc8.camel@suse.com>
References: <20231109234616.100125-1-bmarzins@redhat.com>
	 <20231109234616.100125-2-bmarzins@redhat.com>
In-Reply-To: <20231109234616.100125-2-bmarzins@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6324:EE_|PA4PR04MB9664:EE_
x-ms-office365-filtering-correlation-id: 6db6f2d1-0f21-4df1-3522-08dbe1e42225
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 JhIuNPvg+N/Ymk/V94eRJUAw5gzb2/EuyBNvqydGlnXHIQPw8A2bngB6uBGydXrCunsOd5d7/sCrhQasSGYYhtNA/uhRzMy6Lva5zZ7HQZDpV+R28nNvgewl8jMocBmEMuNl3ZlWGzwFt7k20QFPB1zAGARSaQzJD3+oE2+FA/U+iTEs6eN/IBng3tsaDGfZWsdLo8Mify0Ah6vrzsoGwAgOQhHbluC+9KMkhFyKwapWa6AJW0h1Y8gZwfOheECV6HJDvL9bq++3iWXf/QYR1V/2+DLVaYLfgFkw63LgDgFXumR6mMJ374To6fgHcdz8FJPvXh0p1BYxlreqCf+VnQXJEu49Ip9hDqYm7j6EhS04VL0lhEBls2z6qoHzrYp7ve8IJ7FQLkXu13utdxYv6FOGcS5vV6jaYgRPOJYC5AZV81X95/7l6PN/chJOdGoNHMDYMu4tzVcn5K+OpzrOu/zZaFV6XNGfDjrqQkeDoBaLg7/EP9qwzxS5brR1f076u23sAjajquvR1UWHsZGavOvQLfiCy7DyrDfw4lN6g3HWCceaQ0M5kJN8OT2XujNeoAW9W75QSYg4rlVsBNwIzeGD47T8KEhSx35JDcUUn0CMEetFwwHeT23RMYLjs7I/
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6324.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(366004)(136003)(376002)(39860400002)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(478600001)(6506007)(38070700009)(36756003)(38100700002)(122000001)(6512007)(2906002)(2616005)(76116006)(6486002)(110136005)(41300700001)(44832011)(5660300002)(26005)(86362001)(4744005)(64756008)(71200400001)(316002)(66946007)(8936002)(66476007)(4326008)(66556008)(66446008)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-15?Q?3wIVZPIzKPgWG5zb0zH93j5hTNOYB0uyP2vkYljLP5TU2ys0xTuKW+bft?=
 =?iso-8859-15?Q?bbl3PCmVtOC0R7fSy7n2jUKxp816BO15gZgcK7Z+e8nxMpMoMYWA5aWMQ?=
 =?iso-8859-15?Q?aw3JPY9M4UQehFsYGjfgY/RXxlb9lyiNnmytKNkAQuYBe88jeCfVwU+uH?=
 =?iso-8859-15?Q?Wpv+Z7NJPVKkw9e4VZU2MJXIm63DKVJpKUtphTDJJCMUiEu0vO5iuPOIk?=
 =?iso-8859-15?Q?x0hUyp0gFCZ9xdAoMcy+hmKlmBEYMKrRQ5diax38tukd1iKnxZdlGJehf?=
 =?iso-8859-15?Q?fePYwQVVRoqxZDwNMuheybOYf+uCQyDyPOgvW5BInb16O4/XRcmG5KHJG?=
 =?iso-8859-15?Q?ZcdW9u6/mt2OLuqv/T5ZzNEuaV9Yg7v7RdHf8AHLv+VVbTjw9z3LyuzKl?=
 =?iso-8859-15?Q?mQyds/D6zqiH2Sjtd/aJcTazojc0QdZHQmJKSL9s48R/9uorpZR0U1VHy?=
 =?iso-8859-15?Q?MSlZCiPMBKh8Wwnp0inw/GWiU/rhzHhEShGXal416Qbrp3S9P1/sWHRvu?=
 =?iso-8859-15?Q?bQ0wrAgDg9Acirsn9gRNygbbXau2e9AhdrCdFfblWEtrTWpySYlacqp9G?=
 =?iso-8859-15?Q?PhApOK3MjQgB7N7UjrAc/fcmXc/RMzQOl0DpwQF5Ds2v6KGonZ/OHhfux?=
 =?iso-8859-15?Q?VhejC1E7ECM4ojWmXkV/3FubbsO2x+6Qgw9dEwXKNcOA4PJLqh6/P/Kdn?=
 =?iso-8859-15?Q?rlLkJoo37g4OQ7kJpVSWa4Jd9F3mGlVWOvwlUPQBamlef6y3xhFmOpzvm?=
 =?iso-8859-15?Q?xZQba56TLTnhvXGXKB9JCXfgjxaA7cTXT473PtzwX48XcB3xwhypixldD?=
 =?iso-8859-15?Q?dtOAJ4axZw18+oo0AYy4FKQrz0vwgUNdFjFanhZFjnQLiJDcPk7/SW7og?=
 =?iso-8859-15?Q?r9XrXiDdIUozDRMyxx+hn9PwXfIoSwZDPzNUS+zp7uI/7auiucDu6/itW?=
 =?iso-8859-15?Q?31TSjrmn6nrOmRE/SWo0kr9ipNVtd8Nk2CMjHPNJHq06Wqsr2zcJRD8/U?=
 =?iso-8859-15?Q?PmlV1suUe+6QQHeCVbgt6iX3Gt8a+3ZZKe9OzifCMWqty0bHu4rxRYDo/?=
 =?iso-8859-15?Q?cQ3y1I6ZAv4NQ0DuUplvkw0dpkaieAxNwETd6wTCw/AFGFHBUdMeccO44?=
 =?iso-8859-15?Q?V9g46+5NtZuLCPvqJpUVOJXH+PwyIwjUUUa13IxaRmNWBD0YnmiKh/va1?=
 =?iso-8859-15?Q?T+fSiPv/Oi2Aa9kr6q3FkdoEIbRu/WOpa7N6Cn2GxD1gMBmP7Nrxd1eFe?=
 =?iso-8859-15?Q?IjiR7WwwkduWOvH22NQ7A4W+ULzvKpDiiIYyW+Skm/le0r6Xu33Nun8kW?=
 =?iso-8859-15?Q?pu04YF/zsXqRN9w+oGUlIMzmG6msCvkAYDCtjbapRAy8crD0RtoQAPvJv?=
 =?iso-8859-15?Q?tZk9no0FrenyXb67arV40Kx3WtGrZ0uHigBfeRDUsq9kQZy/gux8l0gkz?=
 =?iso-8859-15?Q?zhKvxZU1qRuMRBSSdGdWxZrgKnvKMFOEw7osfTWUTUG2SVLCD88ooXEff?=
 =?iso-8859-15?Q?TdpWOGLDbAlc1ZZ/XcLymMOdS6+Lcpb1q0l/iFNYZ/z4cmbKbNyL58MEJ?=
 =?iso-8859-15?Q?hEBX2SwYM7dVW7KTmwKu6oGcuI6BOT0/42YdXMwcXBuUsRacILlwxX+m0?=
 =?iso-8859-15?Q?MWJ8rgvqI+t/YY5G8BwF4cVQDt2Nuf9+y0h8D5OnsZmG3Js+cnhZz+Leb?=
 =?iso-8859-15?Q?XWP1NOlm0KagZMcxeVIFW3vFCA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <5E193FB4B24C3E44B50A5A9B9C37235F@eurprd04.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6db6f2d1-0f21-4df1-3522-08dbe1e42225
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2023 11:56:54.4301
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8wil1Q1nLX0n0yhdnjvSjXVbmWWqqFIbavXgl3zhsYKuQhq3RFs9cC3iVLckXbFWbq3PXFmMdkTXM4lWapjBrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9664

On Thu, 2023-11-09 at 18:46 -0500, Benjamin Marzinski wrote:
> This option lets multipath set a scsi disk's max_retries sysfs value.
> Setting this can be helpful for cases where the path checker
> succeeds,
> but IO commands hang and timeout. By default, the SCSI layer will
> retry
> IOs 5 times. Reducing this value will allow multipath to retry the IO
> down another path sooner.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>


