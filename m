Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C35DC433FE
	for <dm-devel@archiver.kernel.org>; Fri, 21 Oct 2022 17:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666374749;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rP0THjkn0E6xFgYJ0CEo+78IWrmxzy4JDeGAcA2EcgU=;
	b=D07s2OFF9JbMUeSjV3lfEvyp/Nu+d7sJyTj3qlR4SC4lmqgHLzV2eZhzHylxYVU2vtS8nY
	/W/7Jdjzn0OTNTrg2g435p1D+VoVQRgoSQQipGX1tPl9WaiXU/NG9TYiVeHpeQTv1ivq9y
	XJwvPUmYp5o8Lor1a/OKbCZ2BnEqCX8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-6SuYwY2sO1G9fUBOAl7VqA-1; Fri, 21 Oct 2022 13:52:25 -0400
X-MC-Unique: 6SuYwY2sO1G9fUBOAl7VqA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70C41827981;
	Fri, 21 Oct 2022 17:52:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5BB691121319;
	Fri, 21 Oct 2022 17:52:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 252B01946587;
	Fri, 21 Oct 2022 17:52:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 179231946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 21 Oct 2022 17:52:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F0AD4C154AB; Fri, 21 Oct 2022 17:52:22 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CB875C15BA5;
 Fri, 21 Oct 2022 17:52:22 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 29LHqLt1025948;
 Fri, 21 Oct 2022 12:52:21 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 29LHqBHW025939;
 Fri, 21 Oct 2022 12:52:11 -0500
Date: Fri, 21 Oct 2022 12:51:51 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20221021175150.GD19568@octiron.msp.redhat.com>
References: <1665525183-27377-1-git-send-email-bmarzins@redhat.com>
 <1665525183-27377-4-git-send-email-bmarzins@redhat.com>
 <306b876895770fc11229ea43418e3766282ee4e5.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <306b876895770fc11229ea43418e3766282ee4e5.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 3/4] libmultipath: use regular array for
 field widths
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 21, 2022 at 07:04:55AM +0000, Martin Wilck wrote:
> On Tue, 2022-10-11 at 16:53 -0500, Benjamin Marzinski wrote:
> > We know the size of these arrays, so we can just allocate them on the
> > stack. Also, show_path() doesn't use the width, so don't initialize
> > it
> > in the first place.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> This isn't wrong, but I'm not sure what it actually achieves except a
> few less NULL checks (I'm sure you're aware that this doesn't mean
> better protection against out-of-memory situations). It comes at the
> cost of an ABI change.=A0I understand that the intention is to eliminate
> __attribute__((cleanup())). But if we agree we don't want to do that
> everywhere, I see no particular reason to do it in this code path.
>=20
> I'm not totally against it, but I'm not enthusiastic, either.

That's fine. How about I send a patch to just fix show_path().

-Ben

>=20
> Regards,
> Martin
>=20
>=20
>=20
> > ---
> > =A0libmultipath/foreign.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 5 ++--
> > =A0libmultipath/libmultipath.version |=A0 4 +--
> > =A0libmultipath/print.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 32 +++=
++++++++-------------
> > =A0libmultipath/print.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 4 +=
--
> > =A0multipath/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
|=A0 5 ++--
> > =A0multipathd/cli_handlers.c=A0=A0=A0=A0=A0=A0=A0=A0 | 41 ++++++++++++-=
----------------
> > --
> > =A06 files changed, 38 insertions(+), 53 deletions(-)
> >=20
> > diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
> > index 8981ff58..4cc2a8e3 100644
> > --- a/libmultipath/foreign.c
> > +++ b/libmultipath/foreign.c
> > @@ -550,10 +550,9 @@ void print_foreign_topology(int verbosity)
> > =A0=A0=A0=A0=A0=A0=A0=A0struct strbuf buf =3D STRBUF_INIT;
> > =A0=A0=A0=A0=A0=A0=A0=A0struct foreign *fgn;
> > =A0=A0=A0=A0=A0=A0=A0=A0int i;
> > -=A0=A0=A0=A0=A0=A0=A0fieldwidth_t *width __attribute__((cleanup(cleanu=
p_ucharp)))
> > =3D NULL;
> > +=A0=A0=A0=A0=A0=A0=A0fieldwidth_t width[path_layout_size()];
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0if ((width =3D alloc_path_layout()) =3D=3D NULL)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> > +=A0=A0=A0=A0=A0=A0=A0memset(width, 0, sizeof(width));
> > =A0=A0=A0=A0=A0=A0=A0=A0rdlock_foreigns();
> > =A0=A0=A0=A0=A0=A0=A0=A0if (foreigns =3D=3D NULL) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0unlock_foreigns(NULL);
> > diff --git a/libmultipath/libmultipath.version
> > b/libmultipath/libmultipath.version
> > index 8a447f7f..af7c5ed2 100644
> > --- a/libmultipath/libmultipath.version
> > +++ b/libmultipath/libmultipath.version
> > @@ -38,9 +38,7 @@ global:
> > =A0=A0=A0=A0=A0=A0=A0=A0add_map_with_path;
> > =A0=A0=A0=A0=A0=A0=A0=A0adopt_paths;
> > =A0=A0=A0=A0=A0=A0=A0=A0alloc_multipath;
> > -=A0=A0=A0=A0=A0=A0=A0alloc_multipath_layout;
> > =A0=A0=A0=A0=A0=A0=A0=A0alloc_path;
> > -=A0=A0=A0=A0=A0=A0=A0alloc_path_layout;
> > =A0=A0=A0=A0=A0=A0=A0=A0alloc_path_with_pathinfo;
> > =A0=A0=A0=A0=A0=A0=A0=A0change_foreign;
> > =A0=A0=A0=A0=A0=A0=A0=A0check_alias_settings;
> > @@ -126,6 +124,7 @@ global:
> > =A0=A0=A0=A0=A0=A0=A0=A0libmultipath_exit;
> > =A0=A0=A0=A0=A0=A0=A0=A0libmultipath_init;
> > =A0=A0=A0=A0=A0=A0=A0=A0load_config;
> > +=A0=A0=A0=A0=A0=A0=A0multipath_layout_size;
> > =A0=A0=A0=A0=A0=A0=A0=A0need_io_err_check;
> > =A0=A0=A0=A0=A0=A0=A0=A0orphan_path;
> > =A0=A0=A0=A0=A0=A0=A0=A0parse_prkey_flags;
> > @@ -133,6 +132,7 @@ global:
> > =A0=A0=A0=A0=A0=A0=A0=A0path_discovery;
> > =A0=A0=A0=A0=A0=A0=A0=A0path_get_tpgs;
> > =A0=A0=A0=A0=A0=A0=A0=A0pathinfo;
> > +=A0=A0=A0=A0=A0=A0=A0path_layout_size;
> > =A0=A0=A0=A0=A0=A0=A0=A0path_offline;
> > =A0=A0=A0=A0=A0=A0=A0=A0print_all_paths;
> > =A0=A0=A0=A0=A0=A0=A0=A0print_foreign_topology;
> > diff --git a/libmultipath/print.c b/libmultipath/print.c
> > index 97f9a177..87d6a329 100644
> > --- a/libmultipath/print.c
> > +++ b/libmultipath/print.c
> > @@ -805,6 +805,12 @@ static const struct multipath_data mpd[] =3D {
> > =A0=A0=A0=A0=A0=A0=A0=A0{'g', "vpd page data", snprint_multipath_vpd_da=
ta},
> > =A0};
> > =A0
> > +
> > +int multipath_layout_size(void)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0return ARRAY_SIZE(mpd);
> > +}
> > +
> > =A0static const struct path_data pd[] =3D {
> > =A0=A0=A0=A0=A0=A0=A0=A0{'w', "uuid",=A0=A0=A0=A0=A0=A0=A0=A0=A0 snprin=
t_path_uuid},
> > =A0=A0=A0=A0=A0=A0=A0=A0{'i', "hcil",=A0=A0=A0=A0=A0=A0=A0=A0=A0 snprin=
t_hcil},
> > @@ -834,6 +840,11 @@ static const struct path_data pd[] =3D {
> > =A0=A0=A0=A0=A0=A0=A0=A0{'L', "LUN hex",=A0=A0=A0=A0=A0=A0 snprint_path=
_lunhex},
> > =A0};
> > =A0
> > +int path_layout_size(void)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0return ARRAY_SIZE(pd);
> > +}
> > +
> > =A0static const struct pathgroup_data pgd[] =3D {
> > =A0=A0=A0=A0=A0=A0=A0=A0{'s', "selector",=A0=A0=A0=A0=A0 snprint_pg_sel=
ector},
> > =A0=A0=A0=A0=A0=A0=A0=A0{'p', "pri",=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 snpr=
int_pg_pri},
> > @@ -871,10 +882,6 @@ int snprint_wildcards(struct strbuf *buff)
> > =A0=A0=A0=A0=A0=A0=A0=A0return get_strbuf_len(buff) - initial_len;
> > =A0}
> > =A0
> > -fieldwidth_t *alloc_path_layout(void) {
> > -=A0=A0=A0=A0=A0=A0=A0return calloc(ARRAY_SIZE(pd), sizeof(fieldwidth_t=
));
> > -}
> > -
> > =A0void get_path_layout(vector pathvec, int header, fieldwidth_t
> > *width)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0vector gpvec =3D vector_convert(NULL, pathvec, =
struct path,
> > @@ -929,11 +936,6 @@ void _get_path_layout (const struct _vector
> > *gpvec, enum layout_reset reset,
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0}
> > =A0
> > -fieldwidth_t *alloc_multipath_layout(void) {
> > -
> > -=A0=A0=A0=A0=A0=A0=A0return calloc(ARRAY_SIZE(mpd), sizeof(fieldwidth_=
t));
> > -}
> > -
> > =A0void get_multipath_layout (vector mpvec, int header, fieldwidth_t
> > *width) {
> > =A0=A0=A0=A0=A0=A0=A0=A0vector gmvec =3D vector_convert(NULL, mpvec, st=
ruct multipath,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dm_multipath_to_gen);
> > @@ -1187,12 +1189,11 @@ int _snprint_pathgroup(const struct
> > gen_pathgroup *ggp, struct strbuf *line,
> > =A0void _print_multipath_topology(const struct gen_multipath *gmp, int
> > verbosity)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0struct strbuf buff =3D STRBUF_INIT;
> > -=A0=A0=A0=A0=A0=A0=A0fieldwidth_t *p_width
> > __attribute__((cleanup(cleanup_ucharp))) =3D NULL;
> > +=A0=A0=A0=A0=A0=A0=A0fieldwidth_t p_width[ARRAY_SIZE(pd)] =3D {0};
> > =A0=A0=A0=A0=A0=A0=A0=A0const struct gen_pathgroup *gpg;
> > =A0=A0=A0=A0=A0=A0=A0=A0const struct _vector *pgvec, *pathvec;
> > =A0=A0=A0=A0=A0=A0=A0=A0int j;
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0p_width =3D alloc_path_layout();
> > =A0=A0=A0=A0=A0=A0=A0=A0pgvec =3D gmp->ops->get_pathgroups(gmp);
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0if (pgvec !=3D NULL) {
> > @@ -1236,14 +1237,11 @@ int _snprint_multipath_topology(const struct
> > gen_multipath *gmp,
> > =A0=A0=A0=A0=A0=A0=A0=A0const struct gen_pathgroup *gpg;
> > =A0=A0=A0=A0=A0=A0=A0=A0struct strbuf style =3D STRBUF_INIT;
> > =A0=A0=A0=A0=A0=A0=A0=A0size_t initial_len =3D get_strbuf_len(buff);
> > -=A0=A0=A0=A0=A0=A0=A0fieldwidth_t *width __attribute__((cleanup(cleanu=
p_ucharp)))
> > =3D NULL;
> > +=A0=A0=A0=A0=A0=A0=A0fieldwidth_t width[ARRAY_SIZE(mpd)] =3D {0};
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0if (verbosity <=3D 0)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0if ((width =3D alloc_multipath_layout()) =3D=3D N=
ULL)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -ENOMEM;
> > -
> > =A0=A0=A0=A0=A0=A0=A0=A0if (verbosity =3D=3D 1)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return _snprint_multipa=
th(gmp, buff, "%n", width);
> > =A0
> > @@ -2027,7 +2025,7 @@ static void print_all_paths_custo(vector
> > pathvec, int banner, const char *fmt)
> > =A0=A0=A0=A0=A0=A0=A0=A0int i;
> > =A0=A0=A0=A0=A0=A0=A0=A0struct path * pp;
> > =A0=A0=A0=A0=A0=A0=A0=A0struct strbuf line =3D STRBUF_INIT;
> > -=A0=A0=A0=A0=A0=A0=A0fieldwidth_t *width __attribute__((cleanup(cleanu=
p_ucharp)))
> > =3D NULL;
> > +=A0=A0=A0=A0=A0=A0=A0fieldwidth_t width[ARRAY_SIZE(pd)] =3D {0};
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0if (!VECTOR_SIZE(pathvec)) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (banner)
> > @@ -2035,8 +2033,6 @@ static void print_all_paths_custo(vector
> > pathvec, int banner, const char *fmt)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0if ((width =3D alloc_path_layout()) =3D=3D NULL)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> > =A0=A0=A0=A0=A0=A0=A0=A0get_path_layout(pathvec, 1, width);
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push_cast(reset_strbuf, &line);
> > diff --git a/libmultipath/print.h b/libmultipath/print.h
> > index 52f5b256..4e50827d 100644
> > --- a/libmultipath/print.h
> > +++ b/libmultipath/print.h
> > @@ -16,11 +16,11 @@ enum layout_reset {
> > =A0};
> > =A0
> > =A0/* fieldwidth_t is defined in generic.h */
> > -fieldwidth_t *alloc_path_layout(void);
> > +int multipath_layout_size(void);
> > +int path_layout_size(void);
> > =A0void _get_path_layout (const struct _vector *gpvec, enum
> > layout_reset,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fiel=
dwidth_t *width);
> > =A0void get_path_layout (vector pathvec, int header, fieldwidth_t
> > *width);
> > -fieldwidth_t *alloc_multipath_layout(void);
> > =A0void _get_multipath_layout (const struct _vector *gmvec, enum
> > layout_reset,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 fieldwidth_t *width);
> > =A0void get_multipath_layout (vector mpvec, int header, fieldwidth_t
> > *width);
> > diff --git a/multipath/main.c b/multipath/main.c
> > index 7b69a3ce..f4c85409 100644
> > --- a/multipath/main.c
> > +++ b/multipath/main.c
> > @@ -457,7 +457,7 @@ configure (struct config *conf, enum mpath_cmds
> > cmd,
> > =A0=A0=A0=A0=A0=A0=A0=A0int di_flag =3D 0;
> > =A0=A0=A0=A0=A0=A0=A0=A0char * refwwid =3D NULL;
> > =A0=A0=A0=A0=A0=A0=A0=A0char * dev =3D NULL;
> > -=A0=A0=A0=A0=A0=A0=A0fieldwidth_t *width __attribute__((cleanup(cleanu=
p_ucharp)))
> > =3D NULL;
> > +=A0=A0=A0=A0=A0=A0=A0fieldwidth_t width[path_layout_size()];
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0/*
> > =A0=A0=A0=A0=A0=A0=A0=A0 * allocate core vectors to store paths and mul=
tipaths
> > @@ -544,8 +544,7 @@ configure (struct config *conf, enum mpath_cmds
> > cmd,
> > =A0=A0=A0=A0=A0=A0=A0=A0if (libmp_verbosity > 2)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0print_all_paths(pathvec=
, 1);
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0if ((width =3D alloc_path_layout()) =3D=3D NULL)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> > +=A0=A0=A0=A0=A0=A0=A0memset(width, 0, sizeof(width));
> > =A0=A0=A0=A0=A0=A0=A0=A0get_path_layout(pathvec, 0, width);
> > =A0=A0=A0=A0=A0=A0=A0=A0foreign_path_layout(width);
> > =A0
> > diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> > index 5b8f647b..ddc807a1 100644
> > --- a/multipathd/cli_handlers.c
> > +++ b/multipathd/cli_handlers.c
> > @@ -38,11 +38,10 @@ show_paths (struct strbuf *reply, struct vectors
> > *vecs, char *style, int pretty)
> > =A0=A0=A0=A0=A0=A0=A0=A0int i;
> > =A0=A0=A0=A0=A0=A0=A0=A0struct path * pp;
> > =A0=A0=A0=A0=A0=A0=A0=A0int hdr_len =3D 0;
> > -=A0=A0=A0=A0=A0=A0=A0fieldwidth_t *width __attribute__((cleanup(cleanu=
p_ucharp)))
> > =3D NULL;
> > +=A0=A0=A0=A0=A0=A0=A0fieldwidth_t width[path_layout_size()];
> > =A0
> > +=A0=A0=A0=A0=A0=A0=A0memset(width, 0, sizeof(width));
> > =A0=A0=A0=A0=A0=A0=A0=A0if (pretty) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if ((width =3D alloc_path=
_layout()) =3D=3D NULL)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn 1;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0get_path_layout(vecs->p=
athvec, 1, width);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0foreign_path_layout(wid=
th);
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > @@ -50,10 +49,10 @@ show_paths (struct strbuf *reply, struct vectors
> > *vecs, char *style, int pretty)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(vecs->pathvec, pp, i) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (snprint_path(reply, s=
tyle, pp, width) < 0)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (snprint_path(reply, s=
tyle, pp, pretty? width :
> > NULL) < 0)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0return 1;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > -=A0=A0=A0=A0=A0=A0=A0if (snprint_foreign_paths(reply, style, width) < =
0)
> > +=A0=A0=A0=A0=A0=A0=A0if (snprint_foreign_paths(reply, style, pretty? w=
idth : NULL)
> > < 0)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0if (pretty && get_strbuf_len(reply) =3D=3D (siz=
e_t)hdr_len)
> > @@ -67,12 +66,7 @@ static int
> > =A0show_path (struct strbuf *reply, struct vectors *vecs, struct path
> > *pp,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 char *style)
> > =A0{
> > -=A0=A0=A0=A0=A0=A0=A0fieldwidth_t *width __attribute__((cleanup(cleanu=
p_ucharp)))
> > =3D NULL;
> > -
> > -=A0=A0=A0=A0=A0=A0=A0if ((width =3D alloc_path_layout()) =3D=3D NULL)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > -=A0=A0=A0=A0=A0=A0=A0get_path_layout(vecs->pathvec, 1, width);
> > -=A0=A0=A0=A0=A0=A0=A0if (snprint_path(reply, style, pp, 0) < 0)
> > +=A0=A0=A0=A0=A0=A0=A0if (snprint_path(reply, style, pp, NULL) < 0)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0}
> > @@ -95,10 +89,9 @@ show_maps_topology (struct strbuf *reply, struct
> > vectors * vecs)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0int i;
> > =A0=A0=A0=A0=A0=A0=A0=A0struct multipath * mpp;
> > -=A0=A0=A0=A0=A0=A0=A0fieldwidth_t *p_width
> > __attribute__((cleanup(cleanup_ucharp))) =3D NULL;
> > +=A0=A0=A0=A0=A0=A0=A0fieldwidth_t p_width[path_layout_size()];
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0if ((p_width =3D alloc_path_layout()) =3D=3D NULL=
)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > +=A0=A0=A0=A0=A0=A0=A0memset(p_width, 0, sizeof(p_width));
> > =A0=A0=A0=A0=A0=A0=A0=A0get_path_layout(vecs->pathvec, 0, p_width);
> > =A0=A0=A0=A0=A0=A0=A0=A0foreign_path_layout(p_width);
> > =A0
> > @@ -258,10 +251,9 @@ cli_list_map_topology (void *v, struct strbuf
> > *reply, void *data)
> > =A0=A0=A0=A0=A0=A0=A0=A0struct multipath * mpp;
> > =A0=A0=A0=A0=A0=A0=A0=A0struct vectors * vecs =3D (struct vectors *)dat=
a;
> > =A0=A0=A0=A0=A0=A0=A0=A0char * param =3D get_keyparam(v, MAP);
> > -=A0=A0=A0=A0=A0=A0=A0fieldwidth_t *p_width
> > __attribute__((cleanup(cleanup_ucharp))) =3D NULL;
> > +=A0=A0=A0=A0=A0=A0=A0fieldwidth_t p_width[path_layout_size()];
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0if ((p_width =3D alloc_path_layout()) =3D=3D NULL=
)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > +=A0=A0=A0=A0=A0=A0=A0memset(p_width, 0, sizeof(p_width));
> > =A0=A0=A0=A0=A0=A0=A0=A0get_path_layout(vecs->pathvec, 0, p_width);
> > =A0=A0=A0=A0=A0=A0=A0=A0param =3D convert_dev(param, 0);
> > =A0=A0=A0=A0=A0=A0=A0=A0mpp =3D find_mp_by_str(vecs->mpvec, param);
> > @@ -357,11 +349,10 @@ show_maps (struct strbuf *reply, struct vectors
> > *vecs, char *style,
> > =A0=A0=A0=A0=A0=A0=A0=A0int i;
> > =A0=A0=A0=A0=A0=A0=A0=A0struct multipath * mpp;
> > =A0=A0=A0=A0=A0=A0=A0=A0int hdr_len =3D 0;
> > -=A0=A0=A0=A0=A0=A0=A0fieldwidth_t *width __attribute__((cleanup(cleanu=
p_ucharp)))
> > =3D NULL;
> > +=A0=A0=A0=A0=A0=A0=A0fieldwidth_t width[multipath_layout_size()];
> > =A0
> > +=A0=A0=A0=A0=A0=A0=A0memset(width, 0, sizeof(width));
> > =A0=A0=A0=A0=A0=A0=A0=A0if (pretty) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if ((width =3D alloc_mult=
ipath_layout()) =3D=3D NULL)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn 1;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0get_multipath_layout(ve=
cs->mpvec, 1, width);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0foreign_multipath_layou=
t(width);
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > @@ -374,10 +365,11 @@ show_maps (struct strbuf *reply, struct vectors
> > *vecs, char *style,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0i--;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0continue;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (snprint_multipath(rep=
ly, style, mpp, width) < 0)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (snprint_multipath(rep=
ly, style, mpp,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pretty? width : NULL) < 0)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0return 1;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > -=A0=A0=A0=A0=A0=A0=A0if (snprint_foreign_multipaths(reply, style, widt=
h) < 0)
> > +=A0=A0=A0=A0=A0=A0=A0if (snprint_foreign_multipaths(reply, style, pret=
ty? width :
> > NULL) < 0)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0if (pretty && get_strbuf_len(reply) =3D=3D (siz=
e_t)hdr_len)
> > @@ -416,10 +408,9 @@ cli_list_map_fmt (void *v, struct strbuf *reply,
> > void *data)
> > =A0=A0=A0=A0=A0=A0=A0=A0struct vectors * vecs =3D (struct vectors *)dat=
a;
> > =A0=A0=A0=A0=A0=A0=A0=A0char * param =3D get_keyparam(v, MAP);
> > =A0=A0=A0=A0=A0=A0=A0=A0char * fmt =3D get_keyparam(v, FMT);
> > -=A0=A0=A0=A0=A0=A0=A0fieldwidth_t *width __attribute__((cleanup(cleanu=
p_ucharp)))
> > =3D NULL;
> > +=A0=A0=A0=A0=A0=A0=A0fieldwidth_t width[multipath_layout_size()];
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0if ((width =3D alloc_multipath_layout()) =3D=3D N=
ULL)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > +=A0=A0=A0=A0=A0=A0=A0memset(width, 0, sizeof(width));
> > =A0=A0=A0=A0=A0=A0=A0=A0get_multipath_layout(vecs->mpvec, 1, width);
> > =A0=A0=A0=A0=A0=A0=A0=A0param =3D convert_dev(param, 0);
> > =A0=A0=A0=A0=A0=A0=A0=A0mpp =3D find_mp_by_str(vecs->mpvec, param);
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

