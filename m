Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C862C4332F
	for <dm-devel@archiver.kernel.org>; Thu, 20 Oct 2022 16:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666281873;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=AqhZeudIE+zPCJqlnP1w1I0kptZVDlPImeKvB353cu4=;
	b=NhKPOxeaQ0RBDQtLeuw75MDbVmU9TSeEIj5XFneE53F1IfsyO9RR71U8J6b1BmdLn7XfoS
	1FuYavpvQA7zHq+rZh+LFoclzDOQxYMgc2PEUPPErwyAdaQDaxMqJmYHaBHyh6pyxaLDe4
	nwbAQPnzmrX7MAAxtEVX+VqwDWm58ok=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-354-dnPXZpTAPPONn-KZQQ1Low-1; Thu, 20 Oct 2022 12:04:29 -0400
X-MC-Unique: dnPXZpTAPPONn-KZQQ1Low-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC5A618A0677;
	Thu, 20 Oct 2022 16:04:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 979BEC15BBD;
	Thu, 20 Oct 2022 16:04:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 420E61946597;
	Thu, 20 Oct 2022 16:04:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 746661946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Oct 2022 16:03:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BAE012166B48; Thu, 20 Oct 2022 16:03:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B35D02166B41
 for <dm-devel@redhat.com>; Thu, 20 Oct 2022 16:03:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90C268279A9
 for <dm-devel@redhat.com>; Thu, 20 Oct 2022 16:03:51 +0000 (UTC)
Received: from EUR03-DBA-obe.outbound.protection.outlook.com
 (mail-dbaeur03on2079.outbound.protection.outlook.com [40.107.104.79]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-1Y1RkKGhOx-ft_X9lc8L9A-1; Thu, 20 Oct 2022 12:03:49 -0400
X-MC-Unique: 1Y1RkKGhOx-ft_X9lc8L9A-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by VE1PR04MB7454.eurprd04.prod.outlook.com (2603:10a6:800:1a8::7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Thu, 20 Oct
 2022 16:03:46 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::eec2:cac0:7732:8da]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::eec2:cac0:7732:8da%4]) with mapi id 15.20.5723.035; Thu, 20 Oct 2022
 16:03:46 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 0/4] remove dangerous cleanup __attribute__ uses
Thread-Index: AQHY3bvbunQAwHOhV0SlLzLEsTKfWK4Xf5cA
Date: Thu, 20 Oct 2022 16:03:46 +0000
Message-ID: <ea71be8dba1dd8103d8d46d76011bc74d1a73034.camel@suse.com>
References: <1665525183-27377-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1665525183-27377-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|VE1PR04MB7454:EE_
x-ms-office365-filtering-correlation-id: fe89d487-9610-48d1-faa2-08dab2b4ab45
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: AK/1NPU8zOuTwMH23GghHOohdFF4Vhj9c6xhV93bj1fvge7PI6b8IUEwqFQXlOYGObnvqbvgPZUEe7dSdZN4KAUZ/hTa2pYGF5N9r3Vwmqj1ERpxsF8L7PumnAxD5fNJBNWVKwrpd33waaytPga5asdczl1Yc+kGwpLMXETeiyfqNNeG08wnDVXJYS2LAyZtDUhJaoscSyqbk/l43VM+EvoBF8esGg4JDyJ1cb7+FMW9BM5Js3AdLVuALTMwQRulKB4fFAn3OlGtySjPJQBbBM3MUG0DUCxIBBm8awnt+zMSOLi3JRhN+h9tY4Ft07Hmjcw552FHq3M5TnQbvqb6WpItf32FoXQyx4ru/WaaGigB8ddNlwW4ApezHzVImKIefLyDMwun2CY2yanU6mkieo+0QlX5FiC9Eacubrdygds3aSw0+o1bkMLx+OmJuTP3VLZw2vhHvn2TvC0h37MV61krbdy12JJsu8bMQf0rUyomBdi4ek7apmY2mjnFmVhjlHbx2F5XY7mM04h9madYqAldG43LIRv55TD0XSO8wvR2baXCNvOVkMjZbWPW9Sk2Fs+ojl7BF+XikG/W9vbyoJb8tvn5lNVz0O6mI95rthSQ+bDV6O7RF1b2H6QpkbLG+JUWHkx2QH95Y/T/QbEUgrKowETt3u3rT6Ajtr6s7kI7x7V3Yodgtx0cLH+iAQ3UTQMbvGLFhoUTdgo8oVx1R1vYB0fQQ7ghYqorlDngnlOiBaI3zPmceVczv6dAAQTO5lPncQMBQAy3T/Rubsa7wQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(136003)(396003)(346002)(39860400002)(366004)(376002)(451199015)(26005)(71200400001)(83380400001)(86362001)(478600001)(6486002)(6512007)(66476007)(66556008)(6506007)(316002)(41300700001)(44832011)(8936002)(4326008)(66446008)(36756003)(76116006)(110136005)(186003)(2616005)(4001150100001)(2906002)(8676002)(66946007)(5660300002)(64756008)(122000001)(38070700005)(38100700002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?jgCth86c8V1OBNRYL6LknZU8Z3/TJS/l8j/snmCRrgvlLhR992iEd3wD6?=
 =?iso-8859-15?Q?jWSP8HTKv+1eE3ILFcbeFCBPyrDXJD/w/Q68H5QJsRi9OLxLbF4NLGtkT?=
 =?iso-8859-15?Q?34vhwTJYY0RTBne21rNM3FQdm/TjqZP9eFhydRKDMm+Kx4BqYBXcMA8m8?=
 =?iso-8859-15?Q?5Ctt9LtifL6Pk8DRbrUD0IgJTkBeBgl2z20eEUmb8doz0DZTrlJ4+cyrM?=
 =?iso-8859-15?Q?FtCYW3NSHMhoqAF9y/KhY8VziRARMRpk7n3TaZwC5n8bmyk8PWTtRa1Q5?=
 =?iso-8859-15?Q?Auq/KzyPwH8b5dDGRGscsftWCK+WpCa7xCmRcmsxDFu9w665t2cpBUZ9C?=
 =?iso-8859-15?Q?xo6XZRMw2f3mGm8X5W94WQoMX5ittwGAIy6/7Lner2m2YnIFUjGCK6cFv?=
 =?iso-8859-15?Q?i5LtFkSF50Ma77wfXWIgOPEfy3F+aoQPxLaLePMqf9JlxkBsI4RznenHE?=
 =?iso-8859-15?Q?zAA4Mrcdo2X26HiuFvA15eoVkl5Yp7c7RiGxKF5bbnp2qycXBWX9JdEYt?=
 =?iso-8859-15?Q?BbO0KiW/JRN3SSCrhpRcOdi6t0/q6MkgAGgEKu+dl6MOlPEJ7U7qVGFFv?=
 =?iso-8859-15?Q?omYfeJ+3mpabE1sKMospiq23L38hBZ3e+UEkLqvVogJRtcDAvKbALxPhu?=
 =?iso-8859-15?Q?5QIqKZ2DMYSQS1vhSxZ723362YGBAdwBf7dQEU3rGuz5X3i6gqA0YwhZu?=
 =?iso-8859-15?Q?u3IqhQSFe0X+/XfWXVujHCUYF42P8mYLXplC+KrZEmyf6KwVjUtE3JHCf?=
 =?iso-8859-15?Q?1j0F+yCoNbprznn/Rzwj+izJJS4V51BXgRl5tDPQXPNETZ+q1gFoYvLIr?=
 =?iso-8859-15?Q?q4yZda8n5aejmpFH6V2ljAN1yJEkWSksMsTHm+0l8T6bRvtdJWz02aw2n?=
 =?iso-8859-15?Q?wi8Jl80Y6QEamqmhCcOuCLIW8VdcTzb11GgW/+ROGSR3X1K8coScDxlXc?=
 =?iso-8859-15?Q?a2N2QoPiJCS35NP64UadyzWhCitOlW9CCht9TVO9KUeZT+zbgxyp89x71?=
 =?iso-8859-15?Q?qWe0guLUb2UuMNDpLCuxwQDoxmDg/DvvcKiE86a2/sj+5KtjxZvEtMLPe?=
 =?iso-8859-15?Q?l63ycZoHsaVyN+gdldir9v0J1H0DSIkoOwu6tfDVe3DzBYbmtDEhJE3Gt?=
 =?iso-8859-15?Q?ZO6ZTy0J2lpgH++r+1MdfPbFSgZ1bEisWSCsZCrGikfJmEKL2bdNrI8Bi?=
 =?iso-8859-15?Q?5cTKifDY3SQH2fesylJkyGCWN19ayb+qGrMKvJHQ9lcanp4V/umklo18K?=
 =?iso-8859-15?Q?mtSr+4fTWOtw3nHHwBlDRQULaqZG9lqx/qwP3U1SL1kzt//0MHWgP6C7U?=
 =?iso-8859-15?Q?ZoOC3xH1PNYOd0uIHp2vU+Nh/doSuOtfmIP420pROjPVOitJKVxR7y2ri?=
 =?iso-8859-15?Q?ORYKHbwNtox1b49PyWeW7UxL4/4V4HTek3CpvFNKjw+ATiK1knrU+PsDg?=
 =?iso-8859-15?Q?47OBGevCzV3IpKaHq1Myp/do2Kg8iKcOJJhVyBwMVFjpTsYrZ1bfzTrC1?=
 =?iso-8859-15?Q?SzV1SdY2LP5XrYqJOABj6Uh6LWbOHy0LAkeiib2fC8mVh+z5ihkThRMGw?=
 =?iso-8859-15?Q?5mA4u7e0rc6kh7nonrYm/Ljk5v7Ce1A74lPfn818fq0R+5pi5TK7NFkPn?=
 =?iso-8859-15?Q?cxvFanLm/yGmVeXF1utf/EZVdqSG7J/xGveRuU1ns0KNImuB38xdzotxn?=
 =?iso-8859-15?Q?uAp/r9F0HerBT2RhL2GYZfbB9A=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe89d487-9610-48d1-faa2-08dab2b4ab45
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2022 16:03:46.3225 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WxoZa0RE3Gip/yBXoJJKLvyqKgfLhlq+yo+OTfKSzGRILNuAECHwneF03tYI+i4prubE/mBWy+ByBGarqn3wBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7454
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 0/4] remove dangerous cleanup __attribute__
 uses
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <70BBBA57F3D0AA4EB2B511877B747339@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-10-11 at 16:52 -0500, Benjamin Marzinski wrote:
> the cleanup __attribute__ is only run when a variable goes out of
> scope
> normally. It is not run on pthread cancellation. This means that
> multipathd could leak whatever resources were supposed to be cleaned
> up
> if the thread was cancelled in a function using variables with the
> cleanup __attribute__. This patchset removes all these uses in cases
> where the code is run by multipathd and includes a cancellation point
> in the variables scope (usually condlog(), which calls fprintf(), a
> cancellation point, the way multipathd is usually run).

I have to say I don't like this.=A0

Cleaning up resources is certainly  very important, but in most of
cases it's only about freeing memory on exit: memory which is going to
be freed by the system anyway when multipathd terminates. Resource
cleanup matters much more during runtime than on exit. The only threads
that are cancelled during multipathd runtime are the TUR threads.
It's nice to have valgrind show zero leaks when we kill multipathd out
if the sudden. But we should weigh this against the side effects it
has, which is ugly, hard-to-maintain code.

pthread_cleanup_push()/pop() calls contribute a lot to the bad
readability and maintainability of much of the multipath code base, not
to mention the weird errors some gcc versions throw for
pthread_cleanup() constructs.=A0I'd rather try to get rid of as much of
them as we can. I know it won't be possible everywhere, because some
resources (like file descriptors) really need to be cleaned up, but I
am really unsure whether we need pthread cleanup for every free()
operation.

__attribute__((cleanup())), on the contrary, goes a long way to make
code more readable and easier to review. It actually helps a lot to
ensure resources are properly cleaned up, considering how easily a
"goto cleanup;" statement may be forgotten. Replacing it by
pthread_cleanup() and goto statements is undesirable, IMO.

If your concern is really condlog(), let's discuss if we can find a way
to convert this such that it is no cancellation point any more. I can
imagine converting the locking in log_safe() from a mutex into some
lockless scheme, using atomic variables, and using the log thread not
only for syslog, but also for the fprintf() case.

Regards
Martin


>=20
> Benjamin Marzinski (4):
> =A0 libmultipath: don't print garbage keywords
> =A0 libmultipath: avoid STRBUF_ON_STACK with cancellation points
> =A0 libmultipath: use regular array for field widths
> =A0 libmultipath: avoid cleanup __attribute__ with cancellation points
>=20
> =A0libmpathutil/parser.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 | 13 ++--
> =A0libmpathutil/strbuf.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0 4 +-
> =A0libmultipath/alias.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 | 59 ++++++++++-------
> =A0libmultipath/blacklist.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 |=A0 4 +-
> =A0libmultipath/configure.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 |=A0 6 +-
> =A0libmultipath/discovery.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 | 34 ++++++----
> =A0libmultipath/dmparser.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 | 23 +++----
> =A0libmultipath/foreign.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 |=A0 9 +--
> =A0libmultipath/generic.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 | 14 ++--
> =A0libmultipath/libmultipath.version=A0=A0=A0=A0=A0=A0=A0 |=A0 4 +-
> =A0libmultipath/print.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 | 82 ++++++++++++++--------
> --
> =A0libmultipath/print.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 |=A0 4 +-
> =A0libmultipath/prioritizers/weightedpath.c | 22 ++++---
> =A0libmultipath/propsel.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 | 76 ++++++++++++++++------
> =A0libmultipath/sysfs.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 | 11 +---
> =A0libmultipath/uevent.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0 6 +-
> =A0multipath/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 |=A0 5 +-
> =A0multipathd/cli_handlers.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 | 52 +++++++--------
> =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 | 49 ++++++++------
> =A019 files changed, 286 insertions(+), 191 deletions(-)
>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

