Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 974D2EDEC69
	for <dm-devel@archiver.kernel.org>; Wed, 13 Sep 2023 14:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694615905;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9uJyuH+jZ7mZWANAY7akr3pqgzGdW0iuo9oDpjwiLOs=;
	b=hgI44HDOEWcHDyrfB50ZuknwZP2zlAnMqS+qEw/fbJUiahe4g27/W+FLnTq03AC2x9GYn+
	33x3JZtv5MRFYKiHjdlKywBs+2TWe3lb9xvK2Gg/XhOEeym5OmklAItnVRr+W3hOocLP7T
	6iWMjsjE7wqcfhoHaKshq0fAiMxKEnw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-464-vPUDAgf4OkKbkherAGqMHg-1; Wed, 13 Sep 2023 10:38:23 -0400
X-MC-Unique: vPUDAgf4OkKbkherAGqMHg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A3AE88B7AD;
	Wed, 13 Sep 2023 14:38:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 32EC640C6EA8;
	Wed, 13 Sep 2023 14:38:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E5A7019465B5;
	Wed, 13 Sep 2023 14:38:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D640919465B1
 for <dm-devel@listman.corp.redhat.com>; Wed, 13 Sep 2023 14:38:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BEF9863A52; Wed, 13 Sep 2023 14:38:18 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A3CD42904;
 Wed, 13 Sep 2023 14:38:18 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 38DEcAR7002576;
 Wed, 13 Sep 2023 09:38:10 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 38DEc9M3002575;
 Wed, 13 Sep 2023 09:38:09 -0500
Date: Wed, 13 Sep 2023 09:38:09 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20230913143809.GW7412@octiron.msp.redhat.com>
References: <20230911163846.27197-1-mwilck@suse.com>
 <20230911163846.27197-23-mwilck@suse.com>
 <20230912230048.GR7412@octiron.msp.redhat.com>
 <592dd1bd954e2ccc33e1e0d837421d649fdafdf7.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <592dd1bd954e2ccc33e1e0d837421d649fdafdf7.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v2 22/37] libmultipath: sort aliases by
 length and strcmp
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 13, 2023 at 03:53:25PM +0200, Martin Wilck wrote:
> On Tue, 2023-09-12 at 18:00 -0500, Benjamin Marzinski wrote:
> > On Mon, Sep 11, 2023 at 06:38:31PM +0200, mwilck@suse.com=A0wrote:
> > > From: Martin Wilck <mwilck@suse.com>
> > >=20
> > > The current sort order of aliases is alphabetical, which is does
> > > not match
> > > the actual order of aliases, where "mpathaa" > "mpathz". Change the
> > > ordering as
> > > follows: first sort by string length, then alphabetically. This
> > > will make
> > > sure that for aliases with the same prefix, alias order is correct
> > > ("mpathaaa"
> > > will be sorted after "mpathzz", etc). Even for mixed prefixes, the
> > > alias
> > > order will be correct for every individual prefix, even though
> > > aliases with
> > > different prefixes may alternate in the file.
> > >=20
> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > ---
> > > =A0libmultipath/alias.c | 45 +++++++++++++++++++++++++++++++++-------
> > > ----
> > > =A01 file changed, 34 insertions(+), 11 deletions(-)
> > >=20
> > > diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> > > index 58436ec..af6565b 100644
> > > --- a/libmultipath/alias.c
> > > +++ b/libmultipath/alias.c
> > > @@ -117,6 +117,35 @@ static const struct binding
> > > *get_binding_for_wwid(const Bindings *bindings,
> > > =A0=A0=A0=A0=A0=A0=A0=A0return NULL;
> > > =A0}
> > > =A0
> > > +/*
> > > + * Sort order for aliases.
> > > + *
> > > + * The "numeric" ordering of aliases for a given prefix P is
> > > + * Pa, ..., Pz, Paa, ..., Paz, Pba, ... , Pzz, Paaa, ..., Pzzz,
> > > Paaaa, ...
> > > + * We use the fact that for equal prefix, longer strings are
> > > always
> > > + * higher than shorter ones. Strings of equal length are sorted
> > > alphabetically.
> > > + * This is achieved by sorting be length first, then using
> > > strcmp().
> > > + * If multiple prefixes are in use, the aliases with a given
> > > prefix will
> > > + * not necessarily be in a contiguous range of the vector, but
> > > they will
> > > + * be ordered such that for a given prefix, numercally higher
> > > aliases will
> > > + * always be sorted after lower ones.
> > > + */
> > > +static int alias_compar(const void *p1, const void *p2)
> > > +{
> >=20
> > I'm confused as to why we need to pass p1 and p2 and pointers to
> > pointers to chars, instead of simply as pointers to chars. We always
> > derefence them immediately, and only use the dereferenced pointers.
> > Am I
> > missing something?
>=20
> I wanted to make the relationship of alias_compar() and
> mp_alias_compar() as obvious as possible. mp_alias_compar() takes=20
> (struct mpentry **) arguments, because it's used as an argument to
> vector_sort() aka msort(), which has the same calling convention as
> qsort()'s "compar" argument. Therefore I wrote alias_compar() such that
> it takes (char **) pointers. This way we could use alias_compar() as an
> argument to vector_sort() as well, even though we currently don't.
>=20
>=20
> Does this make sense? If not, I can change it, but I think the function
> should not be named alias_compar() if it can't be passed to
> vector_sort().

It's fine as it is. I was just confused as to why.

-Ben

>=20
> Martin
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

