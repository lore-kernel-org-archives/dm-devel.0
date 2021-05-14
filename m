Return-Path: <SRS0=HAWy=KJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A08EC433ED
	for <dm-devel@archiver.kernel.org>; Fri, 14 May 2021 15:52:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D511F6144A
	for <dm-devel@archiver.kernel.org>; Fri, 14 May 2021 15:52:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D511F6144A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1621007522;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bduGRyHo6xW/9nJjq9aU1XS3ikLA2nrQA0LSn2eB6+k=;
	b=g4zuMqYLmCv09ovjAT0r/KG2FwVpKGokHxCm/audlhUjEGI8dm4jpgi6Wx9X6Z/WTguzw+
	bUzmx9czIna18pn+BtOo5Gwo9/KcFAUEVr2b6PhV1MK6tlem+fe7MpDGzso1LhfZgaNc9Z
	NhNrTHKdesUguYERRKDpe7CB/m7J2EY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-wM6m_SpJOk-NSwrv_Jjj4w-1; Fri, 14 May 2021 11:52:01 -0400
X-MC-Unique: wM6m_SpJOk-NSwrv_Jjj4w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0CE59106BB39;
	Fri, 14 May 2021 15:51:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B3DB5C1C2;
	Fri, 14 May 2021 15:51:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 96BA91806D0E;
	Fri, 14 May 2021 15:51:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14EFpnhp021573 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 14 May 2021 11:51:49 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3D4FE2BFE7; Fri, 14 May 2021 15:51:49 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ECDD363BA7;
	Fri, 14 May 2021 15:51:43 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 14EFpgUe018623; 
	Fri, 14 May 2021 10:51:42 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 14EFpgel018622;
	Fri, 14 May 2021 10:51:42 -0500
Date: Fri, 14 May 2021 10:51:41 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20210514155141.GJ25887@octiron.msp.redhat.com>
References: <1620926595-12029-1-git-send-email-bmarzins@redhat.com>
	<1620926595-12029-7-git-send-email-bmarzins@redhat.com>
	<2b55188067c100090ac3783d4fea328d4db83518.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <2b55188067c100090ac3783d4fea328d4db83518.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 6/6] multipathd: use symbolic returns for
 ev_remove_path()
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

On Thu, May 13, 2021 at 08:11:13PM +0000, Martin Wilck wrote:
> On Thu, 2021-05-13 at 12:23 -0500, Benjamin Marzinski wrote:
> > There are many possible outcomes of calling ev_remove_path(), and not
> > all callers agree on which outcomes are a success and which are a
> > failure. So ev_remove_path() should simply return a different value
> > for
> > each outcome, and the callers can decide how to deal with them.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > =A0multipathd/cli_handlers.c | 14 ++++++++++++--
> > =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0 | 35 +++++++++++++++++++--=
--------------
> > =A0multipathd/main.h=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 9 +++++++++
> > =A03 files changed, 40 insertions(+), 18 deletions(-)
> >=20
> > diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> > index 1de6ad8e..1462ea84 100644
> > --- a/multipathd/cli_handlers.c
> > +++ b/multipathd/cli_handlers.c
> > @@ -752,7 +752,8 @@ cli_add_path (void * v, char ** reply, int * len,
> > void * data)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Have the checker reinstate this
> > path asap */
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->tick =3D 1;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}=
 else if (!ev_remove_path(pp, vecs, true))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}=
 else if (ev_remove_path(pp, vecs, true) &
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 REMOVE_PATH_SUCCESS)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Path removed in ev_remove_path()
> > */
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0pp =3D NULL;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0else {
> > @@ -813,6 +814,7 @@ cli_del_path (void * v, char ** reply, int * len,
> > void * data)
> > =A0=A0=A0=A0=A0=A0=A0=A0struct vectors * vecs =3D (struct vectors *)dat=
a;
> > =A0=A0=A0=A0=A0=A0=A0=A0char * param =3D get_keyparam(v, PATH);
> > =A0=A0=A0=A0=A0=A0=A0=A0struct path *pp;
> > +=A0=A0=A0=A0=A0=A0=A0int ret;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0param =3D convert_dev(param, 1);
> > =A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: remove path (operator)", param)=
;
> > @@ -821,7 +823,15 @@ cli_del_path (void * v, char ** reply, int *
> > len, void * data)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "%s: path al=
ready removed", param);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > -=A0=A0=A0=A0=A0=A0=A0return ev_remove_path(pp, vecs, 1);
> > +=A0=A0=A0=A0=A0=A0=A0ret =3D ev_remove_path(pp, vecs, 1);
> > +=A0=A0=A0=A0=A0=A0=A0if (ret =3D=3D REMOVE_PATH_DELAY) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*reply =3D strdup("delaye=
d\n");
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*len =3D strlen(*reply) +=
 1;
> > +=A0=A0=A0=A0=A0=A0=A0} else if (ret =3D=3D REMOVE_PATH_MAP_ERROR) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*reply =3D strdup("map re=
load error. removed\n");
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*len =3D strlen(*reply) +=
 1;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0return (ret =3D=3D REMOVE_PATH_FAILURE);
> > =A0}
> > =A0
> > =A0int
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 4bdf14bd..72fb7e38 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -838,7 +838,7 @@ handle_path_wwid_change(struct path *pp, struct
> > vectors *vecs)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0udd =3D udev_device_ref(pp->udev);
> > -=A0=A0=A0=A0=A0=A0=A0if (ev_remove_path(pp, vecs, 1) !=3D 0 && pp->mpp=
) {
> > +=A0=A0=A0=A0=A0=A0=A0if (!(ev_remove_path(pp, vecs, 1) & REMOVE_PATH_S=
UCCESS) &&
> > pp->mpp) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->dmstate =3D PSTATE_=
FAILED;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0dm_fail_path(pp->mpp->a=
lias, pp->dev_t);
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > @@ -948,8 +948,8 @@ uev_add_path (struct uevent *uev, struct vectors
> > * vecs, int need_do_map)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Make another attempt to remove the
> > path
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->mpp =3D prev_mpp;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0ret =3D ev_remove_path(pp, vecs, true);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0if (ret !=3D 0) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0if (!(ev_remove_path(pp, vecs, true)
> > &
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 REMOVE_PATH_SUCCESS)) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Failure in ev_remove_=
path
> > will keep
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * path in pathvec in
> > INIT_REMOVED state
> > @@ -960,6 +960,7 @@ uev_add_path (struct uevent *uev, struct vectors
> > * vecs, int need_do_map)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0dm_fail_path(pp->mpp->al=
ias,
> > pp->dev_t);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s: failed t=
o re-
> > add path still mapped in %s",
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
pp->dev, pp->mpp-
> > >alias);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =3D 1;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0} else if (r =3D=3D PATHINFO_OK)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Path successfully fre=
ed,
> > move on to
> > @@ -1167,7 +1168,7 @@ static int
> > =A0uev_remove_path (struct uevent *uev, struct vectors * vecs, int
> > need_do_map)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0struct path *pp;
> > -=A0=A0=A0=A0=A0=A0=A0int ret;
> > +=A0=A0=A0=A0=A0=A0=A0int ret =3D 0;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: remove path (uevent)", uev->ker=
nel);
> > =A0=A0=A0=A0=A0=A0=A0=A0delete_foreign(uev->udev);
> > @@ -1176,8 +1177,8 @@ uev_remove_path (struct uevent *uev, struct
> > vectors * vecs, int need_do_map)
> > =A0=A0=A0=A0=A0=A0=A0=A0lock(&vecs->lock);
> > =A0=A0=A0=A0=A0=A0=A0=A0pthread_testcancel();
> > =A0=A0=A0=A0=A0=A0=A0=A0pp =3D find_path_by_dev(vecs->pathvec, uev->ker=
nel);
> > -=A0=A0=A0=A0=A0=A0=A0if (pp)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =3D ev_remove_path(pp=
, vecs, need_do_map);
> > +=A0=A0=A0=A0=A0=A0=A0if (pp && ev_remove_path(pp, vecs, need_do_map) =
=3D=3D
> > REMOVE_PATH_FAILURE)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =3D 1;
> > =A0=A0=A0=A0=A0=A0=A0=A0lock_cleanup_pop(vecs->lock);
> > =A0=A0=A0=A0=A0=A0=A0=A0if (!pp) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Not an error; path m=
ight have been purged earlier
> > */
> > @@ -1191,7 +1192,7 @@ int
> > =A0ev_remove_path (struct path *pp, struct vectors * vecs, int
> > need_do_map)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0struct multipath * mpp;
> > -=A0=A0=A0=A0=A0=A0=A0int i, retval =3D 0;
> > +=A0=A0=A0=A0=A0=A0=A0int i, retval =3D REMOVE_PATH_SUCCESS;
> > =A0=A0=A0=A0=A0=A0=A0=A0char params[PARAMS_SIZE] =3D {0};
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0/*
> > @@ -1245,7 +1246,6 @@ ev_remove_path (struct path *pp, struct vectors
> > * vecs, int need_do_map)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: removed map after"
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0" removing all paths",
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0alias);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0retval =3D 0;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0/* flush_map() has freed the path */
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0}
> > @@ -1262,11 +1262,14 @@ ev_remove_path (struct path *pp, struct
> > vectors * vecs, int need_do_map)
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (mpp->wait_for_udev)=
 {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0mpp->wait_for_udev =3D 2;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
etval =3D REMOVE_PATH_DELAY;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0goto out;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!need_do_map)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!need_do_map) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
etval =3D REMOVE_PATH_DELAY;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0goto out;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * reload the map
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> > @@ -1275,7 +1278,7 @@ ev_remove_path (struct path *pp, struct vectors
> > * vecs, int need_do_map)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0condlog(0, "%s: failed in domap for "
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0"removal of path %s",
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->alias, pp->dev);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
etval =3D 1;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
etval =3D REMOVE_PATH_FAILURE;
>=20
> Hm. With the introduction of INIT_REMOVED, this failure isn't fatal any
> more. As far as multipathd is concerned, the path is removed and will
> be deleted from the map as soon as the reason for the domap() failure
> (likely a problem with some other device in the map) is resolved.
> There's no difference from the REMOVE_PATH_DELAY case wrt how the path
> will be treated in the future.
>=20
> So while I agree it's reasonable to distinguish this case from the
> "delay without failure" cases above, I'm unsure if we should treat it
> as an error in uev_remove_path() (or uev_trigger(), for that matter).

Sure. All that a failure does is print an error message anyway, and a
message already gets printed if domap fails, so another message won't
help with debugging problems.
=20
>=20
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0/*
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 * update our state from kernel
> > @@ -1283,12 +1286,12 @@ ev_remove_path (struct path *pp, struct
> > vectors * vecs, int need_do_map)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0char devt[BLK_DEV_SIZE];
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0strlcpy(devt, pp->dev_t, sizeof(devt));
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/=
* setup_multipath will free the path
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
* regardless of whether it succeeds or
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
* fails */
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (setup_multipath(vecs, mpp))
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/=
*
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
* Successful map reload without this path:
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
* sync_map_state() will free it.
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
*/
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0return REMOVE_PATH_MAP_ERROR;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0sync_map_state(mpp);
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0condlog(2, "%s: path removed from map %s",
> > @@ -1307,7 +1310,7 @@ fail:
> > =A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "%s: error removing path. removing m=
ap %s", pp-
> > >dev,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->alias);
> > =A0=A0=A0=A0=A0=A0=A0=A0remove_map_and_stop_waiter(mpp, vecs);
> > -=A0=A0=A0=A0=A0=A0=A0return 0;
> > +=A0=A0=A0=A0=A0=A0=A0return REMOVE_PATH_MAP_ERROR;
> > =A0}
> > =A0
> > =A0static int
> > diff --git a/multipathd/main.h b/multipathd/main.h
> > index ddd953f9..24d050c8 100644
> > --- a/multipathd/main.h
> > +++ b/multipathd/main.h
> > @@ -13,6 +13,15 @@ enum daemon_status {
> > =A0=A0=A0=A0=A0=A0=A0=A0DAEMON_STATUS_SIZE,
> > =A0};
> > =A0
> > +#define REMOVE_PATH_FAILURE 0x0 /* path was not removed */
>=20
> We should add a remark that this is normally non-fatal, it's init state
> is set to INIT_REMOVED, and that it will be removed at the next
> possible occasion. The only thing that should be avoided is to try and
> add another path with the same major/minor number.

Sure.

> Use an enum, maybe?

I can do that.=20

-Ben

> Regards,
> Martin
>=20
>=20
> > +#define REMOVE_PATH_SUCCESS 0x1 /* path was removed */
> > +#define REMOVE_PATH_DELAY 0x2 /* path is set to be removed later. it
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 * currently still exists and is part
> > of the
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 * kernel map */
> > +#define REMOVE_PATH_MAP_ERROR 0x5 /* map was removed because of
> > error. value
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * includes REMOVE_PATH_SUCCESS bit
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * because the path was also
> > removed */
>=20
>=20
>=20
> > +
> > =A0struct prout_param_descriptor;
> > =A0struct prin_resp;
> > =A0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

