Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6917CEE14DB
	for <dm-devel@archiver.kernel.org>; Thu,  7 Sep 2023 10:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694082671;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4EoZ0ophxB8ETTtuwMBe6ZNAOwVCgPITAoPV6/OoFeU=;
	b=cn4aei0DSZhmAUl2qk5UrRTX8JAzwlRHTo+7x9/HYWps2y3w7Rjn707ShljN61I6IVbYnV
	uGqjtRVTaa3wocPEYeUvedQ7oEJ5NSkvTiaapuOamlKt7OkXV84EjGyM/mJATWUwue37xJ
	WXXuCUWypDKfjiyqY62ZyX19pmmA3gY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-gQBCDkxPOImnQe_SG5NeJw-1; Thu, 07 Sep 2023 06:31:08 -0400
X-MC-Unique: gQBCDkxPOImnQe_SG5NeJw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 80EC83C11A07;
	Thu,  7 Sep 2023 10:31:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1449C2026D76;
	Thu,  7 Sep 2023 10:31:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B4E7C194658F;
	Thu,  7 Sep 2023 10:31:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 963F8194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Sep 2023 10:30:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 88164493112; Thu,  7 Sep 2023 10:30:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 80692493110
 for <dm-devel@redhat.com>; Thu,  7 Sep 2023 10:30:59 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57608823D5E
 for <dm-devel@redhat.com>; Thu,  7 Sep 2023 10:30:59 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-63-UaCf2L71MjC2t1PSrtI6FQ-1; Thu,
 07 Sep 2023 06:30:55 -0400
X-MC-Unique: UaCf2L71MjC2t1PSrtI6FQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 1957B21863;
 Thu,  7 Sep 2023 10:30:54 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E241D138FA;
 Thu,  7 Sep 2023 10:30:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id p7VeNV2m+WS6WgAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 07 Sep 2023 10:30:53 +0000
Message-ID: <5cef84987794cc449028055a63c522c1ea690738.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 07 Sep 2023 12:30:53 +0200
In-Reply-To: <20230906224708.GC7412@octiron.msp.redhat.com>
References: <20230901180235.23980-1-mwilck@suse.com>
 <20230901180235.23980-19-mwilck@suse.com>
 <20230906224708.GC7412@octiron.msp.redhat.com>
User-Agent: Evolution 3.48.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 18/21] libmultipath: keep bindings in memory
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2023-09-06 at 17:47 -0500, Benjamin Marzinski wrote:
> On Fri, Sep 01, 2023 at 08:02:31PM +0200, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > Rather than opening the bindings file every time we must retrieve
> > a binding, keep the contents in memory and write the file only
> > if additions have been made. This simplifies the code, and should
> > speed up
> > alias lookups significantly. As a side effect, the aliases will be
> > stored
> > sorted by alias, which changes the way aliases are allocated if
> > there are
> > unused "holes" in the sequence of aliases. For example, if the
> > bindings file
> > contains mpathb, mpathy, and mpatha, in this order, the next new
> > alias used to
> > be mpathz and is now mpathc.
> >=20
> > Another side effect is that multipathd will not automatically pick
> > up changes
> > to the bindings file at runtime without a reconfigure operation. It
> > is
> > questionable whether these on-the-fly changes were a good idea in
> > the first
> > place, as inconsistent configurations may easily come to pass. It
> > desired,
> > it would be feasible to implement automatic update of the bindings
> > using the
> > existing inotify approach.
>=20
> I'm not so much worried about someone manually changing the bindings
> file outside of multipath. But it is possible for multipathd to miss
> changes made by the multipath command.=A0 For instance, say that
> someone
> has find_multipaths set to "yes" and adds a new device, but only a
> single path comes up.=A0 They know there will be more paths later, so
> they
> run
>=20
> # multipath <new_path_dev>
>=20
> to create a multipath device for this.=A0 Multipathd won't pick up this
> new binding. If, for some reason the path goes away, and comes back
> later, it will now be in the bindings file, but multipathd will still
> have no record of the correct binding for it, which already exists in
> the bindings file. I don't know if this needs something as complex as
> inotify to handle.=A0 We could just record the mtime of the bindings
> file
> when we read it.=A0 If it has changed when we call
> get_user_friendly_alias() or get_user_friendly_wwid() we would call
> check_alias_settings().
>=20
> additional comments below.=20
> > The new implementation of get_user_friendly_alias() is slightly
> > different
> > than before. The logic is summarized in a comment in the code. Unit
> > tests
> > will be provided that illustrate the changes.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =A0libmultipath/alias.c=A0=A0=A0=A0 | 369 ++++++++++++++++-------------=
------
> > ----
> > =A0libmultipath/alias.h=A0=A0=A0=A0 |=A0=A0 2 +-
> > =A0libmultipath/configure.c |=A0=A0 3 +-
> > =A03 files changed, 157 insertions(+), 217 deletions(-)
> >=20
> > diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> > index 2f9bc82..6003df0 100644
> > --- a/libmultipath/alias.c
> > +++ b/libmultipath/alias.c
> > @@ -50,8 +50,6 @@
> > =A0"# alias wwid\n" \
> > =A0"#\n"
> > =A0
> > -static const char bindings_file_header[] =3D BINDINGS_FILE_HEADER;
> > -
> > =A0struct binding {
> > =A0=A0=A0=A0=A0=A0=A0=A0char *alias;
> > =A0=A0=A0=A0=A0=A0=A0=A0char *wwid;
> > @@ -80,6 +78,45 @@ static void _free_binding(struct binding *bdg)
> > =A0=A0=A0=A0=A0=A0=A0=A0free(bdg);
> > =A0}
> > =A0
> > +static const struct binding *get_binding_for_alias(const Bindings
> > *bindings,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 const char
> > *alias)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0const struct binding *bdg;
> > +=A0=A0=A0=A0=A0=A0=A0int i;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (!alias)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return NULL;
> > +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(bindings, bdg, i) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!strncmp(bdg->alias, =
alias, WWID_SIZE)) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(3, "Found matching alias [%s] in
> > bindings file."
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0" Setting wwid to %s", alias, bdg-
> > >wwid);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn bdg;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +
> > +=A0=A0=A0=A0=A0=A0=A0condlog(3, "No matching alias [%s] in bindings fi=
le.",
> > alias);
> > +=A0=A0=A0=A0=A0=A0=A0return NULL;
> > +}
> > +
> > +static const struct binding *get_binding_for_wwid(const Bindings
> > *bindings,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 const char *wwid)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0const struct binding *bdg;
> > +=A0=A0=A0=A0=A0=A0=A0int i;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (!wwid)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return NULL;
> > +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(bindings, bdg, i) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!strncmp(bdg->wwid, w=
wid, WWID_SIZE)) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(3, "Found matching wwid [%s] in
> > bindings file."
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0" Setting alias to %s", wwid, bdg-
> > >alias);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn bdg;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0condlog(3, "No matching wwid [%s] in bindings fil=
e.",
> > wwid);
> > +=A0=A0=A0=A0=A0=A0=A0return NULL;
> > +}
> > +
> > =A0static int add_binding(Bindings *bindings, const char *alias,
> > const char *wwid)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0struct binding *bdg;
> > @@ -115,6 +152,24 @@ static int add_binding(Bindings *bindings,
> > const char *alias, const char *wwid)
> > =A0=A0=A0=A0=A0=A0=A0=A0return BINDING_ERROR;
> > =A0}
> > =A0
> > +static int delete_binding(Bindings *bindings, const char *wwid)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0struct binding *bdg;
> > +=A0=A0=A0=A0=A0=A0=A0int i;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(bindings, bdg, i) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!strncmp(bdg->wwid, w=
wid, WWID_SIZE)) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0_=
free_binding(bdg);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0b=
reak;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0if (i >=3D VECTOR_SIZE(bindings))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return BINDING_NOTFOUND;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0vector_del_slot(bindings, i);
> > +=A0=A0=A0=A0=A0=A0=A0return BINDING_DELETED;
> > +}
> > +
> > =A0static int write_bindings_file(const Bindings *bindings, int fd)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0struct binding *bnd;
> > @@ -267,38 +322,15 @@ static bool id_already_taken(int id, const
> > char *prefix, const char *map_wwid)
> > =A0=A0=A0=A0=A0=A0=A0=A0return alias_already_taken(alias, map_wwid);
> > =A0}
> > =A0
> > -/*
> > - * Returns: 0=A0=A0 if matching entry in WWIDs file found
> > - *=A0=A0=A0=A0=A0=A0=A0=A0 -1=A0=A0 if an error occurs
> > - *=A0=A0=A0=A0=A0=A0=A0=A0 >0=A0=A0 a free ID that could be used for t=
he WWID at hand
> > - * *map_alias is set to a freshly allocated string with the
> > matching alias if
> > - * the function returns 0, or to NULL otherwise.
> > - */
> > -static int
> > -lookup_binding(FILE *f, const char *map_wwid, char **map_alias,
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 const char *prefix, int check_=
if_taken)
> > +int get_free_id(const Bindings *bindings, const char *prefix,
> > const char *map_wwid)
> > =A0{
> > -=A0=A0=A0=A0=A0=A0=A0char buf[LINE_MAX];
> > -=A0=A0=A0=A0=A0=A0=A0unsigned int line_nr =3D 0;
> > -=A0=A0=A0=A0=A0=A0=A0int id =3D 1;
> > +=A0=A0=A0=A0=A0=A0=A0const struct binding *bdg;
> > +=A0=A0=A0=A0=A0=A0=A0int i, id =3D 1;
> > =A0=A0=A0=A0=A0=A0=A0=A0int biggest_id =3D 1;
> > =A0=A0=A0=A0=A0=A0=A0=A0int smallest_bigger_id =3D INT_MAX;
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0*map_alias =3D NULL;
> > -
> > -=A0=A0=A0=A0=A0=A0=A0rewind(f);
> > -=A0=A0=A0=A0=A0=A0=A0while (fgets(buf, LINE_MAX, f)) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0const char *alias, *wwid;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0char *c, *saveptr;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0int curr_id;
> > -
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0line_nr++;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c =3D strpbrk(buf, "#\n\r=
");
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (c)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*=
c =3D '\0';
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0alias =3D strtok_r(buf, "=
 \t", &saveptr);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!alias) /* blank line=
 */
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ontinue;
> > +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(bindings, bdg, i) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0int curr_id =3D scan_devn=
ame(bdg->alias, prefix);
>=20
> If we know that the bindings will be sorted by alias order, we don't
> need to do all this. Something like this should work:

That's true. Unfortunately, we can't ensure ordering "by alias order".
The reason is that our configuration allows using different alias
prefixes for different devices. The current sorting is simply
alphabetical. It detects duplicates, but it ensures "alias order" only
between "mpatha" and "mpathz".

I've thought of just removing the "different aliases for different
devices" feature. I don't know if any users out there actually set
device-specific alias_prefix values in the devices section of
multipath.conf. I don't recall having seen such a configuration so far;
almost every config I have seen simply uses "mpath" everywhere. But I
recognize that it may feel tempting in some cases. One could use the
"NETAPP" prefix for some arrays and the "EMC" prefix for others, for
example, making it easier to see which is what. And we simply don't
know if we'd break existing user setups with such a change. So if at
all, we can't do it in a minor release without deprecating it first.

When we add a binding in add_binding(), we don't know which
alias_prefix is configured for a given WWID, and we have no easy way to
figure it out. We know the alias, but we don't know which portion of it
is the prefix and which is the ID (it's not forbidden to use "aaaa" as
alias_prefix). I wouldn't want to start guessing.

If you can think of a way to keep the bindings cleanly sorted, please
let me know.

>=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (curr_id <=3D 0)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ontinue;
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0while (id < curr_id) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (!id_already_taken(id, prefix, map_wwid))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0return id;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
d++;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (id =3D=3D INT_MAX)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0b=
reak;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0id++;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0if (id =3D=3D INT_MAX)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "no more avail=
able user_friendly_names");
> =A0=A0=A0=A0=A0=A0=A0=A0return id < INT_MAX ? id : -1;
> }
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Find an unused index=
 - explanation of the
> > algorithm
> > @@ -333,8 +365,6 @@ lookup_binding(FILE *f, const char *map_wwid,
> > char **map_alias,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * biggest_id is always=
 > smallest_bigger_id,
> > except in the
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * "perfectly ordered" =
case.
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> > -
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0curr_id =3D scan_devname(=
alias, prefix);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (curr_id =3D=3D id) =
{
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (id < INT_MAX)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0id++;
> > @@ -345,36 +375,15 @@ lookup_binding(FILE *f, const char *map_wwid,
> > char **map_alias,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (curr_id > biggest_i=
d)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0biggest_id =3D curr_id;
> > +
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (curr_id > id && cur=
r_id < smallest_bigger_id)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0smallest_bigger_id =3D curr_id;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0wwid =3D strtok_r(NULL, "=
 \t", &saveptr);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!wwid){
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(3,
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0"Ignoring malformed line %u in
> > bindings file",
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0line_nr);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ontinue;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (strcmp(wwid, map_wwid=
) =3D=3D 0){
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(3, "Found matching wwid [%s] in
> > bindings file."
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0" Setting alias to %s", wwid,
> > alias);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*=
map_alias =3D strdup(alias);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (*map_alias =3D=3D NULL) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "Cannot copy alias from
> > bindings "
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"file: out of memory");
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0return -1;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn 0;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > -=A0=A0=A0=A0=A0=A0=A0if (!prefix && check_if_taken)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0id =3D -1;
> > -=A0=A0=A0=A0=A0=A0=A0if (id >=3D smallest_bigger_id) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (biggest_id < INT_MAX)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
d =3D biggest_id + 1;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
d =3D -1;
> > -=A0=A0=A0=A0=A0=A0=A0}
> > -=A0=A0=A0=A0=A0=A0=A0if (id > 0 && check_if_taken) {
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (id >=3D smallest_bigger_id)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0id =3D biggest_id < INT_M=
AX ? biggest_id + 1 : -1;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (id > 0) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0while(id_already_taken(=
id, prefix, map_wwid)) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (id =3D=3D INT_MAX) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0id =3D -1;
> > @@ -391,63 +400,16 @@ lookup_binding(FILE *f, const char *map_wwid,
> > char **map_alias,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > -=A0=A0=A0=A0=A0=A0=A0if (id < 0) {
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (id < 0)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "no more ava=
ilable
> > user_friendly_names");
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -1;
> > -=A0=A0=A0=A0=A0=A0=A0} else
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "No matching w=
wid [%s] in bindings
> > file.", map_wwid);
> > =A0=A0=A0=A0=A0=A0=A0=A0return id;
> > =A0}
> > =A0
> > -static int
> > -rlookup_binding(FILE *f, char *buff, const char *map_alias)
> > -{
> > -=A0=A0=A0=A0=A0=A0=A0char line[LINE_MAX];
> > -=A0=A0=A0=A0=A0=A0=A0unsigned int line_nr =3D 0;
> > -
> > -=A0=A0=A0=A0=A0=A0=A0buff[0] =3D '\0';
> > -
> > -=A0=A0=A0=A0=A0=A0=A0while (fgets(line, LINE_MAX, f)) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0char *c, *saveptr;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0const char *alias, *wwid;
> > -
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0line_nr++;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c =3D strpbrk(line, "#\n\=
r");
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (c)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*=
c =3D '\0';
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0alias =3D strtok_r(line, =
" \t", &saveptr);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!alias) /* blank line=
 */
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ontinue;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0wwid =3D strtok_r(NULL, "=
 \t", &saveptr);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!wwid){
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(3,
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0"Ignoring malformed line %u in
> > bindings file",
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0line_nr);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ontinue;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (strlen(wwid) > WWID_S=
IZE - 1) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(3,
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0"Ignoring too large wwid at %u in
> > bindings file", line_nr);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ontinue;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (strcmp(alias, map_ali=
as) =3D=3D 0){
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(3, "Found matching alias [%s] in
> > bindings file."
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0" Setting wwid to %s", alias,
> > wwid);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s=
trlcpy(buff, wwid, WWID_SIZE);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn 0;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > -=A0=A0=A0=A0=A0=A0=A0}
> > -=A0=A0=A0=A0=A0=A0=A0condlog(3, "No matching alias [%s] in bindings fi=
le.",
> > map_alias);
> > -
> > -=A0=A0=A0=A0=A0=A0=A0return -1;
> > -}
> > -
> > =A0static char *
> > -allocate_binding(int fd, const char *wwid, int id, const char
> > *prefix)
> > +allocate_binding(const char *filename, const char *wwid, int id,
> > const char *prefix)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0STRBUF_ON_STACK(buf);
> > -=A0=A0=A0=A0=A0=A0=A0off_t offset;
> > -=A0=A0=A0=A0=A0=A0=A0ssize_t len;
> > =A0=A0=A0=A0=A0=A0=A0=A0char *alias, *c;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0if (id <=3D 0) {
> > @@ -460,29 +422,22 @@ allocate_binding(int fd, const char *wwid,
> > int id, const char *prefix)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 format_devname(&buf, id) =3D=3D -1)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return NULL;
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0if (print_strbuf(&buf, " %s\n", wwid) < 0)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return NULL;
> > -
> > -=A0=A0=A0=A0=A0=A0=A0offset =3D lseek(fd, 0, SEEK_END);
> > -=A0=A0=A0=A0=A0=A0=A0if (offset < 0){
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "Cannot seek t=
o end of bindings file :
> > %s",
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s=
trerror(errno));
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return NULL;
> > -=A0=A0=A0=A0=A0=A0=A0}
> > -
> > -=A0=A0=A0=A0=A0=A0=A0len =3D get_strbuf_len(&buf);
> > =A0=A0=A0=A0=A0=A0=A0=A0alias =3D steal_strbuf_str(&buf);
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0if (write(fd, alias, len) !=3D len) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "Cannot write =
binding to bindings file :
> > %s",
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s=
trerror(errno));
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* clear partial write */
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (ftruncate(fd, offset)=
)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(0, "Cannot truncate the header :
> > %s",
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0strerror(errno));
> > +=A0=A0=A0=A0=A0=A0=A0if (add_binding(&global_bindings, alias, wwid) !=
=3D
> > BINDING_ADDED) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "%s: cannot al=
locate new binding %s for
> > %s",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0_=
_func__, alias, wwid);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(alias);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return NULL;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (update_bindings_file(&global_bindings, filena=
me) =3D=3D -1)
> > {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s: deleting =
binding %s for %s",
> > __func__, alias, wwid);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0delete_binding(&global_bi=
ndings, wwid);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(alias);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return NULL;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +
>=20
> We no longer need to end the alias at the space, since we're not
> printing the wwid in the buffer.

Right, thanks. This makes me realize that we don't sanity-check the
alias prefix, but that's a different issue.

>=20
> > =A0=A0=A0=A0=A0=A0=A0=A0c =3D strchr(alias, ' ');
> > =A0=A0=A0=A0=A0=A0=A0=A0if (c)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*c =3D '\0';
> > @@ -491,144 +446,130 @@ allocate_binding(int fd, const char *wwid,
> > int id, const char *prefix)
> > =A0=A0=A0=A0=A0=A0=A0=A0return alias;
> > =A0}
> > =A0
> > +/*
> > + * get_user_friendly_alias() action table
> > + *
> > + * The table shows the various cases, the actions taken, and the
> > CI
> > + * functions from tests/alias.c that represent them.
> > + *
> > + *=A0 - O: old alias given
> > + *=A0 - A: old alias in table (y: yes, correct WWID; X: yes, wrong
> > WWID)
> > + *=A0 - W: wwid in table
> > + *=A0 - U: old alias is used
> > + *
> > + *=A0 | No | O | A | W | U |
> > action=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | function
> > gufa_X=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |
> > + *=A0 |----+---+---+---+---+----------------------------------------
> > ----+------------------------------|
> > + *=A0 |=A0 1 | n | - | n | - | get new
> > alias=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 | nomatch_Y=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 |
> > + *=A0 |=A0 2 | n | - | y | - | use alias from
> > bindings=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | mat=
ch_a_Y=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |
> > + *=A0 |=A0 3 | y | n | n | n | add binding for old
> > alias=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | old_nomatch_=
nowwidmatch=A0=A0=A0=A0=A0 |
> > + *=A0 |=A0 4 | y | n | n | y | error, no alias (can't add
> > entry)=A0=A0=A0=A0=A0=A0=A0=A0=A0 | old_nomatch_nowwidmatch_used |
> > + *=A0 |=A0 5 | y | n | y | - | use alias from bindings (avoid
> > duplicates) | old_nomatch_wwidmatch=A0=A0=A0=A0=A0=A0=A0 |
> > + *=A0 |=A0 6 | y | y | n | - | [ impossible
> > ]=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 | -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 |
> > + *=A0 |=A0 7 | y | y | y | n | use old alias =3D=3D alias from
> > bindings=A0=A0=A0=A0=A0=A0 | old_match=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 |
> > + *=A0 |=A0 8 | y | y | y | y | error, no alias (would be
> > duplicate)=A0=A0=A0=A0=A0=A0 | old_match_used=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 |
> > + *=A0 |=A0 9 | y | X | n | - | get new
> > alias=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 | old_match_other=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 |
> > + *=A0 | 10 | y | X | y | - | use alias from
> > bindings=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | old=
_match_other_wwidmatch=A0=A0=A0 |
> > + *
> > + * Notes:
> > + *=A0 - "use alias from bindings" means that the alias from the
> > bindings file will
> > + *=A0=A0=A0=A0 be tried; if it is in use, the alias selection will fai=
l.
> > No other
> > + *=A0=A0=A0=A0 bindings will be attempted.
> > + *=A0 - "get new alias" fails if all aliases are used up, or if
> > writing the
> > + *=A0=A0=A0=A0 bindings file fails.
> > + */
> > +
> > =A0char *get_user_friendly_alias(const char *wwid, const char *file,
> > const char *alias_old,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 const char *prefix, bool
> > bindings_read_only)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0char *alias =3D NULL;
> > =A0=A0=A0=A0=A0=A0=A0=A0int id =3D 0;
> > -=A0=A0=A0=A0=A0=A0=A0int fd, can_write;
> > =A0=A0=A0=A0=A0=A0=A0=A0bool new_binding =3D false;
> > -=A0=A0=A0=A0=A0=A0=A0char buff[WWID_SIZE];
> > -=A0=A0=A0=A0=A0=A0=A0FILE *f;
> > +=A0=A0=A0=A0=A0=A0=A0bool old_alias_taken =3D false;
> > +=A0=A0=A0=A0=A0=A0=A0const struct binding *bdg;
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0fd =3D open_file(file, &can_write, bindings_file_=
header);
> > -=A0=A0=A0=A0=A0=A0=A0if (fd < 0)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return NULL;
> > -
> > -=A0=A0=A0=A0=A0=A0=A0f =3D fdopen(fd, "r");
> > -=A0=A0=A0=A0=A0=A0=A0if (!f) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "cannot fdopen=
 on bindings file
> > descriptor");
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0close(fd);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return NULL;
> > -=A0=A0=A0=A0=A0=A0=A0}
> > -
> > -=A0=A0=A0=A0=A0=A0=A0if (!strlen(alias_old))
> > +=A0=A0=A0=A0=A0=A0=A0if (!*alias_old)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto new_alias;
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0/* lookup the binding. if it exists, the wwid wil=
l be in
> > buff
> > -=A0=A0=A0=A0=A0=A0=A0 * either way, id contains the id for the alias
> > -=A0=A0=A0=A0=A0=A0=A0 */
> > -=A0=A0=A0=A0=A0=A0=A0rlookup_binding(f, buff, alias_old);
> > -
> > -=A0=A0=A0=A0=A0=A0=A0if (strlen(buff) > 0) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* if buff is our wwid, i=
t's already
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * allocated correctly
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (strcmp(buff, wwid) =
=3D=3D 0) {
> > +=A0=A0=A0=A0=A0=A0=A0/* See if there's a binding matching both alias_o=
ld and
> > wwid */
> > +=A0=A0=A0=A0=A0=A0=A0bdg =3D get_binding_for_alias(&global_bindings, a=
lias_old);
> > +=A0=A0=A0=A0=A0=A0=A0if (bdg) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!strcmp(bdg->wwid, ww=
id)) {
>=20
> I'm still not convinced that it is possible for mpp->alias_old to be
> set
> when there isn't a multipath device with the alias_old and the
> desired
> wwid. Unless I'm missing something we should be able to skip the
> alias_already_taken() check.

Let's follow up this discussion in the 4/21 thread.


>=20
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (!alias_already_taken(alias_old, wwid))
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0alias =3D strdup(alias_old);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0else
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "ERROR: old alias [%s]
> > for wwid [%s] is used by other map",
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0alias_old, wwid);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0goto out;
> > -
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0condlog(0, "alias %s already bound to wwid
> > %s, cannot reuse",
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0alias_old, buff);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto new_alias;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0alias_old, bdg->wwid);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto new_alias;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0/*
> > -=A0=A0=A0=A0=A0=A0=A0 * Look for an existing alias in the bindings fil=
e.
> > -=A0=A0=A0=A0=A0=A0=A0 * Pass prefix =3D NULL, so lookup_binding() won'=
t try to
> > allocate a new id.
> > -=A0=A0=A0=A0=A0=A0=A0 */
> > -=A0=A0=A0=A0=A0=A0=A0id =3D lookup_binding(f, wwid, &alias, NULL, 0);
> > -=A0=A0=A0=A0=A0=A0=A0if (alias) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (alias_already_taken(a=
lias, wwid)) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
ree(alias);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0a=
lias =3D NULL;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(3, "Use existing binding [%s] for
> > WWID [%s]",
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0alias, wwid);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> > -=A0=A0=A0=A0=A0=A0=A0}
> > -
> > =A0=A0=A0=A0=A0=A0=A0=A0/* allocate the existing alias in the bindings =
file */
> > -=A0=A0=A0=A0=A0=A0=A0id =3D scan_devname(alias_old, prefix);
> > -=A0=A0=A0=A0=A0=A0=A0if (id > 0 && id_already_taken(id, prefix, wwid))=
 {
> again, I think it's safe to skip this check, since we're checking
> alias_old.
> > +=A0=A0=A0=A0=A0=A0=A0if (alias_already_taken(alias_old, wwid)) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "ERROR: old =
alias [%s] for wwid [%s] is
> > used by other map",
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0alias_old, wwid);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0old_alias_taken =3D true;
> > +=A0=A0=A0=A0=A0=A0=A0} else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0id =3D scan_devname(alias=
_old, prefix);
> > +
> > +new_alias:
> > +=A0=A0=A0=A0=A0=A0=A0/* Check for existing binding of WWID */
> > +=A0=A0=A0=A0=A0=A0=A0bdg =3D get_binding_for_wwid(&global_bindings, ww=
id);
> > +=A0=A0=A0=A0=A0=A0=A0if (bdg) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!alias_already_taken(=
bdg->alias, wwid)) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(3, "Use existing binding [%s] for
> > WWID [%s]",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0bdg->alias, wwid);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0a=
lias =3D strdup(bdg->alias);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0
> > -new_alias:
> > -=A0=A0=A0=A0=A0=A0=A0if (id <=3D 0) {
> > +=A0=A0=A0=A0=A0=A0=A0/*
> > +=A0=A0=A0=A0=A0=A0=A0 * old_alias_taken means that the WWID is not in =
the
> > bindings file, but
> > +=A0=A0=A0=A0=A0=A0=A0 * alias_old is currently taken by a different WW=
ID. We
> > shouldn't added
> > +=A0=A0=A0=A0=A0=A0=A0 * a new binding in this case.
> > +=A0=A0=A0=A0=A0=A0=A0 */
> > +=A0=A0=A0=A0=A0=A0=A0if (id <=3D 0 && !old_alias_taken) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * no existing alias wa=
s provided, or allocating it
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * failed. Try a new on=
e.
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0id =3D lookup_binding(f, =
wwid, &alias, prefix, 1);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (id =3D=3D 0 && alias_=
already_taken(alias, wwid)) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
ree(alias);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0a=
lias =3D NULL;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0id =3D get_free_id(&globa=
l_bindings, prefix, wwid);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (id <=3D 0)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0goto out;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0new_binding =3D true;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0if (fflush(f) !=3D 0) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "cannot fflush=
 bindings file stream :
> > %s",
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s=
trerror(errno));
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> > -=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0if (!bindings_read_only && id > 0)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0alias =3D allocate_bindin=
g(file, wwid, id, prefix);
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0if (can_write && !bindings_read_only) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0alias =3D allocate_bindin=
g(fd, wwid, id, prefix);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (alias && !new_binding=
)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(2, "Allocated existing binding [%s]
> > for WWID [%s]",
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0alias, wwid);
> > -=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0if (alias && !new_binding)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "Allocated exi=
sting binding [%s] for
> > WWID [%s]",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0a=
lias, wwid);
> > =A0
> > =A0out:
> > -=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(free, alias);
> > -=A0=A0=A0=A0=A0=A0=A0fclose(f);
> > -=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(0);
> > =A0=A0=A0=A0=A0=A0=A0=A0return alias;
> > =A0}
> > =A0
> > -int
> > -get_user_friendly_wwid(const char *alias, char *buff, const char
> > *file)
> > +int get_user_friendly_wwid(const char *alias, char *buff)
> > =A0{
> > -=A0=A0=A0=A0=A0=A0=A0int fd, unused;
> > -=A0=A0=A0=A0=A0=A0=A0FILE *f;
> > +=A0=A0=A0=A0=A0=A0=A0const struct binding *bdg;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0if (!alias || *alias =3D=3D '\0') {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "Cannot find=
 binding for empty alias");
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -1;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0fd =3D open_file(file, &unused, bindings_file_hea=
der);
> > -=A0=A0=A0=A0=A0=A0=A0if (fd < 0)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -1;
> > -
> > -=A0=A0=A0=A0=A0=A0=A0f =3D fdopen(fd, "r");
> > -=A0=A0=A0=A0=A0=A0=A0if (!f) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "cannot fdopen=
 on bindings file
> > descriptor : %s",
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s=
trerror(errno));
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0close(fd);
> > +=A0=A0=A0=A0=A0=A0=A0bdg =3D get_binding_for_alias(&global_bindings, a=
lias);
> > +=A0=A0=A0=A0=A0=A0=A0if (!bdg) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*buff =3D '\0';
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -1;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > -
> > -=A0=A0=A0=A0=A0=A0=A0rlookup_binding(f, buff, alias);
> > -=A0=A0=A0=A0=A0=A0=A0if (!strlen(buff)) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fclose(f);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -1;
> > -=A0=A0=A0=A0=A0=A0=A0}
> > -
> > -=A0=A0=A0=A0=A0=A0=A0fclose(f);
> I think you mean bdg->wwid here.
>=20

Argh, thanks for spotting this.

Martin

> -Ben
>=20
> > +=A0=A0=A0=A0=A0=A0=A0strlcpy(buff, bdg->alias, WWID_SIZE);
> > =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0}
> > =A0
> > diff --git a/libmultipath/alias.h b/libmultipath/alias.h
> > index 37b49d9..5ef6720 100644
> > --- a/libmultipath/alias.h
> > +++ b/libmultipath/alias.h
> > @@ -2,7 +2,7 @@
> > =A0#define _ALIAS_H
> > =A0
> > =A0int valid_alias(const char *alias);
> > -int get_user_friendly_wwid(const char *alias, char *buff, const
> > char *file);
> > +int get_user_friendly_wwid(const char *alias, char *buff);
> > =A0char *get_user_friendly_alias(const char *wwid, const char *file,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 const char *alias_old,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 const char *prefix, bool
> > bindings_read_only);
> > diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> > index 029fbbd..d809490 100644
> > --- a/libmultipath/configure.c
> > +++ b/libmultipath/configure.c
> > @@ -1378,8 +1378,7 @@ static int _get_refwwid(enum mpath_cmds cmd,
> > const char *dev,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0refwwid =3D tmpwwid;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* or may be a binding =
*/
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else if (get_user_friendl=
y_wwid(dev, tmpwwid,
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
f-
> > >bindings_file) =3D=3D 0)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else if (get_user_friendl=
y_wwid(dev, tmpwwid) =3D=3D 0)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0refwwid =3D tmpwwid;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* or may be an alias *=
/
> > --=20
> > 2.41.0
>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

