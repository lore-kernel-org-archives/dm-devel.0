Return-Path: <SRS0=mjIs=PY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A953C433F5
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 20:13:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B109961076
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 20:13:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B109961076
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-B0ZhViFRPpqXMbLoscK-CA-1; Fri, 05 Nov 2021 16:13:22 -0400
X-MC-Unique: B0ZhViFRPpqXMbLoscK-CA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA7951006AA3;
	Fri,  5 Nov 2021 20:13:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A5E4670911;
	Fri,  5 Nov 2021 20:13:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3BDF81806D04;
	Fri,  5 Nov 2021 20:13:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A5KDG0Y020563 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 5 Nov 2021 16:13:16 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E3F751121315; Fri,  5 Nov 2021 20:13:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DE8F41121314
	for <dm-devel@redhat.com>; Fri,  5 Nov 2021 20:13:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09E3B18E0042
	for <dm-devel@redhat.com>; Fri,  5 Nov 2021 20:13:13 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-153-y3HDN-a-OLKt_Bh1Uj2G9Q-1;
	Fri, 05 Nov 2021 16:13:09 -0400
X-MC-Unique: y3HDN-a-OLKt_Bh1Uj2G9Q-1
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
	(mail-am6eur05lp2105.outbound.protection.outlook.com [104.47.18.105])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-14-IV2xoGGiO2yZM9W9NSh74g-1; Fri, 05 Nov 2021 21:13:07 +0100
X-MC-Unique: IV2xoGGiO2yZM9W9NSh74g-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB9PR04MB8346.eurprd04.prod.outlook.com (2603:10a6:10:24d::10)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13;
	Fri, 5 Nov 2021 20:13:05 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4669.013;
	Fri, 5 Nov 2021 20:13:05 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH 6/8] libmultipath: improve checks for set_str
Thread-Index: AQHXuu1p2RKByrtZakKWNdsnipSlz6v0ANUAgACulACAALR8gIAAKVQA
Date: Fri, 5 Nov 2021 20:13:05 +0000
Message-ID: <d02f2f1e145f54a30438d7006c7f615f8e7506d3.camel@suse.com>
References: <1633550663-25571-1-git-send-email-bmarzins@redhat.com>
	<1633550663-25571-7-git-send-email-bmarzins@redhat.com>
	<5424c4163d1fee71af3f1126adc2a59d3069b09f.camel@suse.com>
	<05b1d72f805515947ea21b9afd43446de6a2c7d6.camel@suse.com>
	<20211105174509.GJ19591@octiron.msp.redhat.com>
In-Reply-To: <20211105174509.GJ19591@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 01b9389a-3ffd-4d76-e1a2-08d9a098ad80
x-ms-traffictypediagnostic: DB9PR04MB8346:
x-microsoft-antispam-prvs: <DB9PR04MB834677788D8F075A653C2A58FC8E9@DB9PR04MB8346.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: t+x3qf92ClmKxsHJt2L3O1cvTFUGqB/AkS7JLtEzlTlL8PizClDi+3AGddI3wULWXOrgUGaiKOr2nzuDcjzkxY4P0xkkj/RxLwZ/twPPTnRO9gIHBDMwe0b2P2S85fZfObqzGR1CJQSeTerK5cXdgjevNE3V4113MGB66bMyx0m5cCj0aN5WKFMFuf8wK/ehKoreP3rKlEPpZEd+xhqp5NKhWFPVE/KSf8Eq3HGRYEfnQ6lzsvq3Ex7wQpsTm7fIBfm4NPzcrmkjzI0tR/dy2T+w+NVEdCVd3NmonsNXbeiZByBvKcaTzCpVKc1pykSgG3AFQz1N+p+mvgYtDbPvwuvMvGJxXF31ZLrCWsOiE0K5OtZVM25h2D8XHgrZpWj/GGnYwGon6AfSvgrYK3z2r5XaqOTFs6uLqqMW16Ay/88lDHKM1ruLfTwPl3vl7m8Vn6AamGNFHngDiFuSuewTIBfaHikqXzu8kEGzBvduW4A9jjQTuzafcj8sfoSa/Z9sKSq/LUnWtwCd2qQnF3cFAwLaIQQrW04ihTiYiYIQhdCbBNO7ZJiIPjdj5B8+LlwGsQwA1V9CalcQ+iwsEdGpTeys4e0gsE8Wzf6sSjwejBNLIoLDsjQ5FuU7WWQ66l+mCz9XO6D3L6JXxKT6bqNOVgJEWQy21htFPk3TlQob6SnO9oL2nwbFf4aWhWsDN7WFYj8p6pzNddGUz8ANoQnBnQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(8676002)(6506007)(122000001)(38070700005)(6916009)(38100700002)(508600001)(54906003)(8936002)(2616005)(66476007)(2906002)(186003)(66556008)(5660300002)(4326008)(66446008)(316002)(26005)(64756008)(83380400001)(66946007)(36756003)(44832011)(71200400001)(86362001)(6486002)(76116006)(91956017)(6512007);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?u3SmldpsDjwSi6MRE3Rwz6OTbBHRia/qR/lPssj5wnpmrnYDokzD5Bl0N?=
	=?iso-8859-15?Q?yrvrmHOC3uzDGEwh01Z5A5hT7A5WRKSivERNtW1GxlDTgT7VBr00lP1zU?=
	=?iso-8859-15?Q?ZvQa/jwD+egT3tDaTwBFm8e5AJx4iMjJ9vwBwcDgETukG8giFa63F2IAC?=
	=?iso-8859-15?Q?ENxN85jLBavPE6YhF2aZx9AahlDQvDQ6YxRIzkqRlOOvckvkdi50Kvq/x?=
	=?iso-8859-15?Q?S01yXG8BOkgjTEOQyDCAvYIBT9dy5bY6dCz3mPCD+NeHp06c3bm3leD4m?=
	=?iso-8859-15?Q?WT2q0MiJY2Oks1Lz8VwrgRcAtkDHaoeX9hRKeQtkWcFZZWtpjeZDDsYu5?=
	=?iso-8859-15?Q?Sgl540yHnby0wqMtzgReeZQL33bFDTWz1nqESwpQz7irXsKf/6649iZqO?=
	=?iso-8859-15?Q?nyQtCKjoaQi+cokD6KuCCtvakwnZeqm6hnH8ETf1Y5rdUTSnWa6CTcpTY?=
	=?iso-8859-15?Q?TFJHxrAmJ1MUOZgpuNP2foOXUnLjnzIU9yx+P/ppTmJiO8fQxgJ5z2k/3?=
	=?iso-8859-15?Q?GlzNLs5fti2V/Xsm1LgX+eZwqVRR8egE+l8v7sBZ5k4isJS4BJgJj9al1?=
	=?iso-8859-15?Q?j3do8D38aKe+gF3hoild1OEZgUYwjT0Fvx4Aip9efZXJyWcxjRzt+LaTg?=
	=?iso-8859-15?Q?YIyn8VDoiwemZz6Tq59GEaZoKfeCfGbUYfU8XgIy3idC1A8iRxtDLNuVX?=
	=?iso-8859-15?Q?0CYQrau0qund/kc4xspYrlyhS13Q31O/eMNqSSmdDp1CUsVwZ/Sm67C3x?=
	=?iso-8859-15?Q?0FXp9vly/P3k+W0s0cWNUXX5bPINbbqUhsc42X3X7W4fDESYuhRZckFj3?=
	=?iso-8859-15?Q?9qVWKZL5k6IrYCg7qdNhFKPH59YavVOFIrZ3Z1Gf2xWYq4EkT/ln5Q50R?=
	=?iso-8859-15?Q?Cq/eEo+hFw/Dn+a/BbLSQAYQcboxflOU7m/Sn+EilvJVxdw5ds+78jDTa?=
	=?iso-8859-15?Q?1NeQiWdKM4IzeNlS4G+ZS0kCsp+6IxoDpZPKqPQaCqmNWAF/w964+arW8?=
	=?iso-8859-15?Q?o/9Ib0uI7aY8WovlOti2zuzd7Pkuad4mHGSJ1bvtThQJRknrddY2ZzrBu?=
	=?iso-8859-15?Q?y3fcU8QTEtFiDypHb+ni4uNgNssFsOVJeaNJ66zq09ZEyvI64hOnw74t5?=
	=?iso-8859-15?Q?AHFVpePp6o7yty3xNgJ8MbGWNl4Zone03WqlnMTDsnklFieSihLVP7eNv?=
	=?iso-8859-15?Q?LmdF0KBkTaBQSyZ9IoskT/l7wQj24+H4fCa3UNdx0LS6CLqUDVdTVzdy5?=
	=?iso-8859-15?Q?McZkB/n6Lh4NI6OaQWQI4EgyK+p4E3y9upZJj4kmv5GhOgbWb1cEj+oGM?=
	=?iso-8859-15?Q?PYM3qr5g0cD1+iP8wmbgZhkHPSXQF218iQ00Yf/cE5Z1ORCUE1Bm7ZfIb?=
	=?iso-8859-15?Q?TqJ+xz4MpZbLVtL1ZMHp/RC7+vqley4z4Go9ZfLFAxt6zUJDdECoplv+Q?=
	=?iso-8859-15?Q?L7P/BNDIMCeYU1qzsZ1desmuL3NEICpHaKybmXf36C9UZYRnsqMbVwXsl?=
	=?iso-8859-15?Q?ofXael0IQTIhgvVQl0vnaWcG3xM1cPQnnrNJpWq+oJRZDgBxItHZUxWOb?=
	=?iso-8859-15?Q?nfiO6/fBaDV9OL5wF2rFG3CURZb4GtGIAXaDjHXgCY7zRbVUzbXFZQeM7?=
	=?iso-8859-15?Q?+ww42H9Vf38X/mxooFbMnTLxE3AqRRitm57wOpIFMa6vZKovXqIxvGLAy?=
	=?iso-8859-15?Q?4lDmcAACRLYM2edfsxwjDcfc4uQzk/BJjoCngUD7wPKwHL8=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01b9389a-3ffd-4d76-e1a2-08d9a098ad80
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2021 20:13:05.4884 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gAzIRKaaWuAu6DuVKawSdpXadGdZqoMoRperLMV3aRCEwGBXSEQcDhLq54zgGM3Y/q+3vx1L9xw6xlbk4CPvgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8346
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A5KDG0Y020563
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 6/8] libmultipath: improve checks for set_str
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
Content-ID: <91C0FD4DF091364E90E72356C9738E43@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, 2021-11-05 at 12:45 -0500, Benjamin Marzinski wrote:
> > 
> > I've changed my mind on this one. The options for directories and
> > paths
> > should be turned into buildtime options instead. If we do that, we
> > don't need this sort of checks any more, except the "noslash" part.
> 
> That seems reasonable. I do want to ask around a little bit to see if
> I
> can find anyone who is actually setting the directories. The only one
> I
> really worry about is "config_dir". I worry that people might do
> something like stick that on shared storage, to make it possible to
> change the multipath config on a bunch of machines in one place.

Not impossible, but frankly, that sort of setup would be typical for
the mid-2000's. Nowadays people would rather use something like ansible
to distribute the configuration. (*)

For us as distribution maintainers, these arbitrarily configurable
paths are a nightmare.

Regards
Martin

(In my testing and playing-around routine, I actually rely on the fact
that it's possible to set a config_dir that doesn't exist. Under normal
operation, it doesn't - if I want to experiment, I just move something
there. But I think I could easily live with built-time settings).


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

