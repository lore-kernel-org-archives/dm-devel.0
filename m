Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 042ACC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 22 Nov 2021 15:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637595377;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HwR7Itam1vdQc/CMcmSoylWwnlSLGZL7u5X8D83nqFE=;
	b=e8KBe59u5izw/9DaGcj9Ps2rUsH5RMQwH5UNJGxi9IZKNFnyZJk0JSD+vkw8aa+GHZdvJk
	Xu7YVjxo+A1rUoO1wU1L5RKaTUsC38ikDI0hvt20sPyD1o+y4WhYDRKsnqZ6AvpVj26TSS
	+jNznKcNq1sZVC0xH6K6KT7cey/Fo4I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-134-wd4Q9NOQPXSINWlmJfp4CQ-1; Mon, 22 Nov 2021 10:36:14 -0500
X-MC-Unique: wd4Q9NOQPXSINWlmJfp4CQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72EC010144E0;
	Mon, 22 Nov 2021 15:36:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2CB0560C82;
	Mon, 22 Nov 2021 15:36:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3DCE74E9F5;
	Mon, 22 Nov 2021 15:36:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AMFa304021123 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 22 Nov 2021 10:36:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 11103ADCB; Mon, 22 Nov 2021 15:36:03 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4535E5DF5E;
	Mon, 22 Nov 2021 15:35:57 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AMFZtUa006634; 
	Mon, 22 Nov 2021 09:35:55 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AMFZtcF006633;
	Mon, 22 Nov 2021 09:35:55 -0600
Date: Mon, 22 Nov 2021 09:35:54 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20211122153554.GJ19591@octiron.msp.redhat.com>
References: <1637275667-13436-1-git-send-email-bmarzins@redhat.com>
	<6444fd097cf43bdfe6b1947f42f270e958310fff.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <6444fd097cf43bdfe6b1947f42f270e958310fff.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

On Fri, Nov 19, 2021 at 09:33:39PM +0000, Martin Wilck wrote:
> On Thu, 2021-11-18 at 16:47 -0600, Benjamin Marzinski wrote:
> > A mulitpath device can only be reloaded read/write when all paths are
> > read/write. Also, whenever a read-only device is rescanned, the scsi
> > subsystem will first unconditionally issue a uevent with DISK_RO=3D0
> > before checking the read-only status, and if it the device is still
> > read-only, issuing another uevent with DISK_RO=3D1. These uevents cause
> > pointless rereads when read-only paths are rescanned. To avoid this,
> > check to see if all paths are read/write before changing a multipath
> > device from read-only to read/write.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > =A0libmultipath/libmultipath.version |=A0 5 +++++
> > =A0libmultipath/sysfs.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 22 +++=
+++++++++++++++++++
> > =A0libmultipath/sysfs.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> > =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | =
31
> > ++++++++++++++++++++++++++++++-
> > =A04 files changed, 58 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/libmultipath/libmultipath.version
> > b/libmultipath/libmultipath.version
> > index 58a7d1be..ab4c7e30 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -1440,6 +1440,35 @@ finish_path_init(struct path *pp, struct
> > vectors * vecs)
> > =A0=A0=A0=A0=A0=A0=A0=A0return -1;
> > =A0}
> > =A0
> > +static bool
> > +needs_ro_update(struct multipath *mpp, int ro)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0struct pathgroup * pgp;
> > +=A0=A0=A0=A0=A0=A0=A0struct path * pp;
> > +=A0=A0=A0=A0=A0=A0=A0unsigned int i, j;
> > +=A0=A0=A0=A0=A0=A0=A0struct dm_info *dmi =3D NULL;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (!mpp || ro < 0)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return false;
> > +=A0=A0=A0=A0=A0=A0=A0dm_get_info(mpp->alias, &dmi);
>=20
> Why can't you just use mpp->dmi here?

Since that value is set when the dmi is originally created, I didn't
want to not reload a map, if we simply haven't updated it yet to reflect
a change in the read-only value, like with do with dm_is_suspended()
or dm_get_deferred_remove(), etc. I could make a dm_get_read_only()
function and put it libmultipath/devmapper.c like the others, if you'd
rather.
=20
> > +=A0=A0=A0=A0=A0=A0=A0if (!dmi) /* assume we do need to reload the devi=
ce */
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return true;
>
> Why that? I'd assume that if a DM_DEVICE_INFO ioctl fails on the
> device, a RELOAD would almost certainly fail, too.
>=20

Since reloading when it's not necessary doesn't do any harm (it's what
we currently do) while not switching to read/write when we should is a
problem, I thought that I'd error on the side of caution, but I agree
that the reload is unlikey to succeed, so I can change this if you'd
like.

> > +=A0=A0=A0=A0=A0=A0=A0if (dmi->read_only =3D=3D ro) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(dmi);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return false;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0free(dmi);
> > +=A0=A0=A0=A0=A0=A0=A0if (ro =3D=3D 1)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return true;
> > +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot (mpp->pg, pgp, i) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot (pgp-=
>paths, pp, j) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (sysfs_get_ro(pp) =3D=3D 1)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0return false;
>=20
> I think you should also return false here if sysfs_get_ro() returns
> error.

Same thing here. I was erroring on the side of caution, but it should be
fine to change.

-Ben

=20
> Regards,
> Martin
>=20
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0return true;
> > +}
> > +
> > =A0static int
> > =A0uev_update_path (struct uevent *uev, struct vectors * vecs)
> > =A0{
> > @@ -1512,7 +1541,7 @@ uev_update_path (struct uevent *uev, struct
> > vectors * vecs)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ro =3D uevent_get_disk_=
ro(uev);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (mpp && ro >=3D 0) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (needs_ro_update(mpp, =
ro)) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0condlog(2, "%s: update path write_protect to
> > '%d' (uevent)", uev->kernel, ro);
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (mpp->wait_for_udev)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

