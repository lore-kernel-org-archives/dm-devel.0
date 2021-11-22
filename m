Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2479AC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 22 Nov 2021 16:48:27 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-11HERDgjMLKzCam-2ILELA-1; Mon, 22 Nov 2021 11:48:22 -0500
X-MC-Unique: 11HERDgjMLKzCam-2ILELA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A69B9128A;
	Mon, 22 Nov 2021 16:48:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8006B10016F2;
	Mon, 22 Nov 2021 16:48:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F121A4A703;
	Mon, 22 Nov 2021 16:48:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AMGmCSd027078 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 22 Nov 2021 11:48:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 665DD4010FFC; Mon, 22 Nov 2021 16:48:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 600E840CFD0B
	for <dm-devel@redhat.com>; Mon, 22 Nov 2021 16:48:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 43EF3811E7A
	for <dm-devel@redhat.com>; Mon, 22 Nov 2021 16:48:12 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-72-5cxzXSXbOKmFzeiAY1ATNg-1; Mon, 22 Nov 2021 11:48:10 -0500
X-MC-Unique: 5cxzXSXbOKmFzeiAY1ATNg-1
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
	(mail-am6eur05lp2106.outbound.protection.outlook.com [104.47.18.106])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-8-VRIkFSrTOgmvy717wj3sLg-1; Mon, 22 Nov 2021 17:48:08 +0100
X-MC-Unique: VRIkFSrTOgmvy717wj3sLg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5578.eurprd04.prod.outlook.com (2603:10a6:10:87::26) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22;
	Mon, 22 Nov 2021 16:48:07 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c445:c7a6:f796:5e65]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c445:c7a6:f796:5e65%3]) with mapi id 15.20.4713.024;
	Mon, 22 Nov 2021 16:48:07 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH] multipathd: avoid unnecessary path read-only reloads
Thread-Index: AQHX3M5WUEb/bxOK1E+H6voh4CAkfawPs7yLgAAUGQA=
Date: Mon, 22 Nov 2021 16:48:06 +0000
Message-ID: <7ae474b1273b27a188593b716e5f0dfc1d09cad1.camel@suse.com>
References: <1637275667-13436-1-git-send-email-bmarzins@redhat.com>
	<6444fd097cf43bdfe6b1947f42f270e958310fff.camel@suse.com>
	<20211122153554.GJ19591@octiron.msp.redhat.com>
In-Reply-To: <20211122153554.GJ19591@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1decef6b-2df6-4896-092d-08d9add7dc03
x-ms-traffictypediagnostic: DB7PR04MB5578:
x-microsoft-antispam-prvs: <DB7PR04MB5578CC178E71BAE4941D2B5DFC9F9@DB7PR04MB5578.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 3j4bUODxkMiLAFlT7Yjn9Fk+KSyy8MVSLSKUpMa1mbsktRCkEmjvtPyeMCrk4EQBdMgJcH1oTiGGsyihj+w6G9vV6pLk5Hvc5YKbVkrV+q8bAhvPvNCGoIsn4xl2HA89OcP7bxsZySHh2CYWc5xbG48BL95nD1u9WmxblbyM+EeVujNLX7TmZiDp13H1fwB8/c8fyXqsKarVtMOpJLpcPcEvKKVVnsjOc/2j89o60XKxcgvlZt/RB2clcYoe6xOv2vKHKu35dzDlN4dyHqrJ3iZxsIuz14+9+la7S1HZ1ABcKIJMwZDaEDuBrAVHy5WuqB764p6besawZ6sM47aoX4Qn0YxawX82qP67bZlEPkXeLC0A1CDZXBG5LBw6+EkN4yT6I//BSZiKc36wgRO4dV0T2278eF5hhhvUo4NT+WBycuXxyVdr3EobnrctXfsXdyYnKDp5EbyMpb49nIsHzTerGagpK5/KoBM59iYlsSm6Ow8HnSLEDh8sdZMiMm6KojWtLkNq4baEeDeY5jtLJT7TK4r7jPSiQx5wzqS3p6lw8q8AzjBoRioUCncC4l3uvDiBdG6o5fTkhy7tnZOaGGIE1AGRSe8qt65Vnac7UZbgpdMCeQMlwXKoRVd+AvA4by2hvY0g8E799bvB3OZtQk0Z54N3ytOiC17jBQdNxOwTizvrcXQc5hbK88WSajv03WEhx1h/zM4DWQ9udMPc0g==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(6506007)(66946007)(66476007)(76116006)(36756003)(6486002)(91956017)(8676002)(6512007)(4001150100001)(44832011)(2906002)(38070700005)(66556008)(508600001)(64756008)(316002)(83380400001)(2616005)(86362001)(71200400001)(4326008)(26005)(8936002)(5660300002)(54906003)(6916009)(186003)(66446008)(122000001)(38100700002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?CBlLAD1OPTWTYh67/4zhieo+herIg+yn/U28bFccqX/nwzY0Om8N6x5Fw?=
	=?iso-8859-15?Q?3bmOOdEzJNHsXl/NKDUsXGNML9wSYK6Ob47mdEFfCjZBNgEbhJcqedd8v?=
	=?iso-8859-15?Q?9BTZrnVWFyEDfohPzrBxchSDhuMEylG8efnmJ77OKA6PwsnFP1WjVbVq9?=
	=?iso-8859-15?Q?OqSkbeIZKEEUd3dkr2xDXM3MTKYb9GIy2cuVZuuNxDngVtj1zvWHrblHk?=
	=?iso-8859-15?Q?+taE9o7e+enkVGHOn2jaLA3uvx4c/DYDTOE9J8MZ9qvQhMKF0HchMu4W4?=
	=?iso-8859-15?Q?mTeJYeuMmALDb6YdgEscYyShUdpRr/suaDaK2+TuwTm9XuRFwpO9z3USF?=
	=?iso-8859-15?Q?67/gqnmoL5zgRx6gtJQt5hwZADDent7HYHWLfKdfQa09UgpXS60PxvkQG?=
	=?iso-8859-15?Q?eitYzcBzNbgbd9F8Xm5olEsnUg+fbNLZ78tFqSJvslads6aaAmk/2J9FO?=
	=?iso-8859-15?Q?52eMNkNHVERJcbPdoyjTn+RlYm1N6T+tD4/+S3rgma7XHcSNEeR6DG7dv?=
	=?iso-8859-15?Q?dgnA3w/98YXnDxufey2SmSdy/deytvSZ7CZeQacfqfy7AJTFRoOhgGQxI?=
	=?iso-8859-15?Q?h6j3LgwkuJiPVVZ7SXUU43qH7zObLYkPpYXjfEa1PEgHfCcGT7jNL59AM?=
	=?iso-8859-15?Q?AOs8fKrCndmacO2pWadDur+ey6tmb48z/jddnNwVEzmByeI65h5KHlIhR?=
	=?iso-8859-15?Q?9uOyHOkdbU2wvswbUXa15hML1a66A1u3dLxQcIdvc1LfScjTMsWdehs+Q?=
	=?iso-8859-15?Q?NQJqc/SeqR+88/sifSSew4qavahb+9vaeCENqg7D0LrEPubzN/iUTRrnC?=
	=?iso-8859-15?Q?hAmrnH0/D9vDFtmCHpIv5lxwDNnyZBn4ncnHz0ll5x5DtMwlx1fKdY9ph?=
	=?iso-8859-15?Q?tlRqyoqpEGSIA1VB00A0rOd2sNe67hyTAeu+RfQZ0h3ANdTH2rukAsZEE?=
	=?iso-8859-15?Q?b8M9YBPxLvKrmTPNnCNQ5i1scFjGG+PiY7PPzCA523rhyW3gpiLUNfVXY?=
	=?iso-8859-15?Q?CDC1vp5Zgk2H4arltDpDQFiRzkK6eAxD6YbmxoNxpVxTEFGh0kUudOrpd?=
	=?iso-8859-15?Q?sQ4L4hAhAtuZmFZShWIPavsiPfvTvXPZT9yCPOYdKuljomNfll0tNfSmG?=
	=?iso-8859-15?Q?iAGk8T5mYyInkqXZ0ql/q9mmEOL9Ycd1jlrFvsRyRBG3elzCrLteGyMcO?=
	=?iso-8859-15?Q?MsgdIiMQGR/Y3nFCPrlYQq/WV35HlPUleTrbtnBmB41G8xY0Wq1RH/sRU?=
	=?iso-8859-15?Q?cnHkOUxFIRZ2gmI6bg9JErAKZREVururpn8OrNalSaZG7IyxuTPip1g5e?=
	=?iso-8859-15?Q?Da2Ogw+JIl2B+MpxVIYRTiew2t7SDKHEhTDEppQL9nQN+M790BaQ+S2Ph?=
	=?iso-8859-15?Q?u7WPA/EF4zXDqiAAsh8DMkPKKZNPg0Vv5p8ss5gffTej4kEkV5HrMs19A?=
	=?iso-8859-15?Q?mJRfjMugiHsVq+5h8fgwqh3WSoX9xn4Hd57/LtQs/0KFYABx95lxS2Yxd?=
	=?iso-8859-15?Q?EB0aZGs2ZlP8pMd+eRSdGOc9jqj7lUH16fWzHIkwsr2kLekeUXk7u5pMz?=
	=?iso-8859-15?Q?5VK37Prwx7MV5hLsNDCz4ZwWmWLhIQ/ksH4miRj8sn0GegC6x4rGsK87u?=
	=?iso-8859-15?Q?3wwR68V+3tClUB86d8Tt29x1P9MCHW7kLb3xsAnkZdbFDKX1fzpgj0e1Y?=
	=?iso-8859-15?Q?Pue9DBuj50b/Z8K6DJjFGNUQ5r6QZbT0i8qms+HDoK8ktsc=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1decef6b-2df6-4896-092d-08d9add7dc03
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2021 16:48:06.8737 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n0QQiDgwEeKgIVC6oUAnEVUPYMgHOP7aaUJBolU14Nk5Ba5WgsJv+/YxAoZBhKX6riJaRTTKrwXmXpN/TG9KRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5578
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AMGmCSd027078
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <887EFC16CE1242469CBD5ED28E6C29D5@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-11-22 at 09:35 -0600, Benjamin Marzinski wrote:
> On Fri, Nov 19, 2021 at 09:33:39PM +0000, Martin Wilck wrote:
> > On Thu, 2021-11-18 at 16:47 -0600, Benjamin Marzinski wrote:
> > > A mulitpath device can only be reloaded read/write when all paths
> > > are
> > > read/write. Also, whenever a read-only device is rescanned, the
> > > scsi
> > > subsystem will first unconditionally issue a uevent with
> > > DISK_RO=3D0
> > > before checking the read-only status, and if it the device is
> > > still
> > > read-only, issuing another uevent with DISK_RO=3D1. These uevents
> > > cause
> > > pointless rereads when read-only paths are rescanned. To avoid
> > > this,
> > > check to see if all paths are read/write before changing a
> > > multipath
> > > device from read-only to read/write.
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > ---
> > > =A0libmultipath/libmultipath.version |=A0 5 +++++
> > > =A0libmultipath/sysfs.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 22 +=
+++++++++++++++++++++
> > > =A0libmultipath/sysfs.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1=
 +
> > > =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
| 31
> > > ++++++++++++++++++++++++++++++-
> > > =A04 files changed, 58 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/libmultipath/libmultipath.version
> > > b/libmultipath/libmultipath.version
> > > index 58a7d1be..ab4c7e30 100644
> > > --- a/multipathd/main.c
> > > +++ b/multipathd/main.c
> > > @@ -1440,6 +1440,35 @@ finish_path_init(struct path *pp, struct
> > > vectors * vecs)
> > > =A0=A0=A0=A0=A0=A0=A0=A0return -1;
> > > =A0}
> > > =A0
> > > +static bool
> > > +needs_ro_update(struct multipath *mpp, int ro)
> > > +{
> > > +=A0=A0=A0=A0=A0=A0=A0struct pathgroup * pgp;
> > > +=A0=A0=A0=A0=A0=A0=A0struct path * pp;
> > > +=A0=A0=A0=A0=A0=A0=A0unsigned int i, j;
> > > +=A0=A0=A0=A0=A0=A0=A0struct dm_info *dmi =3D NULL;
> > > +
> > > +=A0=A0=A0=A0=A0=A0=A0if (!mpp || ro < 0)
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return false;
> > > +=A0=A0=A0=A0=A0=A0=A0dm_get_info(mpp->alias, &dmi);
> >=20
> > Why can't you just use mpp->dmi here?
>=20
> Since that value is set when the dmi is originally created, I didn't
> want to not reload a map, if we simply haven't updated it yet to
> reflect
> a change in the read-only value, like with do with dm_is_suspended()
> or dm_get_deferred_remove(), etc. I could make a dm_get_read_only()
> function and put it libmultipath/devmapper.c like the others, if
> you'd
> rather.

I had expected that this property wouldn't silently change under us.
Actually, I do think that we should get an uevent if this happens.
Not sure if we process it properly, though.

> =A0
> > > +=A0=A0=A0=A0=A0=A0=A0if (!dmi) /* assume we do need to reload the de=
vice */
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return true;
> >=20
> > Why that? I'd assume that if a DM_DEVICE_INFO ioctl fails on the
> > device, a RELOAD would almost certainly fail, too.
> >=20
>=20
> Since reloading when it's not necessary doesn't do any harm (it's
> what
> we currently do) while not switching to read/write when we should is
> a
> problem, I thought that I'd error on the side of caution, but I agree
> that the reload is unlikey to succeed, so I can change this if you'd
> like.

I misunderstood what being "cautious" means in this context. I gather
now that it's "if in doubt, reload". Fine with me.

>=20
> > > +=A0=A0=A0=A0=A0=A0=A0if (dmi->read_only =3D=3D ro) {
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(dmi);
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return false;
> > > +=A0=A0=A0=A0=A0=A0=A0}
> > > +=A0=A0=A0=A0=A0=A0=A0free(dmi);
> > > +=A0=A0=A0=A0=A0=A0=A0if (ro =3D=3D 1)
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return true;
> > > +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot (mpp->pg, pgp, i) {
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot (pg=
p->paths, pp, j) {
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (sysfs_get_ro(pp) =3D=3D 1)
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0return false;
> >=20
> > I think you should also return false here if sysfs_get_ro() returns
> > error.
>=20
> Same thing here. I was erroring on the side of caution, but it should
> be
> fine to change.

Same misunderstanding on my part. Thanks for the clarification.

Regards
Martin

>=20
> -Ben
>=20
> =A0
> > Regards,
> > Martin
> >=20
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > > +=A0=A0=A0=A0=A0=A0=A0}
> > > +=A0=A0=A0=A0=A0=A0=A0return true;
> > > +}
> > > +
> > > =A0static int
> > > =A0uev_update_path (struct uevent *uev, struct vectors * vecs)
> > > =A0{
> > > @@ -1512,7 +1541,7 @@ uev_update_path (struct uevent *uev, struct
> > > vectors * vecs)
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > > =A0
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ro =3D uevent_get_dis=
k_ro(uev);
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (mpp && ro >=3D 0) {
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (needs_ro_update(mpp=
, ro)) {
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0condlog(2, "%s: update path write_protect
> > > to
> > > '%d' (uevent)", uev->kernel, ro);
> > > =A0
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (mpp->wait_for_udev)
>=20


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

