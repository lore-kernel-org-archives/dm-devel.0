Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38FC8C00140
	for <dm-devel@archiver.kernel.org>; Wed, 24 Aug 2022 07:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661326383;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OzrqimLCUEMfbfItDlLz/SGKmcUGcYlFBQw7RXClfU8=;
	b=BcMv63TLQIQl9C1rZyCy8ec52oUSnRYMqyllzwO6VGc2XOvjvZcQ9b3n9QoDdyqVQiosR0
	EeI064yqau776g1Ruwj4EA8VndfXZ8Vhj6pSPA7j6n465KK0nL9ZsXEtQGHangjmomH7vS
	kyaneHQ8kMm5GaBygJIpi7VohZeR8Yc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-8JrjAharP12pUJPzGY37NQ-1; Wed, 24 Aug 2022 03:32:59 -0400
X-MC-Unique: 8JrjAharP12pUJPzGY37NQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0388618E0043;
	Wed, 24 Aug 2022 07:32:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6E1E41121314;
	Wed, 24 Aug 2022 07:32:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2DFA61946A42;
	Wed, 24 Aug 2022 07:32:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 633DF1946A40
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 Aug 2022 07:32:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 25BD1945D2; Wed, 24 Aug 2022 07:32:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 21B56945DD
 for <dm-devel@redhat.com>; Wed, 24 Aug 2022 07:32:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 073D9804191
 for <dm-devel@redhat.com>; Wed, 24 Aug 2022 07:32:56 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-352-DDe2VcHhOwCSgB1U1ZUyGQ-1; Wed,
 24 Aug 2022 03:32:52 -0400
X-MC-Unique: DDe2VcHhOwCSgB1U1ZUyGQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id C3D2933C07;
 Wed, 24 Aug 2022 07:32:50 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 97A7313AC0;
 Wed, 24 Aug 2022 07:32:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id SWoqIyLUBWN7TQAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 24 Aug 2022 07:32:50 +0000
Message-ID: <fb6d91e4bbcc7e96f0f516065dfb2b8c1341da13.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 24 Aug 2022 09:32:49 +0200
In-Reply-To: <20220823212723.GY10602@octiron.msp.redhat.com>
References: <20220818210630.19395-1-mwilck@suse.com>
 <20220818210630.19395-3-mwilck@suse.com>
 <20220823212723.GY10602@octiron.msp.redhat.com>
User-Agent: Evolution 3.44.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 2/3] libmultipath: check_alias_settings():
 pre-sort mptable by alias
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-08-23 at 16:27 -0500, Benjamin Marzinski wrote:
> On Thu, Aug 18, 2022 at 11:06:29PM +0200, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > add_binding() contains an optimization; it assumes that the list of
> > bindings is alphabetically sorted by alias, and tries to maintain
> > this order.
> >=20
> > But conf->mptable is sorted by wwid. Therefore
> > check_alias_settings() may take
> > a long time if the mptable is large.
> >=20
> > Create a copy of the mptable, sorted by alias, and use it for
> > add_bindings().
> > This speeds up check_alias_settings by roughly a factor of 10 (0.1s
> > vs. 1s)
> > for my test setup with 10000 entries in the mptable.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =A0libmultipath/alias.c | 29 ++++++++++++++++++++++++++++-
> > =A01 file changed, 28 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> > index 548a118..60428fe 100644
> > --- a/libmultipath/alias.c
> > +++ b/libmultipath/alias.c
> > @@ -672,6 +672,26 @@ static void cleanup_fclose(void *p)
> > =A0=A0=A0=A0=A0=A0=A0=A0fclose(p);
> > =A0}
> > =A0
> > +static int alias_compar(const void *p1, const void *p2)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0const char *alias1 =3D (*(struct mpentry * const =
*)p1)-
> > >alias;
> > +=A0=A0=A0=A0=A0=A0=A0const char *alias2 =3D (*(struct mpentry * const =
*)p2)-
> > >alias;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (!alias1 && !alias2)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > +=A0=A0=A0=A0=A0=A0=A0if (!alias1)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > +=A0=A0=A0=A0=A0=A0=A0if (!alias2)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -1;
> > +=A0=A0=A0=A0=A0=A0=A0return strcmp(alias1, alias2);
> > +}
> > +
> > +static void cleanup_vector_free(void *arg)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0if=A0 (arg)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0vector_free((vector)arg);
> > +}
> > +
> > =A0/*
> > =A0 * check_alias_settings(): test for inconsistent alias
> > configuration
> > =A0 *
> > @@ -693,10 +713,16 @@ int check_alias_settings(const struct config
> > *conf)
> > =A0=A0=A0=A0=A0=A0=A0=A0int can_write;
> > =A0=A0=A0=A0=A0=A0=A0=A0int rc =3D 0, i, fd;
> > =A0=A0=A0=A0=A0=A0=A0=A0Bindings bindings =3D {.allocated =3D 0, };
> > +=A0=A0=A0=A0=A0=A0=A0vector mptable =3D NULL;
> > =A0=A0=A0=A0=A0=A0=A0=A0struct mpentry *mpe;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push_cast(free_bindings, &bindi=
ngs);
> > -=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(conf->mptable, mpe, i) {
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanup_vector_free, mptable=
);
> > +=A0=A0=A0=A0=A0=A0=A0mptable =3D vector_convert(NULL, conf->mptable, s=
truct
> > mpentry *, identity);
> > +=A0=A0=A0=A0=A0=A0=A0if (!mptable)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -1;
>=20
> Are there other places in the code where we return without popping
> the
> cleanup handler?

Of course not. Stupid mistake.

>  According to the man page "POSIX.1 says that the effect
> of using return, break, continue, or=A0 goto to=A0 prematurely=A0 leave=
=A0 a
> block=A0 bracketed pthread_cleanup_push() and pthread_cleanup_pop() is
> undefined.=A0 Portable applications should avoid doing this." It also
> says
> that linux implements these as macros that expand to create code
> blocks.
> So, I'm pretty sure this is safe in linux, but if we aren't already
> doing it, we probably shouldn't start, especially since
> vector_convert()
> doesn't have any pthread cancellation points, so we can just move the
> push until after we are sure we successfully copied the vector.
>=20
> > +=A0=A0=A0=A0=A0=A0=A0vector_sort(mptable, alias_compar);
> > +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(mptable, mpe, i) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!mpe->wwid || !mpe-=
>alias)
>=20
> Unless I'm missing something, merge_mptable() should have already
> guaranteed that mpe->wwid must be non-NULL. Also, since mptable has
> all
> of the entries with a NULL alias sorted to the end, as soon as we hit
> one, we can stop checking.

Right, thanks.=20

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

