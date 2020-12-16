Return-Path: <SRS0=g9U1=FU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C770C4361B
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 21:07:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D67A222582
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 21:07:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D67A222582
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-8CHOkYm7OcetET6_-SEYKQ-1; Wed, 16 Dec 2020 16:07:38 -0500
X-MC-Unique: 8CHOkYm7OcetET6_-SEYKQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1CA56801817;
	Wed, 16 Dec 2020 21:07:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 63D9460BF3;
	Wed, 16 Dec 2020 21:07:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CD100180954D;
	Wed, 16 Dec 2020 21:07:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BGL7TrH004337 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Dec 2020 16:07:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 69C2310FFE54; Wed, 16 Dec 2020 21:07:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 627FA101A802
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 21:07:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F224186E125
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 21:07:27 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-23-IpuZiNvjOSexyUCwMqHTPA-1;
	Wed, 16 Dec 2020 16:07:22 -0500
X-MC-Unique: IpuZiNvjOSexyUCwMqHTPA-1
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
	(mail-db3eur04lp2057.outbound.protection.outlook.com [104.47.12.57])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-36-Ws7kUTYmPYy6pONxKZyJyw-1; Wed, 16 Dec 2020 22:07:19 +0100
X-MC-Unique: Ws7kUTYmPYy6pONxKZyJyw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB3PR0402MB3642.eurprd04.prod.outlook.com (2603:10a6:8:2::24) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13;
	Wed, 16 Dec 2020 21:07:17 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6]) by DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6%3]) with mapi id 15.20.3654.021;
	Wed, 16 Dec 2020 21:07:17 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 2/6] libmultipath: add eh_deadline multipath.conf
	parameter
Thread-Index: AQHWsndX4FgSw8VaCUeqq0OCYoepbKn6ee4A
Date: Wed, 16 Dec 2020 21:07:17 +0000
Message-ID: <e4617094ac7a898338a00b9fe990c3681270ed90.camel@suse.com>
References: <1604472849-22422-1-git-send-email-bmarzins@redhat.com>
	<1604472849-22422-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1604472849-22422-3-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5
x-originating-ip: [2.203.204.191]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2907ce78-8450-4468-ab69-08d8a20691f6
x-ms-traffictypediagnostic: DB3PR0402MB3642:
x-microsoft-antispam-prvs: <DB3PR0402MB3642B85845F20C9F68BA2106FCC50@DB3PR0402MB3642.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: MKC6mY0INBgZiJT4rbIfbB3QOWpJ/oVrBNdMztoZCLbZywoVTPDoIQzBPIBY+txIDQM9KmL2kQiWtWDK4u5PycHI1hULivgKc5zTe6A2uZXeMOGPlEoXEg2rq8CtQTVHbIDt7m5jCjF/Bt531vdinFKw2Budy3DqqTPiQI/y6y4Ee+N8MhNqHOptezAwtxko02cC3/ElKHVdP9SFLd4exoCOZ1axajSth+1SGCGKSjhchX83ASbMknTz+bH60ERJ7nYoqFpPPCh6iwXoEulvr2Oi/HwebYKr3ElHwZxeEq9AYd5mkXaM1hT2jpwFxWbvxXcjLVhopseOnQIYVC43Yg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(396003)(136003)(39860400002)(366004)(376002)(346002)(8936002)(4744005)(64756008)(66946007)(26005)(44832011)(76116006)(91956017)(71200400001)(478600001)(2906002)(316002)(6486002)(5660300002)(6506007)(66556008)(8676002)(110136005)(4326008)(66476007)(186003)(6512007)(86362001)(2616005)(66446008)(36756003);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?0llV07PlE1ZtN8pLkY/ZPnZY9Hsx8hpeco+1ul/1E61GzTDBjaFHPzXv5?=
	=?iso-8859-15?Q?Hc0QGm6DhlNI3JeNOEgZ82y1dzARzWPBQnWHmV8MS7DQgEJN/EmtgJYrR?=
	=?iso-8859-15?Q?aZB5em3SWI6KPJVDpWWUCED6N99h47X6odH19/0XXZhJJd7D8IQ/cD7Fy?=
	=?iso-8859-15?Q?GyRjB/d8ZYiBQr9NQlqIzan0JoHx80wW9iUD9yAyWEzkmlXwd1Uixf9g2?=
	=?iso-8859-15?Q?6Y0iNfxqNMJzsRHgvsJ0HD+OAvUAXK4duSCo+vJg4clC4y4umdcTAu5/j?=
	=?iso-8859-15?Q?vbe8OMnW/64LSoAqJIYpVHSFEWJDITzaikhlntVP6Azr/Iwlu/afLykrx?=
	=?iso-8859-15?Q?lSGsCP2kmEvSt3yx8yltvY2mqMaB6HtY/i1UlZykly7evqdgWZ2Md4MHV?=
	=?iso-8859-15?Q?JxJB73sLJoGZPxzOFiJxNWPvAfSLnYr2gxCUtm/kRtx2W/GEasyzXBpmL?=
	=?iso-8859-15?Q?GYhRg4dUD0zx1arQmV8w/FnjCNGP5gNqjM3xQEEJpR/QT020qmhJ9w7mr?=
	=?iso-8859-15?Q?EATr51xVXJkgEC7Tj2rQLEv/fLVkkdStQhEiO3VJE4V99IyIvMMmEMIIF?=
	=?iso-8859-15?Q?RDqzOxluz1UApOHeL5AiSSiHFQnpTVuXlheNVCXXBT1mBRdyu9TPmUGBV?=
	=?iso-8859-15?Q?NpTNIaNdiSwapatw0zqMCTFpj0h0apwS9RcUZUPWaaAhe705TMvuEh0G2?=
	=?iso-8859-15?Q?6VTMQFRFDgSeZqTwfyBqFnG1s1ePXsOApy2VofYD4JZajpAkv9ZnksY0w?=
	=?iso-8859-15?Q?Inhc5/mw9/XhwRxwwUcyH4wU26K/tr1lElOTFLS3ryNC174WOSe6TO77o?=
	=?iso-8859-15?Q?J/QFt25x7xndtqAaX0zNMvQirhUnD3kI3HBodnvviyDOgLgGxkIWQdTSg?=
	=?iso-8859-15?Q?aZI02/YDYAuQ9+rIFnB6vAWKMR4TMjPzBDNpcROsdfsf+HQHVaB0M7pCz?=
	=?iso-8859-15?Q?F+nwKGP3Gv5hAVNn9akFyKn0286ys0yAdAme6X1CAh5CUKS2yuVnuAvrH?=
	=?iso-8859-15?Q?XK4hLFYy66mOamYccgpkDGBJxmM7fuXbRlI1c+nY05y4ikIzDY1jlXT?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2907ce78-8450-4468-ab69-08d8a20691f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2020 21:07:17.4910 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N8V+qW5Aw5CA35rNqMEHHWnV7544XxZYOSK0KlsR1D3DT31l//li24M2Gizw4BNf1wZ7Bwa4Vdx+pedRBBub/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3642
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BGL7TrH004337
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 2/6] libmultipath: add eh_deadline
 multipath.conf parameter
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <06E8D7F64D7E5245A8B233721B548E9E@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2020-11-04 at 00:54 -0600, Benjamin Marzinski wrote:
> There are times a fc rport is never lost, meaning that
> fast_io_fail_tmo
> and dev_loss_tmo never trigger, but scsi commands still hang. This
> can
> cause problems in cases where users have strict timing requirements,
> and
> the easiest way to solve these issues is to set eh_deadline. Since
> it's
> already possible to set fast_io_fail_tmo and dev_loss_tmo from
> multipath.conf, and have multipath take care of setting it correctly
> for
> the scsi devices in sysfs, it makes sense to allow users to set
> eh_deadline here as well.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

