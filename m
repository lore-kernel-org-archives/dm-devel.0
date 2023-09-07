Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A4C8EE14D4
	for <dm-devel@archiver.kernel.org>; Thu,  7 Sep 2023 07:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694071506;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=n+FY50vLqy/YJxn5kHQe1DyoJLOaJh0+5hNQpD55ldQ=;
	b=h7KKaiER9ioM7BS0bSGPH53ehZqFcjQ5OrlosnsJh0anENWp9bSzdXlUKespnLjZw6Zh44
	Oglxftc6dU/nftJPMuv9d8zFfPqiG+zaaBcYi1bH2E/sib/pzHLJqhkf5LLXpMFEkxXiRS
	5IDcSGdbVl1m0aYgvRCyxe+wF4OCS1w=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-542-UJOo0deZNRSoW0MKMwgR7A-1; Thu, 07 Sep 2023 03:25:02 -0400
X-MC-Unique: UJOo0deZNRSoW0MKMwgR7A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6E1A29AB455;
	Thu,  7 Sep 2023 07:25:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5F13C140E962;
	Thu,  7 Sep 2023 07:24:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2B5E3194658F;
	Thu,  7 Sep 2023 07:24:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 89840194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Sep 2023 07:24:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 729E852572D; Thu,  7 Sep 2023 07:24:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6AA4552572C
 for <dm-devel@redhat.com>; Thu,  7 Sep 2023 07:24:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 454B8281294C
 for <dm-devel@redhat.com>; Thu,  7 Sep 2023 07:24:50 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-227--6sUsRuHO6-USfZp7W1fPQ-1; Thu,
 07 Sep 2023 03:24:48 -0400
X-MC-Unique: -6sUsRuHO6-USfZp7W1fPQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 5035821863;
 Thu,  7 Sep 2023 07:24:47 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 255EA138F9;
 Thu,  7 Sep 2023 07:24:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 0LyZB796+WS/DAAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 07 Sep 2023 07:24:47 +0000
Message-ID: <9948d7855eba709714b5b487240e44a309288f07.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 07 Sep 2023 09:24:46 +0200
In-Reply-To: <20230906224248.GO7412@octiron.msp.redhat.com>
References: <20230901180235.23980-1-mwilck@suse.com>
 <20230901180235.23980-5-mwilck@suse.com>
 <20230906224248.GO7412@octiron.msp.redhat.com>
User-Agent: Evolution 3.48.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 04/21] libmultipath: never allocate an alias
 that's already taken
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
Cc: dm-devel@redhat.com, David Bond <dbond@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2023-09-06 at 17:42 -0500, Benjamin Marzinski wrote:
> On Fri, Sep 01, 2023 at 08:02:17PM +0200, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > If the bindings file is changed in a way that multipathd can't
> > handle
> > (e.g. by swapping the aliases of two maps), multipathd must not try
> > to re-use an alias that is already used by another map. Creating
> > or renaming a map with such an alias will fail. We already avoid
> > this for some cases, but not for all. Fix it.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > Cc: David Bond <dbond@suse.com>
> > ---
> > =A0libmultipath/alias.c | 36 +++++++++++++++++++++++++++++++-----
> > =A0tests/alias.c=A0=A0=A0=A0=A0=A0=A0 |=A0 2 +-
> > =A02 files changed, 32 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> > index 9b9b789..f7834d1 100644
> > --- a/libmultipath/alias.c
> > +++ b/libmultipath/alias.c
> > @@ -120,7 +120,7 @@ static bool alias_already_taken(const char
> > *alias, const char *map_wwid)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (dm_get_uuid(alias, =
wwid, sizeof(wwid)) =3D=3D 0 &&
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 strncmp(map_w=
wid, wwid, sizeof(wwid)) =3D=3D 0)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0return false;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: alias '%s=
' already taken, but not
> > in bindings file. reselecting alias",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: alias '%s=
' already taken,
> > reselecting alias",
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0map_wwid, alias);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return true;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > @@ -363,28 +363,54 @@ char *get_user_friendly_alias(const char
> > *wwid, const char *file, const char *al
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * allocated correctly
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (strcmp(buff, wwid) =
=3D=3D 0) {
>=20
> I'm confused about this. We should only have alias_old set if there
> already exists a device that matches this WWID, right? That's what I
> though alias_old means. Am I missing some way that alias_old could
> get
> set to something other than the alias of an already existing device
> with
> a matching WWID? Otherwise, once we verify that that this mapping
> also
> exists in the bindings file, we should be fine to use it?
>=20

This is mainly meant as an additional consistency check, to make sure
that the logic in get_user_friendly_alias() is correct, no matter how
"alias_old" was set by the caller.=A0Note that alias_old is ab^H^Hreused
by the ACT_RENAME action; it is not immediately obvious that alias_old
can never be set to an invalid value in get_user_friendly_alias().

condlog() prints "ERROR" here because it's a condition that shouldn't
occur.

> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0a=
lias =3D strdup(alias_old);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (!alias_already_taken(alias_old, wwid))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0alias =3D strdup(alias_old);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0e=
lse
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "ERROR: old alias [%s]
> > for wwid [%s] is used by other map",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0alias_old, wwid);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0goto out;
> > +
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0condlog(0, "alias %s already bound to wwid
> > %s, cannot reuse",
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0alias_old, buff);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto new_alias;
>=20
> extra semicolon.
>=20
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto new_alias;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0
> > +=A0=A0=A0=A0=A0=A0=A0/*
> > +=A0=A0=A0=A0=A0=A0=A0 * Look for an existing alias in the bindings fil=
e.
> > +=A0=A0=A0=A0=A0=A0=A0 * Pass prefix =3D NULL, so lookup_binding() won'=
t try to
> > allocate a new id.
> > +=A0=A0=A0=A0=A0=A0=A0 */
>=20
> There's no point in saving the return value here. We don't use if for
> anything.
>=20
> > =A0=A0=A0=A0=A0=A0=A0=A0id =3D lookup_binding(f, wwid, &alias, NULL, 0)=
;
> > =A0=A0=A0=A0=A0=A0=A0=A0if (alias) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "Use existing =
binding [%s] for WWID
> > [%s]",
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0a=
lias, wwid);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (alias_already_taken(a=
lias, wwid)) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
ree(alias);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0a=
lias =3D NULL;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(3, "Use existing binding [%s] for
> > WWID [%s]",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0alias, wwid);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0/* allocate the existing alias in the bindings =
file */
> > =A0=A0=A0=A0=A0=A0=A0=A0id =3D scan_devname(alias_old, prefix);
>=20
> Again, unless I'm overlooking something, I don't think we need to
> check if the alias is already taken here. Since we know that a device
> already exists with alias_old and the correct WWID, as long as
> alias_old
> is a valid user_friendly_name we can just use it.

Similar reasoning as above. We could perhaps remove these checks, but
we'd need to replace them by comments explaining why this condition
can't occur.

We could (and maybe should) move the call to find_existing_alias() from
add_map_with_path() to get_user_friendly_alias(), so that we have the
entire alias logic in a single place. The mpp->alias_old field would
then only be used for ACT_RENAME.

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

