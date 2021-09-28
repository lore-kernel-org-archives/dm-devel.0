Return-Path: <SRS0=D7/d=OS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00CE0C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 28 Sep 2021 19:15:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 929DB6135E
	for <dm-devel@archiver.kernel.org>; Tue, 28 Sep 2021 19:15:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 929DB6135E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-V2arVPMkPjKQPQ89oqUppw-1; Tue, 28 Sep 2021 15:15:27 -0400
X-MC-Unique: V2arVPMkPjKQPQ89oqUppw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5F6E835DE1;
	Tue, 28 Sep 2021 19:15:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 77CBE76608;
	Tue, 28 Sep 2021 19:15:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1348D4E58F;
	Tue, 28 Sep 2021 19:15:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18SJFIK6002836 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 28 Sep 2021 15:15:18 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2AEE4D1BA8; Tue, 28 Sep 2021 19:15:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 22479CF63A
	for <dm-devel@redhat.com>; Tue, 28 Sep 2021 19:15:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7DB178001EA
	for <dm-devel@redhat.com>; Tue, 28 Sep 2021 19:15:15 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-520-P41_5jMFMlKZp1eYB0Mt_w-1;
	Tue, 28 Sep 2021 15:15:13 -0400
X-MC-Unique: P41_5jMFMlKZp1eYB0Mt_w-1
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur04lp2052.outbound.protection.outlook.com [104.47.14.52])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-6-nfjP5ooDNhKAXswLIOmXlw-1; Tue, 28 Sep 2021 21:15:11 +0200
X-MC-Unique: nfjP5ooDNhKAXswLIOmXlw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB8PR04MB6843.eurprd04.prod.outlook.com (2603:10a6:10:11b::14)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.17;
	Tue, 28 Sep 2021 19:15:10 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::5158:3113:295b:d9c1]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::5158:3113:295b:d9c1%5]) with mapi id 15.20.4544.021;
	Tue, 28 Sep 2021 19:15:10 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [linux-lvm] Discussion: performance issue on event activation
	mode
Thread-Index: AQHXWptdVb+iQI7pP06gMwUhQri0uKsIs+kAgABkm4CAAPX+gIAADzyAgJKTMYCAG6beAIAAXmQAgAD6QwCAAIiSAIAACUiAgAAo+QCAABnQgA==
Date: Tue, 28 Sep 2021 19:15:10 +0000
Message-ID: <420505080258b180629310f9c64a4e5595da1ab7.camel@suse.com>
References: <d1d35f7dba3d0e887e7eac06a06ff2414a84c924.camel@suse.com>
	<20210607214835.GB8181@redhat.com>
	<20210608122901.o7nw3v56kt756acu@alatyr-rpi.brq.redhat.com>
	<f6b8c5b6c01ecef842eb711748a765f81b7f04e7.camel@suse.com>
	<20210909194417.GC19437@redhat.com>
	<20210927100032.xczilyd5263b4ohk@alatyr-rpi.brq.redhat.com>
	<20210927153822.GA4779@redhat.com>
	<9947152f39a9c5663abdbe3dfee343556e8d53d7.camel@suse.com>
	<20210928144254.GC11549@redhat.com>
	<138b7ddb721b6a58df8f0401b76c7975678f0dda.camel@suse.com>
	<20210928174246.GF3087@octiron.msp.redhat.com>
In-Reply-To: <20210928174246.GF3087@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c0807bc0-bb1c-46e6-3e8c-08d982b44a5c
x-ms-traffictypediagnostic: DB8PR04MB6843:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB6843CE1A29DAFADB8B16C8FAFCA89@DB8PR04MB6843.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Xg2/jSv+KGp/RcC7l/LuiY7G+Ggjf25GxPSYO+Rdpwv2kCcrYsmqGwKJiTwXL+6hSg4q2h6tE9bOT5TnhIqoQ3D7Fg3m8eMrKEB8b86e4wZjvrZG9JwhVzj4l+6RPI2jmY0BXSHfjiHv+X8s6YYg6MiaKHreW/r41ejSoWkexdGke9tsQR9BUZ2UiLAt6fPH02d4yWEkD59CCA+9MSSvQtG0DY0/lJbCj0CajASakImWJcKV+63Uam8rVS4ZQ13kN1FJ6ElxUqrulWegYduf0F43cqZbI9yhL4IxCxbmYB8WTv3ioifdUwLZFhhOmX0FVTleZEuZ80WbBivedRNAz59z2giuJoR+lwEpr8H+zjku/eHtZJ4V7lHeSKPwpyR9XlDUrz0Q3hCQJJFmv4B6sH48gFrP+Mnsw9c+K1TY9Gh5Wo7rRHvBNTRvhxoHHnGrk/JwRRvcdL149tu9Vd4MxD52w6JtVVZC8E0I+r/JwQIbS5Ugxevn3wp3KPNYtr7wEx8QvQ3xDemAJO9q/kj2UZl9rLzZAkV74XWCGndSrZvb+DB3EaLdZtqtd6zISRQCSPM/nAJPbjFMFmwoWQKhCIagHbK+tlJ8BMrJkHaYZwRVlFd1MS2LzcUOQ5+t8C5lu5hAeU4WGNJxsjF0Ph0iH99l0DLXyJeufI7x1rlYEExfs6iX1YFDOFFTnhLSHnpwj+DiALacIIKJlassclj7Kw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(8936002)(450100002)(38100700002)(66476007)(44832011)(2616005)(66946007)(6916009)(122000001)(66556008)(54906003)(6486002)(83380400001)(26005)(186003)(64756008)(316002)(6506007)(2906002)(66446008)(5660300002)(508600001)(36756003)(6512007)(91956017)(76116006)(86362001)(8676002)(38070700005)(4326008)(71200400001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?doKeX0OlyEbDsMohVYS9Cxlz8oUeaO7uONTohkX/i0XVK0Cw9X9JBF3Dy?=
	=?iso-8859-15?Q?9axwO/ne10k6/O3eCgJ2PHNr7DcM5uIdn6Fmka7BGmeKqvZ/MAErZQXme?=
	=?iso-8859-15?Q?q/bgHGc/lheq+E4Y0SIhfatrMddG5aIvXIig2Tbc0WDkoVvuwQ1ZJnO6p?=
	=?iso-8859-15?Q?DHlC9SoU7rDfgoRHta/Z8mWTNZOWvczukiDIjN8qCJeUqZWjXIR2pzqpj?=
	=?iso-8859-15?Q?/PgNL9D0CWG9/1QFMR9JyeWleIyfFfNcXeFxIGBF9urW36tbKO8kLoVFX?=
	=?iso-8859-15?Q?9XV4nguH9yqV9o9Hh+LR/b2yNEt9FFTlZilL96jhMUbHqsE2sWTNcte55?=
	=?iso-8859-15?Q?FGmAPHgaFMyLvSkKkH5xYIgQzGh/vDF+PzkC1ZEAHqxX9yHmY1qclZvky?=
	=?iso-8859-15?Q?S4YLoW7W+KbtQAIyL2zsViobguYndE2bmN0iBI/RFGjRhQjlHKJvdAvlO?=
	=?iso-8859-15?Q?OqEnesiWbmK7fUyuktOB80y7R8+oHqXxDM8kX5EhymSolAChkcHlU/mk5?=
	=?iso-8859-15?Q?iZjILDjMg3Hcl8XXlEdr9QobqxMgTBx7C5dzOVdxY5RlIijZOjUKl2ZRR?=
	=?iso-8859-15?Q?HXSxy0HKgKKHLsdh9oK7zfjdrrkrUwWcqh0fKgkycVQUqYptJBXpLFx/d?=
	=?iso-8859-15?Q?ftQp+UqZHHK63pxfF6VnQEwsAofa5mghIsc6dIOF7IkdgfDZSEUpELT+p?=
	=?iso-8859-15?Q?o3dQn63fpNprWY1Qt8YgpXnJc1ki2eyaQtq4sshWazUr/5VMOEFsEeqVE?=
	=?iso-8859-15?Q?p60bBO4O6kqkBjzBqijQd6i21vqWJg9TTMQrkzVN8DvpiAdC96bfEUlhE?=
	=?iso-8859-15?Q?eR9QvIRS5FI8DIsmCGyna+Izvx+ax/vuJM0jGC1ud285NJbLQplzXGqXt?=
	=?iso-8859-15?Q?cj1SoSskbgbC/Wyn81z715ko95ikB4kT16BryyAXrvVyP5/QrKEConYA7?=
	=?iso-8859-15?Q?D+cbxlJT/Fs/3fY4x+g5PkG7JSyJdFScp2DtdKuygeYH2aiSlS1kuTiv1?=
	=?iso-8859-15?Q?orOW2SzA1pgL4wM+ii8ImlecO7iUUi44QrUkqK5JR0mk53HzYgtRv92Sv?=
	=?iso-8859-15?Q?1Wr4grBlVQwKHK3hr+CWnksl2ImQ5ePPx5ZnGxm0sRejCCC9Xcx6rC0Cr?=
	=?iso-8859-15?Q?s9XthqwxuHfX0nkK/wsIoZdPI2koPof73MZjBnotyRcpRyYjBhfR0vGca?=
	=?iso-8859-15?Q?DzuSUN3+KtHEpuGcS6TYdHdjPd8pqr+ixIcsl7ggGqJG/SjQ008z702Ek?=
	=?iso-8859-15?Q?cJFIM70FlBj4xytCD6QBHXxJoXha8fKURjwQt7oMt6UFHW5MrhmyEOs+O?=
	=?iso-8859-15?Q?Mb5t5A0V0Q3VOCLZ60X5T98VaWTQ3RWU6sMJqiMBb6E6qSBT49L0yy37X?=
	=?iso-8859-15?Q?LpWfD/O2DVsctXK645Yj9SVizrclruu3/?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0807bc0-bb1c-46e6-3e8c-08d982b44a5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2021 19:15:10.2259 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jG0foKLXz2KRWpiY3zHjFVjtrM37V6CzItmyuUQRbicQGIHQEtd+YtZ75N9cv8ySuw6568bNt+aL0oz7OKVueA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6843
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18SJFIK6002836
X-loop: dm-devel@redhat.com
Cc: "prajnoha@redhat.com" <prajnoha@redhat.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"teigland@redhat.com" <teigland@redhat.com>,
	"zkabelac@redhat.com" <zkabelac@redhat.com>,
	"linux-lvm@redhat.com" <linux-lvm@redhat.com>,
	Heming Zhao <heming.zhao@suse.com>
Subject: Re: [dm-devel] [linux-lvm] Discussion: performance issue on event
 activation mode
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
Content-ID: <2CC7E3C872FAE9449F49AE9958E6F35B@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-09-28 at 12:42 -0500, Benjamin Marzinski wrote:
> On Tue, Sep 28, 2021 at 03:16:08PM +0000, Martin Wilck wrote:
> > On Tue, 2021-09-28 at 09:42 -0500, David Teigland wrote:
> >=20
> >=20
> > I have pondered this quite a bit, but I can't say I have a concrete
> > plan.
> >=20
> > To avoid depending on "udev settle", multipathd needs to partially
> > revert to udev-independent device detection. At least during
> > initial
> > startup, we may encounter multipath maps with members that don't
> > exist
> > in the udev db, and we need to deal with this situation gracefully.
> > We
> > currently don't, and it's a tough problem to solve cleanly. Not
> > relying
> > on udev opens up a Pandora's box wrt WWID determination, for
> > example.
> > Any such change would without doubt carry a large risk of
> > regressions
> > in some scenarios, which we wouldn't want to happen in our large
> > customer's data centers.
>=20
> I'm not actually sure that it's as bad as all that. We just may need
> a
> way for multipathd to detect if the coldplug has happened.=A0 I'm sure
> if
> we say we need it to remove the udev settle, we can get some method
> to
> check this. Perhaps there is one already, that I don't know about.

Our ideas are not so far apart, but this is the wrong thread on the
wrong mailing list :-) Adding dm-devel.

My thinking is: if during startup multipathd encounters existing maps
with member devices missing in udev, it can test the existence of the
devices in sysfs, and if the devices are present there, it shouldn't
flush the maps. This should probably be a general principle, not only
during startup or "boot" (wondering if it makes sense to try and add a
concept like "started during boot" to multipathd - I'd rather try to
keep it generic). Anyway, however you put it, that means that we'd
deviate at least to some extent from the current "always rely on udev"
principle. That's what I meant. Perhaps I exaggerated the difficulties.
Anyway, details need to be worked out, and I expect some rough edges.

> > I also looked into Lennart's "storage daemon" concept where
> > multipathd
> > would continue running over the initramfs/rootfs switch, but that
> > would
> > be yet another step with even higher risk.
>=20
> This is the "set argv[0][0] =3D '@' to disble initramfs daemon killing"
> concept, right? We still have the problem where the udev database
> gets
> cleared, so if we ever need to look at that while processing the
> coldplug events, we'll have problems.

If multipathd had started during initrd processing, it would have seen
the uevents for the member devices. There are no "remove" events, so
multipathd might not even notice that the devices are gone. But libudev
queries on the devices could fail between pivot and coldplug, which is
perhaps even nastier... Also, a daemon running like this would live in
a separate, detached mount namespace. It couldn't just reread its
configuration file or the wwids file; it would have no access to the
ordinary root FS.=20

> >=20
> > > Otherwise, when the devices file is not used,
> > > md: from reading the md headers from the disk
> > > mpath: from reading sysfs links and /etc/multipath/wwids
> >=20
> > Ugh. Reading sysfs links means that you're indirectly depending on
> > udev, because udev creates those. It's *more* fragile than calling
> > into
> > libudev directly, IMO. Using /etc/multipath/wwids is plain wrong in
> > general. It works only on distros that use "find_multipaths
> > strict",
> > like RHEL. Not to mention that the path can be customized in
> > multipath.conf.
>=20
> I admit that a wwid being in the wwids file doesn't mean that it is
> definitely a multipath path device (it could always still be
> blacklisted
> for instance). Also, the ability to move the wwids file is
> unfortunate,
> and probably never used. But it is the case that every wwid in the
> wwids
> file has had a multipath device successfully created for it. This is
> true regardless of the find_multipaths setting, and seems to me to be
> a
> good hint. Conversely, if a device wwid isn't in the wwids file, then
> it
> very likely has never been multipathed before (assuming that the
> wwids
> file is on a writable filesystem).

Hm. I hear you, but I am able to run "multipath -a" and add a wwid to
the file without it being created. Actually I'm able to add bogus wwids
to the file in this way.

Regards,
Martin
>=20


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

