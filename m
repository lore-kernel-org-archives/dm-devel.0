Return-Path: <SRS0=MR+g=QE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC71C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 20:51:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6EE4861B1B
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 20:51:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6EE4861B1B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-ka1EImS6MgansCMdlZJszw-1; Wed, 17 Nov 2021 15:51:07 -0500
X-MC-Unique: ka1EImS6MgansCMdlZJszw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 594EA824F87;
	Wed, 17 Nov 2021 20:51:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 02DF55C1BB;
	Wed, 17 Nov 2021 20:51:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C6A304EA37;
	Wed, 17 Nov 2021 20:51:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AHKp0Tg022503 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 17 Nov 2021 15:51:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 18F10404727F; Wed, 17 Nov 2021 20:51:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 12F53404727E
	for <dm-devel@redhat.com>; Wed, 17 Nov 2021 20:51:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECD8C1066562
	for <dm-devel@redhat.com>; Wed, 17 Nov 2021 20:50:59 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-207-cKCqJODoODqQ-V4HX1AgPA-1; Wed, 17 Nov 2021 15:50:58 -0500
X-MC-Unique: cKCqJODoODqQ-V4HX1AgPA-1
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
	(mail-am6eur05lp2104.outbound.protection.outlook.com [104.47.18.104])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-36-mNqznFRjMCyRKNpKb7TCRw-1; Wed, 17 Nov 2021 21:50:56 +0100
X-MC-Unique: mNqznFRjMCyRKNpKb7TCRw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB8PR04MB5867.eurprd04.prod.outlook.com (2603:10a6:10:ac::22) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27;
	Wed, 17 Nov 2021 20:50:55 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c445:c7a6:f796:5e65]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c445:c7a6:f796:5e65%3]) with mapi id 15.20.4690.027;
	Wed, 17 Nov 2021 20:50:55 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 0/4] Add "reconfigure all" multipath command
Thread-Index: AQHX2/JtREPPydXWd06vt5l1CDRr26wIMbsA
Date: Wed, 17 Nov 2021 20:50:55 +0000
Message-ID: <c78729cd320b2a8dec4414c389922ec1e41ff13d.camel@suse.com>
References: <1637181217-4423-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1637181217-4423-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 10ab049a-43d0-4545-4b73-08d9aa0bf34b
x-ms-traffictypediagnostic: DB8PR04MB5867:
x-microsoft-antispam-prvs: <DB8PR04MB5867B4569AD7C368A4ED926CFC9A9@DB8PR04MB5867.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:541
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: +gp7R75UsFJSLmrnFmpZit1aw2s0nlnmjCsbiSHPGVmNBo62kbTCnZE+n27fFdzMkBdrf0vfKYQtKeatZ5u2Bh6yr3Vu/66pU+DXvKLV12JrepCDJ8uBu8HhHcBd80Oakp/yXgILWceBFwm/dHNls57jgs+F91erQ0rLCf0j1UO7AcBIajvDr3yiBpCsnbMmd+uL6yl/JOwcbxzHTklBiGoFIcMqxGCp08CXTOAiJMyDtczDlQe01n5Sq1frOSjYgsU6PkYzQPqwyRMSWasNGWqNobQKmtIxhnyUxkpnDmoMhSXWs7JkTLA0n9oDhMkXFRteMny+uMQmVBHNH8actvnu+iF+lKHf6l2Nwcq+oQnt8gi5qeC7FshaKmAQIe9+xe3lyxBiAwrjsJxEws19Fxp7FxVwQOWAIb4pfsk3mXGQ3fQURWUFFY9EXXJYu5zlhRN7/Bqu8CGa/ESNrEdJn9b3tIxPbkmAd7fUwZOhUDkcyNs/s+lSLYUjk0VJwwVqISgTo83YjFNUZz1xsJyevw+BiOagKT+SE5JoeHfW5OjuyjxWkOoZY2JejdwINR35vfo8481Gkcofu3iAYOrIUxnd1gmVCzpiS5xcNGNW0Y0iEYlt+oyqEBCfRJ08D5xDO1lwuiBHURb1mkCFC5HG7HZ+/TZ3qlTeLJ9p5/mBOYMoN3mb6vIYcMxtrbRzT+jEjef+H4k79m5o0TvJkPQ8Hg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(122000001)(6486002)(5660300002)(4744005)(38100700002)(38070700005)(71200400001)(186003)(508600001)(86362001)(4001150100001)(66476007)(64756008)(76116006)(8936002)(26005)(91956017)(66946007)(66446008)(4326008)(83380400001)(66556008)(8676002)(2616005)(6506007)(6512007)(110136005)(44832011)(36756003)(316002)(2906002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?PCcj1kU+n29SJ+3QzAhzYpTt1W+Dzu1v+JSMoSwUuWR4mQwzmUUdB/GLq?=
	=?iso-8859-15?Q?i/x0TooGd29L96Cd1vsx2tnXnDwJJK87/YgDjsYa6+9ghGAcyxhXkDLI9?=
	=?iso-8859-15?Q?EYJdfCmbGtnN2AGM6NLxXyI/5TwoaGEZ+QR9fGd8AINCj2G++e7pBmx8I?=
	=?iso-8859-15?Q?EMiuYM23Pz+qtT/eh3v2/WFxcY9v2rZfrYqbGQlioEdT9G/VkZApsawsP?=
	=?iso-8859-15?Q?ZC97Dk7UxOZucXWhzbkcw/48MEsf+c3ki54iCY8/e4WCovmA2QTwIsktQ?=
	=?iso-8859-15?Q?v9K0P0cj98IJQ+9h2bzXEk/GKqiZJxI5x4v5/UM275kIZ6bs0MJe4MJdX?=
	=?iso-8859-15?Q?pzKWjGIVZsgoHhrhNWO3yZgy9Bs/2OPcTWtJflT0GvSgg+2PSfsMq5Z/m?=
	=?iso-8859-15?Q?jv0z3dSbYotPX4QBB5liJsKmHpSuUFRcSbYcUqbPJBpq0yD9b/q6knJ/V?=
	=?iso-8859-15?Q?joWug01RfBN6KzKx+QEMIe8IUEgHFlcbTnx9QPXFwr3PIBzfuuw95jaQ+?=
	=?iso-8859-15?Q?ZzPkKGYl5nKxYgTeU9DCXgKqQsg7IwcPAqp7LksuDC2i/uyE4Zr1vPs01?=
	=?iso-8859-15?Q?p87OmCc4AXdEWiftpLNIwC5Y4Sf5526Eilyyvqn8YeDLMhi+p3U+sxsk+?=
	=?iso-8859-15?Q?3C+OOkAcxQ6M9D3BlikC03doRtp+kQTrrgwQXoeXnKRMuxulvq5ylly/+?=
	=?iso-8859-15?Q?S+QYDI+CHOOT16yK6VZVMaZLYgiWj9Mz0QMUB9dvWwdKE9ODjm5ifYlyj?=
	=?iso-8859-15?Q?vPeaNemSG7iuITEBNNIz+dkRuFrrISiC31ijPjyfZw5sAlDf9L9ohb1rs?=
	=?iso-8859-15?Q?R0qKc6Ngx2sEdxvYRUMxhJfkncK7cE2vIsLqDH2ruEIK7ccv/oIzfIoys?=
	=?iso-8859-15?Q?w+QR86TGMewMiHlmih/C2RgJdX+epoir++oCbCAnpfsm9qfFSN7o+shCB?=
	=?iso-8859-15?Q?au8hOQlpInyRGUzipHddlrbxvsYEReUqRa9EVi0KiS//Ol3dTEmvoGA1P?=
	=?iso-8859-15?Q?yn3o4wpdEcaH7gCC4n+x4ZunbfidfwoyyjAEA9A7JY10+3nSpw3lgds8D?=
	=?iso-8859-15?Q?ZUW1cMTfzJRtz2JEDXUpk88rvncsFlCkr30VoQ+VqxHcy98RObzSz6bph?=
	=?iso-8859-15?Q?S7Ew78/+76PQ4rVKcQPHlARu2dZMloN6WMPCyNO56vOhgHf0etNcQ2Vaa?=
	=?iso-8859-15?Q?dyYNGFre/RkG4igRvaHmfNRYLoVpt+46PWr0s+KsZl3okvRKKWCYy3Wps?=
	=?iso-8859-15?Q?QVOsNgbVpDTcB3a4x4wvg9UZYfuiUGqiutplyCTSID5FuGv2B5nVpV3Qi?=
	=?iso-8859-15?Q?Nj1/qY64NrScJkxm0ztYfb3iYmU9VHKWmWcvmBaRYFaa/y6hXawR1k9rQ?=
	=?iso-8859-15?Q?Fm4t9BFA8ySJzKqdLja+5s4GANrxQlZGfSOKIo2itXwgK5HzPCYKDV4Gv?=
	=?iso-8859-15?Q?4vNrApJ3LIp3XAj+l7kYLDA7857uP+rSCmuWE95kav8hwlZhvo5rIZhRu?=
	=?iso-8859-15?Q?wA+4ASkhgK6RbGXPAdI9/ftzjNefA59CL4OTuhQndxniTlqpyH2/cia1K?=
	=?iso-8859-15?Q?rxP7qgBtkSa3Wntrr3XsN9bjvXNmfXaq+FQpd3Dll9FsocIMbRovdwDYi?=
	=?iso-8859-15?Q?Gbxhz6WRsXbcaAskxupEq4xqhzOhAlawYzaazckqC2tPtZ5ddEBcfymPN?=
	=?iso-8859-15?Q?tAmp8QVqr6KneAsFRNjrWBWJ6E4AG5dUn9MJ6a0iN5lWFNA=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10ab049a-43d0-4545-4b73-08d9aa0bf34b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2021 20:50:55.1986 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HeKAceLCJbR0eewkOCtdoCqXx//1TrDR+rN3RUsfiFjcDX9lvKhHaJiHtRpsEj/3v9QROmQPiXe0GHs2CBpAoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5867
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AHKp0Tg022503
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 0/4] Add "reconfigure all" multipath
	command
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <A111B2387E4BEA4CA1B938F8CCA8EA86@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2021-11-17 at 14:33 -0600, Benjamin Marzinski wrote:
> 
> Changes from v1 as suggested by Martin Wilck:
> 
> 0001: update libmultipath.version to handle ABI change in struct
> config
> 0003: Clarify commit message

Did you overlook the two other comments I had on 0003, or did you
deliberately ignore them? Just asking.

Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

