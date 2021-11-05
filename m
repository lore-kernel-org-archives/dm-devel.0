Return-Path: <SRS0=mjIs=PY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48776C433EF
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 23:20:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D0421611C1
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 23:20:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D0421611C1
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-4MbOqBN-NHWPuKAbD4gxyg-1; Fri, 05 Nov 2021 19:20:17 -0400
X-MC-Unique: 4MbOqBN-NHWPuKAbD4gxyg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7244100CCC3;
	Fri,  5 Nov 2021 23:20:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7739D5D740;
	Fri,  5 Nov 2021 23:20:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 90C684A703;
	Fri,  5 Nov 2021 23:20:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A5NK9H2003104 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 5 Nov 2021 19:20:10 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D8D2051DC; Fri,  5 Nov 2021 23:20:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D202851E1
	for <dm-devel@redhat.com>; Fri,  5 Nov 2021 23:20:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1237F811E78
	for <dm-devel@redhat.com>; Fri,  5 Nov 2021 23:20:07 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-494-1G11YNO-MzSXDYw1bIpX2Q-1;
	Fri, 05 Nov 2021 19:20:05 -0400
X-MC-Unique: 1G11YNO-MzSXDYw1bIpX2Q-1
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur04lp2054.outbound.protection.outlook.com [104.47.13.54])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-16-abRNvgyVP2e1osMSuhGmJA-1; Sat, 06 Nov 2021 00:20:03 +0100
X-MC-Unique: abRNvgyVP2e1osMSuhGmJA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB3PR0402MB3897.eurprd04.prod.outlook.com (2603:10a6:8:12::11)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.18;
	Fri, 5 Nov 2021 23:20:01 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4669.013;
	Fri, 5 Nov 2021 23:20:01 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH 5/7] multipathd: fully initialize paths added by
	update_pathvec_from_dm
Thread-Index: AQHXxebeV4GFGv0wyUqQuLf4uivcTKv0BbIAgADVtYCAALbYAIAAGUOA
Date: Fri, 5 Nov 2021 23:20:01 +0000
Message-ID: <c137193a6dbc7ea9ce25d06766874012de2f8ed0.camel@suse.com>
References: <1634757322-6015-1-git-send-email-bmarzins@redhat.com>
	<1634757322-6015-6-git-send-email-bmarzins@redhat.com>
	<2a319ae1e5eba66db17ab6372c95ac81f75a92e2.camel@suse.com>
	<33b4e4f8942ab340b4fba39e91c3d10e9c6aa402.camel@suse.com>
	<20211105214936.GO19591@octiron.msp.redhat.com>
In-Reply-To: <20211105214936.GO19591@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 929d98d4-e961-4575-77a7-08d9a0b2caea
x-ms-traffictypediagnostic: DB3PR0402MB3897:
x-microsoft-antispam-prvs: <DB3PR0402MB38972946C051F92AF6D38011FC8E9@DB3PR0402MB3897.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ilHFs8Rzc1mQR/72iLBpC0N2gib7gPevIWDER+EU1FEwR6AuKLGc11VwTy48vMuUmux3tX63ysKQMWadmGOl6Uk+b7v/24JcrTBnZ6Gw4lfFEs0bdWOSmBFVnXS31r9ZKt9bsHBrATWYkUFr0qfb0jzdlSEhiDbUpMDJDcCEX9BJD+SwENzvWxbnQ6RUrcZ4NL0G+70CXf1lLB6nNXz3m/aQeU6NS3mmskJ4L4BwqdJrCwCGZC55B0s0HJtqvoVaK59rKJ/PG2/32kIOciNNvPudtZ2+4sQoJSKgXV/1QmNYc8D0a9X9f2Nhv0T3fkEGVLUtI4NlivtgRsZjJIT4Bx6ztTMDFf+4SzKFyth1RsnRXq+EAa/cIkyfq68os9kD3KXMzg2iYwgXyANRy+pRpqJ6JU/Gu+KH761npzmYvEnuA/DrELoC7mucrtLsHx6k3Efs2GB9zfcry0zlOEDqetaanms6BGQo43oGa3jz2UtXZS34VrIeRAANSni9d8P7hJ5uEeJcIRNP1TtNgxNvOpQQD6AoQ3D5QjLY8M2u8eyIBlkX6xStdNxMcP1wjnt1w7V/gLaJ3eUPa32hbu3rGWrYZKD8D9ZWDsT2wTDJXrGzM2g/fco8OxGMtjeuU7N8f4tgK1e2UVTL4Caea5X8IxpANf6Dbrk1LGPWqz2MaJXTdXyjKj2vuWMlzKHXfihNXiXdPv+HuHMrT6A4Iq1Gtg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(2616005)(76116006)(91956017)(186003)(8676002)(6506007)(71200400001)(316002)(6916009)(38070700005)(38100700002)(122000001)(4326008)(54906003)(508600001)(5660300002)(8936002)(4001150100001)(44832011)(86362001)(66946007)(66446008)(66476007)(64756008)(2906002)(66556008)(6486002)(6512007)(26005)(83380400001)(36756003);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?MOjGjpXMRgiUq0UlX6Mp/REWbSYKXC1bJXlSdmwjU2rsdvRgExmC21kh7?=
	=?iso-8859-15?Q?UUlpDyUhtV54k2lC0NRAFMHE1i2lEWlQQdXObeUUkkJqeNIYPwxR9/x5E?=
	=?iso-8859-15?Q?3bBNeerMFGjAsN3kkrgnRQoVj+FOB45DQg2lSKz0lRLPy2ftqOjIJul6U?=
	=?iso-8859-15?Q?fvwEI/6S4zV01Gq7+2jJO130yZi2XJRFqak8hylOLqADHrjot/BPjjYGv?=
	=?iso-8859-15?Q?GRRPLU6mDOh8BKGfe6ptKnZoCIoa5aNkyXhuJYTLuHIS5mxE+cge6txmp?=
	=?iso-8859-15?Q?VIzJC9ALn2GyCo2yoj+58ye94p9fu32xWcl3J095zWqEaNAnPtO/bHD4j?=
	=?iso-8859-15?Q?/oToN2crUrkXM/Bztvu20RJesHfLpmql+6WhJVmIUYVK4uglDjUabFYBF?=
	=?iso-8859-15?Q?B5fkeVkjAyk3nMlVSVxvkiKB1BbwKKyN0QhAJQBpPaCZ8jVZy6ixQXqQF?=
	=?iso-8859-15?Q?OUmh/J6mMtvgjnw4j/cLupSPo79jjHIsYOJOAhdgbsG0XgQIiTMMGiPMz?=
	=?iso-8859-15?Q?6Sbf5sPzAeokDwEpAnFsboiWiNHI0TpyR5C/ZoYJz4unSW9kYZod4wPb/?=
	=?iso-8859-15?Q?QKnklKdMUMn+4MlAlWpCW3R23IhvdAHBp1fL2ApTNwegKJFzkepktAFMM?=
	=?iso-8859-15?Q?6Q+2xaqLTZFgM7XTga2ZBY7Xi2QEX6gO2Tw+cUwo7TWrg223UidSzYGlr?=
	=?iso-8859-15?Q?st8rtTH4KDFFr2218ChpvbGx8ynmqOX5PjMOUVS1GvUMyu+fI/UVjuFc/?=
	=?iso-8859-15?Q?eFVEvLyFwNxMyOOh1ya9IYgKXf6zq7/guhT4ClGvjqw/T+mtXJ+ljcEyb?=
	=?iso-8859-15?Q?FaQh72+nndRC8zsv22YCPUeRkFmAGyHLxijzJDXBqqCctt9JfHAH3qhWW?=
	=?iso-8859-15?Q?wNkVldWOm8wiR6P+jYMC5I+mqdDgmmDmPfg2U7XyunLFmxRXp1jxE7RCK?=
	=?iso-8859-15?Q?qlYV4/wZ68Gsjeh219T0KK5kwS5aiwQwaJIr1Y/ludxeqxbzECeyyIzVz?=
	=?iso-8859-15?Q?OuH66/9cSMrjDIb5SFXMswbtZ3OrmD/YYAZEJkuqedIEwL7uF7sIpmMl9?=
	=?iso-8859-15?Q?X8hNhIFEkX+y2k8aASJqxIoMKiSoJRVJpuWXFjxYb812hxNz4U+oL61KH?=
	=?iso-8859-15?Q?hI7PDftInK9SLE5vaKnisbJRUA4ZEN+aL+GotOw/Lkbv6j9MUtzQFOng2?=
	=?iso-8859-15?Q?DL/eDwl1GTCfBMWyHMJ+hd6ErJTWP3G0EzBUCWyeovvHj/Wprac8une4a?=
	=?iso-8859-15?Q?yUMi54LTIYQ4WJE9TqVZ91r/dTY1xsN2c6msXpTGd6F6vtQBG5yx9SVIR?=
	=?iso-8859-15?Q?C/yk/rKUMpMghTsgYbu/NrR8S1xb2FC+Nj6mtr3lf1hul4AyJs1ppf9Xl?=
	=?iso-8859-15?Q?qmfch0s23uIa1fJn65hbUlriBDBJ/YHET4gbKubpkUd3/z2vVLFlzcadP?=
	=?iso-8859-15?Q?qpgShkM5sJgrRgd4N9GhCJzjWMxfAkS8Wt+TV4k9fJu387XZdETIQti/Q?=
	=?iso-8859-15?Q?DyVuAZOQ2zLWMaTGe1cbEioyosCC4Nv/BM8u66UY8cPK3aWZRVtNL/yIF?=
	=?iso-8859-15?Q?b9EGeTRJ5YEzmulHXr+00A/j8xPqtaeNyJ3OMOJQP+WcZz4DBtOuSgKgG?=
	=?iso-8859-15?Q?sEkSIh1v25SKlU7J6Np/3Rtj1rdsioKYl9YjPBGpITL+woSYeSeCI8CCn?=
	=?iso-8859-15?Q?rNL+RxguyIfhMqjjVjE/CleemYmqFXBHqPqN7kTqpH/v6to=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 929d98d4-e961-4575-77a7-08d9a0b2caea
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2021 23:20:01.8142 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g+jfvi+WanBJo47H0O6vMHJ7Z5okpCZ/FgFCL+UsdUkgTD8vS+kj/G0MjOBJLDq467IfVRQMi8I8XlWVMgUFcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3897
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A5NK9H2003104
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 5/7] multipathd: fully initialize paths added
 by update_pathvec_from_dm
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <590D564C803F0040A01034472E69FD0C@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2021-11-05 at 16:49 -0500, Benjamin Marzinski wrote:
> On Fri, Nov 05, 2021 at 10:55:11AM +0000, Martin Wilck wrote:
> > Hi Ben,
> >=20
> > On Thu, 2021-11-04 at 23:10 +0100, Martin Wilck wrote:
> > > On Wed, 2021-10-20 at 14:15 -0500, Benjamin Marzinski wrote:
> > > > ...
> > >=20
> > > >=20
> > > > Multipath now has a new state to deal with these devices,
> > > > INIT_PARTIAL.
> > > > Devices in this state are treated mostly like INIT_OK devices,
> > > > but
> > > > when "multipathd add path" is called or an add/change uevent
> > > > happens
> > > > on these devices, multipathd will finish initializing them, and
> > > > remove
> > > > them if necessary.
> > > >=20
> > > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > >=20
> > > Nice. Somehow in my mind the issue always look much more complex.
> > > I like this, but I want to give it some testing before I finally
> > > ack
> > > it.
> >=20
> > I noted that running "multipathd add path $path" for a path in
> > INIT_PARTIAL state changes this paths's init state to INIT_OK, even
> > if
> > the udev still has no information about it (*).
>=20
> Ah. Didn't think about that.
> =A0
> > The reason is that pp->wwid is set, and thus pathinfo() won't even
> > try
> > to retrieve the WWID, although for INIT_PARTIAL paths the origin of
> > the
> > WWID is not 100% trustworthy (being just copied from pp->mpp-
> > > wwid).=A0pathinfo() will return PATHINFO_OK without having retrieved
> > > the
> > WWID.=A0
> >=20
> > I suppose we could apply a similar logic as in uev_update_path()
> > here,
> > clearing pp->wwid before calling pathinfo().=A0If udev was still
> > unaware
> > of the path, this would mean a transition from INIT_PARTIAL to
> > INIT_MISSING_UDEV. OTOH, we'd now need to be prepared to have to
> > remove
> > the path from the map if the WWID doesn't match after the call to
> > pathinfo(). This means we'd basically need to reimplement the
> > "changed
> > WWID" logic from uev_update_path(), and thus we'd need to unify both
> > code paths.
> >=20
> > In general, the difference between INIT_MISSING_UDEV and INIT_PARTIAL
> > is subtle.=A0Correct me if I'm wrong, but INIT_PARTIAL means "udev has
> > no
> > information about this device" and INIT_MISSING_UDEV currently means
> > "we weren't able to figure out a WWID for the path" (meaning that
> > INIT_MISSING_UDEV is a misnomer - when fallback are allowed,
> > INIT_MISSING_UDEV is actually independent of the device's state in
> > the
> > udev db. We should rename this to INIT_MISSING_WWID, perhaps).
>=20
> Yeah. makes sense.
>=20
> > The
> > semantics of the two states are very different though:
> > INIT_MISSING_UDEV will trigger an attempt to regenerate an uevent,
> > whereas INIT_PARTIAL will just stick passively. IMO it'd make sense
> > to
> > trigger an uevent in the INIT_PARTIAL case, too, albeit perhaps not
> > immediately (after the default uevent timeout - 180s?).=20
>=20
> Sure. We do want to wait long enough to be fairly sure that udev isn't
> just being a little bit slow.
>=20
> This would also handle the case where multipathd simply wasn't
> tracking the path for some reason. If the device doesn't exist in the
> udev database at all, do with send an "add" event instead of a "change"
> event?

I don't think it matters. If no database file exists, udev can still
deliver some information:

# udevadm info /dev/sde
P: /devices/pci0000:00/0000:00:01.0/0000:01:00.7/host3/rport-3:0-
0/target3:0:0/3:0:0:4/block/sde
N: sde
L: 0
E: DEVPATH=3D/devices/pci0000:00/0000:00:01.0/0000:01:00.7/host3/rport-
3:0-0/target3:0:0/3:0:0:4/block/sde
E: DEVNAME=3D/dev/sde
E: DEVTYPE=3Ddisk
E: MAJOR=3D8
E: MINOR=3D64
E: SUBSYSTEM=3Dblock

(note USEC_INITIALIZED is not in the set)

If I run "udevadm trigger -c change /dev/sde" in this situation, I'll
get the full info, as if I had run "add" before (some rules may differ
between "add" and "change", but that's quite unusual).

>=20
> > Also, we currently don't track the udev state of=A0devices cleanly.
> > We
> > set INIT_MISSING_UDEV if we can't obtain uid_attribute, which
> > doesn't
> > necessarily mean that udev is unaware of the device. I believe we
> > should e.g. check the USEC_INITIALIZED property - it is non-NULL if
> > and
> > only if the device is present in the udev db. If uid_attribute
> > isn't
> > set regardless, we could conclude that the udev rules just don't
> > set
> > it. It might make sense to retrigger *one* uevent in that case, but
> > no
> > more.
>=20
> IIRC, the initial reason why INIT_MISSING_UDEV was added was because
> sometimes udev workers timed out, causing them to not run all the
> rules.
> Do you know offhand if USEC_INITIALIZED is set in this case? If we
> could
> differentiate between the following states:

udevd sets this property very early, when it first receives an uevent.
But libudev calls won't return it until the database file is written,
which happens last, after all rules and RUN statements have been
processed, _in the worker_. Thus if the worker is killed, the file
won't be written.


0. the device doesn't exist in sysfs=20

> 1: udev hasn't gotten an event for a device

I don't think we can detect this without listening for kernel uevents.
And even if we listen to them, we could have missed some. udevd doesn't
have an API for it, either, AFAIK.

> 2: udev got an event but timed out or failed while processing it

This would be the USEC_INITIALIZED case, IMO

> 3: udev successfully processed the event for the device, but
> multipath
> =A0=A0 isn't seeing the attributes it was expecting.
>=20
> We could react more sensibly.

Yes.

Regards
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

