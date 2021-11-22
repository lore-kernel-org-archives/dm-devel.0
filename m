Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C887C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 22 Nov 2021 19:39:34 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-zL5b9iY0Ptux9A_UjEte2g-1; Mon, 22 Nov 2021 14:39:30 -0500
X-MC-Unique: zL5b9iY0Ptux9A_UjEte2g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F7B68066FE;
	Mon, 22 Nov 2021 19:39:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CAC1F5E274;
	Mon, 22 Nov 2021 19:39:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 089714E58F;
	Mon, 22 Nov 2021 19:39:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AMJdJus009747 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 22 Nov 2021 14:39:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 637DE4010FF8; Mon, 22 Nov 2021 19:39:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D53340CFD0B
	for <dm-devel@redhat.com>; Mon, 22 Nov 2021 19:39:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4028C10726A2
	for <dm-devel@redhat.com>; Mon, 22 Nov 2021 19:39:19 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-4-WYhG5utiNUqUnK4Yd_MUYQ-1; Mon, 22 Nov 2021 14:39:17 -0500
X-MC-Unique: WYhG5utiNUqUnK4Yd_MUYQ-1
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur05lp2170.outbound.protection.outlook.com [104.47.17.170])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-33-lGwZJSdcMeOLTgAM_XEb_w-1; Mon, 22 Nov 2021 20:39:15 +0100
X-MC-Unique: lGwZJSdcMeOLTgAM_XEb_w-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBBPR04MB7899.eurprd04.prod.outlook.com (2603:10a6:10:1e1::21)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22;
	Mon, 22 Nov 2021 19:39:13 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c445:c7a6:f796:5e65]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c445:c7a6:f796:5e65%3]) with mapi id 15.20.4713.024;
	Mon, 22 Nov 2021 19:39:13 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH] multipathd: avoid unnecessary path read-only reloads
Thread-Index: AQHX3M5WUEb/bxOK1E+H6voh4CAkfawPs7yLgAAjhyqAACBgAA==
Date: Mon, 22 Nov 2021 19:39:12 +0000
Message-ID: <148fdecf9a05bcd82fa7da26910a82dc94d579df.camel@suse.com>
References: <1637275667-13436-1-git-send-email-bmarzins@redhat.com>
	<6444fd097cf43bdfe6b1947f42f270e958310fff.camel@suse.com>
	<20211122153554.GJ19591@octiron.msp.redhat.com>
	<7ae474b1273b27a188593b716e5f0dfc1d09cad1.camel@suse.com>
	<20211122174303.GL19591@octiron.msp.redhat.com>
In-Reply-To: <20211122174303.GL19591@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3fecb07e-fb45-4886-694e-08d9adefc305
x-ms-traffictypediagnostic: DBBPR04MB7899:
x-microsoft-antispam-prvs: <DBBPR04MB789989A971926138A5D8203AFC9F9@DBBPR04MB7899.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: FA8UPPsT4EJ27bjmx+52bT2XrLkvQVxK+tC66FlZFgrbQSpZLFEeBGtcIugCZpJ31PF58ZJlCR2YjgZyLXEm/8xUIXGR+iZugC0h6/WN3pPCOw9eoaC7kqR6BqcRCnxUeyx7S9AS+UTGUEebamG1Y4CuWwVMd181TnYRleTZEbIgQzihfL424x0dXiURXAcYKvB1RfTPpjiA7kpEl3LwVQ8FmxXMJztErzqsfCMnCyc8AMrBIPa0t/uSwhBrnoIvl8QsyfeoiCoAMCYNLZ/d7TkwCFTL9+KANCsZ4u/ASZZTyiAmGRrm6LAHS7/c7Z3kLsPJwBlaNWhQQp1rOWPr0kWoaGJHDiLpGicW/ZRFqyxIVS6notjV3VtbFJeSirQczqtYsT+3ZU+wPR5fsSBau0HXbgEH9jpSnD6F9Hcls1rVxR2sWsbKvuE1Ew+rfUmULb7qQvLhnm0ITzHnXfulwW4j64PdNgrV7sfVY8vBETxPd8gkjSVQ81o5/Vh1pnp7lMludmYWacHXN2tM7P7bryEVDpz7sxuS5QoYRpEb+oOoGX3VEzXjyObCG+98U6l5QzKSKUx3hMI6U6FoNjA0gUhP6FszD7uNIjOv/dE0C9mxbNqrpqZlNenUHOiIpFgq4vbvW+yUTmZKcGUr3dZ2qca9MnTUfKWTR9PUoSXMihJ+jKT+1FZQoIsXMlt634yDstTuXutvC6WUbzwazBL7Rw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(38070700005)(71200400001)(6506007)(6916009)(83380400001)(8676002)(2906002)(36756003)(5660300002)(316002)(6486002)(508600001)(38100700002)(186003)(54906003)(44832011)(64756008)(66946007)(86362001)(66446008)(122000001)(91956017)(76116006)(66556008)(66476007)(4001150100001)(4326008)(26005)(6512007)(8936002)(2616005);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?C+IvxM8PZso2f/lIA4RBpcgwgVrC7jIVRkI6/lGjP4u1xp/r1U6GJJE+p?=
	=?iso-8859-15?Q?LjWI1RWXOu1zToD07+4tN7TNZeZJRda5PlwUu7nZLQA0kWES4a+EPp6It?=
	=?iso-8859-15?Q?R8dKIrD8OfIsDK08mKemscw9rLJ0zdJGEUSE4JT/sRtcegp/ZhUvom5r/?=
	=?iso-8859-15?Q?nGrkNxUzDrKXiUC28TUSMBv5ojRY5VNv73fNvOaAseZ/bTZQJCP3IUCxF?=
	=?iso-8859-15?Q?R4t6zfqWXKJz+eDdRbkQcYPe08niRx5D4SR5ti//20io9LoLmRRKADMpF?=
	=?iso-8859-15?Q?ytM+WSGCpv+hdHzMM+LELeaFGfFDpgFsZk/qs1S+HChR4dE5zuISpxoxu?=
	=?iso-8859-15?Q?NkZCYwzRoUAB9qeQkZvwpqbxL2ccE6qQ31OIklvJpSBCwEPLxPoXQSdvC?=
	=?iso-8859-15?Q?NcvH3JuyY1ZQO2UPFmTNv5DYJnBShWaY6SKVsuBWrcEQ9QRQIuaY5hZzy?=
	=?iso-8859-15?Q?g+aiN0cMpoH0wSPCXZd3Ic//TxlhQdzO3GhUJZYuKmJvNjKDD41VXDLqY?=
	=?iso-8859-15?Q?K4YzmKwq6Y/1DYHOgIivteaXhx4UMl3ghy8lZHlvoxWd7/DrniZ6SOdI5?=
	=?iso-8859-15?Q?76bPX0CUToYR6Lh5ZT6Hhi+UOOY8zbc0yQ/J7LX4RVRGkTptgw/2q497v?=
	=?iso-8859-15?Q?If6+OItJbu2TA35YOYIFyurAsdl7QZnbQ2WIZ8LxQZ9TgitIu9YBA5XWN?=
	=?iso-8859-15?Q?C/QDpwRJ8KV/7FLMcKkQ3b0iLJoKNaMoTqgRZd3L9qOON9jDPlVfCdTLN?=
	=?iso-8859-15?Q?+HHLJcZIoaD5yV4TClNVewTL5IVxpx2hbEJ8Pf09RnpqGrKk+ZkbldFBW?=
	=?iso-8859-15?Q?z3eLDZAxgeJA4d/BtGdWSganjZ5qeGno6GEuga/2Tfn6kwmt2YGDpl7oj?=
	=?iso-8859-15?Q?oBPf23RUxW7QQG5TE2pPsb8+lSNi5ltJwO6ramvD2SzkKbRVXRkoWeDmh?=
	=?iso-8859-15?Q?R3UsHHrbAggqlywWBSg4Jy7q/UMIKUxZpAm6Q50SHQ9x7NYIcQIcrGBVY?=
	=?iso-8859-15?Q?ZLefrrqD5avo/0QMG78EUR8e3uO7wCE/T2wkX2Q7VZT4jAxuibLKf326G?=
	=?iso-8859-15?Q?ifcjxWxTLzYSveRi0XUlS4vyRt9FSHAP5yvDS5Y19Fx9nynDR+JItlk9a?=
	=?iso-8859-15?Q?lY9Z2WsTkOg73m297pau3zjnAQ8vlq0Qc/lUfYhio3p86k1gWslbB/W6I?=
	=?iso-8859-15?Q?ZOPrhChocX1zSIzV3X1M6cSEY528PfyCMkb8cE0ak7NGaylSHBJQwK/6h?=
	=?iso-8859-15?Q?ODI0ydf1mAAeZyWo0PPFTNw8VXfIH8F0P6Pwr5LsxTfH8r8m4/D/b8Qvu?=
	=?iso-8859-15?Q?xwHe7YRqElOBEuLspGHXL3/NPQFvwf9ZNGHv40dui0vV1bcdE4iiVJEtW?=
	=?iso-8859-15?Q?SH/rs+ZEMUItCLK/Ly4tNkLG7OepWa4MTp6IHwyKmth5VCwiRZ/ah5Qr3?=
	=?iso-8859-15?Q?SbsFlHuqCkMuvNBg5F8n1eYqRqgxghBpj8Qmn/FpJBczcTGdW5/SptslP?=
	=?iso-8859-15?Q?slQKOz76/cM1ba9TudJzkfLlrS/vEkCoiTNVO7qBckQr5Fm70tTpLeZhO?=
	=?iso-8859-15?Q?yOlr164dDL8i+CgqV+Q3j2aFbTjvAosZAQM8Cckz6Giu8cFnO5zfnOqJe?=
	=?iso-8859-15?Q?2r0M4XQb1++6pJi+/OAYNnwTxU1W1uuSIZ+7aWvGyW6eph9T2fL6toMls?=
	=?iso-8859-15?Q?5E/lDIrNwSQrvoyXYpGqFT883Os4IrzcVW2OZ9auiH5dfQ8=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fecb07e-fb45-4886-694e-08d9adefc305
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2021 19:39:12.9437 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yHnnNiGMaK+ME1cugS2SOT4nTT4IkH9al4liSLlII2QG1+IsWP0BfuzOPfHRAeKTtAVn112QiS9FpomQ4EgiTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7899
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AMJdJus009747
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] multipathd: avoid unnecessary path read-only
	reloads
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <B86B619BBD4B9140A0AF250365436043@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-11-22 at 11:43 -0600, Benjamin Marzinski wrote:
> On Mon, Nov 22, 2021 at 04:48:06PM +0000, Martin Wilck wrote:
> > On Mon, 2021-11-22 at 09:35 -0600, Benjamin Marzinski wrote:
> > > On Fri, Nov 19, 2021 at 09:33:39PM +0000, Martin Wilck wrote:
> > > > On Thu, 2021-11-18 at 16:47 -0600, Benjamin Marzinski wrote:
> > > > > A mulitpath device can only be reloaded read/write when all
> > > > > paths
> > > > > are
> > > > > read/write. Also, whenever a read-only device is rescanned,
> > > > > the
> > > > > scsi
> > > > > subsystem will first unconditionally issue a uevent with
> > > > > DISK_RO=3D0
> > > > > before checking the read-only status, and if it the device is
> > > > > still
> > > > > read-only, issuing another uevent with DISK_RO=3D1. These
> > > > > uevents
> > > > > cause
> > > > > pointless rereads when read-only paths are rescanned. To
> > > > > avoid
> > > > > this,
> > > > > check to see if all paths are read/write before changing a
> > > > > multipath
> > > > > device from read-only to read/write.
> > > > >=20
> > > > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > > > ---
> > > > > =A0libmultipath/libmultipath.version |=A0 5 +++++
> > > > > =A0libmultipath/sysfs.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | =
22
> > > > > ++++++++++++++++++++++
> > > > > =A0libmultipath/sysfs.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=
=A0 1 +
> > > > > =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 | 31
> > > > > ++++++++++++++++++++++++++++++-
> > > > > =A04 files changed, 58 insertions(+), 1 deletion(-)
> > > > >=20
> > > > > diff --git a/libmultipath/libmultipath.version
> > > > > b/libmultipath/libmultipath.version
> > > > > index 58a7d1be..ab4c7e30 100644
> > > > > --- a/multipathd/main.c
> > > > > +++ b/multipathd/main.c
> > > > > @@ -1440,6 +1440,35 @@ finish_path_init(struct path *pp,
> > > > > struct
> > > > > vectors * vecs)
> > > > > =A0=A0=A0=A0=A0=A0=A0=A0return -1;
> > > > > =A0}
> > > > > =A0
> > > > > +static bool
> > > > > +needs_ro_update(struct multipath *mpp, int ro)
> > > > > +{
> > > > > +=A0=A0=A0=A0=A0=A0=A0struct pathgroup * pgp;
> > > > > +=A0=A0=A0=A0=A0=A0=A0struct path * pp;
> > > > > +=A0=A0=A0=A0=A0=A0=A0unsigned int i, j;
> > > > > +=A0=A0=A0=A0=A0=A0=A0struct dm_info *dmi =3D NULL;
> > > > > +
> > > > > +=A0=A0=A0=A0=A0=A0=A0if (!mpp || ro < 0)
> > > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return false;
> > > > > +=A0=A0=A0=A0=A0=A0=A0dm_get_info(mpp->alias, &dmi);
> > > >=20
> > > > Why can't you just use mpp->dmi here?
> > >=20
> > > Since that value is set when the dmi is originally created, I
> > > didn't
> > > want to not reload a map, if we simply haven't updated it yet to
> > > reflect
> > > a change in the read-only value, like with do with
> > > dm_is_suspended()
> > > or dm_get_deferred_remove(), etc. I could make a
> > > dm_get_read_only()
> > > function and put it libmultipath/devmapper.c like the others, if
> > > you'd
> > > rather.
> >=20
> > I had expected that this property wouldn't silently change under
> > us.
> > Actually, I do think that we should get an uevent if this happens.
> > Not sure if we process it properly, though.
>=20
> I think we will update the dmi, but I'm not sure that these uevents
> won't race. The worry was that the device would switch to read-only
> and
> then back too quickly, and we would get this event and still see the
> device in read/write because we haven't processed the event which
> would
> update the multipath dmi.

OK. I'm fine with the patch, perhaps explain these subtleties some more
in the commit message for future reference.

Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

