Return-Path: <SRS0=Y5I9=I3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE6A7C433C1
	for <dm-devel@archiver.kernel.org>; Mon, 29 Mar 2021 19:08:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5FACC6196E
	for <dm-devel@archiver.kernel.org>; Mon, 29 Mar 2021 19:08:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5FACC6196E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-o0rTD_rsON2k9Vw7WBG-nA-1; Mon, 29 Mar 2021 15:08:36 -0400
X-MC-Unique: o0rTD_rsON2k9Vw7WBG-nA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07524180FCA7;
	Mon, 29 Mar 2021 19:08:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A822E100239A;
	Mon, 29 Mar 2021 19:08:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 05B54180B451;
	Mon, 29 Mar 2021 19:08:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12TJ8OEM008175 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Mar 2021 15:08:24 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7B2372026D07; Mon, 29 Mar 2021 19:08:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 74F152026D7F
	for <dm-devel@redhat.com>; Mon, 29 Mar 2021 19:08:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE370100DE78
	for <dm-devel@redhat.com>; Mon, 29 Mar 2021 19:08:20 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-271-2TNn66N2P96QqVNxYMlLqg-1;
	Mon, 29 Mar 2021 15:08:18 -0400
X-MC-Unique: 2TNn66N2P96QqVNxYMlLqg-1
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur04lp2052.outbound.protection.outlook.com [104.47.14.52])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-28-474xVNrgN1WUGRvGbsKygQ-1; Mon, 29 Mar 2021 21:08:16 +0200
X-MC-Unique: 474xVNrgN1WUGRvGbsKygQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBBPR04MB7802.eurprd04.prod.outlook.com (2603:10a6:10:1f0::20)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25;
	Mon, 29 Mar 2021 19:08:14 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb%7]) with mapi id 15.20.3977.033;
	Mon, 29 Mar 2021 19:08:14 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH 2/4] libmultipath: fix priorities in parse_vpd_pg83
Thread-Index: AQHXIdphHMXt7za5/0CjNSBmSMx0R6qWe/iAgACfY4CAA5B5gIAAoOGAgAANUYA=
Date: Mon, 29 Mar 2021 19:08:14 +0000
Message-ID: <facc763d175793d4d21822f8880522574364680a.camel@suse.com>
References: <1616719966-10221-1-git-send-email-bmarzins@redhat.com>
	<1616719966-10221-3-git-send-email-bmarzins@redhat.com>
	<1088f960e04492a26530385040b2485b3691c94e.camel@suse.com>
	<20210327021853.GI15006@octiron.msp.redhat.com>
	<31162621ac38601976bfa51db92989471fd4c23e.camel@suse.com>
	<20210329182033.GJ15006@octiron.msp.redhat.com>
In-Reply-To: <20210329182033.GJ15006@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a13a80e4-6e39-44ea-b9cb-08d8f2e60124
x-ms-traffictypediagnostic: DBBPR04MB7802:
x-ld-processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR04MB78026DA39C65FB2264697604FC7E9@DBBPR04MB7802.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: N3K3k0YwTpRxjRHvq0qnLTINQdhzK9SeI4GGuvXzHcEWYr9Ku/d3btxYdm1TREGu7+0FSceeLHmIbUfN4l8PYB/BwlWjMFe+GaePLOKN8ps/Ed0NRwS2tm9hJ3vaHPnvunyVjVcdwZXZf90umUJSbmdBzoXlSOTjvQozA14seReerSfAaRkdvWnbkoRaBoq89KWedNW89vV4nT0/z/ErW1nSwwLXfu0de0oc1z2k8Q4rPT+m29krg/s20MeQ3NwP+uczmXKnbBVyoxfwLrwXg4jPzG/82hQU8/G8qHi+qsvlajBuvyc3BGKOQjRdAm9+p+m8FdhaePbplzH99M6r7LdFXenatBbWRWt20TWNT/WN8n+DYU8Y9LS5USyxhrl/00f0+8BdZkFzBFP/BO/Cw4Vp2dbLnaH4ylYyY5wIAG1KKp/BCR2U5Bsq8g/+HHjp8SfzwjHQUpNafUEdgpKoJVDZtjRUdcXwhmyE45900V2dvFH30JYZMlpB1ifaV2fQgI01bQSAYuAPaDiNj0tSI8UENUvYnzIxSvAKFsIi/yYEkHJ6SvL96Pz3lk03QQS2ZsD0DOgWsv07rgPr6a9m6e90feBADNVRfVX/B2AkU9qrlJGNadYxfbQnHeO+q9IJVJG8LvI07cLQCBPzV6Jx6khphE2/3AeCI8dmtjJ4to4=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(396003)(136003)(376002)(39850400004)(346002)(366004)(5660300002)(64756008)(66556008)(66476007)(66446008)(66946007)(76116006)(316002)(91956017)(83380400001)(86362001)(8936002)(2906002)(2616005)(6486002)(6916009)(36756003)(26005)(186003)(478600001)(6506007)(71200400001)(8676002)(4326008)(54906003)(38100700001)(44832011)(6512007);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?d3cy/zCCKUNQyIJe1FFO522uMS/JBZdciKz69ac+EHAg47KEvh2W3wvTK?=
	=?iso-8859-15?Q?kxpFi3CZwY6vtHVF/wZpI94cDazUZR/Xv7WXaJs5Du3H6ZYjl9aTugjWV?=
	=?iso-8859-15?Q?WF5LcfqlGq/A5+VjigNTWrVGDRIg244WzdNp0imSpg7EXcSjPIjt+29zH?=
	=?iso-8859-15?Q?9Y2SIJYID/mXCrQSMa2SGIaGz3QSE11jySit+AZwyRJK9v67pKVWl99iv?=
	=?iso-8859-15?Q?smhECeq1PAnVeRRT5Izm2N+CHZYJrC/10GbdLU1+c1uD5VT6eCFqPeIeS?=
	=?iso-8859-15?Q?CsUxzHrraBV+T1EY/fLEvVJ2LNwIBs3cN+fnMYYH02pRrV4vzR6EegLIu?=
	=?iso-8859-15?Q?F8/0XDHRPY54XbfcppciVAi6srZbmUPAG1z8JuM+IU2bivpr8T800YFpr?=
	=?iso-8859-15?Q?3MvF7AvCSduZ6twcyayjufFiHFaI6tfhvzM34Wo6z/N3tTK/ZVhzNucCI?=
	=?iso-8859-15?Q?I3enTA1TxFKWajy5ftWZ/v2G3SuVU5NqAVqNUkt8gYhl0sNf2hXKuoeJs?=
	=?iso-8859-15?Q?+OPAJjXWIe/0zfS6mcc6NR7slUjoXBI4B6Kp6JWT/osITVwqaI4D0qLNi?=
	=?iso-8859-15?Q?sc/7KzbPmIPPJLlhDaqws8Oql5ZxgfUuWDqG/16U1gqNS6a3lVPrtxsJh?=
	=?iso-8859-15?Q?v4d9pFY013f1hUK7rlaR8EUbaDOoR6MsZ6cLXq418jWkaKHG2Ut0CnE5p?=
	=?iso-8859-15?Q?CbK3QULZO2jMW7/Ph148EO7vN6i8gZjYIpOJBDL1jxEJjkVJkwCkf3JnC?=
	=?iso-8859-15?Q?zF6vBeR9FwnQBuInae1k1VbbXZZU1IUMtUkZtT0/Mfb9A2A1laA2ZY2lL?=
	=?iso-8859-15?Q?8x4x1DdqBvb2N5yBN4dbMbWk3vcpfKra7rE560qoq+m8M3pj6Iic530he?=
	=?iso-8859-15?Q?D/MyTT/6IMKdQFVaPBwsidRQTf2O5yl8QLBkb3xFJLjXnaOx+6RgxoMzV?=
	=?iso-8859-15?Q?pSGkr/BqfAelyPv2Rgrl4t6eHYH3epGGg2HDHnxdAp2CG9pCDj5A4g4bp?=
	=?iso-8859-15?Q?B9ap0yawnpMlqy1IejYRvF5inr009koYvQ5DWmP1BjAxPgHUwNnldCE9r?=
	=?iso-8859-15?Q?z07hxD8G8sr29KcyjJR/UPWxpWHYQJmUJSSE2K/Ac0p+sDQlw3NiReJGG?=
	=?iso-8859-15?Q?zjwQuduR7tJ1RI6T0UJxe/O6eB0eJRVtrsH7pIF9hRebfNtHrsGIIv3vM?=
	=?iso-8859-15?Q?Ja07aTLFVGOhg2TrCQWh3QztCrqSHvla4ToEpNKFxwi5AZNEpnYdt/Ql3?=
	=?iso-8859-15?Q?/S+A7tSfRSUIUWFh+ULfIkNjVd0mSnDGQoLCwtx0a5k6+95YJ0cMBCktG?=
	=?iso-8859-15?Q?hS/Tw9nvPbX7j8YVgZTdoa0ToB8tVUU107Z4ffk/DxGMpeowIsYMn+j4o?=
	=?iso-8859-15?Q?VSz/Yn5oRN7fhsSYfdYUiiRRV43j2rKoG?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a13a80e4-6e39-44ea-b9cb-08d8f2e60124
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2021 19:08:14.7429 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bPDSuWxjKYf+nOyK1JaL6syaXU6VvqrC7XL1uQE1Oh/GZz6wNDkHslYgIWHQUnrzR5bB+mst+JODs9mkwRdN6A==
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12TJ8OEM008175
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	Hannes Reinecke <hare@suse.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <1754535B1CE0D2488742D2F009316AD8@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-03-29 at 13:20 -0500, Benjamin Marzinski wrote:
> >=20
> > multipathd could figure out the system configuration from the (non)
> > availability of certain properties, and use an appropriate fallback
> > logic for either case.
>=20
> That seems like reasonable first step, although one that won't help
> SID,
> since it can't rely on getting the wwid from udev.=A0

Can you conceive of a different approach that would be better for SID?
I'd like to hear about it.

>  This actually brings
> up a different point I have. Is your main objection to adding more
> config options that it is complicating the code, or confusing the
> users?

Both, with emphasis on the latter. I'm quite positive that we have too
many options already. That doesn't mean I would generally oppose new
options if they make sense. We should rather try to get rid of some new
ones that nobody uses any more.

> Because multipath wouldn't need to add any configuration options to
> be
> easily usable with SID (the current workaround, setting uid_attribute
> to
> "", is pretty non-obvious to users) if it could just check if sid was
> running, and key off that.=A0 However this adds even more code
> complexity
> than simply checking a config option. I don't know how you would feel
> about accepting a patch that does this, when SID is production ready.

I could live well with this autodetection. I think it would be better
than doing the same thing with a configuration options.

Regards,
Martin


--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

