Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BB56C433FE
	for <dm-devel@archiver.kernel.org>; Fri, 21 Oct 2022 17:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666374561;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=o6Rd8eZ2TyvsxT9lAo5YwncO+IFziZDdNxIPlpGV0BI=;
	b=GNuwlxku8DDjU7UdkgCURhF7RU2YOOLHImN+GkNxJhL1ldmg9A4UF1tr46vlV75/c7nbVY
	z8cdmYf3y45amvPyma0/OVVcBqn8vLfEhd+OjJj1d/oOgVyd6OhaoyH+NFz0+JzoM4nkn+
	SkhMt1CGyqmKgwfAQWHOIe3GsBZKt90=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-VKYh8wFOM_WI0Dmv0fCWBw-1; Fri, 21 Oct 2022 13:49:18 -0400
X-MC-Unique: VKYh8wFOM_WI0Dmv0fCWBw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30128101E14D;
	Fri, 21 Oct 2022 17:49:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CE2AE2166B2C;
	Fri, 21 Oct 2022 17:49:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A21071946587;
	Fri, 21 Oct 2022 17:49:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5513C1946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 21 Oct 2022 17:49:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B53261759E; Fri, 21 Oct 2022 17:49:14 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 938B917585;
 Fri, 21 Oct 2022 17:49:14 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 29LHnDob025931;
 Fri, 21 Oct 2022 12:49:13 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 29LHn3pa025929;
 Fri, 21 Oct 2022 12:49:03 -0500
Date: Fri, 21 Oct 2022 12:48:37 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20221021174837.GC19568@octiron.msp.redhat.com>
References: <1665164144-6716-1-git-send-email-bmarzins@redhat.com>
 <1665164144-6716-5-git-send-email-bmarzins@redhat.com>
 <72e32000e148f9abc792b24afd15aebb5262ad7d.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <72e32000e148f9abc792b24afd15aebb5262ad7d.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 4/8] libmultipath: fix queue_mode feature
 handling
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 20, 2022 at 02:58:42PM +0000, Martin Wilck wrote:
> On Fri, 2022-10-07 at 12:35 -0500, Benjamin Marzinski wrote:
> > device-mapper is not able to change the queue_mode on a table reload.
> > Make sure that when multipath sets up the map, both on regular
> > reloads
> > and reconfigures, it keeps the queue_mode the same.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> Reviewed-by: Martin Wilck <mwilck@suse.com>
>=20
> Some remarks below.
>=20
> > ---
> > =A0libmultipath/configure.c=A0=A0 |=A0 4 +++
> > =A0libmultipath/dmparser.c=A0=A0=A0 |=A0 2 ++
> > =A0libmultipath/propsel.c=A0=A0=A0=A0 | 55
> > ++++++++++++++++++++++++++++++++++++++
> > =A0libmultipath/structs.h=A0=A0=A0=A0 |=A0 7 +++++
> > =A0multipath/multipath.conf.5 |=A0 7 +++--
> > =A05 files changed, 73 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> > index 8af7cd79..41641e30 100644
> > --- a/libmultipath/configure.c
> > +++ b/libmultipath/configure.c
> > @@ -1075,6 +1075,7 @@ int coalesce_paths (struct vectors *vecs,
> > vector mpvec, char *refwwid,
> > =A0=A0=A0=A0=A0=A0=A0=A0struct config *conf =3D NULL;
> > =A0=A0=A0=A0=A0=A0=A0=A0int allow_queueing;
> > =A0=A0=A0=A0=A0=A0=A0=A0struct bitfield *size_mismatch_seen;
> > +=A0=A0=A0=A0=A0=A0=A0struct multipath * cmpp;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0/* ignore refwwid if it's empty */
> > =A0=A0=A0=A0=A0=A0=A0=A0if (refwwid && !strlen(refwwid))
> > @@ -1184,6 +1185,9 @@ int coalesce_paths (struct vectors *vecs,
> > vector mpvec, char *refwwid,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0verify_paths(mpp);
> > =A0
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0cmpp =3D find_mp_by_wwid(=
curmp, mpp->wwid);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (cmpp)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0m=
pp->queue_mode =3D cmpp->queue_mode;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (setup_map(mpp, &par=
ams, vecs)) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0remove_map(mpp, vecs->pathvec, NULL);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0continue;
> > diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
> > index 50d13c08..3b37a926 100644
> > --- a/libmultipath/dmparser.c
> > +++ b/libmultipath/dmparser.c
> > @@ -151,6 +151,8 @@ int disassemble_map(const struct _vector
> > *pathvec,
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(word);
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0mpp->queue_mode =3D strstr(mpp->features, "queue_=
mode bio") ?
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 QUEUE_MODE_BIO : QUEUE_MODE_RQ;
>=20
> Nitpick: You have spent effort to make multipath-tools support any
> whitepace characters in the previous patches, but here you don't. I can
> see that disassemble_map() generally assumes space characters as word
> delimiters, but at least I see some inconsistency here.
>=20
> Do you intend to generalize the whitespace handling in
> disassemble_map(), too? Or am I overlooking something?

The kernel will never output any whitespace characters other than space,
so that seems like unnecessary complexity.  We also know that the kernel
will never output a feature named something like "enqueue_mode" so we
don't need to check for the space before "queue_mode". But I suppose the
the kernel could add feature named "<something>queue_mode" in the
future. If you think it's important, I send a patch to add a space
before "queue_mode", in the check to deal with that possibility, but I'm
not particularly worried about this.
=20
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0/*
> > =A0=A0=A0=A0=A0=A0=A0=A0 * hwhandler
> > diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> > index 98e3aad1..d4f19897 100644
> > --- a/libmultipath/propsel.c
> > +++ b/libmultipath/propsel.c
> > @@ -26,6 +26,7 @@
> > =A0#include "strbuf.h"
> > =A0#include <inttypes.h>
> > =A0#include <libudev.h>
> > +#include <ctype.h>
> > =A0
> > =A0pgpolicyfn *pgpolicies[] =3D {
> > =A0=A0=A0=A0=A0=A0=A0=A0NULL,
> > @@ -413,6 +414,59 @@ void reconcile_features_with_options(const char
> > *id, char **features, int* no_pa
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0}
> > =A0
> > +static void reconcile_features_with_queue_mode(struct multipath *mp)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0char *space =3D NULL, *val =3D NULL, *mode_str =
=3D NULL, *feat;
> > +=A0=A0=A0=A0=A0=A0=A0int features_mode =3D QUEUE_MODE_UNDEF;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (!mp->features)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanup_free_ptr, &space);
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanup_free_ptr, &val);
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanup_free_ptr, &mode_str)=
;
>=20
> I was wondering why we need pthread_cleanup() complexity here, seeing
> no cancellation points in this function. I eventually realized that
> condlog()->dlog()->log_safe()->pthread_mutex_lock() is a cancellation
> point. I suppose we need to clean that up some time.
>=20

So is fprintf(), so even as a systemd style daemon, condlog() is a
cancellation point.
=20
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (!(feat =3D strstr(mp->features, "queue_mode")=
) ||
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 feat =3D=3D mp->features || !isspace(*(=
feat - 1)) ||
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sscanf(feat, "queue_mode%m[ \f\n\r\t\v]=
%ms", &space,
> > &val) !=3D 2)
>=20
> Nit: Given that mp->features comes from the multipath.conf, I'm pretty
> sure that it can't contain \n or \r as whitespace characters
> (read_line() would remove them()). Not sure about \f and \v; guess they
> are allowed but I wouldn't swear that they can be used in
> multipath.conf without causing trouble elsewhere.

I was matching the characters that isspace() checks for, for
consistency, since we used isspace() to check that there was a space
before "queue_mode".

-Ben
=20
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto sync_mode;
> > +=A0=A0=A0=A0=A0=A0=A0if (asprintf(&mode_str, "queue_mode%s%s", space, =
val) < 0) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "failed to all=
ocate space for queue_mode
> > feature string");
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mode_str =3D NULL; /* val=
ue undefined on failure */
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto exit;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (!strcmp(val, "rq") || !strcmp(val, "mq"))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0features_mode =3D QUEUE_M=
ODE_RQ;
> > +=A0=A0=A0=A0=A0=A0=A0else if (!strcmp(val, "bio"))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0features_mode =3D QUEUE_M=
ODE_BIO;
> > +=A0=A0=A0=A0=A0=A0=A0if (features_mode =3D=3D QUEUE_MODE_UNDEF) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: ignoring =
invalid feature '%s'",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0m=
p->alias, mode_str);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto sync_mode;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (mp->queue_mode =3D=3D QUEUE_MODE_UNDEF)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mp->queue_mode =3D featur=
es_mode;
> > +=A0=A0=A0=A0=A0=A0=A0if (mp->queue_mode =3D=3D features_mode)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto exit;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0condlog(2,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"%s: ignoring feature '%s=
' because queue_mode is set
> > to '%s'",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mp->alias, mode_str,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(mp->queue_mode =3D=3D QU=
EUE_MODE_RQ)? "rq" : "bio");
> > +
> > +sync_mode:
> > +=A0=A0=A0=A0=A0=A0=A0if (mode_str)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0remove_feature(&mp->featu=
res, mode_str);
> > +=A0=A0=A0=A0=A0=A0=A0if (mp->queue_mode =3D=3D QUEUE_MODE_BIO)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0add_feature(&mp->features=
, "queue_mode bio");
> > +exit:
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> > +}
> > +
> > =A0int select_features(struct config *conf, struct multipath *mp)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0const char *origin;
> > @@ -428,6 +482,7 @@ out:
> > =A0=A0=A0=A0=A0=A0=A0=A0reconcile_features_with_options(mp->alias, &mp-=
>features,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0&mp->no_path_retry,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0&mp->retain_hwhandler);
> > +=A0=A0=A0=A0=A0=A0=A0reconcile_features_with_queue_mode(mp);
> > =A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: features =3D \"%s\" %s", mp->al=
ias, mp-
> > >features, origin);
> > =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0}
> > diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> > index 5a713d46..129bdf0e 100644
> > --- a/libmultipath/structs.h
> > +++ b/libmultipath/structs.h
> > @@ -170,6 +170,12 @@ enum max_sectors_kb_states {
> > =A0=A0=A0=A0=A0=A0=A0=A0MAX_SECTORS_KB_MIN =3D 4,=A0 /* can't be smalle=
r than page size
> > */
> > =A0};
> > =A0
> > +enum queue_mode_states {
> > +=A0=A0=A0=A0=A0=A0=A0QUEUE_MODE_UNDEF =3D 0,
> > +=A0=A0=A0=A0=A0=A0=A0QUEUE_MODE_BIO,
> > +=A0=A0=A0=A0=A0=A0=A0QUEUE_MODE_RQ,
> > +};
> > +
> > =A0enum scsi_protocol {
> > =A0=A0=A0=A0=A0=A0=A0=A0SCSI_PROTOCOL_FCP =3D 0,=A0=A0/* Fibre Channel =
*/
> > =A0=A0=A0=A0=A0=A0=A0=A0SCSI_PROTOCOL_SPI =3D 1,=A0=A0/* parallel SCSI =
*/
> > @@ -396,6 +402,7 @@ struct multipath {
> > =A0=A0=A0=A0=A0=A0=A0=A0int needs_paths_uevent;
> > =A0=A0=A0=A0=A0=A0=A0=A0int ghost_delay;
> > =A0=A0=A0=A0=A0=A0=A0=A0int ghost_delay_tick;
> > +=A0=A0=A0=A0=A0=A0=A0int queue_mode;
> > =A0=A0=A0=A0=A0=A0=A0=A0uid_t uid;
> > =A0=A0=A0=A0=A0=A0=A0=A0gid_t gid;
> > =A0=A0=A0=A0=A0=A0=A0=A0mode_t mode;
> > diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> > index e098d555..46a4126c 100644
> > --- a/multipath/multipath.conf.5
> > +++ b/multipath/multipath.conf.5
> > @@ -459,8 +459,11 @@ precedence. See KNOWN ISSUES.
> > =A0<mode> can be \fIbio\fR, \fIrq\fR or \fImq\fR, which corresponds to
> > =A0bio-based, request-based, and block-multiqueue (blk-mq) request-
> > based,
> > =A0respectively.
> > -The default depends on the kernel parameter \fBdm_mod.use_blk_mq\fR.
> > It is
> > -\fImq\fR if the latter is set, and \fIrq\fR otherwise.
> > +Before kernel 4.20 The default depends on the kernel parameter
> > +\fBdm_mod.use_blk_mq\fR. It is \fImq\fR if the latter is set, and
> > \fIrq\fR
> > +otherwise. Since kernel 4.20, \fIrq\fR and \fImq\fR both correspond
> > to
> > +block-multiqueue. Once a multipath device has been created, its
> > queue_mode
> > +cannot be changed.
> > =A0.TP
> > =A0The default is: \fB<unset>\fR
> > =A0.RE
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

