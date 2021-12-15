Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CF92C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 15 Dec 2021 07:37:09 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-172-L3JJUCFqNwWYqDbkDzQ-9g-1; Wed, 15 Dec 2021 02:37:04 -0500
X-MC-Unique: L3JJUCFqNwWYqDbkDzQ-9g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E356F100E328;
	Wed, 15 Dec 2021 07:37:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 441E68795B;
	Wed, 15 Dec 2021 07:37:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C39541809C88;
	Wed, 15 Dec 2021 07:36:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BF7Z21V011143 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 15 Dec 2021 02:35:02 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8128E2166B49; Wed, 15 Dec 2021 07:35:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A6122166B44
	for <dm-devel@redhat.com>; Wed, 15 Dec 2021 07:34:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4C101C1CD6A
	for <dm-devel@redhat.com>; Wed, 15 Dec 2021 07:34:59 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-117-GPyImbqDOdSQMtLAzXnBZw-1; Wed, 15 Dec 2021 02:34:56 -0500
X-MC-Unique: GPyImbqDOdSQMtLAzXnBZw-1
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
	(mail-db8eur05lp2111.outbound.protection.outlook.com [104.47.17.111])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-35-tRdoz97YNOyWZuK9tR2t3A-1; Wed, 15 Dec 2021 08:34:54 +0100
X-MC-Unique: tRdoz97YNOyWZuK9tR2t3A-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB6PR0402MB2743.eurprd04.prod.outlook.com (2603:10a6:4:95::8) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17;
	Wed, 15 Dec 2021 07:34:53 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9%6]) with mapi id 15.20.4778.018;
	Wed, 15 Dec 2021 07:34:53 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH] multipathd: avoid unnecessary path read-only reloads
Thread-Index: AQHX3M5WUEb/bxOK1E+H6voh4CAkfawy4bFigABxMAA=
Date: Wed, 15 Dec 2021 07:34:52 +0000
Message-ID: <d454450eeff45a29919615a023cb22098f3cec24.camel@suse.com>
References: <1637275667-13436-1-git-send-email-bmarzins@redhat.com>
	<e66c48b73da8481f7f2365aa90f8a90624972255.camel@suse.com>
	<20211215004923.GC19591@octiron.msp.redhat.com>
In-Reply-To: <20211215004923.GC19591@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.2
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1887005e-45fe-4581-4967-08d9bf9d6260
x-ms-traffictypediagnostic: DB6PR0402MB2743:EE_
x-microsoft-antispam-prvs: <DB6PR0402MB2743AF6725CC307AF7D384E9FC769@DB6PR0402MB2743.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: AcBAIcKLAyjNhO/sJwjtq0SvrVVwl9o9UhBIYmSrGnF20WSSKMfW7sn+4I9J0jOW259xDFVQw9oC0zS8DvTCfNfDV9mXgPIwDQmJkf/kfbulOXRcfTEr744GBdvv0RCYsWaKo7uItsbu6dz1mMM8xEGUN7d5z91XqPsbjtgF/aySn0UKPhcEWHIN4xiJS8C/zkeeGYyZW20KrlHjx5xKA28eN03H/DttpVpteiEFzsV6MCUsKiiYIjI5Od15pq7x5wRH7LS+IPRJgYEO3UvYl27rOR3xNWEzww2Nn8w1zOdCZilbbkH+ipliyAIx5xMP5LZLKLVfxMa0sw4TamTJwlhspmTHZYyiY6wCFcMECoYUB5aHgiSIZLhsFiRqdjswYQij1E2v8Wr7crvRQnNDn7P8WC8vE8tX+QVdRZpReexyvMjvXNUqXRhMhaizkE75JbNrFlTSoTyWRF26vcFOaddHZWp+22HiWVolM9lDEVTByvIejgo9VuTXKupaMsIkJxlUjqqW1CjcJbbpVN8sEmqYrB0Q6WiSOuZyNeGiyt6O9p3jyqkBcneVYjBEL1ejm0ctLTgsQeWcLXj21za2shyUPKK2wwIl/p/OcxQqwMWleBoIjtla4ILlT+4bRg+IDuZoizNoY1C76A7xdKpqjd6V2xD36MGvezAVYHe3F7O0FapY75qR46QCl7CNjerpoJUwyGAvJGEcppbC+f6UmQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(122000001)(186003)(36756003)(86362001)(2906002)(6512007)(6486002)(66556008)(38100700002)(26005)(316002)(8936002)(64756008)(54906003)(6506007)(4001150100001)(66476007)(4326008)(91956017)(2616005)(66946007)(8676002)(5660300002)(6916009)(508600001)(76116006)(66446008)(83380400001)(44832011)(38070700005)(71200400001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?omE7JdmRbb9EIhNhACw7ntrY4owaLMEIIB2DckKjrBxBVx32xv6WL5e4q?=
	=?iso-8859-15?Q?17ZaErLqr5Dh6P5FOvsu7KxGhwKlVFhAfpDoAOp0H9s49YFyi4Yv8ZY8I?=
	=?iso-8859-15?Q?iMkPpTTcWhfhnK2OX6UNwfwGYB7XIv9tlzTMWywpY/RAIQMbCU8Lp9CMm?=
	=?iso-8859-15?Q?kOX/byxH/80K2/SH+CYYUZgEQmGnPhWUd6WocpfZlH40vPsjFFtwwBlmC?=
	=?iso-8859-15?Q?w1bXLIhaqEn7yfJMu4H8/iP6eGFwBs/lvvm6fhjZKWjOkpd7wtRFJ0xwg?=
	=?iso-8859-15?Q?DGARCe3qg48A19HNcuj7mDMX8lb73CNOvphrWlrxaH9o91JiaHYJUbcoL?=
	=?iso-8859-15?Q?RnPb5B0vcYK/TdrNW9J/JJdHGUQhsSAuezmPEgQxJcpR/Ff0MH+Hk5Fur?=
	=?iso-8859-15?Q?XvVXYHf1xahYiz5Fr06286ZQn9+ONAGr8CmETtq3proJdhwkkF6seHc0e?=
	=?iso-8859-15?Q?FVnzjo7/K6grYLHIZ7llKsf+R4lbGTKbqc3AtYei3L9AEO026WeGdWSad?=
	=?iso-8859-15?Q?5Bd+gasie8WC5YU6a4xqJ0hNgHyXBmw/S913uyoMrhkQpP3PCo9hq1L1q?=
	=?iso-8859-15?Q?5AUk7NrL2pwYbRAug4ofCf50weNrvo4qF9Xw/1InPgT3KHtgPnNMWb3nl?=
	=?iso-8859-15?Q?9Yvaor3Oln1gxz0P7nbTepZrgpyin7Tbh0Y77T4jafRgkjC7HJYEj0N6t?=
	=?iso-8859-15?Q?jebtQ0KNI7Tmy9X7GqbzDEy11CO0EhQbAZJsbxYw+zFVLt3TEIakWMtrs?=
	=?iso-8859-15?Q?qFl3O/8nJxgKfOuoco8OK9/+uFT+PwL1AzOKyrDJiVZkP6oidA/IEWnmm?=
	=?iso-8859-15?Q?wtW6aEbboLIhKr/tsZVx4fGHmB9kFFdrKlL8dVcimhSQ7tGMnq5xobqok?=
	=?iso-8859-15?Q?N+nVz0HvxgZVQCsvbw1p9Ir99g7Ni/agErW6qegEUVqDTLWoKRXsECsXV?=
	=?iso-8859-15?Q?FNX8QnL8/xnqPdRklJ7aVzVqw6AEnhairBe9zSndTOOmSW1EbUxO2JmDD?=
	=?iso-8859-15?Q?ibZZc4nd3BlNeoqLAO4w3eODgSCh+tPPAbxQE1r80ots0DHmULBGQqUfD?=
	=?iso-8859-15?Q?jvnA2PqBWbFUYm+pm9PIZCqTVbVJWHSQyoNcE1m2PY67sZtFQQt834Y7f?=
	=?iso-8859-15?Q?75CiXT9E1y3UpQRctlVBBEBOsN7PcWjYPXbfh4K2xIOpu/4z7ZOsm9jgA?=
	=?iso-8859-15?Q?m6SW9SeVfbarELYYkKcqF2iZxWgpjQsqksrypHuxGzBK4bfcLxqJm4jxy?=
	=?iso-8859-15?Q?LAF19LZjwzApYhmU7hwu4b1b9ieIdbm1fTQCNH4QHZp13YKKvhe/wEgDX?=
	=?iso-8859-15?Q?Fyg6tapiTRvglgxYd0c0OZAhv7AnmtRG39ZNUMtgOOqSjfNKxbyx/PtRM?=
	=?iso-8859-15?Q?xZavygM2RT90FmbDzFYQ3WqH64+WzoLRAVOIXktvZrBvI9pM8w54Qu74Z?=
	=?iso-8859-15?Q?YBgyxYZymNH3YYBD7UGQT4Tz+ksMGCzc80/4+1ox7VPQR8YjfCXlPHhU0?=
	=?iso-8859-15?Q?rqautlklyAksl6jVPfMjNJTwXu5v01jOY35UeV4me8KFz6IUTC4BSwae6?=
	=?iso-8859-15?Q?7mDW3YCgukZM9m5AP5lNh1ns+GPFYNM2X5+2mQEWe8ahyW4RBu1cPzSVT?=
	=?iso-8859-15?Q?vLorBp1XVLDe15yshTOqvFkPssTsGfQtNE9pHJnxMpvKEdDlUwfQawUSn?=
	=?iso-8859-15?Q?Cv+PrcteylpyG9cpRtW8fjoF74eK5sMZm4miRbIQoC/wWgc=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1887005e-45fe-4581-4967-08d9bf9d6260
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 07:34:53.0394 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lDn0QFX2EfDkePSBQCPtW4D82kwal0e/YNJH9BuDV6gwgx2n5MYHT/Ho4HlBd00j6NAWAF3aTi6Je4i/CxUA1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2743
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1BF7Z21V011143
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <5516635F231BFA40B4ED8FED6F7BD28F@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-12-14 at 18:49 -0600, Benjamin Marzinski wrote:
> On Fri, Dec 03, 2021 at 08:25:00AM +0000, Martin Wilck wrote:
> > On Thu, 2021-11-18 at 16:47 -0600, Benjamin Marzinski wrote:
> > > +int
> > > +sysfs_get_ro (struct path *pp)
> > > +{
> > > +=A0=A0=A0=A0=A0=A0=A0int ro;
> > > +=A0=A0=A0=A0=A0=A0=A0char buff[3]; /* Either "0\n\0" or "1\n\0" */
> > > +
> > > +=A0=A0=A0=A0=A0=A0=A0if (!pp->udev)
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -1;
> > > +
> > > +=A0=A0=A0=A0=A0=A0=A0if (sysfs_attr_get_value(pp->udev, "ro", buff,
> > > sizeof(buff))
> > > <=3D 0) {
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: Cannot =
read ro attribute in
> > > sysfs",
> > > pp->dev);
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -1;
> > > +=A0=A0=A0=A0=A0=A0=A0}
> > > +
> > > +=A0=A0=A0=A0=A0=A0=A0if (sscanf(buff, "%d\n", &ro) !=3D 1 || ro < 0 =
|| ro > 1) {
> >=20
> > This is ok, but for self-evidently correct code in multipath-tools,
> > it'd be better to read just 2 bytes and set buff[2] =3D '\0'
> > explicitly.
> > I haven't checked, but coverity might stumble on this.
>=20
> Actually this is just the way sysfs_attr_get_value() works. You have
> to
> provide a larger buffer than you will read (in this case, ro will
> only
> ever have two bytes), otherwise it will think that it overflowed.
> sysfs_attr_get_value() also does the NULL termination itself.
>=20

Well, fine then. It's a nit anyway.

Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

