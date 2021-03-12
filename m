Return-Path: <SRS0=XTDI=IK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE51C433DB
	for <dm-devel@archiver.kernel.org>; Fri, 12 Mar 2021 16:21:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 96F0C65006
	for <dm-devel@archiver.kernel.org>; Fri, 12 Mar 2021 16:21:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 96F0C65006
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-FtX85VxUNEGo_f6KjyYm2Q-1; Fri, 12 Mar 2021 11:21:17 -0500
X-MC-Unique: FtX85VxUNEGo_f6KjyYm2Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85E25760CF;
	Fri, 12 Mar 2021 16:21:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 629C559475;
	Fri, 12 Mar 2021 16:21:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2D5B257DC6;
	Fri, 12 Mar 2021 16:21:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12CFrcY6018708 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 12 Mar 2021 10:53:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E02262026D65; Fri, 12 Mar 2021 15:53:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DA23E2026D60
	for <dm-devel@redhat.com>; Fri, 12 Mar 2021 15:53:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81ECD800B24
	for <dm-devel@redhat.com>; Fri, 12 Mar 2021 15:53:35 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-341-yhYuRRvAMPS65caYg4VjTA-1;
	Fri, 12 Mar 2021 10:53:33 -0500
X-MC-Unique: yhYuRRvAMPS65caYg4VjTA-1
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
	(mail-am6eur05lp2104.outbound.protection.outlook.com [104.47.18.104])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-20-0G-lEncIPfOG29yrxy4EXw-1; Fri, 12 Mar 2021 16:53:31 +0100
X-MC-Unique: 0G-lEncIPfOG29yrxy4EXw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBBPR04MB7802.eurprd04.prod.outlook.com (2603:10a6:10:1f0::20)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.26;
	Fri, 12 Mar 2021 15:53:30 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb%7]) with mapi id 15.20.3912.029;
	Fri, 12 Mar 2021 15:53:30 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH] kpartx: free loop device after listing partitions
Thread-Index: AQHXCnMMp2KKJ3bzH0GSZg6+D98KM6qAmsqA
Date: Fri, 12 Mar 2021 15:53:30 +0000
Message-ID: <4ad7249fac6055a3f0dfa2082a4bf6a98640c60c.camel@suse.com>
References: <1614146713-19694-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1614146713-19694-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cb7801e3-01bb-4501-d890-08d8e56efbca
x-ms-traffictypediagnostic: DBBPR04MB7802:
x-microsoft-antispam-prvs: <DBBPR04MB78020561913F447C0BD51F9EFC6F9@DBBPR04MB7802.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: YFdoNn3eZsJUP1DuNsKWSdi8uNksRdLJe4o/hxvgGgT6I0B1mptZ6TN6Zc+AW3hl/1PoKqrPwB2ORJWyjNzZi1Y9EFsrJ0PteaMawfrAliZFERxgLIiW7Xf4SElopommtmgiw4bbOUUzPxlKcSHKnHX0FBzISNmlp5zPZ7+e77jnJd/8WcpTG4ZHvnRJ2VXiXTSIcxAdxxaU1MXV7fNPMzbh8xcCBIQMVTxIXEkLfsNr9IqOUBo4V0eRU7H0er7jGn4S270xcx5mPMENjLDN20g/s0q+rQGsGB5VpmWrGS5UVUj/ScYxpXxqQujFdT0JH8RYOUfqqiv/jWKX9zWROFR1UjQtACFmvB+JLV8yCNWYEWpHr2SCAEfGPmBl+g3hDAjmoJMW5qX9fM/tms40dQiUyIwTBcBoSJixXYV1vGlQRFbhfkPZvFCiPNnVVNwDE5udlMNiTjTvQ9WrCxUgFLakywTz1aNQVYBUFpxStYnUYszeFWfRluysf/3J8Epip80ipJX+wmwZ0kUcifHbQg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(136003)(346002)(396003)(366004)(39860400002)(376002)(66446008)(76116006)(66556008)(66476007)(6486002)(2616005)(8936002)(66946007)(36756003)(478600001)(44832011)(4326008)(2906002)(6512007)(316002)(4744005)(110136005)(8676002)(186003)(26005)(64756008)(86362001)(91956017)(71200400001)(5660300002)(6506007);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?XPlV/OjT7Wwq5KvPK0NgdtWmmIE1P9QzWFHyNDXvySo0Vutvbuk5qAXYq?=
	=?iso-8859-15?Q?I4oIsG3PPvjBpxljx6Ex5ev1yrYOtg6rROk3wC0UxH11Bs/hJ0MOtSvCt?=
	=?iso-8859-15?Q?Is7Pz+Phpqw+xAQEGFaoKaD8SKNA0qrLr9VGvVSIjBbt15xoqAy76d2ED?=
	=?iso-8859-15?Q?Z0ksT0hjXp3sQrQiO+a+E/eKE+Mij0L6BZSGmIFa4HJSwc4PzPXK909wW?=
	=?iso-8859-15?Q?ep4bshyx76VuUo2a2f+89hMhMXSBHYav+skxUiRIDARvBPEquqHvcgv3a?=
	=?iso-8859-15?Q?rp44YeofsISE5ZUZFMy36ohGJrzq4g26VMVrOa4wztnplAFkVMQBErRw2?=
	=?iso-8859-15?Q?rvpbb7zAHMxUhn/YI26CwWTKCRdswcVoI1r3QIO3gA1eega5W7DOzQrfh?=
	=?iso-8859-15?Q?eeLsZa8DEyuWPTiDaKb5sb3w6rlNMCAbzoB0zzss/JMpuO3Dzzga0uZvn?=
	=?iso-8859-15?Q?gJ6xOrGgaiEZX6XjNnIrroF46GCYrjkmdz6zyC8esXHh5VnEh8Q+WeFHR?=
	=?iso-8859-15?Q?QifNHNFwaP5lPMutDu6s7QNI825P7woQ+B6kIhfRCkrp1t9Hv5jutzkOP?=
	=?iso-8859-15?Q?tciZD/ZFv/cVZHn6txVGkt0x/TtnjPUWeMLv4uZDu+83tph1ZFC1aHRXz?=
	=?iso-8859-15?Q?kpFZjdvADOTVZBEsMV4+Pa1Z0ey2xlJxei88hoYkN/qnsLgF7dNtmyPgb?=
	=?iso-8859-15?Q?TO5q7ASbrJ/gZhXpzwd7vFaw8Z1m/Oi3FahPOLyhf0/1+LYibr6b2+LNu?=
	=?iso-8859-15?Q?rWyCFr1/cDqKIX7oAxhYXyQRLGONtWxNfNfl8TWO5t35g6cLp8N/BUEmf?=
	=?iso-8859-15?Q?/nmwRXuQf3e3afThUgPFp7huqWQBowddVxL1T1FU1zPE7v8kpq3HdwIqp?=
	=?iso-8859-15?Q?FRuGxNgm2Opwm56h1NkgAC2+QBguqU/VSApfqZtrbJtY9JcIaostrFB3G?=
	=?iso-8859-15?Q?s1gz8b16oeK6tJFeL29GLMJ/UVgbHdBWdcS9JaxfPscNHBEhov4In7hMu?=
	=?iso-8859-15?Q?SyyHyQGdY/HzQ4hvmmZZaLrAuORe7MVQerpmlKYWxsvSpKkoudmk1bDAP?=
	=?iso-8859-15?Q?SuobwwG8f+0SnSnL0qvUHxpeU+0ERRHbYWpY8ookjYwIRgBRis2pFNlwl?=
	=?iso-8859-15?Q?eaXN09XrvsW7V+NULroZpn2/SAO8zuFw6Mofdlcin8k7PAoU8JVqCVXhR?=
	=?iso-8859-15?Q?0xTPb1ncXlEoFpNk6V2b6fxLbG13DeT4SmSVhZDNUGm4BoiGVm4bE549W?=
	=?iso-8859-15?Q?6Zns9cp/roVt57S/xmjGnmfWZxTZKl2uuqublbzRYwdHf1lxWz5TIGzpt?=
	=?iso-8859-15?Q?plE7dDwLik17gmjkAJyTu7NXAne6su+Kswf5Cb/B8h8DbnSkBEzLjYUhP?=
	=?iso-8859-15?Q?fDsuY9B3Ksx8JGh+aBJ9HlEb5qgcyQt2n?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb7801e3-01bb-4501-d890-08d8e56efbca
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2021 15:53:30.5443 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1yTXncvVPKaF+Fbz/ulzw9WaiYmqx9/84UXHaaqVDmahDkKfbD20CxRduRm845FRl58y8x5BEXiPyiEHUGiAqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7802
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12CFrcY6018708
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] kpartx: free loop device after listing
	partitions
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <5F1151C1762D704B96E7AAF57AC5F41E@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-02-24 at 00:05 -0600, Benjamin Marzinski wrote:
> If "kpartx -l" is run on a file that doesn't already have a loop
> device
> associated with it, it will create a loop device to run the command.
> Starting with da59d15c6 ("Fix loopback file with kpartx -av"), it
> will
> not free the loop device when exitting. This is because it checks if
> the
> the file it stat()ed is a regular file, before freeing the loop
> device.
> However, after da59d15c6, stat() is rerun on the loop device itself,
> so
> the check fails.=A0 There is no need to check this, if loopcreated is
> true, then the file will be a kpartx created loop device, and should
> be
> freed.
>=20
> Also, keep kpartx from printing that the loop device has been removed
> at normal verbosity.
>=20
> Fixes: da59d15c6 ("Fix loopback file with kpartx -av")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

