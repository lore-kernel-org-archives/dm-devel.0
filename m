Return-Path: <SRS0=kuEZ=GQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D1A0C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 13 Jan 2021 11:46:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E69BB233ED
	for <dm-devel@archiver.kernel.org>; Wed, 13 Jan 2021 11:46:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E69BB233ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-FrIIo0FFN86i-Kn3eDclJg-1; Wed, 13 Jan 2021 06:46:20 -0500
X-MC-Unique: FrIIo0FFN86i-Kn3eDclJg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 46527107AD2F;
	Wed, 13 Jan 2021 11:46:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EB435100AE35;
	Wed, 13 Jan 2021 11:46:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BFE4A180954D;
	Wed, 13 Jan 2021 11:46:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10DBk5Lq025479 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Jan 2021 06:46:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5DA7ECF62B; Wed, 13 Jan 2021 11:46:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 572A3C77F4
	for <dm-devel@redhat.com>; Wed, 13 Jan 2021 11:46:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93C6E811E76
	for <dm-devel@redhat.com>; Wed, 13 Jan 2021 11:46:00 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-352-aVNkOxc7PligjoLWQd6grg-1;
	Wed, 13 Jan 2021 06:45:58 -0500
X-MC-Unique: aVNkOxc7PligjoLWQd6grg-1
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
	(mail-db3eur04lp2050.outbound.protection.outlook.com [104.47.12.50])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-22-vyr5Q5-RNeSyU0TqZ48M7Q-1; Wed, 13 Jan 2021 12:45:56 +0100
X-MC-Unique: vyr5Q5-RNeSyU0TqZ48M7Q-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBAPR04MB7318.eurprd04.prod.outlook.com (2603:10a6:10:1ab::14)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10;
	Wed, 13 Jan 2021 11:45:55 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6]) by DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6%3]) with mapi id 15.20.3742.012;
	Wed, 13 Jan 2021 11:45:55 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 0/3] Multipath io_err_stat fixes
Thread-Index: AQHW6T4VaYNOrF2ER0C1i4BElYSkqaolcNAA
Date: Wed, 13 Jan 2021 11:45:55 +0000
Message-ID: <d4899abd850929066473f4165940d431f20fa6e1.camel@suse.com>
References: <1610495575-8177-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1610495575-8177-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2
x-originating-ip: [2.203.204.191]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a6dc4f6-a637-4c92-29e8-08d8b7b8c96f
x-ms-traffictypediagnostic: DBAPR04MB7318:
x-microsoft-antispam-prvs: <DBAPR04MB7318E272BE73F0123260D901FCA90@DBAPR04MB7318.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: s9XOWcrIoNuC14i+H4Jn727g/PvHPgIUzpMkcQ9WZoIrhVt3uub8odYFa85G0J/w+0kZ8QSErlIBYBdpgFOCUfUcYEuh9c13BM0cJkdj5Kh1m0Zh3/ay6AUm0SWuXr0L+jNh106VdrdFTT1Y7EXzv9wRzr2tZ997aQ7Hj4Ds2XjTbD8X+heA1/HIlivXZ4o3sNlPaohDjNqlN9ddtfdPQgQTfVaNTFUs3D4llHRFffTbJ26fttbh/s16GCpEpg37bL2LtQX1T0tGpM0R8YtUDF5wVpHXEoD8Fi8nuig4TUsJvX37zfDXpXRZN8G0l4E1HDKBm3oAa5pHgikaNl7DZPDJLLFaZmSawEWeI4fI9XsgTvzGP3aAlSBVLQDGQ+H2
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(376002)(366004)(396003)(39860400002)(136003)(346002)(71200400001)(6486002)(44832011)(26005)(110136005)(316002)(2616005)(4744005)(36756003)(91956017)(66446008)(66556008)(66946007)(478600001)(76116006)(8936002)(5660300002)(2906002)(186003)(86362001)(4326008)(64756008)(6506007)(8676002)(66476007)(83380400001)(6512007);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?+xJo9Vc2t+a8W1PxH+Z/CruoCcIU4+t00+JfjS1Zg0FV6wO3HjQ21TdH5?=
	=?iso-8859-15?Q?6KBJiM75gxug/TAsu1YjusvsceAvdJ4NTanMpVYOc4qbFZR3wS5ifOfd0?=
	=?iso-8859-15?Q?HsUNu1lw4qZPSxfUwtFdSNSzPZSAhQTmXCS4mRLhxADFxDw6bkRpgzKD0?=
	=?iso-8859-15?Q?xRNkM5Qu0fZkzbwYmpgy1vfYPV68Fg+/gvEvDMn1SVX15FCX3T3vFMWKl?=
	=?iso-8859-15?Q?R6QFxyNvqxBipPmFu//1Kz9/ddRNEZvH8dvuDc8u7AJx+mPj/YgZKKQlr?=
	=?iso-8859-15?Q?B3osJ2Rvxl9zSpI49ZZ0r4Vyj/sSq/MZ1d9IgBARc8eF4ckCnDyfZ68pG?=
	=?iso-8859-15?Q?2n1UM34jNpYGeEmV/q7bpAn4AIezkXG7U3XHTr/K94etnY/ZZUg24/lqu?=
	=?iso-8859-15?Q?5g8DbYFu5J4fFrPiepPR1emMmbLvgJwYysPieV7JZboPv/jRiPYDcxjyA?=
	=?iso-8859-15?Q?3iWDSO/Ow/XUWbkL0CvaWZoKbMxKlOrpeZ/hM/hZSY2ZzE195lcpuMVSL?=
	=?iso-8859-15?Q?3dPQdaTqnn5THKUV2SIiVZ8D8FrGHxN7jIJwdu/zlr98bLDI45Krgb+Ch?=
	=?iso-8859-15?Q?PTh2XQ6rLWs2a5dVqZw/1QJHMJSmJSm19udtCLIqp/m9fjo6IeSggjTFF?=
	=?iso-8859-15?Q?v78hD52ifWoZ8qLGEpDSovE5Hfh6lXAQEo7vnOOCrqDQExdz0Fy9InN2c?=
	=?iso-8859-15?Q?h+bywRWmCflWu+A8LNKlp8a933oHwh1jZwWvoV52HCVlCKnehfJpwcchs?=
	=?iso-8859-15?Q?ucnn5G8mna7SsHAAaKH+cMxVAXiipgVuCZ+s1nHRXubnUh+zq3zLJf76m?=
	=?iso-8859-15?Q?NWlhJc78faaCFgfitGwUwPEtnb6sJHWkOX9MuZtfB3VbSM98XMlX5kap7?=
	=?iso-8859-15?Q?T1TUxojZFKhYNUL5SNLFtT+poLlv9OlRzBwXrMa9sYjqnEJBHLGXHMODz?=
	=?iso-8859-15?Q?wEABsY1HWf5qj4mNTaRGz0tVniIMH47xY1T0LM5eyZZd9clyf4mixp/LY?=
	=?iso-8859-15?Q?JDQvZiL8ZumGoyFvV08TR6UOWPJBfFjYXlViWTTsMfMIirxj7OHqrkE?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a6dc4f6-a637-4c92-29e8-08d8b7b8c96f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2021 11:45:55.3086 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VyzvsNuIjHTgGMbLfun6Y3okORdwr0YhxjjRRSfpFGvp++NMXGDDOmtdJMWruTFn/o1RtbLN+MntUJSiCSSDJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7318
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10DBk5Lq025479
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/3] Multipath io_err_stat fixes
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
Content-ID: <368702A0EC1C2E42BA9876631088FCFE@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-01-12 at 17:52 -0600, Benjamin Marzinski wrote:
> I found an ABBA deadlock in the io_err_stat marginal path code, and
> in
> the process of fixing it, noticed a potential crash on shutdown. This
> patchset addresses both of the issues.
>=20
> Benjamin Marzinski (3):
> =A0 libmultipath: make find_err_path_by_dev() static
> =A0 multipathd: avoid io_err_stat crash during shutdown
> =A0 multipathd: avoid io_err_stat ABBA deadlock
>=20
> =A0libmultipath/io_err_stat.c | 159 +++++++++++++++++------------------
> --
> =A01 file changed, 73 insertions(+), 86 deletions(-)
>=20

Thanks, the series looks good, I have only minor nits.

I've made some remarks about the io_err_stat code in the review. While
you're working at it, would you be willing to fix those issues too?

Cheers,
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

