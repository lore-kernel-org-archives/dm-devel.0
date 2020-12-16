Return-Path: <SRS0=g9U1=FU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EEF2C4361B
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 21:14:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E1FB7233E2
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 21:14:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E1FB7233E2
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-GaAviS37MWyJfBsZZ6O1AQ-1; Wed, 16 Dec 2020 16:14:05 -0500
X-MC-Unique: GaAviS37MWyJfBsZZ6O1AQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB248190D340;
	Wed, 16 Dec 2020 21:14:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4424E27C3D;
	Wed, 16 Dec 2020 21:14:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9514050032;
	Wed, 16 Dec 2020 21:13:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BGLDwtA006133 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Dec 2020 16:13:58 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 65C352026D48; Wed, 16 Dec 2020 21:13:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F32D2026D5D
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 21:13:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3DD6C8007DF
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 21:13:56 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-259-MjE9RmGmOrmPigVByKXicw-1;
	Wed, 16 Dec 2020 16:13:54 -0500
X-MC-Unique: MjE9RmGmOrmPigVByKXicw-1
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur02lp2058.outbound.protection.outlook.com [104.47.5.58])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-23-GtuT6UdUMyiw_sJl2uZR8g-1; Wed, 16 Dec 2020 22:13:51 +0100
X-MC-Unique: GtuT6UdUMyiw_sJl2uZR8g-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBAPR04MB7317.eurprd04.prod.outlook.com (2603:10a6:10:1b3::15)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13;
	Wed, 16 Dec 2020 21:13:49 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6]) by DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6%3]) with mapi id 15.20.3654.021;
	Wed, 16 Dec 2020 21:13:49 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 4/6] libmultipath: factor out code to get vpd page data
Thread-Index: AQHWsndW+o3a3DVRK0OD3HxtTx81sKn6e8EA
Date: Wed, 16 Dec 2020 21:13:49 +0000
Message-ID: <73dd01fbb1141e0da4686d7ccb43110f14d56fc1.camel@suse.com>
References: <1604472849-22422-1-git-send-email-bmarzins@redhat.com>
	<1604472849-22422-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1604472849-22422-5-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5
x-originating-ip: [2.203.204.191]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a619ac5-c2d2-4569-dd42-08d8a2077ba0
x-ms-traffictypediagnostic: DBAPR04MB7317:
x-microsoft-antispam-prvs: <DBAPR04MB7317CDB1BCFAAC69E63FCDCCFCC50@DBAPR04MB7317.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: QrK10SC3qfyROFLyTs9zgoW4ZD5w/z7nslUJOqdm7LNibpQAZnBf4eXFciH3F71qVXFPVigGx9QCr77F78HO2lLBaS4AIGcAUhBwlJ3JD4xsxA8RHyx1tsTE+SGM30ch2MSJvGRC6VcS8Ehz1vARVB8PZo4/TzDOAWNYBpJJOTiQIniQqyWM/xydpa9uh7Mpf2sfZH1h7Up4uh2vvAI6WUVTMukh78Bv6IanVFsTIrrswCUTsZqw3DlSZVFE0Ymm47iw4S3B77b3ejxVOSgStw95AVZZqZBhuPG3XMtaewN0aF2pQVMW80DLF4r7Trbs4pcGUSfBF9NBl1hZXabkQg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(39860400002)(366004)(136003)(376002)(396003)(346002)(86362001)(91956017)(76116006)(6506007)(6512007)(44832011)(2906002)(8936002)(186003)(5660300002)(8676002)(26005)(66946007)(478600001)(2616005)(316002)(6486002)(83380400001)(64756008)(4326008)(36756003)(66556008)(110136005)(66476007)(66446008)(71200400001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?E2JXtP9TBtFConzhOo1UiD4Or4yflgA6AWpLBOGb2+f1mZABG8031JOYL?=
	=?iso-8859-15?Q?oiC44PFx7Vx6ymsewLTfBUqpUyu27PHqVptNfub1vSBQUEC7SVR+vIffC?=
	=?iso-8859-15?Q?m1qP2un6QOnUEi/1ua9KXeV3Af3pcw8ZMano38fd9EaHm+KtGwvsSqtQr?=
	=?iso-8859-15?Q?C9H4sCMLoTnHTChqj08q5f16RTTnsEeAg6q3TYkULabQU6jkyZjgxyAgp?=
	=?iso-8859-15?Q?FbWNkwqll3iiangik3kt5Tdk5zsTT7b6ybMIGUer8fGvfwC5o10DDtq07?=
	=?iso-8859-15?Q?Jk1fI2RFuPBdvAlYZcuh5lhNY06IFELs8pAVRfOUPUnrHVppf3m1Qlmp+?=
	=?iso-8859-15?Q?5v7sGNG6chmUNEJN53hzGjIc4uV6ZU2jwUiYnB62+telr59cwM4j8wAgL?=
	=?iso-8859-15?Q?SMG9vBGyi/JuNJ7UBgjyXDrtuojeVvaLLP+4+8c1caukhKdWCKEYDxHH7?=
	=?iso-8859-15?Q?i5AXvOXF7JMdUpqKKDh6x4JalqPwStq0SMwQsP/m1pJmzXQVw5rZlQdQH?=
	=?iso-8859-15?Q?niqNugyEh5dCuP0IBgkICKpaJ361PEf5xjooSxL3aiFhllCxC9WN3GADB?=
	=?iso-8859-15?Q?Bi9dnoJKp62J6l8z7oAZZw2WqIgdU0n2bqFYE8OIHA63WszC1CFYbvVvt?=
	=?iso-8859-15?Q?Q818AoKZAlINqLN7HefSdhfMMAcSIzir2LsvIxmaUd/kRqomIQRNPHhG8?=
	=?iso-8859-15?Q?2F2rbWfvgjrY5fD4VA4c/rlBRDJPSaf/qHRrc7e/U/xa5EOK827KTixGf?=
	=?iso-8859-15?Q?GorAal24pjdMy6neQnmxE2HHbfYdTG3Ws4J0+Wco85sPHV5jYQSK4OJ22?=
	=?iso-8859-15?Q?4WkLccbczrj2pYyXPoY56efLenYAT7TzTlfQCL1VtETE9m9/SqyN7/e4/?=
	=?iso-8859-15?Q?/C2TLsXlePtCiJbig5+95bjcPM5EOYfpNejjHhbbtjzhrT4If9HIx7g8I?=
	=?iso-8859-15?Q?dXWdcKfpjsgM001ikl6rv5dBW9wJq7gqo4gLmCZQC7ARALcuI/O13Rgvo?=
	=?iso-8859-15?Q?GVecsOB7HAegbnJ5DpPfTkVaJJWU6/xekalry50EbUgnlwZrP3nHUnn?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a619ac5-c2d2-4569-dd42-08d8a2077ba0
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2020 21:13:49.4026 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 620P7p0sGda9XR4d4ox8+L6ZulSAAjQ8AO26vLSRhE3dKs8BBL/7n+I/dEU+0q9RPF3hGjLb/8CPtcpvoICzXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7317
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BGLDwtA006133
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 4/6] libmultipath: factor out code to get
	vpd page data
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <91A82D5D957F8448B95E52EEABBEBDA0@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2020-11-04 at 00:54 -0600, Benjamin Marzinski wrote:
> A future patch will reuse the code to get the vpd page data, so
> factor
> it out from get_vpd_sgio().
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/discovery.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
>=20
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index a97d2998..95ddbbbd 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -1319,11 +1319,10 @@ get_vpd_sysfs (struct udev_device *parent,
> int pg, char * str, int maxlen)
>  =09return len;
>  }
> =20
> -int
> -get_vpd_sgio (int fd, int pg, int vend_id, char * str, int maxlen)
> +static int
> +fetch_vpd_page(int fd, int pg, unsigned char *buff)
>  {
> -=09int len, buff_len;
> -=09unsigned char buff[4096];
> +=09int buff_len;
> =20
>  =09memset(buff, 0x0, 4096);

I don't know ... I think we shouldn't write any new functions making
assumptions about the size of buffers passed to them, even if the
caller is directly next to them in the code.

>  =09if (sgio_get_vpd(buff, 4096, fd, pg) < 0) {
> @@ -1344,6 +1343,18 @@ get_vpd_sgio (int fd, int pg, int vend_id,
> char * str, int maxlen)
>  =09=09condlog(3, "vpd pg%02x page truncated", pg);
>  =09=09buff_len =3D 4096;
>  =09}
> +=09return buff_len;
> +}
> +
> +int
> +get_vpd_sgio (int fd, int pg, int vend_id, char * str, int maxlen)
> +{
> +=09int len, buff_len;
> +=09unsigned char buff[4096];
> +
> +=09buff_len =3D fetch_vpd_page(fd, pg, buff);
> +=09if (buff_len < 0)
> +=09=09return buff_len;
>  =09if (pg =3D=3D 0x80)
>  =09=09len =3D parse_vpd_pg80(buff, str, maxlen);
>  =09else if (pg =3D=3D 0x83)

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

