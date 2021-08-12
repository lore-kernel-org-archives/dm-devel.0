Return-Path: <SRS0=gpIH=ND=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31831C4338F
	for <dm-devel@archiver.kernel.org>; Thu, 12 Aug 2021 10:24:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AF89560FD7
	for <dm-devel@archiver.kernel.org>; Thu, 12 Aug 2021 10:24:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AF89560FD7
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-kwyiHMetPGWUx6oxHYFVFw-1; Thu, 12 Aug 2021 06:24:11 -0400
X-MC-Unique: kwyiHMetPGWUx6oxHYFVFw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84BA9801AC5;
	Thu, 12 Aug 2021 10:24:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C8B65B826;
	Thu, 12 Aug 2021 10:24:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3F43B181A0F0;
	Thu, 12 Aug 2021 10:24:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17CANVt2012269 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 12 Aug 2021 06:23:31 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BA7EC10FAAF; Thu, 12 Aug 2021 10:23:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B4D5210FAA2
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 10:23:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 989198CA953
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 10:23:28 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-101-aLjcnMscOl-KcG6ZlumYcg-1;
	Thu, 12 Aug 2021 06:23:26 -0400
X-MC-Unique: aLjcnMscOl-KcG6ZlumYcg-1
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
	(mail-db8eur05lp2105.outbound.protection.outlook.com [104.47.17.105])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-31-M2sGkIKtOn2mu8mH2Bllnw-1; Thu, 12 Aug 2021 12:23:24 +0200
X-MC-Unique: M2sGkIKtOn2mu8mH2Bllnw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5385.eurprd04.prod.outlook.com (2603:10a6:10:83::16) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17;
	Thu, 12 Aug 2021 10:23:23 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::5158:3113:295b:d9c1]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::5158:3113:295b:d9c1%5]) with mapi id 15.20.4415.015;
	Thu, 12 Aug 2021 10:23:23 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 5/5] libmultipath: deal with dynamic PTHREAD_STACK_MIN
Thread-Index: AQHXhMMtxYe3KWSOVkey684vWAcksatvvqKA
Date: Thu, 12 Aug 2021 10:23:23 +0000
Message-ID: <bad4247178f378c3a78cf85927cabe998fe32cd9.camel@suse.com>
References: <1627595165-19980-1-git-send-email-bmarzins@redhat.com>
	<1627595165-19980-6-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1627595165-19980-6-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.3
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 68496af9-2c9b-464e-23b0-08d95d7b3743
x-ms-traffictypediagnostic: DB7PR04MB5385:
x-microsoft-antispam-prvs: <DB7PR04MB5385A642BE0374DD933307D7FCF99@DB7PR04MB5385.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:400
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: qhrK4vDOIyf22ihBLky0m0dybdN/X4OA6/AXxglF19QnC2Kj+WfKlkMS07yBPtn16/6rE/nE18p05hw7Gt6fvIN1vwMLDGeqXvNHq6siz0u9DS21ll2pAWOxXqbNs7QpFJfB1ZI9lg0pjCygn5/FNgqqEZz5tCSkv3ydl6ev8dkHQR6HzY3JuFyolWOx0zvlaXHYdYnh3XllMcuCkex2r5hPerLQBDU5AYSTQshUiOqYNX3H0qWw5DRHFbirLRBcdPftGGkR0XJbTIh0lEVv814jPoakrigNca1bMJtNYaPOtr4yEPPvxhsBUte784knKV6LJ3s9ZmeUvw3LObfYNi94wmB9a6eX4yn24YsfOhxHMuGssu9EnAlrD/vQ9tLflpShbgS2rsBmiO924R+p4ZTwGhroRBbB1XaZA8XxrU8zEasaySL+sDZmcQX50beywMr1JR7iIcbuAPGtGQ+ttn3LsJg18TeTAD77FbWzSGNsF0ZGaOOkqslXrlys3ZVkTUcA8GgSgNes8A7NxnwCH3fvbX9OpPy2FD/tGakWM6z64MOtAPIXpGMgQLjTDU/GMvJk+Z0jZOBh1YRjtE+MkjKFYB4y/4wjPaTjw31YD/2xXbFEPwmv/D1PXjcUXeKb9o6YM6K4HoIf4EgP6EQ9opnydkGhrTFroAd11r5Bo0f0qQT4F7fkegaDzG3HFuar0MHO/Udwo+9i/gVlVusrcg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(71200400001)(66476007)(66556008)(66446008)(64756008)(66946007)(6486002)(91956017)(86362001)(4744005)(44832011)(2906002)(38070700005)(5660300002)(36756003)(8936002)(76116006)(2616005)(8676002)(6506007)(508600001)(26005)(38100700002)(122000001)(4326008)(6512007)(316002)(186003)(110136005);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?13YC6xHh8Wwsn1ZZEmv4l+34PWIaZyGyvGuw7Ki9YpLZdwaZ1KClz51un?=
	=?iso-8859-15?Q?I6oeN/nOxNPWhfLXOiYvyI3FkL0Fc+sblMXP86c7BGDb0hlwi+Ibx/8f4?=
	=?iso-8859-15?Q?EtGdKOsHGr2Rs2XSiySDPm3vjar0p95RhAEouTfJri1JoF3Bc5dqmzwWW?=
	=?iso-8859-15?Q?Olh1PY1Q0tPIERofdoNzy3DKtb7s5whqqx432/L6wFTmbZOHuLYN6FG8B?=
	=?iso-8859-15?Q?6Yb7tMx3AZCfgGaZw+DgfYTtDYWYYU5VvlxRsPD8gp5T+b0kZqrHpBQiq?=
	=?iso-8859-15?Q?/koAAfQtqNqrrGHcAQAvjanN/XHWcpZm+T5iTkwxOtjhSSpS2EdY8jWa1?=
	=?iso-8859-15?Q?+LroPR37ebJp8qEJWvCNZLQgBl7BQAic4cLQdBqiutiUi4+1LFxjyAPpB?=
	=?iso-8859-15?Q?YW1z4yfLUROIEhpghSddKk7lcAA0XTRmuiiNB4Xcgv4RofGlseZ0n0WUk?=
	=?iso-8859-15?Q?koMbwP38MfeZEAGPGjzrvnpWrSi8hFiiLkCtiWcXhccoRQwJwU/gMEHuZ?=
	=?iso-8859-15?Q?EV8tbFgDx/wgSmGyy5MueKTS9sZqVP/PraCzwkwBwec7/lQuaysZS+ieT?=
	=?iso-8859-15?Q?7oSN0gWxSb0REdqfJiCQSPcG6Beyjww8qAuSiHNDYjBcTS7WA6bHkER91?=
	=?iso-8859-15?Q?L1AablxPqqgoHLtoCfOvsLLlbpv6C3dhu03SojpzSbvdmgpD/KtI0QiqE?=
	=?iso-8859-15?Q?Q6e9iyUDfPYJNEsjqIQfxSXd+9NN4GQ0rLFq2lar02XSbFTMTWMH4LAsy?=
	=?iso-8859-15?Q?LnDEPq6Hx8EKCXmuduiHx/nfQJIq+Z14EyOkktGWOOp6SSyDWI/a97Y0m?=
	=?iso-8859-15?Q?o5oA3SrYXpwnYYcOOyz6Q1Q/GIZr+K9dsDqRcGYD7KCkEEfyxjVnPwi0B?=
	=?iso-8859-15?Q?X1KQEsAlNt7umGJIl3oCNvXgB+ZxE99bpoVUNyhzv2zD5nNGOJduiBpqq?=
	=?iso-8859-15?Q?iWHXApw4qR/W5U53LP56++ZkeCof4YKa7bXBIlT25pmuxuerLS6KspzlF?=
	=?iso-8859-15?Q?/mB19cSRqJuKTg0xmqwDWQuSkcGavANmy3KpiWhl61Tii6tDHHNvxrsHf?=
	=?iso-8859-15?Q?+2f+kshTUOFVuXjJUl+SmVP21Z+LKle3pLro2/MdaPiOApum6Q6WPC9dX?=
	=?iso-8859-15?Q?IXV1/W6MzsZjHIrTkliYdbdTaKZWydmG30uDrTR/W1uzoOSvP5XnJvSEU?=
	=?iso-8859-15?Q?cLsMGE1cl2mPqUUkHZGviV11Z7xeu6wAQMACegK5uWb8PYq/ZYx22DVMO?=
	=?iso-8859-15?Q?FnLgInVBcsdoqvmaOf0FTtexHVoWxwjI5cTmwiWKBSnfH8cKtzeFYxBtT?=
	=?iso-8859-15?Q?I8uZBkN8DppKfkLhwXWKegS22jhID4Xmc2+QugRrOdc5hjeXL1rko9/qj?=
	=?iso-8859-15?Q?/xILNudp8k1Gqa4AX1f+PUcutFAot4lPC?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68496af9-2c9b-464e-23b0-08d95d7b3743
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2021 10:23:23.8473 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3a5HDHAdOa6Wf048uZ4m5BdI78LkjKzkla5u5i1fJOL/nIjzq7nvyqQxobLDzM8dqnpdC9sLlCF0tXa+dGrU+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5385
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17CANVt2012269
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 5/5] libmultipath: deal with dynamic
	PTHREAD_STACK_MIN
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
Content-ID: <69A40BE6807E3A449861C46B72DED3F7@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Do, 2021-07-29 at 16:46 -0500, Benjamin Marzinski wrote:
> Starting in glibc-2.34 (commit 5d98a7da), PTHREAD_STACK_MIN is defined
> as sysconf(_SC_THREAD_STACK_MIN) if _GNU_SOURCE is defined. sysconf()
> returns a long and can, at least in theory, return -1.=A0 This change
> causes compilation to fail in setup_thread_attr() due to a comparision
> with different signedness, since stacksize is a size_t.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

