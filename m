Return-Path: <SRS0=jKmk=GI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08D16C433DB
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 10:56:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 503FD225AB
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 10:56:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 503FD225AB
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-aC6mjVBFP_S7MpzEq_E32Q-1; Tue, 05 Jan 2021 05:55:59 -0500
X-MC-Unique: aC6mjVBFP_S7MpzEq_E32Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3BAAC59;
	Tue,  5 Jan 2021 10:55:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AF46060C04;
	Tue,  5 Jan 2021 10:55:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 569F54A7C6;
	Tue,  5 Jan 2021 10:55:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 105AtqVL021111 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 5 Jan 2021 05:55:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 37C6A5D218; Tue,  5 Jan 2021 10:55:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3018D5D217
	for <dm-devel@redhat.com>; Tue,  5 Jan 2021 10:55:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE50780391A
	for <dm-devel@redhat.com>; Tue,  5 Jan 2021 10:55:49 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-46-uo2IxwCgN1CIVl8JKBhFoA-1;
	Tue, 05 Jan 2021 05:55:45 -0500
X-MC-Unique: uo2IxwCgN1CIVl8JKBhFoA-1
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
	(mail-am6eur05lp2105.outbound.protection.outlook.com [104.47.18.105])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-20-CiCY2DoePAmTwGpkWjp6-A-1; Tue, 05 Jan 2021 11:55:43 +0100
X-MC-Unique: CiCY2DoePAmTwGpkWjp6-A-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBAPR04MB7463.eurprd04.prod.outlook.com (2603:10a6:10:1ad::10)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.22;
	Tue, 5 Jan 2021 10:55:42 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6]) by DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6%3]) with mapi id 15.20.3721.024;
	Tue, 5 Jan 2021 10:55:42 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH 6/6] multipath.conf.5: Improve checker_timeout description
Thread-Index: AQHW1ZKB6X4Ojcg7Y0KOu2ExvyDMOKn9h70AgBrB9ACAAK3HgA==
Date: Tue, 5 Jan 2021 10:55:42 +0000
Message-ID: <1e9340a290585e60e0423d04523c82069cff57d3.camel@suse.com>
References: <1608332802-9720-1-git-send-email-bmarzins@redhat.com>
	<1608332802-9720-7-git-send-email-bmarzins@redhat.com>
	<28b07148b5249f05e6509d5a34ed145a23975be4.camel@suse.com>
	<20210105003342.GT3103@octiron.msp.redhat.com>
In-Reply-To: <20210105003342.GT3103@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2
x-originating-ip: [2.203.204.191]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f7cc43cd-dee9-44b2-568f-08d8b168724d
x-ms-traffictypediagnostic: DBAPR04MB7463:
x-microsoft-antispam-prvs: <DBAPR04MB7463139210526BB929C2A73EFCD10@DBAPR04MB7463.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: A2vfXGYjPcUTQA5dIPfPYb7j3XmA67pRn2nGYY/8t+npXW6xWO1XTjqMB/lcDB/ylrqWLFMMIZTTCkG3IJs3as3tTVADtSeuMamkbQAEZIeC87Ijg5kLfPSU+ypPkA7VmX0yBNVs3hlA6lgk/QNDUOIqctIWVmkh4LkLimw8lCFZTPNln2SkrNl9pPXAeJjFeIOGCzAjZV5C2SYzVU3ZwiU1ER+hZ1zYYMwb++uELn08eBZ3GT2nPTcu7QqyRtFuWgjjWEC3xGfIlDeZGUuI3qpabciJWWuRPZqxnFvq8pthvxJ1aNdSLq6gJq/Nt7kpyiKsCrhdLk40u8zjshwjUIggXEwf2T93Tao28Ic4ZqB0YGuFmwWrODTAKrbAJHEl+gUWmQE5ZyhC+d4IRY7mKw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(396003)(136003)(39860400002)(366004)(376002)(346002)(6512007)(66556008)(316002)(2616005)(8936002)(83380400001)(76116006)(36756003)(66946007)(66574015)(64756008)(91956017)(66476007)(66446008)(478600001)(86362001)(4326008)(6506007)(26005)(54906003)(44832011)(5660300002)(4001150100001)(6916009)(186003)(6486002)(71200400001)(2906002)(8676002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?EBgThfN+tFOKFn3U4Q7rVUIgVtx0qCdZl6Rko9mGUHbwRHCu9/vwnYhD7?=
	=?iso-8859-15?Q?ptL2Az9i0L5x0A4DVvhYXEKKyUFwUlbTEqcxKPgsZKhb6C/pLOijk0sD1?=
	=?iso-8859-15?Q?Yrh9XIUn8kTxPC4xNZCZuVGHz/J7JyjrDY+ogZr3gWbXGTElL9yMU9OxD?=
	=?iso-8859-15?Q?UDe91/Qft3DyFKJfBH0x81sZL+ek9xTMDz9TqsaWrCa4elpqrDOP1WS1O?=
	=?iso-8859-15?Q?3r1APN82ag2bSmiVk7k2t4XU/TTs5aID99t5kk3VO4Tobl+Y3EmM+8Yrl?=
	=?iso-8859-15?Q?k4GEjfvcgkWj3u4UPAPtJya14x9L9HLEh97dkDA3+7T2mbCmfyvun4yw+?=
	=?iso-8859-15?Q?TDfiFw0fDGvEwESJwV9R6nUenrnzUq2yN6siyc8c8ZWOgbe2Fck4QhHgj?=
	=?iso-8859-15?Q?rscBimLIGSG0V4hm94sk9C03JW7a3NggH5JMA6cDuEPcn7bU4n1pDMoz7?=
	=?iso-8859-15?Q?qJaIlyz+x+iaDfGDQolXf0nq0lRIddzwURYjXYHerBHSrfd4e45LPQgEO?=
	=?iso-8859-15?Q?EIB3Q7henREdGPU5pT6nW0OrQYdxtQ+qAFQIwAztfvFVYj5KCKQhIWGly?=
	=?iso-8859-15?Q?FSwKmoozuCzDm8XxFS7R74kytAHtpZ9StDfT/n9/PJzMJM+pkpsD1WLdz?=
	=?iso-8859-15?Q?iyvGs08RAQ72SwiyZJGe06mcgwjCSXjmujMvQ6zHPRPzICCS4zc0xF3Pr?=
	=?iso-8859-15?Q?8hy+ESZxYUDZUMEkOqIo7UdM0eta4mDh7wNnYsEyWLxH1FmlCkYDfbQkA?=
	=?iso-8859-15?Q?hZeIKnMqPRrIf+y1uAY9ocKMlMxqw4UlSLfFNy3x/F/Vk9KUBDefuzl5C?=
	=?iso-8859-15?Q?SXSQP2908Tu5PPgt6ECJxhzqZZiJtVqk31EUgCs58erjrYrqTs6rQWK4r?=
	=?iso-8859-15?Q?5Xdf0NnxINnuPwqWOsPyLTp0ilXsX7uhMBSQvqKo5B1rQcthRohRkViyI?=
	=?iso-8859-15?Q?bhmpB/G0c9Y7QBFSLjZCILju41D+8S6OWCLg91Gsk+iEocoYcdsK10ymQ?=
	=?iso-8859-15?Q?NKMQsH/gKswUlWGLByyuZIyGmLeTc+lzKXfjsqWSvTwnn2vf1OlN0Pf?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7cc43cd-dee9-44b2-568f-08d8b168724d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2021 10:55:42.4092 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WkH2qppV49OIHZIXxqP9tOizIPJX1QpCOxVyDRIfr68aih3Q2BVwa4GLCf5tOwUkmlNLFemb0vgj3402VOrOrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7463
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 105AtqVL021111
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 6/6] multipath.conf.5: Improve
	checker_timeout description
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <2BD73D4392B75944914CE14E258E343F@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-01-04 at 18:33 -0600, Benjamin Marzinski wrote:
> On Fri, Dec 18, 2020 at 11:56:47PM +0000, Martin Wilck wrote:
> > On Fri, 2020-12-18 at 17:06 -0600, Benjamin Marzinski wrote:
> > > I was asked to explain how checker_timeout works for checkers
> > > like
> > > directio, that don't issue scsi commands with an explicit timeout
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > ---
> > > =A0multipath/multipath.conf.5 | 9 +++++++--
> > > =A01 file changed, 7 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/multipath/multipath.conf.5
> > > b/multipath/multipath.conf.5
> > > index ea66a01e..c7c4184b 100644
> > > --- a/multipath/multipath.conf.5
> > > +++ b/multipath/multipath.conf.5
> > > @@ -639,8 +639,13 @@ The default is: \fBno\fR
> > > =A0.
> > > =A0.TP
> > > =A0.B checker_timeout
> > > -Specify the timeout to use for path checkers and prioritizers
> > > that
> > > issue SCSI
> > > -commands with an explicit timeout, in seconds.
> > > +Specify the timeout to use for path checkers and prioritizers,
> > > in
> > > seconds.
> > > +Only prioritizers that issue scsi commands use checker_timeout.=20
> > > Checkers
> > > +that support an asynchronous mode (\fItur\fR and
> > > \fIdirectio\fR),
> > > will
> > > +return shortly after being called by multipathd, regardless of
> > > whether the
> > > +storage array responds. If the storage array hasn't responded,
> > > mulitpathd will
> >=20
> > typo
> >=20
> > > +check for a response every second, until \fIchecker_timeout\fR
> > > seconds have
> > > +elapsed.
> >=20
> > This is a bit confusing IMHO. Most importantly, checkers will
> > consider
> > a path down if it doesn't respond to the checker command after the
> > given timeout. The async behavior doesn't fit too well into this
> > section. Maybe we should mention and explain the async property in
> > the
> > path_checkers section, and only refer to that here.
>=20
> Sounds reasonable.
>=20
> > (Btw is the directio checker still deprecated after all the work
> > you
> > recently put into it? The man page still says so).
>=20
> No. I'll change that.=A0 There are times when devices claim to be ready
> with the tur checker, when in truth, IO to them will fail.=A0 In these
> cases, the directio checker is the best way to avoid having paths
> bouncing up and down.

Right. I recently had one such case with persistent reservations. SPC-4
mandates that the status of TUR commands is independent of PR status
(TUR is always "allowed"), while obviously ordinary IO would fail if
the active PR exclude the current host. That basically makes the TUR
checker inappropriate as soon as PRs on SPC-4 compliant devices are in
use.

As we have support for PR already, I wonder if we could/should extend
the TUR checker to take this into account.

Cheers,
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

