Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AE02C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 15:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637683046;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pCTaFxuKamjIhhYlPkR3WYtsvgYVuDyt+kAKTzYYsvE=;
	b=L9ruTBgr5m3RXQ6yFKeEtjKV6S9HcV/M/U4djpxK1qyTZUfOSII9BqHacxIWFy7mNWfp6b
	sug/+sEJF0BFLC504wgePoj64PtQojc5R/Ph+/enPsLXFNVn5ZVI111sud+Vp/EQraW3wC
	mKuS4WPReDe4yCQinMt4FZKn6Xi4kfM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-247-X-ASOsKKNia5tqb4IAYZWg-1; Tue, 23 Nov 2021 10:57:23 -0500
X-MC-Unique: X-ASOsKKNia5tqb4IAYZWg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 412191B2C984;
	Tue, 23 Nov 2021 15:57:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C03E660CC3;
	Tue, 23 Nov 2021 15:57:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4A32E1832E7F;
	Tue, 23 Nov 2021 15:57:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ANFvChS016817 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 10:57:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9AEE4E14A; Tue, 23 Nov 2021 15:57:12 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C8BC19736;
	Tue, 23 Nov 2021 15:57:04 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1ANFv2Jk013869; 
	Tue, 23 Nov 2021 09:57:02 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1ANFv1V1013868;
	Tue, 23 Nov 2021 09:57:01 -0600
Date: Tue, 23 Nov 2021 09:57:01 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20211123155701.GM19591@octiron.msp.redhat.com>
References: <1637275667-13436-1-git-send-email-bmarzins@redhat.com>
	<6444fd097cf43bdfe6b1947f42f270e958310fff.camel@suse.com>
	<20211122153554.GJ19591@octiron.msp.redhat.com>
	<7ae474b1273b27a188593b716e5f0dfc1d09cad1.camel@suse.com>
	<20211122174303.GL19591@octiron.msp.redhat.com>
	<148fdecf9a05bcd82fa7da26910a82dc94d579df.camel@suse.com>
	<d4620e9a741d0c5d8565f71c4a20eebb1ca6ebee.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <d4620e9a741d0c5d8565f71c4a20eebb1ca6ebee.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] multipathd: avoid unnecessary path read-only
	reloads
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 23, 2021 at 11:05:20AM +0000, Martin Wilck wrote:
> Hi Ben,
>=20
> some more thoughts about the ro handling.
>=20
> On Mon, 2021-11-22 at 20:39 +0100, Martin Wilck wrote:
> > On Mon, 2021-11-22 at 11:43 -0600, Benjamin Marzinski wrote:
> > > On Mon, Nov 22, 2021 at 04:48:06PM +0000, Martin Wilck wrote:
> > > > On Mon, 2021-11-22 at 09:35 -0600, Benjamin Marzinski wrote:
> > > > > On Fri, Nov 19, 2021 at 09:33:39PM +0000, Martin Wilck wrote:
> > > > > > On Thu, 2021-11-18 at 16:47 -0600, Benjamin Marzinski wrote:
> > > > > > >=20
> > > > > > > +static bool
> > > > > > > +needs_ro_update(struct multipath *mpp, int ro)
> > > > > > > +{
> > > > > > > +=A0=A0=A0=A0=A0=A0=A0struct pathgroup * pgp;
> > > > > > > +=A0=A0=A0=A0=A0=A0=A0struct path * pp;
> > > > > > > +=A0=A0=A0=A0=A0=A0=A0unsigned int i, j;
> > > > > > > +=A0=A0=A0=A0=A0=A0=A0struct dm_info *dmi =3D NULL;
> > > > > > > +
> > > > > > > +=A0=A0=A0=A0=A0=A0=A0if (!mpp || ro < 0)
> > > > > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return false;
> > > > > > > +=A0=A0=A0=A0=A0=A0=A0dm_get_info(mpp->alias, &dmi);
> > > > > >=20
> > > > > > Why can't you just use mpp->dmi here?
> > > > >=20
> > > > > Since that value is set when the dmi is originally created, I
> > > > > didn't
> > > > > want to not reload a map, if we simply haven't updated it yet
> > > > > to
> > > > > reflect
> > > > > a change in the read-only value, like with do with
> > > > > dm_is_suspended()
> > > > > or dm_get_deferred_remove(), etc. I could make a
> > > > > dm_get_read_only()
> > > > > function and put it libmultipath/devmapper.c like the others,
> > > > > if
> > > > > you'd
> > > > > rather.
> > > >=20
> > > > I had expected that this property wouldn't silently change under
> > > > us.
> > > > Actually, I do think that we should get an uevent if this
> > > > happens.
> > > > Not sure if we process it properly, though.
> > >=20
> > > I think we will update the dmi,=A0
>=20
> This would need to be done on a change uevent for the dm device in
> ev_add_map(), but AFAICS we don't. ev_add_map() is basically a noop if
> the map is already known, unless wait_for_udev is 2.
>=20
> > > but I'm not sure that these uevents
> > > won't race. The worry was that the device would switch to read-only
> > > and
> > > then back too quickly, and we would get this event and still see
> > > the
> > > device in read/write because we haven't processed the event which
> > > would
> > > update the multipath dmi.
> >=20
> > OK. I'm fine with the patch, perhaps explain these subtleties some
> > more
> > in the commit message for future reference.
>=20
> I've never looked into the ro attribute processing closely. I just did.
> I'm unsure how a race would come to pass, in particular with your patch
> applied:
>=20
>  1. path change uevent arrives
>  2. ro attribute of path device has changed
>  3. map reload occurs if=20
>     a) map was rw before (thus all paths, too) and the path changed to
> ro
>     b) map was ro before and all paths have changed to rw
>  4. kernel will call set_disk_ro() depending on the DM_READONLY_FLAG;
>     set_disk_ro() triggers an uevent for the block device if and only
>     if the ro flag changed
>  5. we set mpp->dmi in __setup_multipath().
>=20
> We hold the vecs lock between 3 and 5, so even if the uevent arrived
> before setup_multipath() was called, I don't see how it could race.
> mpp->dmi as derived in 5 should reflect the state correctly.

I admit, I didn't find a definitive race. I was just worried about the
possibility of the dmi being outdated. While there's always the
possibility of the multipath device's RO state getting changed outside
of multipathd (by a multipath call for example), this is not the place
to deal with that. ev_add_map() would be. After looking at this, I'm
o.k. with trusting the existing dmi, especially if we are updating it in
ev_add_map().
=20
> What we could do is remember the ro-state of the map in dm_addmap(),
> e.g. in a mpp->ro field. If map creation with ro=3D0 succeeded, we can be
> pretty certain that the map is in read-write state. Otherwise we'd
> fallback to ro=3D1, and remember that state, too. We could verify that
> state once more against the dmi info in setup_multipath(). By doing
> that we'd cover the time span between the dm ioctl and retrieving the
> dmi in setup_multipath(). That would IMHO be more consistent than the
> current use of the temporary force_readonly flag.

So the idea would be to never try reloading read-write when the map is
marked as RO, until we get a path event updating the RO state? I do
worry about cases where well fail to reload the map correctly then.
Imagine that we have a map with mpp->ro=3D1 with one read-only path. The
read-only path gets removed. If we just assume that the mpp->ro state is
correct until with get a path_event changing the read-only state, we
will won't reload read/write here.  The other option would be to check
the path's RO state every time we reload, or at least whenever we're
reloading to remove a path. That has the advantage that it doesn't
produce a dm error message like a failed reload does, but I'm not sure
if it's any less work. Or am I misunderstanding what you are suggesting
here?

> I've been wondering whether we should use your logic during map
> creation, too, and not even try to setup the map with ro=3D0 if we have
> paths in read-only state.

If sysfs says one of the paths is read-only, it seems reasonable to skip
the read/write reload.

-Ben
=20
> Regards
> Martin
>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

