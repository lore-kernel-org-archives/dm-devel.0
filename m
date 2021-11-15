Return-Path: <SRS0=k/UL=QC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8221C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 15 Nov 2021 23:46:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 64EE761B62
	for <dm-devel@archiver.kernel.org>; Mon, 15 Nov 2021 23:46:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 64EE761B62
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637019985;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=D94VNzb33H+Nj7sK3ZeRgIAM/B/fYIPGK07dmWFd8NE=;
	b=ZmQAu4xg9zg3/wen8u5gCfDXzai4RbeJd/91MQqxygyXik3VQUtoLQD3zAtpLNmznb6Wof
	X0pVrFphb6Cjwad/uzXZTC36X+mRXX2mutlvULDWXwLv4+FI00YHaF9qZHDxF/bkWpXGwo
	XYo5ztVqnE2ftICDqaYpXbsTjioP1RA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-dVs8pHbOOI-syHUGO2bVnw-1; Mon, 15 Nov 2021 18:46:21 -0500
X-MC-Unique: dVs8pHbOOI-syHUGO2bVnw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6BA6E87180C;
	Mon, 15 Nov 2021 23:46:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0471A5DF21;
	Mon, 15 Nov 2021 23:46:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 867A94E58F;
	Mon, 15 Nov 2021 23:46:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AFNkECC000576 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 15 Nov 2021 18:46:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E1E1F60C13; Mon, 15 Nov 2021 23:46:14 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C57860BE5;
	Mon, 15 Nov 2021 23:46:10 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AFNk8vX022250; 
	Mon, 15 Nov 2021 17:46:08 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AFNk8nC022249;
	Mon, 15 Nov 2021 17:46:08 -0600
Date: Mon, 15 Nov 2021 17:46:08 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20211115234608.GW19591@octiron.msp.redhat.com>
References: <1632180076-9294-1-git-send-email-bmarzins@redhat.com>
	<1632180076-9294-4-git-send-email-bmarzins@redhat.com>
	<0b1c32c80fb5263df6263570f26b60247576f1b5.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <0b1c32c80fb5263df6263570f26b60247576f1b5.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 3/4] multipathd: pass in the type of
	reconfigure
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 15, 2021 at 04:23:54PM +0000, Martin Wilck wrote:
> On Mon, 2021-09-20 at 18:21 -0500, Benjamin Marzinski wrote:
> > This code doesn't actually change how multipathd reconfigures. It still
> > does a weak reconfigure at the start, and full reconfigures later.
>=20
> AFAICS it does change this, at least for the cases where reconfigure()
> is called from ev_add_map() and missing_uev_wait_tick, where you call
> schedule_reconfigure(false). The old code was using a static variable
> and thus always doing a hard reconfigure when called more than once.
>=20
> I'm find with this change (the old behavior was arguably wrong), but
> the commit message should be clarified in this respect.

Sure.

-Ben

>=20
> > But
> > now schedule_reconfigure() takes the type of reconfigure to do, and
> > that
> > gets passed down to reconfigure(). If a full reconfigure has already
> > been requested but not started, weak reconfigure requests will be
> > upgraded. A future patch will enable users to control what kind of
> > reconfigures happen.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > =A0libmultipath/configure.c=A0 |=A0 2 +-
> > =A0multipathd/cli_handlers.c |=A0 2 +-
> > =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0 | 62 ++++++++++++++++++++-=
------------------
> > =A0multipathd/main.h=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 2 +-
> > =A04 files changed, 35 insertions(+), 33 deletions(-)
> >=20
> > diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> > index 7edb355b..eb8ec1bd 100644
> > --- a/libmultipath/configure.c
> > +++ b/libmultipath/configure.c
> > @@ -1098,7 +1098,7 @@ out:
> > =A0 * FORCE_RELOAD_NONE: existing maps aren't touched at all
> > =A0 * FORCE_RELOAD_YES: all maps are rebuilt from scratch and (re)loade=
d
> > in DM
> > =A0 * FORCE_RELOAD_WEAK: existing maps are compared to the current conf
> > and only
> > - * reloaded in DM if there's a difference. This is useful during
> > startup.
> > + * reloaded in DM if there's a difference. This is normally
> > sufficient.
> > =A0 */
> > =A0int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwi=
d,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int force_rel=
oad, enum mpath_cmds cmd)
> > diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> > index f59db3ab..b12a4e7e 100644
> > --- a/multipathd/cli_handlers.c
> > +++ b/multipathd/cli_handlers.c
> > @@ -1012,7 +1012,7 @@ cli_reconfigure(void * v, struct strbuf *reply,
> > void * data)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "reconfigure (operator)");
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0schedule_reconfigure();
> > +=A0=A0=A0=A0=A0=A0=A0schedule_reconfigure(true);
> > =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0}
> > =A0
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 1ead0904..5c831e8d 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -162,13 +162,6 @@ static bool get_delayed_reconfig(void)
> > =A0=A0=A0=A0=A0=A0=A0=A0return val;
> > =A0}
> > =A0
> > -static void set_delayed_reconfig(bool val)
> > -{
> > -=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&config_lock);
> > -=A0=A0=A0=A0=A0=A0=A0__delayed_reconfig =3D val;
> > -=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock(&config_lock);
> > -}
> > -
> > =A0/*
> > =A0 * global copy of vecs for use in sig handlers
> > =A0 */
> > @@ -290,7 +283,18 @@ enum daemon_status wait_for_state_change_if(enum
> > daemon_status oldstate,
> > =A0}
> > =A0
> > =A0/* Don't access this variable without holding config_lock */
> > -static bool reconfigure_pending;
> > +static enum force_reload_types reconfigure_pending =3D
> > FORCE_RELOAD_NONE;
> > +/* Only set while changing to DAEMON_CONFIGURE, and only access while
> > + * reconfiguring in DAEMON_CONFIGURE */
> > +static volatile enum force_reload_types reload_type =3D
> > FORCE_RELOAD_NONE;
> > +
> > +static void enable_delayed_reconfig(enum force_reload_types type)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&config_lock);
> > +=A0=A0=A0=A0=A0=A0=A0reconfigure_pending =3D type;
> > +=A0=A0=A0=A0=A0=A0=A0__delayed_reconfig =3D true;
> > +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock(&config_lock);
> > +}
> > =A0
> > =A0/* must be called with config_lock held */
> > =A0static void __post_config_state(enum daemon_status state)
> > @@ -305,7 +309,8 @@ static void __post_config_state(enum daemon_status
> > state)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * In either case, chil=
d() will see DAEMON_CONFIGURE
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * again and start anot=
her reconfigure cycle.
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (reconfigure_pending &=
& state =3D=3D DAEMON_IDLE &&
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (reconfigure_pending !=
=3D FORCE_RELOAD_NONE &&
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 state =3D=3D DA=
EMON_IDLE &&
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (old_state =
=3D=3D DAEMON_CONFIGURE ||
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 old_state =
=3D=3D DAEMON_RUNNING)) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0/*
> > @@ -317,7 +322,8 @@ static void __post_config_state(enum daemon_status
> > state)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0state =3D DAEMON_CONFIGURE;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (state =3D=3D DAEMON=
_CONFIGURE) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
econfigure_pending =3D false;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eload_type =3D (reconfigure_pending =3D=3D
> > FORCE_RELOAD_YES) ? FORCE_RELOAD_YES : FORCE_RELOAD_WEAK;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
econfigure_pending =3D FORCE_RELOAD_NONE;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0__delayed_reconfig =3D false;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0running_state =3D state=
;
> > @@ -334,20 +340,25 @@ void post_config_state(enum daemon_status state)
> > =A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> > =A0}
> > =A0
> > -void schedule_reconfigure(void)
> > +void schedule_reconfigure(bool force_reload_yes)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&config_lock);
> > =A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(config_cleanup, NULL);
> > +=A0=A0=A0=A0=A0=A0=A0enum force_reload_types type;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0type =3D (reconfigure_pending =3D=3D FORCE_RELOAD=
_YES ||
> > force_reload_yes) ?
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 FORCE_RELOAD_YES : FORCE_RELOA=
D_WEAK;
> > =A0=A0=A0=A0=A0=A0=A0=A0switch (running_state)
> > =A0=A0=A0=A0=A0=A0=A0=A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0case DAEMON_SHUTDOWN:
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> > =A0=A0=A0=A0=A0=A0=A0=A0case DAEMON_IDLE:
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0reconfigure_pending =3D t=
ype;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0__post_config_state(DAE=
MON_CONFIGURE);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> > =A0=A0=A0=A0=A0=A0=A0=A0case DAEMON_CONFIGURE:
> > =A0=A0=A0=A0=A0=A0=A0=A0case DAEMON_RUNNING:
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0reconfigure_pending =3D t=
rue;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0reconfigure_pending =3D t=
ype;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> > =A0=A0=A0=A0=A0=A0=A0=A0default:
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> > @@ -812,7 +823,7 @@ ev_add_map (char * dev, const char * alias, struct
> > vectors * vecs)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (get_delayed_reconfig() &&
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 !need_to_delay_reconfig(vecs)) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "reconfigure (delayed)");
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0schedule_reconfigure();
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0schedule_reconfigure(false);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > @@ -1830,7 +1841,7 @@ missing_uev_wait_tick(struct vectors *vecs)
> > =A0=A0=A0=A0=A0=A0=A0=A0if (timed_out && get_delayed_reconfig() &&
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 !need_to_delay_reconfig(vecs)) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "reconfigure=
 (delayed)");
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0schedule_reconfigure();
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0schedule_reconfigure(fals=
e);
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0}
> > =A0
> > @@ -2588,14 +2599,13 @@ checkerloop (void *ap)
> > =A0}
> > =A0
> > =A0int
> > -configure (struct vectors * vecs)
> > +configure (struct vectors * vecs, enum force_reload_types type)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0struct multipath * mpp;
> > =A0=A0=A0=A0=A0=A0=A0=A0struct path * pp;
> > =A0=A0=A0=A0=A0=A0=A0=A0vector mpvec;
> > =A0=A0=A0=A0=A0=A0=A0=A0int i, ret;
> > =A0=A0=A0=A0=A0=A0=A0=A0struct config *conf;
> > -=A0=A0=A0=A0=A0=A0=A0static int force_reload =3D FORCE_RELOAD_WEAK;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0if (!vecs->pathvec && !(vecs->pathvec =3D vecto=
r_alloc())) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "couldn't al=
locate path vec in configure");
> > @@ -2643,15 +2653,7 @@ configure (struct vectors * vecs)
> > =A0=A0=A0=A0=A0=A0=A0=A0if (should_exit())
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto fail;
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0/*
> > -=A0=A0=A0=A0=A0=A0=A0 * create new set of maps & push changed ones int=
o dm
> > -=A0=A0=A0=A0=A0=A0=A0 * In the first call, use FORCE_RELOAD_WEAK to av=
oid making
> > -=A0=A0=A0=A0=A0=A0=A0 * superfluous ACT_RELOAD ioctls. Later calls are=
 done
> > -=A0=A0=A0=A0=A0=A0=A0 * with FORCE_RELOAD_YES.
> > -=A0=A0=A0=A0=A0=A0=A0 */
> > -=A0=A0=A0=A0=A0=A0=A0ret =3D coalesce_paths(vecs, mpvec, NULL, force_r=
eload,
> > CMD_NONE);
> > -=A0=A0=A0=A0=A0=A0=A0if (force_reload =3D=3D FORCE_RELOAD_WEAK)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0force_reload =3D FORCE_RE=
LOAD_YES;
> > +=A0=A0=A0=A0=A0=A0=A0ret =3D coalesce_paths(vecs, mpvec, NULL, type, C=
MD_NONE);
>=20
>=20
> Can we please rename this variable from "type" to "reload_type" here,
> for the sake of readability? Likewise, in reconfigure()?
>=20
> > =A0=A0=A0=A0=A0=A0=A0=A0if (ret !=3D CP_OK) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "configure f=
ailed while coalescing paths");
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto fail;
> > @@ -2729,7 +2731,7 @@ void rcu_free_config(struct rcu_head *head)
> > =A0}
> > =A0
> > =A0int
> > -reconfigure (struct vectors * vecs)
> > +reconfigure (struct vectors * vecs, enum force_reload_types type)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0struct config * old, *conf;
> > =A0
> > @@ -2763,7 +2765,7 @@ reconfigure (struct vectors * vecs)
> > =A0=A0=A0=A0=A0=A0=A0=A0rcu_assign_pointer(multipath_conf, conf);
> > =A0=A0=A0=A0=A0=A0=A0=A0call_rcu(&old->rcu, rcu_free_config);
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0configure(vecs);
> > +=A0=A0=A0=A0=A0=A0=A0configure(vecs, type);
> > =A0
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > @@ -2815,7 +2817,7 @@ handle_signals(bool nonfatal)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> > =A0=A0=A0=A0=A0=A0=A0=A0if (reconfig_sig) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "reconfigure=
 (signal)");
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0schedule_reconfigure();
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0schedule_reconfigure(true=
);
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0if (log_reset_sig) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "reset log (=
signal)");
> > @@ -3274,9 +3276,9 @@ child (__attribute__((unused)) void *param)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0lock(&vecs->lock);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0pthread_testcancel();
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (!need_to_delay_reconfig(vecs))
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0reconfigure(vecs);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0reconfigure(vecs, reload_type);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0else
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0set_delayed_reconfig(true);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0enable_delayed_reconfig(reload_type);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0lock_cleanup_pop(vecs->lock);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0post_config_state(DAEMON_IDLE);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > diff --git a/multipathd/main.h b/multipathd/main.h
> > index a1697a74..c8a1ce92 100644
> > --- a/multipathd/main.h
> > +++ b/multipathd/main.h
> > @@ -37,7 +37,7 @@ void exit_daemon(void);
> > =A0const char * daemon_status(void);
> > =A0enum daemon_status wait_for_state_change_if(enum daemon_status
> > oldstate,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 unsigned long =
ms);
> > -void schedule_reconfigure(void);
> > +void schedule_reconfigure(bool reconfig_all);
>=20
> For consistency, please consider using an "enum force_reload_types" as
> argument to schedule_reconfigure() rather than a boolean.
>=20
> Otherwise, the patch looks good.
>=20
> Cheers
> Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

