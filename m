Return-Path: <SRS0=NHnu=EJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 811EAC00A89
	for <dm-devel@archiver.kernel.org>; Tue,  3 Nov 2020 03:06:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C43BD2076E
	for <dm-devel@archiver.kernel.org>; Tue,  3 Nov 2020 03:06:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GuT10qmc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C43BD2076E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1604372764;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7XBoQoIT77V0vLi+0t07QCKe4qS1YRAfdlCHSQVak0o=;
	b=GuT10qmcSurffKbCkKpgH/DqBUbLciv1fFWpBAJetWYqPsWz37A9YIiNxyYs2e23jGOxZX
	gWCwMn0PZv8XO4gxe3wvsFK5VWtul7XoT4vaeqdIcLb/gfizBZkgwMC3yWZ3YAYGPHOguM
	rLg1MXSPW/5xU3IvOHOpJxjqBYXFMQs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-zVzqM-58MWuq1aoCxDmBQg-1; Mon, 02 Nov 2020 22:06:02 -0500
X-MC-Unique: zVzqM-58MWuq1aoCxDmBQg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6DE7B8030B5;
	Tue,  3 Nov 2020 03:05:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D3F021E8A;
	Tue,  3 Nov 2020 03:05:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 71FC81800BB2;
	Tue,  3 Nov 2020 03:05:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A335nmW014915 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 2 Nov 2020 22:05:49 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 928C762A14; Tue,  3 Nov 2020 03:05:49 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BFAA5576E;
	Tue,  3 Nov 2020 03:05:46 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0A335iqq013779; 
	Mon, 2 Nov 2020 21:05:45 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0A335iaf013778;
	Mon, 2 Nov 2020 21:05:44 -0600
Date: Mon, 2 Nov 2020 21:05:43 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20201103030543.GY3384@octiron.msp.redhat.com>
References: <1603487708-12547-1-git-send-email-bmarzins@redhat.com>
	<1603487708-12547-3-git-send-email-bmarzins@redhat.com>
	<644d20035bc0175c414b632251bf795b15d72896.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <644d20035bc0175c414b632251bf795b15d72896.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/5] libmultipath: add eh_deadline
 multipath.conf parameter
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 30, 2020 at 09:00:48PM +0000, Martin Wilck wrote:
> On Fri, 2020-10-23 at 16:15 -0500, Benjamin Marzinski wrote:
> > There are times a fc rport is never lost, meaning that
> > fast_io_fail_tmo
> > and dev_loss_tmo never trigger, but scsi commands still hang. This
> > can
> > cause problems in cases where users have string timing requirements,=20
>=20
> Did you mean "strict" here?
>=20

Whoops. yes.

> > and
> > the easiest way to solve these issues is to set eh_deadline. Since
> > it's
> > already possible to set fast_io_fail_tmo and dev_loss_tmo from
> > multipath.conf, and have multipath take care of setting it correctly
> > for
> > the scsi devices in sysfs, it makes sense to allow users to set
> > eh_deadline here as well.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/config.c      |  2 ++
> >  libmultipath/config.h      |  2 ++
> >  libmultipath/configure.c   |  1 +
> >  libmultipath/dict.c        | 10 ++++++
> >  libmultipath/discovery.c   | 70 ++++++++++++++++++++++++++++++----
> > ----
> >  libmultipath/propsel.c     | 17 +++++++++
> >  libmultipath/propsel.h     |  1 +
> >  libmultipath/structs.h     |  7 ++++
> >  multipath/multipath.conf.5 | 16 +++++++++
> >  9 files changed, 111 insertions(+), 15 deletions(-)
> >=20
> > diff --git a/libmultipath/config.c b/libmultipath/config.c
> > index 49e7fb81..9f3cb38d 100644
> > --- a/libmultipath/config.c
> > +++ b/libmultipath/config.c
> > @@ -424,6 +424,7 @@ merge_hwe (struct hwentry * dst, struct hwentry *
> > src)
> >  =09merge_num(flush_on_last_del);
> >  =09merge_num(fast_io_fail);
> >  =09merge_num(dev_loss);
> > +=09merge_num(eh_deadline);
> >  =09merge_num(user_friendly_names);
> >  =09merge_num(retain_hwhandler);
> >  =09merge_num(detect_prio);
> > @@ -579,6 +580,7 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
> >  =09hwe->flush_on_last_del =3D dhwe->flush_on_last_del;
> >  =09hwe->fast_io_fail =3D dhwe->fast_io_fail;
> >  =09hwe->dev_loss =3D dhwe->dev_loss;
> > +=09hwe->eh_deadline =3D dhwe->eh_deadline;
> >  =09hwe->user_friendly_names =3D dhwe->user_friendly_names;
> >  =09hwe->retain_hwhandler =3D dhwe->retain_hwhandler;
> >  =09hwe->detect_prio =3D dhwe->detect_prio;
> > diff --git a/libmultipath/config.h b/libmultipath/config.h
> > index 661dd586..9ce37f16 100644
> > --- a/libmultipath/config.h
> > +++ b/libmultipath/config.h
> > @@ -63,6 +63,7 @@ struct hwentry {
> >  =09int flush_on_last_del;
> >  =09int fast_io_fail;
> >  =09unsigned int dev_loss;
> > +=09int eh_deadline;
> >  =09int user_friendly_names;
> >  =09int retain_hwhandler;
> >  =09int detect_prio;
> > @@ -148,6 +149,7 @@ struct config {
> >  =09int attribute_flags;
> >  =09int fast_io_fail;
> >  =09unsigned int dev_loss;
> > +=09int eh_deadline;
> >  =09int log_checker_err;
> >  =09int allow_queueing;
> >  =09int allow_usb_devices;
> > diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> > index 1c8aac08..a878d870 100644
> > --- a/libmultipath/configure.c
> > +++ b/libmultipath/configure.c
> > @@ -368,6 +368,7 @@ int setup_map(struct multipath *mpp, char
> > *params, int params_size,
> >  =09select_gid(conf, mpp);
> >  =09select_fast_io_fail(conf, mpp);
> >  =09select_dev_loss(conf, mpp);
> > +=09select_eh_deadline(conf, mpp);
> >  =09select_reservation_key(conf, mpp);
> >  =09select_deferred_remove(conf, mpp);
> >  =09select_marginal_path_err_sample_time(conf, mpp);
> > diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> > index f4357da1..bab96146 100644
> > --- a/libmultipath/dict.c
> > +++ b/libmultipath/dict.c
> > @@ -899,6 +899,13 @@ declare_ovr_snprint(dev_loss, print_dev_loss)
> >  declare_hw_handler(dev_loss, set_dev_loss)
> >  declare_hw_snprint(dev_loss, print_dev_loss)
> > =20
> > +declare_def_handler(eh_deadline, set_undef_off_zero)
> > +declare_def_snprint(eh_deadline, print_undef_off_zero)
> > +declare_ovr_handler(eh_deadline, set_undef_off_zero)
> > +declare_ovr_snprint(eh_deadline, print_undef_off_zero)
> > +declare_hw_handler(eh_deadline, set_undef_off_zero)
> > +declare_hw_snprint(eh_deadline, print_undef_off_zero)
> > +
> >  static int
> >  set_pgpolicy(vector strvec, void *ptr)
> >  {
> > @@ -1771,6 +1778,7 @@ init_keywords(vector keywords)
> >  =09install_keyword("gid", &def_gid_handler, &snprint_def_gid);
> >  =09install_keyword("fast_io_fail_tmo", &def_fast_io_fail_handler,
> > &snprint_def_fast_io_fail);
> >  =09install_keyword("dev_loss_tmo", &def_dev_loss_handler,
> > &snprint_def_dev_loss);
> > +=09install_keyword("eh_deadline", &def_eh_deadline_handler,
> > &snprint_def_eh_deadline);
> >  =09install_keyword("bindings_file", &def_bindings_file_handler,
> > &snprint_def_bindings_file);
> >  =09install_keyword("wwids_file", &def_wwids_file_handler,
> > &snprint_def_wwids_file);
> >  =09install_keyword("prkeys_file", &def_prkeys_file_handler,
> > &snprint_def_prkeys_file);
> > @@ -1880,6 +1888,7 @@ init_keywords(vector keywords)
> >  =09install_keyword("flush_on_last_del",
> > &hw_flush_on_last_del_handler, &snprint_hw_flush_on_last_del);
> >  =09install_keyword("fast_io_fail_tmo", &hw_fast_io_fail_handler,
> > &snprint_hw_fast_io_fail);
> >  =09install_keyword("dev_loss_tmo", &hw_dev_loss_handler,
> > &snprint_hw_dev_loss);
> > +=09install_keyword("eh_deadline", &hw_eh_deadline_handler,
> > &snprint_hw_eh_deadline);
> >  =09install_keyword("user_friendly_names",
> > &hw_user_friendly_names_handler, &snprint_hw_user_friendly_names);
> >  =09install_keyword("retain_attached_hw_handler",
> > &hw_retain_hwhandler_handler, &snprint_hw_retain_hwhandler);
> >  =09install_keyword("detect_prio", &hw_detect_prio_handler,
> > &snprint_hw_detect_prio);
> > @@ -1920,6 +1929,7 @@ init_keywords(vector keywords)
> >  =09install_keyword("flush_on_last_del",
> > &ovr_flush_on_last_del_handler, &snprint_ovr_flush_on_last_del);
> >  =09install_keyword("fast_io_fail_tmo", &ovr_fast_io_fail_handler,
> > &snprint_ovr_fast_io_fail);
> >  =09install_keyword("dev_loss_tmo", &ovr_dev_loss_handler,
> > &snprint_ovr_dev_loss);
> > +=09install_keyword("eh_deadline", &ovr_eh_deadline_handler,
> > &snprint_ovr_eh_deadline);
> >  =09install_keyword("user_friendly_names",
> > &ovr_user_friendly_names_handler, &snprint_ovr_user_friendly_names);
> >  =09install_keyword("retain_attached_hw_handler",
> > &ovr_retain_hwhandler_handler, &snprint_ovr_retain_hwhandler);
> >  =09install_keyword("detect_prio", &ovr_detect_prio_handler,
> > &snprint_ovr_detect_prio);
> > diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> > index 950b1586..ef9a9a23 100644
> > --- a/libmultipath/discovery.c
> > +++ b/libmultipath/discovery.c
> > @@ -585,6 +585,42 @@ sysfs_get_asymmetric_access_state(struct path
> > *pp, char *buff, int buflen)
> >  =09return !!preferred;
> >  }
> > =20
> > +static int
> > +sysfs_set_eh_deadline(struct multipath *mpp, struct path *pp)
> > +{
> > +=09struct udev_device *hostdev;
> > +=09char host_name[HOST_NAME_LEN], value[16];
> > +=09int ret;
> > +
> > +=09if (mpp->eh_deadline =3D=3D EH_DEADLINE_UNSET)
> > +=09=09return 0;
> > +
> > +=09sprintf(host_name, "host%d", pp->sg_id.host_no);
> > +=09hostdev =3D udev_device_new_from_subsystem_sysname(udev,
> > +=09=09=09"scsi_host", host_name);
> > +=09if (!hostdev)
> > +=09=09return 1;
> > +
> > +=09if (mpp->eh_deadline =3D=3D EH_DEADLINE_OFF)
> > +=09=09sprintf(value, "off");
> > +=09else if (mpp->eh_deadline =3D=3D EH_DEADLINE_ZERO)
> > +=09=09sprintf(value, "0");
> > +=09else
> > +=09=09snprintf(value, 16, "%u", mpp->eh_deadline);
>=20
> Hm, mpp->eh_deadline is an "int". This should cause a compiler warning,
> does it not?

um.. no. Not on either gcc-8 or gcc-10.  But I'll fix it.

> Nitpick: You're certain to not need more than 11 bytes of string
> buffer, so you could simply use sprintf(). If you want to use
> snprintf(), please pass sizeof(value) rather than an explicit number.

Sure.

> > +
> > +=09ret =3D sysfs_attr_set_value(hostdev, "eh_deadline",
> > +=09=09=09=09   value, strlen(value));
>=20
> Nitpick: you could use the return value of sprintf() here rather than
> calling strlen() again.

Sure

> > +=09/*
> > +=09 * not all scsi drivers support setting eh_deadline, so failing
> > +=09 * is totally reasonable
> > +=09 */
> > +=09if (ret <=3D 0)
> > +=09=09condlog(4, "%s: failed to set eh_deadline to %s, error
> > %d", udev_device_get_sysname(hostdev), value, -ret);
>=20
> Loglevel 3 might still be justified. After all, the user did set
> eh_deadline, and might wonder why her settings aren't applied.

makes sense.

> > +
> > +=09udev_device_unref(hostdev);
> > +=09return (ret <=3D 0);
> > +}
> > +
> >  static void
> >  sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
> >  {
> > @@ -799,7 +835,8 @@ sysfs_set_scsi_tmo (struct multipath *mpp,
> > unsigned int checkint)
> >  =09=09mpp->fast_io_fail =3D MP_FAST_IO_FAIL_OFF;
> >  =09}
> >  =09if (mpp->dev_loss =3D=3D DEV_LOSS_TMO_UNSET &&
> > -=09    mpp->fast_io_fail =3D=3D MP_FAST_IO_FAIL_UNSET)
> > +=09    mpp->fast_io_fail =3D=3D MP_FAST_IO_FAIL_UNSET &&
> > +=09    mpp->eh_deadline =3D=3D EH_DEADLINE_UNSET)
> >  =09=09return 0;
> > =20
> >  =09vector_foreach_slot(mpp->paths, pp, i) {
> > @@ -808,21 +845,24 @@ sysfs_set_scsi_tmo (struct multipath *mpp,
> > unsigned int checkint)
> >  =09=09=09=09err_path =3D pp;
> >  =09=09=09continue;
> >  =09=09}
> > -
> > -=09=09switch (pp->sg_id.proto_id) {
> > -=09=09case SCSI_PROTOCOL_FCP:
> > -=09=09=09sysfs_set_rport_tmo(mpp, pp);
> > -=09=09=09continue;
> > -=09=09case SCSI_PROTOCOL_ISCSI:
> > -=09=09=09sysfs_set_session_tmo(mpp, pp);
> > -=09=09=09continue;
> > -=09=09case SCSI_PROTOCOL_SAS:
> > -=09=09=09sysfs_set_nexus_loss_tmo(mpp, pp);
> > -=09=09=09continue;
> > -=09=09default:
> > -=09=09=09if (!err_path)
> > -=09=09=09=09err_path =3D pp;
> > +=09=09if (mpp->dev_loss !=3D DEV_LOSS_TMO_UNSET ||
> > +=09=09    mpp->fast_io_fail !=3D MP_FAST_IO_FAIL_UNSET) {
>=20
> Perhaps we should rather check these in the called functions then
> introduce another conditional here. Some callees do check these
> already. We've got the likely shortcut (none set) above already.

Sure.

> > +=09=09=09switch (pp->sg_id.proto_id) {
> > +=09=09=09case SCSI_PROTOCOL_FCP:
> > +=09=09=09=09sysfs_set_rport_tmo(mpp, pp);
> > +=09=09=09=09break;
> > +=09=09=09case SCSI_PROTOCOL_ISCSI:
> > +=09=09=09=09sysfs_set_session_tmo(mpp, pp);
> > +=09=09=09=09break;
> > +=09=09=09case SCSI_PROTOCOL_SAS:
> > +=09=09=09=09sysfs_set_nexus_loss_tmo(mpp, pp);
> > +=09=09=09=09break;
> > +=09=09=09default:
> > +=09=09=09=09if (!err_path)
> > +=09=09=09=09=09err_path =3D pp;
> > +=09=09=09}
> >  =09=09}
> > +=09=09sysfs_set_eh_deadline(mpp, pp);
> >  =09}
> > =20
> >  =09if (err_path) {
> > diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> > index 67d025cf..fa4ac5d9 100644
> > --- a/libmultipath/propsel.c
> > +++ b/libmultipath/propsel.c
> > @@ -775,6 +775,23 @@ out:
> >  =09return 0;
> >  }
> > =20
> > +int select_eh_deadline(struct config *conf, struct multipath *mp)
> > +{
> > +=09const char *origin;
> > +=09char buff[12];
> > +
> > +=09mp_set_ovr(eh_deadline);
> > +=09mp_set_hwe(eh_deadline);
> > +=09mp_set_conf(eh_deadline);
> > +=09mp->eh_deadline =3D EH_DEADLINE_UNSET;
> > +=09/* not changing sysfs in default cause, so don't print anything
> > */
> > +=09return 0;
> > +out:
> > +=09print_undef_off_zero(buff, 12, mp->eh_deadline);
> > +=09condlog(3, "%s: eh_deadline =3D %s %s", mp->alias, buff, origin);
> > +=09return 0;
> > +}
> > +
> >  int select_flush_on_last_del(struct config *conf, struct multipath
> > *mp)
> >  {
> >  =09const char *origin;
> > diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
> > index 3d6edd8a..a68bacf0 100644
> > --- a/libmultipath/propsel.h
> > +++ b/libmultipath/propsel.h
> > @@ -17,6 +17,7 @@ int select_uid(struct config *conf, struct
> > multipath *mp);
> >  int select_gid(struct config *conf, struct multipath *mp);
> >  int select_fast_io_fail(struct config *conf, struct multipath *mp);
> >  int select_dev_loss(struct config *conf, struct multipath *mp);
> > +int select_eh_deadline(struct config *conf, struct multipath *mp);
> >  int select_reservation_key(struct config *conf, struct multipath
> > *mp);
> >  int select_retain_hwhandler (struct config *conf, struct multipath *
> > mp);
> >  int select_detect_prio(struct config *conf, struct path * pp);
> > diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> > index cfa7b649..d6ff6762 100644
> > --- a/libmultipath/structs.h
> > +++ b/libmultipath/structs.h
> > @@ -236,6 +236,12 @@ enum fast_io_fail_states {
> >  =09MP_FAST_IO_FAIL_ZERO =3D UOZ_ZERO,
> >  };
> > =20
> > +enum eh_deadline_states {
> > +=09EH_DEADLINE_UNSET =3D UOZ_UNDEF,
> > +=09EH_DEADLINE_OFF =3D UOZ_OFF,
> > +=09EH_DEADLINE_ZERO =3D UOZ_ZERO,
> > +};
> > +
> >  struct vpd_vendor_page {
> >  =09int pg;
> >  =09const char *name;
> > @@ -356,6 +362,7 @@ struct multipath {
> >  =09int ghost_delay;
> >  =09int ghost_delay_tick;
> >  =09unsigned int dev_loss;
> > +=09int eh_deadline;
> >  =09uid_t uid;
> >  =09gid_t gid;
> >  =09mode_t mode;
> > diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> > index d2101ed6..cf05c1ab 100644
> > --- a/multipath/multipath.conf.5
> > +++ b/multipath/multipath.conf.5
> > @@ -717,6 +717,22 @@ The default is: \fB600\fR
> >  .
> >  .
> >  .TP
> > +.B eh_deadline
> > +Specify the maximum number of seconds the SCSI layer will spend
> > doing error
> > +handling when scsi devices fail. After this timeout the scsi layer
> > will perform
> > +a full HBA reset. Setting this may be necessary in cases where the
> > rport is
> > +never lost, so \fIfast_io_fail_tmo\fR and \fIdev_loss_tmo\fR will
> > never
> > +trigger, but (frequently do to load) scsi commands still hang.
> > \fBNote:\fR when
> > +the scsi error handler performs the HBA reset, all target paths on
> > that HBA
> > +will be affected. eh_deadline should only be set in cases where all
> > targets on
> > +the affected HBAs are multipathed.
> > +.RS
> > +.TP
> > +The default is: \fB<unset>\fR
> > +.RE
> > +.
> > +.
> > +.TP
> >  .B bindings_file
> >  The full pathname of the binding file to be used when the
> > user_friendly_names
> >  option is set.
>=20
> --=20
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE  Software Solutions Germany GmbH
> HRB 36809, AG N=FCrnberg GF: Felix
> Imend=F6rffer
>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

