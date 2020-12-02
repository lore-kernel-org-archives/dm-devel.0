Return-Path: <SRS0=/aYG=FG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0A6AC64E7C
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 13:55:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 08D0D21D46
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 13:55:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08D0D21D46
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-3hUptoUzPkmshrEhtoN_FQ-1; Wed, 02 Dec 2020 08:55:20 -0500
X-MC-Unique: 3hUptoUzPkmshrEhtoN_FQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF2B41012E95;
	Wed,  2 Dec 2020 13:55:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 745A5100AE32;
	Wed,  2 Dec 2020 13:55:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E14084E58E;
	Wed,  2 Dec 2020 13:55:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B2Dt9Mg015723 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Dec 2020 08:55:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1E333100416C; Wed,  2 Dec 2020 13:55:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1848610FFE72
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 13:55:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A88B811E76
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 13:55:04 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-342-DApZJGOXO6emeONJpqxmvg-1;
	Wed, 02 Dec 2020 08:55:02 -0500
X-MC-Unique: DApZJGOXO6emeONJpqxmvg-1
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur04lp2054.outbound.protection.outlook.com [104.47.14.54])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-6-KC5ZR2qyO0eiuL2Fpahu3g-1; Wed, 02 Dec 2020 14:54:59 +0100
X-MC-Unique: KC5ZR2qyO0eiuL2Fpahu3g-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB6PR0402MB2742.eurprd04.prod.outlook.com (2603:10a6:4:96::10)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25;
	Wed, 2 Dec 2020 13:54:57 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6]) by DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6%3]) with mapi id 15.20.3611.025;
	Wed, 2 Dec 2020 13:54:57 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 1/5] multipath: fix issues found by compiling with gcc
	10
Thread-Index: AQHWNsg0Air+gJM54kWvOB9jPoWGsKnk994A
Date: Wed, 2 Dec 2020 13:54:57 +0000
Message-ID: <6d9b937e46499c5d35921d2eb62943c987b46425.camel@suse.com>
References: <1582143705-20886-1-git-send-email-bmarzins@redhat.com>
	<1582143705-20886-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1582143705-20886-2-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5
x-originating-ip: [2.202.118.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e87f966-baab-44f9-cba2-08d896c9dad9
x-ms-traffictypediagnostic: DB6PR0402MB2742:
x-microsoft-antispam-prvs: <DB6PR0402MB2742C9D5F1BEB1AB04A47293FCF30@DB6PR0402MB2742.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Yw6sKHjUlFW81+hmiojq+s3/Q452urbs7JfA4tQwwNhlSVY2r9uzPa3yL9xRRnwSD1jPijswiXQFdH54wjjOFYrQ7IkWXxEsb2g4zfHNQNBh3MGvIKCMZk4jL8pvVCPLkL5Sbfl6ngK/Fww+Zjx+BGVWDLUZyNntjPbFfa6gtJic8Ikk96rrJIPnA2DmyUVGB+nlCr4RvZ+ylVcxW1tth4LXX2TeiHmaoql/nyn70ND6FX/ezWj/gtrXGZdK+DvebrY3d3ByEqxGqgL0ScOCgDhKX+EJUmeFJehZ8q5oKr7Ak9OYSpcjjFCdNcTWmz3CFKZCVkOEK1FTyozU2lYa6w==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(376002)(346002)(396003)(136003)(39860400002)(36756003)(71200400001)(316002)(44832011)(2616005)(66574015)(478600001)(83380400001)(6512007)(6506007)(186003)(26005)(8676002)(8936002)(91956017)(6486002)(64756008)(66556008)(66446008)(2906002)(66476007)(5660300002)(110136005)(66946007)(76116006)(86362001)(4326008);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?Pxq7jQwK1L039vcbTiNBS8RMMm7WAWHxPWJpZVAQpteE03Grmvwha+8uR?=
	=?iso-8859-15?Q?ytZGdUAIqHYqpzq1SeB+9oANVxE5FERCkdcN0m1zo23JkuR3jysMl4ydS?=
	=?iso-8859-15?Q?625ZNtNG2uzvxOQDM5KOd2I6mg18CJcraTZBTKrCPoKaRe13iuXiOc44n?=
	=?iso-8859-15?Q?eQY1bv7vOS4QkrLWOVF4BlIeler6Khii9xkXaPHoKMEhc0lZ4AAaQ9ykG?=
	=?iso-8859-15?Q?J020gAJTJId1jrQC4+S5iUPKxb0u8rxsXuBSF4VG5tWbgHtQt6um2WpeI?=
	=?iso-8859-15?Q?WVxiQpCfyxCDdIrpQp22aBTNCRGfFrHrFTj8DbNGH0dcHIu+LrrcpYN8g?=
	=?iso-8859-15?Q?Xa2nKU8NjpeCtlHJQMNHY/qthoj0w5KdrF1ZUhAWfWuBt8I1rUQyOsLJ9?=
	=?iso-8859-15?Q?0K1AVgYzbU2UWlaUBV8cDvgCxuMjguA415G3fGCyj8qucrGR+pIvmDPE1?=
	=?iso-8859-15?Q?rEnALI5udhQSgChaKSmRbd3A8sOr4tl5mG3+IlMrFF/qEdImv+jVrIUgH?=
	=?iso-8859-15?Q?1doPPad5kv5I7DuZZ/pkGnKPLrgfAzhEKBm7vP8D3ceaPHWEUVBosRa8l?=
	=?iso-8859-15?Q?7KGd3/ut5Ft9QY2V57tZ/18V6S8XzsZNXr3KUZ4CmMvHvf4XNiIdlsPLb?=
	=?iso-8859-15?Q?cwBDD3UlYEzEtgOO9HOf7YKzJi6Q0SeOquY7uEzpFwFDx98jn6JHxiuK6?=
	=?iso-8859-15?Q?L2rVHQZzmfT7qz2R2p9fJz5D0e8ZzbAOh+rtVwC6K9l3JS5wm53etw5uy?=
	=?iso-8859-15?Q?JRPXzWrBg/RcjA+ayOaE0fIqHdlYylkgSuGdXzxkRyFMeDMmckoaUhMoM?=
	=?iso-8859-15?Q?hux1ervNH/vDERoNAs+KqCqHHeTh9gll0FD75hkKYrxaGqIyEE0xGFFvl?=
	=?iso-8859-15?Q?uOGBbBWmNUxk31qnOPKydzNOK8W04h5wUuCmN31ytDHQZcDhvjLZQfHfP?=
	=?iso-8859-15?Q?VLeomB9RAiRtgqVHVmWvtkL/oqa1CySPCO/PFkpkR5aFh+pJ52vpQFpoS?=
	=?iso-8859-15?Q?TQ6rOXei63ENRLfU/812jPUsqbVlkOUjjubw+OZ07oof/Va228C4pWj?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e87f966-baab-44f9-cba2-08d896c9dad9
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2020 13:54:57.6305 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +jYQnIUktGykdYwRhVX4ihSok2o95MSFDHikxjYtRbR1RhCBqzcwOYlQey55Z6auuOmsQWP70e9i9HNHjLYApQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2742
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0B2Dt9Mg015723
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 1/5] multipath: fix issues found by
 compiling with gcc 10
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <39737506C85BAB429D5C1FEEEA877D86@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi Ben,

On Wed, 2020-02-19 at 14:21 -0600, Benjamin Marzinski wrote:
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  kpartx/dasd.c        |  6 +++---
>  libmultipath/print.c | 16 ++++++++--------
>  multipath/main.c     |  2 +-
>  3 files changed, 12 insertions(+), 12 deletions(-)
>=20
> diff --git a/kpartx/dasd.c b/kpartx/dasd.c
> index 1486ccaa..14b9d3aa 100644
> --- a/kpartx/dasd.c
> +++ b/kpartx/dasd.c
> @@ -186,7 +186,7 @@ read_dasd_pt(int fd, __attribute__((unused))
> struct slice all,
>  =09=09goto out;
>  =09}
> =20
> -=09if ((!info.FBA_layout) && (!strcmp(info.type, "ECKD")))
> +=09if ((!info.FBA_layout) && (!memcmp(info.type, "ECKD", 4)))
>  =09=09memcpy (&vlabel, data, sizeof(vlabel));
>  =09else {
>  =09=09bzero(&vlabel,4);

are you using different compiler / warning flags here than we usually do?

I just found that with the standard flags, gcc 10 does *not* complain about
the old (badly broken, noting that info.type is declared as char[4]) code.
Nor has any other compiler so far, although we're using pretty verbose=20
warning options.

Regards
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

