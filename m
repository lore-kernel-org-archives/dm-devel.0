Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 377FEEDEC4D
	for <dm-devel@archiver.kernel.org>; Wed, 13 Sep 2023 13:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694613234;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yqy7ngSVe0zcGvb2MwGEp9osH+HjOqWmksnD3WKNBbs=;
	b=AzMevNISCswI8QH9pAHWnp3DpHBjV+6aOUziEMI7jEvAEtfN3OO9CESZ7cQUomwy1kZ8fH
	ueUTbwjIhMtyTsMn6znKZyMHFA0/u33GwcgSrVhMJ0Sho96yQE5NOgSpw2mrzdMWJi2n6B
	xgadBxBrCDUkqrlFl/fA24IUK3QZPmM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-J8kpLIIlOemiVUFaOd5NJw-1; Wed, 13 Sep 2023 09:53:48 -0400
X-MC-Unique: J8kpLIIlOemiVUFaOd5NJw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1270881D79F;
	Wed, 13 Sep 2023 13:53:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EEF7740C200A;
	Wed, 13 Sep 2023 13:53:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BA5B219465B6;
	Wed, 13 Sep 2023 13:53:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1680119465B5
 for <dm-devel@listman.corp.redhat.com>; Wed, 13 Sep 2023 13:53:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CAE3310F1BE8; Wed, 13 Sep 2023 13:53:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C39F610F1BE7
 for <dm-devel@redhat.com>; Wed, 13 Sep 2023 13:53:30 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A14CE101A550
 for <dm-devel@redhat.com>; Wed, 13 Sep 2023 13:53:30 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-115-FVb8X0PtOD2yRo4PTQTuxw-1; Wed,
 13 Sep 2023 09:53:27 -0400
X-MC-Unique: FVb8X0PtOD2yRo4PTQTuxw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 1A828218E3;
 Wed, 13 Sep 2023 13:53:26 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DD8FA13582;
 Wed, 13 Sep 2023 13:53:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 2wJaNNW+AWVuUgAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 13 Sep 2023 13:53:25 +0000
Message-ID: <592dd1bd954e2ccc33e1e0d837421d649fdafdf7.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 13 Sep 2023 15:53:25 +0200
In-Reply-To: <20230912230048.GR7412@octiron.msp.redhat.com>
References: <20230911163846.27197-1-mwilck@suse.com>
 <20230911163846.27197-23-mwilck@suse.com>
 <20230912230048.GR7412@octiron.msp.redhat.com>
User-Agent: Evolution 3.48.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2023-09-12 at 18:00 -0500, Benjamin Marzinski wrote:
> On Mon, Sep 11, 2023 at 06:38:31PM +0200, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > The current sort order of aliases is alphabetical, which is does
> > not match
> > the actual order of aliases, where "mpathaa" > "mpathz". Change the
> > ordering as
> > follows: first sort by string length, then alphabetically. This
> > will make
> > sure that for aliases with the same prefix, alias order is correct
> > ("mpathaaa"
> > will be sorted after "mpathzz", etc). Even for mixed prefixes, the
> > alias
> > order will be correct for every individual prefix, even though
> > aliases with
> > different prefixes may alternate in the file.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =A0libmultipath/alias.c | 45 +++++++++++++++++++++++++++++++++-------
> > ----
> > =A01 file changed, 34 insertions(+), 11 deletions(-)
> >=20
> > diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> > index 58436ec..af6565b 100644
> > --- a/libmultipath/alias.c
> > +++ b/libmultipath/alias.c
> > @@ -117,6 +117,35 @@ static const struct binding
> > *get_binding_for_wwid(const Bindings *bindings,
> > =A0=A0=A0=A0=A0=A0=A0=A0return NULL;
> > =A0}
> > =A0
> > +/*
> > + * Sort order for aliases.
> > + *
> > + * The "numeric" ordering of aliases for a given prefix P is
> > + * Pa, ..., Pz, Paa, ..., Paz, Pba, ... , Pzz, Paaa, ..., Pzzz,
> > Paaaa, ...
> > + * We use the fact that for equal prefix, longer strings are
> > always
> > + * higher than shorter ones. Strings of equal length are sorted
> > alphabetically.
> > + * This is achieved by sorting be length first, then using
> > strcmp().
> > + * If multiple prefixes are in use, the aliases with a given
> > prefix will
> > + * not necessarily be in a contiguous range of the vector, but
> > they will
> > + * be ordered such that for a given prefix, numercally higher
> > aliases will
> > + * always be sorted after lower ones.
> > + */
> > +static int alias_compar(const void *p1, const void *p2)
> > +{
>=20
> I'm confused as to why we need to pass p1 and p2 and pointers to
> pointers to chars, instead of simply as pointers to chars. We always
> derefence them immediately, and only use the dereferenced pointers.
> Am I
> missing something?

I wanted to make the relationship of alias_compar() and
mp_alias_compar() as obvious as possible. mp_alias_compar() takes=20
(struct mpentry **) arguments, because it's used as an argument to
vector_sort() aka msort(), which has the same calling convention as
qsort()'s "compar" argument. Therefore I wrote alias_compar() such that
it takes (char **) pointers. This way we could use alias_compar() as an
argument to vector_sort() as well, even though we currently don't.


Does this make sense? If not, I can change it, but I think the function
should not be named alias_compar() if it can't be passed to
vector_sort().

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

