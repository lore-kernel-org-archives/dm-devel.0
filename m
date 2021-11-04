Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA4D4C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 21:16:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 71E156124F
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 21:16:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 71E156124F
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-huTISggQOZKbO9IQWV-Lmg-1; Thu, 04 Nov 2021 17:16:34 -0400
X-MC-Unique: huTISggQOZKbO9IQWV-Lmg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98F8D1808304;
	Thu,  4 Nov 2021 21:16:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B9AA60C81;
	Thu,  4 Nov 2021 21:16:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 045DA1806D04;
	Thu,  4 Nov 2021 21:16:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4LBjeA025658 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 17:11:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0F3D22026D6B; Thu,  4 Nov 2021 21:11:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0644B2026D46
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 21:11:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CBAA7811E7A
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 21:11:41 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-26-30v4SHZtMCuZkg6-ddzJZQ-1;
	Thu, 04 Nov 2021 17:11:40 -0400
X-MC-Unique: 30v4SHZtMCuZkg6-ddzJZQ-1
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur04lp2050.outbound.protection.outlook.com [104.47.14.50])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-10-l-cHBhZnPm-yIXcDWjLGHw-1; Thu, 04 Nov 2021 22:11:37 +0100
X-MC-Unique: l-cHBhZnPm-yIXcDWjLGHw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB6PR04MB3111.eurprd04.prod.outlook.com (2603:10a6:6:7::12) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.4649.19; Thu, 4 Nov 2021 21:11:35 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4649.019;
	Thu, 4 Nov 2021 21:11:34 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 8/8] libmultipath: cleanup invalid config handling
Thread-Index: AQHXuu1oU5QnbE7ggkq7MbG1lPGjJav0CzwA
Date: Thu, 4 Nov 2021 21:11:34 +0000
Message-ID: <c93fc9dcca43a0f385b2c172266ab58cfbbb4767.camel@suse.com>
References: <1633550663-25571-1-git-send-email-bmarzins@redhat.com>
	<1633550663-25571-9-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1633550663-25571-9-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 11636fa5-2639-4da7-3ad8-08d99fd7aec6
x-ms-traffictypediagnostic: DB6PR04MB3111:
x-microsoft-antispam-prvs: <DB6PR04MB3111FF704F3A0767A1E3A5A5FC8D9@DB6PR04MB3111.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:422
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: JYJX+Y1xKy6xGgavrdovER6YxWmTmeI2r7/CqLpdrZixJS5Kd+/0mN7cU6LF7LRNBX+l95IPNUzHQhxKD2vNJxbFnGkyW/JKbXZSLxU6ft6JHIf9U5Z/vC2HxV9hSoBSRldQoE3BN7RqIBtNO5zTWmT0+BQQv6UEydhqQffz4T6Xu2jva5QJJdZX4g9fGEx8nNTRzoMvwJuymog2fk49NulGJ9ptH2/8/hK3b6IpCG740qC97MehEsEgGiiqF0U0zZ+CQqhUhfNoKrK/eXncqD1dXdLa/uTMmXRMS7SP6FQUkmhALT9S1s0FwMqRI6EpHCjletEkEPr0Eu/SRnjKQW+6i56UMEH5oAHujfjAqFuyKD+082h6Z4tSEO1yluUWo2A+qoT4/eTgRTMzsFCApFh/PjIBBv2evPdcwM6EelwSg7mKZad+OoN8bps7urqQg8gyFPQT5dX1FlxHF0rJsQnXr4Sc7gG9b3DneGjCy+tjkp5OKZU1L2ip2jYevPVDh2ZZdubidQ89NFVeOvNlzaszpQfrEA/lxrfR0x1wZH8v/UydzR4vuJcq3f1YH+w8dlWa0RuWD97dFPgioNA81o5ZkIpKZ01Ti+ZxBHpygwGUNXvDUltTWCQ9FyYHhNnQzjtUnO6Gji6B5/GXjhXC+YphR+Euczp6BmTJ1T1VU3F9zBryrr7cFW8gfpXeCjLLFN+9QBqETYNbZf65MboTMQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(8676002)(64756008)(110136005)(86362001)(66446008)(508600001)(66556008)(6486002)(66476007)(6512007)(66946007)(71200400001)(186003)(5660300002)(26005)(2616005)(316002)(91956017)(76116006)(83380400001)(4326008)(6506007)(44832011)(8936002)(38100700002)(38070700005)(122000001)(36756003)(2906002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?fECv3rsE2Rb4l2HKeQ2btpfoS6sofQo47/7zy4DxGpDAQkThg4ZR1Pyor?=
	=?iso-8859-15?Q?kOZyM+Y18SjdOyWAX0IPjvCX9LJlReFG3NyS15gX2ZpvRIVWLqrHD5u/C?=
	=?iso-8859-15?Q?HJRRS4yblyhI9tsePdh2tZ5dLk3Yt/KH7CmvzjgcSx24MtDiTBt0ChyqC?=
	=?iso-8859-15?Q?pxtEcTjTKrDV4vDKwPRLZOQt7zoe/oX+6Y5GZrEgJX6pmW82HS2X0zGwS?=
	=?iso-8859-15?Q?kiJ7SaUX7wAtH6cSitS3c8N8XQZTIlFHEtHIZqWLEy/TvBfro/QLeb1ZA?=
	=?iso-8859-15?Q?ZGwk1hTcNZpHVjkY0/geye+DSsq1kBHaZ9IHycIiBK2Ihq6sCihqgmr8J?=
	=?iso-8859-15?Q?UXomxdMGcJCOJXqYJqf6qTThEUT9Qj0BhHXDh81OeZRaMxSRXkMSA82AQ?=
	=?iso-8859-15?Q?BBU5JW+Ss+/lRfGHZGuvj6Fw7mSX6odeAJa/vKhfchZHNw7gALjgyC9QZ?=
	=?iso-8859-15?Q?JYs+90BNGfpo6/JvtmnWyZrCtPxXBJ6RXyiS4yXIeS7E0DmUOzN8wlYNU?=
	=?iso-8859-15?Q?KuvqavUpDzkIe8p2aBIou9Bkzn5036OAV3i4khSrfU7HaFU9ZdokUlUMf?=
	=?iso-8859-15?Q?nkszGJP63IGoFyeOt2ukF2+E+zMoqLGh1lyexno1SyJjyxRaagCkkzxnN?=
	=?iso-8859-15?Q?RvwGn1tf/kbL+sDuhI7XLLDun/JBCNqaA2wWKp4m8eiw6iOv4Q7OnnXyf?=
	=?iso-8859-15?Q?ZFZ5iCX8Ald2geY82WASCZqBqf/VvpO6A5/HLh4+TSlunsQdRv+xrCkJr?=
	=?iso-8859-15?Q?UcYKi+dgBJbR4026Otm9Wp0KmGnBIuO2p1XlAbwZcHLwKQ+caaK2+mu14?=
	=?iso-8859-15?Q?G+zIoqJTbdSIBa6626WWTKAVEUGSciJdZ5qqnJyvPbX/quMhsy2T97yYm?=
	=?iso-8859-15?Q?8qQ56DWvrEnaNKPUvGlPIoIAXIin8RbnvXOLRFlxg0QnX1aWg7NZhS8Q5?=
	=?iso-8859-15?Q?bAtG3sgLfqDGm5Vu0/6N9BOZnRyMJWRd5utqLLNK3YWViEj6UOzwY8X+1?=
	=?iso-8859-15?Q?RcIvuwQD7rAAcPLpGMfFuHX6Lns8n2T8PMWsUgdIbrq8R/AGZqGOq1GcZ?=
	=?iso-8859-15?Q?EiCu2iI7QaXa+dTjrBmr6PzkFMx6Xp8eMVPC/htRN6UKRSmZA0O+r92MD?=
	=?iso-8859-15?Q?D0KegyzwOd+2KTff6IwwdvxUr3OCOtVM8rnJ2SqKNKvPHvy5m0KW5Lhl5?=
	=?iso-8859-15?Q?OuvCe60r7y8VyuMenUKvA+LhF9PKxwAU/dAPrVZMaWj/XzN+4u30Wu7WJ?=
	=?iso-8859-15?Q?pTSsWdbYxT61Jeubip1+GtyiNSlPIIAX+Im86qK6zS7hI8qRTjBVuI9zU?=
	=?iso-8859-15?Q?WBDjv6XHPtOGqw9eZFBIFhuiJmaDqh7EJkXu8ib0KGUBreaUD6bIAnAWq?=
	=?iso-8859-15?Q?9NUPQtxZaVorbVa3Ea/RCbHzFrXCtoCGl9un6UmOoLIsczNO+Y8zIXY3M?=
	=?iso-8859-15?Q?HIOVHkIlqQK14YR4lUcugf7gvXcFveuvzXOjU7nQYXKXpY0G+NYZrfNf5?=
	=?iso-8859-15?Q?/ei01VsUYqli02Verr+QxXGR1t4zWlQyKt3/3BlnfhhOkedTgeRz7kKdi?=
	=?iso-8859-15?Q?4asCFbbcZzx1fzTwWfYQpsBb9u3Wry15ysaRwD9p1pGAnCOXi2m/TQhsu?=
	=?iso-8859-15?Q?yBaV/IVyH+7iM1g+32n5DATiiC7u8Sxz0rcS7alxV0A33OBVJy1So04r9?=
	=?iso-8859-15?Q?sDvOiAZPdFWQSjqJAU2PRox3UiPh7VoUh/TcX7/iHSjbQS8=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11636fa5-2639-4da7-3ad8-08d99fd7aec6
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 21:11:34.7858 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RrksU8J0hrdmJCyLhvgSY+Z+HAiUocICzAdjKQpsB8CU1aZ9Ctvy+Uw1Hym16EVsGr8Hkd+s3YcM/kzlFeClJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3111
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A4LBjeA025658
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 8/8] libmultipath: cleanup invalid config
	handling
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <2AB9461E47249A4FB96247ADCF5C6B8E@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-10-06 at 15:04 -0500, Benjamin Marzinski wrote:
> Add error reporting to the remaining config handlers. If the value is
> invalid, do not change the existing config option's value.

Like for the previous patch, I'm unsure if this is wise. You rely on a
reasonable default being set before the function is called. I suppose
that's the case, but I like seeing the "invalid" value substituted
right there where the validity is checked. That saves us from searching
the code for the default value.

Maybe I overlooked an important rationale for not touching the values
in the case of invalid input, please explain.

Cheers,
Martin

>  Also print
> an error whenever 0 is returned for an invalid value. When the
> handler
> returns 1, config processing already fails with an error message.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =A0libmultipath/dict.c | 73 +++++++++++++++++++++++++++++++------------
> --
> =A01 file changed, 51 insertions(+), 22 deletions(-)
>=20
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index e79fcdd7..8c3b5f72 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -199,8 +199,11 @@ set_yes_no(vector strvec, void *ptr, const char
> *file, int line_nr)
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (strcmp(buff, "yes") =3D=3D 0 || strcmp(buff, =
"1") =3D=3D 0)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D YN_YES;
> -=A0=A0=A0=A0=A0=A0=A0else
> +=A0=A0=A0=A0=A0=A0=A0else if (strcmp(buff, "no") =3D=3D 0 || strcmp(buff=
, "0") =3D=3D 0)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D YN_NO;
> +=A0=A0=A0=A0=A0=A0=A0else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, inv=
alid value for %s:
> \"%s\"",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fil=
e, line_nr, (char*)VECTOR_SLOT(strvec, 0),
> buff);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> @@ -221,7 +224,8 @@ set_yes_no_undef(vector strvec, void *ptr, const
> char *file, int line_nr)
> =A0=A0=A0=A0=A0=A0=A0=A0else if (strcmp(buff, "yes") =3D=3D 0 || strcmp(b=
uff, "1") =3D=3D 0)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D YNU_YES;
> =A0=A0=A0=A0=A0=A0=A0=A0else
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D YNU_UNDEF;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, inv=
alid value for %s:
> \"%s\"",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fil=
e, line_nr, (char*)VECTOR_SLOT(strvec, 0),
> buff);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> @@ -471,9 +475,6 @@ def_find_multipaths_handler(struct config *conf,
> vector strvec,
> =A0=A0=A0=A0=A0=A0=A0=A0char *buff;
> =A0=A0=A0=A0=A0=A0=A0=A0int i;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0if (set_yes_no_undef(strvec, &conf->find_multipaths=
, file,
> line_nr) =3D=3D 0 && conf->find_multipaths !=3D FIND_MULTIPATHS_UNDEF)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> -
> =A0=A0=A0=A0=A0=A0=A0=A0buff =3D set_value(strvec);
> =A0=A0=A0=A0=A0=A0=A0=A0if (!buff)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> @@ -486,9 +487,14 @@ def_find_multipaths_handler(struct config *conf,
> vector strvec,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0
> -=A0=A0=A0=A0=A0=A0=A0if (conf->find_multipaths =3D=3D YNU_UNDEF) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "illegal value f=
or find_multipaths: %s",
> buff);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf->find_multipaths =3D D=
EFAULT_FIND_MULTIPATHS;
> +=A0=A0=A0=A0=A0=A0=A0if (i >=3D __FIND_MULTIPATHS_LAST) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (strcmp(buff, "no") =3D=
=3D 0 || strcmp(buff, "0") =3D=3D
> 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
f->find_multipaths =3D FIND_MULTIPATHS_OFF;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else if (strcmp(buff, "yes"=
) =3D=3D 0 || strcmp(buff,
> "1") =3D=3D 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
f->find_multipaths =3D FIND_MULTIPATHS_ON;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(1, "%s line %d, invalid value for
> find_multipaths: \"%s\"",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0file, line_nr, buff);
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> @@ -537,8 +543,10 @@ static int uid_attrs_handler(struct config
> *conf, vector strvec,
> =A0=A0=A0=A0=A0=A0=A0=A0if (!val)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> =A0=A0=A0=A0=A0=A0=A0=A0if (parse_uid_attrs(val, conf))
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "error parsing u=
id_attrs: \"%s\"", val);
> -=A0=A0=A0=A0=A0=A0=A0condlog(3, "parsed %d uid_attrs", VECTOR_SIZE(&conf=
-
> >uid_attrs));
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d,erro=
r parsing uid_attrs:
> \"%s\"", file,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0lin=
e_nr, val);
> +=A0=A0=A0=A0=A0=A0=A0else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(4, "parsed %d uid_a=
ttrs", VECTOR_SIZE(&conf-
> >uid_attrs));
> =A0=A0=A0=A0=A0=A0=A0=A0FREE(val);
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0}
> @@ -766,8 +774,11 @@ def_config_dir_handler(struct config *conf,
> vector strvec, const char *file,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int li=
ne_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0/* this is only valid in the main config file */
> -=A0=A0=A0=A0=A0=A0=A0if (conf->processed_main_config)
> +=A0=A0=A0=A0=A0=A0=A0if (conf->processed_main_config) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, con=
fig_dir option only valid
> in /etc/multipath.conf",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fil=
e, line_nr);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> +=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0return set_path(strvec, &conf->config_dir, file, =
line_nr);
> =A0}
> =A0declare_def_snprint(config_dir, print_str)
> @@ -825,7 +836,9 @@ set_mode(vector strvec, void *ptr, int *flags,
> const char *file, int line_nr)
> =A0=A0=A0=A0=A0=A0=A0=A0if (sscanf(buff, "%o", &mode) =3D=3D 1 && mode <=
=3D 0777) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*flags |=3D (1 << ATTR_MO=
DE);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*mode_ptr =3D mode;
> -=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0} else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, inv=
alid value for mode:
> \"%s\"",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fil=
e, line_nr, buff);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> @@ -850,7 +863,9 @@ set_uid(vector strvec, void *ptr, int *flags,
> const char *file, int line_nr)
> =A0=A0=A0=A0=A0=A0=A0=A0else if (sscanf(buff, "%u", &uid) =3D=3D 1){
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*flags |=3D (1 << ATTR_UI=
D);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*uid_ptr =3D uid;
> -=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0} else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, inv=
alid value for uid:
> \"%s\"",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fil=
e, line_nr, buff);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> @@ -876,7 +891,9 @@ set_gid(vector strvec, void *ptr, int *flags,
> const char *file, int line_nr)
> =A0=A0=A0=A0=A0=A0=A0=A0else if (sscanf(buff, "%u", &gid) =3D=3D 1){
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*flags |=3D (1 << ATTR_GI=
D);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*gid_ptr =3D gid;
> -=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0} else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, inv=
alid value for gid:
> \"%s\"",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fil=
e, line_nr, buff);
> =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0}
> @@ -978,7 +995,8 @@ set_dev_loss(vector strvec, void *ptr, const char
> *file, int line_nr)
> =A0=A0=A0=A0=A0=A0=A0=A0if (!strcmp(buff, "infinity"))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*uint_ptr =3D MAX_DEV_LOS=
S_TMO;
> =A0=A0=A0=A0=A0=A0=A0=A0else if (sscanf(buff, "%u", uint_ptr) !=3D 1)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*uint_ptr =3D DEV_LOSS_TMO_=
UNSET;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, inv=
alid value for
> dev_loss_tmo: \"%s\"",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fil=
e, line_nr, buff);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> @@ -1012,13 +1030,19 @@ static int
> =A0set_pgpolicy(vector strvec, void *ptr, const char *file, int
> line_nr)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> +=A0=A0=A0=A0=A0=A0=A0int policy;
> =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0buff =3D set_value(strvec);
> =A0=A0=A0=A0=A0=A0=A0=A0if (!buff)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D get_pgpolicy_id(buff);
> +=A0=A0=A0=A0=A0=A0=A0policy =3D get_pgpolicy_id(buff);
> +=A0=A0=A0=A0=A0=A0=A0if (policy !=3D IOPOLICY_UNDEF)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D policy;
> +=A0=A0=A0=A0=A0=A0=A0else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, inv=
alid value for
> path_grouping_policy: \"%s\"",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fil=
e, line_nr, buff);
> =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> @@ -1131,10 +1155,11 @@ set_rr_weight(vector strvec, void *ptr, const
> char *file, int line_nr)
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (!strcmp(buff, "priorities"))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D RR_WEIGHT_PR=
IO;
> -
> -=A0=A0=A0=A0=A0=A0=A0if (!strcmp(buff, "uniform"))
> +=A0=A0=A0=A0=A0=A0=A0else if (!strcmp(buff, "uniform"))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D RR_WEIGHT_NO=
NE;
> -
> +=A0=A0=A0=A0=A0=A0=A0else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, inv=
alid value for rr_weight:
> \"%s\"",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fil=
e, line_nr, buff);
> =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> @@ -1270,10 +1295,13 @@ def_log_checker_err_handler(struct config
> *conf, vector strvec,
> =A0=A0=A0=A0=A0=A0=A0=A0if (!buff)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0if (strlen(buff) =3D=3D 4 && !strcmp(buff, "once"))
> +=A0=A0=A0=A0=A0=A0=A0if (!strcmp(buff, "once"))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf->log_checker_err =3D=
 LOG_CHKR_ERR_ONCE;
> -=A0=A0=A0=A0=A0=A0=A0else if (strlen(buff) =3D=3D 6 && !strcmp(buff, "al=
ways"))
> +=A0=A0=A0=A0=A0=A0=A0else if (!strcmp(buff, "always"))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf->log_checker_err =3D=
 LOG_CHKR_ERR_ALWAYS;
> +=A0=A0=A0=A0=A0=A0=A0else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, inv=
alid value for
> log_checker_err: \"%s\"",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fil=
e, line_nr, buff);
> =A0

We lack a proper DEFAULT for log_checker_err.


> =A0=A0=A0=A0=A0=A0=A0=A0free(buff);
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> @@ -1534,7 +1562,8 @@ hw_vpd_vendor_handler(struct config *conf,
> vector strvec, const char *file,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto out;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0}
> -=A0=A0=A0=A0=A0=A0=A0hwe->vpd_vendor_id =3D 0;
> +=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, invalid value for vpd_vendo=
r:
> \"%s\"",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0file, line_nr, buff);
> =A0out:
> =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

