Return-Path: <SRS0=OsX1=HN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B38C433DB
	for <dm-devel@archiver.kernel.org>; Thu, 11 Feb 2021 04:48:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 395B164E16
	for <dm-devel@archiver.kernel.org>; Thu, 11 Feb 2021 04:48:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 395B164E16
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1613018933;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5xpm3eNY5OYCBr9Pibk2hy+9knBUz5yEqdtAMHHvQBA=;
	b=VXPW53AI+ekAcpMdiw9G09Ic34EBBlDghPGaC4FLmQ1Rap/ia0gdfQOfWs2NfOhjUTIayM
	jEkmI8WVTAd7H16qSZlbMz94lvGWNXi+Lre9q8MVmOguGldK6UC6dmv1hltvcdr7uKCoAr
	X7tJCxi4kFLLjFlrpExHHlsCbZ9YwtE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-KMv_wOhkNtq_qj2BKPvypg-1; Wed, 10 Feb 2021 23:48:51 -0500
X-MC-Unique: KMv_wOhkNtq_qj2BKPvypg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0B1F8030C1;
	Thu, 11 Feb 2021 04:48:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2CB3E5C1A1;
	Thu, 11 Feb 2021 04:48:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 340E14E58E;
	Thu, 11 Feb 2021 04:48:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11B4meuO003896 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 10 Feb 2021 23:48:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2B06D1F07F; Thu, 11 Feb 2021 04:48:40 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B07FE1A8A9;
	Thu, 11 Feb 2021 04:48:36 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 11B4mZR3023604; 
	Wed, 10 Feb 2021 22:48:35 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 11B4mXpY023603;
	Wed, 10 Feb 2021 22:48:33 -0600
Date: Wed, 10 Feb 2021 22:48:33 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20210211044833.GJ15006@octiron.msp.redhat.com>
References: <1612847967-8813-1-git-send-email-bmarzins@redhat.com>
	<1612847967-8813-3-git-send-email-bmarzins@redhat.com>
	<e8131e361f84ef1caee140183a26c9f60b172f24.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <e8131e361f84ef1caee140183a26c9f60b172f24.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"wucy11@chinatelecom.cn" <wucy11@chinatelecom.cn>
Subject: Re: [dm-devel] [PATCH 2/2] multipathd: add recheck_wwid_time option
 to verify the path wwid
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 09, 2021 at 10:19:45PM +0000, Martin Wilck wrote:
> On Mon, 2021-02-08 at 23:19 -0600, Benjamin Marzinski wrote:
> > There are cases where the wwid of a path changes due to LUN remapping
> > without triggering uevent for the changed path. Multipathd has no
> > method
> > for trying to catch these cases, and corruption has resulted because
> > of
> > it.
> >=20
> > In order to have a better chance at catching these cases, multipath
> > now
> > has a recheck_wwid_time option, which can either be set to "off" or a
> > number of seconds. If a path is failed for equal to or greater than
> > the
> > configured number of seconds, multipathd will recheck its wwid before
> > restoring it, when the path checker sees that it has come back up.
>=20
> Can't the WWID change also happen without the path going offline, or
> at least without being offline long enough that multipathd would
> notice?

Yes. There is no way to guarantee that you won't hit this issue. That's
why this is configurable and disableable. People get to choose how
likely they are to shoot themselves in the foot.

>=20
> >  If
> > multipathd notices that a path's wwid has changed it will remove and
> > re-add the path, just like the existing wwid checking code for change
> > events does.=A0 In cases where the no uevent occurs, both the udev
> > database entry and sysfs will have the old wwid, so the only way to
> > get
> > a current wwid is to ask the device directly.=A0
>=20
> sysfs is wrong too, really? In that case I fear triggering an uevent
> won't fix the situation. You need to force the kernel to rescan the
> device, otherwise udev will fetch the WWID from sysfs again, which
> still has the wrong ID... or what am I missing here?

In the reproducer I posted using targetcli and FC devices, sysfs is
wrong.  That does make me a little leary about simply re-adding these
devices as new.  udev will run scsi_id to grab the new WWID and store
that in the udev database, but if we ever fail back to looking at sysfs,
we will still see the old data.  In general, having devices on the
system with bad sysfs data seems dangerous.

> > > Currently multipath only
> > has code to directly get the wwid for scsi devices, so this option
> > only
> > effects scsi devices. Also, since it's possible the the udev wwid
> > won't
> > match the wwid from get_vpd_sgio(), if multipathd doesn't initially
> > see
> > the two values matching for a device, it will disable this option for
> > that device.
> >=20
> > If recheck_wwid_time is not turned off, multipathd will also
> > automatically recheck the wwid whenever an existing path gets a add
> > event, or is manually re-added with cli_add_path().
> >=20
> > Co-developed-by: Chongyun Wu <wucy11@chinatelecom.cn>
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> I am uncertain about this.
>=20
> We get one more configuration option that defaults to off and that only
> the truly inaugurated will understand and use. And even those will not
> know how to set the recheck time. Should it be 1s, 10, or 100? We
> already have too many of these options in multipath-tools. We shy away
> from giving users reasonable defaults, with the result that most people
> won't bother.
>=20
> I generally don't understand what the UP/DOWN state has to do with
> this. If the WWID can change without any events seen by either the
> kernel or user space, why would the path go down and up again? And even
> if so, why would it matter how long the device remained down?

A new LUN can't get remapped to a still-being-used LUN id. The LUN that
was previously mapped to that id must get unmapped first.  That will
cause IO and and checker commands to fail. So unless a LUN gets unmapped
from a LUN id, and a new one remapped to that id quick enough for no IO
and or checker commands to go to it, the path should go down. In the
case that spurred this development, the path was down for hours before a
new LUN was remapped to that ID.

> But foremost, do we really have to try to deal with configuration
> mistakes as blatant as this? What if a user sets the same WWID for
> different devices, or re-uses the same WWID on different storage
> servers? I already hesitated about the code I added myself for catching
> user errors in the WWIDs file, but this seems even more far-fetched.
>=20
> Please convince me.

Err.. An important customer corrupted their data and while they admit
that they were at fault, it's hard for them to guarantee that something
like this won't happen in the future, and they asked if multipath could
do a better job of catching these sorts of mistakes. Obviously this is
more convincing when it's coming from your customer. But the fact still
stands that this has happened to multiple users even with our existing
code to catch this.

Since this isn't a problem that can always be fixed, the best we can do
is try to catch it before something bad happens.  If the path is
remapped before it goes down, then corruption can happen before there
is any possiblity of doing anything. That case is unsolvable. But if
the path does go down when the LUN is unmapped, then there is a chance
to catch this before damage is done.

Now, obviously if you don't set this to 0, then it's possible that the
path gets unmapped and goes down, but comes up before your timeout, and
you don't catch it in time.  Really, this is a dial that nobody that
hasn't got bitten by this issue cares about, but everyone who has had
this happen really wants to be there.

> This said, I'd like to understand why there are no events in these
> cases. I'd have thought we'd at least get a UNIT ATTENTION (REPORTED
> LUNS DATA HAS CHANGED), which would have caused a uevent.=A0If there was
> no UNIT ATTENTION, I'd blame the storage side.=A0

Are you able to try the reproducer I targetcli FC reproducer I posted?

> Maybe we need to monitor scsi_device uevents.
>=20
> Technical remarks below.
>=20
>=20
> > ---
> > =A0libmultipath/config.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> > =A0libmultipath/config.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> > =A0libmultipath/configure.c=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 4 +-
> > =A0libmultipath/configure.h=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 2 +
> > =A0libmultipath/defaults.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> > =A0libmultipath/dict.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 36 +=
+++++++++++
> > =A0libmultipath/libmultipath.version |=A0 6 ++
> > =A0libmultipath/structs.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 10 ++++
> > =A0multipath/multipath.conf.5=A0=A0=A0=A0=A0=A0=A0 | 18 ++++++
> > =A0multipathd/cli_handlers.c=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 9 +++
> > =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | =
92
> > +++++++++++++++++++++++++++++++
> > =A0multipathd/main.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=
=A0 2 +
> > =A012 files changed, 180 insertions(+), 2 deletions(-)
> > =A0.
> > =A0.\" ----------------------------------------------------------------
> > ------------
> > diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> > index 54635738..970d5e21 100644
> > --- a/multipathd/cli_handlers.c
> > +++ b/multipathd/cli_handlers.c
> > @@ -715,6 +715,15 @@ cli_add_path (void * v, char ** reply, int *
> > len, void * data)
> > =A0=A0=A0=A0=A0=A0=A0=A0pp =3D find_path_by_dev(vecs->pathvec, param);
> > =A0=A0=A0=A0=A0=A0=A0=A0if (pp && pp->initialized !=3D INIT_REMOVED) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: path al=
ready in pathvec", param);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pp->allow_wwid_rechec=
k =3D=3D ALLOW_WWID_RECHECK_ON
> > &&
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 check_path_wwid=
_change(pp)) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(0, "%s: wwid changed. Removing
> > device",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0pp->dev);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0h=
andle_path_wwid_change(pp, vecs);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn 1;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pp->mpp)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0return 0;
> > =A0=A0=A0=A0=A0=A0=A0=A0} else if (pp) {
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 19679848..17eef3a4 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -823,6 +823,59 @@ ev_remove_map (char * devname, char * alias, int
> > minor, struct vectors * vecs)
> > =A0=A0=A0=A0=A0=A0=A0=A0return flush_map(mpp, vecs, 0);
> > =A0}
> > =A0
> > +void
> > +handle_path_wwid_change(struct path *pp, struct vectors *vecs)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0const char *action =3D "add";
> > +=A0=A0=A0=A0=A0=A0=A0if (!pp || !pp->udev)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0sysfs_attr_set_value(pp->udev, "uevent", action,
> > strlen(action));
> > +=A0=A0=A0=A0=A0=A0=A0trigger_partitions_udev_change(pp->udev, action,
> > strlen(action));
>=20
> Nit: it looks a bit weird to use a const char * variable for "action"
> and a constant for "uevent".

It does mean that there's no chance of typo'ing it one of the four times
it's used and not having it be caught, but I'm fine with changing it.

> > +=A0=A0=A0=A0=A0=A0=A0if (ev_remove_path(pp, vecs, 1) !=3D 0 && pp->mpp=
) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->dmstate =3D PSTATE_FA=
ILED;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0dm_fail_path(pp->mpp->ali=
as, pp->dev_t);
> > +=A0=A0=A0=A0=A0=A0=A0}
>=20
> I suggest taking a ref on pp->udev, calling ev_remove_path(), and
> triggering the uevent after that.
>

vecs locking will save us from handling the uevent before we remove the
path, but your ordering does make things look more obviously correct.
I'm fine with changing it.

> > +}
> > +
> > +bool
> > +check_path_wwid_change(struct path *pp)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0char wwid[WWID_SIZE];
> > +=A0=A0=A0=A0=A0=A0=A0int len =3D 0;
> > +=A0=A0=A0=A0=A0=A0=A0char *c;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (!strlen(pp->wwid) || pp->bus !=3D SYSFS_BUS_S=
CSI)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return false;
>=20
> Maybe you should look at uid_attribute here, to be consistent with
> has_uid_fallback()?

Possibly, be this code will never be run to see if wwid has changed
without first having been run and verifying that the wwids match. If
the wwids don't match the first time, then it's disabled.
=20
> > +
> > +=A0=A0=A0=A0=A0=A0=A0/* Get the real fresh device wwid by sgio. sysfs =
still has
> > old
> > +=A0=A0=A0=A0=A0=A0=A0 * data, so only get_vpd_sgio will work to get th=
e new wwid
> > */
> > +=A0=A0=A0=A0=A0=A0=A0len =3D get_vpd_sgio(pp->fd, 0x83, 0, wwid, WWID_=
SIZE);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (len <=3D 0) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: failed to=
 check wwid by sgio: len =3D
> > %d",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p=
p->dev, len);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return false;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +
> > +=A0=A0=A0=A0=A0=A0=A0/*Strip any trailing blanks */
> > +=A0=A0=A0=A0=A0=A0=A0c =3D strchr(wwid, '\0');
>=20
> Quite unusual, why not use strlen() or strnlen()?

This was pulled directly from get_uid(). But I agree it could be cleaned
up in both places

>=20
> > +=A0=A0=A0=A0=A0=A0=A0c--;
> > +=A0=A0=A0=A0=A0=A0=A0while (c && c >=3D wwid && *c =3D=3D ' ') {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*c =3D '\0';
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c--;
> > +=A0=A0=A0=A0=A0=A0=A0}
>=20
> Nit: You don't have to nullify every space. Just the first one.
Again, this is just a copy of get_uid().

>=20
> > +=A0=A0=A0=A0=A0=A0=A0condlog(4, "%s: Got wwid %s by sgio", pp->dev, ww=
id);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (strncmp(wwid, pp->wwid, WWID_SIZE)) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "%s: wwid '%s'=
 doesn't match wwid '%s'
> > from device",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p=
p->dev, pp->wwid, wwid);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return true;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +
> > +=A0=A0=A0=A0=A0=A0=A0return false;
> > +}
> > +
> > =A0static int
> > =A0uev_add_path (struct uevent *uev, struct vectors * vecs, int
> > need_do_map)
> > =A0{
> > @@ -919,6 +972,21 @@ uev_add_path (struct uevent *uev, struct vectors
> > * vecs, int need_do_map)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0uev->kernel);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =3D 1;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0}
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else if (pp->allow_wwid=
_recheck =3D=3D
> > ALLOW_WWID_RECHECK_ON &&
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 check_path_wwid_change(pp)) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(2, "%s wwid change detected when
> > processing add uevent. removing path", pp->dev);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/=
*
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
* don't use handle_path_wwid_change here,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
* since that would just trigger another add
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
* uevent
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
*/
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
et =3D ev_remove_path(pp, vecs, true);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (ret =3D=3D 0)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0pp =3D NULL;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0e=
lse if (pp->mpp) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0pp->dmstate =3D PSTATE_FAILED;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0dm_fail_path(pp->mpp->alias, pp-
> > >dev_t);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
>=20
> What's the purpose of this code? Are you handling your own artificial
> "add" event here, which you triggered before in
> handle_path_wwid_change()? Or are there real cases where the kernel
> would send an "add" event without sending a "remove" event first?
>

This shouldn't be for handling our own add event. Either the
ev_remove_path() in handle_path_wwid_changed() succeeded, and there is
no path in pathvec, or it failed, and pp->initialized should be set to
INIT_REMOVED. Either way, we miss this code path. This is simply if we
get an "add" event without the "remove" event, which is a real thing
that has happened when LUNs get remapped.

> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0if (pp)
> > @@ -2049,6 +2117,7 @@ check_path (struct vectors * vecs, struct path
> > * pp, unsigned int ticks)
> > =A0=A0=A0=A0=A0=A0=A0=A0unsigned int checkint, max_checkint;
> > =A0=A0=A0=A0=A0=A0=A0=A0struct config *conf;
> > =A0=A0=A0=A0=A0=A0=A0=A0int marginal_pathgroups, marginal_changed =3D 0=
;
> > +=A0=A0=A0=A0=A0=A0=A0int recheck_wwid_time;
> > =A0=A0=A0=A0=A0=A0=A0=A0int ret;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0if (((pp->initialized =3D=3D INIT_OK ||
> > @@ -2066,6 +2135,7 @@ check_path (struct vectors * vecs, struct path
> > * pp, unsigned int ticks)
> > =A0=A0=A0=A0=A0=A0=A0=A0checkint =3D conf->checkint;
> > =A0=A0=A0=A0=A0=A0=A0=A0max_checkint =3D conf->max_checkint;
> > =A0=A0=A0=A0=A0=A0=A0=A0marginal_pathgroups =3D conf->marginal_pathgrou=
ps;
> > +=A0=A0=A0=A0=A0=A0=A0recheck_wwid_time =3D conf->recheck_wwid_time;
> > =A0=A0=A0=A0=A0=A0=A0=A0put_multipath_config(conf);
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0if (pp->checkint =3D=3D CHECKINT_UNDEF) {
> > @@ -2197,6 +2267,26 @@ check_path (struct vectors * vecs, struct path
> > * pp, unsigned int ticks)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0=A0=A0=A0=A0=A0=A0=A0set_no_path_retry(pp->mpp);
> > =A0
> > +=A0=A0=A0=A0=A0=A0=A0if (recheck_wwid_time !=3D RECHECK_WWID_OFF &&
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (newstate =3D=3D PATH_UP || newstate =
=3D=3D PATH_GHOST)) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pp->allow_wwid_rechec=
k =3D=3D
> > ALLOW_WWID_RECHECK_UNSET) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (check_path_wwid_change(pp))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0pp->allow_wwid_recheck =3D
> > ALLOW_WWID_RECHECK_OFF;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0e=
lse
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0pp->allow_wwid_recheck =3D
> > ALLOW_WWID_RECHECK_ON;
>=20
> This is confusing. I pulled my hair over this code before I read your
> man page hunk: "When the path is originally added, if the path's
> configured wwid doesn't match the wwid retrieved directly
> from the scsi device, rechecks will be disabled for the device."
>=20
> So, I gather this is an alternative to the has_uid_fallback() logic
> mentioned above. It deserves at least a comment here. Please consider
> if using the same logic as has_uid_falback() isn't just as good as
> this.

I'm fine with using the same logic as has_uid_fallback() to determine if
if we can use get_vpd_sgio().

-Ben

> Btw, as we're already pretty much on corner-case ground here, if the
> path fails quickly after being detected, a WWID change could have
> occured already when it comes UP first, and this code is run for the
> first time.
>=20
>=20
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else if (((pp->state !=
=3D PATH_UP && pp->state !=3D
> > PATH_GHOST) ||
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 pp->dmstate =3D=3D PSTATE_FAILED) &&
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 pp->failed_time >=3D recheck_wwid_time &&
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 pp->allow_wwid_recheck =3D=3D
> > ALLOW_WWID_RECHECK_ON &&
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 check_path_wwid_change(pp)) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(0, "%s: path wwid change detected.
> > Removing",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0pp->dev);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0h=
andle_path_wwid_change(pp, vecs);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn 0;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->failed_time =3D 0;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +
> > =A0=A0=A0=A0=A0=A0=A0=A0if ((newstate =3D=3D PATH_UP || newstate =3D=3D=
 PATH_GHOST) &&
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (san_path_check_enabled(pp->mpp) ||
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 marginal_path_check_enabled(pp->mp=
p))) {
> > @@ -2330,6 +2420,8 @@ check_path (struct vectors * vecs, struct path
> > * pp, unsigned int ticks)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (newstate =3D=3D PAT=
H_DOWN) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0int log_checker_err;
> > =A0
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (recheck_wwid_time !=3D RECHECK_WWID_OFF)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0pp->failed_time +=3D pp->checkint;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0conf =3D get_multipath_config();
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0log_checker_err =3D conf->log_checker_err;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0put_multipath_config(conf);
> > diff --git a/multipathd/main.h b/multipathd/main.h
> > index 5abbe97b..ddd953f9 100644
> > --- a/multipathd/main.h
> > +++ b/multipathd/main.h
> > @@ -50,4 +50,6 @@ int update_multipath (struct vectors *vecs, char
> > *mapname, int reset);
> > =A0int reload_and_sync_map(struct multipath *mpp, struct vectors *vecs,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0int refresh);
> > =A0
> > +void handle_path_wwid_change(struct path *pp, struct vectors *vecs);
> > +bool check_path_wwid_change(struct path *pp);
> > =A0#endif /* MAIN_H */
>=20
> --=20
> Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
> SUSE Software Solutions Germany GmbH
> HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer
>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

