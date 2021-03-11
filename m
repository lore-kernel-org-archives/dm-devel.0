Return-Path: <SRS0=c+In=IJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA521C433DB
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 21:34:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4D32064F84
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 21:34:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D32064F84
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1615498445;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qjCbOM01HbvABM4uMDXzbkgcIqsUKsNrEnUnDgphQW0=;
	b=PoMMQRwZixpi07ltZDIbSEuEq1RgLm74SBsDdWeVeQQxCHBNWwrkstcjagRtItgPV3ANHT
	HAC7ARLuDgp3iZ9J3VCmGTp1pxyRVkK7mzcRq4fSg4hWfhIkdRP2DC9qphn8vbCnKfInqi
	SFP0RuU5glC1XFCoC8s5fuYmpFWikKw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-7AYPsa7ENSeny-TH6ROfzQ-1; Thu, 11 Mar 2021 16:34:01 -0500
X-MC-Unique: 7AYPsa7ENSeny-TH6ROfzQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3591819253C8;
	Thu, 11 Mar 2021 21:33:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 118275C1C5;
	Thu, 11 Mar 2021 21:33:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B269357DC1;
	Thu, 11 Mar 2021 21:33:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12BLXtD4013902 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Mar 2021 16:33:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 38AC25B697; Thu, 11 Mar 2021 21:33:55 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F0D195D74C;
	Thu, 11 Mar 2021 21:33:51 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 12BLXogV032677; 
	Thu, 11 Mar 2021 15:33:50 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 12BLXms1032676;
	Thu, 11 Mar 2021 15:33:48 -0600
Date: Thu, 11 Mar 2021 15:33:47 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20210311213347.GU15006@octiron.msp.redhat.com>
References: <1614148402-19847-1-git-send-email-bmarzins@redhat.com>
	<1614148402-19847-4-git-send-email-bmarzins@redhat.com>
	<8f500bcd5d5a683edcfa4d59567a50cc794cb085.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <8f500bcd5d5a683edcfa4d59567a50cc794cb085.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"wucy11@chinatelecom.cn" <wucy11@chinatelecom.cn>
Subject: Re: [dm-devel] [PATCH v2 3/3] multipathd: add recheck_wwid option
 to verify the path wwid
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
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 11, 2021 at 08:30:51PM +0000, Martin Wilck wrote:
> On Wed, 2021-02-24 at 00:33 -0600, Benjamin Marzinski wrote:
> > There are cases where the wwid of a path changes due to LUN remapping
> > without triggering uevent for the changed path. Multipathd has no
> > method
> > for trying to catch these cases, and corruption has resulted because
> > of
> > it.
> >=20
> > In order to have a better chance at catching these cases, multipath
> > now
> > has a recheck_wwid option. If this is set to "yes", when a failed
> > path
> > has become active again, multipathd will recheck its wwid. If
> > multipathd
> > notices that a path's wwid has changed, it will remove and re-add the
> > path, just like the existing wwid checking code for change events
> > does.
> > In cases where the no uevent occurs, both the udev database entry and
> > sysfs will have the old wwid, so the only way to get a current wwid
> > is
> > to ask the device directly. Currently multipath only has code to
> > directly get the wwid for scsi devices, so this option only effects
> > scsi
> > devices, and they must be configured to be able to use the
> > uid_fallback
> > methods. To make sure both the sysfs and udev database values are
> > updated, multipathd triggers a both a rescan of the device and a udev
> > add event.
> >=20
> > Co-developed-by: Chongyun Wu <wucy11@chinatelecom.cn>
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> Two minor remarks below, but:
>=20
> Reviewed-by: Martin Wilck <mwilck@suse.com>
>=20
> > =A0
> > +static void
> > +rescan_path(struct udev_device *parent)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0while(parent) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0const char *subsys =3D
> > udev_device_get_subsystem(parent);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (subsys && !strncmp(su=
bsys, "scsi", 4))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0b=
reak;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0parent =3D udev_device_ge=
t_parent(parent);
> > +=A0=A0=A0=A0=A0=A0=A0}
>=20
> You could have used udev_device_get_parent_with_subsystem_devtype()
> here.=20

fair enough.
=20
> > +=A0=A0=A0=A0=A0=A0=A0if (parent)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sysfs_attr_set_value(pare=
nt, "rescan", "1",
> > strlen("1"));
> > +}
> > +
> > +void
> > +handle_path_wwid_change(struct path *pp, struct vectors *vecs)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0struct udev_device *udd;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (!pp || !pp->udev)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0udd =3D udev_device_ref(pp->udev);
> > +=A0=A0=A0=A0=A0=A0=A0if (ev_remove_path(pp, vecs, 1) !=3D 0 && pp->mpp=
) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->dmstate =3D PSTATE_FA=
ILED;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0dm_fail_path(pp->mpp->ali=
as, pp->dev_t);
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0rescan_path(udd);
> > +=A0=A0=A0=A0=A0=A0=A0sysfs_attr_set_value(udd, "uevent", "add", strlen=
("add"));
> > +=A0=A0=A0=A0=A0=A0=A0trigger_partitions_udev_change(udd, "add", strlen=
("add"));
>=20
> Why do you need to do this for the partitions?

When I tested this before, it didn't appear that an add event ever got
retrigger for any existing partitions. But since the device got
remapped, the udev information about those partitions most also be
wrong. The idea was to get them to be using better data. Admittedly,
this isn't really necessary for kpartx. It just seems like since
multipath noticed it, it should try to clean it up.  But actually, there
might not even be partitions on the device anymore, so perhaps it's best
to just leave them alone.

I can respin this using udev_device_get_parent_with_subsystem_devtype(),
and removing the udev triggers on the partitions, if you want.

-Ben

> > +=A0=A0=A0=A0=A0=A0=A0udev_device_unref(udd);
> > +}
> > +
> > +bool
> > +check_path_wwid_change(struct path *pp)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0char wwid[WWID_SIZE];
> > +=A0=A0=A0=A0=A0=A0=A0int len =3D 0;
> > +=A0=A0=A0=A0=A0=A0=A0size_t i;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (!strlen(pp->wwid))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return false;
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
> > +=A0=A0=A0=A0=A0=A0=A0for (i =3D strlen(pp->wwid); i > 0 && pp->wwid[i-=
1] =3D=3D ' '; i--
> > );
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* no-op */
> > +=A0=A0=A0=A0=A0=A0=A0pp->wwid[i] =3D '\0';
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
> > @@ -1296,6 +1363,7 @@ uev_update_path (struct uevent *uev, struct
> > vectors * vecs)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0condlog(0, "%s: path wwid changed from '%s'
> > to '%s'",
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0uev->kernel, wwid, pp->wwid);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0ev_remove_path(pp, vecs, 1);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
escan_path(uev->udev);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0needs_reinit =3D 1;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0goto out;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else {
> > @@ -2197,6 +2265,16 @@ check_path (struct vectors * vecs, struct path
> > * pp, unsigned int ticks)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0=A0=A0=A0=A0=A0=A0=A0set_no_path_retry(pp->mpp);
> > =A0
> > +=A0=A0=A0=A0=A0=A0=A0if (pp->recheck_wwid =3D=3D RECHECK_WWID_ON &&
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (newstate =3D=3D PATH_UP || newstate =
=3D=3D PATH_GHOST) &&
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ((pp->state !=3D PATH_UP && pp->state !=
=3D PATH_GHOST) ||
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pp->dmstate =3D=3D PSTATE_FAILED) &&
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 check_path_wwid_change(pp)) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "%s: path wwid=
 change detected. Removing",
> > pp->dev);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0handle_path_wwid_change(p=
p, vecs);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +
> > =A0=A0=A0=A0=A0=A0=A0=A0if ((newstate =3D=3D PATH_UP || newstate =3D=3D=
 PATH_GHOST) &&
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (san_path_check_enabled(pp->mpp) ||
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 marginal_path_check_enabled(pp->mp=
p))) {
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
https://listman.redhat.com/mailman/listinfo/dm-devel

