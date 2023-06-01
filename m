Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 100EBC7EE23
	for <dm-devel@archiver.kernel.org>; Thu,  1 Jun 2023 17:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685641656;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mwEhr02iZAzPuke7pyepQ5Yt67KvNQpNxOuhn64si8k=;
	b=F9pEIF9p1V+2EUvCmPkIA/g6hrg/UsJJKHvYcwnjeAWzAdA8xjxz0k7MSxSbr9iRIhLuKz
	mM3Oangi0qWm9xhHEMEgk9cC3/RrrVGOJzD/uLMec+/mW/fy09oEOg62DeoUqBhiP7yHIX
	CcUX4bDmwCwqdrbaLdsU9vamSxcRzTU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-224-pxllGB9NM6C1vCwZA9snOQ-1; Thu, 01 Jun 2023 13:47:33 -0400
X-MC-Unique: pxllGB9NM6C1vCwZA9snOQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8A6D101A53A;
	Thu,  1 Jun 2023 17:47:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6BB8A9E63;
	Thu,  1 Jun 2023 17:47:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 190CC1946595;
	Thu,  1 Jun 2023 17:47:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2E335194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Jun 2023 17:47:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0D30B40CFD09; Thu,  1 Jun 2023 17:47:24 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DD36640CFD08;
 Thu,  1 Jun 2023 17:47:23 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 351HlLXT023775;
 Thu, 1 Jun 2023 12:47:21 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 351HlLZB023774;
 Thu, 1 Jun 2023 12:47:21 -0500
Date: Thu, 1 Jun 2023 12:47:20 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20230601174720.GM24096@octiron.msp.redhat.com>
References: <1684537332-23033-1-git-send-email-bmarzins@redhat.com>
 <1684537332-23033-2-git-send-email-bmarzins@redhat.com>
 <c4e9f110538008c2e9e70fe06ae15a08fe7c4d97.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <c4e9f110538008c2e9e70fe06ae15a08fe7c4d97.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 1/5] libmultipath: add group_by_tpg
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, May 31, 2023 at 03:19:55PM +0000, Martin Wilck wrote:
> On Fri, 2023-05-19 at 18:02 -0500, Benjamin Marzinski wrote:
> > When we group paths by prio and the priority changes, paths can end
> > up
> > temporarily in the wrong path groups.=A0 This usually happens when some
> > paths are down, so their priority can't be updated. To avoid this for
> > ALUA paths, group them by their target port group instead. The path
> > groups chosen by this policy won't always match with those chosen by
> > group_by_prio, since it is possible for multiple ALUA target port
> > groups to have the same priority.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > =A0libmultipath/discovery.c=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> > =A0libmultipath/pgpolicies.c=A0=A0=A0=A0=A0=A0=A0 | 19 ++++++++++++++++=
+++
> > =A0libmultipath/pgpolicies.h=A0=A0=A0=A0=A0=A0=A0 |=A0 4 +++-
> > =A0libmultipath/prioritizers/alua.c |=A0 1 +
> > =A0libmultipath/propsel.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 27 ++++++++++=
+++++++++++++++--
> > =A0libmultipath/structs.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> > =A0libmultipath/structs.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 3 +++
> > =A0multipath/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=
=A0 1 +
> > =A0multipath/multipath.conf.5=A0=A0=A0=A0=A0=A0 |=A0 4 ++++
> > =A09 files changed, 58 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> > index 6865cd92..2dcafe5d 100644
> > --- a/libmultipath/discovery.c
> > +++ b/libmultipath/discovery.c
> > @@ -1051,6 +1051,7 @@ detect_alua(struct path * pp)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0pp->tpgs =3D tpgs;
> > +=A0=A0=A0=A0=A0=A0=A0pp->tpg_id =3D ret;
> > =A0}
> > =A0
> > =A0int path_get_tpgs(struct path *pp)
> > diff --git a/libmultipath/pgpolicies.c b/libmultipath/pgpolicies.c
> > index 10b44d37..e14da8cc 100644
> > --- a/libmultipath/pgpolicies.c
> > +++ b/libmultipath/pgpolicies.c
> > @@ -25,6 +25,8 @@ int get_pgpolicy_id(char * str)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return GROUP_BY_PRIO;
> > =A0=A0=A0=A0=A0=A0=A0=A0if (0 =3D=3D strncmp(str, "group_by_node_name",=
 18))
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return GROUP_BY_NODE_NA=
ME;
> > +=A0=A0=A0=A0=A0=A0=A0if (0 =3D=3D strncmp(str, "group_by_tpg", 12))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return GROUP_BY_TPG;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0return IOPOLICY_UNDEF;
> > =A0}
> > @@ -49,6 +51,9 @@ int get_pgpolicy_name(char * buff, int len, int id)
> > =A0=A0=A0=A0=A0=A0=A0=A0case GROUP_BY_NODE_NAME:
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s =3D "group_by_node_na=
me";
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> > +=A0=A0=A0=A0=A0=A0=A0case GROUP_BY_TPG:
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s =3D "group_by_tpg";
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> > =A0=A0=A0=A0=A0=A0=A0=A0default:
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s =3D "undefined";
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> > @@ -191,6 +196,12 @@ prios_match(struct path *pp1, struct path *pp2)
> > =A0=A0=A0=A0=A0=A0=A0=A0return (pp1->priority =3D=3D pp2->priority);
> > =A0}
> > =A0
> > +bool
> > +tpg_match(struct path *pp1, struct path *pp2)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0return (pp1->tpg_id =3D=3D pp2->tpg_id);
> > +}
> > +
> > =A0int group_by_match(struct multipath * mp, vector paths,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool (*path_matc=
h_fn)(struct path *, struct path
> > *))
> > =A0{
> > @@ -279,6 +290,14 @@ int group_by_prio(struct multipath *mp, vector
> > paths)
> > =A0=A0=A0=A0=A0=A0=A0=A0return group_by_match(mp, paths, prios_match);
> > =A0}
> > =A0
> > +/*
> > + * One path group per alua target port group present in the path
> > vector
> > + */
> > +int group_by_tpg(struct multipath *mp, vector paths)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0return group_by_match(mp, paths, tpg_match);
> > +}
> > +
> > =A0int one_path_per_group(struct multipath *mp, vector paths)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0int i;
> > diff --git a/libmultipath/pgpolicies.h b/libmultipath/pgpolicies.h
> > index 15927610..d3ab2f35 100644
> > --- a/libmultipath/pgpolicies.h
> > +++ b/libmultipath/pgpolicies.h
> > @@ -16,7 +16,8 @@ enum iopolicies {
> > =A0=A0=A0=A0=A0=A0=A0=A0MULTIBUS,
> > =A0=A0=A0=A0=A0=A0=A0=A0GROUP_BY_SERIAL,
> > =A0=A0=A0=A0=A0=A0=A0=A0GROUP_BY_PRIO,
> > -=A0=A0=A0=A0=A0=A0=A0GROUP_BY_NODE_NAME
> > +=A0=A0=A0=A0=A0=A0=A0GROUP_BY_NODE_NAME,
> > +=A0=A0=A0=A0=A0=A0=A0GROUP_BY_TPG,
> > =A0};
> > =A0
> > =A0int get_pgpolicy_id(char *);
> > @@ -30,5 +31,6 @@ int one_group(struct multipath *, vector);
> > =A0int group_by_serial(struct multipath *, vector);
> > =A0int group_by_prio(struct multipath *, vector);
> > =A0int group_by_node_name(struct multipath *, vector);
> > +int group_by_tpg(struct multipath *, vector);
> > =A0
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
>=20
> In view of the discussion from the cover letter:
>=20
> tpg_id should have already been set by detect_alua(). I'm not sure if
> it's good to overwrite it silently here. Shouldn't we rather check
> if the value is unchanged, or refrain from setting it more than once?

We can certainly log a message here, but like you said in your reply to
my cover letter, it does appear possible the a path can change the
Target Port Group it belongs to.  In this case, we should update the
tpg_id if we notice the change, so the path gets placed in correct
group. With my second patchset, which makes multipath do more to update
the priorities of all the paths in non-group-by-prio setups, this should
mostly keep the paths in the correct pathgroup, if they change TPG.
Obviously the paths that are down won't get updated, but that's no worse
than we have now, and changing TPGs is a corner case.
=20
>=20
> > =A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: reported target port group is %=
i", pp->dev,
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
>=20
> I don't understand this logic. Why don't you simply check pp->tpgs?

The call to verify_alua_prio is because the prio is set per path, and it
is possible that not all paths have the ALUA prioritizer. Regardless of
how that occured (and I admit that it's really only possible due to a
failure while trying to get the tpg), we can't really group the paths by
tpg if not all the paths have it set.

As for why verfy_alua_prio() doesn't check pp->tpgs, there are multiple
cases where a path that is configured with alua can fail detect_prio()
with what appears to be a temporary error. In that case the tpgs will
remain TPGS_UNDEF.  So if pp->tgpgs =3D=3D UNDEF, the code would still need
to check the prio name to see if the path is configured with ALUA. On
the other hand, if we check the prio name first, then that's the
definitive answer, and it doesn't matter if p->tpgs wasn't set yet.
=20
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

