Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2081.outbound.protection.outlook.com [40.107.22.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D5610A1A
	for <dm-devel@lists.linux.dev>; Thu,  9 Nov 2023 09:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="mh9h5WlN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RNqu5M7YjkbAIjorf8Gx159UM6qY6ad3P4djtNy0IpldUX/I+55Ke8u4XLtx3v42lFtoj/4NoUisFhHagnfJSEbh6sSsEe/75fOIZ9paDPCk45WKMiSA+RtQ5As+h0JAPE+ZXdHTBe2ldcCRQw+r62pw0XU0o3vt5afuSpyOI+0ci02YbPiebJzT+iC/WZ8NXtgH6JiCdFLWT3L+9OZkjwRDiiCFjpacAcOWlq6TO8sjFCuzkcWY3UtCEf5E9IxM1Er4Qi4dj6Qd9d/Qh9cpXJQrU/M6ux2biI4yZSqaduVzeybQ/3BIrUbIo+eOhAk3CR+1TQw+HjgoAm5wsgNKbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pShKE0W5tayUwpzh7FfAEdPyyqF8fzv1vbbAx/w6rXs=;
 b=dA3BvcgEWQOHtV4zaB1XwpdeJGlKdCTVCOIGjmh5NYpZcnbykwoWpqWmhGGKTm79tbFGNJVv2tkvnj27iupGOmk7akBnv9GfT3r86Rr0vDUOHUYsXsw3QTNQ59KLjXlqX6F1oPy/+jtKsCCGk8pzk19adFFQJnumXCaIVXS1XEj4ou7B5xNR3Xv+SOjNvKfATlZil27FZn5deYLigFCvMN/Wi6RXjjnehjEh1az6D/TQ+5O3jJ2+hObLVKa7D6IQZVRGtOKPQHmoQbxGlFUaOLyo4+7D9Ga6xbZesTLCBHCFGyV1Pg26QWRbi6CGWD6gAi5cZxBkoEJQdC3gBVYbrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pShKE0W5tayUwpzh7FfAEdPyyqF8fzv1vbbAx/w6rXs=;
 b=mh9h5WlNvLvNtizWD02FurtTusojD5IbJrnfyNT74dHRRnHneMh16o4k7Rryb0L9jS2GHZWaC+gMgQ5JeT55gp68qJpkD6wSTmqXSEJPg+f2qlujTOJeazorReSVe7XCxR0fBFcZpSp3qo8qcGJZlyx8Kcouk21yx6q/wT+c7btC71wIhpzJvtp6nKhUk3e3xWz/YV5dKZt0/HCQDhncVjVX1TIIzWKd0ysCUgogK5pehaAUlq/9liKHa7InKiIYwC9lwVO/HKB0i6K66o4Sbqmuq6uH/FxE/+sgEFugn2T/IfzZAI3ls4vmPizcLQln2BgeRZPrLq+ja8mAgbb0QQ==
Received: from AM0PR04MB6324.eurprd04.prod.outlook.com (2603:10a6:208:13f::12)
 by AS8PR04MB7576.eurprd04.prod.outlook.com (2603:10a6:20b:29b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.15; Thu, 9 Nov
 2023 09:07:24 +0000
Received: from AM0PR04MB6324.eurprd04.prod.outlook.com
 ([fe80::a371:c087:fe5a:1e77]) by AM0PR04MB6324.eurprd04.prod.outlook.com
 ([fe80::a371:c087:fe5a:1e77%4]) with mapi id 15.20.6977.017; Thu, 9 Nov 2023
 09:07:24 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
CC: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 1/7] libmultipath: Add max_retries config option
Thread-Topic: [PATCH 1/7] libmultipath: Add max_retries config option
Thread-Index: AQHaDdoOZRSHWsemRkaW+Xn4xoVS/7BwlueAgABtqQCAALgJgA==
Date: Thu, 9 Nov 2023 09:07:23 +0000
Message-ID: <4eb3625118838c31b4348c24f0712665b9a05109.camel@suse.com>
References: <20231102221507.105371-1-bmarzins@redhat.com>
	 <20231102221507.105371-2-bmarzins@redhat.com>
	 <e704003e124116e72771d2b7ef90ca66ef242e1c.camel@suse.com>
	 <ZUwG6iJU1xZ/S8WS@bmarzins-01.fast.rdu2.eng.redhat.com>
In-Reply-To: <ZUwG6iJU1xZ/S8WS@bmarzins-01.fast.rdu2.eng.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6324:EE_|AS8PR04MB7576:EE_
x-ms-office365-filtering-correlation-id: f14137b8-f065-4e00-4d85-08dbe10349a4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 qEEpbOP8G1/5dXoRIx+2V/PdxftysDnY+Dp//FN6AiwGB0hcDmjqehsuetitvRIyhWXbGqhFiXUoxSfND1ro8gl2VwN3Q/TwObNcXOdkpqOyU/DPv7wG+Ja5DRA8hkXUyy8IYJo3WL+jvrq8DBv1Bj0J0P3HjLl5zhkBQ3EaWQIRVK3TOObYrOKFjrYdp8YJzWl/UM+n95oH1brmSVkTl4dFWXGGPeMZecU52yZMP9+b/ULVlyKBEP8BuNlVC7rgJoOyXXwZ558p+y5ld8eF63oWibTsOFclzrfOgxJvegXH9rq/RZfuTTImjcvZ1+kByGYnQQRnZT36zxWIXYiyi7nZnF6uuD0XxpxA0EV/K9ZxQ7SInUamH9rQYmNtCx7+MztMG7fN1AcgUHR1u8xMd4jTzyhBAP0E95tlARXzfwYkCCwIiTuoLfZXiEvnteqRf2Rqk1p83A05H61YpIdRUQSjaoYsDdV894cp8HqdiTJq+yvlqgEVGDIo3zUSzLn7mst7FB/S4go2530OtvdIR9nv2gkd+VXeAu67m/r5D6sbL418ofZ04eGShZK46uPG5JuZQg5jFt9qqFEsKLRZyrF4qwIXijrUc9X4yX7/e5RWUEjU2/XMk0UnEaLrcT1J
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6324.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(376002)(136003)(39860400002)(366004)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(316002)(478600001)(2616005)(6512007)(6486002)(71200400001)(6506007)(38100700002)(36756003)(122000001)(2906002)(86362001)(76116006)(66556008)(5660300002)(44832011)(64756008)(54906003)(41300700001)(66476007)(83380400001)(66446008)(66946007)(6916009)(26005)(8676002)(4326008)(38070700009)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-15?Q?YrpPzipS7k0w2hv7evE9hwIloqoEVHbKXxJOcTKMiYjQpf3nehzYPnhh+?=
 =?iso-8859-15?Q?Umq5Aj4KiOxRJi+Twq8dyDKxeL6ewpecrjAScDJqpanPZSQEpI9hhN0nY?=
 =?iso-8859-15?Q?itw6rpEZaovfLbkbSrFS4VmdfaMAPv5y0BK/fswicm3Rz/gi4kYtaCECf?=
 =?iso-8859-15?Q?H2+yCozAwe69d/pmeoKymQC2zCvdxneLd50BJRfnTKA0Fkj9+zE6vcTW+?=
 =?iso-8859-15?Q?K3ot/0U2N6VHLypJhQA7/XJKXtl5CEBdp9K/cYFQahZVTAU1FaWulXgww?=
 =?iso-8859-15?Q?5nYEnBuAS9E+nyv53h5JRYbaHLZ2BFaVP62iJ9yt428fDCs8Epv/ngH/b?=
 =?iso-8859-15?Q?Gqa7zGS2337qRqZcqHFlDMobNLwF6t4XCZY6mcQfJzr4p5OUUECmFxg5r?=
 =?iso-8859-15?Q?EkvDLaC0yZ8zQZiHto22wpSaWlWUf6mHYuH6P5FwVYqHvQSwhJjm6a7L7?=
 =?iso-8859-15?Q?tblEMn063F5RYGCo6lr/eSCHp+YxAGHuwdWs4lhPIKXMXsYyHoQm+YU8i?=
 =?iso-8859-15?Q?13oHbfhknlGImrXotLYct+gg83wPInuZNm/W9Uo7dqD717XsGzlPTRffa?=
 =?iso-8859-15?Q?kKQrIdldRkVWoSJoa87ohFP3apnQi5yzCFuL/V368zlfO6PG8Iz22SGxZ?=
 =?iso-8859-15?Q?BNF3RC7S3l20P46L7aDfpE0aU0O3C0KIQ5MHWkHwvcfLvzJJpGa06WG6M?=
 =?iso-8859-15?Q?JpKpcHon314AN2V3JB02Tdgx+oOzqoYdsbrVKF1XpraPaKpsc5gJfkpV3?=
 =?iso-8859-15?Q?mfGuSBqovGJcjTALHHT0cOWNS6dTfdG0jIs9XOTRG7AXZ0PODlkvMKQz9?=
 =?iso-8859-15?Q?pxQctsWbTsgSRJGCXY64RSLGFtom5WK7m1plDlz1FWE0OM2p/4InwqOjN?=
 =?iso-8859-15?Q?U1I696KU9xUDBvH5zxXgC6RPlBtKoC5AEa//0OV7yCUyw3qG8fKD4GJzl?=
 =?iso-8859-15?Q?sdlwQjOKPnq8XYjsPAU0Y3yh21cA4yhC9udZmcHjGqPRFhjI10UBUVx1D?=
 =?iso-8859-15?Q?qtW8iHZ8/5lTbHKpD0uJcp3jRUXhiw+SpzBMx4uP7FUF1TSO+n/XKMlbb?=
 =?iso-8859-15?Q?hwnwMx+o6OKY5JSOjIcCgzwdjta9Zm/ECC1U3GcBeSCgQUV3u1TV57In4?=
 =?iso-8859-15?Q?s8p3SM8S92a4E1aiMSwoBV6QLBLSRn5Ni2uo9PU4jWMXSyvpEzTN465kD?=
 =?iso-8859-15?Q?zPz+RIjqYY83nPYbgs3ARkiMTFeqxvBXGVAgl1KH4oA8tvWKCZL4YN+eU?=
 =?iso-8859-15?Q?apKrlh1oR9lCiHi+bklBSgd7a+RgDQYvBFR1+yCaZEp9wHB32sezBGV9r?=
 =?iso-8859-15?Q?lYQx1RT0TQUaXiwvoabtdj8osXboBvxf43MuS/CTruAClvWJ/4H1V9Mv9?=
 =?iso-8859-15?Q?Zpd8Q6KIdfLQW1l6U+fXWrg7nDVS5fwoEeJt7w1IGt0WkWBjZFm/MRYHg?=
 =?iso-8859-15?Q?Or8A7UvxNkVKiLfNOlIiepb24tvoxqMl9FT1FZDSgaas7vU6MUm0HphnU?=
 =?iso-8859-15?Q?i4QOt/62UZjF9w2AJXgKGmxEEpG0MnzP8MruY4OiiyYv19uRMqpKf/GNw?=
 =?iso-8859-15?Q?1SMlTrwSriU8I5DqLbgENA9VTPnhcfDUXuUN3yWaGFdO7xt7BlzXiqrLO?=
 =?iso-8859-15?Q?2uHtmXNuyfBlwAfQKcSOBsozE2JzB/H1dyV2ovvAz5lMQHJII+pzY+R8v?=
 =?iso-8859-15?Q?nv+K8jzYgBQFuLP7bKgDrYyLTQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <758B912701AE724DBE76F527CB1463D7@eurprd04.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f14137b8-f065-4e00-4d85-08dbe10349a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2023 09:07:23.9440
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MkvUKt3NU9WTU9zdH6Ol4IN9OyZZ2pGce4ymRmXh/CPgX3La80qfhZ/pDtZAF4mRqQbNtBI2fdwmkuQjZyDi5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7576

Hi Ben,

On Wed, 2023-11-08 at 17:08 -0500, Benjamin Marzinski wrote:
> On Wed, Nov 08, 2023 at 03:36:14PM +0000, Martin Wilck wrote:
> > On Thu, 2023-11-02 at 18:15 -0400, Benjamin Marzinski wrote:
> > > This option lets multipath set a scsi disk's max_retries sysfs
> > > value.
> > > Setting this can be helpful for cases where the path checker
> > > succeeds,
> > > but IO commands hang and timeout. By default, the SCSI layer will
> > > retry
> > > IOs 5 times. Reducing this value will allow multipath to retry
> > > the IO
> > > down another path sooner.
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> >=20
> > 2 nitpicks below. Please explain to me again why we recommend to
> > activate shaky paths detection with this. What will go wrong if the
> > user uses max_retries without shaky path detection?
>=20

I've thought about this some more after my review. Similar to the auto-
resize, do we need to make this parameter a hardware property? AFAICS
it would be sufficient to have it as setting in the "defaults" section,
which would make the patch much simpler.

> In the case were the path_checker keeps succeeding, but the IOs keep
> hanging, multipathd will just keep restoring this path over and over
> again. That's the sort of path ping-ponging that shaky path detection
> should be able to stop. I guess this is can speed up other cases for
> failover as well, so I can leave that off.=A0 Hopefully people know
> that
> if they are seeing ping-ponging, shaky path detection can help with
> it.

This is a general argument for enabling shaky paths detection. But I
don't see how it relates to max_retries. Decreasing max_retries should=20
make it less likely that regular IOs are hanging while the path checker
succeeds, whether or not shaky path detection is enabled. By decreasing
max_retries, we force the kernel to treat regular IO more like
passthrough IO. AFAIU that should decrease the difference of failure
probability between the path checker and regular IO.

I have another question; as pointed out in my previous post about this
patch, max_retries only affects the kernel's "maybe_retry" case, IOW
mostly DID_TRANSPORT_DISRUPTED. This is a condition that can happen
with shaky paths. But SCSI command timeouts are also likely, and for
that case, reducing max_retries isn't going to help, as timed out
commands won't be retried but passed to the error handler.
DID_TRANSPORT_DISRUPTED errors will happen quickly most of the time.
IOW, I don't quite understand how decreasing max_retries substantially
decreases the time regular I/O=A0would be hanging [1]. I associate
hanging IO mostly with command timeouts. Am I missing something here?

Regards
Martin

[1] Note that SAM_STAT_BUSY is treated by the kernel with
ADD_TO_MLQUEUE, which means max_retries is ignored.

