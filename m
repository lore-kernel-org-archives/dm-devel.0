Return-Path: <SRS0=g9U1=FU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C5A2C2BBCA
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 21:18:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DA04C2376E
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 21:18:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA04C2376E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-38tP3Ci7N5adbQf73b8YRw-1; Wed, 16 Dec 2020 16:18:18 -0500
X-MC-Unique: 38tP3Ci7N5adbQf73b8YRw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 367A0801817;
	Wed, 16 Dec 2020 21:18:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C6AA527CA6;
	Wed, 16 Dec 2020 21:18:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E0A5F180954D;
	Wed, 16 Dec 2020 21:18:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BGLIAE2006586 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Dec 2020 16:18:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EBC432026D48; Wed, 16 Dec 2020 21:18:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E548A2026D5D
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 21:18:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A463B185A794
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 21:18:07 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-407-FE1u_ptOMnGLO_quxZwDsg-1;
	Wed, 16 Dec 2020 16:18:05 -0500
X-MC-Unique: FE1u_ptOMnGLO_quxZwDsg-1
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur02lp2050.outbound.protection.outlook.com [104.47.5.50])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-8-Gv_ZXxgrNn6CO_OneQ0VEg-1; Wed, 16 Dec 2020 22:18:02 +0100
X-MC-Unique: Gv_ZXxgrNn6CO_OneQ0VEg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBAPR04MB7317.eurprd04.prod.outlook.com (2603:10a6:10:1b3::15)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13;
	Wed, 16 Dec 2020 21:18:01 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6]) by DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6%3]) with mapi id 15.20.3654.021;
	Wed, 16 Dec 2020 21:18:01 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 5/6] libmultipath: limit reading 0xc9 vpd page
Thread-Index: AQHWsndY9jwtkD4B7E+vNuKCUocwI6n6fO4A
Date: Wed, 16 Dec 2020 21:18:01 +0000
Message-ID: <8eab5c37addfd83366defd5c463d175ead90b7ec.camel@suse.com>
References: <1604472849-22422-1-git-send-email-bmarzins@redhat.com>
	<1604472849-22422-6-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1604472849-22422-6-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5
x-originating-ip: [2.203.204.191]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d65a527c-0931-4f9f-7fde-08d8a2081198
x-ms-traffictypediagnostic: DBAPR04MB7317:
x-microsoft-antispam-prvs: <DBAPR04MB73173BA6E0EE1345825E6104FCC50@DBAPR04MB7317.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: b1RueXiJVfiabafGHnkNB4Q/MJbssNMjzinexHbfvKenaLCHuFWQKGZxk1j5CqJ03QA+H6MNesyQfSzlCWqhUIUIhaPVkO1GMCvNzI4u/+VuMGGYF4Z+rhjMBeV++nX6QJJE66/1TuNGdnw9W5Aa4kk8xvd+4eXJaSeCrmbM/vaoiv/J4xbANyDD4OQkaLMITJFrsGQ4wb3D8+pAYM+cUC+ypdqqCihut1jbmOHIIFDm0OQSagU266DFwMbbgH0gcULMA2A95phwphcKbfCwWTknbFTbkdoiLrbkcqFaK9BzMe1TBAjqeQgi3qRRi5RB9ZDxMywGeF/Qvr3mi9+jIQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(39860400002)(366004)(136003)(376002)(396003)(346002)(86362001)(91956017)(76116006)(6506007)(6512007)(44832011)(2906002)(66574015)(8936002)(186003)(5660300002)(8676002)(26005)(66946007)(478600001)(2616005)(316002)(6486002)(83380400001)(64756008)(4326008)(54906003)(36756003)(66556008)(110136005)(66476007)(66446008)(71200400001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?go1xgA5oZiCpoq3Gu65heUA5Cd1i3MnmoHwLYLOFZpXO9BCN+vDXUKgnA?=
	=?iso-8859-15?Q?SyqXu+vM/clRKCO2eDV6S4Y/KgW3M6SgzvtoSu4G9/kmcTsZQAmaVWpXI?=
	=?iso-8859-15?Q?OezWkUaIOGhLY+nolZdTnjKHhrkVBRXcpMLXKpujCbVbVECh/uhy5ihKH?=
	=?iso-8859-15?Q?WulzrOwmY3OcGHxfb5bUckP2uFF27xZBPPB6UvQyXy25Jasjtmxx36lCR?=
	=?iso-8859-15?Q?lJPDwNaj6Maxm0H+lLqv4B7/X1q5hg6b8XXnqm+yluVMtrZa2Svg9ux2G?=
	=?iso-8859-15?Q?J8ZFOEI2koHgm14HzQ+6og0WAeC6n5bLErRMfcfwSRXW5rHd0E04uOZiq?=
	=?iso-8859-15?Q?fbzlby4fOJNp04fAX1ZozqoFzG0bwIuqB31l+lbLV0TTL/TRpUoifAjSB?=
	=?iso-8859-15?Q?XvwOsLI3NAnUs9R+j8lfsxmStEiylfrTPxXYdhmpcjLIukXCOqLq87+Az?=
	=?iso-8859-15?Q?y1UIAakKb67S2TUi5FSSPyY9GKG0CqnCb877DbNDenx/N0k8zGskZ7Hcg?=
	=?iso-8859-15?Q?d3uBBQmySeqofUp5RdXPfykIOl84HYFvpsUoidjBS0utyLyBfIKIKHLx/?=
	=?iso-8859-15?Q?Cr5eA9pYlVq5krACKT43BepDZd1Gp/hweLSyHl054mUgPN2qI1f4E33v3?=
	=?iso-8859-15?Q?sP2DmtiPCNu/sSovr+/xnbwKc8koiaYVn/j6dpwsxXQjT5gkqu4UmYDVa?=
	=?iso-8859-15?Q?YRx6/FynS0eP4QksQtkX33WPjhAAX1J4CVVQhAf5y1lq2Sn0vyptP/JGm?=
	=?iso-8859-15?Q?9OiyNte8KZJ6DiWtIAg1EdxLHYrR9mN5d8C/22aNeynS38g0ODsCenYHC?=
	=?iso-8859-15?Q?XYII11REdIsKtylLTDET/kQqel6I2k35J1s859SYIVP9CeuT120E60TG8?=
	=?iso-8859-15?Q?eHj9uQVEOExMYXwKRepYcs4HrXjHmzPnNteBGOltpVxRRvUAK+s/YY33n?=
	=?iso-8859-15?Q?9Cg5omwKAkAXFzsl2zK+kGze91F45XncqPxjs+ltH9BNaicHA/YhHNbhA?=
	=?iso-8859-15?Q?XOUSUTFbtOdCB+bwRuwXyyubW3Ae7bgsUtgvYQF3tsVY4rnIGeR2sEh?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d65a527c-0931-4f9f-7fde-08d8a2081198
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2020 21:18:01.0410 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W751Bxpq+0ZngAScvvId4fERyASJPNQe/o0SKvWfj4furGZ9RDy4LpHkRvCvvwnu7eMPHwS9eksxNgm9c/ATEA==
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BGLIAE2006586
X-loop: dm-devel@redhat.com
Cc: "ng-eseries-upstream-maintainers@netapp.com"
	<ng-eseries-upstream-maintainers@netapp.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"sschremm@netapp.com" <sschremm@netapp.com>
Subject: Re: [dm-devel] [PATCH v2 5/6] libmultipath: limit reading 0xc9 vpd
	page
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
Content-ID: <2E1264A7C93CC9489A0A78B808530C3E@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2020-11-04 at 00:54 -0600, Benjamin Marzinski wrote:
> Only rdac arrays support 0xC9 vpd page inquiries. All other arrays
> will
> return a failure. Only do the rdac inquiry when detecting array
> capabilities if the array's path checker is explicitly set to rdac,
> or
> the path checker is not set, and the array reports that it supports
> vpd
> page 0xC9 in the Supported VPD Pages (0x00) vpd page.
>=20
> Multipath was doing the check if either the path checker was set to
> rdac, or no path checker was set.  This means that for almost all
> non-rdac arrays, multipath was issuing a bad inquiry. This was
> annoying
> users.
>=20
> Cc: Steve Schremmer <sschremm@netapp.com>
> Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/discovery.c | 25 +++++++++++++++++++++++++
>  libmultipath/discovery.h |  1 +
>  libmultipath/propsel.c   | 10 ++++++----
>  3 files changed, 32 insertions(+), 4 deletions(-)
>=20
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 95ddbbbd..5669690d 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -1346,6 +1346,31 @@ fetch_vpd_page(int fd, int pg, unsigned char
> *buff)
>  =09return buff_len;
>  }
> =20
> +/* heavily based on sg_inq.c from sg3_utils */
> +bool
> +is_vpd_page_supported(int fd, int pg)
> +{
> +=09int i, len, buff_len;
> +=09unsigned char buff[4096];
> +
> +=09buff_len =3D fetch_vpd_page(fd, 0x00, buff);
> +=09if (buff_len < 0)
> +=09=09return false;
> +=09if (buff_len < 4) {
> +=09=09condlog(3, "VPD page 00h too short");
> +=09=09return false;
> +=09}
> +
> +=09len =3D buff[3] + 4;

SPC-4 says that the page length is a 16-bit value.
You may also want to check buff[1] =3D=3D 0.

> +=09if (len > buff_len)
> +=09=09condlog(3, "vpd page 00h trucated, expected %d, have
> %d",
> +=09=09=09len, buff_len);
> +=09for (i =3D 4; i < len; ++i)
> +=09=09if (buff[i] =3D=3D pg)
> +=09=09=09return true;
> +=09return false;
> +}
> +
>  int
>  get_vpd_sgio (int fd, int pg, int vend_id, char * str, int maxlen)
>  {
> diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
> index 6444887d..d3193daf 100644
> --- a/libmultipath/discovery.h
> +++ b/libmultipath/discovery.h
> @@ -56,6 +56,7 @@ int sysfs_get_asymmetric_access_state(struct path
> *pp,
>  =09=09=09=09      char *buff, int buflen);
>  int get_uid(struct path * pp, int path_state, struct udev_device
> *udev,
>  =09    int allow_fallback);
> +bool is_vpd_page_supported(int fd, int pg);
> =20
>  /*
>   * discovery bitmask
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index fa4ac5d9..f771a830 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -496,13 +496,15 @@ check_rdac(struct path * pp)
>  {
>  =09int len;
>  =09char buff[44];
> -=09const char *checker_name;
> +=09const char *checker_name =3D NULL;
> =20
>  =09if (pp->bus !=3D SYSFS_BUS_SCSI)
>  =09=09return 0;
> -=09/* Avoid ioctl if this is likely not an RDAC array */
> -=09if (__do_set_from_hwe(checker_name, pp, checker_name) &&
> -=09    strcmp(checker_name, RDAC))
> +=09/* Avoid checking 0xc9 if this is likely not an RDAC array */
> +=09if (!__do_set_from_hwe(checker_name, pp, checker_name) &&
> +=09    !is_vpd_page_supported(pp->fd, 0xC9))
> +=09=09return 0;
> +=09if (checker_name && strcmp(checker_name, RDAC))

Do we still need the name check after testing whether 0xc9 is
supported? Well I guess it doesn't harm.

Regards
Martin

>  =09=09return 0;
>  =09len =3D get_vpd_sgio(pp->fd, 0xC9, 0, buff, 44);
>  =09if (len <=3D 0)

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

