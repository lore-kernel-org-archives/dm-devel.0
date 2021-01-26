Return-Path: <SRS0=Cj1z=G5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DA74C433E0
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 10:04:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7948223110
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 10:04:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7948223110
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-gE-r4FKgP1uSlgbjb3Vwhw-1; Tue, 26 Jan 2021 05:04:44 -0500
X-MC-Unique: gE-r4FKgP1uSlgbjb3Vwhw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 63AEF8799E0;
	Tue, 26 Jan 2021 10:04:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2DDF160C47;
	Tue, 26 Jan 2021 10:04:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 964FC4E58F;
	Tue, 26 Jan 2021 10:04:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10QA4bXX008948 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 26 Jan 2021 05:04:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 99593110F0A3; Tue, 26 Jan 2021 10:04:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 947BB110F0A0
	for <dm-devel@redhat.com>; Tue, 26 Jan 2021 10:04:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3810C805B01
	for <dm-devel@redhat.com>; Tue, 26 Jan 2021 10:04:35 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-61-6lc7OAMgPZWtJz5PHQNMQQ-1;
	Tue, 26 Jan 2021 05:04:33 -0500
X-MC-Unique: 6lc7OAMgPZWtJz5PHQNMQQ-1
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
	(mail-db3eur04lp2052.outbound.protection.outlook.com [104.47.12.52])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-37-sxGqCHzoOZukGVlDc4uqsw-1; Tue, 26 Jan 2021 11:04:29 +0100
X-MC-Unique: sxGqCHzoOZukGVlDc4uqsw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB3PR0402MB3899.eurprd04.prod.outlook.com (2603:10a6:8:f::26) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.17;
	Tue, 26 Jan 2021 10:04:28 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6]) by DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6%3]) with mapi id 15.20.3784.017;
	Tue, 26 Jan 2021 10:04:28 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH] libmpathpersist: fix thread safety of default functions
Thread-Index: AQHW86R3vwBPJEgCl0yYZ/QVg4jpnKo5rfgA
Date: Tue, 26 Jan 2021 10:04:28 +0000
Message-ID: <17aedb32b8cf8229441d3a48b72b56ef6f6ebc12.camel@suse.com>
References: <1611639064-8187-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1611639064-8187-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2
x-originating-ip: [84.58.19.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 777b439b-1616-4feb-7ed4-08d8c1e1c480
x-ms-traffictypediagnostic: DB3PR0402MB3899:
x-microsoft-antispam-prvs: <DB3PR0402MB38991C70C4ED678FBC75B310FCBC0@DB3PR0402MB3899.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: KaP35iT0Rl9Rb0AzmGjRCIYB61QOMy6WX9b0PW2Jkq2eIFRghBM0abl7e+N40FWoZTtIBkUNQ+mG+2IwU1JAlMFzOAwqtCQV5WXakWjDk1UiJFdpdJeGP4CTa06LeL45cv3XPTgmTCqM9TWhSK+AU9KmvZZ6wu9n5XkbyEcOSeV6+40R1wy2OaCrZKMzjtqjsmFJL7GcvF3/sSKxI3hmeJ0sCATlS01aBFVn+MqRcpphD/hCCUTLVR0KzoowdDFjXjjfzxKHj+8FtI+9kL2TSo8IJpq9ICGVnycLhAAYvU99w3vVUfMRTK6FvxRlbYfx/hYavqdsZ5AlNPbmOdiPmqXkec+dgifbv6vPfKEKoVQcTQH7kgW9kXZjM3r1kqfNMz7oPikjk5SXphoCByKnGxwpcV3GGqTbYmZ9aqb9FrKWUxSzCO4ywwuoDzhEkxjaYPE0SHDL+IROs/jLprw4TNfHWdjbVbQG8AAoPqLUmd87rNbKnm1eeMdcG1pzKiJspeh5YlR6/UVd8Zw/nqHMy5tH/iqyKI6oXY3eq5PiHY7ji/hGAOXXjazMJ8xH9ag2qB7nwsaZDWtGbgbVzjApbIvg64O+4d8+7w8paq+jjcY=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(376002)(136003)(366004)(396003)(39850400004)(346002)(4326008)(2906002)(71200400001)(478600001)(8676002)(316002)(966005)(6486002)(186003)(8936002)(26005)(6506007)(5660300002)(2616005)(44832011)(76116006)(66476007)(66556008)(91956017)(64756008)(66446008)(66946007)(110136005)(6512007)(36756003)(86362001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?y1BKp6dvxYPr1/GNViPI/cg9Yuw/ZjwiFksLSLqGAwyEgAtiDWkrDqxXP?=
	=?iso-8859-15?Q?JCFB2ZAnK9GZpYKszGzLxpOziDXn1W9BsLuV6WI5nqktC1tx0TXs9v+2a?=
	=?iso-8859-15?Q?COKu9Dw6FJK36FCL28R0HxeD4kRDM7T9zd3KZRTOMEvdgjywAU/xzlFVx?=
	=?iso-8859-15?Q?GIwNpwwLNY2yuAXWprKInLoMa4E1RFeRvkvuVrhTqJnwA2K+oETyC3FQA?=
	=?iso-8859-15?Q?hhixLnPmPfVWDjHe/rw6RbqeA9iyQWBjzmV7aSEyU9O4xg2mNR9s3yc8C?=
	=?iso-8859-15?Q?wJMbVC4d39revVUmgFdtl/ffZ/DywnIYwE0BjaMZiVdneC7S/n5gHu7Ka?=
	=?iso-8859-15?Q?yq1HrvYRuYXNGkJq6S0lACA2mAYkPnbt/6JJTtlY+V6jx8SLI1r1qIWxE?=
	=?iso-8859-15?Q?1a21eV+RutGOZHyBGrFy8ZWmVh5LTEW8oszUC2eUznmidTwguLSv2hpRw?=
	=?iso-8859-15?Q?7C4TwWDiTDpRyl86RHYm9SPuUayMpczTU7JiC8ANLDFaCMYbt8kCR/vb/?=
	=?iso-8859-15?Q?rPBdBT79r0jVd/MGxKwv1Qixgio/2Cf+QauqwhQsFpXQbnoVeNVf434e/?=
	=?iso-8859-15?Q?bixPN0TE3ZFm3r+WfFrEEXWtbgix0G4p08y88eE1ctSq9UhuXA7yIivXE?=
	=?iso-8859-15?Q?PH0CcEhkgv7x9zXHSP95wG88ZAQWv9jgBFDNj3+Enb/Jt/z7o7mLqbEOX?=
	=?iso-8859-15?Q?ttJT+YdJOiYNbCOUw44BtHfnqVrljflnVjT/btoU49ByGqF3aamRsfavx?=
	=?iso-8859-15?Q?lO+NnHM4xYWrMh6vaBdAaVN7z4/jZOFE/bGaLPF5kCsihRrWWYY6mZU+F?=
	=?iso-8859-15?Q?yupUgWpxskepGNZep2Luv7Wv+CZ0skJb9WWn79pfjdbruWhI6OBq5ehmF?=
	=?iso-8859-15?Q?cEakmoTnWQLUSKFfqcJmMpxs4hc3nct/CZ9ojw9ISTRU9p+vUnEfZTM+8?=
	=?iso-8859-15?Q?5WHNXOaNH0tXHwVddFel4+EELsux2V44X4HAJZ5+TgwJ2BmxBo6yMxdJi?=
	=?iso-8859-15?Q?OR/ULuHyEcnrAJ/7EIEaIpVPRFAD7gIiCkF/cvoxtnzA25Be1hRZlXNBn?=
	=?iso-8859-15?Q?yiVz8Gzv8OgRiP7xjKXm9nNy4v3137qRGGZNvzSQX817F/rG8uu0XHkMp?=
	=?iso-8859-15?Q?nwhRa?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 777b439b-1616-4feb-7ed4-08d8c1e1c480
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2021 10:04:28.0333 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T8x2IozYwgv6x+WaKwtSSYpdtUHNGoC1VH68q4xu7uNwctVrsSaOS9nVpzFd5kli6XSnFbDlfM95TyDwZAD3EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3899
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10QA4bXX008948
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] libmpathpersist: fix thread safety of
	default functions
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
Content-ID: <62C73D0B87807F47BC4DF415237A853B@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-01-25 at 23:31 -0600, Benjamin Marzinski wrote:
> commit a839e39e ("libmpathpersist: factor out initialization and
> teardown") made mpath_presistent_reserve_{in,out} use share variables
> for curmp and pathvec.=A0 There are users of this library that call
> these
> functions in a multi-threaded process, and this change causes their
> application to crash. config and udev are also shared variables, but
> libmpathpersist doesn't write to the config in
> mpath_presistent_reserve_{in,out}, and looking into the libudev code,
> I
> don't see any place where libmpathpersist uses the udev object in a
> way
> that isn't thread-safe.
>=20
> This patch makes mpath_presistent_reserve_{in,out} go back to using
> local variables for curmp and pathvec, so that multiple threads won't
> be operating on these variables at the same time.
>=20
> Fixes: a839e39e ("libmpathpersist: factor out initialization and
> teardown")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

It turns out our CI has caught an actual bug for the first time :-)

https://github.com/openSUSE/multipath-tools/runs/1768201417?check_suite_foc=
us=3Dtrue#step:8:719

No need to resubmit, I'll just quickly amend this.

Regards
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

