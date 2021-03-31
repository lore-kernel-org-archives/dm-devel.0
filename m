Return-Path: <SRS0=fKNG=I5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FCCEC43460
	for <dm-devel@archiver.kernel.org>; Wed, 31 Mar 2021 13:33:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 23C1561990
	for <dm-devel@archiver.kernel.org>; Wed, 31 Mar 2021 13:33:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 23C1561990
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-wpvviIjyOAGjA3P8_rUWKA-1; Wed, 31 Mar 2021 09:32:57 -0400
X-MC-Unique: wpvviIjyOAGjA3P8_rUWKA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 257171B18BC3;
	Wed, 31 Mar 2021 13:32:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F0E595C1BB;
	Wed, 31 Mar 2021 13:32:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8D66318155DD;
	Wed, 31 Mar 2021 13:32:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12V9vfKJ007539 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 31 Mar 2021 05:57:41 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E996F2026D64; Wed, 31 Mar 2021 09:57:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E235F2026D7F
	for <dm-devel@redhat.com>; Wed, 31 Mar 2021 09:57:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 477D9811E7F
	for <dm-devel@redhat.com>; Wed, 31 Mar 2021 09:57:37 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-402-io-l0vi2NzaRUijJiMHrGA-1;
	Wed, 31 Mar 2021 05:57:35 -0400
X-MC-Unique: io-l0vi2NzaRUijJiMHrGA-1
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
	(mail-am5eur02lp2055.outbound.protection.outlook.com [104.47.4.55])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-23-wUmtMWLUM7CuPKHeq_Famg-1; Wed, 31 Mar 2021 11:57:32 +0200
X-MC-Unique: wUmtMWLUM7CuPKHeq_Famg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB4076.eurprd04.prod.outlook.com (2603:10a6:5:1e::25) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25;
	Wed, 31 Mar 2021 09:57:30 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.3999.027;
	Wed, 31 Mar 2021 09:57:30 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "erwin@erwinvanlonden.net" <erwin@erwinvanlonden.net>,
	"muneendra.kumar@broadcom.com" <muneendra.kumar@broadcom.com>,
	"bblock@linux.ibm.com" <bblock@linux.ibm.com>,
	"hare@suse.de" <hare@suse.de>
Thread-Topic: [dm-devel] dm-multipath - IO queue dispatch based on FPIN
	Congestion/Latency notifications.
Thread-Index: AQHXH8ZRsvMl6pS9x02jEI+NQfbmHaqU4l6AgAFApYCAB5ulQoAAKk8A
Date: Wed, 31 Mar 2021 09:57:29 +0000
Message-ID: <4fff162d56dd8eebaa7d13be9d6ff580cacbe15f.camel@suse.com>
References: <5b87a64d88a13eb8b4917a1cc0d35691f9fc8227.camel@erwinvanlonden.net>
	<YFy1Q6nvJEcRzwyl@t480-pf1aa2c2.linux.ibm.com>
	<b3025c4bf84fe357712fa0fe32bfa3e9@mail.gmail.com>
	<2c6ff107ccf5f0589520ef124cd9ecc4cdcc355e.camel@erwinvanlonden.net>
	<8966fcda-b1ca-5d50-398a-13195dab3c44@suse.de>
In-Reply-To: <8966fcda-b1ca-5d50-398a-13195dab3c44@suse.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bcd463c6-6d1d-489b-324b-08d8f42b65d0
x-ms-traffictypediagnostic: DB7PR04MB4076:
x-microsoft-antispam-prvs: <DB7PR04MB40763BC66EA2B841B182D8DCFC7C9@DB7PR04MB4076.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: fsZ33N+cdm4STStxtVvMKRgDcd99OOJjAU+rdpwJjE2CHZ4MuQefE9am4C/y/IxLTKf+8Ieb83dRuaZxTixI7KBJKvqWIvCYTlLxrh6bCCCrcB/4sAHRea/WI3qdhFzmTRN+YvML31smtLY9gzf2VkRxr7CYkJHKyQVBLArVqdeyGfvSokLnlVL1P3ZC6dhrB/+6xxof7Upt9RVHaIdJEYx8sH9IrlTgHOVOzfDR8w88vyNHy23AdxalsYiB4prbxIvh+g4P+7RDwjRznS2hzP9FcaS6pgfLgqiaK5ItMqxL4KcSPLFfHFvfF95lyOFzzV0gBlnyrP+0ssXII/XOGj31p7WX9ViWD2t5uiNKfC+fVY9kunMcgrHWC1PzkxZlDfRchtgV89s1T8ybi0hTsF5wCCl13vBQAOSEkw8x/b+fV1MdJgfhvUDomVE3pr5EVeo4yHhXJYF8mnB3SqJh2aOQUjjNgh+rLnlkdyJjD5Jk2I4uoTlb5dmVfZMSJ67Nmx6yFH04Um0jysJY8BZvcnKcR/kYvjgqhw1Nhypym2UQ5qNl7TLLhzZI0J9m+7oNhwcsuXz6JUSfc64pTMJzLNcO+5A58HihoIROpAIPudnLnRjBadkAlMxGboM/khj1OmSG46UW5wDWwzcWCzOaSdDaUvZC6joUf+TG4VDM0zE=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(346002)(376002)(136003)(39850400004)(396003)(86362001)(4326008)(2906002)(66946007)(110136005)(6512007)(6506007)(71200400001)(66574015)(38100700001)(54906003)(66556008)(186003)(83380400001)(66476007)(26005)(36756003)(8936002)(2616005)(76116006)(44832011)(91956017)(53546011)(5660300002)(316002)(15650500001)(66446008)(8676002)(478600001)(6486002)(64756008);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?Sw71S3gBXQfK2xU+BhimA4XU9MxM7r1Lbh7giK3TvPhnEiIayJWTSekns?=
	=?iso-8859-15?Q?jR4KMMnWPyWhyE8RcWrZRcPDPGbITITFbe8CwLVrrrPuvZqc4f9buYpKN?=
	=?iso-8859-15?Q?rv5y7CjjURTHnBzKv6Ot/kgBjUEr+16bWtpiGyHw5fGwiYr6mUrYFheG5?=
	=?iso-8859-15?Q?giGkDmW6fy6OaPIeHjsXYB4Hwv6rgiDEc4tvOAVAo3ZUGStx/mo31tPsD?=
	=?iso-8859-15?Q?BIe9WpS/zChWTgpj39MlBcZyEsDTq6216CNEUOMs2IOP693uFyJT74QGS?=
	=?iso-8859-15?Q?0t1s8wo6eM8IZYswc5JFtIphLJ7QyZeKx8ZgTPkVDi+1yXvBFh80qZCLM?=
	=?iso-8859-15?Q?u+nhk3wdQPoJ05V76o77rbzx216NfzL+fEH9ycnYVT39rxPvc8lk9z3mi?=
	=?iso-8859-15?Q?atVUQiqH1awRYff5k7K3mcimP10FSIVGPXEa+meMrrP/LRejT0aiTizIf?=
	=?iso-8859-15?Q?hpNWeyQlUIUgLdB61Fm194vZIBa3YZtGAfSnTgHUW2XCGieisYVbhr7Ka?=
	=?iso-8859-15?Q?0nTzqGPGgpM2ykHPiSiHkm3svmvrv9Q0KstRE80nM9ZtnD7/hQxAZisA/?=
	=?iso-8859-15?Q?n9nu9efizSxWRqFownU14ySU9qx7/jO3UelByyzi9fzYxcarb1hbJaryV?=
	=?iso-8859-15?Q?SckQo2IMwTJoWFEsJG2OmbE9LTP7RI45G0couDQjnj7UpOotFdPrqRqtW?=
	=?iso-8859-15?Q?BqKD+iTT8aYIyr5BqIgv3AEqPVIdOFsOErCaK1q7OpmDQLsMvZHeQifoV?=
	=?iso-8859-15?Q?5f5GvJj+71snUIyEA8s8UwHKjkr7EfAzFBn7mXGPPY3wiDTTcxL67UOXg?=
	=?iso-8859-15?Q?1D1eU5Q+piHEwABlT+V4O8/TBuqXaymtfBOwTnf1rsi+QbDaWY2SP+TO6?=
	=?iso-8859-15?Q?S/c5HbRztH4hBCtfIQm3x1E+NXSPZFlk8VXUwboZUkxVhTd75sQK0jdJe?=
	=?iso-8859-15?Q?TClRDHRIXsOSjv2bURfBOstK2UTvXrTwoAVXMygPc7j++21N1ASrG8eVf?=
	=?iso-8859-15?Q?+VcK5aDem5kGY5LbPWgYWXHmbk4PrcltgjwFGEnt9thAF4TWxdp9Kacw1?=
	=?iso-8859-15?Q?RAdVrTCyDoNND5TStIWTlTYYcT/WbQ+TTEdfviW45HOI1+IaqF2D5kv3u?=
	=?iso-8859-15?Q?crj4rx+xU5bHj/RcEYwqRGWQA36Ftw45b971+0OGqED0oZhDUSO2Y6i11?=
	=?iso-8859-15?Q?8+nwxGVLkoW17A4jtaA9LjCG6q+jIDQnTsSFex6qQlgXbSUTyBkQTpBtG?=
	=?iso-8859-15?Q?D6Zt79RJ62mh6EMa1rpAYrTjgnmcyBEgYUG4CNdNUBT8ubr5kPFjKUtm3?=
	=?iso-8859-15?Q?q9x4aibmZ2ok/ZiCd14QQ6UKF2c/hH50KoNkEc9Fowc4S/yRrhrs5v3/i?=
	=?iso-8859-15?Q?QOa5mO0mp/wJm2XWPVjr2MXi93ztpm7Rx?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcd463c6-6d1d-489b-324b-08d8f42b65d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2021 09:57:30.0480 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +hJgohGR/vi2Aa7JjwF6CxUrieg4KQTwT7GTdMPmBKoU35+FoJ35HRhWERrPCKNUjx7Cu/jIt4j7hZFfaQ45OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4076
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12V9vfKJ007539
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <37346682859B914194FD50FA3D660717@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-03-31 at 09:25 +0200, Hannes Reinecke wrote:
> Hi Erwin,
>=20
> On 3/31/21 2:22 AM, Erwin van Londen wrote:
> > Hello Muneendra, benjamin,
> >=20
> > The fpin options that are developed do have a whole plethora of
> > options
> > and do not mainly trigger paths being in a marginal state. Th mpio
> > layer
> > could utilise the various triggers like congestion and latency and
> > not
> > just use a marginal state as a decisive point. If a path is
> > somewhat
> > congested the amount of io's dispersed over these paths could just
> > be
> > reduced by a flexible margin depending on how often and which fpins
> > are
> > actually received. If for instance and fpin is recieved that an
> > upstream
> > port is throwing physical errors you may exclude is entirely from
> > queueing IO's to it. If it is a latency related problem where
> > credit
> > shortages come in play you may just need to queue very small IO's
> > to it.
> > The scsi CDB will tell the size of the IO. Congestion notifications
> > may
> > just be used for potentially adding an artificial=A0 delay to reduce
> > the
> > workload on these paths and schedule them on another.
> >=20
> As correctly noted, FPINs come with a variety of options.
> And I'm not certain we can everything correctly; a degraded path is
> simple, but for congestion there is only _so_ much we can do.
> The typical cause for congestion is, say, a 32G host port talking to
> a
> 16G (or even 8G) target port _and_ a 32G target port.
>=20
> So the host cannot 'tune down' it's link to 8G; doing so would impact
> performance on the 32G target port.
> (And we would suffer reverse congestion whenever that target port
> sends
> frames).
>=20
> And throttling things on the SCSI layer only helps _so_ much, as the
> real congestion is due to the speed with which the frames are
> sequenced
> onto the wire. Which is not something we from the OS can control.
>=20
> From another POV this is arguably a fabric mis-design; so it _could_
> be
> alleviated by separating out the ports with lower speeds into its own
> zone (or even on a separate SAN); that would trivially make the
> congestion go away.
>=20
> But for that the admin first should be _alerted_, and this really is
> my
> primary goal: having FPINs showing up in the message log, to alert
> the
> admin that his fabric is not performing well.
>=20
> A second step will be to massaging FPINs into DM multipath, and have
> it
> influencing the path priority or path status. But this is currently
> under discussion how it could be integrated best.

If there was any discussion, I haven't been involved :-)=A0

I haven't looked into FPIN much so far. I'm rather sceptic with it's
usefulness for dm-multipath. Being a property of FC-2, FPIN works at
least 2 layers below dm-multipath. dm-multipath is agnostic against
protocol and transport properties by design. User space multipathd can
cross these layers and tune dm-multipath based on lower-level
properties, but such actions  have rather large latencies.

As you know, dm-multipath has 3 switches for routing IO via different
paths:

 1 priority groups,
 2 path status (good / failed)
 3 path selector algorithm

1) and 2) are controlled by user space, and have high latency.

The current "marginal" concept in multipathd watches paths for repeated
failures, and configures the kernel to avoid using paths that are
considered marginal, using methods 1) and 2). This is a very-high-
latency algorithm that changes state on the time scale of minutes.
There is no concept for "delaying" or "pausing" IO on paths on short
time scale.

The only low-latency mechanism is 3). But it's block level, no existing
selector looks at transport-level properties.

That said, I can quite well imagine a feedback mechanism based on
throttling or delays applied in the FC drivers. For example, it a
remote port was throttled by the driver in response to FPIN messages,
it's bandwidth would decrease, and a path selector like "service-time"
would automatically assign less IO to such paths. This wouldn't need
any changes in dm-multipath or multipath-tools, it would work entirely
on the FC level.

Talking about improving the current "marginal" algorithm in multipathd,
and knowing that it's slow, FPIN might provide additional data
that would be good to have. Currently, multipathd only has 2 inputs,
"good<->bad" state transitions based either on kernel I/O errors or
path checker results, and failure statistics from multipathd's internal
"io_err_stat" thread, which only reads sector 0. This could obviously
be improved, but there may actually be lower-hanging fruit than
evaluating FPIN notifications (for example, I've pondered utilizing the
kernel's blktrace functionality to detect unusually long IO latencies
or bandwidth drops).

Talking about FPIN, is it planned to notify user space about such
fabric events, and if yes, how?

Thanks,
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

