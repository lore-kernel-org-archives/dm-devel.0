Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35409C7EE23
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 18:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686163599;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4eA7H/xl1RdmnixNgAglhVSLIFckOG6XkmcJxZDwQjE=;
	b=K5GoUx7IaZYZvHxScusb4x+XyNt+ZZdQCnxP7/3cI1zgAsY1+xV9G7nQHYTblNEZ5363e/
	o52fEObbY/MnCpEVGZ0zhN9n4pIZhhGv9RJiNK95w3aCo6zuSIFmJnsK/svYnpXb0KFSYo
	4A157NJ6jFmDBBefJVIcSBSK7AikV/4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-xTfpFc-XNIuWXrINduMTKg-1; Wed, 07 Jun 2023 14:46:36 -0400
X-MC-Unique: xTfpFc-XNIuWXrINduMTKg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8D843C0286A;
	Wed,  7 Jun 2023 18:46:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C44D8492B00;
	Wed,  7 Jun 2023 18:46:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 849ED19452C3;
	Wed,  7 Jun 2023 18:46:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ECEA719465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 18:46:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A9300403367; Wed,  7 Jun 2023 18:46:32 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 013F8403176;
 Wed,  7 Jun 2023 18:46:31 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 357IkTfg005208;
 Wed, 7 Jun 2023 13:46:29 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 357IkSrb005207;
 Wed, 7 Jun 2023 13:46:28 -0500
Date: Wed, 7 Jun 2023 13:46:28 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20230607184628.GE32239@octiron.msp.redhat.com>
References: <1686082391-29210-1-git-send-email-bmarzins@redhat.com>
 <1686082391-29210-2-git-send-email-bmarzins@redhat.com>
 <ba8f322db61002338353839fbd2d4921a5c11ebd.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <ba8f322db61002338353839fbd2d4921a5c11ebd.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH V2 01/11] libmultipath: add group_by_tpg
 path_grouping_policy
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 07, 2023 at 06:31:19PM +0000, Martin Wilck wrote:
> On Tue, 2023-06-06 at 15:13 -0500, Benjamin Marzinski wrote:
> > =A0#endif
> > diff --git a/libmultipath/prioritizers/alua.c
> > b/libmultipath/prioritizers/alua.c
> > index 0ab06e2b..4888a974 100644
> > --- a/libmultipath/prioritizers/alua.c
> > +++ b/libmultipath/prioritizers/alua.c
> > @@ -65,6 +65,7 @@ get_alua_info(struct path * pp, unsigned int
> > timeout)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0return -ALUA_PRIO_NOT_SUPPORTED;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -ALUA_PRIO_RTPG_=
FAILED;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0pp->tpg_id =3D tpg;
> > =A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: reported target port group is %=
i", pp->dev,
>=20
>=20
> I still think that we should log a change here. Perhaps we should keep
> the existing condlog() and just use prio 2 if the tpg_id changed, and
> prio 4 if it didn't (the current 3 clutters the logs quite a bit).

Oops. My Bad. I meant to add that. I'll send a follow-on patch.=20

-Ben

>=20
> Regards
> Martin
>=20
>=20
>=20
> > tpg);
> > =A0=A0=A0=A0=A0=A0=A0=A0rc =3D get_asymmetric_access_state(pp, tpg, tim=
eout);
> > =A0=A0=A0=A0=A0=A0=A0=A0if (rc < 0) {
> > diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> > index a25cc921..841fa247 100644
> > --- a/libmultipath/propsel.c
> > +++ b/libmultipath/propsel.c
> > @@ -35,7 +35,8 @@ pgpolicyfn *pgpolicies[] =3D {
> > =A0=A0=A0=A0=A0=A0=A0=A0one_group,
> > =A0=A0=A0=A0=A0=A0=A0=A0group_by_serial,
> > =A0=A0=A0=A0=A0=A0=A0=A0group_by_prio,
> > -=A0=A0=A0=A0=A0=A0=A0group_by_node_name
> > +=A0=A0=A0=A0=A0=A0=A0group_by_node_name,
> > +=A0=A0=A0=A0=A0=A0=A0group_by_tpg,
> > =A0};
> > =A0
> > =A0#define do_set(var, src, dest,
> > msg)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > @@ -249,10 +250,26 @@ out:
> > =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0}
> > =A0
> > +static bool
> > +verify_alua_prio(struct multipath *mp)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0int i;
> > +=A0=A0=A0=A0=A0=A0=A0struct path *pp;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(mp->paths, pp, i) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0const char *name =3D prio=
_name(&pp->prio);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (strncmp(name, PRIO_AL=
UA, PRIO_NAME_LEN) &&
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 strncmp(name, P=
RIO_SYSFS, PRIO_NAME_LEN))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
return false;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0return true;
> > +}
> > +
> > =A0int select_pgpolicy(struct config *conf, struct multipath * mp)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0const char *origin;
> > =A0=A0=A0=A0=A0=A0=A0=A0char buff[POLICY_NAME_SIZE];
> > +=A0=A0=A0=A0=A0=A0=A0int log_prio =3D 3;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0if (conf->pgpolicy_flag > 0) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mp->pgpolicy =3D conf->=
pgpolicy_flag;
> > @@ -265,9 +282,15 @@ int select_pgpolicy(struct config *conf, struct
> > multipath * mp)
> > =A0=A0=A0=A0=A0=A0=A0=A0mp_set_conf(pgpolicy);
> > =A0=A0=A0=A0=A0=A0=A0=A0mp_set_default(pgpolicy, DEFAULT_PGPOLICY);
> > =A0out:
> > +=A0=A0=A0=A0=A0=A0=A0if (mp->pgpolicy =3D=3D GROUP_BY_TPG && !verify_a=
lua_prio(mp)) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mp->pgpolicy =3D DEFAULT_=
PGPOLICY;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0origin =3D "(setting: eme=
rgency fallback - not all
> > paths use alua prio)";
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0log_prio =3D 1;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0mp->pgpolicyfn =3D pgpolicies[mp->pgpolicy];
> > =A0=A0=A0=A0=A0=A0=A0=A0get_pgpolicy_name(buff, POLICY_NAME_SIZE, mp->p=
gpolicy);
> > -=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: path_grouping_policy =3D %s %s", =
mp->alias,
> > buff, origin);
> > +=A0=A0=A0=A0=A0=A0=A0condlog(log_prio, "%s: path_grouping_policy =3D %=
s %s", mp-
> > >alias, buff,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0origin);
> > =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0}
> > =A0
> > diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> > index 87e84d5d..39504dca 100644
> > --- a/libmultipath/structs.c
> > +++ b/libmultipath/structs.c
> > @@ -125,6 +125,7 @@ alloc_path (void)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->sg_id.proto_id =3D =
PROTOCOL_UNSET;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->fd =3D -1;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->tpgs =3D TPGS_UNDEF=
;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->tpg_id =3D GROUP_ID_U=
NDEF;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->priority =3D PRIO_U=
NDEF;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->checkint =3D CHECKI=
NT_UNDEF;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0checker_clear(&pp->chec=
ker);
> > diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> > index a1208751..0eea19b4 100644
> > --- a/libmultipath/structs.h
> > +++ b/libmultipath/structs.h
> > @@ -317,6 +317,8 @@ struct hd_geometry {
> > =A0};
> > =A0#endif
> > =A0
> > +#define GROUP_ID_UNDEF -1
> > +
> > =A0struct path {
> > =A0=A0=A0=A0=A0=A0=A0=A0char dev[FILE_NAME_SIZE];
> > =A0=A0=A0=A0=A0=A0=A0=A0char dev_t[BLK_DEV_SIZE];
> > @@ -372,6 +374,7 @@ struct path {
> > =A0=A0=A0=A0=A0=A0=A0=A0/* configlet pointers */
> > =A0=A0=A0=A0=A0=A0=A0=A0vector hwe;
> > =A0=A0=A0=A0=A0=A0=A0=A0struct gen_path generic_path;
> > +=A0=A0=A0=A0=A0=A0=A0int tpg_id;
> > =A0};
> > =A0
> > =A0typedef int (pgpolicyfn) (struct multipath *, vector);
> > diff --git a/multipath/main.c b/multipath/main.c
> > index 90f940f1..b78f3162 100644
> > --- a/multipath/main.c
> > +++ b/multipath/main.c
> > @@ -157,6 +157,7 @@ usage (char * progname)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 . group_by_serial=A0=A0=A0=A0 one priority group
> > per serial\n"
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 . group_by_prio=A0=A0=A0=A0=A0=A0 one priority group
> > per priority lvl\n"
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 . group_by_node_name=A0 one priority group
> > per target node\n"
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 . group_by_tpg=A0=A0=A0=A0=A0=A0=A0 one priority group
> > per ALUA target port group\n"
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"=A0 -v lvl=A0 verbosit=
y level:\n"
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 . 0 no output\n"
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 . 1 print created devmap names only\n"
> > diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> > index b4dccd1b..b65a543d 100644
> > --- a/multipath/multipath.conf.5
> > +++ b/multipath/multipath.conf.5
> > @@ -233,6 +233,10 @@ per-multipath option in the configuration file.
> > =A0One priority group per target node name. Target node names are
> > fetched
> > =A0in \fI/sys/class/fc_transport/target*/node_name\fR.
> > =A0.TP
> > +.I group_by_tpg
> > +One priority group per ALUA target port group. In order to use this
> > policy,
> > +all paths in the multipath device must have \fIprio\fR set to
> > \fBalua\fR.
> > +.TP
> > =A0The default is: \fBfailover\fR
> > =A0.RE
> > =A0.
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

