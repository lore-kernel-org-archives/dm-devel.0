Return-Path: <SRS0=fKNG=I5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95DE2C433ED
	for <dm-devel@archiver.kernel.org>; Wed, 31 Mar 2021 13:33:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1ECA061987
	for <dm-devel@archiver.kernel.org>; Wed, 31 Mar 2021 13:33:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1ECA061987
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-XzW1_gU9O0KPOOx0gtAvmg-1; Wed, 31 Mar 2021 09:33:08 -0400
X-MC-Unique: XzW1_gU9O0KPOOx0gtAvmg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54B45108BD07;
	Wed, 31 Mar 2021 13:33:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 22AF210016F4;
	Wed, 31 Mar 2021 13:33:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CCA4C4A7CB;
	Wed, 31 Mar 2021 13:33:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12VCfHof028166 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 31 Mar 2021 08:41:17 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 415952026D64; Wed, 31 Mar 2021 12:41:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3AA3D2026D7F
	for <dm-devel@redhat.com>; Wed, 31 Mar 2021 12:41:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 69BD0805F43
	for <dm-devel@redhat.com>; Wed, 31 Mar 2021 12:41:14 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-72-iGtRUKxrMhiU6EzX-DAlAA-1;
	Wed, 31 Mar 2021 08:41:12 -0400
X-MC-Unique: iGtRUKxrMhiU6EzX-DAlAA-1
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
	(mail-am5eur02lp2054.outbound.protection.outlook.com [104.47.4.54])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-1-tllA3xUFMViha84DpmUiyw-1; Wed, 31 Mar 2021 14:41:09 +0200
X-MC-Unique: tllA3xUFMViha84DpmUiyw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB4747.eurprd04.prod.outlook.com (2603:10a6:10:18::12) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18;
	Wed, 31 Mar 2021 12:41:07 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.3999.027;
	Wed, 31 Mar 2021 12:41:07 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "erwin@erwinvanlonden.net" <erwin@erwinvanlonden.net>,
	"muneendra.kumar@broadcom.com" <muneendra.kumar@broadcom.com>,
	"bblock@linux.ibm.com" <bblock@linux.ibm.com>,
	"hare@suse.de" <hare@suse.de>
Thread-Topic: [dm-devel] dm-multipath - IO queue dispatch based on FPIN
	Congestion/Latency notifications.
Thread-Index: AQHXH8ZRsvMl6pS9x02jEI+NQfbmHaqU4l6AgAFApYCAB5ulQoAAKk8AgAAORwCAAA/hAIAAAiQAgAABQ4CAAAwogA==
Date: Wed, 31 Mar 2021 12:41:06 +0000
Message-ID: <5a0f7c60adbad68fc1df91e1a6c192fab04b66fc.camel@suse.com>
References: <5b87a64d88a13eb8b4917a1cc0d35691f9fc8227.camel@erwinvanlonden.net>
	<YFy1Q6nvJEcRzwyl@t480-pf1aa2c2.linux.ibm.com>
	<b3025c4bf84fe357712fa0fe32bfa3e9@mail.gmail.com>
	<2c6ff107ccf5f0589520ef124cd9ecc4cdcc355e.camel@erwinvanlonden.net>
	<8966fcda-b1ca-5d50-398a-13195dab3c44@suse.de>
	<4fff162d56dd8eebaa7d13be9d6ff580cacbe15f.camel@suse.com>
	<30cb8c2e97ea8303ee1dfef8a4c34599@mail.gmail.com>
	<7b7663da1edf9fcb3e2515e41602ab68de02d2a9.camel@suse.com>
	<0419387c-071c-2c5e-79f4-8873553e5da3@suse.de>
	<c661804f254c8dec17b57c6b95f0fe05@mail.gmail.com>
In-Reply-To: <c661804f254c8dec17b57c6b95f0fe05@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 42a8f298-8f6d-4341-5ff1-08d8f442412d
x-ms-traffictypediagnostic: DB7PR04MB4747:
x-microsoft-antispam-prvs: <DB7PR04MB4747354384113CA413576ED3FC7C9@DB7PR04MB4747.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 4BI4r8dfjNdasjkMoZaLh7F158LR7nzV9d+KWjoSrPYugg29aSRk9szJf81t7Z6r2trOXEwj9nhMgr/ZNiOpK7SCm9WHRXt6ob88bPwUWFVz3uVTwiEoz1fDLrSNxKDfXfI6MeVWLnp8+kjmar2jSX+Myx+aMuFyjkkAcXjQVAkdVQuindNrWSsaW4k44uYRr41sNeUv/Y1QoHNh5va9/CSoB5BY8N70T1X8OdgYfEbKq1lpsNd5Zi1pet0Lb0j8P0UUURzvJmzZWiY5yjNcDsE0IQ8tzdUlOffbyHuOAVo2m1+7dfaHYQbkd7BaeTllZ/JdyEf8tY4g3AtmhVzITV5qzTHHF77PEUcVg8dL4WASPNmH6iFSFTo3wppPITtF7HBRsknPC2GsNZAFprHpE4ygdh16sIwmj35nc5011BeHJNGVHeyaVsO0q+UyKUW3LNalw2XhlaSmZ5E8EbQ/xfQ13LcSLv5ctyjo+aTEmjy4UI30It6vMpfZZdWxJeUGGlXaOSbOiQC7Ydf5mUIKa1prW03Z5nC4ttSocvRzizCTZAwzM4rYyGgNdslxo5Wn/Xb62EQ1f+tSBPb3DrxIRzE1VakDef2cGJWYwnWinnyJPIYSI5O4iPY7JGQrrgsafkrdH0CMSau4ANfhJ0evD7PyBJkdef305M3kA09TJBo8ZE+hgH4+2hQzO0Uq3Zywh7oEt67ieD6VdbtfQ5uWzk+V0XZw0D6cDDjT0iYcZRY=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(136003)(39860400002)(366004)(376002)(346002)(396003)(186003)(8676002)(6512007)(36756003)(86362001)(38100700001)(5660300002)(478600001)(66476007)(8936002)(2906002)(2616005)(26005)(316002)(110136005)(44832011)(54906003)(66446008)(66556008)(91956017)(66946007)(71200400001)(6506007)(6486002)(4326008)(76116006)(64756008)(966005);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?hvXj57ZIGh1x0dAgajCMmkaCNKTsVdJAeoUFx4yEn4DsSmqelF3xtJepU?=
	=?iso-8859-15?Q?M95v/FIryjY+SqpLsONsIDIJiShFpqdLLyOE5DFWHIQiwfdrRk3F9NHm7?=
	=?iso-8859-15?Q?pCmagT5f4VOq/KnYCiqh3Jh7oCIeHktHHYPVAHghp9QQemyhyi4OIQF/j?=
	=?iso-8859-15?Q?6ZN25z6A5BpKp9p3gGQ7jhlohvbPZtOzQE1iS8UkjSDejgSheXqYP7T1O?=
	=?iso-8859-15?Q?C+oK8kFyMAR2yVXBbdKf5YEQVOD212wxu9kHaWqryzscs/gchnw+6hHsw?=
	=?iso-8859-15?Q?NAUo6/Mryvp1Ue5dKSJ0Oxk3JxuA4OinKW4LsehlkGdab3AuuZqMpYYD8?=
	=?iso-8859-15?Q?82mxJgM0E/Y9PE24CsWy0Wi7mDiveZ3SyWPtsWH3S6lOwJdu0CKHInBNK?=
	=?iso-8859-15?Q?fG6zn2sKuhNA8+GR7N0juyII5JZXKT4XMXH07k8RznqbjPGl8DEkUZlku?=
	=?iso-8859-15?Q?+rpA8n4CkQCrTsac0xA5Kr6ppKGgpGYJ1zMhfY+MvCcw8J+KahmK3/66B?=
	=?iso-8859-15?Q?JCyZlxrVF87HUAG/zfe8+icQtVVoy4WFx+IEoraexFuqYQrtbiFNCBYPC?=
	=?iso-8859-15?Q?8wfSxZLXEngQ7M0hyY4yvsmp5e2bcpUf9R3ty4VeE7r91VTqcfhrYZecr?=
	=?iso-8859-15?Q?glDVDwLJlghyB1Ybl04uitax6p++GzYCQympqMNVKuSJ8UjYYTrEFXNRO?=
	=?iso-8859-15?Q?idtFJ9k8G9O7ECPvxmTUCiCX1QSuOSQubC+3HAYKwMpyKpOcuJaCJJ5Ge?=
	=?iso-8859-15?Q?xL+ukeWU267SLOVZsukYk0snJhaq7xVBv7Oxb+bmsviVgkC40H10zuAWV?=
	=?iso-8859-15?Q?ABPWdSFc/stXagTMURMKBSYK7pi7YVOYKosIxLXuQ3xDkDizH8MWQPQFP?=
	=?iso-8859-15?Q?houyttD82dLc6zc797OcI+V0lf+WIhRznkjDmZBy0uPbWD28QvvXTM7ZY?=
	=?iso-8859-15?Q?QooxNTicVPj78v83MdDG5AZYwyOqk0XSyWjmAyL3oCGystbwXdMILERJd?=
	=?iso-8859-15?Q?olGttmK0nmeb0Wj7E8YotwkNKLuX1hQrU0XYP5np8N/jYswI6Vo26s5BG?=
	=?iso-8859-15?Q?iKw81siPYr4tNtP3kaVuBIUVq7wDKTmZ2ixyHd6awXwyPGQwS/xHCh+Ye?=
	=?iso-8859-15?Q?9srV9cztkXCjZ0SwefuWi9ftkaZ0SDcqhgShUwtbDv3AaWZ8lzjzy3BRA?=
	=?iso-8859-15?Q?FaBqk5pNMaQZTla5diqwOjnXPic9Qu84Snwg6fYZwRys7RacKZiMso0pM?=
	=?iso-8859-15?Q?TcOfaw/1nU7kFVL3EI6JJ+vA0Q5BTuoB1R5pkoNWptcbPuJ6JDXhZLLMG?=
	=?iso-8859-15?Q?nD07LLChTVr9qZl/HbrtfqWyII+fD+VCwcLwoWklOcvAqdVJKA8PVxMQF?=
	=?iso-8859-15?Q?iFqQe4v5MQr00cY9CxK4tGwz+DLS0X8D9?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42a8f298-8f6d-4341-5ff1-08d8f442412d
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2021 12:41:06.8478 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 32c1NfyPIO44mb/tgJJU30N0zX0cqDTzZIl0W0TVpmiUYfK7P/Gd5M2utonzsCq18f+vvSp8trEsQu2kstHDww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4747
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12VCfHof028166
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 31 Mar 2021 09:32:19 -0400
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] dm-multipath - IO queue dispatch based on FPIN
 Congestion/Latency notifications.
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
Content-ID: <B091488962172F40B5E617C00EBA8297@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-03-31 at 17:27 +0530, Muneendra Kumar M wrote:
> Hi Martin,
>=20
> > >=20
> > > I'm aware of Ben's work, but I hadn't realized it had anything to
> > > do
> > > with FPIN. As of today, multipathd doesn't listen on the
> > > NETLINK_SCSITRANSPORT socket. Does any user space tool do this?
> > > Google didn't show me anything.
> > >=20
> > I did, once, but that was years ago.
>=20
> We have user space daemon(Broadcom'sFiber Channel Transport Daemon)
> called
> fctxpd (Benjamin was talking in his patch) which acts on fpin-li events
> by listening=A0 on NETLINK_SCSITRANSPORT socket
> And it sets the path to marginal path group on receiving FPIN events.
> This daemon is part of epel8.
> Below is the path for the same where we have changes
> https://github.com/brocade/bsn-fc-txptd
>=20
> Regards,
> Muneendra.

I see, and this daemon uses multipathd's "set marginal" command to make
multipathd act on it. I can see now that Ben talked about "Broadcom's
Fiber Channel Transport Daemon" back then, but he didn't go into
details, and I either overlooked it entirely, or forgot about it.
I recall that I was wondering by myself whether the "set marginal"
command had any use other than manual testing.

I wonder if we could / should incorporate this functionality into
multipathd itself.

But anyway, it seems that this part of the FPIN mechanism works
already.

Thanks
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

