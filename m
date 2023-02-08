Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C306C05027
	for <dm-devel@archiver.kernel.org>; Wed,  8 Feb 2023 07:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675841751;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lTg0MqMH/QGB3gA79/Abz3d+MFF37Z4DZkA3eqzOKCU=;
	b=ZEhgLCHUWW1u/t4M5PF0Jv8iq9ucNaURINcGwoTPC/GhNUK9DCZJzBgwWvg67VHqhQ0B7s
	S9pdqcp6h0s74d87mcYze10AfY9MbP0Nv7S7soytJfH6trgG9Z9GzTvLrtEYW4YmrQ/S4z
	Is7Dtfavhz9ZZtjJX9xVwNcG/ijJuJA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-212-hy4DgxwTMVCcg_X9VjO6lg-1; Wed, 08 Feb 2023 02:35:47 -0500
X-MC-Unique: hy4DgxwTMVCcg_X9VjO6lg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5EBF1100F939;
	Wed,  8 Feb 2023 07:35:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AA803404CD84;
	Wed,  8 Feb 2023 07:35:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1B24C1946588;
	Wed,  8 Feb 2023 07:35:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1A2321946588
 for <dm-devel@listman.corp.redhat.com>; Wed,  8 Feb 2023 07:35:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DC539404CD85; Wed,  8 Feb 2023 07:35:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D31A2404CD84
 for <dm-devel@redhat.com>; Wed,  8 Feb 2023 07:35:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B41FF28004B6
 for <dm-devel@redhat.com>; Wed,  8 Feb 2023 07:35:42 +0000 (UTC)
Received: from EUR02-AM0-obe.outbound.protection.outlook.com
 (mail-am0eur02on2082.outbound.protection.outlook.com [40.107.247.82]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-474-hRJHpsYDNWmW93f9bE1PYA-2; Wed, 08 Feb 2023 02:35:39 -0500
X-MC-Unique: hRJHpsYDNWmW93f9bE1PYA-2
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by AS4PR04MB9386.eurprd04.prod.outlook.com (2603:10a6:20b:4e9::8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Wed, 8 Feb
 2023 07:35:37 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::264c:9f82:e937:9408]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::264c:9f82:e937:9408%3]) with mapi id 15.20.6064.029; Wed, 8 Feb 2023
 07:35:36 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH] multipath.rules: fix "smart" bug with failed valid path
 check
Thread-Index: AQHZO1TRbKDOpnqkN0i94lq6egfSTq7EqTOA
Date: Wed, 8 Feb 2023 07:35:36 +0000
Message-ID: <c9bb45183e47591f9a6fe1bca9f695a697e7fd62.camel@suse.com>
References: <1675816336-24371-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1675816336-24371-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|AS4PR04MB9386:EE_
x-ms-office365-filtering-correlation-id: e686a37d-3883-4e29-1969-08db09a711e5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: GukIQaeDUjxemoTgq3hcNfp5cz4aENlx8WR7xvIYpESEn9OB3zVVNK7BBYgwUZ69CPEeGjDtobFf5l9dwFZKl77URsMXCQPaeWGMnshdZCLJdFdnb0Bq+PDe27TpcoHQG72hvqRH2TycuU5KMexjQExcBTaULd3cI2mSwDVciYGwDLcat+fXyEATEvJSpwD/DlSXr+uFHdN4ldzOQrCCp8DYZNx4Wsd5gmYOMTcexgNx0n5vmGAl3q9gFM2E9dQnDzMrHHGVE5LHbmSeOJr6FEM6pGO78wpe1YwrXUWwieZR1ZDWqfDbENNWWc+eFmFvkBGURipvWWS0yUZWBNcKz5URuOVaWYDbYk9iS32UZWGCQdKIsXo5VsQDqbTmDZS1RRGqnAvvz9+02t/Jt4J8C3KlpP677MW58jE4ShPlnxr3VaOKAClAhzryaXw+ohieG/9g7fAFAxBi6jNfZLIww6B76LbD1oEmlyWnoskqh1Zp1V7YW39pPRWdkMxBR+oHQghO7+6QT6aBCzw5+u0Rp6SyGPmLZfCXFMwld1Eb7GZPEQf3BE0MZ8Xjch3pbgNCMXd1qmDH6Izhmgt1cvEaB+g/tjJeuIQNLrLbcL3jNGj/32e5x0gAOPjmtlza6YQwd6GWzpjCmJgpW1zeSQu64r5UqmoLppIBuqWQXyAmkEQZUe7/OFvakjpeL+67GfcZZRsh7dcPjLG1pY4/NohSMg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(396003)(39860400002)(366004)(136003)(376002)(346002)(451199018)(2616005)(86362001)(6506007)(36756003)(71200400001)(6486002)(478600001)(4326008)(41300700001)(8936002)(316002)(110136005)(83380400001)(6512007)(186003)(26005)(66946007)(8676002)(91956017)(76116006)(66476007)(66556008)(64756008)(66446008)(44832011)(5660300002)(2906002)(38070700005)(122000001)(38100700002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?mMm7s8217dMrSkwG2i144gcglqfoPCHgYDgNZ2tkJBLcuniecJUobe1vB?=
 =?iso-8859-15?Q?Reb8E4Yr9Mq9YtAcFN5HrSK6AGBXOtHD7+Qy7/z34MCGYpKMuelC4d7kV?=
 =?iso-8859-15?Q?0D+tzDpiU4sWllsvZnF3ScrxQ43Lpl8T99CnqSAFnRNhl/zrGK3Yp1pSk?=
 =?iso-8859-15?Q?QxH0mAmjuy6H+bwt1d6Prfz7+le/aPLUJJ7rxCdG8PrgmkAsAIV9oHJVF?=
 =?iso-8859-15?Q?9XRWLwT0l9cO2KFk8vBHtnCUlRAU4WRiDMqqnOgbXtDKCjKXWll0vM3Vv?=
 =?iso-8859-15?Q?SWzHVsQdUqPL9Zc/JOGjX8UQ1D45nybaJhlPTtO6ZVFUE385BtNDGtfIP?=
 =?iso-8859-15?Q?AZKb2lfmx82clt+cnTGoDIbyC67e0tNGGT1PBuxz1cSq6mbc3FzDWP5ng?=
 =?iso-8859-15?Q?vHTdHTlMv73UXghKFTrJGaf4nxr1Ylz54wwtXLDEzt1DxVlq1lCxn8Vy2?=
 =?iso-8859-15?Q?BP8Sde+iI7TAMOrxcdUU1d9+4VtUIe/A+zIqBBTAUSwONIVMwcCMvmY93?=
 =?iso-8859-15?Q?SBOLVSK5rRaubu0nPKPG8uHs7+KAj+CympOS0c5jld++8ktJcEWr8yF/r?=
 =?iso-8859-15?Q?jbFUyEP/GvVu3i6RVVmy4rI4RVHJHtJA7xSL/UPt8B6xU0UvVM9UulvGF?=
 =?iso-8859-15?Q?MuP1gnbi0kmJpistBsNSgIq9tnJ65cdFqIEuazDf4+pl38OQp43j9+agm?=
 =?iso-8859-15?Q?bd3TPzQ2wFUuTElDvLBpV3uYdiYuocQsRDG5iyWhlZRsJY7KzgLBOtOD+?=
 =?iso-8859-15?Q?CAL/48CedzelNkpLrcHREZihyWy62Q7WqLcCXRY3aOMulqLUjJIq4SXCW?=
 =?iso-8859-15?Q?8XE8JWvNaGIc0dFKQ6kdwN6p362h+vLCur5tYCeSF2YL4T8ULZrYJn/D7?=
 =?iso-8859-15?Q?SzpbnqHjSrKO5DEb123U0farAncibZuLOKnksbHBM6uWFqVjVvXRSU2q1?=
 =?iso-8859-15?Q?cYAvRA3NE4xPTLFDeZWCB23z9yFT3ASh8Tz8clwz/19rVzbSlnVS2jCoy?=
 =?iso-8859-15?Q?M78mhRjtyVAA8C7Zq+NpVwtPZe9N4P4asXjPaU6KTw8uNz3Fv7BkvRfSM?=
 =?iso-8859-15?Q?ThAe1hnb4mq4+WvjuF3lzNNdhoIoyGX1uArG/QyBuu/T8Cu304/Xjfei+?=
 =?iso-8859-15?Q?GbIMSOuZQLFljzWLACFdvwE2SIuPdc2JGboIF1SxratJUtq9K7TKvX5YF?=
 =?iso-8859-15?Q?KAle2a2Ciwd+VCXuF+kANS/u58N7rPwQRldHWlcIXsJtlKCWrOOrH6e1V?=
 =?iso-8859-15?Q?JuGN63uQr0+sGGF3saWi9uP28Q0oGocOrmDJn5KOPA3GE0e1q0vgVL3xD?=
 =?iso-8859-15?Q?9a4F619+LIiGBVar88MlNw1eeJFgMH2QDSpGlNq4JGT6MmAyepaEbQjZb?=
 =?iso-8859-15?Q?He77oMY0uJcp2LCYe61ccNlGxjDQo9Zm0Fl2Fkr0ikwK+/r8R6Nr9ssqr?=
 =?iso-8859-15?Q?AkZmf76uxz6GmR3Xfdbfe40P57O5AEYkcfBZuuPPvPXEEJ3GDwOdkafQK?=
 =?iso-8859-15?Q?dMgh9Sh4jMHeeMIBZlYA2nnH0f8xIZu4D1+1aolLkeKft/J9iXymXSlep?=
 =?iso-8859-15?Q?XS4xXwKUwxL94F7wEOiZozEDougkE265ScN7dmz3LceVvefDQXvWt90aW?=
 =?iso-8859-15?Q?6F3Q2n2EqIRQD+0K+64HQ81rsXcIs68Dm7orTL132PPBocnK7h54EV5wb?=
 =?iso-8859-15?Q?LY0l01Sg78xFvCT4dxpDq4V4RA=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e686a37d-3883-4e29-1969-08db09a711e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2023 07:35:36.7004 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q87Rx/5oeEVGIVmqPgDQA07JYwsCaf/Cs80NsbckmCRFZLhNzaK7qa6kYpK0mBZgncGteoY5bHQvYPrLTR5cQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9386
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH] multipath.rules: fix "smart" bug with failed
 valid path check
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <A5D354C824DBAA45891244F9404BBEAF@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello Ben,

On Tue, 2023-02-07 at 18:32 -0600, Benjamin Marzinski wrote:
> If "multipath -u" fails, udev doesn't import any values from the
> program. This means that multipath.rules will continue to use the
> values
> for DM_MULTIPATH_DEVICE_PATH and FIND_MULTIPATHS_WAIT_UNTIL that it
> has
> already imported from the database. This is the correct thing to do
> for
> every case except the MAYBE case for "find_multipaths smart". In that
> case, DM_MULTIPATH_DEVICE_PATH will be set to 1, and the rules will
> assume that the device has been definitively claimed.
> 
> In this case, we know that the device shouldn't have been claimed
> before, but we don't know if it should be claimed now, or if we have
> hit
> the timeout and it should be released, since we didn't get any
> information from multipath. The safest thing to do is assume that
> this
> was the timeout, and the device shouldn't be claimed. The only time
> when
> this could be the wrong answer is when we first see a new multipath
> device, and it could only cause problems if there is metadata on the
> device that will cause it to get autoassembled by something else,
> before
> multipathd can autoassemble it. If we assume that it is a multipath
> device, or we assume that this wasn't actually the timeout uevent, we
> can keep a necessary device from getting released to the reset of the
> system.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

We have this code in check_path_valid():

	/*
	 * multipath -u must exit with status 0, otherwise udev won't
	 * import its output.
	 */
	if (!is_uevent && r == PATH_IS_NOT_VALID)
		r = RTVL_FAIL;
	else
		r = RTVL_OK;


AFAICS about the only condition I can imagine in which "multipath -u"
would return an exit status other than 0 would be failure of
init_config(). If that's the case you're concerned about, the issue
might be easier to fix in main.c directly. 

Regards,
Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

