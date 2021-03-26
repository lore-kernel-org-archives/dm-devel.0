Return-Path: <SRS0=sRxI=IY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B09FCC433DB
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 17:12:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0461B619FF
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 17:12:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0461B619FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-C82HlE1xMve8mLhRFjJixw-1; Fri, 26 Mar 2021 13:12:52 -0400
X-MC-Unique: C82HlE1xMve8mLhRFjJixw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87FE08143F2;
	Fri, 26 Mar 2021 17:12:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6030C1378E;
	Fri, 26 Mar 2021 17:12:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 253A54BB7C;
	Fri, 26 Mar 2021 17:12:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12QHCj0C006470 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 26 Mar 2021 13:12:46 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CE7D22157F24; Fri, 26 Mar 2021 17:12:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C7EB72157F23
	for <dm-devel@redhat.com>; Fri, 26 Mar 2021 17:12:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7693285A5A8
	for <dm-devel@redhat.com>; Fri, 26 Mar 2021 17:12:43 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-442-F0SIrp2PP_CSohKVSHV72w-1;
	Fri, 26 Mar 2021 13:12:41 -0400
X-MC-Unique: F0SIrp2PP_CSohKVSHV72w-1
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur04lp2059.outbound.protection.outlook.com [104.47.13.59])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-28-ybQ6UF2fNmeLqJpLVOj9vg-2; Fri, 26 Mar 2021 18:12:38 +0100
X-MC-Unique: ybQ6UF2fNmeLqJpLVOj9vg-2
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB3PR0402MB3643.eurprd04.prod.outlook.com (2603:10a6:8:5::25) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29;
	Fri, 26 Mar 2021 17:12:36 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb%7]) with mapi id 15.20.3977.026;
	Fri, 26 Mar 2021 17:12:36 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, Hannes Reinecke
	<hare@suse.com>, "christophe.varoqui@opensvc.com"
	<christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 2/4] libmultipath: fix priorities in parse_vpd_pg83
Thread-Index: AQHXIdphHMXt7za5/0CjNSBmSMx0R6qWe/iA
Date: Fri, 26 Mar 2021 17:12:36 +0000
Message-ID: <1088f960e04492a26530385040b2485b3691c94e.camel@suse.com>
References: <1616719966-10221-1-git-send-email-bmarzins@redhat.com>
	<1616719966-10221-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1616719966-10221-3-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 52a5165a-72a7-4a74-429b-08d8f07a5a4b
x-ms-traffictypediagnostic: DB3PR0402MB3643:
x-ld-processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB3PR0402MB364321B4738FECF96ED56F65FC619@DB3PR0402MB3643.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 8h4Ff44AlaYzoCco/uFLAC9SZ3FNwRleTkGEnoW0uUtF1rmFI4GObwYE0y3Bwr0qZtGVQoiPmeKCTT3PU8E9N5Ry7T19JGYF4mBIW4y1CB71f/ZGViUNiOVFv3evzY4U1ZtvKBidjVQ+0DEWMroYF9qnAoF0LoRTJ6tp2wA4yBVFZnqoA3thubPJvRQQJ3SohEL1uNVlXojeS9SCKpvFNJk9G38mFmTbJ6XKROqFg9q/bcrG/NfdEGINfxPEMy6Vf7EUF/nepKcHfIDWz3niewEN55Ozgc9AgEo63neC2mMBa+jZfmi7YZRTcoIkwdLLKRTgy3y9igalNq8ZuhmcRObcIDTo43ggi2X8/K+c/+qMJGlmKjt3OZcfVxHrj3kUEUz47rYTD0kIjO3CvjITwi/EAxd6Sq9GJ1O7jkGEPpupDa0YtCbTm+Aq7J7tZ+YWSY5GSFnKlS+dBs+QhQe6f9B9VRlXtG1O4AzVvg4qDSIrn/m2t883UmpWQfHSm09oUh84So6KJMYlVhhDVx0q2klZyQqLa2W4dsBOEnCKuiomC1S8E+ka3FLlQ19EGYZ5QBNzcEkl7Lh5gYq2htmefh/OhHmgtUY5n2RJBBRzYDTdaWOzZF8dfNJMbHpkig/p/VPgJhFP3bV3Yx0gIz5g1nT8B8yr8tFtXXdBpIZE/9JeZ0HqejI9/6WMOiQ+ShU5kLjD64aiYaLuauMFqhuM4Hcw/+gCYB1nuYSzf6Dr/1o=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(376002)(346002)(396003)(39860400002)(366004)(136003)(2906002)(36756003)(6506007)(5660300002)(71200400001)(6486002)(83380400001)(316002)(6512007)(4326008)(8936002)(86362001)(8676002)(91956017)(76116006)(66946007)(66446008)(66556008)(66476007)(64756008)(186003)(478600001)(38100700001)(2616005)(966005)(26005)(44832011)(110136005);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?yBMxn/imK4WpYucX3u9vybN+Pt1EDjaugOY3WhHKNLU1cfgDhvJhpZsDB?=
	=?iso-8859-15?Q?PMC4Dx7VcGZMS44gDqU/HXD7njxgcW5lAKQxOtI1S5Zl3vQ2iqQrcaDqz?=
	=?iso-8859-15?Q?jCvpbz9Yxz6CqIGbryHvtoWs8y/J2WwFESqbkr0j8i19WzhcDLeDi6B4Y?=
	=?iso-8859-15?Q?NTzqEzs81av8Gw32oib2ER6yFKGt0Pu2E/bowC4IgQK45Di3Q9QxK/LT6?=
	=?iso-8859-15?Q?UloN0qxZxH1y4qDJn5SmOYcpvhfxxxAcWQVHm1hl5GP0BltI9fFx3PXv1?=
	=?iso-8859-15?Q?ycGvAXiMXcqDS0qtxKJX/kdeyzgwTY0tMhxj3iP9CHetm43V1LdAZtygC?=
	=?iso-8859-15?Q?Keml7+CEAevdNt/xiWw47ZqdKV/idSXtNU8WrCBrUuujHYog4LVQFQ6fj?=
	=?iso-8859-15?Q?8anAJXNLkKv4qLMeVGURSS26ac6qtVry8ZUodWJ0AtlYV6at4FBfN0nwW?=
	=?iso-8859-15?Q?52BEhTJIVphWuRDVX0pJ1fXusjDgcH9cLxSHSLSvwHDn7Eee6ogplGiuu?=
	=?iso-8859-15?Q?GzktM+2IFObckAVuLMRDQg7XbogqQc4sSI1ES6b0MOXqZ0M6+vfkY8J6v?=
	=?iso-8859-15?Q?fsZWlOsnlMOzZ2sTfDyLBgoK/hzC3ZbteOZlysAmXIRJXWbnQT0SfkXTZ?=
	=?iso-8859-15?Q?h8v7DZxYHHFolGMDW5ciZ2VzSGPtrDHT1HjLPLxwow1sgjMl4ALFjJwqn?=
	=?iso-8859-15?Q?RGfERTTsaJeb4bqMGWhgVmuMUMG0Ii041WP4Rh9JByzzlHetu3/bAZFNc?=
	=?iso-8859-15?Q?t/sFoX/lKc9qS1wtRik0so5Vg3Y2Jbah+O5DAOB74WV8+hAFPpggAb1TS?=
	=?iso-8859-15?Q?kG/dhaD2k09aDOFqtXWYVgq5lgKQn+VO+MQ/VIoFy+StqJQFxjF1gfG2b?=
	=?iso-8859-15?Q?Ghk5AMPA6KJ5gTZk81A6RRSDIyJ4fbAtcasb/Hy+69S5BO+zG/lX/rr6X?=
	=?iso-8859-15?Q?Yi5cI8bFKRxM8lsRcpjEVY+nzDBvRSKyWifEchDMmRSnSIffjWwTBx7gH?=
	=?iso-8859-15?Q?oBbeyVo/caZZUbTY+19iohqUjZ6WgWEgp6wrAFxuguJMXQzKFbjsytvyz?=
	=?iso-8859-15?Q?/PH3qvAyVWFK06MxmM3rPtBgBEqjffKtcI9A4vadB6WboNWzIAHsyIb63?=
	=?iso-8859-15?Q?8OvQSK1r+A+WmeQ1sGUd4q5R5pZZ3FW3Lul+6MwcYTT8MTL6a15bzjpTP?=
	=?iso-8859-15?Q?0mueq/OTBEMWVIqiLWMXAmW3r4HNohqXuy9MwWDybVlmqd4zrCj/xdlx4?=
	=?iso-8859-15?Q?Kgx5TktfiItvorjiLizGQKweCtIWdixHpz/v812b+ljbF+bgq50aXJzqa?=
	=?iso-8859-15?Q?+WT6+VhFUSUsOdyBCaAeo9k/OeZK0f1adfUiRv9E98JOYFQg5Nk9lQLrz?=
	=?iso-8859-15?Q?VxCz8fg3++AGtPycee0aCeFiczYYMKPUC?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52a5165a-72a7-4a74-429b-08d8f07a5a4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2021 17:12:36.2914 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xdU0HB3N4OXlbA18QsuiXVtUkwsZFgJQ8ZVxCVCkRC4v73iOA0kjxnmtAy6ZzghWpZAPx3rRx0kQFS6YN6VERg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3643
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12QHCj0C006470
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/4] libmultipath: fix priorities in
	parse_vpd_pg83
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <5FCE9EB0013AF04A9F52533DA5D74411@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-03-25 at 19:52 -0500, Benjamin Marzinski wrote:
> The priorities for the EUI-64 (0x02) and NAME (0x08) scsi identifiers
> in
> parse_vpd_pg83() don't match their priorities in 55-scsi-sg3_id.rules.
> Switch them so that they match.

I think we should rather change the udev rules file, to be consistent
with what the kernel does:

https://elixir.bootlin.com/linux/latest/A/ident/designator_prio

Regards
Martin



>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =A0libmultipath/discovery.c | 16 ++++++++--------
> =A01 file changed, 8 insertions(+), 8 deletions(-)
>=20
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 5727f7a6..f8044141 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -1152,19 +1152,19 @@ parse_vpd_pg83(const unsigned char *in, size_t
> in_len,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0vpd =3D d;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0b=
reak;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0case 0x8:
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* =
SCSI Name: Prio 4 */
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(memcmp(d + 4, "eui.", 4) &&
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 memcmp(d + 4, "naa.", 4) &&
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 memcmp(d + 4, "iqn.", 4))
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0break;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0case 0x2:
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* =
EUI-64: Prio 4 */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (prio < 4) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0prio =3D 4;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0vpd =3D d;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0b=
reak;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0case 0x2:
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* =
EUI-64: Prio 3 */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0case 0x8:
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* =
SCSI Name: Prio 3 */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(memcmp(d + 4, "eui.", 4) &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 memcmp(d + 4, "naa.", 4) &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 memcmp(d + 4, "iqn.", 4))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0break;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (prio < 3) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0prio =3D 3;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0vpd =3D d;

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

