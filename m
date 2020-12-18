Return-Path: <SRS0=A8Ao=FW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0732BC4361B
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 23:57:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6E9E523A7B
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 23:57:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E9E523A7B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-nQUxP9qtOBe9zj9LZO13qg-1; Fri, 18 Dec 2020 18:57:04 -0500
X-MC-Unique: nQUxP9qtOBe9zj9LZO13qg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24F52107ACE3;
	Fri, 18 Dec 2020 23:57:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C8B4D299B4;
	Fri, 18 Dec 2020 23:56:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 14E254BB7B;
	Fri, 18 Dec 2020 23:56:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BINuuCl032473 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 18 Dec 2020 18:56:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F3B9F10439AC; Fri, 18 Dec 2020 23:56:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EF1EC10DCF5F
	for <dm-devel@redhat.com>; Fri, 18 Dec 2020 23:56:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 811C1185A794
	for <dm-devel@redhat.com>; Fri, 18 Dec 2020 23:56:53 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-314-cCH45j_lOH2kCm1oVahuNQ-1;
	Fri, 18 Dec 2020 18:56:51 -0500
X-MC-Unique: cCH45j_lOH2kCm1oVahuNQ-1
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur05lp2170.outbound.protection.outlook.com [104.47.17.170])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-19-phcPgc7HPwyQCGA6ZOh5Zw-1; Sat, 19 Dec 2020 00:56:48 +0100
X-MC-Unique: phcPgc7HPwyQCGA6ZOh5Zw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBBPR04MB6268.eurprd04.prod.outlook.com (2603:10a6:10:cc::18) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25;
	Fri, 18 Dec 2020 23:56:47 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6]) by DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6%3]) with mapi id 15.20.3654.021;
	Fri, 18 Dec 2020 23:56:47 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 6/6] multipath.conf.5: Improve checker_timeout description
Thread-Index: AQHW1ZKB6X4Ojcg7Y0KOu2ExvyDMOKn9h70A
Date: Fri, 18 Dec 2020 23:56:47 +0000
Message-ID: <28b07148b5249f05e6509d5a34ed145a23975be4.camel@suse.com>
References: <1608332802-9720-1-git-send-email-bmarzins@redhat.com>
	<1608332802-9720-7-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1608332802-9720-7-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5
x-originating-ip: [2.203.204.191]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f13b1293-b1c5-4a12-c245-08d8a3b0945d
x-ms-traffictypediagnostic: DBBPR04MB6268:
x-microsoft-antispam-prvs: <DBBPR04MB6268BEC3E79D18A5FD91E823FCC30@DBBPR04MB6268.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: va89ZMNBoTYCRVQ4DCC/PuyqxlX27gRB1HSznlJz+0AxntiNSeVLSotK26bid00SLjzuN+hO10NyBy9VtJtq56mnUjLKgx1uPSH1c99u3Jz3ACWTymjwokkCp3DflnIl462WZuKIilHnma6YrqSn3hnppv2GqQhnxw+DGSrFtLUhfp9/uLb3/WJVfLX5dNdpE1d1y75iDpTcMJ6s6wcbiCwm2ltp+SdNEbYgBbG9Xw5GHdUOHj76C1/W5OqDvR7ED8+bmqsL+z19Q4VlUhSHvc8bwdcMylihIOtsV4XHHP+90uGa8f+wiOGtOTGatlHE1wbcB4GTndW7abm7Ptx9ElCfN30cOJMjURn41H3LOOru3NwJfn0XQ9GjyBqSAe9zmkl3Rvl6n8ZjqWQd4Q4EWA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(376002)(39860400002)(396003)(136003)(366004)(346002)(5660300002)(8676002)(66946007)(4326008)(110136005)(66574015)(91956017)(76116006)(26005)(6506007)(71200400001)(64756008)(4001150100001)(8936002)(2906002)(66556008)(66446008)(478600001)(6486002)(2616005)(6512007)(86362001)(44832011)(186003)(316002)(66476007)(83380400001)(36756003);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?ZodCxrnAZxYgJR7fdY8kjZwUAp6cX0EzHiDoqO81SCQLj/GVkEDAW3cvi?=
	=?iso-8859-15?Q?N/oICNbaFSHmn4Bmu441hzZZZ1diKIoAGonRsr2FBIu6hc6ryFCV5JubY?=
	=?iso-8859-15?Q?atCTU+e0np1KAVOHeOH1ilJpT4zv0BI3GJAICW+1MYcBtJuOwEaWS8tpJ?=
	=?iso-8859-15?Q?7bMa0edsK1oCuGPTgt+QR6B4KEsPU2088gSqsj1dRp+qA4oeRw1bX4GN8?=
	=?iso-8859-15?Q?QrO+wv+t9Lw26uPnJ0991agQZ8CabOrUkcln9dkfjs/fL8xC9qgMX8ZK5?=
	=?iso-8859-15?Q?PJ9TjcEBR6E9WobAhfLnocTMQLAGUCPKbOcBvEdoC0Tgpz17Ed3nZJKZb?=
	=?iso-8859-15?Q?+nlIQUwiQVXsoO5O+gEwcYF6nRWr6DYFkigDOlKgiHqTZzaNCIQATk4t0?=
	=?iso-8859-15?Q?vv8sHcfwPHTsnny9kdXS/EvzaPBvmUZ6ALpBzZAkX4i1/Z1QU3w3I4gdt?=
	=?iso-8859-15?Q?ii/yvhEMb12tdAvLgSQM25X/18qgkg8swAEAtptCDcELGIgx5+6ggIqK3?=
	=?iso-8859-15?Q?GWOf3jfSrz22fmBZSBwftuSeuYcCouSbOAWiq53cLQ24Pl5CBs/dCTLfO?=
	=?iso-8859-15?Q?5NxHwwZXA5CzimQc5WUv+ABD68D/lWGZzV/Kzg5mLwzWnbrs6/eLxwfym?=
	=?iso-8859-15?Q?pFWJ9IqkFO8zFef5qSw96ANzTWdyWDzFwhRGjZm+YS0j0aK+7GC1nNxpS?=
	=?iso-8859-15?Q?Kr+A707lWxEhouv9a9f/kh/MQyasykqU2/33w2Hd9e0egUYLBV/DAUupV?=
	=?iso-8859-15?Q?Z9LJyt5MudiHADC0Dyest5PDC4AYHJx2L8IhA9qIA7ypeSz+yLtTwhV5C?=
	=?iso-8859-15?Q?2AOQ6ap7E2ZnnVOkbW8AFWD2r0ni+nivqyOL0TkbHOPMH+QMKx0sWxTBa?=
	=?iso-8859-15?Q?w2RwU7EDrBj+od7o9oUylqOHZlSJmwXlhWUfpYfTbYAgY4QWoWXF3fs7l?=
	=?iso-8859-15?Q?guElc0cou4CAHw6DDUUe59ag5Ls0ba64oJunuvegFnAoNq8IFC98+Y6eE?=
	=?iso-8859-15?Q?n2VFEk7AUOGFgo52aPgj23noQrShyd7UEYzM/gMPKdIxm7re8TzeWC6?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f13b1293-b1c5-4a12-c245-08d8a3b0945d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2020 23:56:47.0330 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0CLvpNgbPvoOAUi5Jwh5tufl/AnbJa1C/uYgq0N0OC5SSrwd5zQScEMaOCXi+BId+ch2FBiuN9SSnytWOlhH4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6268
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BINuuCl032473
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 6/6] multipath.conf.5: Improve
	checker_timeout description
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
Content-ID: <B1010C58E624464DBA7C998208986441@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2020-12-18 at 17:06 -0600, Benjamin Marzinski wrote:
> I was asked to explain how checker_timeout works for checkers like
> directio, that don't issue scsi commands with an explicit timeout
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipath/multipath.conf.5 | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index ea66a01e..c7c4184b 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -639,8 +639,13 @@ The default is: \fBno\fR
>  .
>  .TP
>  .B checker_timeout
> -Specify the timeout to use for path checkers and prioritizers that
> issue SCSI
> -commands with an explicit timeout, in seconds.
> +Specify the timeout to use for path checkers and prioritizers, in
> seconds.
> +Only prioritizers that issue scsi commands use checker_timeout.=20
> Checkers
> +that support an asynchronous mode (\fItur\fR and \fIdirectio\fR),
> will
> +return shortly after being called by multipathd, regardless of
> whether the
> +storage array responds. If the storage array hasn't responded,
> mulitpathd will

typo

> +check for a response every second, until \fIchecker_timeout\fR
> seconds have
> +elapsed.

This is a bit confusing IMHO. Most importantly, checkers will consider
a path down if it doesn't respond to the checker command after the
given timeout. The async behavior doesn't fit too well into this
section. Maybe we should mention and explain the async property in the
path_checkers section, and only refer to that here.

(Btw is the directio checker still deprecated after all the work you
recently put into it? The man page still says so).

Regards,
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

