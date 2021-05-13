Return-Path: <SRS0=4utB=KI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA0AAC433ED
	for <dm-devel@archiver.kernel.org>; Thu, 13 May 2021 19:37:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 39CF7613F1
	for <dm-devel@archiver.kernel.org>; Thu, 13 May 2021 19:37:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 39CF7613F1
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-nfO3b0nuMqOyTq0PucXw_Q-1; Thu, 13 May 2021 15:37:15 -0400
X-MC-Unique: nfO3b0nuMqOyTq0PucXw_Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB923C741E;
	Thu, 13 May 2021 19:36:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C9E9226F1;
	Thu, 13 May 2021 19:36:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 73C3E18005B6;
	Thu, 13 May 2021 19:36:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14DJatNu017514 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 13 May 2021 15:36:56 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DC8491649DC; Thu, 13 May 2021 19:36:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D63FF163594
	for <dm-devel@redhat.com>; Thu, 13 May 2021 19:36:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4CC1A85828E
	for <dm-devel@redhat.com>; Thu, 13 May 2021 19:36:51 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-25-m4aBWowKP2u5LXb0Pg0BZw-1;
	Thu, 13 May 2021 15:36:49 -0400
X-MC-Unique: m4aBWowKP2u5LXb0Pg0BZw-1
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur02lp2058.outbound.protection.outlook.com [104.47.5.58])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-39-mHKgTbmlMG6UbTuIiPw2DQ-1; Thu, 13 May 2021 21:36:46 +0200
X-MC-Unique: mHKgTbmlMG6UbTuIiPw2DQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB6PR0401MB2357.eurprd04.prod.outlook.com (2603:10a6:4:4b::17)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25;
	Thu, 13 May 2021 19:36:44 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.4108.031;
	Thu, 13 May 2021 19:36:44 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [dm-devel] [PATCH 3/5] multipathd: make ev_remove_path return
	success on path removal
Thread-Index: AQHXRrx9QRn2HTqim0uQGVS/yH6it6rfuRYAgACKSYCAAAw3AIAAFTwAgAFsUQA=
Date: Thu, 13 May 2021 19:36:44 +0000
Message-ID: <29077ef5a48882ad93ff81b5c9fc649971b8ebdb.camel@suse.com>
References: <1620775324-23984-1-git-send-email-bmarzins@redhat.com>
	<1620775324-23984-4-git-send-email-bmarzins@redhat.com>
	<66c4ca02bb90a7a4c18819082d2ec554ddc56205.camel@suse.com>
	<20210512195305.GE25887@octiron.msp.redhat.com>
	<7e6fb44f90e6088f53a41396a7e210cd3009d469.camel@suse.com>
	<20210512215248.GG25887@octiron.msp.redhat.com>
In-Reply-To: <20210512215248.GG25887@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.206.153.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d31cec86-aaa7-4e0a-1579-08d9164670d0
x-ms-traffictypediagnostic: DB6PR0401MB2357:
x-microsoft-antispam-prvs: <DB6PR0401MB23579DC79D70AD0A643C5D8DFC519@DB6PR0401MB2357.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1051
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: qXzz1PYD+pKiybU9yv265lG+qQeXHkE2xfx+W8P0idL4n8ZDHBgHJUbSaeie6OrgQQzUTTkKB4bYV/LfwtwYfM+X19BppBIDEpy7gnKTKjzJR+3MiVPY+5YvoSKbQxssKwO4ULkfS0k5srgEY8xbT6OEkk6aproCPPmdUowWcz+1tRJ0sHkVa2c58xkbJt9u/X0cT6gAuIch8NTFjtewRtu/OLOaKx1/YeltKxXxKtZ4BiKDM0DKoPFdNEMI/FA9wla9frakIXk02k+R9DP2TZ3ybktcdvnKm5lUZtZtsm7bePpSyAkDALsPzZqv8/OA3JszEXvxsp2WozO5WcyeA6RrDLzDsHr7Gixk3XHxmM2OqaqV5uXeu59NqB+YnkrXOxR7gebtof90bFk+8VpGkf74/c6PsZqKYVHSM2/jlxen680Ux1aSwm/tON50fDXdWxVyUcwJT0WnCILTUwTvOVAWjbVmrpv1w61OO7jPXraI6z5SkvaYigffWU2DaliQ4w+WNZhp2avvBEQK6T1hWxYDeseAdb3U38G9sFVf5AfSMLbOA723O++zFkvU3boDYVPQXQNoQZBf2OiDFB3vtBcjpB4fSMAAjKHTgubDBtIYwOY5YgMfTDZA1AIQFyoIMhxfgIsV7Xv88RDA3G74+2qopvHttpUmDv6utoOPOvg1ao0SrcMkMfFwPpEqMlAP
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(346002)(396003)(136003)(39840400004)(366004)(376002)(91956017)(76116006)(6916009)(66946007)(478600001)(6486002)(966005)(26005)(6506007)(66556008)(66476007)(83380400001)(316002)(122000001)(450100002)(5660300002)(2906002)(44832011)(71200400001)(6512007)(186003)(4326008)(36756003)(86362001)(8676002)(8936002)(2616005)(38100700002)(66446008)(64756008);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?NqNkG9NMZBe1ZVZFkEs0XRWZCYyJPObDTyI1WS4WPZ8JG39ajCREEF4SK?=
	=?iso-8859-15?Q?iba32EXKsKYN0XuKxKczMNzpbYZmKSDfqayE+/Y56WZUVzC86fZ3tg4JL?=
	=?iso-8859-15?Q?7Btmm2HFK5e4cO0rHvvftcg/K90OkkJy/irqhhNuQpvCadJRItg7bDQ0l?=
	=?iso-8859-15?Q?9q13ZVUCEx/l3Q1y/9WeSxAb5QS2d7QXEfZCg0JoDX/ryINc4sCMW+BAU?=
	=?iso-8859-15?Q?/Ur6fKpzXOOOhQfM3Ul/SF95jPHp/NE0QIgEuCsDB6jqCv12xjQ1PqcV2?=
	=?iso-8859-15?Q?AGvO+hlHlH0pI28W39HS1uMt9rgsP3ZRY/OEZF2UOy0Y+E36fC/tiwp0z?=
	=?iso-8859-15?Q?4YL0AmdjUTRcYBhOJfgYkSPzggT8ZLXu26RdIp/xiFPrTRpH8+WIHaJlw?=
	=?iso-8859-15?Q?SIJ+Ltg7g/eKJ6hvh3Z50waAHJQXn1kgwxtRfM2utwy+l/cWHfZy6B/1y?=
	=?iso-8859-15?Q?BR9SZ8QbWqiVPJVqdhoHvGhPsMdUPMNsu3lgvETxj1eMNJx6lQoBdGkDg?=
	=?iso-8859-15?Q?P1CRnfihiOED58Dgyf0RTvr8E5ZLElj6FnV7Zt9qH82SnohRDPxp1kN0H?=
	=?iso-8859-15?Q?YZT/F1nxwnUZK+PcJOTineMEDqcUDcXv3D7MMsaXJoLP0tO2LKrfU0yUa?=
	=?iso-8859-15?Q?VQYkH15YXyyucQo1YhSzqOJX3vu8WHQYXrYDhmiFRtH3KiT/rLIHXgXZI?=
	=?iso-8859-15?Q?soyVLUlM06GmjkAQFn4X78OwNarsoA+mj2sLdnY1fWx8T04mWcV2USkhd?=
	=?iso-8859-15?Q?C91AHzQqASaYQlCrbPFRDmBL5oBXJN4mKRc542tBJtMYWwvz8DqSyA5+9?=
	=?iso-8859-15?Q?wl7Jyg9MEAJfCubBYyfUkbQ02GBx/W6gCuRhu94VJRHIoSK1Iio5H27Wo?=
	=?iso-8859-15?Q?/aDEXTaktW4KNjaZAeSBa/hk6lMmtqos630Oic8oP7w8v6h5SKhDYA/d0?=
	=?iso-8859-15?Q?HknacMhyLuLj2sWVSQoio6PPOxmQYFCMNOtcMIfyYYFKQ8cScgwPgy+3+?=
	=?iso-8859-15?Q?JiugU3TZg/1EJ+Qp8Wrn4SNVLqnOGxxCxXOsEJcPoMRKvJFDaemkP3zUE?=
	=?iso-8859-15?Q?H3Po2irHQZhBiYHcffADZywaFtl4eU62RlZNn0Pwo3VPIVNluMZYeINks?=
	=?iso-8859-15?Q?yyG8GUp/xvkmnCCwXAUhGMZq91i0fGRsvHMu0gPEQ9ubil873eGKu6Dbp?=
	=?iso-8859-15?Q?iexKuBVlAQYdwnGZWfcAs36dQftL6imIkASSiQus7QfDZFOjLYcvGamD5?=
	=?iso-8859-15?Q?HHVy9/NGi6rVeTfFDN3Br1ZeMsaGqpSkpkzODGOmklsAMD7GOZDGa7FGu?=
	=?iso-8859-15?Q?/pyczxGanzg1pEo2vfpvLJvKm9c97AwftGcjFwkwtbIr0f8HtTV/rMVQi?=
	=?iso-8859-15?Q?CwyrOQu4RiinADtsSVnyiDxbBH4aKpJY/?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d31cec86-aaa7-4e0a-1579-08d9164670d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2021 19:36:44.5053 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mv7M4VMzg94fUUmd9p5pR8KwM9PWu27hNzbvUpSnb57UhpDQZq49TrqeYHVC/GADzey+r30H8FTPyzM6NuEuXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2357
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14DJatNu017514
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 3/5] multipathd: make ev_remove_path return
 success on path removal
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
Content-ID: <EF44405BEC507D468C6084C6388F0231@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-05-12 at 16:52 -0500, Benjamin Marzinski wrote:
> On Wed, May 12, 2021 at 08:36:49PM +0000, Martin Wilck wrote:
> > On Wed, 2021-05-12 at 14:53 -0500, Benjamin Marzinski wrote:
> > > On Wed, May 12, 2021 at 11:38:08AM +0000, Martin Wilck wrote:
> > > > On Tue, 2021-05-11 at 18:22 -0500, Benjamin Marzinski wrote:
> > > So AFAICS, the only way for a path not to get removed is if you
> > > succeed
> > > with wait_for_udev or !need_do_map, or if you fail in domap.
> >=20
> > Agreed. Let's fix these comments.
>=20
> Yep.
> =A0
> > > =A0Since wait_for_udev can happen in more situations,
> > > it's a lot harder to say what the right answer is. For
> > > cli_add_path
> > > and
> > > uev_add_path, it seems like we want to know if the path was
> > > really
> > > removed. So returning failure there makes sense.=A0 For
> > > cli_del_path
> > > and
> > > uev_remove_path, it seems like we want to avoid spurious error
> > > messages
> > > when everything went alright and we're just waiting to update the
> > > map.
> > > So returning success makes sense there.
> > >=20
> > > Perhaps the answer is to return symbolic values, to describe what
> > > actually happened, rather than success or failure.
> >=20
> > This is what I meant. I didn't express myself clearly enough; I
> > just
> > thought that 0 doesn't have to mean "success".
> >=20
>=20
> Sure. I'll add symbolic returns.
>=20
> >=20
> > I think the callers just need to know if the path is still
> > referenced
> > somewhere. Acting appropriately is then up to the caller. You just
> > proved that my cases a) and b) are actually equivalent, which is
> > nice.
> > Perhaps we need to introduce another return code indicating that
> > the
> > entire map had been removed (e.g. failure in setup_multipath()).
>=20
> The more important return to me seems to be an indication of whether
> the
> remove has been delayed.=A0

To make sure that we talk about the same thing: when you say "the
remove has been delayed", you mean the case where we just set
INIT_REMOVED, without actually deleting the path from pathvec etc.,
right? This is what I meant with "path is still referenced somewhere"
in my previous post. Ack, this is of course the most important thing
for the callers to know.

>  For uev_remove_path(), you don't want to
> return failure just because the remove has been delayed. Otherwise
> there
> will be spurious error messages in the logs.

With the introduction of INIT_REMOVED, I think we could do away with
these error messages altogether. uev_remove_path() could actually be a
void function. We *know* that at least INIT_REMOVED will be set, which
means that that path will be treated by multipathd as if it didn't
exist. The error message you're talking about would be the highly
unhelpful "uevent trigger error" message - we might was well just ditch
that message. We print much more meaningful messages in
ev_remove_path().

>  cli_del_path is a little
> trickier.=A0 My biggest question with that is whether it would mess
> with
> people's scripts to add a reply message saying what happened. It
> seems
> like it should only fail if domap failed. But it would be nice to
> tell
> the user that the remove has been delayed, or that the map couldn't
> be
> reloaded and was removed as well.=20

Same argument here. As far as multipathd is concerned, that path will
be gone. We print "fail" if the domap() call failed, and we should
continue to do so. We could add documentation saying that this means a
"deferred removal".

>=20
> > > > However, this goes beyond the purpose of your patch. *If* we
> > > > remove
> > > > the
> > > > map, returning 0 is correct for either a) or b).
> > > >=20
> > > > P.S. 2: I wonder if the logic in uev_update_path() is correct.
> > > > Rather
> > > > than calling uev_add_path() after rescan_path() directly, I
> > > > think
> > > > we
> > > > should rather wait for another uevent (and possibly trigger
> > > > another
> > > > "add" event, I don't think "rescan" automatically generates
> > > > one).
> > > >=20
> > >=20
> > > Yep. You're correct. I'll fix that.
>=20
> Actually, I take it back. The code seems to work o.k. as is. The
> uev_update_path() code checks if get_uid() now returns a different
> value, instead of using get_vpd_sgio() like the recheck_wwid code
> does.
> This means that the uid_attribute must have already gotten updated
> when
> rescan_path() is called. So my real question is "is there any real
> benefit to calling rescan_path() at all here". This code seemed to be
> working correctly before we added it, except in the case where
> uid_attribute wasn't getting updated (which recheck_wwid now will
> hopefully catch).

My point was that calling uev_add_path() right after rescan_path() is
wrong, and I still think so - *if* we rescan, we shouldn't look at udev
properties before we can be reasonably sure that the rescan has
completed and has been processed by udev. I agree that calling
rescan_path() in this code path is probably not helpful.=A0

Let's remove it.

> If there is a benefit, then we have to be careful to only call it
> once.
> Otherwise, we could get stuck in an endless loop where we trigger an
> add
> uevent, which in turn triggers another add uevent, and so on.

I don't see that risk, because uev_update_path() is only called for
"change" uevents, not "add".

Regards,
Martin

>=20
> -Ben
> =A0
> > > -Ben
> > >=20
> > > >=20
> > > > > ---
> > > > > =A0multipathd/main.c | 6 ++++--
> > > > > =A01 file changed, 4 insertions(+), 2 deletions(-)
> > > > >=20
> > > > > diff --git a/multipathd/main.c b/multipathd/main.c
> > > > > index 6090434c..4bdf14bd 100644
> > > > > --- a/multipathd/main.c
> > > > > +++ b/multipathd/main.c
> > > > > @@ -1284,7 +1284,7 @@ ev_remove_path (struct path *pp, struct
> > > > > vectors *
> > > > > vecs, int need_do_map)
> > > > > =A0
> > > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0strlcpy(devt, pp->dev_t,
> > > > > sizeof(devt));
> > > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0if (setup_multipath(vecs, mpp))
> > > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0/*
> > > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 * Successful map reload without this
> > > > > path:
> > > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 * sync_map_state() will free it.
> > > > > @@ -1304,8 +1304,10 @@ out:
> > > > > =A0=A0=A0=A0=A0=A0=A0=A0return retval;
> > > > > =A0
> > > > > =A0fail:
> > > > > +=A0=A0=A0=A0=A0=A0=A0condlog(0, "%s: error removing path. removi=
ng map
> > > > > %s",
> > > > > pp->dev,
> > > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->alias);
> > > > > =A0=A0=A0=A0=A0=A0=A0=A0remove_map_and_stop_waiter(mpp, vecs);
> > > > > -=A0=A0=A0=A0=A0=A0=A0return 1;
> > > > > +=A0=A0=A0=A0=A0=A0=A0return 0;
> > > > > =A0}
> > > > > =A0
> > > > > =A0static int
> > >=20
> > > --
> > > dm-devel mailing list
> > > dm-devel@redhat.com
> > > https://listman.redhat.com/mailman/listinfo/dm-devel
> > >=20
>=20


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

