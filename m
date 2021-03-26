Return-Path: <SRS0=sRxI=IY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E87A7C433C1
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 17:16:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3DE1960C40
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 17:16:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3DE1960C40
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-8rjDNN23N-WRoraaMtZVCQ-1; Fri, 26 Mar 2021 13:16:18 -0400
X-MC-Unique: 8rjDNN23N-WRoraaMtZVCQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F25B21853028;
	Fri, 26 Mar 2021 17:16:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C9F3B2BFEB;
	Fri, 26 Mar 2021 17:16:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 694CA1809C83;
	Fri, 26 Mar 2021 17:16:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12QHFwYJ007915 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 26 Mar 2021 13:15:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 63C1F2026D48; Fri, 26 Mar 2021 17:15:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D1292026D07
	for <dm-devel@redhat.com>; Fri, 26 Mar 2021 17:15:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C76880231D
	for <dm-devel@redhat.com>; Fri, 26 Mar 2021 17:15:55 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-32-yV5rFRfhO_CsGKY997pSmQ-1;
	Fri, 26 Mar 2021 13:15:53 -0400
X-MC-Unique: yV5rFRfhO_CsGKY997pSmQ-1
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
	(mail-db5eur01lp2059.outbound.protection.outlook.com [104.47.2.59])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-19-6oYgQLVHOYC9UFJDZOj6fQ-1; Fri, 26 Mar 2021 18:15:50 +0100
X-MC-Unique: 6oYgQLVHOYC9UFJDZOj6fQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBAPR04MB7286.eurprd04.prod.outlook.com (2603:10a6:10:1aa::6) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18;
	Fri, 26 Mar 2021 17:15:49 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb%7]) with mapi id 15.20.3977.026;
	Fri, 26 Mar 2021 17:15:49 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [dm-devel] [PATCH 3/4] multipathd: improve getting parent
	udevice in rescan_path
Thread-Index: AQHXIdphVkwn/x+/TkyxWSDbU40WaaqWg56A
Date: Fri, 26 Mar 2021 17:15:49 +0000
Message-ID: <b24ce9c178b04d7e38f3ea3b77e62593df7e3164.camel@suse.com>
References: <1616719966-10221-1-git-send-email-bmarzins@redhat.com>
	<1616719966-10221-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1616719966-10221-4-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bfebf1f9-3fb2-4003-3b89-08d8f07acd37
x-ms-traffictypediagnostic: DBAPR04MB7286:
x-microsoft-antispam-prvs: <DBAPR04MB72860C09E869D6BCDA1DA7B0FC619@DBAPR04MB7286.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1091
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: JpCZde+7y4HySQ5DGL/Fc25kYEpzemUqt1blBTRUecIcmmj/QIeNdyYXBU05ALZkA412GGx7gGzba1RAj0BMJIgJIuTPWWtXmfRk3fxg1cD3kOK1c2GqqQsChbfGo8f5VZpUO9ZKPPyRfAF41zcRPCu8Q7k0jYWBviFuqarxYX4MaggCLscnjqVpwvDPsSfS6I26MkX7buBXuk0g02nGUkB9g7kXYf4niqle0TyhXcPkbZLilAE2ANI7ei8nnXH7jtX3esBns08sc2YmS/85V0TnVVtbfP5sPX90lvadJgLmM+BoS2cbzarBhI+UnNLB+prinJdRTm6ec1l5YJXBY8TMKLnrUoWDBUxQ8J17wtJoqOKc8NYAzqbI0Uzz84Xzma0cUUWtrkeZWJCuX49p3vdjHsGD8AreYAp/m724n9jAKQTy0mMK9f8PqDPqaVC8ZKZ6Bacwki0YG4OU880orKpN4M3ZUubhNVbwKZBDGKHjlHrxkcoCpyw90pkB4SqhGQVxWUP+EBXaBZLCP41G2d5BnTMj//12e0OQY4Z0w83h8Zy9cTpX8LFtP96gD13amER8pjzS7bFm315m1S9d9AI+ZIsEWcUrJD/k7WxqtMT2ko7ba3cafgWsddNeXwA/dfQE05kghKnaD8F0ShWq6uFlKwAovPjYlz8ujSSuNFI=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(396003)(39860400002)(346002)(376002)(136003)(186003)(86362001)(4326008)(2906002)(2616005)(316002)(44832011)(5660300002)(64756008)(66446008)(66946007)(66476007)(26005)(66556008)(8936002)(8676002)(76116006)(91956017)(71200400001)(6506007)(6486002)(110136005)(478600001)(4744005)(38100700001)(6512007)(36756003);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?9W8iILJvNm1CP7vJ5/Osi3dWN5BouQxLo4WWCgyqisz6IT5gmf+5R5hDw?=
	=?iso-8859-15?Q?rYEZufGR08fM3n2A21B8OfF4U11hD1YfNStR0VRkh9bPnNfvAy4EI4jpt?=
	=?iso-8859-15?Q?DM2hwr6sWzdTVve/jGiITc+9myEZj3gC/PgF29rwABiIaV8W3VNODZrA5?=
	=?iso-8859-15?Q?6TlH6hlpvF2cHZ/zduOFKSsCPZvRIND9SI/o2FieSAIA5xOWzYvJgFl71?=
	=?iso-8859-15?Q?dCxh4DYTHPchcxe+mv06I9ax0mMFAr45/KJlt/3wGtpuGkkgjPC/e14c9?=
	=?iso-8859-15?Q?M5xgo28/ovJrFk0Qt/o4LMXblXsk/NnKDhQv7YtcXyM6f/EzZ5/Fy9bwz?=
	=?iso-8859-15?Q?In2eXfADBIvjWUsGcPC3S7d3ZPGjQn+McDXNCzskgfHL4pDoQIwsLyJ/e?=
	=?iso-8859-15?Q?DDANPYY+RI20epmSYJd1bzeU0+Tj8QpJnYTsT9V7bA5B4+xKEyHYlyK+J?=
	=?iso-8859-15?Q?wlHy2tjsFznbgeC3ueNMi7+EIdtfzm9d26WLYgUQk7hU24DydjkiiQaeL?=
	=?iso-8859-15?Q?G7U9/9pjrao++lTBHeW6KItU+ZQFdOJKPLSnomwc6zUMTqSJm2ADOHN3h?=
	=?iso-8859-15?Q?TVC1BPB7yhitmFSbpbMZhN6fBnrENkNUoYe3rAeD/QJk4ITsPebPEpCDJ?=
	=?iso-8859-15?Q?41QO+oUIOMLecXN0dSOqMpXMWOviHo+A8SvULfv+G5ociuY1GXe1rnSTT?=
	=?iso-8859-15?Q?v5aEkIIoBLiSwyNFR/5pWjmKCjFzblZXUFZCQM76Ggc/itAZd7d2QuO8K?=
	=?iso-8859-15?Q?d44I29g6R8iAirXNIlSAAnM61AQULSzrL9JwslfGjr9sfELaaqQRljyU4?=
	=?iso-8859-15?Q?MD1OJlV4Pv52O7IMvK4kcNS0u9lion13VKxjqYj3fz/svzjMOE+oDiThO?=
	=?iso-8859-15?Q?paQmq43wb+KM7Xo8M0yetR5ia0Jr3HMBatjQTFjPXRv42BxJfpXx2MBo/?=
	=?iso-8859-15?Q?EysBEuHd53H69nSu7omkzCZIUwwXknb9W5d4eKueduzXns1HOLzAXjEw3?=
	=?iso-8859-15?Q?ph7mBdP1IIDglbA3rti1BC/IOlGNimliV6J2cV93TpcinmuTJptzgxVYj?=
	=?iso-8859-15?Q?SANBQhp4nMKySR7WHc54Pssc8HKNK7FzFZmUvMOIKqLjghZyV6SAkUvBM?=
	=?iso-8859-15?Q?BU1EZmyHhttGFzPF4fqLTeftyWI70kbJ/FlCdqbDsrSgh46PYYzBBTYll?=
	=?iso-8859-15?Q?4af0y4depdRsSM4Vs9CxieEXkE1KI6jOWXBQtVm7U1A4LKTUgKIAfX61V?=
	=?iso-8859-15?Q?T208VlXB0iXokye9d6QuBhmrityrBdHYL2USZgufCI/CBui3B32dq3KXZ?=
	=?iso-8859-15?Q?IweB/9iUDqy8/ffmF/4c//XRx7zVBWSOtLGxLk33YtBsy6UBHahfoJWHV?=
	=?iso-8859-15?Q?st2r9Cn4sjWrba+thINkwl9VZRtKfzv11?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfebf1f9-3fb2-4003-3b89-08d8f07acd37
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2021 17:15:49.1001 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gDKJ3oK4LtTVUB+pwG413iHmUf9bxJ7CHqbWCqFxSeyhtXEjNnhjo/vnwK6QQmJHPdeB+SZPNKLTU7csaq50xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7286
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12QHFwYJ007915
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 3/4] multipathd: improve getting parent
 udevice in rescan_path
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
Content-ID: <DE94D2016CD7304DB0506E7B6EEA3912@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-03-25 at 19:52 -0500, Benjamin Marzinski wrote:
> Instead of looping through parents and checking, just call
> udev_device_get_parent_with_subsystem_devtype() to get the
> right one.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

