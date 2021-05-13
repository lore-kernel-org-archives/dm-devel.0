Return-Path: <SRS0=4utB=KI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E108C433ED
	for <dm-devel@archiver.kernel.org>; Thu, 13 May 2021 19:55:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AF4DA61406
	for <dm-devel@archiver.kernel.org>; Thu, 13 May 2021 19:55:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF4DA61406
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-WL3cEzEZOJ-V_cw-_n_I_A-1; Thu, 13 May 2021 15:55:31 -0400
X-MC-Unique: WL3cEzEZOJ-V_cw-_n_I_A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8E62801B12;
	Thu, 13 May 2021 19:55:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CAB73687DF;
	Thu, 13 May 2021 19:55:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A27D418005B6;
	Thu, 13 May 2021 19:55:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14DJtQkr019805 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 13 May 2021 15:55:26 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 09CFC2077FAA; Thu, 13 May 2021 19:55:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 043052077FA6
	for <dm-devel@redhat.com>; Thu, 13 May 2021 19:55:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CCAA100DE77
	for <dm-devel@redhat.com>; Thu, 13 May 2021 19:55:22 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-591-CFr2eHffMpidqQ6JE8pmkg-1;
	Thu, 13 May 2021 15:55:20 -0400
X-MC-Unique: CFr2eHffMpidqQ6JE8pmkg-1
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
	(mail-ve1eur03lp2050.outbound.protection.outlook.com [104.47.9.50])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-24-dl0pHlKXNtGZMvXWApjZwA-1; Thu, 13 May 2021 21:55:17 +0200
X-MC-Unique: dl0pHlKXNtGZMvXWApjZwA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB3PR0402MB3643.eurprd04.prod.outlook.com (2603:10a6:8:5::25) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25;
	Thu, 13 May 2021 19:55:14 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.4108.031;
	Thu, 13 May 2021 19:55:14 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 1/6] multipathd: don't fail to remove path once the
	map is removed
Thread-Index: AQHXSDHkf15Dl6DZYESXJ5gucFqnyw==
Date: Thu, 13 May 2021 19:55:14 +0000
Message-ID: <1619e210afc0f86b0a3779bfbd36a17549bfd8f0.camel@suse.com>
References: <1620926595-12029-1-git-send-email-bmarzins@redhat.com>
	<1620926595-12029-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1620926595-12029-2-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.206.153.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4902997d-5244-45d8-6c94-08d916490695
x-ms-traffictypediagnostic: DB3PR0402MB3643:
x-microsoft-antispam-prvs: <DB3PR0402MB36438B5D86BDF14C51F7B63FFC519@DB3PR0402MB3643.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: zMVhwjn1X1/4jvJrcS9MD33feZ4zOK2oLLjyYiIrQh/ZZ792jyoAoG6oS6WqiOsrHhTmuLy/lW2DivqHGE1tHey2VPNmJD7hfW72otNl6FkIb3xs2DsRCdrd1KSRhiuCoOQSt6FpCiZqCRG7N404FbPVWp1gKMZFjTNW7cxEYW/ebtczW7N9BhAMbibNlBzGpxfZXlJogwC0e6jz/i9uNqiDblcKaKkiJ+CQhm9bmhDCfvljwGfepzZvm6TWpQOVbQULP88i6AtqgWB6bNtbGjsJ1Fzku6poEWgRuYHNZ/SJNjDTqJ4ruRjVleYHXR6Gr3AYLbXq3EyOZr33ARQmyfU5DqlXiO3F1i4NvwZ2GMQcAdKpTvyReriwZGiMkHgZ9fNOq42I+H2IxdL+RTyLQIhKLYlmsSNXsNfIgOeuPr6/SMgErqGiGjHZvfjr6VMfwSSjroWU0QR0vEFD0dKTSHhLyXmq4ZUvrx1Y2lT9fAhOK5tArUqXYV8/rDh/UwQbPHSNmps3Ncfk9TWfo6TbB7VOwd8gpML1j7MNynnPtDRSUQ+RFHxywHZjafu3HH0WlFs+lwHYtoeF9azREUQYCl5jfYjXyOMZNEWM11y4uX4=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(136003)(346002)(376002)(39850400004)(366004)(396003)(2616005)(66946007)(4744005)(110136005)(91956017)(76116006)(6512007)(26005)(86362001)(478600001)(8676002)(36756003)(71200400001)(44832011)(8936002)(83380400001)(66476007)(2906002)(66556008)(186003)(5660300002)(66446008)(122000001)(316002)(6486002)(6506007)(38100700002)(4326008)(64756008);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?3Z/LnwgmK1o+Cogzp6nd3iuz5RZYQQ6s9iDP9wY3B0+CEo7GkijeL5Zo4?=
	=?iso-8859-15?Q?AU6RwJlbn7LlkIKkCbGzzyG6rCfBCREaiwgYtFNteIsrEj8IdUODMSkm9?=
	=?iso-8859-15?Q?GRW8o22XbaoyluuFKMjobbLYw4uywnQQEQyiM2BuYzxxI+GHCWW2fOo1t?=
	=?iso-8859-15?Q?W9L/irMWzhrewI4ADRMWKe4fdCkymZBP4bQV3yqR/2OSnSQs1ynbXznVJ?=
	=?iso-8859-15?Q?r648p+PsQymqb6cADwq/mSqOqwstTnkPr1TE4gXOrUg/ol5cT9dXOT+A0?=
	=?iso-8859-15?Q?HPnMjqaMlX7AekYu4Z9OfpQiuXWF3YFjxCFw733bkDajaLjI9Vl+s4PQm?=
	=?iso-8859-15?Q?CN7f+FH4q58agNPFLQxz53rsQmWIj6rEySm7i1h5SzDi0pBV3+5pFcZrF?=
	=?iso-8859-15?Q?3qos5JABkOCSTYOMSRPP8m+CQUBN0EvKEztiSTQH4ahVJuJiKxruAgCPW?=
	=?iso-8859-15?Q?D3c3kAEhsYF2grS2mrGHahULcESPw0rzCqgqy0LNtxdvYkmGHeuHBGoh/?=
	=?iso-8859-15?Q?eM7uHLAkOcupvmrqifK+adeETjGH4NHswxserarw4MqAIrsQfHIF3ZxRo?=
	=?iso-8859-15?Q?1DC+ZTunmXoNjWc2SWoFqxHZHPzyIOpB4V6cHABUmYiClowGmgcH1jA0Q?=
	=?iso-8859-15?Q?84h9iWC5rQNVcw+LSlSDJ/LQAKe7ic6j90nJIItcCd4VrOwjkQNgmGPtf?=
	=?iso-8859-15?Q?vxFvDSwV9Q3TJnnK4JpG9VoqgR9VJ0gSG2g5Oqdm1T6DSmIYVIgSwqHr+?=
	=?iso-8859-15?Q?wm+6b3YlqwSVEvY9dIngG37zJ62nRtuX5UEivNYu5Hl4yd68S6cqeVoP5?=
	=?iso-8859-15?Q?JABMLhc9/8UITQ+ltH5PYcqKXG8xs/0+mfrZMYtdkJ9hw3IzyiIMCTKYo?=
	=?iso-8859-15?Q?fjlQPYyiVPzmtHGqLROh6QU9nytxFeJbPaqEV5ypWlUIQ1twb6DfDan5r?=
	=?iso-8859-15?Q?H0+LXHtgO9Ni+56dfhPn+9+e8ZlLyq+el/NXmKjA+UDMniKYznLZGxX8O?=
	=?iso-8859-15?Q?ZL8wN2Yyp8IymVR01l5tO+0okZKWowIZ+io/HgjL8jw1RzaTD1RG+WMxA?=
	=?iso-8859-15?Q?dbe7V3kYkoNxO16J0ASbedVA7Xgx6s00BV0yvxFv/LsM4vNN0SQ1zRMrj?=
	=?iso-8859-15?Q?HFGWzBoiaNhRNOfmNlmBhUVz9DzS3tA4Rs2A1923Ie8N4ckWRm4siA4j4?=
	=?iso-8859-15?Q?gaNZEyybAnjfafRjY7t4H/btyvb+SJYgvRnT3acm1Jj6qu6uMA9jyUUPX?=
	=?iso-8859-15?Q?As/RD5HOknex4mC5Yk21cC3WOae8LyoBY0jVZ4YYmSAKqKPbspD8YrLnN?=
	=?iso-8859-15?Q?bPK/s6wsWvvr7kQlOzV/8lCxZMpSBiQjmS9+3S+OuNNeEX/bTZhr7fjKy?=
	=?iso-8859-15?Q?RXcuoj1KQCfci5jNazoRLbETsLbwKkSOC?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4902997d-5244-45d8-6c94-08d916490695
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2021 19:55:14.7466 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tnYkeGQjaWKsxB3lJPP+rHhV4cazDFAByq8huxQBEXBNldbTBYPESFq0ovMou5SXqD6AWM5dwra0lMDzHVooBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3643
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14DJtQkr019805
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 1/6] multipathd: don't fail to remove path
 once the map is removed
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <B1715F808763D14E9CB65767E6CEAF98@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-05-13 at 12:23 -0500, Benjamin Marzinski wrote:
> In ev_remove_path(), if update_mpp_paths() fails, we delete the
> entire
> map. However, since update_mpp_paths() happens before we call
> set_path_removed(), pp->initialized isn't set to INIT_REMOVED, so
> remove_map_and_stop_waiter() doesn't remove the path when in removes
> the
> map.=A0 But with the map removed, there's nothing to keep us from
> removing
> the path.
>=20
> Call set_path_removed() before update_mpp_paths() to avoid the odd
> case
> of ev_remove_path() removing the map but not the path.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

