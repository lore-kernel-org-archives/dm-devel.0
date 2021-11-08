Return-Path: <SRS0=u3eZ=P3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C354C433EF
	for <dm-devel@archiver.kernel.org>; Mon,  8 Nov 2021 19:12:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 871D6610CB
	for <dm-devel@archiver.kernel.org>; Mon,  8 Nov 2021 19:12:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 871D6610CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-pJzzYXpQNj68MwlCmALllQ-1; Mon, 08 Nov 2021 14:12:03 -0500
X-MC-Unique: pJzzYXpQNj68MwlCmALllQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9885C8799EB;
	Mon,  8 Nov 2021 19:11:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0896C101F6D4;
	Mon,  8 Nov 2021 19:11:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 65002180BAD2;
	Mon,  8 Nov 2021 19:11:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A8JBqOh019629 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 8 Nov 2021 14:11:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7A5C71121315; Mon,  8 Nov 2021 19:11:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7523B1121314
	for <dm-devel@redhat.com>; Mon,  8 Nov 2021 19:11:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C6C280A0AB
	for <dm-devel@redhat.com>; Mon,  8 Nov 2021 19:11:49 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-60-10kkIwsSPhusT9XvI3PogQ-1;
	Mon, 08 Nov 2021 14:11:47 -0500
X-MC-Unique: 10kkIwsSPhusT9XvI3PogQ-1
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
	(mail-db5eur01lp2058.outbound.protection.outlook.com [104.47.2.58])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-5-zd32K5W1N8mWHGgRdphudw-1; Mon, 08 Nov 2021 20:11:45 +0100
X-MC-Unique: zd32K5W1N8mWHGgRdphudw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB6PR0401MB2518.eurprd04.prod.outlook.com (2603:10a6:4:36::17)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10;
	Mon, 8 Nov 2021 19:11:44 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4669.016;
	Mon, 8 Nov 2021 19:11:44 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH 5/7] multipathd: fully initialize paths added by
	update_pathvec_from_dm
Thread-Index: AQHXxebeV4GFGv0wyUqQuLf4uivcTKv0BbIAgADVtYCAALbYAIAAGUOAgAREaYCAAAcvgIAACbwAgAAcSoA=
Date: Mon, 8 Nov 2021 19:11:44 +0000
Message-ID: <39604b8ae2718e822d06f89905bb2575251433a2.camel@suse.com>
References: <1634757322-6015-1-git-send-email-bmarzins@redhat.com>
	<1634757322-6015-6-git-send-email-bmarzins@redhat.com>
	<2a319ae1e5eba66db17ab6372c95ac81f75a92e2.camel@suse.com>
	<33b4e4f8942ab340b4fba39e91c3d10e9c6aa402.camel@suse.com>
	<20211105214936.GO19591@octiron.msp.redhat.com>
	<c137193a6dbc7ea9ce25d06766874012de2f8ed0.camel@suse.com>
	<20211108162955.GR19591@octiron.msp.redhat.com>
	<40e458b6a89435469238548fe41a08bad57acad1.camel@suse.com>
	<20211108173028.GS19591@octiron.msp.redhat.com>
In-Reply-To: <20211108173028.GS19591@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7134d093-244b-439f-5878-08d9a2eb9a7b
x-ms-traffictypediagnostic: DB6PR0401MB2518:
x-microsoft-antispam-prvs: <DB6PR0401MB2518CA951A2B34C1CCE87905FC919@DB6PR0401MB2518.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: xW7aErf1Z8Cgr48ZWTdhoenJFXNoxfy6j2Z+EZQbz7FAH3tuv/OkRwvAiUQoJZGy20QZ6teW9zqxKIMaiXhP4Iiw3XJ0Y+X3uaBuiafah3H7E0yDYSiDzg567DB03wtDcrSADUz3kEL52vFQuMpdRzIUWxN/vb0H4B+0XlSbCstiestMyPETHx4cCmW240GvZX6+kCT0aoR9qzi+snUc2R/WWZtiGQTJUcX8D2tS0cH9LrpBL++MPsiP5HOhMzAhPCYRfUKwHiNZgQOFgFL1YBJ8qNEFjyh4u8uQrkAuTG684wbfn0RDO+0FkdwJ3gdUnWjuMIGIZxs07Mw4cZk2j96x1DxK2lX0X4z0MYI1+xYL7MOBtp3r0qgxSvGVgPH4XKWA69J/MRbHl4Fe5Dy21f9wRUp6xd8aGyB/m30dowpnLf+VT6f3z6ky7Nx3mHcxzd9z2tvMmtacbtEJUN6S0rB4Qi9k8jSLrG1AvCJgV9byHjPadwvhg8SYg1DD2IFLWC7HNF0mNp0rYUNgViajqHxIcukwmqf7To9jVyddL2T9w53/jnkoTbRHZhfkh7tezCEC9lc2KxU4/aCdf37seFfMY0wjymb5DkptmSeIBJvqJjBH+yQ8m495onRvqot9eVwg2sTduU3Hsbr90mHmiY2bQSV/EJ9FcvX/ZQanoE3xoy2heJlC6Mrp2PvuJ99GUTfhYSxI2Zm2omoGc9P+bg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(186003)(6916009)(122000001)(6486002)(71200400001)(38100700002)(8936002)(26005)(5660300002)(4326008)(64756008)(66556008)(66446008)(66946007)(66476007)(86362001)(44832011)(6512007)(76116006)(91956017)(83380400001)(6506007)(36756003)(8676002)(2616005)(508600001)(2906002)(54906003)(15650500001)(38070700005)(316002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?KnfTFZg8UFP1KpxUYJdVYUSpfoctL/HmVKc3lk7ysROHU/r3DVjkLax39?=
	=?iso-8859-15?Q?WVpg/bbP4Y8xZ24Poq3nofmhiYmt9YTXg4ufAm+3q26ikrrG71J6xPa6n?=
	=?iso-8859-15?Q?gGybdPWhtFT2AgDwgveY1QG4TuyleUPPp3qBqwcGchKq0l7nm9wr7n4b0?=
	=?iso-8859-15?Q?Xg6ZJqh+Osvt06rQW4rUQLmo8vxrHWVtVOBw7oyWOaNaHs9GoEM/TFejC?=
	=?iso-8859-15?Q?T64QFZyU2A4z4EQ9LbzodUwXO7tRMdz5AyXF0+vN2wRC9HXXk0MRniE8M?=
	=?iso-8859-15?Q?WPbUSHrap4QNwbJMrrC+tmfYjTaWxQtZvyPqHI25cnHKQXQnLXHCamHCg?=
	=?iso-8859-15?Q?5TAtVbHTvHlsrNuWcBi5tCXIAOr2khnUfgurAHmGiEDySQA2gOb4GaIBv?=
	=?iso-8859-15?Q?++Xs0WOJIspIfPIcji2KDwpSTSNQRZ/GX7q5Mta9y/nW/Rg2khmxsBBHZ?=
	=?iso-8859-15?Q?XTzZkON2Ojw/eGk2HvI811+ti1Ck7Unr2EhBmf7J2/SGbPoMm+wZuGuXd?=
	=?iso-8859-15?Q?x1M+osP8dHAg3G3UtUCZNRLxtwk8CBqEijavSuIU174fXWDghLOezsy+6?=
	=?iso-8859-15?Q?ga5Xq+/VEKmEphNV9BHNEyq/H/nPpdCnrfogrJWwxUXX+dG8FsS/tCmHq?=
	=?iso-8859-15?Q?83n3rO7Be1ndzArpuciqaxVU5SE/5P44JWCdxakMMKIQ/Z0k5vuhmm/18?=
	=?iso-8859-15?Q?67OaN1CJrTCknLkIQM1FDZKbPI67F3JkWynEkqF5TzDrhg4+ZPk79XnMn?=
	=?iso-8859-15?Q?WxooQ4X/Ryyv9nojItoftH/OpMzLo4/KKLFioYirxV87wYXcWBnt+IBad?=
	=?iso-8859-15?Q?60XWDcAFStRQ6xQC5WtjNoR0J+a4L2RwPgJ89zvrxSi7niu3WmcXtUgbR?=
	=?iso-8859-15?Q?98BjYvw31e3jBJc5mv4cHZbloDQVLUIZ9MJIIOjyf1/KaTHPtnCDn0hKN?=
	=?iso-8859-15?Q?YdjQBpbrqgMdUZr7J3UFrfxuJ/W5WFPE7EBont2XhXp/VOrqRPhyMFvi3?=
	=?iso-8859-15?Q?sJJrdEm19DyW8KT+P2llCD9Q9Edt9O3ItUEpG4LmcUJr1RtcJWj0P4+yG?=
	=?iso-8859-15?Q?7NYcmtCp6gHLHmwImgQPfNnX9bYKaYLddRkTFJJXmzAaXMvWrOAtu121p?=
	=?iso-8859-15?Q?voyMh7DUvozrczapNEejAtK0UXOdLN8FL7ELgt9tiy8rAE+I/2fLn7Ymy?=
	=?iso-8859-15?Q?T0/9rdPpVgTub/7Rck3NdiQZsqVonaY+7rhqYCJtlXIn73bVhEEeKY9e5?=
	=?iso-8859-15?Q?RnmCvCTWAiNTgKMoT2ZmAl9rcmUUj/GKQXcrSja8Upf9qTT++VdUTrYSc?=
	=?iso-8859-15?Q?7+jn+mYCboOI9m3yNttLUDK4bgA51ZrVAamj9Whi1l+41rN/JgTaQNXMT?=
	=?iso-8859-15?Q?5myEPzjGzlRnye9rpqmkB4aBHcvs9fISklCwr9Op3p2END0liBABk00SR?=
	=?iso-8859-15?Q?VkthZ/Vw8VpZcyfho/4NooAIA/uGEcJAZHlmhj1FsecdQOKJD6cRNSZt2?=
	=?iso-8859-15?Q?R9mWsGAHbemirZPFW8WU3BxsMzr6yu7jFTprMcwcoKvNjHBUw42t3UZCf?=
	=?iso-8859-15?Q?wAnLt3ABxe1X0J7ZVhfPdlhDy/4oMWHehgLmSPwMACLMGVjVFLalkMUmp?=
	=?iso-8859-15?Q?rb6Ko8LJW0z7dHtuopfSE5JLETP/rmW3RwB69fmDAY5JfdN9f8aGHLZMp?=
	=?iso-8859-15?Q?BdWd5w3AcuePhmydh4FFlABWf5k7c047lnQkAd7oZFDGjOM=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7134d093-244b-439f-5878-08d9a2eb9a7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2021 19:11:44.0935 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LbOqLW214WHJEHxmrby4JZIAYfai9792fPukU30ykowCVemRY2mTG+GOpTXhsrfUvDqym73pAfLzmo/6U9RCJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2518
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A8JBqOh019629
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 5/7] multipathd: fully initialize paths added
 by update_pathvec_from_dm
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
Content-ID: <B89BE8E82608CF4FA95F4998D0B2137A@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-11-08 at 11:30 -0600, Benjamin Marzinski wrote:
> On Mon, Nov 08, 2021 at 04:55:37PM +0000, Martin Wilck wrote:
> > On Mon, 2021-11-08 at 10:29 -0600, Benjamin Marzinski wrote:
> > > On Fri, Nov 05, 2021 at 11:20:01PM +0000, Martin Wilck wrote:
> > > > > 1: udev hasn't gotten an event for a device
> > > >=20
> > > > I don't think we can detect this without listening for kernel
> > > > uevents.
> > > > And even if we listen to them, we could have missed some. udevd
> > > > doesn't
> > > > have an API for it, either, AFAIK.
> > >=20
> > > Isn't this the most common INIT_PARTIAL case, where we are
> > > waiting
> > > for
> > > the coldplug uevent? If there is no database file when we are
> > > processing
> > > the device, we are in this state. Correct?=20
> >=20
> > Not necessarily. udev may have got an event, but not have finished
> > processing it, or failed to process it entirely (e.g. because of a
> > timeout, your case 2.). When udevd sees an "add" or "change" event
> > for
> > a device for the first time, creating the db entry is the last
> > action
> > it takes. During coldplug, udevd will receive a lot of events
> > almost
> > simultaneously, but it may take considerable time until it has
> > processed them all.
>=20
> Fair enough. So if the first uevent hasn't completed already
> successfully, it's gonna be hard to know why.

I just realized that what I said was wrong.

The worker does this (udev v246):

worker_process_device()
  udev_event_execute_rules()
    udev_rules_apply_to_event()
    update_devnode() /* symlinks etc */
    device_ensure_usec_initialized() /* set USEC_INITIALIZED */
    device_update_db() /* here the db file is (re)written */
       /* from this point on,=A0
          libudev will consider the device initialized */
    update_devnode() /* again */
    device_set_is_initialized() /* sets is_initialized property */
  udev_event_execute_run() /* Here RUN is executed */
  if (udev_event->inotify_watch)
     device_update_db()  /* again, this is what I was referring to */
device_monitor_send_device() /* send "udev" uevent to listeners */

If a worker is killed because of timeout, or exits with error, udevd
will receive SIGCHLD and delete the db entry for the device in
question.

> =A0
> > > > > 2: udev got an event but timed out or failed while processing
> > > > > it
> > > >=20
> > > > This would be the USEC_INITIALIZED case, IMO
> > >=20
> > > If udev has, in the past, successfully processed an event for a
> > > device,
> > > but fails while processing a later uevent, it doesn't keep th
> > > data
> > > from
> > > the previous event. So it could lose the uid_attribute. But the
> > > database file should still exist. Correct?
> >=20
> > That's true. But we can't do anything about it. libudev will return
> > what the database currently contains, which is the content from the
> > last successfuly processed "add" or "change" uevent, whether or not
> > other uevents are in the queue or being processed. I don't think
> > this
> > scenario matters in the current discussion about partially
> > initialized
> > paths. This is the "changed wwid" scenario which I think we handle
> > quite nicely today already. Or am I misunderstanding?
>=20
> If both events occurred before multipathd started up, then this
> wouldn't
> simply be a "changed WWID".=A0 The hope is to be able to reliably
> distinguish this from case 3, where the data from udev is fine, but
> the
> uid_attribute still isn't there.

I'm not quite getting this. Are you talking about the case where one,
or both, uevents are lost?=20

IMO we can use udev_device_get_is_initialized() as test. AFAICS it's
basically equivalent to USEC_INITIALIZED being set. If that function
returns true and uid_attribute is not set, re-triggering an uevent
makes relatively little sense to me. The likelihood that the next even
will yield a different result is pretty close to zero.

If if the first uevent is handled successfully but the second times
out, udevd will delete the db file (see above), but no uevent will be
sent to listeners. So multipathd will be ignorant of the lost / timed
out event. There's nothing we can do about that.

Regards
Martin








>=20
> -Ben
>=20
> > Cheers,
> > Martin
>=20


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

